//fdta-vmi-msg-wrapper.cpp

#include "shared/fdta-vmi-msg-warpper.h"
#include "shared/fdta-vmi-common.h"
#include "shared/fdta-vmi-callback.h"
#include "shared/fdta-linux-vmi.h"
#include <map>
using namespace std;

#define MODULE_NAME_SIZE 64
#define MODULE_FULLNAME_SIZE 256
#define PROCESS_NAME_SIZE 64

int vmi_locate_module_by_pc(CPUState *cs, gva_t eip, gva_t pgd, modinfo_t *tm)
{
    module *m;
    process *p;
    gva_t base = 0;

    p = vmi_find_process_by_pgd(pgd);
    if(!p)
        return -1;

    m = vmi_find_module_by_pc(cs, eip, pgd, &base);
    if(!m)
        return -1;
    strncpy(tm->name, m->name, MODULE_NAME_SIZE);
    tm->base = base;
    tm->size = m->size;
    return 0;
}

int vmi_locate_module_by_name(CPUState *cs, const char *name, uint32_t pid, modinfo_t * tm)
{
    module * m = NULL;
	process * p = NULL;
	gva_t base = 0;

	if(!tm) {
		printf("tm is NULL\n");
		return -1;
	}
    p = vmi_find_process_by_pid(pid);
    if(!p) {
        return -1;
    }
    m = vmi_find_module_by_name(cs, name, p->pgd,&base);
    if(!m){
        return -1;
    }
	strncpy(tm->name,m->name, MODULE_NAME_SIZE ) ;
	tm->base = base;
	tm->size = m->size ;
	return 0;
}

int vmi_find_pgd_by_pid(uint32_t pid)
{
    process * p = NULL;
	p = vmi_find_process_by_pid(pid);
	if(!p) {
        return -1;
    }
	return p->pgd;
}

int vmi_find_pid_by_pgd(uint32_t pgd)
{
    process * p = NULL;
	p  = vmi_find_process_by_pgd(pgd);
	if(!p)
		return -1;
	return p->pid;
}

int vmi_find_pid_by_name(const char* proc_name)
{
	process *p = NULL;
	p = vmi_find_process_by_name(proc_name);
	if(!p)
		return -1;
	return p->pid;    
}

int vmi_find_procname_pid_by_pgd(uint32_t pgd, char proc_name[], size_t len, uint32_t *pid)
{
    process *p = NULL;
	p = vmi_find_process_by_pgd(pgd);
	if(!p)
		return -1;
	if(len > PROCESS_NAME_SIZE)
		strncpy(proc_name, p->name, PROCESS_NAME_SIZE);
	else
		strncpy(proc_name, p->name, len);
	*pid = p->pid;

	return 0;
}

int vmi_find_procname_pgd_by_pid(uint32_t pid, char proc_name[], size_t len, uint32_t *pgd)
{
    process *p = NULL;
	p = vmi_find_process_by_pid(pid);
	if(!p)
		return -1;
	if(len > PROCESS_NAME_SIZE)
		strncpy(proc_name,p->name, PROCESS_NAME_SIZE);
	else
		strncpy(proc_name,p->name, len);
	*pgd = p->pgd;

	return 0;
}

int vmi_get_loaded_modules_count(uint32_t pid)
{
    process *p = NULL;
	p = vmi_find_process_by_pid(pid);
	if(!p)
		return -1;
	return p->module_list.size();
}

int vmi_get_proc_modules_by_pid(uint32_t pid, modinfo_t *buf)
{
    process *p = NULL;
    p = vmi_find_process_by_pid(pid);
    module * m = NULL;
    if(!p)
        return -1;
    unordered_map<fdta_target_ulong, module *>::iterator iter;
    uint32_t index = 0;
    for (iter = p->module_list.begin(); iter != p->module_list.end(); iter++) {
        m = iter->second;
        buf[index].size = m->size;
        buf[index].base = iter->first;
        strncpy(buf[index].name, m->name, MODULE_NAME_SIZE);
        index ++;
    }
    return 0;
}

int vmi_get_all_processes_count(void)
{
    return process_map.size();
}

// 遍历容器process_map并将process的一些信息储存在procinfo_t类型的结构体数组中
int vmi_get_all_processes_info(size_t num_proc, procinfo_t *arr)
{
    unordered_map < fdta_target_ulong, process * >::iterator iter;
    size_t nproc;
    uint32_t idx = 0;
    nproc = process_map.size();
    if(num_proc != nproc)
    {
        printf("num_proc is not the same with current process number\n");
        return -1;
    }
    if(arr)
    {
        for (iter = process_map.begin(); iter != process_map.end(); iter++)
        {
            process * proc = iter->second;
            arr[idx].pgd = proc->pgd;
            arr[idx].pid = proc->pid;
            arr[idx].n_mods = proc->module_list.size();
            strncpy(arr[idx].name, proc->name,PROCESS_NAME_SIZE);
            arr[idx].name[511] = '\0';
            idx++;
        }
    }
    return 0;
}

// 遍历容器process_map并输出proc相关信息如pid/pgd/name
void vmi_list_processes(void)
{
    process *proc;
	unordered_map<fdta_target_ulong, process *>::iterator iter;

	for (iter = process_map.begin(); iter != process_map.end(); iter++) {
		proc = iter->second;
		printf("%d\tpgd=0x%016x\t%s\n", proc->pid, proc->pgd, proc->name);
	}

}

// 使用pid从容器process_pid_map中找到相应的process，然后遍历proc->module_list输出相应的module信息如base/name/size
int vmi_list_modules(CPUState* cs, uint32_t pid)
{
    unordered_map<fdta_target_ulong, process *>::iterator iter = process_pid_map.find(pid);
	if (iter == process_pid_map.end())
	{
		printf("pid not found\n");
		return -1;
	}

	unordered_map<fdta_target_ulong, module *>::iterator iter2;
	process *proc = iter->second;

	if(!proc->modules_extracted)
    {
        traverse_mmap(cs, proc);
    }

	map< fdta_target_ulong, module *> modules;
	map< fdta_target_ulong, module *>::iterator iter_m;

	for (iter2 = proc->module_list.begin(); iter2 != proc->module_list.end();iter2++) {
		modules[iter2->first] = iter2->second;
	}

	for (iter_m = modules.begin(); iter_m!=modules.end(); iter_m++) {
		module *mod = iter_m->second;
		fdta_target_ulong base = iter_m->first;
		printf("%20s\t0x%08x\t0x%08x\n", mod->name, base, mod->size);
	}

	return 0;
}
