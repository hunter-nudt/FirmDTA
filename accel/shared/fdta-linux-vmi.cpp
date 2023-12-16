#include "shared/fdta-linux-vmi.h"
#include "shared/fdta-vmi-common.h"
#include "migration/qemu-file-types.h"
#include "shared/fdta-linux-procinfo.h"
#include "shared/fdta-main.h"
#include "shared/fdta-callback-common.h"
#include "shared/fdta-target.h"

#include <unordered_map>
#include <unordered_set>
#include <string>
using namespace std;

#define BREAK_IF(x) if(x) break
#define MAX_PARAM_PREFIX_LEN (64 - sizeof(target_ptr))

//Global variable used to read values from the stack
uint32_t call_stack[12];
int monitored = 0;
static int first = 1;

// current linux profile
static ProcInfo OFFSET_PROFILE = {"vmi"};

void print_loaded_modules(CPUState *cs)
{
    char module_name[MAX_PARAM_PREFIX_LEN];
    fdta_target_ulong module_size, first_module;
    fdta_target_ulong next_module = OFFSET_PROFILE.modules;

	next_module -= OFFSET_PROFILE.module_list;
	first_module = next_module;

	fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_list, &next_module);

  	next_module -= OFFSET_PROFILE.module_list;
	
    printf("%20s %10s \n", "Module", "Size");

    while(true) {
        fdta_read_mem(cs, next_module + OFFSET_PROFILE.module_name, MAX_PARAM_PREFIX_LEN, module_name);
        module_name[MAX_PARAM_PREFIX_LEN - 1] = '\0';		
        fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_size, &module_size);

        printf("%20s  |  %10u\n", module_name, module_size);

		fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_list, &next_module);	  
        next_module -= OFFSET_PROFILE.module_list;
        if(first_module == next_module) {
			printf("done\n");
            break;
        }
    }
}

void traverse_module_list(CPUState *cs)
{
	fdta_target_ulong module_size, first_module, module_base;
    fdta_target_ulong next_module = OFFSET_PROFILE.modules;

	next_module -= OFFSET_PROFILE.module_list;

	first_module = next_module;

	fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_list, &next_module);

  	next_module -= OFFSET_PROFILE.module_list;
	
	char module_name[MAX_PARAM_PREFIX_LEN];

    while(true)
    {
        fdta_read_mem(cs, next_module + OFFSET_PROFILE.module_name, MAX_PARAM_PREFIX_LEN, module_name);
        //module_name[MAX_PARAM_PREFIX_LEN - 1] = '\0';
		module_name[31] = '\0';

		if(!vmi_find_module_by_key(module_name)) {								
	        fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_size, &module_size);
	        fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_init, &module_base);

			module *mod = new module();
            memcpy(mod->name, module_name, 31);
            mod->name[31] = '\0';
            mod->size = module_size;
            mod->inode_number = 0;

			//printf("kernel module %s base %x\n", module_name, module_base);
            vmi_add_module(mod, module_name);
	        vmi_insert_module(0, module_base , mod);
		}

		fdta_read_ptr(cs, next_module + OFFSET_PROFILE.module_list, &next_module);		  
        next_module -= OFFSET_PROFILE.module_list;
        if(first_module == next_module) {
            break;
        }
    }
}


//  Wait for kernel's `init_module` to call `trim_init_extable' where we grab module data
void new_module_callback(fdta_callback_params* params)
{
	CPUState *cs = params->bb.cs;
	fdta_target_ulong pc = fdta_get_pc(cs);
    if(OFFSET_PROFILE.trim_init_extable != pc) {
        return;
    } 
	traverse_module_list(cs);
}


