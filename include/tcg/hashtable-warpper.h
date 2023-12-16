/*
Copyright (C) <2012> <Syracuse System Security (Sycure) Lab>

FDTAF is based on QEMU, a whole-system emulator. You can redistribute
and modify it under the terms of the GNU LGPL, version 2.1 or later,
but it is made available WITHOUT ANY WARRANTY. See the top-level
README file for more details.

For more information about FDTAF and other softwares, see our
web site at:
http://sycurelab.ecs.syr.edu/

If you have any questions about FDTAF,please post it on
http://code.google.com/p/fdta-platform/
*/
/*
 * hashtable-wrapper.h
 *
 *  Created on: Dec 21, 2011
 *      Author: lok
 */

#ifndef HASHTABLEWRAPPER_H
#define HASHTABLEWRAPPER_H

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdio.h>
#include "qemu/osdep.h"
#include "qemu/host-utils.h"
#include "cpu.h"


//A regular unordered hashtable
typedef struct hashtable hashtable;
//A regular unordered hashmap
typedef struct hashmap hashmap;
//An unordered hashtable that also maintains a count
// of the number of times a certain key has been added
// and decremented when a key is removed
typedef struct counting_hashtable counting_hashtable;
//Similar to the counting hashtable
typedef struct counting_hashmap counting_hashmap;

hashtable* hashtable_new(void);
void hashtable_free(hashtable* p_table);
int hashtable_add(hashtable* p_hash, uint32_t item);
int hashtable_remove(hashtable* p_hash, uint32_t item);
int hashtable_exist(hashtable* p_hash, uint32_t item);
void hashtable_print(FILE* fp, hashtable* p_hash);

counting_hashtable* counting_hashtable_new(void);
void counting_hashtable_free(counting_hashtable* p_table);
/** Returns the count for the key **/
uint32_t counting_hashtable_add(counting_hashtable* p_hash, uint32_t item);
/** Returns the count for the key **/
uint32_t counting_hashtable_remove(counting_hashtable* p_hash, uint32_t item);
int counting_hashtable_exist(counting_hashtable* p_hash, uint32_t item);
uint32_t counting_hashtable_count(counting_hashtable* p_table, uint32_t key);
void counting_hashtable_print(FILE* fp, counting_hashtable* p_hash);

hashmap* hashmap_new(void);
void hashmap_free(hashmap* p_map);
int hashmap_add(hashmap* p_map, uint32_t key, uint32_t val);
int hashmap_remove(hashmap* p_map, uint32_t key, uint32_t val);
hashtable* hashmap_gethashtable(hashmap* p_map, uint32_t key);
int hashmap_exist(hashmap* p_map, uint32_t from, uint32_t to);
void hashmap_print(FILE* fp, hashmap* p_map);

counting_hashmap* counting_hashmap_new(void);
void counting_hashmap_free(counting_hashmap* p_map);
uint32_t counting_hashmap_add(counting_hashmap* p_map, uint32_t key, uint32_t val);
uint32_t counting_hashmap_remove(counting_hashmap* p_map, uint32_t key, uint32_t val);
counting_hashtable* counting_hashmap_getcounting_hashtable(counting_hashmap* p_map, uint32_t key);
int counting_hashmap_exist(counting_hashmap* p_map, uint32_t from, uint32_t to);
void counting_hashmap_print(FILE* fp, counting_hashmap* p_map);

#ifdef __cplusplus
}
#endif
#endif /* HASHTABLEWRAPPER_H_ */
