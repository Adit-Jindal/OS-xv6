
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc 10 c7 10 00       	mov    $0x10c710,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 ed 08 10 00       	mov    $0x1008ed,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax

00100018 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
  100018:	55                   	push   %ebp
  100019:	89 e5                	mov    %esp,%ebp
  10001b:	83 ec 08             	sub    $0x8,%esp
  10001e:	8b 55 08             	mov    0x8(%ebp),%edx
  100021:	8b 45 0c             	mov    0xc(%ebp),%eax
  100024:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  100028:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10002c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100030:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100034:	66 ef                	out    %ax,(%dx)
}
  100036:	90                   	nop
  100037:	c9                   	leave  
  100038:	c3                   	ret    

00100039 <cli>:
  return eflags;
}

static inline void
cli(void)
{
  100039:	55                   	push   %ebp
  10003a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
  10003c:	fa                   	cli    
}
  10003d:	90                   	nop
  10003e:	5d                   	pop    %ebp
  10003f:	c3                   	ret    

00100040 <printint>:

static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100040:	55                   	push   %ebp
  100041:	89 e5                	mov    %esp,%ebp
  100043:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  100046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10004a:	74 1c                	je     100068 <printint+0x28>
  10004c:	8b 45 08             	mov    0x8(%ebp),%eax
  10004f:	c1 e8 1f             	shr    $0x1f,%eax
  100052:	0f b6 c0             	movzbl %al,%eax
  100055:	89 45 10             	mov    %eax,0x10(%ebp)
  100058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10005c:	74 0a                	je     100068 <printint+0x28>
    x = -xx;
  10005e:	8b 45 08             	mov    0x8(%ebp),%eax
  100061:	f7 d8                	neg    %eax
  100063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100066:	eb 06                	jmp    10006e <printint+0x2e>
  else
    x = xx;
  100068:	8b 45 08             	mov    0x8(%ebp),%eax
  10006b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
  10006e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
  100075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10007b:	ba 00 00 00 00       	mov    $0x0,%edx
  100080:	f7 f1                	div    %ecx
  100082:	89 d1                	mov    %edx,%ecx
  100084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100087:	8d 50 01             	lea    0x1(%eax),%edx
  10008a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10008d:	0f b6 91 00 50 10 00 	movzbl 0x105000(%ecx),%edx
  100094:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
  100098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10009b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10009e:	ba 00 00 00 00       	mov    $0x0,%edx
  1000a3:	f7 f1                	div    %ecx
  1000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1000a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1000ac:	75 c7                	jne    100075 <printint+0x35>

  if(sign)
  1000ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1000b2:	74 2a                	je     1000de <printint+0x9e>
    buf[i++] = '-';
  1000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000b7:	8d 50 01             	lea    0x1(%eax),%edx
  1000ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1000bd:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
  1000c2:	eb 1a                	jmp    1000de <printint+0x9e>
    consputc(buf[i]);
  1000c4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1000c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000ca:	01 d0                	add    %edx,%eax
  1000cc:	0f b6 00             	movzbl (%eax),%eax
  1000cf:	0f be c0             	movsbl %al,%eax
  1000d2:	83 ec 0c             	sub    $0xc,%esp
  1000d5:	50                   	push   %eax
  1000d6:	e8 5f 02 00 00       	call   10033a <consputc>
  1000db:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
  1000de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1000e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1000e6:	79 dc                	jns    1000c4 <printint+0x84>
}
  1000e8:	90                   	nop
  1000e9:	90                   	nop
  1000ea:	c9                   	leave  
  1000eb:	c3                   	ret    

001000ec <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1000ec:	55                   	push   %ebp
  1000ed:	89 e5                	mov    %esp,%ebp
  1000ef:	83 ec 18             	sub    $0x18,%esp
  int i, c;
  uint *argp;
  char *s;

  if (fmt == 0)
  1000f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000f5:	85 c0                	test   %eax,%eax
  1000f7:	0f 84 63 01 00 00    	je     100260 <cprintf+0x174>
    // panic("null fmt");
    return;

  argp = (uint*)(void*)(&fmt + 1);
  1000fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  100100:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10010a:	e9 2f 01 00 00       	jmp    10023e <cprintf+0x152>
    if(c != '%'){
  10010f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100113:	74 13                	je     100128 <cprintf+0x3c>
      consputc(c);
  100115:	83 ec 0c             	sub    $0xc,%esp
  100118:	ff 75 e8             	push   -0x18(%ebp)
  10011b:	e8 1a 02 00 00       	call   10033a <consputc>
  100120:	83 c4 10             	add    $0x10,%esp
      continue;
  100123:	e9 12 01 00 00       	jmp    10023a <cprintf+0x14e>
    }
    c = fmt[++i] & 0xff;
  100128:	8b 55 08             	mov    0x8(%ebp),%edx
  10012b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100132:	01 d0                	add    %edx,%eax
  100134:	0f b6 00             	movzbl (%eax),%eax
  100137:	0f be c0             	movsbl %al,%eax
  10013a:	25 ff 00 00 00       	and    $0xff,%eax
  10013f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
  100142:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100146:	0f 84 17 01 00 00    	je     100263 <cprintf+0x177>
      break;
    switch(c){
  10014c:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100150:	74 5e                	je     1001b0 <cprintf+0xc4>
  100152:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100156:	0f 8f c2 00 00 00    	jg     10021e <cprintf+0x132>
  10015c:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100160:	74 6b                	je     1001cd <cprintf+0xe1>
  100162:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100166:	0f 8f b2 00 00 00    	jg     10021e <cprintf+0x132>
  10016c:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100170:	74 3e                	je     1001b0 <cprintf+0xc4>
  100172:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100176:	0f 8f a2 00 00 00    	jg     10021e <cprintf+0x132>
  10017c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100180:	0f 84 89 00 00 00    	je     10020f <cprintf+0x123>
  100186:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
  10018a:	0f 85 8e 00 00 00    	jne    10021e <cprintf+0x132>
    case 'd':
      printint(*argp++, 10, 1);
  100190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100193:	8d 50 04             	lea    0x4(%eax),%edx
  100196:	89 55 f0             	mov    %edx,-0x10(%ebp)
  100199:	8b 00                	mov    (%eax),%eax
  10019b:	83 ec 04             	sub    $0x4,%esp
  10019e:	6a 01                	push   $0x1
  1001a0:	6a 0a                	push   $0xa
  1001a2:	50                   	push   %eax
  1001a3:	e8 98 fe ff ff       	call   100040 <printint>
  1001a8:	83 c4 10             	add    $0x10,%esp
      break;
  1001ab:	e9 8a 00 00 00       	jmp    10023a <cprintf+0x14e>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  1001b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001b3:	8d 50 04             	lea    0x4(%eax),%edx
  1001b6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001b9:	8b 00                	mov    (%eax),%eax
  1001bb:	83 ec 04             	sub    $0x4,%esp
  1001be:	6a 00                	push   $0x0
  1001c0:	6a 10                	push   $0x10
  1001c2:	50                   	push   %eax
  1001c3:	e8 78 fe ff ff       	call   100040 <printint>
  1001c8:	83 c4 10             	add    $0x10,%esp
      break;
  1001cb:	eb 6d                	jmp    10023a <cprintf+0x14e>
    case 's':
      if((s = (char*)*argp++) == 0)
  1001cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001d0:	8d 50 04             	lea    0x4(%eax),%edx
  1001d3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001d6:	8b 00                	mov    (%eax),%eax
  1001d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1001db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1001df:	75 22                	jne    100203 <cprintf+0x117>
        s = "(null)";
  1001e1:	c7 45 ec e0 40 10 00 	movl   $0x1040e0,-0x14(%ebp)
      for(; *s; s++)
  1001e8:	eb 19                	jmp    100203 <cprintf+0x117>
        consputc(*s);
  1001ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1001ed:	0f b6 00             	movzbl (%eax),%eax
  1001f0:	0f be c0             	movsbl %al,%eax
  1001f3:	83 ec 0c             	sub    $0xc,%esp
  1001f6:	50                   	push   %eax
  1001f7:	e8 3e 01 00 00       	call   10033a <consputc>
  1001fc:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
  1001ff:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100206:	0f b6 00             	movzbl (%eax),%eax
  100209:	84 c0                	test   %al,%al
  10020b:	75 dd                	jne    1001ea <cprintf+0xfe>
      break;
  10020d:	eb 2b                	jmp    10023a <cprintf+0x14e>
    case '%':
      consputc('%');
  10020f:	83 ec 0c             	sub    $0xc,%esp
  100212:	6a 25                	push   $0x25
  100214:	e8 21 01 00 00       	call   10033a <consputc>
  100219:	83 c4 10             	add    $0x10,%esp
      break;
  10021c:	eb 1c                	jmp    10023a <cprintf+0x14e>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  10021e:	83 ec 0c             	sub    $0xc,%esp
  100221:	6a 25                	push   $0x25
  100223:	e8 12 01 00 00       	call   10033a <consputc>
  100228:	83 c4 10             	add    $0x10,%esp
      consputc(c);
  10022b:	83 ec 0c             	sub    $0xc,%esp
  10022e:	ff 75 e8             	push   -0x18(%ebp)
  100231:	e8 04 01 00 00       	call   10033a <consputc>
  100236:	83 c4 10             	add    $0x10,%esp
      break;
  100239:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10023a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10023e:	8b 55 08             	mov    0x8(%ebp),%edx
  100241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100244:	01 d0                	add    %edx,%eax
  100246:	0f b6 00             	movzbl (%eax),%eax
  100249:	0f be c0             	movsbl %al,%eax
  10024c:	25 ff 00 00 00       	and    $0xff,%eax
  100251:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100254:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100258:	0f 85 b1 fe ff ff    	jne    10010f <cprintf+0x23>
  10025e:	eb 04                	jmp    100264 <cprintf+0x178>
    return;
  100260:	90                   	nop
  100261:	eb 01                	jmp    100264 <cprintf+0x178>
      break;
  100263:	90                   	nop
    }
  }
}
  100264:	c9                   	leave  
  100265:	c3                   	ret    

00100266 <halt>:

void
halt(void)
{
  100266:	55                   	push   %ebp
  100267:	89 e5                	mov    %esp,%ebp
  100269:	83 ec 08             	sub    $0x8,%esp
  cprintf("Bye COL%d!\n\0", 331);
  10026c:	83 ec 08             	sub    $0x8,%esp
  10026f:	68 4b 01 00 00       	push   $0x14b
  100274:	68 e7 40 10 00       	push   $0x1040e7
  100279:	e8 6e fe ff ff       	call   1000ec <cprintf>
  10027e:	83 c4 10             	add    $0x10,%esp
  outw(0x602, 0x2000);
  100281:	83 ec 08             	sub    $0x8,%esp
  100284:	68 00 20 00 00       	push   $0x2000
  100289:	68 02 06 00 00       	push   $0x602
  10028e:	e8 85 fd ff ff       	call   100018 <outw>
  100293:	83 c4 10             	add    $0x10,%esp
  // For older versions of QEMU, 
  outw(0xB002, 0x2000);
  100296:	83 ec 08             	sub    $0x8,%esp
  100299:	68 00 20 00 00       	push   $0x2000
  10029e:	68 02 b0 00 00       	push   $0xb002
  1002a3:	e8 70 fd ff ff       	call   100018 <outw>
  1002a8:	83 c4 10             	add    $0x10,%esp
  for(;;);
  1002ab:	eb fe                	jmp    1002ab <halt+0x45>

001002ad <panic>:
}

void
panic(char *s)
{
  1002ad:	55                   	push   %ebp
  1002ae:	89 e5                	mov    %esp,%ebp
  1002b0:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
  1002b3:	e8 81 fd ff ff       	call   100039 <cli>
  cprintf("lapicid %d: panic: ", lapicid());
  1002b8:	e8 35 05 00 00       	call   1007f2 <lapicid>
  1002bd:	83 ec 08             	sub    $0x8,%esp
  1002c0:	50                   	push   %eax
  1002c1:	68 f4 40 10 00       	push   $0x1040f4
  1002c6:	e8 21 fe ff ff       	call   1000ec <cprintf>
  1002cb:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	83 ec 0c             	sub    $0xc,%esp
  1002d4:	50                   	push   %eax
  1002d5:	e8 12 fe ff ff       	call   1000ec <cprintf>
  1002da:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
  1002dd:	83 ec 0c             	sub    $0xc,%esp
  1002e0:	68 08 41 10 00       	push   $0x104108
  1002e5:	e8 02 fe ff ff       	call   1000ec <cprintf>
  1002ea:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	8d 45 cc             	lea    -0x34(%ebp),%eax
  1002f3:	50                   	push   %eax
  1002f4:	8d 45 08             	lea    0x8(%ebp),%eax
  1002f7:	50                   	push   %eax
  1002f8:	e8 4c 0f 00 00       	call   101249 <getcallerpcs>
  1002fd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100307:	eb 1c                	jmp    100325 <panic+0x78>
    cprintf(" %p", pcs[i]);
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10030c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
  100310:	83 ec 08             	sub    $0x8,%esp
  100313:	50                   	push   %eax
  100314:	68 0a 41 10 00       	push   $0x10410a
  100319:	e8 ce fd ff ff       	call   1000ec <cprintf>
  10031e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100321:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100325:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  100329:	7e de                	jle    100309 <panic+0x5c>
  panicked = 1; // freeze other CPU
  10032b:	c7 05 ac 54 10 00 01 	movl   $0x1,0x1054ac
  100332:	00 00 00 
  halt();
  100335:	e8 2c ff ff ff       	call   100266 <halt>

0010033a <consputc>:

#define BACKSPACE 0x100

void
consputc(int c)
{
  10033a:	55                   	push   %ebp
  10033b:	89 e5                	mov    %esp,%ebp
  10033d:	83 ec 08             	sub    $0x8,%esp
  if(c == BACKSPACE){
  100340:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
  100347:	75 29                	jne    100372 <consputc+0x38>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100349:	83 ec 0c             	sub    $0xc,%esp
  10034c:	6a 08                	push   $0x8
  10034e:	e8 f9 0a 00 00       	call   100e4c <uartputc>
  100353:	83 c4 10             	add    $0x10,%esp
  100356:	83 ec 0c             	sub    $0xc,%esp
  100359:	6a 20                	push   $0x20
  10035b:	e8 ec 0a 00 00       	call   100e4c <uartputc>
  100360:	83 c4 10             	add    $0x10,%esp
  100363:	83 ec 0c             	sub    $0xc,%esp
  100366:	6a 08                	push   $0x8
  100368:	e8 df 0a 00 00       	call   100e4c <uartputc>
  10036d:	83 c4 10             	add    $0x10,%esp
  } else
    uartputc(c);
}
  100370:	eb 0e                	jmp    100380 <consputc+0x46>
    uartputc(c);
  100372:	83 ec 0c             	sub    $0xc,%esp
  100375:	ff 75 08             	push   0x8(%ebp)
  100378:	e8 cf 0a 00 00       	call   100e4c <uartputc>
  10037d:	83 c4 10             	add    $0x10,%esp
}
  100380:	90                   	nop
  100381:	c9                   	leave  
  100382:	c3                   	ret    

00100383 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100383:	55                   	push   %ebp
  100384:	89 e5                	mov    %esp,%ebp
  100386:	83 ec 18             	sub    $0x18,%esp
  int c;

  while((c = getc()) >= 0){
  100389:	e9 17 01 00 00       	jmp    1004a5 <consoleintr+0x122>
    switch(c){
  10038e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  100392:	74 63                	je     1003f7 <consoleintr+0x74>
  100394:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  100398:	0f 8f 8b 00 00 00    	jg     100429 <consoleintr+0xa6>
  10039e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  1003a2:	74 53                	je     1003f7 <consoleintr+0x74>
  1003a4:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
  1003a8:	75 7f                	jne    100429 <consoleintr+0xa6>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1003aa:	eb 1d                	jmp    1003c9 <consoleintr+0x46>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  1003ac:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  1003b1:	83 e8 01             	sub    $0x1,%eax
  1003b4:	a3 a8 54 10 00       	mov    %eax,0x1054a8
        consputc(BACKSPACE);
  1003b9:	83 ec 0c             	sub    $0xc,%esp
  1003bc:	68 00 01 00 00       	push   $0x100
  1003c1:	e8 74 ff ff ff       	call   10033a <consputc>
  1003c6:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
  1003c9:	8b 15 a8 54 10 00    	mov    0x1054a8,%edx
  1003cf:	a1 a4 54 10 00       	mov    0x1054a4,%eax
  1003d4:	39 c2                	cmp    %eax,%edx
  1003d6:	0f 84 c9 00 00 00    	je     1004a5 <consoleintr+0x122>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1003dc:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  1003e1:	83 e8 01             	sub    $0x1,%eax
  1003e4:	83 e0 7f             	and    $0x7f,%eax
  1003e7:	0f b6 80 20 54 10 00 	movzbl 0x105420(%eax),%eax
      while(input.e != input.w &&
  1003ee:	3c 0a                	cmp    $0xa,%al
  1003f0:	75 ba                	jne    1003ac <consoleintr+0x29>
      }
      break;
  1003f2:	e9 ae 00 00 00       	jmp    1004a5 <consoleintr+0x122>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  1003f7:	8b 15 a8 54 10 00    	mov    0x1054a8,%edx
  1003fd:	a1 a4 54 10 00       	mov    0x1054a4,%eax
  100402:	39 c2                	cmp    %eax,%edx
  100404:	0f 84 9b 00 00 00    	je     1004a5 <consoleintr+0x122>
        input.e--;
  10040a:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  10040f:	83 e8 01             	sub    $0x1,%eax
  100412:	a3 a8 54 10 00       	mov    %eax,0x1054a8
        consputc(BACKSPACE);
  100417:	83 ec 0c             	sub    $0xc,%esp
  10041a:	68 00 01 00 00       	push   $0x100
  10041f:	e8 16 ff ff ff       	call   10033a <consputc>
  100424:	83 c4 10             	add    $0x10,%esp
      }
      break;
  100427:	eb 7c                	jmp    1004a5 <consoleintr+0x122>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10042d:	74 75                	je     1004a4 <consoleintr+0x121>
  10042f:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  100434:	8b 15 a0 54 10 00    	mov    0x1054a0,%edx
  10043a:	29 d0                	sub    %edx,%eax
  10043c:	83 f8 7f             	cmp    $0x7f,%eax
  10043f:	77 63                	ja     1004a4 <consoleintr+0x121>
        c = (c == '\r') ? '\n' : c;
  100441:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
  100445:	74 05                	je     10044c <consoleintr+0xc9>
  100447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10044a:	eb 05                	jmp    100451 <consoleintr+0xce>
  10044c:	b8 0a 00 00 00       	mov    $0xa,%eax
  100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
  100454:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  100459:	8d 50 01             	lea    0x1(%eax),%edx
  10045c:	89 15 a8 54 10 00    	mov    %edx,0x1054a8
  100462:	83 e0 7f             	and    $0x7f,%eax
  100465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100468:	88 90 20 54 10 00    	mov    %dl,0x105420(%eax)
        consputc(c);
  10046e:	83 ec 0c             	sub    $0xc,%esp
  100471:	ff 75 f4             	push   -0xc(%ebp)
  100474:	e8 c1 fe ff ff       	call   10033a <consputc>
  100479:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10047c:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  100480:	74 18                	je     10049a <consoleintr+0x117>
  100482:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  100486:	74 12                	je     10049a <consoleintr+0x117>
  100488:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  10048d:	8b 15 a0 54 10 00    	mov    0x1054a0,%edx
  100493:	83 ea 80             	sub    $0xffffff80,%edx
  100496:	39 d0                	cmp    %edx,%eax
  100498:	75 0a                	jne    1004a4 <consoleintr+0x121>
          input.w = input.e;
  10049a:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  10049f:	a3 a4 54 10 00       	mov    %eax,0x1054a4
        }
      }
      break;
  1004a4:	90                   	nop
  while((c = getc()) >= 0){
  1004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1004a8:	ff d0                	call   *%eax
  1004aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1004ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b1:	0f 89 d7 fe ff ff    	jns    10038e <consoleintr+0xb>
    }
  }
}
  1004b7:	90                   	nop
  1004b8:	90                   	nop
  1004b9:	c9                   	leave  
  1004ba:	c3                   	ret    

001004bb <consoleread>:


int
consoleread(struct inode *ip, char *dst, int n)
{
  1004bb:	55                   	push   %ebp
  1004bc:	89 e5                	mov    %esp,%ebp
  1004be:	83 ec 10             	sub    $0x10,%esp
  uint target;
  int c;

  target = n;
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n > 0){
  1004c7:	eb 63                	jmp    10052c <consoleread+0x71>
    while(input.r == input.w);
  1004c9:	90                   	nop
  1004ca:	8b 15 a0 54 10 00    	mov    0x1054a0,%edx
  1004d0:	a1 a4 54 10 00       	mov    0x1054a4,%eax
  1004d5:	39 c2                	cmp    %eax,%edx
  1004d7:	74 f1                	je     1004ca <consoleread+0xf>
    c = input.buf[input.r++ % INPUT_BUF];
  1004d9:	a1 a0 54 10 00       	mov    0x1054a0,%eax
  1004de:	8d 50 01             	lea    0x1(%eax),%edx
  1004e1:	89 15 a0 54 10 00    	mov    %edx,0x1054a0
  1004e7:	83 e0 7f             	and    $0x7f,%eax
  1004ea:	0f b6 80 20 54 10 00 	movzbl 0x105420(%eax),%eax
  1004f1:	0f be c0             	movsbl %al,%eax
  1004f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(c == C('D')){  // EOF
  1004f7:	83 7d f8 04          	cmpl   $0x4,-0x8(%ebp)
  1004fb:	75 17                	jne    100514 <consoleread+0x59>
      if(n < target){
  1004fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100500:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100503:	76 2f                	jbe    100534 <consoleread+0x79>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  100505:	a1 a0 54 10 00       	mov    0x1054a0,%eax
  10050a:	83 e8 01             	sub    $0x1,%eax
  10050d:	a3 a0 54 10 00       	mov    %eax,0x1054a0
      }
      break;
  100512:	eb 20                	jmp    100534 <consoleread+0x79>
    }
    *dst++ = c;
  100514:	8b 45 0c             	mov    0xc(%ebp),%eax
  100517:	8d 50 01             	lea    0x1(%eax),%edx
  10051a:	89 55 0c             	mov    %edx,0xc(%ebp)
  10051d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100520:	88 10                	mov    %dl,(%eax)
    --n;
  100522:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
  100526:	83 7d f8 0a          	cmpl   $0xa,-0x8(%ebp)
  10052a:	74 0b                	je     100537 <consoleread+0x7c>
  while(n > 0){
  10052c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  100530:	7f 97                	jg     1004c9 <consoleread+0xe>
  100532:	eb 04                	jmp    100538 <consoleread+0x7d>
      break;
  100534:	90                   	nop
  100535:	eb 01                	jmp    100538 <consoleread+0x7d>
      break;
  100537:	90                   	nop
  }

  return target - n;
  100538:	8b 55 10             	mov    0x10(%ebp),%edx
  10053b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10053e:	29 d0                	sub    %edx,%eax
}
  100540:	c9                   	leave  
  100541:	c3                   	ret    

00100542 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
  100542:	55                   	push   %ebp
  100543:	89 e5                	mov    %esp,%ebp
  100545:	83 ec 18             	sub    $0x18,%esp
  int i;
  for(i = 0; i < n; i++)
  100548:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10054f:	eb 21                	jmp    100572 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  100551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100554:	8b 45 0c             	mov    0xc(%ebp),%eax
  100557:	01 d0                	add    %edx,%eax
  100559:	0f b6 00             	movzbl (%eax),%eax
  10055c:	0f be c0             	movsbl %al,%eax
  10055f:	0f b6 c0             	movzbl %al,%eax
  100562:	83 ec 0c             	sub    $0xc,%esp
  100565:	50                   	push   %eax
  100566:	e8 cf fd ff ff       	call   10033a <consputc>
  10056b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
  10056e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100575:	3b 45 10             	cmp    0x10(%ebp),%eax
  100578:	7c d7                	jl     100551 <consolewrite+0xf>
  return n;
  10057a:	8b 45 10             	mov    0x10(%ebp),%eax
}
  10057d:	c9                   	leave  
  10057e:	c3                   	ret    

0010057f <consoleinit>:

void
consoleinit(void)
{
  10057f:	55                   	push   %ebp
  100580:	89 e5                	mov    %esp,%ebp
  devsw[CONSOLE].write = consolewrite;
  100582:	c7 05 4c ae 10 00 42 	movl   $0x100542,0x10ae4c
  100589:	05 10 00 
  devsw[CONSOLE].read = consoleread;
  10058c:	c7 05 48 ae 10 00 bb 	movl   $0x1004bb,0x10ae48
  100593:	04 10 00 
  100596:	90                   	nop
  100597:	5d                   	pop    %ebp
  100598:	c3                   	ret    

00100599 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
  100599:	55                   	push   %ebp
  10059a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  10059c:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1005a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1005a4:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
  1005a6:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1005ab:	8b 40 10             	mov    0x10(%eax),%eax
}
  1005ae:	5d                   	pop    %ebp
  1005af:	c3                   	ret    

001005b0 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  1005b0:	55                   	push   %ebp
  1005b1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1005b3:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1005b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1005bb:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1005bd:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1005c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1005c5:	89 50 10             	mov    %edx,0x10(%eax)
}
  1005c8:	90                   	nop
  1005c9:	5d                   	pop    %ebp
  1005ca:	c3                   	ret    

001005cb <ioapicinit>:

void
ioapicinit(void)
{
  1005cb:	55                   	push   %ebp
  1005cc:	89 e5                	mov    %esp,%ebp
  1005ce:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1005d1:	c7 05 b0 54 10 00 00 	movl   $0xfec00000,0x1054b0
  1005d8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  1005db:	6a 01                	push   $0x1
  1005dd:	e8 b7 ff ff ff       	call   100599 <ioapicread>
  1005e2:	83 c4 04             	add    $0x4,%esp
  1005e5:	c1 e8 10             	shr    $0x10,%eax
  1005e8:	25 ff 00 00 00       	and    $0xff,%eax
  1005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
  1005f0:	6a 00                	push   $0x0
  1005f2:	e8 a2 ff ff ff       	call   100599 <ioapicread>
  1005f7:	83 c4 04             	add    $0x4,%esp
  1005fa:	c1 e8 18             	shr    $0x18,%eax
  1005fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
  100600:	0f b6 05 c4 54 10 00 	movzbl 0x1054c4,%eax
  100607:	0f b6 c0             	movzbl %al,%eax
  10060a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10060d:	74 10                	je     10061f <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  10060f:	83 ec 0c             	sub    $0xc,%esp
  100612:	68 10 41 10 00       	push   $0x104110
  100617:	e8 d0 fa ff ff       	call   1000ec <cprintf>
  10061c:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10061f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100626:	eb 3f                	jmp    100667 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  100628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062b:	83 c0 20             	add    $0x20,%eax
  10062e:	0d 00 00 01 00       	or     $0x10000,%eax
  100633:	89 c2                	mov    %eax,%edx
  100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100638:	83 c0 08             	add    $0x8,%eax
  10063b:	01 c0                	add    %eax,%eax
  10063d:	83 ec 08             	sub    $0x8,%esp
  100640:	52                   	push   %edx
  100641:	50                   	push   %eax
  100642:	e8 69 ff ff ff       	call   1005b0 <ioapicwrite>
  100647:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
  10064a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10064d:	83 c0 08             	add    $0x8,%eax
  100650:	01 c0                	add    %eax,%eax
  100652:	83 c0 01             	add    $0x1,%eax
  100655:	83 ec 08             	sub    $0x8,%esp
  100658:	6a 00                	push   $0x0
  10065a:	50                   	push   %eax
  10065b:	e8 50 ff ff ff       	call   1005b0 <ioapicwrite>
  100660:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
  100663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10066d:	7e b9                	jle    100628 <ioapicinit+0x5d>
  }
}
  10066f:	90                   	nop
  100670:	90                   	nop
  100671:	c9                   	leave  
  100672:	c3                   	ret    

00100673 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  100673:	55                   	push   %ebp
  100674:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  100676:	8b 45 08             	mov    0x8(%ebp),%eax
  100679:	83 c0 20             	add    $0x20,%eax
  10067c:	89 c2                	mov    %eax,%edx
  10067e:	8b 45 08             	mov    0x8(%ebp),%eax
  100681:	83 c0 08             	add    $0x8,%eax
  100684:	01 c0                	add    %eax,%eax
  100686:	52                   	push   %edx
  100687:	50                   	push   %eax
  100688:	e8 23 ff ff ff       	call   1005b0 <ioapicwrite>
  10068d:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	c1 e0 18             	shl    $0x18,%eax
  100696:	89 c2                	mov    %eax,%edx
  100698:	8b 45 08             	mov    0x8(%ebp),%eax
  10069b:	83 c0 08             	add    $0x8,%eax
  10069e:	01 c0                	add    %eax,%eax
  1006a0:	83 c0 01             	add    $0x1,%eax
  1006a3:	52                   	push   %edx
  1006a4:	50                   	push   %eax
  1006a5:	e8 06 ff ff ff       	call   1005b0 <ioapicwrite>
  1006aa:	83 c4 08             	add    $0x8,%esp
}
  1006ad:	90                   	nop
  1006ae:	c9                   	leave  
  1006af:	c3                   	ret    

001006b0 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1006b0:	55                   	push   %ebp
  1006b1:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1006b3:	8b 15 b4 54 10 00    	mov    0x1054b4,%edx
  1006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bc:	c1 e0 02             	shl    $0x2,%eax
  1006bf:	01 c2                	add    %eax,%edx
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
  1006c6:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1006cb:	83 c0 20             	add    $0x20,%eax
  1006ce:	8b 00                	mov    (%eax),%eax
}
  1006d0:	90                   	nop
  1006d1:	5d                   	pop    %ebp
  1006d2:	c3                   	ret    

001006d3 <lapicinit>:

void
lapicinit(void)
{
  1006d3:	55                   	push   %ebp
  1006d4:	89 e5                	mov    %esp,%ebp
  if(!lapic)
  1006d6:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1006db:	85 c0                	test   %eax,%eax
  1006dd:	0f 84 0c 01 00 00    	je     1007ef <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
  1006e3:	68 3f 01 00 00       	push   $0x13f
  1006e8:	6a 3c                	push   $0x3c
  1006ea:	e8 c1 ff ff ff       	call   1006b0 <lapicw>
  1006ef:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  1006f2:	6a 0b                	push   $0xb
  1006f4:	68 f8 00 00 00       	push   $0xf8
  1006f9:	e8 b2 ff ff ff       	call   1006b0 <lapicw>
  1006fe:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
  100701:	68 20 00 02 00       	push   $0x20020
  100706:	68 c8 00 00 00       	push   $0xc8
  10070b:	e8 a0 ff ff ff       	call   1006b0 <lapicw>
  100710:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
  100713:	68 80 96 98 00       	push   $0x989680
  100718:	68 e0 00 00 00       	push   $0xe0
  10071d:	e8 8e ff ff ff       	call   1006b0 <lapicw>
  100722:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  100725:	68 00 00 01 00       	push   $0x10000
  10072a:	68 d4 00 00 00       	push   $0xd4
  10072f:	e8 7c ff ff ff       	call   1006b0 <lapicw>
  100734:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
  100737:	68 00 00 01 00       	push   $0x10000
  10073c:	68 d8 00 00 00       	push   $0xd8
  100741:	e8 6a ff ff ff       	call   1006b0 <lapicw>
  100746:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  100749:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  10074e:	83 c0 30             	add    $0x30,%eax
  100751:	8b 00                	mov    (%eax),%eax
  100753:	c1 e8 10             	shr    $0x10,%eax
  100756:	25 fc 00 00 00       	and    $0xfc,%eax
  10075b:	85 c0                	test   %eax,%eax
  10075d:	74 12                	je     100771 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
  10075f:	68 00 00 01 00       	push   $0x10000
  100764:	68 d0 00 00 00       	push   $0xd0
  100769:	e8 42 ff ff ff       	call   1006b0 <lapicw>
  10076e:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
  100771:	6a 33                	push   $0x33
  100773:	68 dc 00 00 00       	push   $0xdc
  100778:	e8 33 ff ff ff       	call   1006b0 <lapicw>
  10077d:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  100780:	6a 00                	push   $0x0
  100782:	68 a0 00 00 00       	push   $0xa0
  100787:	e8 24 ff ff ff       	call   1006b0 <lapicw>
  10078c:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
  10078f:	6a 00                	push   $0x0
  100791:	68 a0 00 00 00       	push   $0xa0
  100796:	e8 15 ff ff ff       	call   1006b0 <lapicw>
  10079b:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  10079e:	6a 00                	push   $0x0
  1007a0:	6a 2c                	push   $0x2c
  1007a2:	e8 09 ff ff ff       	call   1006b0 <lapicw>
  1007a7:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1007aa:	6a 00                	push   $0x0
  1007ac:	68 c4 00 00 00       	push   $0xc4
  1007b1:	e8 fa fe ff ff       	call   1006b0 <lapicw>
  1007b6:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1007b9:	68 00 85 08 00       	push   $0x88500
  1007be:	68 c0 00 00 00       	push   $0xc0
  1007c3:	e8 e8 fe ff ff       	call   1006b0 <lapicw>
  1007c8:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
  1007cb:	90                   	nop
  1007cc:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1007d1:	05 00 03 00 00       	add    $0x300,%eax
  1007d6:	8b 00                	mov    (%eax),%eax
  1007d8:	25 00 10 00 00       	and    $0x1000,%eax
  1007dd:	85 c0                	test   %eax,%eax
  1007df:	75 eb                	jne    1007cc <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1007e1:	6a 00                	push   $0x0
  1007e3:	6a 20                	push   $0x20
  1007e5:	e8 c6 fe ff ff       	call   1006b0 <lapicw>
  1007ea:	83 c4 08             	add    $0x8,%esp
  1007ed:	eb 01                	jmp    1007f0 <lapicinit+0x11d>
    return;
  1007ef:	90                   	nop
}
  1007f0:	c9                   	leave  
  1007f1:	c3                   	ret    

001007f2 <lapicid>:

int
lapicid(void)
{
  1007f2:	55                   	push   %ebp
  1007f3:	89 e5                	mov    %esp,%ebp
  if (!lapic)
  1007f5:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1007fa:	85 c0                	test   %eax,%eax
  1007fc:	75 07                	jne    100805 <lapicid+0x13>
    return 0;
  1007fe:	b8 00 00 00 00       	mov    $0x0,%eax
  100803:	eb 0d                	jmp    100812 <lapicid+0x20>
  return lapic[ID] >> 24;
  100805:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  10080a:	83 c0 20             	add    $0x20,%eax
  10080d:	8b 00                	mov    (%eax),%eax
  10080f:	c1 e8 18             	shr    $0x18,%eax
}
  100812:	5d                   	pop    %ebp
  100813:	c3                   	ret    

00100814 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  100814:	55                   	push   %ebp
  100815:	89 e5                	mov    %esp,%ebp
  if(lapic)
  100817:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  10081c:	85 c0                	test   %eax,%eax
  10081e:	74 0c                	je     10082c <lapiceoi+0x18>
    lapicw(EOI, 0);
  100820:	6a 00                	push   $0x0
  100822:	6a 2c                	push   $0x2c
  100824:	e8 87 fe ff ff       	call   1006b0 <lapicw>
  100829:	83 c4 08             	add    $0x8,%esp
}
  10082c:	90                   	nop
  10082d:	c9                   	leave  
  10082e:	c3                   	ret    

0010082f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  10082f:	55                   	push   %ebp
  100830:	89 e5                	mov    %esp,%ebp
  100832:	90                   	nop
  100833:	5d                   	pop    %ebp
  100834:	c3                   	ret    

00100835 <sti>:


static inline void
sti(void)
{
  100835:	55                   	push   %ebp
  100836:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
  100838:	fb                   	sti    
}
  100839:	90                   	nop
  10083a:	5d                   	pop    %ebp
  10083b:	c3                   	ret    

0010083c <wfi>:

static inline void
wfi(void)
{
  10083c:	55                   	push   %ebp
  10083d:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
  10083f:	f4                   	hlt    
}
  100840:	90                   	nop
  100841:	5d                   	pop    %ebp
  100842:	c3                   	ret    

00100843 <welcome>:
#include "fcntl.h"

extern char end[]; // first address after kernel loaded from ELF file

