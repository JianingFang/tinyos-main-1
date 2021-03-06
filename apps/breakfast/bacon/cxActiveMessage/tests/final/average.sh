#!/bin/bash
thresh=-100
targetIpi=61440
rateOptions="targetIpi ${targetIpi}UL queueThreshold 10"
burstOptions="senderDest 0UL requestAck 0"
senderMap=map.nonroot

if [ $# -lt 3 ]
then
  echo "Usage: $0 testDuration txp testNum"
  exit 1
fi
testDuration=$1
txp=$2
testNum=$3

for bw in 0 2
do
  for sel in 1
  do
    for roundThresh in 8
    do
      ./installTestbed.sh \
        testLabel type.burst.bw.${bw}.sel.${sel}.txp.${txp}.ipi.${targetIpi}.thresh.${thresh}.sm.${senderMap}.rt.${roundThresh}.tn.${testNum}\
        txp $txp \
        receiverMap map.none \
        senderMap $senderMap \
        rootMap map.0 \
        maxDepth 8 \
        fps 40 \
        rssiThreshold $thresh\
        $burstOptions\
        cxForwarderSelection $sel \
        $rateOptions \
        bufferWidth $bw \
        roundThresh $roundThresh
      sleep $testDuration
    done
  done
done

