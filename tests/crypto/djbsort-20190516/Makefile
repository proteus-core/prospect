KERNEL_DIR = ../kernel
EXTRA_CFLAGS = -I./include

all: sort_portable3_int32.bin sort_portable3_int32.ihex sort_portable3_int32.objdump

# all: sort_portable3_int32.bin sort_portable3_int32.ihex\
# 	 sort_portable3_uint32.bin sort_portable3_uint32.ihex\
# 	 sort_portable4_int32.bin sort_portable4_int32.ihex\
# 	 sort_portable4_uint32.bin sort_portable4_uint32.ihex

include $(KERNEL_DIR)/Makefile.include

%.elf: %.S clear.S $(EXTRA_OBJECTS) $(KERNEL_LIB)
	$(CC) $(CFLAGS) -T $(KERNEL_DIR)/link.ld -o $@ $^

sort_portable3_int32.elf: int32/portable3/sort.S

# sort_portable3_int32.elf: sort_portable3_int32.S int32/portable3/sort.S clear.S $(EXTRA_OBJECTS) $(KERNEL_LIB)
# 	$(CC) $(CFLAGS) -T $(KERNEL_DIR)/link.ld -o $@ $^
sort_portable3_uint32.elf: uint32/portable3/sort.S int32/portable3/sort.S
sort_portable4_int32.elf: int32/portable4/sort.S
sort_portable4_uint32.elf: uint32/portable4/sort.S int32/portable4/sort.S

%.S: %.c
	$(CC) $(CFLAGS) -o $@ -S $^

%.objdump: %.elf
	$(OBJDUMP) $^ -d > $@

clean:
	rm -f *.elf *.bin *.ihex *.o *.objdump *.binsec
