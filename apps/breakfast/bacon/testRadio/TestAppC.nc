#include "radioTest.h"

configuration TestAppC{
} implementation {
  components TestP;

  components MainC, LedsC, new TimerMilliC();
  TestP.Boot -> MainC;
  TestP.Leds -> LedsC;
  TestP.Timer -> TimerMilliC;
  components new TimerMilliC() as IndicatorTimer;
  TestP.IndicatorTimer -> IndicatorTimer;
  components new TimerMilliC() as WDTResetTimer;
  TestP.WDTResetTimer -> WDTResetTimer;

  components PlatformSerialC;
  components SerialPrintfC;
  TestP.SerialControl -> PlatformSerialC;
  TestP.UartStream -> PlatformSerialC;

  components ActiveMessageC;
//  components new DelayedAMSenderC(AM_RADIO_TEST) as AMSenderC;
  components new AMSenderC(AM_RADIO_TEST) as AMSenderC;
  components new AMReceiverC(AM_RADIO_TEST);
  TestP.SplitControl -> ActiveMessageC;
  TestP.AMSend -> AMSenderC;
//  TestP.DelayedSend -> AMSenderC;
  TestP.AMPacket -> AMSenderC;
  TestP.Packet -> AMSenderC;
  TestP.Receive -> AMReceiverC;

  components Rf1aActiveMessageC;
  //for setting tx power
  TestP.Rf1aIf -> Rf1aActiveMessageC;
  TestP.Rf1aPhysical -> Rf1aActiveMessageC;

  components Rf1aDumpConfigC;
  TestP.Rf1aDumpConfig -> Rf1aDumpConfigC;

  components CC1190C;
  TestP.AmpControl -> CC1190C;
  TestP.CC1190 -> CC1190C;
  
  //TODO: swap settings at compile time. Include in settings (for
  //  logging)
  //SRFS6_868_xxx_CUR_HC.nc
//  components PDERf1aSettingsP as TestConfigP;
//  components SRFS7_915_GFSK_125K_SENS_HC as TestConfigP;
//  components DefaultRf1aSettingsP as TestConfigP;
//
//  components new Rf1aChannelCacheC(2);
//  TestConfigP.Rf1aChannelCache -> Rf1aChannelCacheC;
//  Rf1aActiveMessageC.Rf1aConfigure -> TestConfigP.Rf1aConfigure;
//
  components Rf1aC;
  TestP.Rf1aPhysicalMetadata -> Rf1aC.Rf1aPhysicalMetadata;
}
