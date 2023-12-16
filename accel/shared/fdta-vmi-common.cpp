//  2022 Nov 14
//  Author: aspen
#include "shared/fdta-vmi-common.h"
#include "shared/fdta-callback-common.h"
#include "shared/fdta-basic-callback.h"
#include "shared/fdta-vmi-callback.h"
#include "shared/fdta-output.h"
#include "shared/fdta-linux-vmi.h"
#include "shared/fdta-main.h"

#include <unordered_map>
#include <unordered_set>
using namespace std;

//map pgd to process_info_t
unordered_map < fdta_target_ulong, process * > process_map;
//map pid to process_info_t
unordered_map < fdta_target_ulong, process * > process_pid_map;
//map module_name to module_info
unordered_map < string, module * > module_name;

uint32_t GuestOS_index_c = 11;

uintptr_t insn_handle_c = 0;

fdta_target_ulong vmi_guest_kernel_base = 0;

static basic_callback_t vmi_callbacks[VMI_LAST_CB];

static void guest_os_confirm(fdta_callback_params* param)
{
    static long long count_out = 0x8000000000L;	// detection fails after 1000 basic blocks
    int found_guest_os = 0;

    // Probing guest OS for every basic block is too expensive and wasteful.
    // Let's just do it once every 256 basic blocks
    if((count_out & 0xff) != 0)
	{
		goto _skip_probe;
	}
    	
	found_guest_os = find_linux(param->tx.cs);

	if(found_guest_os) {
		fdta_unregister_callback(FDTAF_TLB_EXEC_CB, insn_handle_c);
		linux_vmi_init();
	}

_skip_probe:

	if (count_out-- <= 0) // not find 
	{
		fdta_unregister_callback(FDTAF_TLB_EXEC_CB, insn_handle_c);
		printf("oops! guest OS type cannot be decided. \n");
	}
}

module * vmi_find_module_by_key(const char *key)
{
	string temp(key);
	unordered_map < string, module * >::iterator iter = module_name.find(temp);
	if (iter != module_name.end()){
		return iter->second;
	}
	return NULL;
}

module * vmi_find_module_by_base(CPUState *cs, gva_t pgd, gva_t base)
{
	unordered_map < fdta_target_ulong, process *>::iterator iter = process_map.find(pgd);
	process *proc;
	
	if (iter == process_pid_map.end()) //pid not found
		return NULL;

	proc = iter->second;

	if(!proc->modules_extracted) {
		cs = fdta_get_current_cpu();
		traverse_mmap(cs, proc);
	}
		
	unordered_map < fdta_target_ulong, module *>::iterator iter_m = proc->module_list.find(base);
	if(iter_m == proc->module_list.end())
		return NULL;

	return iter_m->second;
}

module * vmi_find_module_by_pc(CPUState *cs, gva_t pc, gva_t pgd, gva_t *base)
{
	process *proc;
	if (pc >= vmi_guest_kernel_base) {
		proc = process_pid_map[0];
	}
    else {
		unordered_map < fdta_target_ulong, process * >::iterator iter_p = process_map.find(pgd);
		if (iter_p == process_map.end())
			return NULL;

		proc = iter_p->second;
	}

	if(!proc->modules_extracted) {
		traverse_mmap(cs, proc);
	}	

	unordered_map< uint32_t, module * >::iterator iter;
	for (iter = proc->module_list.begin(); iter != proc->module_list.end(); iter++) {
		module *mod = iter->second;
		if (iter->first <= pc && mod->size + iter->first > pc) {
			*base = iter->first;
			return mod;
		}
	}

    return NULL;
}

