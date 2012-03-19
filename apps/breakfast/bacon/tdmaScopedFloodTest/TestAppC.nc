 #include "CX.h"
 #include "schedule.h"

configuration TestAppC{
} implementation {
  components MainC;
  components TestP;
  components SerialPrintfC;
  components PlatformSerialC;
  components LedsC;

  TestP.Boot -> MainC;
  TestP.UartStream -> PlatformSerialC;
  TestP.UartControl -> PlatformSerialC;
  TestP.Leds -> LedsC;

  components GlossyRf1aSettings125KC as Rf1aSettings;

  components new Rf1aPhysicalC();
  Rf1aPhysicalC.Rf1aConfigure -> Rf1aSettings;

  components new Rf1aIeee154PacketC() as Ieee154Packet; 
  Ieee154Packet.Rf1aPhysicalMetadata -> Rf1aPhysicalC;
  components Ieee154AMAddressC;

  components Rf1aCXPacketC;
  Rf1aCXPacketC.SubPacket -> Ieee154Packet;
  Rf1aCXPacketC.Ieee154Packet -> Ieee154Packet;
  Rf1aCXPacketC.Rf1aPacket -> Ieee154Packet;

  components Rf1aAMPacketC as AMPacket;
  AMPacket.SubPacket -> Rf1aCXPacketC;
  AMPacket.Ieee154Packet -> Ieee154Packet;
  AMPacket.Rf1aPacket -> Ieee154Packet;
  AMPacket.ActiveMessageAddress -> Ieee154AMAddressC;
  Rf1aCXPacketC.AMPacket -> AMPacket;

  components CXTDMAPhysicalC;
  CXTDMAPhysicalC.HplMsp430Rf1aIf -> Rf1aPhysicalC;
  CXTDMAPhysicalC.Resource -> Rf1aPhysicalC;
  CXTDMAPhysicalC.Rf1aPhysical -> Rf1aPhysicalC;
  CXTDMAPhysicalC.Rf1aStatus -> Rf1aPhysicalC;
  CXTDMAPhysicalC.Rf1aPacket -> Ieee154Packet;
  CXTDMAPhysicalC.CXPacket -> Rf1aCXPacketC;

  components TDMASchedulerC;
  TDMASchedulerC.SubSplitControl -> CXTDMAPhysicalC;
  TDMASchedulerC.SubCXTDMA -> CXTDMAPhysicalC;
  TDMASchedulerC.AMPacket -> AMPacket;
  TDMASchedulerC.CXPacket -> Rf1aCXPacketC;
  TDMASchedulerC.Packet -> Rf1aCXPacketC;
  TDMASchedulerC.Rf1aPacket -> Ieee154Packet;
  TDMASchedulerC.Ieee154Packet -> Ieee154Packet;

  components CXTDMADispatchC;
  CXTDMADispatchC.SubCXTDMA -> TDMASchedulerC;
  CXTDMADispatchC.CXPacket -> Rf1aCXPacketC;
  
  //this is just used to keep the enumerated arbiter happy
  enum{
    CX_RM_FLOOD_UC = unique(CXTDMA_RM_RESOURCE),
  };

  components CXFloodC;
  CXFloodC.CXTDMA -> CXTDMADispatchC.CXTDMA[CX_RM_FLOOD];
  CXFloodC.Resource -> CXTDMADispatchC.Resource[CX_RM_FLOOD];
  //TODO: this is going to have fan-out to deal with.
  CXFloodC.TDMAScheduler -> TDMASchedulerC.TDMAScheduler;
  CXFloodC.CXPacket -> Rf1aCXPacketC;
  CXFloodC.LayerPacket -> Rf1aCXPacketC;

  //this is just used to keep the enumerated arbiter happy
  enum{
    CX_RM_SCOPEDFLOOD_UC = unique(CXTDMA_RM_RESOURCE),
  };

  components CXScopedFloodC;
  CXScopedFloodC.CXTDMA -> CXTDMADispatchC.CXTDMA[CX_RM_SCOPEDFLOOD];
  CXScopedFloodC.Resource -> CXTDMADispatchC.Resource[CX_RM_SCOPEDFLOOD];
  CXScopedFloodC.TDMAScheduler -> TDMASchedulerC.TDMAScheduler;
  CXScopedFloodC.CXPacket -> Rf1aCXPacketC;
  CXScopedFloodC.LayerPacket -> Rf1aCXPacketC;

  components CXRoutingTableC;
  CXScopedFloodC.CXRoutingTable -> CXRoutingTableC;


  #if TDMA_ROOT == 1
  #warning TDMA: IS ROOT
  components TDMARootC as RootC;
  #else
  components TDMANonRootC as RootC;
  #endif
  RootC.SubSplitControl -> TDMASchedulerC.SplitControl;
  RootC.Send -> CXFloodC.Send[CX_TYPE_SCHEDULE];
  RootC.TDMARootControl -> TDMASchedulerC.TDMARootControl;

  TestP.SplitControl -> RootC.SplitControl;
  TestP.AMPacket -> AMPacket;
  TestP.CXPacket -> Rf1aCXPacketC;
  TestP.Packet -> Rf1aCXPacketC;

  TestP.FloodSend -> CXFloodC.Send[CX_TYPE_DATA];
  TestP.FloodReceive -> CXFloodC.Receive[CX_TYPE_DATA];

  TestP.ScopedFloodSend -> CXScopedFloodC.Send[CX_TYPE_DATA];
  TestP.ScopedFloodReceive -> CXScopedFloodC.Receive[CX_TYPE_DATA];
  
}