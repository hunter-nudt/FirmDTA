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
/**
 * FDTAF_types.h
 * Some defines for commonly used types
 * @author: Lok Yan
 * @date: 19 SEP 2012
 * 
 * @auther: aspen
 * @date: 31 Oct 2022
*/

#ifndef FDTAF_TYPES_COMMON_H
#define FDTAF_TYPES_COMMON_H

#include "qemu/osdep.h"
#include "cpu-param.h"

#ifdef __cplusplus
extern "C"
{
#endif

#ifndef TARGET_LONG_BITS
# error TARGET_LONG_BITS must be defined in cpu-param.h
#endif

#define TARGET_LONG_SIZE (TARGET_LONG_BITS / 8)

#if TARGET_LONG_SIZE == 4
typedef int32_t fdta_target_long;
typedef uint32_t fdta_target_ulong;
#elif TARGET_LONG_SIZE == 8
typedef int64_t fdta_target_long;
typedef uint64_t fdta_target_ulong;
#else
# error TARGET_LONG_SIZE undefined
#endif

typedef fdta_target_ulong gva_t;
typedef fdta_target_ulong gpa_t;

#if __WORDSIZE == 64
    typedef uint64_t hva_t;
    typedef uint64_t hpa_t;
#else
    typedef uint32_t hva_t;
    typedef uint32_t hpa_t;
#endif

typedef uintptr_t fdta_handle;
#define FDTAF_NULL_HANDLE ((uintptr_t)NULL)

//Used for addresses since -1 is a rarely used-if ever 32-bit address
#define INV_ADDR ((uint32_t) -1)   // 0xFFFFFFFF is only for 32-bit

#define INV_OFFSET ((uint32_t) -1)

#define INV_UINT ((uint32_t) -1)


/**
 * ERRORCODES
 */

typedef int fdta_errno_t;
/**
 * Returned when a pointer is NULL when it should not have been
 */
#define NULL_POINTER_ERROR (-101)

/**
 * Returned when a pointer already points to something, although the function is expected to malloc a new area of memory.
 * This is used to signify that there is a potential for a memory leak.
 */
#define NON_NULL_POINTER_ERROR (-102)

/**
 * Returned when malloc fails. Out of memory.
 */
#define OOM_ERROR (-103)

/**
 * Returned when there is an error reading memory - for the guest.
 */
#define MEM_READ_ERROR (-104)
#define FILE_OPEN_ERROR (-105)
#define FILE_READ_ERROR (-105)
#define FILE_WRITE_ERROR (-105)

/**
 * Returned by functions that needed to search for an item before it can continue, but couldn't find it.
 */
#define ITEM_NOT_FOUND_ERROR (-106)

/**
 * Returned when one of the parameters into the function doesn't check out.
 */
#define PARAMETER_ERROR (-107)

#ifdef __cplusplus
}
#endif

#endif  /* FDTAF_TYPES_COMMON_H */
