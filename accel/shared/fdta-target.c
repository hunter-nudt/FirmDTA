#include "qemu/osdep.h"
#include "hw/core/cpu.h"
#include "exec/exec-all.h"
#include "exec/cpu-all.h"
#include "shared/fdta-target.h"

#ifdef TARGET_MIPS      /* FDTAF_TARGET_MIPS */

static struct {
    fdta_target_ulong pgd_current_p;
    int softshift;
} linux_pte_info = {0};


/* Check if the current execution of guest system is in kernel mode (i.e., ring-0) */ 
int fdta_is_in_kernel(CPUState *cs)
{
    CPUMIPSState *env = (CPUMIPSState *)cs->env_ptr;
    return ((env->hflags & MIPS_HFLAG_MODE) == MIPS_HFLAG_KM);
}


gva_t fdta_get_pc(CPUState* cs)
{
    CPUMIPSState *env = (CPUMIPSState *)cs->env_ptr;
    return (env->active_tc.PC);
}

gpa_t fdta_get_pgd(CPUState* cs)
{
    CPUMIPSState *env = (CPUMIPSState *)cs->env_ptr;
    
    if (unlikely(linux_pte_info.pgd_current_p == 0)) {
        int i;
        uint32_t lui_ins, lw_ins, srl_ins;
        uint32_t address;
        uint32_t ebase;

        ebase = env->CP0_EBase - 0x80000000;
        /*
         * The exact TLB refill code varies depeing on the kernel version
         * and configuration. Examins the TLB handler to extract
         * pgd_current_p and the shift required to convert in memory PTE
         * to TLB format
        */
        static struct {
            struct {
                uint32_t off;
                uint32_t op;
                uint32_t mask;
            } lui, lw, srl;
        } handlers[] = {
            /* 2.6.29+ */
            {
                {0x00, 0x3c1b0000, 0xffff0000}, /* 0x3c1b803f : lui k1,%hi(pgd_current_p) */
                {0x08, 0x8f7b0000, 0xffff0000}, /* 0x8f7b3000 : lw  k1,%lo(k1) */
                {0x34, 0x001ad182, 0xffffffff}  /* 0x001ad182 : srl k0,k0,0x6 */
            },
            /* 3.4+ */
            {
                {0x00, 0x3c1b0000, 0xffff0000}, /* 0x3c1b803f : lui k1,%hi(pgd_current_p) */
                {0x08, 0x8f7b0000, 0xffff0000}, /* 0x8f7b3000 : lw  k1,%lo(k1) */
                {0x34, 0x001ad142, 0xffffffff}  /* 0x001ad182 : srl k0,k0,0x5 */
            }
        };

        /* Match the kernel TLB refill exception handler against known code */
        for (i = 0; i < sizeof(handlers)/sizeof(handlers[0]); i++) {
            lui_ins = ldl_phys(cs->as, ebase + handlers[i].lui.off);
            lw_ins = ldl_phys(cs->as, ebase + handlers[i].lw.off);
            srl_ins = ldl_phys(cs->as, ebase + handlers[i].srl.off);
            if (((lui_ins & handlers[i].lui.mask) == handlers[i].lui.op) &&
                ((lw_ins & handlers[i].lw.mask) == handlers[i].lw.op) &&
                ((srl_ins & handlers[i].srl.mask) == handlers[i].srl.op))
                break;
        }
        if (i >= sizeof(handlers)/sizeof(handlers[0])) {
            printf("TLBMiss handler dump:\n");
            for (i = 0; i < 0x80; i+= 4)
                //printf("0x%08x: 0x%08x\n", ebase + i, ldl_phys(env->as, ebase + i));
            cpu_abort(cs, "TLBMiss handler signature not recognised\n");
        }
        address = (lui_ins & 0xffff) << 16;
        address += (((int32_t)(lw_ins & 0xffff)) << 16) >> 16;
        if (address >= 0x80000000 && address < 0xa0000000)
            address -= 0x80000000;
        else if (address >= 0xa0000000 && address <= 0xc0000000)
            address -= 0xa0000000;
        else
            cpu_abort(cs, "pgd_current_p not in KSEG0/KSEG1\n");

        linux_pte_info.pgd_current_p = address;
        linux_pte_info.softshift = (srl_ins >> 6) & 0x1f;
    }

    /* Get pgd_current */
    //return ldl_phys(env->as, linux_pte_info.pgd_current_p);
    return ldl_phys(cs->as, linux_pte_info.pgd_current_p) - 0x80000000; //zyw
}

