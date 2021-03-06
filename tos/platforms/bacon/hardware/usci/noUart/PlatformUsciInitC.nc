/* Copyright (c) 2009-2010 People Power Co.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the People Power Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * PEOPLE POWER CO. OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 *
 */

#include "msp430usci.h"

/**
 * Connect the appropriate pins for USCI support on a CC430.
 * Additionally, expose an Init interface so that we have a
 * well-defined place to do port-mapping
 *
 * @author Peter A. Bigot <pab@peoplepowerco.com>
 * @author Doug Carlson <carlson@cs.jhu.edu>
 */

configuration PlatformUsciInitC {
  provides interface Init;
} implementation {
  #warning Using no-uart PlatformUsciInitC
  components PlatformUsciInitP;
  Init = PlatformUsciInitP;

  components HplMsp430GeneralIOC as GIO;

  components Msp430UsciSpiA0P as SpiA0C;
  //never fear, we port-map the A0 module in stm25p/noUart
  SpiA0C.SIMO -> GIO.Port13;
  SpiA0C.SOMI -> GIO.Port12;
  SpiA0C.CLK -> GIO.Port14;

  components Msp430UsciI2CB0P as I2CB0C;
  I2CB0C.SDA -> GIO.Port26;
  I2CB0C.SCL -> GIO.Port27;
}