//  Traverse the task_struct linked list and add all un-added processes
//  This function is called
void traverse_task_struct_add(CPUState *cs)
{
    uint32_t task_pid = 0;
    const int MAX_LOOP_COUNT = 1024;	// prevent infinite loop
    fdta_target_ulong next_task, mm, proc_pgd, task_pgd, ts_parent_pid, ts_real_parent;
    next_task = OFFSET_PROFILE.init_task_addr;

    for (int count = MAX_LOOP_COUNT; count > 0; --count)
    {
        BREAK_IF(fdta_read_ptr(cs, next_task + (OFFSET_PROFILE.ts_tasks + sizeof(target_ptr)), &next_task) < 0);
        next_task -= OFFSET_PROFILE.ts_tasks;
        if(OFFSET_PROFILE.init_task_addr == next_task) {
            break;
        }

        BREAK_IF(fdta_read_ptr(cs, next_task + OFFSET_PROFILE.ts_mm, &mm) < 0);

        if (mm != 0) {
            BREAK_IF(fdta_read_ptr(cs, mm + OFFSET_PROFILE.mm_pgd, &task_pgd) < 0);

            proc_pgd = fdta_get_phys_addr(cs, task_pgd);
        }
        else {
            // We don't add kernel processed for now.
            proc_pgd = -1;
            continue;
        }

        if (!vmi_find_process_by_pgd(proc_pgd)) {

            // get task_pid
            BREAK_IF(fdta_read_ptr(cs, next_task + OFFSET_PROFILE.ts_tgid, &task_pid) < 0);

            // get parent task's base address
            BREAK_IF(fdta_read_ptr(cs, next_task + OFFSET_PROFILE.ts_real_parent, &ts_real_parent) < 0
                     || fdta_read_ptr(cs, ts_real_parent + OFFSET_PROFILE.ts_tgid, &ts_parent_pid) < 0);

            process* pe = new process();
            pe->pid = task_pid;
            pe->parent_pid = ts_parent_pid;
            pe->pgd = proc_pgd;
            pe->EPROC_base_addr = next_task; // store current task_struct's base address
            BREAK_IF(fdta_read_mem(cs, next_task + OFFSET_PROFILE.ts_comm, SIZEOF_COMM, pe->name) < 0);
            vmi_create_process(pe);
			pe->modules_extracted = false;
        }
    }
}

// Traverse the task_struct linked list and updates the internal FDTAF process data structures on process exit
// This is called when the linux system call `proc_exit_connector` is called.
process *traverse_task_struct_remove(CPUState *cs)
{
    unordered_set<fdta_target_ulong> pids;
    uint32_t task_pid = 0;
    process *right_proc = NULL;
    uint32_t right_pid = 0;

    fdta_target_ulong next_task, mm;
    next_task = OFFSET_PROFILE.init_task_addr;

    while(true)
    {
        BREAK_IF(fdta_read_ptr(cs, next_task + (OFFSET_PROFILE.ts_tasks + sizeof(target_ptr)), &next_task) < 0);
        next_task -= OFFSET_PROFILE.ts_tasks;
        if(OFFSET_PROFILE.init_task_addr == next_task) {
            break;
        }
        BREAK_IF(fdta_read_ptr(cs, next_task + OFFSET_PROFILE.ts_mm, &mm) < 0);
        if (mm != 0) {
            fdta_read_ptr(cs, next_task + OFFSET_PROFILE.ts_tgid,
                           &task_pid);
            // Collect PIDs of all processes in the task linked list
            pids.insert(task_pid);
        }
    }

    // Compare the collected list with the internal list. We track the Process which is removed and call `vmi_process_remove`
    for(unordered_map < fdta_target_ulong, process * >::iterator iter = process_pid_map.begin(); iter != process_pid_map.end(); ++iter) {
        if(iter->first != 0 && !pids.count(iter->first)) {
            right_pid = iter->first;
            right_proc = iter->second;
            break;
        }
    }

    if(right_pid == 0)
		return NULL;
	//monitor_printf(default_mon,"process with pid [%08x]  ended\n",right_pid);
    vmi_remove_process(right_pid);
    return right_proc;
}

