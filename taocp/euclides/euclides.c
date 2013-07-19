#include <stdio.h>
#include <stdlib.h>

/**
 * Euclid's Algorithm as specified in TAOCP VOL1.
 */
int gcd_euclides(int m, int n)
{
    int r = m%n;
    while ( r ) 
    {
        m = n;
        n = r;
        r = m%n;
    }
    return n;
}

int main(int argc, char **argv)
{
    int n;
    int m;
    printf("Enter two integers:\n");
    scanf("%d %d", &m, &n);
    printf("GCD(%d, %d) = %d\n", m, n, gcd_euclides(m, n));
    return 0;
}
