
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	ea2080e7          	jalr	-350(ra) # f32 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	34650513          	addi	a0,a0,838 # 13e0 <malloc+0xf0>
      a2:	00001097          	auipc	ra,0x1
      a6:	e70080e7          	jalr	-400(ra) # f12 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	33650513          	addi	a0,a0,822 # 13e0 <malloc+0xf0>
      b2:	00001097          	auipc	ra,0x1
      b6:	e68080e7          	jalr	-408(ra) # f1a <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	32c50513          	addi	a0,a0,812 # 13e8 <malloc+0xf8>
      c4:	00001097          	auipc	ra,0x1
      c8:	16e080e7          	jalr	366(ra) # 1232 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	ddc080e7          	jalr	-548(ra) # eaa <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	33250513          	addi	a0,a0,818 # 1408 <malloc+0x118>
      de:	00001097          	auipc	ra,0x1
      e2:	e3c080e7          	jalr	-452(ra) # f1a <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	33298993          	addi	s3,s3,818 # 1418 <malloc+0x128>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	32098993          	addi	s3,s3,800 # 1410 <malloc+0x120>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      fc:	00002a17          	auipc	s4,0x2
     100:	f24a0a13          	addi	s4,s4,-220 # 2020 <buf.0>
     104:	a825                	j	13c <go+0xc4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	31650513          	addi	a0,a0,790 # 1420 <malloc+0x130>
     112:	00001097          	auipc	ra,0x1
     116:	dd8080e7          	jalr	-552(ra) # eea <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	db8080e7          	jalr	-584(ra) # ed2 <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	d96080e7          	jalr	-618(ra) # eca <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	4789                	li	a5,2
     152:	18f50563          	beq	a0,a5,2dc <go+0x264>
    } else if(what == 3){
     156:	478d                	li	a5,3
     158:	1af50163          	beq	a0,a5,2fa <go+0x282>
    } else if(what == 4){
     15c:	4791                	li	a5,4
     15e:	1af50763          	beq	a0,a5,30c <go+0x294>
    } else if(what == 5){
     162:	4795                	li	a5,5
     164:	1ef50b63          	beq	a0,a5,35a <go+0x2e2>
    } else if(what == 6){
     168:	4799                	li	a5,6
     16a:	20f50963          	beq	a0,a5,37c <go+0x304>
    } else if(what == 7){
     16e:	479d                	li	a5,7
     170:	22f50763          	beq	a0,a5,39e <go+0x326>
    } else if(what == 8){
     174:	47a1                	li	a5,8
     176:	22f50d63          	beq	a0,a5,3b0 <go+0x338>
    } else if(what == 9){
     17a:	47a5                	li	a5,9
     17c:	24f50363          	beq	a0,a5,3c2 <go+0x34a>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     180:	47a9                	li	a5,10
     182:	26f50f63          	beq	a0,a5,400 <go+0x388>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     186:	47ad                	li	a5,11
     188:	2af50b63          	beq	a0,a5,43e <go+0x3c6>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     18c:	47b1                	li	a5,12
     18e:	2cf50d63          	beq	a0,a5,468 <go+0x3f0>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     192:	47b5                	li	a5,13
     194:	2ef50f63          	beq	a0,a5,492 <go+0x41a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     198:	47b9                	li	a5,14
     19a:	32f50a63          	beq	a0,a5,4ce <go+0x456>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     19e:	47bd                	li	a5,15
     1a0:	36f50e63          	beq	a0,a5,51c <go+0x4a4>
      sbrk(6011);
    } else if(what == 16){
     1a4:	47c1                	li	a5,16
     1a6:	38f50363          	beq	a0,a5,52c <go+0x4b4>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1aa:	47c5                	li	a5,17
     1ac:	3af50363          	beq	a0,a5,552 <go+0x4da>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1b0:	47c9                	li	a5,18
     1b2:	42f50963          	beq	a0,a5,5e4 <go+0x56c>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b6:	47cd                	li	a5,19
     1b8:	46f50d63          	beq	a0,a5,632 <go+0x5ba>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1bc:	47d1                	li	a5,20
     1be:	54f50e63          	beq	a0,a5,71a <go+0x6a2>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c2:	47d5                	li	a5,21
     1c4:	5ef50c63          	beq	a0,a5,7bc <go+0x744>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c8:	47d9                	li	a5,22
     1ca:	f4f51ce3          	bne	a0,a5,122 <go+0xaa>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1ce:	f9840513          	addi	a0,s0,-104
     1d2:	00001097          	auipc	ra,0x1
     1d6:	ce8080e7          	jalr	-792(ra) # eba <pipe>
     1da:	6e054563          	bltz	a0,8c4 <go+0x84c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1de:	fa040513          	addi	a0,s0,-96
     1e2:	00001097          	auipc	ra,0x1
     1e6:	cd8080e7          	jalr	-808(ra) # eba <pipe>
     1ea:	6e054b63          	bltz	a0,8e0 <go+0x868>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ee:	00001097          	auipc	ra,0x1
     1f2:	cb4080e7          	jalr	-844(ra) # ea2 <fork>
      if(pid1 == 0){
     1f6:	70050363          	beqz	a0,8fc <go+0x884>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1fa:	7a054b63          	bltz	a0,9b0 <go+0x938>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fe:	00001097          	auipc	ra,0x1
     202:	ca4080e7          	jalr	-860(ra) # ea2 <fork>
      if(pid2 == 0){
     206:	7c050363          	beqz	a0,9cc <go+0x954>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     20a:	08054fe3          	bltz	a0,aa8 <go+0xa30>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20e:	f9842503          	lw	a0,-104(s0)
     212:	00001097          	auipc	ra,0x1
     216:	cc0080e7          	jalr	-832(ra) # ed2 <close>
      close(aa[1]);
     21a:	f9c42503          	lw	a0,-100(s0)
     21e:	00001097          	auipc	ra,0x1
     222:	cb4080e7          	jalr	-844(ra) # ed2 <close>
      close(bb[1]);
     226:	fa442503          	lw	a0,-92(s0)
     22a:	00001097          	auipc	ra,0x1
     22e:	ca8080e7          	jalr	-856(ra) # ed2 <close>
      char buf[4] = { 0, 0, 0, 0 };
     232:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     236:	4605                	li	a2,1
     238:	f9040593          	addi	a1,s0,-112
     23c:	fa042503          	lw	a0,-96(s0)
     240:	00001097          	auipc	ra,0x1
     244:	c82080e7          	jalr	-894(ra) # ec2 <read>
      read(bb[0], buf+1, 1);
     248:	4605                	li	a2,1
     24a:	f9140593          	addi	a1,s0,-111
     24e:	fa042503          	lw	a0,-96(s0)
     252:	00001097          	auipc	ra,0x1
     256:	c70080e7          	jalr	-912(ra) # ec2 <read>
      read(bb[0], buf+2, 1);
     25a:	4605                	li	a2,1
     25c:	f9240593          	addi	a1,s0,-110
     260:	fa042503          	lw	a0,-96(s0)
     264:	00001097          	auipc	ra,0x1
     268:	c5e080e7          	jalr	-930(ra) # ec2 <read>
      close(bb[0]);
     26c:	fa042503          	lw	a0,-96(s0)
     270:	00001097          	auipc	ra,0x1
     274:	c62080e7          	jalr	-926(ra) # ed2 <close>
      int st1, st2;
      wait(&st1);
     278:	f9440513          	addi	a0,s0,-108
     27c:	00001097          	auipc	ra,0x1
     280:	c36080e7          	jalr	-970(ra) # eb2 <wait>
      wait(&st2);
     284:	fa840513          	addi	a0,s0,-88
     288:	00001097          	auipc	ra,0x1
     28c:	c2a080e7          	jalr	-982(ra) # eb2 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     290:	f9442783          	lw	a5,-108(s0)
     294:	fa842703          	lw	a4,-88(s0)
     298:	8fd9                	or	a5,a5,a4
     29a:	2781                	sext.w	a5,a5
     29c:	ef89                	bnez	a5,2b6 <go+0x23e>
     29e:	00001597          	auipc	a1,0x1
     2a2:	3fa58593          	addi	a1,a1,1018 # 1698 <malloc+0x3a8>
     2a6:	f9040513          	addi	a0,s0,-112
     2aa:	00001097          	auipc	ra,0x1
     2ae:	998080e7          	jalr	-1640(ra) # c42 <strcmp>
     2b2:	e60508e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2b6:	f9040693          	addi	a3,s0,-112
     2ba:	fa842603          	lw	a2,-88(s0)
     2be:	f9442583          	lw	a1,-108(s0)
     2c2:	00001517          	auipc	a0,0x1
     2c6:	3de50513          	addi	a0,a0,990 # 16a0 <malloc+0x3b0>
     2ca:	00001097          	auipc	ra,0x1
     2ce:	f68080e7          	jalr	-152(ra) # 1232 <printf>
        exit(1);
     2d2:	4505                	li	a0,1
     2d4:	00001097          	auipc	ra,0x1
     2d8:	bd6080e7          	jalr	-1066(ra) # eaa <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2dc:	20200593          	li	a1,514
     2e0:	00001517          	auipc	a0,0x1
     2e4:	15050513          	addi	a0,a0,336 # 1430 <malloc+0x140>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c02080e7          	jalr	-1022(ra) # eea <open>
     2f0:	00001097          	auipc	ra,0x1
     2f4:	be2080e7          	jalr	-1054(ra) # ed2 <close>
     2f8:	b52d                	j	122 <go+0xaa>
      unlink("grindir/../a");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	12650513          	addi	a0,a0,294 # 1420 <malloc+0x130>
     302:	00001097          	auipc	ra,0x1
     306:	bf8080e7          	jalr	-1032(ra) # efa <unlink>
     30a:	bd21                	j	122 <go+0xaa>
      if(chdir("grindir") != 0){
     30c:	00001517          	auipc	a0,0x1
     310:	0d450513          	addi	a0,a0,212 # 13e0 <malloc+0xf0>
     314:	00001097          	auipc	ra,0x1
     318:	c06080e7          	jalr	-1018(ra) # f1a <chdir>
     31c:	e115                	bnez	a0,340 <go+0x2c8>
      unlink("../b");
     31e:	00001517          	auipc	a0,0x1
     322:	12a50513          	addi	a0,a0,298 # 1448 <malloc+0x158>
     326:	00001097          	auipc	ra,0x1
     32a:	bd4080e7          	jalr	-1068(ra) # efa <unlink>
      chdir("/");
     32e:	00001517          	auipc	a0,0x1
     332:	0da50513          	addi	a0,a0,218 # 1408 <malloc+0x118>
     336:	00001097          	auipc	ra,0x1
     33a:	be4080e7          	jalr	-1052(ra) # f1a <chdir>
     33e:	b3d5                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     340:	00001517          	auipc	a0,0x1
     344:	0a850513          	addi	a0,a0,168 # 13e8 <malloc+0xf8>
     348:	00001097          	auipc	ra,0x1
     34c:	eea080e7          	jalr	-278(ra) # 1232 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00001097          	auipc	ra,0x1
     356:	b58080e7          	jalr	-1192(ra) # eaa <exit>
      close(fd);
     35a:	854a                	mv	a0,s2
     35c:	00001097          	auipc	ra,0x1
     360:	b76080e7          	jalr	-1162(ra) # ed2 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     364:	20200593          	li	a1,514
     368:	00001517          	auipc	a0,0x1
     36c:	0e850513          	addi	a0,a0,232 # 1450 <malloc+0x160>
     370:	00001097          	auipc	ra,0x1
     374:	b7a080e7          	jalr	-1158(ra) # eea <open>
     378:	892a                	mv	s2,a0
     37a:	b365                	j	122 <go+0xaa>
      close(fd);
     37c:	854a                	mv	a0,s2
     37e:	00001097          	auipc	ra,0x1
     382:	b54080e7          	jalr	-1196(ra) # ed2 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     386:	20200593          	li	a1,514
     38a:	00001517          	auipc	a0,0x1
     38e:	0d650513          	addi	a0,a0,214 # 1460 <malloc+0x170>
     392:	00001097          	auipc	ra,0x1
     396:	b58080e7          	jalr	-1192(ra) # eea <open>
     39a:	892a                	mv	s2,a0
     39c:	b359                	j	122 <go+0xaa>
      write(fd, buf, sizeof(buf));
     39e:	3e700613          	li	a2,999
     3a2:	85d2                	mv	a1,s4
     3a4:	854a                	mv	a0,s2
     3a6:	00001097          	auipc	ra,0x1
     3aa:	b24080e7          	jalr	-1244(ra) # eca <write>
     3ae:	bb95                	j	122 <go+0xaa>
      read(fd, buf, sizeof(buf));
     3b0:	3e700613          	li	a2,999
     3b4:	85d2                	mv	a1,s4
     3b6:	854a                	mv	a0,s2
     3b8:	00001097          	auipc	ra,0x1
     3bc:	b0a080e7          	jalr	-1270(ra) # ec2 <read>
     3c0:	b38d                	j	122 <go+0xaa>
      mkdir("grindir/../a");
     3c2:	00001517          	auipc	a0,0x1
     3c6:	05e50513          	addi	a0,a0,94 # 1420 <malloc+0x130>
     3ca:	00001097          	auipc	ra,0x1
     3ce:	b48080e7          	jalr	-1208(ra) # f12 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3d2:	20200593          	li	a1,514
     3d6:	00001517          	auipc	a0,0x1
     3da:	0a250513          	addi	a0,a0,162 # 1478 <malloc+0x188>
     3de:	00001097          	auipc	ra,0x1
     3e2:	b0c080e7          	jalr	-1268(ra) # eea <open>
     3e6:	00001097          	auipc	ra,0x1
     3ea:	aec080e7          	jalr	-1300(ra) # ed2 <close>
      unlink("a/a");
     3ee:	00001517          	auipc	a0,0x1
     3f2:	09a50513          	addi	a0,a0,154 # 1488 <malloc+0x198>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	b04080e7          	jalr	-1276(ra) # efa <unlink>
     3fe:	b315                	j	122 <go+0xaa>
      mkdir("/../b");
     400:	00001517          	auipc	a0,0x1
     404:	09050513          	addi	a0,a0,144 # 1490 <malloc+0x1a0>
     408:	00001097          	auipc	ra,0x1
     40c:	b0a080e7          	jalr	-1270(ra) # f12 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     410:	20200593          	li	a1,514
     414:	00001517          	auipc	a0,0x1
     418:	08450513          	addi	a0,a0,132 # 1498 <malloc+0x1a8>
     41c:	00001097          	auipc	ra,0x1
     420:	ace080e7          	jalr	-1330(ra) # eea <open>
     424:	00001097          	auipc	ra,0x1
     428:	aae080e7          	jalr	-1362(ra) # ed2 <close>
      unlink("b/b");
     42c:	00001517          	auipc	a0,0x1
     430:	07c50513          	addi	a0,a0,124 # 14a8 <malloc+0x1b8>
     434:	00001097          	auipc	ra,0x1
     438:	ac6080e7          	jalr	-1338(ra) # efa <unlink>
     43c:	b1dd                	j	122 <go+0xaa>
      unlink("b");
     43e:	00001517          	auipc	a0,0x1
     442:	03250513          	addi	a0,a0,50 # 1470 <malloc+0x180>
     446:	00001097          	auipc	ra,0x1
     44a:	ab4080e7          	jalr	-1356(ra) # efa <unlink>
      link("../grindir/./../a", "../b");
     44e:	00001597          	auipc	a1,0x1
     452:	ffa58593          	addi	a1,a1,-6 # 1448 <malloc+0x158>
     456:	00001517          	auipc	a0,0x1
     45a:	05a50513          	addi	a0,a0,90 # 14b0 <malloc+0x1c0>
     45e:	00001097          	auipc	ra,0x1
     462:	aac080e7          	jalr	-1364(ra) # f0a <link>
     466:	b975                	j	122 <go+0xaa>
      unlink("../grindir/../a");
     468:	00001517          	auipc	a0,0x1
     46c:	06050513          	addi	a0,a0,96 # 14c8 <malloc+0x1d8>
     470:	00001097          	auipc	ra,0x1
     474:	a8a080e7          	jalr	-1398(ra) # efa <unlink>
      link(".././b", "/grindir/../a");
     478:	00001597          	auipc	a1,0x1
     47c:	fd858593          	addi	a1,a1,-40 # 1450 <malloc+0x160>
     480:	00001517          	auipc	a0,0x1
     484:	05850513          	addi	a0,a0,88 # 14d8 <malloc+0x1e8>
     488:	00001097          	auipc	ra,0x1
     48c:	a82080e7          	jalr	-1406(ra) # f0a <link>
     490:	b949                	j	122 <go+0xaa>
      int pid = fork();
     492:	00001097          	auipc	ra,0x1
     496:	a10080e7          	jalr	-1520(ra) # ea2 <fork>
      if(pid == 0){
     49a:	c909                	beqz	a0,4ac <go+0x434>
      } else if(pid < 0){
     49c:	00054c63          	bltz	a0,4b4 <go+0x43c>
      wait(0);
     4a0:	4501                	li	a0,0
     4a2:	00001097          	auipc	ra,0x1
     4a6:	a10080e7          	jalr	-1520(ra) # eb2 <wait>
     4aa:	b9a5                	j	122 <go+0xaa>
        exit(0);
     4ac:	00001097          	auipc	ra,0x1
     4b0:	9fe080e7          	jalr	-1538(ra) # eaa <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	02c50513          	addi	a0,a0,44 # 14e0 <malloc+0x1f0>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d76080e7          	jalr	-650(ra) # 1232 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	9e4080e7          	jalr	-1564(ra) # eaa <exit>
      int pid = fork();
     4ce:	00001097          	auipc	ra,0x1
     4d2:	9d4080e7          	jalr	-1580(ra) # ea2 <fork>
      if(pid == 0){
     4d6:	c909                	beqz	a0,4e8 <go+0x470>
      } else if(pid < 0){
     4d8:	02054563          	bltz	a0,502 <go+0x48a>
      wait(0);
     4dc:	4501                	li	a0,0
     4de:	00001097          	auipc	ra,0x1
     4e2:	9d4080e7          	jalr	-1580(ra) # eb2 <wait>
     4e6:	b935                	j	122 <go+0xaa>
        fork();
     4e8:	00001097          	auipc	ra,0x1
     4ec:	9ba080e7          	jalr	-1606(ra) # ea2 <fork>
        fork();
     4f0:	00001097          	auipc	ra,0x1
     4f4:	9b2080e7          	jalr	-1614(ra) # ea2 <fork>
        exit(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	9b0080e7          	jalr	-1616(ra) # eaa <exit>
        printf("grind: fork failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	fde50513          	addi	a0,a0,-34 # 14e0 <malloc+0x1f0>
     50a:	00001097          	auipc	ra,0x1
     50e:	d28080e7          	jalr	-728(ra) # 1232 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	996080e7          	jalr	-1642(ra) # eaa <exit>
      sbrk(6011);
     51c:	6505                	lui	a0,0x1
     51e:	77b50513          	addi	a0,a0,1915 # 177b <digits+0xab>
     522:	00001097          	auipc	ra,0x1
     526:	a10080e7          	jalr	-1520(ra) # f32 <sbrk>
     52a:	bee5                	j	122 <go+0xaa>
      if(sbrk(0) > break0)
     52c:	4501                	li	a0,0
     52e:	00001097          	auipc	ra,0x1
     532:	a04080e7          	jalr	-1532(ra) # f32 <sbrk>
     536:	beaaf6e3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     53a:	4501                	li	a0,0
     53c:	00001097          	auipc	ra,0x1
     540:	9f6080e7          	jalr	-1546(ra) # f32 <sbrk>
     544:	40aa853b          	subw	a0,s5,a0
     548:	00001097          	auipc	ra,0x1
     54c:	9ea080e7          	jalr	-1558(ra) # f32 <sbrk>
     550:	bec9                	j	122 <go+0xaa>
      int pid = fork();
     552:	00001097          	auipc	ra,0x1
     556:	950080e7          	jalr	-1712(ra) # ea2 <fork>
     55a:	8b2a                	mv	s6,a0
      if(pid == 0){
     55c:	c51d                	beqz	a0,58a <go+0x512>
      } else if(pid < 0){
     55e:	04054963          	bltz	a0,5b0 <go+0x538>
      if(chdir("../grindir/..") != 0){
     562:	00001517          	auipc	a0,0x1
     566:	f9650513          	addi	a0,a0,-106 # 14f8 <malloc+0x208>
     56a:	00001097          	auipc	ra,0x1
     56e:	9b0080e7          	jalr	-1616(ra) # f1a <chdir>
     572:	ed21                	bnez	a0,5ca <go+0x552>
      kill(pid);
     574:	855a                	mv	a0,s6
     576:	00001097          	auipc	ra,0x1
     57a:	964080e7          	jalr	-1692(ra) # eda <kill>
      wait(0);
     57e:	4501                	li	a0,0
     580:	00001097          	auipc	ra,0x1
     584:	932080e7          	jalr	-1742(ra) # eb2 <wait>
     588:	be69                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     58a:	20200593          	li	a1,514
     58e:	00001517          	auipc	a0,0x1
     592:	f3250513          	addi	a0,a0,-206 # 14c0 <malloc+0x1d0>
     596:	00001097          	auipc	ra,0x1
     59a:	954080e7          	jalr	-1708(ra) # eea <open>
     59e:	00001097          	auipc	ra,0x1
     5a2:	934080e7          	jalr	-1740(ra) # ed2 <close>
        exit(0);
     5a6:	4501                	li	a0,0
     5a8:	00001097          	auipc	ra,0x1
     5ac:	902080e7          	jalr	-1790(ra) # eaa <exit>
        printf("grind: fork failed\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	f3050513          	addi	a0,a0,-208 # 14e0 <malloc+0x1f0>
     5b8:	00001097          	auipc	ra,0x1
     5bc:	c7a080e7          	jalr	-902(ra) # 1232 <printf>
        exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00001097          	auipc	ra,0x1
     5c6:	8e8080e7          	jalr	-1816(ra) # eaa <exit>
        printf("grind: chdir failed\n");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	f3e50513          	addi	a0,a0,-194 # 1508 <malloc+0x218>
     5d2:	00001097          	auipc	ra,0x1
     5d6:	c60080e7          	jalr	-928(ra) # 1232 <printf>
        exit(1);
     5da:	4505                	li	a0,1
     5dc:	00001097          	auipc	ra,0x1
     5e0:	8ce080e7          	jalr	-1842(ra) # eaa <exit>
      int pid = fork();
     5e4:	00001097          	auipc	ra,0x1
     5e8:	8be080e7          	jalr	-1858(ra) # ea2 <fork>
      if(pid == 0){
     5ec:	c909                	beqz	a0,5fe <go+0x586>
      } else if(pid < 0){
     5ee:	02054563          	bltz	a0,618 <go+0x5a0>
      wait(0);
     5f2:	4501                	li	a0,0
     5f4:	00001097          	auipc	ra,0x1
     5f8:	8be080e7          	jalr	-1858(ra) # eb2 <wait>
     5fc:	b61d                	j	122 <go+0xaa>
        kill(getpid());
     5fe:	00001097          	auipc	ra,0x1
     602:	92c080e7          	jalr	-1748(ra) # f2a <getpid>
     606:	00001097          	auipc	ra,0x1
     60a:	8d4080e7          	jalr	-1836(ra) # eda <kill>
        exit(0);
     60e:	4501                	li	a0,0
     610:	00001097          	auipc	ra,0x1
     614:	89a080e7          	jalr	-1894(ra) # eaa <exit>
        printf("grind: fork failed\n");
     618:	00001517          	auipc	a0,0x1
     61c:	ec850513          	addi	a0,a0,-312 # 14e0 <malloc+0x1f0>
     620:	00001097          	auipc	ra,0x1
     624:	c12080e7          	jalr	-1006(ra) # 1232 <printf>
        exit(1);
     628:	4505                	li	a0,1
     62a:	00001097          	auipc	ra,0x1
     62e:	880080e7          	jalr	-1920(ra) # eaa <exit>
      if(pipe(fds) < 0){
     632:	fa840513          	addi	a0,s0,-88
     636:	00001097          	auipc	ra,0x1
     63a:	884080e7          	jalr	-1916(ra) # eba <pipe>
     63e:	02054b63          	bltz	a0,674 <go+0x5fc>
      int pid = fork();
     642:	00001097          	auipc	ra,0x1
     646:	860080e7          	jalr	-1952(ra) # ea2 <fork>
      if(pid == 0){
     64a:	c131                	beqz	a0,68e <go+0x616>
      } else if(pid < 0){
     64c:	0a054a63          	bltz	a0,700 <go+0x688>
      close(fds[0]);
     650:	fa842503          	lw	a0,-88(s0)
     654:	00001097          	auipc	ra,0x1
     658:	87e080e7          	jalr	-1922(ra) # ed2 <close>
      close(fds[1]);
     65c:	fac42503          	lw	a0,-84(s0)
     660:	00001097          	auipc	ra,0x1
     664:	872080e7          	jalr	-1934(ra) # ed2 <close>
      wait(0);
     668:	4501                	li	a0,0
     66a:	00001097          	auipc	ra,0x1
     66e:	848080e7          	jalr	-1976(ra) # eb2 <wait>
     672:	bc45                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     674:	00001517          	auipc	a0,0x1
     678:	eac50513          	addi	a0,a0,-340 # 1520 <malloc+0x230>
     67c:	00001097          	auipc	ra,0x1
     680:	bb6080e7          	jalr	-1098(ra) # 1232 <printf>
        exit(1);
     684:	4505                	li	a0,1
     686:	00001097          	auipc	ra,0x1
     68a:	824080e7          	jalr	-2012(ra) # eaa <exit>
        fork();
     68e:	00001097          	auipc	ra,0x1
     692:	814080e7          	jalr	-2028(ra) # ea2 <fork>
        fork();
     696:	00001097          	auipc	ra,0x1
     69a:	80c080e7          	jalr	-2036(ra) # ea2 <fork>
        if(write(fds[1], "x", 1) != 1)
     69e:	4605                	li	a2,1
     6a0:	00001597          	auipc	a1,0x1
     6a4:	e9858593          	addi	a1,a1,-360 # 1538 <malloc+0x248>
     6a8:	fac42503          	lw	a0,-84(s0)
     6ac:	00001097          	auipc	ra,0x1
     6b0:	81e080e7          	jalr	-2018(ra) # eca <write>
     6b4:	4785                	li	a5,1
     6b6:	02f51363          	bne	a0,a5,6dc <go+0x664>
        if(read(fds[0], &c, 1) != 1)
     6ba:	4605                	li	a2,1
     6bc:	fa040593          	addi	a1,s0,-96
     6c0:	fa842503          	lw	a0,-88(s0)
     6c4:	00000097          	auipc	ra,0x0
     6c8:	7fe080e7          	jalr	2046(ra) # ec2 <read>
     6cc:	4785                	li	a5,1
     6ce:	02f51063          	bne	a0,a5,6ee <go+0x676>
        exit(0);
     6d2:	4501                	li	a0,0
     6d4:	00000097          	auipc	ra,0x0
     6d8:	7d6080e7          	jalr	2006(ra) # eaa <exit>
          printf("grind: pipe write failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	e6450513          	addi	a0,a0,-412 # 1540 <malloc+0x250>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	b4e080e7          	jalr	-1202(ra) # 1232 <printf>
     6ec:	b7f9                	j	6ba <go+0x642>
          printf("grind: pipe read failed\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	e7250513          	addi	a0,a0,-398 # 1560 <malloc+0x270>
     6f6:	00001097          	auipc	ra,0x1
     6fa:	b3c080e7          	jalr	-1220(ra) # 1232 <printf>
     6fe:	bfd1                	j	6d2 <go+0x65a>
        printf("grind: fork failed\n");
     700:	00001517          	auipc	a0,0x1
     704:	de050513          	addi	a0,a0,-544 # 14e0 <malloc+0x1f0>
     708:	00001097          	auipc	ra,0x1
     70c:	b2a080e7          	jalr	-1238(ra) # 1232 <printf>
        exit(1);
     710:	4505                	li	a0,1
     712:	00000097          	auipc	ra,0x0
     716:	798080e7          	jalr	1944(ra) # eaa <exit>
      int pid = fork();
     71a:	00000097          	auipc	ra,0x0
     71e:	788080e7          	jalr	1928(ra) # ea2 <fork>
      if(pid == 0){
     722:	c909                	beqz	a0,734 <go+0x6bc>
      } else if(pid < 0){
     724:	06054f63          	bltz	a0,7a2 <go+0x72a>
      wait(0);
     728:	4501                	li	a0,0
     72a:	00000097          	auipc	ra,0x0
     72e:	788080e7          	jalr	1928(ra) # eb2 <wait>
     732:	bac5                	j	122 <go+0xaa>
        unlink("a");
     734:	00001517          	auipc	a0,0x1
     738:	d8c50513          	addi	a0,a0,-628 # 14c0 <malloc+0x1d0>
     73c:	00000097          	auipc	ra,0x0
     740:	7be080e7          	jalr	1982(ra) # efa <unlink>
        mkdir("a");
     744:	00001517          	auipc	a0,0x1
     748:	d7c50513          	addi	a0,a0,-644 # 14c0 <malloc+0x1d0>
     74c:	00000097          	auipc	ra,0x0
     750:	7c6080e7          	jalr	1990(ra) # f12 <mkdir>
        chdir("a");
     754:	00001517          	auipc	a0,0x1
     758:	d6c50513          	addi	a0,a0,-660 # 14c0 <malloc+0x1d0>
     75c:	00000097          	auipc	ra,0x0
     760:	7be080e7          	jalr	1982(ra) # f1a <chdir>
        unlink("../a");
     764:	00001517          	auipc	a0,0x1
     768:	cc450513          	addi	a0,a0,-828 # 1428 <malloc+0x138>
     76c:	00000097          	auipc	ra,0x0
     770:	78e080e7          	jalr	1934(ra) # efa <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     774:	20200593          	li	a1,514
     778:	00001517          	auipc	a0,0x1
     77c:	dc050513          	addi	a0,a0,-576 # 1538 <malloc+0x248>
     780:	00000097          	auipc	ra,0x0
     784:	76a080e7          	jalr	1898(ra) # eea <open>
        unlink("x");
     788:	00001517          	auipc	a0,0x1
     78c:	db050513          	addi	a0,a0,-592 # 1538 <malloc+0x248>
     790:	00000097          	auipc	ra,0x0
     794:	76a080e7          	jalr	1898(ra) # efa <unlink>
        exit(0);
     798:	4501                	li	a0,0
     79a:	00000097          	auipc	ra,0x0
     79e:	710080e7          	jalr	1808(ra) # eaa <exit>
        printf("grind: fork failed\n");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	d3e50513          	addi	a0,a0,-706 # 14e0 <malloc+0x1f0>
     7aa:	00001097          	auipc	ra,0x1
     7ae:	a88080e7          	jalr	-1400(ra) # 1232 <printf>
        exit(1);
     7b2:	4505                	li	a0,1
     7b4:	00000097          	auipc	ra,0x0
     7b8:	6f6080e7          	jalr	1782(ra) # eaa <exit>
      unlink("c");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	dc450513          	addi	a0,a0,-572 # 1580 <malloc+0x290>
     7c4:	00000097          	auipc	ra,0x0
     7c8:	736080e7          	jalr	1846(ra) # efa <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7cc:	20200593          	li	a1,514
     7d0:	00001517          	auipc	a0,0x1
     7d4:	db050513          	addi	a0,a0,-592 # 1580 <malloc+0x290>
     7d8:	00000097          	auipc	ra,0x0
     7dc:	712080e7          	jalr	1810(ra) # eea <open>
     7e0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7e2:	04054f63          	bltz	a0,840 <go+0x7c8>
      if(write(fd1, "x", 1) != 1){
     7e6:	4605                	li	a2,1
     7e8:	00001597          	auipc	a1,0x1
     7ec:	d5058593          	addi	a1,a1,-688 # 1538 <malloc+0x248>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	6da080e7          	jalr	1754(ra) # eca <write>
     7f8:	4785                	li	a5,1
     7fa:	06f51063          	bne	a0,a5,85a <go+0x7e2>
      if(fstat(fd1, &st) != 0){
     7fe:	fa840593          	addi	a1,s0,-88
     802:	855a                	mv	a0,s6
     804:	00000097          	auipc	ra,0x0
     808:	6fe080e7          	jalr	1790(ra) # f02 <fstat>
     80c:	e525                	bnez	a0,874 <go+0x7fc>
      if(st.size != 1){
     80e:	fb843583          	ld	a1,-72(s0)
     812:	4785                	li	a5,1
     814:	06f59d63          	bne	a1,a5,88e <go+0x816>
      if(st.ino > 200){
     818:	fac42583          	lw	a1,-84(s0)
     81c:	0c800793          	li	a5,200
     820:	08b7e563          	bltu	a5,a1,8aa <go+0x832>
      close(fd1);
     824:	855a                	mv	a0,s6
     826:	00000097          	auipc	ra,0x0
     82a:	6ac080e7          	jalr	1708(ra) # ed2 <close>
      unlink("c");
     82e:	00001517          	auipc	a0,0x1
     832:	d5250513          	addi	a0,a0,-686 # 1580 <malloc+0x290>
     836:	00000097          	auipc	ra,0x0
     83a:	6c4080e7          	jalr	1732(ra) # efa <unlink>
     83e:	b0d5                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     840:	00001517          	auipc	a0,0x1
     844:	d4850513          	addi	a0,a0,-696 # 1588 <malloc+0x298>
     848:	00001097          	auipc	ra,0x1
     84c:	9ea080e7          	jalr	-1558(ra) # 1232 <printf>
        exit(1);
     850:	4505                	li	a0,1
     852:	00000097          	auipc	ra,0x0
     856:	658080e7          	jalr	1624(ra) # eaa <exit>
        printf("grind: write c failed\n");
     85a:	00001517          	auipc	a0,0x1
     85e:	d4650513          	addi	a0,a0,-698 # 15a0 <malloc+0x2b0>
     862:	00001097          	auipc	ra,0x1
     866:	9d0080e7          	jalr	-1584(ra) # 1232 <printf>
        exit(1);
     86a:	4505                	li	a0,1
     86c:	00000097          	auipc	ra,0x0
     870:	63e080e7          	jalr	1598(ra) # eaa <exit>
        printf("grind: fstat failed\n");
     874:	00001517          	auipc	a0,0x1
     878:	d4450513          	addi	a0,a0,-700 # 15b8 <malloc+0x2c8>
     87c:	00001097          	auipc	ra,0x1
     880:	9b6080e7          	jalr	-1610(ra) # 1232 <printf>
        exit(1);
     884:	4505                	li	a0,1
     886:	00000097          	auipc	ra,0x0
     88a:	624080e7          	jalr	1572(ra) # eaa <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     88e:	2581                	sext.w	a1,a1
     890:	00001517          	auipc	a0,0x1
     894:	d4050513          	addi	a0,a0,-704 # 15d0 <malloc+0x2e0>
     898:	00001097          	auipc	ra,0x1
     89c:	99a080e7          	jalr	-1638(ra) # 1232 <printf>
        exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00000097          	auipc	ra,0x0
     8a6:	608080e7          	jalr	1544(ra) # eaa <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     8aa:	00001517          	auipc	a0,0x1
     8ae:	d4e50513          	addi	a0,a0,-690 # 15f8 <malloc+0x308>
     8b2:	00001097          	auipc	ra,0x1
     8b6:	980080e7          	jalr	-1664(ra) # 1232 <printf>
        exit(1);
     8ba:	4505                	li	a0,1
     8bc:	00000097          	auipc	ra,0x0
     8c0:	5ee080e7          	jalr	1518(ra) # eaa <exit>
        fprintf(2, "grind: pipe failed\n");
     8c4:	00001597          	auipc	a1,0x1
     8c8:	c5c58593          	addi	a1,a1,-932 # 1520 <malloc+0x230>
     8cc:	4509                	li	a0,2
     8ce:	00001097          	auipc	ra,0x1
     8d2:	936080e7          	jalr	-1738(ra) # 1204 <fprintf>
        exit(1);
     8d6:	4505                	li	a0,1
     8d8:	00000097          	auipc	ra,0x0
     8dc:	5d2080e7          	jalr	1490(ra) # eaa <exit>
        fprintf(2, "grind: pipe failed\n");
     8e0:	00001597          	auipc	a1,0x1
     8e4:	c4058593          	addi	a1,a1,-960 # 1520 <malloc+0x230>
     8e8:	4509                	li	a0,2
     8ea:	00001097          	auipc	ra,0x1
     8ee:	91a080e7          	jalr	-1766(ra) # 1204 <fprintf>
        exit(1);
     8f2:	4505                	li	a0,1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	5b6080e7          	jalr	1462(ra) # eaa <exit>
        close(bb[0]);
     8fc:	fa042503          	lw	a0,-96(s0)
     900:	00000097          	auipc	ra,0x0
     904:	5d2080e7          	jalr	1490(ra) # ed2 <close>
        close(bb[1]);
     908:	fa442503          	lw	a0,-92(s0)
     90c:	00000097          	auipc	ra,0x0
     910:	5c6080e7          	jalr	1478(ra) # ed2 <close>
        close(aa[0]);
     914:	f9842503          	lw	a0,-104(s0)
     918:	00000097          	auipc	ra,0x0
     91c:	5ba080e7          	jalr	1466(ra) # ed2 <close>
        close(1);
     920:	4505                	li	a0,1
     922:	00000097          	auipc	ra,0x0
     926:	5b0080e7          	jalr	1456(ra) # ed2 <close>
        if(dup(aa[1]) != 1){
     92a:	f9c42503          	lw	a0,-100(s0)
     92e:	00000097          	auipc	ra,0x0
     932:	5f4080e7          	jalr	1524(ra) # f22 <dup>
     936:	4785                	li	a5,1
     938:	02f50063          	beq	a0,a5,958 <go+0x8e0>
          fprintf(2, "grind: dup failed\n");
     93c:	00001597          	auipc	a1,0x1
     940:	ce458593          	addi	a1,a1,-796 # 1620 <malloc+0x330>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	8be080e7          	jalr	-1858(ra) # 1204 <fprintf>
          exit(1);
     94e:	4505                	li	a0,1
     950:	00000097          	auipc	ra,0x0
     954:	55a080e7          	jalr	1370(ra) # eaa <exit>
        close(aa[1]);
     958:	f9c42503          	lw	a0,-100(s0)
     95c:	00000097          	auipc	ra,0x0
     960:	576080e7          	jalr	1398(ra) # ed2 <close>
        char *args[3] = { "echo", "hi", 0 };
     964:	00001797          	auipc	a5,0x1
     968:	cd478793          	addi	a5,a5,-812 # 1638 <malloc+0x348>
     96c:	faf43423          	sd	a5,-88(s0)
     970:	00001797          	auipc	a5,0x1
     974:	cd078793          	addi	a5,a5,-816 # 1640 <malloc+0x350>
     978:	faf43823          	sd	a5,-80(s0)
     97c:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     980:	fa840593          	addi	a1,s0,-88
     984:	00001517          	auipc	a0,0x1
     988:	cc450513          	addi	a0,a0,-828 # 1648 <malloc+0x358>
     98c:	00000097          	auipc	ra,0x0
     990:	556080e7          	jalr	1366(ra) # ee2 <exec>
        fprintf(2, "grind: echo: not found\n");
     994:	00001597          	auipc	a1,0x1
     998:	cc458593          	addi	a1,a1,-828 # 1658 <malloc+0x368>
     99c:	4509                	li	a0,2
     99e:	00001097          	auipc	ra,0x1
     9a2:	866080e7          	jalr	-1946(ra) # 1204 <fprintf>
        exit(2);
     9a6:	4509                	li	a0,2
     9a8:	00000097          	auipc	ra,0x0
     9ac:	502080e7          	jalr	1282(ra) # eaa <exit>
        fprintf(2, "grind: fork failed\n");
     9b0:	00001597          	auipc	a1,0x1
     9b4:	b3058593          	addi	a1,a1,-1232 # 14e0 <malloc+0x1f0>
     9b8:	4509                	li	a0,2
     9ba:	00001097          	auipc	ra,0x1
     9be:	84a080e7          	jalr	-1974(ra) # 1204 <fprintf>
        exit(3);
     9c2:	450d                	li	a0,3
     9c4:	00000097          	auipc	ra,0x0
     9c8:	4e6080e7          	jalr	1254(ra) # eaa <exit>
        close(aa[1]);
     9cc:	f9c42503          	lw	a0,-100(s0)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	502080e7          	jalr	1282(ra) # ed2 <close>
        close(bb[0]);
     9d8:	fa042503          	lw	a0,-96(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	4f6080e7          	jalr	1270(ra) # ed2 <close>
        close(0);
     9e4:	4501                	li	a0,0
     9e6:	00000097          	auipc	ra,0x0
     9ea:	4ec080e7          	jalr	1260(ra) # ed2 <close>
        if(dup(aa[0]) != 0){
     9ee:	f9842503          	lw	a0,-104(s0)
     9f2:	00000097          	auipc	ra,0x0
     9f6:	530080e7          	jalr	1328(ra) # f22 <dup>
     9fa:	cd19                	beqz	a0,a18 <go+0x9a0>
          fprintf(2, "grind: dup failed\n");
     9fc:	00001597          	auipc	a1,0x1
     a00:	c2458593          	addi	a1,a1,-988 # 1620 <malloc+0x330>
     a04:	4509                	li	a0,2
     a06:	00000097          	auipc	ra,0x0
     a0a:	7fe080e7          	jalr	2046(ra) # 1204 <fprintf>
          exit(4);
     a0e:	4511                	li	a0,4
     a10:	00000097          	auipc	ra,0x0
     a14:	49a080e7          	jalr	1178(ra) # eaa <exit>
        close(aa[0]);
     a18:	f9842503          	lw	a0,-104(s0)
     a1c:	00000097          	auipc	ra,0x0
     a20:	4b6080e7          	jalr	1206(ra) # ed2 <close>
        close(1);
     a24:	4505                	li	a0,1
     a26:	00000097          	auipc	ra,0x0
     a2a:	4ac080e7          	jalr	1196(ra) # ed2 <close>
        if(dup(bb[1]) != 1){
     a2e:	fa442503          	lw	a0,-92(s0)
     a32:	00000097          	auipc	ra,0x0
     a36:	4f0080e7          	jalr	1264(ra) # f22 <dup>
     a3a:	4785                	li	a5,1
     a3c:	02f50063          	beq	a0,a5,a5c <go+0x9e4>
          fprintf(2, "grind: dup failed\n");
     a40:	00001597          	auipc	a1,0x1
     a44:	be058593          	addi	a1,a1,-1056 # 1620 <malloc+0x330>
     a48:	4509                	li	a0,2
     a4a:	00000097          	auipc	ra,0x0
     a4e:	7ba080e7          	jalr	1978(ra) # 1204 <fprintf>
          exit(5);
     a52:	4515                	li	a0,5
     a54:	00000097          	auipc	ra,0x0
     a58:	456080e7          	jalr	1110(ra) # eaa <exit>
        close(bb[1]);
     a5c:	fa442503          	lw	a0,-92(s0)
     a60:	00000097          	auipc	ra,0x0
     a64:	472080e7          	jalr	1138(ra) # ed2 <close>
        char *args[2] = { "cat", 0 };
     a68:	00001797          	auipc	a5,0x1
     a6c:	c0878793          	addi	a5,a5,-1016 # 1670 <malloc+0x380>
     a70:	faf43423          	sd	a5,-88(s0)
     a74:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a78:	fa840593          	addi	a1,s0,-88
     a7c:	00001517          	auipc	a0,0x1
     a80:	bfc50513          	addi	a0,a0,-1028 # 1678 <malloc+0x388>
     a84:	00000097          	auipc	ra,0x0
     a88:	45e080e7          	jalr	1118(ra) # ee2 <exec>
        fprintf(2, "grind: cat: not found\n");
     a8c:	00001597          	auipc	a1,0x1
     a90:	bf458593          	addi	a1,a1,-1036 # 1680 <malloc+0x390>
     a94:	4509                	li	a0,2
     a96:	00000097          	auipc	ra,0x0
     a9a:	76e080e7          	jalr	1902(ra) # 1204 <fprintf>
        exit(6);
     a9e:	4519                	li	a0,6
     aa0:	00000097          	auipc	ra,0x0
     aa4:	40a080e7          	jalr	1034(ra) # eaa <exit>
        fprintf(2, "grind: fork failed\n");
     aa8:	00001597          	auipc	a1,0x1
     aac:	a3858593          	addi	a1,a1,-1480 # 14e0 <malloc+0x1f0>
     ab0:	4509                	li	a0,2
     ab2:	00000097          	auipc	ra,0x0
     ab6:	752080e7          	jalr	1874(ra) # 1204 <fprintf>
        exit(7);
     aba:	451d                	li	a0,7
     abc:	00000097          	auipc	ra,0x0
     ac0:	3ee080e7          	jalr	1006(ra) # eaa <exit>

0000000000000ac4 <iter>:
  }
}

void
iter()
{
     ac4:	7179                	addi	sp,sp,-48
     ac6:	f406                	sd	ra,40(sp)
     ac8:	f022                	sd	s0,32(sp)
     aca:	ec26                	sd	s1,24(sp)
     acc:	e84a                	sd	s2,16(sp)
     ace:	1800                	addi	s0,sp,48
  unlink("a");
     ad0:	00001517          	auipc	a0,0x1
     ad4:	9f050513          	addi	a0,a0,-1552 # 14c0 <malloc+0x1d0>
     ad8:	00000097          	auipc	ra,0x0
     adc:	422080e7          	jalr	1058(ra) # efa <unlink>
  unlink("b");
     ae0:	00001517          	auipc	a0,0x1
     ae4:	99050513          	addi	a0,a0,-1648 # 1470 <malloc+0x180>
     ae8:	00000097          	auipc	ra,0x0
     aec:	412080e7          	jalr	1042(ra) # efa <unlink>
  
  int pid1 = fork();
     af0:	00000097          	auipc	ra,0x0
     af4:	3b2080e7          	jalr	946(ra) # ea2 <fork>
  if(pid1 < 0){
     af8:	02054163          	bltz	a0,b1a <iter+0x56>
     afc:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     afe:	e91d                	bnez	a0,b34 <iter+0x70>
    rand_next ^= 31;
     b00:	00001717          	auipc	a4,0x1
     b04:	50070713          	addi	a4,a4,1280 # 2000 <rand_next>
     b08:	631c                	ld	a5,0(a4)
     b0a:	01f7c793          	xori	a5,a5,31
     b0e:	e31c                	sd	a5,0(a4)
    go(0);
     b10:	4501                	li	a0,0
     b12:	fffff097          	auipc	ra,0xfffff
     b16:	566080e7          	jalr	1382(ra) # 78 <go>
    printf("grind: fork failed\n");
     b1a:	00001517          	auipc	a0,0x1
     b1e:	9c650513          	addi	a0,a0,-1594 # 14e0 <malloc+0x1f0>
     b22:	00000097          	auipc	ra,0x0
     b26:	710080e7          	jalr	1808(ra) # 1232 <printf>
    exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00000097          	auipc	ra,0x0
     b30:	37e080e7          	jalr	894(ra) # eaa <exit>
    exit(0);
  }

  int pid2 = fork();
     b34:	00000097          	auipc	ra,0x0
     b38:	36e080e7          	jalr	878(ra) # ea2 <fork>
     b3c:	892a                	mv	s2,a0
  if(pid2 < 0){
     b3e:	02054263          	bltz	a0,b62 <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b42:	ed0d                	bnez	a0,b7c <iter+0xb8>
    rand_next ^= 7177;
     b44:	00001697          	auipc	a3,0x1
     b48:	4bc68693          	addi	a3,a3,1212 # 2000 <rand_next>
     b4c:	629c                	ld	a5,0(a3)
     b4e:	6709                	lui	a4,0x2
     b50:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x539>
     b54:	8fb9                	xor	a5,a5,a4
     b56:	e29c                	sd	a5,0(a3)
    go(1);
     b58:	4505                	li	a0,1
     b5a:	fffff097          	auipc	ra,0xfffff
     b5e:	51e080e7          	jalr	1310(ra) # 78 <go>
    printf("grind: fork failed\n");
     b62:	00001517          	auipc	a0,0x1
     b66:	97e50513          	addi	a0,a0,-1666 # 14e0 <malloc+0x1f0>
     b6a:	00000097          	auipc	ra,0x0
     b6e:	6c8080e7          	jalr	1736(ra) # 1232 <printf>
    exit(1);
     b72:	4505                	li	a0,1
     b74:	00000097          	auipc	ra,0x0
     b78:	336080e7          	jalr	822(ra) # eaa <exit>
    exit(0);
  }

  int st1 = -1;
     b7c:	57fd                	li	a5,-1
     b7e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b82:	fdc40513          	addi	a0,s0,-36
     b86:	00000097          	auipc	ra,0x0
     b8a:	32c080e7          	jalr	812(ra) # eb2 <wait>
  if(st1 != 0){
     b8e:	fdc42783          	lw	a5,-36(s0)
     b92:	ef99                	bnez	a5,bb0 <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b94:	57fd                	li	a5,-1
     b96:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b9a:	fd840513          	addi	a0,s0,-40
     b9e:	00000097          	auipc	ra,0x0
     ba2:	314080e7          	jalr	788(ra) # eb2 <wait>

  exit(0);
     ba6:	4501                	li	a0,0
     ba8:	00000097          	auipc	ra,0x0
     bac:	302080e7          	jalr	770(ra) # eaa <exit>
    kill(pid1);
     bb0:	8526                	mv	a0,s1
     bb2:	00000097          	auipc	ra,0x0
     bb6:	328080e7          	jalr	808(ra) # eda <kill>
    kill(pid2);
     bba:	854a                	mv	a0,s2
     bbc:	00000097          	auipc	ra,0x0
     bc0:	31e080e7          	jalr	798(ra) # eda <kill>
     bc4:	bfc1                	j	b94 <iter+0xd0>

0000000000000bc6 <main>:
}

int
main()
{
     bc6:	1101                	addi	sp,sp,-32
     bc8:	ec06                	sd	ra,24(sp)
     bca:	e822                	sd	s0,16(sp)
     bcc:	e426                	sd	s1,8(sp)
     bce:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     bd0:	00001497          	auipc	s1,0x1
     bd4:	43048493          	addi	s1,s1,1072 # 2000 <rand_next>
     bd8:	a829                	j	bf2 <main+0x2c>
      iter();
     bda:	00000097          	auipc	ra,0x0
     bde:	eea080e7          	jalr	-278(ra) # ac4 <iter>
    sleep(20);
     be2:	4551                	li	a0,20
     be4:	00000097          	auipc	ra,0x0
     be8:	356080e7          	jalr	854(ra) # f3a <sleep>
    rand_next += 1;
     bec:	609c                	ld	a5,0(s1)
     bee:	0785                	addi	a5,a5,1
     bf0:	e09c                	sd	a5,0(s1)
    int pid = fork();
     bf2:	00000097          	auipc	ra,0x0
     bf6:	2b0080e7          	jalr	688(ra) # ea2 <fork>
    if(pid == 0){
     bfa:	d165                	beqz	a0,bda <main+0x14>
    if(pid > 0){
     bfc:	fea053e3          	blez	a0,be2 <main+0x1c>
      wait(0);
     c00:	4501                	li	a0,0
     c02:	00000097          	auipc	ra,0x0
     c06:	2b0080e7          	jalr	688(ra) # eb2 <wait>
     c0a:	bfe1                	j	be2 <main+0x1c>

0000000000000c0c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c0c:	1141                	addi	sp,sp,-16
     c0e:	e406                	sd	ra,8(sp)
     c10:	e022                	sd	s0,0(sp)
     c12:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c14:	00000097          	auipc	ra,0x0
     c18:	fb2080e7          	jalr	-78(ra) # bc6 <main>
  exit(0);
     c1c:	4501                	li	a0,0
     c1e:	00000097          	auipc	ra,0x0
     c22:	28c080e7          	jalr	652(ra) # eaa <exit>

0000000000000c26 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c26:	1141                	addi	sp,sp,-16
     c28:	e422                	sd	s0,8(sp)
     c2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c2c:	87aa                	mv	a5,a0
     c2e:	0585                	addi	a1,a1,1
     c30:	0785                	addi	a5,a5,1
     c32:	fff5c703          	lbu	a4,-1(a1)
     c36:	fee78fa3          	sb	a4,-1(a5)
     c3a:	fb75                	bnez	a4,c2e <strcpy+0x8>
    ;
  return os;
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	addi	sp,sp,16
     c40:	8082                	ret

0000000000000c42 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c42:	1141                	addi	sp,sp,-16
     c44:	e422                	sd	s0,8(sp)
     c46:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c48:	00054783          	lbu	a5,0(a0)
     c4c:	cb91                	beqz	a5,c60 <strcmp+0x1e>
     c4e:	0005c703          	lbu	a4,0(a1)
     c52:	00f71763          	bne	a4,a5,c60 <strcmp+0x1e>
    p++, q++;
     c56:	0505                	addi	a0,a0,1
     c58:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c5a:	00054783          	lbu	a5,0(a0)
     c5e:	fbe5                	bnez	a5,c4e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c60:	0005c503          	lbu	a0,0(a1)
}
     c64:	40a7853b          	subw	a0,a5,a0
     c68:	6422                	ld	s0,8(sp)
     c6a:	0141                	addi	sp,sp,16
     c6c:	8082                	ret

0000000000000c6e <strlen>:

uint
strlen(const char *s)
{
     c6e:	1141                	addi	sp,sp,-16
     c70:	e422                	sd	s0,8(sp)
     c72:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c74:	00054783          	lbu	a5,0(a0)
     c78:	cf91                	beqz	a5,c94 <strlen+0x26>
     c7a:	0505                	addi	a0,a0,1
     c7c:	87aa                	mv	a5,a0
     c7e:	4685                	li	a3,1
     c80:	9e89                	subw	a3,a3,a0
     c82:	00f6853b          	addw	a0,a3,a5
     c86:	0785                	addi	a5,a5,1
     c88:	fff7c703          	lbu	a4,-1(a5)
     c8c:	fb7d                	bnez	a4,c82 <strlen+0x14>
    ;
  return n;
}
     c8e:	6422                	ld	s0,8(sp)
     c90:	0141                	addi	sp,sp,16
     c92:	8082                	ret
  for(n = 0; s[n]; n++)
     c94:	4501                	li	a0,0
     c96:	bfe5                	j	c8e <strlen+0x20>

0000000000000c98 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c98:	1141                	addi	sp,sp,-16
     c9a:	e422                	sd	s0,8(sp)
     c9c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c9e:	ca19                	beqz	a2,cb4 <memset+0x1c>
     ca0:	87aa                	mv	a5,a0
     ca2:	1602                	slli	a2,a2,0x20
     ca4:	9201                	srli	a2,a2,0x20
     ca6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     caa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     cae:	0785                	addi	a5,a5,1
     cb0:	fee79de3          	bne	a5,a4,caa <memset+0x12>
  }
  return dst;
}
     cb4:	6422                	ld	s0,8(sp)
     cb6:	0141                	addi	sp,sp,16
     cb8:	8082                	ret

0000000000000cba <strchr>:

char*
strchr(const char *s, char c)
{
     cba:	1141                	addi	sp,sp,-16
     cbc:	e422                	sd	s0,8(sp)
     cbe:	0800                	addi	s0,sp,16
  for(; *s; s++)
     cc0:	00054783          	lbu	a5,0(a0)
     cc4:	cb99                	beqz	a5,cda <strchr+0x20>
    if(*s == c)
     cc6:	00f58763          	beq	a1,a5,cd4 <strchr+0x1a>
  for(; *s; s++)
     cca:	0505                	addi	a0,a0,1
     ccc:	00054783          	lbu	a5,0(a0)
     cd0:	fbfd                	bnez	a5,cc6 <strchr+0xc>
      return (char*)s;
  return 0;
     cd2:	4501                	li	a0,0
}
     cd4:	6422                	ld	s0,8(sp)
     cd6:	0141                	addi	sp,sp,16
     cd8:	8082                	ret
  return 0;
     cda:	4501                	li	a0,0
     cdc:	bfe5                	j	cd4 <strchr+0x1a>

0000000000000cde <gets>:

char*
gets(char *buf, int max)
{
     cde:	711d                	addi	sp,sp,-96
     ce0:	ec86                	sd	ra,88(sp)
     ce2:	e8a2                	sd	s0,80(sp)
     ce4:	e4a6                	sd	s1,72(sp)
     ce6:	e0ca                	sd	s2,64(sp)
     ce8:	fc4e                	sd	s3,56(sp)
     cea:	f852                	sd	s4,48(sp)
     cec:	f456                	sd	s5,40(sp)
     cee:	f05a                	sd	s6,32(sp)
     cf0:	ec5e                	sd	s7,24(sp)
     cf2:	1080                	addi	s0,sp,96
     cf4:	8baa                	mv	s7,a0
     cf6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cf8:	892a                	mv	s2,a0
     cfa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cfc:	4aa9                	li	s5,10
     cfe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     d00:	89a6                	mv	s3,s1
     d02:	2485                	addiw	s1,s1,1
     d04:	0344d863          	bge	s1,s4,d34 <gets+0x56>
    cc = read(0, &c, 1);
     d08:	4605                	li	a2,1
     d0a:	faf40593          	addi	a1,s0,-81
     d0e:	4501                	li	a0,0
     d10:	00000097          	auipc	ra,0x0
     d14:	1b2080e7          	jalr	434(ra) # ec2 <read>
    if(cc < 1)
     d18:	00a05e63          	blez	a0,d34 <gets+0x56>
    buf[i++] = c;
     d1c:	faf44783          	lbu	a5,-81(s0)
     d20:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d24:	01578763          	beq	a5,s5,d32 <gets+0x54>
     d28:	0905                	addi	s2,s2,1
     d2a:	fd679be3          	bne	a5,s6,d00 <gets+0x22>
  for(i=0; i+1 < max; ){
     d2e:	89a6                	mv	s3,s1
     d30:	a011                	j	d34 <gets+0x56>
     d32:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d34:	99de                	add	s3,s3,s7
     d36:	00098023          	sb	zero,0(s3)
  return buf;
}
     d3a:	855e                	mv	a0,s7
     d3c:	60e6                	ld	ra,88(sp)
     d3e:	6446                	ld	s0,80(sp)
     d40:	64a6                	ld	s1,72(sp)
     d42:	6906                	ld	s2,64(sp)
     d44:	79e2                	ld	s3,56(sp)
     d46:	7a42                	ld	s4,48(sp)
     d48:	7aa2                	ld	s5,40(sp)
     d4a:	7b02                	ld	s6,32(sp)
     d4c:	6be2                	ld	s7,24(sp)
     d4e:	6125                	addi	sp,sp,96
     d50:	8082                	ret

0000000000000d52 <stat>:

int
stat(const char *n, struct stat *st)
{
     d52:	1101                	addi	sp,sp,-32
     d54:	ec06                	sd	ra,24(sp)
     d56:	e822                	sd	s0,16(sp)
     d58:	e426                	sd	s1,8(sp)
     d5a:	e04a                	sd	s2,0(sp)
     d5c:	1000                	addi	s0,sp,32
     d5e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d60:	4581                	li	a1,0
     d62:	00000097          	auipc	ra,0x0
     d66:	188080e7          	jalr	392(ra) # eea <open>
  if(fd < 0)
     d6a:	02054563          	bltz	a0,d94 <stat+0x42>
     d6e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d70:	85ca                	mv	a1,s2
     d72:	00000097          	auipc	ra,0x0
     d76:	190080e7          	jalr	400(ra) # f02 <fstat>
     d7a:	892a                	mv	s2,a0
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00000097          	auipc	ra,0x0
     d82:	154080e7          	jalr	340(ra) # ed2 <close>
  return r;
}
     d86:	854a                	mv	a0,s2
     d88:	60e2                	ld	ra,24(sp)
     d8a:	6442                	ld	s0,16(sp)
     d8c:	64a2                	ld	s1,8(sp)
     d8e:	6902                	ld	s2,0(sp)
     d90:	6105                	addi	sp,sp,32
     d92:	8082                	ret
    return -1;
     d94:	597d                	li	s2,-1
     d96:	bfc5                	j	d86 <stat+0x34>

0000000000000d98 <atoi>:

int
atoi(const char *s)
{
     d98:	1141                	addi	sp,sp,-16
     d9a:	e422                	sd	s0,8(sp)
     d9c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d9e:	00054603          	lbu	a2,0(a0)
     da2:	fd06079b          	addiw	a5,a2,-48
     da6:	0ff7f793          	andi	a5,a5,255
     daa:	4725                	li	a4,9
     dac:	02f76963          	bltu	a4,a5,dde <atoi+0x46>
     db0:	86aa                	mv	a3,a0
  n = 0;
     db2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     db4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     db6:	0685                	addi	a3,a3,1
     db8:	0025179b          	slliw	a5,a0,0x2
     dbc:	9fa9                	addw	a5,a5,a0
     dbe:	0017979b          	slliw	a5,a5,0x1
     dc2:	9fb1                	addw	a5,a5,a2
     dc4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     dc8:	0006c603          	lbu	a2,0(a3)
     dcc:	fd06071b          	addiw	a4,a2,-48
     dd0:	0ff77713          	andi	a4,a4,255
     dd4:	fee5f1e3          	bgeu	a1,a4,db6 <atoi+0x1e>
  return n;
}
     dd8:	6422                	ld	s0,8(sp)
     dda:	0141                	addi	sp,sp,16
     ddc:	8082                	ret
  n = 0;
     dde:	4501                	li	a0,0
     de0:	bfe5                	j	dd8 <atoi+0x40>

0000000000000de2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     de2:	1141                	addi	sp,sp,-16
     de4:	e422                	sd	s0,8(sp)
     de6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     de8:	02b57463          	bgeu	a0,a1,e10 <memmove+0x2e>
    while(n-- > 0)
     dec:	00c05f63          	blez	a2,e0a <memmove+0x28>
     df0:	1602                	slli	a2,a2,0x20
     df2:	9201                	srli	a2,a2,0x20
     df4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     df8:	872a                	mv	a4,a0
      *dst++ = *src++;
     dfa:	0585                	addi	a1,a1,1
     dfc:	0705                	addi	a4,a4,1
     dfe:	fff5c683          	lbu	a3,-1(a1)
     e02:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e06:	fee79ae3          	bne	a5,a4,dfa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e0a:	6422                	ld	s0,8(sp)
     e0c:	0141                	addi	sp,sp,16
     e0e:	8082                	ret
    dst += n;
     e10:	00c50733          	add	a4,a0,a2
    src += n;
     e14:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e16:	fec05ae3          	blez	a2,e0a <memmove+0x28>
     e1a:	fff6079b          	addiw	a5,a2,-1
     e1e:	1782                	slli	a5,a5,0x20
     e20:	9381                	srli	a5,a5,0x20
     e22:	fff7c793          	not	a5,a5
     e26:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e28:	15fd                	addi	a1,a1,-1
     e2a:	177d                	addi	a4,a4,-1
     e2c:	0005c683          	lbu	a3,0(a1)
     e30:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e34:	fee79ae3          	bne	a5,a4,e28 <memmove+0x46>
     e38:	bfc9                	j	e0a <memmove+0x28>

0000000000000e3a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e3a:	1141                	addi	sp,sp,-16
     e3c:	e422                	sd	s0,8(sp)
     e3e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e40:	ca05                	beqz	a2,e70 <memcmp+0x36>
     e42:	fff6069b          	addiw	a3,a2,-1
     e46:	1682                	slli	a3,a3,0x20
     e48:	9281                	srli	a3,a3,0x20
     e4a:	0685                	addi	a3,a3,1
     e4c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e4e:	00054783          	lbu	a5,0(a0)
     e52:	0005c703          	lbu	a4,0(a1)
     e56:	00e79863          	bne	a5,a4,e66 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e5a:	0505                	addi	a0,a0,1
    p2++;
     e5c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e5e:	fed518e3          	bne	a0,a3,e4e <memcmp+0x14>
  }
  return 0;
     e62:	4501                	li	a0,0
     e64:	a019                	j	e6a <memcmp+0x30>
      return *p1 - *p2;
     e66:	40e7853b          	subw	a0,a5,a4
}
     e6a:	6422                	ld	s0,8(sp)
     e6c:	0141                	addi	sp,sp,16
     e6e:	8082                	ret
  return 0;
     e70:	4501                	li	a0,0
     e72:	bfe5                	j	e6a <memcmp+0x30>

0000000000000e74 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e74:	1141                	addi	sp,sp,-16
     e76:	e406                	sd	ra,8(sp)
     e78:	e022                	sd	s0,0(sp)
     e7a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e7c:	00000097          	auipc	ra,0x0
     e80:	f66080e7          	jalr	-154(ra) # de2 <memmove>
}
     e84:	60a2                	ld	ra,8(sp)
     e86:	6402                	ld	s0,0(sp)
     e88:	0141                	addi	sp,sp,16
     e8a:	8082                	ret

0000000000000e8c <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     e8c:	1141                	addi	sp,sp,-16
     e8e:	e422                	sd	s0,8(sp)
     e90:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     e92:	040007b7          	lui	a5,0x4000
}
     e96:	17f5                	addi	a5,a5,-3
     e98:	07b2                	slli	a5,a5,0xc
     e9a:	4388                	lw	a0,0(a5)
     e9c:	6422                	ld	s0,8(sp)
     e9e:	0141                	addi	sp,sp,16
     ea0:	8082                	ret

0000000000000ea2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ea2:	4885                	li	a7,1
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	8082                	ret

0000000000000eaa <exit>:
.global exit
exit:
 li a7, SYS_exit
     eaa:	4889                	li	a7,2
 ecall
     eac:	00000073          	ecall
 ret
     eb0:	8082                	ret

0000000000000eb2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     eb2:	488d                	li	a7,3
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     eba:	4891                	li	a7,4
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <read>:
.global read
read:
 li a7, SYS_read
     ec2:	4895                	li	a7,5
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <write>:
.global write
write:
 li a7, SYS_write
     eca:	48c1                	li	a7,16
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <close>:
.global close
close:
 li a7, SYS_close
     ed2:	48d5                	li	a7,21
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	8082                	ret

0000000000000eda <kill>:
.global kill
kill:
 li a7, SYS_kill
     eda:	4899                	li	a7,6
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     ee2:	489d                	li	a7,7
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <open>:
.global open
open:
 li a7, SYS_open
     eea:	48bd                	li	a7,15
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ef2:	48c5                	li	a7,17
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     efa:	48c9                	li	a7,18
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f02:	48a1                	li	a7,8
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <link>:
.global link
link:
 li a7, SYS_link
     f0a:	48cd                	li	a7,19
 ecall
     f0c:	00000073          	ecall
 ret
     f10:	8082                	ret

0000000000000f12 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f12:	48d1                	li	a7,20
 ecall
     f14:	00000073          	ecall
 ret
     f18:	8082                	ret

0000000000000f1a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f1a:	48a5                	li	a7,9
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	8082                	ret

0000000000000f22 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f22:	48a9                	li	a7,10
 ecall
     f24:	00000073          	ecall
 ret
     f28:	8082                	ret

0000000000000f2a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f2a:	48ad                	li	a7,11
 ecall
     f2c:	00000073          	ecall
 ret
     f30:	8082                	ret

0000000000000f32 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f32:	48b1                	li	a7,12
 ecall
     f34:	00000073          	ecall
 ret
     f38:	8082                	ret

0000000000000f3a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f3a:	48b5                	li	a7,13
 ecall
     f3c:	00000073          	ecall
 ret
     f40:	8082                	ret

0000000000000f42 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f42:	48b9                	li	a7,14
 ecall
     f44:	00000073          	ecall
 ret
     f48:	8082                	ret

0000000000000f4a <connect>:
.global connect
connect:
 li a7, SYS_connect
     f4a:	48f5                	li	a7,29
 ecall
     f4c:	00000073          	ecall
 ret
     f50:	8082                	ret

0000000000000f52 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     f52:	48f9                	li	a7,30
 ecall
     f54:	00000073          	ecall
 ret
     f58:	8082                	ret

0000000000000f5a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f5a:	1101                	addi	sp,sp,-32
     f5c:	ec06                	sd	ra,24(sp)
     f5e:	e822                	sd	s0,16(sp)
     f60:	1000                	addi	s0,sp,32
     f62:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f66:	4605                	li	a2,1
     f68:	fef40593          	addi	a1,s0,-17
     f6c:	00000097          	auipc	ra,0x0
     f70:	f5e080e7          	jalr	-162(ra) # eca <write>
}
     f74:	60e2                	ld	ra,24(sp)
     f76:	6442                	ld	s0,16(sp)
     f78:	6105                	addi	sp,sp,32
     f7a:	8082                	ret

0000000000000f7c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f7c:	7139                	addi	sp,sp,-64
     f7e:	fc06                	sd	ra,56(sp)
     f80:	f822                	sd	s0,48(sp)
     f82:	f426                	sd	s1,40(sp)
     f84:	f04a                	sd	s2,32(sp)
     f86:	ec4e                	sd	s3,24(sp)
     f88:	0080                	addi	s0,sp,64
     f8a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f8c:	c299                	beqz	a3,f92 <printint+0x16>
     f8e:	0805c863          	bltz	a1,101e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f92:	2581                	sext.w	a1,a1
  neg = 0;
     f94:	4881                	li	a7,0
     f96:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f9a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f9c:	2601                	sext.w	a2,a2
     f9e:	00000517          	auipc	a0,0x0
     fa2:	73250513          	addi	a0,a0,1842 # 16d0 <digits>
     fa6:	883a                	mv	a6,a4
     fa8:	2705                	addiw	a4,a4,1
     faa:	02c5f7bb          	remuw	a5,a1,a2
     fae:	1782                	slli	a5,a5,0x20
     fb0:	9381                	srli	a5,a5,0x20
     fb2:	97aa                	add	a5,a5,a0
     fb4:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffdbf8>
     fb8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     fbc:	0005879b          	sext.w	a5,a1
     fc0:	02c5d5bb          	divuw	a1,a1,a2
     fc4:	0685                	addi	a3,a3,1
     fc6:	fec7f0e3          	bgeu	a5,a2,fa6 <printint+0x2a>
  if(neg)
     fca:	00088b63          	beqz	a7,fe0 <printint+0x64>
    buf[i++] = '-';
     fce:	fd040793          	addi	a5,s0,-48
     fd2:	973e                	add	a4,a4,a5
     fd4:	02d00793          	li	a5,45
     fd8:	fef70823          	sb	a5,-16(a4)
     fdc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     fe0:	02e05863          	blez	a4,1010 <printint+0x94>
     fe4:	fc040793          	addi	a5,s0,-64
     fe8:	00e78933          	add	s2,a5,a4
     fec:	fff78993          	addi	s3,a5,-1
     ff0:	99ba                	add	s3,s3,a4
     ff2:	377d                	addiw	a4,a4,-1
     ff4:	1702                	slli	a4,a4,0x20
     ff6:	9301                	srli	a4,a4,0x20
     ff8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ffc:	fff94583          	lbu	a1,-1(s2)
    1000:	8526                	mv	a0,s1
    1002:	00000097          	auipc	ra,0x0
    1006:	f58080e7          	jalr	-168(ra) # f5a <putc>
  while(--i >= 0)
    100a:	197d                	addi	s2,s2,-1
    100c:	ff3918e3          	bne	s2,s3,ffc <printint+0x80>
}
    1010:	70e2                	ld	ra,56(sp)
    1012:	7442                	ld	s0,48(sp)
    1014:	74a2                	ld	s1,40(sp)
    1016:	7902                	ld	s2,32(sp)
    1018:	69e2                	ld	s3,24(sp)
    101a:	6121                	addi	sp,sp,64
    101c:	8082                	ret
    x = -xx;
    101e:	40b005bb          	negw	a1,a1
    neg = 1;
    1022:	4885                	li	a7,1
    x = -xx;
    1024:	bf8d                	j	f96 <printint+0x1a>

0000000000001026 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1026:	7119                	addi	sp,sp,-128
    1028:	fc86                	sd	ra,120(sp)
    102a:	f8a2                	sd	s0,112(sp)
    102c:	f4a6                	sd	s1,104(sp)
    102e:	f0ca                	sd	s2,96(sp)
    1030:	ecce                	sd	s3,88(sp)
    1032:	e8d2                	sd	s4,80(sp)
    1034:	e4d6                	sd	s5,72(sp)
    1036:	e0da                	sd	s6,64(sp)
    1038:	fc5e                	sd	s7,56(sp)
    103a:	f862                	sd	s8,48(sp)
    103c:	f466                	sd	s9,40(sp)
    103e:	f06a                	sd	s10,32(sp)
    1040:	ec6e                	sd	s11,24(sp)
    1042:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1044:	0005c903          	lbu	s2,0(a1)
    1048:	18090f63          	beqz	s2,11e6 <vprintf+0x1c0>
    104c:	8aaa                	mv	s5,a0
    104e:	8b32                	mv	s6,a2
    1050:	00158493          	addi	s1,a1,1
  state = 0;
    1054:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1056:	02500a13          	li	s4,37
      if(c == 'd'){
    105a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    105e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1062:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1066:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    106a:	00000b97          	auipc	s7,0x0
    106e:	666b8b93          	addi	s7,s7,1638 # 16d0 <digits>
    1072:	a839                	j	1090 <vprintf+0x6a>
        putc(fd, c);
    1074:	85ca                	mv	a1,s2
    1076:	8556                	mv	a0,s5
    1078:	00000097          	auipc	ra,0x0
    107c:	ee2080e7          	jalr	-286(ra) # f5a <putc>
    1080:	a019                	j	1086 <vprintf+0x60>
    } else if(state == '%'){
    1082:	01498f63          	beq	s3,s4,10a0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1086:	0485                	addi	s1,s1,1
    1088:	fff4c903          	lbu	s2,-1(s1)
    108c:	14090d63          	beqz	s2,11e6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1090:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1094:	fe0997e3          	bnez	s3,1082 <vprintf+0x5c>
      if(c == '%'){
    1098:	fd479ee3          	bne	a5,s4,1074 <vprintf+0x4e>
        state = '%';
    109c:	89be                	mv	s3,a5
    109e:	b7e5                	j	1086 <vprintf+0x60>
      if(c == 'd'){
    10a0:	05878063          	beq	a5,s8,10e0 <vprintf+0xba>
      } else if(c == 'l') {
    10a4:	05978c63          	beq	a5,s9,10fc <vprintf+0xd6>
      } else if(c == 'x') {
    10a8:	07a78863          	beq	a5,s10,1118 <vprintf+0xf2>
      } else if(c == 'p') {
    10ac:	09b78463          	beq	a5,s11,1134 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    10b0:	07300713          	li	a4,115
    10b4:	0ce78663          	beq	a5,a4,1180 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10b8:	06300713          	li	a4,99
    10bc:	0ee78e63          	beq	a5,a4,11b8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    10c0:	11478863          	beq	a5,s4,11d0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10c4:	85d2                	mv	a1,s4
    10c6:	8556                	mv	a0,s5
    10c8:	00000097          	auipc	ra,0x0
    10cc:	e92080e7          	jalr	-366(ra) # f5a <putc>
        putc(fd, c);
    10d0:	85ca                	mv	a1,s2
    10d2:	8556                	mv	a0,s5
    10d4:	00000097          	auipc	ra,0x0
    10d8:	e86080e7          	jalr	-378(ra) # f5a <putc>
      }
      state = 0;
    10dc:	4981                	li	s3,0
    10de:	b765                	j	1086 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10e0:	008b0913          	addi	s2,s6,8
    10e4:	4685                	li	a3,1
    10e6:	4629                	li	a2,10
    10e8:	000b2583          	lw	a1,0(s6)
    10ec:	8556                	mv	a0,s5
    10ee:	00000097          	auipc	ra,0x0
    10f2:	e8e080e7          	jalr	-370(ra) # f7c <printint>
    10f6:	8b4a                	mv	s6,s2
      state = 0;
    10f8:	4981                	li	s3,0
    10fa:	b771                	j	1086 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10fc:	008b0913          	addi	s2,s6,8
    1100:	4681                	li	a3,0
    1102:	4629                	li	a2,10
    1104:	000b2583          	lw	a1,0(s6)
    1108:	8556                	mv	a0,s5
    110a:	00000097          	auipc	ra,0x0
    110e:	e72080e7          	jalr	-398(ra) # f7c <printint>
    1112:	8b4a                	mv	s6,s2
      state = 0;
    1114:	4981                	li	s3,0
    1116:	bf85                	j	1086 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1118:	008b0913          	addi	s2,s6,8
    111c:	4681                	li	a3,0
    111e:	4641                	li	a2,16
    1120:	000b2583          	lw	a1,0(s6)
    1124:	8556                	mv	a0,s5
    1126:	00000097          	auipc	ra,0x0
    112a:	e56080e7          	jalr	-426(ra) # f7c <printint>
    112e:	8b4a                	mv	s6,s2
      state = 0;
    1130:	4981                	li	s3,0
    1132:	bf91                	j	1086 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1134:	008b0793          	addi	a5,s6,8
    1138:	f8f43423          	sd	a5,-120(s0)
    113c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1140:	03000593          	li	a1,48
    1144:	8556                	mv	a0,s5
    1146:	00000097          	auipc	ra,0x0
    114a:	e14080e7          	jalr	-492(ra) # f5a <putc>
  putc(fd, 'x');
    114e:	85ea                	mv	a1,s10
    1150:	8556                	mv	a0,s5
    1152:	00000097          	auipc	ra,0x0
    1156:	e08080e7          	jalr	-504(ra) # f5a <putc>
    115a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    115c:	03c9d793          	srli	a5,s3,0x3c
    1160:	97de                	add	a5,a5,s7
    1162:	0007c583          	lbu	a1,0(a5)
    1166:	8556                	mv	a0,s5
    1168:	00000097          	auipc	ra,0x0
    116c:	df2080e7          	jalr	-526(ra) # f5a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1170:	0992                	slli	s3,s3,0x4
    1172:	397d                	addiw	s2,s2,-1
    1174:	fe0914e3          	bnez	s2,115c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1178:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    117c:	4981                	li	s3,0
    117e:	b721                	j	1086 <vprintf+0x60>
        s = va_arg(ap, char*);
    1180:	008b0993          	addi	s3,s6,8
    1184:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1188:	02090163          	beqz	s2,11aa <vprintf+0x184>
        while(*s != 0){
    118c:	00094583          	lbu	a1,0(s2)
    1190:	c9a1                	beqz	a1,11e0 <vprintf+0x1ba>
          putc(fd, *s);
    1192:	8556                	mv	a0,s5
    1194:	00000097          	auipc	ra,0x0
    1198:	dc6080e7          	jalr	-570(ra) # f5a <putc>
          s++;
    119c:	0905                	addi	s2,s2,1
        while(*s != 0){
    119e:	00094583          	lbu	a1,0(s2)
    11a2:	f9e5                	bnez	a1,1192 <vprintf+0x16c>
        s = va_arg(ap, char*);
    11a4:	8b4e                	mv	s6,s3
      state = 0;
    11a6:	4981                	li	s3,0
    11a8:	bdf9                	j	1086 <vprintf+0x60>
          s = "(null)";
    11aa:	00000917          	auipc	s2,0x0
    11ae:	51e90913          	addi	s2,s2,1310 # 16c8 <malloc+0x3d8>
        while(*s != 0){
    11b2:	02800593          	li	a1,40
    11b6:	bff1                	j	1192 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    11b8:	008b0913          	addi	s2,s6,8
    11bc:	000b4583          	lbu	a1,0(s6)
    11c0:	8556                	mv	a0,s5
    11c2:	00000097          	auipc	ra,0x0
    11c6:	d98080e7          	jalr	-616(ra) # f5a <putc>
    11ca:	8b4a                	mv	s6,s2
      state = 0;
    11cc:	4981                	li	s3,0
    11ce:	bd65                	j	1086 <vprintf+0x60>
        putc(fd, c);
    11d0:	85d2                	mv	a1,s4
    11d2:	8556                	mv	a0,s5
    11d4:	00000097          	auipc	ra,0x0
    11d8:	d86080e7          	jalr	-634(ra) # f5a <putc>
      state = 0;
    11dc:	4981                	li	s3,0
    11de:	b565                	j	1086 <vprintf+0x60>
        s = va_arg(ap, char*);
    11e0:	8b4e                	mv	s6,s3
      state = 0;
    11e2:	4981                	li	s3,0
    11e4:	b54d                	j	1086 <vprintf+0x60>
    }
  }
}
    11e6:	70e6                	ld	ra,120(sp)
    11e8:	7446                	ld	s0,112(sp)
    11ea:	74a6                	ld	s1,104(sp)
    11ec:	7906                	ld	s2,96(sp)
    11ee:	69e6                	ld	s3,88(sp)
    11f0:	6a46                	ld	s4,80(sp)
    11f2:	6aa6                	ld	s5,72(sp)
    11f4:	6b06                	ld	s6,64(sp)
    11f6:	7be2                	ld	s7,56(sp)
    11f8:	7c42                	ld	s8,48(sp)
    11fa:	7ca2                	ld	s9,40(sp)
    11fc:	7d02                	ld	s10,32(sp)
    11fe:	6de2                	ld	s11,24(sp)
    1200:	6109                	addi	sp,sp,128
    1202:	8082                	ret

0000000000001204 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1204:	715d                	addi	sp,sp,-80
    1206:	ec06                	sd	ra,24(sp)
    1208:	e822                	sd	s0,16(sp)
    120a:	1000                	addi	s0,sp,32
    120c:	e010                	sd	a2,0(s0)
    120e:	e414                	sd	a3,8(s0)
    1210:	e818                	sd	a4,16(s0)
    1212:	ec1c                	sd	a5,24(s0)
    1214:	03043023          	sd	a6,32(s0)
    1218:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    121c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1220:	8622                	mv	a2,s0
    1222:	00000097          	auipc	ra,0x0
    1226:	e04080e7          	jalr	-508(ra) # 1026 <vprintf>
}
    122a:	60e2                	ld	ra,24(sp)
    122c:	6442                	ld	s0,16(sp)
    122e:	6161                	addi	sp,sp,80
    1230:	8082                	ret

0000000000001232 <printf>:

void
printf(const char *fmt, ...)
{
    1232:	711d                	addi	sp,sp,-96
    1234:	ec06                	sd	ra,24(sp)
    1236:	e822                	sd	s0,16(sp)
    1238:	1000                	addi	s0,sp,32
    123a:	e40c                	sd	a1,8(s0)
    123c:	e810                	sd	a2,16(s0)
    123e:	ec14                	sd	a3,24(s0)
    1240:	f018                	sd	a4,32(s0)
    1242:	f41c                	sd	a5,40(s0)
    1244:	03043823          	sd	a6,48(s0)
    1248:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    124c:	00840613          	addi	a2,s0,8
    1250:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1254:	85aa                	mv	a1,a0
    1256:	4505                	li	a0,1
    1258:	00000097          	auipc	ra,0x0
    125c:	dce080e7          	jalr	-562(ra) # 1026 <vprintf>
}
    1260:	60e2                	ld	ra,24(sp)
    1262:	6442                	ld	s0,16(sp)
    1264:	6125                	addi	sp,sp,96
    1266:	8082                	ret

0000000000001268 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1268:	1141                	addi	sp,sp,-16
    126a:	e422                	sd	s0,8(sp)
    126c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    126e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1272:	00001797          	auipc	a5,0x1
    1276:	d9e7b783          	ld	a5,-610(a5) # 2010 <freep>
    127a:	a805                	j	12aa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    127c:	4618                	lw	a4,8(a2)
    127e:	9db9                	addw	a1,a1,a4
    1280:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1284:	6398                	ld	a4,0(a5)
    1286:	6318                	ld	a4,0(a4)
    1288:	fee53823          	sd	a4,-16(a0)
    128c:	a091                	j	12d0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    128e:	ff852703          	lw	a4,-8(a0)
    1292:	9e39                	addw	a2,a2,a4
    1294:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1296:	ff053703          	ld	a4,-16(a0)
    129a:	e398                	sd	a4,0(a5)
    129c:	a099                	j	12e2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    129e:	6398                	ld	a4,0(a5)
    12a0:	00e7e463          	bltu	a5,a4,12a8 <free+0x40>
    12a4:	00e6ea63          	bltu	a3,a4,12b8 <free+0x50>
{
    12a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12aa:	fed7fae3          	bgeu	a5,a3,129e <free+0x36>
    12ae:	6398                	ld	a4,0(a5)
    12b0:	00e6e463          	bltu	a3,a4,12b8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b4:	fee7eae3          	bltu	a5,a4,12a8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    12b8:	ff852583          	lw	a1,-8(a0)
    12bc:	6390                	ld	a2,0(a5)
    12be:	02059713          	slli	a4,a1,0x20
    12c2:	9301                	srli	a4,a4,0x20
    12c4:	0712                	slli	a4,a4,0x4
    12c6:	9736                	add	a4,a4,a3
    12c8:	fae60ae3          	beq	a2,a4,127c <free+0x14>
    bp->s.ptr = p->s.ptr;
    12cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12d0:	4790                	lw	a2,8(a5)
    12d2:	02061713          	slli	a4,a2,0x20
    12d6:	9301                	srli	a4,a4,0x20
    12d8:	0712                	slli	a4,a4,0x4
    12da:	973e                	add	a4,a4,a5
    12dc:	fae689e3          	beq	a3,a4,128e <free+0x26>
  } else
    p->s.ptr = bp;
    12e0:	e394                	sd	a3,0(a5)
  freep = p;
    12e2:	00001717          	auipc	a4,0x1
    12e6:	d2f73723          	sd	a5,-722(a4) # 2010 <freep>
}
    12ea:	6422                	ld	s0,8(sp)
    12ec:	0141                	addi	sp,sp,16
    12ee:	8082                	ret

00000000000012f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12f0:	7139                	addi	sp,sp,-64
    12f2:	fc06                	sd	ra,56(sp)
    12f4:	f822                	sd	s0,48(sp)
    12f6:	f426                	sd	s1,40(sp)
    12f8:	f04a                	sd	s2,32(sp)
    12fa:	ec4e                	sd	s3,24(sp)
    12fc:	e852                	sd	s4,16(sp)
    12fe:	e456                	sd	s5,8(sp)
    1300:	e05a                	sd	s6,0(sp)
    1302:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1304:	02051493          	slli	s1,a0,0x20
    1308:	9081                	srli	s1,s1,0x20
    130a:	04bd                	addi	s1,s1,15
    130c:	8091                	srli	s1,s1,0x4
    130e:	0014899b          	addiw	s3,s1,1
    1312:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1314:	00001517          	auipc	a0,0x1
    1318:	cfc53503          	ld	a0,-772(a0) # 2010 <freep>
    131c:	c515                	beqz	a0,1348 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    131e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1320:	4798                	lw	a4,8(a5)
    1322:	02977f63          	bgeu	a4,s1,1360 <malloc+0x70>
    1326:	8a4e                	mv	s4,s3
    1328:	0009871b          	sext.w	a4,s3
    132c:	6685                	lui	a3,0x1
    132e:	00d77363          	bgeu	a4,a3,1334 <malloc+0x44>
    1332:	6a05                	lui	s4,0x1
    1334:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1338:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    133c:	00001917          	auipc	s2,0x1
    1340:	cd490913          	addi	s2,s2,-812 # 2010 <freep>
  if(p == (char*)-1)
    1344:	5afd                	li	s5,-1
    1346:	a88d                	j	13b8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1348:	00001797          	auipc	a5,0x1
    134c:	0c078793          	addi	a5,a5,192 # 2408 <base>
    1350:	00001717          	auipc	a4,0x1
    1354:	ccf73023          	sd	a5,-832(a4) # 2010 <freep>
    1358:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    135a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    135e:	b7e1                	j	1326 <malloc+0x36>
      if(p->s.size == nunits)
    1360:	02e48b63          	beq	s1,a4,1396 <malloc+0xa6>
        p->s.size -= nunits;
    1364:	4137073b          	subw	a4,a4,s3
    1368:	c798                	sw	a4,8(a5)
        p += p->s.size;
    136a:	1702                	slli	a4,a4,0x20
    136c:	9301                	srli	a4,a4,0x20
    136e:	0712                	slli	a4,a4,0x4
    1370:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1372:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1376:	00001717          	auipc	a4,0x1
    137a:	c8a73d23          	sd	a0,-870(a4) # 2010 <freep>
      return (void*)(p + 1);
    137e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1382:	70e2                	ld	ra,56(sp)
    1384:	7442                	ld	s0,48(sp)
    1386:	74a2                	ld	s1,40(sp)
    1388:	7902                	ld	s2,32(sp)
    138a:	69e2                	ld	s3,24(sp)
    138c:	6a42                	ld	s4,16(sp)
    138e:	6aa2                	ld	s5,8(sp)
    1390:	6b02                	ld	s6,0(sp)
    1392:	6121                	addi	sp,sp,64
    1394:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1396:	6398                	ld	a4,0(a5)
    1398:	e118                	sd	a4,0(a0)
    139a:	bff1                	j	1376 <malloc+0x86>
  hp->s.size = nu;
    139c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13a0:	0541                	addi	a0,a0,16
    13a2:	00000097          	auipc	ra,0x0
    13a6:	ec6080e7          	jalr	-314(ra) # 1268 <free>
  return freep;
    13aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    13ae:	d971                	beqz	a0,1382 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13b2:	4798                	lw	a4,8(a5)
    13b4:	fa9776e3          	bgeu	a4,s1,1360 <malloc+0x70>
    if(p == freep)
    13b8:	00093703          	ld	a4,0(s2)
    13bc:	853e                	mv	a0,a5
    13be:	fef719e3          	bne	a4,a5,13b0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    13c2:	8552                	mv	a0,s4
    13c4:	00000097          	auipc	ra,0x0
    13c8:	b6e080e7          	jalr	-1170(ra) # f32 <sbrk>
  if(p == (char*)-1)
    13cc:	fd5518e3          	bne	a0,s5,139c <malloc+0xac>
        return 0;
    13d0:	4501                	li	a0,0
    13d2:	bf45                	j	1382 <malloc+0x92>
