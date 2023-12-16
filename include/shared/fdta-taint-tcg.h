#ifndef FDTAF_TAINT_TCG
#define FDTAF_TAINT_TCG

#include "tcg/tcg-op.h"
#include "tcg/tcg.h"

extern TCGOp *last_op;

#ifdef TARGET_I386
#define find_shadow_offset find_shadow_offset_i386
#elif defined(TARGET_ARM)
#define find_shadow_offset find_shadow_offset_arm
#elif defined(TARGET_MIPS)
#define find_shadow_offset find_shadow_offset_mips
#endif

extern TCGv_i64 taint_temps;

extern uint32_t shadow_arg_list[TCG_MAX_TEMPS];

TCGv find_shadow_arg(TCGArg arg);
int find_shadow_offset_i386(int offset);
int find_shadow_offset_arm(int offset);
int find_shadow_offset_mips(int offset);
void clean_shadow_arg(void);
void optimize_taint(TCGOp *old_first_op);

#endif /* FDTAF_TAINT_TCG */