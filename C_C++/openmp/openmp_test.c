/**
* OpenMP testapplication.
* Sources: http://openmp.org/mp-documents/omp-hands-on-SC08.pdf
*
* @file openmp_test.c
* @author Elie De Brauwer <elie[@]de-brauwer.be>
* @date 20100315
*/

#include <assert.h>
#include <math.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#define __USE_BSD
#include <unistd.h>

/** Call a function, but prints its name and the duration of this function. */
#define TIME(A) printf("%50s: ", #A); fsync(0); timeStart(); A ; timeStop();

/** Number of iterations */
#define NUM_CYCLES (1000000)

/** Used for measuring time */
static struct timeval tvStart;

/** Start measuring time. */
inline static void timeStart()
{
    gettimeofday(&tvStart,NULL);
}

/** End measuring time and print time in us */
inline static void timeStop()
{
    struct timeval tvEnd;
    gettimeofday(&tvEnd, NULL);
    printf("%10ld us\n", (tvEnd.tv_sec-tvStart.tv_sec)*1000000+
                     tvEnd.tv_usec-tvStart.tv_usec);
}

/** Each thread will say hello to standard output.
 * Illustrates the use of private variables and barriers.
 */
void listNumThreads()
{
    int id;
    int num_threads;
#pragma omp parallel private(id)
    {
        num_threads = omp_get_num_threads();
        id = omp_get_thread_num();
        printf("Hello from thread %d/%d\n", id+1, num_threads);
// Only print this summary after all the workers have finished.
#pragma omp barrier
        if (id==0)
        {
            printf("There are %d threads\n", num_threads);
        }
    }

}

/** Calculate some sines and cosines. */
void calculateSines()
{
    double a[NUM_CYCLES];
    int i=0;
    for(i=0; i<NUM_CYCLES; i++)
    {
        a[i]=sin(i)+cos(i);
    }
}

/** Calculate some sines and cosines, omp version.
 * Illustrates the use of omp parallel for.
 */
void calculateSines_omp()
{
    double a[NUM_CYCLES];
    int i=0;
#pragma omp parallel for
    for(i=0; i<NUM_CYCLES; i++)
    {
        a[i]=sin(i)+cos(i);
    }
}

/** Calculate some sines and cosines, omp version.
 * Uses much more threads than the system has to offer
 */
void calculateSinesTooMuchThreads_omp()
{
    double a[NUM_CYCLES];
    int i=0;
#pragma omp parallel num_threads(20)
    for(i=0; i<NUM_CYCLES; i++)
    {
        a[i]=sin(i)+cos(i);
    }
}

#define INT_STEPS (25000000)

/** Performs integration of y=x*x in the interval -1, 1
 * <pre>
octave:1> function y = f(x)
> y=x*x
> endfunction
octave:2> [area,ierror,nfneval]=quad("f",-1,1);
octave:3> area
area =  0.66667
 * </pre>
 * */
void numericalIntegration()
{
    int upper=1;
    int lower=-1;
    int i=0;
    double res=0;
    double stepsize = (upper-lower)/(double)INT_STEPS;
    for(i=0; i<INT_STEPS; i++)
    {
        double x = lower + (i+0.5)*stepsize;
        res += x*x*stepsize;
    }
    //printf("%f\n", res);
    assert(res > 0.6666666 && res < 0.6666667);
}

/** Performs integration of y=x*x in the interval -1, 1.
 * OMP version.
 */
void numericalIntegration_omp_parallel()
{
    int upper=1;
    int lower=-1;
    double res=0;
    double stepsize = (upper-lower)/(double)INT_STEPS;
#pragma omp parallel
    {
        double temp_res=0;
        int num_threads = omp_get_num_threads();
        int id = omp_get_thread_num();
        int i=0;         //!< i is private !
        for(i=id; i<INT_STEPS; i+=num_threads) //!< Mind the interleaving here
        {
            double x = lower + (i+0.5)*stepsize;
            temp_res += x*x*stepsize;
        }
// Synchronize here
#pragma omp atomic
        res += temp_res;
    }
    assert(res > 0.6666666 && res < 0.6666667);
}

/** Performs integration of y=x*x in the interval -1, 1.
 * OMP version, using for and reduce.
 */
