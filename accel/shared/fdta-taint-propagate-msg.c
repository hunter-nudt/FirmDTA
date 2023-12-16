#include "qemu/osdep.h"
#include "shared/fdta-types-common.h"
#include "shared/fdta-main.h"
#include "shared/fdta-main-internal.h"
#include "exec/exec-all.h"
#include "exec/cpu-all.h"
#include "exec/translate-all.h"
#include "exec/translator.h"
#include "qapi/qapi-types-machine.h"
#include "accel/tcg/tb-context.h"
#include "sysemu/runstate.h"
#include "sysemu/hw_accel.h"
#include "disas/disas.h"
#include "disas/capstone.h"
#include "disas/dis-asm.h"
#include "elf.h"
#include "tcg/tcg-internal.h"
#include "qemu/cutils.h"

#include "shared/fdta-callback-common.h"
#include "shared/fdta-callback-to-qemu.h"
#include "shared/fdta-target.h"
#include "shared/fdta-linux-vmi.h"
#include "shared/fdta-vmi-msg-warpper.h"
#include "shared/fdta-taint-propagate-msg.h"

static const char * const cond_name[] =
{
    [TCG_COND_NEVER] = "never",
    [TCG_COND_ALWAYS] = "always",
    [TCG_COND_EQ] = "eq",
    [TCG_COND_NE] = "ne",
    [TCG_COND_LT] = "lt",
    [TCG_COND_GE] = "ge",
    [TCG_COND_LE] = "le",
    [TCG_COND_GT] = "gt",
    [TCG_COND_LTU] = "ltu",
    [TCG_COND_GEU] = "geu",
    [TCG_COND_LEU] = "leu",
    [TCG_COND_GTU] = "gtu"
};

static const char * const ldst_name[] =
{
    [MO_UB]   = "ub",
    [MO_SB]   = "sb",
    [MO_LEUW] = "leuw",
    [MO_LESW] = "lesw",
    [MO_LEUL] = "leul",
    [MO_LESL] = "lesl",
    [MO_LEQ]  = "leq",
    [MO_BEUW] = "beuw",
    [MO_BESW] = "besw",
    [MO_BEUL] = "beul",
    [MO_BESL] = "besl",
    [MO_BEQ]  = "beq",
};

static const char * const alignment_name[(MO_AMASK >> MO_ASHIFT) + 1] = {
#ifdef TARGET_ALIGNED_ONLY
    [MO_UNALN >> MO_ASHIFT]    = "un+",
    [MO_ALIGN >> MO_ASHIFT]    = "",
#else
    [MO_UNALN >> MO_ASHIFT]    = "",
    [MO_ALIGN >> MO_ASHIFT]    = "al+",
#endif
    [MO_ALIGN_2 >> MO_ASHIFT]  = "al2+",
    [MO_ALIGN_4 >> MO_ASHIFT]  = "al4+",
    [MO_ALIGN_8 >> MO_ASHIFT]  = "al8+",
    [MO_ALIGN_16 >> MO_ASHIFT] = "al16+",
    [MO_ALIGN_32 >> MO_ASHIFT] = "al32+",
    [MO_ALIGN_64 >> MO_ASHIFT] = "al64+",
};

static const char bswap_flag_name[][6] = {
    [TCG_BSWAP_IZ] = "iz",
    [TCG_BSWAP_OZ] = "oz",
    [TCG_BSWAP_OS] = "os",
    [TCG_BSWAP_IZ | TCG_BSWAP_OZ] = "iz,oz",
    [TCG_BSWAP_IZ | TCG_BSWAP_OS] = "iz,os",
};

