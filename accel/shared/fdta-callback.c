/*
Copyright (C) <2012> <Syracuse System Security (Sycure) Lab>

FDTAF is based on QEMU, a whole-system emulator. You can redistribute
and modify it under the terms of the GNU GPL, version 3 or later,
but it is made available WITHOUT ANY WARRANTY. See the top-level
README file for more details.

For more information about FDTAF and other softwares, see our
web site at:
http://sycurelab.ecs.syr.edu/

If you have any questions about FDTAF,please post it on
http://code.google.com/p/fdta-platform/
*/
/*
 * FDTAF_callback.c
 *
 *  Created on: Apr 10, 2012
 *      Author: heyin@syr.edu
 *  changed on: Nov 18, 2022
 *      Author: Aspen
 */

#include "qemu/osdep.h"
#include "qemu-common.h"
#include "shared/fdta-types-common.h"
#include "exec/exec-all.h"
#include "exec/cpu-defs.h"
#include "exec/helper-proto.h"
#include "exec/translator.h"

#include "shared/fdta-hashtable-wrapper.h"
#include "shared/fdta-callback-common.h"
#include "shared/fdta-callback-to-qemu.h"

#include "shared/fdta-main.h"

#include <sys/queue.h>

#if !defined(CONFIG_USER_ONLY)

#if defined(TARGET_I386) && (HOST_LONG_BITS == 64)
//#warning 64-bit macro
#define PUSH_ALL() __asm__ __volatile__ ("push %rax\npush %rcx\npush %rdx");
#define POP_ALL() __asm__ __volatile__ ("pop %rdx\npop %rcx\npop %rax");
#elif defined(TARGET_I386) && (HOST_LONG_BITS == 32)
//#warning 32-bit macro
#define PUSH_ALL() __asm__ __volatile__ ("push %eax\npush %ecx\npush %edx");
#define POP_ALL() __asm__ __volatile__ ("pop %edx\npop %ecx\npop %eax");
#else
//#warning Dummy PUSH_ALL() and POP_ALL() macros
#define PUSH_ALL() ;
#define POP_ALL() ;
#endif // AWH

// LOK: The callback logic is separated into two parts
//  1. the interface between QEMU and callback
//    this is invoked during translation time
//  2. the interface between the callback and the plugins
//    this is invoked during execution time
// The basic idea is to provide a rich interface for users
//  while abstracting and hiding all of the details

// Currently we support callbacks for instruction begin/end and
// basic block begin and end. Basic block level callbacks can
// also be optimized. There are two types of optimized callbacks
// constant (OCB_CONST) and page (OCB_PAGE). The idea begin
// the constant optimized callback type is that
// function level hooking only needs to know when the function
// starts and returns, both of which are hard target addresses.
// The idea behind the page level callback is for API level
// instrumentation where modules are normally separated at the
// page level. Block end callbacks are a little bit special
// since the callback can be set for both the 'from' and 'to'
// addresses. In this way, you can specify callbacks only for
// the transitions between a target module and the libc library
// for example. For simplicity sake we only provide page-level optimized
// callback support for block ends. Supporting it at the individual
// address level seemed like overkill - n^2 possible combinations.
// Todo: Future implementations should include support for the NOT
// condition for the optimized callbacks. This capability can be used
// for specifying all transitions from outside of a module into a module.
// for example it would be specified as block end callbacks where from
// is NOT module_page and to is module_page.


//We begin by declaring the necessary data structures
// for determining whether a callback is necessary
//These are declared if all block begins and ends
// are needed.
static int bEnableAllBlockBeginCallbacks = 0;
//We keep a count of the number of registered callbacks that
// need all of the block begins and ends so that we can turn
// on or off the optimized callback interface. The complete
// translation cache is flushed when the count goes from 0 to 1
// and from 1 downto 0
static int enableAllBlockBeginCallbacksCount = 0;


//We use hashtables to keep track of individual basic blocks
// that is associated with a callback - we ignore
// the conditional that is registered with the callback
// right now - that is the conditional has been changed
// into a simple "enable" bit. The reasoning is that the condition is controlled
// by the user, and so there is no way for us to update
// the hashtables accordingly.
//Specifically, we use a counting hashtable (essentially a hashmap)
// where the value is the number of callbacks that have registered for
// this particular condition. The affected translation block
// is flushed at the 0 to 1 or 1 to 0 transitions.
static counting_hashtable* pOBBTable;	//optimized block begin table

