# Copyright 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)

ifeq ($(BUILD_DEBUG),)
ifeq ($(APP_OPTIM),debug)
BUILD_DEBUG:=true
endif
endif

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
        alpha.c \
        analysis.c \
        backward_references.c \
        config.c \
        cost.c \
        filter.c \
        frame.c\
        histogram.c \
        iterator.c \
        layer.c \
        picture.c \
        quant.c \
        syntax.c \
        tree.c \
        token.c \
        vp8l.c \
        webpenc.c \
        ../dsp/cpu.c \
        ../dsp/cpu-features.c \
        ../dsp/enc.c \
        ../dsp/enc_neon.c \
        ../dsp/enc_sse2.c \
        ../dsp/lossless.c \
        ../dsp/yuv.c \
        ../utils/bit_writer.c \
        ../utils/color_cache.c \
        ../utils/filters.c \
        ../utils/huffman.c \
        ../utils/huffman_encode.c \
        ../utils/quant_levels.c \
        ../utils/rescaler.c \
        ../utils/thread.c \
        ../utils/utils.c

LOCAL_CFLAGS := -DANDROID -DWEBP_SWAP_16BIT_CSP

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_CFLAGS += -D__ARM_ARCH_7A__
endif
ifeq ($(TARGET_ARCH_ABI),armeabi)
LOCAL_CFLAGS += -D__ARM_ARCH_6__
endif

# If static library has to be linked inside a larger shared library later,
# all code has to be compiled as PIC (Position Independant Code)
LOCAL_CFLAGS += -fPIC -DPIC

ifeq ($(BUILD_DEBUG),true)
# Debug build, turn off all optimization
LOCAL_CFLAGS += -DDEBUG -UNDEBUG -O0 -g
else
# Performance for this specific library requires pushing further
# optimization level, and favor performance over code size
LOCAL_CFLAGS += -O3
LOCAL_CFLAGS += -fstrict-aliasing
ifneq ($(TARGET_COMPILER),clang)
# -fprefetch-loop-arrays is a GCC specific option, not supported
# by clang
LOCAL_CFLAGS += -fprefetch-loop-arrays
endif
endif

LOCAL_C_INCLUDES += \
        $(LOCAL_PATH) \
        $(LOCAL_PATH)/../../include

LOCAL_MODULE:= libyahoo_webpenc

include $(BUILD_STATIC_LIBRARY)
