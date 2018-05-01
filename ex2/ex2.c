// 312253719 Shir Kempinski

#include <stdio.h>
#include <string.h>

#define NUM_UTF16_BYTES 2

void copyFile(char*, char*);
void copyFromDifferentOS(char*, char*, char*, char*);
void copyFileSwapEndian(char*, char*, char*, char*);


int main(int argc, char** argv) {
	// validate that the source file exist
	if (argc > 1) {
		FILE* f = fopen(argv[1], "rb");
		if (f == NULL) {
			return 0;
		}
	}
	// switch between options according to amount of received arguments
	switch(argc - 1) {

	case 2:
		// to copy the file we call copyFile()
		copyFile(argv[1], argv[2]);
		break;

	case 4:
		// validate that the 4th string is a flag
		if (strcmp(argv[4],"-unix") && strcmp(argv[4],"-mac") && strcmp(argv[4], "-win")) {
			return 0;
		}
		// to copy the file regarding os we call copyFromDifferentOS()
		copyFromDifferentOS(argv[1], argv[2], argv[3], argv[4]);
		break;

	case 5:
		// to keep the endian, we call copyFromDifferentOS()
		if (!strcmp(argv[5], "-keep")) {
			copyFromDifferentOS(argv[1], argv[2], argv[3], argv[4]);
		}
		// to swap endians, we call copyFileSwapEndian()
		if (!strcmp(argv[5], "-swap")) {
			copyFileSwapEndian(argv[1], argv[2], argv[3], argv[4]);
		}
		break;

	// for any other arguments
	default:
		break;
	}

	return 0;
}


/**
 * name: copyFile
 * input: two strings (file names)
 * output: void
 * operation: copy the first file to the destination file
 */
void copyFile(char* sorce, char* destination) {
	// open the source file and the destination file
	FILE* src = fopen(sorce, "rb");
	FILE* dest = fopen(destination, "wb");
	// create a buffer to read to
	char buffer[NUM_UTF16_BYTES];
	size_t size;

	do {
		// read 2 bytes from the source to the buffer
		size = fread(buffer, sizeof(char), NUM_UTF16_BYTES, src);
		// write them to the destination
		fwrite(buffer, sizeof(char), size, dest);
	// do it while there's at least one more byte to read from the buffer
	} while (size);

	// close the files
	fclose(src);
	fclose(dest);
}


/**
 * name: copyFromDifferentOS
 * input: 4 strings (source and destination file names and source and destination operation
 * systems flags)
 * output: void
 * operation: copy the source file to the destination file, adjusting the new line symbol to the
 * destined operation system while keeping the file's endian as it was.
 */
void copyFromDifferentOS(char* sFile, char* dFile, char* sOS, char* dOS) {
	//open the files
	FILE* src = fopen(sFile, "rb");
	FILE* dest = fopen(dFile, "wb");
	// create a buffer to read to
	char buffer[NUM_UTF16_BYTES];
	size_t size;

	do {
		size = fread(buffer, sizeof(char), NUM_UTF16_BYTES, src);
		// if the next byte is for a new line
		if ((buffer[0] == '\n' && buffer[1] == '\0')
				|| (buffer[1] == '\n' && buffer[0] == '\0')
				|| (buffer[0] == '\r' && buffer[1] == '\0')
				|| (buffer[1] == '\r' && buffer[0] == '\0')) {
			// if the source operation system is windows, read the next byte as well
			if (!strcmp(sOS, "-win")) {
				size = fread(buffer, sizeof(char), NUM_UTF16_BYTES, src);
			}
			// if we are translating the file to unix
			if (!strcmp(dOS, "-unix")) {
				// preserve the endian
				if (buffer[0] == '\0') {
					buffer[1] = '\n';
				} else {
					buffer[0] = '\n';
					buffer[1] = '\0';
				}
			}
			// if we are translating the file to mac
			if (!strcmp(dOS, "-mac")) {
				// preserve the endian
				if (buffer[0] == '\0') {
					buffer[1] = '\r';
				} else {
					buffer[0] = '\r';
					buffer[1] = '\0';
				}
			}
			// if we are translating the file to windows
			if (!strcmp(dOS, "-win")) {
				// preserve the endian
				if (buffer[0] == '\0') {
					buffer[1] = '\r';
				} else {
					buffer[0] = '\r';
					buffer[1] = '\0';
				}
				// write the /r byte
				fwrite(buffer, sizeof(char), size, dest);
				// set the buffer to be /n, while preserving the endian
				if (buffer[0] == '\0') {
					buffer[1] = '\n';
				} else {
					buffer[0] = '\n';
					buffer[1] = '\0';
				}
			}
		}
		// write from the buffer to the file
		fwrite(buffer, sizeof(char), size, dest);
	// as long as there are more bytes to read
	} while (size);
	// close the files
	fclose(src);
	fclose(dest);
}

/**
 * name: copyFileSwapEndian
 * input: 4 strings (source and destination file names and source and destination operation
 * systems)
 * output: void
 * operation: copy the source file to the destination file, adjusting the new line symbol to the
 * destined operation system and changing the endian.
 */
void copyFileSwapEndian(char* sFile, char* dFile, char* sOS, char* dOS) {
	// open the files
	FILE* src = fopen(sFile, "rb");
	FILE* dest = fopen(dFile, "wb");
	// create a buffer to read to
	char buffer[NUM_UTF16_BYTES];
	size_t size;

	do {
		size = fread(buffer, sizeof(char), NUM_UTF16_BYTES, src);
		// if the next byte is for a new line
		if ((buffer[0] == '\n' && buffer[1] == '\0')
						|| (buffer[1] == '\n' && buffer[0] == '\0')
						|| (buffer[0] == '\r' && buffer[1] == '\0')
						|| (buffer[1] == '\r' && buffer[0] == '\0')) {
			// if the source operating system is windows, read the next byte as well
			if (!strcmp(sOS, "-win")) {
				size = fread(buffer, sizeof(char), NUM_UTF16_BYTES, src);
			}
			// if we are translating the file to unix
			if (!strcmp(dOS, "-unix")) {
				// swap the current endian
				if (buffer[1] == '\0') {
					buffer[1] = '\n';
					buffer[0] = '\0';
				} else {
					buffer[0] = '\n';
					buffer[1] = '\0';
				}
			}
			// if we are translating the file to mac
			if (!strcmp(dOS, "-mac")) {
				// swap the current endian
				if (buffer[1] == '\0') {
					buffer[0] = '\0';
					buffer[1] = '\r';
				} else {
					buffer[0] = '\r';
					buffer[1] = '\0';
				}
			}
			// if we are translating the file to windows
			if (!strcmp(dOS, "-win")) {
				// swap the current endian
				if (buffer[1] == '\0') {
					buffer[0] = '\0';
					buffer[1] = '\r';
				} else {
					buffer[0] = '\r';
					buffer[1] = '\0';
				}
				// write the \r byte
				fwrite(buffer, sizeof(char), size, dest);
				// set the buffer to the \n byte, use the same endian that wes used to write \r
				if (buffer[0] == '\0') {
					buffer[0] = '\0';
					buffer[1] = '\n';
				} else {
					buffer[0] = '\n';
					buffer[1] = '\0';
				}
			}
		// for any char that is not new line symbol
		} else {
			// swap the endians
			char temp = buffer[0];
			buffer[0] = buffer[1];
			buffer[1] = temp;
		}
		// write from the buffer to the file
		fwrite(buffer, sizeof(char), size, dest);
	// as long as there are more bytes to read
	} while (size);
	// close the files
	fclose(src);
	fclose(dest);
}
