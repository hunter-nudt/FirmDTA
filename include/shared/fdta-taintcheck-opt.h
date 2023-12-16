#ifndef FDTAF_TAINTCHECK_OPT
#define FDTAF_TAINTCHECK_OPT

#include "shared/fdta-types-common.h"


#ifdef CONFIG_TCG_TAINT
#include "shared/fdta-taint-memory-basic.h"
#include "shared/fdta-taint-memory.h"
#endif /* CONFIG_TCG_TAINT*/

#ifdef __cplusplus
extern "C"
{
#endif

/* size <= 4 */
#define SIZE_TO_MASK(size) ((1u << (size * 8)) - 1u)
#define DISK_HTAB_SIZE 1024

#ifdef CONFIG_TCG_TAINT
uint64_t taintcheck_check_register(CPUState *cs, int regid, int offset, int size);

int taintcheck_check_virtmem(gva_t vaddr, uint32_t size, uint8_t *taint);

int taintcheck_taint_virtmem(gva_t vaddr, uint32_t size, uint8_t *taint);

void taintcheck_nic_writebuf(uint32_t addr, int size, const uint8_t *taint);

void taintcheck_nic_readbuf(uint32_t addr, int size, uint8_t *taint);

void taintcheck_nic_cleanbuf(uint32_t addr, int size);

void taintcheck_hd_out(int size, int64_t sect_num, uint32_t offset, const void *s);

void taintcheck_hd_in(int size, int64_t sect_num, uint32_t offset, const void *s);

void taintcheck_hd_from_mem(ram_addr_t paddr, int size, int64_t sect_num, const void *s);

void taintcheck_hd_to_mem(ram_addr_t paddr, int size, int64_t sect_num, const void *s);

int taintcheck_init(void);

void taintcheck_cleanup(void);
#endif /* CONFIG_TCG_TAINT */

#ifdef __cplusplus
}
#endif // __cplusplus

#endif /* FDTAF_TAINTCHECK_OPT */