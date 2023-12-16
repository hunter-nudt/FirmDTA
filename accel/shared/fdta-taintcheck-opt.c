#include "qemu/osdep.h"
#include "shared/fdta-main.h"
#include "shared/fdta-main-internal.h"
#include "shared/fdta-taintcheck-opt.h"
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
#include "shared/fdta-callback-common.h"
#include "shared/fdta-callback-to-qemu.h"
#include "shared/fdta-taint-memory-basic.h"
#include "shared/fdta-taint-memory.h"

/* bitmap for nic */
uint8_t nic_bitmap[1024 * 32];

//each disk sector is 512 bytes
typedef struct disk_record {
    const void *bs;
    uint64_t index;
    uint8_t bitmap[512];
    QLIST_ENTRY(disk_record) entry;
} disk_record;

static QLIST_HEAD(disk_record_list_head, disk_record) disk_record_heads[DISK_HTAB_SIZE];
static uint8_t zero_mem[512];

uint64_t taintcheck_check_register(CPUState *cs, int regid, int offset, int size)
{
	int off = offset * 8;
#if defined(TARGET_MIPS)
    CPUMIPSState *env = (CPUMIPSState *)cs->env_ptr;
    return (size < 4) ? (env->active_tc.taint_gpr[regid]>>off) & (SIZE_TO_MASK(size)) : env->active_tc.taint_gpr[regid]>>off;
#elif defined(TARGET_I386)
    CPUX86State *env = (CPUX86State *)cs->env_ptr;
    return (size < 4) ? (env->taint_regs[regid]>>off) & (SIZE_TO_MASK(size)) : env->taint_regs[regid]>>off;
#elif defined(TARGET_ARM)
    CPUARMState *env = (CPUARMState *)cs->env_ptr;
    return (size < 4) ? (env->taint_regs[regid]>>off) & (SIZE_TO_MASK(size)) : env->taint_regs[regid]>>off;    
#endif /* CONFIG_MIPS */
}

static int taintcheck_taint_disk(const uint8_t *taint, uint64_t index, int offset, int size, const void *bs)
{
    struct disk_record_list_head *head = &disk_record_heads[index & (DISK_HTAB_SIZE - 1)];
    disk_record *drec, *new_drec, *next_drec; /* disk_record */
    int found = 0;
    int is_tainted = 0;

    assert(offset + size <= 512);

    if(memcmp(taint, zero_mem, size) != 0) {
        is_tainted = 1;
    }

    QLIST_FOREACH_SAFE(drec, head, entry, next_drec) {
        if (drec->index == index && drec->bs == bs) {
            found = 1;
            break;
        }
    }
    if (!found) {
        if (!is_tainted)
            return 0;

        if (!(new_drec = g_malloc0((size_t)sizeof(disk_record))))
            return -1;

        new_drec->index = index;
        new_drec->bs = bs;
        memcpy(&new_drec->bitmap[offset], taint, size);
        QLIST_INSERT_HEAD(head, new_drec, entry);
    } else {
        memcpy(&drec->bitmap[offset], taint, size);
        if (!is_tainted && !memcmp(drec->bitmap, zero_mem, sizeof(drec->bitmap))) {
            QLIST_REMOVE(drec, entry);
            g_free(drec);
        }
    }
    return 0;
}

static void taintcheck_disk_check(uint8_t *taint, uint64_t index, int offset, int size, const void *bs)
{
    struct disk_record_list_head *head = &disk_record_heads[index & (DISK_HTAB_SIZE - 1)];
    disk_record *drec, *next_drec;
    int found = 0;

    assert(offset + size <= 512);

    QLIST_FOREACH_SAFE(drec, head, entry, next_drec) {
        if (drec->index == index && drec->bs == bs) {
            found = 1;
            break;
        }
    }

    if (!found) {
        bzero(taint, size);
        return;
    }

    memcpy(taint, &drec->bitmap[offset], size);
}

