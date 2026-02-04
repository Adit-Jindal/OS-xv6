#include "types.h"
#include "defs.h"
#include "x86.h"
#include "mouse.h"
#include "traps.h"

// Wait until the mouse controller is ready for us to send a packet
void 
mousewait_send(void) 
{
    // Wait until bit 1 (value=2) of status port (0x64) is clear
    while(inb(MSSTATP) & 0x02)
        ;
    return;
}

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
    // Wait until bit 0 (value=1) of status port (0x64) is set
    while(!(inb(MSSTATP) & 0x01))
        ;
    return;
}

// Send a one-byte command to the mouse controller, and wait for it
// to be properly acknowledged
void 
mousecmd(uchar cmd) 
{
    // Tell controller we want to talk to the mouse, then send the command
    mousewait_send();
    outb(MSSTATP, PS2MS);
    mousewait_send();
    outb(MSDATAP, cmd);

    // Wait for ack from mouse
    mousewait_recv();
    (void)inb(MSDATAP);
    return;
}

void
mouseinit(void)
{
    uchar stat;

    // Enable auxiliary device - the mouse
    mousewait_send();
    outb(MSSTATP, MSEN);

    // Request Compaq status byte
    mousewait_send();
    outb(MSSTATP, 0x20);
    mousewait_recv();
    stat = inb(MSDATAP);

    // Enable IRQ12 by setting bit 1
    stat |= 0x02;

    mousewait_send();
    outb(MSSTATP, 0x60);
    mousewait_send();
    outb(MSDATAP, stat);

    // Set default settings and enable the mouse
    mousecmd(0xF6);
    mousecmd(0xF4);

    // Enable mouse IRQ (IRQ 12) on CPU 0
    ioapicenable(IRQ_MOUSE, 0);

    cprintf("Mouse has been initialized\n");
    return;
}

void
mouseintr(void)
{
    static uchar mbuf[3];
    static int mcycle = 0;
    uchar val;

    int mouse_x = 0, mouse_y = 0; // global reference
    
    // Drain controller buffer
    while(inb(MSSTATP) & 0x01){
        val = inb(MSDATAP);
        mbuf[mcycle++] = val;
        if(mcycle == 3){
            mcycle = 0;
            // First byte: bits 0,1,2 are left,right,middle
            if(mbuf[0] & 0x01)
            cprintf("LEFT\n");
            if(mbuf[0] & 0x02)
            cprintf("RIGHT\n");
            if(mbuf[0] & 0x04)
            cprintf("MID\n");

            int dx = (int)mbuf[1];
            int dy = -(int)mbuf[2];

            mouse_x += dx;
            mouse_y += dy;

            cprintf("Position: (%d, %d)\n", mouse_x, mouse_y);
        }
    }
    return;
}