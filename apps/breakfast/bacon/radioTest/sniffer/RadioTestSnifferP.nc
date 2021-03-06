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

#include "RadioTest.h"
#include "printf.h"

module RadioTestSnifferP {
  uses{
    interface Boot;
    interface Leds;
    interface Receive as ReportReceive;
    interface SplitControl as RadioSplitControl;
  }
} implementation {
 
  event void Boot.booted() {
    if (call RadioSplitControl.start() != SUCCESS){
      call Leds.led2On();
    }
  }

  event void RadioSplitControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call Leds.led2On();
    }
  }

  event void RadioSplitControl.stopDone(error_t err) {
  }

  event message_t* ReportReceive.receive(message_t* msg, void* payload, error_t err) {
    report_t* r = (report_t*)payload;
    call Leds.led0Toggle();
    printf("[%u, %lu, %lu, %x, %d, %d]\n", r->probe.node_id, r->probe.bn, r->probe.sn, r->probe.powerLevel, r->rssi, r->lqi);
    printfflush();
    return msg;
  }
  
}
