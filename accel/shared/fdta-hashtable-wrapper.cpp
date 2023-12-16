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
//  * fdta-hashtable-wrapper.cpp
 *
 *  Created on: Dec 21, 2011
 *      Author: lok
 *  changed on: Oct 24, 2022
 *      author: aspen
 */

#include "shared/fdta-hashtable-wrapper.h"

#include <unordered_set>
#include <unordered_map>
using namespace std;

//hashtable
typedef unordered_set<uint32_t> uset;

hashtable* hashtable_new(void)
{
    uset* p_table = new uset();
    return ((hashtable*)p_table);
}

void hashtable_free(hashtable* p_table)
{
    if (p_table != NULL)
    {
        delete( (uset*)p_table );
    }
}

int hashtable_add(hashtable* p_hash, uint32_t item)
{
    uset* p_table = (uset*) p_hash;
    if (p_table == NULL)
    {
        return (NULL_POINTER_ERROR);
    }

    std::pair<uset::iterator, bool> ret = p_table->insert(item);
    if (ret.second)
    {
        #ifdef FDTAF_DEBUG_VERBOSE
        FDTAF_mprintf("Adding [%x]\n", item);
        #endif
        return (1);
    }
    return (0);
}

int hashtable_remove(hashtable* p_hash, uint32_t item)
{
    uset* p_table = (uset*) p_hash;
    if (p_table == NULL)
    {
        return (NULL_POINTER_ERROR);
    }
    #ifdef FDTAF_DEBUG_VERBOSE
    FDTAF_mprintf("Removing [%x]\n", item);
    #endif
    p_table->erase(item);
    return (1);
}

int hashtable_exist(hashtable* p_hash, uint32_t item)
{ 
    uset* p_table = (uset*) p_hash;
    if (p_table == NULL)
    {
        return (0);
    }
    return ((p_table->find(item)) != p_table->end());
}

void hashtable_print(FILE* fp, hashtable* p_hash)
    {
    uset* p_table = (uset*)p_hash;
    if (p_table == NULL)
    {
        return;
    }

    for (uset::const_iterator it = p_table->begin(); it != p_table->end(); it++)
    {
        fprintf(fp, "    %x\n", *it);
    }
}


//counting_hashtable
typedef unordered_map<uint32_t, uint32_t> cset;

counting_hashtable* counting_hashtable_new()
{
    return ( (counting_hashtable*)(new cset()));
}

void counting_hashtable_free(counting_hashtable* p_table)
{
    if (p_table != NULL)
    {
        delete ( (cset*)p_table );
    }
}

uint32_t counting_hashtable_add(counting_hashtable* p_table, uint32_t key)
{
    if (p_table == NULL)
    {
        return (0);
    }

    cset* p_temp = (cset*)p_table;

    //here I assume that accessing size is quicker than searching to
    // determine if the key exists - NOT THREAD SAFE
    size_t prevSize = p_temp->size();

    //get the reference to the value
    uint32_t& val = (*p_temp)[key];
    //increment it
    val++;
    //if we just increased the size (this means that this is a new key)
    // then reset the value to 1 - I do this because int is not
    // initialized to 0 by default
    if (p_temp->size() > prevSize)
    {
        val = 1;
    }

    return (val);
}

uint32_t counting_hashtable_remove(counting_hashtable* p_table, uint32_t key)
{
    //just going to use the [] operator, which happens to create a new hashtable
    // if its not there already - might change this later
    //Very similar to the add case, except we reset the uint32_t to 0
    cset* p_temp = (cset*)p_table;
    if (p_temp == NULL)
    {
        return (0);
    }

    size_t prevSize = p_temp->size();
    uint32_t& val = (*p_temp)[key];
    val--;
    if (p_temp->size() < prevSize)
    {
        val = 0;
    }

    return (val);
}

int counting_hashtable_exist(counting_hashtable* p_table, uint32_t key)
{
    if (p_table == NULL)
    {
        return (0);
    }

    cset* p_temp = (cset*)p_table;
    cset::const_iterator it = p_temp->find(key);
    if (it == p_temp->end())
    {
        return (0);
    }

    return (it->second > 0);
}

uint32_t counting_hashtable_count(counting_hashtable* p_table, uint32_t key)
{
    if (p_table == NULL)
    {
        return (0);
    }

    cset* p_temp = (cset*)p_table;
    cset::const_iterator it = p_temp->find(key);
    if (it == p_temp->end())
    {
        return (0);
    }

    return (it->second);
}

void counting_hashtable_print(FILE* fp, counting_hashtable* p_table)
{
    cset* p_temp = (cset*)p_table;

    if (p_temp == NULL)
    {
        return;
    }

    for (cset::const_iterator it = p_temp->begin(); it != p_temp->end(); it++)
    {
        if (it->second > 0)
        {
        fprintf(fp, "  %x [%u] ->\n", it->first, it->second);
        }
    }
}