// Traverse the memory map for a process
void traverse_mmap(CPUState *cs, void *opaque)
{
    process *proc = (process *)opaque;
    fdta_target_ulong mm, vma_curr, vma_file, f_dentry, f_inode, mm_mmap, vma_next = 0;
    unordered_set<fdta_target_ulong> module_bases;
    unsigned int inode_number;
    fdta_target_ulong vma_vm_start = 0, vma_vm_end = 0;
    fdta_target_ulong last_vm_end = 0, mod_vm_start = 0;
    char name[32];	// module file path
    string last_mod_name;
    module *mod = NULL;

    if (fdta_read_ptr(cs, proc->EPROC_base_addr + OFFSET_PROFILE.ts_mm, &mm) < 0)
        return;

    if (fdta_read_ptr(cs, mm + OFFSET_PROFILE.mm_mmap, &mm_mmap) < 0)
        return;

    // Mark the `modules_extracted` true. This is done because this function calls `vmi_find_module_by_base`
    // and that function calls `traverse_mmap` if `modules_extracted` is false. We don't want to get into
    // an infinite recursion.
    proc->modules_extracted = true;
    if (-1U == proc->pgd)
        return;

    // starting from the first vm_area, read vm_file. NOTICE vm_area_struct can be null
    if ((vma_curr = mm_mmap) == 0)
        return;

    while(true) {
        // read start of curr vma
        if (fdta_read_ptr(cs, vma_curr + OFFSET_PROFILE.vma_vm_start, &vma_vm_start) < 0)
            goto next;

        // read end of curr vma
        if (fdta_read_ptr(cs, vma_curr + OFFSET_PROFILE.vma_vm_end, &vma_vm_end) < 0)
            goto next;

#if 0
        printf("memory %x:%x ", vma_vm_start, vma_vm_end); 
#endif

        // read the struct* file entry of the curr vma, used to then extract the dentry of the this page
        if (fdta_read_ptr(cs, vma_curr + OFFSET_PROFILE.vma_vm_file, &vma_file) < 0 || !vma_file)
            goto next;

        // dentry extraction from the struct* file
        if (fdta_read_ptr(cs, vma_file + OFFSET_PROFILE.file_dentry, &f_dentry) < 0 || !f_dentry)
            goto next;

        // read small names form the dentry
        if (fdta_read_mem(cs, f_dentry + OFFSET_PROFILE.dentry_d_iname, 32, name) < 0)
            goto next;

        // inode struct extraction from the struct* file
        if (fdta_read_ptr(cs, f_dentry + OFFSET_PROFILE.file_inode, &f_inode) < 0 || !f_inode)
            goto next;

        // inode_number extraction
        if (fdta_read_ptr(cs, f_inode + OFFSET_PROFILE.inode_ino ,&inode_number) < 0 || !inode_number)
            goto next;

        name[31] = '\0';	// truncate long string

        // name is invalid, move on the data structure
        if (strlen(name)==0)
            goto next;

        if (!strcmp(last_mod_name.c_str(), name)) {
            // extending the module
            if(last_vm_end == vma_vm_start) {
                assert(mod);
                fdta_target_ulong new_size = vma_vm_end - mod_vm_start;
                if (mod->size < new_size)
                    mod->size = new_size;
            }
            // This is a special case when the data struct is BEING populated
            goto next;
        }

        char key[32 + 32];
        //not extending, a different module
        mod_vm_start = vma_vm_start;

        sprintf(key, "%u_%s", inode_number, name);
        mod = vmi_find_module_by_key(key);
        module_bases.insert(vma_vm_start);
        if (!mod) {
            mod = new module();
            memcpy(mod->name, name, 31);
            mod->name[31] = '\0';
            mod->size = vma_vm_end - vma_vm_start;
            mod->inode_number = inode_number;
            vmi_add_module(mod, key);
        }

        if(vmi_find_module_by_base(cs, proc->pgd, vma_vm_start) != mod) {
            vmi_insert_module(proc->pid, mod_vm_start , mod);
        }

next:
        if (fdta_read_ptr(cs, vma_curr + OFFSET_PROFILE.vma_vm_next, &vma_next) < 0)
            break;

        if (vma_next == 0) {
            break;
        }

        vma_curr = vma_next;
        last_mod_name = name;
        if (mod != NULL) {
            last_vm_end = vma_vm_end;
        }
    }

    unordered_map<fdta_target_ulong, module *>::iterator iter1 = proc->module_list.begin();
    unordered_set<fdta_target_ulong> bases_to_remove;
    for(; iter1 != proc->module_list.end(); iter1++) {
        //DEBUG-only
        //monitor_printf(default_mon,"module %s base %08x \n",iter->second->name,iter->first);
        if (module_bases.find(iter1->first) == module_bases.end())
            bases_to_remove.insert(iter1->first);
    }

    unordered_set<fdta_target_ulong>::iterator iter2;
    for (iter2 = bases_to_remove.begin(); iter2 != bases_to_remove.end(); iter2++) {
        vmi_remove_module(proc->pid, *iter2);
    }
}

//New process callback function
void new_proc_callback(fdta_callback_params* params)
{
    CPUState *cs = params->bb.cs;
    fdta_target_ulong pc = fdta_get_pc(cs);

    if(OFFSET_PROFILE.proc_exec_connector != pc)
        return;

    traverse_task_struct_add(cs);
}

