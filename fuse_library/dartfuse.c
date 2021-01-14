#define FUSE_USE_VERSION 26

#include <stdio.h>
#include <fuse.h>
#include <string.h>
#include <errno.h>
#include "dartfuse.h"

typedef int (*dartcb)(const char *path);

static dartcb dartCallbackA;

void hello_world()
{
    printf("Hello World from C\n");
}

void set_callback(dartcb dartfn)
{
    dartCallbackA = dartfn;
}

// example code from: https://github.com/fntlnz/fuse-example

static const char *filepath = "/file";
static const char *filename = "file";
static const char *filecontent = "I'm the content of the only file available there\n";

static int getattr_callback(const char *path, struct stat *stbuf)
{
    int r = dartCallbackA(path);
    printf("native got result from Dart callback: %d \n", r);

    memset(stbuf, 0, sizeof(struct stat));

    if (strcmp(path, "/") == 0)
    {
        stbuf->st_mode = S_IFDIR | 0755;
        stbuf->st_nlink = 2;
        return 0;
    }

    if (strcmp(path, filepath) == 0)
    {
        stbuf->st_mode = S_IFREG | 0777;
        stbuf->st_nlink = 1;
        stbuf->st_size = strlen(filecontent);
        return 0;
    }

    return -ENOENT;
}

static int readdir_callback(const char *path, void *buf, fuse_fill_dir_t filler,
                            off_t offset, struct fuse_file_info *fi)
{
    (void)offset;
    (void)fi;

    filler(buf, ".", NULL, 0);
    filler(buf, "..", NULL, 0);

    filler(buf, filename, NULL, 0);

    return 0;
}

static int open_callback(const char *path, struct fuse_file_info *fi)
{
    return 0;
}

static int read_callback(const char *path, char *buf, size_t size, off_t offset,
                         struct fuse_file_info *fi)
{

    if (strcmp(path, filepath) == 0)
    {
        size_t len = strlen(filecontent);
        if (offset >= len)
        {
            return 0;
        }

        if (offset + size > len)
        {
            memcpy(buf, filecontent + offset, len - offset);
            return len - offset;
        }

        memcpy(buf, filecontent + offset, size);
        return size;
    }

    return -ENOENT;
}

static struct fuse_operations fuse_example_operations = {
    .getattr = getattr_callback,
    .open = open_callback,
    .read = read_callback,
    .readdir = readdir_callback,
};

void fuse_init()
{
    printf("fuse init");
    int argc = 5;
    char *argv[5];
    argv[0] = "fusedart";
    argv[1] = "-d";
    argv[2] = "-s";
    argv[3] = "-f";
    argv[4] = "/tmp/example";
    fuse_main(argc, argv, &fuse_example_operations, NULL);
}

int main(int argc, char *argv[])
{
    printf("argc: %d", argc);
    // return fuse_main(argc, argv, &fuse_example_operations, NULL);
}