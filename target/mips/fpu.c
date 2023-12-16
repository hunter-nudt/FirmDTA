/*
 * Helpers for emulation of FPU-related MIPS instructions.
 *
 *  Copyright (C) 2004-2005  Jocelyn Mayer
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
#include "qemu/osdep.h"
#include "fpu/softfloat-helpers.h"
#include "fpu_helper.h"

/* convert MIPS rounding mode in FCR31 to IEEE library */
const FloatRoundMode ieee_rm[4] = {
    float_round_nearest_even,
    float_round_to_zero,
    float_round_up,
    float_round_down
};

const char fregnames[32][4] = {
    "f0",  "f1",  "f2",  "f3",  "f4",  "f5",  "f6",  "f7",
    "f8",  "f9",  "f10", "f11", "f12", "f13", "f14", "f15",
    "f16", "f17", "f18", "f19", "f20", "f21", "f22", "f23",
    "f24", "f25", "f26", "f27", "f28", "f29", "f30", "f31",
};

#ifdef CONFIG_TCG_TAINT
const char taint_fregnames[32][10] = {
    "taint_f0",  "taint_f1",  "taint_f2",  "taint_f3",  "taint_f4",  "taint_f5",  "taint_f6",  "taint_f7",
    "taint_f8",  "taint_f9",  "taint_f10", "taint_f11", "taint_f12", "taint_f13", "taint_f14", "taint_f15",
    "taint_f16", "taint_f17", "taint_f18", "taint_f19", "taint_f20", "taint_f21", "taint_f22", "taint_f23",
    "taint_f24", "taint_f25", "taint_f26", "taint_f27", "taint_f28", "taint_f29", "taint_f30", "taint_f31",
};
#endif 	/* CONFIG_TCG_TAINT */
