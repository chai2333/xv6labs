
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *name) {
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	0500                	addi	s0,sp,640
  2a:	89aa                	mv	s3,a0
  2c:	892e                	mv	s2,a1
  struct dirent de;

  char buf[512];
  int len;

  if ((fd = open(path, 0)) < 0) {
  2e:	4581                	li	a1,0
  30:	00000097          	auipc	ra,0x0
  34:	530080e7          	jalr	1328(ra) # 560 <open>
  38:	12054363          	bltz	a0,15e <find+0x15e>
  3c:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
  3e:	f9840593          	addi	a1,s0,-104
  42:	00000097          	auipc	ra,0x0
  46:	536080e7          	jalr	1334(ra) # 578 <fstat>
  4a:	12054563          	bltz	a0,174 <find+0x174>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    exit(1);
  }

  if (st.type != T_DIR) {
  4e:	fa041703          	lh	a4,-96(s0)
  52:	4785                	li	a5,1
  54:	14f71463          	bne	a4,a5,19c <find+0x19c>

  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (de.inum == 0)
      continue;

    if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
  58:	00001a17          	auipc	s4,0x1
  5c:	a18a0a13          	addi	s4,s4,-1512 # a70 <malloc+0x11a>
  60:	00001a97          	auipc	s5,0x1
  64:	a18a8a93          	addi	s5,s5,-1512 # a78 <malloc+0x122>
    }

    memmove(buf, path, strlen(path));
    memmove(buf + strlen(path), de.name, strlen(de.name));
    len = strlen(path) + strlen(de.name);
    if (buf[len - 1] != '/') {
  68:	02f00b13          	li	s6,47
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
  6c:	4641                	li	a2,16
  6e:	f8840593          	addi	a1,s0,-120
  72:	8526                	mv	a0,s1
  74:	00000097          	auipc	ra,0x0
  78:	4c4080e7          	jalr	1220(ra) # 538 <read>
  7c:	47c1                	li	a5,16
  7e:	14f51663          	bne	a0,a5,1ca <find+0x1ca>
    if (de.inum == 0)
  82:	f8845783          	lhu	a5,-120(s0)
  86:	d3fd                	beqz	a5,6c <find+0x6c>
    if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
  88:	85d2                	mv	a1,s4
  8a:	f8a40513          	addi	a0,s0,-118
  8e:	00000097          	auipc	ra,0x0
  92:	240080e7          	jalr	576(ra) # 2ce <strcmp>
  96:	d979                	beqz	a0,6c <find+0x6c>
  98:	85d6                	mv	a1,s5
  9a:	f8a40513          	addi	a0,s0,-118
  9e:	00000097          	auipc	ra,0x0
  a2:	230080e7          	jalr	560(ra) # 2ce <strcmp>
  a6:	d179                	beqz	a0,6c <find+0x6c>
    if (strcmp(de.name, name) == 0) {
  a8:	85ca                	mv	a1,s2
  aa:	f8a40513          	addi	a0,s0,-118
  ae:	00000097          	auipc	ra,0x0
  b2:	220080e7          	jalr	544(ra) # 2ce <strcmp>
  b6:	c96d                	beqz	a0,1a8 <find+0x1a8>
    memmove(buf, path, strlen(path));
  b8:	854e                	mv	a0,s3
  ba:	00000097          	auipc	ra,0x0
  be:	240080e7          	jalr	576(ra) # 2fa <strlen>
  c2:	0005061b          	sext.w	a2,a0
  c6:	85ce                	mv	a1,s3
  c8:	d8840513          	addi	a0,s0,-632
  cc:	00000097          	auipc	ra,0x0
  d0:	3a2080e7          	jalr	930(ra) # 46e <memmove>
    memmove(buf + strlen(path), de.name, strlen(de.name));
  d4:	854e                	mv	a0,s3
  d6:	00000097          	auipc	ra,0x0
  da:	224080e7          	jalr	548(ra) # 2fa <strlen>
  de:	00050b9b          	sext.w	s7,a0
  e2:	f8a40513          	addi	a0,s0,-118
  e6:	00000097          	auipc	ra,0x0
  ea:	214080e7          	jalr	532(ra) # 2fa <strlen>
  ee:	1b82                	slli	s7,s7,0x20
  f0:	020bdb93          	srli	s7,s7,0x20
  f4:	0005061b          	sext.w	a2,a0
  f8:	f8a40593          	addi	a1,s0,-118
  fc:	d8840793          	addi	a5,s0,-632
 100:	01778533          	add	a0,a5,s7
 104:	00000097          	auipc	ra,0x0
 108:	36a080e7          	jalr	874(ra) # 46e <memmove>
    len = strlen(path) + strlen(de.name);
 10c:	854e                	mv	a0,s3
 10e:	00000097          	auipc	ra,0x0
 112:	1ec080e7          	jalr	492(ra) # 2fa <strlen>
 116:	00050b9b          	sext.w	s7,a0
 11a:	f8a40513          	addi	a0,s0,-118
 11e:	00000097          	auipc	ra,0x0
 122:	1dc080e7          	jalr	476(ra) # 2fa <strlen>
 126:	00ab853b          	addw	a0,s7,a0
 12a:	0005079b          	sext.w	a5,a0
    if (buf[len - 1] != '/') {
 12e:	fff5071b          	addiw	a4,a0,-1
 132:	fb040693          	addi	a3,s0,-80
 136:	9736                	add	a4,a4,a3
 138:	dd874703          	lbu	a4,-552(a4)
 13c:	09670163          	beq	a4,s6,1be <find+0x1be>
      buf[len] = '/';
 140:	97b6                	add	a5,a5,a3
 142:	dd678c23          	sb	s6,-552(a5)
      buf[len + 1] = '\0';
 146:	2505                	addiw	a0,a0,1
 148:	9536                	add	a0,a0,a3
 14a:	dc050c23          	sb	zero,-552(a0)
    } else {
      buf[len] = '\0';
    }
    find(buf, name);
 14e:	85ca                	mv	a1,s2
 150:	d8840513          	addi	a0,s0,-632
 154:	00000097          	auipc	ra,0x0
 158:	eac080e7          	jalr	-340(ra) # 0 <find>
 15c:	bf01                	j	6c <find+0x6c>
    fprintf(2, "find: cannot open %s\n", path);
 15e:	864e                	mv	a2,s3
 160:	00001597          	auipc	a1,0x1
 164:	8e058593          	addi	a1,a1,-1824 # a40 <malloc+0xea>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	700080e7          	jalr	1792(ra) # 86a <fprintf>
    return;
 172:	a08d                	j	1d4 <find+0x1d4>
    fprintf(2, "find: cannot stat %s\n", path);
 174:	864e                	mv	a2,s3
 176:	00001597          	auipc	a1,0x1
 17a:	8e258593          	addi	a1,a1,-1822 # a58 <malloc+0x102>
 17e:	4509                	li	a0,2
 180:	00000097          	auipc	ra,0x0
 184:	6ea080e7          	jalr	1770(ra) # 86a <fprintf>
    close(fd);
 188:	8526                	mv	a0,s1
 18a:	00000097          	auipc	ra,0x0
 18e:	3be080e7          	jalr	958(ra) # 548 <close>
    exit(1);
 192:	4505                	li	a0,1
 194:	00000097          	auipc	ra,0x0
 198:	38c080e7          	jalr	908(ra) # 520 <exit>
    close(fd);
 19c:	8526                	mv	a0,s1
 19e:	00000097          	auipc	ra,0x0
 1a2:	3aa080e7          	jalr	938(ra) # 548 <close>
    return;
 1a6:	a03d                	j	1d4 <find+0x1d4>
      printf("%s%s\n", path, name);
 1a8:	864a                	mv	a2,s2
 1aa:	85ce                	mv	a1,s3
 1ac:	00001517          	auipc	a0,0x1
 1b0:	8d450513          	addi	a0,a0,-1836 # a80 <malloc+0x12a>
 1b4:	00000097          	auipc	ra,0x0
 1b8:	6e4080e7          	jalr	1764(ra) # 898 <printf>
      continue;
 1bc:	bd45                	j	6c <find+0x6c>
      buf[len] = '\0';
 1be:	fb040713          	addi	a4,s0,-80
 1c2:	97ba                	add	a5,a5,a4
 1c4:	dc078c23          	sb	zero,-552(a5)
 1c8:	b759                	j	14e <find+0x14e>
  }

  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	37c080e7          	jalr	892(ra) # 548 <close>
}
 1d4:	27813083          	ld	ra,632(sp)
 1d8:	27013403          	ld	s0,624(sp)
 1dc:	26813483          	ld	s1,616(sp)
 1e0:	26013903          	ld	s2,608(sp)
 1e4:	25813983          	ld	s3,600(sp)
 1e8:	25013a03          	ld	s4,592(sp)
 1ec:	24813a83          	ld	s5,584(sp)
 1f0:	24013b03          	ld	s6,576(sp)
 1f4:	23813b83          	ld	s7,568(sp)
 1f8:	28010113          	addi	sp,sp,640
 1fc:	8082                	ret

00000000000001fe <main>:

int main(int argc, char *argv[]) {
 1fe:	7139                	addi	sp,sp,-64
 200:	fc06                	sd	ra,56(sp)
 202:	f822                	sd	s0,48(sp)
 204:	f426                	sd	s1,40(sp)
 206:	f04a                	sd	s2,32(sp)
 208:	ec4e                	sd	s3,24(sp)
 20a:	0080                	addi	s0,sp,64
  char buf[DIRSIZ + 1];
  char *pathname;
  int pathlen;

  if (argc != 3) {
 20c:	478d                	li	a5,3
 20e:	02f50063          	beq	a0,a5,22e <main+0x30>
    fprintf(2, "Usage: find [dir] [filename]\n");
 212:	00001597          	auipc	a1,0x1
 216:	87658593          	addi	a1,a1,-1930 # a88 <malloc+0x132>
 21a:	4509                	li	a0,2
 21c:	00000097          	auipc	ra,0x0
 220:	64e080e7          	jalr	1614(ra) # 86a <fprintf>
    exit(1);
 224:	4505                	li	a0,1
 226:	00000097          	auipc	ra,0x0
 22a:	2fa080e7          	jalr	762(ra) # 520 <exit>
 22e:	892e                	mv	s2,a1
  }

  pathname = argv[1];
 230:	0085b983          	ld	s3,8(a1)
  pathlen = strlen(pathname);
 234:	854e                	mv	a0,s3
 236:	00000097          	auipc	ra,0x0
 23a:	0c4080e7          	jalr	196(ra) # 2fa <strlen>
 23e:	0005049b          	sext.w	s1,a0
  if (pathname[pathlen - 1] != '/') {
 242:	009987b3          	add	a5,s3,s1
 246:	fff7c703          	lbu	a4,-1(a5)
 24a:	02f00793          	li	a5,47
 24e:	00f71f63          	bne	a4,a5,26c <main+0x6e>
    memmove(buf, pathname, pathlen);
    buf[pathlen] = '/';
    buf[pathlen + 1] = '\0';
  }

  find(buf, argv[2]);
 252:	01093583          	ld	a1,16(s2)
 256:	fc040513          	addi	a0,s0,-64
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <find>
  exit(0);
 262:	4501                	li	a0,0
 264:	00000097          	auipc	ra,0x0
 268:	2bc080e7          	jalr	700(ra) # 520 <exit>
    memmove(buf, pathname, pathlen);
 26c:	8626                	mv	a2,s1
 26e:	85ce                	mv	a1,s3
 270:	fc040513          	addi	a0,s0,-64
 274:	00000097          	auipc	ra,0x0
 278:	1fa080e7          	jalr	506(ra) # 46e <memmove>
    buf[pathlen] = '/';
 27c:	fd040793          	addi	a5,s0,-48
 280:	97a6                	add	a5,a5,s1
 282:	02f00713          	li	a4,47
 286:	fee78823          	sb	a4,-16(a5)
    buf[pathlen + 1] = '\0';
 28a:	2485                	addiw	s1,s1,1
 28c:	fd040793          	addi	a5,s0,-48
 290:	94be                	add	s1,s1,a5
 292:	fe048823          	sb	zero,-16(s1)
 296:	bf75                	j	252 <main+0x54>

0000000000000298 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2a0:	00000097          	auipc	ra,0x0
 2a4:	f5e080e7          	jalr	-162(ra) # 1fe <main>
  exit(0);
 2a8:	4501                	li	a0,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	276080e7          	jalr	630(ra) # 520 <exit>

00000000000002b2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b8:	87aa                	mv	a5,a0
 2ba:	0585                	addi	a1,a1,1
 2bc:	0785                	addi	a5,a5,1
 2be:	fff5c703          	lbu	a4,-1(a1)
 2c2:	fee78fa3          	sb	a4,-1(a5)
 2c6:	fb75                	bnez	a4,2ba <strcpy+0x8>
    ;
  return os;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	cb91                	beqz	a5,2ec <strcmp+0x1e>
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	00f71763          	bne	a4,a5,2ec <strcmp+0x1e>
    p++, q++;
 2e2:	0505                	addi	a0,a0,1
 2e4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	fbe5                	bnez	a5,2da <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ec:	0005c503          	lbu	a0,0(a1)
}
 2f0:	40a7853b          	subw	a0,a5,a0
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <strlen>:

uint
strlen(const char *s)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 300:	00054783          	lbu	a5,0(a0)
 304:	cf91                	beqz	a5,320 <strlen+0x26>
 306:	0505                	addi	a0,a0,1
 308:	87aa                	mv	a5,a0
 30a:	4685                	li	a3,1
 30c:	9e89                	subw	a3,a3,a0
 30e:	00f6853b          	addw	a0,a3,a5
 312:	0785                	addi	a5,a5,1
 314:	fff7c703          	lbu	a4,-1(a5)
 318:	fb7d                	bnez	a4,30e <strlen+0x14>
    ;
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  for(n = 0; s[n]; n++)
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strlen+0x20>

0000000000000324 <memset>:

void*
memset(void *dst, int c, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 32a:	ca19                	beqz	a2,340 <memset+0x1c>
 32c:	87aa                	mv	a5,a0
 32e:	1602                	slli	a2,a2,0x20
 330:	9201                	srli	a2,a2,0x20
 332:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 336:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 33a:	0785                	addi	a5,a5,1
 33c:	fee79de3          	bne	a5,a4,336 <memset+0x12>
  }
  return dst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <strchr>:

char*
strchr(const char *s, char c)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 34c:	00054783          	lbu	a5,0(a0)
 350:	cb99                	beqz	a5,366 <strchr+0x20>
    if(*s == c)
 352:	00f58763          	beq	a1,a5,360 <strchr+0x1a>
  for(; *s; s++)
 356:	0505                	addi	a0,a0,1
 358:	00054783          	lbu	a5,0(a0)
 35c:	fbfd                	bnez	a5,352 <strchr+0xc>
      return (char*)s;
  return 0;
 35e:	4501                	li	a0,0
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <strchr+0x1a>

000000000000036a <gets>:

char*
gets(char *buf, int max)
{
 36a:	711d                	addi	sp,sp,-96
 36c:	ec86                	sd	ra,88(sp)
 36e:	e8a2                	sd	s0,80(sp)
 370:	e4a6                	sd	s1,72(sp)
 372:	e0ca                	sd	s2,64(sp)
 374:	fc4e                	sd	s3,56(sp)
 376:	f852                	sd	s4,48(sp)
 378:	f456                	sd	s5,40(sp)
 37a:	f05a                	sd	s6,32(sp)
 37c:	ec5e                	sd	s7,24(sp)
 37e:	1080                	addi	s0,sp,96
 380:	8baa                	mv	s7,a0
 382:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 384:	892a                	mv	s2,a0
 386:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 388:	4aa9                	li	s5,10
 38a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 38c:	89a6                	mv	s3,s1
 38e:	2485                	addiw	s1,s1,1
 390:	0344d863          	bge	s1,s4,3c0 <gets+0x56>
    cc = read(0, &c, 1);
 394:	4605                	li	a2,1
 396:	faf40593          	addi	a1,s0,-81
 39a:	4501                	li	a0,0
 39c:	00000097          	auipc	ra,0x0
 3a0:	19c080e7          	jalr	412(ra) # 538 <read>
    if(cc < 1)
 3a4:	00a05e63          	blez	a0,3c0 <gets+0x56>
    buf[i++] = c;
 3a8:	faf44783          	lbu	a5,-81(s0)
 3ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b0:	01578763          	beq	a5,s5,3be <gets+0x54>
 3b4:	0905                	addi	s2,s2,1
 3b6:	fd679be3          	bne	a5,s6,38c <gets+0x22>
  for(i=0; i+1 < max; ){
 3ba:	89a6                	mv	s3,s1
 3bc:	a011                	j	3c0 <gets+0x56>
 3be:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c0:	99de                	add	s3,s3,s7
 3c2:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c6:	855e                	mv	a0,s7
 3c8:	60e6                	ld	ra,88(sp)
 3ca:	6446                	ld	s0,80(sp)
 3cc:	64a6                	ld	s1,72(sp)
 3ce:	6906                	ld	s2,64(sp)
 3d0:	79e2                	ld	s3,56(sp)
 3d2:	7a42                	ld	s4,48(sp)
 3d4:	7aa2                	ld	s5,40(sp)
 3d6:	7b02                	ld	s6,32(sp)
 3d8:	6be2                	ld	s7,24(sp)
 3da:	6125                	addi	sp,sp,96
 3dc:	8082                	ret

00000000000003de <stat>:

int
stat(const char *n, struct stat *st)
{
 3de:	1101                	addi	sp,sp,-32
 3e0:	ec06                	sd	ra,24(sp)
 3e2:	e822                	sd	s0,16(sp)
 3e4:	e426                	sd	s1,8(sp)
 3e6:	e04a                	sd	s2,0(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ec:	4581                	li	a1,0
 3ee:	00000097          	auipc	ra,0x0
 3f2:	172080e7          	jalr	370(ra) # 560 <open>
  if(fd < 0)
 3f6:	02054563          	bltz	a0,420 <stat+0x42>
 3fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3fc:	85ca                	mv	a1,s2
 3fe:	00000097          	auipc	ra,0x0
 402:	17a080e7          	jalr	378(ra) # 578 <fstat>
 406:	892a                	mv	s2,a0
  close(fd);
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	13e080e7          	jalr	318(ra) # 548 <close>
  return r;
}
 412:	854a                	mv	a0,s2
 414:	60e2                	ld	ra,24(sp)
 416:	6442                	ld	s0,16(sp)
 418:	64a2                	ld	s1,8(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfc5                	j	412 <stat+0x34>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42a:	00054603          	lbu	a2,0(a0)
 42e:	fd06079b          	addiw	a5,a2,-48
 432:	0ff7f793          	andi	a5,a5,255
 436:	4725                	li	a4,9
 438:	02f76963          	bltu	a4,a5,46a <atoi+0x46>
 43c:	86aa                	mv	a3,a0
  n = 0;
 43e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 440:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 442:	0685                	addi	a3,a3,1
 444:	0025179b          	slliw	a5,a0,0x2
 448:	9fa9                	addw	a5,a5,a0
 44a:	0017979b          	slliw	a5,a5,0x1
 44e:	9fb1                	addw	a5,a5,a2
 450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 454:	0006c603          	lbu	a2,0(a3)
 458:	fd06071b          	addiw	a4,a2,-48
 45c:	0ff77713          	andi	a4,a4,255
 460:	fee5f1e3          	bgeu	a1,a4,442 <atoi+0x1e>
  return n;
}
 464:	6422                	ld	s0,8(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret
  n = 0;
 46a:	4501                	li	a0,0
 46c:	bfe5                	j	464 <atoi+0x40>

000000000000046e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 474:	02b57463          	bgeu	a0,a1,49c <memmove+0x2e>
    while(n-- > 0)
 478:	00c05f63          	blez	a2,496 <memmove+0x28>
 47c:	1602                	slli	a2,a2,0x20
 47e:	9201                	srli	a2,a2,0x20
 480:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 484:	872a                	mv	a4,a0
      *dst++ = *src++;
 486:	0585                	addi	a1,a1,1
 488:	0705                	addi	a4,a4,1
 48a:	fff5c683          	lbu	a3,-1(a1)
 48e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 492:	fee79ae3          	bne	a5,a4,486 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
    dst += n;
 49c:	00c50733          	add	a4,a0,a2
    src += n;
 4a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a2:	fec05ae3          	blez	a2,496 <memmove+0x28>
 4a6:	fff6079b          	addiw	a5,a2,-1
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	fff7c793          	not	a5,a5
 4b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b4:	15fd                	addi	a1,a1,-1
 4b6:	177d                	addi	a4,a4,-1
 4b8:	0005c683          	lbu	a3,0(a1)
 4bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c0:	fee79ae3          	bne	a5,a4,4b4 <memmove+0x46>
 4c4:	bfc9                	j	496 <memmove+0x28>

00000000000004c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e422                	sd	s0,8(sp)
 4ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4cc:	ca05                	beqz	a2,4fc <memcmp+0x36>
 4ce:	fff6069b          	addiw	a3,a2,-1
 4d2:	1682                	slli	a3,a3,0x20
 4d4:	9281                	srli	a3,a3,0x20
 4d6:	0685                	addi	a3,a3,1
 4d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4da:	00054783          	lbu	a5,0(a0)
 4de:	0005c703          	lbu	a4,0(a1)
 4e2:	00e79863          	bne	a5,a4,4f2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4e6:	0505                	addi	a0,a0,1
    p2++;
 4e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ea:	fed518e3          	bne	a0,a3,4da <memcmp+0x14>
  }
  return 0;
 4ee:	4501                	li	a0,0
 4f0:	a019                	j	4f6 <memcmp+0x30>
      return *p1 - *p2;
 4f2:	40e7853b          	subw	a0,a5,a4
}
 4f6:	6422                	ld	s0,8(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
  return 0;
 4fc:	4501                	li	a0,0
 4fe:	bfe5                	j	4f6 <memcmp+0x30>

0000000000000500 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 508:	00000097          	auipc	ra,0x0
 50c:	f66080e7          	jalr	-154(ra) # 46e <memmove>
}
 510:	60a2                	ld	ra,8(sp)
 512:	6402                	ld	s0,0(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret

0000000000000518 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 518:	4885                	li	a7,1
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exit>:
.global exit
exit:
 li a7, SYS_exit
 520:	4889                	li	a7,2
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <wait>:
.global wait
wait:
 li a7, SYS_wait
 528:	488d                	li	a7,3
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 530:	4891                	li	a7,4
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <read>:
.global read
read:
 li a7, SYS_read
 538:	4895                	li	a7,5
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <write>:
.global write
write:
 li a7, SYS_write
 540:	48c1                	li	a7,16
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <close>:
.global close
close:
 li a7, SYS_close
 548:	48d5                	li	a7,21
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <kill>:
.global kill
kill:
 li a7, SYS_kill
 550:	4899                	li	a7,6
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exec>:
.global exec
exec:
 li a7, SYS_exec
 558:	489d                	li	a7,7
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <open>:
.global open
open:
 li a7, SYS_open
 560:	48bd                	li	a7,15
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 568:	48c5                	li	a7,17
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 570:	48c9                	li	a7,18
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 578:	48a1                	li	a7,8
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <link>:
.global link
link:
 li a7, SYS_link
 580:	48cd                	li	a7,19
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 588:	48d1                	li	a7,20
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 590:	48a5                	li	a7,9
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <dup>:
.global dup
dup:
 li a7, SYS_dup
 598:	48a9                	li	a7,10
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a0:	48ad                	li	a7,11
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a8:	48b1                	li	a7,12
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b0:	48b5                	li	a7,13
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b8:	48b9                	li	a7,14
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c0:	1101                	addi	sp,sp,-32
 5c2:	ec06                	sd	ra,24(sp)
 5c4:	e822                	sd	s0,16(sp)
 5c6:	1000                	addi	s0,sp,32
 5c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5cc:	4605                	li	a2,1
 5ce:	fef40593          	addi	a1,s0,-17
 5d2:	00000097          	auipc	ra,0x0
 5d6:	f6e080e7          	jalr	-146(ra) # 540 <write>
}
 5da:	60e2                	ld	ra,24(sp)
 5dc:	6442                	ld	s0,16(sp)
 5de:	6105                	addi	sp,sp,32
 5e0:	8082                	ret

00000000000005e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e2:	7139                	addi	sp,sp,-64
 5e4:	fc06                	sd	ra,56(sp)
 5e6:	f822                	sd	s0,48(sp)
 5e8:	f426                	sd	s1,40(sp)
 5ea:	f04a                	sd	s2,32(sp)
 5ec:	ec4e                	sd	s3,24(sp)
 5ee:	0080                	addi	s0,sp,64
 5f0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f2:	c299                	beqz	a3,5f8 <printint+0x16>
 5f4:	0805c863          	bltz	a1,684 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f8:	2581                	sext.w	a1,a1
  neg = 0;
 5fa:	4881                	li	a7,0
 5fc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 600:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 602:	2601                	sext.w	a2,a2
 604:	00000517          	auipc	a0,0x0
 608:	4ac50513          	addi	a0,a0,1196 # ab0 <digits>
 60c:	883a                	mv	a6,a4
 60e:	2705                	addiw	a4,a4,1
 610:	02c5f7bb          	remuw	a5,a1,a2
 614:	1782                	slli	a5,a5,0x20
 616:	9381                	srli	a5,a5,0x20
 618:	97aa                	add	a5,a5,a0
 61a:	0007c783          	lbu	a5,0(a5)
 61e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 622:	0005879b          	sext.w	a5,a1
 626:	02c5d5bb          	divuw	a1,a1,a2
 62a:	0685                	addi	a3,a3,1
 62c:	fec7f0e3          	bgeu	a5,a2,60c <printint+0x2a>
  if(neg)
 630:	00088b63          	beqz	a7,646 <printint+0x64>
    buf[i++] = '-';
 634:	fd040793          	addi	a5,s0,-48
 638:	973e                	add	a4,a4,a5
 63a:	02d00793          	li	a5,45
 63e:	fef70823          	sb	a5,-16(a4)
 642:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 646:	02e05863          	blez	a4,676 <printint+0x94>
 64a:	fc040793          	addi	a5,s0,-64
 64e:	00e78933          	add	s2,a5,a4
 652:	fff78993          	addi	s3,a5,-1
 656:	99ba                	add	s3,s3,a4
 658:	377d                	addiw	a4,a4,-1
 65a:	1702                	slli	a4,a4,0x20
 65c:	9301                	srli	a4,a4,0x20
 65e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 662:	fff94583          	lbu	a1,-1(s2)
 666:	8526                	mv	a0,s1
 668:	00000097          	auipc	ra,0x0
 66c:	f58080e7          	jalr	-168(ra) # 5c0 <putc>
  while(--i >= 0)
 670:	197d                	addi	s2,s2,-1
 672:	ff3918e3          	bne	s2,s3,662 <printint+0x80>
}
 676:	70e2                	ld	ra,56(sp)
 678:	7442                	ld	s0,48(sp)
 67a:	74a2                	ld	s1,40(sp)
 67c:	7902                	ld	s2,32(sp)
 67e:	69e2                	ld	s3,24(sp)
 680:	6121                	addi	sp,sp,64
 682:	8082                	ret
    x = -xx;
 684:	40b005bb          	negw	a1,a1
    neg = 1;
 688:	4885                	li	a7,1
    x = -xx;
 68a:	bf8d                	j	5fc <printint+0x1a>

000000000000068c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 68c:	7119                	addi	sp,sp,-128
 68e:	fc86                	sd	ra,120(sp)
 690:	f8a2                	sd	s0,112(sp)
 692:	f4a6                	sd	s1,104(sp)
 694:	f0ca                	sd	s2,96(sp)
 696:	ecce                	sd	s3,88(sp)
 698:	e8d2                	sd	s4,80(sp)
 69a:	e4d6                	sd	s5,72(sp)
 69c:	e0da                	sd	s6,64(sp)
 69e:	fc5e                	sd	s7,56(sp)
 6a0:	f862                	sd	s8,48(sp)
 6a2:	f466                	sd	s9,40(sp)
 6a4:	f06a                	sd	s10,32(sp)
 6a6:	ec6e                	sd	s11,24(sp)
 6a8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6aa:	0005c903          	lbu	s2,0(a1)
 6ae:	18090f63          	beqz	s2,84c <vprintf+0x1c0>
 6b2:	8aaa                	mv	s5,a0
 6b4:	8b32                	mv	s6,a2
 6b6:	00158493          	addi	s1,a1,1
  state = 0;
 6ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6bc:	02500a13          	li	s4,37
      if(c == 'd'){
 6c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6c4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6c8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6cc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d0:	00000b97          	auipc	s7,0x0
 6d4:	3e0b8b93          	addi	s7,s7,992 # ab0 <digits>
 6d8:	a839                	j	6f6 <vprintf+0x6a>
        putc(fd, c);
 6da:	85ca                	mv	a1,s2
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	ee2080e7          	jalr	-286(ra) # 5c0 <putc>
 6e6:	a019                	j	6ec <vprintf+0x60>
    } else if(state == '%'){
 6e8:	01498f63          	beq	s3,s4,706 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6ec:	0485                	addi	s1,s1,1
 6ee:	fff4c903          	lbu	s2,-1(s1)
 6f2:	14090d63          	beqz	s2,84c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6fa:	fe0997e3          	bnez	s3,6e8 <vprintf+0x5c>
      if(c == '%'){
 6fe:	fd479ee3          	bne	a5,s4,6da <vprintf+0x4e>
        state = '%';
 702:	89be                	mv	s3,a5
 704:	b7e5                	j	6ec <vprintf+0x60>
      if(c == 'd'){
 706:	05878063          	beq	a5,s8,746 <vprintf+0xba>
      } else if(c == 'l') {
 70a:	05978c63          	beq	a5,s9,762 <vprintf+0xd6>
      } else if(c == 'x') {
 70e:	07a78863          	beq	a5,s10,77e <vprintf+0xf2>
      } else if(c == 'p') {
 712:	09b78463          	beq	a5,s11,79a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 716:	07300713          	li	a4,115
 71a:	0ce78663          	beq	a5,a4,7e6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71e:	06300713          	li	a4,99
 722:	0ee78e63          	beq	a5,a4,81e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 726:	11478863          	beq	a5,s4,836 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72a:	85d2                	mv	a1,s4
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	e92080e7          	jalr	-366(ra) # 5c0 <putc>
        putc(fd, c);
 736:	85ca                	mv	a1,s2
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e86080e7          	jalr	-378(ra) # 5c0 <putc>
      }
      state = 0;
 742:	4981                	li	s3,0
 744:	b765                	j	6ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 746:	008b0913          	addi	s2,s6,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000b2583          	lw	a1,0(s6)
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e8e080e7          	jalr	-370(ra) # 5e2 <printint>
 75c:	8b4a                	mv	s6,s2
      state = 0;
 75e:	4981                	li	s3,0
 760:	b771                	j	6ec <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 762:	008b0913          	addi	s2,s6,8
 766:	4681                	li	a3,0
 768:	4629                	li	a2,10
 76a:	000b2583          	lw	a1,0(s6)
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	e72080e7          	jalr	-398(ra) # 5e2 <printint>
 778:	8b4a                	mv	s6,s2
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bf85                	j	6ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 77e:	008b0913          	addi	s2,s6,8
 782:	4681                	li	a3,0
 784:	4641                	li	a2,16
 786:	000b2583          	lw	a1,0(s6)
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	e56080e7          	jalr	-426(ra) # 5e2 <printint>
 794:	8b4a                	mv	s6,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	bf91                	j	6ec <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 79a:	008b0793          	addi	a5,s6,8
 79e:	f8f43423          	sd	a5,-120(s0)
 7a2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7a6:	03000593          	li	a1,48
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e14080e7          	jalr	-492(ra) # 5c0 <putc>
  putc(fd, 'x');
 7b4:	85ea                	mv	a1,s10
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e08080e7          	jalr	-504(ra) # 5c0 <putc>
 7c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c2:	03c9d793          	srli	a5,s3,0x3c
 7c6:	97de                	add	a5,a5,s7
 7c8:	0007c583          	lbu	a1,0(a5)
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	df2080e7          	jalr	-526(ra) # 5c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d6:	0992                	slli	s3,s3,0x4
 7d8:	397d                	addiw	s2,s2,-1
 7da:	fe0914e3          	bnez	s2,7c2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7de:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b721                	j	6ec <vprintf+0x60>
        s = va_arg(ap, char*);
 7e6:	008b0993          	addi	s3,s6,8
 7ea:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ee:	02090163          	beqz	s2,810 <vprintf+0x184>
        while(*s != 0){
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	c9a1                	beqz	a1,846 <vprintf+0x1ba>
          putc(fd, *s);
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	dc6080e7          	jalr	-570(ra) # 5c0 <putc>
          s++;
 802:	0905                	addi	s2,s2,1
        while(*s != 0){
 804:	00094583          	lbu	a1,0(s2)
 808:	f9e5                	bnez	a1,7f8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 80a:	8b4e                	mv	s6,s3
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bdf9                	j	6ec <vprintf+0x60>
          s = "(null)";
 810:	00000917          	auipc	s2,0x0
 814:	29890913          	addi	s2,s2,664 # aa8 <malloc+0x152>
        while(*s != 0){
 818:	02800593          	li	a1,40
 81c:	bff1                	j	7f8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 81e:	008b0913          	addi	s2,s6,8
 822:	000b4583          	lbu	a1,0(s6)
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	d98080e7          	jalr	-616(ra) # 5c0 <putc>
 830:	8b4a                	mv	s6,s2
      state = 0;
 832:	4981                	li	s3,0
 834:	bd65                	j	6ec <vprintf+0x60>
        putc(fd, c);
 836:	85d2                	mv	a1,s4
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	d86080e7          	jalr	-634(ra) # 5c0 <putc>
      state = 0;
 842:	4981                	li	s3,0
 844:	b565                	j	6ec <vprintf+0x60>
        s = va_arg(ap, char*);
 846:	8b4e                	mv	s6,s3
      state = 0;
 848:	4981                	li	s3,0
 84a:	b54d                	j	6ec <vprintf+0x60>
    }
  }
}
 84c:	70e6                	ld	ra,120(sp)
 84e:	7446                	ld	s0,112(sp)
 850:	74a6                	ld	s1,104(sp)
 852:	7906                	ld	s2,96(sp)
 854:	69e6                	ld	s3,88(sp)
 856:	6a46                	ld	s4,80(sp)
 858:	6aa6                	ld	s5,72(sp)
 85a:	6b06                	ld	s6,64(sp)
 85c:	7be2                	ld	s7,56(sp)
 85e:	7c42                	ld	s8,48(sp)
 860:	7ca2                	ld	s9,40(sp)
 862:	7d02                	ld	s10,32(sp)
 864:	6de2                	ld	s11,24(sp)
 866:	6109                	addi	sp,sp,128
 868:	8082                	ret

000000000000086a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 86a:	715d                	addi	sp,sp,-80
 86c:	ec06                	sd	ra,24(sp)
 86e:	e822                	sd	s0,16(sp)
 870:	1000                	addi	s0,sp,32
 872:	e010                	sd	a2,0(s0)
 874:	e414                	sd	a3,8(s0)
 876:	e818                	sd	a4,16(s0)
 878:	ec1c                	sd	a5,24(s0)
 87a:	03043023          	sd	a6,32(s0)
 87e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 886:	8622                	mv	a2,s0
 888:	00000097          	auipc	ra,0x0
 88c:	e04080e7          	jalr	-508(ra) # 68c <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6161                	addi	sp,sp,80
 896:	8082                	ret

0000000000000898 <printf>:

void
printf(const char *fmt, ...)
{
 898:	711d                	addi	sp,sp,-96
 89a:	ec06                	sd	ra,24(sp)
 89c:	e822                	sd	s0,16(sp)
 89e:	1000                	addi	s0,sp,32
 8a0:	e40c                	sd	a1,8(s0)
 8a2:	e810                	sd	a2,16(s0)
 8a4:	ec14                	sd	a3,24(s0)
 8a6:	f018                	sd	a4,32(s0)
 8a8:	f41c                	sd	a5,40(s0)
 8aa:	03043823          	sd	a6,48(s0)
 8ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b2:	00840613          	addi	a2,s0,8
 8b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ba:	85aa                	mv	a1,a0
 8bc:	4505                	li	a0,1
 8be:	00000097          	auipc	ra,0x0
 8c2:	dce080e7          	jalr	-562(ra) # 68c <vprintf>
}
 8c6:	60e2                	ld	ra,24(sp)
 8c8:	6442                	ld	s0,16(sp)
 8ca:	6125                	addi	sp,sp,96
 8cc:	8082                	ret

00000000000008ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ce:	1141                	addi	sp,sp,-16
 8d0:	e422                	sd	s0,8(sp)
 8d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d8:	00000797          	auipc	a5,0x0
 8dc:	7287b783          	ld	a5,1832(a5) # 1000 <freep>
 8e0:	a805                	j	910 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e2:	4618                	lw	a4,8(a2)
 8e4:	9db9                	addw	a1,a1,a4
 8e6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	6318                	ld	a4,0(a4)
 8ee:	fee53823          	sd	a4,-16(a0)
 8f2:	a091                	j	936 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f4:	ff852703          	lw	a4,-8(a0)
 8f8:	9e39                	addw	a2,a2,a4
 8fa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8fc:	ff053703          	ld	a4,-16(a0)
 900:	e398                	sd	a4,0(a5)
 902:	a099                	j	948 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	6398                	ld	a4,0(a5)
 906:	00e7e463          	bltu	a5,a4,90e <free+0x40>
 90a:	00e6ea63          	bltu	a3,a4,91e <free+0x50>
{
 90e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	fed7fae3          	bgeu	a5,a3,904 <free+0x36>
 914:	6398                	ld	a4,0(a5)
 916:	00e6e463          	bltu	a3,a4,91e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	fee7eae3          	bltu	a5,a4,90e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 91e:	ff852583          	lw	a1,-8(a0)
 922:	6390                	ld	a2,0(a5)
 924:	02059713          	slli	a4,a1,0x20
 928:	9301                	srli	a4,a4,0x20
 92a:	0712                	slli	a4,a4,0x4
 92c:	9736                	add	a4,a4,a3
 92e:	fae60ae3          	beq	a2,a4,8e2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 932:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 936:	4790                	lw	a2,8(a5)
 938:	02061713          	slli	a4,a2,0x20
 93c:	9301                	srli	a4,a4,0x20
 93e:	0712                	slli	a4,a4,0x4
 940:	973e                	add	a4,a4,a5
 942:	fae689e3          	beq	a3,a4,8f4 <free+0x26>
  } else
    p->s.ptr = bp;
 946:	e394                	sd	a3,0(a5)
  freep = p;
 948:	00000717          	auipc	a4,0x0
 94c:	6af73c23          	sd	a5,1720(a4) # 1000 <freep>
}
 950:	6422                	ld	s0,8(sp)
 952:	0141                	addi	sp,sp,16
 954:	8082                	ret

0000000000000956 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 956:	7139                	addi	sp,sp,-64
 958:	fc06                	sd	ra,56(sp)
 95a:	f822                	sd	s0,48(sp)
 95c:	f426                	sd	s1,40(sp)
 95e:	f04a                	sd	s2,32(sp)
 960:	ec4e                	sd	s3,24(sp)
 962:	e852                	sd	s4,16(sp)
 964:	e456                	sd	s5,8(sp)
 966:	e05a                	sd	s6,0(sp)
 968:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 96a:	02051493          	slli	s1,a0,0x20
 96e:	9081                	srli	s1,s1,0x20
 970:	04bd                	addi	s1,s1,15
 972:	8091                	srli	s1,s1,0x4
 974:	0014899b          	addiw	s3,s1,1
 978:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 97a:	00000517          	auipc	a0,0x0
 97e:	68653503          	ld	a0,1670(a0) # 1000 <freep>
 982:	c515                	beqz	a0,9ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 984:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 986:	4798                	lw	a4,8(a5)
 988:	02977f63          	bgeu	a4,s1,9c6 <malloc+0x70>
 98c:	8a4e                	mv	s4,s3
 98e:	0009871b          	sext.w	a4,s3
 992:	6685                	lui	a3,0x1
 994:	00d77363          	bgeu	a4,a3,99a <malloc+0x44>
 998:	6a05                	lui	s4,0x1
 99a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a2:	00000917          	auipc	s2,0x0
 9a6:	65e90913          	addi	s2,s2,1630 # 1000 <freep>
  if(p == (char*)-1)
 9aa:	5afd                	li	s5,-1
 9ac:	a88d                	j	a1e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9ae:	00000797          	auipc	a5,0x0
 9b2:	66278793          	addi	a5,a5,1634 # 1010 <base>
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64f73523          	sd	a5,1610(a4) # 1000 <freep>
 9be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c4:	b7e1                	j	98c <malloc+0x36>
      if(p->s.size == nunits)
 9c6:	02e48b63          	beq	s1,a4,9fc <malloc+0xa6>
        p->s.size -= nunits;
 9ca:	4137073b          	subw	a4,a4,s3
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	1702                	slli	a4,a4,0x20
 9d2:	9301                	srli	a4,a4,0x20
 9d4:	0712                	slli	a4,a4,0x4
 9d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9dc:	00000717          	auipc	a4,0x0
 9e0:	62a73223          	sd	a0,1572(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9e8:	70e2                	ld	ra,56(sp)
 9ea:	7442                	ld	s0,48(sp)
 9ec:	74a2                	ld	s1,40(sp)
 9ee:	7902                	ld	s2,32(sp)
 9f0:	69e2                	ld	s3,24(sp)
 9f2:	6a42                	ld	s4,16(sp)
 9f4:	6aa2                	ld	s5,8(sp)
 9f6:	6b02                	ld	s6,0(sp)
 9f8:	6121                	addi	sp,sp,64
 9fa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9fc:	6398                	ld	a4,0(a5)
 9fe:	e118                	sd	a4,0(a0)
 a00:	bff1                	j	9dc <malloc+0x86>
  hp->s.size = nu;
 a02:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a06:	0541                	addi	a0,a0,16
 a08:	00000097          	auipc	ra,0x0
 a0c:	ec6080e7          	jalr	-314(ra) # 8ce <free>
  return freep;
 a10:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a14:	d971                	beqz	a0,9e8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a18:	4798                	lw	a4,8(a5)
 a1a:	fa9776e3          	bgeu	a4,s1,9c6 <malloc+0x70>
    if(p == freep)
 a1e:	00093703          	ld	a4,0(s2)
 a22:	853e                	mv	a0,a5
 a24:	fef719e3          	bne	a4,a5,a16 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a28:	8552                	mv	a0,s4
 a2a:	00000097          	auipc	ra,0x0
 a2e:	b7e080e7          	jalr	-1154(ra) # 5a8 <sbrk>
  if(p == (char*)-1)
 a32:	fd5518e3          	bne	a0,s5,a02 <malloc+0xac>
        return 0;
 a36:	4501                	li	a0,0
 a38:	bf45                	j	9e8 <malloc+0x92>
