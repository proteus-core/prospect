KERNEL_DIR = ../kernel
HACL_STAR_DIR = ./hacl-star
KREMLIN_INCLUDE_DIR = ./include
KREMLIB_INCLUDE_DIR = ./include/kremlib

# VPATH = $(HACL_STAR_SRC_DIR)
EXTRA_CFLAGS = -I$(KREMLIN_INCLUDE_DIR) -I$(KREMLIB_INCLUDE_DIR)

TARGET = chacha20
DEP = Hacl_Chacha20

all: $(TARGET).bin $(TARGET).ihex $(TARGET).objdump

include $(KERNEL_DIR)/Makefile.include

%.S: %.c
	$(CC) $(CFLAGS) -o $@ -S $^

# $(TARGET).elf: $(TARGET).o $(DEP).o $(EXTRA_OBJECTS) $(KERNEL_LIB)
# 	$(CC) $(CFLAGS) -T $(KERNEL_DIR)/link.ld -o $@ $^

$(TARGET).elf: $(TARGET).S $(DEP).S clear.S $(EXTRA_OBJECTS) $(KERNEL_LIB)
	$(CC) $(CFLAGS) -T $(KERNEL_DIR)/link.ld -o $@ $^

$(TARGET).objdump: $(TARGET).elf
	$(OBJDUMP) -d $^ > $@

clean:
	rm -f *.elf *.bin *.ihex *.o *.objdump

clean-all: clean
	rm -f $(TARGET).S $(DEP).S
