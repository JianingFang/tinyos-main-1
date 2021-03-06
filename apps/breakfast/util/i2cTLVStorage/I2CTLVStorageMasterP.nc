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

#include "I2CTLVStorage.h"
#include "I2CCom.h"

module I2CTLVStorageMasterP{
  provides interface I2CTLVStorageMaster;
  uses interface I2CComMaster;
  uses interface TLVUtils;
} implementation {
  enum {
    S_IDLE = 0,
    S_LOADING = 1,
    S_PERSISTING = 2,
  }; 
  
  uint8_t state = S_IDLE;
  i2c_message_t* readMsg;

  command void* I2CTLVStorageMaster.getPayload(i2c_message_t* msg){
    return &(((i2c_tlv_storage_t*)call I2CComMaster.getPayload(msg))->data);
  }

  task void readTask(){
    error_t error;
    error = call I2CComMaster.receive(readMsg->body.header.slaveAddr, readMsg,
      sizeof(i2c_tlv_storage_t));

    if (error != SUCCESS){
      state = S_IDLE;
      readMsg->body.header.len = 0;
      signal I2CTLVStorageMaster.loaded(error, readMsg);
    }
  }

  event void I2CComMaster.sendDone(error_t error, 
      i2c_message_t* msg){
    if (state == S_LOADING){
      if (error == SUCCESS){
        readMsg = msg;
        post readTask();
      } else {
        signal I2CTLVStorageMaster.loaded(error, msg);
      }
    } else if (state == S_PERSISTING){
      state = S_IDLE;
      signal I2CTLVStorageMaster.persisted(error, msg);
    }
  }

 
  event void I2CComMaster.receiveDone(error_t error, 
      i2c_message_t* msg){
    state = S_IDLE;
    signal I2CTLVStorageMaster.loaded(error, msg);
  }


  command error_t I2CTLVStorageMaster.loadTLVStorage(uint16_t slaveAddr, 
      i2c_message_t* msg){
    error_t ret;
    i2c_tlv_storage_t* payload = (i2c_tlv_storage_t*)call I2CComMaster.getPayload(msg);
    if (state != S_IDLE){
      return EBUSY;
    }
    payload-> cmd = TLV_STORAGE_READ_CMD;
    ret = call I2CComMaster.send(slaveAddr, msg, sizeof(payload->cmd));
    if (ret == SUCCESS){
      state = S_LOADING;
    }
    return ret;
  }

  command error_t I2CTLVStorageMaster.persistTLVStorage(uint16_t slaveAddr,
      i2c_message_t* msg){
    error_t error;
    i2c_tlv_storage_t* payload = (i2c_tlv_storage_t*)call I2CComMaster.getPayload(msg);
    if (state != S_IDLE){
      return EBUSY;
    }

    payload->cmd = TLV_STORAGE_WRITE_CMD;
    error = call I2CComMaster.send(slaveAddr,
      msg,sizeof(i2c_tlv_storage_t));
    if (error == SUCCESS){
      state = S_PERSISTING;
    }
    return error;
  }
}
