// $Id: RadioCountToLedsAppC.nc,v 1.5 2010-06-29 22:07:17 scipio Exp $

/*									tab:4
 * Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the University of California nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
 
#include "RadioCountToLeds.h"

/**
 * Configuration for the RadioCountToLeds application. RadioCountToLeds 
 * maintains a 4Hz counter, broadcasting its value in an AM packet 
 * every time it gets updated. A RadioCountToLeds node that hears a counter 
 * displays the bottom three bits on its LEDs. This application is a useful 
 * test to show that basic AM communication and timers work.
 *
 * @author Philip Levis
 * @date   June 6 2005
 */

configuration RadioCountToLedsAppC {}
implementation {
  components MainC, RadioCountToLedsC as App, LedsC, NoLedsC;
  components new AMSenderC(AM_RADIO_COUNT_MSG);// as AMSenderC;
  components new AMReceiverC(AM_RADIO_COUNT_MSG);
  components new TimerMilliC() as SendTimer;
  components ActiveMessageC;

  components Rf1aActiveMessageC;
  #if TEST_SR == 100
  components Rf1aConfig100KC as Rf1aSettings;
  #elif TEST_SR == 125
  //components Rf1aConfig125KC as Rf1aSettings;
  components SRFS7_915_GFSK_125K_SENS_HC as Rf1aSettings;
  #elif TEST_SR == 250
  //components Rf1aConfig125KC as Rf1aSettings;
  components SRFS7_915_GFSK_250K_SENS_HC as Rf1aSettings;
  #else
  //TODO: other symbol rates
  #error Unknown symbol rate
  #endif
  Rf1aActiveMessageC.Rf1aConfigure -> Rf1aSettings;

  components SerialPrintfC;
  components PlatformSerialC;
  components RandomC;

  App.Boot -> MainC.Boot;
  
  App.Receive -> AMReceiverC;
  App.AMSend -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.Leds -> NoLedsC;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.Random -> RandomC;

//  App.DelayedSend -> AMSenderC;
//  App.DelayTimer -> DelayTimer;
  App.SerialControl -> PlatformSerialC;
  App.UartStream -> PlatformSerialC;

  components Rf1aDumpConfigC;
//  App.Rf1aConfigure -> Rf1aSettings;
  App.Rf1aDumpConfig -> Rf1aDumpConfigC;
  App.Rf1aPhysical -> Rf1aActiveMessageC;
  App.Rf1aPacket -> Rf1aActiveMessageC;
  App.HplMsp430Rf1aIf -> Rf1aActiveMessageC;
  App.SendTimer -> SendTimer;

  App.Rf1aStatus -> Rf1aActiveMessageC;

  components CC1190C;
  App.CC1190 -> CC1190C;
  App.CC1190Control -> CC1190C;
//  App.Rf1aConfigure -> Rf1aSettings;
}


