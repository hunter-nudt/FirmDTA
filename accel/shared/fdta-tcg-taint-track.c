#include "qemu/osdep.h"
#include "shared/fdta-types-common.h"
#include "shared/fdta-main.h"
#include "shared/fdta-main-internal.h"
#include "shared/fdta-taint-memory-basic.h"
#include "shared/fdta-taint-memory.h"
#include "exec/exec-all.h"
#include "exec/cpu-all.h"
#include "exec/translate-all.h"
#include "qapi/qapi-types-machine.h"
#include "hw/core/cpu.h"
#include "accel/tcg/tb-context.h"
#include "sysemu/hw_accel.h"
#if !defined(CONFIG_USER_ONLY)
#include "hw/boards.h"
#endif
#include "exec/helper-proto.h"
#include "exec/helper-gen.h"

#include "shared/fdta-callback-common.h"
#include "shared/fdta-callback-to-qemu.h"
#include "shared/fdta-taint-tcg.h"

#ifdef TARGET_I386
#define CPUARCHState CPUX86State
#elif defined(TARGET_ARM)
#define CPUARCHState CPUARMState
#elif defined(TARGET_MIPS)
#define CPUARCHState CPUMIPSState
#endif

// static inline CPUARCHState * fdta_get_current_env(CPUState *cs) {
// #ifdef TARGET_I386
//     X86CPU *cpu = X86_CPU(cs);
//     CPUX86State *env = &cpu->env;
//     return env;
// #elif defined(TARGET_ARM)
//     ARMCPU *cpu = ARM_CPU(cs);
//     CPUARMState *env = &cpu->env;
//     return env;
// #elif defined(TARGET_MIPS)
//     MIPSCPU *cpu = MIPS_CPU(cs);
//     CPUMIPSState *env = &cpu->env;
//     return env;
// #endif
// }

TCGv_i64 taint_temps;
uint32_t shadow_arg_list[TCG_MAX_TEMPS];

static inline TCGv_i32 arg_i32_tcgv(TCGArg arg)
{
    return (TCGv_i32)((void *)arg - (void *)tcg_ctx);
}

static inline TCGv_i64 arg_i64_tcgv(TCGArg arg)
{
    return (TCGv_i64)((void *)arg - (void *)tcg_ctx);
}

static inline TCGv_ptr arg_ptr_tcgv(TCGArg arg)
{
    return (TCGv_ptr)((void *)arg - (void *)tcg_ctx);
}

static inline TCGv_vec arg_vec_tcgv(TCGArg arg)
{
    return (TCGv_vec)((void *)arg - (void *)tcg_ctx);
}

static inline TCGArg tcgv_to_arg_i32(TCGv_i32 v)
{
    uintptr_t o = (uintptr_t)v;
    return (uintptr_t)((void *)tcg_ctx + o);
}

static inline TCGArg tcgv_to_arg_i64(TCGv_i64 v)
{
    uintptr_t o = (uintptr_t)v;
    return (uintptr_t)((void *)tcg_ctx + o);
}

static inline TCGArg tcgv_to_arg_ptr(TCGv_ptr v)
{
    uintptr_t o = (uintptr_t)v;
    return (uintptr_t)((void *)tcg_ctx + o);
}

static inline TCGArg tcgv_to_arg_vec(TCGv_vec v)
{
    uintptr_t o = (uintptr_t)v;
    return (uintptr_t)((void *)tcg_ctx + o);
}

static inline TCGTemp *arg_to_temp(TCGArg a)
{
    return (TCGTemp *)(uintptr_t)a;
}

TCGv_i32 find_shadow_arg(TCGArg arg)
{
    TCGContext *s = tcg_ctx;
    TCGTemp *t = arg_to_temp(arg);
    int idx = temp_idx(t);
    TCGv_i32 shadow_arg;
    TCGTemp *shadow_t;

    if (idx < s->nb_globals)
        return temp_tcgv_i32(&s->temps[shadow_arg_list[idx]]);

    if (shadow_arg_list[idx])
        return temp_tcgv_i32(&s->temps[shadow_arg_list[idx]]);
    else {
        if(t->type == TCG_TYPE_I32) {
            if(t->kind == TEMP_LOCAL) {
                shadow_arg = tcg_temp_local_new_i32();
            }
            else if(t->kind == TEMP_CONST){
                shadow_arg = tcg_constant_i32(0);
            }
            else {
                shadow_arg = tcg_temp_new_i32();
            }
        }
        else {
            if(t->kind == TEMP_LOCAL) {
                shadow_arg = (TCGv_i32)tcg_temp_local_new_i64();
            }
            else if(t->kind == TEMP_CONST){
                shadow_arg = (TCGv_i32)tcg_constant_i64(0);
            }
            else {
                shadow_arg = (TCGv_i32)tcg_temp_new_i64();
            }
        }
    }

    shadow_t = tcgv_i32_temp(shadow_arg);
    shadow_arg_list[idx] = temp_idx(shadow_t);
    return shadow_arg; 
}

void clean_shadow_arg(void)
{
    TCGContext *s = tcg_ctx;
    for (int i = s->nb_globals - 1; i < TCG_MAX_TEMPS; i++)
    {
        shadow_arg_list[i] = 0;
    }
}

#ifdef TARGET_I386
int find_shadow_offset_i386(int offset)
{
    switch (offset)
    {
        case offsetof(CPUX86State, cc_op):
            return offsetof(CPUX86State, taint_cc_op);
        case offsetof(CPUX86State, cc_dst):
            return offsetof(CPUX86State, taint_cc_dst);
        case offsetof(CPUX86State, cc_src):
            return offsetof(CPUX86State, taint_cc_src);
        case offsetof(CPUX86State, cc_src2):
            return offsetof(CPUX86State, taint_cc_src2);
#ifdef TARGET_X86_64
        case offsetof(CPUX86State, regs[0]):
            return offsetof(CPUX86State, taint_regs[0]);
        case offsetof(CPUX86State, regs[1]):
            return offsetof(CPUX86State, taint_regs[1]);
        case offsetof(CPUX86State, regs[2]):
            return offsetof(CPUX86State, taint_regs[2]);
        case offsetof(CPUX86State, regs[3]):
            return offsetof(CPUX86State, taint_regs[3]);
        case offsetof(CPUX86State, regs[4]):
            return offsetof(CPUX86State, taint_regs[4]);
        case offsetof(CPUX86State, regs[5]):
            return offsetof(CPUX86State, taint_regs[5]);
        case offsetof(CPUX86State, regs[6]):
            return offsetof(CPUX86State, taint_regs[6]);
        case offsetof(CPUX86State, regs[7]):
            return offsetof(CPUX86State, taint_regs[7]);
        case offsetof(CPUX86State, regs[8]):
            return offsetof(CPUX86State, taint_regs[8]);
        case offsetof(CPUX86State, regs[9]):
            return offsetof(CPUX86State, taint_regs[9]);
        case offsetof(CPUX86State, regs[10]):
            return offsetof(CPUX86State, taint_regs[10]);
        case offsetof(CPUX86State, regs[11]):
            return offsetof(CPUX86State, taint_regs[11]);
        case offsetof(CPUX86State, regs[12]):
            return offsetof(CPUX86State, taint_regs[12]);
        case offsetof(CPUX86State, regs[13]):
            return offsetof(CPUX86State, taint_regs[13]);
        case offsetof(CPUX86State, regs[14]):
            return offsetof(CPUX86State, taint_regs[14]);
        case offsetof(CPUX86State, regs[15]):
            return offsetof(CPUX86State, taint_regs[15]);
#endif
        case offsetof(CPUX86State, regs[0]):
            return offsetof(CPUX86State, taint_regs[0]);
        case offsetof(CPUX86State, regs[1]):
            return offsetof(CPUX86State, taint_regs[1]);
        case offsetof(CPUX86State, regs[2]):
            return offsetof(CPUX86State, taint_regs[2]);
        case offsetof(CPUX86State, regs[3]):
            return offsetof(CPUX86State, taint_regs[3]);
        case offsetof(CPUX86State, regs[4]):
            return offsetof(CPUX86State, taint_regs[4]);
        case offsetof(CPUX86State, regs[5]):
            return offsetof(CPUX86State, taint_regs[5]);
        case offsetof(CPUX86State, regs[6]):
            return offsetof(CPUX86State, taint_regs[6]);
        case offsetof(CPUX86State, regs[7]):
            return offsetof(CPUX86State, taint_regs[7]);

        case offsetof(CPUX86State, segs[0].base):
            return offsetof(CPUX86State, taint_segs[0].base);
        case offsetof(CPUX86State, segs[1].base):
            return offsetof(CPUX86State, taint_segs[1].base);
        case offsetof(CPUX86State, segs[2].base):
            return offsetof(CPUX86State, taint_segs[2].base);
        case offsetof(CPUX86State, segs[3].base):
            return offsetof(CPUX86State, taint_segs[3].base);
        case offsetof(CPUX86State, segs[4].base):
            return offsetof(CPUX86State, taint_segs[4].base);
        case offsetof(CPUX86State, segs[5].base):
            return offsetof(CPUX86State, taint_segs[5].base);

        case offsetof(CPUX86State, bnd_regs[0].lb):
            return offsetof(CPUX86State, taint_bnd_regs[0].lb);
        case offsetof(CPUX86State, bnd_regs[1].lb):
            return offsetof(CPUX86State, taint_bnd_regs[1].lb);
        case offsetof(CPUX86State, bnd_regs[2].lb):
            return offsetof(CPUX86State, taint_bnd_regs[2].lb);
        case offsetof(CPUX86State, bnd_regs[3].lb):
            return offsetof(CPUX86State, taint_bnd_regs[3].lb);

        case offsetof(CPUX86State, bnd_regs[0].ub):
            return offsetof(CPUX86State, taint_bnd_regs[0].ub);
        case offsetof(CPUX86State, bnd_regs[1].ub):
            return offsetof(CPUX86State, taint_bnd_regs[0].ub);
        case offsetof(CPUX86State, bnd_regs[2].ub):
            return offsetof(CPUX86State, taint_bnd_regs[0].ub);
        case offsetof(CPUX86State, bnd_regs[3].ub):
            return offsetof(CPUX86State, taint_bnd_regs[0].ub);
        default:
            return offset;
    }
}
#elif defined(TARGET_ARM)
int find_shadow_offset_arm(int offset)
{
    if(offsetof(CPUARMState, regs[0]) <= offset && offset <= offsetof(CPUARMState, regs[15])) {
       for (int i = 0; i < 16; i++) {
           if(offset == offsetof(CPUARMState, regs[i])) {
               return offsetof(CPUARMState, taint_regs[i]);
           }
       }
    }
    else {
        switch (offset) {
            case offsetof(CPUARMState, CF):
                return offsetof(CPUARMState, taint_CF);
            case offsetof(CPUARMState, NF):
                return offsetof(CPUARMState, taint_NF);
            case offsetof(CPUARMState, VF):
                return offsetof(CPUARMState, taint_VF);
            case offsetof(CPUARMState, ZF):
                return offsetof(CPUARMState, taint_ZF);
            case offsetof(CPUARMState, exclusive_addr):
                return offsetof(CPUARMState, taint_exclusive_addr);
            case offsetof(CPUARMState, exclusive_val):
                return offsetof(CPUARMState, taint_exclusive_val);
            default:
                return offset;
        }
    }
    return offset;
}
#elif defined(TARGET_MIPS)
int find_shadow_offset_mips(int offset)
{
    if (offsetof(CPUMIPSState, active_tc.gpr[1]) <= offset && offset <= offsetof(CPUMIPSState, active_tc.gpr[31])) {
        for(int i = 1; i < 32; i++) {
            if(offset == offsetof(CPUMIPSState, active_tc.gpr[i])) {
                return offsetof(CPUMIPSState, active_tc.taint_gpr[i]);
            }
        }
    }           
    else if (offsetof(CPUMIPSState, active_fpu.fpr[0].wr.d[0]) <= offset && offset <= offsetof(CPUMIPSState, active_fpu.fpr[31].wr.d[0])) {
        for(int i = 0; i < 32; i++) {
            if(offset == offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0])) {
                return offsetof(CPUMIPSState, active_fpu.taint_fpr[i].wr.d[0]);
            }
        }
    }
    else if (offsetof(CPUMIPSState, active_fpu.fpr[0].wr.d[1]) <= offset && offset <= offsetof(CPUMIPSState, active_fpu.fpr[31].wr.d[1])) {
        for(int i = 0; i < 32; i++) {
            if(offset == offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1])) {
                return offsetof(CPUMIPSState, active_fpu.taint_fpr[i].wr.d[1]);
            }
        }
    }
    else if (offsetof(CPUMIPSState, active_tc.HI[0]) <= offset && offset <= offsetof(CPUMIPSState, active_tc.HI[3])) {
        for(int i = 0; i < 4; i++) {
            if(offset == offsetof(CPUMIPSState, active_tc.HI[i])) {
                return offsetof(CPUMIPSState, active_tc.taint_HI[i]);
            }
        }
    }
    else if (offsetof(CPUMIPSState, active_tc.LO[0]) <= offset && offset <= offsetof(CPUMIPSState, active_tc.LO[3])) {
        for(int i = 0; i < 4; i++) {
            if(offset == offsetof(CPUMIPSState, active_tc.LO[i])) {
                return offsetof(CPUMIPSState, active_tc.taint_LO[i]);
            }
        }
    }
    else if (offsetof(CPUMIPSState, active_tc.mxu_gpr[0]) <= offset && offset <= offsetof(CPUMIPSState, active_tc.mxu_gpr[14])) {
        for(int i = 0; i < 15; i++) {
            if(offset == offsetof(CPUMIPSState, active_tc.mxu_gpr[i])) {
                return offsetof(CPUMIPSState, active_tc.taint_mxu_gpr[i]);
            }
        }
    }
    else {
        switch (offset) {
            case offsetof(CPUMIPSState, active_tc.PC):
                return offsetof(CPUMIPSState, active_tc.taint_PC);
            case offsetof(CPUMIPSState, active_tc.DSPControl):
                return offsetof(CPUMIPSState, active_tc.taint_DSPControl);
            case offsetof(CPUMIPSState, bcond):
                return offsetof(CPUMIPSState, taint_bcond);
            case offsetof(CPUMIPSState, btarget):
                return offsetof(CPUMIPSState, taint_btarget);
            case offsetof(CPUMIPSState, hflags):
                return offsetof(CPUMIPSState, taint_hflags);
            case offsetof(CPUMIPSState, active_fpu.fcr0):
                return offsetof(CPUMIPSState, active_fpu.taint_fcr0);
            case offsetof(CPUMIPSState, active_fpu.fcr31):
                return offsetof(CPUMIPSState, active_fpu.taint_fcr31);
            case offsetof(CPUMIPSState, lladdr):
                return offsetof(CPUMIPSState, taint_lladdr);
            case offsetof(CPUMIPSState, llval):
                return offsetof(CPUMIPSState, taint_llval);
            case offsetof(CPUMIPSState, active_tc.mxu_cr):
                return offsetof(CPUMIPSState, active_tc.taint_mxu_cr);
            default:
                return offset;
        }    
    }
    return offset;
}
#endif


