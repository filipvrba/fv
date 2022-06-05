#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>

int main( int argc, char* argv[] )
{
    // if (mkfifo("../"))
    printf("hello world\n");
    return 0;
}