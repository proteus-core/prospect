#include <stdlib.h>
#include <stdio.h>
#include "include/int32_sort.h"
#include "sort_portable.h"

#define SIZE 100 // up to 1024

int32_t *secret = data_int32; // Actual symbol to protect is data_int32
__attribute__((section(".declassified"))) static volatile int32_t declassified[SIZE];

void declassify_secret() {
  long long i;
  for (i = 0; i < SIZE; ++i) {
    declassified[i] = secret[i];
  }
}

int main() {
  long long i;

  // Sort secret array
  int32_sort(secret,SIZE);

  // Declassify secret array
  declassify_secret();

  // Print declassified array
  for (i = 0; i < SIZE; ++i) {
    printf("%ld, ", declassified[i]);
  }
  printf("\n");
}
