#ifndef CURVE25519_DONNA_H_
#define CURVE25519_DONNA_H_
#include <string.h>
#include <stdint.h>

typedef uint8_t u8;
typedef int32_t s32;
typedef int64_t limb;

int curve25519_donna(u8 *mypublic, const u8 *secret, const u8 *basepoint);

#endif // CURVE25519-DONNA_H_
