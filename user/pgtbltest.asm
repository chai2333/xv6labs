
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	ff293903          	ld	s2,-14(s2) # 1000 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	50c080e7          	jalr	1292(ra) # 522 <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	9ac50513          	addi	a0,a0,-1620 # 9d0 <malloc+0xe8>
  2c:	00000097          	auipc	ra,0x0
  30:	7fe080e7          	jalr	2046(ra) # 82a <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	46c080e7          	jalr	1132(ra) # 4a2 <exit>

000000000000003e <ugetpid_test>:
}

void
ugetpid_test()
{
  3e:	7179                	addi	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9b050513          	addi	a0,a0,-1616 # 9f8 <malloc+0x110>
  50:	00000097          	auipc	ra,0x0
  54:	7da080e7          	jalr	2010(ra) # 82a <printf>
  testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	9b878793          	addi	a5,a5,-1608 # a10 <malloc+0x128>
  60:	00001717          	auipc	a4,0x1
  64:	faf73023          	sd	a5,-96(a4) # 1000 <testname>
  68:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	42e080e7          	jalr	1070(ra) # 49a <fork>
  74:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
      wait(&ret);
  7a:	fdc40513          	addi	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	42c080e7          	jalr	1068(ra) # 4aa <wait>
      if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
  for (i = 0; i < 64; i++) {
  8c:	34fd                	addiw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	9a050513          	addi	a0,a0,-1632 # a30 <malloc+0x148>
  98:	00000097          	auipc	ra,0x0
  9c:	792080e7          	jalr	1938(ra) # 82a <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	addi	sp,sp,48
  a8:	8082                	ret
        exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	3f6080e7          	jalr	1014(ra) # 4a2 <exit>
    if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	46e080e7          	jalr	1134(ra) # 522 <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3c6080e7          	jalr	966(ra) # 484 <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
      err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	95650513          	addi	a0,a0,-1706 # a20 <malloc+0x138>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3c6080e7          	jalr	966(ra) # 4a2 <exit>

00000000000000e4 <pgaccess_test>:

void
pgaccess_test()
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	95a50513          	addi	a0,a0,-1702 # a48 <malloc+0x160>
  f6:	00000097          	auipc	ra,0x0
  fa:	734080e7          	jalr	1844(ra) # 82a <printf>
  testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	96278793          	addi	a5,a5,-1694 # a60 <malloc+0x178>
 106:	00001717          	auipc	a4,0x1
 10a:	eef73d23          	sd	a5,-262(a4) # 1000 <testname>
  buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7d6080e7          	jalr	2006(ra) # 8e8 <malloc>
 11a:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	addi	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	426080e7          	jalr	1062(ra) # 54a <pgaccess>
 12c:	06054b63          	bltz	a0,1a2 <pgaccess_test+0xbe>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <testname>
 138:	2705                	addiw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <base+0xfe0>
 146:	2705                	addiw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <base+0x1cfe0>
 154:	2705                	addiw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	addi	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	3e6080e7          	jalr	998(ra) # 54a <pgaccess>
 16c:	04054363          	bltz	a0,1b2 <pgaccess_test+0xce>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 170:	fdc42703          	lw	a4,-36(s0)
 174:	400007b7          	lui	a5,0x40000
 178:	0799                	addi	a5,a5,6
 17a:	04f71463          	bne	a4,a5,1c2 <pgaccess_test+0xde>
    err("incorrect access bits set");
  free(buf);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	6e0080e7          	jalr	1760(ra) # 860 <free>
  printf("pgaccess_test: OK\n");
 188:	00001517          	auipc	a0,0x1
 18c:	91850513          	addi	a0,a0,-1768 # aa0 <malloc+0x1b8>
 190:	00000097          	auipc	ra,0x0
 194:	69a080e7          	jalr	1690(ra) # 82a <printf>
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6145                	addi	sp,sp,48
 1a0:	8082                	ret
    err("pgaccess failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	8ce50513          	addi	a0,a0,-1842 # a70 <malloc+0x188>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	e56080e7          	jalr	-426(ra) # 0 <err>
    err("pgaccess failed");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	8be50513          	addi	a0,a0,-1858 # a70 <malloc+0x188>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <err>
    err("incorrect access bits set");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	8be50513          	addi	a0,a0,-1858 # a80 <malloc+0x198>
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <err>

00000000000001d2 <main>:
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  ugetpid_test();
 1da:	00000097          	auipc	ra,0x0
 1de:	e64080e7          	jalr	-412(ra) # 3e <ugetpid_test>
  pgaccess_test();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f02080e7          	jalr	-254(ra) # e4 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	8ce50513          	addi	a0,a0,-1842 # ab8 <malloc+0x1d0>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	638080e7          	jalr	1592(ra) # 82a <printf>
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	2a6080e7          	jalr	678(ra) # 4a2 <exit>

0000000000000204 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 204:	1141                	addi	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 20c:	00000097          	auipc	ra,0x0
 210:	fc6080e7          	jalr	-58(ra) # 1d2 <main>
  exit(0);
 214:	4501                	li	a0,0
 216:	00000097          	auipc	ra,0x0
 21a:	28c080e7          	jalr	652(ra) # 4a2 <exit>

000000000000021e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 224:	87aa                	mv	a5,a0
 226:	0585                	addi	a1,a1,1
 228:	0785                	addi	a5,a5,1
 22a:	fff5c703          	lbu	a4,-1(a1)
 22e:	fee78fa3          	sb	a4,-1(a5) # 3fffffff <base+0x3fffefdf>
 232:	fb75                	bnez	a4,226 <strcpy+0x8>
    ;
  return os;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 240:	00054783          	lbu	a5,0(a0)
 244:	cb91                	beqz	a5,258 <strcmp+0x1e>
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00f71763          	bne	a4,a5,258 <strcmp+0x1e>
    p++, q++;
 24e:	0505                	addi	a0,a0,1
 250:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	fbe5                	bnez	a5,246 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 258:	0005c503          	lbu	a0,0(a1)
}
 25c:	40a7853b          	subw	a0,a5,a0
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <strlen>:

uint
strlen(const char *s)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cf91                	beqz	a5,28c <strlen+0x26>
 272:	0505                	addi	a0,a0,1
 274:	87aa                	mv	a5,a0
 276:	4685                	li	a3,1
 278:	9e89                	subw	a3,a3,a0
 27a:	00f6853b          	addw	a0,a3,a5
 27e:	0785                	addi	a5,a5,1
 280:	fff7c703          	lbu	a4,-1(a5)
 284:	fb7d                	bnez	a4,27a <strlen+0x14>
    ;
  return n;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  for(n = 0; s[n]; n++)
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strlen+0x20>

0000000000000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 296:	ca19                	beqz	a2,2ac <memset+0x1c>
 298:	87aa                	mv	a5,a0
 29a:	1602                	slli	a2,a2,0x20
 29c:	9201                	srli	a2,a2,0x20
 29e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a6:	0785                	addi	a5,a5,1
 2a8:	fee79de3          	bne	a5,a4,2a2 <memset+0x12>
  }
  return dst;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strchr>:

char*
strchr(const char *s, char c)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb99                	beqz	a5,2d2 <strchr+0x20>
    if(*s == c)
 2be:	00f58763          	beq	a1,a5,2cc <strchr+0x1a>
  for(; *s; s++)
 2c2:	0505                	addi	a0,a0,1
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbfd                	bnez	a5,2be <strchr+0xc>
      return (char*)s;
  return 0;
 2ca:	4501                	li	a0,0
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <strchr+0x1a>

00000000000002d6 <gets>:

char*
gets(char *buf, int max)
{
 2d6:	711d                	addi	sp,sp,-96
 2d8:	ec86                	sd	ra,88(sp)
 2da:	e8a2                	sd	s0,80(sp)
 2dc:	e4a6                	sd	s1,72(sp)
 2de:	e0ca                	sd	s2,64(sp)
 2e0:	fc4e                	sd	s3,56(sp)
 2e2:	f852                	sd	s4,48(sp)
 2e4:	f456                	sd	s5,40(sp)
 2e6:	f05a                	sd	s6,32(sp)
 2e8:	ec5e                	sd	s7,24(sp)
 2ea:	1080                	addi	s0,sp,96
 2ec:	8baa                	mv	s7,a0
 2ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f0:	892a                	mv	s2,a0
 2f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f4:	4aa9                	li	s5,10
 2f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2f8:	89a6                	mv	s3,s1
 2fa:	2485                	addiw	s1,s1,1
 2fc:	0344d863          	bge	s1,s4,32c <gets+0x56>
    cc = read(0, &c, 1);
 300:	4605                	li	a2,1
 302:	faf40593          	addi	a1,s0,-81
 306:	4501                	li	a0,0
 308:	00000097          	auipc	ra,0x0
 30c:	1b2080e7          	jalr	434(ra) # 4ba <read>
    if(cc < 1)
 310:	00a05e63          	blez	a0,32c <gets+0x56>
    buf[i++] = c;
 314:	faf44783          	lbu	a5,-81(s0)
 318:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 31c:	01578763          	beq	a5,s5,32a <gets+0x54>
 320:	0905                	addi	s2,s2,1
 322:	fd679be3          	bne	a5,s6,2f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 326:	89a6                	mv	s3,s1
 328:	a011                	j	32c <gets+0x56>
 32a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 32c:	99de                	add	s3,s3,s7
 32e:	00098023          	sb	zero,0(s3)
  return buf;
}
 332:	855e                	mv	a0,s7
 334:	60e6                	ld	ra,88(sp)
 336:	6446                	ld	s0,80(sp)
 338:	64a6                	ld	s1,72(sp)
 33a:	6906                	ld	s2,64(sp)
 33c:	79e2                	ld	s3,56(sp)
 33e:	7a42                	ld	s4,48(sp)
 340:	7aa2                	ld	s5,40(sp)
 342:	7b02                	ld	s6,32(sp)
 344:	6be2                	ld	s7,24(sp)
 346:	6125                	addi	sp,sp,96
 348:	8082                	ret

000000000000034a <stat>:

int
stat(const char *n, struct stat *st)
{
 34a:	1101                	addi	sp,sp,-32
 34c:	ec06                	sd	ra,24(sp)
 34e:	e822                	sd	s0,16(sp)
 350:	e426                	sd	s1,8(sp)
 352:	e04a                	sd	s2,0(sp)
 354:	1000                	addi	s0,sp,32
 356:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 358:	4581                	li	a1,0
 35a:	00000097          	auipc	ra,0x0
 35e:	188080e7          	jalr	392(ra) # 4e2 <open>
  if(fd < 0)
 362:	02054563          	bltz	a0,38c <stat+0x42>
 366:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 368:	85ca                	mv	a1,s2
 36a:	00000097          	auipc	ra,0x0
 36e:	190080e7          	jalr	400(ra) # 4fa <fstat>
 372:	892a                	mv	s2,a0
  close(fd);
 374:	8526                	mv	a0,s1
 376:	00000097          	auipc	ra,0x0
 37a:	154080e7          	jalr	340(ra) # 4ca <close>
  return r;
}
 37e:	854a                	mv	a0,s2
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	64a2                	ld	s1,8(sp)
 386:	6902                	ld	s2,0(sp)
 388:	6105                	addi	sp,sp,32
 38a:	8082                	ret
    return -1;
 38c:	597d                	li	s2,-1
 38e:	bfc5                	j	37e <stat+0x34>

0000000000000390 <atoi>:

int
atoi(const char *s)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 396:	00054603          	lbu	a2,0(a0)
 39a:	fd06079b          	addiw	a5,a2,-48
 39e:	0ff7f793          	andi	a5,a5,255
 3a2:	4725                	li	a4,9
 3a4:	02f76963          	bltu	a4,a5,3d6 <atoi+0x46>
 3a8:	86aa                	mv	a3,a0
  n = 0;
 3aa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3ac:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3ae:	0685                	addi	a3,a3,1
 3b0:	0025179b          	slliw	a5,a0,0x2
 3b4:	9fa9                	addw	a5,a5,a0
 3b6:	0017979b          	slliw	a5,a5,0x1
 3ba:	9fb1                	addw	a5,a5,a2
 3bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c0:	0006c603          	lbu	a2,0(a3)
 3c4:	fd06071b          	addiw	a4,a2,-48
 3c8:	0ff77713          	andi	a4,a4,255
 3cc:	fee5f1e3          	bgeu	a1,a4,3ae <atoi+0x1e>
  return n;
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret
  n = 0;
 3d6:	4501                	li	a0,0
 3d8:	bfe5                	j	3d0 <atoi+0x40>

00000000000003da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e422                	sd	s0,8(sp)
 3de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3e0:	02b57463          	bgeu	a0,a1,408 <memmove+0x2e>
    while(n-- > 0)
 3e4:	00c05f63          	blez	a2,402 <memmove+0x28>
 3e8:	1602                	slli	a2,a2,0x20
 3ea:	9201                	srli	a2,a2,0x20
 3ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f2:	0585                	addi	a1,a1,1
 3f4:	0705                	addi	a4,a4,1
 3f6:	fff5c683          	lbu	a3,-1(a1)
 3fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fe:	fee79ae3          	bne	a5,a4,3f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
    dst += n;
 408:	00c50733          	add	a4,a0,a2
    src += n;
 40c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40e:	fec05ae3          	blez	a2,402 <memmove+0x28>
 412:	fff6079b          	addiw	a5,a2,-1
 416:	1782                	slli	a5,a5,0x20
 418:	9381                	srli	a5,a5,0x20
 41a:	fff7c793          	not	a5,a5
 41e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 420:	15fd                	addi	a1,a1,-1
 422:	177d                	addi	a4,a4,-1
 424:	0005c683          	lbu	a3,0(a1)
 428:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42c:	fee79ae3          	bne	a5,a4,420 <memmove+0x46>
 430:	bfc9                	j	402 <memmove+0x28>

0000000000000432 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e422                	sd	s0,8(sp)
 436:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 438:	ca05                	beqz	a2,468 <memcmp+0x36>
 43a:	fff6069b          	addiw	a3,a2,-1
 43e:	1682                	slli	a3,a3,0x20
 440:	9281                	srli	a3,a3,0x20
 442:	0685                	addi	a3,a3,1
 444:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 446:	00054783          	lbu	a5,0(a0)
 44a:	0005c703          	lbu	a4,0(a1)
 44e:	00e79863          	bne	a5,a4,45e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 452:	0505                	addi	a0,a0,1
    p2++;
 454:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 456:	fed518e3          	bne	a0,a3,446 <memcmp+0x14>
  }
  return 0;
 45a:	4501                	li	a0,0
 45c:	a019                	j	462 <memcmp+0x30>
      return *p1 - *p2;
 45e:	40e7853b          	subw	a0,a5,a4
}
 462:	6422                	ld	s0,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
  return 0;
 468:	4501                	li	a0,0
 46a:	bfe5                	j	462 <memcmp+0x30>

