#ifndef CX_H
#define CX_H

#include "AM.h"
typedef nx_uint8_t cx_routing_method_t;

typedef nx_struct cx_header_t {
  nx_am_addr_t destination;
  //would like to reuse the dsn in the 15.4 header, but it's not exposed in a clean way
  nx_uint8_t sn;
  nx_uint16_t count;
  nx_uint8_t routingMethod;
  nx_am_id_t type;
  nx_uint32_t timestamp;
} cx_header_t;

enum{
  CX_RM_FLOOD = 0x01,
  CX_RM_SCOPEDFLOOD = 0x02,
  CX_RM_AODV = 0x03,
};

#define CX_TYPE_DATA 0xaa

#endif