static inline void
welcome(void) {
  100843:	55                   	push   %ebp
  100844:	89 e5                	mov    %esp,%ebp
  100846:	83 ec 28             	sub    $0x28,%esp
  struct file* c;

  if((c = open("console", O_RDWR)) == 0) {
  100849:	83 ec 08             	sub    $0x8,%esp
  10084c:	6a 02                	push   $0x2
  10084e:	68 42 41 10 00       	push   $0x104142
  100853:	e8 15 33 00 00       	call   103b6d <open>
  100858:	83 c4 10             	add    $0x10,%esp
  10085b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10085e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100862:	75 0d                	jne    100871 <welcome+0x2e>
    panic("Failed to open console");
  100864:	83 ec 0c             	sub    $0xc,%esp
  100867:	68 4a 41 10 00       	push   $0x10414a
  10086c:	e8 3c fa ff ff       	call   1002ad <panic>
  }
  filewrite(c, "\nEnter your name: ", 18);
  100871:	83 ec 04             	sub    $0x4,%esp
  100874:	6a 12                	push   $0x12
  100876:	68 61 41 10 00       	push   $0x104161
  10087b:	ff 75 f4             	push   -0xc(%ebp)
  10087e:	e8 f2 2d 00 00       	call   103675 <filewrite>
  100883:	83 c4 10             	add    $0x10,%esp
  char name[20];
  int namelen = fileread(c, name, 20);
  100886:	83 ec 04             	sub    $0x4,%esp
  100889:	6a 14                	push   $0x14
  10088b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10088e:	50                   	push   %eax
  10088f:	ff 75 f4             	push   -0xc(%ebp)
  100892:	e8 5f 2d 00 00       	call   1035f6 <fileread>
  100897:	83 c4 10             	add    $0x10,%esp
  10089a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  filewrite(c, "Nice to meet you! ", 18);
  10089d:	83 ec 04             	sub    $0x4,%esp
  1008a0:	6a 12                	push   $0x12
  1008a2:	68 74 41 10 00       	push   $0x104174
  1008a7:	ff 75 f4             	push   -0xc(%ebp)
  1008aa:	e8 c6 2d 00 00       	call   103675 <filewrite>
  1008af:	83 c4 10             	add    $0x10,%esp
  filewrite(c, name, namelen);
  1008b2:	83 ec 04             	sub    $0x4,%esp
  1008b5:	ff 75 f0             	push   -0x10(%ebp)
  1008b8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008bb:	50                   	push   %eax
  1008bc:	ff 75 f4             	push   -0xc(%ebp)
  1008bf:	e8 b1 2d 00 00       	call   103675 <filewrite>
  1008c4:	83 c4 10             	add    $0x10,%esp
  filewrite(c, "BYE!\n", 6);
  1008c7:	83 ec 04             	sub    $0x4,%esp
  1008ca:	6a 06                	push   $0x6
  1008cc:	68 87 41 10 00       	push   $0x104187
  1008d1:	ff 75 f4             	push   -0xc(%ebp)
  1008d4:	e8 9c 2d 00 00       	call   103675 <filewrite>
  1008d9:	83 c4 10             	add    $0x10,%esp
  fileclose(c);
  1008dc:	83 ec 0c             	sub    $0xc,%esp
  1008df:	ff 75 f4             	push   -0xc(%ebp)
  1008e2:	e8 3b 2c 00 00       	call   103522 <fileclose>
  1008e7:	83 c4 10             	add    $0x10,%esp
}
  1008ea:	90                   	nop
  1008eb:	c9                   	leave  
  1008ec:	c3                   	ret    

001008ed <main>:

// Bootstrap processor starts running C code here.
int
main(void)
{
  1008ed:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  1008f1:	83 e4 f0             	and    $0xfffffff0,%esp
  1008f4:	ff 71 fc             	push   -0x4(%ecx)
  1008f7:	55                   	push   %ebp
  1008f8:	89 e5                	mov    %esp,%ebp
  1008fa:	51                   	push   %ecx
  1008fb:	83 ec 54             	sub    $0x54,%esp
  mpinit();        // detect other processors
  1008fe:	e8 9f 02 00 00       	call   100ba2 <mpinit>
  lapicinit();     // interrupt controller
  100903:	e8 cb fd ff ff       	call   1006d3 <lapicinit>
  picinit();       // disable pic
  100908:	e8 f3 03 00 00       	call   100d00 <picinit>
  ioapicinit();    // another interrupt controller
  10090d:	e8 b9 fc ff ff       	call   1005cb <ioapicinit>
  consoleinit();   // console hardware
  100912:	e8 68 fc ff ff       	call   10057f <consoleinit>
  uartinit();      // serial port
  100917:	e8 49 04 00 00       	call   100d65 <uartinit>
  ideinit();       // disk 
  10091c:	e8 bc 18 00 00       	call   1021dd <ideinit>
  tvinit();        // trap vectors
  100921:	e8 df 09 00 00       	call   101305 <tvinit>
  binit();         // buffer cache
  100926:	e8 ff 15 00 00       	call   101f2a <binit>
  idtinit();       // load idt register
  10092b:	e8 bb 0a 00 00       	call   1013eb <idtinit>
  sti();           // enable interrupts
  100930:	e8 00 ff ff ff       	call   100835 <sti>
  iinit(ROOTDEV);  // Read superblock to start reading inodes
  100935:	83 ec 0c             	sub    $0xc,%esp
  100938:	6a 01                	push   $0x1
  10093a:	e8 81 1e 00 00       	call   1027c0 <iinit>
  10093f:	83 c4 10             	add    $0x10,%esp
  initlog(ROOTDEV);  // Initialize log
  100942:	83 ec 0c             	sub    $0xc,%esp
  100945:	6a 01                	push   $0x1
  100947:	e8 ec 33 00 00       	call   103d38 <initlog>
  10094c:	83 c4 10             	add    $0x10,%esp

  struct inode console;
  mknod(&console, "console", CONSOLE, CONSOLE);
  10094f:	6a 01                	push   $0x1
  100951:	6a 01                	push   $0x1
  100953:	68 42 41 10 00       	push   $0x104142
  100958:	8d 45 a8             	lea    -0x58(%ebp),%eax
  10095b:	50                   	push   %eax
  10095c:	e8 39 33 00 00       	call   103c9a <mknod>
  100961:	83 c4 10             	add    $0x10,%esp
  welcome();       // print welcome message
  100964:	e8 da fe ff ff       	call   100843 <welcome>
  for(;;)
    wfi();
  100969:	e8 ce fe ff ff       	call   10083c <wfi>
  10096e:	eb f9                	jmp    100969 <main+0x7c>

00100970 <inb>:
{
  100970:	55                   	push   %ebp
  100971:	89 e5                	mov    %esp,%ebp
  100973:	83 ec 14             	sub    $0x14,%esp
  100976:	8b 45 08             	mov    0x8(%ebp),%eax
  100979:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10097d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100981:	89 c2                	mov    %eax,%edx
  100983:	ec                   	in     (%dx),%al
  100984:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100987:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  10098b:	c9                   	leave  
  10098c:	c3                   	ret    

0010098d <outb>:
{
  10098d:	55                   	push   %ebp
  10098e:	89 e5                	mov    %esp,%ebp
  100990:	83 ec 08             	sub    $0x8,%esp
  100993:	8b 45 08             	mov    0x8(%ebp),%eax
  100996:	8b 55 0c             	mov    0xc(%ebp),%edx
  100999:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  10099d:	89 d0                	mov    %edx,%eax
  10099f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1009a2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  1009a6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1009aa:	ee                   	out    %al,(%dx)
}
  1009ab:	90                   	nop
  1009ac:	c9                   	leave  
  1009ad:	c3                   	ret    

001009ae <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
  1009ae:	55                   	push   %ebp
  1009af:	89 e5                	mov    %esp,%ebp
  1009b1:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
  1009b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
  1009bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1009c2:	eb 15                	jmp    1009d9 <sum+0x2b>
    sum += addr[i];
  1009c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ca:	01 d0                	add    %edx,%eax
  1009cc:	0f b6 00             	movzbl (%eax),%eax
  1009cf:	0f b6 c0             	movzbl %al,%eax
  1009d2:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
  1009d5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1009d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1009dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1009df:	7c e3                	jl     1009c4 <sum+0x16>
  return sum;
  1009e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1009e4:	c9                   	leave  
  1009e5:	c3                   	ret    

001009e6 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  1009e6:	55                   	push   %ebp
  1009e7:	89 e5                	mov    %esp,%ebp
  1009e9:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  1009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
  1009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1009f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009f8:	01 d0                	add    %edx,%eax
  1009fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
  1009fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a03:	eb 36                	jmp    100a3b <mpsearch1+0x55>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  100a05:	83 ec 04             	sub    $0x4,%esp
  100a08:	6a 04                	push   $0x4
  100a0a:	68 90 41 10 00       	push   $0x104190
  100a0f:	ff 75 f4             	push   -0xc(%ebp)
  100a12:	e8 96 05 00 00       	call   100fad <memcmp>
  100a17:	83 c4 10             	add    $0x10,%esp
  100a1a:	85 c0                	test   %eax,%eax
  100a1c:	75 19                	jne    100a37 <mpsearch1+0x51>
  100a1e:	83 ec 08             	sub    $0x8,%esp
  100a21:	6a 10                	push   $0x10
  100a23:	ff 75 f4             	push   -0xc(%ebp)
  100a26:	e8 83 ff ff ff       	call   1009ae <sum>
  100a2b:	83 c4 10             	add    $0x10,%esp
  100a2e:	84 c0                	test   %al,%al
  100a30:	75 05                	jne    100a37 <mpsearch1+0x51>
      return (struct mp*)p;
  100a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a35:	eb 11                	jmp    100a48 <mpsearch1+0x62>
  for(p = addr; p < e; p += sizeof(struct mp))
  100a37:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  100a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100a41:	72 c2                	jb     100a05 <mpsearch1+0x1f>
  return 0;    
  100a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100a48:	c9                   	leave  
  100a49:	c3                   	ret    

00100a4a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
  100a4a:	55                   	push   %ebp
  100a4b:	89 e5                	mov    %esp,%ebp
  100a4d:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  // bda = (uchar *) P2V(0x400);
  bda = (uchar *) 0x400;
  100a50:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	83 c0 0f             	add    $0xf,%eax
  100a5d:	0f b6 00             	movzbl (%eax),%eax
  100a60:	0f b6 c0             	movzbl %al,%eax
  100a63:	c1 e0 08             	shl    $0x8,%eax
  100a66:	89 c2                	mov    %eax,%edx
  100a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6b:	83 c0 0e             	add    $0xe,%eax
  100a6e:	0f b6 00             	movzbl (%eax),%eax
  100a71:	0f b6 c0             	movzbl %al,%eax
  100a74:	09 d0                	or     %edx,%eax
  100a76:	c1 e0 04             	shl    $0x4,%eax
  100a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a80:	74 21                	je     100aa3 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
  100a82:	83 ec 08             	sub    $0x8,%esp
  100a85:	68 00 04 00 00       	push   $0x400
  100a8a:	ff 75 f0             	push   -0x10(%ebp)
  100a8d:	e8 54 ff ff ff       	call   1009e6 <mpsearch1>
  100a92:	83 c4 10             	add    $0x10,%esp
  100a95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100a98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100a9c:	74 51                	je     100aef <mpsearch+0xa5>
      return mp;
  100a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100aa1:	eb 61                	jmp    100b04 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aa6:	83 c0 14             	add    $0x14,%eax
  100aa9:	0f b6 00             	movzbl (%eax),%eax
  100aac:	0f b6 c0             	movzbl %al,%eax
  100aaf:	c1 e0 08             	shl    $0x8,%eax
  100ab2:	89 c2                	mov    %eax,%edx
  100ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab7:	83 c0 13             	add    $0x13,%eax
  100aba:	0f b6 00             	movzbl (%eax),%eax
  100abd:	0f b6 c0             	movzbl %al,%eax
  100ac0:	09 d0                	or     %edx,%eax
  100ac2:	c1 e0 0a             	shl    $0xa,%eax
  100ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
  100ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100acb:	2d 00 04 00 00       	sub    $0x400,%eax
  100ad0:	83 ec 08             	sub    $0x8,%esp
  100ad3:	68 00 04 00 00       	push   $0x400
  100ad8:	50                   	push   %eax
  100ad9:	e8 08 ff ff ff       	call   1009e6 <mpsearch1>
  100ade:	83 c4 10             	add    $0x10,%esp
  100ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100ae4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100ae8:	74 05                	je     100aef <mpsearch+0xa5>
      return mp;
  100aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100aed:	eb 15                	jmp    100b04 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
  100aef:	83 ec 08             	sub    $0x8,%esp
  100af2:	68 00 00 01 00       	push   $0x10000
  100af7:	68 00 00 0f 00       	push   $0xf0000
  100afc:	e8 e5 fe ff ff       	call   1009e6 <mpsearch1>
  100b01:	83 c4 10             	add    $0x10,%esp
}
  100b04:	c9                   	leave  
  100b05:	c3                   	ret    

00100b06 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
  100b06:	55                   	push   %ebp
  100b07:	89 e5                	mov    %esp,%ebp
  100b09:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100b0c:	e8 39 ff ff ff       	call   100a4a <mpsearch>
  100b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b18:	74 0a                	je     100b24 <mpconfig+0x1e>
  100b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b1d:	8b 40 04             	mov    0x4(%eax),%eax
  100b20:	85 c0                	test   %eax,%eax
  100b22:	75 07                	jne    100b2b <mpconfig+0x25>
    return 0;
  100b24:	b8 00 00 00 00       	mov    $0x0,%eax
  100b29:	eb 75                	jmp    100ba0 <mpconfig+0x9a>
  // conf = (struct mpconf*) P2V((uint) mp->physaddr);
  conf = (struct mpconf*) (uint) mp->physaddr;
  100b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2e:	8b 40 04             	mov    0x4(%eax),%eax
  100b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
  100b34:	83 ec 04             	sub    $0x4,%esp
  100b37:	6a 04                	push   $0x4
  100b39:	68 95 41 10 00       	push   $0x104195
  100b3e:	ff 75 f0             	push   -0x10(%ebp)
  100b41:	e8 67 04 00 00       	call   100fad <memcmp>
  100b46:	83 c4 10             	add    $0x10,%esp
  100b49:	85 c0                	test   %eax,%eax
  100b4b:	74 07                	je     100b54 <mpconfig+0x4e>
    return 0;
  100b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  100b52:	eb 4c                	jmp    100ba0 <mpconfig+0x9a>
  if(conf->version != 1 && conf->version != 4)
  100b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b57:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100b5b:	3c 01                	cmp    $0x1,%al
  100b5d:	74 12                	je     100b71 <mpconfig+0x6b>
  100b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b62:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100b66:	3c 04                	cmp    $0x4,%al
  100b68:	74 07                	je     100b71 <mpconfig+0x6b>
    return 0;
  100b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b6f:	eb 2f                	jmp    100ba0 <mpconfig+0x9a>
  if(sum((uchar*)conf, conf->length) != 0)
  100b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b74:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100b78:	0f b7 c0             	movzwl %ax,%eax
  100b7b:	83 ec 08             	sub    $0x8,%esp
  100b7e:	50                   	push   %eax
  100b7f:	ff 75 f0             	push   -0x10(%ebp)
  100b82:	e8 27 fe ff ff       	call   1009ae <sum>
  100b87:	83 c4 10             	add    $0x10,%esp
  100b8a:	84 c0                	test   %al,%al
  100b8c:	74 07                	je     100b95 <mpconfig+0x8f>
    return 0;
  100b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  100b93:	eb 0b                	jmp    100ba0 <mpconfig+0x9a>
  *pmp = mp;
  100b95:	8b 45 08             	mov    0x8(%ebp),%eax
  100b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9b:	89 10                	mov    %edx,(%eax)
  return conf;
  100b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100ba0:	c9                   	leave  
  100ba1:	c3                   	ret    

00100ba2 <mpinit>:

void
mpinit(void)
{
  100ba2:	55                   	push   %ebp
  100ba3:	89 e5                	mov    %esp,%ebp
  100ba5:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
  100ba8:	83 ec 0c             	sub    $0xc,%esp
  100bab:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100bae:	50                   	push   %eax
  100baf:	e8 52 ff ff ff       	call   100b06 <mpconfig>
  100bb4:	83 c4 10             	add    $0x10,%esp
  100bb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100bba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100bbe:	75 0d                	jne    100bcd <mpinit+0x2b>
    panic("Expect to run on an SMP");
  100bc0:	83 ec 0c             	sub    $0xc,%esp
  100bc3:	68 9a 41 10 00       	push   $0x10419a
  100bc8:	e8 e0 f6 ff ff       	call   1002ad <panic>
  ismp = 1;
  100bcd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
  100bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100bd7:	8b 40 24             	mov    0x24(%eax),%eax
  100bda:	a3 b4 54 10 00       	mov    %eax,0x1054b4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100be2:	83 c0 2c             	add    $0x2c,%eax
  100be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100beb:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100bef:	0f b7 d0             	movzwl %ax,%edx
  100bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100bf5:	01 d0                	add    %edx,%eax
  100bf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100bfa:	e9 83 00 00 00       	jmp    100c82 <mpinit+0xe0>
    switch(*p){
  100bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c02:	0f b6 00             	movzbl (%eax),%eax
  100c05:	0f b6 c0             	movzbl %al,%eax
  100c08:	83 f8 04             	cmp    $0x4,%eax
  100c0b:	7f 6d                	jg     100c7a <mpinit+0xd8>
  100c0d:	83 f8 03             	cmp    $0x3,%eax
  100c10:	7d 62                	jge    100c74 <mpinit+0xd2>
  100c12:	83 f8 02             	cmp    $0x2,%eax
  100c15:	74 45                	je     100c5c <mpinit+0xba>
  100c17:	83 f8 02             	cmp    $0x2,%eax
  100c1a:	7f 5e                	jg     100c7a <mpinit+0xd8>
  100c1c:	85 c0                	test   %eax,%eax
  100c1e:	74 07                	je     100c27 <mpinit+0x85>
  100c20:	83 f8 01             	cmp    $0x1,%eax
  100c23:	74 4f                	je     100c74 <mpinit+0xd2>
  100c25:	eb 53                	jmp    100c7a <mpinit+0xd8>
    case MPPROC:
      proc = (struct mpproc*)p;
  100c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
  100c2d:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  100c32:	83 f8 07             	cmp    $0x7,%eax
  100c35:	7f 1f                	jg     100c56 <mpinit+0xb4>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  100c37:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  100c3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100c3f:	0f b6 52 01          	movzbl 0x1(%edx),%edx
  100c43:	88 90 b8 54 10 00    	mov    %dl,0x1054b8(%eax)
        ncpu++;
  100c49:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  100c4e:	83 c0 01             	add    $0x1,%eax
  100c51:	a3 c0 54 10 00       	mov    %eax,0x1054c0
      }
      p += sizeof(struct mpproc);
  100c56:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
  100c5a:	eb 26                	jmp    100c82 <mpinit+0xe0>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
  100c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
  100c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c65:	0f b6 40 01          	movzbl 0x1(%eax),%eax
  100c69:	a2 c4 54 10 00       	mov    %al,0x1054c4
      p += sizeof(struct mpioapic);
  100c6e:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100c72:	eb 0e                	jmp    100c82 <mpinit+0xe0>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100c74:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100c78:	eb 08                	jmp    100c82 <mpinit+0xe0>
    default:
      ismp = 0;
  100c7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
  100c81:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c85:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  100c88:	0f 82 71 ff ff ff    	jb     100bff <mpinit+0x5d>
    }
  }
  if(!ismp)
  100c8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c92:	75 0d                	jne    100ca1 <mpinit+0xff>
    panic("Didn't find a suitable machine");
  100c94:	83 ec 0c             	sub    $0xc,%esp
  100c97:	68 b4 41 10 00       	push   $0x1041b4
  100c9c:	e8 0c f6 ff ff       	call   1002ad <panic>

  if(mp->imcrp){
  100ca1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100ca4:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
  100ca8:	84 c0                	test   %al,%al
  100caa:	74 30                	je     100cdc <mpinit+0x13a>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
  100cac:	83 ec 08             	sub    $0x8,%esp
  100caf:	6a 70                	push   $0x70
  100cb1:	6a 22                	push   $0x22
  100cb3:	e8 d5 fc ff ff       	call   10098d <outb>
  100cb8:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  100cbb:	83 ec 0c             	sub    $0xc,%esp
  100cbe:	6a 23                	push   $0x23
  100cc0:	e8 ab fc ff ff       	call   100970 <inb>
  100cc5:	83 c4 10             	add    $0x10,%esp
  100cc8:	83 c8 01             	or     $0x1,%eax
  100ccb:	0f b6 c0             	movzbl %al,%eax
  100cce:	83 ec 08             	sub    $0x8,%esp
  100cd1:	50                   	push   %eax
  100cd2:	6a 23                	push   $0x23
  100cd4:	e8 b4 fc ff ff       	call   10098d <outb>
  100cd9:	83 c4 10             	add    $0x10,%esp
  }
}
  100cdc:	90                   	nop
  100cdd:	c9                   	leave  
  100cde:	c3                   	ret    

00100cdf <outb>:
{
  100cdf:	55                   	push   %ebp
  100ce0:	89 e5                	mov    %esp,%ebp
  100ce2:	83 ec 08             	sub    $0x8,%esp
  100ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ceb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100cef:	89 d0                	mov    %edx,%eax
  100cf1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100cf4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100cf8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100cfc:	ee                   	out    %al,(%dx)
}
  100cfd:	90                   	nop
  100cfe:	c9                   	leave  
  100cff:	c3                   	ret    

00100d00 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
  100d00:	55                   	push   %ebp
  100d01:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  100d03:	68 ff 00 00 00       	push   $0xff
  100d08:	6a 21                	push   $0x21
  100d0a:	e8 d0 ff ff ff       	call   100cdf <outb>
  100d0f:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
  100d12:	68 ff 00 00 00       	push   $0xff
  100d17:	68 a1 00 00 00       	push   $0xa1
  100d1c:	e8 be ff ff ff       	call   100cdf <outb>
  100d21:	83 c4 08             	add    $0x8,%esp
  100d24:	90                   	nop
  100d25:	c9                   	leave  
  100d26:	c3                   	ret    

00100d27 <inb>:
{
  100d27:	55                   	push   %ebp
  100d28:	89 e5                	mov    %esp,%ebp
  100d2a:	83 ec 14             	sub    $0x14,%esp
  100d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d30:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100d34:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100d38:	89 c2                	mov    %eax,%edx
  100d3a:	ec                   	in     (%dx),%al
  100d3b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100d3e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  100d42:	c9                   	leave  
  100d43:	c3                   	ret    

00100d44 <outb>:
{
  100d44:	55                   	push   %ebp
  100d45:	89 e5                	mov    %esp,%ebp
  100d47:	83 ec 08             	sub    $0x8,%esp
  100d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100d50:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100d54:	89 d0                	mov    %edx,%eax
  100d56:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100d59:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100d5d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100d61:	ee                   	out    %al,(%dx)
}
  100d62:	90                   	nop
  100d63:	c9                   	leave  
  100d64:	c3                   	ret    

00100d65 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  100d65:	55                   	push   %ebp
  100d66:	89 e5                	mov    %esp,%ebp
  100d68:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
  100d6b:	6a 00                	push   $0x0
  100d6d:	68 fa 03 00 00       	push   $0x3fa
  100d72:	e8 cd ff ff ff       	call   100d44 <outb>
  100d77:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
  100d7a:	68 80 00 00 00       	push   $0x80
  100d7f:	68 fb 03 00 00       	push   $0x3fb
  100d84:	e8 bb ff ff ff       	call   100d44 <outb>
  100d89:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
  100d8c:	6a 0c                	push   $0xc
  100d8e:	68 f8 03 00 00       	push   $0x3f8
  100d93:	e8 ac ff ff ff       	call   100d44 <outb>
  100d98:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
  100d9b:	6a 00                	push   $0x0
  100d9d:	68 f9 03 00 00       	push   $0x3f9
  100da2:	e8 9d ff ff ff       	call   100d44 <outb>
  100da7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  100daa:	6a 03                	push   $0x3
  100dac:	68 fb 03 00 00       	push   $0x3fb
  100db1:	e8 8e ff ff ff       	call   100d44 <outb>
  100db6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
  100db9:	6a 00                	push   $0x0
  100dbb:	68 fc 03 00 00       	push   $0x3fc
  100dc0:	e8 7f ff ff ff       	call   100d44 <outb>
  100dc5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
  100dc8:	6a 01                	push   $0x1
  100dca:	68 f9 03 00 00       	push   $0x3f9
  100dcf:	e8 70 ff ff ff       	call   100d44 <outb>
  100dd4:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  100dd7:	68 fd 03 00 00       	push   $0x3fd
  100ddc:	e8 46 ff ff ff       	call   100d27 <inb>
  100de1:	83 c4 04             	add    $0x4,%esp
  100de4:	3c ff                	cmp    $0xff,%al
  100de6:	74 61                	je     100e49 <uartinit+0xe4>
    return;
  uart = 1;
  100de8:	c7 05 c8 54 10 00 01 	movl   $0x1,0x1054c8
  100def:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  100df2:	68 fa 03 00 00       	push   $0x3fa
  100df7:	e8 2b ff ff ff       	call   100d27 <inb>
  100dfc:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
  100dff:	68 f8 03 00 00       	push   $0x3f8
  100e04:	e8 1e ff ff ff       	call   100d27 <inb>
  100e09:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
  100e0c:	83 ec 08             	sub    $0x8,%esp
  100e0f:	6a 00                	push   $0x0
  100e11:	6a 04                	push   $0x4
  100e13:	e8 5b f8 ff ff       	call   100673 <ioapicenable>
  100e18:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  100e1b:	c7 45 f4 d3 41 10 00 	movl   $0x1041d3,-0xc(%ebp)
  100e22:	eb 19                	jmp    100e3d <uartinit+0xd8>
    uartputc(*p);
  100e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e27:	0f b6 00             	movzbl (%eax),%eax
  100e2a:	0f be c0             	movsbl %al,%eax
  100e2d:	83 ec 0c             	sub    $0xc,%esp
  100e30:	50                   	push   %eax
  100e31:	e8 16 00 00 00       	call   100e4c <uartputc>
  100e36:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
  100e39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e40:	0f b6 00             	movzbl (%eax),%eax
  100e43:	84 c0                	test   %al,%al
  100e45:	75 dd                	jne    100e24 <uartinit+0xbf>
  100e47:	eb 01                	jmp    100e4a <uartinit+0xe5>
    return;
  100e49:	90                   	nop
}
  100e4a:	c9                   	leave  
  100e4b:	c3                   	ret    

00100e4c <uartputc>:

void
uartputc(int c)
{
  100e4c:	55                   	push   %ebp
  100e4d:	89 e5                	mov    %esp,%ebp
  100e4f:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  100e52:	a1 c8 54 10 00       	mov    0x1054c8,%eax
  100e57:	85 c0                	test   %eax,%eax
  100e59:	74 40                	je     100e9b <uartputc+0x4f>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100e62:	eb 04                	jmp    100e68 <uartputc+0x1c>
  100e64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100e68:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100e6c:	7f 17                	jg     100e85 <uartputc+0x39>
  100e6e:	68 fd 03 00 00       	push   $0x3fd
  100e73:	e8 af fe ff ff       	call   100d27 <inb>
  100e78:	83 c4 04             	add    $0x4,%esp
  100e7b:	0f b6 c0             	movzbl %al,%eax
  100e7e:	83 e0 20             	and    $0x20,%eax
  100e81:	85 c0                	test   %eax,%eax
  100e83:	74 df                	je     100e64 <uartputc+0x18>
  outb(COM1+0, c);
  100e85:	8b 45 08             	mov    0x8(%ebp),%eax
  100e88:	0f b6 c0             	movzbl %al,%eax
  100e8b:	50                   	push   %eax
  100e8c:	68 f8 03 00 00       	push   $0x3f8
  100e91:	e8 ae fe ff ff       	call   100d44 <outb>
  100e96:	83 c4 08             	add    $0x8,%esp
  100e99:	eb 01                	jmp    100e9c <uartputc+0x50>
    return;
  100e9b:	90                   	nop
}
  100e9c:	c9                   	leave  
  100e9d:	c3                   	ret    

00100e9e <uartgetc>:


static int
uartgetc(void)
{
  100e9e:	55                   	push   %ebp
  100e9f:	89 e5                	mov    %esp,%ebp
  if(!uart)
  100ea1:	a1 c8 54 10 00       	mov    0x1054c8,%eax
  100ea6:	85 c0                	test   %eax,%eax
  100ea8:	75 07                	jne    100eb1 <uartgetc+0x13>
    return -1;
  100eaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100eaf:	eb 2e                	jmp    100edf <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
  100eb1:	68 fd 03 00 00       	push   $0x3fd
  100eb6:	e8 6c fe ff ff       	call   100d27 <inb>
  100ebb:	83 c4 04             	add    $0x4,%esp
  100ebe:	0f b6 c0             	movzbl %al,%eax
  100ec1:	83 e0 01             	and    $0x1,%eax
  100ec4:	85 c0                	test   %eax,%eax
  100ec6:	75 07                	jne    100ecf <uartgetc+0x31>
    return -1;
  100ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100ecd:	eb 10                	jmp    100edf <uartgetc+0x41>
  return inb(COM1+0);
  100ecf:	68 f8 03 00 00       	push   $0x3f8
  100ed4:	e8 4e fe ff ff       	call   100d27 <inb>
  100ed9:	83 c4 04             	add    $0x4,%esp
  100edc:	0f b6 c0             	movzbl %al,%eax
}
  100edf:	c9                   	leave  
  100ee0:	c3                   	ret    

00100ee1 <uartintr>:

void
uartintr(void)
{
  100ee1:	55                   	push   %ebp
  100ee2:	89 e5                	mov    %esp,%ebp
  100ee4:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
  100ee7:	83 ec 0c             	sub    $0xc,%esp
  100eea:	68 9e 0e 10 00       	push   $0x100e9e
  100eef:	e8 8f f4 ff ff       	call   100383 <consoleintr>
  100ef4:	83 c4 10             	add    $0x10,%esp
  100ef7:	90                   	nop
  100ef8:	c9                   	leave  
  100ef9:	c3                   	ret    

00100efa <stosb>:
{
  100efa:	55                   	push   %ebp
  100efb:	89 e5                	mov    %esp,%ebp
  100efd:	57                   	push   %edi
  100efe:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  100eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100f02:	8b 55 10             	mov    0x10(%ebp),%edx
  100f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f08:	89 cb                	mov    %ecx,%ebx
  100f0a:	89 df                	mov    %ebx,%edi
  100f0c:	89 d1                	mov    %edx,%ecx
  100f0e:	fc                   	cld    
  100f0f:	f3 aa                	rep stos %al,%es:(%edi)
  100f11:	89 ca                	mov    %ecx,%edx
  100f13:	89 fb                	mov    %edi,%ebx
  100f15:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100f18:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100f1b:	90                   	nop
  100f1c:	5b                   	pop    %ebx
  100f1d:	5f                   	pop    %edi
  100f1e:	5d                   	pop    %ebp
  100f1f:	c3                   	ret    

00100f20 <stosl>:
{
  100f20:	55                   	push   %ebp
  100f21:	89 e5                	mov    %esp,%ebp
  100f23:	57                   	push   %edi
  100f24:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
  100f25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100f28:	8b 55 10             	mov    0x10(%ebp),%edx
  100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2e:	89 cb                	mov    %ecx,%ebx
  100f30:	89 df                	mov    %ebx,%edi
  100f32:	89 d1                	mov    %edx,%ecx
  100f34:	fc                   	cld    
  100f35:	f3 ab                	rep stos %eax,%es:(%edi)
  100f37:	89 ca                	mov    %ecx,%edx
  100f39:	89 fb                	mov    %edi,%ebx
  100f3b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100f3e:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100f41:	90                   	nop
  100f42:	5b                   	pop    %ebx
  100f43:	5f                   	pop    %edi
  100f44:	5d                   	pop    %ebp
  100f45:	c3                   	ret    

00100f46 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100f46:	55                   	push   %ebp
  100f47:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
  100f49:	8b 45 08             	mov    0x8(%ebp),%eax
  100f4c:	83 e0 03             	and    $0x3,%eax
  100f4f:	85 c0                	test   %eax,%eax
  100f51:	75 43                	jne    100f96 <memset+0x50>
  100f53:	8b 45 10             	mov    0x10(%ebp),%eax
  100f56:	83 e0 03             	and    $0x3,%eax
  100f59:	85 c0                	test   %eax,%eax
  100f5b:	75 39                	jne    100f96 <memset+0x50>
    c &= 0xFF;
  100f5d:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100f64:	8b 45 10             	mov    0x10(%ebp),%eax
  100f67:	c1 e8 02             	shr    $0x2,%eax
  100f6a:	89 c2                	mov    %eax,%edx
  100f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f6f:	c1 e0 18             	shl    $0x18,%eax
  100f72:	89 c1                	mov    %eax,%ecx
  100f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f77:	c1 e0 10             	shl    $0x10,%eax
  100f7a:	09 c1                	or     %eax,%ecx
  100f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f7f:	c1 e0 08             	shl    $0x8,%eax
  100f82:	09 c8                	or     %ecx,%eax
  100f84:	0b 45 0c             	or     0xc(%ebp),%eax
  100f87:	52                   	push   %edx
  100f88:	50                   	push   %eax
  100f89:	ff 75 08             	push   0x8(%ebp)
  100f8c:	e8 8f ff ff ff       	call   100f20 <stosl>
  100f91:	83 c4 0c             	add    $0xc,%esp
  100f94:	eb 12                	jmp    100fa8 <memset+0x62>
  } else
    stosb(dst, c, n);
  100f96:	8b 45 10             	mov    0x10(%ebp),%eax
  100f99:	50                   	push   %eax
  100f9a:	ff 75 0c             	push   0xc(%ebp)
  100f9d:	ff 75 08             	push   0x8(%ebp)
  100fa0:	e8 55 ff ff ff       	call   100efa <stosb>
  100fa5:	83 c4 0c             	add    $0xc,%esp
  return dst;
  100fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100fab:	c9                   	leave  
  100fac:	c3                   	ret    

00100fad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100fad:	55                   	push   %ebp
  100fae:	89 e5                	mov    %esp,%ebp
  100fb0:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
  100fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  100fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
  100fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
  100fbf:	eb 30                	jmp    100ff1 <memcmp+0x44>
    if(*s1 != *s2)
  100fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fc4:	0f b6 10             	movzbl (%eax),%edx
  100fc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100fca:	0f b6 00             	movzbl (%eax),%eax
  100fcd:	38 c2                	cmp    %al,%dl
  100fcf:	74 18                	je     100fe9 <memcmp+0x3c>
      return *s1 - *s2;
  100fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fd4:	0f b6 00             	movzbl (%eax),%eax
  100fd7:	0f b6 d0             	movzbl %al,%edx
  100fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100fdd:	0f b6 00             	movzbl (%eax),%eax
  100fe0:	0f b6 c8             	movzbl %al,%ecx
  100fe3:	89 d0                	mov    %edx,%eax
  100fe5:	29 c8                	sub    %ecx,%eax
  100fe7:	eb 1a                	jmp    101003 <memcmp+0x56>
    s1++, s2++;
  100fe9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fed:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
  100ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  100ff4:	8d 50 ff             	lea    -0x1(%eax),%edx
  100ff7:	89 55 10             	mov    %edx,0x10(%ebp)
  100ffa:	85 c0                	test   %eax,%eax
  100ffc:	75 c3                	jne    100fc1 <memcmp+0x14>
  }

  return 0;
  100ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101003:	c9                   	leave  
  101004:	c3                   	ret    

00101005 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  101005:	55                   	push   %ebp
  101006:	89 e5                	mov    %esp,%ebp
  101008:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
  10100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10100e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
  101011:	8b 45 08             	mov    0x8(%ebp),%eax
  101014:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
  101017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10101a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10101d:	73 54                	jae    101073 <memmove+0x6e>
  10101f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101022:	8b 45 10             	mov    0x10(%ebp),%eax
  101025:	01 d0                	add    %edx,%eax
  101027:	39 45 f8             	cmp    %eax,-0x8(%ebp)
  10102a:	73 47                	jae    101073 <memmove+0x6e>
    s += n;
  10102c:	8b 45 10             	mov    0x10(%ebp),%eax
  10102f:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
  101032:	8b 45 10             	mov    0x10(%ebp),%eax
  101035:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
  101038:	eb 13                	jmp    10104d <memmove+0x48>
      *--d = *--s;
  10103a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10103e:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  101042:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101045:	0f b6 10             	movzbl (%eax),%edx
  101048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10104b:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  10104d:	8b 45 10             	mov    0x10(%ebp),%eax
  101050:	8d 50 ff             	lea    -0x1(%eax),%edx
  101053:	89 55 10             	mov    %edx,0x10(%ebp)
  101056:	85 c0                	test   %eax,%eax
  101058:	75 e0                	jne    10103a <memmove+0x35>
  if(s < d && s + n > d){
  10105a:	eb 24                	jmp    101080 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
  10105c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10105f:	8d 42 01             	lea    0x1(%edx),%eax
  101062:	89 45 fc             	mov    %eax,-0x4(%ebp)
  101065:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101068:	8d 48 01             	lea    0x1(%eax),%ecx
  10106b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
  10106e:	0f b6 12             	movzbl (%edx),%edx
  101071:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  101073:	8b 45 10             	mov    0x10(%ebp),%eax
  101076:	8d 50 ff             	lea    -0x1(%eax),%edx
  101079:	89 55 10             	mov    %edx,0x10(%ebp)
  10107c:	85 c0                	test   %eax,%eax
  10107e:	75 dc                	jne    10105c <memmove+0x57>

  return dst;
  101080:	8b 45 08             	mov    0x8(%ebp),%eax
}
  101083:	c9                   	leave  
  101084:	c3                   	ret    

00101085 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  101085:	55                   	push   %ebp
  101086:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
  101088:	ff 75 10             	push   0x10(%ebp)
  10108b:	ff 75 0c             	push   0xc(%ebp)
  10108e:	ff 75 08             	push   0x8(%ebp)
  101091:	e8 6f ff ff ff       	call   101005 <memmove>
  101096:	83 c4 0c             	add    $0xc,%esp
}
  101099:	c9                   	leave  
  10109a:	c3                   	ret    

0010109b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  10109b:	55                   	push   %ebp
  10109c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  10109e:	eb 0c                	jmp    1010ac <strncmp+0x11>
    n--, p++, q++;
  1010a0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1010a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1010a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
  1010ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1010b0:	74 1a                	je     1010cc <strncmp+0x31>
  1010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b5:	0f b6 00             	movzbl (%eax),%eax
  1010b8:	84 c0                	test   %al,%al
  1010ba:	74 10                	je     1010cc <strncmp+0x31>
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	0f b6 10             	movzbl (%eax),%edx
  1010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1010c5:	0f b6 00             	movzbl (%eax),%eax
  1010c8:	38 c2                	cmp    %al,%dl
  1010ca:	74 d4                	je     1010a0 <strncmp+0x5>
  if(n == 0)
  1010cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1010d0:	75 07                	jne    1010d9 <strncmp+0x3e>
    return 0;
  1010d2:	b8 00 00 00 00       	mov    $0x0,%eax
  1010d7:	eb 16                	jmp    1010ef <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
  1010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010dc:	0f b6 00             	movzbl (%eax),%eax
  1010df:	0f b6 d0             	movzbl %al,%edx
  1010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1010e5:	0f b6 00             	movzbl (%eax),%eax
  1010e8:	0f b6 c8             	movzbl %al,%ecx
  1010eb:	89 d0                	mov    %edx,%eax
  1010ed:	29 c8                	sub    %ecx,%eax
}
  1010ef:	5d                   	pop    %ebp
  1010f0:	c3                   	ret    