000000000000046c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e406                	sd	ra,8(sp)
 470:	e022                	sd	s0,0(sp)
 472:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 474:	00000097          	auipc	ra,0x0
 478:	f66080e7          	jalr	-154(ra) # 3da <memmove>
}
 47c:	60a2                	ld	ra,8(sp)
 47e:	6402                	ld	s0,0(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret

0000000000000484 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 48a:	040007b7          	lui	a5,0x4000
}
 48e:	17f5                	addi	a5,a5,-3
 490:	07b2                	slli	a5,a5,0xc
 492:	4388                	lw	a0,0(a5)
 494:	6422                	ld	s0,8(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret

000000000000049a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 49a:	4885                	li	a7,1
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a2:	4889                	li	a7,2
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 4aa:	488d                	li	a7,3
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b2:	4891                	li	a7,4
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <read>:
.global read
read:
 li a7, SYS_read
 4ba:	4895                	li	a7,5
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <write>:
.global write
write:
 li a7, SYS_write
 4c2:	48c1                	li	a7,16
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <close>:
.global close
close:
 li a7, SYS_close
 4ca:	48d5                	li	a7,21
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d2:	4899                	li	a7,6
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <exec>:
.global exec
exec:
 li a7, SYS_exec
 4da:	489d                	li	a7,7
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <open>:
.global open
open:
 li a7, SYS_open
 4e2:	48bd                	li	a7,15
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ea:	48c5                	li	a7,17
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f2:	48c9                	li	a7,18
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4fa:	48a1                	li	a7,8
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <link>:
.global link
link:
 li a7, SYS_link
 502:	48cd                	li	a7,19
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 50a:	48d1                	li	a7,20
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 512:	48a5                	li	a7,9
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <dup>:
.global dup
dup:
 li a7, SYS_dup
 51a:	48a9                	li	a7,10
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 522:	48ad                	li	a7,11
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 52a:	48b1                	li	a7,12
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 532:	48b5                	li	a7,13
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 53a:	48b9                	li	a7,14
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <connect>:
.global connect
connect:
 li a7, SYS_connect
 542:	48f5                	li	a7,29
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 54a:	48f9                	li	a7,30
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 552:	1101                	addi	sp,sp,-32
 554:	ec06                	sd	ra,24(sp)
 556:	e822                	sd	s0,16(sp)
 558:	1000                	addi	s0,sp,32
 55a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 55e:	4605                	li	a2,1
 560:	fef40593          	addi	a1,s0,-17
 564:	00000097          	auipc	ra,0x0
 568:	f5e080e7          	jalr	-162(ra) # 4c2 <write>
}
 56c:	60e2                	ld	ra,24(sp)
 56e:	6442                	ld	s0,16(sp)
 570:	6105                	addi	sp,sp,32
 572:	8082                	ret

