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
#include "shared/fdta-callback-common.h"
#include "shared/fdta-callback-to-qemu.h"
#include "shared/fdta-target.h"
#include "shared/fdta-linux-vmi.h"
#include "shared/fdta-vmi-msg-warpper.h"
#include "shared/fdta-taint-propagate-msg.h"

bool taint_tracking_enabled = false;
bool taint_nic_enabled = false;
bool taint_load_pointers_enabled = false;
bool taint_store_pointers_enabled = false;
bool taint_pointers_enabled = false;

/* Root node for holding memory taint information */
static uint32_t shadow_memory_table_root_size = 0;
middle_node_t **shadow_memory_table = NULL;
leaf_node_pool_t leaf_pool;
middle_node_pool_t middle_pool;

uint32_t middle_nodes_in_use = 0;
uint32_t leaf_nodes_in_use = 0;

static uint8_t zero_index[8] = {0};

static target_ulong last_pc_base = 0;

#if 1
static void debug_func(void)
{
}
#endif

static void taint_data_flow(ram_addr_t paddr, unsigned size, uint32_t is_load, uint8_t taint_label[8])
{
    FILE *taint_log_fp;
    taint_log_fp = fopen("/home/mypc/guest_taint_log", "a");
    if (taint_log_fp == NULL)
    {
        printf("open file fail\n");
        return;
    }
    CPUState *cs = fdta_get_current_cpu();
    gpa_t current_pgd;
    char *proc_name;
    uint32_t pid;
    target_ulong pc_base;
    modinfo_t *modinfo;
    proc_name = (char *)malloc(64);
    modinfo = (modinfo_t *)g_malloc0(sizeof(modinfo_t));

    pc_base = fdta_get_pc(cs);
    if (pc_base != last_pc_base)
    {
        last_pc_base = pc_base;
        current_pgd = fdta_get_pgd(cs);
        vmi_find_procname_pid_by_pgd(current_pgd, proc_name, 64, &pid);
        vmi_locate_module_by_pc(cs, pc_base, current_pgd, modinfo);
        fprintf(taint_log_fp, "\n%ld\t%d\t%08x\t%s\t%s\t%08x\t%x\t%x\n",
                ins_no,
                pid,
                current_pgd,
                proc_name,
                modinfo->name,
                modinfo->base,
                modinfo->size,
                pc_base);
        fprintf(taint_log_fp, "%d\t%08lx\t%d\t",
                is_load,
                paddr,
                size);
        for(int i = 0; i < 8; i++)
        {
            fprintf(taint_log_fp, "%02x", taint_label[i]);
        }
        fprintf(taint_log_fp, "\n");
    }
    else
    {
        fprintf(taint_log_fp, "%d\t%08lx\t%d\t",
                is_load,
                paddr,
                size);
        for(int i = 0; i < 8; i++)
        {
            fprintf(taint_log_fp, "%02x", taint_label[i]);
        }
        fprintf(taint_log_fp, "\n");
    }
    fclose(taint_log_fp);
    if (pc_base == 0x46d2fc)
    {
        debug_func();
    }
}

static inline void convert_endian(uint8_t taint_temps[], unsigned size)
{
    uint8_t temp;
    switch (size)
    {
    case 1:
        break;
    case 2:
        temp = taint_temps[0];
        taint_temps[0] = taint_temps[1];
        taint_temps[1] = temp;
        break;
    case 4:
        temp = taint_temps[0];
        taint_temps[0] = taint_temps[3];
        taint_temps[3] = temp;
        temp = taint_temps[1];
        taint_temps[1] = taint_temps[2];
        taint_temps[2] = temp;
        break;
    case 8:
        temp = taint_temps[0];
        taint_temps[0] = taint_temps[7];
        taint_temps[7] = temp;
        temp = taint_temps[1];
        taint_temps[1] = taint_temps[6];
        taint_temps[6] = temp;
        temp = taint_temps[2];
        taint_temps[2] = taint_temps[5];
        taint_temps[5] = temp;
        temp = taint_temps[3];
        taint_temps[3] = taint_temps[4];
        taint_temps[4] = temp;
        break;
    default:
        break;
    }
}