void numericalIntegration_omp_for()
{
    int upper=1;
    int lower=-1;
    double res=0;
    double stepsize = (upper-lower)/(double)INT_STEPS;
    double x=0;
    int i=0;
#pragma omp parallel for private(x) reduction(+:res)
        for(i=0; i<INT_STEPS; i++)
        {
            x = lower + (i+0.5)*stepsize;
            res += x*x*stepsize;
        }
    assert(res > 0.6666666 && res < 0.6666667);
}

/** Illustrates the use of a simple lock.
 */
void lockDemo()
{
    omp_lock_t lock;
    omp_init_lock(&lock);
#pragma omp parallel
    {
        omp_set_lock(&lock);
        //printf("[%d] took the lock\n", omp_get_thread_num());
        omp_unset_lock(&lock);
    }
    omp_destroy_lock(&lock);
}

#define MONTE_CARLO_NUM  (10000000)

/**
 * Apparently the stdlib random is VEEEERY openmp unfriendly, it stores
 * variable information in private context which results in a looooots of
 * futexes. Hence a reentrant pseudo random number generator has been
 * borrowed from: http://en.wikipedia.org/wiki/Random_number_generation
 */
unsigned int magic_random(unsigned int *m_z, unsigned int *m_w)
{
    *m_z = 36969 * (*m_z & 65535) + (*m_z >> 16);
    *m_w = 18000 * (*m_w & 65535) + (*m_w >> 16);
    return (*m_z << 16) + *m_w;  /* 32-bit result */

}

/** Calculates Pi based on a Monte Carlo simulation
 * Area_circle = pi*r*r
 * Area_square = 2*r*2*r
 * Now the chance that a random point lies within the circle is
 * P = Area_circle/Area_square = pi/4
 *
 * Note: random generator is not seeded.
 */
void monteCarloPiGenerator()
{
    int i = 0;
    const double RADIUS = 1.0;
    int num_in_circle = 0;
    unsigned int mz=1;
    unsigned int mw=2;
    for (i=0; i<MONTE_CARLO_NUM; i++)
    {
        double x = 2.0*magic_random(&mz, &mw)/0xffffffff - 1;
        double y = 2.0*magic_random(&mz, &mw)/0xffffffff - 1;
        //assert(x>=-1 && x<=1 && y>=-1 && y<=1);
        if (x*x + y*y <= RADIUS*RADIUS)
        {
            num_in_circle++;
        }
    }
    double pi = 4.0*num_in_circle/MONTE_CARLO_NUM;
    //printf("Pi: %f\n", pi);
    assert(pi > 3.140 && pi < 3.143);
}

/** monteCarloPiGenerator extended with a parallel for and a reduction,
 * illustrates private variables, requires a special randon number generator.
 */
void monteCarloPiGenerator_omp()
{
    int i = 0;
    const double RADIUS = 1.0;
    int num_in_circle = 0;
    double x;
    double y;
    unsigned int mz=1;
    unsigned int mw=2;
#pragma omp parallel private(x,y,mz,mw) reduction(+:num_in_circle)
    {
        mz=1;
        mw=2;
#pragma omp for
    for (i=0; i<MONTE_CARLO_NUM; i++)
    {
        x = 2.0*magic_random(&mz, &mw)/0xffffffff - 1;
        y = 2.0*magic_random(&mz, &mw)/0xffffffff - 1;
        //assert(x>=-1 && x<=1 && y>=-1 && y<=1);
        if (x*x + y*y <= RADIUS*RADIUS)
        {
            num_in_circle++;
        }
    }
    }
    double pi = 4.0*num_in_circle/MONTE_CARLO_NUM;
    //printf("Pi: %f\n", pi);
    assert(pi > 3.140 && pi < 3.143);
}

int main()
{
    listNumThreads();
    TIME(calculateSines());
    TIME(calculateSines_omp());
    // I have the impression that the following function can trigger
    // segfaults/stack corruption. This mainly happens on a system equipped
    // with two processors + hyperthreading.
    TIME(calculateSinesTooMuchThreads_omp());
    TIME(numericalIntegration());
    TIME(numericalIntegration_omp_parallel());
    TIME(numericalIntegration_omp_for());
    TIME(lockDemo());
    TIME(monteCarloPiGenerator());
    TIME(monteCarloPiGenerator_omp());
    return 0;
}