001010f1 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1010f1:	55                   	push   %ebp
  1010f2:	89 e5                	mov    %esp,%ebp
  1010f4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  1010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
  1010fd:	90                   	nop
  1010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  101101:	8d 50 ff             	lea    -0x1(%eax),%edx
  101104:	89 55 10             	mov    %edx,0x10(%ebp)
  101107:	85 c0                	test   %eax,%eax
  101109:	7e 2c                	jle    101137 <strncpy+0x46>
  10110b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10110e:	8d 42 01             	lea    0x1(%edx),%eax
  101111:	89 45 0c             	mov    %eax,0xc(%ebp)
  101114:	8b 45 08             	mov    0x8(%ebp),%eax
  101117:	8d 48 01             	lea    0x1(%eax),%ecx
  10111a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  10111d:	0f b6 12             	movzbl (%edx),%edx
  101120:	88 10                	mov    %dl,(%eax)
  101122:	0f b6 00             	movzbl (%eax),%eax
  101125:	84 c0                	test   %al,%al
  101127:	75 d5                	jne    1010fe <strncpy+0xd>
    ;
  while(n-- > 0)
  101129:	eb 0c                	jmp    101137 <strncpy+0x46>
    *s++ = 0;
  10112b:	8b 45 08             	mov    0x8(%ebp),%eax
  10112e:	8d 50 01             	lea    0x1(%eax),%edx
  101131:	89 55 08             	mov    %edx,0x8(%ebp)
  101134:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
  101137:	8b 45 10             	mov    0x10(%ebp),%eax
  10113a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10113d:	89 55 10             	mov    %edx,0x10(%ebp)
  101140:	85 c0                	test   %eax,%eax
  101142:	7f e7                	jg     10112b <strncpy+0x3a>
  return os;
  101144:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101147:	c9                   	leave  
  101148:	c3                   	ret    

00101149 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  101149:	55                   	push   %ebp
  10114a:	89 e5                	mov    %esp,%ebp
  10114c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
  101155:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101159:	7f 05                	jg     101160 <safestrcpy+0x17>
    return os;
  10115b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10115e:	eb 32                	jmp    101192 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
  101160:	90                   	nop
  101161:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  101165:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101169:	7e 1e                	jle    101189 <safestrcpy+0x40>
  10116b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10116e:	8d 42 01             	lea    0x1(%edx),%eax
  101171:	89 45 0c             	mov    %eax,0xc(%ebp)
  101174:	8b 45 08             	mov    0x8(%ebp),%eax
  101177:	8d 48 01             	lea    0x1(%eax),%ecx
  10117a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  10117d:	0f b6 12             	movzbl (%edx),%edx
  101180:	88 10                	mov    %dl,(%eax)
  101182:	0f b6 00             	movzbl (%eax),%eax
  101185:	84 c0                	test   %al,%al
  101187:	75 d8                	jne    101161 <safestrcpy+0x18>
    ;
  *s = 0;
  101189:	8b 45 08             	mov    0x8(%ebp),%eax
  10118c:	c6 00 00             	movb   $0x0,(%eax)
  return os;
  10118f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101192:	c9                   	leave  
  101193:	c3                   	ret    

00101194 <strlen>:

int
strlen(const char *s)
{
  101194:	55                   	push   %ebp
  101195:	89 e5                	mov    %esp,%ebp
  101197:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  10119a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1011a1:	eb 04                	jmp    1011a7 <strlen+0x13>
  1011a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1011a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ad:	01 d0                	add    %edx,%eax
  1011af:	0f b6 00             	movzbl (%eax),%eax
  1011b2:	84 c0                	test   %al,%al
  1011b4:	75 ed                	jne    1011a3 <strlen+0xf>
    ;
  return n;
  1011b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1011b9:	c9                   	leave  
  1011ba:	c3                   	ret    

001011bb <readeflags>:
{
  1011bb:	55                   	push   %ebp
  1011bc:	89 e5                	mov    %esp,%ebp
  1011be:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1011c1:	9c                   	pushf  
  1011c2:	58                   	pop    %eax
  1011c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
  1011c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1011c9:	c9                   	leave  
  1011ca:	c3                   	ret    

001011cb <cpuid>:
#include "x86.h"
#include "proc.h"

// Must be called with interrupts disabled
int
cpuid() {
  1011cb:	55                   	push   %ebp
  1011cc:	89 e5                	mov    %esp,%ebp
  1011ce:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
  1011d1:	e8 07 00 00 00       	call   1011dd <mycpu>
  1011d6:	2d b8 54 10 00       	sub    $0x1054b8,%eax
}
  1011db:	c9                   	leave  
  1011dc:	c3                   	ret    

001011dd <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  1011dd:	55                   	push   %ebp
  1011de:	89 e5                	mov    %esp,%ebp
  1011e0:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
  1011e3:	e8 d3 ff ff ff       	call   1011bb <readeflags>
  1011e8:	25 00 02 00 00       	and    $0x200,%eax
  1011ed:	85 c0                	test   %eax,%eax
  1011ef:	74 0d                	je     1011fe <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
  1011f1:	83 ec 0c             	sub    $0xc,%esp
  1011f4:	68 dc 41 10 00       	push   $0x1041dc
  1011f9:	e8 af f0 ff ff       	call   1002ad <panic>
  
  apicid = lapicid();
  1011fe:	e8 ef f5 ff ff       	call   1007f2 <lapicid>
  101203:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
  101206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10120d:	eb 21                	jmp    101230 <mycpu+0x53>
    if (cpus[i].apicid == apicid)
  10120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101212:	05 b8 54 10 00       	add    $0x1054b8,%eax
  101217:	0f b6 00             	movzbl (%eax),%eax
  10121a:	0f b6 c0             	movzbl %al,%eax
  10121d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  101220:	75 0a                	jne    10122c <mycpu+0x4f>
      return &cpus[i];
  101222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101225:	05 b8 54 10 00       	add    $0x1054b8,%eax
  10122a:	eb 1b                	jmp    101247 <mycpu+0x6a>
  for (i = 0; i < ncpu; ++i) {
  10122c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101230:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  101235:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  101238:	7c d5                	jl     10120f <mycpu+0x32>
  }
  panic("unknown apicid\n");
  10123a:	83 ec 0c             	sub    $0xc,%esp
  10123d:	68 02 42 10 00       	push   $0x104202
  101242:	e8 66 f0 ff ff       	call   1002ad <panic>
  101247:	c9                   	leave  
  101248:	c3                   	ret    

00101249 <getcallerpcs>:
// #include "memlayout.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  101249:	55                   	push   %ebp
  10124a:	89 e5                	mov    %esp,%ebp
  10124c:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  10124f:	8b 45 08             	mov    0x8(%ebp),%eax
  101252:	83 e8 08             	sub    $0x8,%eax
  101255:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  101258:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10125f:	eb 2f                	jmp    101290 <getcallerpcs+0x47>
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  101261:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  101265:	74 4a                	je     1012b1 <getcallerpcs+0x68>
  101267:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
  10126b:	74 44                	je     1012b1 <getcallerpcs+0x68>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101277:	8b 45 0c             	mov    0xc(%ebp),%eax
  10127a:	01 c2                	add    %eax,%edx
  10127c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10127f:	8b 40 04             	mov    0x4(%eax),%eax
  101282:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
  101284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101287:	8b 00                	mov    (%eax),%eax
  101289:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  10128c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101290:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  101294:	7e cb                	jle    101261 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
  101296:	eb 19                	jmp    1012b1 <getcallerpcs+0x68>
    pcs[i] = 0;
  101298:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10129b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1012a5:	01 d0                	add    %edx,%eax
  1012a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  1012ad:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1012b1:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  1012b5:	7e e1                	jle    101298 <getcallerpcs+0x4f>
  1012b7:	90                   	nop
  1012b8:	90                   	nop
  1012b9:	c9                   	leave  
  1012ba:	c3                   	ret    

001012bb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushal
  1012bb:	60                   	pusha  
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  1012bc:	54                   	push   %esp
  call trap
  1012bd:	e8 41 01 00 00       	call   101403 <trap>
  addl $4, %esp
  1012c2:	83 c4 04             	add    $0x4,%esp

001012c5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  1012c5:	61                   	popa   
  addl $0x8, %esp  # trapno and errcode
  1012c6:	83 c4 08             	add    $0x8,%esp
  iret
  1012c9:	cf                   	iret   

001012ca <lidt>:
{
  1012ca:	55                   	push   %ebp
  1012cb:	89 e5                	mov    %esp,%ebp
  1012cd:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
  1012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1012d3:	83 e8 01             	sub    $0x1,%eax
  1012d6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  1012da:	8b 45 08             	mov    0x8(%ebp),%eax
  1012dd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e4:	c1 e8 10             	shr    $0x10,%eax
  1012e7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  1012eb:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1012ee:	0f 01 18             	lidtl  (%eax)
}
  1012f1:	90                   	nop
  1012f2:	c9                   	leave  
  1012f3:	c3                   	ret    

001012f4 <rcr2>:

static inline uint
rcr2(void)
{
  1012f4:	55                   	push   %ebp
  1012f5:	89 e5                	mov    %esp,%ebp
  1012f7:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  1012fa:	0f 20 d0             	mov    %cr2,%eax
  1012fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
  101300:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101303:	c9                   	leave  
  101304:	c3                   	ret    

00101305 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void
tvinit(void)
{
  101305:	55                   	push   %ebp
  101306:	89 e5                	mov    %esp,%ebp
  101308:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
  10130b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101312:	e9 c3 00 00 00       	jmp    1013da <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  101317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10131a:	8b 04 85 11 50 10 00 	mov    0x105011(,%eax,4),%eax
  101321:	89 c2                	mov    %eax,%edx
  101323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101326:	66 89 14 c5 e0 54 10 	mov    %dx,0x1054e0(,%eax,8)
  10132d:	00 
  10132e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101331:	66 c7 04 c5 e2 54 10 	movw   $0x8,0x1054e2(,%eax,8)
  101338:	00 08 00 
  10133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10133e:	0f b6 14 c5 e4 54 10 	movzbl 0x1054e4(,%eax,8),%edx
  101345:	00 
  101346:	83 e2 e0             	and    $0xffffffe0,%edx
  101349:	88 14 c5 e4 54 10 00 	mov    %dl,0x1054e4(,%eax,8)
  101350:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101353:	0f b6 14 c5 e4 54 10 	movzbl 0x1054e4(,%eax,8),%edx
  10135a:	00 
  10135b:	83 e2 1f             	and    $0x1f,%edx
  10135e:	88 14 c5 e4 54 10 00 	mov    %dl,0x1054e4(,%eax,8)
  101365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101368:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  10136f:	00 
  101370:	83 e2 f0             	and    $0xfffffff0,%edx
  101373:	83 ca 0e             	or     $0xe,%edx
  101376:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  10137d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101380:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  101387:	00 
  101388:	83 e2 ef             	and    $0xffffffef,%edx
  10138b:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  101392:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101395:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  10139c:	00 
  10139d:	83 e2 9f             	and    $0xffffff9f,%edx
  1013a0:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  1013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1013aa:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  1013b1:	00 
  1013b2:	83 ca 80             	or     $0xffffff80,%edx
  1013b5:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  1013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1013bf:	8b 04 85 11 50 10 00 	mov    0x105011(,%eax,4),%eax
  1013c6:	c1 e8 10             	shr    $0x10,%eax
  1013c9:	89 c2                	mov    %eax,%edx
  1013cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1013ce:	66 89 14 c5 e6 54 10 	mov    %dx,0x1054e6(,%eax,8)
  1013d5:	00 
  for(i = 0; i < 256; i++)
  1013d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1013da:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1013e1:	0f 8e 30 ff ff ff    	jle    101317 <tvinit+0x12>
}
  1013e7:	90                   	nop
  1013e8:	90                   	nop
  1013e9:	c9                   	leave  
  1013ea:	c3                   	ret    

001013eb <idtinit>:

void
idtinit(void)
{
  1013eb:	55                   	push   %ebp
  1013ec:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
  1013ee:	68 00 08 00 00       	push   $0x800
  1013f3:	68 e0 54 10 00       	push   $0x1054e0
  1013f8:	e8 cd fe ff ff       	call   1012ca <lidt>
  1013fd:	83 c4 08             	add    $0x8,%esp
}
  101400:	90                   	nop
  101401:	c9                   	leave  
  101402:	c3                   	ret    

00101403 <trap>:

void
trap(struct trapframe *tf)
{
  101403:	55                   	push   %ebp
  101404:	89 e5                	mov    %esp,%ebp
  101406:	56                   	push   %esi
  101407:	53                   	push   %ebx
  switch(tf->trapno){
  101408:	8b 45 08             	mov    0x8(%ebp),%eax
  10140b:	8b 40 20             	mov    0x20(%eax),%eax
  10140e:	83 e8 20             	sub    $0x20,%eax
  101411:	83 f8 1f             	cmp    $0x1f,%eax
  101414:	77 61                	ja     101477 <trap+0x74>
  101416:	8b 04 85 70 42 10 00 	mov    0x104270(,%eax,4),%eax
  10141d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    ticks++;
  10141f:	a1 e0 5c 10 00       	mov    0x105ce0,%eax
  101424:	83 c0 01             	add    $0x1,%eax
  101427:	a3 e0 5c 10 00       	mov    %eax,0x105ce0
    lapiceoi();
  10142c:	e8 e3 f3 ff ff       	call   100814 <lapiceoi>
    break;
  101431:	eb 7d                	jmp    1014b0 <trap+0xad>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  101433:	e8 c3 0f 00 00       	call   1023fb <ideintr>
    lapiceoi();
  101438:	e8 d7 f3 ff ff       	call   100814 <lapiceoi>
    break;
  10143d:	eb 71                	jmp    1014b0 <trap+0xad>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  10143f:	e8 9d fa ff ff       	call   100ee1 <uartintr>
    lapiceoi();
  101444:	e8 cb f3 ff ff       	call   100814 <lapiceoi>
    break;
  101449:	eb 65                	jmp    1014b0 <trap+0xad>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  10144b:	8b 45 08             	mov    0x8(%ebp),%eax
  10144e:	8b 70 28             	mov    0x28(%eax),%esi
            cpuid(), tf->cs, tf->eip);
  101451:	8b 45 08             	mov    0x8(%ebp),%eax
  101454:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  101458:	0f b7 d8             	movzwl %ax,%ebx
  10145b:	e8 6b fd ff ff       	call   1011cb <cpuid>
  101460:	56                   	push   %esi
  101461:	53                   	push   %ebx
  101462:	50                   	push   %eax
  101463:	68 14 42 10 00       	push   $0x104214
  101468:	e8 7f ec ff ff       	call   1000ec <cprintf>
  10146d:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
  101470:	e8 9f f3 ff ff       	call   100814 <lapiceoi>
    break;
  101475:	eb 39                	jmp    1014b0 <trap+0xad>

  default:
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  101477:	e8 78 fe ff ff       	call   1012f4 <rcr2>
  10147c:	89 c3                	mov    %eax,%ebx
  10147e:	8b 45 08             	mov    0x8(%ebp),%eax
  101481:	8b 70 28             	mov    0x28(%eax),%esi
  101484:	e8 42 fd ff ff       	call   1011cb <cpuid>
  101489:	8b 55 08             	mov    0x8(%ebp),%edx
  10148c:	8b 52 20             	mov    0x20(%edx),%edx
  10148f:	83 ec 0c             	sub    $0xc,%esp
  101492:	53                   	push   %ebx
  101493:	56                   	push   %esi
  101494:	50                   	push   %eax
  101495:	52                   	push   %edx
  101496:	68 38 42 10 00       	push   $0x104238
  10149b:	e8 4c ec ff ff       	call   1000ec <cprintf>
  1014a0:	83 c4 20             	add    $0x20,%esp
            tf->trapno, cpuid(), tf->eip, rcr2());
    panic("trap");
  1014a3:	83 ec 0c             	sub    $0xc,%esp
  1014a6:	68 6a 42 10 00       	push   $0x10426a
  1014ab:	e8 fd ed ff ff       	call   1002ad <panic>
  }
}
  1014b0:	90                   	nop
  1014b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1014b4:	5b                   	pop    %ebx
  1014b5:	5e                   	pop    %esi
  1014b6:	5d                   	pop    %ebp
  1014b7:	c3                   	ret    

001014b8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  1014b8:	6a 00                	push   $0x0
  pushl $0
  1014ba:	6a 00                	push   $0x0
  jmp alltraps
  1014bc:	e9 fa fd ff ff       	jmp    1012bb <alltraps>

001014c1 <vector1>:
.globl vector1
vector1:
  pushl $0
  1014c1:	6a 00                	push   $0x0
  pushl $1
  1014c3:	6a 01                	push   $0x1
  jmp alltraps
  1014c5:	e9 f1 fd ff ff       	jmp    1012bb <alltraps>

001014ca <vector2>:
.globl vector2
vector2:
  pushl $0
  1014ca:	6a 00                	push   $0x0
  pushl $2
  1014cc:	6a 02                	push   $0x2
  jmp alltraps
  1014ce:	e9 e8 fd ff ff       	jmp    1012bb <alltraps>

001014d3 <vector3>:
.globl vector3
vector3:
  pushl $0
  1014d3:	6a 00                	push   $0x0
  pushl $3
  1014d5:	6a 03                	push   $0x3
  jmp alltraps
  1014d7:	e9 df fd ff ff       	jmp    1012bb <alltraps>

001014dc <vector4>:
.globl vector4
vector4:
  pushl $0
  1014dc:	6a 00                	push   $0x0
  pushl $4
  1014de:	6a 04                	push   $0x4
  jmp alltraps
  1014e0:	e9 d6 fd ff ff       	jmp    1012bb <alltraps>

001014e5 <vector5>:
.globl vector5
vector5:
  pushl $0
  1014e5:	6a 00                	push   $0x0
  pushl $5
  1014e7:	6a 05                	push   $0x5
  jmp alltraps
  1014e9:	e9 cd fd ff ff       	jmp    1012bb <alltraps>

001014ee <vector6>:
.globl vector6
vector6:
  pushl $0
  1014ee:	6a 00                	push   $0x0
  pushl $6
  1014f0:	6a 06                	push   $0x6
  jmp alltraps
  1014f2:	e9 c4 fd ff ff       	jmp    1012bb <alltraps>

001014f7 <vector7>:
.globl vector7
vector7:
  pushl $0
  1014f7:	6a 00                	push   $0x0
  pushl $7
  1014f9:	6a 07                	push   $0x7
  jmp alltraps
  1014fb:	e9 bb fd ff ff       	jmp    1012bb <alltraps>

00101500 <vector8>:
.globl vector8
vector8:
  pushl $8
  101500:	6a 08                	push   $0x8
  jmp alltraps
  101502:	e9 b4 fd ff ff       	jmp    1012bb <alltraps>

00101507 <vector9>:
.globl vector9
vector9:
  pushl $0
  101507:	6a 00                	push   $0x0
  pushl $9
  101509:	6a 09                	push   $0x9
  jmp alltraps
  10150b:	e9 ab fd ff ff       	jmp    1012bb <alltraps>

00101510 <vector10>:
.globl vector10
vector10:
  pushl $10
  101510:	6a 0a                	push   $0xa
  jmp alltraps
  101512:	e9 a4 fd ff ff       	jmp    1012bb <alltraps>

00101517 <vector11>:
.globl vector11
vector11:
  pushl $11
  101517:	6a 0b                	push   $0xb
  jmp alltraps
  101519:	e9 9d fd ff ff       	jmp    1012bb <alltraps>

0010151e <vector12>:
.globl vector12
vector12:
  pushl $12
  10151e:	6a 0c                	push   $0xc
  jmp alltraps
  101520:	e9 96 fd ff ff       	jmp    1012bb <alltraps>

00101525 <vector13>:
.globl vector13
vector13:
  pushl $13
  101525:	6a 0d                	push   $0xd
  jmp alltraps
  101527:	e9 8f fd ff ff       	jmp    1012bb <alltraps>

0010152c <vector14>:
.globl vector14
vector14:
  pushl $14
  10152c:	6a 0e                	push   $0xe
  jmp alltraps
  10152e:	e9 88 fd ff ff       	jmp    1012bb <alltraps>

00101533 <vector15>:
.globl vector15
vector15:
  pushl $0
  101533:	6a 00                	push   $0x0
  pushl $15
  101535:	6a 0f                	push   $0xf
  jmp alltraps
  101537:	e9 7f fd ff ff       	jmp    1012bb <alltraps>

0010153c <vector16>:
.globl vector16
vector16:
  pushl $0
  10153c:	6a 00                	push   $0x0
  pushl $16
  10153e:	6a 10                	push   $0x10
  jmp alltraps
  101540:	e9 76 fd ff ff       	jmp    1012bb <alltraps>

00101545 <vector17>:
.globl vector17
vector17:
  pushl $17
  101545:	6a 11                	push   $0x11
  jmp alltraps
  101547:	e9 6f fd ff ff       	jmp    1012bb <alltraps>

0010154c <vector18>:
.globl vector18
vector18:
  pushl $0
  10154c:	6a 00                	push   $0x0
  pushl $18
  10154e:	6a 12                	push   $0x12
  jmp alltraps
  101550:	e9 66 fd ff ff       	jmp    1012bb <alltraps>

00101555 <vector19>:
.globl vector19
vector19:
  pushl $0
  101555:	6a 00                	push   $0x0
  pushl $19
  101557:	6a 13                	push   $0x13
  jmp alltraps
  101559:	e9 5d fd ff ff       	jmp    1012bb <alltraps>

0010155e <vector20>:
.globl vector20
vector20:
  pushl $0
  10155e:	6a 00                	push   $0x0
  pushl $20
  101560:	6a 14                	push   $0x14
  jmp alltraps
  101562:	e9 54 fd ff ff       	jmp    1012bb <alltraps>

00101567 <vector21>:
.globl vector21
vector21:
  pushl $0
  101567:	6a 00                	push   $0x0
  pushl $21
  101569:	6a 15                	push   $0x15
  jmp alltraps
  10156b:	e9 4b fd ff ff       	jmp    1012bb <alltraps>

00101570 <vector22>:
.globl vector22
vector22:
  pushl $0
  101570:	6a 00                	push   $0x0
  pushl $22
  101572:	6a 16                	push   $0x16
  jmp alltraps
  101574:	e9 42 fd ff ff       	jmp    1012bb <alltraps>

00101579 <vector23>:
.globl vector23
vector23:
  pushl $0
  101579:	6a 00                	push   $0x0
  pushl $23
  10157b:	6a 17                	push   $0x17
  jmp alltraps
  10157d:	e9 39 fd ff ff       	jmp    1012bb <alltraps>

00101582 <vector24>:
.globl vector24
vector24:
  pushl $0
  101582:	6a 00                	push   $0x0
  pushl $24
  101584:	6a 18                	push   $0x18
  jmp alltraps
  101586:	e9 30 fd ff ff       	jmp    1012bb <alltraps>

0010158b <vector25>:
.globl vector25
vector25:
  pushl $0
  10158b:	6a 00                	push   $0x0
  pushl $25
  10158d:	6a 19                	push   $0x19
  jmp alltraps
  10158f:	e9 27 fd ff ff       	jmp    1012bb <alltraps>

00101594 <vector26>:
.globl vector26
vector26:
  pushl $0
  101594:	6a 00                	push   $0x0
  pushl $26
  101596:	6a 1a                	push   $0x1a
  jmp alltraps
  101598:	e9 1e fd ff ff       	jmp    1012bb <alltraps>

0010159d <vector27>:
.globl vector27
vector27:
  pushl $0
  10159d:	6a 00                	push   $0x0
  pushl $27
  10159f:	6a 1b                	push   $0x1b
  jmp alltraps
  1015a1:	e9 15 fd ff ff       	jmp    1012bb <alltraps>

001015a6 <vector28>:
.globl vector28
vector28:
  pushl $0
  1015a6:	6a 00                	push   $0x0
  pushl $28
  1015a8:	6a 1c                	push   $0x1c
  jmp alltraps
  1015aa:	e9 0c fd ff ff       	jmp    1012bb <alltraps>

001015af <vector29>:
.globl vector29
vector29:
  pushl $0
  1015af:	6a 00                	push   $0x0
  pushl $29
  1015b1:	6a 1d                	push   $0x1d
  jmp alltraps
  1015b3:	e9 03 fd ff ff       	jmp    1012bb <alltraps>

001015b8 <vector30>:
.globl vector30
vector30:
  pushl $0
  1015b8:	6a 00                	push   $0x0
  pushl $30
  1015ba:	6a 1e                	push   $0x1e
  jmp alltraps
  1015bc:	e9 fa fc ff ff       	jmp    1012bb <alltraps>

001015c1 <vector31>:
.globl vector31
vector31:
  pushl $0
  1015c1:	6a 00                	push   $0x0
  pushl $31
  1015c3:	6a 1f                	push   $0x1f
  jmp alltraps
  1015c5:	e9 f1 fc ff ff       	jmp    1012bb <alltraps>

001015ca <vector32>:
.globl vector32
vector32:
  pushl $0
  1015ca:	6a 00                	push   $0x0
  pushl $32
  1015cc:	6a 20                	push   $0x20
  jmp alltraps
  1015ce:	e9 e8 fc ff ff       	jmp    1012bb <alltraps>

001015d3 <vector33>:
.globl vector33
vector33:
  pushl $0
  1015d3:	6a 00                	push   $0x0
  pushl $33
  1015d5:	6a 21                	push   $0x21
  jmp alltraps
  1015d7:	e9 df fc ff ff       	jmp    1012bb <alltraps>

001015dc <vector34>:
.globl vector34
vector34:
  pushl $0
  1015dc:	6a 00                	push   $0x0
  pushl $34
  1015de:	6a 22                	push   $0x22
  jmp alltraps
  1015e0:	e9 d6 fc ff ff       	jmp    1012bb <alltraps>

001015e5 <vector35>:
.globl vector35
vector35:
  pushl $0
  1015e5:	6a 00                	push   $0x0
  pushl $35
  1015e7:	6a 23                	push   $0x23
  jmp alltraps
  1015e9:	e9 cd fc ff ff       	jmp    1012bb <alltraps>

001015ee <vector36>:
.globl vector36
vector36:
  pushl $0
  1015ee:	6a 00                	push   $0x0
  pushl $36
  1015f0:	6a 24                	push   $0x24
  jmp alltraps
  1015f2:	e9 c4 fc ff ff       	jmp    1012bb <alltraps>

001015f7 <vector37>:
.globl vector37
vector37:
  pushl $0
  1015f7:	6a 00                	push   $0x0
  pushl $37
  1015f9:	6a 25                	push   $0x25
  jmp alltraps
  1015fb:	e9 bb fc ff ff       	jmp    1012bb <alltraps>

00101600 <vector38>:
.globl vector38
vector38:
  pushl $0
  101600:	6a 00                	push   $0x0
  pushl $38
  101602:	6a 26                	push   $0x26
  jmp alltraps
  101604:	e9 b2 fc ff ff       	jmp    1012bb <alltraps>

00101609 <vector39>:
.globl vector39
vector39:
  pushl $0
  101609:	6a 00                	push   $0x0
  pushl $39
  10160b:	6a 27                	push   $0x27
  jmp alltraps
  10160d:	e9 a9 fc ff ff       	jmp    1012bb <alltraps>

00101612 <vector40>:
.globl vector40
vector40:
  pushl $0
  101612:	6a 00                	push   $0x0
  pushl $40
  101614:	6a 28                	push   $0x28
  jmp alltraps
  101616:	e9 a0 fc ff ff       	jmp    1012bb <alltraps>

0010161b <vector41>:
.globl vector41
vector41:
  pushl $0
  10161b:	6a 00                	push   $0x0
  pushl $41
  10161d:	6a 29                	push   $0x29
  jmp alltraps
  10161f:	e9 97 fc ff ff       	jmp    1012bb <alltraps>

00101624 <vector42>:
.globl vector42
vector42:
  pushl $0
  101624:	6a 00                	push   $0x0
  pushl $42
  101626:	6a 2a                	push   $0x2a
  jmp alltraps
  101628:	e9 8e fc ff ff       	jmp    1012bb <alltraps>

0010162d <vector43>:
.globl vector43
vector43:
  pushl $0
  10162d:	6a 00                	push   $0x0
  pushl $43
  10162f:	6a 2b                	push   $0x2b
  jmp alltraps
  101631:	e9 85 fc ff ff       	jmp    1012bb <alltraps>

00101636 <vector44>:
.globl vector44
vector44:
  pushl $0
  101636:	6a 00                	push   $0x0
  pushl $44
  101638:	6a 2c                	push   $0x2c
  jmp alltraps
  10163a:	e9 7c fc ff ff       	jmp    1012bb <alltraps>

0010163f <vector45>:
.globl vector45
vector45:
  pushl $0
  10163f:	6a 00                	push   $0x0
  pushl $45
  101641:	6a 2d                	push   $0x2d
  jmp alltraps
  101643:	e9 73 fc ff ff       	jmp    1012bb <alltraps>

00101648 <vector46>:
.globl vector46
vector46:
  pushl $0
  101648:	6a 00                	push   $0x0
  pushl $46
  10164a:	6a 2e                	push   $0x2e
  jmp alltraps
  10164c:	e9 6a fc ff ff       	jmp    1012bb <alltraps>

00101651 <vector47>:
.globl vector47
vector47:
  pushl $0
  101651:	6a 00                	push   $0x0
  pushl $47
  101653:	6a 2f                	push   $0x2f
  jmp alltraps
  101655:	e9 61 fc ff ff       	jmp    1012bb <alltraps>

0010165a <vector48>:
.globl vector48
vector48:
  pushl $0
  10165a:	6a 00                	push   $0x0
  pushl $48
  10165c:	6a 30                	push   $0x30
  jmp alltraps
  10165e:	e9 58 fc ff ff       	jmp    1012bb <alltraps>

00101663 <vector49>:
.globl vector49
vector49:
  pushl $0
  101663:	6a 00                	push   $0x0
  pushl $49
  101665:	6a 31                	push   $0x31
  jmp alltraps
  101667:	e9 4f fc ff ff       	jmp    1012bb <alltraps>

0010166c <vector50>:
.globl vector50
vector50:
  pushl $0
  10166c:	6a 00                	push   $0x0
  pushl $50
  10166e:	6a 32                	push   $0x32
  jmp alltraps
  101670:	e9 46 fc ff ff       	jmp    1012bb <alltraps>

00101675 <vector51>:
.globl vector51
vector51:
  pushl $0
  101675:	6a 00                	push   $0x0
  pushl $51
  101677:	6a 33                	push   $0x33
  jmp alltraps
  101679:	e9 3d fc ff ff       	jmp    1012bb <alltraps>

0010167e <vector52>:
.globl vector52
vector52:
  pushl $0
  10167e:	6a 00                	push   $0x0
  pushl $52
  101680:	6a 34                	push   $0x34
  jmp alltraps
  101682:	e9 34 fc ff ff       	jmp    1012bb <alltraps>

00101687 <vector53>:
.globl vector53
vector53:
  pushl $0
  101687:	6a 00                	push   $0x0
  pushl $53
  101689:	6a 35                	push   $0x35
  jmp alltraps
  10168b:	e9 2b fc ff ff       	jmp    1012bb <alltraps>

00101690 <vector54>:
.globl vector54
vector54:
  pushl $0
  101690:	6a 00                	push   $0x0
  pushl $54
  101692:	6a 36                	push   $0x36
  jmp alltraps
  101694:	e9 22 fc ff ff       	jmp    1012bb <alltraps>

00101699 <vector55>:
.globl vector55
vector55:
  pushl $0
  101699:	6a 00                	push   $0x0
  pushl $55
  10169b:	6a 37                	push   $0x37
  jmp alltraps
  10169d:	e9 19 fc ff ff       	jmp    1012bb <alltraps>

001016a2 <vector56>:
.globl vector56
vector56:
  pushl $0
  1016a2:	6a 00                	push   $0x0
  pushl $56
  1016a4:	6a 38                	push   $0x38
  jmp alltraps
  1016a6:	e9 10 fc ff ff       	jmp    1012bb <alltraps>

001016ab <vector57>:
.globl vector57
vector57:
  pushl $0
  1016ab:	6a 00                	push   $0x0
  pushl $57
  1016ad:	6a 39                	push   $0x39
  jmp alltraps
  1016af:	e9 07 fc ff ff       	jmp    1012bb <alltraps>

001016b4 <vector58>:
.globl vector58
vector58:
  pushl $0
  1016b4:	6a 00                	push   $0x0
  pushl $58
  1016b6:	6a 3a                	push   $0x3a
  jmp alltraps
  1016b8:	e9 fe fb ff ff       	jmp    1012bb <alltraps>

001016bd <vector59>:
.globl vector59
vector59:
  pushl $0
  1016bd:	6a 00                	push   $0x0
  pushl $59
  1016bf:	6a 3b                	push   $0x3b
  jmp alltraps
  1016c1:	e9 f5 fb ff ff       	jmp    1012bb <alltraps>

001016c6 <vector60>:
.globl vector60
vector60:
  pushl $0
  1016c6:	6a 00                	push   $0x0
  pushl $60
  1016c8:	6a 3c                	push   $0x3c
  jmp alltraps
  1016ca:	e9 ec fb ff ff       	jmp    1012bb <alltraps>

001016cf <vector61>:
.globl vector61
vector61:
  pushl $0
  1016cf:	6a 00                	push   $0x0
  pushl $61
  1016d1:	6a 3d                	push   $0x3d
  jmp alltraps
  1016d3:	e9 e3 fb ff ff       	jmp    1012bb <alltraps>

001016d8 <vector62>:
.globl vector62
vector62:
  pushl $0
  1016d8:	6a 00                	push   $0x0
  pushl $62
  1016da:	6a 3e                	push   $0x3e
  jmp alltraps
  1016dc:	e9 da fb ff ff       	jmp    1012bb <alltraps>

001016e1 <vector63>:
.globl vector63
vector63:
  pushl $0
  1016e1:	6a 00                	push   $0x0
  pushl $63
  1016e3:	6a 3f                	push   $0x3f
  jmp alltraps
  1016e5:	e9 d1 fb ff ff       	jmp    1012bb <alltraps>

001016ea <vector64>:
.globl vector64
vector64:
  pushl $0
  1016ea:	6a 00                	push   $0x0
  pushl $64
  1016ec:	6a 40                	push   $0x40
  jmp alltraps
  1016ee:	e9 c8 fb ff ff       	jmp    1012bb <alltraps>

001016f3 <vector65>:
.globl vector65
vector65:
  pushl $0
  1016f3:	6a 00                	push   $0x0
  pushl $65
  1016f5:	6a 41                	push   $0x41
  jmp alltraps
  1016f7:	e9 bf fb ff ff       	jmp    1012bb <alltraps>

001016fc <vector66>:
.globl vector66
vector66:
  pushl $0
  1016fc:	6a 00                	push   $0x0
  pushl $66
  1016fe:	6a 42                	push   $0x42
  jmp alltraps
  101700:	e9 b6 fb ff ff       	jmp    1012bb <alltraps>

00101705 <vector67>:
.globl vector67
vector67:
  pushl $0
  101705:	6a 00                	push   $0x0
  pushl $67
  101707:	6a 43                	push   $0x43
  jmp alltraps
  101709:	e9 ad fb ff ff       	jmp    1012bb <alltraps>

0010170e <vector68>:
.globl vector68
vector68:
  pushl $0
  10170e:	6a 00                	push   $0x0
  pushl $68
  101710:	6a 44                	push   $0x44
  jmp alltraps
  101712:	e9 a4 fb ff ff       	jmp    1012bb <alltraps>

00101717 <vector69>:
.globl vector69
vector69:
  pushl $0
  101717:	6a 00                	push   $0x0
  pushl $69
  101719:	6a 45                	push   $0x45
  jmp alltraps
  10171b:	e9 9b fb ff ff       	jmp    1012bb <alltraps>

00101720 <vector70>:
.globl vector70
vector70:
  pushl $0
  101720:	6a 00                	push   $0x0
  pushl $70
  101722:	6a 46                	push   $0x46
  jmp alltraps
  101724:	e9 92 fb ff ff       	jmp    1012bb <alltraps>

00101729 <vector71>:
.globl vector71
vector71:
  pushl $0
  101729:	6a 00                	push   $0x0
  pushl $71
  10172b:	6a 47                	push   $0x47
  jmp alltraps
  10172d:	e9 89 fb ff ff       	jmp    1012bb <alltraps>

00101732 <vector72>:
.globl vector72
vector72:
  pushl $0
  101732:	6a 00                	push   $0x0
  pushl $72
  101734:	6a 48                	push   $0x48
  jmp alltraps
  101736:	e9 80 fb ff ff       	jmp    1012bb <alltraps>

0010173b <vector73>:
.globl vector73
vector73:
  pushl $0
  10173b:	6a 00                	push   $0x0
  pushl $73
  10173d:	6a 49                	push   $0x49
  jmp alltraps
  10173f:	e9 77 fb ff ff       	jmp    1012bb <alltraps>

00101744 <vector74>:
.globl vector74
vector74:
  pushl $0
  101744:	6a 00                	push   $0x0
  pushl $74
  101746:	6a 4a                	push   $0x4a
  jmp alltraps
  101748:	e9 6e fb ff ff       	jmp    1012bb <alltraps>

0010174d <vector75>:
.globl vector75
vector75:
  pushl $0
  10174d:	6a 00                	push   $0x0
  pushl $75
  10174f:	6a 4b                	push   $0x4b
  jmp alltraps
  101751:	e9 65 fb ff ff       	jmp    1012bb <alltraps>

00101756 <vector76>:
.globl vector76
vector76:
  pushl $0
  101756:	6a 00                	push   $0x0
  pushl $76
  101758:	6a 4c                	push   $0x4c
  jmp alltraps
  10175a:	e9 5c fb ff ff       	jmp    1012bb <alltraps>

0010175f <vector77>:
.globl vector77
vector77:
  pushl $0
  10175f:	6a 00                	push   $0x0
  pushl $77
  101761:	6a 4d                	push   $0x4d
  jmp alltraps
  101763:	e9 53 fb ff ff       	jmp    1012bb <alltraps>

00101768 <vector78>:
.globl vector78
vector78:
  pushl $0
  101768:	6a 00                	push   $0x0
  pushl $78
  10176a:	6a 4e                	push   $0x4e
  jmp alltraps
  10176c:	e9 4a fb ff ff       	jmp    1012bb <alltraps>

00101771 <vector79>:
.globl vector79
vector79:
  pushl $0
  101771:	6a 00                	push   $0x0
  pushl $79
  101773:	6a 4f                	push   $0x4f
  jmp alltraps
  101775:	e9 41 fb ff ff       	jmp    1012bb <alltraps>

0010177a <vector80>:
.globl vector80
vector80:
  pushl $0
  10177a:	6a 00                	push   $0x0
  pushl $80
  10177c:	6a 50                	push   $0x50
  jmp alltraps
  10177e:	e9 38 fb ff ff       	jmp    1012bb <alltraps>

00101783 <vector81>:
.globl vector81
vector81:
  pushl $0
  101783:	6a 00                	push   $0x0
  pushl $81
  101785:	6a 51                	push   $0x51
  jmp alltraps
  101787:	e9 2f fb ff ff       	jmp    1012bb <alltraps>

0010178c <vector82>:
.globl vector82
vector82:
  pushl $0
  10178c:	6a 00                	push   $0x0
  pushl $82
  10178e:	6a 52                	push   $0x52
  jmp alltraps
  101790:	e9 26 fb ff ff       	jmp    1012bb <alltraps>

00101795 <vector83>:
.globl vector83
vector83:
  pushl $0
  101795:	6a 00                	push   $0x0
  pushl $83
  101797:	6a 53                	push   $0x53
  jmp alltraps
  101799:	e9 1d fb ff ff       	jmp    1012bb <alltraps>

0010179e <vector84>:
.globl vector84
vector84:
  pushl $0
  10179e:	6a 00                	push   $0x0
  pushl $84
  1017a0:	6a 54                	push   $0x54
  jmp alltraps
  1017a2:	e9 14 fb ff ff       	jmp    1012bb <alltraps>

001017a7 <vector85>:
.globl vector85
vector85:
  pushl $0
  1017a7:	6a 00                	push   $0x0
  pushl $85
  1017a9:	6a 55                	push   $0x55
  jmp alltraps
  1017ab:	e9 0b fb ff ff       	jmp    1012bb <alltraps>

001017b0 <vector86>:
.globl vector86
vector86:
  pushl $0
  1017b0:	6a 00                	push   $0x0
  pushl $86
  1017b2:	6a 56                	push   $0x56
  jmp alltraps
  1017b4:	e9 02 fb ff ff       	jmp    1012bb <alltraps>

001017b9 <vector87>:
.globl vector87
vector87:
  pushl $0
  1017b9:	6a 00                	push   $0x0
  pushl $87
  1017bb:	6a 57                	push   $0x57
  jmp alltraps
  1017bd:	e9 f9 fa ff ff       	jmp    1012bb <alltraps>

001017c2 <vector88>:
.globl vector88
vector88:
  pushl $0
  1017c2:	6a 00                	push   $0x0
  pushl $88
  1017c4:	6a 58                	push   $0x58
  jmp alltraps
  1017c6:	e9 f0 fa ff ff       	jmp    1012bb <alltraps>

001017cb <vector89>:
.globl vector89
vector89:
  pushl $0
  1017cb:	6a 00                	push   $0x0
  pushl $89
  1017cd:	6a 59                	push   $0x59
  jmp alltraps
  1017cf:	e9 e7 fa ff ff       	jmp    1012bb <alltraps>

001017d4 <vector90>:
.globl vector90
vector90:
  pushl $0
  1017d4:	6a 00                	push   $0x0
  pushl $90
  1017d6:	6a 5a                	push   $0x5a
  jmp alltraps
  1017d8:	e9 de fa ff ff       	jmp    1012bb <alltraps>

001017dd <vector91>:
.globl vector91
vector91:
  pushl $0
  1017dd:	6a 00                	push   $0x0
  pushl $91
  1017df:	6a 5b                	push   $0x5b
  jmp alltraps
  1017e1:	e9 d5 fa ff ff       	jmp    1012bb <alltraps>

001017e6 <vector92>:
.globl vector92
vector92:
  pushl $0
  1017e6:	6a 00                	push   $0x0
  pushl $92
  1017e8:	6a 5c                	push   $0x5c
  jmp alltraps
  1017ea:	e9 cc fa ff ff       	jmp    1012bb <alltraps>

001017ef <vector93>:
.globl vector93
vector93:
  pushl $0
  1017ef:	6a 00                	push   $0x0
  pushl $93
  1017f1:	6a 5d                	push   $0x5d
  jmp alltraps
  1017f3:	e9 c3 fa ff ff       	jmp    1012bb <alltraps>

001017f8 <vector94>:
.globl vector94
vector94:
  pushl $0
  1017f8:	6a 00                	push   $0x0
  pushl $94
  1017fa:	6a 5e                	push   $0x5e
  jmp alltraps
  1017fc:	e9 ba fa ff ff       	jmp    1012bb <alltraps>

00101801 <vector95>:
.globl vector95
vector95:
  pushl $0
  101801:	6a 00                	push   $0x0
  pushl $95
  101803:	6a 5f                	push   $0x5f
  jmp alltraps
  101805:	e9 b1 fa ff ff       	jmp    1012bb <alltraps>

0010180a <vector96>:
.globl vector96
vector96:
  pushl $0
  10180a:	6a 00                	push   $0x0
  pushl $96
  10180c:	6a 60                	push   $0x60
  jmp alltraps
  10180e:	e9 a8 fa ff ff       	jmp    1012bb <alltraps>

00101813 <vector97>:
.globl vector97
vector97:
  pushl $0
  101813:	6a 00                	push   $0x0
  pushl $97
  101815:	6a 61                	push   $0x61
  jmp alltraps
  101817:	e9 9f fa ff ff       	jmp    1012bb <alltraps>

0010181c <vector98>:
.globl vector98
vector98:
  pushl $0
  10181c:	6a 00                	push   $0x0
  pushl $98
  10181e:	6a 62                	push   $0x62
  jmp alltraps
  101820:	e9 96 fa ff ff       	jmp    1012bb <alltraps>

00101825 <vector99>:
.globl vector99
vector99:
  pushl $0
  101825:	6a 00                	push   $0x0
  pushl $99
  101827:	6a 63                	push   $0x63
  jmp alltraps
  101829:	e9 8d fa ff ff       	jmp    1012bb <alltraps>

0010182e <vector100>:
.globl vector100
vector100:
  pushl $0
  10182e:	6a 00                	push   $0x0
  pushl $100
  101830:	6a 64                	push   $0x64
  jmp alltraps
  101832:	e9 84 fa ff ff       	jmp    1012bb <alltraps>

00101837 <vector101>:
.globl vector101
vector101:
  pushl $0
  101837:	6a 00                	push   $0x0
  pushl $101
  101839:	6a 65                	push   $0x65
  jmp alltraps
  10183b:	e9 7b fa ff ff       	jmp    1012bb <alltraps>

00101840 <vector102>:
.globl vector102
vector102:
  pushl $0
  101840:	6a 00                	push   $0x0
  pushl $102
  101842:	6a 66                	push   $0x66
  jmp alltraps
  101844:	e9 72 fa ff ff       	jmp    1012bb <alltraps>

00101849 <vector103>:
.globl vector103
vector103:
  pushl $0
  101849:	6a 00                	push   $0x0
  pushl $103
  10184b:	6a 67                	push   $0x67
  jmp alltraps
  10184d:	e9 69 fa ff ff       	jmp    1012bb <alltraps>

00101852 <vector104>:
.globl vector104
vector104:
  pushl $0
  101852:	6a 00                	push   $0x0
  pushl $104
  101854:	6a 68                	push   $0x68
  jmp alltraps
  101856:	e9 60 fa ff ff       	jmp    1012bb <alltraps>

0010185b <vector105>:
.globl vector105
vector105:
  pushl $0
  10185b:	6a 00                	push   $0x0
  pushl $105
  10185d:	6a 69                	push   $0x69
  jmp alltraps
  10185f:	e9 57 fa ff ff       	jmp    1012bb <alltraps>

00101864 <vector106>:
.globl vector106
vector106:
  pushl $0
  101864:	6a 00                	push   $0x0
  pushl $106
  101866:	6a 6a                	push   $0x6a
  jmp alltraps
  101868:	e9 4e fa ff ff       	jmp    1012bb <alltraps>

0010186d <vector107>:
.globl vector107
vector107:
  pushl $0
  10186d:	6a 00                	push   $0x0
  pushl $107
  10186f:	6a 6b                	push   $0x6b
  jmp alltraps
  101871:	e9 45 fa ff ff       	jmp    1012bb <alltraps>

00101876 <vector108>:
.globl vector108
vector108:
  pushl $0
  101876:	6a 00                	push   $0x0
  pushl $108
  101878:	6a 6c                	push   $0x6c
  jmp alltraps
  10187a:	e9 3c fa ff ff       	jmp    1012bb <alltraps>

0010187f <vector109>:
.globl vector109
vector109:
  pushl $0
  10187f:	6a 00                	push   $0x0
  pushl $109
  101881:	6a 6d                	push   $0x6d
  jmp alltraps
  101883:	e9 33 fa ff ff       	jmp    1012bb <alltraps>

00101888 <vector110>:
.globl vector110
vector110:
  pushl $0
  101888:	6a 00                	push   $0x0
  pushl $110
  10188a:	6a 6e                	push   $0x6e
  jmp alltraps
  10188c:	e9 2a fa ff ff       	jmp    1012bb <alltraps>

00101891 <vector111>:
.globl vector111
vector111:
  pushl $0
  101891:	6a 00                	push   $0x0
  pushl $111
  101893:	6a 6f                	push   $0x6f
  jmp alltraps
  101895:	e9 21 fa ff ff       	jmp    1012bb <alltraps>

0010189a <vector112>:
.globl vector112
vector112:
  pushl $0
  10189a:	6a 00                	push   $0x0
  pushl $112
  10189c:	6a 70                	push   $0x70
  jmp alltraps
  10189e:	e9 18 fa ff ff       	jmp    1012bb <alltraps>

001018a3 <vector113>:
.globl vector113
vector113:
  pushl $0
  1018a3:	6a 00                	push   $0x0
  pushl $113
  1018a5:	6a 71                	push   $0x71
  jmp alltraps
  1018a7:	e9 0f fa ff ff       	jmp    1012bb <alltraps>

001018ac <vector114>:
.globl vector114
vector114:
  pushl $0
  1018ac:	6a 00                	push   $0x0
  pushl $114
  1018ae:	6a 72                	push   $0x72
  jmp alltraps
  1018b0:	e9 06 fa ff ff       	jmp    1012bb <alltraps>

001018b5 <vector115>:
.globl vector115
vector115:
  pushl $0
  1018b5:	6a 00                	push   $0x0
  pushl $115
  1018b7:	6a 73                	push   $0x73
  jmp alltraps
  1018b9:	e9 fd f9 ff ff       	jmp    1012bb <alltraps>

001018be <vector116>:
.globl vector116
vector116:
  pushl $0
  1018be:	6a 00                	push   $0x0
  pushl $116
  1018c0:	6a 74                	push   $0x74
  jmp alltraps
  1018c2:	e9 f4 f9 ff ff       	jmp    1012bb <alltraps>

001018c7 <vector117>:
.globl vector117
vector117:
  pushl $0
  1018c7:	6a 00                	push   $0x0
  pushl $117
  1018c9:	6a 75                	push   $0x75
  jmp alltraps
  1018cb:	e9 eb f9 ff ff       	jmp    1012bb <alltraps>

001018d0 <vector118>:
.globl vector118
vector118:
  pushl $0
  1018d0:	6a 00                	push   $0x0
  pushl $118
  1018d2:	6a 76                	push   $0x76
  jmp alltraps
  1018d4:	e9 e2 f9 ff ff       	jmp    1012bb <alltraps>

001018d9 <vector119>:
.globl vector119
vector119:
  pushl $0
  1018d9:	6a 00                	push   $0x0
  pushl $119
  1018db:	6a 77                	push   $0x77
  jmp alltraps
  1018dd:	e9 d9 f9 ff ff       	jmp    1012bb <alltraps>

001018e2 <vector120>:
.globl vector120
vector120:
  pushl $0
  1018e2:	6a 00                	push   $0x0
  pushl $120
  1018e4:	6a 78                	push   $0x78
  jmp alltraps
  1018e6:	e9 d0 f9 ff ff       	jmp    1012bb <alltraps>

001018eb <vector121>:
.globl vector121
vector121:
  pushl $0
  1018eb:	6a 00                	push   $0x0
  pushl $121
  1018ed:	6a 79                	push   $0x79
  jmp alltraps
  1018ef:	e9 c7 f9 ff ff       	jmp    1012bb <alltraps>

001018f4 <vector122>:
.globl vector122
vector122:
  pushl $0
  1018f4:	6a 00                	push   $0x0
  pushl $122
  1018f6:	6a 7a                	push   $0x7a
  jmp alltraps
  1018f8:	e9 be f9 ff ff       	jmp    1012bb <alltraps>

001018fd <vector123>:
.globl vector123
vector123:
  pushl $0
  1018fd:	6a 00                	push   $0x0
  pushl $123
  1018ff:	6a 7b                	push   $0x7b
  jmp alltraps
  101901:	e9 b5 f9 ff ff       	jmp    1012bb <alltraps>

00101906 <vector124>:
.globl vector124
vector124:
  pushl $0
  101906:	6a 00                	push   $0x0
  pushl $124
  101908:	6a 7c                	push   $0x7c
  jmp alltraps
  10190a:	e9 ac f9 ff ff       	jmp    1012bb <alltraps>

0010190f <vector125>:
.globl vector125
vector125:
  pushl $0
  10190f:	6a 00                	push   $0x0
  pushl $125
  101911:	6a 7d                	push   $0x7d
  jmp alltraps
  101913:	e9 a3 f9 ff ff       	jmp    1012bb <alltraps>

00101918 <vector126>:
.globl vector126
vector126:
  pushl $0
  101918:	6a 00                	push   $0x0
  pushl $126
  10191a:	6a 7e                	push   $0x7e
  jmp alltraps
  10191c:	e9 9a f9 ff ff       	jmp    1012bb <alltraps>

00101921 <vector127>:
.globl vector127
vector127:
  pushl $0
  101921:	6a 00                	push   $0x0
  pushl $127
  101923:	6a 7f                	push   $0x7f
  jmp alltraps
  101925:	e9 91 f9 ff ff       	jmp    1012bb <alltraps>

0010192a <vector128>:
.globl vector128
vector128:
  pushl $0
  10192a:	6a 00                	push   $0x0
  pushl $128
  10192c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101931:	e9 85 f9 ff ff       	jmp    1012bb <alltraps>

00101936 <vector129>:
.globl vector129
vector129:
  pushl $0
  101936:	6a 00                	push   $0x0
  pushl $129
  101938:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  10193d:	e9 79 f9 ff ff       	jmp    1012bb <alltraps>

00101942 <vector130>:
.globl vector130
vector130:
  pushl $0
  101942:	6a 00                	push   $0x0
  pushl $130
  101944:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  101949:	e9 6d f9 ff ff       	jmp    1012bb <alltraps>

0010194e <vector131>:
.globl vector131
vector131:
  pushl $0
  10194e:	6a 00                	push   $0x0
  pushl $131
  101950:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  101955:	e9 61 f9 ff ff       	jmp    1012bb <alltraps>

0010195a <vector132>:
.globl vector132
vector132:
  pushl $0
  10195a:	6a 00                	push   $0x0
  pushl $132
  10195c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  101961:	e9 55 f9 ff ff       	jmp    1012bb <alltraps>

00101966 <vector133>:
.globl vector133
vector133:
  pushl $0
  101966:	6a 00                	push   $0x0
  pushl $133
  101968:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  10196d:	e9 49 f9 ff ff       	jmp    1012bb <alltraps>

00101972 <vector134>:
.globl vector134
vector134:
  pushl $0
  101972:	6a 00                	push   $0x0
  pushl $134
  101974:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  101979:	e9 3d f9 ff ff       	jmp    1012bb <alltraps>

0010197e <vector135>:
.globl vector135
vector135:
  pushl $0
  10197e:	6a 00                	push   $0x0
  pushl $135
  101980:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  101985:	e9 31 f9 ff ff       	jmp    1012bb <alltraps>

0010198a <vector136>:
.globl vector136
vector136:
  pushl $0
  10198a:	6a 00                	push   $0x0
  pushl $136
  10198c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  101991:	e9 25 f9 ff ff       	jmp    1012bb <alltraps>

00101996 <vector137>:
.globl vector137
vector137:
  pushl $0
  101996:	6a 00                	push   $0x0
  pushl $137
  101998:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  10199d:	e9 19 f9 ff ff       	jmp    1012bb <alltraps>

001019a2 <vector138>:
.globl vector138
vector138:
  pushl $0
  1019a2:	6a 00                	push   $0x0
  pushl $138
  1019a4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  1019a9:	e9 0d f9 ff ff       	jmp    1012bb <alltraps>

001019ae <vector139>:
.globl vector139
vector139:
  pushl $0
  1019ae:	6a 00                	push   $0x0
  pushl $139
  1019b0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  1019b5:	e9 01 f9 ff ff       	jmp    1012bb <alltraps>

001019ba <vector140>:
.globl vector140
vector140:
  pushl $0
  1019ba:	6a 00                	push   $0x0
  pushl $140
  1019bc:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  1019c1:	e9 f5 f8 ff ff       	jmp    1012bb <alltraps>

001019c6 <vector141>:
.globl vector141
vector141:
  pushl $0
  1019c6:	6a 00                	push   $0x0
  pushl $141
  1019c8:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  1019cd:	e9 e9 f8 ff ff       	jmp    1012bb <alltraps>

001019d2 <vector142>:
.globl vector142
vector142:
  pushl $0
  1019d2:	6a 00                	push   $0x0
  pushl $142
  1019d4:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  1019d9:	e9 dd f8 ff ff       	jmp    1012bb <alltraps>

001019de <vector143>:
.globl vector143
vector143:
  pushl $0
  1019de:	6a 00                	push   $0x0
  pushl $143
  1019e0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  1019e5:	e9 d1 f8 ff ff       	jmp    1012bb <alltraps>

001019ea <vector144>:
.globl vector144
vector144:
  pushl $0
  1019ea:	6a 00                	push   $0x0
  pushl $144
  1019ec:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  1019f1:	e9 c5 f8 ff ff       	jmp    1012bb <alltraps>

001019f6 <vector145>:
.globl vector145
vector145:
  pushl $0
  1019f6:	6a 00                	push   $0x0
  pushl $145
  1019f8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  1019fd:	e9 b9 f8 ff ff       	jmp    1012bb <alltraps>

00101a02 <vector146>:
.globl vector146
vector146:
  pushl $0
  101a02:	6a 00                	push   $0x0
  pushl $146
  101a04:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  101a09:	e9 ad f8 ff ff       	jmp    1012bb <alltraps>

00101a0e <vector147>:
.globl vector147
vector147:
  pushl $0
  101a0e:	6a 00                	push   $0x0
  pushl $147
  101a10:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  101a15:	e9 a1 f8 ff ff       	jmp    1012bb <alltraps>

00101a1a <vector148>:
.globl vector148
vector148:
  pushl $0
  101a1a:	6a 00                	push   $0x0
  pushl $148
  101a1c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101a21:	e9 95 f8 ff ff       	jmp    1012bb <alltraps>

00101a26 <vector149>:
.globl vector149
vector149:
  pushl $0
  101a26:	6a 00                	push   $0x0
  pushl $149
  101a28:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  101a2d:	e9 89 f8 ff ff       	jmp    1012bb <alltraps>

00101a32 <vector150>:
.globl vector150
vector150:
  pushl $0
  101a32:	6a 00                	push   $0x0
  pushl $150
  101a34:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  101a39:	e9 7d f8 ff ff       	jmp    1012bb <alltraps>

00101a3e <vector151>:
.globl vector151
vector151:
  pushl $0
  101a3e:	6a 00                	push   $0x0
  pushl $151
  101a40:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  101a45:	e9 71 f8 ff ff       	jmp    1012bb <alltraps>

00101a4a <vector152>:
.globl vector152
vector152:
  pushl $0
  101a4a:	6a 00                	push   $0x0
  pushl $152
  101a4c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  101a51:	e9 65 f8 ff ff       	jmp    1012bb <alltraps>

00101a56 <vector153>:
.globl vector153
vector153:
  pushl $0
  101a56:	6a 00                	push   $0x0
  pushl $153
  101a58:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  101a5d:	e9 59 f8 ff ff       	jmp    1012bb <alltraps>

00101a62 <vector154>:
.globl vector154
vector154:
  pushl $0
  101a62:	6a 00                	push   $0x0
  pushl $154
  101a64:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  101a69:	e9 4d f8 ff ff       	jmp    1012bb <alltraps>

00101a6e <vector155>:
.globl vector155
vector155:
  pushl $0
  101a6e:	6a 00                	push   $0x0
  pushl $155
  101a70:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  101a75:	e9 41 f8 ff ff       	jmp    1012bb <alltraps>

00101a7a <vector156>:
.globl vector156
vector156:
  pushl $0
  101a7a:	6a 00                	push   $0x0
  pushl $156
  101a7c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  101a81:	e9 35 f8 ff ff       	jmp    1012bb <alltraps>

00101a86 <vector157>:
.globl vector157
vector157:
  pushl $0
  101a86:	6a 00                	push   $0x0
  pushl $157
  101a88:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  101a8d:	e9 29 f8 ff ff       	jmp    1012bb <alltraps>

00101a92 <vector158>:
.globl vector158
vector158:
  pushl $0
  101a92:	6a 00                	push   $0x0
  pushl $158
  101a94:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  101a99:	e9 1d f8 ff ff       	jmp    1012bb <alltraps>

00101a9e <vector159>:
.globl vector159
vector159:
  pushl $0
  101a9e:	6a 00                	push   $0x0
  pushl $159
  101aa0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  101aa5:	e9 11 f8 ff ff       	jmp    1012bb <alltraps>

00101aaa <vector160>:
.globl vector160
vector160:
  pushl $0
  101aaa:	6a 00                	push   $0x0
  pushl $160
  101aac:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  101ab1:	e9 05 f8 ff ff       	jmp    1012bb <alltraps>

00101ab6 <vector161>:
.globl vector161
vector161:
  pushl $0
  101ab6:	6a 00                	push   $0x0
  pushl $161
  101ab8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  101abd:	e9 f9 f7 ff ff       	jmp    1012bb <alltraps>

00101ac2 <vector162>:
.globl vector162
vector162:
  pushl $0
  101ac2:	6a 00                	push   $0x0
  pushl $162
  101ac4:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  101ac9:	e9 ed f7 ff ff       	jmp    1012bb <alltraps>

00101ace <vector163>:
.globl vector163
vector163:
  pushl $0
  101ace:	6a 00                	push   $0x0
  pushl $163
  101ad0:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  101ad5:	e9 e1 f7 ff ff       	jmp    1012bb <alltraps>

00101ada <vector164>:
.globl vector164
vector164:
  pushl $0
  101ada:	6a 00                	push   $0x0
  pushl $164
  101adc:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  101ae1:	e9 d5 f7 ff ff       	jmp    1012bb <alltraps>

00101ae6 <vector165>:
.globl vector165
vector165:
  pushl $0
  101ae6:	6a 00                	push   $0x0
  pushl $165
  101ae8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  101aed:	e9 c9 f7 ff ff       	jmp    1012bb <alltraps>

00101af2 <vector166>:
.globl vector166
vector166:
  pushl $0
  101af2:	6a 00                	push   $0x0
  pushl $166
  101af4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  101af9:	e9 bd f7 ff ff       	jmp    1012bb <alltraps>

00101afe <vector167>:
.globl vector167
vector167:
  pushl $0
  101afe:	6a 00                	push   $0x0
  pushl $167
  101b00:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  101b05:	e9 b1 f7 ff ff       	jmp    1012bb <alltraps>

00101b0a <vector168>:
.globl vector168
vector168:
  pushl $0
  101b0a:	6a 00                	push   $0x0
  pushl $168
  101b0c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  101b11:	e9 a5 f7 ff ff       	jmp    1012bb <alltraps>

00101b16 <vector169>:
.globl vector169
vector169:
  pushl $0
  101b16:	6a 00                	push   $0x0
  pushl $169
  101b18:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  101b1d:	e9 99 f7 ff ff       	jmp    1012bb <alltraps>

00101b22 <vector170>:
.globl vector170
vector170:
  pushl $0
  101b22:	6a 00                	push   $0x0
  pushl $170
  101b24:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  101b29:	e9 8d f7 ff ff       	jmp    1012bb <alltraps>

00101b2e <vector171>:
.globl vector171
vector171:
  pushl $0
  101b2e:	6a 00                	push   $0x0
  pushl $171
  101b30:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  101b35:	e9 81 f7 ff ff       	jmp    1012bb <alltraps>

00101b3a <vector172>:
.globl vector172
vector172:
  pushl $0
  101b3a:	6a 00                	push   $0x0
  pushl $172
  101b3c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  101b41:	e9 75 f7 ff ff       	jmp    1012bb <alltraps>

00101b46 <vector173>:
.globl vector173
vector173:
  pushl $0
  101b46:	6a 00                	push   $0x0
  pushl $173
  101b48:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  101b4d:	e9 69 f7 ff ff       	jmp    1012bb <alltraps>

00101b52 <vector174>:
.globl vector174
vector174:
  pushl $0
  101b52:	6a 00                	push   $0x0
  pushl $174
  101b54:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  101b59:	e9 5d f7 ff ff       	jmp    1012bb <alltraps>

00101b5e <vector175>:
.globl vector175
vector175:
  pushl $0
  101b5e:	6a 00                	push   $0x0
  pushl $175
  101b60:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  101b65:	e9 51 f7 ff ff       	jmp    1012bb <alltraps>

00101b6a <vector176>:
.globl vector176
vector176:
  pushl $0
  101b6a:	6a 00                	push   $0x0
  pushl $176
  101b6c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  101b71:	e9 45 f7 ff ff       	jmp    1012bb <alltraps>

00101b76 <vector177>:
.globl vector177
vector177:
  pushl $0
  101b76:	6a 00                	push   $0x0
  pushl $177
  101b78:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  101b7d:	e9 39 f7 ff ff       	jmp    1012bb <alltraps>

00101b82 <vector178>:
.globl vector178
vector178:
  pushl $0
  101b82:	6a 00                	push   $0x0
  pushl $178
  101b84:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  101b89:	e9 2d f7 ff ff       	jmp    1012bb <alltraps>

00101b8e <vector179>:
.globl vector179
vector179:
  pushl $0
  101b8e:	6a 00                	push   $0x0
  pushl $179
  101b90:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  101b95:	e9 21 f7 ff ff       	jmp    1012bb <alltraps>

00101b9a <vector180>:
.globl vector180
vector180:
  pushl $0
  101b9a:	6a 00                	push   $0x0
  pushl $180
  101b9c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  101ba1:	e9 15 f7 ff ff       	jmp    1012bb <alltraps>

00101ba6 <vector181>:
.globl vector181
vector181:
  pushl $0
  101ba6:	6a 00                	push   $0x0
  pushl $181
  101ba8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  101bad:	e9 09 f7 ff ff       	jmp    1012bb <alltraps>

00101bb2 <vector182>:
.globl vector182
vector182:
  pushl $0
  101bb2:	6a 00                	push   $0x0
  pushl $182
  101bb4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  101bb9:	e9 fd f6 ff ff       	jmp    1012bb <alltraps>

00101bbe <vector183>:
.globl vector183
vector183:
  pushl $0
  101bbe:	6a 00                	push   $0x0
  pushl $183
  101bc0:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  101bc5:	e9 f1 f6 ff ff       	jmp    1012bb <alltraps>

00101bca <vector184>:
.globl vector184
vector184:
  pushl $0
  101bca:	6a 00                	push   $0x0
  pushl $184
  101bcc:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  101bd1:	e9 e5 f6 ff ff       	jmp    1012bb <alltraps>

00101bd6 <vector185>:
.globl vector185
vector185:
  pushl $0
  101bd6:	6a 00                	push   $0x0
  pushl $185
  101bd8:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  101bdd:	e9 d9 f6 ff ff       	jmp    1012bb <alltraps>

00101be2 <vector186>:
.globl vector186
vector186:
  pushl $0
  101be2:	6a 00                	push   $0x0
  pushl $186
  101be4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  101be9:	e9 cd f6 ff ff       	jmp    1012bb <alltraps>

00101bee <vector187>:
.globl vector187
vector187:
  pushl $0
  101bee:	6a 00                	push   $0x0
  pushl $187
  101bf0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  101bf5:	e9 c1 f6 ff ff       	jmp    1012bb <alltraps>

00101bfa <vector188>:
.globl vector188
vector188:
  pushl $0
  101bfa:	6a 00                	push   $0x0
  pushl $188
  101bfc:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  101c01:	e9 b5 f6 ff ff       	jmp    1012bb <alltraps>

00101c06 <vector189>:
.globl vector189
vector189:
  pushl $0
  101c06:	6a 00                	push   $0x0
  pushl $189
  101c08:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  101c0d:	e9 a9 f6 ff ff       	jmp    1012bb <alltraps>

00101c12 <vector190>:
.globl vector190
vector190:
  pushl $0
  101c12:	6a 00                	push   $0x0
  pushl $190
  101c14:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  101c19:	e9 9d f6 ff ff       	jmp    1012bb <alltraps>

00101c1e <vector191>:
.globl vector191
vector191:
  pushl $0
  101c1e:	6a 00                	push   $0x0
  pushl $191
  101c20:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  101c25:	e9 91 f6 ff ff       	jmp    1012bb <alltraps>

00101c2a <vector192>:
.globl vector192
vector192:
  pushl $0
  101c2a:	6a 00                	push   $0x0
  pushl $192
  101c2c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  101c31:	e9 85 f6 ff ff       	jmp    1012bb <alltraps>

00101c36 <vector193>:
.globl vector193
vector193:
  pushl $0
  101c36:	6a 00                	push   $0x0
  pushl $193
  101c38:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  101c3d:	e9 79 f6 ff ff       	jmp    1012bb <alltraps>

00101c42 <vector194>:
.globl vector194
vector194:
  pushl $0
  101c42:	6a 00                	push   $0x0
  pushl $194
  101c44:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  101c49:	e9 6d f6 ff ff       	jmp    1012bb <alltraps>

00101c4e <vector195>:
.globl vector195
vector195:
  pushl $0
  101c4e:	6a 00                	push   $0x0
  pushl $195
  101c50:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  101c55:	e9 61 f6 ff ff       	jmp    1012bb <alltraps>

00101c5a <vector196>:
.globl vector196
vector196:
  pushl $0
  101c5a:	6a 00                	push   $0x0
  pushl $196
  101c5c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  101c61:	e9 55 f6 ff ff       	jmp    1012bb <alltraps>

00101c66 <vector197>:
.globl vector197
vector197:
  pushl $0
  101c66:	6a 00                	push   $0x0
  pushl $197
  101c68:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  101c6d:	e9 49 f6 ff ff       	jmp    1012bb <alltraps>

00101c72 <vector198>:
.globl vector198
vector198:
  pushl $0
  101c72:	6a 00                	push   $0x0
  pushl $198
  101c74:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  101c79:	e9 3d f6 ff ff       	jmp    1012bb <alltraps>

00101c7e <vector199>:
.globl vector199
vector199:
  pushl $0
  101c7e:	6a 00                	push   $0x0
  pushl $199
  101c80:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  101c85:	e9 31 f6 ff ff       	jmp    1012bb <alltraps>

00101c8a <vector200>:
.globl vector200
vector200:
  pushl $0
  101c8a:	6a 00                	push   $0x0
  pushl $200
  101c8c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  101c91:	e9 25 f6 ff ff       	jmp    1012bb <alltraps>

00101c96 <vector201>:
.globl vector201
vector201:
  pushl $0
  101c96:	6a 00                	push   $0x0
  pushl $201
  101c98:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  101c9d:	e9 19 f6 ff ff       	jmp    1012bb <alltraps>

00101ca2 <vector202>:
.globl vector202
vector202:
  pushl $0
  101ca2:	6a 00                	push   $0x0
  pushl $202
  101ca4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  101ca9:	e9 0d f6 ff ff       	jmp    1012bb <alltraps>

00101cae <vector203>:
.globl vector203
vector203:
  pushl $0
  101cae:	6a 00                	push   $0x0
  pushl $203
  101cb0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  101cb5:	e9 01 f6 ff ff       	jmp    1012bb <alltraps>

00101cba <vector204>:
.globl vector204
vector204:
  pushl $0
  101cba:	6a 00                	push   $0x0
  pushl $204
  101cbc:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  101cc1:	e9 f5 f5 ff ff       	jmp    1012bb <alltraps>

00101cc6 <vector205>:
.globl vector205
vector205:
  pushl $0
  101cc6:	6a 00                	push   $0x0
  pushl $205
  101cc8:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  101ccd:	e9 e9 f5 ff ff       	jmp    1012bb <alltraps>

00101cd2 <vector206>:
.globl vector206
vector206:
  pushl $0
  101cd2:	6a 00                	push   $0x0
  pushl $206
  101cd4:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  101cd9:	e9 dd f5 ff ff       	jmp    1012bb <alltraps>

00101cde <vector207>:
.globl vector207
vector207:
  pushl $0
  101cde:	6a 00                	push   $0x0
  pushl $207
  101ce0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  101ce5:	e9 d1 f5 ff ff       	jmp    1012bb <alltraps>

00101cea <vector208>:
.globl vector208
vector208:
  pushl $0
  101cea:	6a 00                	push   $0x0
  pushl $208
  101cec:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  101cf1:	e9 c5 f5 ff ff       	jmp    1012bb <alltraps>

00101cf6 <vector209>:
.globl vector209
vector209:
  pushl $0
  101cf6:	6a 00                	push   $0x0
  pushl $209
  101cf8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  101cfd:	e9 b9 f5 ff ff       	jmp    1012bb <alltraps>

00101d02 <vector210>:
.globl vector210
vector210:
  pushl $0
  101d02:	6a 00                	push   $0x0
  pushl $210
  101d04:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  101d09:	e9 ad f5 ff ff       	jmp    1012bb <alltraps>

00101d0e <vector211>:
.globl vector211
vector211:
  pushl $0
  101d0e:	6a 00                	push   $0x0
  pushl $211
  101d10:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  101d15:	e9 a1 f5 ff ff       	jmp    1012bb <alltraps>

00101d1a <vector212>:
.globl vector212
vector212:
  pushl $0
  101d1a:	6a 00                	push   $0x0
  pushl $212
  101d1c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  101d21:	e9 95 f5 ff ff       	jmp    1012bb <alltraps>

00101d26 <vector213>:
.globl vector213
vector213:
  pushl $0
  101d26:	6a 00                	push   $0x0
  pushl $213
  101d28:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  101d2d:	e9 89 f5 ff ff       	jmp    1012bb <alltraps>

00101d32 <vector214>:
.globl vector214
vector214:
  pushl $0
  101d32:	6a 00                	push   $0x0
  pushl $214
  101d34:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  101d39:	e9 7d f5 ff ff       	jmp    1012bb <alltraps>

00101d3e <vector215>:
.globl vector215
vector215:
  pushl $0
  101d3e:	6a 00                	push   $0x0
  pushl $215
  101d40:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  101d45:	e9 71 f5 ff ff       	jmp    1012bb <alltraps>

00101d4a <vector216>:
.globl vector216
vector216:
  pushl $0
  101d4a:	6a 00                	push   $0x0
  pushl $216
  101d4c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  101d51:	e9 65 f5 ff ff       	jmp    1012bb <alltraps>

00101d56 <vector217>:
.globl vector217
vector217:
  pushl $0
  101d56:	6a 00                	push   $0x0
  pushl $217
  101d58:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  101d5d:	e9 59 f5 ff ff       	jmp    1012bb <alltraps>

00101d62 <vector218>:
.globl vector218
vector218:
  pushl $0
  101d62:	6a 00                	push   $0x0
  pushl $218
  101d64:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  101d69:	e9 4d f5 ff ff       	jmp    1012bb <alltraps>

00101d6e <vector219>:
.globl vector219
vector219:
  pushl $0
  101d6e:	6a 00                	push   $0x0
  pushl $219
  101d70:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  101d75:	e9 41 f5 ff ff       	jmp    1012bb <alltraps>

00101d7a <vector220>:
.globl vector220
vector220:
  pushl $0
  101d7a:	6a 00                	push   $0x0
  pushl $220
  101d7c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  101d81:	e9 35 f5 ff ff       	jmp    1012bb <alltraps>

00101d86 <vector221>:
.globl vector221
vector221:
  pushl $0
  101d86:	6a 00                	push   $0x0
  pushl $221
  101d88:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  101d8d:	e9 29 f5 ff ff       	jmp    1012bb <alltraps>

00101d92 <vector222>:
.globl vector222
vector222:
  pushl $0
  101d92:	6a 00                	push   $0x0
  pushl $222
  101d94:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  101d99:	e9 1d f5 ff ff       	jmp    1012bb <alltraps>

00101d9e <vector223>:
.globl vector223
vector223:
  pushl $0
  101d9e:	6a 00                	push   $0x0
  pushl $223
  101da0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  101da5:	e9 11 f5 ff ff       	jmp    1012bb <alltraps>

00101daa <vector224>:
.globl vector224
vector224:
  pushl $0
  101daa:	6a 00                	push   $0x0
  pushl $224
  101dac:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  101db1:	e9 05 f5 ff ff       	jmp    1012bb <alltraps>

00101db6 <vector225>:
.globl vector225
vector225:
  pushl $0
  101db6:	6a 00                	push   $0x0
  pushl $225
  101db8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  101dbd:	e9 f9 f4 ff ff       	jmp    1012bb <alltraps>

00101dc2 <vector226>:
.globl vector226
vector226:
  pushl $0
  101dc2:	6a 00                	push   $0x0
  pushl $226
  101dc4:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  101dc9:	e9 ed f4 ff ff       	jmp    1012bb <alltraps>

00101dce <vector227>:
.globl vector227
vector227:
  pushl $0
  101dce:	6a 00                	push   $0x0
  pushl $227
  101dd0:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  101dd5:	e9 e1 f4 ff ff       	jmp    1012bb <alltraps>

00101dda <vector228>:
.globl vector228
vector228:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $228
  101ddc:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  101de1:	e9 d5 f4 ff ff       	jmp    1012bb <alltraps>

00101de6 <vector229>:
.globl vector229
vector229:
  pushl $0
  101de6:	6a 00                	push   $0x0
  pushl $229
  101de8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  101ded:	e9 c9 f4 ff ff       	jmp    1012bb <alltraps>

00101df2 <vector230>:
.globl vector230
vector230:
  pushl $0
  101df2:	6a 00                	push   $0x0
  pushl $230
  101df4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  101df9:	e9 bd f4 ff ff       	jmp    1012bb <alltraps>

00101dfe <vector231>:
.globl vector231
vector231:
  pushl $0
  101dfe:	6a 00                	push   $0x0
  pushl $231
  101e00:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  101e05:	e9 b1 f4 ff ff       	jmp    1012bb <alltraps>

00101e0a <vector232>:
.globl vector232
vector232:
  pushl $0
  101e0a:	6a 00                	push   $0x0
  pushl $232
  101e0c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  101e11:	e9 a5 f4 ff ff       	jmp    1012bb <alltraps>

00101e16 <vector233>:
.globl vector233
vector233:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $233
  101e18:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  101e1d:	e9 99 f4 ff ff       	jmp    1012bb <alltraps>

00101e22 <vector234>:
.globl vector234
vector234:
  pushl $0
  101e22:	6a 00                	push   $0x0
  pushl $234
  101e24:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  101e29:	e9 8d f4 ff ff       	jmp    1012bb <alltraps>

00101e2e <vector235>:
.globl vector235
vector235:
  pushl $0
  101e2e:	6a 00                	push   $0x0
  pushl $235
  101e30:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  101e35:	e9 81 f4 ff ff       	jmp    1012bb <alltraps>

00101e3a <vector236>:
.globl vector236
vector236:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $236
  101e3c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  101e41:	e9 75 f4 ff ff       	jmp    1012bb <alltraps>

00101e46 <vector237>:
.globl vector237
vector237:
  pushl $0
  101e46:	6a 00                	push   $0x0
  pushl $237
  101e48:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  101e4d:	e9 69 f4 ff ff       	jmp    1012bb <alltraps>

00101e52 <vector238>:
.globl vector238
vector238:
  pushl $0
  101e52:	6a 00                	push   $0x0
  pushl $238
  101e54:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  101e59:	e9 5d f4 ff ff       	jmp    1012bb <alltraps>

00101e5e <vector239>:
.globl vector239
vector239:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $239
  101e60:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  101e65:	e9 51 f4 ff ff       	jmp    1012bb <alltraps>

00101e6a <vector240>:
.globl vector240
vector240:
  pushl $0
  101e6a:	6a 00                	push   $0x0
  pushl $240
  101e6c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  101e71:	e9 45 f4 ff ff       	jmp    1012bb <alltraps>

00101e76 <vector241>:
.globl vector241
vector241:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $241
  101e78:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  101e7d:	e9 39 f4 ff ff       	jmp    1012bb <alltraps>

00101e82 <vector242>:
.globl vector242
vector242:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $242
  101e84:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  101e89:	e9 2d f4 ff ff       	jmp    1012bb <alltraps>

00101e8e <vector243>:
.globl vector243
vector243:
  pushl $0
  101e8e:	6a 00                	push   $0x0
  pushl $243
  101e90:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  101e95:	e9 21 f4 ff ff       	jmp    1012bb <alltraps>

00101e9a <vector244>:
.globl vector244
vector244:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $244
  101e9c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  101ea1:	e9 15 f4 ff ff       	jmp    1012bb <alltraps>

00101ea6 <vector245>:
.globl vector245
vector245:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $245
  101ea8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  101ead:	e9 09 f4 ff ff       	jmp    1012bb <alltraps>

00101eb2 <vector246>:
.globl vector246
vector246:
  pushl $0
  101eb2:	6a 00                	push   $0x0
  pushl $246
  101eb4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  101eb9:	e9 fd f3 ff ff       	jmp    1012bb <alltraps>

00101ebe <vector247>:
.globl vector247
vector247:
  pushl $0
  101ebe:	6a 00                	push   $0x0
  pushl $247
  101ec0:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  101ec5:	e9 f1 f3 ff ff       	jmp    1012bb <alltraps>

00101eca <vector248>:
.globl vector248
vector248:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $248
  101ecc:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  101ed1:	e9 e5 f3 ff ff       	jmp    1012bb <alltraps>

00101ed6 <vector249>:
.globl vector249
vector249:
  pushl $0
  101ed6:	6a 00                	push   $0x0
  pushl $249
  101ed8:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  101edd:	e9 d9 f3 ff ff       	jmp    1012bb <alltraps>

00101ee2 <vector250>:
.globl vector250
vector250:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $250
  101ee4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  101ee9:	e9 cd f3 ff ff       	jmp    1012bb <alltraps>

00101eee <vector251>:
.globl vector251
vector251:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $251
  101ef0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  101ef5:	e9 c1 f3 ff ff       	jmp    1012bb <alltraps>

00101efa <vector252>:
.globl vector252
vector252:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $252
  101efc:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  101f01:	e9 b5 f3 ff ff       	jmp    1012bb <alltraps>

00101f06 <vector253>:
.globl vector253
vector253:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $253
  101f08:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  101f0d:	e9 a9 f3 ff ff       	jmp    1012bb <alltraps>

00101f12 <vector254>:
.globl vector254
vector254:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $254
  101f14:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  101f19:	e9 9d f3 ff ff       	jmp    1012bb <alltraps>

00101f1e <vector255>:
.globl vector255
vector255:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $255
  101f20:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  101f25:	e9 91 f3 ff ff       	jmp    1012bb <alltraps>

00101f2a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
  101f2a:	55                   	push   %ebp
  101f2b:	89 e5                	mov    %esp,%ebp
  101f2d:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  101f30:	c7 05 58 9c 10 00 48 	movl   $0x109c48,0x109c58
  101f37:	9c 10 00 
  bcache.head.next = &bcache.head;
  101f3a:	c7 05 5c 9c 10 00 48 	movl   $0x109c48,0x109c5c
  101f41:	9c 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  101f44:	c7 45 fc 00 5d 10 00 	movl   $0x105d00,-0x4(%ebp)
  101f4b:	eb 30                	jmp    101f7d <binit+0x53>
    b->next = bcache.head.next;
  101f4d:	8b 15 5c 9c 10 00    	mov    0x109c5c,%edx
  101f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101f56:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  101f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101f5c:	c7 40 10 48 9c 10 00 	movl   $0x109c48,0x10(%eax)
    bcache.head.next->prev = b;
  101f63:	a1 5c 9c 10 00       	mov    0x109c5c,%eax
  101f68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101f6b:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  101f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101f71:	a3 5c 9c 10 00       	mov    %eax,0x109c5c
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  101f76:	81 45 fc 1c 02 00 00 	addl   $0x21c,-0x4(%ebp)
  101f7d:	b8 48 9c 10 00       	mov    $0x109c48,%eax
  101f82:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  101f85:	72 c6                	jb     101f4d <binit+0x23>
  }
}
  101f87:	90                   	nop
  101f88:	90                   	nop
  101f89:	c9                   	leave  
  101f8a:	c3                   	ret    

