#!/bin/sh
#set -x
if [ $# -lt 2 ]
then
  echo "usage: $0 <device> <file> [extraArg ...]"
  exit 1
fi
dev=$1
file=$2
shift 2

msp430-bsl.py --invert-test --invert-reset -c $dev -e $@ $file
