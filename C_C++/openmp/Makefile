all: openmp_test

openmp_test: openmp_test.c
	gcc -Wall -Werror -pedantic -std=c99 -lpthread -lm -fopenmp -o $@ $^

.phony=clean
clean:
	rm -f openmp_test