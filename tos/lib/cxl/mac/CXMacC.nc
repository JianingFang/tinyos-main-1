/*
 * Copyright (c) 2014 Johns Hopkins University.
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
 * - Neither the name of the copyright holders nor the names of
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
*/


 #include "CXMac.h"
configuration CXMacC {
  provides interface Send;
  provides interface Receive;

  provides interface SplitControl;
  uses interface Pool<message_t>;

  provides interface Packet;

} implementation {

  components CXMacP;
  components CXLppC;

  //If you need a handle to the rts/cts commands, do so *not* through
  //this component, but by directly grabbing CXBasestationMacC or
  //CXLeafMacC where you need it.
  #if CX_BASESTATION == 1
  components CXBasestationMacC as Controller;
  Controller.Pool = Pool;
  #else
  components CXLeafMacC as Controller;
  #endif

  CXMacP.CXMacController -> Controller;

  Receive = Controller.Receive;
  Controller.SubReceive -> CXLppC.Receive;
  CXLppC.Pool = Pool;
  
  SplitControl = CXLppC.SplitControl;

  Send = Controller.Send;
  Controller.SubSend -> CXMacP.Send;
  CXMacP.SubSend -> CXLppC.Send;

  Packet = CXLppC.Packet;

  components new TimerMilliC();
  CXMacP.Timer -> TimerMilliC;
}
