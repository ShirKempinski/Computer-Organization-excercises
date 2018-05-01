/**
 * 312253719   Shir Kempinski
 */
#include "ex1.h"
#include <stdio.h>


/**
 * A pointer to int will always point to it's first byte out of the four. When setting a pointer to
 * point at an unsigned int with the value 1, the machine will receive different information about
 * the first byte, depending on the endian. If the machine is litlle-endian, this byte would be 0.
 * otherwise, it would be 1.
 */
int is_little_endian() {
	unsigned int x = 1;
	char* p = (char*)&x;
	if ((int) *p == 0) {
		return 0;
	}
	return 1;
}

/**
 * In order to replace a hexa-decimal number with it's least significant byte, we will divide it
 * by 16^2 and take the remain, because a byte contains 2 hexa digits.
 *
 * In order to cut out the least significant byte of a hexa-decimal number, we will subtract the
 * the remain on it's division by 16^2.
 *
 * The result would be the sum of x and y.
 */
unsigned long merge_bytes(unsigned long x, unsigned long y) {
	// Turn y to it's least significant byte
	y = y % 256;
	// Subtract x's least significant byte from x
	x -= x % 256;
	return x + y;
}

/**
 * In order to replace a byte in an unsigned long, first we need to "clean" the index it would
 * enter, to put the byte in the right index, and then we can add them to the desired result.
 * I chose to implement the "cleaning" part by creating a bitwise mask and use it on x, then I
 * shifted b to the right index, and returned their sum.
 */
unsigned long put_byte(unsigned long x, unsigned char b, int i) {
	int byteSize = 8;

	// make a mask according to i
	unsigned long mask = 0xFF;
	mask = mask << byteSize * i;
	mask = ~mask;

	// make the i'th byte of x 00
	x = x & mask;

	// make b long and shift it to the i'th byte
	unsigned long longB = b;
	longB = longB << byteSize * i;

	// add longB to x and return it
	x = x + longB;
	return x;
}
