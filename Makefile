PROJECT_NAME = memtest

AFLAGS		= -t none
LFLAGS		= -t none
RMFLAGS		= -f
 
CC		= cc65
CA		= ca65
CL		= cl65
RM		= rm

TARGET = aim-65

all: clean $(PROJECT_NAME).bin

$(PROJECT_NAME).o: $(PROJECT_NAME).a65
	$(CA) $(AFLAGS) -o $(PROJECT_NAME).o $(PROJECT_NAME).a65
$(PROJECT_NAME).bin: $(PROJECT_NAME).o
	$(CL) $(LFLAGS) -C $(TARGET).cfg -o $(PROJECT_NAME).bin $(PROJECT_NAME).o

clean:
	$(RM) $(RMFLAGS) *.o *.bin *.bin.bak

test: $(PROJECT_NAME).bin
	cp $(PROJECT_NAME).bin $(HOME)/.mame/roms/aim65/aim65mon.z23
	cp $(PROJECT_NAME).bin $(HOME)/.mame/roms/aim65/aim65mon.z22
	mame aim65 -debug
