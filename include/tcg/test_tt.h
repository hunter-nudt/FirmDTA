#ifndef TEST_TT
#define TEST_TT

#include "cpu.h"
#include "exec/memop.h"
#include "exec/memopidx.h"
#include "qemu/bitops.h"
#include "qemu/plugin.h"
#include "qemu/queue.h"
#include "tcg/tcg-mo.h"
#include "tcg-target.h"
#include "tcg/tcg-cond.h"

void test_hello_world(void);

#endif