/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly,
              Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.posix.time;

private import core.sys.posix.config;
public import core.stdc.time;
public import core.sys.posix.sys.types;
public import core.sys.posix.signal; // for sigevent

version (Posix):
extern (C):
nothrow:
@nogc:

//
// Required (defined in core.stdc.time)
//
/*
char* asctime(in tm*);
clock_t clock();
char* ctime(in time_t*);
double difftime(time_t, time_t);
tm* gmtime(in time_t*);
tm* localtime(in time_t*);
time_t mktime(tm*);
size_t strftime(char*, size_t, in char*, in tm*);
time_t time(time_t*);
*/

version( CRuntime_Glibc )
{
    time_t timegm(tm*); // non-standard
}
else version( OSX )
{
    time_t timegm(tm*); // non-standard
}
else version( FreeBSD )
{
    time_t timegm(tm*); // non-standard
}
else version (Solaris)
{
    time_t timegm(tm*); // non-standard
}
else version (CRuntime_Bionic)
{
    // Not supported.
}
else
{
    static assert(false, "Unsupported platform");
}

//
// C Extension (CX)
// (defined in core.stdc.time)
//
/*
char* tzname[];
void tzset();
*/

//
// Process CPU-Time Clocks (CPT)
//
/*
int clock_getcpuclockid(pid_t, clockid_t*);
*/

//
// Clock Selection (CS)
//
/*
int clock_nanosleep(clockid_t, int, in timespec*, timespec*);
*/

//
// Monotonic Clock (MON)
//
/*
CLOCK_MONOTONIC
*/

version( linux )
{
    enum CLOCK_MONOTONIC          = 1;
    // To be removed in December 2015.
    static import core.sys.linux.time;
    deprecated("Please import it from core.sys.linux.time instead.")
        alias CLOCK_MONOTONIC_RAW = core.sys.linux.time.CLOCK_MONOTONIC_RAW; // non-standard
    deprecated("Please import it from core.sys.linux.time instead.")
        alias CLOCK_MONOTONIC_COARSE = core.sys.linux.time.CLOCK_MONOTONIC_COARSE; // non-standard
}
else version (FreeBSD)
{   // time.h
    enum CLOCK_MONOTONIC         = 4;
    // To be removed in December 2015.
    static import core.sys.freebsd.time;
    deprecated("Please import it from core.sys.freebsd.time instead.")
        alias CLOCK_MONOTONIC_PRECISE = core.sys.freebsd.time.CLOCK_MONOTONIC_PRECISE;
    deprecated("Please import it from core.sys.freebsd.time instead.")
        alias CLOCK_MONOTONIC_FAST = core.sys.freebsd.time.CLOCK_MONOTONIC_FAST;
}
else version (OSX)
{
    // No CLOCK_MONOTONIC defined
}
else version (Solaris)
{
    enum CLOCK_MONOTONIC = 4;
}
else
{
    static assert(0);
}

//
// Timer (TMR)
//
/*
CLOCK_PROCESS_CPUTIME_ID (TMR|CPT)
CLOCK_THREAD_CPUTIME_ID (TMR|TCT)

NOTE: timespec must be defined in core.sys.posix.signal to break
      a circular import.

struct timespec
{
    time_t  tv_sec;
    int     tv_nsec;
}

struct itimerspec
{
    timespec it_interval;
    timespec it_value;
}

CLOCK_REALTIME
TIMER_ABSTIME

clockid_t
timer_t

int clock_getres(clockid_t, timespec*);
int clock_gettime(clockid_t, timespec*);
int clock_settime(clockid_t, in timespec*);
int nanosleep(in timespec*, timespec*);
int timer_create(clockid_t, sigevent*, timer_t*);
int timer_delete(timer_t);
int timer_gettime(timer_t, itimerspec*);
int timer_getoverrun(timer_t);
int timer_settime(timer_t, int, in itimerspec*, itimerspec*);
*/

