
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


 * linux_vmi_new.h
 *
 *  Created on: June 26, 2015
 *      Author: Abhishek V B
 *  changed on: Nov 3, 2022
 *      author: aspen
 */


#ifndef FDTAF_LINUX_VMI_H
#define FDTAF_LINUX_VMI_H

#include "shared/fdta-types-common.h"


#ifdef __cplusplus
extern "C" 
{
#endif

#define GUEST_OS_THREAD_SIZE 8192

#define SIZEOF_COMM 16

int find_linux(CPUState *cs);
void linux_vmi_init(void);
void traverse_mmap(CPUState *cs, void *opaque);
void print_loaded_modules(CPUState *cs);
void traverse_task_struct_add(CPUState *cs);

#ifdef __cplusplus
}
#endif

#endif /* FDTAF_LINUX_VMI_H */


