COMPONENT=TestAppC

TEST_DESTINATION?=0
CFLAGS += -DTEST_DESTINATION=$(TEST_DESTINATION)

PACKET_GEN_RATE ?= 0UL
CFLAGS += -DPACKET_GEN_RATE=$(PACKET_GEN_RATE)

CFLAGS += -I$(TOSROOT)/apps/breakfast/bacon/Ping
CFLAGS += -I$(TOSROOT)/apps/breakfast/bacon/RebootCounter
CFLAGS += -I$(TOSROOT)/apps/breakfast/bacon/settingsStorage
CFLAGS += -I$(TOSDIR)/chips/msp430/tlvStorage

CFLAGS += -I$(TOSDIR)/lib/serialprintf
CFLAGS += -I$(TOSDIR)/lib/cxl/debug
CFLAGS += -I$(TOSDIR)/lib/cxl/am
CFLAGS += -I$(TOSDIR)/lib/cxl/mac
CFLAGS += -I$(TOSDIR)/lib/cxl/link
CFLAGS += -I$(TOSDIR)/lib/cxl/packet
CFLAGS += -I$(TOSDIR)/lib/rf1a-tdma/timer
CFLAGS += -I$(TOSDIR)/lib/cxl/scheduler
CFLAGS += -I$(TOSDIR)/lib/cx/routing
CFLAGS += -I$(TOSDIR)/lib/cx/debug


PFLAGS+=-DMSP430XV2_DCO_CONFIG=MSP430XV2_DCO_32MHz_RSEL6
CFLAGS+=-DXT2_SMCLK

CFLAGS+= -DRF1A_FEC_ENABLED=1
CFLAGS+= -DRF1A_WHITENING_ENABLED=1
CFLAGS += -DPATABLE0_SETTING=0x2D
CFLAGS+= -DRF1A_AUTOCAL=0

LPP_DEFAULT_PROBE_INTERVAL?=1024UL
CFLAGS += -DLPP_DEFAULT_PROBE_INTERVAL=$(LPP_DEFAULT_PROBE_INTERVAL)

CX_MAX_DEPTH?=5
CFLAGS += -DCX_MAX_DEPTH=$(CX_MAX_DEPTH)


CX_ROUTER ?= 0
CFLAGS += -DCX_ROUTER=$(CX_ROUTER)
CX_BASESTATION ?= 0
CFLAGS += -DCX_BASESTATION=$(CX_BASESTATION)

CFLAGS += -DAM_ID_FROM_FLASH=0

ENABLE_PRINTF ?= 1
CFLAGS += -DENABLE_PRINTF=$(ENABLE_PRINTF)
CFLAGS += -DRAW_SERIAL_PRINTF=1
CFLAGS += -DDL_LPP=DL_WARN
CFLAGS += -DDL_LINK=DL_WARN
CFLAGS += -DDL_APP=DL_DEBUG
CFLAGS += -DDL_SCHED=DL_WARN
CFLAGS += -DDL_ROUTER=DL_DEBUG

CFLAGS +=-DCX_LPP_BASIC=0

include $(MAKERULES)