version( CRuntime_Glibc )
{
    enum CLOCK_PROCESS_CPUTIME_ID = 2;
    enum CLOCK_THREAD_CPUTIME_ID  = 3;

    // NOTE: See above for why this is commented out.
    //
    //struct timespec
    //{
    //    time_t  tv_sec;
    //    c_long  tv_nsec;
    //}

    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }

    enum CLOCK_REALTIME         = 0;
    // To be removed in December 2015.
    static import core.sys.linux.time;
    deprecated("Please import it from core.sys.linux.time instead.")
        alias CLOCK_REALTIME_COARSE = core.sys.linux.time.CLOCK_REALTIME_COARSE; // non-standard
    enum TIMER_ABSTIME          = 0x01;

    alias int clockid_t;
    alias int timer_t;

    int clock_getres(clockid_t, timespec*);
    int clock_gettime(clockid_t, timespec*);
    int clock_settime(clockid_t, in timespec*);
    int nanosleep(in timespec*, timespec*);
    int timer_create(clockid_t, sigevent*, timer_t*);
    int timer_delete(timer_t);
    int timer_gettime(timer_t, itimerspec*);
    int timer_getoverrun(timer_t);
    int timer_settime(timer_t, int, in itimerspec*, itimerspec*);
}
else version( OSX )
{
    int nanosleep(in timespec*, timespec*);
}
else version( FreeBSD )
{
    //enum CLOCK_PROCESS_CPUTIME_ID = ??;
    enum CLOCK_THREAD_CPUTIME_ID  = 15;

    // NOTE: See above for why this is commented out.
    //
    //struct timespec
    //{
    //    time_t  tv_sec;
    //    c_long  tv_nsec;
    //}

    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }

    enum CLOCK_REALTIME      = 0;
    enum TIMER_ABSTIME       = 0x01;

    alias int clockid_t; // <sys/_types.h>
    alias int timer_t;

    int clock_getres(clockid_t, timespec*);
    int clock_gettime(clockid_t, timespec*);
    int clock_settime(clockid_t, in timespec*);
    int nanosleep(in timespec*, timespec*);
    int timer_create(clockid_t, sigevent*, timer_t*);
    int timer_delete(timer_t);
    int timer_gettime(timer_t, itimerspec*);
    int timer_getoverrun(timer_t);
    int timer_settime(timer_t, int, in itimerspec*, itimerspec*);
}
else version (Solaris)
{
    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }

    enum CLOCK_REALTIME = 0; // <sys/time_impl.h>
    enum TIMER_ABSOLUTE = 0x1;

    alias int clockid_t;
    alias int timer_t;

    int clock_getres(clockid_t, timespec*);
    int clock_gettime(clockid_t, timespec*);
    int clock_settime(clockid_t, in timespec*);
    int clock_nanosleep(clockid_t, int, in timespec*, timespec*);

    int nanosleep(in timespec*, timespec*);

    int timer_create(clockid_t, sigevent*, timer_t*);
    int timer_delete(timer_t);
    int timer_getoverrun(timer_t);
    int timer_gettime(timer_t, itimerspec*);
    int timer_settime(timer_t, int, in itimerspec*, itimerspec*);
}
else version( CRuntime_Bionic )
{
    enum CLOCK_PROCESS_CPUTIME_ID = 2;
    enum CLOCK_THREAD_CPUTIME_ID  = 3;

    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }

    enum CLOCK_REALTIME    = 0;
    enum CLOCK_REALTIME_HR = 4;
    enum TIMER_ABSTIME     = 0x01;

    alias int clockid_t;
    alias int timer_t;

    int clock_getres(int, timespec*);
    int clock_gettime(int, timespec*);
    int nanosleep(in timespec*, timespec*);
    int timer_create(int, sigevent*, timer_t*);
    int timer_delete(timer_t);
    int timer_gettime(timer_t, itimerspec*);
    int timer_getoverrun(timer_t);
    int timer_settime(timer_t, int, in itimerspec*, itimerspec*);
}
else
{
    static assert(false, "Unsupported platform");
}

//
// Thread-Safe Functions (TSF)
//
/*
char* asctime_r(in tm*, char*);
char* ctime_r(in time_t*, char*);
tm*   gmtime_r(in time_t*, tm*);
tm*   localtime_r(in time_t*, tm*);
*/

version( linux )
{
    char* asctime_r(in tm*, char*);
    char* ctime_r(in time_t*, char*);
    tm*   gmtime_r(in time_t*, tm*);
    tm*   localtime_r(in time_t*, tm*);
}
else version( OSX )
{
    char* asctime_r(in tm*, char*);
    char* ctime_r(in time_t*, char*);
    tm*   gmtime_r(in time_t*, tm*);
    tm*   localtime_r(in time_t*, tm*);
}
else version( FreeBSD )
{
    char* asctime_r(in tm*, char*);
    char* ctime_r(in time_t*, char*);
    tm*   gmtime_r(in time_t*, tm*);
    tm*   localtime_r(in time_t*, tm*);
}
else version (Solaris)
{
    char* asctime_r(in tm*, char*);
    char* ctime_r(in time_t*, char*);
    tm* gmtime_r(in time_t*, tm*);
    tm* localtime_r(in time_t*, tm*);
}
else version (Android)
{
    char* asctime_r(in tm*, char*);
    char* ctime_r(in time_t*, char*);
    tm* gmtime_r(in time_t*, tm*);
    tm* localtime_r(in time_t*, tm*);
}
else
{
    static assert(false, "Unsupported platform");
}

//
// XOpen (XSI)
//
/*
getdate_err

int daylight;
int timezone;

tm* getdate(in char*);
char* strptime(in char*, in char*, tm*);
*/

version( CRuntime_Glibc )
{
    extern __gshared int    daylight;
    extern __gshared c_long timezone;

    tm*   getdate(in char*);
    char* strptime(in char*, in char*, tm*);
}
else version( OSX )
{
    extern __gshared c_long timezone;
    extern __gshared int    daylight;

    tm*   getdate(in char*);
    char* strptime(in char*, in char*, tm*);
}
else version( FreeBSD )
{
    //tm*   getdate(in char*);
    char* strptime(in char*, in char*, tm*);
}
else version (Solaris)
{
    extern __gshared c_long timezone, altzone;
    extern __gshared int daylight;

    tm* getdate(in char*);
    char* __strptime_dontzero(in char*, in char*, tm*);
    alias __strptime_dontzero strptime;
}
else version( CRuntime_Bionic )
{
    extern __gshared int    daylight;
    extern __gshared c_long timezone;

    char* strptime(in char*, in char*, tm*);
}
else
{
    static assert(false, "Unsupported platform");
}