module * vmi_find_module_by_name(CPUState *cs, const char *name, gva_t pgd, gva_t *base)
{
	
	unordered_map < fdta_target_ulong, process * >::iterator iter_p = process_map.find(pgd);
	if (iter_p == process_map.end())
		return NULL;

	process *proc = iter_p->second;

	if(!proc->modules_extracted) {
		traverse_mmap(cs, proc);
	}
		
	unordered_map< fdta_target_ulong, module * >::iterator iter;
	for (iter = proc->module_list.begin(); iter != proc->module_list.end(); iter++) {
		module *mod = iter->second;
		if (strcasecmp(mod->name, name) == 0) {
			*base = iter->first;
			return mod;
		}
	}

	return NULL;
}

process * vmi_find_process_by_pid(uint32_t pid)
{
	unordered_map < fdta_target_ulong, process * >::iterator iter = process_pid_map.find(pid);

	if (iter == process_pid_map.end())
		return NULL;

	return iter->second;
}

process * vmi_find_process_by_pgd(gva_t pgd)
{
    unordered_map < fdta_target_ulong, process * >::iterator iter = process_map.find(pgd);

    if (iter != process_map.end())
		return iter->second;

	return NULL;
}

process * vmi_find_process_by_name(const char *name)
{
	unordered_map < fdta_target_ulong, process * >::iterator iter;
	for (iter = process_map.begin(); iter != process_map.end(); iter++) {
		process * proc = iter->second;
		if (strcmp((const char *)name,proc->name) == 0) {
			return proc;
		}
	}
	return 0;
}

int vmi_create_process(process *proc)
{	
	VMI_Callback_Params params;

	proc->modules_extracted = true;
	
	params.cp.pgd = proc->pgd;
	params.cp.pid = proc->pid;
	params.cp.name = proc->name;
    unordered_map < fdta_target_ulong, process * >::iterator iter1 = process_pid_map.find(proc->pid);
    if (iter1 != process_pid_map.end()) {
    	// Found an existing process with the same pid
    	// We force to remove that one.
        // monitor_printf(default_mon, "remove process pid %d", proc->pid);
    	vmi_remove_process(proc->pid);
    }

    unordered_map < fdta_target_ulong, process * >::iterator iter2 = process_map.find(proc->pgd);
    if (iter2 != process_map.end()) {
    	// Found an existing process with the same CR3
    	// We force to remove that process
        // monitor_printf(default_mon, "removing due to pgd 0x%08x\n", proc->pgd);
    	vmi_remove_process(iter2->second->pid);
    }

   	process_pid_map[proc->pid] = proc;
   	process_map[proc->pgd] = proc;

	basic_callback_dispatch(&vmi_callbacks[VMI_CREATEPROC_CB], &params);

	return 0;
}

int vmi_remove_process(uint32_t pid)
{
	VMI_Callback_Params params;
	unordered_map < fdta_target_ulong, process * >::iterator iter = process_pid_map.find(pid);

	if(iter == process_pid_map.end())
	    return -1;

	// params.rp.proc = iter->second;

	params.rp.pgd = iter->second->pgd;
	params.rp.pid = iter->second->pid;
	params.rp.name = iter->second->name;
	// printf("removing %d %x %s\n", params.rp.pid, params.rp.pgd, params.rp.name);
	basic_callback_dispatch(&vmi_callbacks[VMI_REMOVEPROC_CB], &params);

	process_map.erase(iter->second->pgd);
	process_pid_map.erase(iter);
	delete iter->second;

	return 0;
}

int vmi_add_module(module *mod, const char *key){
	if(mod==NULL)
		return -1;
	string temp(key);
	unordered_map < string, module * >::iterator iter = module_name.find(temp);
	if (iter != module_name.end()) {
		return -1;
	}
	module_name[temp] = mod;
	return 1;
}

