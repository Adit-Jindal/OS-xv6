# COL331 Lab 1: Primitive Mouse Support in xv6

In `p5-input`, you have seen how your basic operating system can be modified to handle inputs from an external device - a keyboard.

Modern operating systems also have support for using a mouse or a trackpad. In this lab, you will try to add some primitive support for using the mouse in the basic `xv6` OS, which we have been building up from scratch.

## Introduction

PS/2 is a type of serial communication, typically used for user input devices such as a keyboard or a mouse. A _PS/2 controller_ can be used to communicate both with a PS/2 keyboard and a PS/2 mouse.

A PS/2 controller has two IO ports, which our OS can use to communicate with it:

| I/O PORT | Purpose             |
| -------- | ------------------- |
| 0x60     | Data Port           |
| 0x64     | Command/Status Port |

A PS/2 mouse typically generates `IRQ12` interrupts whenever its state changes.

## Getting Started

Interacting with the PS/2 controller is fairly complex and there are several steps involved. Most of your work will be implementing the functions which we have provided you a skeleton for in `mouse.c`:

```
// Wait until the mouse controller is ready for us to send a packet
void mousewait_send(void);

// Wait until the mouse controller has data for us to receive
void mousewait_recv(void);

// Send a one-byte command to the mouse controller, and wait for it to be properly acknowledged
void mousecmd(uchar cmd);

// To activate the mouse when the system boots up
void mouseinit(void);

// To handle an interrupt raised by the mouse controller
void mouseintr(void);
```

The first three functions are important to communicate with the controller. You need to ensure that the `mouseinit` and `mouseintr` functions are called appropriately when needed. There are some constants defined in `mouse.h` which may be helpful.