static inline leaf_node_t *read_leaf_node_i32(uint32_t address)
{
    leaf_node_t *leaf_node;
    unsigned int middle_node_index = address >> (BITPAGE_LEAF_BITS + BITPAGE_MIDDLE_BITS);
    unsigned int leaf_node_index = (address >> BITPAGE_LEAF_BITS) & (MIDDLE_ADDRESS_MASK);
    // check for out of range physical address
    if (address >= current_machine->ram_size)
        return NULL;

    if (shadow_memory_table[middle_node_index])
    {
        leaf_node = shadow_memory_table[middle_node_index]->leaf[leaf_node_index];
        if (leaf_node)
        {
            return leaf_node;
        }
        else
        {
            return NULL;
        }
    }
    else
    {
        return NULL;
    }
}

static void free_pools(void)
{
    int i;
    for (i = leaf_pool.next_available_node; i < BITPAGE_LEAF_POOL_SIZE; i++)
    {
        if (leaf_pool.pool[i] != NULL)
        {
            g_free(leaf_pool.pool[i]);
            leaf_pool.pool[i] = NULL;
        }
    }

    for (i = middle_pool.next_available_node; i < BITPAGE_MIDDLE_POOL_SIZE; i++)
    {
        if (middle_pool.pool[i] != NULL)
        {
            g_free(middle_pool.pool[i]);
            middle_pool.pool[i] = NULL;
        }
    }
    leaf_pool.next_available_node = 0;
    middle_pool.next_available_node = 0;
}

static inline void return_leaf_node_to_pool(leaf_node_t *node)
{
    if (leaf_pool.next_available_node != 0)
    {
        memset((void *)node, 0, sizeof(leaf_node_t));
        leaf_pool.next_available_node -= 1;
        leaf_pool.pool[leaf_pool.next_available_node] = node;
    }
    else
    {
        memset((void *)node, 0, sizeof(middle_node_t));
        g_free(node);
        node = NULL;
    }
    leaf_nodes_in_use--;
}

static inline void return_middle_node_to_pool(middle_node_t *node)
{
    if (middle_pool.next_available_node > 0)
    {
        memset((void *)node, 0, sizeof(middle_node_t));
        middle_pool.next_available_node -= 1;
        middle_pool.pool[middle_pool.next_available_node] = node;
    }
    else
    {
        memset((void *)node, 0, sizeof(middle_node_t));
        g_free(node);
        node = NULL;
    }
    middle_nodes_in_use--;
}

static inline leaf_node_t *fetch_leaf_node_from_pool(void)
{
    /* If the pool is full, rebuild the pool */
    if (leaf_pool.next_available_node >= BITPAGE_LEAF_POOL_SIZE)
    {
        allocate_leaf_pool();
    }
    leaf_nodes_in_use++;
    return leaf_pool.pool[leaf_pool.next_available_node++];
}

static inline middle_node_t *fetch_middle_node_from_pool(void)
{
    /* If the pool is full, rebuild the pool */
    if (middle_pool.next_available_node >= BITPAGE_MIDDLE_POOL_SIZE)
    {
        allocate_middle_pool();
    }
    middle_nodes_in_use++;
    return middle_pool.pool[middle_pool.next_available_node++];
}

