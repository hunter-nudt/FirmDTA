/*
Copyright (C) <2012> <Syracuse System Security (Sycure) Lab>

FDTAF is based on QEMU, a whole-system emulator. You can redistribute
and modify it under the terms of the GNU GPL, version 3 or later,
but it is made available WITHOUT ANY WARRANTY. See the top-level
README file for more details.

For more information about FDTAF and other softwares, see our
web site at:
http://sycurelab.ecs.syr.edu/

If you have any questions about FDTAF,please post it on
http://code.google.com/p/fdta-platform/
*/
/*
 * FDTAF_main.h
 *
 *  Created on: Oct 14, 2012
 *      Author: lok
 *  changed on: Nov 1, 2022
 *      author: 
 *  This is half of the old main.h. All of the declarations here are
 *  target independent. All of the target dependent declarations and code
 *  are in the target directory in FDTAF_main_x86.h and .c for example
 */

#ifndef FDTAF_MAIN_H
#define FDTAF_MAIN_H

#if defined(CONFIG_2nd_CCACHE) //sina
	#define EXCP12_TNT	39
	extern int second_ccache_flag;
#endif

#include "shared/fdta-types-common.h"


#ifdef __cplusplus
extern "C"
{
#endif

#define PAGE_LEVEL 0
#define BLOCK_LEVEL 1
#define ALL_CACHE 2

/*************************************************************************
 * The Virtual Machine control
 *************************************************************************/
// Pause the guest system
void fdta_stop_vm(void);
// Unpause the guest system
void fdta_start_vm(void);

CPUState *fdta_get_current_cpu(void);

/*************************************************************************
 * Functions for accessing the guest's memory
 *************************************************************************/
/****** Functions used by FDTAF plugins ****/

/***************************************************************************************************************/
// Convert virtual address into physical address
extern gpa_t fdta_get_phys_addr(CPUState *cs, gva_t addr);

// Convert virtual address into physical address for given cr3 - cr3 is a phys addr
// The implementation is target-specific
// extern gpa_t FDTAF_get_physaddr_with_cr3(CPUState *cs, fdta_target_ulong cr3, gva_t addr);
// defined in target/(i386,arm,mip)/..., TODO
extern gpa_t fdta_get_phys_addr_with_pgd(CPUState *cs, gpa_t pgd, gva_t addr);

// wrapper -- pgd is the generic term while cr3 is the register in x86
#define fdta_get_phys_addr_with_cr3(cs, _pgd, _addr) fdta_get_phys_addr_with_pgd(cs, _pgd, _addr)

/***************************************************************************************************************/
// The basic functions for reading/writing mem, which are used by some following functions
extern fdta_errno_t fdta_memory_rw(CPUState* cs, fdta_target_ulong addr, void *buf, int len, int is_write);

fdta_errno_t fdta_memory_rw_with_pgd(
    CPUState *cs,
    fdta_target_ulong pgd,
    gva_t addr,
    void *buf,
    int len,
    int is_write);

/***************************************************************************************************************/
// Encapsulate fdta_memory_rw and fdta_memory_rw_with_pgd for ease of use
/// \brief Read from a memory region by its virtual address.
/// @param env cpu states
/// @param vaddr virtual memory address
/// @param len length of memory region (in bytes)
/// @param buf output buffer of the value to be read
/// @return status: 0 for success and -1 for failure
///
/// If failure, it usually means that the given virtual address cannot be converted
/// into physical address. It could be either invalid address or swapped out.
extern fdta_errno_t fdta_read_mem(CPUState *cs, gva_t vaddr, int len, void *buf);

/// \brief Write into a memory region by its virtual address.
///
/// @param vaddr virtual memory address
/// @param len length of memory region (in bytes)
/// @param buf input buffer of the value to be written
/// @return status: 0 for success and -1 for failure
///
/// If failure, it usually means that the given virtual address cannot be converted
/// into physical address. It could be either invalid address or swapped out.
extern fdta_errno_t fdta_write_mem(CPUState *cs, gva_t vaddr, int len, void *buf);

extern fdta_errno_t fdta_read_mem_with_pgd(CPUState *cs, fdta_target_ulong pgd, gva_t vaddr, int len, void *buf);
extern fdta_errno_t fdta_write_mem_with_pgd(CPUState *cs, fdta_target_ulong pgd, gva_t vaddr, int len, void *buf);
fdta_errno_t fdta_read_ptr(CPUState *cs, gva_t vaddr, gva_t *pptr);
/***************************************************************************************************************/

// For keylogger plugin
extern void * FDTAF_KbdState;
extern void fdta_keystroke_read(uint8_t taint_status);
extern void fdta_keystroke_place(int keycode);

/// \brief Set monitor context.
///
/// This is a boolean flag that indicates if the current execution needs to be monitored
/// and analyzed by the plugin. The default value is 1, which means that the plugin wants
/// to monitor all execution (including the OS kernel and all running applications).
/// Very often, the plugin is only interested in a single user-level process.
/// In this case, the plugin is responsible to set this flag to 1 when the execution is within
/// the specified process and to 0 when it is not.
extern int should_monitor;
extern int g_bNeedFlush;
/***************************************************************************************************************/

// For sleuthkit to read
int fdta_bdrv_pread(void *opaque, int64_t offset, void *buf, int count);

extern int FDTAF_emulation_started; //will be removed

/***************************************************************************************************************/
// In FDTAF - we do not use the same-per vcpu flushing behavior as in QEMU. For example
// fdta_flush_translation_cache is a wrapper for tb_flush that iterates through all of
// the virtual CPUs and calls tb_flush on that particular environment. The main reasoning
// behind this decision is that the user wants to know when an event occurs for any
// vcpu and not only for specific ones. This idea can change in the future of course.
// We have yet to decide how to handle multi-core analysis, at the program abstraction
// level or at the thread execution level or at the virtual cpu core level?
// No matter what the decision, flushing can occur using the CPUState as in QEMU
// or using FDTAF's wrappers.

//These are FDTAF wrappers that does flushing for all VCPUs
//Iterates through all virtual cpus and flushes the blocks
extern void fdta_flush_translation_block(CPUState *cs, gva_t pc);

//Iterates through all virtual cpus and flushes the pages
extern void fdta_flush_translation_page(CPUState *cs, gva_t pc);

// Register block/page/cache-level cache to be flushed to a single linked list named
// flush_list_internal(defined in fdta-main-internal) with type and addr
extern void register_fdta_flush_translation_cache(int type, gva_t pc);

// Do flush
extern void fdta_perform_flush(CPUState *cs);
/***************************************************************************************************************/

/* Static in monitor.c for QEMU, but we use it for plugins: */
///send a keystroke into the guest system
extern void do_send_key(const char *string);

void vmi_init(void);
// int test_find_linux(CPUState *cs);



#ifdef __cplusplus
}
#endif

#endif /* FDTAF_MAIN_H */

