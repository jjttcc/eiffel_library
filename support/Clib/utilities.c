/**
	description: "Low-level utilities";
	author: "Jim Cochrane"
	date: "$Date$";
	revision: "$Revision$"
	licensing: "Copyright 1998 - 2001: Jim Cochrane - %
		%Released under the Eiffel Forum Freeware License; see file forum.txt"
**/

#include <fcntl.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

/* Simple and completely innaccurate sleep function implemented with loops */
void loop_sleep (int seconds, int microseconds) {
	int i, j, k, dummy;

	for (i = 0; i < seconds; ++i) {
		for (j = 0; j < 1000000; ++j) {
			for (k = 0; k < 19; ++k) {
				dummy += 3;
			}
		}
	}
	for (j = 0; j < microseconds; ++j) {
		for (k = 0; k < 47; ++k) {
			dummy += 3;
		}
	}
}

/* Sleep for `seconds' seconds plus `microseconds' millionths of a seconds.
*  Precondition: microseconds < 1000000 */
void microsleep (int seconds, int microseconds) {
#ifdef NO_NANOSLEEP
	loop_sleep (seconds, microseconds);
#else
	struct timespec timespec;
	timespec.tv_sec = seconds;
	timespec.tv_nsec = microseconds * 1000;

	nanosleep (&timespec, 0);
#endif
}

/* Try to open file `s' if it doesn't exist, returning 0 if successful.  If
 * it exists, if `wait', wait for it to be unlinked; otherwise, return -1.
 * If an error occurs, error_on_last_operation will be true; otherwise, it
 * will be false. */
int try_to_open (char* s, int wait) {
	int result;
	int sleep_msecs = 90000;

	errno = 0;
printf("Locking file %s.\n", s);
	result = open (s, O_RDWR | O_CREAT | O_EXCL);
	if (wait && result == -1) {
		do {
			microsleep (0, sleep_msecs);
			result = open (s, O_RDWR | O_CREAT | O_EXCL);
		} while (result == -1);
	}
	if (result != -1) result = 0;
	return result;
}

/* Did an error occur during the last operation?  Result is boolean - that
 * is, 0 is false, not 0 is true. */
int error_on_last_operation() {
	return errno != 0;
}

/* Remove file with name `s'. Return -1 if operation failed. */
int remove_file (char* s) {
	return unlink (s);
}

/* Description of last error that occurred. */
char* last_c_error() {
	return strerror(errno);
}
