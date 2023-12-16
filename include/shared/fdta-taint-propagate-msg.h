#ifndef FDTAF_TAINT_PROPAGATE_MSG_H
#define FDTAF_TAINT_PROPAGATE_MSG_H

#include "qemu/osdep.h"
#include "shared/fdta-callback-common.h"

extern unsigned long ins_no;

void insn_msg(fdta_callback_params* params);
void guest_ins_asm(TranslationBlock *tb, CPUState *cs);
void guest_ins_flow(TranslationBlock *tb, CPUState *cs);
void show_tcg_ops(TCGContext *s);

#endif /* FDTAF_TAINT_PROPAGATE_MSG_H */