
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	354080e7          	jalr	852(ra) # 37e <mkdir>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	80258593          	addi	a1,a1,-2046 # 840 <malloc+0xe4>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	628080e7          	jalr	1576(ra) # 670 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2c4080e7          	jalr	708(ra) # 316 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00000597          	auipc	a1,0x0
  60:	7fc58593          	addi	a1,a1,2044 # 858 <malloc+0xfc>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	60a080e7          	jalr	1546(ra) # 670 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	2a6080e7          	jalr	678(ra) # 316 <exit>

0000000000000078 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	28c080e7          	jalr	652(ra) # 316 <exit>

0000000000000092 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
    ;
  return os;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x1e>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x1e>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strlen>:

uint
strlen(const char *s)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x26>
  e6:	0505                	addi	a0,a0,1
  e8:	87aa                	mv	a5,a0
  ea:	4685                	li	a3,1
  ec:	9e89                	subw	a3,a3,a0
  ee:	00f6853b          	addw	a0,a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	fb7d                	bnez	a4,ee <strlen+0x14>
    ;
  return n;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
  for(n = 0; s[n]; n++)
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strlen+0x20>

0000000000000104 <memset>:

void*
memset(void *dst, int c, uint n)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10a:	ca19                	beqz	a2,120 <memset+0x1c>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 116:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x12>
  }
  return dst;
}
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb99                	beqz	a5,146 <strchr+0x20>
    if(*s == c)
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1a>
  for(; *s; s++)
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xc>
      return (char*)s;
  return 0;
 13e:	4501                	li	a0,0
}
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  return 0;
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strchr+0x1a>

000000000000014a <gets>:

