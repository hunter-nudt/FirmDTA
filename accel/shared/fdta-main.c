#include "qemu/osdep.h"
#include "shared/fdta-types-common.h"
#include "shared/fdta-main.h"
#include "shared/fdta-main-internal.h"
#include "exec/exec-all.h"
#include "exec/cpu-all.h"
#include "exec/translate-all.h"
#include "qapi/qapi-types-machine.h"
#include "accel/tcg/tb-context.h"
#include "sysemu/runstate.h"
#include "sysemu/hw_accel.h"
#if !defined(CONFIG_USER_ONLY)
#include "hw/boards.h"
#endif
#include "shared/fdta-callback-common.h"
#include "shared/fdta-callback-to-qemu.h"
#include "shared/fdta-target.h"
#include "shared/fdta-linux-vmi.h"
#include "shared/fdta-taint-memory-basic.h"
#include "shared/fdta-taint-memory.h"


#define GUEST_OS_THREAD_SIZE 8192

#define MAX_THREAD_INFO_SEARCH_SIZE 8192
#define MAX_TASK_STRUCT_SEARCH_SIZE 4000 

// gva_t fdta_get_esp(CPUState *cs);

// static int devices = 0;

struct tb_cmp {
    uint32_t pc;
};

#ifdef TARGET_WORDS_BIGENDIAN
static void convert_endian_i32(uint32_t *data)
{
   *data = ((*data & 0xff000000) >> 24)
        | ((*data & 0x00ff0000) >>  8)
        | ((*data & 0x0000ff00) <<  8)
        | ((*data & 0x000000ff) << 24);
}
// static void convert_endian_i64(uint64_t *data)
// {
//     *data = (((*data) & 0xff00000000000000ull) >> 56)
//             | (((*data) & 0x00ff000000000000ull) >> 40)
//             | (((*data) & 0x0000ff0000000000ull) >> 24)
//             | (((*data) & 0x000000ff00000000ull) >> 8)
//             | (((*data) & 0x00000000ff000000ull) << 8)
//             | (((*data) & 0x0000000000ff0000ull) << 24)
//             | (((*data) & 0x000000000000ff00ull) << 40)
//             | (((*data) & 0x00000000000000ffull) << 56);
// }
#endif  /* TARGET_WORDS_BIGENDIAN */

flush_list flush_list_internal;

static inline bool tb_htable_cmp(const void *p, const void *d);
static inline void fdta_tb_flush_block(void *p);
static inline void fdta_tb_flush_page(void *p);

/* Pause the guest system */
void fdta_stop_vm(void)
{
	if (runstate_is_running()) {
        vm_stop(RUN_STATE_PAUSED);
    }
}

/* Unpause the guest system */
void fdta_start_vm(void)
{
    if (!runstate_is_running()) {
        vm_start();
    }
}

CPUState *fdta_get_current_cpu(void)
{
    if (!current_cpu) {
        return first_cpu;
    }
    return current_cpu;
}

static gpa_t fdta_get_phys_addr_internal(CPUState* cs, gva_t addr)
{
    CPUArchState *env = (CPUArchState *)cs->env_ptr;
    hwaddr phys_addr;
    uintptr_t mmu_idx = cpu_mmu_index(env, true);
    uintptr_t index = tlb_index(env, mmu_idx, addr);
    CPUTLBEntry *entry = tlb_entry(env, mmu_idx, addr);
    void *p;

    if (unlikely(!tlb_hit(entry->addr_code, addr))) {
        if (!victim_tlb_hit(env, mmu_idx, index, offsetof(CPUTLBEntry, addr_code), (addr) & TARGET_PAGE_MASK)) {
            phys_addr = cpu_get_phys_page_debug(cs, addr & TARGET_PAGE_MASK);
			if (phys_addr == -1)
				return -1;
			phys_addr += addr & (TARGET_PAGE_SIZE - 1);
			return (gpa_t)phys_addr;
        }
    }

    if (unlikely(entry->addr_code & TLB_MMIO)) {
        /* The region is not backed by RAM.  */
        return -1;
    }

    p = (void *)((uintptr_t)addr + entry->addend);
    return qemu_ram_addr_from_host_nofail(p);
}

gpa_t fdta_get_phys_addr(CPUState* cs, gva_t addr)
{
    CPUArchState *env = (CPUArchState *)cs->env_ptr;
    hwaddr phys_addr;
	if (env == NULL )
	{
        cs = fdta_get_current_cpu();
        cpu_synchronize_state(cs);
		env = (CPUArchState *)cs->env_ptr; 
	}

#ifdef TARGET_MIPS
	uint32_t ori_hflags = env->hflags;
	env->hflags &= ~MIPS_HFLAG_UM;
	env->hflags &= ~MIPS_HFLAG_SM;
#endif

	phys_addr = fdta_get_phys_addr_internal(cs, addr);

#ifdef TARGET_MIPS
	env->hflags = ori_hflags;   // restore hflags
#endif

	return (gpa_t)(phys_addr);
}