static inline leaf_node_t *taint_st_general_i32(const ram_addr_t paddr, gva_t vaddr, uint32_t taint)
{
    CPUState *cs = fdta_get_current_cpu();
    unsigned int middle_node_index = paddr >> (BITPAGE_LEAF_BITS + BITPAGE_MIDDLE_BITS);
    unsigned int leaf_node_index = (paddr >> BITPAGE_LEAF_BITS) & (MIDDLE_ADDRESS_MASK);
    leaf_node_t *leaf_node;

    /* does a middle node exist for this address? */
    if (shadow_memory_table[middle_node_index])
    {
        /* does a leaf node exist for this address? */
        if (!shadow_memory_table[middle_node_index]->leaf[leaf_node_index])
        {
            if (!taint)
                return NULL;

            /* Pull leaf node from pool and put taint in it */
            leaf_node = fetch_leaf_node_from_pool();
            shadow_memory_table[middle_node_index]->leaf[leaf_node_index] = leaf_node;
            /*
                Now we are writing a taint into a newly allocated leaf node. We should flush the TLB entry,
                If vaddr is 0, it means this memory write comes from an IO device. We will need to flush the entire TLB.
                FIXME: for a multicore system, we should actually flush TLB in all CPUs.
            */
            // printf("taint_st_general_i32: tlb_flush vaddr=%0x taint=%x\n", vaddr, taint);
            if (vaddr)
                tlb_flush_page(cs, vaddr);
            else
                tlb_flush(cs); // TODO: a more efficient solution is just to flush the entry given a physical address.
        }
        else
        {
            leaf_node = shadow_memory_table[middle_node_index]->leaf[leaf_node_index];
        }
        /* Is there no middle node and no taint to add? */
    }
    /* Pull middle node from pool */
    else
    {
        if (!taint)
            return NULL;

        leaf_node = fetch_leaf_node_from_pool();
        shadow_memory_table[middle_node_index] = fetch_middle_node_from_pool();
        shadow_memory_table[middle_node_index]->leaf[leaf_node_index] = leaf_node;
        /*
            Now we are writing a taint into a newly allocated leaf node. We should flush the TLB entry,
            so the related entry will be marked as io_mem_taint (or io_mem_notdirty). The virtual address is stored in env->mem_io_vaddr,
            because all tainted memory writes either go through io_mem_write (i.e., io_mem_taint or io_mem_notdirty).
            FIXME: what about DMA? There will be no related virtual address.
        */
        // printf("taint_st_general_i32: tlb_flush vaddr=%0x taint=%x\n", vaddr, taint);
        if (vaddr)
            tlb_flush_page(cs, vaddr);
        else
            tlb_flush(cs); // TODO: a more efficient solution is just to flush the entry given a physical address.
    }
    return leaf_node;
}

void allocate_leaf_pool(void)
{
    int i;
    for (i = 0; i < BITPAGE_LEAF_POOL_SIZE; i++)
        leaf_pool.pool[i] = (leaf_node_t *)g_malloc0(sizeof(leaf_node_t));
    leaf_pool.next_available_node = 0;
}

void allocate_middle_pool(void)
{
    int i;
    for (i = 0; i < BITPAGE_MIDDLE_POOL_SIZE; i++)
        middle_pool.pool[i] = (middle_node_t *)g_malloc0(sizeof(middle_node_t));
    middle_pool.next_available_node = 0;
}

void allocate_taint_memory(void)
{
    if (shadow_memory_table)
        return; // don't need allocate if one exists
    shadow_memory_table_root_size = current_machine->ram_size >> (BITPAGE_LEAF_BITS + BITPAGE_MIDDLE_BITS);
    shadow_memory_table = (middle_node_t **)g_malloc0(shadow_memory_table_root_size * sizeof(void *));
    allocate_leaf_pool();
    allocate_middle_pool();
    middle_nodes_in_use = 0;
    leaf_nodes_in_use = 0;
}

void empty_shadow_memory_table(void)
{
    uint32_t middle_index;
    uint32_t leaf_index;
    middle_node_t *middle_node = NULL;
    leaf_node_t *leaf_node = NULL;

    if (!shadow_memory_table)
        return; /* if there's no root, exit */
    for (middle_index = 0; middle_index < shadow_memory_table_root_size; middle_index++)
    {
        middle_node = shadow_memory_table[middle_index];
        if (middle_node)
        {
            for (leaf_index = 0; leaf_index < (1 << BITPAGE_MIDDLE_BITS); leaf_index++)
            {
                leaf_node = middle_node->leaf[leaf_index];
                if (leaf_node)
                {
                    g_free(leaf_node);
                    leaf_node = NULL;
                }
            }
        }
        g_free(middle_node);
        middle_node = NULL;
    }
}

