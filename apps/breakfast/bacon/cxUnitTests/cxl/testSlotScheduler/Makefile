COMPONENT=TestAppC

CFLAGS+=-I$(TOSDIR)/lib/serialprintf
CFLAGS += -I$(TOSDIR)/lib/cxl/mac
CFLAGS += -I$(TOSDIR)/lib/cxl/link
CFLAGS += -I$(TOSDIR)/lib/cxl/debug
CFLAGS += -I$(TOSDIR)/lib/cxl/packet
CFLAGS += -I$(TOSDIR)/lib/cxl/scheduler
CFLAGS += -I$(TOSDIR)/lib/rf1a-tdma/timer

CFLAGS += -I$(TOSDIR)/lib/cx/routing
CFLAGS += -I$(TOSDIR)/lib/cx/debug


CFLAGS += -I$(TOSDIR)/lib/cxl/am
CFLAGS += -DAM_ID_FROM_FLASH=0

PFLAGS+=-DMSP430XV2_DCO_CONFIG=MSP430XV2_DCO_32MHz_RSEL6
CFLAGS+=-DXT2_SMCLK

CFLAGS+= -DTOSH_DATA_LENGTH=111
CFLAGS+= -DRF1A_FEC_ENABLED=1
CFLAGS += -DPATABLE0_SETTING=0x2D
CFLAGS+= -DRF1A_AUTOCAL=0

CFLAGS += -DENABLE_PRINTF=1
CFLAGS += -DRAW_SERIAL_PRINTF=1
CFLAGS += -DDL_LPP=DL_WARN
CFLAGS += -DDL_LINK=DL_WARN
CFLAGS += -DDL_SCHED=DL_WARN
CFLAGS += -DDL_ROUTER=DL_WARN

CX_ROUTER ?= 0
CFLAGS += -DCX_ROUTER=$(CX_ROUTER)

CFLAGS += -DRX_SLACK=0UL

LPP_DEFAULT_PROBE_INTERVAL?=1024UL
CFLAGS += -DLPP_DEFAULT_PROBE_INTERVAL=$(LPP_DEFAULT_PROBE_INTERVAL)
CFLAGS += -DCX_MAX_DEPTH=5

CFLAGS += -DTEST_DESTINATION=0

include $(MAKERULES)
