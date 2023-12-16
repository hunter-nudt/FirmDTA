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
 * Output.c
 *
 *    Created on: Sep 29, 2011
 *            Author: lok
 *    changed on: Oct 24, 2022
 *            author: aspen
 */

#include "shared/fdta-output.h"
#include "monitor/monitor.h"

// file pointers should never be in the kernel memory range so this should work
static const void* FDTAF_OUTPUT_MONITOR_FD = (void*)0xFEEDBEEF;

FILE* ofp = NULL;
Monitor* p_mon = NULL;

void fdta_printf(const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    fdta_vprintf(ofp, fmt, ap);
    va_end(ap);
}

void fdta_fprintf(FILE* fp, const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    if ( (p_mon != NULL) && (((void*)fp == (void*)p_mon) || (fp == FDTAF_OUTPUT_MONITOR_FD)) )
    {
        monitor_vprintf(p_mon, fmt, ap);
    }
    else
    {
        fdta_vprintf(fp, fmt, ap);
    }
    va_end(ap);
}

void fdta_mprintf(const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    if (p_mon != NULL)
    {
        monitor_vprintf(p_mon, fmt, ap);
    }
    else
    {
        vprintf(fmt, ap);
    }
    va_end(ap);
}

void fdta_vprintf(FILE* fp, const char *fmt, va_list ap)
{
    if (fp == NULL)
    {
        //that means either use stdout or monitor
        if (p_mon != NULL)
        {
            monitor_vprintf(p_mon, fmt, ap);
        }
        else
        {
            vprintf(fmt, ap);
        }
    }
    else
    {
        vfprintf(fp, fmt, ap);
    }
}

void fdta_flush(void)
{
    fdta_fflush(ofp);
}

void fdta_fflush(FILE* fp)
{
    if (fp == NULL)
    {
        if (p_mon != NULL)
        {
            //nothing to do here
        }
        else
        {
            fflush(stdout);
        }
    }
    else
    {
        fflush(fp);
    }
}

void fdta_do_set_output_file(Monitor *mon, const char* fileName)
{
    if (ofp != NULL)
    {
        return;
    }

    if (strcmp(fileName, "stdout") == 0)
    {
        fdta_output_cleanup();
        return;
    }
    p_mon = mon; //make a local copy of the monitor
    //open the file
    ofp = fopen(fileName, "w");
    if (ofp == NULL)
    {
        fdta_printf("Could not open the file [%s]\n", fileName);
    }
}

void fdta_output_init(Monitor *mon)
{
    if (mon != NULL)
    {
        p_mon = mon;
    }
    else
    {
        return;
    }
}

void fdta_output_cleanup(void)
{
    if (ofp != NULL)
    {
        fflush(ofp);
        fclose(ofp);
    }
    ofp = NULL;
    p_mon = NULL;
}


FILE* fdta_get_output_fp(void)
{
    return (ofp);
}

Monitor* fdta_get_output_mon(void)
{
    return (p_mon);
}

const FILE* fdta_get_monitor_fp(void)
{
    return (FDTAF_OUTPUT_MONITOR_FD);
}

// void test_hello(void)
// {
//     printf("hello world!\n");
// }