
 #include "CXNetwork.h"
configuration CXNetworkC {
  provides interface SplitControl;
  provides interface CXRequestQueue;
  provides interface Packet;
  provides interface CXNetworkPacket;
  provides interface Notify<uint32_t> as ActivityNotify;

} implementation {
  components CXNetworkP;

  components CXNetworkPacketC;
  components CXPacketMetadataC;

  //convenience interfaces
  Packet = CXNetworkPacketC;
  CXNetworkPacket = CXNetworkPacketC;

  components CXLinkC;
  
  SplitControl = CXLinkC;
  ActivityNotify = CXNetworkP.ActivityNotify;

  CXRequestQueue = CXNetworkP;
  CXNetworkP.SubCXRequestQueue -> CXLinkC;

  CXNetworkP.CXLinkPacket -> CXLinkC;

  CXNetworkP.CXNetworkPacket -> CXNetworkPacketC;

  CXNetworkP.CXPacketMetadata -> CXPacketMetadataC;

  components ActiveMessageC;
  CXNetworkP.AMPacket -> ActiveMessageC;

  components new PoolC(cx_network_metadata_t, CX_NETWORK_POOL_SIZE);
  CXNetworkP.Pool -> PoolC;

  components CXRoutingTableC;
  CXNetworkP.RoutingTable -> CXRoutingTableC;
  
  components CXAMAddressC;
  CXNetworkP.ActiveMessageAddress -> CXAMAddressC;
 
  //For debug
  components CXTransportPacketC;
  components LocalTime32khzC;
  components CXLinkPacketC;
  CXNetworkP.CXTransportPacket -> CXTransportPacketC;
  CXNetworkP.LocalTime -> LocalTime32khzC;
  CXNetworkP.Rf1aPacket -> CXLinkPacketC;

}