int vmi_insert_module(uint32_t pid, uint32_t base, module *mod)
{
	VMI_Callback_Params params;
	params.lm.pid = pid;
	params.lm.base = base;
	params.lm.name = mod->name;
	params.lm.size = mod->size;
	params.lm.full_name = mod->fullname;
	unordered_map < fdta_target_ulong, process *>::iterator iter = process_pid_map.find(pid);
	process *proc;

	if (iter == process_pid_map.end()) //pid not found
		return -1;

	proc = iter->second;
    params.lm.pgd = proc->pgd;

	//Now the pages within the module's memory region are all resolved
	//We also need to removed the previous modules if they happen to sit on the same region

	for (gva_t vaddr = base; vaddr < base + mod->size; vaddr += 4096) {
		proc->resolved_pages.insert(vaddr >> 12);
		//TODO: UnloadModule callback
		proc->module_list.erase(vaddr);
	}

	//Now we insert the new module in module_list
	proc->module_list[base] = mod;

	//check_unresolved_hooks();

	basic_callback_dispatch(&vmi_callbacks[VMI_LOADMODULE_CB], &params);

	return 0;
}

int vmi_remove_module(uint32_t pid, uint32_t base)
{
	VMI_Callback_Params params;
	params.rm.pid = pid;
	params.rm.base = base;
	unordered_map < fdta_target_ulong, process *>::iterator iter = process_pid_map.find(pid);
	process *proc;

	if (iter == process_pid_map.end()) //pid not found
		return -1;

	proc = iter->second;
	params.rm.pgd = proc->pgd;

	unordered_map < fdta_target_ulong, module *>::iterator m_iter = proc->module_list.find(base);
	if(m_iter == proc->module_list.end())
		return -1;

	module *mod = m_iter->second;

	params.rm.name = mod->name;
	params.rm.size = mod->size;
	params.rm.full_name = mod->fullname;

	proc->module_list.erase(m_iter);

	basic_callback_dispatch(&vmi_callbacks[VMI_REMOVEMODULE_CB], &params);

	for (uint32_t vaddr = base; vaddr < base + mod->size; vaddr += 4096) {
		proc->resolved_pages.erase(vaddr >> 12);
	}

	return 0;
}

int vmi_dipatch_lmm(process *proc)
{

	VMI_Callback_Params params;
	params.cp.pgd = proc->pgd;
	params.cp.pid = proc->pid;
	params.cp.name = proc->name;

	basic_callback_dispatch(&vmi_callbacks[VMI_CREATEPROC_CB], &params);

	return 0;
}

int vmi_dispatch_lm(module * m, process *p, gva_t base)	//vmi_dispatch_loadmodule
{
	VMI_Callback_Params params;
	params.lm.pid = p->pid;
	params.lm.base = base;
	params.lm.name = m->name;
	params.lm.size = m->size;
	params.lm.full_name = m->fullname;
	params.lm.pgd = p->pgd;

	basic_callback_dispatch(&vmi_callbacks[VMI_LOADMODULE_CB], &params);

    return 0;
}

int vmi_is_module_extract_required()
{
	if(QLIST_EMPTY(&vmi_callbacks[VMI_LOADMODULE_CB]) && QLIST_EMPTY(&vmi_callbacks[VMI_REMOVEMODULE_CB]))
		return 0;

	return 1;
}


fdta_handle vmi_register_callback(
    VMI_callback_type_t cb_type,
    vmi_callback_func_t cb_func,
    int cb_cond)
{
    if ((cb_type > VMI_LAST_CB) || (cb_type < 0)) {
        return (FDTAF_NULL_HANDLE);
    }

    return (basic_callback_register(&vmi_callbacks[cb_type], (basic_callback_func_t)cb_func, cb_cond));
}

int vmi_unregister_callback(VMI_callback_type_t cb_type, fdta_handle handle)
{
    if ((cb_type > VMI_LAST_CB) || (cb_type < 0)) {
        return (FDTAF_NULL_HANDLE);
    }

    return (basic_callback_unregister(&vmi_callbacks[cb_type], handle));
}

void vmi_init(void)
{
#ifdef CONFIG_ENABLE_VMI
	printf("inside vmi init \n");
	insn_handle_c = fdta_register_callback(FDTAF_TLB_EXEC_CB, guest_os_confirm, 1);
#endif
}
