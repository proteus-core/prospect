#define int32_MINMAX(a,b) \
do { \
  __attribute__((section(".secret"))) static int32 ab; \
  ab = b ^ a;                                          \
  __attribute__((section(".secret"))) static int32 c;  \
  c = b - a;                                           \
  c ^= ab & (c ^ b);                                   \
  c >>= 31;                                            \
  c &= ab;                                             \
  a ^= c;                                              \
  b ^= c;                                              \
} while(0)