//hashmap
typedef unordered_map<uint32_t, uset> umap;

hashmap* hashmap_new()
{
    return ( (hashmap*)(new umap()));
}

void hashmap_free(hashmap* p_map)
{
    if (p_map != NULL)
    {
        delete ( (umap*)p_map );
    }
}

int hashmap_add(hashmap* p_map, uint32_t key, uint32_t val)
{
    umap* p_umap = (umap*)p_map;
    if (p_umap == NULL)
    {
        return (NULL_POINTER_ERROR);
    }

    std::pair<uset::iterator, bool> ret = (*p_umap)[key].insert(val);
    if (ret.second)
    {
        return (1);
    }

    return (0);
}

int hashmap_remove(hashmap* p_map, uint32_t key, uint32_t val)
{
    //just going to use the [] operator, which happens to create a new hashtable
    // if its not there already - might change this later
    umap* p_umap = (umap*)p_map;
    if (p_umap == NULL)
    {
        return (NULL_POINTER_ERROR);
    }

    (*p_umap)[key].erase(val);
    return (1);
}


hashtable* hashmap_gethashtable(hashmap* p_map, uint32_t key)
{
    umap* p_umap = (umap*)p_map;
    if (p_umap == NULL)
    {
        return (NULL);
    }

    umap::iterator it = p_umap->find(key);
    if (it == p_umap->end())
    {
        return (NULL);
    }

    return ((hashtable*)(&(it->second)));
}

int hashmap_exist(hashmap* p_map, uint32_t from, uint32_t to)
{
    hashtable* p_table = hashmap_gethashtable(p_map, from);

    if (p_table == NULL)
    {
        return (0);
    }

    return (hashtable_exist(p_table, to));
}

void hashmap_print(FILE* fp, hashmap* p_map)
{
    umap* p_umap = (umap*)p_map;

    if (p_umap == NULL)
    {
        return;
    }

    for (umap::const_iterator it = p_umap->begin(); it != p_umap->end(); it++)
    {
        fprintf(fp, "  %x ->\n", it->first);
        hashtable_print(fp, (hashtable*)(&(it->second)));
    }
}

//counting_hashmap
typedef unordered_map<uint32_t, cset> cmap;

counting_hashmap* counting_hashmap_new()
{
    return ( (counting_hashmap*)(new cmap()));
}

void counting_hashmap_free(counting_hashmap* p_map)
{
    if (p_map != NULL)
    {
        delete ( (cmap*)p_map );
    } 
}

uint32_t counting_hashmap_add(counting_hashmap* p_map, uint32_t key, uint32_t val)
{
    cmap* p_cmap = (cmap*)p_map;
    if (p_cmap == NULL)
    {
        return (0);
    }

    return (counting_hashtable_add((counting_hashtable*)(&(*p_cmap)[key]), val));
}

uint32_t counting_hashmap_remove(counting_hashmap* p_map, uint32_t key, uint32_t val)
{
    cmap* p_cmap = (cmap*)p_map;
    if (p_cmap == NULL)
    {
        return (0);
    }

    return (counting_hashtable_remove((counting_hashtable*)(&(*p_cmap)[key]), val));
}

counting_hashtable* counting_hashmap_getcounting_hashtable(counting_hashmap* p_map, uint32_t key)
{
    cmap* p_cmap = (cmap*)p_map;
    if (p_cmap == NULL)
    {
        return (NULL);
    }

    cmap::iterator it = p_cmap->find(key);
    if (it == p_cmap->end())
    {
        return (NULL);
    }

    return ((counting_hashtable*)(&(it->second)));
}

int counting_hashmap_exist(counting_hashmap* p_map, uint32_t from, uint32_t to)
{
    counting_hashtable* p_table = counting_hashmap_getcounting_hashtable(p_map, from);

    if (p_table == NULL)
    {
        return (0);
    }

    return (counting_hashtable_exist(p_table, to));
}

uint32_t counting_hashmap_count(counting_hashmap* p_map, uint32_t key, uint32_t val)
{
    cmap* p_cmap = (cmap*)p_map;
    if (p_cmap == NULL)
    {
        return (NULL_POINTER_ERROR);
    }

    return (counting_hashtable_count((counting_hashtable*)(&(*p_cmap)[key]), val));
}

void counting_hashmap_print(FILE* fp, counting_hashmap* p_map)
{
    cmap* p_cmap = (cmap*)p_map;

    if (p_cmap == NULL)
    {
        return;
    }

    for (cmap::const_iterator it = p_cmap->begin(); it != p_cmap->end(); it++)
    {
        fprintf(fp, "  %x ->\n", it->first);
        counting_hashtable_print(fp, (counting_hashtable*)(&(it->second)));
    }
}
