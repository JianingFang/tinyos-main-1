#ifndef CX_LINK_H
#define CX_LINK_H

#include "AM.h"

#ifndef CX_SCALE_TIME
#define CX_SCALE_TIME 1
#endif

#ifndef FRAMELEN_SLOW
//32k = 2**15
#define FRAMELEN_SLOW (1024UL * CX_SCALE_TIME)
#endif

#ifndef FRAMELEN_FAST
//6.5M = 2**5 * 5**16 * 13
#define FRAMELEN_FAST (203125UL * CX_SCALE_TIME)
#endif

//worst case: 8 byte-times (preamble, sfd)
//(64/125000.0)*6.5e6=3328, round up a bit.
#define CX_CS_TIMEOUT_EXTEND 3500UL

//time from strobe command to SFD: 0.00523 S
#define TX_SFD_ADJUST 3395UL

//difference between transmitter SFD and receiver SFD: 60.45 fast ticks
#define T_SFD_PROP_TIME (61UL - 23UL)

#define RX_SFD_ADJUST (TX_SFD_ADJUST + T_SFD_PROP_TIME)

const uint8_t tonePacket[255] = {
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 
};


typedef nx_struct cx_link_header {
  nx_uint8_t ttl;
  nx_uint8_t hopCount;
  nx_am_addr_t destination;
  nx_am_addr_t source;
  nx_uint8_t sn;
} cx_link_header_t;

typedef struct cx_link_metadata {
  uint32_t rxHopCount;
  uint32_t time32k;
  bool retx;
} cx_link_metadata_t;

#endif