0000000000000574 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 574:	7139                	addi	sp,sp,-64
 576:	fc06                	sd	ra,56(sp)
 578:	f822                	sd	s0,48(sp)
 57a:	f426                	sd	s1,40(sp)
 57c:	f04a                	sd	s2,32(sp)
 57e:	ec4e                	sd	s3,24(sp)
 580:	0080                	addi	s0,sp,64
 582:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 584:	c299                	beqz	a3,58a <printint+0x16>
 586:	0805c863          	bltz	a1,616 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 58a:	2581                	sext.w	a1,a1
  neg = 0;
 58c:	4881                	li	a7,0
 58e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 592:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 594:	2601                	sext.w	a2,a2
 596:	00000517          	auipc	a0,0x0
 59a:	55250513          	addi	a0,a0,1362 # ae8 <digits>
 59e:	883a                	mv	a6,a4
 5a0:	2705                	addiw	a4,a4,1
 5a2:	02c5f7bb          	remuw	a5,a1,a2
 5a6:	1782                	slli	a5,a5,0x20
 5a8:	9381                	srli	a5,a5,0x20
 5aa:	97aa                	add	a5,a5,a0
 5ac:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffefe0>
 5b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b4:	0005879b          	sext.w	a5,a1
 5b8:	02c5d5bb          	divuw	a1,a1,a2
 5bc:	0685                	addi	a3,a3,1
 5be:	fec7f0e3          	bgeu	a5,a2,59e <printint+0x2a>
  if(neg)
 5c2:	00088b63          	beqz	a7,5d8 <printint+0x64>
    buf[i++] = '-';
 5c6:	fd040793          	addi	a5,s0,-48
 5ca:	973e                	add	a4,a4,a5
 5cc:	02d00793          	li	a5,45
 5d0:	fef70823          	sb	a5,-16(a4)
 5d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d8:	02e05863          	blez	a4,608 <printint+0x94>
 5dc:	fc040793          	addi	a5,s0,-64
 5e0:	00e78933          	add	s2,a5,a4
 5e4:	fff78993          	addi	s3,a5,-1
 5e8:	99ba                	add	s3,s3,a4
 5ea:	377d                	addiw	a4,a4,-1
 5ec:	1702                	slli	a4,a4,0x20
 5ee:	9301                	srli	a4,a4,0x20
 5f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f4:	fff94583          	lbu	a1,-1(s2)
 5f8:	8526                	mv	a0,s1
 5fa:	00000097          	auipc	ra,0x0
 5fe:	f58080e7          	jalr	-168(ra) # 552 <putc>
  while(--i >= 0)
 602:	197d                	addi	s2,s2,-1
 604:	ff3918e3          	bne	s2,s3,5f4 <printint+0x80>
}
 608:	70e2                	ld	ra,56(sp)
 60a:	7442                	ld	s0,48(sp)
 60c:	74a2                	ld	s1,40(sp)
 60e:	7902                	ld	s2,32(sp)
 610:	69e2                	ld	s3,24(sp)
 612:	6121                	addi	sp,sp,64
 614:	8082                	ret
    x = -xx;
 616:	40b005bb          	negw	a1,a1
    neg = 1;
 61a:	4885                	li	a7,1
    x = -xx;
 61c:	bf8d                	j	58e <printint+0x1a>

