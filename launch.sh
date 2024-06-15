#!/bin/bash

LROOT=$PWD                                                                                                                                                                                                         
ROOTFS_ARM64=_rootfs_arm64                                                                                                                                                                                          
NULL_DEV_NODE=dev/null                                                                                                                                                                                             
CONSOLE_DEV_NODE=dev/console                                                                                                                                                                                       
DEV_DIR_NODE=$PWD/$ROOTFS_ARM64/dev


if [ $# -lt 1 ]; then                                                                                                                                                                                              
    echo "Usage: $0 [arch] [compile/compiled/run/debug/]"                                                                                                                                                                                
fi 

if [ $1 == "arm64" ] && [ $2 == "compile" ]; then
    echo "start to build the kernel for $1"
    if [ ! -c $LROOT/$ROOTFS_ARM64/$CONSOLE_DEV_NODE ];then
        echo "please create console device node first"
        if [ ! -d "$DEV_DIR_NODE" ];then
           mkdir -p $DEV_DIR_NODE
        fi
        cd $DEV_DIR_NODE && sudo mknod console c 5 1
    fi
    if [ ! -c $LROOT/$ROOTFS_ARM64/$NULL_DEV_NODE ];then
        echo "please create null device node first"
        if [ ! -d "$DEV_DIR_NODE" ];then
           mkdir -p $DEV_DIR_NODE
        fi
        cd $DEV_DIR_NODE && sudo mknod null c 1 3
    fi
    cd $LROOT
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- distclean
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j8
fi
