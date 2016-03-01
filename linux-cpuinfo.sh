#!/bin/sh

#set -e
set -x

uname -a
cat /proc/cpuinfo
MACH=`uname -m`
# variables differ by arch, so take a loose guess
# use /bin/grep to avoid aliases

ARCH=$(echo "$MACH" | /bin/grep -i arm)
if [ -n "$ARCH" ]
then
    ARCH="arm"
else
    ARCH=`echo "$MACH" | /bin/grep -i 86`
    if [ -n "$ARCH" ]
    then
        ARCH="x86"
    fi
fi
INFO=`cat /proc/cpuinfo`
CORES=`echo "$INFO"| /bin/grep -c processor`
if [ $ARCH = "arm" ]
then
    # if Processor not found, use model name
    PROC=`echo "$INFO"| /bin/grep "^Processor :"`
    if [ -n  "$PROC" ]
    then
        MODEL=`echo "$INFO"| /bin/grep "^Processor :"`
    else
        MODEL=`echo "$INFO" | /bin/grep "model name"|cut -d: -f2-|sort -u|sed -e 's/(Flattened Device Tree)//'`
    fi
    PROC=`echo "$INFO"| /bin/grep Hardware`
    if [ -n "$PROC" ]
    then
        PROCESSOR=`echo "$INFO"| /bin/grep Hardware|cut -d: -f2-|sed -e 's/(Flattened Device Tree)//'`
    fi
else
    PROCESSOR=`echo "$INFO"| /bin/grep vendor_id|cut -d: -f2-|sort -u`
    MODEL=`echo "$INFO" | /bin/grep "model name"|cut -d: -f2-|sort -u`
fi
echo CORES=$CORES
echo PROCESSOR=$PROCESSOR
echo MODEL=$MODEL
