#!/usr/bin/env python

##generated with: 
## grep 'msg{' ctrl_messages.h | awk '{print $3}' | tr -d '{' | sed -re 's,(_|^)([a-z]),\u\2,g'
allS='''
ReadIvCmdMsg
ReadIvResponseMsg
ReadMfrIdCmdMsg
ReadMfrIdResponseMsg
ReadAdcCCmdMsg
ReadAdcCResponseMsg
ReadBaconBarcodeIdCmdMsg
ReadBaconBarcodeIdResponseMsg
WriteBaconBarcodeIdCmdMsg
WriteBaconBarcodeIdResponseMsg
ReadToastBarcodeIdCmdMsg
ReadToastBarcodeIdResponseMsg
WriteBaconVersionCmdMsg
WriteBaconVersionResponseMsg
ReadBaconVersionCmdMsg
ReadBaconVersionResponseMsg
WriteToastBarcodeIdCmdMsg
WriteToastBarcodeIdResponseMsg
ReadToastAssignmentsCmdMsg
ReadToastAssignmentsResponseMsg
WriteToastAssignmentsCmdMsg
WriteToastAssignmentsResponseMsg
WriteToastVersionCmdMsg
WriteToastVersionResponseMsg
ReadToastVersionCmdMsg
ReadToastVersionResponseMsg
ScanBusCmdMsg
ScanBusResponseMsg
PingCmdMsg
PingResponseMsg
ResetBaconCmdMsg
ResetBaconResponseMsg
SetBusPowerCmdMsg
SetBusPowerResponseMsg
ReadBaconTlvCmdMsg
ReadBaconTlvResponseMsg
ReadToastTlvCmdMsg
ReadToastTlvResponseMsg
WriteBaconTlvCmdMsg
WriteBaconTlvResponseMsg
WriteToastTlvCmdMsg
WriteToastTlvResponseMsg
DeleteBaconTlvEntryCmdMsg
DeleteBaconTlvEntryResponseMsg
DeleteToastTlvEntryCmdMsg
DeleteToastTlvEntryResponseMsg
AddBaconTlvEntryCmdMsg
AddBaconTlvEntryResponseMsg
AddToastTlvEntryCmdMsg
AddToastTlvEntryResponseMsg
ReadBaconTlvEntryCmdMsg
ReadBaconTlvEntryResponseMsg
ReadToastTlvEntryCmdMsg
ReadToastTlvEntryResponseMsg
ReadAnalogSensorCmdMsg
ReadAnalogSensorResponseMsg
'''

__all__= ['PrintfMsg'] + allS.split()