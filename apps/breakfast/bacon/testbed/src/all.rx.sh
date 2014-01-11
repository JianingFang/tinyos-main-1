#!/bin/bash
od=options
sd=$(dirname $0)

if [ $# -eq 0 ]
then
  ./$sd/blink.sh 
fi

source ./$sd/install.sh maps/map.root $od/root.options $od/all.options $od/static.options $od/rx.options $od/radiostats.options

source ./$sd/install.sh maps/map.nonroot $od/slave.options $od/all.options $od/static.options $od/rx.options $od/radiostats.options