static char *tcg_get_arg_str_ptr(TCGContext *s, char *buf, int buf_size,
                                 TCGTemp *ts)
{
    int idx = temp_idx(ts);

    switch (ts->kind) {
    case TEMP_FIXED:
    case TEMP_GLOBAL:
        pstrcpy(buf, buf_size, ts->name);
        break;
    case TEMP_LOCAL:
        snprintf(buf, buf_size, "loc%d", idx - s->nb_globals);
        break;
    case TEMP_NORMAL:
        snprintf(buf, buf_size, "tmp%d", idx - s->nb_globals);
        break;
    case TEMP_CONST:
        switch (ts->type) {
        case TCG_TYPE_I32:
            snprintf(buf, buf_size, "$0x%x", (int32_t)ts->val);
            break;
#if TCG_TARGET_REG_BITS > 32
        case TCG_TYPE_I64:
            snprintf(buf, buf_size, "$0x%" PRIx64, ts->val);
            break;
#endif
        case TCG_TYPE_V64:
        case TCG_TYPE_V128:
        case TCG_TYPE_V256:
            snprintf(buf, buf_size, "v%d$0x%" PRIx64,
                     64 << (ts->type - TCG_TYPE_V64), ts->val);
            break;
        default:
            g_assert_not_reached();
        }
        break;
    }
    return buf;
}

static char *tcg_get_arg_str(TCGContext *s, char *buf,
                             int buf_size, TCGArg arg)
{
    return tcg_get_arg_str_ptr(s, buf, buf_size, arg_temp(arg));
}



void insn_msg(fdta_callback_params* params)
{
    CPUState *cs = params->ib.cs;
    uint32_t pc = params->ib.pc_first;
    uint32_t mips_opcode = params->ib.mips_opcode;
    
    char *proc_name;
    gpa_t current_pgd;
    uint32_t pid;
    modinfo_t *modinfo;
    proc_name = (char *)malloc(64);
    modinfo = (modinfo_t *)g_malloc0(sizeof(modinfo_t));

    current_pgd = fdta_get_pgd(cs);
    vmi_find_procname_pid_by_pgd(current_pgd, proc_name, 64, &pid);
    vmi_locate_module_by_pc(cs, pc, current_pgd, modinfo);

    FILE *log_fp;
    log_fp = fopen("/home/mypc/guest_log", "a");
    if(log_fp == NULL)
    {
        printf("open file fail\n");
        return;
    }

    fprintf(log_fp, "%d\t%08x\t%s\t%s\t%08x\t%x\t%x\t%x\n", 
            pid, 
            current_pgd, 
            proc_name, 
            modinfo->name, 
            modinfo->base, 
            modinfo->size, 
            pc, 
            mips_opcode);

    fclose(log_fp);
}

void guest_ins_asm(TranslationBlock *tb, CPUState *cs)
{
    target_ulong pc;
    target_ulong size;
    char *proc_name;
    gpa_t current_pgd;
    uint32_t pid;
    modinfo_t *modinfo;

    proc_name = (char *)malloc(64);
    modinfo = (modinfo_t *)g_malloc0(sizeof(modinfo_t));

    pc = tb->pc;
    size = tb->size;

    current_pgd = fdta_get_pgd(cs);
    vmi_find_procname_pid_by_pgd(current_pgd, proc_name, 64, &pid);
    vmi_locate_module_by_pc(cs, pc, current_pgd, modinfo);

    FILE *log_ins_fp;
    log_ins_fp = fopen("/home/mypc/guest_ins_log", "a");
    if(log_ins_fp == NULL)
    {
        printf("open guest_ins_log fail\n");
        return;
    }

    fprintf(log_ins_fp, "\n%ld\t%d\t%08x\t%s\t%s\t%08x\t%x\t%x\t%d\n", 
            ins_no,
            pid, 
            current_pgd, 
            proc_name, 
            modinfo->name, 
            modinfo->base, 
            modinfo->size, 
            pc, 
            size);

    target_disas(log_ins_fp, cs, pc, size);
    fclose(log_ins_fp);
}

