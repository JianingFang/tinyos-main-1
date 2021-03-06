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

generic module DefaultRf1aTransmitFragmentC(){
  provides interface Rf1aTransmitFragment;
  provides interface SetNow<const uint8_t*> as SetBuffer;
  provides interface SetNow<uint8_t> as SetLength;
} implementation{
  const uint8_t* tx_pos = NULL;
  uint8_t bytesLeft = 0;
  
  async command unsigned int Rf1aTransmitFragment.transmitReadyCount(unsigned int count ){
    atomic {
      return (bytesLeft < count)? bytesLeft: count;
    }
  }

  async command const uint8_t* Rf1aTransmitFragment.transmitData(unsigned int count ){
    atomic{
      if (bytesLeft < count){
        return NULL;
      }else{
        const uint8_t* rv = tx_pos;
        tx_pos += count;
        bytesLeft -= count;
        return rv;
      }
    }
  }
   
  async command error_t SetBuffer.setNow(const uint8_t* buf){
    tx_pos = buf;
    return SUCCESS;
  }

  async command error_t SetLength.setNow(uint8_t len){
    bytesLeft = len;
    return SUCCESS;
  }

}
