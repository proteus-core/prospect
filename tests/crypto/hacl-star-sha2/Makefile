KERNEL_DIR = ../kernel
HACL_STAR_DIR = ./hacl-star
HACL_STAR_SRC_DIR = $(HACL_STAR_DIR)/dist/portable-gcc-compatible
KREMLIN_INCLUDE_DIR = ./include
KREMLIB_INCLUDE_DIR = ./include/kremlib

EXTRA_CFLAGS = -I$(KREMLIN_INCLUDE_DIR) -I$(KREMLIB_INCLUDE_DIR)

TARGET = sha2

all: $(TARGET).bin $(TARGET).ihex $(TARGET).objdump

include $(KERNEL_DIR)/Makefile.include

%.S: %.c
	$(CC) $(CFLAGS) -o $@ -S $^

$(TARGET).elf: $(TARGET).S Hacl_Hash_SHA2.S clear.S $(EXTRA_OBJECTS) $(KERNEL_LIB)
	$(CC) $(CFLAGS) -T $(KERNEL_DIR)/link.ld -o $@ $^

$(TARGET).objdump: $(TARGET).elf
	$(OBJDUMP) -d $^ > $@

clean:
	rm -f *.elf *.bin *.ihex *.o *.objdump

clean-all: clean
	rm -f *.S