//Process exit callback function
void proc_end_callback(fdta_callback_params *params)
{
    CPUState *cs = params->bb.cs;

    fdta_target_ulong pc = fdta_get_pc(cs);

    if(OFFSET_PROFILE.proc_exit_connector != pc)
        return;

    traverse_task_struct_remove(cs);
}

// Callback corresponding to `vma_link`,`vma_adjust` & `remove_vma`
// This marks the `modules_extracted` for the process `false`
void vma_update_func_callback(fdta_callback_params *params)
{
    CPUState *cs = params->bb.cs;

    fdta_target_ulong pc = fdta_get_pc(cs);

    if(!(pc == OFFSET_PROFILE.vma_link) && !(pc == OFFSET_PROFILE.vma_adjust) && !(pc == OFFSET_PROFILE.remove_vma))
        return;

    uint32_t pgd = fdta_get_pgd(cs);
    process *proc = NULL;

    proc = vmi_find_process_by_pgd(pgd);

    if(proc)
        proc->modules_extracted = false;
}

// TLB miss callback
// This callback is only used for updating modules when users have registered for either a
// module loaded/unloaded callback.
void linux_tlb_call_back(fdta_callback_params *temp)
{
    CPUState *cs = temp->tx.cs;
    uint32_t pgd = -1;
    process *proc = NULL;

    // Check too see if any callbacks are registered
    if(!vmi_is_module_extract_required())
    {
        return;
    }

    // The first time we register for some VMA related callbacks
    if(first)
    {
        printf("Registered for VMA update callbacks!\n");
        fdta_register_optimized_block_begin_callback(&vma_update_func_callback, 1, OFFSET_PROFILE.vma_adjust, OCB_CONST);
        fdta_register_optimized_block_begin_callback(&vma_update_func_callback, 1, OFFSET_PROFILE.vma_link, OCB_CONST);
        fdta_register_optimized_block_begin_callback(&vma_update_func_callback, 1, OFFSET_PROFILE.remove_vma, OCB_CONST);
        first = 0;
    }

    pgd = fdta_get_pgd(cs);
    proc = vmi_find_process_by_pgd(pgd);

    // traverse memory map for a process if required.
    if (proc && !proc->modules_extracted) {
        traverse_mmap(cs, proc);
    }
}


// to see whether this is a Linux or not,
// the trick is to check the init_thread_info, init_task
int find_linux(CPUState *cs)
{
    fdta_target_ulong thread_info = fdta_get_esp(cs) & ~(GUEST_OS_THREAD_SIZE - 1);
    static fdta_target_ulong last_thread_info = 0;

    // if current address is tested before, save time and do not try it again
    if (thread_info == last_thread_info || thread_info <= 0x80000000)
        return 0;
    // first time run
    if (last_thread_info == 0) {
    // memunordered_set(&OFFSET_PROFILE.init_task_addr, -1, sizeof(ProcInfo) - sizeof(OFFSET_PROFILE.strName));
    }

    last_thread_info = thread_info;

    if(load_proc_info(cs, thread_info, OFFSET_PROFILE) != 0) {
        return 0;
    }

    printf("swapper task @ [%08x] \n", OFFSET_PROFILE.init_task_addr);
    
    if (OFFSET_PROFILE.init_task_addr > 0xC0000000) {
        vmi_guest_kernel_base = 0xC0000000;
    }
    else {
        vmi_guest_kernel_base = 0x80000000;
    }
    
    
    return (1);
}


// when we know this is a linux
void linux_vmi_init(void)
{
    fdta_register_optimized_block_begin_callback(&new_proc_callback, 1, OFFSET_PROFILE.proc_exec_connector, OCB_CONST);
	fdta_register_optimized_block_begin_callback(&new_module_callback, 1, OFFSET_PROFILE.trim_init_extable, OCB_CONST);
	fdta_register_optimized_block_begin_callback(&proc_end_callback, 1, OFFSET_PROFILE.proc_exit_connector, OCB_CONST);
    fdta_register_callback(FDTAF_TLB_EXEC_CB, linux_tlb_call_back, 1);

	process *kernel_proc = new process();
	kernel_proc->pgd = 0;
	strcpy(kernel_proc->name, "<kernel>");
	kernel_proc->pid = 0;
	vmi_create_process(kernel_proc);
}