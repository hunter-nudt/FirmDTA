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
#ifndef FDTAF_MAIN_INTERNAL_H
#define FDTAF_MAIN_INTERNAL_H

#include "monitor/monitor-internal.h"
#include "shared/fdta-types-common.h"


#ifdef __cplusplus
extern "C" 
{
#endif

/**
 * Flush related structs AVB
 */
typedef struct __flush_node flush_node;
typedef struct __flush_list flush_list;

typedef struct __flush_node{
	int type; //Type of cache to flush
	unsigned int addr;
	flush_node *next;
} flush_node;

typedef struct __flush_list {
	flush_node *head;
	size_t size;
} flush_list;

extern flush_list flush_list_internal;

extern void flush_list_insert(flush_list *list, int type, uint32_t addr);

void fdta_nic_receive(uint8_t * buf, int size, int cur_pos, int start, int stop);
void fdta_nic_send(uint32_t addr, int size, uint8_t * buf);

/****** Functions used internally ******/
extern void fdta_init(void);

#ifdef __cplusplus
}
#endif

#endif //FDTAF_MAIN_INTERNAL_H