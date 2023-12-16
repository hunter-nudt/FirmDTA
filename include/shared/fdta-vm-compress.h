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
#ifndef FDTAF_VM_COMPRESS_H
#define FDTAF_VM_COMPRESS_H

#define IOBUF_SIZE 4096

#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

#include "hw/hw.h" // AWH
#include <zlib.h>
#include <stdint.h>

typedef struct{
    z_stream zstream;
    void *f;
    uint8_t buf[IOBUF_SIZE];
} FDTAF_CompressState_t;

extern int fdta_compress_open(FDTAF_CompressState_t *s, void *f);
extern int fdta_compress_buf(FDTAF_CompressState_t *s, const uint8_t *buf, int len);
extern void fdta_compress_close(FDTAF_CompressState_t *s);
extern int fdta_decompress_open(FDTAF_CompressState_t *s, void *f);
extern int fdta_decompress_buf(FDTAF_CompressState_t *s, uint8_t *buf, int len);
extern void fdta_decompress_close(FDTAF_CompressState_t *s);
extern void fdta_vm_compress_init(void); //dummy init

#ifdef __cplusplus
}
#endif // __cplusplus

#endif //FDTAF_VM_COMPRESS_H
