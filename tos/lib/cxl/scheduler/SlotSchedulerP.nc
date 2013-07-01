module SlotSchedulerP {
  uses interface CXLink;
  uses interface LppControl;
  uses interface CXMacPacket;
  provides interface Send
  uses interface Send as SubSend;
  uses interface Receive as SubReceive;

  uses interface Timer<T32khz> as SlotTimer;
  uses interface Timer<T32khz> as FrameTimer;
} implementation {

  enum {
    //no idea when we're going to get woken up. transition out at
    //LppControl.wokenUp.
    S_UNSYNCH = 0x00,

    //Just woken up: should be RX'ing with retx until the wakeup
    //period has ended.
    S_WAKEUP = 0x01,

    //slot timer has fired, we're waiting to see a CTS to give us the
    //real slot/frame time reference.
    S_SLOT_CHECK = 0x02,
    
    //we've received a CTS, but we haven't gotten our response ready
    //yet.
    S_STATUS_PREP = 0x03,
    //We have been given a CTS and have the response ready to go.
    S_STATUS_READY = 0x04,
    //We are waiting for the response to clear.
    S_STATUS_SENDING = 0x05,
    
    //we have a packet queued and will send it at the next
    //opportunity.
    S_DATA_READY = 0x06,
    //data being sent, waiting for it to clear.
    S_DATA_SENDING = 0x07,
    //available to send more data, but none queued up at the moment.
    S_IDLE = 0x08, 
    
    //done with everything we're going to do this slot, waiting for
    //the last frame so we can send EOM/data pending packet.
    S_SLOT_END_READY = 0x09,
    S_SLOT_END_SENDING = 0x0a,
    
    //heard a CTS for somebody else, waiting for them to respond with
    //status.
    S_STATUS_WAIT = 0x10,

    //this slot is in use, and we are a forwarder. 
    S_ACTIVE_SLOT = 0xFE,
    //No data pending from ourselves, and we are either not in
    //forwarder set or no response to CTS was observed (and so, there
    //is no data coming during this slot).
    S_UNUSED_SLOT = 0xFF,
  };
  

  message_t* pending;
  message_t* statusMsg;
  message_t* ctsMsg;
  message_t* eosMsg;

  event void LppControl.wokenUp(){
    state = S_WAKEUP;
    wakeupStart = call SlotTimer.now();
    post nextRX();
  }

  event message_t* SubReceive.receive(message_t* msg, void* pl,
      uint8_t len){
    //TODO: grab src/distance and put into routing table
    switch (call CXMacPacket.getMacType(msg)){
      case CXM_CTS:
        //Set the slot/frame timing based on the master's CTS message.
        framesLeft = SLOT_LENGTH / FRAME_LENGTH;
        call SlotTimer.startPeriodicAt(timestamp(msg) - RX_SLACK, SLOT_LENGTH);
        //If we are going to be sending data, then we need to send a
        //status back (for forwarder selection)
        if ( (call CXLinkPacket.getLinkHeader(msg))->destination == TOS_NODE_ID){
          //synchronize sends to CTS timestamp
          call FrameTimer.startPeriodicAt(timestamp(msg), FRAME_LENGTH);
          master = (call CXLinkPacket.getLinkHeader(msg))->src;
          status = S_STATUS_PREP;
          post sendStatus();
        }else{
          //synchronize receives to CTS timestamp - slack
          state = S_STATUS_WAIT;
          call FrameTimer.startPeriodicAt(timestamp(msg) - RX_SLACK, FRAME_LENGTH);
        }
        return msg;

      case CXM_STATUS:
        //TODO: make forwarding decision based on routing table
        //  contents
        //TODO: state should transition to either S_ACTIVE_SLOT or
        //  S_UNUSED_SLOT
        return msg;

      default:
        return signal Receive.receive(msg, pl, len);
    }
  }

  task void sendStatus(){
    if (statusMsg == NULL){
      //TODO: set up status message
      statusMsg = call Pool.get();
      setup_t* pl = call Send.getPayload(msg, sizeof(setup_t));
      call Packet.clear(msg);
      //TODO: distance from routing table
      pl -> distance = distance;
      //TODO: set destination
      //indicate whether there is any data to be sent.
      pl -> dataPending = (pendingMsg != NULL);
      state = S_STATUS_READY;
      //great. when we get the next FrameTimer.fired, we'll send it
      //out.
    }else{
      cerror("Status msg not free\r\n");
    }
  }

  event void FrameTimer.fired(){
    framesLeft --;
    if (pendingRX){
      //ok. we are still in the process of receiving/forwarding a
      //packet, it appears.
      //pass
    } else {
      switch (state){
        case S_STATUS_READY:
          error_t error = call SubSend.send(statusMsg, sizeof(setup_t));
          if (error == SUCCESS){
            state = S_STATUS_SENDING;
          }else{
            cerror("FT %x: SS.S %x\r\n", state, error);
          }
          break;
  
        case S_STATUS_WAIT:
          framesWaited ++;
          if (framesWaited >= MAXDEPTH + 1){
            error_t error = call CXLink.sleep();
            if (error == SUCCESS){
              call FrameTimer.stop();
              state = S_UNUSED_SLOT;
            } else {
              cerror(SCHED, "Status timeout, sleep failed %x\r\n",
                error);
            }
          }
          break;
  
        case S_DATA_READY:
          //TODO: if there is not enough time to send this out in this
          //slot, we should wait until the data pending/EOM frame to
          //indicate what's up.
          error_t error = call SubSend.send(pendingMsg, pendingLen);
          if (error == SUCCESS){
            state = S_DATA_SENDING;
          }else{
            cerror("FT %x: SS.S %x\r\n", state, error);
          }
          break;
  
        case S_CTS_READY:
          error_t error = call SubSend.send(ctsMsg,
            sizeof(cx_lpp_cts_t));
          break;

        case S_ACTIVE_SLOT:
          error_t error = rx(DATA_TIMEOUT, TRUE);
          if (error != SUCCESS){
            cerror("FT %x: rx %x\r\n", state, error);
          }
          break;

        case S_UNUSED_SLOT:
          //on last frame: wait around for an
          //  end-of-message/data-pending from the owner
          //TODO: framesLeft should be 0 or 1?
          if (framesLeft == 1){
            error_t error = rx(CTS_TIMEOUT, TRUE);
            if (error != SUCCESS){
              cerror("FT %x: rx %x\r\n", state, error);
            }
          }
          break;

        case S_SLOT_END_READY:
          //on last frame: send the eos message
          //TODO: framesLeft should be 0 or 1?
          if (framesLeft == 1){
            call SubSend.send(eosMsg, sizeof(cx_eos_t));
          }
          break;

        default:
          break;
      }
    }
  }

  event void SubSend.sendDone(message_t* msg, error_t error){
    if (state == S_STATUS_SENDING){
      if (msg == statusMsg){
        if (error == SUCCESS){
          setup_t* pl = call Send.getPayload(msg, sizeof(setup_t));
          if (pl -> dataPending && pendingMsg != NULL){
            state = S_DATA_READY;
          }else{
            //No data pending: so we sleep until the next slot start.
            call FrameTimer.stop();
            call CXLink.sleep();
            state = S_UNUSED_SLOT;
          }
        }
      } else {
        cerror("Unexpected sendDone, status msg %p got %p\r\n",
          statusMsg, msg);
      }
    }else if (state == S_DATA_SENDING){
      state = S_IDLE;
      signal Send.sendDone(msg, error);
    } else if (state == S_CTS_SENDING){
      call FrameTimer.startPeriodicAt(timestamp(msg), FRAME_LENGTH);
    } else {
      cerror("Unexpected send done state %x\r\n", state);
    }
  }


  event void CXLink.rxDone(){
    pendingRX = FALSE;
    post nextRX();
  }

  error_t rx(uint32_t timeout, bool retx){
    if (pendingRX){
      cerror(SCHED, "RX while pending\r\n");
      return EBUSY;
    } else {
      error_t error = call CXLink.rx(timeout, retx);
      if (error == SUCCESS){
        pendingRX = TRUE;
      }
      return error;
    }
  }

  task void nextRX(){
    if (state == S_WAKEUP){
      if (wakeupTimeoutStillGoing){
        //TODO: set timeout to be from now until end of active period
        //wakeup.
        error_t error = call CXLink.rx(RX_TIMEOUT_MAX, TRUE);
        if (error != SUCCESS){
          cwarn(SCHED, "wakeup re-rx: %x\r\n", error);
        }
      } else {
        if (signal SlotController.isMaster()){
          call SlotTimer.startOneShot(0);
        } else {
          //TODO: this should be one probe interval
          call CXLink.rx(RX_TIMEOUT_MAX, TRUE);
          state = S_SLOT_CHECK;
        }
      }
    }else if (state == S_SLOT_CHECK){
      //we didn't get a CTS, so we deem the active period over.
      //TODO safer: count up the number of non-CTS-bearing slots and
      //sleep when we've exceeded a few of them. N.B. each of these
      //timeout slots adds 30 ms of on-time (not too shabby!).
      error_t error = call LppControl.sleep();
      if (error == SUCCESS){
        state = S_UNSYNCH;
      }else{
        //awjeez awjeez
        cerror(SCHED, "No CTS, failed to sleep with %x\r\n", error);
      }
    }
  }
  
  //when slot timer fires, master will send CTS, and slave will try to
  //check for it.
  event void SlotTimer.fired(){
    if (signal SlotController.isMaster()){
      if(signal SlotController.isActive()){
        am_addr_t activeNode = signal SlotController.activeNode();
        if (ctsMsg == NULL){
          ctsMsg = call Pool.get();
          if (ctsMsg == NULL){
            cerror("No msg in pool for cts\r\n");
          } else {
            error_t error;
            call Packet.clear(ctsMsg);
            //TODO: set up the rest of the CTS packet
            error = call SubSend.send(ctsMsg, sizeof(lpp_cts_t));
            if (error == SUCCESS){
              state = S_CTS_SENDING;
            }else{
              cerror("Failed to send cts %x\r\n", error);
              call Pool.put(ctsMsg);
            }
          }
        } else {
          cerror("CTS msg not available.\r\n");
        }
      } else {
        //end of active period: can sleep now.
        call LppControl.sleep();
        call SlotTimer.stop();
      }
    } else {
      error_t error = call CXLink.rx(CTS_TIMEOUT, TRUE);
      if (error == SUCCESS){
        state = S_SLOT_CHECK;
      }else{
        cerror(SCHED, "Failed to listen for CTS %x\r\n", error);
        state = S_UNUSED_SLOT;
      }
    }
  }
  
  default event am_addr_t SlotController.activeNode(){
    return AM_BROADCAST_ADDR;
  }
  default event bool SlotController.isMaster(){
    return FALSE;
  }

}