/* This deallocates all of the nodes in the tree, including the root */
void free_taint_memory(void)
{
    empty_shadow_memory_table();
    g_free(shadow_memory_table);
    shadow_memory_table = NULL;
    free_pools();
}

/* fresh the shadow memory */
void fresh_taint_memory(void)
{
    CPUState *cs = fdta_get_current_cpu();
    fdta_stop_vm();
    tb_flush(cs);
    empty_shadow_memory_table();
    free_pools();
    allocate_leaf_pool();
    allocate_middle_pool();
    middle_nodes_in_use = 0;
    leaf_nodes_in_use = 0;
    fdta_start_vm();
}

void garbage_collect_taint(int flag)
{
    uint32_t middle_index;
    uint32_t leaf_index;
    uint32_t i, free_leaf, free_middle;
    middle_node_t *middle_node = NULL;
    leaf_node_t *leaf_node = NULL;

    static uint32_t counter = 0;

    if (!shadow_memory_table || !taint_tracking_enabled)
        return;

    if (!flag && (counter < 4 * 1024))
    {
        counter++;
        return;
    }
    counter = 0;
    for (middle_index = 0; middle_index < shadow_memory_table_root_size; middle_index++)
    {
        middle_node = shadow_memory_table[middle_index];
        if (middle_node)
        {
            free_middle = 1;
            for (leaf_index = 0; leaf_index < (1 << BITPAGE_MIDDLE_BITS); leaf_index++)
            {
                leaf_node = middle_node->leaf[leaf_index];
                if (leaf_node)
                {
                    free_leaf = 1;
                    // Take the byte array elements of the leaf node four at a time
                    for (i = 0; i < (1 << (BITPAGE_LEAF_BITS - 2)); i++)
                    {
                        if (*(((uint32_t *)leaf_node->bitmap) + i))
                        {
                            free_leaf = 0;
                            free_middle = 0;
                        }
                    }
                    if (free_leaf)
                    {
                        return_leaf_node_to_pool(leaf_node);
                        middle_node->leaf[leaf_index] = NULL;
                    }
                } // if leaf_node
            }     // End for loop

            if (free_middle)
            {
                return_middle_node_to_pool(middle_node);
                shadow_memory_table[middle_index] = NULL;
            }
        } /* if middle_node */
    }     /* End for loop */
}

int is_phys_page_tainted(ram_addr_t paddr)
{
    unsigned int middle_node_index;
    unsigned int leaf_node_index;
    leaf_node_t *leaf_node = NULL;

    if (!shadow_memory_table)
        return 0;

    middle_node_index = paddr >> (BITPAGE_LEAF_BITS + BITPAGE_MIDDLE_BITS);
    leaf_node_index = (paddr >> BITPAGE_LEAF_BITS) & (MIDDLE_ADDRESS_MASK);

    if (!shadow_memory_table[middle_node_index])
        return 0;

    leaf_node = shadow_memory_table[middle_node_index]->leaf[leaf_node_index];
    return (leaf_node != NULL);
}

