/*  
 *  functions to get vmi messages
 *
 *  Created on: Dec 11, 2013
 *      Author: hu
 */

#ifndef VMI_MSG_WRAPPER_H
#define VMI_MSG_WRAPPER_H

#include "shared/fdta-types-common.h"

#ifdef __cplusplus
extern "C"
{
#endif

/// a structure of module information
typedef struct modinfo
{
	char	    name[512];  // module name
	uint32_t	base;       // module base address
	uint32_t	size;       // module size
}modinfo_t;

typedef struct procinfo
{
  uint32_t pid;
  uint32_t pgd;
  size_t n_mods;
  char name[512];
}procinfo_t;

// find process from process_map using the pgd as search key, then find module from proc->module_list using eip(pc) as search key
// write messages to (char)proc and (modinfo_t*)tm
int vmi_locate_module_by_pc(CPUState *cs, gva_t eip, gva_t pgd, modinfo_t *tm);

// find process from process_pid_map using the pid as search key, then find module from proc->module_list using name as search key
// write messages to (modinfo_t*)tm
int vmi_locate_module_by_name(CPUState *cs, const char *name, uint32_t pid,modinfo_t * tm);

// find process from process_pid_map using pid and return proc->pgd
int vmi_find_pgd_by_pid(uint32_t pid);

// find process from process_map using pgd/pgd and return proc->pid 
int vmi_find_pid_by_pgd(uint32_t pgd);

// find process from process_map using process name and return proc->pid
int vmi_find_pid_by_name(const char* proc_name);

// find process name and pid from process_map using pgd as search key
int vmi_find_procname_pid_by_pgd(uint32_t pgd, char proc_name[], size_t len, uint32_t *pid);

// find process name and pgd from process_pid_map using the pid as search key
int vmi_find_procname_pgd_by_pid(uint32_t pid, char proc_name[], size_t len, uint32_t *pgd);

// get the number of loaded modules for the process
int vmi_get_loaded_modules_count(uint32_t pid);

// 利用pid从容器process_pid_map中获取相应的process，然后遍历proc->module_list并将相关信息保存在modinfo_t类型的结构体数组中
int vmi_get_proc_modules_by_pid(uint32_t pid, modinfo_t *buf);

// 获取进程数量
int vmi_get_all_processes_count(void);

// 遍历容器process_map并将process的一些信息储存在procinfo_t类型的结构体数组中
int vmi_get_all_processes_info(size_t num_proc, procinfo_t *arr);

// 遍历容器process_map并输出proc相关信息如pid/pgd/name
void vmi_list_processes(void);

// 使用pid从容器process_pid_map中找到相应的process，然后遍历proc->module_list输出相应的module信息如base/name/size
int vmi_list_modules(CPUState* cs, uint32_t pid);


#ifdef __cplusplus
}
#endif

#endif /* VMI_MSG_WRAPPER_H */
