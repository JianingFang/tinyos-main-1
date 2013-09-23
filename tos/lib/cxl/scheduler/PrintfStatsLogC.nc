
 #include "CXLinkDebug.h"
 #include "CXLink.h"
configuration PrintfStatsLogC{
  provides interface StatsLog;
  uses interface CXLinkPacket;
  uses interface Packet;
} implementation {
  components PrintfStatsLogP;

  StatsLog = PrintfStatsLogP;

  PrintfStatsLogP.CXLinkPacket = CXLinkPacket;
  PrintfStatsLogP.Packet = Packet;
}