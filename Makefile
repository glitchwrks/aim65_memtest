AFLAGS		= -t none
LFLAGS		= -t none
RMFLAGS		= -f
 
CC		= cc65
CA		= ca65
CL		= cl65
RM		= rm

all: clean memtest.bin

memtest.o: memtest.a65
	$(CA) $(AFLAGS) -o memtest.o memtest.a65
memtest.bin: memtest.o
	$(CL) $(LFLAGS) -C aim-65.cfg -o memtest.bin memtest.o
	
	if ./checksum.pl memtest.bin memtest.a65 -ne 0; then \
		true; \
	else \
		make; \
	fi

clean:
	$(RM) $(RMFLAGS) *.o *.bin *.bin.bak

test: memtest.bin
	cp memtest.bin $(HOME)/.mame/roms/aim65/aim65mon.z23
	cp memtest.bin $(HOME)/.mame/roms/aim65/aim65mon.z22
	mame aim65 -debug