void guest_ins_flow(TranslationBlock *tb, CPUState *cs)
{
    target_ulong pc;
    target_ulong size;
    char *proc_name;
    gpa_t current_pgd;
    uint32_t pid;
    modinfo_t *modinfo;

    proc_name = (char *)malloc(64);
    modinfo = (modinfo_t *)g_malloc0(sizeof(modinfo_t));

    pc = tb->pc;
    size = tb->size;

    current_pgd = fdta_get_pgd(cs);
    vmi_find_procname_pid_by_pgd(current_pgd, proc_name, 64, &pid);
    vmi_locate_module_by_pc(cs, pc, current_pgd, modinfo);

    FILE *log_ins_fp;
    log_ins_fp = fopen("/home/mypc/guest_ins_flow_log", "a");
    if(log_ins_fp == NULL)
    {
        printf("open guest_ins_flow_log fail\n");
        return;
    }

    fprintf(log_ins_fp, "\n%ld\t%d\t%08x\t%s\t%s\t%08x\t%x\t%x\t%d\n", 
            ins_no,
            pid, 
            current_pgd, 
            proc_name, 
            modinfo->name, 
            modinfo->base, 
            modinfo->size, 
            pc, 
            size);

    fclose(log_ins_fp);
}

void show_tcg_ops(TCGContext *s)
{
    char buf[128];
    TCGOp *op;

    FILE *log_tcg_fp;
    log_tcg_fp = fopen("/home/mypc/guest_tcg_log", "a");
    if(log_tcg_fp == NULL)
    {
        printf("open guest_tcg_log fail\n");
        return;
    }

    QTAILQ_FOREACH(op, &s->ops, link) {
        int i, k, nb_oargs, nb_iargs, nb_cargs;
        const TCGOpDef *def;
        TCGOpcode c;

        c = op->opc;
        def = &tcg_op_defs[c];

        if (c == INDEX_op_insn_start) {
            nb_oargs = 0;
            fprintf(log_tcg_fp, "\nPC ----");

            for (i = 0; i < TARGET_INSN_START_WORDS; ++i) {
                target_ulong a;
#if TARGET_LONG_BITS > TCG_TARGET_REG_BITS
                a = deposit64(op->args[i * 2], 32, 32, op->args[i * 2 + 1]);
#else
                a = op->args[i];
#endif
                fprintf(log_tcg_fp, " %08x", a);
            }
        } else if (c == INDEX_op_call) {
            const TCGHelperInfo *info = tcg_call_info(op);
            void *func = tcg_call_func(op);

            /* variable number of arguments */
            nb_oargs = TCGOP_CALLO(op);
            nb_iargs = TCGOP_CALLI(op);
            nb_cargs = def->nb_cargs;

            fprintf(log_tcg_fp, "%s ", def->name);

            /*
             * Print the function name from TCGHelperInfo, if available.
             * Note that plugins have a template function for the info,
             * but the actual function pointer comes from the plugin.
             */
            if (func == info->func) {
                fprintf(log_tcg_fp, "%s", info->name);
            } else {
                fprintf(log_tcg_fp, "plugin(%p)", func);
            }

            fprintf(log_tcg_fp, ",$0x%x,$%d", info->flags, nb_oargs);
            for (i = 0; i < nb_oargs; i++) {
                fprintf(log_tcg_fp, ",%s", tcg_get_arg_str(s, buf, sizeof(buf),
                                                       op->args[i]));
            }
            for (i = 0; i < nb_iargs; i++) {
                TCGArg arg = op->args[nb_oargs + i];
                const char *t = "<dummy>";
                if (arg != TCG_CALL_DUMMY_ARG) {
                    t = tcg_get_arg_str(s, buf, sizeof(buf), arg);
                }
                fprintf(log_tcg_fp, ",%s", t);
            }
        } else {
            fprintf(log_tcg_fp, "%s ", def->name);

            nb_oargs = def->nb_oargs;
            nb_iargs = def->nb_iargs;
            nb_cargs = def->nb_cargs;

            if (def->flags & TCG_OPF_VECTOR) {
                fprintf(log_tcg_fp, "v%d,e%d,", 64 << TCGOP_VECL(op),
                                8 << TCGOP_VECE(op));
            }

            k = 0;
            for (i = 0; i < nb_oargs; i++) {
                if (k != 0) {
                    fprintf(log_tcg_fp, ",");
                }
                fprintf(log_tcg_fp, "%s", tcg_get_arg_str(s, buf, sizeof(buf),
                                                      op->args[k++]));
            }
            for (i = 0; i < nb_iargs; i++) {
                if (k != 0) {
                    fprintf(log_tcg_fp, ",");
                }
                fprintf(log_tcg_fp, "%s", tcg_get_arg_str(s, buf, sizeof(buf),
                                                      op->args[k++]));
            }
            switch (c) {
            case INDEX_op_brcond_i32:
            case INDEX_op_setcond_i32:
            case INDEX_op_movcond_i32:
            case INDEX_op_brcond2_i32:
            case INDEX_op_setcond2_i32:
            case INDEX_op_brcond_i64:
            case INDEX_op_setcond_i64:
            case INDEX_op_movcond_i64:
            case INDEX_op_cmp_vec:
            case INDEX_op_cmpsel_vec:
                if (op->args[k] < ARRAY_SIZE(cond_name)
                    && cond_name[op->args[k]]) {
                    fprintf(log_tcg_fp, ",%s", cond_name[op->args[k++]]);
                } else {
                    fprintf(log_tcg_fp, ",$0x%" TCG_PRIlx, op->args[k++]);
                }
                i = 1;
                break;
            case INDEX_op_qemu_ld_i32:
            case INDEX_op_qemu_st_i32:
            case INDEX_op_qemu_st8_i32:
            case INDEX_op_qemu_ld_i64:
            case INDEX_op_qemu_st_i64:
                {
                    MemOpIdx oi = op->args[k++];
                    MemOp op = get_memop(oi);
                    unsigned ix = get_mmuidx(oi);

                    if (op & ~(MO_AMASK | MO_BSWAP | MO_SSIZE)) {
                        fprintf(log_tcg_fp, ",$0x%x,%u", op, ix);
                    } else {
                        const char *s_al, *s_op;
                        s_al = alignment_name[(op & MO_AMASK) >> MO_ASHIFT];
                        s_op = ldst_name[op & (MO_BSWAP | MO_SSIZE)];
                        fprintf(log_tcg_fp, ",%s%s,%u", s_al, s_op, ix);
                    }
                    i = 1;
                }
                break;
            case INDEX_op_bswap16_i32:
            case INDEX_op_bswap16_i64:
            case INDEX_op_bswap32_i32:
            case INDEX_op_bswap32_i64:
            case INDEX_op_bswap64_i64:
                {
                    TCGArg flags = op->args[k];
                    const char *name = NULL;

                    if (flags < ARRAY_SIZE(bswap_flag_name)) {
                        name = bswap_flag_name[flags];
                    }
                    if (name) {
                        fprintf(log_tcg_fp, ",%s", name);
                    } else {
                        fprintf(log_tcg_fp, ",$0x%" TCG_PRIlx, flags);
                    }
                    i = k = 1;
                }
                break;
            default:
                i = 0;
                break;
            }
            switch (c) {
            case INDEX_op_set_label:
            case INDEX_op_br:
            case INDEX_op_brcond_i32:
            case INDEX_op_brcond_i64:
            case INDEX_op_brcond2_i32:
                fprintf(log_tcg_fp, "%s$L%d", k ? "," : "",
                                arg_label(op->args[k])->id);
                i++, k++;
                break;
            default:
                break;
            }
            for (; i < nb_cargs; i++, k++) {
                fprintf(log_tcg_fp, "%s$0x%" TCG_PRIlx, k ? "," : "", op->args[k]);
            }
        }
        fprintf(log_tcg_fp,"\n");
    }
    fprintf(log_tcg_fp,"\n");
    fclose(log_tcg_fp);
}