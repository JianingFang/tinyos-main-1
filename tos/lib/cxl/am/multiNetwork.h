#ifndef MULTI_NETWORK_H
#define MULTI_NETWORK_H

#include "AM.h"

#define UQ_GLOBAL_SEND "globalqueue.send"
#define UQ_SUBNETWORK_SEND "subnetworkqueue.send"
#define UQ_ROUTER_SEND "routerqueue.send"

enum {
  NS_GLOBAL=0,
  NS_SUBNETWORK=1,
  NS_ROUTER=2,
  NUM_SEGMENTS=3
};

#endif