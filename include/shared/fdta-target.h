#ifndef FDTAF_TARGET
#define FDTAF_TARGET

#include "shared/fdta-types-common.h"


#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

#define MAX_REGS (CPU_NUM_REGS + 8) /* we assume up to 8 temporary registers */
// definitions of kernel and user address
// here are some definitions straight from page_types.h/page_64_types.h
#if defined(TARGET_I386) || defined(TARGET_ARM)
    #define TARGET_PAGE_OFFSET (0xC0000000)
    #define TARGET_KERNEL_IMAGE_START TARGET_PAGE_OFFSET
    #define TARGET_KERNEL_IMAGE_SIZE (896 * 1024 * 1024 - 1)
#elif defined(TARGET_MIPS)
    #define TARGET_PAGE_OFFSET (0x80000000)
    #define TARGET_KERNEL_IMAGE_START TARGET_PAGE_OFFSET
    #define TARGET_KERNEL_IMAGE_SIZE (1024 * 1024 * 1024 - 1)
#else
    #define TARGET_PAGE_OFFSET (0xFFFF880000000000)
    #define TARGET_KERNEL_IMAGE_START (0xFFFFFFFF80000000)
    #define TARGET_KERNEL_IMAGE_SIZE (512 * 1024 * 1024)
#endif

#define TARGET_KERNEL_START TARGET_PAGE_OFFSET

#if defined(TARGET_I386) || defined(TARGET_ARM)
    #define TARGET_KERNEL_END (0xF8000000 - 1)
#elif defined(TARGET_MIPS)
    #define TARGET_KERNEL_END (0xFFFFFFFF)
#else
    //same here - in fact the global stuff (from the kernel image) are defined in higher addresses
    #define TARGET_KERNEL_END 0xFFFFC80000000000
#endif


int fdta_is_in_kernel(CPUState *cs);
gva_t fdta_get_pc(CPUState* cs);
gpa_t fdta_get_pgd(CPUState* cs);
gva_t fdta_get_esp(CPUState* cs);
int is_kernel_address(gva_t addr);

#ifdef __cplusplus
}
#endif  /* __cplusplus */

#endif
