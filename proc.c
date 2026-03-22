#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"

struct {
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void trapret(void);
int sched_count = 0; // CHANGES MADE : added sched_count to ensure time split

int
cpuid() {
  return 0;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  return &cpus[0];
}

// Read proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c = mycpu();
  return c->proc;
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  if((p->offset = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  p->sz = PGSIZE;

  // kstack lives on a different segment
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }

  sp = (char*)(p->kstack + PGSIZE);

  // Allocate kernel stack.
  p->kstack = sp - KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)trapret;

  return p;
}

// Set up first process.
void
pinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;

  memmove(p->offset, _binary_initcode_start, (int)_binary_initcode_size);
  memset(p->tf, 0, sizeof(*p->tf));

  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;

  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  // CHNAGES MADE : set policies (hard coded for now)
  if (p->pid == 2)
    p->policy = 1;
  else
    p->policy = 0;
}

// process scheduler.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;

  // CHANGES MADE : new variables added
  int target_prio;
  int target_exists = 0; // set to 1 if we find any process of the target priority, else 0
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
    target_prio = (sched_count==0);

    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue;

    //   // Switch to chosen process. 
    //   c->proc = p;
    //   p->state = RUNNING;

    //   switchuvm(p);
    //   swtch(&(c->scheduler), p->context);
    // }


    // CHANGES MADE : split the loop based on target priority level
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == RUNNABLE && p->policy==target_prio) {
        target_exists = 1;
        break;
      }
    }

    if (target_exists == 0) { // fallback priority
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state != RUNNABLE)
          continue;

        c->proc = p;
        p->state = RUNNING;

        switchuvm(p);
        swtch(&(c->scheduler), p->context);
        
        sched_count = (sched_count+1)%10;
      }
    }

    else { // target priority exists
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state != RUNNABLE || p->policy!=target_prio)
          continue;
        c->proc = p;
        p->state = RUNNING;

        switchuvm(p);
        swtch(&(c->scheduler), p->context);
        
        sched_count = (sched_count+1)%10;
      }
    }
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct cpu* c = mycpu();
  struct proc *p = myproc();

  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = c->intena;
  swtch(&p->context, c->scheduler);
  c->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  myproc()->state = RUNNABLE;
  sched();
}

void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  };
  struct proc *p;
  char *state;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d", p->pid, state, p->name, p->policy); // CHANGES MADE : policy printed (debugging)
    cprintf("\n");
  }
}