You are encouraged to go through the following [wiki page](https://wiki.osdev.org/Mouse_Input) on PS/2 mouse input. You may also refer to `p5-input` and recall how keyboard interrupts are handled.

## Functions: `mouse.c`

As a first step, you need to implement the first three functions given above, providing the following functionalities.

- `mousewait_send`: Before sending bytes to port 0x60 or 0x64, we must _wait_ for bit 1 (value=2) of port 0x64 to become clear.

- `mousewait_recv`: Bytes cannot be read from port 0x60, we must _wait_ until bit 0 (value=1) of port 0x64 is set.

- `mousecmd(uchar cmd)`: Wait until bytes can be sent to the controller. Send the byte `0xD4` to the control port (`0x64`) to tell the PS/2 controller to address the mouse. Then, send the command `cmd` to the data port (`0x60`). The controller will then send back an acknowledgement (`0xFA`) - wait till the controller has data for us to receive, and then read the `ack`.

## Mouse Initialization

When the system boots, we need to communicate with the PS/2 controller and activate the mouse. We also need to ensure that the controller knows it needs to send interrupts (`IRQ12`) when the mouse state changes.

To initialize the mouse correctly, you must code up the following procedure in the `mouseinit` function:

1. Wait until the controller can receive a control packet.
2. Send `0xA8` to the control port, which tells the PS/2 controller to enable the mouse.
3. To tell the controller to send interrupts when the mouse state changes, we need to modify the "Compaq Status Byte", as follows:
   - Wait until the controller is ready for us to send.
   - Send `0x20` to the control port, which selects the Compaq Status byte as the data we want to retrieve.
   - Wait until the controller has data for us to receive.
   - Read the status byte from the data port.
   - Set the 2nd bit of the status byte to 1 by ORing it with 0x02. This specifies that interrupts should be enabled.
   - Wait until the controller is ready for us to send.
   - Send `0x60` to the control port, which tells the controller we are about to send it the modified status byte.
   - Wait until the controller is ready for us to send.
   - Send the modified status byte to the data port.
4. Use the `mousecmd` function to send `0xF6` to the controller, which selects "default settings" for the mouse
5. Use the `mousecmd` function to send `0xF4` to the controller, which tells the mouse to activate and start sending us interrupts.
6. Tell the interrupt controller that we want to receive the mouse interrupt (`IRQ12`) on CPU 0 using `ioapicenable`.

Make sure that you call `mouseinit` appropriately while booting. For insipiration, see where `uartinit` is called. By following these steps, you should be able to initialize the mouse.

## Mouse Interrupts

The mouse is now hopefully initialized and ready to send interrupts to the OS. We have defined an interrupt number `IRQ_MOUSE` as 12 for mouse interrupts in the `traps.h` file. You need to ensure you write code to suitably handle the `IRQ_MOUSE` interrupt in the xv6 interrupt handler.

In the interrupt handler, you should call the `mouseintr()` function, which will implement with the exact logic of the handler.

Whenever the mouse state changes, the PS/2 controller raises an interrupt. It also has some data to provide the OS, which sits in the PS/2 controller's buffer until the interrupt handler reads it. Your task is to read the data from the PS/2 controller buffer and process it. For this, here is some information on PS/2 mouse packets.

### Mouse Packets

A mouse is usually initialized to generate movement packets at a particular rate. The default rate is 100 packets per second if the mouse is being moved. A mouse also generates a packet if a button is either pressed or released.

Mouse Packets are 3 bytes long. The format of the first byte is given in the table below. Note that 'Of' stands for 'overflow'.

| Bit | Meaning                                                |
| --- | ------------------------------------------------------ |
| 0   | Left button was clicked                                |
| 1   | Right button was clicked                               |
| 2   | Middle button was clicked                              |
| 3   | Always 1                                               |
| 4   | If 1, mouse was moved in the left direction            |
| 5   | If 1, mouse was moved in the down direction            |
| 6   | Position of mouse overflowed the screen in X direction |
| 7   | Position of mouse overflowed the screen in Y direction |

The second byte represents the movement along the X axis, and the third byte the movement along the Y axis. Note that second and third bytes will just be zero if
the mouse was clicked.

We read from the PS/2 controller buffer (from the data port) one byte at a time. To make sense of the data associated with an interrupt, we need to ensure we read 3 bytes to get a full set of data describing the mouse movements.

Since mouse may be moving rapidly, each movement will get added to the
controller's buffer. In the interrupt handler, we should drain the controller's
buffer. We can check that the bit number 0 has a value = 0 of the status port
(`0x64`) which means that there is no more data available on the data port
(`0x60`).

<!-- We can check bit number 0 (value = 1) of the status port (```0x64```) to see if data is available on the data port (```0x60```). -->

At this point, you are equipped with the knowledge to do powerful things with the mouse in the future. However, for now, let us limit ourselves to the simple following task using `cprintf`:

- If there is a left click, print "`LEFT\n`".
- If there is a right click, print "`RIGHT\n`".
- If there is a middle click, print "`MID\n`".

We thus create a mechanism to detect and handle mouse clicks. Convince yourself that using the other data available from the mouse controller, it would not be too difficult to add a more robust and useful mouse functionality to your OS in the future, should you need it.

---

## Deliverables

You will be required to submit the entire `col331-lab-1a` folder with your changes. The code should be able to handle mouse interrupts and print out the required strings on each type of mouse button press.

In the `col331-lab-1a` root directory, run the following commands:

```
make clean
tar czvf lab1_<entryNumber>.tar.gz *
```

This will create a tarball with the name, `lab1_<entryNumber>.tar.gz` in the same directory. Submit this tarball on [Moodle](https://moodlenew.iitd.ac.in/mod/assign/view.php?id=15421). Entry number format: 2020CS10567. (All English letters will be in capitals in the
entry number)

## Auto-grader

Follow the below instructions to run the autograder locally on your submission:

- Use the following command to run the auto-grader
  ```bash
  cd check_scripts
  bash check.sh <path/to/lab1_<entryNumber>.tar.gz>
  ```
- The given sample script consists of 3 basic test cases. Note that your submission will be evaluated by hidden test cases.
