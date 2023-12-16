/*
Copyright (C) <2012> <Syracuse System Security (Sycure) Lab>

fdta is based on QEMU, a whole-system emulator. You can redistribute
and modify it under the terms of the GNU LGPL, version 2.1 or later,
but it is made available WITHOUT ANY WARRANTY. See the top-level
README file for more details.

For more information about fdta and other softwares, see our
web site at:
http://sycurelab.ecs.syr.edu/

If you have any questions about fdta,please post it on
http://code.google.com/p/fdta-platform/
*/
/*
 * Output.h
 *
 *  Created on: Sep 29, 2011
 *      Author: lok
 */

#ifndef OUTPUT_H
#define OUTPUT_H

#include <stdio.h>
#include "qemu/osdep.h"
#include "monitor/monitor.h"

#ifdef __cplusplus
extern "C"
{
#endif

void fdta_printf(const char* fmt, ...);
void fdta_mprintf(const char* fmt, ...);
void fdta_fprintf(FILE* fp, const char* fmt, ...);
void fdta_vprintf(FILE* fp, const char* fmt, va_list ap);
void fdta_flush(void);
void fdta_fflush(FILE* fp);

FILE* fdta_get_output_fp(void);
Monitor* fdta_get_output_mon(void);
const FILE* fdta_get_monitor_fp(void);

void fdta_do_set_output_file(Monitor* mon, const char* fileName);
void fdta_output_init(Monitor* mon);
void fdta_output_cleanup(void);
void test_hello(void);

#ifdef __cplusplus
}
#endif

#endif /* OUTPUT_H */