fdta_errno_t fdta_memory_rw(CPUState* cs, fdta_target_ulong addr, void *buf, int len, int is_write)
{
	hwaddr page, phys_addr;
    int rest_len;

	if (cs == NULL ) 
    {
        cs = fdta_get_current_cpu();
        cpu_synchronize_state(cs);
	}

	int ret = 0;

	while (len > 0) {
		page = addr & TARGET_PAGE_MASK;
		phys_addr = fdta_get_phys_addr(cs, page);
		if (phys_addr == -1 || phys_addr > current_machine->ram_size) {
			ret = -1;
			break;
		}
		rest_len = (page + TARGET_PAGE_SIZE) - addr;
		if (rest_len > len)
			rest_len = len;

		cpu_physical_memory_rw(phys_addr + (addr & ~TARGET_PAGE_MASK), buf, rest_len, is_write);

		len -= rest_len;
		buf += rest_len;
		addr += rest_len;
	}

	return ret;
}


fdta_errno_t fdta_read_mem(CPUState* cs, gva_t vaddr, int len, void *buf) {
	return fdta_memory_rw(cs, vaddr, buf, len, 0);
}

fdta_errno_t fdta_write_mem(CPUState *cs, gva_t vaddr, int len, void *buf) {
    return fdta_memory_rw(cs, vaddr, buf, len, 1);
}

fdta_errno_t fdta_read_ptr(CPUState *cs, gva_t vaddr, gva_t *pptr)
{
    int ret = fdta_read_mem(cs, vaddr, sizeof(gva_t), pptr);
	if(ret == 0)
	{
#ifdef TARGET_WORDS_BIGENDIAN
#if TARGET_LONG_BITS == 32
		convert_endian_i32(pptr);
#else
		convert_endian_i64(pptr);
#endif
#endif
	}
	return ret;
}

static inline bool tb_htable_cmp(const void *p, const void *d)
{
    const TranslationBlock *tb = p;
    const struct tb_cmp *cmp_pc = d;
    if(tb->pc == cmp_pc->pc)
    {
        return true;
    }
    return false;
}

static inline void fdta_tb_flush_block(void *p)
{
    TranslationBlock *tb = p;
    tb_phys_invalidate(tb, -1);
}

static inline void fdta_tb_flush_page(void *p)
{
    TranslationBlock *tb = p;
    tb_invalidate_phys_page_range(tb->page_addr[0], tb->page_addr[0] + TARGET_PAGE_SIZE);
}

void fdta_flush_translation_block(CPUState *cs, gva_t pc)
{
    struct tb_cmp cmp_pc;
    cmp_pc.pc = pc;
    qht_htable_traverse(&tb_ctx.htable, &cmp_pc, tb_htable_cmp, fdta_tb_flush_block);
}

void fdta_flush_translation_page(CPUState *cs, gva_t pc)
{
    struct tb_cmp cmp_pc;
    cmp_pc.pc = pc;
    qht_htable_traverse(&tb_ctx.htable, &cmp_pc, tb_htable_cmp, fdta_tb_flush_page);
}

void flush_list_insert(flush_list *list, int type, uint32_t addr)
{
	++list->size;
	flush_node *temp = list->head;
	flush_node *to_insert = (flush_node *)g_malloc(sizeof(flush_node));
	to_insert->type = type;
	to_insert->next = NULL;
	to_insert->addr = addr;

	if(temp == NULL) {
		list->head = to_insert;
		return;
	}

	while(temp->next != NULL) {
		temp = temp->next;
	}

	temp->next = to_insert;
}

void register_fdta_flush_translation_cache(int type, gva_t pc)
{
    flush_list_insert(&flush_list_internal, type, pc);
}

void fdta_perform_flush(CPUState *cs)
{
    flush_node *prev, *temp = flush_list_internal.head;
	while(temp!=NULL) {
		switch (temp->type) {
			case BLOCK_LEVEL:
				fdta_flush_translation_block(cs, temp->addr);
				break;
			case PAGE_LEVEL:
				fdta_flush_translation_page(cs, temp->addr);
				break;
			case ALL_CACHE:
				tb_flush(cs);
				break;
		}
		prev = temp;
		temp = temp->next;
		prev->next = NULL;
		g_free(prev);
	}
	flush_list_internal.head = NULL;
	flush_list_internal.size = 0;
}

void fdta_init(void)
{
	fdta_callback_init();
	vmi_init();
    shadow_memory_init();
    // fdta_vm_compress_init();
	// function_map_init();
	// init_hookapi();
}


void fdta_nic_receive(uint8_t * buf, int size, int cur_pos, int start, int stop)
{
    if (fdta_is_callback_needed(FDTAF_NIC_REC_CB))
		helper_fdta_invoke_nic_rec_callback(buf, size, cur_pos, start, stop);
}

void fdta_nic_send(uint32_t addr, int size, uint8_t * buf)
{
    if (fdta_is_callback_needed(FDTAF_NIC_SEND_CB))
		helper_fdta_invoke_nic_send_callback(addr, size, buf);
}