//A second page table at the page level
//There are two different hashtables so that determining
// whether a callback is needed at translation time (stage 1)
// can be done in the order of - allBlockBegins, Page level and then
// individual address or constant level.
static counting_hashtable* pOBBPageTable;

//data structures for storing the userspace callbacks (stage 2)
typedef struct callback_struct{
	int enabled;
	//the following are used by the optimized callbacks
	//BlockBegin only uses from - to is ignored
	//blockend uses both from and to
	gva_t from;
	gva_t to;
	OCB_t ocb_type;

	fdta_callback_func_t callback;
	QLIST_ENTRY(callback_struct) link;
} callback_struct;

// Each type of callback has its own callback_list
// The callback list is used to maintain the list of registered callbacks
// as well as their conditions. In essense, this data structure
// is used for interfacing with the user (stage 2)
static QLIST_HEAD(callback_list_head, callback_struct) callback_list_heads[FDTAF_LAST_CB];

//Aravind - Serialized callbacks. 000 to 1ff, 1xx == 0fxx (for two byte opcodes)
static callback_struct* instructionCallbacks[0x200] = {0};

/***********************************************************************************************/

fdta_handle fdta_register_optimized_block_begin_callback(
    fdta_callback_func_t cb_func,
    int cb_cond,
    gva_t addr,
    OCB_t type)
{
    callback_struct * cb_struct = (callback_struct *)g_malloc(sizeof(callback_struct));
    if (cb_struct == NULL) {
        return (FDTAF_NULL_HANDLE);
    }

    //Heng: Optimization on OCB_CONST is not stable. We use OCB_ALL instead for now.
    if (type == OCB_CONST) type = OCB_ALL;

    //pre-populate the info
    cb_struct->callback = cb_func;
    cb_struct->enabled = cb_cond;
    cb_struct->from = addr;
    cb_struct->to = INV_ADDR;
    cb_struct->ocb_type = type;

    switch (type)
    {
        default:
        case (OCB_ALL):
        {
            //call the original
            bEnableAllBlockBeginCallbacks = 1;
            enableAllBlockBeginCallbacksCount++;

            //we need to flush if it just transitioned from 0 to 1
            if (enableAllBlockBeginCallbacksCount == 1)
            {
                // Perhaps we should flush ALL blocks instead of
                // just the ones associated with this cs?
                // tlb_flush() does that exactly
                register_fdta_flush_translation_cache(ALL_CACHE, 0);
            }
            break;
        }
        // case (OCB_CONST):
        // {
        //     if (pOBBTable == NULL)
        //     {
        //         g_free(cb_struct);
        //         return (FDTAF_NULL_HANDLE);
        //     }
        //     //This is not necessarily thread-safe
        //     if (counting_hashtable_add(pOBBTable, addr) == 1)
        //     {
        //         register_fdta_flush_translation_cache(BLOCK_LEVEL, addr);
        //     }
        //     break;
        // }
        case (OCB_CONST_NOT):
        {
            break;
        }
        case (OCB_PAGE_NOT):
        {
            break;
        }
        case (OCB_PAGE):
        {
            addr &= TARGET_PAGE_MASK;
            if (pOBBPageTable == NULL) {
                g_free(cb_struct);
                return (FDTAF_NULL_HANDLE);
            }

            //This is not necessarily thread-safe
            if (counting_hashtable_add(pOBBPageTable, addr) == 1) {
                register_fdta_flush_translation_cache(PAGE_LEVEL, addr);
            }
            break;
        }
    }

    //insert it into the list
    QLIST_INSERT_HEAD(&callback_list_heads[FDTAF_BLOCK_BEGIN_CB], cb_struct, link);
    return ((fdta_handle)cb_struct);
}