00101f8b <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  101f8b:	55                   	push   %ebp
  101f8c:	89 e5                	mov    %esp,%ebp
  101f8e:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  101f91:	a1 5c 9c 10 00       	mov    0x109c5c,%eax
  101f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101f99:	eb 33                	jmp    101fce <bget+0x43>
    if(b->dev == dev && b->blockno == blockno){
  101f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f9e:	8b 40 04             	mov    0x4(%eax),%eax
  101fa1:	39 45 08             	cmp    %eax,0x8(%ebp)
  101fa4:	75 1f                	jne    101fc5 <bget+0x3a>
  101fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fa9:	8b 40 08             	mov    0x8(%eax),%eax
  101fac:	39 45 0c             	cmp    %eax,0xc(%ebp)
  101faf:	75 14                	jne    101fc5 <bget+0x3a>
      b->refcnt++;
  101fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  101fb7:	8d 50 01             	lea    0x1(%eax),%edx
  101fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fbd:	89 50 0c             	mov    %edx,0xc(%eax)
      return b;
  101fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fc3:	eb 7b                	jmp    102040 <bget+0xb5>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  101fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fc8:	8b 40 14             	mov    0x14(%eax),%eax
  101fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101fce:	81 7d f4 48 9c 10 00 	cmpl   $0x109c48,-0xc(%ebp)
  101fd5:	75 c4                	jne    101f9b <bget+0x10>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  101fd7:	a1 58 9c 10 00       	mov    0x109c58,%eax
  101fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101fdf:	eb 49                	jmp    10202a <bget+0x9f>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
  101fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  101fe7:	85 c0                	test   %eax,%eax
  101fe9:	75 36                	jne    102021 <bget+0x96>
  101feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fee:	8b 00                	mov    (%eax),%eax
  101ff0:	83 e0 04             	and    $0x4,%eax
  101ff3:	85 c0                	test   %eax,%eax
  101ff5:	75 2a                	jne    102021 <bget+0x96>
      b->dev = dev;
  101ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  101ffd:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
  102000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102003:	8b 55 0c             	mov    0xc(%ebp),%edx
  102006:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
  102009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10200c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
  102012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102015:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
      return b;
  10201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10201f:	eb 1f                	jmp    102040 <bget+0xb5>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  102021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102024:	8b 40 10             	mov    0x10(%eax),%eax
  102027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10202a:	81 7d f4 48 9c 10 00 	cmpl   $0x109c48,-0xc(%ebp)
  102031:	75 ae                	jne    101fe1 <bget+0x56>
    }
  }
  panic("bget: no buffers");
  102033:	83 ec 0c             	sub    $0xc,%esp
  102036:	68 f0 42 10 00       	push   $0x1042f0
  10203b:	e8 6d e2 ff ff       	call   1002ad <panic>
}
  102040:	c9                   	leave  
  102041:	c3                   	ret    

00102042 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  102042:	55                   	push   %ebp
  102043:	89 e5                	mov    %esp,%ebp
  102045:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
  102048:	83 ec 08             	sub    $0x8,%esp
  10204b:	ff 75 0c             	push   0xc(%ebp)
  10204e:	ff 75 08             	push   0x8(%ebp)
  102051:	e8 35 ff ff ff       	call   101f8b <bget>
  102056:	83 c4 10             	add    $0x10,%esp
  102059:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
  10205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10205f:	8b 00                	mov    (%eax),%eax
  102061:	83 e0 02             	and    $0x2,%eax
  102064:	85 c0                	test   %eax,%eax
  102066:	75 0e                	jne    102076 <bread+0x34>
    iderw(b);
  102068:	83 ec 0c             	sub    $0xc,%esp
  10206b:	ff 75 f4             	push   -0xc(%ebp)
  10206e:	e8 17 04 00 00       	call   10248a <iderw>
  102073:	83 c4 10             	add    $0x10,%esp
  }
  return b;
  102076:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102079:	c9                   	leave  
  10207a:	c3                   	ret    

0010207b <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  10207b:	55                   	push   %ebp
  10207c:	89 e5                	mov    %esp,%ebp
  10207e:	83 ec 08             	sub    $0x8,%esp
  b->flags |= B_DIRTY;
  102081:	8b 45 08             	mov    0x8(%ebp),%eax
  102084:	8b 00                	mov    (%eax),%eax
  102086:	83 c8 04             	or     $0x4,%eax
  102089:	89 c2                	mov    %eax,%edx
  10208b:	8b 45 08             	mov    0x8(%ebp),%eax
  10208e:	89 10                	mov    %edx,(%eax)
  iderw(b);
  102090:	83 ec 0c             	sub    $0xc,%esp
  102093:	ff 75 08             	push   0x8(%ebp)
  102096:	e8 ef 03 00 00       	call   10248a <iderw>
  10209b:	83 c4 10             	add    $0x10,%esp
}
  10209e:	90                   	nop
  10209f:	c9                   	leave  
  1020a0:	c3                   	ret    

001020a1 <brelse>:

// Release a buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  1020a1:	55                   	push   %ebp
  1020a2:	89 e5                	mov    %esp,%ebp
  b->refcnt--;
  1020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a7:	8b 40 0c             	mov    0xc(%eax),%eax
  1020aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  1020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b0:	89 50 0c             	mov    %edx,0xc(%eax)
  if (b->refcnt == 0) {
  1020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b6:	8b 40 0c             	mov    0xc(%eax),%eax
  1020b9:	85 c0                	test   %eax,%eax
  1020bb:	75 47                	jne    102104 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
  1020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1020c0:	8b 40 14             	mov    0x14(%eax),%eax
  1020c3:	8b 55 08             	mov    0x8(%ebp),%edx
  1020c6:	8b 52 10             	mov    0x10(%edx),%edx
  1020c9:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev->next = b->next;
  1020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1020cf:	8b 40 10             	mov    0x10(%eax),%eax
  1020d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1020d5:	8b 52 14             	mov    0x14(%edx),%edx
  1020d8:	89 50 14             	mov    %edx,0x14(%eax)
    b->next = bcache.head.next;
  1020db:	8b 15 5c 9c 10 00    	mov    0x109c5c,%edx
  1020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020e4:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  1020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ea:	c7 40 10 48 9c 10 00 	movl   $0x109c48,0x10(%eax)
    bcache.head.next->prev = b;
  1020f1:	a1 5c 9c 10 00       	mov    0x109c5c,%eax
  1020f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1020f9:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  1020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ff:	a3 5c 9c 10 00       	mov    %eax,0x109c5c
  }
  102104:	90                   	nop
  102105:	5d                   	pop    %ebp
  102106:	c3                   	ret    

00102107 <inb>:
{
  102107:	55                   	push   %ebp
  102108:	89 e5                	mov    %esp,%ebp
  10210a:	83 ec 14             	sub    $0x14,%esp
  10210d:	8b 45 08             	mov    0x8(%ebp),%eax
  102110:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102114:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  102118:	89 c2                	mov    %eax,%edx
  10211a:	ec                   	in     (%dx),%al
  10211b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  10211e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  102122:	c9                   	leave  
  102123:	c3                   	ret    

00102124 <insl>:
{
  102124:	55                   	push   %ebp
  102125:	89 e5                	mov    %esp,%ebp
  102127:	57                   	push   %edi
  102128:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
  102129:	8b 55 08             	mov    0x8(%ebp),%edx
  10212c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10212f:	8b 45 10             	mov    0x10(%ebp),%eax
  102132:	89 cb                	mov    %ecx,%ebx
  102134:	89 df                	mov    %ebx,%edi
  102136:	89 c1                	mov    %eax,%ecx
  102138:	fc                   	cld    
  102139:	f3 6d                	rep insl (%dx),%es:(%edi)
  10213b:	89 c8                	mov    %ecx,%eax
  10213d:	89 fb                	mov    %edi,%ebx
  10213f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  102142:	89 45 10             	mov    %eax,0x10(%ebp)
}
  102145:	90                   	nop
  102146:	5b                   	pop    %ebx
  102147:	5f                   	pop    %edi
  102148:	5d                   	pop    %ebp
  102149:	c3                   	ret    

0010214a <outb>:
{
  10214a:	55                   	push   %ebp
  10214b:	89 e5                	mov    %esp,%ebp
  10214d:	83 ec 08             	sub    $0x8,%esp
  102150:	8b 45 08             	mov    0x8(%ebp),%eax
  102153:	8b 55 0c             	mov    0xc(%ebp),%edx
  102156:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  10215a:	89 d0                	mov    %edx,%eax
  10215c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10215f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  102163:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  102167:	ee                   	out    %al,(%dx)
}
  102168:	90                   	nop
  102169:	c9                   	leave  
  10216a:	c3                   	ret    

0010216b <outsl>:
{
  10216b:	55                   	push   %ebp
  10216c:	89 e5                	mov    %esp,%ebp
  10216e:	56                   	push   %esi
  10216f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
  102170:	8b 55 08             	mov    0x8(%ebp),%edx
  102173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102176:	8b 45 10             	mov    0x10(%ebp),%eax
  102179:	89 cb                	mov    %ecx,%ebx
  10217b:	89 de                	mov    %ebx,%esi
  10217d:	89 c1                	mov    %eax,%ecx
  10217f:	fc                   	cld    
  102180:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  102182:	89 c8                	mov    %ecx,%eax
  102184:	89 f3                	mov    %esi,%ebx
  102186:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  102189:	89 45 10             	mov    %eax,0x10(%ebp)
}
  10218c:	90                   	nop
  10218d:	5b                   	pop    %ebx
  10218e:	5e                   	pop    %esi
  10218f:	5d                   	pop    %ebp
  102190:	c3                   	ret    

00102191 <noop>:

static inline void
noop(void)
{
  102191:	55                   	push   %ebp
  102192:	89 e5                	mov    %esp,%ebp
  asm volatile("nop");
  102194:	90                   	nop
}
  102195:	90                   	nop
  102196:	5d                   	pop    %ebp
  102197:	c3                   	ret    

00102198 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
  102198:	55                   	push   %ebp
  102199:	89 e5                	mov    %esp,%ebp
  10219b:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY);
  10219e:	90                   	nop
  10219f:	68 f7 01 00 00       	push   $0x1f7
  1021a4:	e8 5e ff ff ff       	call   102107 <inb>
  1021a9:	83 c4 04             	add    $0x4,%esp
  1021ac:	0f b6 c0             	movzbl %al,%eax
  1021af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1021b5:	25 c0 00 00 00       	and    $0xc0,%eax
  1021ba:	83 f8 40             	cmp    $0x40,%eax
  1021bd:	75 e0                	jne    10219f <idewait+0x7>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  1021bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1021c3:	74 11                	je     1021d6 <idewait+0x3e>
  1021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1021c8:	83 e0 21             	and    $0x21,%eax
  1021cb:	85 c0                	test   %eax,%eax
  1021cd:	74 07                	je     1021d6 <idewait+0x3e>
    return -1;
  1021cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1021d4:	eb 05                	jmp    1021db <idewait+0x43>
  return 0;
  1021d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1021db:	c9                   	leave  
  1021dc:	c3                   	ret    

001021dd <ideinit>:

void
ideinit(void)
{
  1021dd:	55                   	push   %ebp
  1021de:	89 e5                	mov    %esp,%ebp
  1021e0:	83 ec 18             	sub    $0x18,%esp
  int i;

  // initlock(&idelock, "ide");
  ioapicenable(IRQ_IDE, ncpu - 1);
  1021e3:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  1021e8:	83 e8 01             	sub    $0x1,%eax
  1021eb:	83 ec 08             	sub    $0x8,%esp
  1021ee:	50                   	push   %eax
  1021ef:	6a 0e                	push   $0xe
  1021f1:	e8 7d e4 ff ff       	call   100673 <ioapicenable>
  1021f6:	83 c4 10             	add    $0x10,%esp
  idewait(0);
  1021f9:	83 ec 0c             	sub    $0xc,%esp
  1021fc:	6a 00                	push   $0x0
  1021fe:	e8 95 ff ff ff       	call   102198 <idewait>
  102203:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  102206:	83 ec 08             	sub    $0x8,%esp
  102209:	68 f0 00 00 00       	push   $0xf0
  10220e:	68 f6 01 00 00       	push   $0x1f6
  102213:	e8 32 ff ff ff       	call   10214a <outb>
  102218:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
  10221b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102222:	eb 24                	jmp    102248 <ideinit+0x6b>
    if(inb(0x1f7) != 0){
  102224:	83 ec 0c             	sub    $0xc,%esp
  102227:	68 f7 01 00 00       	push   $0x1f7
  10222c:	e8 d6 fe ff ff       	call   102107 <inb>
  102231:	83 c4 10             	add    $0x10,%esp
  102234:	84 c0                	test   %al,%al
  102236:	74 0c                	je     102244 <ideinit+0x67>
      havedisk1 = 1;
  102238:	c7 05 68 9e 10 00 01 	movl   $0x1,0x109e68
  10223f:	00 00 00 
      break;
  102242:	eb 0d                	jmp    102251 <ideinit+0x74>
  for(i=0; i<1000; i++){
  102244:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102248:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  10224f:	7e d3                	jle    102224 <ideinit+0x47>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
  102251:	83 ec 08             	sub    $0x8,%esp
  102254:	68 e0 00 00 00       	push   $0xe0
  102259:	68 f6 01 00 00       	push   $0x1f6
  10225e:	e8 e7 fe ff ff       	call   10214a <outb>
  102263:	83 c4 10             	add    $0x10,%esp
}
  102266:	90                   	nop
  102267:	c9                   	leave  
  102268:	c3                   	ret    

00102269 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  102269:	55                   	push   %ebp
  10226a:	89 e5                	mov    %esp,%ebp
  10226c:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
  10226f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102273:	75 0d                	jne    102282 <idestart+0x19>
    panic("idestart");
  102275:	83 ec 0c             	sub    $0xc,%esp
  102278:	68 01 43 10 00       	push   $0x104301
  10227d:	e8 2b e0 ff ff       	call   1002ad <panic>
  if(b->blockno >= FSSIZE)
  102282:	8b 45 08             	mov    0x8(%ebp),%eax
  102285:	8b 40 08             	mov    0x8(%eax),%eax
  102288:	3d e7 03 00 00       	cmp    $0x3e7,%eax
  10228d:	76 0d                	jbe    10229c <idestart+0x33>
    panic("incorrect blockno");
  10228f:	83 ec 0c             	sub    $0xc,%esp
  102292:	68 0a 43 10 00       	push   $0x10430a
  102297:	e8 11 e0 ff ff       	call   1002ad <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
  10229c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
  1022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1022a6:	8b 50 08             	mov    0x8(%eax),%edx
  1022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1022ac:	0f af c2             	imul   %edx,%eax
  1022af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  1022b2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  1022b6:	75 07                	jne    1022bf <idestart+0x56>
  1022b8:	b8 20 00 00 00       	mov    $0x20,%eax
  1022bd:	eb 05                	jmp    1022c4 <idestart+0x5b>
  1022bf:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1022c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
  1022c7:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  1022cb:	75 07                	jne    1022d4 <idestart+0x6b>
  1022cd:	b8 30 00 00 00       	mov    $0x30,%eax
  1022d2:	eb 05                	jmp    1022d9 <idestart+0x70>
  1022d4:	b8 c5 00 00 00       	mov    $0xc5,%eax
  1022d9:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
  1022dc:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  1022e0:	7e 0d                	jle    1022ef <idestart+0x86>
  1022e2:	83 ec 0c             	sub    $0xc,%esp
  1022e5:	68 01 43 10 00       	push   $0x104301
  1022ea:	e8 be df ff ff       	call   1002ad <panic>

  idewait(0);
  1022ef:	83 ec 0c             	sub    $0xc,%esp
  1022f2:	6a 00                	push   $0x0
  1022f4:	e8 9f fe ff ff       	call   102198 <idewait>
  1022f9:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
  1022fc:	83 ec 08             	sub    $0x8,%esp
  1022ff:	6a 00                	push   $0x0
  102301:	68 f6 03 00 00       	push   $0x3f6
  102306:	e8 3f fe ff ff       	call   10214a <outb>
  10230b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
  10230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102311:	0f b6 c0             	movzbl %al,%eax
  102314:	83 ec 08             	sub    $0x8,%esp
  102317:	50                   	push   %eax
  102318:	68 f2 01 00 00       	push   $0x1f2
  10231d:	e8 28 fe ff ff       	call   10214a <outb>
  102322:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
  102325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102328:	0f b6 c0             	movzbl %al,%eax
  10232b:	83 ec 08             	sub    $0x8,%esp
  10232e:	50                   	push   %eax
  10232f:	68 f3 01 00 00       	push   $0x1f3
  102334:	e8 11 fe ff ff       	call   10214a <outb>
  102339:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
  10233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10233f:	c1 f8 08             	sar    $0x8,%eax
  102342:	0f b6 c0             	movzbl %al,%eax
  102345:	83 ec 08             	sub    $0x8,%esp
  102348:	50                   	push   %eax
  102349:	68 f4 01 00 00       	push   $0x1f4
  10234e:	e8 f7 fd ff ff       	call   10214a <outb>
  102353:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
  102356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102359:	c1 f8 10             	sar    $0x10,%eax
  10235c:	0f b6 c0             	movzbl %al,%eax
  10235f:	83 ec 08             	sub    $0x8,%esp
  102362:	50                   	push   %eax
  102363:	68 f5 01 00 00       	push   $0x1f5
  102368:	e8 dd fd ff ff       	call   10214a <outb>
  10236d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  102370:	8b 45 08             	mov    0x8(%ebp),%eax
  102373:	8b 40 04             	mov    0x4(%eax),%eax
  102376:	c1 e0 04             	shl    $0x4,%eax
  102379:	83 e0 10             	and    $0x10,%eax
  10237c:	89 c2                	mov    %eax,%edx
  10237e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102381:	c1 f8 18             	sar    $0x18,%eax
  102384:	83 e0 0f             	and    $0xf,%eax
  102387:	09 d0                	or     %edx,%eax
  102389:	83 c8 e0             	or     $0xffffffe0,%eax
  10238c:	0f b6 c0             	movzbl %al,%eax
  10238f:	83 ec 08             	sub    $0x8,%esp
  102392:	50                   	push   %eax
  102393:	68 f6 01 00 00       	push   $0x1f6
  102398:	e8 ad fd ff ff       	call   10214a <outb>
  10239d:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
  1023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1023a3:	8b 00                	mov    (%eax),%eax
  1023a5:	83 e0 04             	and    $0x4,%eax
  1023a8:	85 c0                	test   %eax,%eax
  1023aa:	74 35                	je     1023e1 <idestart+0x178>
    outb(0x1f7, write_cmd);
  1023ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1023af:	0f b6 c0             	movzbl %al,%eax
  1023b2:	83 ec 08             	sub    $0x8,%esp
  1023b5:	50                   	push   %eax
  1023b6:	68 f7 01 00 00       	push   $0x1f7
  1023bb:	e8 8a fd ff ff       	call   10214a <outb>
  1023c0:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
  1023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1023c6:	83 c0 1c             	add    $0x1c,%eax
  1023c9:	83 ec 04             	sub    $0x4,%esp
  1023cc:	68 80 00 00 00       	push   $0x80
  1023d1:	50                   	push   %eax
  1023d2:	68 f0 01 00 00       	push   $0x1f0
  1023d7:	e8 8f fd ff ff       	call   10216b <outsl>
  1023dc:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
  1023df:	eb 17                	jmp    1023f8 <idestart+0x18f>
    outb(0x1f7, read_cmd);
  1023e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1023e4:	0f b6 c0             	movzbl %al,%eax
  1023e7:	83 ec 08             	sub    $0x8,%esp
  1023ea:	50                   	push   %eax
  1023eb:	68 f7 01 00 00       	push   $0x1f7
  1023f0:	e8 55 fd ff ff       	call   10214a <outb>
  1023f5:	83 c4 10             	add    $0x10,%esp
}
  1023f8:	90                   	nop
  1023f9:	c9                   	leave  
  1023fa:	c3                   	ret    

001023fb <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
  1023fb:	55                   	push   %ebp
  1023fc:	89 e5                	mov    %esp,%ebp
  1023fe:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  if((b = idequeue) == 0){
  102401:	a1 64 9e 10 00       	mov    0x109e64,%eax
  102406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10240d:	74 78                	je     102487 <ideintr+0x8c>
    return;
  }
  idequeue = b->qnext;
  10240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102412:	8b 40 18             	mov    0x18(%eax),%eax
  102415:	a3 64 9e 10 00       	mov    %eax,0x109e64

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  10241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10241d:	8b 00                	mov    (%eax),%eax
  10241f:	83 e0 04             	and    $0x4,%eax
  102422:	85 c0                	test   %eax,%eax
  102424:	75 27                	jne    10244d <ideintr+0x52>
  102426:	6a 01                	push   $0x1
  102428:	e8 6b fd ff ff       	call   102198 <idewait>
  10242d:	83 c4 04             	add    $0x4,%esp
  102430:	85 c0                	test   %eax,%eax
  102432:	78 19                	js     10244d <ideintr+0x52>
    insl(0x1f0, b->data, BSIZE/4);
  102434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102437:	83 c0 1c             	add    $0x1c,%eax
  10243a:	68 80 00 00 00       	push   $0x80
  10243f:	50                   	push   %eax
  102440:	68 f0 01 00 00       	push   $0x1f0
  102445:	e8 da fc ff ff       	call   102124 <insl>
  10244a:	83 c4 0c             	add    $0xc,%esp

  b->flags |= B_VALID;
  10244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102450:	8b 00                	mov    (%eax),%eax
  102452:	83 c8 02             	or     $0x2,%eax
  102455:	89 c2                	mov    %eax,%edx
  102457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10245a:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
  10245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10245f:	8b 00                	mov    (%eax),%eax
  102461:	83 e0 fb             	and    $0xfffffffb,%eax
  102464:	89 c2                	mov    %eax,%edx
  102466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102469:	89 10                	mov    %edx,(%eax)

  // Start disk on next buf in queue.
  if(idequeue != 0)
  10246b:	a1 64 9e 10 00       	mov    0x109e64,%eax
  102470:	85 c0                	test   %eax,%eax
  102472:	74 14                	je     102488 <ideintr+0x8d>
    idestart(idequeue);
  102474:	a1 64 9e 10 00       	mov    0x109e64,%eax
  102479:	83 ec 0c             	sub    $0xc,%esp
  10247c:	50                   	push   %eax
  10247d:	e8 e7 fd ff ff       	call   102269 <idestart>
  102482:	83 c4 10             	add    $0x10,%esp
  102485:	eb 01                	jmp    102488 <ideintr+0x8d>
    return;
  102487:	90                   	nop
}
  102488:	c9                   	leave  
  102489:	c3                   	ret    

0010248a <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  10248a:	55                   	push   %ebp
  10248b:	89 e5                	mov    %esp,%ebp
  10248d:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102490:	8b 45 08             	mov    0x8(%ebp),%eax
  102493:	8b 00                	mov    (%eax),%eax
  102495:	83 e0 06             	and    $0x6,%eax
  102498:	83 f8 02             	cmp    $0x2,%eax
  10249b:	75 0d                	jne    1024aa <iderw+0x20>
    panic("iderw: nothing to do");
  10249d:	83 ec 0c             	sub    $0xc,%esp
  1024a0:	68 1c 43 10 00       	push   $0x10431c
  1024a5:	e8 03 de ff ff       	call   1002ad <panic>
  if(b->dev != 0 && !havedisk1)
  1024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1024ad:	8b 40 04             	mov    0x4(%eax),%eax
  1024b0:	85 c0                	test   %eax,%eax
  1024b2:	74 16                	je     1024ca <iderw+0x40>
  1024b4:	a1 68 9e 10 00       	mov    0x109e68,%eax
  1024b9:	85 c0                	test   %eax,%eax
  1024bb:	75 0d                	jne    1024ca <iderw+0x40>
    panic("iderw: ide disk 1 not present");
  1024bd:	83 ec 0c             	sub    $0xc,%esp
  1024c0:	68 31 43 10 00       	push   $0x104331
  1024c5:	e8 e3 dd ff ff       	call   1002ad <panic>

  // Append b to idequeue.
  b->qnext = 0;
  1024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1024cd:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
  1024d4:	c7 45 f4 64 9e 10 00 	movl   $0x109e64,-0xc(%ebp)
  1024db:	eb 0b                	jmp    1024e8 <iderw+0x5e>
  1024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024e0:	8b 00                	mov    (%eax),%eax
  1024e2:	83 c0 18             	add    $0x18,%eax
  1024e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024eb:	8b 00                	mov    (%eax),%eax
  1024ed:	85 c0                	test   %eax,%eax
  1024ef:	75 ec                	jne    1024dd <iderw+0x53>
    ;
  *pp = b;
  1024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024f4:	8b 55 08             	mov    0x8(%ebp),%edx
  1024f7:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
  1024f9:	a1 64 9e 10 00       	mov    0x109e64,%eax
  1024fe:	39 45 08             	cmp    %eax,0x8(%ebp)
  102501:	75 15                	jne    102518 <iderw+0x8e>
    idestart(b);
  102503:	83 ec 0c             	sub    $0xc,%esp
  102506:	ff 75 08             	push   0x8(%ebp)
  102509:	e8 5b fd ff ff       	call   102269 <idestart>
  10250e:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102511:	eb 05                	jmp    102518 <iderw+0x8e>
  {
    // Warning: If we do not call noop(), compiler generates code that does not
    // read "b->flags" again and therefore never come out of this while loop. 
    // "b->flags" is modified by the trap handler in ideintr().  
    noop();
  102513:	e8 79 fc ff ff       	call   102191 <noop>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102518:	8b 45 08             	mov    0x8(%ebp),%eax
  10251b:	8b 00                	mov    (%eax),%eax
  10251d:	83 e0 06             	and    $0x6,%eax
  102520:	83 f8 02             	cmp    $0x2,%eax
  102523:	75 ee                	jne    102513 <iderw+0x89>
  }
}
  102525:	90                   	nop
  102526:	90                   	nop
  102527:	c9                   	leave  
  102528:	c3                   	ret    

00102529 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  102529:	55                   	push   %ebp
  10252a:	89 e5                	mov    %esp,%ebp
  10252c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
  10252f:	8b 45 08             	mov    0x8(%ebp),%eax
  102532:	83 ec 08             	sub    $0x8,%esp
  102535:	6a 01                	push   $0x1
  102537:	50                   	push   %eax
  102538:	e8 05 fb ff ff       	call   102042 <bread>
  10253d:	83 c4 10             	add    $0x10,%esp
  102540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
  102543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102546:	83 c0 1c             	add    $0x1c,%eax
  102549:	83 ec 04             	sub    $0x4,%esp
  10254c:	6a 1c                	push   $0x1c
  10254e:	50                   	push   %eax
  10254f:	ff 75 0c             	push   0xc(%ebp)
  102552:	e8 ae ea ff ff       	call   101005 <memmove>
  102557:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  10255a:	83 ec 0c             	sub    $0xc,%esp
  10255d:	ff 75 f4             	push   -0xc(%ebp)
  102560:	e8 3c fb ff ff       	call   1020a1 <brelse>
  102565:	83 c4 10             	add    $0x10,%esp
}
  102568:	90                   	nop
  102569:	c9                   	leave  
  10256a:	c3                   	ret    

0010256b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
  10256b:	55                   	push   %ebp
  10256c:	89 e5                	mov    %esp,%ebp
  10256e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
  102571:	8b 55 0c             	mov    0xc(%ebp),%edx
  102574:	8b 45 08             	mov    0x8(%ebp),%eax
  102577:	83 ec 08             	sub    $0x8,%esp
  10257a:	52                   	push   %edx
  10257b:	50                   	push   %eax
  10257c:	e8 c1 fa ff ff       	call   102042 <bread>
  102581:	83 c4 10             	add    $0x10,%esp
  102584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
  102587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10258a:	83 c0 1c             	add    $0x1c,%eax
  10258d:	83 ec 04             	sub    $0x4,%esp
  102590:	68 00 02 00 00       	push   $0x200
  102595:	6a 00                	push   $0x0
  102597:	50                   	push   %eax
  102598:	e8 a9 e9 ff ff       	call   100f46 <memset>
  10259d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  1025a0:	83 ec 0c             	sub    $0xc,%esp
  1025a3:	ff 75 f4             	push   -0xc(%ebp)
  1025a6:	e8 94 1a 00 00       	call   10403f <log_write>
  1025ab:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  1025ae:	83 ec 0c             	sub    $0xc,%esp
  1025b1:	ff 75 f4             	push   -0xc(%ebp)
  1025b4:	e8 e8 fa ff ff       	call   1020a1 <brelse>
  1025b9:	83 c4 10             	add    $0x10,%esp
}
  1025bc:	90                   	nop
  1025bd:	c9                   	leave  
  1025be:	c3                   	ret    

