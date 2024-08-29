
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define STDIN 0

#define BUFFER_SIZE 512

int main(int argc, char *argv[]) {
   0:	cc010113          	addi	sp,sp,-832
   4:	32113c23          	sd	ra,824(sp)
   8:	32813823          	sd	s0,816(sp)
   c:	32913423          	sd	s1,808(sp)
  10:	33213023          	sd	s2,800(sp)
  14:	31313c23          	sd	s3,792(sp)
  18:	31413823          	sd	s4,784(sp)
  1c:	31513423          	sd	s5,776(sp)
  20:	0680                	addi	s0,sp,832
  char buf[BUFFER_SIZE];
  char *newargv[MAXARG];
  int i = 0, j;

  if (argc < 2) {
  22:	4785                	li	a5,1
  24:	04a7db63          	bge	a5,a0,7a <main+0x7a>
  28:	8aae                	mv	s5,a1
  2a:	ffe5091b          	addiw	s2,a0,-2
  2e:	1902                	slli	s2,s2,0x20
  30:	02095913          	srli	s2,s2,0x20
  34:	090e                	slli	s2,s2,0x3
  36:	cc840793          	addi	a5,s0,-824
  3a:	993e                	add	s2,s2,a5
  int i = 0, j;
  3c:	4481                	li	s1,0
      buf[i] = '\0';
      i = 0;
      for (j = 0; j + 1 < argc; j++) {
        newargv[j] = argv[j + 1];
      }
      newargv[j++] = buf;
  3e:	fff50a1b          	addiw	s4,a0,-1
  42:	0a0e                	slli	s4,s4,0x3
  44:	fc040793          	addi	a5,s0,-64
  48:	9a3e                	add	s4,s4,a5
      newargv[j] = (void *)0;
  4a:	050e                	slli	a0,a0,0x3
  4c:	00a789b3          	add	s3,a5,a0
  while (read(STDIN, &buf[i], 1) != 0) {
  50:	4605                	li	a2,1
  52:	dc040793          	addi	a5,s0,-576
  56:	009785b3          	add	a1,a5,s1
  5a:	4501                	li	a0,0
  5c:	00000097          	auipc	ra,0x0
  60:	338080e7          	jalr	824(ra) # 394 <read>
  64:	c541                	beqz	a0,ec <main+0xec>
    if (buf[i] == '\n') {
  66:	fc040793          	addi	a5,s0,-64
  6a:	97a6                	add	a5,a5,s1
  6c:	e007c703          	lbu	a4,-512(a5)
  70:	47a9                	li	a5,10
  72:	02f70263          	beq	a4,a5,96 <main+0x96>
        exec(argv[1], newargv);
      } else {
        wait((void *)0);
      }
    } else {
      ++i;
  76:	2485                	addiw	s1,s1,1
  78:	bfe1                	j	50 <main+0x50>
    fprintf(2, "Usage: xargs [options] [command [initial-arguments]]\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	82658593          	addi	a1,a1,-2010 # 8a0 <malloc+0xee>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	642080e7          	jalr	1602(ra) # 6c6 <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	2ee080e7          	jalr	750(ra) # 37c <exit>
      buf[i] = '\0';
  96:	fc040793          	addi	a5,s0,-64
  9a:	94be                	add	s1,s1,a5
  9c:	e0048023          	sb	zero,-512(s1)
      for (j = 0; j + 1 < argc; j++) {
  a0:	008a8713          	addi	a4,s5,8
      buf[i] = '\0';
  a4:	cc040793          	addi	a5,s0,-832
        newargv[j] = argv[j + 1];
  a8:	6314                	ld	a3,0(a4)
  aa:	e394                	sd	a3,0(a5)
      for (j = 0; j + 1 < argc; j++) {
  ac:	0721                	addi	a4,a4,8
  ae:	07a1                	addi	a5,a5,8
  b0:	ff279ce3          	bne	a5,s2,a8 <main+0xa8>
      newargv[j++] = buf;
  b4:	dc040793          	addi	a5,s0,-576
  b8:	d0fa3023          	sd	a5,-768(s4)
      newargv[j] = (void *)0;
  bc:	d009b023          	sd	zero,-768(s3)
      if (fork() == 0) {
  c0:	00000097          	auipc	ra,0x0
  c4:	2b4080e7          	jalr	692(ra) # 374 <fork>
  c8:	84aa                	mv	s1,a0
  ca:	e911                	bnez	a0,de <main+0xde>
        exec(argv[1], newargv);
  cc:	cc040593          	addi	a1,s0,-832
  d0:	008ab503          	ld	a0,8(s5)
  d4:	00000097          	auipc	ra,0x0
  d8:	2e0080e7          	jalr	736(ra) # 3b4 <exec>
  dc:	bf95                	j	50 <main+0x50>
        wait((void *)0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2a4080e7          	jalr	676(ra) # 384 <wait>
      i = 0;
  e8:	4481                	li	s1,0
  ea:	b79d                	j	50 <main+0x50>
    }
  }
  exit(0);
  ec:	00000097          	auipc	ra,0x0
  f0:	290080e7          	jalr	656(ra) # 37c <exit>

00000000000000f4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  extern int main();
  main();
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <main>
  exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	276080e7          	jalr	630(ra) # 37c <exit>

000000000000010e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 114:	87aa                	mv	a5,a0
 116:	0585                	addi	a1,a1,1
 118:	0785                	addi	a5,a5,1
 11a:	fff5c703          	lbu	a4,-1(a1)
 11e:	fee78fa3          	sb	a4,-1(a5)
 122:	fb75                	bnez	a4,116 <strcpy+0x8>
    ;
  return os;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb91                	beqz	a5,148 <strcmp+0x1e>
 136:	0005c703          	lbu	a4,0(a1)
 13a:	00f71763          	bne	a4,a5,148 <strcmp+0x1e>
    p++, q++;
 13e:	0505                	addi	a0,a0,1
 140:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 142:	00054783          	lbu	a5,0(a0)
 146:	fbe5                	bnez	a5,136 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 148:	0005c503          	lbu	a0,0(a1)
}
 14c:	40a7853b          	subw	a0,a5,a0
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cf91                	beqz	a5,17c <strlen+0x26>
 162:	0505                	addi	a0,a0,1
 164:	87aa                	mv	a5,a0
 166:	4685                	li	a3,1
 168:	9e89                	subw	a3,a3,a0
 16a:	00f6853b          	addw	a0,a3,a5
 16e:	0785                	addi	a5,a5,1
 170:	fff7c703          	lbu	a4,-1(a5)
 174:	fb7d                	bnez	a4,16a <strlen+0x14>
    ;
  return n;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret
  for(n = 0; s[n]; n++)
 17c:	4501                	li	a0,0
 17e:	bfe5                	j	176 <strlen+0x20>

0000000000000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 186:	ca19                	beqz	a2,19c <memset+0x1c>
 188:	87aa                	mv	a5,a0
 18a:	1602                	slli	a2,a2,0x20
 18c:	9201                	srli	a2,a2,0x20
 18e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 192:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 196:	0785                	addi	a5,a5,1
 198:	fee79de3          	bne	a5,a4,192 <memset+0x12>
  }
  return dst;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strchr>:

char*
strchr(const char *s, char c)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	cb99                	beqz	a5,1c2 <strchr+0x20>
    if(*s == c)
 1ae:	00f58763          	beq	a1,a5,1bc <strchr+0x1a>
  for(; *s; s++)
 1b2:	0505                	addi	a0,a0,1
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	fbfd                	bnez	a5,1ae <strchr+0xc>
      return (char*)s;
  return 0;
 1ba:	4501                	li	a0,0
}
 1bc:	6422                	ld	s0,8(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret
  return 0;
 1c2:	4501                	li	a0,0
 1c4:	bfe5                	j	1bc <strchr+0x1a>

00000000000001c6 <gets>:

char*
gets(char *buf, int max)
{
 1c6:	711d                	addi	sp,sp,-96
 1c8:	ec86                	sd	ra,88(sp)
 1ca:	e8a2                	sd	s0,80(sp)
 1cc:	e4a6                	sd	s1,72(sp)
 1ce:	e0ca                	sd	s2,64(sp)
 1d0:	fc4e                	sd	s3,56(sp)
 1d2:	f852                	sd	s4,48(sp)
 1d4:	f456                	sd	s5,40(sp)
 1d6:	f05a                	sd	s6,32(sp)
 1d8:	ec5e                	sd	s7,24(sp)
 1da:	1080                	addi	s0,sp,96
 1dc:	8baa                	mv	s7,a0
 1de:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	892a                	mv	s2,a0
 1e2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e4:	4aa9                	li	s5,10
 1e6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e8:	89a6                	mv	s3,s1
 1ea:	2485                	addiw	s1,s1,1
 1ec:	0344d863          	bge	s1,s4,21c <gets+0x56>
    cc = read(0, &c, 1);
 1f0:	4605                	li	a2,1
 1f2:	faf40593          	addi	a1,s0,-81
 1f6:	4501                	li	a0,0
 1f8:	00000097          	auipc	ra,0x0
 1fc:	19c080e7          	jalr	412(ra) # 394 <read>
    if(cc < 1)
 200:	00a05e63          	blez	a0,21c <gets+0x56>
    buf[i++] = c;
 204:	faf44783          	lbu	a5,-81(s0)
 208:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20c:	01578763          	beq	a5,s5,21a <gets+0x54>
 210:	0905                	addi	s2,s2,1
 212:	fd679be3          	bne	a5,s6,1e8 <gets+0x22>
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	a011                	j	21c <gets+0x56>
 21a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21c:	99de                	add	s3,s3,s7
 21e:	00098023          	sb	zero,0(s3)
  return buf;
}
 222:	855e                	mv	a0,s7
 224:	60e6                	ld	ra,88(sp)
 226:	6446                	ld	s0,80(sp)
 228:	64a6                	ld	s1,72(sp)
 22a:	6906                	ld	s2,64(sp)
 22c:	79e2                	ld	s3,56(sp)
 22e:	7a42                	ld	s4,48(sp)
 230:	7aa2                	ld	s5,40(sp)
 232:	7b02                	ld	s6,32(sp)
 234:	6be2                	ld	s7,24(sp)
 236:	6125                	addi	sp,sp,96
 238:	8082                	ret

000000000000023a <stat>:

int
stat(const char *n, struct stat *st)
{
 23a:	1101                	addi	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	e426                	sd	s1,8(sp)
 242:	e04a                	sd	s2,0(sp)
 244:	1000                	addi	s0,sp,32
 246:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	4581                	li	a1,0
 24a:	00000097          	auipc	ra,0x0
 24e:	172080e7          	jalr	370(ra) # 3bc <open>
  if(fd < 0)
 252:	02054563          	bltz	a0,27c <stat+0x42>
 256:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 258:	85ca                	mv	a1,s2
 25a:	00000097          	auipc	ra,0x0
 25e:	17a080e7          	jalr	378(ra) # 3d4 <fstat>
 262:	892a                	mv	s2,a0
  close(fd);
 264:	8526                	mv	a0,s1
 266:	00000097          	auipc	ra,0x0
 26a:	13e080e7          	jalr	318(ra) # 3a4 <close>
  return r;
}
 26e:	854a                	mv	a0,s2
 270:	60e2                	ld	ra,24(sp)
 272:	6442                	ld	s0,16(sp)
 274:	64a2                	ld	s1,8(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	597d                	li	s2,-1
 27e:	bfc5                	j	26e <stat+0x34>

0000000000000280 <atoi>:

int
atoi(const char *s)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 286:	00054603          	lbu	a2,0(a0)
 28a:	fd06079b          	addiw	a5,a2,-48
 28e:	0ff7f793          	andi	a5,a5,255
 292:	4725                	li	a4,9
 294:	02f76963          	bltu	a4,a5,2c6 <atoi+0x46>
 298:	86aa                	mv	a3,a0
  n = 0;
 29a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 29c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 29e:	0685                	addi	a3,a3,1
 2a0:	0025179b          	slliw	a5,a0,0x2
 2a4:	9fa9                	addw	a5,a5,a0
 2a6:	0017979b          	slliw	a5,a5,0x1
 2aa:	9fb1                	addw	a5,a5,a2
 2ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b0:	0006c603          	lbu	a2,0(a3)
 2b4:	fd06071b          	addiw	a4,a2,-48
 2b8:	0ff77713          	andi	a4,a4,255
 2bc:	fee5f1e3          	bgeu	a1,a4,29e <atoi+0x1e>
  return n;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  n = 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <atoi+0x40>

00000000000002ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d0:	02b57463          	bgeu	a0,a1,2f8 <memmove+0x2e>
    while(n-- > 0)
 2d4:	00c05f63          	blez	a2,2f2 <memmove+0x28>
 2d8:	1602                	slli	a2,a2,0x20
 2da:	9201                	srli	a2,a2,0x20
 2dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e2:	0585                	addi	a1,a1,1
 2e4:	0705                	addi	a4,a4,1
 2e6:	fff5c683          	lbu	a3,-1(a1)
 2ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ee:	fee79ae3          	bne	a5,a4,2e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
    dst += n;
 2f8:	00c50733          	add	a4,a0,a2
    src += n;
 2fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fe:	fec05ae3          	blez	a2,2f2 <memmove+0x28>
 302:	fff6079b          	addiw	a5,a2,-1
 306:	1782                	slli	a5,a5,0x20
 308:	9381                	srli	a5,a5,0x20
 30a:	fff7c793          	not	a5,a5
 30e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 310:	15fd                	addi	a1,a1,-1
 312:	177d                	addi	a4,a4,-1
 314:	0005c683          	lbu	a3,0(a1)
 318:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31c:	fee79ae3          	bne	a5,a4,310 <memmove+0x46>
 320:	bfc9                	j	2f2 <memmove+0x28>

0000000000000322 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 328:	ca05                	beqz	a2,358 <memcmp+0x36>
 32a:	fff6069b          	addiw	a3,a2,-1
 32e:	1682                	slli	a3,a3,0x20
 330:	9281                	srli	a3,a3,0x20
 332:	0685                	addi	a3,a3,1
 334:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 336:	00054783          	lbu	a5,0(a0)
 33a:	0005c703          	lbu	a4,0(a1)
 33e:	00e79863          	bne	a5,a4,34e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 342:	0505                	addi	a0,a0,1
    p2++;
 344:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 346:	fed518e3          	bne	a0,a3,336 <memcmp+0x14>
  }
  return 0;
 34a:	4501                	li	a0,0
 34c:	a019                	j	352 <memcmp+0x30>
      return *p1 - *p2;
 34e:	40e7853b          	subw	a0,a5,a4
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
  return 0;
 358:	4501                	li	a0,0
 35a:	bfe5                	j	352 <memcmp+0x30>

000000000000035c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 364:	00000097          	auipc	ra,0x0
 368:	f66080e7          	jalr	-154(ra) # 2ca <memmove>
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 374:	4885                	li	a7,1
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exit>:
.global exit
exit:
 li a7, SYS_exit
 37c:	4889                	li	a7,2
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <wait>:
.global wait
wait:
 li a7, SYS_wait
 384:	488d                	li	a7,3
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38c:	4891                	li	a7,4
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <read>:
.global read
read:
 li a7, SYS_read
 394:	4895                	li	a7,5
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <write>:
.global write
write:
 li a7, SYS_write
 39c:	48c1                	li	a7,16
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <close>:
.global close
close:
 li a7, SYS_close
 3a4:	48d5                	li	a7,21
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ac:	4899                	li	a7,6
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b4:	489d                	li	a7,7
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <open>:
.global open
open:
 li a7, SYS_open
 3bc:	48bd                	li	a7,15
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c4:	48c5                	li	a7,17
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3cc:	48c9                	li	a7,18
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d4:	48a1                	li	a7,8
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <link>:
.global link
link:
 li a7, SYS_link
 3dc:	48cd                	li	a7,19
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e4:	48d1                	li	a7,20
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ec:	48a5                	li	a7,9
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f4:	48a9                	li	a7,10
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fc:	48ad                	li	a7,11
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 404:	48b1                	li	a7,12
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40c:	48b5                	li	a7,13
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 414:	48b9                	li	a7,14
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41c:	1101                	addi	sp,sp,-32
 41e:	ec06                	sd	ra,24(sp)
 420:	e822                	sd	s0,16(sp)
 422:	1000                	addi	s0,sp,32
 424:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 428:	4605                	li	a2,1
 42a:	fef40593          	addi	a1,s0,-17
 42e:	00000097          	auipc	ra,0x0
 432:	f6e080e7          	jalr	-146(ra) # 39c <write>
}
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret

000000000000043e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43e:	7139                	addi	sp,sp,-64
 440:	fc06                	sd	ra,56(sp)
 442:	f822                	sd	s0,48(sp)
 444:	f426                	sd	s1,40(sp)
 446:	f04a                	sd	s2,32(sp)
 448:	ec4e                	sd	s3,24(sp)
 44a:	0080                	addi	s0,sp,64
 44c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44e:	c299                	beqz	a3,454 <printint+0x16>
 450:	0805c863          	bltz	a1,4e0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 454:	2581                	sext.w	a1,a1
  neg = 0;
 456:	4881                	li	a7,0
 458:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 45c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45e:	2601                	sext.w	a2,a2
 460:	00000517          	auipc	a0,0x0
 464:	48050513          	addi	a0,a0,1152 # 8e0 <digits>
 468:	883a                	mv	a6,a4
 46a:	2705                	addiw	a4,a4,1
 46c:	02c5f7bb          	remuw	a5,a1,a2
 470:	1782                	slli	a5,a5,0x20
 472:	9381                	srli	a5,a5,0x20
 474:	97aa                	add	a5,a5,a0
 476:	0007c783          	lbu	a5,0(a5)
 47a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47e:	0005879b          	sext.w	a5,a1
 482:	02c5d5bb          	divuw	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fec7f0e3          	bgeu	a5,a2,468 <printint+0x2a>
  if(neg)
 48c:	00088b63          	beqz	a7,4a2 <printint+0x64>
    buf[i++] = '-';
 490:	fd040793          	addi	a5,s0,-48
 494:	973e                	add	a4,a4,a5
 496:	02d00793          	li	a5,45
 49a:	fef70823          	sb	a5,-16(a4)
 49e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a2:	02e05863          	blez	a4,4d2 <printint+0x94>
 4a6:	fc040793          	addi	a5,s0,-64
 4aa:	00e78933          	add	s2,a5,a4
 4ae:	fff78993          	addi	s3,a5,-1
 4b2:	99ba                	add	s3,s3,a4
 4b4:	377d                	addiw	a4,a4,-1
 4b6:	1702                	slli	a4,a4,0x20
 4b8:	9301                	srli	a4,a4,0x20
 4ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4be:	fff94583          	lbu	a1,-1(s2)
 4c2:	8526                	mv	a0,s1
 4c4:	00000097          	auipc	ra,0x0
 4c8:	f58080e7          	jalr	-168(ra) # 41c <putc>
  while(--i >= 0)
 4cc:	197d                	addi	s2,s2,-1
 4ce:	ff3918e3          	bne	s2,s3,4be <printint+0x80>
}
 4d2:	70e2                	ld	ra,56(sp)
 4d4:	7442                	ld	s0,48(sp)
 4d6:	74a2                	ld	s1,40(sp)
 4d8:	7902                	ld	s2,32(sp)
 4da:	69e2                	ld	s3,24(sp)
 4dc:	6121                	addi	sp,sp,64
 4de:	8082                	ret
    x = -xx;
 4e0:	40b005bb          	negw	a1,a1
    neg = 1;
 4e4:	4885                	li	a7,1
    x = -xx;
 4e6:	bf8d                	j	458 <printint+0x1a>

00000000000004e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e8:	7119                	addi	sp,sp,-128
 4ea:	fc86                	sd	ra,120(sp)
 4ec:	f8a2                	sd	s0,112(sp)
 4ee:	f4a6                	sd	s1,104(sp)
 4f0:	f0ca                	sd	s2,96(sp)
 4f2:	ecce                	sd	s3,88(sp)
 4f4:	e8d2                	sd	s4,80(sp)
 4f6:	e4d6                	sd	s5,72(sp)
 4f8:	e0da                	sd	s6,64(sp)
 4fa:	fc5e                	sd	s7,56(sp)
 4fc:	f862                	sd	s8,48(sp)
 4fe:	f466                	sd	s9,40(sp)
 500:	f06a                	sd	s10,32(sp)
 502:	ec6e                	sd	s11,24(sp)
 504:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	18090f63          	beqz	s2,6a8 <vprintf+0x1c0>
 50e:	8aaa                	mv	s5,a0
 510:	8b32                	mv	s6,a2
 512:	00158493          	addi	s1,a1,1
  state = 0;
 516:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 518:	02500a13          	li	s4,37
      if(c == 'd'){
 51c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 520:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 524:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 528:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52c:	00000b97          	auipc	s7,0x0
 530:	3b4b8b93          	addi	s7,s7,948 # 8e0 <digits>
 534:	a839                	j	552 <vprintf+0x6a>
        putc(fd, c);
 536:	85ca                	mv	a1,s2
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	ee2080e7          	jalr	-286(ra) # 41c <putc>
 542:	a019                	j	548 <vprintf+0x60>
    } else if(state == '%'){
 544:	01498f63          	beq	s3,s4,562 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 548:	0485                	addi	s1,s1,1
 54a:	fff4c903          	lbu	s2,-1(s1)
 54e:	14090d63          	beqz	s2,6a8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 552:	0009079b          	sext.w	a5,s2
    if(state == 0){
 556:	fe0997e3          	bnez	s3,544 <vprintf+0x5c>
      if(c == '%'){
 55a:	fd479ee3          	bne	a5,s4,536 <vprintf+0x4e>
        state = '%';
 55e:	89be                	mv	s3,a5
 560:	b7e5                	j	548 <vprintf+0x60>
      if(c == 'd'){
 562:	05878063          	beq	a5,s8,5a2 <vprintf+0xba>
      } else if(c == 'l') {
 566:	05978c63          	beq	a5,s9,5be <vprintf+0xd6>
      } else if(c == 'x') {
 56a:	07a78863          	beq	a5,s10,5da <vprintf+0xf2>
      } else if(c == 'p') {
 56e:	09b78463          	beq	a5,s11,5f6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 572:	07300713          	li	a4,115
 576:	0ce78663          	beq	a5,a4,642 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57a:	06300713          	li	a4,99
 57e:	0ee78e63          	beq	a5,a4,67a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 582:	11478863          	beq	a5,s4,692 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 586:	85d2                	mv	a1,s4
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e92080e7          	jalr	-366(ra) # 41c <putc>
        putc(fd, c);
 592:	85ca                	mv	a1,s2
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e86080e7          	jalr	-378(ra) # 41c <putc>
      }
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b765                	j	548 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5a2:	008b0913          	addi	s2,s6,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000b2583          	lw	a1,0(s6)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e8e080e7          	jalr	-370(ra) # 43e <printint>
 5b8:	8b4a                	mv	s6,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b771                	j	548 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5be:	008b0913          	addi	s2,s6,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000b2583          	lw	a1,0(s6)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e72080e7          	jalr	-398(ra) # 43e <printint>
 5d4:	8b4a                	mv	s6,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bf85                	j	548 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5da:	008b0913          	addi	s2,s6,8
 5de:	4681                	li	a3,0
 5e0:	4641                	li	a2,16
 5e2:	000b2583          	lw	a1,0(s6)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e56080e7          	jalr	-426(ra) # 43e <printint>
 5f0:	8b4a                	mv	s6,s2
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	bf91                	j	548 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5f6:	008b0793          	addi	a5,s6,8
 5fa:	f8f43423          	sd	a5,-120(s0)
 5fe:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 602:	03000593          	li	a1,48
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e14080e7          	jalr	-492(ra) # 41c <putc>
  putc(fd, 'x');
 610:	85ea                	mv	a1,s10
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e08080e7          	jalr	-504(ra) # 41c <putc>
 61c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61e:	03c9d793          	srli	a5,s3,0x3c
 622:	97de                	add	a5,a5,s7
 624:	0007c583          	lbu	a1,0(a5)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	df2080e7          	jalr	-526(ra) # 41c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 632:	0992                	slli	s3,s3,0x4
 634:	397d                	addiw	s2,s2,-1
 636:	fe0914e3          	bnez	s2,61e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 63a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 63e:	4981                	li	s3,0
 640:	b721                	j	548 <vprintf+0x60>
        s = va_arg(ap, char*);
 642:	008b0993          	addi	s3,s6,8
 646:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 64a:	02090163          	beqz	s2,66c <vprintf+0x184>
        while(*s != 0){
 64e:	00094583          	lbu	a1,0(s2)
 652:	c9a1                	beqz	a1,6a2 <vprintf+0x1ba>
          putc(fd, *s);
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	dc6080e7          	jalr	-570(ra) # 41c <putc>
          s++;
 65e:	0905                	addi	s2,s2,1
        while(*s != 0){
 660:	00094583          	lbu	a1,0(s2)
 664:	f9e5                	bnez	a1,654 <vprintf+0x16c>
        s = va_arg(ap, char*);
 666:	8b4e                	mv	s6,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	bdf9                	j	548 <vprintf+0x60>
          s = "(null)";
 66c:	00000917          	auipc	s2,0x0
 670:	26c90913          	addi	s2,s2,620 # 8d8 <malloc+0x126>
        while(*s != 0){
 674:	02800593          	li	a1,40
 678:	bff1                	j	654 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 67a:	008b0913          	addi	s2,s6,8
 67e:	000b4583          	lbu	a1,0(s6)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	d98080e7          	jalr	-616(ra) # 41c <putc>
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bd65                	j	548 <vprintf+0x60>
        putc(fd, c);
 692:	85d2                	mv	a1,s4
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	d86080e7          	jalr	-634(ra) # 41c <putc>
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b565                	j	548 <vprintf+0x60>
        s = va_arg(ap, char*);
 6a2:	8b4e                	mv	s6,s3
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b54d                	j	548 <vprintf+0x60>
    }
  }
}
 6a8:	70e6                	ld	ra,120(sp)
 6aa:	7446                	ld	s0,112(sp)
 6ac:	74a6                	ld	s1,104(sp)
 6ae:	7906                	ld	s2,96(sp)
 6b0:	69e6                	ld	s3,88(sp)
 6b2:	6a46                	ld	s4,80(sp)
 6b4:	6aa6                	ld	s5,72(sp)
 6b6:	6b06                	ld	s6,64(sp)
 6b8:	7be2                	ld	s7,56(sp)
 6ba:	7c42                	ld	s8,48(sp)
 6bc:	7ca2                	ld	s9,40(sp)
 6be:	7d02                	ld	s10,32(sp)
 6c0:	6de2                	ld	s11,24(sp)
 6c2:	6109                	addi	sp,sp,128
 6c4:	8082                	ret

00000000000006c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c6:	715d                	addi	sp,sp,-80
 6c8:	ec06                	sd	ra,24(sp)
 6ca:	e822                	sd	s0,16(sp)
 6cc:	1000                	addi	s0,sp,32
 6ce:	e010                	sd	a2,0(s0)
 6d0:	e414                	sd	a3,8(s0)
 6d2:	e818                	sd	a4,16(s0)
 6d4:	ec1c                	sd	a5,24(s0)
 6d6:	03043023          	sd	a6,32(s0)
 6da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e2:	8622                	mv	a2,s0
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e04080e7          	jalr	-508(ra) # 4e8 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6161                	addi	sp,sp,80
 6f2:	8082                	ret

00000000000006f4 <printf>:

void
printf(const char *fmt, ...)
{
 6f4:	711d                	addi	sp,sp,-96
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	e40c                	sd	a1,8(s0)
 6fe:	e810                	sd	a2,16(s0)
 700:	ec14                	sd	a3,24(s0)
 702:	f018                	sd	a4,32(s0)
 704:	f41c                	sd	a5,40(s0)
 706:	03043823          	sd	a6,48(s0)
 70a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70e:	00840613          	addi	a2,s0,8
 712:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 716:	85aa                	mv	a1,a0
 718:	4505                	li	a0,1
 71a:	00000097          	auipc	ra,0x0
 71e:	dce080e7          	jalr	-562(ra) # 4e8 <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6125                	addi	sp,sp,96
 728:	8082                	ret

000000000000072a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72a:	1141                	addi	sp,sp,-16
 72c:	e422                	sd	s0,8(sp)
 72e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 730:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	00001797          	auipc	a5,0x1
 738:	8cc7b783          	ld	a5,-1844(a5) # 1000 <freep>
 73c:	a805                	j	76c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73e:	4618                	lw	a4,8(a2)
 740:	9db9                	addw	a1,a1,a4
 742:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	6398                	ld	a4,0(a5)
 748:	6318                	ld	a4,0(a4)
 74a:	fee53823          	sd	a4,-16(a0)
 74e:	a091                	j	792 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 750:	ff852703          	lw	a4,-8(a0)
 754:	9e39                	addw	a2,a2,a4
 756:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 758:	ff053703          	ld	a4,-16(a0)
 75c:	e398                	sd	a4,0(a5)
 75e:	a099                	j	7a4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	6398                	ld	a4,0(a5)
 762:	00e7e463          	bltu	a5,a4,76a <free+0x40>
 766:	00e6ea63          	bltu	a3,a4,77a <free+0x50>
{
 76a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	fed7fae3          	bgeu	a5,a3,760 <free+0x36>
 770:	6398                	ld	a4,0(a5)
 772:	00e6e463          	bltu	a3,a4,77a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	fee7eae3          	bltu	a5,a4,76a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 77a:	ff852583          	lw	a1,-8(a0)
 77e:	6390                	ld	a2,0(a5)
 780:	02059713          	slli	a4,a1,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	0712                	slli	a4,a4,0x4
 788:	9736                	add	a4,a4,a3
 78a:	fae60ae3          	beq	a2,a4,73e <free+0x14>
    bp->s.ptr = p->s.ptr;
 78e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 792:	4790                	lw	a2,8(a5)
 794:	02061713          	slli	a4,a2,0x20
 798:	9301                	srli	a4,a4,0x20
 79a:	0712                	slli	a4,a4,0x4
 79c:	973e                	add	a4,a4,a5
 79e:	fae689e3          	beq	a3,a4,750 <free+0x26>
  } else
    p->s.ptr = bp;
 7a2:	e394                	sd	a3,0(a5)
  freep = p;
 7a4:	00001717          	auipc	a4,0x1
 7a8:	84f73e23          	sd	a5,-1956(a4) # 1000 <freep>
}
 7ac:	6422                	ld	s0,8(sp)
 7ae:	0141                	addi	sp,sp,16
 7b0:	8082                	ret

00000000000007b2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f426                	sd	s1,40(sp)
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
 7c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c6:	02051493          	slli	s1,a0,0x20
 7ca:	9081                	srli	s1,s1,0x20
 7cc:	04bd                	addi	s1,s1,15
 7ce:	8091                	srli	s1,s1,0x4
 7d0:	0014899b          	addiw	s3,s1,1
 7d4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7d6:	00001517          	auipc	a0,0x1
 7da:	82a53503          	ld	a0,-2006(a0) # 1000 <freep>
 7de:	c515                	beqz	a0,80a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e2:	4798                	lw	a4,8(a5)
 7e4:	02977f63          	bgeu	a4,s1,822 <malloc+0x70>
 7e8:	8a4e                	mv	s4,s3
 7ea:	0009871b          	sext.w	a4,s3
 7ee:	6685                	lui	a3,0x1
 7f0:	00d77363          	bgeu	a4,a3,7f6 <malloc+0x44>
 7f4:	6a05                	lui	s4,0x1
 7f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fe:	00001917          	auipc	s2,0x1
 802:	80290913          	addi	s2,s2,-2046 # 1000 <freep>
  if(p == (char*)-1)
 806:	5afd                	li	s5,-1
 808:	a88d                	j	87a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 80a:	00001797          	auipc	a5,0x1
 80e:	80678793          	addi	a5,a5,-2042 # 1010 <base>
 812:	00000717          	auipc	a4,0x0
 816:	7ef73723          	sd	a5,2030(a4) # 1000 <freep>
 81a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 820:	b7e1                	j	7e8 <malloc+0x36>
      if(p->s.size == nunits)
 822:	02e48b63          	beq	s1,a4,858 <malloc+0xa6>
        p->s.size -= nunits;
 826:	4137073b          	subw	a4,a4,s3
 82a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82c:	1702                	slli	a4,a4,0x20
 82e:	9301                	srli	a4,a4,0x20
 830:	0712                	slli	a4,a4,0x4
 832:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 834:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 838:	00000717          	auipc	a4,0x0
 83c:	7ca73423          	sd	a0,1992(a4) # 1000 <freep>
      return (void*)(p + 1);
 840:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 844:	70e2                	ld	ra,56(sp)
 846:	7442                	ld	s0,48(sp)
 848:	74a2                	ld	s1,40(sp)
 84a:	7902                	ld	s2,32(sp)
 84c:	69e2                	ld	s3,24(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6b02                	ld	s6,0(sp)
 854:	6121                	addi	sp,sp,64
 856:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	e118                	sd	a4,0(a0)
 85c:	bff1                	j	838 <malloc+0x86>
  hp->s.size = nu;
 85e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 862:	0541                	addi	a0,a0,16
 864:	00000097          	auipc	ra,0x0
 868:	ec6080e7          	jalr	-314(ra) # 72a <free>
  return freep;
 86c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 870:	d971                	beqz	a0,844 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	fa9776e3          	bgeu	a4,s1,822 <malloc+0x70>
    if(p == freep)
 87a:	00093703          	ld	a4,0(s2)
 87e:	853e                	mv	a0,a5
 880:	fef719e3          	bne	a4,a5,872 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 884:	8552                	mv	a0,s4
 886:	00000097          	auipc	ra,0x0
 88a:	b7e080e7          	jalr	-1154(ra) # 404 <sbrk>
  if(p == (char*)-1)
 88e:	fd5518e3          	bne	a0,s5,85e <malloc+0xac>
        return 0;
 892:	4501                	li	a0,0
 894:	bf45                	j	844 <malloc+0x92>
