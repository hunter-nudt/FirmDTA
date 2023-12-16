/*** fdta-linux-procinfo.h ***/
#ifndef LINUX_PROCINFO_H
#define LINUX_PROCINFO_H

#include "shared/fdta-types-common.h"


#ifdef __cplusplus
extern "C"
{
#endif

typedef uint32_t target_ptr;

//some definitions to help limit how much to search
// these will likely have to be adjusted for 64 bit, 20, 4k and 100 works for 32
#define MAX_THREAD_INFO_SEARCH_SIZE 8192
#define MAX_TASK_STRUCT_SEARCH_SIZE 2000 

/** Data structure that helps keep things organized. **/
typedef struct _ProcInfo
{
	char strName[32];
	uint32_t init_task_addr;
	uint32_t init_task_size;

	uint32_t ts_tasks;
	uint32_t ts_pid;
	uint32_t ts_tgid;
	uint32_t ts_group_leader;
	uint32_t ts_thread_group;
	uint32_t ts_real_parent;
	uint32_t ts_mm;
	union
	{
		uint32_t ts_stack;
		uint32_t ts_thread_info;
	};
	uint32_t ts_real_cred;
	uint32_t ts_cred;
	uint32_t ts_comm;

	uint32_t module_name;
	uint32_t module_size;
	uint32_t module_init;
	uint32_t module_list;
	uint32_t modules;
	uint32_t cred_uid;
	uint32_t cred_gid;
	uint32_t cred_euid;
	uint32_t cred_egid;
	uint32_t mm_mmap;
	uint32_t mm_pgd;
	uint32_t mm_arg_start;
	uint32_t mm_start_brk;
	uint32_t mm_brk;
	uint32_t mm_start_stack;
	uint32_t vma_vm_start;
	uint32_t vma_vm_end;
	uint32_t vma_vm_next;
	uint32_t vma_vm_file;
	uint32_t vma_vm_flags;
	uint32_t vma_vm_pgoff;
	uint32_t file_dentry;
	uint32_t dentry_d_name;
	uint32_t dentry_d_iname;
	uint32_t dentry_d_parent;
	uint32_t ti_task;
	uint32_t file_inode;
	uint32_t inode_ino;
	
	uint32_t proc_fork_connector;
	uint32_t proc_exit_connector;
	uint32_t proc_exec_connector;
	uint32_t vma_link;
	uint32_t remove_vma;
	uint32_t vma_adjust;
	uint32_t trim_init_extable;
// #ifdef TARGET_MIPS
	uint32_t mips_pgd_current;
// #endif	
} ProcInfo;

// int populate_mm_struct_offsets(CPUState *env, target_ptr mm, ProcInfo* pPI);
// int populate_vm_area_struct_offsets(CPUState *env, target_ptr vma, ProcInfo* pPI);
// int populate_dentry_struct_offsets(CPUState * env, target_ptr dentry, ProcInfo* pPI);
// int getDentryFromFile(CPUState * env, target_ptr file, ProcInfo* pPI);
// //runs through the guest's memory and populates the offsets within the
// // ProcInfo data structure. Returns the number of elements/offsets found
// // or -1 if error
// int populate_kernel_offsets(CPUState *env, target_ptr threadinfo, ProcInfo* pPI);

int print_proc_info(ProcInfo* pPI);
int load_proc_info(CPUState * env, gva_t threadinfo, ProcInfo &pi);
void load_library_info(const char *strName);

#ifdef __cplusplus
}
#endif
#endif /* LINUX_PROCINFO_H */
