all: udp_socket_test

udp_socket_test: udp_socket_test.c
	gcc -Wall -Werror -pedantic -std=c99 -lpthread -o $@ $^

.phony=clean
clean:
	rm -f udp_socket_test