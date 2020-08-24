#!/bin/bash

if [ "$1" = "-m" ] ; then
    DEFCONFIG=vendor/x1q_chn_openx_defconfig
elif [ "$1" = "-x" ] ; then
    DEFCONFIG=vendor/y2q_chn_openx_defconfig
elif [ "$1" = "-xl" ] ; then
    DEFCONFIG=vendor/z3q_chn_openx_defconfig
else
    echo "Requires a cup of coffee." >&2
    exit 1
fi

export ARCH=arm64
mkdir out

BUILD_CROSS_COMPILE=/home/devries/Workspace/Kernel/Toolchain/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
KERNEL_LLVM_BIN=/home/devries/Workspace/Kernel/Toolchain/clang_linux-x86/clang-r377782b/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y PLATFORM_VERSION=10.0"

make -j56 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $DEFCONFIG
make -j56 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE 2>&1 | tee build.txt
 
cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
