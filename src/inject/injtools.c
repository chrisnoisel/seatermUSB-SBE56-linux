#include <stdio.h>
#include <stdarg.h>
#include "injtools.h"

// https://gist.github.com/ccbrown/9722406
void INJ_printhex(const void* data, size_t size) {
	char ascii[17];
	size_t i, j;
	ascii[16] = '\0';
	for (i = 0; i < size; ++i)
	{
		fprintf(stderr, "%02X ", ((unsigned char*)data)[i]);
		ascii[i % 16] = (((unsigned char*)data)[i] >= ' ' && ((unsigned char*)data)[i] <= '~') ? ((unsigned char*)data)[i] : '.';
		
		if ((i+1) % 8 == 0 || i+1 == size) 
		{
			fprintf(stderr, " ");
			if ((i+1) % 16 == 0)
				fprintf(stderr, "|  %s \n", ascii);
				
			else if (i+1 == size) {
				ascii[(i+1) % 16] = '\0';
				if ((i+1) % 16 <= 8)
					fprintf(stderr, " ");
				for (j = (i+1) % 16; j < 16; ++j)
					fprintf(stderr, "   ");
				fprintf(stderr, "|  %s \n", ascii);
			}
		}
	}
}

void INJ_dbgprint(char *fmt, ...) 
{
	FILE * pFile;
	va_list args;
	//pFile = fopen ("/tmp/dump_socket.txt","a");
	va_start (args, fmt);
	vfprintf(stderr, fmt, args);
	va_end (args);
}