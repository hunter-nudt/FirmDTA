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
/**
 * @author Lok Yan
 * @date 9 Oct 2012
 * @author aspen
 * @date 1 Nov 2022
 * Explicit declaration of prototypes between FDTAF callbacks and QEMU. This includes all of the
 *   helper functions
 */

#ifndef FDTAF_CALLBACK_TO_QEMU_H
#define FDTAF_CALLBACK_TO_QEMU_H

#include "shared/fdta-callback-common.h"

#ifdef __cplusplus
extern "C"
{
#endif

int fdta_is_callback_needed(fdta_callback_type_t cb_type);
int fdta_is_callback_needed_for_opcode(int op);
int fdta_is_block_begin_callback_needed(gva_t pc);

// extern void helper_fdta_invoke_block_begin_callback(CPUState* cs, TranslationBlock* tb);
extern void helper_fdta_invoke_block_end_callback(CPUState* cs, TranslationBlock* tb, gva_t from);
extern void helper_fdta_invoke_insn_after_callback(CPUState* cs);
extern void helper_fdta_invoke_eip_check_callback(gva_t source_eip, gva_t target_eip, gva_t target_eip_taint);

//This is needed since tlb_exec_cb doesn't go into tb and therefore not in helper.h
extern void fdta_invoke_tlb_exec_callback(CPUState *cs, gva_t vaddr);

void helper_fdta_invoke_nic_rec_callback(uint8_t * buf, int size, int cur_pos, int start, int stop);
void helper_fdta_invoke_nic_send_callback(uint32_t addr, int size, uint8_t *buf);
void helper_fdta_invoke_mem_read_callback(gva_t vaddr, ram_addr_t paddr, unsigned long value, DATA_TYPE data_type);
void helper_fdta_invoke_mem_write_callback(gva_t vaddr, ram_addr_t paddr, unsigned long value, DATA_TYPE data_type);
void helper_fdta_invoke_keystroke_callback(int keycode, uint32_t *taint_mark);
void helper_fdta_invoke_read_taint_mem(gva_t vaddr, ram_addr_t paddr, uint32_t size, uint8_t *taint_info);
void helper_fdta_invoke_write_taint_mem(gva_t vaddr, ram_addr_t paddr, uint32_t size, uint8_t *taint_info);
void helper_fdta_invoke_log_pointer_read(gva_t virt_addr,gva_t taint_info);
void helper_fdta_invoke_log_pointer_write(gva_t virt_addr, gva_t taint_info);

#ifdef __cplusplus
}
#endif

#endif//FDTAF_CALLBACK_TO_QEMU_H