# Running djbsort on Proteus/Prospect
Source: https://sorting.cr.yp.to/


## Files

- `sort_portable3_int32.c`: sorts an array of 100 integers and prints the result
- `sort_portable3_int32.S`: assembly code of `sort_portable3_int32.c`, modified
  to clear secrets from register after the execution of the cryptographic
  primitive (so they are not written to public memory locations, e.g. on the
  stack, afterwards).
- `Hacl_Hash_Sort_Portable3_Int32.c`: implementation of the
  `Hacl_Sort_Portable3_Int32_sort_portable3_int32_encrypt` primitive.

Secrets local variables have been annotated using:
``` c
__attribute__((section(".secret"))) static
```

`include/int32_minmax.c`, and `sort_portable.h` have been modified to annotate
secrets. In total, `3` annotations were added to mark all secret variables.

Approximate time to place all annotation and make sure that no secrets are
written to public location: 15 minutes.

## Building & running
### Prerequisites
- [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) configured like this:
```
./configure --prefix=... --with-arch=rv32im --with-abi=ilp32
```

### Building
Build with `make`.

This creates `sort_portable3_int32.bin` and `sort_portable3_int32.ihex` which can be simulated on Proteus.

### Running
Secret initialization in Proteus/Prospect:
``` scala
  def isSecret(address: UInt): Bool = {
    val beg  = U"32'h80016b78"
    val size = U"h1000"
    (beg <= address) && (address < (beg + size))
  }
``` 

Expected output:
```
-2146145426, -2140970695, -2138189220, -2066822708, -2020463147, -1993129414, -1968673625, -1963648433, -1905600324, -1880154419, -1867945926, -1801530940, -1734385968, -1728610361, -1714382897, -1642993663, -1605360954, -1587094956, -1549526339, -1499870478, -1485674780, -1447658864, -1427011898, -1426643498, -1421549973, -1328075934, -1304126335, -1298331600, -1254484560, -1189059682, -1160270262, -1151519083, -1091265752, -1090640678, -1063317603, -1045253924, -1020072025, -877848241, -816909325, -797139254, -698362427, -617165524, -541388015, -415438466, -285151633, -237591441, -215916430, -206865293, -203785593, -150318639, -139293294, -98028038, -69177470, 34189155, 66038476, 74853925, 150845537, 218026900, 262483564, 294564392, 401116445, 484883238, 612697149, 617974680, 662547550, 734454147, 752439642, 767837347, 894314873, 895618226, 927332899, 929601107, 990848096, 1052278174, 1055172670, 1183000654, 1200996386, 1277220282, 1288724798, 1340689750, 1466064160, 1495627926, 1509419382, 1514426698, 1678133540, 1687937690, 1729398488, 1746213912, 1761250325, 1853149532, 1854327580, 1860973408, 1896026900, 1977662117, 2014423160, 2038347355, 2074955874, 2109025036, 2135181530, 2137921753,
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
    val size = U"h190"
    (beg <= address) && (address < (beg + size))
  }
```


In addition, after declassification we add a few lines of assembly code to `sort_portable3_int32.S` to clear registers:
```asm
# Begin: Extra code to clear secrets from registers
addi    sp,sp,-4
sw      s2,0(sp)
call clear_s_regs
call clear_t_regs
lw      s2,0(sp)
addi    sp,sp,4
# End
```
