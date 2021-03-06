SOURCES=blink.c
CC=msp430-gcc
CCFLAGS=-mmcu=cc430x5137
OBJCOPY=msp430-objcopy
ODIR=bin
EXES=$(SOURCES:.c=.bin)
EXES_=$(patsubst %,$(ODIR)/%,$(EXES))
HEXES=$(SOURCES:.c=.hex)
HEXES_=$(patsubst %,$(ODIR)/%,$(HEXES))

all: $(ODIR) $(HEXES_) $(EXES_)

$(ODIR):
	mkdir -p $(ODIR)

$(ODIR)/%.hex: $(ODIR)/%.bin
	$(OBJCOPY) -I elf32-msp430 -O ihex $< $@

$(ODIR)/%.bin: %.c 
	$(CC) $(CCFLAGS) $(CFLAGS) $< -o $@ 

clean:
	rm -rf $(ODIR)

