# Running HACL*/Chacha20 on Proteus/Prospect

## Files

- `chacha20.c`: encrypts a 72 bytes array and prints the result
- `chacha20.S`: assembly code of `chacha20.c`, modified to clear secrets from
  register after the execution of the cryptographic primitive (so they are not
  written to public memory locations, e.g. on the stack, afterwards). Note that
  if you modify `chacha20.c` you'll have to remove `chacha20.S` before recompiling
  with the Makefile.
- `Hacl_Hash_Chacha20.c`: implementation of the `Hacl_Chacha20_chacha20_encrypt` primitive.

Secrets local variables have been annotated using:
``` c
__attribute__((section(".secret"))) static
```

`chacha20.c`, `Hacl_Hash_CHACHA20.c` and `include/kremlin/lowstar_endianness.h`
have been modified to annotate secrets. In total, `51` annotations were added to
mark all secret variables.

Approximate time to place all annotation and make sure that no secrets are
written to public location: 1h

## Building & running
### Prerequisites
- [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) configured like this:
```
./configure --prefix=... --with-arch=rv32im --with-abi=ilp32
```

### Building
Build with `make`.

This creates `chacha20.bin` and `chacha20.ihex` which can be simulated on Proteus.

### Running
Secret initialization in Proteus/Prospect:
``` scala
def isSecret(address: UInt): Bool = {
  val beg  = U"32'h80016a3c"
  val size = U"h1f4"
  (beg <= address) && (address < (beg + size))
}
``` 

Expected output:
```
44b302f763d628b29928366a0ea744edc74786ad03bf95cb35774cd29eafbaaf
```

## Track secret spilling to the stack
It is important to make sure that secrets are not written to non secret memory
locations. Typically this can happen when secrets are copied to local variables
on the stack, registers are saved on the stack to respect calling conventions,
or registers are spilled on the stack by the compiler when all data do not fit
in registers.

We make sure that this does not happen in this program. We use Proteus/Prospect
secret tracking to flag secrets that are written to public locations.

After the execution of the hash function, the result is declassified. Memory
used for declassification is marked in Proteus/Prospect using the following
code:

``` scala
def isDeclassified(address: UInt): Bool = {
  val beg  = U"32'h800169e8"
  val size = U"h48"
  (beg <= address) && (address < (beg + size))
}
```


In addition, after declassification we add a few lines of assembly code to `chacha20.S` to clear registers:
```
	# Begin: Extra code to clear secrets from registers
	addi    sp,sp,-4
    sw      s1,0(sp)
	call clear_s_regs
	call clear_t_regs
    lw      s1,0(sp)
    addi    sp,sp,4
	# End
```
