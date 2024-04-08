#ifndef uint32_sort_H
#define uint32_sort_H

#include <stdint.h>

#define uint32_sort djbsort_uint32
#define uint32_sort_implementation djbsort_uint32_implementation
#define uint32_sort_version djbsort_uint32_version
#define uint32_sort_compiler djbsort_uint32_compiler

#ifdef __cplusplus
extern "C" {
#endif

extern void uint32_sort(uint32_t *,long long) __attribute__((visibility("default")));

extern const char uint32_sort_implementation[] __attribute__((visibility("default")));
extern const char uint32_sort_version[] __attribute__((visibility("default")));
extern const char uint32_sort_compiler[] __attribute__((visibility("default")));

#ifdef __cplusplus
}
#endif

#endif
