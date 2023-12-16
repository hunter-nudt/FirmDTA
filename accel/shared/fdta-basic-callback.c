/*
 * fdta-basic-callback.c
 *
 *  Created on: Nov 14, 2022
 *      Author: aspen
 */

#include "shared/fdta-basic-callback.h"

basic_callback_t* basic_callback_new(void)
{
    basic_callback_t* pList = (basic_callback_t*)malloc(sizeof(basic_callback_t));
    if (pList == NULL)
    {
        return (NULL);
    }
    QLIST_INIT(pList);
    return (pList);
}

fdta_errno_t basic_callback_init(basic_callback_t* pList)
{
    if (pList == NULL)
    {
        return (NULL_POINTER_ERROR);
    }
    QLIST_INIT(pList);
    return (0);
}

fdta_errno_t basic_callback_clear(basic_callback_t* pList)
{
    basic_callback_entry_t *cb_struct = NULL;
    if (pList == NULL)
    {
        return (NULL_POINTER_ERROR);
    }
    while (!QLIST_EMPTY(pList))
    {
        QLIST_REMOVE(QLIST_FIRST(pList), link);
        free(cb_struct);
    }
    return (0);
}

fdta_errno_t basic_callback_delete(basic_callback_t* pList)
{
    if (pList == NULL)
    {
        return (NULL_POINTER_ERROR);
    }
    basic_callback_clear(pList);
    free(pList);
    return (0);
}

void basic_callback_dispatch(basic_callback_t* pList, void* params)
{
    basic_callback_entry_t *cb_struct, *cb_temp;

    if (pList == NULL)
    {
        return; // (NULL_POINTER_ERROR);
    }

    //FIXME: not thread safe
    QLIST_FOREACH_SAFE(cb_struct, pList, link, cb_temp) 
    {
        if(cb_struct->enabled)
            cb_struct->callback(params);
    }
}

// this is for backwards compatibility -
// for block begin and end - we make a call to the optimized versions
// for insn begin and end we just use the old logic
fdta_handle basic_callback_register(
    basic_callback_t* pList,
    basic_callback_func_t cb_func,
    int cb_cond)
{
    if (pList == NULL)
    {
        return (FDTAF_NULL_HANDLE);
    }

    basic_callback_entry_t* cb_struct = (basic_callback_entry_t*)malloc(sizeof(basic_callback_entry_t));
    if (cb_struct == NULL)
    {
        return (FDTAF_NULL_HANDLE);
    }

    cb_struct->callback = cb_func;
    cb_struct->enabled = cb_cond;

    QLIST_INSERT_HEAD(pList, cb_struct, link);

    return (fdta_handle)cb_struct;
}

fdta_errno_t basic_callback_unregister(basic_callback_t* pList, fdta_handle handle)
{
    basic_callback_entry_t *cb_struct = NULL, *cb_temp;
    if (pList == NULL)
    {
        return (NULL_POINTER_ERROR);
    }

    //FIXME: not thread safe
    QLIST_FOREACH_SAFE(cb_struct, pList, link, cb_temp) 
    {
        if((fdta_handle)cb_struct != handle)
            continue;

        QLIST_REMOVE(cb_struct, link);
        free(cb_struct);
        return 0;
    }

    return (ITEM_NOT_FOUND_ERROR);
}