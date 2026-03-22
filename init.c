// init: The initial user-level program

#include "types.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  int fd = open("console", O_RDWR);
  printf(fd, "Hello %s from init.c\n", argv[0]);

  // Hardcode changing process 2's policy to 1 (background)
  if (getpid() == 2) {
    if (set_sched_policy(1) == 0) {
      printf(fd, "Successfully set process 2 to background policy!\n");
    }
  }

  close(fd);

  while(1) {
    
  };
}