/// @brief check the taint of a memory buffer given the start virtual address.
/// @param vaddr the virtual address of the memory buffer
/// @param size the memory buffer size
/// @param taint he output taint array, it must hold at least [size] bytes
/// @return  0 means success, -1 means failure
int taintcheck_check_virtmem(gva_t vaddr, uint32_t size, uint8_t *taint)
{
    gpa_t paddr = 0;
    gpa_t offset;
    uint32_t i, len = 0;
    CPUState *cs = fdta_get_current_cpu();

    /* If tainting is disabled, return no taint */
    if(!taint_tracking_enabled) {
		bzero(taint, size);
		return 0;
	}

    for(i = 0; i < size; i += len) {
        paddr = fdta_get_phys_addr(cs, vaddr + i);
        if(paddr == -1) {
            return -1;
        }
        offset = (vaddr + i) & (BITPAGE_LEAF_BITS);
        len = MIN((1 << BITPAGE_LEAF_BITS) - offset, size - i);
        taint_mem_check(paddr, len, taint + i);
    }

	return 0;
}

/// @brief set taint for a memory buffer given the start virtual address.
/// @param vaddr the virtual address of the memory buffer
/// @param size the memory buffer size
/// @param taint the taint array, it must hold at least [size] bytes
/// @return 0 means success, -1 means failure
int taintcheck_taint_virtmem(gva_t vaddr, uint32_t size, uint8_t *taint)
{
    gpa_t paddr = 0;
    gpa_t offset;
    uint32_t i, len = 0;
    CPUState *cs = fdta_get_current_cpu();

    /* If tainting is disabled, return no taint */
    if(!taint_tracking_enabled) {
		bzero(taint, size);
		return 0;
	}

    for(i = 0; i < size; i += len) {
        paddr = fdta_get_phys_addr(cs, vaddr + i);
        if(paddr == -1) {
            return -1;
        }
        offset = (vaddr + i) & (BITPAGE_LEAF_BITS);
        len = MIN((1 << BITPAGE_LEAF_BITS) - offset, size - i);
        taint_mem(paddr, len, taint + i);
    }

	return 0;
}

void taintcheck_nic_writebuf(uint32_t addr, int size, const uint8_t *taint)
{
	memcpy(&nic_bitmap[addr], taint, size);
}

void taintcheck_nic_readbuf(uint32_t addr, int size, uint8_t *taint)
{
    memcpy(taint, &nic_bitmap[addr], size);
}

void taintcheck_nic_cleanbuf(uint32_t addr, int size)
{
	memset(&nic_bitmap[addr], 0, size);
}

void taintcheck_hd_out(int size, int64_t sect_num, uint32_t offset, const void *s)
{
    CPUState *cs = fdta_get_current_cpu();
    if(size > 8) {
        return;
    }
    taintcheck_taint_disk((uint8_t *)cs->taint_index, sect_num, offset, size, s);
}

void taintcheck_hd_in(int size, int64_t sect_num, uint32_t offset, const void *s)
{
    CPUState *cs = fdta_get_current_cpu();
    if(size > 8) {
        return;
    }
    taintcheck_disk_check((uint8_t *)cs->taint_index, sect_num, offset, size, s);
}

void taintcheck_hd_from_mem(ram_addr_t paddr, int size, int64_t sect_num, const void *s)
{
    /* we assume size is multiple of 512, because this function is used in DMA, and paddr is also aligned. */
    uint32_t i;
    uint8_t taint[512];
	if (!taint_tracking_enabled) {
		return;
	}
    for (i = 0; i < size; i += 512) {
        taint_mem_check(paddr + i, 512, taint);
        taintcheck_taint_disk(taint, sect_num + i/512, 0, 512, s);
    }
}

void taintcheck_hd_to_mem(ram_addr_t paddr, int size, int64_t sect_num, const void *s)
{
    /* we assume size is multiple of 512, because this function is used in DMA, and paddr is also aligned. */
    uint32_t i;
    uint8_t taint[512];
	if (!taint_tracking_enabled) {
		return;
	}
	for (i = 0; i < size; i += 512) {
        taintcheck_disk_check(taint, sect_num + i/512, 0, size, s);
        taint_mem(paddr + i, 512, taint);
	}
}

int taintcheck_init(void)
{
    uint32_t i;
    for (i = 0; i < DISK_HTAB_SIZE; i++) {
        QLIST_INIT(&disk_record_heads[i]);
    }
        
    bzero(zero_mem, sizeof(zero_mem));
    return 0;
}

void taintcheck_cleanup(void)
{
    bzero(nic_bitmap, sizeof(nic_bitmap));
}