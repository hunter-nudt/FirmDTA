#ifndef FDTAF_TAINT_MEMORY_H
#define FDTAF_TAINT_MEMORY_H
#ifdef __cplusplus
extern "C" 
{
#endif

#include "qemu/osdep.h"

extern bool taint_tracking_enabled;
extern bool taint_nic_enabled;
extern bool taint_load_pointers_enabled;
extern bool taint_store_pointers_enabled;
extern bool taint_pointers_enabled;
extern bool taint_start;

void fresh_taint_memory(void);

void taint_mem(ram_addr_t paddr, int size, uint8_t *taint);

void taint_mem_check(ram_addr_t paddr, uint32_t size, uint8_t *taint);

#ifdef __cplusplus
}
#endif

#endif /* FDTAF_TAINT_MEMORY_BASIC_H */