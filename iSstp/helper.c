#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char* argv[])
{
    char buf[256];

    setuid(0);
    if(!strcmp(argv[1], "start") && argc == 6){
        sprintf(buf, "%s --cert-warn --user %s --password %s %s usepeerdns require-mschap-v2 noauth noipdefault defaultroute",
                argv[2], argv[3], argv[4], argv[5]);
        system(buf);
     }
    else if(!strcmp(argv[1], "stop")){
        system("killall sstpc helper");
    }
    else    return -1;
}