#if 1
static void taint_ld_mmu_internal(CPUArchState *env, gva_t vaddr, MemOpIdx oi)
{
    CPUState *cs = fdta_get_current_cpu();
    unsigned int middle_node_index;
    unsigned int leaf_node_index;
    unsigned int next_middle_node_index;
    unsigned int next_leaf_node_index;
    leaf_node_t *leaf_node = NULL;
    gva_t next_page_vaddr;
    ram_addr_t paddr;
    ram_addr_t next_page_paddr;
    MemOp op = get_memop(oi);
    unsigned size = memop_size(op);

    paddr = fdta_get_phys_addr(cs, vaddr);

    if (paddr >= current_machine->ram_size)
        return;

    if (!shadow_memory_table)
    {
        memcpy(env->taint_temps, zero_index, size);
        return;
    }

    middle_node_index = paddr >> (BITPAGE_LEAF_BITS + BITPAGE_MIDDLE_BITS);

    if (!shadow_memory_table[middle_node_index])
    {
        memcpy(env->taint_temps, zero_index, size);
        return;
    }

    /* if paddr spans two pages or IO */
    if (size > 1 && unlikely((paddr & ~TARGET_PAGE_MASK) + size - 1 >= TARGET_PAGE_SIZE))
    {
        target_ulong size_prev = size - (paddr & (size - 1));
        target_ulong size_next = paddr & (size - 1);
        next_page_vaddr = (vaddr & ~((target_ulong)size - 1)) + size;
        next_page_paddr = fdta_get_phys_addr(cs, next_page_vaddr);
        if (next_page_paddr >= current_machine->ram_size)
            return;

        leaf_node_index = (paddr >> BITPAGE_LEAF_BITS) & (MIDDLE_ADDRESS_MASK);        /* leaf index of prev page */
        leaf_node = shadow_memory_table[middle_node_index]->leaf[leaf_node_index]; /* leaf node of prev page */
        if (leaf_node)
        {
            memcpy(env->taint_temps, (leaf_node->bitmap + ((paddr) & (LEAF_ADDRESS_MASK))), size_prev);
        }
        else
        {
            memcpy(env->taint_temps, zero_index, size_prev);
        }

        next_middle_node_index = next_page_paddr >> (BITPAGE_LEAF_BITS + BITPAGE_MIDDLE_BITS); /* middle index of next page */
        if (!shadow_memory_table[next_middle_node_index])
        {
            memcpy(env->taint_temps + size_prev, zero_index, size_next);
        }
        else
        {
            next_leaf_node_index = (next_page_paddr >> BITPAGE_LEAF_BITS) & (MIDDLE_ADDRESS_MASK);   /* leaf index of next page */
            leaf_node = shadow_memory_table[next_middle_node_index]->leaf[next_leaf_node_index]; /* leaf node of next page */
            if (leaf_node)
            {
                memcpy(env->taint_temps + size_prev, leaf_node->bitmap, size_next);
            }
            else
            {
                memcpy(env->taint_temps + size_prev, zero_index, size_next);
            }
        }
    }
    else
    {
        leaf_node_index = (paddr >> BITPAGE_LEAF_BITS) & (MIDDLE_ADDRESS_MASK);
        leaf_node = shadow_memory_table[middle_node_index]->leaf[leaf_node_index];
        if (leaf_node)
        {
            memcpy(env->taint_temps, (leaf_node->bitmap + ((paddr) & (LEAF_ADDRESS_MASK))), size);
        }
        else
        {
            memcpy(env->taint_temps, zero_index, size);
        }
    }

    if (memcmp(env->taint_temps, zero_index, size))
    {
        if (taint_start && taint_tracking_enabled)
        {
            taint_data_flow(paddr, size, 1, env->taint_temps);
        }
    }

    if (memop_big_endian(op))
    {
        convert_endian(env->taint_temps, size);
    }

    if (memcmp(env->taint_temps, zero_index, size) && fdta_is_callback_needed(FDTAF_READ_TAINTMEM_CB))
    {
        helper_fdta_invoke_read_taint_mem(vaddr, paddr, size, env->taint_temps);
    }
    return;
}
#endif

void helper_taint_ld_mmu(CPUArchState *env, gva_t vaddr, MemOpIdx oi)
{
    taint_ld_mmu_internal(env, vaddr, oi);
}