fdta_errno_t fdta_unregister_optimized_block_begin_callback(fdta_handle handle)
{
	callback_struct *cb_struct, *cb_next;

	// to unregister the callback, we have to first find the
	// callback and its conditions and then remove it from the
	// corresonding hashtable

	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_BLOCK_BEGIN_CB], link, cb_next) {
		if((fdta_handle)cb_struct != handle)
			continue;

		//now that we have found it - check out its conditions
		switch(cb_struct->ocb_type)
		{
			default: //same as ALL to match the register function
			case (OCB_ALL):
            {
                enableAllBlockBeginCallbacksCount--;
                if (enableAllBlockBeginCallbacksCount == 0)
                {
                    bEnableAllBlockBeginCallbacks = 0;
                    //if its now zero flush the cache
                    register_fdta_flush_translation_cache(ALL_CACHE, 0);
                }
                else if (enableAllBlockBeginCallbacksCount < 0)
                {
                    // if it underflowed then reset to 0
                    // this is really an error
                    // notice I don't reset enableallblockbegincallbacks to 0
                    // just in case
                    enableAllBlockBeginCallbacksCount = 0;
                }
                break;
            }
			// case (OCB_CONST):
            // {
            //     if (pOBBTable == NULL)
            //     {
            //         return (NULL_POINTER_ERROR);
            //     }
            //     if (counting_hashtable_remove(pOBBTable, cb_struct->from) == 0)
            //     {
            //         register_fdta_flush_translation_cache(BLOCK_LEVEL, cb_struct->from);
            //     }
            //     break;
            // }
			case (OCB_PAGE):
            {
                if (pOBBPageTable == NULL)
                {
                    return (NULL_POINTER_ERROR);
                }
                if (counting_hashtable_remove(pOBBPageTable, cb_struct->from) == 0)
                {
                    register_fdta_flush_translation_cache(PAGE_LEVEL, cb_struct->from);
                }
                break;
            }
		}

		//now that we cleaned up the hashtables - we should remove the callback entry
		QLIST_REMOVE(cb_struct, link);
		//and free the struct
		g_free(cb_struct);

		return 0;
	}
	return -1;
}

// this is for backwards compatibility -
// for block begin and end - we make a call to the optimized versions
// for insn begin and end we just use the old logic
// for mem read and write ,use the old logic
fdta_handle fdta_register_callback(
    fdta_callback_type_t cb_type,
    fdta_callback_func_t cb_func,
    int cb_cond)
{
    if (cb_type == FDTAF_BLOCK_BEGIN_CB)
    {
        return(fdta_register_optimized_block_begin_callback(cb_func, cb_cond, INV_ADDR, OCB_ALL));
    }

    callback_struct * cb_struct = (callback_struct *)g_malloc(sizeof(callback_struct));

    if(cb_struct == NULL)
        return (FDTAF_NULL_HANDLE);

    cb_struct->callback = cb_func;
    cb_struct->enabled = cb_cond;


    if(cb_type == FDTAF_TLB_EXEC_CB)
	    goto insert_callback; //Should not flush for tlb callbacks since they don't go into tb.

// AVB ,Do we need a flush here?
    if(QLIST_EMPTY(&callback_list_heads[cb_type]))
        register_fdta_flush_translation_cache(ALL_CACHE, 0);

insert_callback:
    QLIST_INSERT_HEAD(&callback_list_heads[cb_type], cb_struct, link);
    return (fdta_handle)cb_struct;
}

int fdta_unregister_callback(fdta_callback_type_t cb_type, fdta_handle handle)
{
    if (cb_type == FDTAF_BLOCK_BEGIN_CB)
    {
        return (fdta_unregister_optimized_block_begin_callback(handle));
    }

    callback_struct *cb_struct, *cb_next;
    //FIXME: not thread safe
    QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[cb_type], link, cb_next) {
        if((fdta_handle)cb_struct != handle)
            continue;

        QLIST_REMOVE(cb_struct, link);
        g_free(cb_struct);

        if(cb_type == FDTAF_TLB_EXEC_CB) {
            goto done;
        }

        if(QLIST_EMPTY(&callback_list_heads[cb_type])) {
            register_fdta_flush_translation_cache(ALL_CACHE, 0);
        }
done:
        return 0;
    }
    return -1;
}

void fdta_callback_init(void)
{
    int i;

    for(i=0; i<FDTAF_LAST_CB; i++)
        QLIST_INIT(&callback_list_heads[i]);

    pOBBTable = counting_hashtable_new();
    pOBBPageTable = counting_hashtable_new();

    bEnableAllBlockBeginCallbacks = 0;
    enableAllBlockBeginCallbacksCount = 0;
}
/***********************************************************************************************/

