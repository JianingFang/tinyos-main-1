/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @version $Revision$ $Date$
 */

configuration Msp430I2C0P {
  
  provides interface Resource[ uint8_t id ];
  provides interface ResourceConfigure[uint8_t id ];
  provides interface I2CPacket<TI2CBasicAddr> as I2CBasicAddr;
  
//  uses interface Resource as UsciResource[ uint8_t id ];
//  uses interface Msp430UsciConfigure[ uint8_t id ];
//  uses interface HplMsp430UsciInterrupts as InterruptsRx[ uint8_t mode ];
//  uses interface HplMsp430UsciInterrupts as InterruptsTx[ uint8_t mode ];
  
}

implementation {
  
  components Msp430I2CP as I2CP;
  Resource = I2CP.Resource;
  ResourceConfigure = I2CP.ResourceConfigure;
//  Msp430UsciConfigure = I2CP.Msp430UsciConfigure;
  I2CBasicAddr = I2CP.I2CBasicAddr;
//  UsciResource = I2CP.UsciResource;
//  InterruptsRx = I2CP.InterruptsRx;
//  InterruptsTx = I2CP.InterruptsTx;
  
//  components HplMsp430I2C0C as HplI2CC;
//  I2CP.HplI2C -> HplI2CC;
  
//  components LedsC as Leds;
//  I2CP.Leds -> Leds;

  components HplMsp430UsciInterruptsAB0P;
  I2CP.InterruptsState -> HplMsp430UsciInterruptsAB0P.InterruptsUCB0State;
  I2CP.InterruptsRx -> HplMsp430UsciInterruptsAB0P.InterruptsUCB0Rx;
  I2CP.InterruptsTx -> HplMsp430UsciInterruptsAB0P.InterruptsUCB0Tx;

  components HplMsp430GeneralIOC as GIO;
  I2CP.SDA -> GIO.UCB0SDA;
  I2CP.SCL -> GIO.UCB0SCL;  
}