#if 1
static void taint_st_mmu_internal(CPUArchState *env, gva_t vaddr, MemOpIdx oi)
{
    CPUState *cs = fdta_get_current_cpu();
    uint8_t changed = 0;
    uint32_t is_tainted = 0;
    uint32_t is_tainted_prev = 0;
    uint32_t is_tainted_next = 0;
    gva_t next_page_vaddr;
    ram_addr_t paddr;
    ram_addr_t next_page_paddr;
    leaf_node_t *leaf_node;
    leaf_node_t *next_leaf_node;
    MemOp op = get_memop(oi);
    unsigned size = memop_size(op);

    paddr = fdta_get_phys_addr(cs, vaddr);

    if (paddr >= current_machine->ram_size)
    {
        return;
    }

    if (!shadow_memory_table)
    {
        return;
    }

    if (!memcmp(env->taint_temps, zero_index, size))
    {
        is_tainted = 0;
    }
    else
    {
        is_tainted = 1;
        if (taint_start && taint_tracking_enabled)
        {
            taint_data_flow(paddr, size, 0, env->taint_temps);
        }
    }

    if (memop_big_endian(op))
    {
        convert_endian(env->taint_temps, size);
    }

    /* if paddr spans two pages or IO */
    if (size > 1 && unlikely((paddr & ~TARGET_PAGE_MASK) + size - 1 >= TARGET_PAGE_SIZE))
    {
        target_ulong size_prev = size - (paddr & (size - 1));
        target_ulong size_next = paddr & (size - 1);
        next_page_vaddr = (vaddr & ~((target_ulong)size - 1)) + size;
        next_page_paddr = fdta_get_phys_addr(cs, next_page_vaddr);
        if (!memcmp(env->taint_temps, zero_index, size_prev))
        { /* taint message in prev page */
            is_tainted_prev = 0;
        }
        else
        {
            is_tainted_prev = 1;
        }
        leaf_node = taint_st_general_i32(paddr, vaddr, is_tainted_prev); /* leaf_node of prev page */
        if (leaf_node)
        {
            if (!memcmp(env->taint_temps, leaf_node->bitmap + ((paddr) & (LEAF_ADDRESS_MASK)), size_prev))
            {
                changed = 1;
            }
            memcpy((leaf_node->bitmap + ((paddr) & (LEAF_ADDRESS_MASK))), env->taint_temps, size_prev);
        }
        if (!memcmp(env->taint_temps + size_prev, zero_index, size_next))
        { /* taint message in next page */
            is_tainted_next = 0;
        }
        else
        {
            is_tainted_next = 1;
        }
        next_leaf_node = taint_st_general_i32(next_page_paddr, next_page_vaddr, is_tainted_next); /* leaf_node of next page */
        if (next_leaf_node)
        {
            if (!memcmp(env->taint_temps + size_prev, next_leaf_node->bitmap, size_next))
            {
                changed = 1;
            }
            memcpy(next_leaf_node->bitmap, env->taint_temps + size_prev, size_next);
        }
        if ((is_tainted || changed) && fdta_is_callback_needed(FDTAF_WRITE_TAINTMEM_CB))
        {
            helper_fdta_invoke_write_taint_mem(vaddr, paddr, size, env->taint_temps);
        }
    }

    leaf_node = taint_st_general_i32(paddr, vaddr, is_tainted);
    if (leaf_node)
    {
        if (memcmp(env->taint_temps, leaf_node->bitmap + ((paddr) & (LEAF_ADDRESS_MASK)), size))
        {
            changed = 1;
        }
        memcpy((leaf_node->bitmap + ((paddr) & (LEAF_ADDRESS_MASK))), env->taint_temps, size);
    }
    if ((is_tainted || changed) && fdta_is_callback_needed(FDTAF_WRITE_TAINTMEM_CB))
    {
        helper_fdta_invoke_write_taint_mem(vaddr, paddr, size, env->taint_temps);
    }
    return;
}
#endif

void helper_taint_st_mmu(CPUArchState *env, gva_t vaddr, MemOpIdx oi)
{
    taint_st_mmu_internal(env, vaddr, oi);
}