001025bf <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
  1025bf:	55                   	push   %ebp
  1025c0:	89 e5                	mov    %esp,%ebp
  1025c2:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  1025c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
  1025cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1025d3:	e9 0b 01 00 00       	jmp    1026e3 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
  1025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025db:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  1025e1:	85 c0                	test   %eax,%eax
  1025e3:	0f 48 c2             	cmovs  %edx,%eax
  1025e6:	c1 f8 0c             	sar    $0xc,%eax
  1025e9:	89 c2                	mov    %eax,%edx
  1025eb:	a1 98 9e 10 00       	mov    0x109e98,%eax
  1025f0:	01 d0                	add    %edx,%eax
  1025f2:	83 ec 08             	sub    $0x8,%esp
  1025f5:	50                   	push   %eax
  1025f6:	ff 75 08             	push   0x8(%ebp)
  1025f9:	e8 44 fa ff ff       	call   102042 <bread>
  1025fe:	83 c4 10             	add    $0x10,%esp
  102601:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  102604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10260b:	e9 9e 00 00 00       	jmp    1026ae <balloc+0xef>
      m = 1 << (bi % 8);
  102610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102613:	83 e0 07             	and    $0x7,%eax
  102616:	ba 01 00 00 00       	mov    $0x1,%edx
  10261b:	89 c1                	mov    %eax,%ecx
  10261d:	d3 e2                	shl    %cl,%edx
  10261f:	89 d0                	mov    %edx,%eax
  102621:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  102624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102627:	8d 50 07             	lea    0x7(%eax),%edx
  10262a:	85 c0                	test   %eax,%eax
  10262c:	0f 48 c2             	cmovs  %edx,%eax
  10262f:	c1 f8 03             	sar    $0x3,%eax
  102632:	89 c2                	mov    %eax,%edx
  102634:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102637:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  10263c:	0f b6 c0             	movzbl %al,%eax
  10263f:	23 45 e8             	and    -0x18(%ebp),%eax
  102642:	85 c0                	test   %eax,%eax
  102644:	75 64                	jne    1026aa <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
  102646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102649:	8d 50 07             	lea    0x7(%eax),%edx
  10264c:	85 c0                	test   %eax,%eax
  10264e:	0f 48 c2             	cmovs  %edx,%eax
  102651:	c1 f8 03             	sar    $0x3,%eax
  102654:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102657:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  10265c:	89 d1                	mov    %edx,%ecx
  10265e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102661:	09 ca                	or     %ecx,%edx
  102663:	89 d1                	mov    %edx,%ecx
  102665:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102668:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
        log_write(bp);
  10266c:	83 ec 0c             	sub    $0xc,%esp
  10266f:	ff 75 ec             	push   -0x14(%ebp)
  102672:	e8 c8 19 00 00       	call   10403f <log_write>
  102677:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
  10267a:	83 ec 0c             	sub    $0xc,%esp
  10267d:	ff 75 ec             	push   -0x14(%ebp)
  102680:	e8 1c fa ff ff       	call   1020a1 <brelse>
  102685:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
  102688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10268e:	01 c2                	add    %eax,%edx
  102690:	8b 45 08             	mov    0x8(%ebp),%eax
  102693:	83 ec 08             	sub    $0x8,%esp
  102696:	52                   	push   %edx
  102697:	50                   	push   %eax
  102698:	e8 ce fe ff ff       	call   10256b <bzero>
  10269d:	83 c4 10             	add    $0x10,%esp
        return b + bi;
  1026a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1026a6:	01 d0                	add    %edx,%eax
  1026a8:	eb 57                	jmp    102701 <balloc+0x142>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  1026aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1026ae:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
  1026b5:	7f 17                	jg     1026ce <balloc+0x10f>
  1026b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1026ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1026bd:	01 d0                	add    %edx,%eax
  1026bf:	89 c2                	mov    %eax,%edx
  1026c1:	a1 80 9e 10 00       	mov    0x109e80,%eax
  1026c6:	39 c2                	cmp    %eax,%edx
  1026c8:	0f 82 42 ff ff ff    	jb     102610 <balloc+0x51>
      }
    }
    brelse(bp);
  1026ce:	83 ec 0c             	sub    $0xc,%esp
  1026d1:	ff 75 ec             	push   -0x14(%ebp)
  1026d4:	e8 c8 f9 ff ff       	call   1020a1 <brelse>
  1026d9:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
  1026dc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1026e3:	8b 15 80 9e 10 00    	mov    0x109e80,%edx
  1026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026ec:	39 c2                	cmp    %eax,%edx
  1026ee:	0f 87 e4 fe ff ff    	ja     1025d8 <balloc+0x19>
  }
  panic("balloc: out of blocks");
  1026f4:	83 ec 0c             	sub    $0xc,%esp
  1026f7:	68 50 43 10 00       	push   $0x104350
  1026fc:	e8 ac db ff ff       	call   1002ad <panic>
}
  102701:	c9                   	leave  
  102702:	c3                   	ret    

00102703 <bfree>:


// Free a disk block.
static void
bfree(int dev, uint b)
{
  102703:	55                   	push   %ebp
  102704:	89 e5                	mov    %esp,%ebp
  102706:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  102709:	8b 45 0c             	mov    0xc(%ebp),%eax
  10270c:	c1 e8 0c             	shr    $0xc,%eax
  10270f:	89 c2                	mov    %eax,%edx
  102711:	a1 98 9e 10 00       	mov    0x109e98,%eax
  102716:	01 c2                	add    %eax,%edx
  102718:	8b 45 08             	mov    0x8(%ebp),%eax
  10271b:	83 ec 08             	sub    $0x8,%esp
  10271e:	52                   	push   %edx
  10271f:	50                   	push   %eax
  102720:	e8 1d f9 ff ff       	call   102042 <bread>
  102725:	83 c4 10             	add    $0x10,%esp
  102728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
  10272b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10272e:	25 ff 0f 00 00       	and    $0xfff,%eax
  102733:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
  102736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102739:	83 e0 07             	and    $0x7,%eax
  10273c:	ba 01 00 00 00       	mov    $0x1,%edx
  102741:	89 c1                	mov    %eax,%ecx
  102743:	d3 e2                	shl    %cl,%edx
  102745:	89 d0                	mov    %edx,%eax
  102747:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
  10274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10274d:	8d 50 07             	lea    0x7(%eax),%edx
  102750:	85 c0                	test   %eax,%eax
  102752:	0f 48 c2             	cmovs  %edx,%eax
  102755:	c1 f8 03             	sar    $0x3,%eax
  102758:	89 c2                	mov    %eax,%edx
  10275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10275d:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  102762:	0f b6 c0             	movzbl %al,%eax
  102765:	23 45 ec             	and    -0x14(%ebp),%eax
  102768:	85 c0                	test   %eax,%eax
  10276a:	75 0d                	jne    102779 <bfree+0x76>
    panic("freeing free block");
  10276c:	83 ec 0c             	sub    $0xc,%esp
  10276f:	68 66 43 10 00       	push   $0x104366
  102774:	e8 34 db ff ff       	call   1002ad <panic>
  bp->data[bi/8] &= ~m;
  102779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10277c:	8d 50 07             	lea    0x7(%eax),%edx
  10277f:	85 c0                	test   %eax,%eax
  102781:	0f 48 c2             	cmovs  %edx,%eax
  102784:	c1 f8 03             	sar    $0x3,%eax
  102787:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10278a:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  10278f:	89 d1                	mov    %edx,%ecx
  102791:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102794:	f7 d2                	not    %edx
  102796:	21 ca                	and    %ecx,%edx
  102798:	89 d1                	mov    %edx,%ecx
  10279a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10279d:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
  log_write(bp);
  1027a1:	83 ec 0c             	sub    $0xc,%esp
  1027a4:	ff 75 f4             	push   -0xc(%ebp)
  1027a7:	e8 93 18 00 00       	call   10403f <log_write>
  1027ac:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  1027af:	83 ec 0c             	sub    $0xc,%esp
  1027b2:	ff 75 f4             	push   -0xc(%ebp)
  1027b5:	e8 e7 f8 ff ff       	call   1020a1 <brelse>
  1027ba:	83 c4 10             	add    $0x10,%esp
}
  1027bd:	90                   	nop
  1027be:	c9                   	leave  
  1027bf:	c3                   	ret    

001027c0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
  1027c0:	55                   	push   %ebp
  1027c1:	89 e5                	mov    %esp,%ebp
  1027c3:	57                   	push   %edi
  1027c4:	56                   	push   %esi
  1027c5:	53                   	push   %ebx
  1027c6:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
  1027c9:	83 ec 08             	sub    $0x8,%esp
  1027cc:	68 80 9e 10 00       	push   $0x109e80
  1027d1:	ff 75 08             	push   0x8(%ebp)
  1027d4:	e8 50 fd ff ff       	call   102529 <readsb>
  1027d9:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
  1027dc:	a1 98 9e 10 00       	mov    0x109e98,%eax
  1027e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1027e4:	8b 3d 94 9e 10 00    	mov    0x109e94,%edi
  1027ea:	8b 35 90 9e 10 00    	mov    0x109e90,%esi
  1027f0:	8b 1d 8c 9e 10 00    	mov    0x109e8c,%ebx
  1027f6:	8b 0d 88 9e 10 00    	mov    0x109e88,%ecx
  1027fc:	8b 15 84 9e 10 00    	mov    0x109e84,%edx
  102802:	a1 80 9e 10 00       	mov    0x109e80,%eax
  102807:	ff 75 e4             	push   -0x1c(%ebp)
  10280a:	57                   	push   %edi
  10280b:	56                   	push   %esi
  10280c:	53                   	push   %ebx
  10280d:	51                   	push   %ecx
  10280e:	52                   	push   %edx
  10280f:	50                   	push   %eax
  102810:	68 7c 43 10 00       	push   $0x10437c
  102815:	e8 d2 d8 ff ff       	call   1000ec <cprintf>
  10281a:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
  10281d:	90                   	nop
  10281e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  102821:	5b                   	pop    %ebx
  102822:	5e                   	pop    %esi
  102823:	5f                   	pop    %edi
  102824:	5d                   	pop    %ebp
  102825:	c3                   	ret    

00102826 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
  102826:	55                   	push   %ebp
  102827:	89 e5                	mov    %esp,%ebp
  102829:	83 ec 28             	sub    $0x28,%esp
  10282c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10282f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
  102833:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  10283a:	e9 9e 00 00 00       	jmp    1028dd <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
  10283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102842:	c1 e8 03             	shr    $0x3,%eax
  102845:	89 c2                	mov    %eax,%edx
  102847:	a1 94 9e 10 00       	mov    0x109e94,%eax
  10284c:	01 d0                	add    %edx,%eax
  10284e:	83 ec 08             	sub    $0x8,%esp
  102851:	50                   	push   %eax
  102852:	ff 75 08             	push   0x8(%ebp)
  102855:	e8 e8 f7 ff ff       	call   102042 <bread>
  10285a:	83 c4 10             	add    $0x10,%esp
  10285d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
  102860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102863:	8d 50 1c             	lea    0x1c(%eax),%edx
  102866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102869:	83 e0 07             	and    $0x7,%eax
  10286c:	c1 e0 06             	shl    $0x6,%eax
  10286f:	01 d0                	add    %edx,%eax
  102871:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
  102874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102877:	0f b7 00             	movzwl (%eax),%eax
  10287a:	66 85 c0             	test   %ax,%ax
  10287d:	75 4c                	jne    1028cb <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
  10287f:	83 ec 04             	sub    $0x4,%esp
  102882:	6a 40                	push   $0x40
  102884:	6a 00                	push   $0x0
  102886:	ff 75 ec             	push   -0x14(%ebp)
  102889:	e8 b8 e6 ff ff       	call   100f46 <memset>
  10288e:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
  102891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102894:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  102898:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
  10289b:	83 ec 0c             	sub    $0xc,%esp
  10289e:	ff 75 f0             	push   -0x10(%ebp)
  1028a1:	e8 99 17 00 00       	call   10403f <log_write>
  1028a6:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
  1028a9:	83 ec 0c             	sub    $0xc,%esp
  1028ac:	ff 75 f0             	push   -0x10(%ebp)
  1028af:	e8 ed f7 ff ff       	call   1020a1 <brelse>
  1028b4:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
  1028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028ba:	83 ec 08             	sub    $0x8,%esp
  1028bd:	50                   	push   %eax
  1028be:	ff 75 08             	push   0x8(%ebp)
  1028c1:	e8 64 01 00 00       	call   102a2a <iget>
  1028c6:	83 c4 10             	add    $0x10,%esp
  1028c9:	eb 30                	jmp    1028fb <ialloc+0xd5>
    }
    brelse(bp);
  1028cb:	83 ec 0c             	sub    $0xc,%esp
  1028ce:	ff 75 f0             	push   -0x10(%ebp)
  1028d1:	e8 cb f7 ff ff       	call   1020a1 <brelse>
  1028d6:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
  1028d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1028dd:	8b 15 88 9e 10 00    	mov    0x109e88,%edx
  1028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028e6:	39 c2                	cmp    %eax,%edx
  1028e8:	0f 87 51 ff ff ff    	ja     10283f <ialloc+0x19>
  }
  panic("ialloc: no inodes");
  1028ee:	83 ec 0c             	sub    $0xc,%esp
  1028f1:	68 cf 43 10 00       	push   $0x1043cf
  1028f6:	e8 b2 d9 ff ff       	call   1002ad <panic>
}
  1028fb:	c9                   	leave  
  1028fc:	c3                   	ret    

001028fd <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
  1028fd:	55                   	push   %ebp
  1028fe:	89 e5                	mov    %esp,%ebp
  102900:	83 ec 18             	sub    $0x18,%esp
  if(ip->valid && ip->nlink == 0){
  102903:	8b 45 08             	mov    0x8(%ebp),%eax
  102906:	8b 40 0c             	mov    0xc(%eax),%eax
  102909:	85 c0                	test   %eax,%eax
  10290b:	74 4a                	je     102957 <iput+0x5a>
  10290d:	8b 45 08             	mov    0x8(%ebp),%eax
  102910:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  102914:	66 85 c0             	test   %ax,%ax
  102917:	75 3e                	jne    102957 <iput+0x5a>
    int r = ip->ref;
  102919:	8b 45 08             	mov    0x8(%ebp),%eax
  10291c:	8b 40 08             	mov    0x8(%eax),%eax
  10291f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(r == 1){
  102922:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102926:	75 2f                	jne    102957 <iput+0x5a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
  102928:	83 ec 0c             	sub    $0xc,%esp
  10292b:	ff 75 08             	push   0x8(%ebp)
  10292e:	e8 c1 03 00 00       	call   102cf4 <itrunc>
  102933:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
  102936:	8b 45 08             	mov    0x8(%ebp),%eax
  102939:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
      iupdate(ip);
  10293f:	83 ec 0c             	sub    $0xc,%esp
  102942:	ff 75 08             	push   0x8(%ebp)
  102945:	e8 1f 00 00 00       	call   102969 <iupdate>
  10294a:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
  10294d:	8b 45 08             	mov    0x8(%ebp),%eax
  102950:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    }
  }
  ip->ref--;
  102957:	8b 45 08             	mov    0x8(%ebp),%eax
  10295a:	8b 40 08             	mov    0x8(%eax),%eax
  10295d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102960:	8b 45 08             	mov    0x8(%ebp),%eax
  102963:	89 50 08             	mov    %edx,0x8(%eax)
}
  102966:	90                   	nop
  102967:	c9                   	leave  
  102968:	c3                   	ret    

00102969 <iupdate>:
// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
void
iupdate(struct inode *ip)
{
  102969:	55                   	push   %ebp
  10296a:	89 e5                	mov    %esp,%ebp
  10296c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  10296f:	8b 45 08             	mov    0x8(%ebp),%eax
  102972:	8b 40 04             	mov    0x4(%eax),%eax
  102975:	c1 e8 03             	shr    $0x3,%eax
  102978:	89 c2                	mov    %eax,%edx
  10297a:	a1 94 9e 10 00       	mov    0x109e94,%eax
  10297f:	01 c2                	add    %eax,%edx
  102981:	8b 45 08             	mov    0x8(%ebp),%eax
  102984:	8b 00                	mov    (%eax),%eax
  102986:	83 ec 08             	sub    $0x8,%esp
  102989:	52                   	push   %edx
  10298a:	50                   	push   %eax
  10298b:	e8 b2 f6 ff ff       	call   102042 <bread>
  102990:	83 c4 10             	add    $0x10,%esp
  102993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  102996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102999:	8d 50 1c             	lea    0x1c(%eax),%edx
  10299c:	8b 45 08             	mov    0x8(%ebp),%eax
  10299f:	8b 40 04             	mov    0x4(%eax),%eax
  1029a2:	83 e0 07             	and    $0x7,%eax
  1029a5:	c1 e0 06             	shl    $0x6,%eax
  1029a8:	01 d0                	add    %edx,%eax
  1029aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
  1029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b0:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  1029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b7:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  1029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bd:	0f b7 50 12          	movzwl 0x12(%eax),%edx
  1029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029c4:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  1029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cb:	0f b7 50 14          	movzwl 0x14(%eax),%edx
  1029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029d2:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  1029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d9:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  1029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029e0:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  1029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e7:	8b 50 18             	mov    0x18(%eax),%edx
  1029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029ed:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f3:	8d 50 1c             	lea    0x1c(%eax),%edx
  1029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029f9:	83 c0 0c             	add    $0xc,%eax
  1029fc:	83 ec 04             	sub    $0x4,%esp
  1029ff:	6a 34                	push   $0x34
  102a01:	52                   	push   %edx
  102a02:	50                   	push   %eax
  102a03:	e8 fd e5 ff ff       	call   101005 <memmove>
  102a08:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  102a0b:	83 ec 0c             	sub    $0xc,%esp
  102a0e:	ff 75 f4             	push   -0xc(%ebp)
  102a11:	e8 29 16 00 00       	call   10403f <log_write>
  102a16:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102a19:	83 ec 0c             	sub    $0xc,%esp
  102a1c:	ff 75 f4             	push   -0xc(%ebp)
  102a1f:	e8 7d f6 ff ff       	call   1020a1 <brelse>
  102a24:	83 c4 10             	add    $0x10,%esp
}
  102a27:	90                   	nop
  102a28:	c9                   	leave  
  102a29:	c3                   	ret    

00102a2a <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
struct inode*
iget(uint dev, uint inum)
{
  102a2a:	55                   	push   %ebp
  102a2b:	89 e5                	mov    %esp,%ebp
  102a2d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  // Is the inode already cached?
  empty = 0;
  102a30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  102a37:	c7 45 f4 a0 9e 10 00 	movl   $0x109ea0,-0xc(%ebp)
  102a3e:	eb 4d                	jmp    102a8d <iget+0x63>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  102a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a43:	8b 40 08             	mov    0x8(%eax),%eax
  102a46:	85 c0                	test   %eax,%eax
  102a48:	7e 29                	jle    102a73 <iget+0x49>
  102a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a4d:	8b 00                	mov    (%eax),%eax
  102a4f:	39 45 08             	cmp    %eax,0x8(%ebp)
  102a52:	75 1f                	jne    102a73 <iget+0x49>
  102a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a57:	8b 40 04             	mov    0x4(%eax),%eax
  102a5a:	39 45 0c             	cmp    %eax,0xc(%ebp)
  102a5d:	75 14                	jne    102a73 <iget+0x49>
      ip->ref++;
  102a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a62:	8b 40 08             	mov    0x8(%eax),%eax
  102a65:	8d 50 01             	lea    0x1(%eax),%edx
  102a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a6b:	89 50 08             	mov    %edx,0x8(%eax)
      return ip;
  102a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a71:	eb 64                	jmp    102ad7 <iget+0xad>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  102a73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a77:	75 10                	jne    102a89 <iget+0x5f>
  102a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a7c:	8b 40 08             	mov    0x8(%eax),%eax
  102a7f:	85 c0                	test   %eax,%eax
  102a81:	75 06                	jne    102a89 <iget+0x5f>
      empty = ip;
  102a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  102a89:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
  102a8d:	81 7d f4 40 ae 10 00 	cmpl   $0x10ae40,-0xc(%ebp)
  102a94:	72 aa                	jb     102a40 <iget+0x16>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
  102a96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a9a:	75 0d                	jne    102aa9 <iget+0x7f>
    panic("iget: no inodes");
  102a9c:	83 ec 0c             	sub    $0xc,%esp
  102a9f:	68 e1 43 10 00       	push   $0x1043e1
  102aa4:	e8 04 d8 ff ff       	call   1002ad <panic>

  ip = empty;
  102aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
  102aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  102ab5:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
  102ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  102abd:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
  102ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
  102aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102acd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

  return ip;
  102ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ad7:	c9                   	leave  
  102ad8:	c3                   	ret    

00102ad9 <iread>:

// Reads the inode from disk if necessary.
void
iread(struct inode *ip)
{
  102ad9:	55                   	push   %ebp
  102ada:	89 e5                	mov    %esp,%ebp
  102adc:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  102adf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ae3:	74 0a                	je     102aef <iread+0x16>
  102ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae8:	8b 40 08             	mov    0x8(%eax),%eax
  102aeb:	85 c0                	test   %eax,%eax
  102aed:	7f 0d                	jg     102afc <iread+0x23>
    panic("iread");
  102aef:	83 ec 0c             	sub    $0xc,%esp
  102af2:	68 f1 43 10 00       	push   $0x1043f1
  102af7:	e8 b1 d7 ff ff       	call   1002ad <panic>

  if(ip->valid == 0){
  102afc:	8b 45 08             	mov    0x8(%ebp),%eax
  102aff:	8b 40 0c             	mov    0xc(%eax),%eax
  102b02:	85 c0                	test   %eax,%eax
  102b04:	0f 85 cd 00 00 00    	jne    102bd7 <iread+0xfe>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  102b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0d:	8b 40 04             	mov    0x4(%eax),%eax
  102b10:	c1 e8 03             	shr    $0x3,%eax
  102b13:	89 c2                	mov    %eax,%edx
  102b15:	a1 94 9e 10 00       	mov    0x109e94,%eax
  102b1a:	01 c2                	add    %eax,%edx
  102b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1f:	8b 00                	mov    (%eax),%eax
  102b21:	83 ec 08             	sub    $0x8,%esp
  102b24:	52                   	push   %edx
  102b25:	50                   	push   %eax
  102b26:	e8 17 f5 ff ff       	call   102042 <bread>
  102b2b:	83 c4 10             	add    $0x10,%esp
  102b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  102b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b34:	8d 50 1c             	lea    0x1c(%eax),%edx
  102b37:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3a:	8b 40 04             	mov    0x4(%eax),%eax
  102b3d:	83 e0 07             	and    $0x7,%eax
  102b40:	c1 e0 06             	shl    $0x6,%eax
  102b43:	01 d0                	add    %edx,%eax
  102b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
  102b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b4b:	0f b7 10             	movzwl (%eax),%edx
  102b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b51:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
  102b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b58:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  102b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5f:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
  102b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b66:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6d:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
  102b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b74:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  102b78:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7b:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
  102b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b82:	8b 50 08             	mov    0x8(%eax),%edx
  102b85:	8b 45 08             	mov    0x8(%ebp),%eax
  102b88:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  102b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b8e:	8d 50 0c             	lea    0xc(%eax),%edx
  102b91:	8b 45 08             	mov    0x8(%ebp),%eax
  102b94:	83 c0 1c             	add    $0x1c,%eax
  102b97:	83 ec 04             	sub    $0x4,%esp
  102b9a:	6a 34                	push   $0x34
  102b9c:	52                   	push   %edx
  102b9d:	50                   	push   %eax
  102b9e:	e8 62 e4 ff ff       	call   101005 <memmove>
  102ba3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102ba6:	83 ec 0c             	sub    $0xc,%esp
  102ba9:	ff 75 f4             	push   -0xc(%ebp)
  102bac:	e8 f0 f4 ff ff       	call   1020a1 <brelse>
  102bb1:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
  102bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb7:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if(ip->type == 0)
  102bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  102bc5:	66 85 c0             	test   %ax,%ax
  102bc8:	75 0d                	jne    102bd7 <iread+0xfe>
      panic("iread: no type");
  102bca:	83 ec 0c             	sub    $0xc,%esp
  102bcd:	68 f7 43 10 00       	push   $0x1043f7
  102bd2:	e8 d6 d6 ff ff       	call   1002ad <panic>
  }
}
  102bd7:	90                   	nop
  102bd8:	c9                   	leave  
  102bd9:	c3                   	ret    

00102bda <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  102bda:	55                   	push   %ebp
  102bdb:	89 e5                	mov    %esp,%ebp
  102bdd:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  102be0:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
  102be4:	77 42                	ja     102c28 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
  102be6:	8b 45 08             	mov    0x8(%ebp),%eax
  102be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bec:	83 c2 04             	add    $0x4,%edx
  102bef:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102bfa:	75 24                	jne    102c20 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
  102bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bff:	8b 00                	mov    (%eax),%eax
  102c01:	83 ec 0c             	sub    $0xc,%esp
  102c04:	50                   	push   %eax
  102c05:	e8 b5 f9 ff ff       	call   1025bf <balloc>
  102c0a:	83 c4 10             	add    $0x10,%esp
  102c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c10:	8b 45 08             	mov    0x8(%ebp),%eax
  102c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c16:	8d 4a 04             	lea    0x4(%edx),%ecx
  102c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c1c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
  102c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c23:	e9 ca 00 00 00       	jmp    102cf2 <bmap+0x118>
  }
  bn -= NDIRECT;
  102c28:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
  102c2c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
  102c30:	0f 87 af 00 00 00    	ja     102ce5 <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  102c36:	8b 45 08             	mov    0x8(%ebp),%eax
  102c39:	8b 40 4c             	mov    0x4c(%eax),%eax
  102c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c43:	75 1d                	jne    102c62 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  102c45:	8b 45 08             	mov    0x8(%ebp),%eax
  102c48:	8b 00                	mov    (%eax),%eax
  102c4a:	83 ec 0c             	sub    $0xc,%esp
  102c4d:	50                   	push   %eax
  102c4e:	e8 6c f9 ff ff       	call   1025bf <balloc>
  102c53:	83 c4 10             	add    $0x10,%esp
  102c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c59:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c5f:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
  102c62:	8b 45 08             	mov    0x8(%ebp),%eax
  102c65:	8b 00                	mov    (%eax),%eax
  102c67:	83 ec 08             	sub    $0x8,%esp
  102c6a:	ff 75 f4             	push   -0xc(%ebp)
  102c6d:	50                   	push   %eax
  102c6e:	e8 cf f3 ff ff       	call   102042 <bread>
  102c73:	83 c4 10             	add    $0x10,%esp
  102c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  102c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c7c:	83 c0 1c             	add    $0x1c,%eax
  102c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
  102c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c8f:	01 d0                	add    %edx,%eax
  102c91:	8b 00                	mov    (%eax),%eax
  102c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c9a:	75 36                	jne    102cd2 <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
  102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9f:	8b 00                	mov    (%eax),%eax
  102ca1:	83 ec 0c             	sub    $0xc,%esp
  102ca4:	50                   	push   %eax
  102ca5:	e8 15 f9 ff ff       	call   1025bf <balloc>
  102caa:	83 c4 10             	add    $0x10,%esp
  102cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cbd:	01 c2                	add    %eax,%edx
  102cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cc2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
  102cc4:	83 ec 0c             	sub    $0xc,%esp
  102cc7:	ff 75 f0             	push   -0x10(%ebp)
  102cca:	e8 70 13 00 00       	call   10403f <log_write>
  102ccf:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  102cd2:	83 ec 0c             	sub    $0xc,%esp
  102cd5:	ff 75 f0             	push   -0x10(%ebp)
  102cd8:	e8 c4 f3 ff ff       	call   1020a1 <brelse>
  102cdd:	83 c4 10             	add    $0x10,%esp
    return addr;
  102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce3:	eb 0d                	jmp    102cf2 <bmap+0x118>
  }

  panic("bmap: out of range");
  102ce5:	83 ec 0c             	sub    $0xc,%esp
  102ce8:	68 06 44 10 00       	push   $0x104406
  102ced:	e8 bb d5 ff ff       	call   1002ad <panic>
}
  102cf2:	c9                   	leave  
  102cf3:	c3                   	ret    

00102cf4 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
  102cf4:	55                   	push   %ebp
  102cf5:	89 e5                	mov    %esp,%ebp
  102cf7:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  102cfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102d01:	eb 45                	jmp    102d48 <itrunc+0x54>
    if(ip->addrs[i]){
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d09:	83 c2 04             	add    $0x4,%edx
  102d0c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102d10:	85 c0                	test   %eax,%eax
  102d12:	74 30                	je     102d44 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
  102d14:	8b 45 08             	mov    0x8(%ebp),%eax
  102d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d1a:	83 c2 04             	add    $0x4,%edx
  102d1d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102d21:	8b 55 08             	mov    0x8(%ebp),%edx
  102d24:	8b 12                	mov    (%edx),%edx
  102d26:	83 ec 08             	sub    $0x8,%esp
  102d29:	50                   	push   %eax
  102d2a:	52                   	push   %edx
  102d2b:	e8 d3 f9 ff ff       	call   102703 <bfree>
  102d30:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
  102d33:	8b 45 08             	mov    0x8(%ebp),%eax
  102d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d39:	83 c2 04             	add    $0x4,%edx
  102d3c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
  102d43:	00 
  for(i = 0; i < NDIRECT; i++){
  102d44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102d48:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
  102d4c:	7e b5                	jle    102d03 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
  102d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d51:	8b 40 4c             	mov    0x4c(%eax),%eax
  102d54:	85 c0                	test   %eax,%eax
  102d56:	0f 84 a1 00 00 00    	je     102dfd <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5f:	8b 50 4c             	mov    0x4c(%eax),%edx
  102d62:	8b 45 08             	mov    0x8(%ebp),%eax
  102d65:	8b 00                	mov    (%eax),%eax
  102d67:	83 ec 08             	sub    $0x8,%esp
  102d6a:	52                   	push   %edx
  102d6b:	50                   	push   %eax
  102d6c:	e8 d1 f2 ff ff       	call   102042 <bread>
  102d71:	83 c4 10             	add    $0x10,%esp
  102d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
  102d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d7a:	83 c0 1c             	add    $0x1c,%eax
  102d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
  102d80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102d87:	eb 3c                	jmp    102dc5 <itrunc+0xd1>
      if(a[j])
  102d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d96:	01 d0                	add    %edx,%eax
  102d98:	8b 00                	mov    (%eax),%eax
  102d9a:	85 c0                	test   %eax,%eax
  102d9c:	74 23                	je     102dc1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
  102d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dab:	01 d0                	add    %edx,%eax
  102dad:	8b 00                	mov    (%eax),%eax
  102daf:	8b 55 08             	mov    0x8(%ebp),%edx
  102db2:	8b 12                	mov    (%edx),%edx
  102db4:	83 ec 08             	sub    $0x8,%esp
  102db7:	50                   	push   %eax
  102db8:	52                   	push   %edx
  102db9:	e8 45 f9 ff ff       	call   102703 <bfree>
  102dbe:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
  102dc1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc8:	83 f8 7f             	cmp    $0x7f,%eax
  102dcb:	76 bc                	jbe    102d89 <itrunc+0x95>
    }
    brelse(bp);
  102dcd:	83 ec 0c             	sub    $0xc,%esp
  102dd0:	ff 75 ec             	push   -0x14(%ebp)
  102dd3:	e8 c9 f2 ff ff       	call   1020a1 <brelse>
  102dd8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
  102ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dde:	8b 40 4c             	mov    0x4c(%eax),%eax
  102de1:	8b 55 08             	mov    0x8(%ebp),%edx
  102de4:	8b 12                	mov    (%edx),%edx
  102de6:	83 ec 08             	sub    $0x8,%esp
  102de9:	50                   	push   %eax
  102dea:	52                   	push   %edx
  102deb:	e8 13 f9 ff ff       	call   102703 <bfree>
  102df0:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
  102df3:	8b 45 08             	mov    0x8(%ebp),%eax
  102df6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
  102dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102e00:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
  102e07:	83 ec 0c             	sub    $0xc,%esp
  102e0a:	ff 75 08             	push   0x8(%ebp)
  102e0d:	e8 57 fb ff ff       	call   102969 <iupdate>
  102e12:	83 c4 10             	add    $0x10,%esp
}
  102e15:	90                   	nop
  102e16:	c9                   	leave  
  102e17:	c3                   	ret    

00102e18 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
  102e18:	55                   	push   %ebp
  102e19:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
  102e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1e:	8b 00                	mov    (%eax),%eax
  102e20:	89 c2                	mov    %eax,%edx
  102e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e25:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
  102e28:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2b:	8b 50 04             	mov    0x4(%eax),%edx
  102e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e31:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
  102e34:	8b 45 08             	mov    0x8(%ebp),%eax
  102e37:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  102e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
  102e41:	8b 45 08             	mov    0x8(%ebp),%eax
  102e44:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  102e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
  102e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e52:	8b 50 18             	mov    0x18(%eax),%edx
  102e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e58:	89 50 10             	mov    %edx,0x10(%eax)
}
  102e5b:	90                   	nop
  102e5c:	5d                   	pop    %ebp
  102e5d:	c3                   	ret    

00102e5e <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  102e5e:	55                   	push   %ebp
  102e5f:	89 e5                	mov    %esp,%ebp
  102e61:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  102e64:	8b 45 08             	mov    0x8(%ebp),%eax
  102e67:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  102e6b:	66 83 f8 03          	cmp    $0x3,%ax
  102e6f:	75 5c                	jne    102ecd <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  102e71:	8b 45 08             	mov    0x8(%ebp),%eax
  102e74:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102e78:	66 85 c0             	test   %ax,%ax
  102e7b:	78 20                	js     102e9d <readi+0x3f>
  102e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e80:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102e84:	66 83 f8 09          	cmp    $0x9,%ax
  102e88:	7f 13                	jg     102e9d <readi+0x3f>
  102e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102e91:	98                   	cwtl   
  102e92:	8b 04 c5 40 ae 10 00 	mov    0x10ae40(,%eax,8),%eax
  102e99:	85 c0                	test   %eax,%eax
  102e9b:	75 0a                	jne    102ea7 <readi+0x49>
      return -1;
  102e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102ea2:	e9 16 01 00 00       	jmp    102fbd <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
  102ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eaa:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102eae:	98                   	cwtl   
  102eaf:	8b 04 c5 40 ae 10 00 	mov    0x10ae40(,%eax,8),%eax
  102eb6:	8b 55 14             	mov    0x14(%ebp),%edx
  102eb9:	83 ec 04             	sub    $0x4,%esp
  102ebc:	52                   	push   %edx
  102ebd:	ff 75 0c             	push   0xc(%ebp)
  102ec0:	ff 75 08             	push   0x8(%ebp)
  102ec3:	ff d0                	call   *%eax
  102ec5:	83 c4 10             	add    $0x10,%esp
  102ec8:	e9 f0 00 00 00       	jmp    102fbd <readi+0x15f>
  }

  if(off > ip->size || off + n < off || ip->nlink < 1)
  102ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed0:	8b 40 18             	mov    0x18(%eax),%eax
  102ed3:	39 45 10             	cmp    %eax,0x10(%ebp)
  102ed6:	77 19                	ja     102ef1 <readi+0x93>
  102ed8:	8b 55 10             	mov    0x10(%ebp),%edx
  102edb:	8b 45 14             	mov    0x14(%ebp),%eax
  102ede:	01 d0                	add    %edx,%eax
  102ee0:	39 45 10             	cmp    %eax,0x10(%ebp)
  102ee3:	77 0c                	ja     102ef1 <readi+0x93>
  102ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  102eec:	66 85 c0             	test   %ax,%ax
  102eef:	7f 0a                	jg     102efb <readi+0x9d>
    return -1;
  102ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102ef6:	e9 c2 00 00 00       	jmp    102fbd <readi+0x15f>
  if(off + n > ip->size)
  102efb:	8b 55 10             	mov    0x10(%ebp),%edx
  102efe:	8b 45 14             	mov    0x14(%ebp),%eax
  102f01:	01 c2                	add    %eax,%edx
  102f03:	8b 45 08             	mov    0x8(%ebp),%eax
  102f06:	8b 40 18             	mov    0x18(%eax),%eax
  102f09:	39 c2                	cmp    %eax,%edx
  102f0b:	76 0c                	jbe    102f19 <readi+0xbb>
    n = ip->size - off;
  102f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f10:	8b 40 18             	mov    0x18(%eax),%eax
  102f13:	2b 45 10             	sub    0x10(%ebp),%eax
  102f16:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  102f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f20:	e9 89 00 00 00       	jmp    102fae <readi+0x150>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  102f25:	8b 45 10             	mov    0x10(%ebp),%eax
  102f28:	c1 e8 09             	shr    $0x9,%eax
  102f2b:	83 ec 08             	sub    $0x8,%esp
  102f2e:	50                   	push   %eax
  102f2f:	ff 75 08             	push   0x8(%ebp)
  102f32:	e8 a3 fc ff ff       	call   102bda <bmap>
  102f37:	83 c4 10             	add    $0x10,%esp
  102f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3d:	8b 12                	mov    (%edx),%edx
  102f3f:	83 ec 08             	sub    $0x8,%esp
  102f42:	50                   	push   %eax
  102f43:	52                   	push   %edx
  102f44:	e8 f9 f0 ff ff       	call   102042 <bread>
  102f49:	83 c4 10             	add    $0x10,%esp
  102f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  102f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  102f52:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f57:	ba 00 02 00 00       	mov    $0x200,%edx
  102f5c:	29 c2                	sub    %eax,%edx
  102f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  102f61:	2b 45 f4             	sub    -0xc(%ebp),%eax
  102f64:	39 c2                	cmp    %eax,%edx
  102f66:	0f 46 c2             	cmovbe %edx,%eax
  102f69:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
  102f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6f:	8d 50 1c             	lea    0x1c(%eax),%edx
  102f72:	8b 45 10             	mov    0x10(%ebp),%eax
  102f75:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f7a:	01 d0                	add    %edx,%eax
  102f7c:	83 ec 04             	sub    $0x4,%esp
  102f7f:	ff 75 ec             	push   -0x14(%ebp)
  102f82:	50                   	push   %eax
  102f83:	ff 75 0c             	push   0xc(%ebp)
  102f86:	e8 7a e0 ff ff       	call   101005 <memmove>
  102f8b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102f8e:	83 ec 0c             	sub    $0xc,%esp
  102f91:	ff 75 f0             	push   -0x10(%ebp)
  102f94:	e8 08 f1 ff ff       	call   1020a1 <brelse>
  102f99:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  102f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f9f:	01 45 f4             	add    %eax,-0xc(%ebp)
  102fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa5:	01 45 10             	add    %eax,0x10(%ebp)
  102fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fab:	01 45 0c             	add    %eax,0xc(%ebp)
  102fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fb1:	3b 45 14             	cmp    0x14(%ebp),%eax
  102fb4:	0f 82 6b ff ff ff    	jb     102f25 <readi+0xc7>
  }
  return n;
  102fba:	8b 45 14             	mov    0x14(%ebp),%eax
}
  102fbd:	c9                   	leave  
  102fbe:	c3                   	ret    