static inline int gen_taintcheck_insn(TCGOp *old_first_op)
{
    int tcg_insn_num = 0;
    int pos, len; /* constant parameters */
    unsigned vece;
    int offset, shadow_offset;
    TCGTemp *rt;
    TCGv shadow_arg;
    TCGv_i32 shadow_i32_arg[6];
    TCGv_i64 shadow_i64_arg[6];
    TCGv_vec shadow_vec_arg[3];
    // TCGv_vec shadow_vec_arg3, shadow_vec_arg4, shadow_vec_arg5;
    TCGv_i32 temp_i32_arg[5];
    TCGv_i64 temp_i64_arg[5];
    TCGv_i32 temp_i32_zero, temp_i32_oi;
    TCGv_i64 temp_i64_zero;
    TCGv_vec temp_vec_arg[4];
    TCGv_vec temp_vec_zeros, temp_vec_ones;
    TCGType type;
    TCGContext *s = tcg_ctx;
    QTAILQ_HEAD(, TCGOp) old_ops;
    QTAILQ_INIT(&old_ops);
    TCGOp *op_ptr, *temp_op;
    op_ptr = old_first_op;
    temp_op = QTAILQ_NEXT(op_ptr, link);


    /* remove new ops from tcg_ctx->ops, and join ops to old_ops(QTAILQ) */
    do {
        QTAILQ_REMOVE(&s->ops, op_ptr, link);
        QTAILQ_INSERT_TAIL(&old_ops, op_ptr, link);
        op_ptr = temp_op;
        if (op_ptr == NULL)
        {
            break;
        }
        temp_op = QTAILQ_NEXT(op_ptr, link);
    } while (op_ptr != NULL);

    // clean_shadow_arg();
    op_ptr = QTAILQ_FIRST(&old_ops);
    temp_op = QTAILQ_NEXT(op_ptr, link);
    do
    {
#if 0
        printf("%p\t%x\t%lx\t%lx\t%lx\n", op_ptr, op_ptr->opc, op_ptr->args[0],op_ptr->args[1],op_ptr->args[2]);
#endif
        tcg_insn_num++;
        switch (op_ptr->opc)
        {
        /* predefined ops */
        case INDEX_op_discard: /* DONE */ /* bitwise */
            shadow_arg = find_shadow_arg(op_ptr->args[0]);
            tcg_gen_discard_tl(shadow_arg);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_set_label: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* variable number of parameters */
        case INDEX_op_call: /* DONE */
            for(int i = 0; i < TCGOP_CALLO(op_ptr); i++) {
                if(op_ptr->args[i] == tcgv_to_arg_ptr(cpu_env))
                    continue;
                shadow_i32_arg[i] = (TCGv_i32)find_shadow_arg(op_ptr->args[i]);
                rt = tcgv_i32_temp(shadow_i32_arg[i]);
                if(rt->type == TCG_TYPE_I32) {
                    tcg_gen_movi_i32(shadow_i32_arg[i], 0);
                }
                else if(rt->type == TCG_TYPE_I64) {
                    tcg_gen_movi_i64((TCGv_i64)shadow_i32_arg[i], 0);
                }
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_br:   /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mb: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mov_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_setcond_i32: /* DONE */ /* bytewise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[1] && shadow_i32_arg[2])
            {
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            }
            else if (shadow_i32_arg[1])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[1]);
            }
            else if (shadow_i32_arg[2])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            }
            else
            {
                tcg_gen_mov_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* determine if there is any taint */
            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_arg[0], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_movcond_i32: /* DONE */ /* bitwise */
            /*  rules
                if C1 | C2 != 0, T0 = -1(0xFFFFFFFF)
                if C1 | C2 == 0, T0 = C1 cond C2 ? T1 : T2
                T0 = ((C1 | C2) != 0 ? -1 : 0) | (C1 cond C2 ? T1 : T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* C1 */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* C2 */
            shadow_i32_arg[3] = (TCGv_i32)find_shadow_arg(op_ptr->args[3]); /* V1 */
            shadow_i32_arg[4] = (TCGv_i32)find_shadow_arg(op_ptr->args[4]); /* V2 */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_zero, 0);

            /* determine if there is any taint in C1 and C2 */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
            {
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_arg[0], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[0], temp_i32_arg[1]); /* temp_i32_arg[0] = ((C1 | C2) != 0 ? -1 : 0) */
            }

            /* (C1 cond C2 ? T1 : T2) */
            tcg_gen_movcond_i32(op_ptr->args[5], temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1]), arg_i32_tcgv(op_ptr->args[2]), shadow_i32_arg[3], shadow_i32_arg[4]);

            /* T0 = ((C1 | C2) != 0 ? -1 : 0) | (C1 cond C2 ? T1 : T2) */
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* load/store */
        case INDEX_op_ld8u_i32:  /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            else {
                tcg_gen_ld8u_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld8s_i32:  /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            else {
                tcg_gen_ld8s_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld16u_i32: /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            else {
                tcg_gen_ld16u_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld16s_i32: /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            else {
                tcg_gen_ld16s_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld_i32:    /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            // tcg_gen_ld_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), offset);
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            else {
                tcg_gen_ld_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st8_i32:   /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st8_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st16_i32:  /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st16_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st_i32:    /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st_i32(shadow_i32_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* arith */
        case INDEX_op_add_i32: /* DONE */ /* bitwise */ /* FIXME */
            /*
                T -> Taint
                V -> Value
                T0 = (T1 | T2) | ((V1_min + V2_min) ^ (V1_max + V2_max))
                V1_min = V1 & (~T1)
                V2_min = V2 & (~T2)
                V1_max = V1 | T1
                V2_max = V2 | T2
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            /* declared the new temporary variables that we need */
            temp_i32_arg[0] = tcg_temp_new_i32(); /* scratch */
            temp_i32_arg[1] = tcg_temp_new_i32(); /* V1_min */
            temp_i32_arg[2] = tcg_temp_new_i32(); /* V2_min */
            temp_i32_arg[3] = tcg_temp_new_i32(); /* V1_max */
            temp_i32_arg[4] = tcg_temp_new_i32(); /* V2_max */

            /* the logic:
                T1 = shadow_i32_arg[1]
                T2 = shadow_i32_arg[2]
                V1 = op_ptr->args[1]
                V2 = op_ptr->args[2]
            */

            /* calculate V1_min = V1 & (not T1) */
            tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]);                              /* not T1 */
            tcg_gen_and_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1]), temp_i32_arg[0]); /* V1_min = V1 & (not T1) */

            /* calculate V2_min = V2 & (not T2) */
            tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[2]);                              /* not T2 */
            tcg_gen_and_i32(temp_i32_arg[2], arg_i32_tcgv(op_ptr->args[2]), temp_i32_arg[0]); /* V2_min = V2 & (not T2) */

            /* calculate V1_max = V1 | T1 and V2_max = V2 | T2 */
            tcg_gen_or_i32(temp_i32_arg[3], arg_i32_tcgv(op_ptr->args[1]), shadow_i32_arg[1]); /* V1_max = V1 | T1 */
            tcg_gen_or_i32(temp_i32_arg[4], arg_i32_tcgv(op_ptr->args[2]), shadow_i32_arg[2]); /* V2_max = V2 | T2 */

            /* now that we have the mins and maxes, we need to sum them */
            tcg_gen_add_i32(temp_i32_arg[0], temp_i32_arg[3], temp_i32_arg[4]); /* V1_max + V2_max */
            tcg_gen_add_i32(temp_i32_arg[3], temp_i32_arg[1], temp_i32_arg[2]); /* V1_min + V2_min */

            /* ((V1_min + V2_min) ^ (V1_max + V2_max)) */
            tcg_gen_xor_i32(temp_i32_arg[1], temp_i32_arg[0], temp_i32_arg[3]);

            /* T1 | T2 */
            tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);

            /*  T0 = (T1 | T2) | ((V1_min + V2_min) ^ (V1_max + V2_max)) */
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sub_i32: /* DONE */ /* bitwise */ /* FIXME */
            /*
                T0 = (T1 | T2) | ((V1_min - V2_max) ^ (V1_max - V2_min))
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            /* declared the new temporary variables that we need */
            temp_i32_arg[0] = tcg_temp_new_i32(); /* scratch */
            temp_i32_arg[1] = tcg_temp_new_i32(); /* V1_min */
            temp_i32_arg[2] = tcg_temp_new_i32(); /* V2_min */
            temp_i32_arg[3] = tcg_temp_new_i32(); /* V1_max */
            temp_i32_arg[4] = tcg_temp_new_i32(); /* V2_max */

            /* the logic:
                T1 = shadow_i32_arg[1]
                T2 = shadow_i32_arg[2]
                V1 = op_ptr->args[1]
                V2 = op_ptr->args[2]
            */

            /* calculate V1_min = V1 & (not T1) */
            tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]);                              /* not T1 */
            tcg_gen_and_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1]), temp_i32_arg[0]); /* V1_min = V1 & (not T1) */

            /* calculate V2_min = V2 & (not T2) */
            tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[2]);                              /* not T2 */
            tcg_gen_and_i32(temp_i32_arg[2], arg_i32_tcgv(op_ptr->args[2]), temp_i32_arg[0]); /* V2_min = V2 & (not T2) */

            /* calculate V1_max = V1 | T1 and V2_max = V2 | T2 */
            tcg_gen_or_i32(temp_i32_arg[3], arg_i32_tcgv(op_ptr->args[1]), shadow_i32_arg[1]); /* V1_max = V1 | T1 */
            tcg_gen_or_i32(temp_i32_arg[4], arg_i32_tcgv(op_ptr->args[2]), shadow_i32_arg[2]); /* V2_max = V2 | T2 */

            /* now that we have the mins and maxes, we need to sum them */
            tcg_gen_sub_i32(temp_i32_arg[0], temp_i32_arg[1], temp_i32_arg[4]); /* V1_min - V2_max */
            tcg_gen_sub_i32(temp_i32_arg[4], temp_i32_arg[3], temp_i32_arg[2]); /* V1_max - V2_min */

            /* ((V1_min - V2_max) ^ (V1_max - V2_min)) */
            tcg_gen_xor_i32(temp_i32_arg[1], temp_i32_arg[0], temp_i32_arg[4]);

            /* T1 | T2 */
            tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);

            /* T0 = (T1 | T2) | ((V1_min - V2_max) ^ (V1_max - V2_min)) */
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mul_i32: /* DONE */ /* bytewise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            if (!shadow_i32_arg[1] && !shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();

            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            else if (shadow_i32_arg[1])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[1]);
            else if (shadow_i32_arg[2])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);

            tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_div_i32: /* DONE */  /* bytewise */
        case INDEX_op_divu_i32: /* DONE */ /* bytewise */
        case INDEX_op_rem_i32: /* DONE */  /* bytewise */
        case INDEX_op_remu_i32: /* DONE */ /* bytewise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[1] && shadow_i32_arg[2])
            {
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            }
            else if (shadow_i32_arg[1])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[1]);
            }
            else if (shadow_i32_arg[2])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            }
            else
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_arg[0], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_div2_i32: /* DONE */  /* bytewise */
        case INDEX_op_divu2_i32: /* DONE */ /* bytewise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);
            shadow_i32_arg[3] = (TCGv_i32)find_shadow_arg(op_ptr->args[3]);
            shadow_i32_arg[4] = (TCGv_i32)find_shadow_arg(op_ptr->args[4]);

            /* No shadows for any inputs */
            if (!(shadow_i32_arg[2] || shadow_i32_arg[3] || shadow_i32_arg[4]))
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                tcg_gen_movi_i32(shadow_i32_arg[1], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* check for shadows on shadow_i32_arg[2] and shadow_i32_arg[3] */
            if (shadow_i32_arg[2] && shadow_i32_arg[3])
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[2], shadow_i32_arg[3]);
            else if (shadow_i32_arg[2])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            else if (shadow_i32_arg[3])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[3]);
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* check for shadow on arg4 */
            if (shadow_i32_arg[4])
                tcg_gen_or_i32(temp_i32_arg[1], temp_i32_arg[0], shadow_i32_arg[4]);
            else
                tcg_gen_mov_i32(temp_i32_arg[1], temp_i32_arg[0]);

            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], temp_i32_arg[1], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[0]);
            tcg_gen_neg_i32(shadow_i32_arg[1], temp_i32_arg[0]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_and_i32: /* DONE */ /* bitwise */
            /*  bitwise AND rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      AND 1      X       1
                1      X      AND 0      1       1
                1      X      AND 1      X       1
                ... otherwise, ResultingTaint = 0
                AND: ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();

            /*
                T1 -> shadow_i32_arg[1]
                V1 -> arg_i32_tcgv(op_ptr->args[1])
                T2 -> shadow_i32_arg[2]
                V2 -> arg_i32_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_i32_arg[1])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            if (shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1]), shadow_i32_arg[2]); /* V1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            tcg_gen_and_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & V2) */
            if (shadow_i32_arg[2])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            if (shadow_i32_arg[1])
                tcg_gen_and_i32(temp_i32_arg[1], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2])); /* T1 & V2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            tcg_gen_and_i32(temp_i32_arg[3], temp_i32_arg[0], temp_i32_arg[1]); /* (T1 & (~T2) & V2) */

            /* T1 & T2 */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_i32(temp_i32_arg[1], temp_i32_arg[2], temp_i32_arg[3]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_or_i32: /* DONE */ /* bitwise */
            /*  bitwise OR rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      OR  1      X       1
                1      X      OR  0      0       1
                1      X      OR  1      X       1
                ... otherwise, ResultingTaint = 0
                OR: ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();

            /*
                T1 -> shadow_i32_arg[1]
                V1 -> arg_i32_tcgv(op_ptr->args[1])
                T2 -> shadow_i32_arg[2]
                V2 -> arg_i32_tcgv(op_ptr->args[2])
            */
            if (shadow_i32_arg[1])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            tcg_gen_not_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[0], temp_i32_arg[2], shadow_i32_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            if (shadow_i32_arg[2])
                tcg_gen_not_i32(temp_i32_arg[1], shadow_i32_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], -1);
            tcg_gen_not_i32(temp_i32_arg[2], arg_i32_tcgv(op_ptr->args[2])); /* ~V2 */
            tcg_gen_and_i32(temp_i32_arg[3], temp_i32_arg[1], temp_i32_arg[2]);  /* (~T2) & (~V2) */
            if (shadow_i32_arg[1])
                tcg_gen_and_i32(temp_i32_arg[1], temp_i32_arg[3], shadow_i32_arg[1]); /* (~T2) & (~V2) & T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);

            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[2], shadow_i32_arg[1], shadow_i32_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_i32(temp_i32_arg[3], temp_i32_arg[0], temp_i32_arg[1]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[2], temp_i32_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_xor_i32: /* DONE */ /* bitwise */
            /*
                XOR: T0 = T1 | T2
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            /* Perform an OR an arg1 and arg2 to find taint */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_or_i32(shadow_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            else if (shadow_i32_arg[1])
                tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else if (shadow_i32_arg[2])
                tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[2]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* shifts/rotates */
        case INDEX_op_shl_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* insert taint IR */
            if (!shadow_i32_arg[1] && !shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i32_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_zero, shadow_i32_arg[2]);
                tcg_gen_neg_i32(temp_i32_arg[2], temp_i32_arg[1]);
            }
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            if (shadow_i32_arg[1])
            {
                /* perform the SHL on arg1 */
                tcg_gen_shl_i32(temp_i32_arg[0], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i32_arg[0]) and arg2 (temp_i32_arg[2]) */
                tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[2]);
            }
            else
                tcg_gen_mov_i32(shadow_i32_arg[0], temp_i32_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shr_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* insert taint IR */
            if (!shadow_i32_arg[1] && !shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i32_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_zero, shadow_i32_arg[2]);
                tcg_gen_neg_i32(temp_i32_arg[2], temp_i32_arg[1]);
            }
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            if (shadow_i32_arg[1])
            {
                /* perform the SHR on arg1 */
                tcg_gen_shr_i32(temp_i32_arg[0], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i32_arg[0]) and arg2 (temp_i32_arg[2]) */
                tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[2]);
            }
            else
                tcg_gen_mov_i32(shadow_i32_arg[0], temp_i32_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sar_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* insert taint IR */
            if (!shadow_i32_arg[1] && !shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i32_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_zero, shadow_i32_arg[2]);
                tcg_gen_neg_i32(temp_i32_arg[2], temp_i32_arg[1]);
            }
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            if (shadow_i32_arg[1])
            {
                /* perform the SAR on shadow_i32_arg[1] */
                tcg_gen_sar_i32(temp_i32_arg[0], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i32_arg[0]) and arg2 (temp_i32_arg[2]) */
                tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[2]);
            }
            else
                tcg_gen_mov_i32(shadow_i32_arg[0], temp_i32_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotl_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* insert taint IR */
            if (!shadow_i32_arg[1] && !shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i32_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_zero, shadow_i32_arg[2]);
                tcg_gen_neg_i32(temp_i32_arg[2], temp_i32_arg[1]);
            }
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            if (shadow_i32_arg[1])
            {
                /* perform the ROTL on shadow_i32_arg[1] */
                tcg_gen_rotl_i32(temp_i32_arg[0], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i32_arg[0]) and arg2 (temp_i32_arg[2]) */
                tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[2]);
            }
            else
                tcg_gen_mov_i32(shadow_i32_arg[0], temp_i32_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotr_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* insert taint IR */
            if (!shadow_i32_arg[1] && !shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i32_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_zero, shadow_i32_arg[2]);
                tcg_gen_neg_i32(temp_i32_arg[2], temp_i32_arg[1]);
            }
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            if (shadow_i32_arg[1])
            {
                /* perform the ROTR on shadow_i32_arg[1] */
                tcg_gen_rotr_i32(temp_i32_arg[0], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i32_arg[0]) and arg2 (temp_i32_arg[2]) */
                tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[2]);
            }
            else
                tcg_gen_mov_i32(shadow_i32_arg[0], temp_i32_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_deposit_i32: /* DONE */ /* bitwise ~ bytewise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            pos = op_ptr->args[3]; /* the position of the first bit, counting from the LSB */
            len = op_ptr->args[4]; /* the length of the bitfield */

            /* insert taint IR */
            /* handle general case */
            tcg_gen_deposit_i32(shadow_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2], pos, len);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extract_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);

            pos = op_ptr->args[2]; /* the position of the first bit, counting from the LSB */
            len = op_ptr->args[3]; /* the length of the bitfield */

            /* insert taint IR */
            tcg_gen_extract_i32(shadow_i32_arg[0], shadow_i32_arg[1], pos, len);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sextract_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);

            pos = op_ptr->args[2]; /* the position of the first bit, counting from the LSB */
            len = op_ptr->args[3]; /* the length of the bitfield */

            /* insert taint IR */
            tcg_gen_sextract_i32(shadow_i32_arg[0], shadow_i32_arg[1], pos, len);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extract2_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            pos = op_ptr->args[3]; /* the position of the first bit, counting from the LSB */

            /* insert taint IR */
            tcg_gen_extract2_i32(shadow_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2], pos);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_brcond_i32: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_add2_i32: /* DONE */ /* bytewise */
        case INDEX_op_sub2_i32: /* DONE */ /* bytewise */
            /*
                add2 and sub2
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]); /* output low */
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* output high */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* input1 low */
            shadow_i32_arg[3] = (TCGv_i32)find_shadow_arg(op_ptr->args[3]); /* input1 high */
            shadow_i32_arg[4] = (TCGv_i32)find_shadow_arg(op_ptr->args[4]); /* input2 low */
            shadow_i32_arg[5] = (TCGv_i32)find_shadow_arg(op_ptr->args[5]); /* input3 high */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (!(shadow_i32_arg[2] || shadow_i32_arg[3] || shadow_i32_arg[4] || shadow_i32_arg[5]))
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                tcg_gen_movi_i32(shadow_i32_arg[1], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* combine high/low taint of input 1 into temp_i32_arg[0] */
            if (shadow_i32_arg[2] && shadow_i32_arg[3])
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[2], shadow_i32_arg[3]);
            else if (shadow_i32_arg[2])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            else if (shadow_i32_arg[3])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[3]);
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* combine high/low taint of input 2 into temp_i32_arg[1] */
            if (shadow_i32_arg[4] && shadow_i32_arg[5])
                tcg_gen_or_i32(temp_i32_arg[1], shadow_i32_arg[4], shadow_i32_arg[5]);
            else if (shadow_i32_arg[4])
                tcg_gen_mov_i32(temp_i32_arg[1], shadow_i32_arg[4]);
            else if (shadow_i32_arg[5])
                tcg_gen_mov_i32(temp_i32_arg[1], shadow_i32_arg[5]);
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);

            /* determine if there is any taint */
            tcg_gen_or_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]);
            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], temp_i32_arg[2], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[0]);
            tcg_gen_neg_i32(shadow_i32_arg[1], temp_i32_arg[0]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mulu2_i32: /* DONE */ /* bytewise */
        case INDEX_op_muls2_i32: /* DONE */ /* bytewise */
            /*
                mulu2 and muls2
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]); /* output low */
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* output high */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* input1 */
            shadow_i32_arg[3] = (TCGv_i32)find_shadow_arg(op_ptr->args[3]); /* input2 */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[2] && shadow_i32_arg[3])
            {
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[2], shadow_i32_arg[3]);
            }
            else if (shadow_i32_arg[2])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            }
            else if (shadow_i32_arg[3])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[3]);
            }
            else
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                tcg_gen_movi_i32(shadow_i32_arg[1], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* determine if there is any taint */
            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_arg[0], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[1]);
            tcg_gen_neg_i32(shadow_i32_arg[1], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_muluh_i32: /* DONE */ /* bytewise */
        case INDEX_op_mulsh_i32: /* DONE */ /* bytewise */
            /*
                muluh and mulsh
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* input2 */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[1] && shadow_i32_arg[2])
            {
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            }
            else if (shadow_i32_arg[1])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[1]);
            }
            else if (shadow_i32_arg[2])
            {
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            }
            else
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* determine if there is any taint */
            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_arg[0], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_brcond2_i32: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_setcond2_i32: /* DONE */                            /* bytewise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* input1 low */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* input1 high */
            shadow_i32_arg[3] = (TCGv_i32)find_shadow_arg(op_ptr->args[3]); /* input2 low */
            shadow_i32_arg[4] = (TCGv_i32)find_shadow_arg(op_ptr->args[4]); /* input3 high */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            /* insert taint IR */
            /* combine high/low taint of input 1 into temp_i32_arg[0] */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_or_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            else if (shadow_i32_arg[1])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[1]);
            else if (shadow_i32_arg[2])
                tcg_gen_mov_i32(temp_i32_arg[0], shadow_i32_arg[2]);
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* combine high/low taint of input 2 into temp_i32_arg[1] */
            if (shadow_i32_arg[3] && shadow_i32_arg[4])
                tcg_gen_or_i32(temp_i32_arg[1], shadow_i32_arg[3], shadow_i32_arg[4]);
            else if (shadow_i32_arg[3])
                tcg_gen_mov_i32(temp_i32_arg[1], shadow_i32_arg[3]);
            else if (shadow_i32_arg[4])
                tcg_gen_mov_i32(temp_i32_arg[1], shadow_i32_arg[4]);
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);

            /* determine if there is any taint */
            tcg_gen_or_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]);
            tcg_gen_movi_i32(temp_i32_zero, 0);
            tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], temp_i32_arg[2], temp_i32_zero);
            tcg_gen_neg_i32(shadow_i32_arg[0], temp_i32_arg[0]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext8s_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_ext8s_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext16s_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_ext16s_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext8u_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_ext8u_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext16u_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_ext16u_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_bswap16_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_bswap16_i32(shadow_i32_arg[0], shadow_i32_arg[1], op_ptr->args[2]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_bswap32_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_bswap32_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_not_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_neg_i32: /* DONE */ /* bitwise */ /* FIXME */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i32_arg[1])
                tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_andc_i32: /* DONE */ /* bitwise */
            /*  ANDC: V0 = V1 & ~V2
                bitwise ANDC rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      ANDC 1      X       1
                1      X      ANDC 0      0       1
                1      X      ANDC 1      X       1
                ... otherwise, ResultingTaint = 0
                AND: T0 = ((~T1) & V1 & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();

            /*
                T1 -> shadow_i32_arg[1]
                V1 -> arg_i32_tcgv(op_ptr->args[1])
                T2 -> shadow_i32_arg[2]
                V2 -> arg_i32_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_i32_arg[1])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            if (shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1]), shadow_i32_arg[2]); /* V1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            tcg_gen_and_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & (~V2)) */
            tcg_gen_not_i32(temp_i32_arg[3], arg_i32_tcgv(op_ptr->args[2])); /* ~V2 */
            if (shadow_i32_arg[2])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            if (shadow_i32_arg[1])
                tcg_gen_and_i32(temp_i32_arg[1], shadow_i32_arg[1], temp_i32_arg[3]); /* T1 & (~V2) */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            tcg_gen_and_i32(temp_i32_arg[3], temp_i32_arg[0], temp_i32_arg[1]); /* (T1 & (~T2) & (~V2)) */

            /* T1 & T2 */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_i32(temp_i32_arg[1], temp_i32_arg[2], temp_i32_arg[3]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_orc_i32: /* DONE */ /* bitwise */
            /*  ORC: V0 = V1 | ~V2
                bitwise ORC rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      OR  1      X       1
                1      X      OR  0      1       1
                1      X      OR  1      X       1
                ... otherwise, ResultingTaint = 0
                ORC: T0 = ((~T1) & (~V1) & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();

            /*
                T1 -> shadow_i32_arg[1]
                V1 -> arg_i32_tcgv(op_ptr->args[1])
                T2 -> shadow_i32_arg[2]
                V2 -> arg_i32_tcgv(op_ptr->args[2])
            */
            /* (~T1) & (~V1) & T2 */
            if (shadow_i32_arg[1])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            tcg_gen_not_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[0], temp_i32_arg[2], shadow_i32_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* (~T2) & V2 & T1 */
            if (shadow_i32_arg[2])
                tcg_gen_not_i32(temp_i32_arg[1], shadow_i32_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], -1);
            tcg_gen_and_i32(temp_i32_arg[3], temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[2])); /* (~T2) & V2 */
            if (shadow_i32_arg[1])
                tcg_gen_and_i32(temp_i32_arg[1], temp_i32_arg[3], shadow_i32_arg[1]); /* (~T2) & V2 & T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);

            /* T1 & T2 */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[2], shadow_i32_arg[1], shadow_i32_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_i32(temp_i32_arg[3], temp_i32_arg[0], temp_i32_arg[1]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[2], temp_i32_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_eqv_i32: /* DONE */ /* bitwise */
            /*
                EQV: VO = ~(V1 ^ V2)
                bitwise EQV rules:
                EQV: T0 = T1 | T2
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            /* perform an OR an arg1 and arg2 to find taint */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_or_i32(shadow_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]);
            else if (shadow_i32_arg[1])
                tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[1]);
            else if (shadow_i32_arg[2])
                tcg_gen_mov_i32(shadow_i32_arg[0], shadow_i32_arg[2]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_nand_i32: /* DONE */ /* bitwise */
            /*  NAND: V0 = ~(V1 & V2)
                bitwise NAND rules:(copy AND rules)
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      NAND 1      X       1
                1      X      NAND 0      1       1
                1      X      NAND 1      X       1
                ... otherwise, ResultingTaint = 0
                NAND: ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();

            /*
                T1 -> shadow_i32_arg[1]
                V1 -> arg_i32_tcgv(op_ptr->args[1])
                T2 -> shadow_i32_arg[2]
                V2 -> arg_i32_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_i32_arg[1])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            if (shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1]), shadow_i32_arg[2]); /* V1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            tcg_gen_and_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & V2) */
            if (shadow_i32_arg[2])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            if (shadow_i32_arg[1])
                tcg_gen_and_i32(temp_i32_arg[1], shadow_i32_arg[1], arg_i32_tcgv(op_ptr->args[2])); /* T1 & V2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            tcg_gen_and_i32(temp_i32_arg[3], temp_i32_arg[0], temp_i32_arg[1]); /* (T1 & (~T2) & V2) */

            /* T1 & T2 */
            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[0], shadow_i32_arg[1], shadow_i32_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_i32(temp_i32_arg[1], temp_i32_arg[2], temp_i32_arg[3]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_nor_i32: /* DONE */ /* bitwise */
            /*  NOR: V0 = ~(V1 | V2)
                bitwise NOR rules:(copy OR rules)
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      NOR  1      X       1
                1      X      NOR  0      0       1
                1      X      NOR  1      X       1
                ... otherwise, ResultingTaint = 0
                NOR: ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]);

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();

            /*
                T1 -> shadow_i32_arg[1]
                V1 -> arg_i32_tcgv(op_ptr->args[1])
                T2 -> shadow_i32_arg[2]
                V2 -> arg_i32_tcgv(op_ptr->args[2])
            */
            if (shadow_i32_arg[1])
                tcg_gen_not_i32(temp_i32_arg[0], shadow_i32_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], -1);
            tcg_gen_not_i32(temp_i32_arg[1], arg_i32_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_i32(temp_i32_arg[2], temp_i32_arg[0], temp_i32_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[0], temp_i32_arg[2], shadow_i32_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[0], 0);

            if (shadow_i32_arg[2])
                tcg_gen_not_i32(temp_i32_arg[1], shadow_i32_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], -1);
            tcg_gen_not_i32(temp_i32_arg[2], arg_i32_tcgv(op_ptr->args[2])); /* ~V2 */
            tcg_gen_and_i32(temp_i32_arg[3], temp_i32_arg[1], temp_i32_arg[2]);  /* (~T2) & (~V2) */
            if (shadow_i32_arg[1])
                tcg_gen_and_i32(temp_i32_arg[1], temp_i32_arg[3], shadow_i32_arg[1]); /* (~T2) & (~V2) & T1 */
            else
                tcg_gen_movi_i32(temp_i32_arg[1], 0);

            if (shadow_i32_arg[1] && shadow_i32_arg[2])
                tcg_gen_and_i32(temp_i32_arg[2], shadow_i32_arg[1], shadow_i32_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i32(temp_i32_arg[2], 0);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_i32(temp_i32_arg[3], temp_i32_arg[0], temp_i32_arg[1]);
            tcg_gen_or_i32(shadow_i32_arg[0], temp_i32_arg[2], temp_i32_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_clz_i32: /* DONE */ /* bitwise */
            /*
                CLZ: V0 = V1 ? CLZ(V1) : V2
                V2 is a constant, so we only need to focus on V1
                if V1 is not tainted, T0 = 0
                if V1 is tainted, then CLZ(V1) is tainted
                for example, if CLZ(V1) = 4(0x0...0|0100)
                then the tainted bits are 0x0...0|0111
                so we only want to taint the bits in result of CLZ(V1)
                taint rules:
                T1_mask = T1 ? -1 : 0
                tmp1 = V1 ? CLZ(V1) : V2
                tmp2 = tmp1 ? CLZ(tmp1) : V2
                mask = -1
                T0 = (mask >> tmp2) & T1_mask
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* arg1 */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* arg2 */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[1])
            {
                /* T1_mask = T1 ? -1 : 0  */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], shadow_i32_arg[1], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);

                /* tmp1 = V1 ? CLZ(V1) : V2 */
                /* tmp2 = tmp1 ? CLZ(tmp1) : V2 */
                tcg_gen_clz_i32(temp_i32_arg[0], arg_i32_tcgv(op_ptr->args[1]), arg_i32_tcgv(op_ptr->args[2]));
                tcg_gen_clz_i32(temp_i32_arg[2], temp_i32_arg[0], arg_i32_tcgv(op_ptr->args[2]));

                /* mask = -1 */
                tcg_gen_movi_i32(temp_i32_arg[3], -1);

                /* mask >> tmp2 */
                tcg_gen_shr_i32(temp_i32_arg[0], temp_i32_arg[3], temp_i32_arg[2]);

                /* T0 = (mask >> tmp2) & T1_mask */
                tcg_gen_and_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);
            }
            else
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ctz_i32: /* DONE */ /* bitwise */
            /*
                CLZ: V0 = V1 ? CTZ(V1) : V2
                V2 is a constant, so we only need to focus on V1
                if V1 is not tainted, T0 = 0
                if V1 is tainted, then CTZ(V1) is tainted
                for example, if CTZ(V1) = 4(0x0...0|0100)
                then the tainted bits are 0x0...0|0111
                so we only want to taint the bits in result of CTZ(V1)
                taint rules:
                T1_mask = T1 ? -1 : 0
                tmp1 = V1 ? CTZ(V1) : V2
                tmp2 = tmp1 ? CLZ(tmp1) : V2
                mask = -1
                T0 = (mask >> tmp2) & T1_mask
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* arg1 */
            shadow_i32_arg[2] = (TCGv_i32)find_shadow_arg(op_ptr->args[2]); /* arg2 */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[1])
            {
                /* T1_mask = T1 ? -1 : 0  */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], shadow_i32_arg[1], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);

                /* tmp1 = V1 ? CTZ(V1) : V2 */
                /* tmp2 = tmp1 ? CLZ(tmp1) : V2 */
                tcg_gen_ctz_i32(temp_i32_arg[0], arg_i32_tcgv(op_ptr->args[1]), arg_i32_tcgv(op_ptr->args[2]));
                tcg_gen_clz_i32(temp_i32_arg[2], temp_i32_arg[0], arg_i32_tcgv(op_ptr->args[2]));

                /* mask = -1 */
                tcg_gen_movi_i32(temp_i32_arg[3], -1);

                /* mask >> tmp2 */
                tcg_gen_shr_i32(temp_i32_arg[0], temp_i32_arg[3], temp_i32_arg[2]);

                /* T0 = (mask >> tmp2) & T1_mask */
                tcg_gen_and_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[1]);
            }
            else
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ctpop_i32: /* DONE */ /* bitwise */
            /*
                V0 = the num of 1 bit in V1
                if V1 is not tainted, T0 = 0
                if V1 is tainted, but all of 1 bit in V1 are not tainted, T0 = 0
                if V1 is tainted, the num of 1 bit is tainted
                taint rules:
                T1_mask = V1 & T1 ? -1 : 0
                ctpop tmp1 V1
                tmp2 = tmp1 ? CLZ(tmp1) : 32
                mask = -1
                T0 = (mask >> tmp2) & T1_mask
            */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]); /* arg1 */

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_arg[2] = tcg_temp_new_i32();
            temp_i32_arg[3] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();

            if (shadow_i32_arg[1])
            {
                /* T1_mask = V1 & T1 ? -1 : 0 */
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_and_i32(temp_i32_arg[0], arg_i32_tcgv(op_ptr->args[1]), shadow_i32_arg[1]);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[1], temp_i32_arg[0], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[2], temp_i32_arg[1]);

                /* ctpop tmp1 V1 */
                /* tmp2 = tmp1 ? CLZ(tmp1) : V2 */
                tcg_gen_ctpop_i32(temp_i32_arg[0], arg_i32_tcgv(op_ptr->args[1]));
                tcg_gen_clzi_i32(temp_i32_arg[1], temp_i32_arg[0], 32);

                /* mask = -1 */
                tcg_gen_movi_i32(temp_i32_arg[3], -1);

                /* mask >> tmp2 */
                tcg_gen_shr_i32(temp_i32_arg[0], temp_i32_arg[3], temp_i32_arg[1]);

                /* T0 = (mask >> tmp2) & T1_mask */
                tcg_gen_and_i32(shadow_i32_arg[0], temp_i32_arg[0], temp_i32_arg[2]);
            }
            else
            {
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mov_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_setcond_i64: /* DONE */ /* bytewise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[1] && shadow_i64_arg[2])
            {
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
            }
            else if (shadow_i64_arg[1])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[1]);
            }
            else if (shadow_i64_arg[2])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);
            }
            else
            {
                tcg_gen_mov_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* determine if there is any taint */
            tcg_gen_movi_i64(temp_i64_zero, 0);
            tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_arg[0], temp_i64_zero);
            tcg_gen_neg_i64(shadow_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_movcond_i64: /* DONE */ /* bitwise */
            /*  taint rules
                if TC1 | TC2 != 0, T0 = -1(0xFFFFFFFF)
                if TC1 | TC2 == 0, T0 = C1 cond C2 ? T1 : T2
                T0 = ((TC1 | TC2) != 0 ? -1 : 0) | (C1 cond C2 ? T1 : T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* C1 */
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]); /* C2 */
            shadow_i64_arg[3] = (TCGv_i64)find_shadow_arg(op_ptr->args[3]); /* V1 */
            shadow_i64_arg[4] = (TCGv_i64)find_shadow_arg(op_ptr->args[4]); /* V2 */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();
            tcg_gen_movi_i64(temp_i64_zero, 0);
            /* determine if there is any taint in C1 and C2 */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
            {
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_arg[0], temp_i64_zero);
                tcg_gen_neg_i64(temp_i64_arg[0], temp_i64_arg[1]); /* temp_i64_arg[0] = ((TC1 | TC2) != 0 ? -1 : 0) */
            }

            /* (C1 cond C2 ? T1 : T2) */
            tcg_gen_movcond_i64(op_ptr->args[5], temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1]), arg_i64_tcgv(op_ptr->args[2]), shadow_i64_arg[3], shadow_i64_arg[4]);

            /* T0 = ((C1 | C2) != 0 ? -1 : 0) | (C1 cond C2 ? T1 : T2) */
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* load/store */
        case INDEX_op_ld8u_i64:  /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld8u_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld8s_i64:  /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld8s_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld16u_i64: /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld16u_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld16s_i64: /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld16s_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld32u_i64: /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld32u_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld32s_i64: /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld32s_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld_i64:    /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset == offset) {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            else {
                tcg_gen_ld_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st8_i64:   /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st8_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st16_i64:  /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st16_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st32_i64:  /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st32_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_st_i64:    /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            offset = op_ptr->args[2];
            shadow_offset = find_shadow_offset(offset);
            if (shadow_offset != offset) {
                tcg_gen_st_i64(shadow_i64_arg[0], arg_ptr_tcgv(op_ptr->args[1]), shadow_offset);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* arith */
        case INDEX_op_add_i64: /* DONE */ /* bitwise */ /* FIXME */
            /*
                T -> Taint
                V -> Value
                T0 = (T1 | T2) | ((V1_min + V2_min) ^ (V1_max + V2_max))
                V1_min = V1 & (not T1)
                V2_min = V2 & (not T2)
                V1_max = V1 | T1
                V2_max = V2 | T2
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            /* declared the new temporary variables that we need */
            temp_i64_arg[0] = tcg_temp_new_i64(); /* scratch */
            temp_i64_arg[1] = tcg_temp_new_i64(); /* V1_min */
            temp_i64_arg[2] = tcg_temp_new_i64(); /* V2_min */
            temp_i64_arg[3] = tcg_temp_new_i64(); /* V1_max */
            temp_i64_arg[4] = tcg_temp_new_i64(); /* V2_max */

            /* the logic:
                T1 = shadow_i64_arg[1]
                T2 = shadow_i64_arg[2]
                V1 = op_ptr->args[1]
                V2 = op_ptr->args[2]
            */

            /* calculate V1_min = V1 & (not T1) */
            tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]);                              /* not T1 */
            tcg_gen_and_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1]), temp_i64_arg[0]); /* V1_min = V1 & (not T1) */

            /* calculate V2_min = V2 & (not T2) */
            tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[2]);                              /* not T2 */
            tcg_gen_and_i64(temp_i64_arg[2], arg_i64_tcgv(op_ptr->args[2]), temp_i64_arg[0]); /* V2_min = V2 & (not T2) */

            /* calculate V1_max = V1 | T1 and V2_max = V2 | T2 */
            tcg_gen_or_i64(temp_i64_arg[3], arg_i64_tcgv(op_ptr->args[1]), shadow_i64_arg[1]); /* V1_max = V1 | T1 */
            tcg_gen_or_i64(temp_i64_arg[4], arg_i64_tcgv(op_ptr->args[2]), shadow_i64_arg[2]); /* V2_max = V2 | T2 */

            /* now that we have the mins and maxes, we need to sum them */
            tcg_gen_add_i64(temp_i64_arg[0], temp_i64_arg[3], temp_i64_arg[4]); /* V1_max + V2_max */
            tcg_gen_add_i64(temp_i64_arg[3], temp_i64_arg[1], temp_i64_arg[2]); /* V1_min + V2_min */

            /* ((V1_min + V2_min) ^ (V1_max + V2_max)) */
            tcg_gen_xor_i64(temp_i64_arg[1], temp_i64_arg[0], temp_i64_arg[3]);

            /* T1 | T2 */
            tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);

            /*  T0 = (T1 | T2) | ((V1_min + V2_min) ^ (V1_max + V2_max)) */
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sub_i64: /* DONE */ /* bitwise */ /* FIXME */
            /*
                T0 = (T1 | T2) | ((V1_min - V2_max) ^ (V1_max - V2_min))
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            /* declared the new temporary variables that we need */
            temp_i64_arg[0] = tcg_temp_new_i64(); /* scratch */
            temp_i64_arg[1] = tcg_temp_new_i64(); /* V1_min */
            temp_i64_arg[2] = tcg_temp_new_i64(); /* V2_min */
            temp_i64_arg[3] = tcg_temp_new_i64(); /* V1_max */
            temp_i64_arg[4] = tcg_temp_new_i64(); /* V2_max */

            /* the logic:
                T1 = shadow_i64_arg[1]
                T2 = shadow_i64_arg[2]
                V1 = op_ptr->args[1]
                V2 = op_ptr->args[2]
            */

            /* calculate V1_min = V1 & (not T1) */
            tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]);                              /* not T1 */
            tcg_gen_and_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1]), temp_i64_arg[0]); /* V1_min = V1 & (not T1) */

            /* calculate V2_min = V2 & (not T2) */
            tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[2]);                              /* not T2 */
            tcg_gen_and_i64(temp_i64_arg[2], arg_i64_tcgv(op_ptr->args[2]), temp_i64_arg[0]); /* V2_min = V2 & (not T2) */

            /* calculate V1_max = V1 | T1 and V2_max = V2 | T2 */
            tcg_gen_or_i64(temp_i64_arg[3], arg_i64_tcgv(op_ptr->args[1]), shadow_i64_arg[1]); /* V1_max = V1 | T1 */
            tcg_gen_or_i64(temp_i64_arg[4], arg_i64_tcgv(op_ptr->args[2]), shadow_i64_arg[2]); /* V2_max = V2 | T2 */

            /* now that we have the mins and maxes, we need to sum them */
            tcg_gen_sub_i64(temp_i64_arg[0], temp_i64_arg[1], temp_i64_arg[4]); /* V1_min - V2_max */
            tcg_gen_sub_i64(temp_i64_arg[4], temp_i64_arg[3], temp_i64_arg[2]); /* V1_max - V2_min */

            /* ((V1_min - V2_max) ^ (V1_max - V2_min)) */
            tcg_gen_xor_i64(temp_i64_arg[1], temp_i64_arg[0], temp_i64_arg[4]);

            /* T1 | T2 */
            tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);

            /* T0 = (T1 | T2) | ((V1_min - V2_max) ^ (V1_max - V2_min)) */
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mul_i64: /* DONE */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            if (!shadow_i64_arg[1] && !shadow_i64_arg[2])
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();

            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
            else if (shadow_i64_arg[1])
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[1]);
            else if (shadow_i64_arg[2])
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);

            tcg_gen_neg_i64(temp_i64_arg[1], temp_i64_arg[0]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_div_i64: /* DONE */  /* bytewise */
        case INDEX_op_divu_i64: /* DONE */ /* bytewise */
        case INDEX_op_rem_i64: /* DONE */  /* bytewise */
        case INDEX_op_remu_i64: /* DONE */ /* bytewise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[1] && shadow_i64_arg[2])
            {
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
            }
            else if (shadow_i64_arg[1])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[1]);
            }
            else if (shadow_i64_arg[2])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);
            }
            else
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }

            tcg_gen_movi_i64(temp_i64_zero, 0);
            tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_arg[0], temp_i64_zero);
            tcg_gen_neg_i64(shadow_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_div2_i64: /* DONE */  /* bytewise */
        case INDEX_op_divu2_i64: /* DONE */ /* bytewise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);
            shadow_i64_arg[3] = (TCGv_i64)find_shadow_arg(op_ptr->args[3]);
            shadow_i64_arg[4] = (TCGv_i64)find_shadow_arg(op_ptr->args[4]);

            /* No shadows for any inputs */
            if (!(shadow_i64_arg[2] || shadow_i64_arg[3] || shadow_i64_arg[4]))
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                tcg_gen_movi_i64(shadow_i64_arg[1], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            /* check for shadows on shadow_i64_arg[2] and shadow_i64_arg[3] */
            if (shadow_i64_arg[2] && shadow_i64_arg[3])
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[2], shadow_i64_arg[3]);
            else if (shadow_i64_arg[2])
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);
            else if (shadow_i64_arg[3])
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[3]);
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            /* check for shadow on arg4 */
            if (shadow_i64_arg[4])
                tcg_gen_or_i64(temp_i64_arg[1], temp_i64_arg[0], shadow_i64_arg[4]);
            else
                tcg_gen_mov_i64(temp_i64_arg[1], temp_i64_arg[0]);

            tcg_gen_movi_i64(temp_i64_zero, 0);
            tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[0], temp_i64_arg[1], temp_i64_zero);
            tcg_gen_neg_i64(shadow_i64_arg[0], temp_i64_arg[0]);
            tcg_gen_neg_i64(shadow_i64_arg[1], temp_i64_arg[0]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_and_i64: /* DONE */ /* bitwise */
            /*  bitwise AND rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      AND 1      X       1
                1      X      AND 0      1       1
                1      X      AND 1      X       1
                ... otherwise, ResultingTaint = 0
                AND: T0 = ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();

            /*
                T1 -> shadow_i64_arg[1]
                V1 -> arg_i64_tcgv(op_ptr->args[1])
                T2 -> shadow_i64_arg[2]
                V2 -> arg_i64_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_i64_arg[1])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            if (shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1]), shadow_i64_arg[2]); /* V1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);
            tcg_gen_and_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & V2) */
            if (shadow_i64_arg[2])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            if (shadow_i64_arg[1])
                tcg_gen_and_i64(temp_i64_arg[1], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2])); /* T1 & V2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);
            tcg_gen_and_i64(temp_i64_arg[3], temp_i64_arg[0], temp_i64_arg[1]); /* (T1 & (~T2) & V2) */

            /* T1 & T2 */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_i64(temp_i64_arg[1], temp_i64_arg[2], temp_i64_arg[3]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_or_i64: /* DONE */ /* bitwise */
            /*  bitwise OR rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      OR  1      X       1
                1      X      OR  0      0       1
                1      X      OR  1      X       1
                ... otherwise, ResultingTaint = 0
                OR: T0 = ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();

            /*
                T1 -> shadow_i64_arg[1]
                V1 -> arg_i64_tcgv(op_ptr->args[1])
                T2 -> shadow_i64_arg[2]
                V2 -> arg_i64_tcgv(op_ptr->args[2])
            */
            if (shadow_i64_arg[1])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            tcg_gen_not_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1])); /* ~T1 */
            tcg_gen_and_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[0], temp_i64_arg[2], shadow_i64_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            if (shadow_i64_arg[2])
                tcg_gen_not_i64(temp_i64_arg[1], shadow_i64_arg[2]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], -1);
            tcg_gen_not_i64(temp_i64_arg[2], arg_i64_tcgv(op_ptr->args[2])); /* ~V2 */
            tcg_gen_and_i64(temp_i64_arg[3], temp_i64_arg[1], temp_i64_arg[2]);  /* (~T2) & (~V2) */
            if (shadow_i64_arg[1])
                tcg_gen_and_i64(temp_i64_arg[1], temp_i64_arg[3], shadow_i64_arg[1]); /* (~T2) & (~V2) & T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);

            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[2], shadow_i64_arg[1], shadow_i64_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_i64(temp_i64_arg[3], temp_i64_arg[0], temp_i64_arg[1]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[2], temp_i64_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_xor_i64: /* DONE */ /* bitwise */
            /*
                XOR: T0 = T1 | T2
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            /* Perform an OR an arg1 and arg2 to find taint */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_or_i64(shadow_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
            else if (shadow_i64_arg[1])
                tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else if (shadow_i64_arg[2])
                tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[2]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* shifts/rotates */
        case INDEX_op_shl_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            /* insert taint IR */
            if (!shadow_i64_arg[1] && !shadow_i64_arg[2])
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i64_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_zero, shadow_i64_arg[2]);
                tcg_gen_neg_i64(temp_i64_arg[2], temp_i64_arg[1]);
            }
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            if (shadow_i64_arg[1])
            {
                /* perform the SHL on arg1 */
                tcg_gen_shl_i64(temp_i64_arg[0], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i64_arg[0]) and arg2 (temp_i64_arg[2]) */
                tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[2]);
            }
            else
                tcg_gen_mov_i64(shadow_i64_arg[0], temp_i64_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shr_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            /* insert taint IR */
            if (!shadow_i64_arg[1] && !shadow_i64_arg[2])
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i64_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_zero, shadow_i64_arg[2]);
                tcg_gen_neg_i64(temp_i64_arg[2], temp_i64_arg[1]);
            }
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            if (shadow_i64_arg[1])
            {
                /* perform the SHR on arg1 */
                tcg_gen_shr_i64(temp_i64_arg[0], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i64_arg[0]) and arg2 (temp_i64_arg[2]) */
                tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[2]);
            }
            else
                tcg_gen_mov_i64(shadow_i64_arg[0], temp_i64_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sar_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            /* insert taint IR */
            if (!shadow_i64_arg[1] && !shadow_i64_arg[2])
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i64_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_zero, shadow_i64_arg[2]);
                tcg_gen_neg_i64(temp_i64_arg[2], temp_i64_arg[1]);
            }
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            if (shadow_i64_arg[1])
            {
                /* perform the SAR on shadow_i64_arg[1] */
                tcg_gen_sar_i64(temp_i64_arg[0], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i64_arg[0]) and arg2 (temp_i64_arg[2]) */
                tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[2]);
            }
            else
                tcg_gen_mov_i64(shadow_i64_arg[0], temp_i64_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotl_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            /* insert taint IR */
            if (!shadow_i64_arg[1] && !shadow_i64_arg[2])
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i64_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_zero, shadow_i64_arg[2]);
                tcg_gen_neg_i64(temp_i64_arg[2], temp_i64_arg[1]);
            }
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            if (shadow_i64_arg[1])
            {
                /* perform the ROTL on shadow_i64_arg[1] */
                tcg_gen_rotl_i64(temp_i64_arg[0], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i64_arg[0]) and arg2 (temp_i64_arg[2]) */
                tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[2]);
            }
            else
                tcg_gen_mov_i64(shadow_i64_arg[0], temp_i64_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotr_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            /* insert taint IR */
            if (!shadow_i64_arg[1] && !shadow_i64_arg[2])
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            if (shadow_i64_arg[2])
            {
                /* check if the shift amount (arg2) is tainted. If so, the
                entire result will be tainted. */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_zero, shadow_i64_arg[2]);
                tcg_gen_neg_i64(temp_i64_arg[2], temp_i64_arg[1]);
            }
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            if (shadow_i64_arg[1])
            {
                /* perform the ROTR on shadow_i64_arg[1] */
                tcg_gen_rotr_i64(temp_i64_arg[0], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2]));
                /* or together the taint of shifted arg1 (temp_i64_arg[0]) and arg2 (temp_i64_arg[2]) */
                tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[2]);
            }
            else
                tcg_gen_mov_i64(shadow_i64_arg[0], temp_i64_arg[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_deposit_i64: /* DONE */ /* bitwise~bytewise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            pos = op_ptr->args[3]; /* the position of the first bit, counting from the LSB */
            len = op_ptr->args[4]; /* the length of the bitfield */

            /* insert taint IR */
            /* handle general case */
            tcg_gen_deposit_i64(shadow_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2], pos, len);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extract_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);

            pos = op_ptr->args[2]; /* the position of the first bit, counting from the LSB */
            len = op_ptr->args[3]; /* the length of the bitfield */

            /* insert taint IR */
            tcg_gen_extract_i64(shadow_i64_arg[0], shadow_i64_arg[1], pos, len);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sextract_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);

            pos = op_ptr->args[2]; /* the position of the first bit, counting from the LSB */
            len = op_ptr->args[3]; /* the length of the bitfield */

            /* insert taint IR */
            tcg_gen_sextract_i64(shadow_i64_arg[0], shadow_i64_arg[1], pos, len);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extract2_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            pos = op_ptr->args[3]; /* the position of the first bit, counting from the LSB */

            /* insert taint IR */
            tcg_gen_extract2_i64(shadow_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2], pos);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;

        /* size changing ops */
        case INDEX_op_ext_i32_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext_i32_i64(shadow_i64_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extu_i32_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = (TCGv_i32)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_extu_i32_i64(shadow_i64_arg[0], shadow_i32_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extrl_i64_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_extrl_i64_i32(shadow_i32_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_extrh_i64_i32: /* DONE */ /* bitwise */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_extrh_i64_i32(shadow_i32_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i32(shadow_i32_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_brcond_i64: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext8s_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext8s_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext16s_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext16s_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext32s_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext32s_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext8u_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext8u_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext16u_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext16u_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ext32u_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_ext32u_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_bswap16_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_bswap16_i64(shadow_i64_arg[0], shadow_i64_arg[1], op_ptr->args[2]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_bswap32_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_bswap32_i64(shadow_i64_arg[0], shadow_i64_arg[1], op_ptr->args[2]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_bswap64_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_bswap64_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_not_i64: /* DONE */ /* bitwise */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_neg_i64: /* DONE */ /* bitwise */ /* FIXME */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            if (shadow_i64_arg[1])
                tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_andc_i64: /* DONE */ /* bitwise */
            /*  ANDC: V0 = V1 & ~V2
                bitwise ANDC rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      ANDC 1      X       1
                1      X      ANDC 0      0       1
                1      X      ANDC 1      X       1
                ... otherwise, ResultingTaint = 0
                AND: T0 = ((~T1) & V1 & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();

            /*
                T1 -> shadow_i64_arg[1]
                V1 -> arg_i64_tcgv(op_ptr->args[1])
                T2 -> shadow_i64_arg[2]
                V2 -> arg_i64_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_i64_arg[1])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            if (shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1]), shadow_i64_arg[2]); /* V1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);
            tcg_gen_and_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & (~V2)) */
            tcg_gen_not_i64(temp_i64_arg[3], arg_i64_tcgv(op_ptr->args[2])); /* ~V2 */
            if (shadow_i64_arg[2])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            if (shadow_i64_arg[1])
                tcg_gen_and_i64(temp_i64_arg[1], shadow_i64_arg[1], temp_i64_arg[3]); /* T1 & (~V2) */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);
            tcg_gen_and_i64(temp_i64_arg[3], temp_i64_arg[0], temp_i64_arg[1]); /* (T1 & (~T2) & (~V2)) */

            /* T1 & T2 */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_i64(temp_i64_arg[1], temp_i64_arg[2], temp_i64_arg[3]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_orc_i64: /* DONE */ /* bitwise */
            /*  ORC: V0 = V1 | ~V2
                bitwise ORC rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      OR  1      X       1
                1      X      OR  0      1       1
                1      X      OR  1      X       1
                ... otherwise, ResultingTaint = 0
                ORC: T0 = ((~T1) & (~V1) & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();

            /*
                T1 -> shadow_i64_arg[1]
                V1 -> arg_i64_tcgv(op_ptr->args[1])
                T2 -> shadow_i64_arg[2]
                V2 -> arg_i64_tcgv(op_ptr->args[2])
            */
            /* (~T1) & (~V1) & T2 */
            if (shadow_i64_arg[1])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            tcg_gen_not_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[0], temp_i64_arg[2], shadow_i64_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            /* (~T2) & V2 & T1 */
            if (shadow_i64_arg[2])
                tcg_gen_not_i64(temp_i64_arg[1], shadow_i64_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], -1);
            tcg_gen_and_i64(temp_i64_arg[3], temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[2])); /* (~T2) & V2 */
            if (shadow_i64_arg[1])
                tcg_gen_and_i64(temp_i64_arg[1], temp_i64_arg[3], shadow_i64_arg[1]); /* (~T2) & V2 & T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);

            /* T1 & T2 */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[2], shadow_i64_arg[1], shadow_i64_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_i64(temp_i64_arg[3], temp_i64_arg[0], temp_i64_arg[1]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[2], temp_i64_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_eqv_i64: /* DONE */ /* bitwise */
            /*
                EQV: VO = ~(V1 ^ V2)
                bitwise EQV rules:
                EQV: T0 = T1 | T2
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            /* perform an OR an arg1 and arg2 to find taint */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_or_i64(shadow_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
            else if (shadow_i64_arg[1])
                tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[1]);
            else if (shadow_i64_arg[2])
                tcg_gen_mov_i64(shadow_i64_arg[0], shadow_i64_arg[2]);
            else
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_nand_i64: /* DONE */ /* bitwise */
            /*  NAND: V0 = ~(V1 & V2)
                bitwise NAND rules:(copy AND rules)
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      NAND 1      X       1
                1      X      NAND 0      1       1
                1      X      NAND 1      X       1
                ... otherwise, ResultingTaint = 0
                NAND: ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();

            /*
                T1 -> shadow_i64_arg[1]
                V1 -> arg_i64_tcgv(op_ptr->args[1])
                T2 -> shadow_i64_arg[2]
                V2 -> arg_i64_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_i64_arg[1])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            if (shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1]), shadow_i64_arg[2]); /* V1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);
            tcg_gen_and_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & V2) */
            if (shadow_i64_arg[2])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            if (shadow_i64_arg[1])
                tcg_gen_and_i64(temp_i64_arg[1], shadow_i64_arg[1], arg_i64_tcgv(op_ptr->args[2])); /* T1 & V2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);
            tcg_gen_and_i64(temp_i64_arg[3], temp_i64_arg[0], temp_i64_arg[1]); /* (T1 & (~T2) & V2) */

            /* T1 & T2 */
            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_i64(temp_i64_arg[1], temp_i64_arg[2], temp_i64_arg[3]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_nor_i64: /* DONE */ /* bitwise */
            /*  NOR: V0 = ~(V1 | V2)
                bitwise NOR rules:(copy OR rules)
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      NOR  1      X       1
                1      X      NOR  0      0       1
                1      X      NOR  1      X       1
                ... otherwise, ResultingTaint = 0
                NOR: ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]);
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]);

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();

            /*
                T1 -> shadow_i64_arg[1]
                V1 -> arg_i64_tcgv(op_ptr->args[1])
                T2 -> shadow_i64_arg[2]
                V2 -> arg_i64_tcgv(op_ptr->args[2])
            */
            if (shadow_i64_arg[1])
                tcg_gen_not_i64(temp_i64_arg[0], shadow_i64_arg[1]); /* ~T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], -1);
            tcg_gen_not_i64(temp_i64_arg[1], arg_i64_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[0], temp_i64_arg[2], shadow_i64_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            if (shadow_i64_arg[2])
                tcg_gen_not_i64(temp_i64_arg[1], shadow_i64_arg[2]); /* ~T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], -1);
            tcg_gen_not_i64(temp_i64_arg[2], arg_i64_tcgv(op_ptr->args[2])); /* ~V2 */
            tcg_gen_and_i64(temp_i64_arg[3], temp_i64_arg[1], temp_i64_arg[2]);  /* (~T2) & (~V2) */
            if (shadow_i64_arg[1])
                tcg_gen_and_i64(temp_i64_arg[1], temp_i64_arg[3], shadow_i64_arg[1]); /* (~T2) & (~V2) & T1 */
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);

            if (shadow_i64_arg[1] && shadow_i64_arg[2])
                tcg_gen_and_i64(temp_i64_arg[2], shadow_i64_arg[1], shadow_i64_arg[2]); /* T1 & T2 */
            else
                tcg_gen_movi_i64(temp_i64_arg[2], 0);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_i64(temp_i64_arg[3], temp_i64_arg[0], temp_i64_arg[1]);
            tcg_gen_or_i64(shadow_i64_arg[0], temp_i64_arg[2], temp_i64_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_clz_i64: /* DONE */ /* bitwise */
            /*
                CLZ: V0 = V1 ? CLZ(V1) : V2
                V2 is a constant, so we only need to focus on V1
                if V1 is not tainted, T0 = 0
                if V1 is tainted, then CLZ(V1) is tainted
                for example, if CLZ(V1) = 4(0x0...0|0100)
                then the tainted bits are 0x0...0|0111
                so we only want to taint the bits in result of CLZ(V1)
                taint rules:
                T1_mask = T1 ? -1 : 0
                tmp1 = V1 ? CLZ(V1) : V2
                tmp2 = tmp1 ? CLZ(tmp1) : V2
                mask = -1
                T0 = (mask >> tmp2) & T1_mask
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* arg1 */
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]); /* arg2 */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[1])
            {
                /* T1_mask = T1 ? -1 : 0  */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[0], shadow_i64_arg[1], temp_i64_zero);
                tcg_gen_neg_i64(temp_i64_arg[1], temp_i64_arg[0]);

                /* tmp1 = V1 ? CLZ(V1) : V2 */
                /* tmp2 = tmp1 ? CLZ(tmp1) : V2 */
                tcg_gen_clz_i64(temp_i64_arg[0], arg_i64_tcgv(op_ptr->args[1]), arg_i64_tcgv(op_ptr->args[2]));
                tcg_gen_clz_i64(temp_i64_arg[2], temp_i64_arg[0], arg_i64_tcgv(op_ptr->args[2]));

                /* mask = -1 */
                tcg_gen_movi_i64(temp_i64_arg[3], -1);

                /* mask >> tmp2 */
                tcg_gen_shr_i64(temp_i64_arg[0], temp_i64_arg[3], temp_i64_arg[2]);

                /* T0 = (mask >> tmp2) & T1_mask */
                tcg_gen_and_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);
            }
            else
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ctz_i64: /* DONE */ /* bitwise */
            /*
                CLZ: V0 = V1 ? CTZ(V1) : V2
                V2 is a constant, so we only need to focus on V1
                if V1 is not tainted, T0 = 0
                if V1 is tainted, then CTZ(V1) is tainted
                for example, if CTZ(V1) = 4(0x0...0|0100)
                then the tainted bits are 0x0...0|0111
                so we only want to taint the bits in result of CTZ(V1)
                taint rules:
                T1_mask = T1 ? -1 : 0
                tmp1 = V1 ? CTZ(V1) : V2
                tmp2 = tmp1 ? CLZ(tmp1) : V2
                mask = -1
                T0 = (mask >> tmp2) & T1_mask
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* arg1 */
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]); /* arg2 */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[1])
            {
                /* T1_mask = T1 ? -1 : 0  */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[0], shadow_i64_arg[1], temp_i64_zero);
                tcg_gen_neg_i64(temp_i64_arg[1], temp_i64_arg[0]);

                /* tmp1 = V1 ? CTZ(V1) : V2 */
                /* tmp2 = tmp1 ? CLZ(tmp1) : V2 */
                tcg_gen_ctz_i64(temp_i64_arg[0], arg_i64_tcgv(op_ptr->args[1]), arg_i64_tcgv(op_ptr->args[2]));
                tcg_gen_clz_i64(temp_i64_arg[2], temp_i64_arg[0], arg_i64_tcgv(op_ptr->args[2]));

                /* mask = -1 */
                tcg_gen_movi_i64(temp_i64_arg[3], -1);

                /* mask >> tmp2 */
                tcg_gen_shr_i64(temp_i64_arg[0], temp_i64_arg[3], temp_i64_arg[2]);

                /* T0 = (mask >> tmp2) & T1_mask */
                tcg_gen_and_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[1]);
            }
            else
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ctpop_i64: /* DONE */ /* bitwise */
            /*
                V0 = the num of 1 bit in V1
                if V1 is not tainted, T0 = 0
                if V1 is tainted, but all of 1 bit in V1 are not tainted, T0 = 0
                if V1 is tainted, the num of 1 bit is tainted
                taint rules:
                T1_mask = V1 & T1 ? -1 : 0
                ctpop tmp1 V1
                tmp2 = tmp1 ? CLZ(tmp1) : 64
                mask = -1
                T0 = (mask >> tmp2) & T1_mask
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* arg1 */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_arg[3] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[1])
            {
                /* T1_mask = V1 & T1 ? -1 : 0 */
                tcg_gen_movi_i64(temp_i64_zero, 0);
                tcg_gen_and_i64(temp_i64_arg[0], arg_i64_tcgv(op_ptr->args[1]), shadow_i64_arg[1]);
                tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_arg[0], temp_i64_zero);
                tcg_gen_neg_i64(temp_i64_arg[2], temp_i64_arg[1]);

                /* ctpop tmp1 V1 */
                /* tmp2 = tmp1 ? CLZ(tmp1) : 64 */
                tcg_gen_ctpop_i64(temp_i64_arg[0], arg_i64_tcgv(op_ptr->args[1]));
                tcg_gen_clzi_i64(temp_i64_arg[1], temp_i64_arg[0], 64);

                /* mask = -1 */
                tcg_gen_movi_i64(temp_i64_arg[3], -1);

                /* mask >> tmp2 */
                tcg_gen_shr_i64(temp_i64_arg[0], temp_i64_arg[3], temp_i64_arg[1]);

                /* T0 = (mask >> tmp2) & T1_mask */
                tcg_gen_and_i64(shadow_i64_arg[0], temp_i64_arg[0], temp_i64_arg[2]);
            }
            else
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
            }
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_add2_i64: /* DONE */ /* bytewise */
        case INDEX_op_sub2_i64: /* DONE */ /* bytewise */
            /*
                add2 and sub2
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]); /* output low */
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* output high */
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]); /* input1 low */
            shadow_i64_arg[3] = (TCGv_i64)find_shadow_arg(op_ptr->args[3]); /* input1 high */
            shadow_i64_arg[4] = (TCGv_i64)find_shadow_arg(op_ptr->args[4]); /* input2 low */
            shadow_i64_arg[5] = (TCGv_i64)find_shadow_arg(op_ptr->args[5]); /* input3 high */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_arg[2] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (!(shadow_i64_arg[2] || shadow_i64_arg[3] || shadow_i64_arg[4] || shadow_i64_arg[5]))
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                tcg_gen_movi_i64(shadow_i64_arg[1], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* combine high/low taint of input 1 into temp_i64_arg[0] */
            if (shadow_i64_arg[2] && shadow_i64_arg[3])
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[2], shadow_i64_arg[3]);
            else if (shadow_i64_arg[2])
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);
            else if (shadow_i64_arg[3])
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[3]);
            else
                tcg_gen_movi_i64(temp_i64_arg[0], 0);

            /* combine high/low taint of input 2 into temp_i64_arg[1] */
            if (shadow_i64_arg[4] && shadow_i64_arg[5])
                tcg_gen_or_i64(temp_i64_arg[1], shadow_i64_arg[4], shadow_i64_arg[5]);
            else if (shadow_i64_arg[4])
                tcg_gen_mov_i64(temp_i64_arg[1], shadow_i64_arg[4]);
            else if (shadow_i64_arg[5])
                tcg_gen_mov_i64(temp_i64_arg[1], shadow_i64_arg[5]);
            else
                tcg_gen_movi_i64(temp_i64_arg[1], 0);

            /* determine if there is any taint */
            tcg_gen_or_i64(temp_i64_arg[2], temp_i64_arg[0], temp_i64_arg[1]);
            tcg_gen_movi_i64(temp_i64_zero, 0);
            tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[0], temp_i64_arg[2], temp_i64_zero);
            tcg_gen_neg_i64(shadow_i64_arg[0], temp_i64_arg[0]);
            tcg_gen_neg_i64(shadow_i64_arg[1], temp_i64_arg[0]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mulu2_i64: /* DONE */ /* bytewise */
        case INDEX_op_muls2_i64: /* DONE */ /* bytewise */
            /*
                mulu2 and mulu2
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]); /* output low */
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* output high */
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]); /* input1 */
            shadow_i64_arg[3] = (TCGv_i64)find_shadow_arg(op_ptr->args[3]); /* input2 */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[2] && shadow_i64_arg[3])
            {
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[2], shadow_i64_arg[3]);
            }
            else if (shadow_i64_arg[2])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);
            }
            else if (shadow_i64_arg[3])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[3]);
            }
            else
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                tcg_gen_movi_i64(shadow_i64_arg[1], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* determine if there is any taint */
            tcg_gen_movi_i64(temp_i64_zero, 0);
            tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_arg[0], temp_i64_zero);
            tcg_gen_neg_i64(shadow_i64_arg[0], temp_i64_arg[1]);
            tcg_gen_neg_i64(shadow_i64_arg[1], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_muluh_i64: /* DONE */ /* bytewise */
        case INDEX_op_mulsh_i64: /* DONE */ /* bytewise */
            /*
                muluh and mulsh
            */
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_i64_arg[1] = (TCGv_i64)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_i64_arg[2] = (TCGv_i64)find_shadow_arg(op_ptr->args[2]); /* input2 */

            temp_i64_arg[0] = tcg_temp_new_i64();
            temp_i64_arg[1] = tcg_temp_new_i64();
            temp_i64_zero = tcg_temp_new_i64();

            if (shadow_i64_arg[1] && shadow_i64_arg[2])
            {
                tcg_gen_or_i64(temp_i64_arg[0], shadow_i64_arg[1], shadow_i64_arg[2]);
            }
            else if (shadow_i64_arg[1])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[1]);
            }
            else if (shadow_i64_arg[2])
            {
                tcg_gen_mov_i64(temp_i64_arg[0], shadow_i64_arg[2]);
            }
            else
            {
                tcg_gen_movi_i64(shadow_i64_arg[0], 0);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            /* determine if there is any taint */
            tcg_gen_movi_i64(temp_i64_zero, 0);
            tcg_gen_setcond_i64(TCG_COND_NE, temp_i64_arg[1], temp_i64_arg[0], temp_i64_zero);
            tcg_gen_neg_i64(shadow_i64_arg[0], temp_i64_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* QEMU specific */
        case INDEX_op_insn_start: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_exit_tb: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_goto_tb: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_goto_ptr: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_plugin_cb_start: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_plugin_cb_end: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_qemu_ld_i32:  /* DONE */            
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            gen_helper_taint_ld_mmu(cpu_env, arg_i32_tcgv(op_ptr->args[1]), temp_i32_oi);
            tcg_gen_mov_i32(shadow_i32_arg[0], (TCGv_i32)taint_temps);
            
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_qemu_st_i32:  /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            tcg_gen_st_i32(shadow_i32_arg[0], cpu_env, offsetof(CPUARCHState, taint_temps));
            gen_helper_taint_st_mmu(cpu_env, arg_i32_tcgv(op_ptr->args[1]), temp_i32_oi);
            
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_qemu_ld_i64:  /* DONE */
#if TARGET_LONG_BITS == 32
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            gen_helper_taint_ld_mmu(cpu_env, arg_i32_tcgv(op_ptr->args[1]), temp_i32_oi);
            tcg_gen_mov_i64(shadow_i64_arg[0], (TCGv_i64)taint_temps);
#else
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            gen_helper_taint_ld_mmu(cpu_env, arg_i64_tcgv(op_ptr->args[1]), temp_i32_oi);
            tcg_gen_mov_i64(shadow_i64_arg[0], (TCGv_i64)taint_temps);
#endif
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_qemu_st_i64:  /* DONE */           
#if TARGET_LONG_BITS == 32
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            tcg_gen_st_i64(shadow_i64_arg[0], cpu_env, offsetof(CPUARCHState, taint_temps));
            gen_helper_taint_st_mmu(cpu_env, arg_i32_tcgv(op_ptr->args[1]), temp_i32_oi);
#else
            shadow_i64_arg[0] = (TCGv_i64)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            tcg_gen_st_i64(shadow_i64_arg[0], cpu_env, offsetof(CPUARCHState, taint_temps));
            gen_helper_taint_st_mmu(cpu_env, arg_i64_tcgv(op_ptr->args[1]), temp_i32_oi); 
#endif
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_qemu_st8_i32: /* DONE */
            shadow_i32_arg[0] = (TCGv_i32)find_shadow_arg(op_ptr->args[0]);
            temp_i32_oi = tcg_temp_new_i32();
            tcg_gen_movi_i32(temp_i32_oi, op_ptr->args[2]);
            tcg_gen_st_i32(shadow_i32_arg[0], cpu_env, offsetof(CPUARCHState, taint_temps));
            gen_helper_taint_st_mmu(cpu_env, arg_i32_tcgv(op_ptr->args[1]), temp_i32_oi);
            
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        /* Host vector support.  */
        case INDEX_op_mov_vec: /* DONE */ /* bitwise */
            /*
                taint rules:
                T0 = T1
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_dup_vec: /* DONE */ /* bitwise */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = find_shadow_arg(op_ptr->args[1]);
            vece = TCGOP_VECE(op_ptr);

            tcg_gen_dup_tl_vec(vece, shadow_vec_arg[0], shadow_i32_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;

        case INDEX_op_dup2_vec: /* DONE */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_i32_arg[1] = find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = find_shadow_arg(op_ptr->args[2]);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            vec_gen_3(INDEX_op_dup2_vec, type, MO_64, tcgv_to_arg_vec(shadow_vec_arg[0]), tcgv_to_arg_i32(shadow_i32_arg[1]), tcgv_to_arg_i32(shadow_i32_arg[2]));

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ld_vec:   /* TODO */
        case INDEX_op_st_vec:   /* TODO */
        case INDEX_op_dupm_vec: /* TODO */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_add_vec: /* DONE */ /* bytewise */ /* FIXME */
            /*
                V0 = V1 + V2
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;

        case INDEX_op_sub_vec: /* DONE */ /* bytewise */ /* FIXME */
            /*
                V0 = V1 - V2
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_mul_vec: /* DONE */ /* bytewise */ /* FIXME */
            /*
                V0 = V1 * V2
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_neg_vec: /* DONE */ /* bitwise */
            /*
                V0 = -V1
                taint rules:
                T0 = T1
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_abs_vec: /* DONE */ /* bitwise */
            /*
                V0 = V1 < 0 ? -V1 : V1
                taint rules:
                T0 = T1
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ssadd_vec: /* DONE */ /* bytewise */ /* FIXME */
            /*
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_usadd_vec: /* DONE */ /* bytewise */ /* FIXME */
            /*
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sssub_vec: /* DONE */ /* bytewise */ /* FIXME */
            /*
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_ussub_vec: /* DONE */ /* bytewise */                /* FIXME */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_smin_vec: /* DONE */ /* bitwise */
            /*
                V0 = MIN(V1, V2) for signed element type
                need the result of op.
                if V0 = V1, T0 = T1
                if V0 = V2, T0 = T2
                taint rules:
                tmp = SMIN(V1, V2)
                tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0
                T0 = tmp2 & T1 | ~tmp2 & T2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                /* tmp = SMIN(V1, V2) */
                tcg_gen_smin_vec(vece, temp_vec_arg[0], arg_vec_tcgv(op_ptr->args[1]), arg_vec_tcgv(op_ptr->args[2]));

                /* tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0 */
                tcg_gen_cmp_vec(TCG_COND_EQ, vece, temp_vec_arg[1], temp_vec_arg[0], temp_vec_zeros);

                /* tmp2 & T1 */
                tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[1], shadow_vec_arg[1]);

                /* ~tmp2 & T2 */
                tcg_gen_not_vec(vece, temp_vec_arg[0], temp_vec_arg[1]);
                tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[0], shadow_vec_arg[2]);

                /* T0 = tmp2 & T1 | ~tmp2 & T2 */
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[2], temp_vec_arg[3]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_umin_vec: /* DONE */ /* bitwise */
            /*
                V0 = MIN(V1, V2) for unsigned element type
                need the result of op.
                if V0 = V1, T0 = T1
                if V0 = V2, T0 = T2
                taint rules:
                tmp = UMIN(V1, V2)
                tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0
                T0 = tmp2 & T1 | ~tmp2 & T2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                /* tmp = UMIN(V1, V2) */
                tcg_gen_umin_vec(vece, temp_vec_arg[0], arg_vec_tcgv(op_ptr->args[1]), arg_vec_tcgv(op_ptr->args[2]));

                /* tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0 */
                tcg_gen_cmp_vec(TCG_COND_EQ, vece, temp_vec_arg[1], temp_vec_arg[0], temp_vec_zeros);

                /* tmp2 & T1 */
                tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[1], shadow_vec_arg[1]);

                /* ~tmp2 & T2 */
                tcg_gen_not_vec(vece, temp_vec_arg[0], temp_vec_arg[1]);
                tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[0], shadow_vec_arg[2]);

                /* T0 = tmp2 & T1 | ~tmp2 & T2 */
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[2], temp_vec_arg[3]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_smax_vec: /* DONE */ /* bitwise */
            /*
                V0 = MAX(V1, V2) for signed element type
                need the result of op.
                if V0 = V1, T0 = T1
                if V0 = V2, T0 = T2
                taint rules:
                tmp = SMAX(V1, V2)
                tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0
                T0 = tmp2 & T1 | ~tmp2 & T2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                /* tmp = SMAX(V1, V2) */
                tcg_gen_smax_vec(vece, temp_vec_arg[0], arg_vec_tcgv(op_ptr->args[1]), arg_vec_tcgv(op_ptr->args[2]));

                /* tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0 */
                tcg_gen_cmp_vec(TCG_COND_EQ, vece, temp_vec_arg[1], temp_vec_arg[0], temp_vec_zeros);

                /* tmp2 & T1 */
                tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[1], shadow_vec_arg[1]);

                /* ~tmp2 & T2 */
                tcg_gen_not_vec(vece, temp_vec_arg[0], temp_vec_arg[1]);
                tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[0], shadow_vec_arg[2]);

                /* T0 = tmp2 & T1 | ~tmp2 & T2 */
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[2], temp_vec_arg[3]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_umax_vec: /* DONE */ /* bitwise */
            /*
                V0 = MAX(V1, V2) for unsigned element type
                need the result of op.
                if V0 = V1, T0 = T1
                if V0 = V2, T0 = T2
                taint rules:
                tmp = UMAX(V1, V2)
                tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0
                T0 = tmp2 & T1 | ~tmp2 & T2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                /* tmp = UMAX(V1, V2) */
                tcg_gen_umax_vec(vece, temp_vec_arg[0], arg_vec_tcgv(op_ptr->args[1]), arg_vec_tcgv(op_ptr->args[2]));

                /* tmp2 = tmp TCG_COND_EQ V1 ? -1 : 0 */
                tcg_gen_cmp_vec(TCG_COND_EQ, vece, temp_vec_arg[1], temp_vec_arg[0], temp_vec_zeros);

                /* tmp2 & T1 */
                tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[1], shadow_vec_arg[1]);

                /* ~tmp2 & T2 */
                tcg_gen_not_vec(vece, temp_vec_arg[0], temp_vec_arg[1]);
                tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[0], shadow_vec_arg[2]);

                /* T0 = tmp2 & T1 | ~tmp2 & T2 */
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[2], temp_vec_arg[3]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;

        case INDEX_op_and_vec: /* DONE */ /* bitwise */
            /*  bitwise AND rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      AND 1      X       1
                1      X      AND 0      1       1
                1      X      AND 1      X       1
                ... otherwise, ResultingTaint = 0
                AND: ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);
            temp_vec_ones = tcg_const_ones_vec_matching(shadow_vec_arg[0]);
            /*
                T1 -> shadow_vec_arg[1]
                V1 -> arg_vec_tcgv(op_ptr->args[1])
                T2 -> shadow_vec_arg[2]
                V2 -> arg_vec_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_vec_arg[1])
                tcg_gen_not_vec(vece, temp_vec_arg[0], shadow_vec_arg[1]); /* ~T1 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_ones);
            if (shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[1], arg_vec_tcgv(op_ptr->args[1]), shadow_vec_arg[2]); /* V1 & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_zeros);
            tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[0], temp_vec_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & V2) */
            if (shadow_vec_arg[2])
                tcg_gen_not_vec(vece, temp_vec_arg[0], shadow_vec_arg[2]); /* ~T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_ones);
            if (shadow_vec_arg[1])
                tcg_gen_and_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_vec_tcgv(op_ptr->args[2])); /* T1 & V2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_zeros);
            tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[0], temp_vec_arg[1]); /* (T1 & (~T2) & V2) */

            /* T1 & T2 */
            if (shadow_vec_arg[1] && shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]); /* T1 & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_vec(vece, temp_vec_arg[1], temp_vec_arg[2], temp_vec_arg[3]);
            tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_or_vec: /* DONE */ /* bitwise */
            /*  bitwise OR rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      OR  1      X       1
                1      X      OR  0      0       1
                1      X      OR  1      X       1
                ... otherwise, ResultingTaint = 0
                OR: ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);
            temp_vec_ones = tcg_const_ones_vec_matching(shadow_vec_arg[0]);

            /*
                T1 -> shadow_vec_arg[1]
                V1 -> arg_vec_tcgv(op_ptr->args[1])
                T2 -> shadow_vec_arg[2]
                V2 -> arg_vec_tcgv(op_ptr->args[2])
            */
            if (shadow_vec_arg[1])
                tcg_gen_not_vec(vece, temp_vec_arg[0], shadow_vec_arg[1]); /* ~T1 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_ones);
            tcg_gen_not_vec(vece, temp_vec_arg[1], arg_vec_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[0], temp_vec_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[0], temp_vec_arg[2], shadow_vec_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);

            if (shadow_vec_arg[2])
                tcg_gen_not_vec(vece, temp_vec_arg[1], shadow_vec_arg[2]); /* ~T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_ones);
            tcg_gen_not_vec(vece, temp_vec_arg[2], arg_vec_tcgv(op_ptr->args[2])); /* ~V2 */
            tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[1], temp_vec_arg[2]);  /* (~T2) & (~V2) */
            if (shadow_vec_arg[1])
                tcg_gen_and_vec(vece, temp_vec_arg[1], temp_vec_arg[3], shadow_vec_arg[1]); /* (~T2) & (~V2) & T1 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_zeros);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[2], shadow_vec_arg[1], shadow_vec_arg[2]); /* T1 & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[2], temp_vec_zeros);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_vec(vece, temp_vec_arg[3], temp_vec_arg[0], temp_vec_arg[1]);
            tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[2], temp_vec_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_xor_vec: /* DONE */ /* bitwise */
            /*
                XOR: T0 = T1 | T2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);

            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            /* Perform an OR an arg1 and arg2 to find taint */
            if (shadow_vec_arg[1] && shadow_vec_arg[2])
                tcg_gen_or_vec(vece, shadow_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            else if (shadow_vec_arg[1])
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            else if (shadow_vec_arg[2])
                tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[2]);
            else
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_andc_vec: /* DONE */ /* bitwise */
            /*  ANDC: V0 = V1 & ~V2
                bitwise ANDC rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      1      ANDC 1      X       1
                1      X      ANDC 0      0       1
                1      X      ANDC 1      X       1
                ... otherwise, ResultingTaint = 0
                AND: T0 = ((~T1) & V1 & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2)
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);
            temp_vec_ones = tcg_const_ones_vec_matching(shadow_vec_arg[0]);

            /*
                T1 -> shadow_vec_arg[1]
                V1 -> arg_vec_tcgv(op_ptr->args[1])
                T2 -> shadow_vec_arg[2]
                V2 -> arg_vec_tcgv(op_ptr->args[2])
            */

            /* (~T1) & V1 & T2 */
            if (shadow_vec_arg[1])
                tcg_gen_not_vec(vece, temp_vec_arg[0], shadow_vec_arg[1]); /* ~T1 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_ones);
            if (shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[1], arg_vec_tcgv(op_ptr->args[1]), shadow_vec_arg[2]); /* V1 & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_zeros);
            tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[0], temp_vec_arg[1]); /* (~T1) & V1 & T2 */

            /* (T1 & (~T2) & (~V2)) */
            tcg_gen_not_vec(vece, temp_vec_arg[3], arg_vec_tcgv(op_ptr->args[2])); /* ~V2 */
            if (shadow_vec_arg[2])
                tcg_gen_not_vec(vece, temp_vec_arg[0], shadow_vec_arg[2]); /* ~T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_ones);
            if (shadow_vec_arg[1])
                tcg_gen_and_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], temp_vec_arg[3]); /* T1 & (~V2) */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_zeros);
            tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[0], temp_vec_arg[1]); /* (T1 & (~T2) & (~V2)) */

            /* T1 & T2 */
            if (shadow_vec_arg[1] && shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]); /* T1 & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);

            /* ((~T1) & V1 & T2) | (T1 & (~T2) & (~V2)) | (T1 & T2) */
            tcg_gen_or_vec(vece, temp_vec_arg[1], temp_vec_arg[2], temp_vec_arg[3]);
            tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_orc_vec: /* DONE */ /* bitwise */
            /*  ORC: V0 = V1 | ~V2
                bitwise ORC rules:
                Taint1 Value1 Op  Taint2 Value2  ResultingTaint
                0      0      OR  1      X       1
                1      X      OR  0      1       1
                1      X      OR  1      X       1
                ... otherwise, ResultingTaint = 0
                ORC: T0 = ((~T1) & (~V1) & T2) | (T1 & (~T2) & V2) | (T1 & T2)
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_arg[2] = tcg_temp_new_vec(type);
            temp_vec_arg[3] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);
            temp_vec_ones = tcg_const_ones_vec_matching(shadow_vec_arg[0]);

            /*
                T1 -> shadow_vec_arg[1]
                V1 -> arg_vec_tcgv(op_ptr->args[1])
                T2 -> shadow_vec_arg[2]
                V2 -> arg_vec_tcgv(op_ptr->args[2])
            */

            /* (~T1) & (~V1) & T2 */
            if (shadow_vec_arg[1])
                tcg_gen_not_vec(vece, temp_vec_arg[0], shadow_vec_arg[1]); /* ~T1 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_ones);
            tcg_gen_not_vec(vece, temp_vec_arg[1], arg_vec_tcgv(op_ptr->args[1])); /* ~V1 */
            tcg_gen_and_vec(vece, temp_vec_arg[2], temp_vec_arg[0], temp_vec_arg[1]);  /* (~T1) & (~V1) */
            if (shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[0], temp_vec_arg[2], shadow_vec_arg[2]); /* (~T1) & (~V1) & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);

            /* (~T2) & V2 & T1 */
            if (shadow_vec_arg[2])
                tcg_gen_not_vec(vece, temp_vec_arg[1], shadow_vec_arg[2]); /* ~T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_ones);
            tcg_gen_and_vec(vece, temp_vec_arg[3], temp_vec_arg[1], arg_vec_tcgv(op_ptr->args[2])); /* (~T2) & V2 */
            if (shadow_vec_arg[1])
                tcg_gen_and_vec(vece, temp_vec_arg[1], temp_vec_arg[3], shadow_vec_arg[1]); /* (~T2) & V2 & T1 */
            else
                tcg_gen_mov_vec(temp_vec_arg[1], temp_vec_zeros);

            /* T1 & T2 */
            if (shadow_vec_arg[1] && shadow_vec_arg[2])
                tcg_gen_and_vec(vece, temp_vec_arg[2], shadow_vec_arg[1], shadow_vec_arg[2]); /* T1 & T2 */
            else
                tcg_gen_mov_vec(temp_vec_arg[2], temp_vec_zeros);

            /* ((~T1) & (~V1) & T2) | (T1 & (~T2) & V2) | (T1 & T2) */
            tcg_gen_or_vec(vece, temp_vec_arg[3], temp_vec_arg[0], temp_vec_arg[1]);
            tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[2], temp_vec_arg[3]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_not_vec: /* DONE */ /* bitwise */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            vece = TCGOP_VECE(op_ptr);
            tcg_gen_mov_vec(shadow_vec_arg[0], shadow_vec_arg[1]);
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shli_vec: /* DONE */ /* bitwise */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            vece = TCGOP_VECE(op_ptr);

            tcg_gen_shli_vec(vece, shadow_vec_arg[0], shadow_vec_arg[1], op_ptr->args[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;

        case INDEX_op_shri_vec: /* DONE */ /* bitwise */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            vece = TCGOP_VECE(op_ptr);

            tcg_gen_shri_vec(vece, shadow_vec_arg[0], shadow_vec_arg[1], op_ptr->args[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;

        case INDEX_op_sari_vec: /* DONE */ /* bitwise */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            vece = TCGOP_VECE(op_ptr);

            tcg_gen_sari_vec(vece, shadow_vec_arg[0], shadow_vec_arg[1], op_ptr->args[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotli_vec: /* DONE */ /* bitwise */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            vece = TCGOP_VECE(op_ptr);

            tcg_gen_rotli_vec(vece, shadow_vec_arg[0], shadow_vec_arg[1], op_ptr->args[2]);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shls_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = shls T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                shls tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();
            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);

            if (shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], shadow_i32_arg[2], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);
            }
            else
            {
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            }

            tcg_gen_dup_i32_vec(vece, temp_vec_arg[0], temp_i32_arg[1]);

            if (shadow_vec_arg[1])
            {
                tcg_gen_shls_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shrs_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = shrs T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                shrs tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();
            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);

            if (shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], shadow_i32_arg[2], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);
            }
            else
            {
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            }

            tcg_gen_dup_i32_vec(vece, temp_vec_arg[0], temp_i32_arg[1]);

            if (shadow_vec_arg[1])
            {
                tcg_gen_shrs_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sars_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = sars T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                sars tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();
            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);

            if (shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], shadow_i32_arg[2], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);
            }
            else
            {
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            }

            tcg_gen_dup_i32_vec(vece, temp_vec_arg[0], temp_i32_arg[1]);

            if (shadow_vec_arg[1])
            {
                tcg_gen_sars_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotls_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = rotls T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                rotls tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_i32_arg[2] = find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_i32_arg[0] = tcg_temp_new_i32();
            temp_i32_arg[1] = tcg_temp_new_i32();
            temp_i32_zero = tcg_temp_new_i32();
            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);

            if (shadow_i32_arg[2])
            {
                tcg_gen_movi_i32(temp_i32_zero, 0);
                tcg_gen_setcond_i32(TCG_COND_NE, temp_i32_arg[0], shadow_i32_arg[2], temp_i32_zero);
                tcg_gen_neg_i32(temp_i32_arg[1], temp_i32_arg[0]);
            }
            else
            {
                tcg_gen_movi_i32(temp_i32_arg[1], 0);
            }

            tcg_gen_dup_i32_vec(vece, temp_vec_arg[0], temp_i32_arg[1]);

            if (shadow_vec_arg[1])
            {
                tcg_gen_rotls_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_i32_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shlv_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = shlv T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                shlv tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[2])
            {
                tcg_gen_cmp_vec(TCG_COND_NE, vece, temp_vec_arg[0], shadow_vec_arg[2], temp_vec_zeros);
            }
            else
            {
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);
            }

            if (shadow_vec_arg[1])
            {
                tcg_gen_shlv_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_vec_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_shrv_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = shrv T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                shrv tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[2])
            {
                tcg_gen_cmp_vec(TCG_COND_NE, vece, temp_vec_arg[0], shadow_vec_arg[2], temp_vec_zeros);
            }
            else
            {
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);
            }

            if (shadow_vec_arg[1])
            {
                tcg_gen_shrv_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_vec_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_sarv_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = sarv T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                sarv tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[2])
            {
                tcg_gen_cmp_vec(TCG_COND_NE, vece, temp_vec_arg[0], shadow_vec_arg[2], temp_vec_zeros);
            }
            else
            {
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);
            }

            if (shadow_vec_arg[1])
            {
                tcg_gen_sarv_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_vec_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotlv_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = rotlv T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                rotlv tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[2])
            {
                tcg_gen_cmp_vec(TCG_COND_NE, vece, temp_vec_arg[0], shadow_vec_arg[2], temp_vec_zeros);
            }
            else
            {
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);
            }

            if (shadow_vec_arg[1])
            {
                tcg_gen_rotlv_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_vec_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_rotrv_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                if T2 != 0, T0 = -1
                if T2 == 0, T0 = rotrv T0 T1 V2
                taint rules:
                tmp1 = T2 ? -1 : 0
                rotrv tmp2 T1 V2
                T0 = tmp1 | tmp2
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]);
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]);
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]);
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_arg[1] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[2])
            {
                tcg_gen_cmp_vec(TCG_COND_NE, vece, temp_vec_arg[0], shadow_vec_arg[2], temp_vec_zeros);
            }
            else
            {
                tcg_gen_mov_vec(temp_vec_arg[0], temp_vec_zeros);
            }

            if (shadow_vec_arg[1])
            {
                tcg_gen_rotrv_vec(vece, temp_vec_arg[1], shadow_vec_arg[1], arg_vec_tcgv(op_ptr->args[2]));
                tcg_gen_or_vec(vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_arg[1]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_arg[0]);
            }

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_cmp_vec: /* DONE */ /* bitwise ~ bytewise */
            /*
                V0 = V1 cond V2 ? -1 : 0
                taint rules:
                T0 = T1 | T2 ? -1 : 0
            */
            shadow_vec_arg[0] = (TCGv_vec)find_shadow_arg(op_ptr->args[0]); /* output */
            shadow_vec_arg[1] = (TCGv_vec)find_shadow_arg(op_ptr->args[1]); /* input1 */
            shadow_vec_arg[2] = (TCGv_vec)find_shadow_arg(op_ptr->args[2]); /* input2 */
            vece = TCGOP_VECE(op_ptr);
            rt = arg_to_temp(op_ptr->args[0]);
            type = rt->base_type;

            temp_vec_arg[0] = tcg_temp_new_vec(type);
            temp_vec_zeros = tcg_const_zeros_vec_matching(shadow_vec_arg[0]);

            if (shadow_vec_arg[1] && shadow_vec_arg[2])
            {
                tcg_gen_or_vec(vece, temp_vec_arg[0], shadow_vec_arg[1], shadow_vec_arg[2]);
            }
            else if (shadow_vec_arg[1])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[1]);
            }
            else if (shadow_vec_arg[2])
            {
                tcg_gen_mov_vec(temp_vec_arg[0], shadow_vec_arg[2]);
            }
            else
            {
                tcg_gen_mov_vec(shadow_vec_arg[0], temp_vec_zeros);
                /* reinsert original opcode to tcg_ctx->ops */
                QTAILQ_REMOVE(&old_ops, op_ptr, link);
                QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
                op_ptr = temp_op;
                if (op_ptr == NULL)
                {
                    break;
                }
                temp_op = QTAILQ_NEXT(op_ptr, link);
                break;
            }

            tcg_gen_cmp_vec(TCG_COND_NE, vece, shadow_vec_arg[0], temp_vec_arg[0], temp_vec_zeros);

            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        case INDEX_op_bitsel_vec:   /* TODO */
        case INDEX_op_cmpsel_vec:   /* TODO */
        case INDEX_op_last_generic: /* DONE */
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        default:
            /* reinsert original opcode to tcg_ctx->ops */
            QTAILQ_REMOVE(&old_ops, op_ptr, link);
            QTAILQ_INSERT_TAIL(&s->ops, op_ptr, link);
            op_ptr = temp_op;
            if (op_ptr == NULL)
            {
                break;
            }
            temp_op = QTAILQ_NEXT(op_ptr, link);
            break;
        }
    } while (op_ptr != NULL);
    return tcg_insn_num;
}

void optimize_taint(TCGOp *old_first_op)
{
    gen_taintcheck_insn(old_first_op);
    // int tcg_insn_num = gen_taintcheck_insn(old_first_op);
    // printf("DEBUG: %d tcg insns are tainted\n", tcg_insn_num);
}