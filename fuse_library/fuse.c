#include <stdio.h>
#include "fuse.h"

int main()
{
    hello_world();
    return 0;
}

void hello_world()
{
    printf("Hello World from C\n");
}