000000000000061e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61e:	7119                	addi	sp,sp,-128
 620:	fc86                	sd	ra,120(sp)
 622:	f8a2                	sd	s0,112(sp)
 624:	f4a6                	sd	s1,104(sp)
 626:	f0ca                	sd	s2,96(sp)
 628:	ecce                	sd	s3,88(sp)
 62a:	e8d2                	sd	s4,80(sp)
 62c:	e4d6                	sd	s5,72(sp)
 62e:	e0da                	sd	s6,64(sp)
 630:	fc5e                	sd	s7,56(sp)
 632:	f862                	sd	s8,48(sp)
 634:	f466                	sd	s9,40(sp)
 636:	f06a                	sd	s10,32(sp)
 638:	ec6e                	sd	s11,24(sp)
 63a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63c:	0005c903          	lbu	s2,0(a1)
 640:	18090f63          	beqz	s2,7de <vprintf+0x1c0>
 644:	8aaa                	mv	s5,a0
 646:	8b32                	mv	s6,a2
 648:	00158493          	addi	s1,a1,1
  state = 0;
 64c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64e:	02500a13          	li	s4,37
      if(c == 'd'){
 652:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 656:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 65a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 65e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 662:	00000b97          	auipc	s7,0x0
 666:	486b8b93          	addi	s7,s7,1158 # ae8 <digits>
 66a:	a839                	j	688 <vprintf+0x6a>
        putc(fd, c);
 66c:	85ca                	mv	a1,s2
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	ee2080e7          	jalr	-286(ra) # 552 <putc>
 678:	a019                	j	67e <vprintf+0x60>
    } else if(state == '%'){
 67a:	01498f63          	beq	s3,s4,698 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 67e:	0485                	addi	s1,s1,1
 680:	fff4c903          	lbu	s2,-1(s1)
 684:	14090d63          	beqz	s2,7de <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 688:	0009079b          	sext.w	a5,s2
    if(state == 0){
 68c:	fe0997e3          	bnez	s3,67a <vprintf+0x5c>
      if(c == '%'){
 690:	fd479ee3          	bne	a5,s4,66c <vprintf+0x4e>
        state = '%';
 694:	89be                	mv	s3,a5
 696:	b7e5                	j	67e <vprintf+0x60>
      if(c == 'd'){
 698:	05878063          	beq	a5,s8,6d8 <vprintf+0xba>
      } else if(c == 'l') {
 69c:	05978c63          	beq	a5,s9,6f4 <vprintf+0xd6>
      } else if(c == 'x') {
 6a0:	07a78863          	beq	a5,s10,710 <vprintf+0xf2>
      } else if(c == 'p') {
 6a4:	09b78463          	beq	a5,s11,72c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6a8:	07300713          	li	a4,115
 6ac:	0ce78663          	beq	a5,a4,778 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b0:	06300713          	li	a4,99
 6b4:	0ee78e63          	beq	a5,a4,7b0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6b8:	11478863          	beq	a5,s4,7c8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6bc:	85d2                	mv	a1,s4
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e92080e7          	jalr	-366(ra) # 552 <putc>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e86080e7          	jalr	-378(ra) # 552 <putc>
      }
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b765                	j	67e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6d8:	008b0913          	addi	s2,s6,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000b2583          	lw	a1,0(s6)
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	e8e080e7          	jalr	-370(ra) # 574 <printint>
 6ee:	8b4a                	mv	s6,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b771                	j	67e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	008b0913          	addi	s2,s6,8
 6f8:	4681                	li	a3,0
 6fa:	4629                	li	a2,10
 6fc:	000b2583          	lw	a1,0(s6)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e72080e7          	jalr	-398(ra) # 574 <printint>
 70a:	8b4a                	mv	s6,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bf85                	j	67e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 710:	008b0913          	addi	s2,s6,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000b2583          	lw	a1,0(s6)
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e56080e7          	jalr	-426(ra) # 574 <printint>
 726:	8b4a                	mv	s6,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	bf91                	j	67e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 72c:	008b0793          	addi	a5,s6,8
 730:	f8f43423          	sd	a5,-120(s0)
 734:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 738:	03000593          	li	a1,48
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	e14080e7          	jalr	-492(ra) # 552 <putc>
  putc(fd, 'x');
 746:	85ea                	mv	a1,s10
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e08080e7          	jalr	-504(ra) # 552 <putc>
 752:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 754:	03c9d793          	srli	a5,s3,0x3c
 758:	97de                	add	a5,a5,s7
 75a:	0007c583          	lbu	a1,0(a5)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	df2080e7          	jalr	-526(ra) # 552 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 768:	0992                	slli	s3,s3,0x4
 76a:	397d                	addiw	s2,s2,-1
 76c:	fe0914e3          	bnez	s2,754 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 770:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 774:	4981                	li	s3,0
 776:	b721                	j	67e <vprintf+0x60>
        s = va_arg(ap, char*);
 778:	008b0993          	addi	s3,s6,8
 77c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 780:	02090163          	beqz	s2,7a2 <vprintf+0x184>
        while(*s != 0){
 784:	00094583          	lbu	a1,0(s2)
 788:	c9a1                	beqz	a1,7d8 <vprintf+0x1ba>
          putc(fd, *s);
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	dc6080e7          	jalr	-570(ra) # 552 <putc>
          s++;
 794:	0905                	addi	s2,s2,1
        while(*s != 0){
 796:	00094583          	lbu	a1,0(s2)
 79a:	f9e5                	bnez	a1,78a <vprintf+0x16c>
        s = va_arg(ap, char*);
 79c:	8b4e                	mv	s6,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bdf9                	j	67e <vprintf+0x60>
          s = "(null)";
 7a2:	00000917          	auipc	s2,0x0
 7a6:	33e90913          	addi	s2,s2,830 # ae0 <malloc+0x1f8>
        while(*s != 0){
 7aa:	02800593          	li	a1,40
 7ae:	bff1                	j	78a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7b0:	008b0913          	addi	s2,s6,8
 7b4:	000b4583          	lbu	a1,0(s6)
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	d98080e7          	jalr	-616(ra) # 552 <putc>
 7c2:	8b4a                	mv	s6,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bd65                	j	67e <vprintf+0x60>
        putc(fd, c);
 7c8:	85d2                	mv	a1,s4
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	d86080e7          	jalr	-634(ra) # 552 <putc>
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b565                	j	67e <vprintf+0x60>
        s = va_arg(ap, char*);
 7d8:	8b4e                	mv	s6,s3
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b54d                	j	67e <vprintf+0x60>
    }
  }
}
 7de:	70e6                	ld	ra,120(sp)
 7e0:	7446                	ld	s0,112(sp)
 7e2:	74a6                	ld	s1,104(sp)
 7e4:	7906                	ld	s2,96(sp)
 7e6:	69e6                	ld	s3,88(sp)
 7e8:	6a46                	ld	s4,80(sp)
 7ea:	6aa6                	ld	s5,72(sp)
 7ec:	6b06                	ld	s6,64(sp)
 7ee:	7be2                	ld	s7,56(sp)
 7f0:	7c42                	ld	s8,48(sp)
 7f2:	7ca2                	ld	s9,40(sp)
 7f4:	7d02                	ld	s10,32(sp)
 7f6:	6de2                	ld	s11,24(sp)
 7f8:	6109                	addi	sp,sp,128
 7fa:	8082                	ret

00000000000007fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fc:	715d                	addi	sp,sp,-80
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	addi	s0,sp,32
 804:	e010                	sd	a2,0(s0)
 806:	e414                	sd	a3,8(s0)
 808:	e818                	sd	a4,16(s0)
 80a:	ec1c                	sd	a5,24(s0)
 80c:	03043023          	sd	a6,32(s0)
 810:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 818:	8622                	mv	a2,s0
 81a:	00000097          	auipc	ra,0x0
 81e:	e04080e7          	jalr	-508(ra) # 61e <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6161                	addi	sp,sp,80
 828:	8082                	ret

000000000000082a <printf>:

void
printf(const char *fmt, ...)
{
 82a:	711d                	addi	sp,sp,-96
 82c:	ec06                	sd	ra,24(sp)
 82e:	e822                	sd	s0,16(sp)
 830:	1000                	addi	s0,sp,32
 832:	e40c                	sd	a1,8(s0)
 834:	e810                	sd	a2,16(s0)
 836:	ec14                	sd	a3,24(s0)
 838:	f018                	sd	a4,32(s0)
 83a:	f41c                	sd	a5,40(s0)
 83c:	03043823          	sd	a6,48(s0)
 840:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 844:	00840613          	addi	a2,s0,8
 848:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84c:	85aa                	mv	a1,a0
 84e:	4505                	li	a0,1
 850:	00000097          	auipc	ra,0x0
 854:	dce080e7          	jalr	-562(ra) # 61e <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6125                	addi	sp,sp,96
 85e:	8082                	ret

0000000000000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	1141                	addi	sp,sp,-16
 862:	e422                	sd	s0,8(sp)
 864:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 866:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	00000797          	auipc	a5,0x0
 86e:	7a67b783          	ld	a5,1958(a5) # 1010 <freep>
 872:	a805                	j	8a2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 874:	4618                	lw	a4,8(a2)
 876:	9db9                	addw	a1,a1,a4
 878:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	6318                	ld	a4,0(a4)
 880:	fee53823          	sd	a4,-16(a0)
 884:	a091                	j	8c8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 886:	ff852703          	lw	a4,-8(a0)
 88a:	9e39                	addw	a2,a2,a4
 88c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 88e:	ff053703          	ld	a4,-16(a0)
 892:	e398                	sd	a4,0(a5)
 894:	a099                	j	8da <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 896:	6398                	ld	a4,0(a5)
 898:	00e7e463          	bltu	a5,a4,8a0 <free+0x40>
 89c:	00e6ea63          	bltu	a3,a4,8b0 <free+0x50>
{
 8a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	fed7fae3          	bgeu	a5,a3,896 <free+0x36>
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e6e463          	bltu	a3,a4,8b0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ac:	fee7eae3          	bltu	a5,a4,8a0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8b0:	ff852583          	lw	a1,-8(a0)
 8b4:	6390                	ld	a2,0(a5)
 8b6:	02059713          	slli	a4,a1,0x20
 8ba:	9301                	srli	a4,a4,0x20
 8bc:	0712                	slli	a4,a4,0x4
 8be:	9736                	add	a4,a4,a3
 8c0:	fae60ae3          	beq	a2,a4,874 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c8:	4790                	lw	a2,8(a5)
 8ca:	02061713          	slli	a4,a2,0x20
 8ce:	9301                	srli	a4,a4,0x20
 8d0:	0712                	slli	a4,a4,0x4
 8d2:	973e                	add	a4,a4,a5
 8d4:	fae689e3          	beq	a3,a4,886 <free+0x26>
  } else
    p->s.ptr = bp;
 8d8:	e394                	sd	a3,0(a5)
  freep = p;
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73b23          	sd	a5,1846(a4) # 1010 <freep>
}
 8e2:	6422                	ld	s0,8(sp)
 8e4:	0141                	addi	sp,sp,16
 8e6:	8082                	ret

00000000000008e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e8:	7139                	addi	sp,sp,-64
 8ea:	fc06                	sd	ra,56(sp)
 8ec:	f822                	sd	s0,48(sp)
 8ee:	f426                	sd	s1,40(sp)
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	ec4e                	sd	s3,24(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
 8fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fc:	02051493          	slli	s1,a0,0x20
 900:	9081                	srli	s1,s1,0x20
 902:	04bd                	addi	s1,s1,15
 904:	8091                	srli	s1,s1,0x4
 906:	0014899b          	addiw	s3,s1,1
 90a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 90c:	00000517          	auipc	a0,0x0
 910:	70453503          	ld	a0,1796(a0) # 1010 <freep>
 914:	c515                	beqz	a0,940 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 918:	4798                	lw	a4,8(a5)
 91a:	02977f63          	bgeu	a4,s1,958 <malloc+0x70>
 91e:	8a4e                	mv	s4,s3
 920:	0009871b          	sext.w	a4,s3
 924:	6685                	lui	a3,0x1
 926:	00d77363          	bgeu	a4,a3,92c <malloc+0x44>
 92a:	6a05                	lui	s4,0x1
 92c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 930:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 934:	00000917          	auipc	s2,0x0
 938:	6dc90913          	addi	s2,s2,1756 # 1010 <freep>
  if(p == (char*)-1)
 93c:	5afd                	li	s5,-1
 93e:	a88d                	j	9b0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 940:	00000797          	auipc	a5,0x0
 944:	6e078793          	addi	a5,a5,1760 # 1020 <base>
 948:	00000717          	auipc	a4,0x0
 94c:	6cf73423          	sd	a5,1736(a4) # 1010 <freep>
 950:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 952:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 956:	b7e1                	j	91e <malloc+0x36>
      if(p->s.size == nunits)
 958:	02e48b63          	beq	s1,a4,98e <malloc+0xa6>
        p->s.size -= nunits;
 95c:	4137073b          	subw	a4,a4,s3
 960:	c798                	sw	a4,8(a5)
        p += p->s.size;
 962:	1702                	slli	a4,a4,0x20
 964:	9301                	srli	a4,a4,0x20
 966:	0712                	slli	a4,a4,0x4
 968:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96e:	00000717          	auipc	a4,0x0
 972:	6aa73123          	sd	a0,1698(a4) # 1010 <freep>
      return (void*)(p + 1);
 976:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 97a:	70e2                	ld	ra,56(sp)
 97c:	7442                	ld	s0,48(sp)
 97e:	74a2                	ld	s1,40(sp)
 980:	7902                	ld	s2,32(sp)
 982:	69e2                	ld	s3,24(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
 98a:	6121                	addi	sp,sp,64
 98c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 98e:	6398                	ld	a4,0(a5)
 990:	e118                	sd	a4,0(a0)
 992:	bff1                	j	96e <malloc+0x86>
  hp->s.size = nu;
 994:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 998:	0541                	addi	a0,a0,16
 99a:	00000097          	auipc	ra,0x0
 99e:	ec6080e7          	jalr	-314(ra) # 860 <free>
  return freep;
 9a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a6:	d971                	beqz	a0,97a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9aa:	4798                	lw	a4,8(a5)
 9ac:	fa9776e3          	bgeu	a4,s1,958 <malloc+0x70>
    if(p == freep)
 9b0:	00093703          	ld	a4,0(s2)
 9b4:	853e                	mv	a0,a5
 9b6:	fef719e3          	bne	a4,a5,9a8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9ba:	8552                	mv	a0,s4
 9bc:	00000097          	auipc	ra,0x0
 9c0:	b6e080e7          	jalr	-1170(ra) # 52a <sbrk>
  if(p == (char*)-1)
 9c4:	fd5518e3          	bne	a0,s5,994 <malloc+0xac>
        return 0;
 9c8:	4501                	li	a0,0
 9ca:	bf45                	j	97a <malloc+0x92>