char*
gets(char *buf, int max)
{
 14a:	711d                	addi	sp,sp,-96
 14c:	ec86                	sd	ra,88(sp)
 14e:	e8a2                	sd	s0,80(sp)
 150:	e4a6                	sd	s1,72(sp)
 152:	e0ca                	sd	s2,64(sp)
 154:	fc4e                	sd	s3,56(sp)
 156:	f852                	sd	s4,48(sp)
 158:	f456                	sd	s5,40(sp)
 15a:	f05a                	sd	s6,32(sp)
 15c:	ec5e                	sd	s7,24(sp)
 15e:	1080                	addi	s0,sp,96
 160:	8baa                	mv	s7,a0
 162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 168:	4aa9                	li	s5,10
 16a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	2485                	addiw	s1,s1,1
 170:	0344d863          	bge	s1,s4,1a0 <gets+0x56>
    cc = read(0, &c, 1);
 174:	4605                	li	a2,1
 176:	faf40593          	addi	a1,s0,-81
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	1b2080e7          	jalr	434(ra) # 32e <read>
    if(cc < 1)
 184:	00a05e63          	blez	a0,1a0 <gets+0x56>
    buf[i++] = c;
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 190:	01578763          	beq	a5,s5,19e <gets+0x54>
 194:	0905                	addi	s2,s2,1
 196:	fd679be3          	bne	a5,s6,16c <gets+0x22>
  for(i=0; i+1 < max; ){
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x56>
 19e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e426                	sd	s1,8(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	188080e7          	jalr	392(ra) # 356 <open>
  if(fd < 0)
 1d6:	02054563          	bltz	a0,200 <stat+0x42>
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	190080e7          	jalr	400(ra) # 36e <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	154080e7          	jalr	340(ra) # 33e <close>
  return r;
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	64a2                	ld	s1,8(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
    return -1;
 200:	597d                	li	s2,-1
 202:	bfc5                	j	1f2 <stat+0x34>

0000000000000204 <atoi>:

int
atoi(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054603          	lbu	a2,0(a0)
 20e:	fd06079b          	addiw	a5,a2,-48
 212:	0ff7f793          	andi	a5,a5,255
 216:	4725                	li	a4,9
 218:	02f76963          	bltu	a4,a5,24a <atoi+0x46>
 21c:	86aa                	mv	a3,a0
  n = 0;
 21e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 220:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 222:	0685                	addi	a3,a3,1
 224:	0025179b          	slliw	a5,a0,0x2
 228:	9fa9                	addw	a5,a5,a0
 22a:	0017979b          	slliw	a5,a5,0x1
 22e:	9fb1                	addw	a5,a5,a2
 230:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 234:	0006c603          	lbu	a2,0(a3)
 238:	fd06071b          	addiw	a4,a2,-48
 23c:	0ff77713          	andi	a4,a4,255
 240:	fee5f1e3          	bgeu	a1,a4,222 <atoi+0x1e>
  return n;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <atoi+0x40>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57463          	bgeu	a0,a1,27c <memmove+0x2e>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x28>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x28>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x46>
 2a4:	bfc9                	j	276 <memmove+0x28>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addiw	a3,a2,-1
 2b2:	1682                	slli	a3,a3,0x20
 2b4:	9281                	srli	a3,a3,0x20
 2b6:	0685                	addi	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f66080e7          	jalr	-154(ra) # 24e <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 2fe:	040007b7          	lui	a5,0x4000
}
 302:	17f5                	addi	a5,a5,-3
 304:	07b2                	slli	a5,a5,0xc
 306:	4388                	lw	a0,0(a5)
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30e:	4885                	li	a7,1
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <exit>:
.global exit
exit:
 li a7, SYS_exit
 316:	4889                	li	a7,2
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <wait>:
.global wait
wait:
 li a7, SYS_wait
 31e:	488d                	li	a7,3
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 326:	4891                	li	a7,4
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <read>:
.global read
read:
 li a7, SYS_read
 32e:	4895                	li	a7,5
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <write>:
.global write
write:
 li a7, SYS_write
 336:	48c1                	li	a7,16
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <close>:
.global close
close:
 li a7, SYS_close
 33e:	48d5                	li	a7,21
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <kill>:
.global kill
kill:
 li a7, SYS_kill
 346:	4899                	li	a7,6
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exec>:
.global exec
exec:
 li a7, SYS_exec
 34e:	489d                	li	a7,7
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <open>:
.global open
open:
 li a7, SYS_open
 356:	48bd                	li	a7,15
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35e:	48c5                	li	a7,17
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 366:	48c9                	li	a7,18
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36e:	48a1                	li	a7,8
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <link>:
.global link
link:
 li a7, SYS_link
 376:	48cd                	li	a7,19
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37e:	48d1                	li	a7,20
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 386:	48a5                	li	a7,9
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <dup>:
.global dup
dup:
 li a7, SYS_dup
 38e:	48a9                	li	a7,10
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 396:	48ad                	li	a7,11
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39e:	48b1                	li	a7,12
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a6:	48b5                	li	a7,13
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ae:	48b9                	li	a7,14
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3b6:	48f5                	li	a7,29
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3be:	48f9                	li	a7,30
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c6:	1101                	addi	sp,sp,-32
 3c8:	ec06                	sd	ra,24(sp)
 3ca:	e822                	sd	s0,16(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	fef40593          	addi	a1,s0,-17
 3d8:	00000097          	auipc	ra,0x0
 3dc:	f5e080e7          	jalr	-162(ra) # 336 <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e8:	7139                	addi	sp,sp,-64
 3ea:	fc06                	sd	ra,56(sp)
 3ec:	f822                	sd	s0,48(sp)
 3ee:	f426                	sd	s1,40(sp)
 3f0:	f04a                	sd	s2,32(sp)
 3f2:	ec4e                	sd	s3,24(sp)
 3f4:	0080                	addi	s0,sp,64
 3f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c299                	beqz	a3,3fe <printint+0x16>
 3fa:	0805c863          	bltz	a1,48a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fe:	2581                	sext.w	a1,a1
  neg = 0;
 400:	4881                	li	a7,0
 402:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 406:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 408:	2601                	sext.w	a2,a2
 40a:	00000517          	auipc	a0,0x0
 40e:	47650513          	addi	a0,a0,1142 # 880 <digits>
 412:	883a                	mv	a6,a4
 414:	2705                	addiw	a4,a4,1
 416:	02c5f7bb          	remuw	a5,a1,a2
 41a:	1782                	slli	a5,a5,0x20
 41c:	9381                	srli	a5,a5,0x20
 41e:	97aa                	add	a5,a5,a0
 420:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffeff0>
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	0005879b          	sext.w	a5,a1
 42c:	02c5d5bb          	divuw	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f0e3          	bgeu	a5,a2,412 <printint+0x2a>
  if(neg)
 436:	00088b63          	beqz	a7,44c <printint+0x64>
    buf[i++] = '-';
 43a:	fd040793          	addi	a5,s0,-48
 43e:	973e                	add	a4,a4,a5
 440:	02d00793          	li	a5,45
 444:	fef70823          	sb	a5,-16(a4)
 448:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44c:	02e05863          	blez	a4,47c <printint+0x94>
 450:	fc040793          	addi	a5,s0,-64
 454:	00e78933          	add	s2,a5,a4
 458:	fff78993          	addi	s3,a5,-1
 45c:	99ba                	add	s3,s3,a4
 45e:	377d                	addiw	a4,a4,-1
 460:	1702                	slli	a4,a4,0x20
 462:	9301                	srli	a4,a4,0x20
 464:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 468:	fff94583          	lbu	a1,-1(s2)
 46c:	8526                	mv	a0,s1
 46e:	00000097          	auipc	ra,0x0
 472:	f58080e7          	jalr	-168(ra) # 3c6 <putc>
  while(--i >= 0)
 476:	197d                	addi	s2,s2,-1
 478:	ff3918e3          	bne	s2,s3,468 <printint+0x80>
}
 47c:	70e2                	ld	ra,56(sp)
 47e:	7442                	ld	s0,48(sp)
 480:	74a2                	ld	s1,40(sp)
 482:	7902                	ld	s2,32(sp)
 484:	69e2                	ld	s3,24(sp)
 486:	6121                	addi	sp,sp,64
 488:	8082                	ret
    x = -xx;
 48a:	40b005bb          	negw	a1,a1
    neg = 1;
 48e:	4885                	li	a7,1
    x = -xx;
 490:	bf8d                	j	402 <printint+0x1a>

0000000000000492 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 492:	7119                	addi	sp,sp,-128
 494:	fc86                	sd	ra,120(sp)
 496:	f8a2                	sd	s0,112(sp)
 498:	f4a6                	sd	s1,104(sp)
 49a:	f0ca                	sd	s2,96(sp)
 49c:	ecce                	sd	s3,88(sp)
 49e:	e8d2                	sd	s4,80(sp)
 4a0:	e4d6                	sd	s5,72(sp)
 4a2:	e0da                	sd	s6,64(sp)
 4a4:	fc5e                	sd	s7,56(sp)
 4a6:	f862                	sd	s8,48(sp)
 4a8:	f466                	sd	s9,40(sp)
 4aa:	f06a                	sd	s10,32(sp)
 4ac:	ec6e                	sd	s11,24(sp)
 4ae:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b0:	0005c903          	lbu	s2,0(a1)
 4b4:	18090f63          	beqz	s2,652 <vprintf+0x1c0>
 4b8:	8aaa                	mv	s5,a0
 4ba:	8b32                	mv	s6,a2
 4bc:	00158493          	addi	s1,a1,1
  state = 0;
 4c0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c2:	02500a13          	li	s4,37
      if(c == 'd'){
 4c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ca:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4ce:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4d2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d6:	00000b97          	auipc	s7,0x0
 4da:	3aab8b93          	addi	s7,s7,938 # 880 <digits>
 4de:	a839                	j	4fc <vprintf+0x6a>
        putc(fd, c);
 4e0:	85ca                	mv	a1,s2
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	ee2080e7          	jalr	-286(ra) # 3c6 <putc>
 4ec:	a019                	j	4f2 <vprintf+0x60>
    } else if(state == '%'){
 4ee:	01498f63          	beq	s3,s4,50c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4f2:	0485                	addi	s1,s1,1
 4f4:	fff4c903          	lbu	s2,-1(s1)
 4f8:	14090d63          	beqz	s2,652 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 500:	fe0997e3          	bnez	s3,4ee <vprintf+0x5c>
      if(c == '%'){
 504:	fd479ee3          	bne	a5,s4,4e0 <vprintf+0x4e>
        state = '%';
 508:	89be                	mv	s3,a5
 50a:	b7e5                	j	4f2 <vprintf+0x60>
      if(c == 'd'){
 50c:	05878063          	beq	a5,s8,54c <vprintf+0xba>
      } else if(c == 'l') {
 510:	05978c63          	beq	a5,s9,568 <vprintf+0xd6>
      } else if(c == 'x') {
 514:	07a78863          	beq	a5,s10,584 <vprintf+0xf2>
      } else if(c == 'p') {
 518:	09b78463          	beq	a5,s11,5a0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 51c:	07300713          	li	a4,115
 520:	0ce78663          	beq	a5,a4,5ec <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 524:	06300713          	li	a4,99
 528:	0ee78e63          	beq	a5,a4,624 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 52c:	11478863          	beq	a5,s4,63c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 530:	85d2                	mv	a1,s4
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e92080e7          	jalr	-366(ra) # 3c6 <putc>
        putc(fd, c);
 53c:	85ca                	mv	a1,s2
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e86080e7          	jalr	-378(ra) # 3c6 <putc>
      }
      state = 0;
 548:	4981                	li	s3,0
 54a:	b765                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 54c:	008b0913          	addi	s2,s6,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e8e080e7          	jalr	-370(ra) # 3e8 <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	b771                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	008b0913          	addi	s2,s6,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000b2583          	lw	a1,0(s6)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e72080e7          	jalr	-398(ra) # 3e8 <printint>
 57e:	8b4a                	mv	s6,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	bf85                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 584:	008b0913          	addi	s2,s6,8
 588:	4681                	li	a3,0
 58a:	4641                	li	a2,16
 58c:	000b2583          	lw	a1,0(s6)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e56080e7          	jalr	-426(ra) # 3e8 <printint>
 59a:	8b4a                	mv	s6,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bf91                	j	4f2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5a0:	008b0793          	addi	a5,s6,8
 5a4:	f8f43423          	sd	a5,-120(s0)
 5a8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ac:	03000593          	li	a1,48
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e14080e7          	jalr	-492(ra) # 3c6 <putc>
  putc(fd, 'x');
 5ba:	85ea                	mv	a1,s10
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e08080e7          	jalr	-504(ra) # 3c6 <putc>
 5c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	03c9d793          	srli	a5,s3,0x3c
 5cc:	97de                	add	a5,a5,s7
 5ce:	0007c583          	lbu	a1,0(a5)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	df2080e7          	jalr	-526(ra) # 3c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5dc:	0992                	slli	s3,s3,0x4
 5de:	397d                	addiw	s2,s2,-1
 5e0:	fe0914e3          	bnez	s2,5c8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5e4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b721                	j	4f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ec:	008b0993          	addi	s3,s6,8
 5f0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5f4:	02090163          	beqz	s2,616 <vprintf+0x184>
        while(*s != 0){
 5f8:	00094583          	lbu	a1,0(s2)
 5fc:	c9a1                	beqz	a1,64c <vprintf+0x1ba>
          putc(fd, *s);
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dc6080e7          	jalr	-570(ra) # 3c6 <putc>
          s++;
 608:	0905                	addi	s2,s2,1
        while(*s != 0){
 60a:	00094583          	lbu	a1,0(s2)
 60e:	f9e5                	bnez	a1,5fe <vprintf+0x16c>
        s = va_arg(ap, char*);
 610:	8b4e                	mv	s6,s3
      state = 0;
 612:	4981                	li	s3,0
 614:	bdf9                	j	4f2 <vprintf+0x60>
          s = "(null)";
 616:	00000917          	auipc	s2,0x0
 61a:	26290913          	addi	s2,s2,610 # 878 <malloc+0x11c>
        while(*s != 0){
 61e:	02800593          	li	a1,40
 622:	bff1                	j	5fe <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 624:	008b0913          	addi	s2,s6,8
 628:	000b4583          	lbu	a1,0(s6)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	d98080e7          	jalr	-616(ra) # 3c6 <putc>
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd65                	j	4f2 <vprintf+0x60>
        putc(fd, c);
 63c:	85d2                	mv	a1,s4
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d86080e7          	jalr	-634(ra) # 3c6 <putc>
      state = 0;
 648:	4981                	li	s3,0
 64a:	b565                	j	4f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 64c:	8b4e                	mv	s6,s3
      state = 0;
 64e:	4981                	li	s3,0
 650:	b54d                	j	4f2 <vprintf+0x60>
    }
  }
}
 652:	70e6                	ld	ra,120(sp)
 654:	7446                	ld	s0,112(sp)
 656:	74a6                	ld	s1,104(sp)
 658:	7906                	ld	s2,96(sp)
 65a:	69e6                	ld	s3,88(sp)
 65c:	6a46                	ld	s4,80(sp)
 65e:	6aa6                	ld	s5,72(sp)
 660:	6b06                	ld	s6,64(sp)
 662:	7be2                	ld	s7,56(sp)
 664:	7c42                	ld	s8,48(sp)
 666:	7ca2                	ld	s9,40(sp)
 668:	7d02                	ld	s10,32(sp)
 66a:	6de2                	ld	s11,24(sp)
 66c:	6109                	addi	sp,sp,128
 66e:	8082                	ret

0000000000000670 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 670:	715d                	addi	sp,sp,-80
 672:	ec06                	sd	ra,24(sp)
 674:	e822                	sd	s0,16(sp)
 676:	1000                	addi	s0,sp,32
 678:	e010                	sd	a2,0(s0)
 67a:	e414                	sd	a3,8(s0)
 67c:	e818                	sd	a4,16(s0)
 67e:	ec1c                	sd	a5,24(s0)
 680:	03043023          	sd	a6,32(s0)
 684:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 688:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68c:	8622                	mv	a2,s0
 68e:	00000097          	auipc	ra,0x0
 692:	e04080e7          	jalr	-508(ra) # 492 <vprintf>
}
 696:	60e2                	ld	ra,24(sp)
 698:	6442                	ld	s0,16(sp)
 69a:	6161                	addi	sp,sp,80
 69c:	8082                	ret

000000000000069e <printf>:

void
printf(const char *fmt, ...)
{
 69e:	711d                	addi	sp,sp,-96
 6a0:	ec06                	sd	ra,24(sp)
 6a2:	e822                	sd	s0,16(sp)
 6a4:	1000                	addi	s0,sp,32
 6a6:	e40c                	sd	a1,8(s0)
 6a8:	e810                	sd	a2,16(s0)
 6aa:	ec14                	sd	a3,24(s0)
 6ac:	f018                	sd	a4,32(s0)
 6ae:	f41c                	sd	a5,40(s0)
 6b0:	03043823          	sd	a6,48(s0)
 6b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	00840613          	addi	a2,s0,8
 6bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c0:	85aa                	mv	a1,a0
 6c2:	4505                	li	a0,1
 6c4:	00000097          	auipc	ra,0x0
 6c8:	dce080e7          	jalr	-562(ra) # 492 <vprintf>
}
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret

00000000000006d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	00001797          	auipc	a5,0x1
 6e2:	9227b783          	ld	a5,-1758(a5) # 1000 <freep>
 6e6:	a805                	j	716 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e8:	4618                	lw	a4,8(a2)
 6ea:	9db9                	addw	a1,a1,a4
 6ec:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	6398                	ld	a4,0(a5)
 6f2:	6318                	ld	a4,0(a4)
 6f4:	fee53823          	sd	a4,-16(a0)
 6f8:	a091                	j	73c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fa:	ff852703          	lw	a4,-8(a0)
 6fe:	9e39                	addw	a2,a2,a4
 700:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 702:	ff053703          	ld	a4,-16(a0)
 706:	e398                	sd	a4,0(a5)
 708:	a099                	j	74e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x40>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x50>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x36>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059713          	slli	a4,a1,0x20
 72e:	9301                	srli	a4,a4,0x20
 730:	0712                	slli	a4,a4,0x4
 732:	9736                	add	a4,a4,a3
 734:	fae60ae3          	beq	a2,a4,6e8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061713          	slli	a4,a2,0x20
 742:	9301                	srli	a4,a4,0x20
 744:	0712                	slli	a4,a4,0x4
 746:	973e                	add	a4,a4,a5
 748:	fae689e3          	beq	a3,a4,6fa <free+0x26>
  } else
    p->s.ptr = bp;
 74c:	e394                	sd	a3,0(a5)
  freep = p;
 74e:	00001717          	auipc	a4,0x1
 752:	8af73923          	sd	a5,-1870(a4) # 1000 <freep>
}
 756:	6422                	ld	s0,8(sp)
 758:	0141                	addi	sp,sp,16
 75a:	8082                	ret

000000000000075c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75c:	7139                	addi	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f426                	sd	s1,40(sp)
 764:	f04a                	sd	s2,32(sp)
 766:	ec4e                	sd	s3,24(sp)
 768:	e852                	sd	s4,16(sp)
 76a:	e456                	sd	s5,8(sp)
 76c:	e05a                	sd	s6,0(sp)
 76e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	02051493          	slli	s1,a0,0x20
 774:	9081                	srli	s1,s1,0x20
 776:	04bd                	addi	s1,s1,15
 778:	8091                	srli	s1,s1,0x4
 77a:	0014899b          	addiw	s3,s1,1
 77e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 780:	00001517          	auipc	a0,0x1
 784:	88053503          	ld	a0,-1920(a0) # 1000 <freep>
 788:	c515                	beqz	a0,7b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78c:	4798                	lw	a4,8(a5)
 78e:	02977f63          	bgeu	a4,s1,7cc <malloc+0x70>
 792:	8a4e                	mv	s4,s3
 794:	0009871b          	sext.w	a4,s3
 798:	6685                	lui	a3,0x1
 79a:	00d77363          	bgeu	a4,a3,7a0 <malloc+0x44>
 79e:	6a05                	lui	s4,0x1
 7a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a8:	00001917          	auipc	s2,0x1
 7ac:	85890913          	addi	s2,s2,-1960 # 1000 <freep>
  if(p == (char*)-1)
 7b0:	5afd                	li	s5,-1
 7b2:	a88d                	j	824 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7b4:	00001797          	auipc	a5,0x1
 7b8:	85c78793          	addi	a5,a5,-1956 # 1010 <base>
 7bc:	00001717          	auipc	a4,0x1
 7c0:	84f73223          	sd	a5,-1980(a4) # 1000 <freep>
 7c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ca:	b7e1                	j	792 <malloc+0x36>
      if(p->s.size == nunits)
 7cc:	02e48b63          	beq	s1,a4,802 <malloc+0xa6>
        p->s.size -= nunits;
 7d0:	4137073b          	subw	a4,a4,s3
 7d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d6:	1702                	slli	a4,a4,0x20
 7d8:	9301                	srli	a4,a4,0x20
 7da:	0712                	slli	a4,a4,0x4
 7dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80a73f23          	sd	a0,-2018(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ea:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ee:	70e2                	ld	ra,56(sp)
 7f0:	7442                	ld	s0,48(sp)
 7f2:	74a2                	ld	s1,40(sp)
 7f4:	7902                	ld	s2,32(sp)
 7f6:	69e2                	ld	s3,24(sp)
 7f8:	6a42                	ld	s4,16(sp)
 7fa:	6aa2                	ld	s5,8(sp)
 7fc:	6b02                	ld	s6,0(sp)
 7fe:	6121                	addi	sp,sp,64
 800:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	e118                	sd	a4,0(a0)
 806:	bff1                	j	7e2 <malloc+0x86>
  hp->s.size = nu;
 808:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80c:	0541                	addi	a0,a0,16
 80e:	00000097          	auipc	ra,0x0
 812:	ec6080e7          	jalr	-314(ra) # 6d4 <free>
  return freep;
 816:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81a:	d971                	beqz	a0,7ee <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	fa9776e3          	bgeu	a4,s1,7cc <malloc+0x70>
    if(p == freep)
 824:	00093703          	ld	a4,0(s2)
 828:	853e                	mv	a0,a5
 82a:	fef719e3          	bne	a4,a5,81c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 82e:	8552                	mv	a0,s4
 830:	00000097          	auipc	ra,0x0
 834:	b6e080e7          	jalr	-1170(ra) # 39e <sbrk>
  if(p == (char*)-1)
 838:	fd5518e3          	bne	a0,s5,808 <malloc+0xac>
        return 0;
 83c:	4501                	li	a0,0
 83e:	bf45                	j	7ee <malloc+0x92>
