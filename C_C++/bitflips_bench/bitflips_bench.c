#include <string.h>
#include <sys/time.h>
#include <stdio.h>
#include <assert.h>

unsigned int hweight8(unsigned int w)
{
        unsigned int res = w - ((w >> 1) & 0x55);
        res = (res & 0x33) + ((res >> 2) & 0x33);
        return (res + (res >> 4)) & 0x0F;
}

static unsigned int erased_sector_bitflips(unsigned char *data,
					   unsigned int chunk_size)
{
        unsigned int flip_bits = 0;
        int i;
        int base = 0;
        int tmp;

        for (i = 0; i < chunk_size; i++) {
                tmp = hweight8(~data[base + i]);

                if (tmp) {
                        data[base + i] = 0xff;
                        flip_bits += tmp;
                }
        }

        return flip_bits;
}

static unsigned int erased_sector_bitflips_omap(unsigned char *data,
					   unsigned int chunk_size)
{
	unsigned int flip_bits = 0;
	int i;
	int base = 0;

	/* Count bitflips */
	for (i = 0; i < chunk_size; i++)
		flip_bits += hweight8(~data[base + i]);

	/* Correct bitflips by 0xFF'ing this chunk. */
	if (flip_bits)
		memset(&data[base], 0xFF, chunk_size);

	return flip_bits;
}

int main()
{
	int i = 0;
	int NUM_ITER = 1000;
	int BUFF_SIZE = 4096;
	int NUM_BITFLIPS = 10;
	unsigned char buff[BUFF_SIZE];
	struct timeval tv1, tv2;
	memset(buff, 0xFF, BUFF_SIZE);

	gettimeofday(&tv1, NULL);
	for (i = 0; i < NUM_ITER; i++)
	{
		int j = 0;
		for (j = 0; j < NUM_BITFLIPS; j++)
		{
			buff[j] = 0xFE;
		}
		assert(erased_sector_bitflips_omap(buff, BUFF_SIZE) == NUM_BITFLIPS);
	}
	gettimeofday(&tv2, NULL);
	printf("omap  : %ld usec\n", (tv2.tv_sec - tv1.tv_sec) * 1000000 + tv2.tv_usec - tv1.tv_usec);

	gettimeofday(&tv1, NULL);
	for (i = 0; i < NUM_ITER; i++)
	{
		int j = 0;
		for (j = 0; j < NUM_BITFLIPS; j++)
		{
			buff[j] = 0xFE;
		}
		assert(erased_sector_bitflips(buff, BUFF_SIZE) == NUM_BITFLIPS);
	}
	gettimeofday(&tv2, NULL);
	printf("speedy: %ld usec\n", (tv2.tv_sec - tv1.tv_sec) * 1000000 + tv2.tv_usec - tv1.tv_usec);
	return 0;
}