00102fbf <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  102fbf:	55                   	push   %ebp
  102fc0:	89 e5                	mov    %esp,%ebp
  102fc2:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  102fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  102fcc:	66 83 f8 03          	cmp    $0x3,%ax
  102fd0:	75 5c                	jne    10302e <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  102fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102fd9:	66 85 c0             	test   %ax,%ax
  102fdc:	78 20                	js     102ffe <writei+0x3f>
  102fde:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102fe5:	66 83 f8 09          	cmp    $0x9,%ax
  102fe9:	7f 13                	jg     102ffe <writei+0x3f>
  102feb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  102ff2:	98                   	cwtl   
  102ff3:	8b 04 c5 44 ae 10 00 	mov    0x10ae44(,%eax,8),%eax
  102ffa:	85 c0                	test   %eax,%eax
  102ffc:	75 0a                	jne    103008 <writei+0x49>
      return -1;
  102ffe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103003:	e9 3b 01 00 00       	jmp    103143 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
  103008:	8b 45 08             	mov    0x8(%ebp),%eax
  10300b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  10300f:	98                   	cwtl   
  103010:	8b 04 c5 44 ae 10 00 	mov    0x10ae44(,%eax,8),%eax
  103017:	8b 55 14             	mov    0x14(%ebp),%edx
  10301a:	83 ec 04             	sub    $0x4,%esp
  10301d:	52                   	push   %edx
  10301e:	ff 75 0c             	push   0xc(%ebp)
  103021:	ff 75 08             	push   0x8(%ebp)
  103024:	ff d0                	call   *%eax
  103026:	83 c4 10             	add    $0x10,%esp
  103029:	e9 15 01 00 00       	jmp    103143 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
  10302e:	8b 45 08             	mov    0x8(%ebp),%eax
  103031:	8b 40 18             	mov    0x18(%eax),%eax
  103034:	39 45 10             	cmp    %eax,0x10(%ebp)
  103037:	77 0d                	ja     103046 <writei+0x87>
  103039:	8b 55 10             	mov    0x10(%ebp),%edx
  10303c:	8b 45 14             	mov    0x14(%ebp),%eax
  10303f:	01 d0                	add    %edx,%eax
  103041:	39 45 10             	cmp    %eax,0x10(%ebp)
  103044:	76 0a                	jbe    103050 <writei+0x91>
    return -1;
  103046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10304b:	e9 f3 00 00 00       	jmp    103143 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
  103050:	8b 55 10             	mov    0x10(%ebp),%edx
  103053:	8b 45 14             	mov    0x14(%ebp),%eax
  103056:	01 d0                	add    %edx,%eax
  103058:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10305d:	76 0a                	jbe    103069 <writei+0xaa>
    return -1;
  10305f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103064:	e9 da 00 00 00       	jmp    103143 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  103069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103070:	e9 97 00 00 00       	jmp    10310c <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  103075:	8b 45 10             	mov    0x10(%ebp),%eax
  103078:	c1 e8 09             	shr    $0x9,%eax
  10307b:	83 ec 08             	sub    $0x8,%esp
  10307e:	50                   	push   %eax
  10307f:	ff 75 08             	push   0x8(%ebp)
  103082:	e8 53 fb ff ff       	call   102bda <bmap>
  103087:	83 c4 10             	add    $0x10,%esp
  10308a:	8b 55 08             	mov    0x8(%ebp),%edx
  10308d:	8b 12                	mov    (%edx),%edx
  10308f:	83 ec 08             	sub    $0x8,%esp
  103092:	50                   	push   %eax
  103093:	52                   	push   %edx
  103094:	e8 a9 ef ff ff       	call   102042 <bread>
  103099:	83 c4 10             	add    $0x10,%esp
  10309c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  10309f:	8b 45 10             	mov    0x10(%ebp),%eax
  1030a2:	25 ff 01 00 00       	and    $0x1ff,%eax
  1030a7:	ba 00 02 00 00       	mov    $0x200,%edx
  1030ac:	29 c2                	sub    %eax,%edx
  1030ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1030b1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1030b4:	39 c2                	cmp    %eax,%edx
  1030b6:	0f 46 c2             	cmovbe %edx,%eax
  1030b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
  1030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030bf:	8d 50 1c             	lea    0x1c(%eax),%edx
  1030c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c5:	25 ff 01 00 00       	and    $0x1ff,%eax
  1030ca:	01 d0                	add    %edx,%eax
  1030cc:	83 ec 04             	sub    $0x4,%esp
  1030cf:	ff 75 ec             	push   -0x14(%ebp)
  1030d2:	ff 75 0c             	push   0xc(%ebp)
  1030d5:	50                   	push   %eax
  1030d6:	e8 2a df ff ff       	call   101005 <memmove>
  1030db:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
  1030de:	83 ec 0c             	sub    $0xc,%esp
  1030e1:	ff 75 f0             	push   -0x10(%ebp)
  1030e4:	e8 56 0f 00 00       	call   10403f <log_write>
  1030e9:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  1030ec:	83 ec 0c             	sub    $0xc,%esp
  1030ef:	ff 75 f0             	push   -0x10(%ebp)
  1030f2:	e8 aa ef ff ff       	call   1020a1 <brelse>
  1030f7:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1030fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030fd:	01 45 f4             	add    %eax,-0xc(%ebp)
  103100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103103:	01 45 10             	add    %eax,0x10(%ebp)
  103106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103109:	01 45 0c             	add    %eax,0xc(%ebp)
  10310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10310f:	3b 45 14             	cmp    0x14(%ebp),%eax
  103112:	0f 82 5d ff ff ff    	jb     103075 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
  103118:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  10311c:	74 22                	je     103140 <writei+0x181>
  10311e:	8b 45 08             	mov    0x8(%ebp),%eax
  103121:	8b 40 18             	mov    0x18(%eax),%eax
  103124:	39 45 10             	cmp    %eax,0x10(%ebp)
  103127:	76 17                	jbe    103140 <writei+0x181>
    ip->size = off;
  103129:	8b 45 08             	mov    0x8(%ebp),%eax
  10312c:	8b 55 10             	mov    0x10(%ebp),%edx
  10312f:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
  103132:	83 ec 0c             	sub    $0xc,%esp
  103135:	ff 75 08             	push   0x8(%ebp)
  103138:	e8 2c f8 ff ff       	call   102969 <iupdate>
  10313d:	83 c4 10             	add    $0x10,%esp
  }
  return n;
  103140:	8b 45 14             	mov    0x14(%ebp),%eax
}
  103143:	c9                   	leave  
  103144:	c3                   	ret    

00103145 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  103145:	55                   	push   %ebp
  103146:	89 e5                	mov    %esp,%ebp
  103148:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
  10314b:	83 ec 04             	sub    $0x4,%esp
  10314e:	6a 0e                	push   $0xe
  103150:	ff 75 0c             	push   0xc(%ebp)
  103153:	ff 75 08             	push   0x8(%ebp)
  103156:	e8 40 df ff ff       	call   10109b <strncmp>
  10315b:	83 c4 10             	add    $0x10,%esp
}
  10315e:	c9                   	leave  
  10315f:	c3                   	ret    

00103160 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  103160:	55                   	push   %ebp
  103161:	89 e5                	mov    %esp,%ebp
  103163:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
  103166:	8b 45 08             	mov    0x8(%ebp),%eax
  103169:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10316d:	66 83 f8 01          	cmp    $0x1,%ax
  103171:	74 0d                	je     103180 <dirlookup+0x20>
    panic("dirlookup not DIR");
  103173:	83 ec 0c             	sub    $0xc,%esp
  103176:	68 19 44 10 00       	push   $0x104419
  10317b:	e8 2d d1 ff ff       	call   1002ad <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
  103180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103187:	eb 7b                	jmp    103204 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103189:	6a 10                	push   $0x10
  10318b:	ff 75 f4             	push   -0xc(%ebp)
  10318e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103191:	50                   	push   %eax
  103192:	ff 75 08             	push   0x8(%ebp)
  103195:	e8 c4 fc ff ff       	call   102e5e <readi>
  10319a:	83 c4 10             	add    $0x10,%esp
  10319d:	83 f8 10             	cmp    $0x10,%eax
  1031a0:	74 0d                	je     1031af <dirlookup+0x4f>
      panic("dirlookup read");
  1031a2:	83 ec 0c             	sub    $0xc,%esp
  1031a5:	68 2b 44 10 00       	push   $0x10442b
  1031aa:	e8 fe d0 ff ff       	call   1002ad <panic>
    if(de.inum == 0)
  1031af:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1031b3:	66 85 c0             	test   %ax,%ax
  1031b6:	74 47                	je     1031ff <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
  1031b8:	83 ec 08             	sub    $0x8,%esp
  1031bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1031be:	83 c0 02             	add    $0x2,%eax
  1031c1:	50                   	push   %eax
  1031c2:	ff 75 0c             	push   0xc(%ebp)
  1031c5:	e8 7b ff ff ff       	call   103145 <namecmp>
  1031ca:	83 c4 10             	add    $0x10,%esp
  1031cd:	85 c0                	test   %eax,%eax
  1031cf:	75 2f                	jne    103200 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
  1031d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031d5:	74 08                	je     1031df <dirlookup+0x7f>
        *poff = off;
  1031d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1031da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031dd:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
  1031df:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1031e3:	0f b7 c0             	movzwl %ax,%eax
  1031e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
  1031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ec:	8b 00                	mov    (%eax),%eax
  1031ee:	83 ec 08             	sub    $0x8,%esp
  1031f1:	ff 75 f0             	push   -0x10(%ebp)
  1031f4:	50                   	push   %eax
  1031f5:	e8 30 f8 ff ff       	call   102a2a <iget>
  1031fa:	83 c4 10             	add    $0x10,%esp
  1031fd:	eb 19                	jmp    103218 <dirlookup+0xb8>
      continue;
  1031ff:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
  103200:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  103204:	8b 45 08             	mov    0x8(%ebp),%eax
  103207:	8b 40 18             	mov    0x18(%eax),%eax
  10320a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10320d:	0f 82 76 ff ff ff    	jb     103189 <dirlookup+0x29>
    }
  }

  return 0;
  103213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103218:	c9                   	leave  
  103219:	c3                   	ret    

0010321a <dirlink>:


// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  10321a:	55                   	push   %ebp
  10321b:	89 e5                	mov    %esp,%ebp
  10321d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  103220:	83 ec 04             	sub    $0x4,%esp
  103223:	6a 00                	push   $0x0
  103225:	ff 75 0c             	push   0xc(%ebp)
  103228:	ff 75 08             	push   0x8(%ebp)
  10322b:	e8 30 ff ff ff       	call   103160 <dirlookup>
  103230:	83 c4 10             	add    $0x10,%esp
  103233:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10323a:	74 18                	je     103254 <dirlink+0x3a>
    iput(ip);
  10323c:	83 ec 0c             	sub    $0xc,%esp
  10323f:	ff 75 f0             	push   -0x10(%ebp)
  103242:	e8 b6 f6 ff ff       	call   1028fd <iput>
  103247:	83 c4 10             	add    $0x10,%esp
    return -1;
  10324a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10324f:	e9 9c 00 00 00       	jmp    1032f0 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  103254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10325b:	eb 39                	jmp    103296 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103260:	6a 10                	push   $0x10
  103262:	50                   	push   %eax
  103263:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103266:	50                   	push   %eax
  103267:	ff 75 08             	push   0x8(%ebp)
  10326a:	e8 ef fb ff ff       	call   102e5e <readi>
  10326f:	83 c4 10             	add    $0x10,%esp
  103272:	83 f8 10             	cmp    $0x10,%eax
  103275:	74 0d                	je     103284 <dirlink+0x6a>
      panic("dirlink read");
  103277:	83 ec 0c             	sub    $0xc,%esp
  10327a:	68 3a 44 10 00       	push   $0x10443a
  10327f:	e8 29 d0 ff ff       	call   1002ad <panic>
    if(de.inum == 0)
  103284:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103288:	66 85 c0             	test   %ax,%ax
  10328b:	74 18                	je     1032a5 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
  10328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103290:	83 c0 10             	add    $0x10,%eax
  103293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103296:	8b 45 08             	mov    0x8(%ebp),%eax
  103299:	8b 50 18             	mov    0x18(%eax),%edx
  10329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329f:	39 c2                	cmp    %eax,%edx
  1032a1:	77 ba                	ja     10325d <dirlink+0x43>
  1032a3:	eb 01                	jmp    1032a6 <dirlink+0x8c>
      break;
  1032a5:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
  1032a6:	83 ec 04             	sub    $0x4,%esp
  1032a9:	6a 0e                	push   $0xe
  1032ab:	ff 75 0c             	push   0xc(%ebp)
  1032ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1032b1:	83 c0 02             	add    $0x2,%eax
  1032b4:	50                   	push   %eax
  1032b5:	e8 37 de ff ff       	call   1010f1 <strncpy>
  1032ba:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
  1032bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1032c0:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032c7:	6a 10                	push   $0x10
  1032c9:	50                   	push   %eax
  1032ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1032cd:	50                   	push   %eax
  1032ce:	ff 75 08             	push   0x8(%ebp)
  1032d1:	e8 e9 fc ff ff       	call   102fbf <writei>
  1032d6:	83 c4 10             	add    $0x10,%esp
  1032d9:	83 f8 10             	cmp    $0x10,%eax
  1032dc:	74 0d                	je     1032eb <dirlink+0xd1>
    panic("dirlink");
  1032de:	83 ec 0c             	sub    $0xc,%esp
  1032e1:	68 47 44 10 00       	push   $0x104447
  1032e6:	e8 c2 cf ff ff       	call   1002ad <panic>

  return 0;
  1032eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032f0:	c9                   	leave  
  1032f1:	c3                   	ret    

001032f2 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  1032f2:	55                   	push   %ebp
  1032f3:	89 e5                	mov    %esp,%ebp
  1032f5:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
  1032f8:	eb 04                	jmp    1032fe <skipelem+0xc>
    path++;
  1032fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  1032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103301:	0f b6 00             	movzbl (%eax),%eax
  103304:	3c 2f                	cmp    $0x2f,%al
  103306:	74 f2                	je     1032fa <skipelem+0x8>
  if(*path == 0)
  103308:	8b 45 08             	mov    0x8(%ebp),%eax
  10330b:	0f b6 00             	movzbl (%eax),%eax
  10330e:	84 c0                	test   %al,%al
  103310:	75 07                	jne    103319 <skipelem+0x27>
    return 0;
  103312:	b8 00 00 00 00       	mov    $0x0,%eax
  103317:	eb 77                	jmp    103390 <skipelem+0x9e>
  s = path;
  103319:	8b 45 08             	mov    0x8(%ebp),%eax
  10331c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
  10331f:	eb 04                	jmp    103325 <skipelem+0x33>
    path++;
  103321:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
  103325:	8b 45 08             	mov    0x8(%ebp),%eax
  103328:	0f b6 00             	movzbl (%eax),%eax
  10332b:	3c 2f                	cmp    $0x2f,%al
  10332d:	74 0a                	je     103339 <skipelem+0x47>
  10332f:	8b 45 08             	mov    0x8(%ebp),%eax
  103332:	0f b6 00             	movzbl (%eax),%eax
  103335:	84 c0                	test   %al,%al
  103337:	75 e8                	jne    103321 <skipelem+0x2f>
  len = path - s;
  103339:	8b 45 08             	mov    0x8(%ebp),%eax
  10333c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10333f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
  103342:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  103346:	7e 15                	jle    10335d <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
  103348:	83 ec 04             	sub    $0x4,%esp
  10334b:	6a 0e                	push   $0xe
  10334d:	ff 75 f4             	push   -0xc(%ebp)
  103350:	ff 75 0c             	push   0xc(%ebp)
  103353:	e8 ad dc ff ff       	call   101005 <memmove>
  103358:	83 c4 10             	add    $0x10,%esp
  10335b:	eb 26                	jmp    103383 <skipelem+0x91>
  else {
    memmove(name, s, len);
  10335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103360:	83 ec 04             	sub    $0x4,%esp
  103363:	50                   	push   %eax
  103364:	ff 75 f4             	push   -0xc(%ebp)
  103367:	ff 75 0c             	push   0xc(%ebp)
  10336a:	e8 96 dc ff ff       	call   101005 <memmove>
  10336f:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
  103372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103375:	8b 45 0c             	mov    0xc(%ebp),%eax
  103378:	01 d0                	add    %edx,%eax
  10337a:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
  10337d:	eb 04                	jmp    103383 <skipelem+0x91>
    path++;
  10337f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  103383:	8b 45 08             	mov    0x8(%ebp),%eax
  103386:	0f b6 00             	movzbl (%eax),%eax
  103389:	3c 2f                	cmp    $0x2f,%al
  10338b:	74 f2                	je     10337f <skipelem+0x8d>
  return path;
  10338d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103390:	c9                   	leave  
  103391:	c3                   	ret    

00103392 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  103392:	55                   	push   %ebp
  103393:	89 e5                	mov    %esp,%ebp
  103395:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  ip = iget(ROOTDEV, ROOTINO);
  103398:	83 ec 08             	sub    $0x8,%esp
  10339b:	6a 01                	push   $0x1
  10339d:	6a 01                	push   $0x1
  10339f:	e8 86 f6 ff ff       	call   102a2a <iget>
  1033a4:	83 c4 10             	add    $0x10,%esp
  1033a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
  1033aa:	e9 90 00 00 00       	jmp    10343f <namex+0xad>
    iread(ip);
  1033af:	83 ec 0c             	sub    $0xc,%esp
  1033b2:	ff 75 f4             	push   -0xc(%ebp)
  1033b5:	e8 1f f7 ff ff       	call   102ad9 <iread>
  1033ba:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
  1033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1033c4:	66 83 f8 01          	cmp    $0x1,%ax
  1033c8:	74 18                	je     1033e2 <namex+0x50>
      iput(ip);
  1033ca:	83 ec 0c             	sub    $0xc,%esp
  1033cd:	ff 75 f4             	push   -0xc(%ebp)
  1033d0:	e8 28 f5 ff ff       	call   1028fd <iput>
  1033d5:	83 c4 10             	add    $0x10,%esp
      return 0;
  1033d8:	b8 00 00 00 00       	mov    $0x0,%eax
  1033dd:	e9 99 00 00 00       	jmp    10347b <namex+0xe9>
    }
    if(nameiparent && *path == '\0'){
  1033e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033e6:	74 12                	je     1033fa <namex+0x68>
  1033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033eb:	0f b6 00             	movzbl (%eax),%eax
  1033ee:	84 c0                	test   %al,%al
  1033f0:	75 08                	jne    1033fa <namex+0x68>
      // Stop one level early.
      return ip;
  1033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033f5:	e9 81 00 00 00       	jmp    10347b <namex+0xe9>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  1033fa:	83 ec 04             	sub    $0x4,%esp
  1033fd:	6a 00                	push   $0x0
  1033ff:	ff 75 10             	push   0x10(%ebp)
  103402:	ff 75 f4             	push   -0xc(%ebp)
  103405:	e8 56 fd ff ff       	call   103160 <dirlookup>
  10340a:	83 c4 10             	add    $0x10,%esp
  10340d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103414:	75 15                	jne    10342b <namex+0x99>
      iput(ip);
  103416:	83 ec 0c             	sub    $0xc,%esp
  103419:	ff 75 f4             	push   -0xc(%ebp)
  10341c:	e8 dc f4 ff ff       	call   1028fd <iput>
  103421:	83 c4 10             	add    $0x10,%esp
      return 0;
  103424:	b8 00 00 00 00       	mov    $0x0,%eax
  103429:	eb 50                	jmp    10347b <namex+0xe9>
    }
    iput(ip);
  10342b:	83 ec 0c             	sub    $0xc,%esp
  10342e:	ff 75 f4             	push   -0xc(%ebp)
  103431:	e8 c7 f4 ff ff       	call   1028fd <iput>
  103436:	83 c4 10             	add    $0x10,%esp
    ip = next;
  103439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10343c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
  10343f:	83 ec 08             	sub    $0x8,%esp
  103442:	ff 75 10             	push   0x10(%ebp)
  103445:	ff 75 08             	push   0x8(%ebp)
  103448:	e8 a5 fe ff ff       	call   1032f2 <skipelem>
  10344d:	83 c4 10             	add    $0x10,%esp
  103450:	89 45 08             	mov    %eax,0x8(%ebp)
  103453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103457:	0f 85 52 ff ff ff    	jne    1033af <namex+0x1d>
  }
  if(nameiparent){
  10345d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103461:	74 15                	je     103478 <namex+0xe6>
    iput(ip);
  103463:	83 ec 0c             	sub    $0xc,%esp
  103466:	ff 75 f4             	push   -0xc(%ebp)
  103469:	e8 8f f4 ff ff       	call   1028fd <iput>
  10346e:	83 c4 10             	add    $0x10,%esp
    return 0;
  103471:	b8 00 00 00 00       	mov    $0x0,%eax
  103476:	eb 03                	jmp    10347b <namex+0xe9>
  }
  return ip;
  103478:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10347b:	c9                   	leave  
  10347c:	c3                   	ret    

0010347d <namei>:

struct inode*
namei(char *path)
{
  10347d:	55                   	push   %ebp
  10347e:	89 e5                	mov    %esp,%ebp
  103480:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  103483:	83 ec 04             	sub    $0x4,%esp
  103486:	8d 45 ea             	lea    -0x16(%ebp),%eax
  103489:	50                   	push   %eax
  10348a:	6a 00                	push   $0x0
  10348c:	ff 75 08             	push   0x8(%ebp)
  10348f:	e8 fe fe ff ff       	call   103392 <namex>
  103494:	83 c4 10             	add    $0x10,%esp
}
  103497:	c9                   	leave  
  103498:	c3                   	ret    

00103499 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
  103499:	55                   	push   %ebp
  10349a:	89 e5                	mov    %esp,%ebp
  10349c:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
  10349f:	83 ec 04             	sub    $0x4,%esp
  1034a2:	ff 75 0c             	push   0xc(%ebp)
  1034a5:	6a 01                	push   $0x1
  1034a7:	ff 75 08             	push   0x8(%ebp)
  1034aa:	e8 e3 fe ff ff       	call   103392 <namex>
  1034af:	83 c4 10             	add    $0x10,%esp
}
  1034b2:	c9                   	leave  
  1034b3:	c3                   	ret    

001034b4 <filealloc>:
} ftable;

// Allocate a file structure.
struct file*
filealloc(void)
{
  1034b4:	55                   	push   %ebp
  1034b5:	89 e5                	mov    %esp,%ebp
  1034b7:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1034ba:	c7 45 fc a0 ae 10 00 	movl   $0x10aea0,-0x4(%ebp)
  1034c1:	eb 1d                	jmp    1034e0 <filealloc+0x2c>
    if(f->ref == 0){
  1034c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1034c6:	8b 40 04             	mov    0x4(%eax),%eax
  1034c9:	85 c0                	test   %eax,%eax
  1034cb:	75 0f                	jne    1034dc <filealloc+0x28>
      f->ref = 1;
  1034cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1034d0:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      return f;
  1034d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1034da:	eb 13                	jmp    1034ef <filealloc+0x3b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1034dc:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
  1034e0:	b8 70 b6 10 00       	mov    $0x10b670,%eax
  1034e5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1034e8:	72 d9                	jb     1034c3 <filealloc+0xf>
    }
  }
  return 0;
  1034ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034ef:	c9                   	leave  
  1034f0:	c3                   	ret    

001034f1 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  1034f1:	55                   	push   %ebp
  1034f2:	89 e5                	mov    %esp,%ebp
  1034f4:	83 ec 08             	sub    $0x8,%esp
  if(f->ref < 1)
  1034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1034fa:	8b 40 04             	mov    0x4(%eax),%eax
  1034fd:	85 c0                	test   %eax,%eax
  1034ff:	7f 0d                	jg     10350e <filedup+0x1d>
    panic("filedup");
  103501:	83 ec 0c             	sub    $0xc,%esp
  103504:	68 4f 44 10 00       	push   $0x10444f
  103509:	e8 9f cd ff ff       	call   1002ad <panic>
  f->ref++;
  10350e:	8b 45 08             	mov    0x8(%ebp),%eax
  103511:	8b 40 04             	mov    0x4(%eax),%eax
  103514:	8d 50 01             	lea    0x1(%eax),%edx
  103517:	8b 45 08             	mov    0x8(%ebp),%eax
  10351a:	89 50 04             	mov    %edx,0x4(%eax)
  return f;
  10351d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103520:	c9                   	leave  
  103521:	c3                   	ret    

00103522 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  103522:	55                   	push   %ebp
  103523:	89 e5                	mov    %esp,%ebp
  103525:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  if(f->ref < 1)
  103528:	8b 45 08             	mov    0x8(%ebp),%eax
  10352b:	8b 40 04             	mov    0x4(%eax),%eax
  10352e:	85 c0                	test   %eax,%eax
  103530:	7f 0d                	jg     10353f <fileclose+0x1d>
    panic("fileclose");
  103532:	83 ec 0c             	sub    $0xc,%esp
  103535:	68 57 44 10 00       	push   $0x104457
  10353a:	e8 6e cd ff ff       	call   1002ad <panic>
  if(--f->ref > 0){
  10353f:	8b 45 08             	mov    0x8(%ebp),%eax
  103542:	8b 40 04             	mov    0x4(%eax),%eax
  103545:	8d 50 ff             	lea    -0x1(%eax),%edx
  103548:	8b 45 08             	mov    0x8(%ebp),%eax
  10354b:	89 50 04             	mov    %edx,0x4(%eax)
  10354e:	8b 45 08             	mov    0x8(%ebp),%eax
  103551:	8b 40 04             	mov    0x4(%eax),%eax
  103554:	85 c0                	test   %eax,%eax
  103556:	7f 56                	jg     1035ae <fileclose+0x8c>
    return;
  }
  ff = *f;
  103558:	8b 45 08             	mov    0x8(%ebp),%eax
  10355b:	8b 10                	mov    (%eax),%edx
  10355d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103560:	8b 50 04             	mov    0x4(%eax),%edx
  103563:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103566:	8b 50 08             	mov    0x8(%eax),%edx
  103569:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10356c:	8b 50 0c             	mov    0xc(%eax),%edx
  10356f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103572:	8b 40 10             	mov    0x10(%eax),%eax
  103575:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
  103578:	8b 45 08             	mov    0x8(%ebp),%eax
  10357b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
  103582:	8b 45 08             	mov    0x8(%ebp),%eax
  103585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(ff.type == FD_INODE){
  10358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10358e:	83 f8 01             	cmp    $0x1,%eax
  103591:	75 1c                	jne    1035af <fileclose+0x8d>
    begin_op();
  103593:	e8 aa 09 00 00       	call   103f42 <begin_op>
    iput(ff.ip);
  103598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10359b:	83 ec 0c             	sub    $0xc,%esp
  10359e:	50                   	push   %eax
  10359f:	e8 59 f3 ff ff       	call   1028fd <iput>
  1035a4:	83 c4 10             	add    $0x10,%esp
    end_op();
  1035a7:	e8 9c 09 00 00       	call   103f48 <end_op>
  1035ac:	eb 01                	jmp    1035af <fileclose+0x8d>
    return;
  1035ae:	90                   	nop
  }
}
  1035af:	c9                   	leave  
  1035b0:	c3                   	ret    

001035b1 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  1035b1:	55                   	push   %ebp
  1035b2:	89 e5                	mov    %esp,%ebp
  1035b4:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
  1035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ba:	8b 00                	mov    (%eax),%eax
  1035bc:	83 f8 01             	cmp    $0x1,%eax
  1035bf:	75 2e                	jne    1035ef <filestat+0x3e>
    iread(f->ip);
  1035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c4:	8b 40 0c             	mov    0xc(%eax),%eax
  1035c7:	83 ec 0c             	sub    $0xc,%esp
  1035ca:	50                   	push   %eax
  1035cb:	e8 09 f5 ff ff       	call   102ad9 <iread>
  1035d0:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
  1035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d6:	8b 40 0c             	mov    0xc(%eax),%eax
  1035d9:	83 ec 08             	sub    $0x8,%esp
  1035dc:	ff 75 0c             	push   0xc(%ebp)
  1035df:	50                   	push   %eax
  1035e0:	e8 33 f8 ff ff       	call   102e18 <stati>
  1035e5:	83 c4 10             	add    $0x10,%esp
    return 0;
  1035e8:	b8 00 00 00 00       	mov    $0x0,%eax
  1035ed:	eb 05                	jmp    1035f4 <filestat+0x43>
  }
  return -1;
  1035ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1035f4:	c9                   	leave  
  1035f5:	c3                   	ret    

001035f6 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
  1035f6:	55                   	push   %ebp
  1035f7:	89 e5                	mov    %esp,%ebp
  1035f9:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
  1035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ff:	0f b6 40 08          	movzbl 0x8(%eax),%eax
  103603:	84 c0                	test   %al,%al
  103605:	75 07                	jne    10360e <fileread+0x18>
    return -1;
  103607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10360c:	eb 65                	jmp    103673 <fileread+0x7d>
  if(f->type == FD_INODE){
  10360e:	8b 45 08             	mov    0x8(%ebp),%eax
  103611:	8b 00                	mov    (%eax),%eax
  103613:	83 f8 01             	cmp    $0x1,%eax
  103616:	75 4e                	jne    103666 <fileread+0x70>
    iread(f->ip);
  103618:	8b 45 08             	mov    0x8(%ebp),%eax
  10361b:	8b 40 0c             	mov    0xc(%eax),%eax
  10361e:	83 ec 0c             	sub    $0xc,%esp
  103621:	50                   	push   %eax
  103622:	e8 b2 f4 ff ff       	call   102ad9 <iread>
  103627:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  10362a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10362d:	8b 45 08             	mov    0x8(%ebp),%eax
  103630:	8b 50 10             	mov    0x10(%eax),%edx
  103633:	8b 45 08             	mov    0x8(%ebp),%eax
  103636:	8b 40 0c             	mov    0xc(%eax),%eax
  103639:	51                   	push   %ecx
  10363a:	52                   	push   %edx
  10363b:	ff 75 0c             	push   0xc(%ebp)
  10363e:	50                   	push   %eax
  10363f:	e8 1a f8 ff ff       	call   102e5e <readi>
  103644:	83 c4 10             	add    $0x10,%esp
  103647:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10364a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10364e:	7e 11                	jle    103661 <fileread+0x6b>
      f->off += r;
  103650:	8b 45 08             	mov    0x8(%ebp),%eax
  103653:	8b 50 10             	mov    0x10(%eax),%edx
  103656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103659:	01 c2                	add    %eax,%edx
  10365b:	8b 45 08             	mov    0x8(%ebp),%eax
  10365e:	89 50 10             	mov    %edx,0x10(%eax)
    return r;
  103661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103664:	eb 0d                	jmp    103673 <fileread+0x7d>
  }
  panic("fileread");
  103666:	83 ec 0c             	sub    $0xc,%esp
  103669:	68 61 44 10 00       	push   $0x104461
  10366e:	e8 3a cc ff ff       	call   1002ad <panic>
}
  103673:	c9                   	leave  
  103674:	c3                   	ret    

00103675 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
  103675:	55                   	push   %ebp
  103676:	89 e5                	mov    %esp,%ebp
  103678:	53                   	push   %ebx
  103679:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
  10367c:	8b 45 08             	mov    0x8(%ebp),%eax
  10367f:	0f b6 40 09          	movzbl 0x9(%eax),%eax
  103683:	84 c0                	test   %al,%al
  103685:	75 0a                	jne    103691 <filewrite+0x1c>
    return -1;
  103687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10368c:	e9 e2 00 00 00       	jmp    103773 <filewrite+0xfe>
  if(f->type == FD_INODE){
  103691:	8b 45 08             	mov    0x8(%ebp),%eax
  103694:	8b 00                	mov    (%eax),%eax
  103696:	83 f8 01             	cmp    $0x1,%eax
  103699:	0f 85 c7 00 00 00    	jne    103766 <filewrite+0xf1>
    // write a few blocks at a time
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
  10369f:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
  1036a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
  1036ad:	e9 91 00 00 00       	jmp    103743 <filewrite+0xce>
      int n1 = n - i;
  1036b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1036b5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1036b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
  1036bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1036c1:	7e 06                	jle    1036c9 <filewrite+0x54>
        n1 = max;
  1036c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

			begin_op();
  1036c9:	e8 74 08 00 00       	call   103f42 <begin_op>
      iread(f->ip);
  1036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1036d1:	8b 40 0c             	mov    0xc(%eax),%eax
  1036d4:	83 ec 0c             	sub    $0xc,%esp
  1036d7:	50                   	push   %eax
  1036d8:	e8 fc f3 ff ff       	call   102ad9 <iread>
  1036dd:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
  1036e0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1036e6:	8b 50 10             	mov    0x10(%eax),%edx
  1036e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1036ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ef:	01 c3                	add    %eax,%ebx
  1036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1036f4:	8b 40 0c             	mov    0xc(%eax),%eax
  1036f7:	51                   	push   %ecx
  1036f8:	52                   	push   %edx
  1036f9:	53                   	push   %ebx
  1036fa:	50                   	push   %eax
  1036fb:	e8 bf f8 ff ff       	call   102fbf <writei>
  103700:	83 c4 10             	add    $0x10,%esp
  103703:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103706:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10370a:	7e 11                	jle    10371d <filewrite+0xa8>
        f->off += r;
  10370c:	8b 45 08             	mov    0x8(%ebp),%eax
  10370f:	8b 50 10             	mov    0x10(%eax),%edx
  103712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103715:	01 c2                	add    %eax,%edx
  103717:	8b 45 08             	mov    0x8(%ebp),%eax
  10371a:	89 50 10             	mov    %edx,0x10(%eax)
      end_op();
  10371d:	e8 26 08 00 00       	call   103f48 <end_op>

      if(r < 0)
  103722:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103726:	78 29                	js     103751 <filewrite+0xdc>
        break;
      if(r != n1)
  103728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10372b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10372e:	74 0d                	je     10373d <filewrite+0xc8>
        panic("short filewrite");
  103730:	83 ec 0c             	sub    $0xc,%esp
  103733:	68 6a 44 10 00       	push   $0x10446a
  103738:	e8 70 cb ff ff       	call   1002ad <panic>
      i += r;
  10373d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103740:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
  103743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103746:	3b 45 10             	cmp    0x10(%ebp),%eax
  103749:	0f 8c 63 ff ff ff    	jl     1036b2 <filewrite+0x3d>
  10374f:	eb 01                	jmp    103752 <filewrite+0xdd>
        break;
  103751:	90                   	nop
    }
    return i == n ? n : -1;
  103752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103755:	3b 45 10             	cmp    0x10(%ebp),%eax
  103758:	75 05                	jne    10375f <filewrite+0xea>
  10375a:	8b 45 10             	mov    0x10(%ebp),%eax
  10375d:	eb 14                	jmp    103773 <filewrite+0xfe>
  10375f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103764:	eb 0d                	jmp    103773 <filewrite+0xfe>
  }
  panic("filewrite");
  103766:	83 ec 0c             	sub    $0xc,%esp
  103769:	68 7a 44 10 00       	push   $0x10447a
  10376e:	e8 3a cb ff ff       	call   1002ad <panic>
}
  103773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103776:	c9                   	leave  
  103777:	c3                   	ret    

00103778 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
  103778:	55                   	push   %ebp
  103779:	89 e5                	mov    %esp,%ebp
  10377b:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  10377e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
  103785:	eb 40                	jmp    1037c7 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10378a:	6a 10                	push   $0x10
  10378c:	50                   	push   %eax
  10378d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  103790:	50                   	push   %eax
  103791:	ff 75 08             	push   0x8(%ebp)
  103794:	e8 c5 f6 ff ff       	call   102e5e <readi>
  103799:	83 c4 10             	add    $0x10,%esp
  10379c:	83 f8 10             	cmp    $0x10,%eax
  10379f:	74 0d                	je     1037ae <isdirempty+0x36>
      panic("isdirempty: readi");
  1037a1:	83 ec 0c             	sub    $0xc,%esp
  1037a4:	68 84 44 10 00       	push   $0x104484
  1037a9:	e8 ff ca ff ff       	call   1002ad <panic>
    if(de.inum != 0)
  1037ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  1037b2:	66 85 c0             	test   %ax,%ax
  1037b5:	74 07                	je     1037be <isdirempty+0x46>
      return 0;
  1037b7:	b8 00 00 00 00       	mov    $0x0,%eax
  1037bc:	eb 1b                	jmp    1037d9 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  1037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037c1:	83 c0 10             	add    $0x10,%eax
  1037c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1037ca:	8b 50 18             	mov    0x18(%eax),%edx
  1037cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037d0:	39 c2                	cmp    %eax,%edx
  1037d2:	77 b3                	ja     103787 <isdirempty+0xf>
  }
  return 1;
  1037d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1037d9:	c9                   	leave  
  1037da:	c3                   	ret    

001037db <unlink>:

