configuration CXLinkPacketC{
  provides interface CXLinkPacket;
  provides interface Rf1aPacket;
  provides interface Packet;
  provides interface Ieee154Packet;

  uses interface Rf1aPhysicalMetadata;

} implementation {
  //The link layer does not add anything to the packet, it just reuses
  //elements of the 15.4 header.
  components new Rf1aIeee154PacketC();
  Rf1aPacket = Rf1aIeee154PacketC;

  components CXPacketMetadataC;

  components CXLinkPacketP;
  CXLinkPacketP.Ieee154Packet -> Rf1aIeee154PacketC;
  CXLinkPacketP.Rf1aPacket -> Rf1aIeee154PacketC;
  Packet = CXLinkPacketP.Packet;
  CXLinkPacketP.SubPacket -> Rf1aIeee154PacketC;
  CXLinkPacketP.CXPacketMetadata -> CXPacketMetadataC;

  CXLinkPacket = CXLinkPacketP;
  Rf1aIeee154PacketC.Rf1aPhysicalMetadata = Rf1aPhysicalMetadata;
  Ieee154Packet = Rf1aIeee154PacketC;
}