void taint_mem(ram_addr_t paddr, int size, uint8_t *taint)
{
    uint32_t i, offset, len = 0;
    leaf_node_t *leaf_node = NULL;
    int is_tainted;
    uint8_t zero_mem[1 << BITPAGE_LEAF_BITS];

    FILE *taint_log_fp;
    taint_log_fp = fopen("/home/mypc/guest_taint_log", "a");
    if (taint_log_fp == NULL)
    {
        printf("open file fail\n");
        return;
    }
    fprintf(taint_log_fp, "---- INITIAL TAINT MARKING ----\n");
    for (int i = 0; i < size; i++)
    {
        fprintf(taint_log_fp, "%08lx\t", paddr + i);
    }
    fprintf(taint_log_fp, "\n---- INITIAL TAINT MARKING ----\n");
    fclose(taint_log_fp);

    bzero(zero_mem, sizeof(zero_mem));

    for (i = 0; i < size; i += len)
    {
        offset = (paddr + i) & (LEAF_ADDRESS_MASK);
        len = MIN((1 << BITPAGE_LEAF_BITS) - offset, size - i);
        is_tainted = (memcmp(taint + i, zero_mem, len) != 0);

        // the name of this function is a little misleading.
        // What we want is to get a leaf_node based on the address.
        // We set vaddr as zero, so it may flush the entire TLB if a new tainted page is found.
        leaf_node = taint_st_general_i32(paddr + i, 0, is_tainted);
        if (leaf_node)
        {
            memcpy(&leaf_node->bitmap[offset], taint + i, len);
        }
    }
}

void taint_mem_check(ram_addr_t paddr, uint32_t size, uint8_t *taint)
{
    leaf_node_t *leaf_node = NULL;
    uint32_t i, offset, len = 0;

    bzero(taint, size);
    for (i = 0; i < size; i += len)
    {
        offset = (paddr + i) & (LEAF_ADDRESS_MASK);
        len = MIN((1 << BITPAGE_LEAF_BITS) - offset, size - i);
        leaf_node = read_leaf_node_i32(paddr + i);
        if (leaf_node)
        {
            memcpy(taint + i, &leaf_node->bitmap[offset], len);
        }
    }
}

uint32_t calc_tainted_bytes(void)
{
    uint32_t tainted_bytes, i;
    uint32_t leaf_index;
    uint32_t middle_index;
    middle_node_t *middle_node = NULL;
    leaf_node_t *leaf_node = NULL;

    if (!shadow_memory_table)
        return 0;
    tainted_bytes = 0;
    for (middle_index = 0; middle_index < shadow_memory_table_root_size; middle_index++)
    {
        middle_node = shadow_memory_table[middle_index];
        if (middle_node)
        {
            for (leaf_index = 0; leaf_index < (1 << BITPAGE_MIDDLE_BITS); leaf_index++)
            {
                leaf_node = middle_node->leaf[leaf_index];
                if (leaf_node)
                {
                    for (i = 0; i < (1 << BITPAGE_LEAF_BITS); i++)
                    {
                        if (leaf_node->bitmap[i])
                            tainted_bytes++;
                    }
                }
            }
        }
    }
    return tainted_bytes;
}

#if 1
static void debug_func1(void)
{
}
#endif

int check_taint_pc(CPUArchState *env)
{
#ifdef TARGET_MIPS
    if (env->active_tc.taint_PC || env->active_tc.taint_gpr[25] || env->active_tc.taint_gpr[24])
    {
        debug_func1();
        printf("PC HAS BEEN TAINTED!\n");
        return 1;
    }
    else
    {
        return 0;
    }
#elif defined(TARGET_I386)
    target_ulong taint_cs_base = env->taint_segs[R_CS].base;
    target_ulong taint_pc = env->taint_eip;
    if (taint_pc || taint_cs_base)
    {
        debug_func1();
        printf("PC HAS BEEN TAINTED!\n");
        return 1;
    }
    else
    {
        return 0;
    }
#elif defined(TARGET_ARM)
    if (env->taint_regs[15])
    {
        debug_func1();
        printf("PC HAS BEEN TAINTED!\n");
        return 1;
    }
    else
    {
        return 0;
    }
#else
    return 0;
#endif
}

/* init shadow memory */
void shadow_memory_init(void)
{
    if (taint_tracking_enabled)
    {
        allocate_taint_memory();
    }
}