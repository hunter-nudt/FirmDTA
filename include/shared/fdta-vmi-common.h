/*
 * vmi.h
 *
 *  Created on: Jan 22, 2013
 *      Author: Heng Yin
 *  changed on: Nov 3, 2022
 *      author: aspen
 */

#ifndef FDTAF_VMI_COMMON_H
#define FDTAF_VMI_COMMON_H

#include "shared/fdta-types-common.h"

#include <list>
#include <unordered_map>
#include <unordered_set>
#include <string>
using namespace std;

#ifdef __cplusplus
extern "C"
{
#endif

#define VMI_MAX_MODULE_PROCESS_NAME_LEN 64
#define VMI_MAX_MODULE_FULL_NAME_LEN 256

class module{
public:
	char name[VMI_MAX_MODULE_PROCESS_NAME_LEN];
	char fullname[VMI_MAX_MODULE_FULL_NAME_LEN];
	uint32_t size;
	uint32_t codesize; // use these to identify dll
	uint32_t checksum;
	uint16_t major;
	uint16_t minor;
	unsigned int inode_number;
};

class process{
public:
    uint32_t pgd;
    uint32_t pid;
    uint32_t parent_pid;
    uint32_t EPROC_base_addr;
    char name[VMI_MAX_MODULE_PROCESS_NAME_LEN];
    bool modules_extracted;
    //map base address to module pointer
    unordered_map< fdta_target_ulong, module * >module_list;
    //a set of virtual pages that have been resolved with module information
    unordered_set< fdta_target_ulong > resolved_pages;
};

typedef enum {
	WINXP_SP2_C = 0, 
    WINXP_SP3_C,
    WIN7_SP0_C,
    WIN7_SP1_C,
    LINUX_GENERIC_C,
} GUEST_OS_C;

typedef struct os_handle_c{
	GUEST_OS_C os_info;
	int (*find)(CPUState *cs, uintptr_t insn_handle);
	void (*init)();
} os_handle_c;

extern fdta_target_ulong vmi_guest_kernel_base;

// map pgd to process_info_t
extern unordered_map < fdta_target_ulong, process * > process_map;
// map pid to process_info_t
extern unordered_map < fdta_target_ulong, process * > process_pid_map;
// map module_name to module_info
extern unordered_map < string, module * > module_name;

// 这里的key是module_name,这个函数是从module_name容器中查找module。
module * vmi_find_module_by_key(const char *key);

// 使用pgd定位到module所在proc,然后用base从proc->module_list中查找相应module
module * vmi_find_module_by_base(CPUState *cs, gva_t pgd, gva_t base);

// 先使用pgd定位到proc,然后使用pc从proc->module_list中查找相应的module,并将base指向module_base_addr
module * vmi_find_module_by_pc(CPUState *cs, gva_t pc, gva_t pgd, gva_t *base);

// 先使用pgd定位到proc,然后使用module_name从proc->module_list中查找相应的module,并将base指向module_base_addr
module * vmi_find_module_by_name(CPUState *cs, const char *name, gva_t pgd, gva_t *base);


// 以pid为索引从容器process_pid_map中找到相应process
process * vmi_find_process_by_pid(uint32_t pid);

// 以pgd的值从容器process_map中查找相应process
process * vmi_find_process_by_pgd(gva_t pgd);

// 以proc name为索引从容器process_map中找到相应的process
process * vmi_find_process_by_name(const char *name);


// 将新发现的process加入容器,并触发类型为VMI_CREATEPROC_CB的回调函数
int vmi_create_process(process *proc);

// 触发类型为VMI_REMOVEPROC_CB的回调函数,并从容器中删除pid对应的process
int vmi_remove_process(uint32_t pid);

// 将module加入module_name容器
int vmi_add_module(module *mod, const char *key);

// 插入module到proc->module_list,并触发类型为VMI_LOADMODULE_CB的回调函数
int vmi_insert_module(uint32_t pid, uint32_t base, module *mod);

// 从process中的module_list中删除module,并触发类型为VMI_REMOVEMODULE_CB的回调函数s
int vmi_remove_module(uint32_t pid, uint32_t base);

//触发类型为VMI_CREATEPROC_CB的回调函数,参数是proc,不加入容器
int vmi_dipatch_lmm(process *proc);

//触发类型为VMI_LOADMODULE_CB的回调函数,同样不将module加入容器
int vmi_dispatch_lm(module *m,process *proc, gva_t base);

int vmi_is_module_extract_required();

int vmi_extract_symbols(module *mod, gva_t base);

int procmod_init();
void handle_guest_message(const char *message);


#ifdef __cplusplus
}
#endif

#endif /* FDTAF_VMI_COMMON_H */
