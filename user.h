// system calls
int write(int, const void*, int);
int close(int);
int open(const char*, int);
int exec(char*);
int set_sched_policy(int);
int getpid(void);

void printf(int, const char*, ...);