int
unlink(char* path, char* name)
{
  1037db:	55                   	push   %ebp
  1037dc:	89 e5                	mov    %esp,%ebp
  1037de:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *dp;
  struct dirent de;
  uint off;

	begin_op();
  1037e1:	e8 5c 07 00 00       	call   103f42 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
  1037e6:	83 ec 08             	sub    $0x8,%esp
  1037e9:	ff 75 0c             	push   0xc(%ebp)
  1037ec:	ff 75 08             	push   0x8(%ebp)
  1037ef:	e8 a5 fc ff ff       	call   103499 <nameiparent>
  1037f4:	83 c4 10             	add    $0x10,%esp
  1037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1037fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1037fe:	75 0f                	jne    10380f <unlink+0x34>
    end_op();
  103800:	e8 43 07 00 00       	call   103f48 <end_op>
    return -1;
  103805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10380a:	e9 8c 01 00 00       	jmp    10399b <unlink+0x1c0>
  }

  iread(dp);
  10380f:	83 ec 0c             	sub    $0xc,%esp
  103812:	ff 75 f4             	push   -0xc(%ebp)
  103815:	e8 bf f2 ff ff       	call   102ad9 <iread>
  10381a:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
  10381d:	83 ec 08             	sub    $0x8,%esp
  103820:	68 96 44 10 00       	push   $0x104496
  103825:	ff 75 0c             	push   0xc(%ebp)
  103828:	e8 18 f9 ff ff       	call   103145 <namecmp>
  10382d:	83 c4 10             	add    $0x10,%esp
  103830:	85 c0                	test   %eax,%eax
  103832:	0f 84 47 01 00 00    	je     10397f <unlink+0x1a4>
  103838:	83 ec 08             	sub    $0x8,%esp
  10383b:	68 98 44 10 00       	push   $0x104498
  103840:	ff 75 0c             	push   0xc(%ebp)
  103843:	e8 fd f8 ff ff       	call   103145 <namecmp>
  103848:	83 c4 10             	add    $0x10,%esp
  10384b:	85 c0                	test   %eax,%eax
  10384d:	0f 84 2c 01 00 00    	je     10397f <unlink+0x1a4>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
  103853:	83 ec 04             	sub    $0x4,%esp
  103856:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103859:	50                   	push   %eax
  10385a:	ff 75 0c             	push   0xc(%ebp)
  10385d:	ff 75 f4             	push   -0xc(%ebp)
  103860:	e8 fb f8 ff ff       	call   103160 <dirlookup>
  103865:	83 c4 10             	add    $0x10,%esp
  103868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10386b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10386f:	0f 84 0d 01 00 00    	je     103982 <unlink+0x1a7>
    goto bad;
  iread(ip);
  103875:	83 ec 0c             	sub    $0xc,%esp
  103878:	ff 75 f0             	push   -0x10(%ebp)
  10387b:	e8 59 f2 ff ff       	call   102ad9 <iread>
  103880:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
  103883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103886:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  10388a:	66 85 c0             	test   %ax,%ax
  10388d:	7f 0d                	jg     10389c <unlink+0xc1>
    panic("unlink: nlink < 1");
  10388f:	83 ec 0c             	sub    $0xc,%esp
  103892:	68 9b 44 10 00       	push   $0x10449b
  103897:	e8 11 ca ff ff       	call   1002ad <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
  10389c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10389f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1038a3:	66 83 f8 01          	cmp    $0x1,%ax
  1038a7:	75 25                	jne    1038ce <unlink+0xf3>
  1038a9:	83 ec 0c             	sub    $0xc,%esp
  1038ac:	ff 75 f0             	push   -0x10(%ebp)
  1038af:	e8 c4 fe ff ff       	call   103778 <isdirempty>
  1038b4:	83 c4 10             	add    $0x10,%esp
  1038b7:	85 c0                	test   %eax,%eax
  1038b9:	75 13                	jne    1038ce <unlink+0xf3>
    iput(ip);
  1038bb:	83 ec 0c             	sub    $0xc,%esp
  1038be:	ff 75 f0             	push   -0x10(%ebp)
  1038c1:	e8 37 f0 ff ff       	call   1028fd <iput>
  1038c6:	83 c4 10             	add    $0x10,%esp
    goto bad;
  1038c9:	e9 b5 00 00 00       	jmp    103983 <unlink+0x1a8>
  }

  memset(&de, 0, sizeof(de));
  1038ce:	83 ec 04             	sub    $0x4,%esp
  1038d1:	6a 10                	push   $0x10
  1038d3:	6a 00                	push   $0x0
  1038d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1038d8:	50                   	push   %eax
  1038d9:	e8 68 d6 ff ff       	call   100f46 <memset>
  1038de:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1038e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1038e4:	6a 10                	push   $0x10
  1038e6:	50                   	push   %eax
  1038e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1038ea:	50                   	push   %eax
  1038eb:	ff 75 f4             	push   -0xc(%ebp)
  1038ee:	e8 cc f6 ff ff       	call   102fbf <writei>
  1038f3:	83 c4 10             	add    $0x10,%esp
  1038f6:	83 f8 10             	cmp    $0x10,%eax
  1038f9:	74 0d                	je     103908 <unlink+0x12d>
    panic("unlink: writei");
  1038fb:	83 ec 0c             	sub    $0xc,%esp
  1038fe:	68 ad 44 10 00       	push   $0x1044ad
  103903:	e8 a5 c9 ff ff       	call   1002ad <panic>
  if(ip->type == T_DIR){
  103908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10390b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10390f:	66 83 f8 01          	cmp    $0x1,%ax
  103913:	75 21                	jne    103936 <unlink+0x15b>
    dp->nlink--;
  103915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103918:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  10391c:	83 e8 01             	sub    $0x1,%eax
  10391f:	89 c2                	mov    %eax,%edx
  103921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103924:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  103928:	83 ec 0c             	sub    $0xc,%esp
  10392b:	ff 75 f4             	push   -0xc(%ebp)
  10392e:	e8 36 f0 ff ff       	call   102969 <iupdate>
  103933:	83 c4 10             	add    $0x10,%esp
  }
  iput(dp);
  103936:	83 ec 0c             	sub    $0xc,%esp
  103939:	ff 75 f4             	push   -0xc(%ebp)
  10393c:	e8 bc ef ff ff       	call   1028fd <iput>
  103941:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
  103944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103947:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  10394b:	83 e8 01             	sub    $0x1,%eax
  10394e:	89 c2                	mov    %eax,%edx
  103950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103953:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
  103957:	83 ec 0c             	sub    $0xc,%esp
  10395a:	ff 75 f0             	push   -0x10(%ebp)
  10395d:	e8 07 f0 ff ff       	call   102969 <iupdate>
  103962:	83 c4 10             	add    $0x10,%esp
  iput(ip);
  103965:	83 ec 0c             	sub    $0xc,%esp
  103968:	ff 75 f0             	push   -0x10(%ebp)
  10396b:	e8 8d ef ff ff       	call   1028fd <iput>
  103970:	83 c4 10             	add    $0x10,%esp

  end_op();
  103973:	e8 d0 05 00 00       	call   103f48 <end_op>
  return 0;
  103978:	b8 00 00 00 00       	mov    $0x0,%eax
  10397d:	eb 1c                	jmp    10399b <unlink+0x1c0>
    goto bad;
  10397f:	90                   	nop
  103980:	eb 01                	jmp    103983 <unlink+0x1a8>
    goto bad;
  103982:	90                   	nop

bad:
  iput(dp);
  103983:	83 ec 0c             	sub    $0xc,%esp
  103986:	ff 75 f4             	push   -0xc(%ebp)
  103989:	e8 6f ef ff ff       	call   1028fd <iput>
  10398e:	83 c4 10             	add    $0x10,%esp
  end_op();
  103991:	e8 b2 05 00 00       	call   103f48 <end_op>
  return -1;
  103996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10399b:	c9                   	leave  
  10399c:	c3                   	ret    

0010399d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
  10399d:	55                   	push   %ebp
  10399e:	89 e5                	mov    %esp,%ebp
  1039a0:	83 ec 38             	sub    $0x38,%esp
  1039a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1039a6:	8b 55 10             	mov    0x10(%ebp),%edx
  1039a9:	8b 45 14             	mov    0x14(%ebp),%eax
  1039ac:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
  1039b0:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  1039b4:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1039b8:	83 ec 08             	sub    $0x8,%esp
  1039bb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1039be:	50                   	push   %eax
  1039bf:	ff 75 08             	push   0x8(%ebp)
  1039c2:	e8 d2 fa ff ff       	call   103499 <nameiparent>
  1039c7:	83 c4 10             	add    $0x10,%esp
  1039ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1039cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039d1:	75 0a                	jne    1039dd <create+0x40>
    return 0;
  1039d3:	b8 00 00 00 00       	mov    $0x0,%eax
  1039d8:	e9 8e 01 00 00       	jmp    103b6b <create+0x1ce>
  iread(dp);
  1039dd:	83 ec 0c             	sub    $0xc,%esp
  1039e0:	ff 75 f4             	push   -0xc(%ebp)
  1039e3:	e8 f1 f0 ff ff       	call   102ad9 <iread>
  1039e8:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
  1039eb:	83 ec 04             	sub    $0x4,%esp
  1039ee:	6a 00                	push   $0x0
  1039f0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1039f3:	50                   	push   %eax
  1039f4:	ff 75 f4             	push   -0xc(%ebp)
  1039f7:	e8 64 f7 ff ff       	call   103160 <dirlookup>
  1039fc:	83 c4 10             	add    $0x10,%esp
  1039ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a06:	74 50                	je     103a58 <create+0xbb>
    iput(dp);
  103a08:	83 ec 0c             	sub    $0xc,%esp
  103a0b:	ff 75 f4             	push   -0xc(%ebp)
  103a0e:	e8 ea ee ff ff       	call   1028fd <iput>
  103a13:	83 c4 10             	add    $0x10,%esp
    iread(ip);
  103a16:	83 ec 0c             	sub    $0xc,%esp
  103a19:	ff 75 f0             	push   -0x10(%ebp)
  103a1c:	e8 b8 f0 ff ff       	call   102ad9 <iread>
  103a21:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
  103a24:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  103a29:	75 15                	jne    103a40 <create+0xa3>
  103a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a2e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103a32:	66 83 f8 02          	cmp    $0x2,%ax
  103a36:	75 08                	jne    103a40 <create+0xa3>
      return ip;
  103a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a3b:	e9 2b 01 00 00       	jmp    103b6b <create+0x1ce>
    iput(ip);
  103a40:	83 ec 0c             	sub    $0xc,%esp
  103a43:	ff 75 f0             	push   -0x10(%ebp)
  103a46:	e8 b2 ee ff ff       	call   1028fd <iput>
  103a4b:	83 c4 10             	add    $0x10,%esp
    return 0;
  103a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  103a53:	e9 13 01 00 00       	jmp    103b6b <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  103a58:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
  103a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a5f:	8b 00                	mov    (%eax),%eax
  103a61:	83 ec 08             	sub    $0x8,%esp
  103a64:	52                   	push   %edx
  103a65:	50                   	push   %eax
  103a66:	e8 bb ed ff ff       	call   102826 <ialloc>
  103a6b:	83 c4 10             	add    $0x10,%esp
  103a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a75:	75 0d                	jne    103a84 <create+0xe7>
    panic("create: ialloc");
  103a77:	83 ec 0c             	sub    $0xc,%esp
  103a7a:	68 bc 44 10 00       	push   $0x1044bc
  103a7f:	e8 29 c8 ff ff       	call   1002ad <panic>

  iread(ip);
  103a84:	83 ec 0c             	sub    $0xc,%esp
  103a87:	ff 75 f0             	push   -0x10(%ebp)
  103a8a:	e8 4a f0 ff ff       	call   102ad9 <iread>
  103a8f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
  103a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a95:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
  103a99:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
  103a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aa0:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  103aa4:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
  103aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aab:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
  103ab1:	83 ec 0c             	sub    $0xc,%esp
  103ab4:	ff 75 f0             	push   -0x10(%ebp)
  103ab7:	e8 ad ee ff ff       	call   102969 <iupdate>
  103abc:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
  103abf:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
  103ac4:	75 6a                	jne    103b30 <create+0x193>
    dp->nlink++;  // for ".."
  103ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ac9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103acd:	83 c0 01             	add    $0x1,%eax
  103ad0:	89 c2                	mov    %eax,%edx
  103ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ad5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  103ad9:	83 ec 0c             	sub    $0xc,%esp
  103adc:	ff 75 f4             	push   -0xc(%ebp)
  103adf:	e8 85 ee ff ff       	call   102969 <iupdate>
  103ae4:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  103ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aea:	8b 40 04             	mov    0x4(%eax),%eax
  103aed:	83 ec 04             	sub    $0x4,%esp
  103af0:	50                   	push   %eax
  103af1:	68 96 44 10 00       	push   $0x104496
  103af6:	ff 75 f0             	push   -0x10(%ebp)
  103af9:	e8 1c f7 ff ff       	call   10321a <dirlink>
  103afe:	83 c4 10             	add    $0x10,%esp
  103b01:	85 c0                	test   %eax,%eax
  103b03:	78 1e                	js     103b23 <create+0x186>
  103b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b08:	8b 40 04             	mov    0x4(%eax),%eax
  103b0b:	83 ec 04             	sub    $0x4,%esp
  103b0e:	50                   	push   %eax
  103b0f:	68 98 44 10 00       	push   $0x104498
  103b14:	ff 75 f0             	push   -0x10(%ebp)
  103b17:	e8 fe f6 ff ff       	call   10321a <dirlink>
  103b1c:	83 c4 10             	add    $0x10,%esp
  103b1f:	85 c0                	test   %eax,%eax
  103b21:	79 0d                	jns    103b30 <create+0x193>
      panic("create dots");
  103b23:	83 ec 0c             	sub    $0xc,%esp
  103b26:	68 cb 44 10 00       	push   $0x1044cb
  103b2b:	e8 7d c7 ff ff       	call   1002ad <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
  103b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b33:	8b 40 04             	mov    0x4(%eax),%eax
  103b36:	83 ec 04             	sub    $0x4,%esp
  103b39:	50                   	push   %eax
  103b3a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103b3d:	50                   	push   %eax
  103b3e:	ff 75 f4             	push   -0xc(%ebp)
  103b41:	e8 d4 f6 ff ff       	call   10321a <dirlink>
  103b46:	83 c4 10             	add    $0x10,%esp
  103b49:	85 c0                	test   %eax,%eax
  103b4b:	79 0d                	jns    103b5a <create+0x1bd>
    panic("create: dirlink");
  103b4d:	83 ec 0c             	sub    $0xc,%esp
  103b50:	68 d7 44 10 00       	push   $0x1044d7
  103b55:	e8 53 c7 ff ff       	call   1002ad <panic>

  iput(dp);
  103b5a:	83 ec 0c             	sub    $0xc,%esp
  103b5d:	ff 75 f4             	push   -0xc(%ebp)
  103b60:	e8 98 ed ff ff       	call   1028fd <iput>
  103b65:	83 c4 10             	add    $0x10,%esp

  return ip;
  103b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103b6b:	c9                   	leave  
  103b6c:	c3                   	ret    

00103b6d <open>:


struct file*
open(char* path, int omode)
{
  103b6d:	55                   	push   %ebp
  103b6e:	89 e5                	mov    %esp,%ebp
  103b70:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  103b73:	e8 ca 03 00 00       	call   103f42 <begin_op>

  if(omode & O_CREATE){
  103b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b7b:	25 00 02 00 00       	and    $0x200,%eax
  103b80:	85 c0                	test   %eax,%eax
  103b82:	74 29                	je     103bad <open+0x40>
    ip = create(path, T_FILE, 0, 0);
  103b84:	6a 00                	push   $0x0
  103b86:	6a 00                	push   $0x0
  103b88:	6a 02                	push   $0x2
  103b8a:	ff 75 08             	push   0x8(%ebp)
  103b8d:	e8 0b fe ff ff       	call   10399d <create>
  103b92:	83 c4 10             	add    $0x10,%esp
  103b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
  103b98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b9c:	75 73                	jne    103c11 <open+0xa4>
      end_op();
  103b9e:	e8 a5 03 00 00       	call   103f48 <end_op>
      return 0;
  103ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  103ba8:	e9 eb 00 00 00       	jmp    103c98 <open+0x12b>
    }
  } else {
    if((ip = namei(path)) == 0){
  103bad:	83 ec 0c             	sub    $0xc,%esp
  103bb0:	ff 75 08             	push   0x8(%ebp)
  103bb3:	e8 c5 f8 ff ff       	call   10347d <namei>
  103bb8:	83 c4 10             	add    $0x10,%esp
  103bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bc2:	75 0f                	jne    103bd3 <open+0x66>
      end_op();
  103bc4:	e8 7f 03 00 00       	call   103f48 <end_op>
      return 0;
  103bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  103bce:	e9 c5 00 00 00       	jmp    103c98 <open+0x12b>
    }
    iread(ip);
  103bd3:	83 ec 0c             	sub    $0xc,%esp
  103bd6:	ff 75 f4             	push   -0xc(%ebp)
  103bd9:	e8 fb ee ff ff       	call   102ad9 <iread>
  103bde:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
  103be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103be4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103be8:	66 83 f8 01          	cmp    $0x1,%ax
  103bec:	75 23                	jne    103c11 <open+0xa4>
  103bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103bf2:	74 1d                	je     103c11 <open+0xa4>
      iput(ip);
  103bf4:	83 ec 0c             	sub    $0xc,%esp
  103bf7:	ff 75 f4             	push   -0xc(%ebp)
  103bfa:	e8 fe ec ff ff       	call   1028fd <iput>
  103bff:	83 c4 10             	add    $0x10,%esp
      end_op();
  103c02:	e8 41 03 00 00       	call   103f48 <end_op>
      return 0;
  103c07:	b8 00 00 00 00       	mov    $0x0,%eax
  103c0c:	e9 87 00 00 00       	jmp    103c98 <open+0x12b>
    }
  }

  struct file* f;
  if((f = filealloc()) == 0) { 
  103c11:	e8 9e f8 ff ff       	call   1034b4 <filealloc>
  103c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c1d:	75 1a                	jne    103c39 <open+0xcc>
    iput(ip);
  103c1f:	83 ec 0c             	sub    $0xc,%esp
  103c22:	ff 75 f4             	push   -0xc(%ebp)
  103c25:	e8 d3 ec ff ff       	call   1028fd <iput>
  103c2a:	83 c4 10             	add    $0x10,%esp
    end_op();
  103c2d:	e8 16 03 00 00       	call   103f48 <end_op>
    return 0;
  103c32:	b8 00 00 00 00       	mov    $0x0,%eax
  103c37:	eb 5f                	jmp    103c98 <open+0x12b>
  }

  f->type = FD_INODE;
  103c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c3c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  f->ip = ip;
  103c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103c48:	89 50 0c             	mov    %edx,0xc(%eax)
  f->off = 0;
  103c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c4e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  f->readable = !(omode & O_WRONLY);
  103c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c58:	83 e0 01             	and    $0x1,%eax
  103c5b:	85 c0                	test   %eax,%eax
  103c5d:	0f 94 c0             	sete   %al
  103c60:	89 c2                	mov    %eax,%edx
  103c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c65:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  103c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c6b:	83 e0 01             	and    $0x1,%eax
  103c6e:	85 c0                	test   %eax,%eax
  103c70:	75 0a                	jne    103c7c <open+0x10f>
  103c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c75:	83 e0 02             	and    $0x2,%eax
  103c78:	85 c0                	test   %eax,%eax
  103c7a:	74 07                	je     103c83 <open+0x116>
  103c7c:	b8 01 00 00 00       	mov    $0x1,%eax
  103c81:	eb 05                	jmp    103c88 <open+0x11b>
  103c83:	b8 00 00 00 00       	mov    $0x0,%eax
  103c88:	89 c2                	mov    %eax,%edx
  103c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c8d:	88 50 09             	mov    %dl,0x9(%eax)
  end_op();
  103c90:	e8 b3 02 00 00       	call   103f48 <end_op>
  return f;
  103c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103c98:	c9                   	leave  
  103c99:	c3                   	ret    

00103c9a <mknod>:

int
mknod(struct inode *ip, char* path, int major, int minor)
{
  103c9a:	55                   	push   %ebp
  103c9b:	89 e5                	mov    %esp,%ebp
  103c9d:	83 ec 08             	sub    $0x8,%esp
  begin_op();
  103ca0:	e8 9d 02 00 00       	call   103f42 <begin_op>
  if((ip = create(path, T_DEV, major, minor)) == 0){
  103ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  103ca8:	0f bf d0             	movswl %ax,%edx
  103cab:	8b 45 10             	mov    0x10(%ebp),%eax
  103cae:	98                   	cwtl   
  103caf:	52                   	push   %edx
  103cb0:	50                   	push   %eax
  103cb1:	6a 03                	push   $0x3
  103cb3:	ff 75 0c             	push   0xc(%ebp)
  103cb6:	e8 e2 fc ff ff       	call   10399d <create>
  103cbb:	83 c4 10             	add    $0x10,%esp
  103cbe:	89 45 08             	mov    %eax,0x8(%ebp)
  103cc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103cc5:	75 0c                	jne    103cd3 <mknod+0x39>
    end_op();
  103cc7:	e8 7c 02 00 00       	call   103f48 <end_op>
    return -1;
  103ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103cd1:	eb 18                	jmp    103ceb <mknod+0x51>
  }
  iput(ip);
  103cd3:	83 ec 0c             	sub    $0xc,%esp
  103cd6:	ff 75 08             	push   0x8(%ebp)
  103cd9:	e8 1f ec ff ff       	call   1028fd <iput>
  103cde:	83 c4 10             	add    $0x10,%esp
  end_op();
  103ce1:	e8 62 02 00 00       	call   103f48 <end_op>
  return 0;
  103ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103ceb:	c9                   	leave  
  103cec:	c3                   	ret    

00103ced <mkdir>:

int mkdir(char *path)
{
  103ced:	55                   	push   %ebp
  103cee:	89 e5                	mov    %esp,%ebp
  103cf0:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  103cf3:	e8 4a 02 00 00       	call   103f42 <begin_op>
  if((ip = create(path, T_DIR, 0, 0)) == 0){
  103cf8:	6a 00                	push   $0x0
  103cfa:	6a 00                	push   $0x0
  103cfc:	6a 01                	push   $0x1
  103cfe:	ff 75 08             	push   0x8(%ebp)
  103d01:	e8 97 fc ff ff       	call   10399d <create>
  103d06:	83 c4 10             	add    $0x10,%esp
  103d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103d10:	75 0c                	jne    103d1e <mkdir+0x31>
    end_op();
  103d12:	e8 31 02 00 00       	call   103f48 <end_op>
    return -1;
  103d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103d1c:	eb 18                	jmp    103d36 <mkdir+0x49>
  }
  iput(ip);
  103d1e:	83 ec 0c             	sub    $0xc,%esp
  103d21:	ff 75 f4             	push   -0xc(%ebp)
  103d24:	e8 d4 eb ff ff       	call   1028fd <iput>
  103d29:	83 c4 10             	add    $0x10,%esp
  end_op();
  103d2c:	e8 17 02 00 00       	call   103f48 <end_op>
  return 0;
  103d31:	b8 00 00 00 00       	mov    $0x0,%eax
  103d36:	c9                   	leave  
  103d37:	c3                   	ret    

00103d38 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
  103d38:	55                   	push   %ebp
  103d39:	89 e5                	mov    %esp,%ebp
  103d3b:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  readsb(dev, &sb);
  103d3e:	83 ec 08             	sub    $0x8,%esp
  103d41:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103d44:	50                   	push   %eax
  103d45:	ff 75 08             	push   0x8(%ebp)
  103d48:	e8 dc e7 ff ff       	call   102529 <readsb>
  103d4d:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
  103d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d53:	a3 80 b6 10 00       	mov    %eax,0x10b680
  log.size = sb.nlog;
  103d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103d5b:	a3 84 b6 10 00       	mov    %eax,0x10b684
  log.dev = dev;
  103d60:	8b 45 08             	mov    0x8(%ebp),%eax
  103d63:	a3 8c b6 10 00       	mov    %eax,0x10b68c
  recover_from_log();
  103d68:	e8 b3 01 00 00       	call   103f20 <recover_from_log>
}
  103d6d:	90                   	nop
  103d6e:	c9                   	leave  
  103d6f:	c3                   	ret    

00103d70 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
  103d70:	55                   	push   %ebp
  103d71:	89 e5                	mov    %esp,%ebp
  103d73:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  103d76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d7d:	e9 95 00 00 00       	jmp    103e17 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
  103d82:	8b 15 80 b6 10 00    	mov    0x10b680,%edx
  103d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d8b:	01 d0                	add    %edx,%eax
  103d8d:	83 c0 01             	add    $0x1,%eax
  103d90:	89 c2                	mov    %eax,%edx
  103d92:	a1 8c b6 10 00       	mov    0x10b68c,%eax
  103d97:	83 ec 08             	sub    $0x8,%esp
  103d9a:	52                   	push   %edx
  103d9b:	50                   	push   %eax
  103d9c:	e8 a1 e2 ff ff       	call   102042 <bread>
  103da1:	83 c4 10             	add    $0x10,%esp
  103da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
  103da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103daa:	83 c0 04             	add    $0x4,%eax
  103dad:	8b 04 85 84 b6 10 00 	mov    0x10b684(,%eax,4),%eax
  103db4:	89 c2                	mov    %eax,%edx
  103db6:	a1 8c b6 10 00       	mov    0x10b68c,%eax
  103dbb:	83 ec 08             	sub    $0x8,%esp
  103dbe:	52                   	push   %edx
  103dbf:	50                   	push   %eax
  103dc0:	e8 7d e2 ff ff       	call   102042 <bread>
  103dc5:	83 c4 10             	add    $0x10,%esp
  103dc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
  103dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dce:	8d 50 1c             	lea    0x1c(%eax),%edx
  103dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103dd4:	83 c0 1c             	add    $0x1c,%eax
  103dd7:	83 ec 04             	sub    $0x4,%esp
  103dda:	68 00 02 00 00       	push   $0x200
  103ddf:	52                   	push   %edx
  103de0:	50                   	push   %eax
  103de1:	e8 1f d2 ff ff       	call   101005 <memmove>
  103de6:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
  103de9:	83 ec 0c             	sub    $0xc,%esp
  103dec:	ff 75 ec             	push   -0x14(%ebp)
  103def:	e8 87 e2 ff ff       	call   10207b <bwrite>
  103df4:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
  103df7:	83 ec 0c             	sub    $0xc,%esp
  103dfa:	ff 75 f0             	push   -0x10(%ebp)
  103dfd:	e8 9f e2 ff ff       	call   1020a1 <brelse>
  103e02:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
  103e05:	83 ec 0c             	sub    $0xc,%esp
  103e08:	ff 75 ec             	push   -0x14(%ebp)
  103e0b:	e8 91 e2 ff ff       	call   1020a1 <brelse>
  103e10:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  103e13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103e17:	a1 90 b6 10 00       	mov    0x10b690,%eax
  103e1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e1f:	0f 8c 5d ff ff ff    	jl     103d82 <install_trans+0x12>
  }
}
  103e25:	90                   	nop
  103e26:	90                   	nop
  103e27:	c9                   	leave  
  103e28:	c3                   	ret    

00103e29 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  103e29:	55                   	push   %ebp
  103e2a:	89 e5                	mov    %esp,%ebp
  103e2c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  103e2f:	a1 80 b6 10 00       	mov    0x10b680,%eax
  103e34:	89 c2                	mov    %eax,%edx
  103e36:	a1 8c b6 10 00       	mov    0x10b68c,%eax
  103e3b:	83 ec 08             	sub    $0x8,%esp
  103e3e:	52                   	push   %edx
  103e3f:	50                   	push   %eax
  103e40:	e8 fd e1 ff ff       	call   102042 <bread>
  103e45:	83 c4 10             	add    $0x10,%esp
  103e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
  103e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e4e:	83 c0 1c             	add    $0x1c,%eax
  103e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
  103e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e57:	8b 00                	mov    (%eax),%eax
  103e59:	a3 90 b6 10 00       	mov    %eax,0x10b690
  for (i = 0; i < log.lh.n; i++) {
  103e5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103e65:	eb 1b                	jmp    103e82 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
  103e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e6d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
  103e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e74:	83 c2 04             	add    $0x4,%edx
  103e77:	89 04 95 84 b6 10 00 	mov    %eax,0x10b684(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  103e7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103e82:	a1 90 b6 10 00       	mov    0x10b690,%eax
  103e87:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e8a:	7c db                	jl     103e67 <read_head+0x3e>
  }
  brelse(buf);
  103e8c:	83 ec 0c             	sub    $0xc,%esp
  103e8f:	ff 75 f0             	push   -0x10(%ebp)
  103e92:	e8 0a e2 ff ff       	call   1020a1 <brelse>
  103e97:	83 c4 10             	add    $0x10,%esp
}
  103e9a:	90                   	nop
  103e9b:	c9                   	leave  
  103e9c:	c3                   	ret    

00103e9d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  103e9d:	55                   	push   %ebp
  103e9e:	89 e5                	mov    %esp,%ebp
  103ea0:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  103ea3:	a1 80 b6 10 00       	mov    0x10b680,%eax
  103ea8:	89 c2                	mov    %eax,%edx
  103eaa:	a1 8c b6 10 00       	mov    0x10b68c,%eax
  103eaf:	83 ec 08             	sub    $0x8,%esp
  103eb2:	52                   	push   %edx
  103eb3:	50                   	push   %eax
  103eb4:	e8 89 e1 ff ff       	call   102042 <bread>
  103eb9:	83 c4 10             	add    $0x10,%esp
  103ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
  103ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ec2:	83 c0 1c             	add    $0x1c,%eax
  103ec5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
  103ec8:	8b 15 90 b6 10 00    	mov    0x10b690,%edx
  103ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ed1:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
  103ed3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103eda:	eb 1b                	jmp    103ef7 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
  103edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103edf:	83 c0 04             	add    $0x4,%eax
  103ee2:	8b 0c 85 84 b6 10 00 	mov    0x10b684(,%eax,4),%ecx
  103ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103eef:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  103ef3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103ef7:	a1 90 b6 10 00       	mov    0x10b690,%eax
  103efc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103eff:	7c db                	jl     103edc <write_head+0x3f>
  }
  bwrite(buf);
  103f01:	83 ec 0c             	sub    $0xc,%esp
  103f04:	ff 75 f0             	push   -0x10(%ebp)
  103f07:	e8 6f e1 ff ff       	call   10207b <bwrite>
  103f0c:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
  103f0f:	83 ec 0c             	sub    $0xc,%esp
  103f12:	ff 75 f0             	push   -0x10(%ebp)
  103f15:	e8 87 e1 ff ff       	call   1020a1 <brelse>
  103f1a:	83 c4 10             	add    $0x10,%esp
}
  103f1d:	90                   	nop
  103f1e:	c9                   	leave  
  103f1f:	c3                   	ret    

00103f20 <recover_from_log>:

static void
recover_from_log(void)
{
  103f20:	55                   	push   %ebp
  103f21:	89 e5                	mov    %esp,%ebp
  103f23:	83 ec 08             	sub    $0x8,%esp
  read_head();
  103f26:	e8 fe fe ff ff       	call   103e29 <read_head>
  install_trans(); // if committed, copy from log to disk
  103f2b:	e8 40 fe ff ff       	call   103d70 <install_trans>
  log.lh.n = 0;
  103f30:	c7 05 90 b6 10 00 00 	movl   $0x0,0x10b690
  103f37:	00 00 00 
  write_head(); // clear the log
  103f3a:	e8 5e ff ff ff       	call   103e9d <write_head>
}
  103f3f:	90                   	nop
  103f40:	c9                   	leave  
  103f41:	c3                   	ret    

00103f42 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
  103f42:	55                   	push   %ebp
  103f43:	89 e5                	mov    %esp,%ebp
  
}
  103f45:	90                   	nop
  103f46:	5d                   	pop    %ebp
  103f47:	c3                   	ret    

00103f48 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  103f48:	55                   	push   %ebp
  103f49:	89 e5                	mov    %esp,%ebp
  103f4b:	83 ec 08             	sub    $0x8,%esp
  // call commit w/o holding locks, since not allowed
  // to sleep with locks.
  commit();
  103f4e:	e8 bc 00 00 00       	call   10400f <commit>
}
  103f53:	90                   	nop
  103f54:	c9                   	leave  
  103f55:	c3                   	ret    

00103f56 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
  103f56:	55                   	push   %ebp
  103f57:	89 e5                	mov    %esp,%ebp
  103f59:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  103f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103f63:	e9 95 00 00 00       	jmp    103ffd <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
  103f68:	8b 15 80 b6 10 00    	mov    0x10b680,%edx
  103f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f71:	01 d0                	add    %edx,%eax
  103f73:	83 c0 01             	add    $0x1,%eax
  103f76:	89 c2                	mov    %eax,%edx
  103f78:	a1 8c b6 10 00       	mov    0x10b68c,%eax
  103f7d:	83 ec 08             	sub    $0x8,%esp
  103f80:	52                   	push   %edx
  103f81:	50                   	push   %eax
  103f82:	e8 bb e0 ff ff       	call   102042 <bread>
  103f87:	83 c4 10             	add    $0x10,%esp
  103f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
  103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f90:	83 c0 04             	add    $0x4,%eax
  103f93:	8b 04 85 84 b6 10 00 	mov    0x10b684(,%eax,4),%eax
  103f9a:	89 c2                	mov    %eax,%edx
  103f9c:	a1 8c b6 10 00       	mov    0x10b68c,%eax
  103fa1:	83 ec 08             	sub    $0x8,%esp
  103fa4:	52                   	push   %edx
  103fa5:	50                   	push   %eax
  103fa6:	e8 97 e0 ff ff       	call   102042 <bread>
  103fab:	83 c4 10             	add    $0x10,%esp
  103fae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
  103fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fb4:	8d 50 1c             	lea    0x1c(%eax),%edx
  103fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fba:	83 c0 1c             	add    $0x1c,%eax
  103fbd:	83 ec 04             	sub    $0x4,%esp
  103fc0:	68 00 02 00 00       	push   $0x200
  103fc5:	52                   	push   %edx
  103fc6:	50                   	push   %eax
  103fc7:	e8 39 d0 ff ff       	call   101005 <memmove>
  103fcc:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
  103fcf:	83 ec 0c             	sub    $0xc,%esp
  103fd2:	ff 75 f0             	push   -0x10(%ebp)
  103fd5:	e8 a1 e0 ff ff       	call   10207b <bwrite>
  103fda:	83 c4 10             	add    $0x10,%esp
    brelse(from);
  103fdd:	83 ec 0c             	sub    $0xc,%esp
  103fe0:	ff 75 ec             	push   -0x14(%ebp)
  103fe3:	e8 b9 e0 ff ff       	call   1020a1 <brelse>
  103fe8:	83 c4 10             	add    $0x10,%esp
    brelse(to);
  103feb:	83 ec 0c             	sub    $0xc,%esp
  103fee:	ff 75 f0             	push   -0x10(%ebp)
  103ff1:	e8 ab e0 ff ff       	call   1020a1 <brelse>
  103ff6:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  103ff9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103ffd:	a1 90 b6 10 00       	mov    0x10b690,%eax
  104002:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104005:	0f 8c 5d ff ff ff    	jl     103f68 <write_log+0x12>
  }
}
  10400b:	90                   	nop
  10400c:	90                   	nop
  10400d:	c9                   	leave  
  10400e:	c3                   	ret    

0010400f <commit>:

static void
commit()
{
  10400f:	55                   	push   %ebp
  104010:	89 e5                	mov    %esp,%ebp
  104012:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
  104015:	a1 90 b6 10 00       	mov    0x10b690,%eax
  10401a:	85 c0                	test   %eax,%eax
  10401c:	7e 1e                	jle    10403c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
  10401e:	e8 33 ff ff ff       	call   103f56 <write_log>
    write_head();    // Write header to disk -- the real commit
  104023:	e8 75 fe ff ff       	call   103e9d <write_head>
    install_trans(); // Now install writes to home locations
  104028:	e8 43 fd ff ff       	call   103d70 <install_trans>
    log.lh.n = 0;
  10402d:	c7 05 90 b6 10 00 00 	movl   $0x0,0x10b690
  104034:	00 00 00 
    write_head();    // Erase the transaction from the log
  104037:	e8 61 fe ff ff       	call   103e9d <write_head>
  }
}
  10403c:	90                   	nop
  10403d:	c9                   	leave  
  10403e:	c3                   	ret    

0010403f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
  10403f:	55                   	push   %ebp
  104040:	89 e5                	mov    %esp,%ebp
  104042:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
  104045:	a1 90 b6 10 00       	mov    0x10b690,%eax
  10404a:	83 f8 1d             	cmp    $0x1d,%eax
  10404d:	7f 12                	jg     104061 <log_write+0x22>
  10404f:	a1 90 b6 10 00       	mov    0x10b690,%eax
  104054:	8b 15 84 b6 10 00    	mov    0x10b684,%edx
  10405a:	83 ea 01             	sub    $0x1,%edx
  10405d:	39 d0                	cmp    %edx,%eax
  10405f:	7c 0d                	jl     10406e <log_write+0x2f>
    panic("too big a transaction");
  104061:	83 ec 0c             	sub    $0xc,%esp
  104064:	68 e7 44 10 00       	push   $0x1044e7
  104069:	e8 3f c2 ff ff       	call   1002ad <panic>

  for (i = 0; i < log.lh.n; i++) {
  10406e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104075:	eb 1d                	jmp    104094 <log_write+0x55>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
  104077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10407a:	83 c0 04             	add    $0x4,%eax
  10407d:	8b 04 85 84 b6 10 00 	mov    0x10b684(,%eax,4),%eax
  104084:	89 c2                	mov    %eax,%edx
  104086:	8b 45 08             	mov    0x8(%ebp),%eax
  104089:	8b 40 08             	mov    0x8(%eax),%eax
  10408c:	39 c2                	cmp    %eax,%edx
  10408e:	74 10                	je     1040a0 <log_write+0x61>
  for (i = 0; i < log.lh.n; i++) {
  104090:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104094:	a1 90 b6 10 00       	mov    0x10b690,%eax
  104099:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10409c:	7c d9                	jl     104077 <log_write+0x38>
  10409e:	eb 01                	jmp    1040a1 <log_write+0x62>
      break;
  1040a0:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
  1040a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1040a4:	8b 40 08             	mov    0x8(%eax),%eax
  1040a7:	89 c2                	mov    %eax,%edx
  1040a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040ac:	83 c0 04             	add    $0x4,%eax
  1040af:	89 14 85 84 b6 10 00 	mov    %edx,0x10b684(,%eax,4)
  if (i == log.lh.n)
  1040b6:	a1 90 b6 10 00       	mov    0x10b690,%eax
  1040bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1040be:	75 0d                	jne    1040cd <log_write+0x8e>
    log.lh.n++;
  1040c0:	a1 90 b6 10 00       	mov    0x10b690,%eax
  1040c5:	83 c0 01             	add    $0x1,%eax
  1040c8:	a3 90 b6 10 00       	mov    %eax,0x10b690
  b->flags |= B_DIRTY; // prevent eviction
  1040cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1040d0:	8b 00                	mov    (%eax),%eax
  1040d2:	83 c8 04             	or     $0x4,%eax
  1040d5:	89 c2                	mov    %eax,%edx
  1040d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1040da:	89 10                	mov    %edx,(%eax)
  1040dc:	90                   	nop
  1040dd:	c9                   	leave  
  1040de:	c3                   	ret    
