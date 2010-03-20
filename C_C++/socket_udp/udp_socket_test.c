/**
 * Small UDP socket example, it creates a sender thread which puts an
 * integer on a socket, and the main thread starts reading these integers.

 * @file udp_socket_test.c
 * @author Elie De Brauwer <elie[@]de-brauwer.be>
 * @date 20100310
 * @license Simplified BSD
 */

#include <arpa/inet.h>
#include <assert.h>
#include <netinet/ip.h>
#include <pthread.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

/** Port to connect to. */
#define PORT (1234)

/**
 * Sender will put integer on a socket.
 * @param attr Unused
 * @return Nothing.
 */
void * senderThread(void * __attribute((unused)) attr)
{
    int tmp = 0;
    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    assert(sock != -1);

    struct sockaddr_in sa;
    sa.sin_family = AF_INET;
    sa.sin_port = htons(1234);
    sa.sin_addr.s_addr = inet_addr("127.0.0.1");

    assert(connect(sock, (struct sockaddr *)&sa, sizeof(struct sockaddr))==0);

    while (1)
    {
        printf("Tx: %d\n", tmp);
        assert(send(sock, &tmp, sizeof(tmp), 0)==sizeof(tmp));
        tmp++;
    }

    close(sock);
    return NULL;
}

/**
 * Reader will read values from a socket and print these.
 * to standard output.
  */
void reader()
{
    int tmp = 0;
    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    assert(sock != -1);

    struct sockaddr_in sa;
    sa.sin_family = AF_INET;
    sa.sin_port = htons(1234);
    sa.sin_addr.s_addr = INADDR_ANY; // listen on all interfaces
    assert(bind(sock, (struct sockaddr *)&sa, sizeof(struct sockaddr_in))==0);

    //assert(listen(sock, 0)==0);
    while (1)
    {
        assert(recv(sock, &tmp, sizeof(tmp),0)==(sizeof(tmp)));
        printf("Rx: %d\n",tmp);
    }
    close(sock);
}

int main()
{
    // Create a thread for sending data
    pthread_t tid;
    assert(pthread_create(&tid, NULL, senderThread, 0)==0);

    // Start reading data
    reader();
    return 0;
}