gva_t fdta_get_esp(CPUState* cs)
{
    CPUMIPSState *env = (CPUMIPSState *)cs->env_ptr;
  /* AWH - General-purpose register 29 (of 32) is the stack pointer */
    return (env->active_tc.gpr[29]);
}

int is_kernel_address(gva_t addr)
{
    if(((addr >= TARGET_KERNEL_START) && (addr < TARGET_KERNEL_END))
    || ((addr >= TARGET_KERNEL_IMAGE_START) && (addr < (TARGET_KERNEL_IMAGE_START + TARGET_KERNEL_IMAGE_SIZE))))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#elif defined(TARGET_I386)    /* FDTAF_TARGET_X86 */

/* Check if the current execution of guest system is in kernel mode (i.e., ring-0) */
int fdta_is_in_kernel(CPUState *cs)
{
    CPUX86State *env = (CPUX86State *)cs->env_ptr;
    return ((env->hflags & HF_CPL_MASK) == 0);
}

gva_t fdta_get_pc(CPUState* cs)
{
    CPUX86State *env = (CPUX86State *)cs->env_ptr;
    return (env->eip + env->segs[R_CS].base);
}

gpa_t fdta_get_pgd(CPUState* cs)
{
    CPUX86State *env = (CPUX86State *)cs->env_ptr;
    return (env->cr[3]);
}

gva_t fdta_get_esp(CPUState* cs)
{
    CPUX86State *env = (CPUX86State *)cs->env_ptr;
    return (env->regs[R_ESP]);
}

int is_kernel_address(gva_t addr)
{
    if(((addr >= TARGET_KERNEL_START) && (addr < TARGET_KERNEL_END))
    || ((addr >= TARGET_KERNEL_IMAGE_START) && (addr < (TARGET_KERNEL_IMAGE_START + TARGET_KERNEL_IMAGE_SIZE))))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#elif defined(TARGET_ARM)   /* FDTAF_TARGET_ARM */
#include "target/arm/internals.h"
int fdta_is_in_kernel(CPUState *cs)
{
    CPUARMState *env = (CPUARMState *)cs->env_ptr;
    return ((env->uncached_cpsr & CPSR_M) != ARM_CPU_MODE_USR);
}

gva_t fdta_get_pc(CPUState* cs)
{
    CPUARMState *env = (CPUARMState *)cs->env_ptr;
    return (env->regs[15]);
}

//Based this off of helper.c in get_level1_table_address
gpa_t fdta_get_pgd(CPUState* cs)
{
    CPUARMState *env = (CPUARMState *)cs->env_ptr;
    return env->cp15.ttbr0_el[1] & 0xfffff000;
}

gva_t fdta_get_esp(CPUState* cs)
{
    CPUARMState *env = (CPUARMState *)cs->env_ptr;
    return (env->regs[13]);
}

int is_kernel_address(gva_t addr)
{
    if(((addr >= TARGET_KERNEL_START) && (addr < TARGET_KERNEL_END))
    || ((addr >= TARGET_KERNEL_IMAGE_START) && (addr < (TARGET_KERNEL_IMAGE_START + TARGET_KERNEL_IMAGE_SIZE))))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#else

int fdta_is_in_kernel(CPUState *cs)
{
    return 0;
}

gva_t fdta_get_pc(CPUState* cs)
{
    return 0;
}

//Based this off of helper.c in get_level1_table_address
gpa_t fdta_get_pgd(CPUState* cs)
{
    return 0;
}

gva_t fdta_get_esp(CPUState* cs)
{
    return 0;
}

int is_kernel_address(gva_t addr)
{
    return 0;
}

#endif