// LOK: I turned this into a dumb function
// and so we can have the more specialized helper functions
// for the block begin and block end callbacks
int fdta_is_callback_needed(fdta_callback_type_t cb_type)
{
    return !QLIST_EMPTY(&callback_list_heads[cb_type]);
}

int fdta_is_callback_needed_for_opcode(int op)
{
	if(op < 0x200 && instructionCallbacks[op] != NULL)
		return 1;

	return 0;
}

//here we search from the broadest to the narrowest
// to determine whether the callback is needed
int fdta_is_block_begin_callback_needed(gva_t pc)
{
    //go through the page list first
    if (bEnableAllBlockBeginCallbacks)
    {
        return (1);
    }

    if (counting_hashtable_exist(pOBBPageTable, pc & TARGET_PAGE_MASK))
    {
        return (1);
    }

    if (counting_hashtable_exist(pOBBTable, pc))
    {
        return (1);
    }

    return 0;
}

/***********************************************************************************************/

void helper_fdta_invoke_block_begin_callback(CPUState* cs, TranslationBlock* tb)
{
    static callback_struct *cb_struct, *cb_next;
    static fdta_callback_params params;

    if ((cs == NULL) || (tb == NULL))
    {
        return;
    }

    params.bb.cs = cs;
    params.bb.tb = tb;

    PUSH_ALL()

    //FIXME: not thread safe
    QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_BLOCK_BEGIN_CB], link, cb_next){
        // If it is a global callback or it is within the execution context,
        // invoke this callback
        if(cb_struct->enabled){
            params.cbhandle = (fdta_handle)cb_struct;
            switch (cb_struct->ocb_type)
            {
                default:
                case (OCB_ALL):
                {
                    cb_struct->callback(&params);
                    break;
                }
                // case (OCB_CONST):
                // {
                //     if (cb_struct->from == tb->pc)
                //     {
                //         cb_struct->callback(&params);
                //     }
                //     break;
                // }
                case (OCB_PAGE):
                {
                    if ((cb_struct->from & TARGET_PAGE_MASK) == (tb->pc & TARGET_PAGE_MASK))
                    {
                        cb_struct->callback(&params);
                    }
                    break;
                }
            }
        }
    }
    POP_ALL()
}

void helper_fdta_invoke_block_end_callback(CPUState *cs, TranslationBlock *tb, gva_t from)
{
    static callback_struct *cb_struct, *cb_next;
    static fdta_callback_params params;

    if (cs == NULL) return;

    params.be.cs = cs;
    params.be.tb = tb;

    PUSH_ALL()

    //FIXME: not thread safe
    QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_BLOCK_END_CB], link, cb_next) {
        // If it is a global callback or it is within the execution context,
        // invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
        if(cb_struct->enabled)
        {
            cb_struct->callback(&params);
        }
    }
    POP_ALL()
}

void helper_fdta_invoke_insn_before_callback(CPUState *cs, uint32_t pc, uint32_t mips_opcode)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;

	if (cs == 0) return;

	params.ib.cs = cs;
    params.ib.pc_first = pc;
    params.ib.mips_opcode = mips_opcode;
    PUSH_ALL()
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_INSN_BEFORE_CB], link, cb_next) {
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if(cb_struct->enabled)
			cb_struct->callback(&params);
	}
    POP_ALL()
}

void helper_fdta_invoke_insn_after_callback(CPUState *cs)
{
	static callback_struct *cb_struct, *cb_next;
    static fdta_callback_params params;

	if (cs == 0) return;
	params.ia.cs = cs;
    PUSH_ALL()
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_INSN_AFTER_CB], link,cb_next) {
		// If it is a global callback or it is within the execution context,
		// invoke this callback
	    params.cbhandle = (fdta_handle)cb_struct;
		if(cb_struct->enabled)
			cb_struct->callback(&params);
	}
    POP_ALL()
}

void helper_fdta_invoke_eip_check_callback(gva_t source_eip, gva_t target_eip, gva_t target_eip_taint)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;

	params.ec.source_eip = source_eip;
    params.ec.target_eip = target_eip;
    params.ec.target_eip_taint = target_eip_taint;
    PUSH_ALL()
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_EIP_CHECK_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled) {
			cb_struct->callback(&params);
		}
	}
	POP_ALL() // AWH
}

