#ifndef LINUX_READELF_H
#define LINUX_READELF_H

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

#include "exec/cpu-defs.h"

int read_elf_info(const char * mod_name, target_ulong start_addr, unsigned int inode_number);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