void fdta_invoke_tlb_exec_callback(CPUState *cs, gva_t vaddr)
{
    callback_struct *cb_struct, *cb_next;
    fdta_callback_params params;

    if ((cs == NULL) || (vaddr == 0)) {
        return;
    }
    params.tx.cs = cs;
    params.tx.vaddr = vaddr;
    QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_TLB_EXEC_CB], link, cb_next) {
        if(cb_struct->enabled) {
            cb_struct->callback(&params);
        }
    }
}


void helper_fdta_invoke_nic_rec_callback(uint8_t * buf, int size, int cur_pos, int start, int stop)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;
	params.nr.buf = buf;
	params.nr.size = size;
	params.nr.cur_pos = cur_pos;
	params.nr.start = start;
	params.nr.stop = stop;
    PUSH_ALL()
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_NIC_REC_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled) {
            cb_struct->callback(&params);
        }	
	}
    POP_ALL()
}

void helper_fdta_invoke_nic_send_callback(uint32_t addr, int size, uint8_t *buf)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;
	params.ns.addr = addr;
	params.ns.size = size;
	params.ns.buf = buf;
    PUSH_ALL() // AWH
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_NIC_SEND_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled)
			cb_struct->callback(&params);
	}
    POP_ALL() // AWH
}

void helper_fdta_invoke_mem_read_callback(gva_t vaddr, ram_addr_t paddr, unsigned long value, DATA_TYPE data_type)
{
    static callback_struct *cb_struct, *cb_next;
    static fdta_callback_params params;
    params.mr.dt = data_type;
    params.mr.paddr = paddr;
    params.mr.vaddr = vaddr;
    params.mr.value = value;
    //if (cpu_single_cs == 0) return;
    PUSH_ALL()
    //FIXME: not thread safe
    QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_MEM_READ_CB], link, cb_next)
    {
        // If it is a global callback or it is within the execution context,
        // invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
        if (cb_struct->enabled) {
            cb_struct->callback(&params);
        }
    }
    POP_ALL()
}

void helper_fdta_invoke_mem_write_callback(gva_t vaddr, ram_addr_t paddr, unsigned long value, DATA_TYPE data_type)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;
	params.mw.dt = data_type;
    params.mw.paddr = paddr;
	params.mw.vaddr = vaddr;
    params.mw.value = value;
    PUSH_ALL()
	//if (cpu_single_cs == 0) return;

	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_MEM_WRITE_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled)
			cb_struct->callback(&params);
	}
    POP_ALL()
}

void helper_fdta_invoke_keystroke_callback(int keycode, uint32_t *taint_mark)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;
	params.ks.keycode=keycode;
	params.ks.taint_mark=taint_mark;
	//if (cpu_single_cs == 0) return;

	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_KEYSTROKE_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled) {
			cb_struct->callback(&params);
		}
	}
}

void helper_fdta_invoke_read_taint_mem(gva_t vaddr, ram_addr_t paddr, uint32_t size, uint8_t *taint_info)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;
	params.rt.vaddr = vaddr;
    params.rt.paddr = paddr;
	params.rt.size = size;
	params.rt.taint_info = taint_info;
    PUSH_ALL()
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_READ_TAINTMEM_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled)
			cb_struct->callback(&params);
	}
    POP_ALL()
}

void helper_fdta_invoke_write_taint_mem(gva_t vaddr, ram_addr_t paddr, uint32_t size, uint8_t *taint_info)
{
	static callback_struct *cb_struct, *cb_next;
	static fdta_callback_params params;
	params.wt.paddr = paddr;
	params.wt.vaddr = vaddr;
	params.wt.size = size;
	params.wt.taint_info = taint_info;
    PUSH_ALL()
	//FIXME: not thread safe
	QLIST_FOREACH_SAFE(cb_struct, &callback_list_heads[FDTAF_WRITE_TAINTMEM_CB], link, cb_next)
	{
		// If it is a global callback or it is within the execution context,
		// invoke this callback
        params.cbhandle = (fdta_handle)cb_struct;
		if (cb_struct->enabled)
			cb_struct->callback(&params);
	}
    POP_ALL()
}

#endif