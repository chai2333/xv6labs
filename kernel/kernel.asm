
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	eb010113          	addi	sp,sp,-336 # 80019eb0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	179050ef          	jal	ra,8000598e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	f8078793          	addi	a5,a5,-128 # 80021fb0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8f090913          	addi	s2,s2,-1808 # 80008940 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	320080e7          	jalr	800(ra) # 8000637a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3c0080e7          	jalr	960(ra) # 8000642e <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	db4080e7          	jalr	-588(ra) # 80005e3e <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	85450513          	addi	a0,a0,-1964 # 80008940 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	1f6080e7          	jalr	502(ra) # 800062ea <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	eb050513          	addi	a0,a0,-336 # 80021fb0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	81e48493          	addi	s1,s1,-2018 # 80008940 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	24e080e7          	jalr	590(ra) # 8000637a <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	80650513          	addi	a0,a0,-2042 # 80008940 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2ea080e7          	jalr	746(ra) # 8000642e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	7da50513          	addi	a0,a0,2010 # 80008940 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2c0080e7          	jalr	704(ra) # 8000642e <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	be2080e7          	jalr	-1054(ra) # 80000f08 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5e270713          	addi	a4,a4,1506 # 80008910 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	bc6080e7          	jalr	-1082(ra) # 80000f08 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	b34080e7          	jalr	-1228(ra) # 80005e88 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	91a080e7          	jalr	-1766(ra) # 80001c7e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	fd4080e7          	jalr	-44(ra) # 80005340 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	164080e7          	jalr	356(ra) # 800014d8 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	9d4080e7          	jalr	-1580(ra) # 80005d50 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	ce4080e7          	jalr	-796(ra) # 80006068 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	af4080e7          	jalr	-1292(ra) # 80005e88 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	ae4080e7          	jalr	-1308(ra) # 80005e88 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	ad4080e7          	jalr	-1324(ra) # 80005e88 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	a82080e7          	jalr	-1406(ra) # 80000e56 <procinit>
    trapinit();      // trap vectors
    800003dc:	00002097          	auipc	ra,0x2
    800003e0:	87a080e7          	jalr	-1926(ra) # 80001c56 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	89a080e7          	jalr	-1894(ra) # 80001c7e <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	f3e080e7          	jalr	-194(ra) # 8000532a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f4c080e7          	jalr	-180(ra) # 80005340 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	0d6080e7          	jalr	214(ra) # 800024d2 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	77a080e7          	jalr	1914(ra) # 80002b7e <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	718080e7          	jalr	1816(ra) # 80003b24 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	034080e7          	jalr	52(ra) # 80005448 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	e9e080e7          	jalr	-354(ra) # 800012ba <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4ef72323          	sw	a5,1254(a4) # 80008910 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	4da7b783          	ld	a5,1242(a5) # 80008918 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	9b4080e7          	jalr	-1612(ra) # 80005e3e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c82080e7          	jalr	-894(ra) # 80000118 <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd2080e7          	jalr	-814(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	00a7d513          	srli	a0,a5,0xa
    8000053c:	0532                	slli	a0,a0,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	77fd                	lui	a5,0xfffff
    80000562:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000566:	15fd                	addi	a1,a1,-1
    80000568:	00c589b3          	add	s3,a1,a2
    8000056c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000570:	8952                	mv	s2,s4
    80000572:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00006097          	auipc	ra,0x6
    800005b4:	88e080e7          	jalr	-1906(ra) # 80005e3e <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	87e080e7          	jalr	-1922(ra) # 80005e3e <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00006097          	auipc	ra,0x6
    80000610:	832080e7          	jalr	-1998(ra) # 80005e3e <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	af8080e7          	jalr	-1288(ra) # 80000118 <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4a080e7          	jalr	-1206(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	6ee080e7          	jalr	1774(ra) # 80000dc2 <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	20a7bf23          	sd	a0,542(a5) # 80008918 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	6e6080e7          	jalr	1766(ra) # 80005e3e <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	6d6080e7          	jalr	1750(ra) # 80005e3e <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	6c6080e7          	jalr	1734(ra) # 80005e3e <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	6b6080e7          	jalr	1718(ra) # 80005e3e <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	940080e7          	jalr	-1728(ra) # 80000118 <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	990080e7          	jalr	-1648(ra) # 80000178 <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	900080e7          	jalr	-1792(ra) # 80000118 <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	952080e7          	jalr	-1710(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	98e080e7          	jalr	-1650(ra) # 800001d4 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	5d8080e7          	jalr	1496(ra) # 80005e3e <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	767d                	lui	a2,0xfffff
    8000088a:	8f71                	and	a4,a4,a2
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff1                	and	a5,a5,a2
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6985                	lui	s3,0x1
    800008d4:	19fd                	addi	s3,s3,-1
    800008d6:	95ce                	add	a1,a1,s3
    800008d8:	79fd                	lui	s3,0xfffff
    800008da:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	830080e7          	jalr	-2000(ra) # 80000118 <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	880080e7          	jalr	-1920(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a821                	j	8000099a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000986:	0532                	slli	a0,a0,0xc
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	fe0080e7          	jalr	-32(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000990:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000994:	04a1                	addi	s1,s1,8
    80000996:	03248163          	beq	s1,s2,800009b8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000099a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099c:	00f57793          	andi	a5,a0,15
    800009a0:	ff3782e3          	beq	a5,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a4:	8905                	andi	a0,a0,1
    800009a6:	d57d                	beqz	a0,80000994 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a8:	00007517          	auipc	a0,0x7
    800009ac:	75050513          	addi	a0,a0,1872 # 800080f8 <etext+0xf8>
    800009b0:	00005097          	auipc	ra,0x5
    800009b4:	48e080e7          	jalr	1166(ra) # 80005e3e <panic>
    }
  }
  kfree((void*)pagetable);
    800009b8:	8552                	mv	a0,s4
    800009ba:	fffff097          	auipc	ra,0xfffff
    800009be:	662080e7          	jalr	1634(ra) # 8000001c <kfree>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret

00000000800009d2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d2:	1101                	addi	sp,sp,-32
    800009d4:	ec06                	sd	ra,24(sp)
    800009d6:	e822                	sd	s0,16(sp)
    800009d8:	e426                	sd	s1,8(sp)
    800009da:	1000                	addi	s0,sp,32
    800009dc:	84aa                	mv	s1,a0
  if(sz > 0)
    800009de:	e999                	bnez	a1,800009f4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e0:	8526                	mv	a0,s1
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	f86080e7          	jalr	-122(ra) # 80000968 <freewalk>
}
    800009ea:	60e2                	ld	ra,24(sp)
    800009ec:	6442                	ld	s0,16(sp)
    800009ee:	64a2                	ld	s1,8(sp)
    800009f0:	6105                	addi	sp,sp,32
    800009f2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f4:	6605                	lui	a2,0x1
    800009f6:	167d                	addi	a2,a2,-1
    800009f8:	962e                	add	a2,a2,a1
    800009fa:	4685                	li	a3,1
    800009fc:	8231                	srli	a2,a2,0xc
    800009fe:	4581                	li	a1,0
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	d0a080e7          	jalr	-758(ra) # 8000070a <uvmunmap>
    80000a08:	bfe1                	j	800009e0 <uvmfree+0xe>

0000000080000a0a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0a:	c679                	beqz	a2,80000ad8 <uvmcopy+0xce>
{
    80000a0c:	715d                	addi	sp,sp,-80
    80000a0e:	e486                	sd	ra,72(sp)
    80000a10:	e0a2                	sd	s0,64(sp)
    80000a12:	fc26                	sd	s1,56(sp)
    80000a14:	f84a                	sd	s2,48(sp)
    80000a16:	f44e                	sd	s3,40(sp)
    80000a18:	f052                	sd	s4,32(sp)
    80000a1a:	ec56                	sd	s5,24(sp)
    80000a1c:	e85a                	sd	s6,16(sp)
    80000a1e:	e45e                	sd	s7,8(sp)
    80000a20:	0880                	addi	s0,sp,80
    80000a22:	8b2a                	mv	s6,a0
    80000a24:	8aae                	mv	s5,a1
    80000a26:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2a:	4601                	li	a2,0
    80000a2c:	85ce                	mv	a1,s3
    80000a2e:	855a                	mv	a0,s6
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	a2c080e7          	jalr	-1492(ra) # 8000045c <walk>
    80000a38:	c531                	beqz	a0,80000a84 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3a:	6118                	ld	a4,0(a0)
    80000a3c:	00177793          	andi	a5,a4,1
    80000a40:	cbb1                	beqz	a5,80000a94 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a42:	00a75593          	srli	a1,a4,0xa
    80000a46:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	6ca080e7          	jalr	1738(ra) # 80000118 <kalloc>
    80000a56:	892a                	mv	s2,a0
    80000a58:	c939                	beqz	a0,80000aae <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	85de                	mv	a1,s7
    80000a5e:	fffff097          	auipc	ra,0xfffff
    80000a62:	776080e7          	jalr	1910(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a66:	8726                	mv	a4,s1
    80000a68:	86ca                	mv	a3,s2
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	85ce                	mv	a1,s3
    80000a6e:	8556                	mv	a0,s5
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	ad4080e7          	jalr	-1324(ra) # 80000544 <mappages>
    80000a78:	e515                	bnez	a0,80000aa4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	99be                	add	s3,s3,a5
    80000a7e:	fb49e6e3          	bltu	s3,s4,80000a2a <uvmcopy+0x20>
    80000a82:	a081                	j	80000ac2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a84:	00007517          	auipc	a0,0x7
    80000a88:	68450513          	addi	a0,a0,1668 # 80008108 <etext+0x108>
    80000a8c:	00005097          	auipc	ra,0x5
    80000a90:	3b2080e7          	jalr	946(ra) # 80005e3e <panic>
      panic("uvmcopy: page not present");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	69450513          	addi	a0,a0,1684 # 80008128 <etext+0x128>
    80000a9c:	00005097          	auipc	ra,0x5
    80000aa0:	3a2080e7          	jalr	930(ra) # 80005e3e <panic>
      kfree(mem);
    80000aa4:	854a                	mv	a0,s2
    80000aa6:	fffff097          	auipc	ra,0xfffff
    80000aaa:	576080e7          	jalr	1398(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aae:	4685                	li	a3,1
    80000ab0:	00c9d613          	srli	a2,s3,0xc
    80000ab4:	4581                	li	a1,0
    80000ab6:	8556                	mv	a0,s5
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	c52080e7          	jalr	-942(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac0:	557d                	li	a0,-1
}
    80000ac2:	60a6                	ld	ra,72(sp)
    80000ac4:	6406                	ld	s0,64(sp)
    80000ac6:	74e2                	ld	s1,56(sp)
    80000ac8:	7942                	ld	s2,48(sp)
    80000aca:	79a2                	ld	s3,40(sp)
    80000acc:	7a02                	ld	s4,32(sp)
    80000ace:	6ae2                	ld	s5,24(sp)
    80000ad0:	6b42                	ld	s6,16(sp)
    80000ad2:	6ba2                	ld	s7,8(sp)
    80000ad4:	6161                	addi	sp,sp,80
    80000ad6:	8082                	ret
  return 0;
    80000ad8:	4501                	li	a0,0
}
    80000ada:	8082                	ret

0000000080000adc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000adc:	1141                	addi	sp,sp,-16
    80000ade:	e406                	sd	ra,8(sp)
    80000ae0:	e022                	sd	s0,0(sp)
    80000ae2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae4:	4601                	li	a2,0
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	976080e7          	jalr	-1674(ra) # 8000045c <walk>
  if(pte == 0)
    80000aee:	c901                	beqz	a0,80000afe <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af0:	611c                	ld	a5,0(a0)
    80000af2:	9bbd                	andi	a5,a5,-17
    80000af4:	e11c                	sd	a5,0(a0)
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret
    panic("uvmclear");
    80000afe:	00007517          	auipc	a0,0x7
    80000b02:	64a50513          	addi	a0,a0,1610 # 80008148 <etext+0x148>
    80000b06:	00005097          	auipc	ra,0x5
    80000b0a:	338080e7          	jalr	824(ra) # 80005e3e <panic>

0000000080000b0e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0e:	c6bd                	beqz	a3,80000b7c <copyout+0x6e>
{
    80000b10:	715d                	addi	sp,sp,-80
    80000b12:	e486                	sd	ra,72(sp)
    80000b14:	e0a2                	sd	s0,64(sp)
    80000b16:	fc26                	sd	s1,56(sp)
    80000b18:	f84a                	sd	s2,48(sp)
    80000b1a:	f44e                	sd	s3,40(sp)
    80000b1c:	f052                	sd	s4,32(sp)
    80000b1e:	ec56                	sd	s5,24(sp)
    80000b20:	e85a                	sd	s6,16(sp)
    80000b22:	e45e                	sd	s7,8(sp)
    80000b24:	e062                	sd	s8,0(sp)
    80000b26:	0880                	addi	s0,sp,80
    80000b28:	8b2a                	mv	s6,a0
    80000b2a:	8c2e                	mv	s8,a1
    80000b2c:	8a32                	mv	s4,a2
    80000b2e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b30:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b32:	6a85                	lui	s5,0x1
    80000b34:	a015                	j	80000b58 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b36:	9562                	add	a0,a0,s8
    80000b38:	0004861b          	sext.w	a2,s1
    80000b3c:	85d2                	mv	a1,s4
    80000b3e:	41250533          	sub	a0,a0,s2
    80000b42:	fffff097          	auipc	ra,0xfffff
    80000b46:	692080e7          	jalr	1682(ra) # 800001d4 <memmove>

    len -= n;
    80000b4a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b50:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b54:	02098263          	beqz	s3,80000b78 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b58:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b5c:	85ca                	mv	a1,s2
    80000b5e:	855a                	mv	a0,s6
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9a2080e7          	jalr	-1630(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b68:	cd01                	beqz	a0,80000b80 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6a:	418904b3          	sub	s1,s2,s8
    80000b6e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b70:	fc99f3e3          	bgeu	s3,s1,80000b36 <copyout+0x28>
    80000b74:	84ce                	mv	s1,s3
    80000b76:	b7c1                	j	80000b36 <copyout+0x28>
  }
  return 0;
    80000b78:	4501                	li	a0,0
    80000b7a:	a021                	j	80000b82 <copyout+0x74>
    80000b7c:	4501                	li	a0,0
}
    80000b7e:	8082                	ret
      return -1;
    80000b80:	557d                	li	a0,-1
}
    80000b82:	60a6                	ld	ra,72(sp)
    80000b84:	6406                	ld	s0,64(sp)
    80000b86:	74e2                	ld	s1,56(sp)
    80000b88:	7942                	ld	s2,48(sp)
    80000b8a:	79a2                	ld	s3,40(sp)
    80000b8c:	7a02                	ld	s4,32(sp)
    80000b8e:	6ae2                	ld	s5,24(sp)
    80000b90:	6b42                	ld	s6,16(sp)
    80000b92:	6ba2                	ld	s7,8(sp)
    80000b94:	6c02                	ld	s8,0(sp)
    80000b96:	6161                	addi	sp,sp,80
    80000b98:	8082                	ret

0000000080000b9a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9a:	caa5                	beqz	a3,80000c0a <copyin+0x70>
{
    80000b9c:	715d                	addi	sp,sp,-80
    80000b9e:	e486                	sd	ra,72(sp)
    80000ba0:	e0a2                	sd	s0,64(sp)
    80000ba2:	fc26                	sd	s1,56(sp)
    80000ba4:	f84a                	sd	s2,48(sp)
    80000ba6:	f44e                	sd	s3,40(sp)
    80000ba8:	f052                	sd	s4,32(sp)
    80000baa:	ec56                	sd	s5,24(sp)
    80000bac:	e85a                	sd	s6,16(sp)
    80000bae:	e45e                	sd	s7,8(sp)
    80000bb0:	e062                	sd	s8,0(sp)
    80000bb2:	0880                	addi	s0,sp,80
    80000bb4:	8b2a                	mv	s6,a0
    80000bb6:	8a2e                	mv	s4,a1
    80000bb8:	8c32                	mv	s8,a2
    80000bba:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bbc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bbe:	6a85                	lui	s5,0x1
    80000bc0:	a01d                	j	80000be6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc2:	018505b3          	add	a1,a0,s8
    80000bc6:	0004861b          	sext.w	a2,s1
    80000bca:	412585b3          	sub	a1,a1,s2
    80000bce:	8552                	mv	a0,s4
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	604080e7          	jalr	1540(ra) # 800001d4 <memmove>

    len -= n;
    80000bd8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bdc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bde:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be2:	02098263          	beqz	s3,80000c06 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bea:	85ca                	mv	a1,s2
    80000bec:	855a                	mv	a0,s6
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	914080e7          	jalr	-1772(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bf6:	cd01                	beqz	a0,80000c0e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf8:	418904b3          	sub	s1,s2,s8
    80000bfc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bfe:	fc99f2e3          	bgeu	s3,s1,80000bc2 <copyin+0x28>
    80000c02:	84ce                	mv	s1,s3
    80000c04:	bf7d                	j	80000bc2 <copyin+0x28>
  }
  return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	a021                	j	80000c10 <copyin+0x76>
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret
      return -1;
    80000c0e:	557d                	li	a0,-1
}
    80000c10:	60a6                	ld	ra,72(sp)
    80000c12:	6406                	ld	s0,64(sp)
    80000c14:	74e2                	ld	s1,56(sp)
    80000c16:	7942                	ld	s2,48(sp)
    80000c18:	79a2                	ld	s3,40(sp)
    80000c1a:	7a02                	ld	s4,32(sp)
    80000c1c:	6ae2                	ld	s5,24(sp)
    80000c1e:	6b42                	ld	s6,16(sp)
    80000c20:	6ba2                	ld	s7,8(sp)
    80000c22:	6c02                	ld	s8,0(sp)
    80000c24:	6161                	addi	sp,sp,80
    80000c26:	8082                	ret

0000000080000c28 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c28:	c6c5                	beqz	a3,80000cd0 <copyinstr+0xa8>
{
    80000c2a:	715d                	addi	sp,sp,-80
    80000c2c:	e486                	sd	ra,72(sp)
    80000c2e:	e0a2                	sd	s0,64(sp)
    80000c30:	fc26                	sd	s1,56(sp)
    80000c32:	f84a                	sd	s2,48(sp)
    80000c34:	f44e                	sd	s3,40(sp)
    80000c36:	f052                	sd	s4,32(sp)
    80000c38:	ec56                	sd	s5,24(sp)
    80000c3a:	e85a                	sd	s6,16(sp)
    80000c3c:	e45e                	sd	s7,8(sp)
    80000c3e:	0880                	addi	s0,sp,80
    80000c40:	8a2a                	mv	s4,a0
    80000c42:	8b2e                	mv	s6,a1
    80000c44:	8bb2                	mv	s7,a2
    80000c46:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c48:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4a:	6985                	lui	s3,0x1
    80000c4c:	a035                	j	80000c78 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c4e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c52:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c54:	0017b793          	seqz	a5,a5
    80000c58:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5c:	60a6                	ld	ra,72(sp)
    80000c5e:	6406                	ld	s0,64(sp)
    80000c60:	74e2                	ld	s1,56(sp)
    80000c62:	7942                	ld	s2,48(sp)
    80000c64:	79a2                	ld	s3,40(sp)
    80000c66:	7a02                	ld	s4,32(sp)
    80000c68:	6ae2                	ld	s5,24(sp)
    80000c6a:	6b42                	ld	s6,16(sp)
    80000c6c:	6ba2                	ld	s7,8(sp)
    80000c6e:	6161                	addi	sp,sp,80
    80000c70:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c72:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c76:	c8a9                	beqz	s1,80000cc8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c78:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7c:	85ca                	mv	a1,s2
    80000c7e:	8552                	mv	a0,s4
    80000c80:	00000097          	auipc	ra,0x0
    80000c84:	882080e7          	jalr	-1918(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c88:	c131                	beqz	a0,80000ccc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c8a:	41790833          	sub	a6,s2,s7
    80000c8e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c90:	0104f363          	bgeu	s1,a6,80000c96 <copyinstr+0x6e>
    80000c94:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c96:	955e                	add	a0,a0,s7
    80000c98:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9c:	fc080be3          	beqz	a6,80000c72 <copyinstr+0x4a>
    80000ca0:	985a                	add	a6,a6,s6
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	14fd                	addi	s1,s1,-1
    80000caa:	9b26                	add	s6,s6,s1
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4)
    80000cb4:	df49                	beqz	a4,80000c4e <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      --max;
    80000cba:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cbe:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc0:	ff0796e3          	bne	a5,a6,80000cac <copyinstr+0x84>
      dst++;
    80000cc4:	8b42                	mv	s6,a6
    80000cc6:	b775                	j	80000c72 <copyinstr+0x4a>
    80000cc8:	4781                	li	a5,0
    80000cca:	b769                	j	80000c54 <copyinstr+0x2c>
      return -1;
    80000ccc:	557d                	li	a0,-1
    80000cce:	b779                	j	80000c5c <copyinstr+0x34>
  int got_null = 0;
    80000cd0:	4781                	li	a5,0
  if(got_null){
    80000cd2:	0017b793          	seqz	a5,a5
    80000cd6:	40f00533          	neg	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <_vmprint>:

void
_vmprint(pte_t *pte, int level)
{
  if (level == 3) {
    80000cdc:	478d                	li	a5,3
    80000cde:	0af58763          	beq	a1,a5,80000d8c <_vmprint+0xb0>
{
    80000ce2:	711d                	addi	sp,sp,-96
    80000ce4:	ec86                	sd	ra,88(sp)
    80000ce6:	e8a2                	sd	s0,80(sp)
    80000ce8:	e4a6                	sd	s1,72(sp)
    80000cea:	e0ca                	sd	s2,64(sp)
    80000cec:	fc4e                	sd	s3,56(sp)
    80000cee:	f852                	sd	s4,48(sp)
    80000cf0:	f456                	sd	s5,40(sp)
    80000cf2:	f05a                	sd	s6,32(sp)
    80000cf4:	ec5e                	sd	s7,24(sp)
    80000cf6:	e862                	sd	s8,16(sp)
    80000cf8:	e466                	sd	s9,8(sp)
    80000cfa:	e06a                	sd	s10,0(sp)
    80000cfc:	1080                	addi	s0,sp,96
    80000cfe:	8a2e                	mv	s4,a1
    80000d00:	892a                	mv	s2,a0
    return;
  }

  for (int i = 0; i < 512; i++) {
    80000d02:	4981                	li	s3,0
    if (pte[i]) {
      for (int j = 0; j <= level; j++)
        printf(" ..");
      printf("%d: pte %p pa %p\n", i, pte[i], PTE2PA(pte[i]));
    80000d04:	00007c97          	auipc	s9,0x7
    80000d08:	45cc8c93          	addi	s9,s9,1116 # 80008160 <etext+0x160>
      _vmprint((pte_t *)PTE2PA(pte[i]), level + 1);
    80000d0c:	00158c1b          	addiw	s8,a1,1
      for (int j = 0; j <= level; j++)
    80000d10:	4d01                	li	s10,0
        printf(" ..");
    80000d12:	00007a97          	auipc	s5,0x7
    80000d16:	446a8a93          	addi	s5,s5,1094 # 80008158 <etext+0x158>
  for (int i = 0; i < 512; i++) {
    80000d1a:	20000b93          	li	s7,512
    80000d1e:	a80d                	j	80000d50 <_vmprint+0x74>
      printf("%d: pte %p pa %p\n", i, pte[i], PTE2PA(pte[i]));
    80000d20:	000b3603          	ld	a2,0(s6) # 1000 <_entry-0x7ffff000>
    80000d24:	00a65693          	srli	a3,a2,0xa
    80000d28:	06b2                	slli	a3,a3,0xc
    80000d2a:	85ce                	mv	a1,s3
    80000d2c:	8566                	mv	a0,s9
    80000d2e:	00005097          	auipc	ra,0x5
    80000d32:	15a080e7          	jalr	346(ra) # 80005e88 <printf>
      _vmprint((pte_t *)PTE2PA(pte[i]), level + 1);
    80000d36:	000b3503          	ld	a0,0(s6)
    80000d3a:	8129                	srli	a0,a0,0xa
    80000d3c:	85e2                	mv	a1,s8
    80000d3e:	0532                	slli	a0,a0,0xc
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	f9c080e7          	jalr	-100(ra) # 80000cdc <_vmprint>
  for (int i = 0; i < 512; i++) {
    80000d48:	2985                	addiw	s3,s3,1
    80000d4a:	0921                	addi	s2,s2,8
    80000d4c:	03798263          	beq	s3,s7,80000d70 <_vmprint+0x94>
    if (pte[i]) {
    80000d50:	8b4a                	mv	s6,s2
    80000d52:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000d56:	dbed                	beqz	a5,80000d48 <_vmprint+0x6c>
      for (int j = 0; j <= level; j++)
    80000d58:	fc0a44e3          	bltz	s4,80000d20 <_vmprint+0x44>
    80000d5c:	84ea                	mv	s1,s10
        printf(" ..");
    80000d5e:	8556                	mv	a0,s5
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	128080e7          	jalr	296(ra) # 80005e88 <printf>
      for (int j = 0; j <= level; j++)
    80000d68:	2485                	addiw	s1,s1,1
    80000d6a:	fe9a5ae3          	bge	s4,s1,80000d5e <_vmprint+0x82>
    80000d6e:	bf4d                	j	80000d20 <_vmprint+0x44>
    }
  }
}
    80000d70:	60e6                	ld	ra,88(sp)
    80000d72:	6446                	ld	s0,80(sp)
    80000d74:	64a6                	ld	s1,72(sp)
    80000d76:	6906                	ld	s2,64(sp)
    80000d78:	79e2                	ld	s3,56(sp)
    80000d7a:	7a42                	ld	s4,48(sp)
    80000d7c:	7aa2                	ld	s5,40(sp)
    80000d7e:	7b02                	ld	s6,32(sp)
    80000d80:	6be2                	ld	s7,24(sp)
    80000d82:	6c42                	ld	s8,16(sp)
    80000d84:	6ca2                	ld	s9,8(sp)
    80000d86:	6d02                	ld	s10,0(sp)
    80000d88:	6125                	addi	sp,sp,96
    80000d8a:	8082                	ret
    80000d8c:	8082                	ret

0000000080000d8e <vmprint>:

void
vmprint(pagetable_t pgtbl)
{
    80000d8e:	1101                	addi	sp,sp,-32
    80000d90:	ec06                	sd	ra,24(sp)
    80000d92:	e822                	sd	s0,16(sp)
    80000d94:	e426                	sd	s1,8(sp)
    80000d96:	1000                	addi	s0,sp,32
    80000d98:	84aa                	mv	s1,a0
  printf("page table %p\n", pgtbl);
    80000d9a:	85aa                	mv	a1,a0
    80000d9c:	00007517          	auipc	a0,0x7
    80000da0:	3dc50513          	addi	a0,a0,988 # 80008178 <etext+0x178>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	0e4080e7          	jalr	228(ra) # 80005e88 <printf>
  _vmprint(pgtbl, 0);
    80000dac:	4581                	li	a1,0
    80000dae:	8526                	mv	a0,s1
    80000db0:	00000097          	auipc	ra,0x0
    80000db4:	f2c080e7          	jalr	-212(ra) # 80000cdc <_vmprint>
    80000db8:	60e2                	ld	ra,24(sp)
    80000dba:	6442                	ld	s0,16(sp)
    80000dbc:	64a2                	ld	s1,8(sp)
    80000dbe:	6105                	addi	sp,sp,32
    80000dc0:	8082                	ret

0000000080000dc2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dc2:	7139                	addi	sp,sp,-64
    80000dc4:	fc06                	sd	ra,56(sp)
    80000dc6:	f822                	sd	s0,48(sp)
    80000dc8:	f426                	sd	s1,40(sp)
    80000dca:	f04a                	sd	s2,32(sp)
    80000dcc:	ec4e                	sd	s3,24(sp)
    80000dce:	e852                	sd	s4,16(sp)
    80000dd0:	e456                	sd	s5,8(sp)
    80000dd2:	e05a                	sd	s6,0(sp)
    80000dd4:	0080                	addi	s0,sp,64
    80000dd6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	00008497          	auipc	s1,0x8
    80000ddc:	fb848493          	addi	s1,s1,-72 # 80008d90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000de0:	8b26                	mv	s6,s1
    80000de2:	00007a97          	auipc	s5,0x7
    80000de6:	21ea8a93          	addi	s5,s5,542 # 80008000 <etext>
    80000dea:	01000937          	lui	s2,0x1000
    80000dee:	197d                	addi	s2,s2,-1
    80000df0:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df2:	0000ea17          	auipc	s4,0xe
    80000df6:	b9ea0a13          	addi	s4,s4,-1122 # 8000e990 <tickslock>
    char *pa = kalloc();
    80000dfa:	fffff097          	auipc	ra,0xfffff
    80000dfe:	31e080e7          	jalr	798(ra) # 80000118 <kalloc>
    80000e02:	862a                	mv	a2,a0
    if(pa == 0)
    80000e04:	c129                	beqz	a0,80000e46 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e06:	416485b3          	sub	a1,s1,s6
    80000e0a:	8591                	srai	a1,a1,0x4
    80000e0c:	000ab783          	ld	a5,0(s5)
    80000e10:	02f585b3          	mul	a1,a1,a5
    80000e14:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e18:	4719                	li	a4,6
    80000e1a:	6685                	lui	a3,0x1
    80000e1c:	40b905b3          	sub	a1,s2,a1
    80000e20:	854e                	mv	a0,s3
    80000e22:	fffff097          	auipc	ra,0xfffff
    80000e26:	7c2080e7          	jalr	1986(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2a:	17048493          	addi	s1,s1,368
    80000e2e:	fd4496e3          	bne	s1,s4,80000dfa <proc_mapstacks+0x38>
  }
}
    80000e32:	70e2                	ld	ra,56(sp)
    80000e34:	7442                	ld	s0,48(sp)
    80000e36:	74a2                	ld	s1,40(sp)
    80000e38:	7902                	ld	s2,32(sp)
    80000e3a:	69e2                	ld	s3,24(sp)
    80000e3c:	6a42                	ld	s4,16(sp)
    80000e3e:	6aa2                	ld	s5,8(sp)
    80000e40:	6b02                	ld	s6,0(sp)
    80000e42:	6121                	addi	sp,sp,64
    80000e44:	8082                	ret
      panic("kalloc");
    80000e46:	00007517          	auipc	a0,0x7
    80000e4a:	34250513          	addi	a0,a0,834 # 80008188 <etext+0x188>
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	ff0080e7          	jalr	-16(ra) # 80005e3e <panic>

0000000080000e56 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e56:	7139                	addi	sp,sp,-64
    80000e58:	fc06                	sd	ra,56(sp)
    80000e5a:	f822                	sd	s0,48(sp)
    80000e5c:	f426                	sd	s1,40(sp)
    80000e5e:	f04a                	sd	s2,32(sp)
    80000e60:	ec4e                	sd	s3,24(sp)
    80000e62:	e852                	sd	s4,16(sp)
    80000e64:	e456                	sd	s5,8(sp)
    80000e66:	e05a                	sd	s6,0(sp)
    80000e68:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e6a:	00007597          	auipc	a1,0x7
    80000e6e:	32658593          	addi	a1,a1,806 # 80008190 <etext+0x190>
    80000e72:	00008517          	auipc	a0,0x8
    80000e76:	aee50513          	addi	a0,a0,-1298 # 80008960 <pid_lock>
    80000e7a:	00005097          	auipc	ra,0x5
    80000e7e:	470080e7          	jalr	1136(ra) # 800062ea <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e82:	00007597          	auipc	a1,0x7
    80000e86:	31658593          	addi	a1,a1,790 # 80008198 <etext+0x198>
    80000e8a:	00008517          	auipc	a0,0x8
    80000e8e:	aee50513          	addi	a0,a0,-1298 # 80008978 <wait_lock>
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	458080e7          	jalr	1112(ra) # 800062ea <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9a:	00008497          	auipc	s1,0x8
    80000e9e:	ef648493          	addi	s1,s1,-266 # 80008d90 <proc>
      initlock(&p->lock, "proc");
    80000ea2:	00007b17          	auipc	s6,0x7
    80000ea6:	306b0b13          	addi	s6,s6,774 # 800081a8 <etext+0x1a8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eaa:	8aa6                	mv	s5,s1
    80000eac:	00007a17          	auipc	s4,0x7
    80000eb0:	154a0a13          	addi	s4,s4,340 # 80008000 <etext>
    80000eb4:	01000937          	lui	s2,0x1000
    80000eb8:	197d                	addi	s2,s2,-1
    80000eba:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebc:	0000e997          	auipc	s3,0xe
    80000ec0:	ad498993          	addi	s3,s3,-1324 # 8000e990 <tickslock>
      initlock(&p->lock, "proc");
    80000ec4:	85da                	mv	a1,s6
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	422080e7          	jalr	1058(ra) # 800062ea <initlock>
      p->state = UNUSED;
    80000ed0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ed4:	415487b3          	sub	a5,s1,s5
    80000ed8:	8791                	srai	a5,a5,0x4
    80000eda:	000a3703          	ld	a4,0(s4)
    80000ede:	02e787b3          	mul	a5,a5,a4
    80000ee2:	00d7979b          	slliw	a5,a5,0xd
    80000ee6:	40f907b3          	sub	a5,s2,a5
    80000eea:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eec:	17048493          	addi	s1,s1,368
    80000ef0:	fd349ae3          	bne	s1,s3,80000ec4 <procinit+0x6e>
  }
}
    80000ef4:	70e2                	ld	ra,56(sp)
    80000ef6:	7442                	ld	s0,48(sp)
    80000ef8:	74a2                	ld	s1,40(sp)
    80000efa:	7902                	ld	s2,32(sp)
    80000efc:	69e2                	ld	s3,24(sp)
    80000efe:	6a42                	ld	s4,16(sp)
    80000f00:	6aa2                	ld	s5,8(sp)
    80000f02:	6b02                	ld	s6,0(sp)
    80000f04:	6121                	addi	sp,sp,64
    80000f06:	8082                	ret

0000000080000f08 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f08:	1141                	addi	sp,sp,-16
    80000f0a:	e422                	sd	s0,8(sp)
    80000f0c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f0e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f10:	2501                	sext.w	a0,a0
    80000f12:	6422                	ld	s0,8(sp)
    80000f14:	0141                	addi	sp,sp,16
    80000f16:	8082                	ret

0000000080000f18 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f18:	1141                	addi	sp,sp,-16
    80000f1a:	e422                	sd	s0,8(sp)
    80000f1c:	0800                	addi	s0,sp,16
    80000f1e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f20:	2781                	sext.w	a5,a5
    80000f22:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f24:	00008517          	auipc	a0,0x8
    80000f28:	a6c50513          	addi	a0,a0,-1428 # 80008990 <cpus>
    80000f2c:	953e                	add	a0,a0,a5
    80000f2e:	6422                	ld	s0,8(sp)
    80000f30:	0141                	addi	sp,sp,16
    80000f32:	8082                	ret

0000000080000f34 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f34:	1101                	addi	sp,sp,-32
    80000f36:	ec06                	sd	ra,24(sp)
    80000f38:	e822                	sd	s0,16(sp)
    80000f3a:	e426                	sd	s1,8(sp)
    80000f3c:	1000                	addi	s0,sp,32
  push_off();
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	3f0080e7          	jalr	1008(ra) # 8000632e <push_off>
    80000f46:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f48:	2781                	sext.w	a5,a5
    80000f4a:	079e                	slli	a5,a5,0x7
    80000f4c:	00008717          	auipc	a4,0x8
    80000f50:	a1470713          	addi	a4,a4,-1516 # 80008960 <pid_lock>
    80000f54:	97ba                	add	a5,a5,a4
    80000f56:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f58:	00005097          	auipc	ra,0x5
    80000f5c:	476080e7          	jalr	1142(ra) # 800063ce <pop_off>
  return p;
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret

0000000080000f6c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f6c:	1141                	addi	sp,sp,-16
    80000f6e:	e406                	sd	ra,8(sp)
    80000f70:	e022                	sd	s0,0(sp)
    80000f72:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	fc0080e7          	jalr	-64(ra) # 80000f34 <myproc>
    80000f7c:	00005097          	auipc	ra,0x5
    80000f80:	4b2080e7          	jalr	1202(ra) # 8000642e <release>

  if (first) {
    80000f84:	00008797          	auipc	a5,0x8
    80000f88:	93c7a783          	lw	a5,-1732(a5) # 800088c0 <first.1>
    80000f8c:	eb89                	bnez	a5,80000f9e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f8e:	00001097          	auipc	ra,0x1
    80000f92:	d08080e7          	jalr	-760(ra) # 80001c96 <usertrapret>
}
    80000f96:	60a2                	ld	ra,8(sp)
    80000f98:	6402                	ld	s0,0(sp)
    80000f9a:	0141                	addi	sp,sp,16
    80000f9c:	8082                	ret
    first = 0;
    80000f9e:	00008797          	auipc	a5,0x8
    80000fa2:	9207a123          	sw	zero,-1758(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80000fa6:	4505                	li	a0,1
    80000fa8:	00002097          	auipc	ra,0x2
    80000fac:	b56080e7          	jalr	-1194(ra) # 80002afe <fsinit>
    80000fb0:	bff9                	j	80000f8e <forkret+0x22>

0000000080000fb2 <allocpid>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fbe:	00008917          	auipc	s2,0x8
    80000fc2:	9a290913          	addi	s2,s2,-1630 # 80008960 <pid_lock>
    80000fc6:	854a                	mv	a0,s2
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	3b2080e7          	jalr	946(ra) # 8000637a <acquire>
  pid = nextpid;
    80000fd0:	00008797          	auipc	a5,0x8
    80000fd4:	8f478793          	addi	a5,a5,-1804 # 800088c4 <nextpid>
    80000fd8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fda:	0014871b          	addiw	a4,s1,1
    80000fde:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fe0:	854a                	mv	a0,s2
    80000fe2:	00005097          	auipc	ra,0x5
    80000fe6:	44c080e7          	jalr	1100(ra) # 8000642e <release>
}
    80000fea:	8526                	mv	a0,s1
    80000fec:	60e2                	ld	ra,24(sp)
    80000fee:	6442                	ld	s0,16(sp)
    80000ff0:	64a2                	ld	s1,8(sp)
    80000ff2:	6902                	ld	s2,0(sp)
    80000ff4:	6105                	addi	sp,sp,32
    80000ff6:	8082                	ret

0000000080000ff8 <proc_pagetable>:
{
    80000ff8:	1101                	addi	sp,sp,-32
    80000ffa:	ec06                	sd	ra,24(sp)
    80000ffc:	e822                	sd	s0,16(sp)
    80000ffe:	e426                	sd	s1,8(sp)
    80001000:	e04a                	sd	s2,0(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	7c8080e7          	jalr	1992(ra) # 800007ce <uvmcreate>
    8000100e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001010:	cd39                	beqz	a0,8000106e <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001012:	4729                	li	a4,10
    80001014:	00006697          	auipc	a3,0x6
    80001018:	fec68693          	addi	a3,a3,-20 # 80007000 <_trampoline>
    8000101c:	6605                	lui	a2,0x1
    8000101e:	040005b7          	lui	a1,0x4000
    80001022:	15fd                	addi	a1,a1,-1
    80001024:	05b2                	slli	a1,a1,0xc
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	51e080e7          	jalr	1310(ra) # 80000544 <mappages>
    8000102e:	04054763          	bltz	a0,8000107c <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001032:	4719                	li	a4,6
    80001034:	05893683          	ld	a3,88(s2)
    80001038:	6605                	lui	a2,0x1
    8000103a:	020005b7          	lui	a1,0x2000
    8000103e:	15fd                	addi	a1,a1,-1
    80001040:	05b6                	slli	a1,a1,0xd
    80001042:	8526                	mv	a0,s1
    80001044:	fffff097          	auipc	ra,0xfffff
    80001048:	500080e7          	jalr	1280(ra) # 80000544 <mappages>
    8000104c:	04054063          	bltz	a0,8000108c <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)p->usyscall, PTE_R | PTE_U) < 0) {
    80001050:	4749                	li	a4,18
    80001052:	06093683          	ld	a3,96(s2)
    80001056:	6605                	lui	a2,0x1
    80001058:	040005b7          	lui	a1,0x4000
    8000105c:	15f5                	addi	a1,a1,-3
    8000105e:	05b2                	slli	a1,a1,0xc
    80001060:	8526                	mv	a0,s1
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	4e2080e7          	jalr	1250(ra) # 80000544 <mappages>
    8000106a:	04054463          	bltz	a0,800010b2 <proc_pagetable+0xba>
}
    8000106e:	8526                	mv	a0,s1
    80001070:	60e2                	ld	ra,24(sp)
    80001072:	6442                	ld	s0,16(sp)
    80001074:	64a2                	ld	s1,8(sp)
    80001076:	6902                	ld	s2,0(sp)
    80001078:	6105                	addi	sp,sp,32
    8000107a:	8082                	ret
    uvmfree(pagetable, 0);
    8000107c:	4581                	li	a1,0
    8000107e:	8526                	mv	a0,s1
    80001080:	00000097          	auipc	ra,0x0
    80001084:	952080e7          	jalr	-1710(ra) # 800009d2 <uvmfree>
    return 0;
    80001088:	4481                	li	s1,0
    8000108a:	b7d5                	j	8000106e <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000108c:	4681                	li	a3,0
    8000108e:	4605                	li	a2,1
    80001090:	040005b7          	lui	a1,0x4000
    80001094:	15fd                	addi	a1,a1,-1
    80001096:	05b2                	slli	a1,a1,0xc
    80001098:	8526                	mv	a0,s1
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	670080e7          	jalr	1648(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    800010a2:	4581                	li	a1,0
    800010a4:	8526                	mv	a0,s1
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	92c080e7          	jalr	-1748(ra) # 800009d2 <uvmfree>
    return 0;
    800010ae:	4481                	li	s1,0
    800010b0:	bf7d                	j	8000106e <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b2:	4681                	li	a3,0
    800010b4:	4605                	li	a2,1
    800010b6:	040005b7          	lui	a1,0x4000
    800010ba:	15fd                	addi	a1,a1,-1
    800010bc:	05b2                	slli	a1,a1,0xc
    800010be:	8526                	mv	a0,s1
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	64a080e7          	jalr	1610(ra) # 8000070a <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010c8:	4681                	li	a3,0
    800010ca:	4605                	li	a2,1
    800010cc:	020005b7          	lui	a1,0x2000
    800010d0:	15fd                	addi	a1,a1,-1
    800010d2:	05b6                	slli	a1,a1,0xd
    800010d4:	8526                	mv	a0,s1
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	634080e7          	jalr	1588(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    800010de:	4581                	li	a1,0
    800010e0:	8526                	mv	a0,s1
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	8f0080e7          	jalr	-1808(ra) # 800009d2 <uvmfree>
    return 0;
    800010ea:	4481                	li	s1,0
    800010ec:	b749                	j	8000106e <proc_pagetable+0x76>

00000000800010ee <proc_freepagetable>:
{
    800010ee:	7179                	addi	sp,sp,-48
    800010f0:	f406                	sd	ra,40(sp)
    800010f2:	f022                	sd	s0,32(sp)
    800010f4:	ec26                	sd	s1,24(sp)
    800010f6:	e84a                	sd	s2,16(sp)
    800010f8:	e44e                	sd	s3,8(sp)
    800010fa:	1800                	addi	s0,sp,48
    800010fc:	84aa                	mv	s1,a0
    800010fe:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001100:	4681                	li	a3,0
    80001102:	4605                	li	a2,1
    80001104:	04000937          	lui	s2,0x4000
    80001108:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000110c:	05b2                	slli	a1,a1,0xc
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	5fc080e7          	jalr	1532(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	020005b7          	lui	a1,0x2000
    8000111e:	15fd                	addi	a1,a1,-1
    80001120:	05b6                	slli	a1,a1,0xd
    80001122:	8526                	mv	a0,s1
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	5e6080e7          	jalr	1510(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000112c:	4681                	li	a3,0
    8000112e:	4605                	li	a2,1
    80001130:	1975                	addi	s2,s2,-3
    80001132:	00c91593          	slli	a1,s2,0xc
    80001136:	8526                	mv	a0,s1
    80001138:	fffff097          	auipc	ra,0xfffff
    8000113c:	5d2080e7          	jalr	1490(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80001140:	85ce                	mv	a1,s3
    80001142:	8526                	mv	a0,s1
    80001144:	00000097          	auipc	ra,0x0
    80001148:	88e080e7          	jalr	-1906(ra) # 800009d2 <uvmfree>
}
    8000114c:	70a2                	ld	ra,40(sp)
    8000114e:	7402                	ld	s0,32(sp)
    80001150:	64e2                	ld	s1,24(sp)
    80001152:	6942                	ld	s2,16(sp)
    80001154:	69a2                	ld	s3,8(sp)
    80001156:	6145                	addi	sp,sp,48
    80001158:	8082                	ret

000000008000115a <freeproc>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	1000                	addi	s0,sp,32
    80001164:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001166:	6d28                	ld	a0,88(a0)
    80001168:	c509                	beqz	a0,80001172 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	eb2080e7          	jalr	-334(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001172:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    80001176:	70a8                	ld	a0,96(s1)
    80001178:	c509                	beqz	a0,80001182 <freeproc+0x28>
    kfree((void*)p->usyscall);
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	ea2080e7          	jalr	-350(ra) # 8000001c <kfree>
  p->usyscall = 0;
    80001182:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001186:	68a8                	ld	a0,80(s1)
    80001188:	c511                	beqz	a0,80001194 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    8000118a:	64ac                	ld	a1,72(s1)
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	f62080e7          	jalr	-158(ra) # 800010ee <proc_freepagetable>
  p->pagetable = 0;
    80001194:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001198:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000119c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011a0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011a4:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011a8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011ac:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011b0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011b4:	0004ac23          	sw	zero,24(s1)
}
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6105                	addi	sp,sp,32
    800011c0:	8082                	ret

00000000800011c2 <allocproc>:
{
    800011c2:	1101                	addi	sp,sp,-32
    800011c4:	ec06                	sd	ra,24(sp)
    800011c6:	e822                	sd	s0,16(sp)
    800011c8:	e426                	sd	s1,8(sp)
    800011ca:	e04a                	sd	s2,0(sp)
    800011cc:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ce:	00008497          	auipc	s1,0x8
    800011d2:	bc248493          	addi	s1,s1,-1086 # 80008d90 <proc>
    800011d6:	0000d917          	auipc	s2,0xd
    800011da:	7ba90913          	addi	s2,s2,1978 # 8000e990 <tickslock>
    acquire(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	00005097          	auipc	ra,0x5
    800011e4:	19a080e7          	jalr	410(ra) # 8000637a <acquire>
    if(p->state == UNUSED) {
    800011e8:	4c9c                	lw	a5,24(s1)
    800011ea:	cf81                	beqz	a5,80001202 <allocproc+0x40>
      release(&p->lock);
    800011ec:	8526                	mv	a0,s1
    800011ee:	00005097          	auipc	ra,0x5
    800011f2:	240080e7          	jalr	576(ra) # 8000642e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f6:	17048493          	addi	s1,s1,368
    800011fa:	ff2492e3          	bne	s1,s2,800011de <allocproc+0x1c>
  return 0;
    800011fe:	4481                	li	s1,0
    80001200:	a095                	j	80001264 <allocproc+0xa2>
  p->pid = allocpid();
    80001202:	00000097          	auipc	ra,0x0
    80001206:	db0080e7          	jalr	-592(ra) # 80000fb2 <allocpid>
    8000120a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000120c:	4785                	li	a5,1
    8000120e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	f08080e7          	jalr	-248(ra) # 80000118 <kalloc>
    80001218:	892a                	mv	s2,a0
    8000121a:	eca8                	sd	a0,88(s1)
    8000121c:	c939                	beqz	a0,80001272 <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0) {
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	efa080e7          	jalr	-262(ra) # 80000118 <kalloc>
    80001226:	892a                	mv	s2,a0
    80001228:	f0a8                	sd	a0,96(s1)
    8000122a:	c125                	beqz	a0,8000128a <allocproc+0xc8>
  p->usyscall->pid = p->pid;
    8000122c:	589c                	lw	a5,48(s1)
    8000122e:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	dc6080e7          	jalr	-570(ra) # 80000ff8 <proc_pagetable>
    8000123a:	892a                	mv	s2,a0
    8000123c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000123e:	c135                	beqz	a0,800012a2 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001240:	07000613          	li	a2,112
    80001244:	4581                	li	a1,0
    80001246:	06848513          	addi	a0,s1,104
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	f2e080e7          	jalr	-210(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001252:	00000797          	auipc	a5,0x0
    80001256:	d1a78793          	addi	a5,a5,-742 # 80000f6c <forkret>
    8000125a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000125c:	60bc                	ld	a5,64(s1)
    8000125e:	6705                	lui	a4,0x1
    80001260:	97ba                	add	a5,a5,a4
    80001262:	f8bc                	sd	a5,112(s1)
}
    80001264:	8526                	mv	a0,s1
    80001266:	60e2                	ld	ra,24(sp)
    80001268:	6442                	ld	s0,16(sp)
    8000126a:	64a2                	ld	s1,8(sp)
    8000126c:	6902                	ld	s2,0(sp)
    8000126e:	6105                	addi	sp,sp,32
    80001270:	8082                	ret
    freeproc(p);
    80001272:	8526                	mv	a0,s1
    80001274:	00000097          	auipc	ra,0x0
    80001278:	ee6080e7          	jalr	-282(ra) # 8000115a <freeproc>
    release(&p->lock);
    8000127c:	8526                	mv	a0,s1
    8000127e:	00005097          	auipc	ra,0x5
    80001282:	1b0080e7          	jalr	432(ra) # 8000642e <release>
    return 0;
    80001286:	84ca                	mv	s1,s2
    80001288:	bff1                	j	80001264 <allocproc+0xa2>
    freeproc(p);
    8000128a:	8526                	mv	a0,s1
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	ece080e7          	jalr	-306(ra) # 8000115a <freeproc>
    release(&p->lock);
    80001294:	8526                	mv	a0,s1
    80001296:	00005097          	auipc	ra,0x5
    8000129a:	198080e7          	jalr	408(ra) # 8000642e <release>
    return 0;
    8000129e:	84ca                	mv	s1,s2
    800012a0:	b7d1                	j	80001264 <allocproc+0xa2>
    freeproc(p);
    800012a2:	8526                	mv	a0,s1
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	eb6080e7          	jalr	-330(ra) # 8000115a <freeproc>
    release(&p->lock);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	180080e7          	jalr	384(ra) # 8000642e <release>
    return 0;
    800012b6:	84ca                	mv	s1,s2
    800012b8:	b775                	j	80001264 <allocproc+0xa2>

00000000800012ba <userinit>:
{
    800012ba:	1101                	addi	sp,sp,-32
    800012bc:	ec06                	sd	ra,24(sp)
    800012be:	e822                	sd	s0,16(sp)
    800012c0:	e426                	sd	s1,8(sp)
    800012c2:	1000                	addi	s0,sp,32
  p = allocproc();
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	efe080e7          	jalr	-258(ra) # 800011c2 <allocproc>
    800012cc:	84aa                	mv	s1,a0
  initproc = p;
    800012ce:	00007797          	auipc	a5,0x7
    800012d2:	64a7b923          	sd	a0,1618(a5) # 80008920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012d6:	03400613          	li	a2,52
    800012da:	00007597          	auipc	a1,0x7
    800012de:	5f658593          	addi	a1,a1,1526 # 800088d0 <initcode>
    800012e2:	6928                	ld	a0,80(a0)
    800012e4:	fffff097          	auipc	ra,0xfffff
    800012e8:	518080e7          	jalr	1304(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    800012ec:	6785                	lui	a5,0x1
    800012ee:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012f0:	6cb8                	ld	a4,88(s1)
    800012f2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012f6:	6cb8                	ld	a4,88(s1)
    800012f8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012fa:	4641                	li	a2,16
    800012fc:	00007597          	auipc	a1,0x7
    80001300:	eb458593          	addi	a1,a1,-332 # 800081b0 <etext+0x1b0>
    80001304:	16048513          	addi	a0,s1,352
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	fba080e7          	jalr	-70(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001310:	00007517          	auipc	a0,0x7
    80001314:	eb050513          	addi	a0,a0,-336 # 800081c0 <etext+0x1c0>
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	208080e7          	jalr	520(ra) # 80003520 <namei>
    80001320:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001324:	478d                	li	a5,3
    80001326:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	104080e7          	jalr	260(ra) # 8000642e <release>
}
    80001332:	60e2                	ld	ra,24(sp)
    80001334:	6442                	ld	s0,16(sp)
    80001336:	64a2                	ld	s1,8(sp)
    80001338:	6105                	addi	sp,sp,32
    8000133a:	8082                	ret

000000008000133c <growproc>:
{
    8000133c:	1101                	addi	sp,sp,-32
    8000133e:	ec06                	sd	ra,24(sp)
    80001340:	e822                	sd	s0,16(sp)
    80001342:	e426                	sd	s1,8(sp)
    80001344:	e04a                	sd	s2,0(sp)
    80001346:	1000                	addi	s0,sp,32
    80001348:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000134a:	00000097          	auipc	ra,0x0
    8000134e:	bea080e7          	jalr	-1046(ra) # 80000f34 <myproc>
    80001352:	84aa                	mv	s1,a0
  sz = p->sz;
    80001354:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001356:	01204c63          	bgtz	s2,8000136e <growproc+0x32>
  } else if(n < 0){
    8000135a:	02094663          	bltz	s2,80001386 <growproc+0x4a>
  p->sz = sz;
    8000135e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001360:	4501                	li	a0,0
}
    80001362:	60e2                	ld	ra,24(sp)
    80001364:	6442                	ld	s0,16(sp)
    80001366:	64a2                	ld	s1,8(sp)
    80001368:	6902                	ld	s2,0(sp)
    8000136a:	6105                	addi	sp,sp,32
    8000136c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000136e:	4691                	li	a3,4
    80001370:	00b90633          	add	a2,s2,a1
    80001374:	6928                	ld	a0,80(a0)
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	540080e7          	jalr	1344(ra) # 800008b6 <uvmalloc>
    8000137e:	85aa                	mv	a1,a0
    80001380:	fd79                	bnez	a0,8000135e <growproc+0x22>
      return -1;
    80001382:	557d                	li	a0,-1
    80001384:	bff9                	j	80001362 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001386:	00b90633          	add	a2,s2,a1
    8000138a:	6928                	ld	a0,80(a0)
    8000138c:	fffff097          	auipc	ra,0xfffff
    80001390:	4e2080e7          	jalr	1250(ra) # 8000086e <uvmdealloc>
    80001394:	85aa                	mv	a1,a0
    80001396:	b7e1                	j	8000135e <growproc+0x22>

0000000080001398 <fork>:
{
    80001398:	7139                	addi	sp,sp,-64
    8000139a:	fc06                	sd	ra,56(sp)
    8000139c:	f822                	sd	s0,48(sp)
    8000139e:	f426                	sd	s1,40(sp)
    800013a0:	f04a                	sd	s2,32(sp)
    800013a2:	ec4e                	sd	s3,24(sp)
    800013a4:	e852                	sd	s4,16(sp)
    800013a6:	e456                	sd	s5,8(sp)
    800013a8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013aa:	00000097          	auipc	ra,0x0
    800013ae:	b8a080e7          	jalr	-1142(ra) # 80000f34 <myproc>
    800013b2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	e0e080e7          	jalr	-498(ra) # 800011c2 <allocproc>
    800013bc:	10050c63          	beqz	a0,800014d4 <fork+0x13c>
    800013c0:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013c2:	048ab603          	ld	a2,72(s5)
    800013c6:	692c                	ld	a1,80(a0)
    800013c8:	050ab503          	ld	a0,80(s5)
    800013cc:	fffff097          	auipc	ra,0xfffff
    800013d0:	63e080e7          	jalr	1598(ra) # 80000a0a <uvmcopy>
    800013d4:	04054863          	bltz	a0,80001424 <fork+0x8c>
  np->sz = p->sz;
    800013d8:	048ab783          	ld	a5,72(s5)
    800013dc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013e0:	058ab683          	ld	a3,88(s5)
    800013e4:	87b6                	mv	a5,a3
    800013e6:	058a3703          	ld	a4,88(s4)
    800013ea:	12068693          	addi	a3,a3,288
    800013ee:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013f2:	6788                	ld	a0,8(a5)
    800013f4:	6b8c                	ld	a1,16(a5)
    800013f6:	6f90                	ld	a2,24(a5)
    800013f8:	01073023          	sd	a6,0(a4)
    800013fc:	e708                	sd	a0,8(a4)
    800013fe:	eb0c                	sd	a1,16(a4)
    80001400:	ef10                	sd	a2,24(a4)
    80001402:	02078793          	addi	a5,a5,32
    80001406:	02070713          	addi	a4,a4,32
    8000140a:	fed792e3          	bne	a5,a3,800013ee <fork+0x56>
  np->trapframe->a0 = 0;
    8000140e:	058a3783          	ld	a5,88(s4)
    80001412:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001416:	0d8a8493          	addi	s1,s5,216
    8000141a:	0d8a0913          	addi	s2,s4,216
    8000141e:	158a8993          	addi	s3,s5,344
    80001422:	a00d                	j	80001444 <fork+0xac>
    freeproc(np);
    80001424:	8552                	mv	a0,s4
    80001426:	00000097          	auipc	ra,0x0
    8000142a:	d34080e7          	jalr	-716(ra) # 8000115a <freeproc>
    release(&np->lock);
    8000142e:	8552                	mv	a0,s4
    80001430:	00005097          	auipc	ra,0x5
    80001434:	ffe080e7          	jalr	-2(ra) # 8000642e <release>
    return -1;
    80001438:	597d                	li	s2,-1
    8000143a:	a059                	j	800014c0 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000143c:	04a1                	addi	s1,s1,8
    8000143e:	0921                	addi	s2,s2,8
    80001440:	01348b63          	beq	s1,s3,80001456 <fork+0xbe>
    if(p->ofile[i])
    80001444:	6088                	ld	a0,0(s1)
    80001446:	d97d                	beqz	a0,8000143c <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001448:	00002097          	auipc	ra,0x2
    8000144c:	76e080e7          	jalr	1902(ra) # 80003bb6 <filedup>
    80001450:	00a93023          	sd	a0,0(s2)
    80001454:	b7e5                	j	8000143c <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001456:	158ab503          	ld	a0,344(s5)
    8000145a:	00002097          	auipc	ra,0x2
    8000145e:	8e2080e7          	jalr	-1822(ra) # 80002d3c <idup>
    80001462:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001466:	4641                	li	a2,16
    80001468:	160a8593          	addi	a1,s5,352
    8000146c:	160a0513          	addi	a0,s4,352
    80001470:	fffff097          	auipc	ra,0xfffff
    80001474:	e52080e7          	jalr	-430(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001478:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000147c:	8552                	mv	a0,s4
    8000147e:	00005097          	auipc	ra,0x5
    80001482:	fb0080e7          	jalr	-80(ra) # 8000642e <release>
  acquire(&wait_lock);
    80001486:	00007497          	auipc	s1,0x7
    8000148a:	4f248493          	addi	s1,s1,1266 # 80008978 <wait_lock>
    8000148e:	8526                	mv	a0,s1
    80001490:	00005097          	auipc	ra,0x5
    80001494:	eea080e7          	jalr	-278(ra) # 8000637a <acquire>
  np->parent = p;
    80001498:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000149c:	8526                	mv	a0,s1
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	f90080e7          	jalr	-112(ra) # 8000642e <release>
  acquire(&np->lock);
    800014a6:	8552                	mv	a0,s4
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	ed2080e7          	jalr	-302(ra) # 8000637a <acquire>
  np->state = RUNNABLE;
    800014b0:	478d                	li	a5,3
    800014b2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014b6:	8552                	mv	a0,s4
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	f76080e7          	jalr	-138(ra) # 8000642e <release>
}
    800014c0:	854a                	mv	a0,s2
    800014c2:	70e2                	ld	ra,56(sp)
    800014c4:	7442                	ld	s0,48(sp)
    800014c6:	74a2                	ld	s1,40(sp)
    800014c8:	7902                	ld	s2,32(sp)
    800014ca:	69e2                	ld	s3,24(sp)
    800014cc:	6a42                	ld	s4,16(sp)
    800014ce:	6aa2                	ld	s5,8(sp)
    800014d0:	6121                	addi	sp,sp,64
    800014d2:	8082                	ret
    return -1;
    800014d4:	597d                	li	s2,-1
    800014d6:	b7ed                	j	800014c0 <fork+0x128>

00000000800014d8 <scheduler>:
{
    800014d8:	7139                	addi	sp,sp,-64
    800014da:	fc06                	sd	ra,56(sp)
    800014dc:	f822                	sd	s0,48(sp)
    800014de:	f426                	sd	s1,40(sp)
    800014e0:	f04a                	sd	s2,32(sp)
    800014e2:	ec4e                	sd	s3,24(sp)
    800014e4:	e852                	sd	s4,16(sp)
    800014e6:	e456                	sd	s5,8(sp)
    800014e8:	e05a                	sd	s6,0(sp)
    800014ea:	0080                	addi	s0,sp,64
    800014ec:	8792                	mv	a5,tp
  int id = r_tp();
    800014ee:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014f0:	00779a93          	slli	s5,a5,0x7
    800014f4:	00007717          	auipc	a4,0x7
    800014f8:	46c70713          	addi	a4,a4,1132 # 80008960 <pid_lock>
    800014fc:	9756                	add	a4,a4,s5
    800014fe:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001502:	00007717          	auipc	a4,0x7
    80001506:	49670713          	addi	a4,a4,1174 # 80008998 <cpus+0x8>
    8000150a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000150c:	498d                	li	s3,3
        p->state = RUNNING;
    8000150e:	4b11                	li	s6,4
        c->proc = p;
    80001510:	079e                	slli	a5,a5,0x7
    80001512:	00007a17          	auipc	s4,0x7
    80001516:	44ea0a13          	addi	s4,s4,1102 # 80008960 <pid_lock>
    8000151a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000151c:	0000d917          	auipc	s2,0xd
    80001520:	47490913          	addi	s2,s2,1140 # 8000e990 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001524:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001528:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000152c:	10079073          	csrw	sstatus,a5
    80001530:	00008497          	auipc	s1,0x8
    80001534:	86048493          	addi	s1,s1,-1952 # 80008d90 <proc>
    80001538:	a811                	j	8000154c <scheduler+0x74>
      release(&p->lock);
    8000153a:	8526                	mv	a0,s1
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	ef2080e7          	jalr	-270(ra) # 8000642e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001544:	17048493          	addi	s1,s1,368
    80001548:	fd248ee3          	beq	s1,s2,80001524 <scheduler+0x4c>
      acquire(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	e2c080e7          	jalr	-468(ra) # 8000637a <acquire>
      if(p->state == RUNNABLE) {
    80001556:	4c9c                	lw	a5,24(s1)
    80001558:	ff3791e3          	bne	a5,s3,8000153a <scheduler+0x62>
        p->state = RUNNING;
    8000155c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001560:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001564:	06848593          	addi	a1,s1,104
    80001568:	8556                	mv	a0,s5
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	682080e7          	jalr	1666(ra) # 80001bec <swtch>
        c->proc = 0;
    80001572:	020a3823          	sd	zero,48(s4)
    80001576:	b7d1                	j	8000153a <scheduler+0x62>

0000000080001578 <sched>:
{
    80001578:	7179                	addi	sp,sp,-48
    8000157a:	f406                	sd	ra,40(sp)
    8000157c:	f022                	sd	s0,32(sp)
    8000157e:	ec26                	sd	s1,24(sp)
    80001580:	e84a                	sd	s2,16(sp)
    80001582:	e44e                	sd	s3,8(sp)
    80001584:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	9ae080e7          	jalr	-1618(ra) # 80000f34 <myproc>
    8000158e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001590:	00005097          	auipc	ra,0x5
    80001594:	d70080e7          	jalr	-656(ra) # 80006300 <holding>
    80001598:	c93d                	beqz	a0,8000160e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000159a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000159c:	2781                	sext.w	a5,a5
    8000159e:	079e                	slli	a5,a5,0x7
    800015a0:	00007717          	auipc	a4,0x7
    800015a4:	3c070713          	addi	a4,a4,960 # 80008960 <pid_lock>
    800015a8:	97ba                	add	a5,a5,a4
    800015aa:	0a87a703          	lw	a4,168(a5)
    800015ae:	4785                	li	a5,1
    800015b0:	06f71763          	bne	a4,a5,8000161e <sched+0xa6>
  if(p->state == RUNNING)
    800015b4:	4c98                	lw	a4,24(s1)
    800015b6:	4791                	li	a5,4
    800015b8:	06f70b63          	beq	a4,a5,8000162e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015c0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015c2:	efb5                	bnez	a5,8000163e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015c4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015c6:	00007917          	auipc	s2,0x7
    800015ca:	39a90913          	addi	s2,s2,922 # 80008960 <pid_lock>
    800015ce:	2781                	sext.w	a5,a5
    800015d0:	079e                	slli	a5,a5,0x7
    800015d2:	97ca                	add	a5,a5,s2
    800015d4:	0ac7a983          	lw	s3,172(a5)
    800015d8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015da:	2781                	sext.w	a5,a5
    800015dc:	079e                	slli	a5,a5,0x7
    800015de:	00007597          	auipc	a1,0x7
    800015e2:	3ba58593          	addi	a1,a1,954 # 80008998 <cpus+0x8>
    800015e6:	95be                	add	a1,a1,a5
    800015e8:	06848513          	addi	a0,s1,104
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	600080e7          	jalr	1536(ra) # 80001bec <swtch>
    800015f4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015f6:	2781                	sext.w	a5,a5
    800015f8:	079e                	slli	a5,a5,0x7
    800015fa:	97ca                	add	a5,a5,s2
    800015fc:	0b37a623          	sw	s3,172(a5)
}
    80001600:	70a2                	ld	ra,40(sp)
    80001602:	7402                	ld	s0,32(sp)
    80001604:	64e2                	ld	s1,24(sp)
    80001606:	6942                	ld	s2,16(sp)
    80001608:	69a2                	ld	s3,8(sp)
    8000160a:	6145                	addi	sp,sp,48
    8000160c:	8082                	ret
    panic("sched p->lock");
    8000160e:	00007517          	auipc	a0,0x7
    80001612:	bba50513          	addi	a0,a0,-1094 # 800081c8 <etext+0x1c8>
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	828080e7          	jalr	-2008(ra) # 80005e3e <panic>
    panic("sched locks");
    8000161e:	00007517          	auipc	a0,0x7
    80001622:	bba50513          	addi	a0,a0,-1094 # 800081d8 <etext+0x1d8>
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	818080e7          	jalr	-2024(ra) # 80005e3e <panic>
    panic("sched running");
    8000162e:	00007517          	auipc	a0,0x7
    80001632:	bba50513          	addi	a0,a0,-1094 # 800081e8 <etext+0x1e8>
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	808080e7          	jalr	-2040(ra) # 80005e3e <panic>
    panic("sched interruptible");
    8000163e:	00007517          	auipc	a0,0x7
    80001642:	bba50513          	addi	a0,a0,-1094 # 800081f8 <etext+0x1f8>
    80001646:	00004097          	auipc	ra,0x4
    8000164a:	7f8080e7          	jalr	2040(ra) # 80005e3e <panic>

000000008000164e <yield>:
{
    8000164e:	1101                	addi	sp,sp,-32
    80001650:	ec06                	sd	ra,24(sp)
    80001652:	e822                	sd	s0,16(sp)
    80001654:	e426                	sd	s1,8(sp)
    80001656:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	8dc080e7          	jalr	-1828(ra) # 80000f34 <myproc>
    80001660:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001662:	00005097          	auipc	ra,0x5
    80001666:	d18080e7          	jalr	-744(ra) # 8000637a <acquire>
  p->state = RUNNABLE;
    8000166a:	478d                	li	a5,3
    8000166c:	cc9c                	sw	a5,24(s1)
  sched();
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	f0a080e7          	jalr	-246(ra) # 80001578 <sched>
  release(&p->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	db6080e7          	jalr	-586(ra) # 8000642e <release>
}
    80001680:	60e2                	ld	ra,24(sp)
    80001682:	6442                	ld	s0,16(sp)
    80001684:	64a2                	ld	s1,8(sp)
    80001686:	6105                	addi	sp,sp,32
    80001688:	8082                	ret

000000008000168a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000168a:	7179                	addi	sp,sp,-48
    8000168c:	f406                	sd	ra,40(sp)
    8000168e:	f022                	sd	s0,32(sp)
    80001690:	ec26                	sd	s1,24(sp)
    80001692:	e84a                	sd	s2,16(sp)
    80001694:	e44e                	sd	s3,8(sp)
    80001696:	1800                	addi	s0,sp,48
    80001698:	89aa                	mv	s3,a0
    8000169a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000169c:	00000097          	auipc	ra,0x0
    800016a0:	898080e7          	jalr	-1896(ra) # 80000f34 <myproc>
    800016a4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	cd4080e7          	jalr	-812(ra) # 8000637a <acquire>
  release(lk);
    800016ae:	854a                	mv	a0,s2
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	d7e080e7          	jalr	-642(ra) # 8000642e <release>

  // Go to sleep.
  p->chan = chan;
    800016b8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016bc:	4789                	li	a5,2
    800016be:	cc9c                	sw	a5,24(s1)

  sched();
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	eb8080e7          	jalr	-328(ra) # 80001578 <sched>

  // Tidy up.
  p->chan = 0;
    800016c8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	d60080e7          	jalr	-672(ra) # 8000642e <release>
  acquire(lk);
    800016d6:	854a                	mv	a0,s2
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	ca2080e7          	jalr	-862(ra) # 8000637a <acquire>
}
    800016e0:	70a2                	ld	ra,40(sp)
    800016e2:	7402                	ld	s0,32(sp)
    800016e4:	64e2                	ld	s1,24(sp)
    800016e6:	6942                	ld	s2,16(sp)
    800016e8:	69a2                	ld	s3,8(sp)
    800016ea:	6145                	addi	sp,sp,48
    800016ec:	8082                	ret

00000000800016ee <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ee:	7139                	addi	sp,sp,-64
    800016f0:	fc06                	sd	ra,56(sp)
    800016f2:	f822                	sd	s0,48(sp)
    800016f4:	f426                	sd	s1,40(sp)
    800016f6:	f04a                	sd	s2,32(sp)
    800016f8:	ec4e                	sd	s3,24(sp)
    800016fa:	e852                	sd	s4,16(sp)
    800016fc:	e456                	sd	s5,8(sp)
    800016fe:	0080                	addi	s0,sp,64
    80001700:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	00007497          	auipc	s1,0x7
    80001706:	68e48493          	addi	s1,s1,1678 # 80008d90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000170a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000170c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170e:	0000d917          	auipc	s2,0xd
    80001712:	28290913          	addi	s2,s2,642 # 8000e990 <tickslock>
    80001716:	a811                	j	8000172a <wakeup+0x3c>
      }
      release(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	d14080e7          	jalr	-748(ra) # 8000642e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	17048493          	addi	s1,s1,368
    80001726:	03248663          	beq	s1,s2,80001752 <wakeup+0x64>
    if(p != myproc()){
    8000172a:	00000097          	auipc	ra,0x0
    8000172e:	80a080e7          	jalr	-2038(ra) # 80000f34 <myproc>
    80001732:	fea488e3          	beq	s1,a0,80001722 <wakeup+0x34>
      acquire(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	c42080e7          	jalr	-958(ra) # 8000637a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001740:	4c9c                	lw	a5,24(s1)
    80001742:	fd379be3          	bne	a5,s3,80001718 <wakeup+0x2a>
    80001746:	709c                	ld	a5,32(s1)
    80001748:	fd4798e3          	bne	a5,s4,80001718 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000174c:	0154ac23          	sw	s5,24(s1)
    80001750:	b7e1                	j	80001718 <wakeup+0x2a>
    }
  }
}
    80001752:	70e2                	ld	ra,56(sp)
    80001754:	7442                	ld	s0,48(sp)
    80001756:	74a2                	ld	s1,40(sp)
    80001758:	7902                	ld	s2,32(sp)
    8000175a:	69e2                	ld	s3,24(sp)
    8000175c:	6a42                	ld	s4,16(sp)
    8000175e:	6aa2                	ld	s5,8(sp)
    80001760:	6121                	addi	sp,sp,64
    80001762:	8082                	ret

0000000080001764 <reparent>:
{
    80001764:	7179                	addi	sp,sp,-48
    80001766:	f406                	sd	ra,40(sp)
    80001768:	f022                	sd	s0,32(sp)
    8000176a:	ec26                	sd	s1,24(sp)
    8000176c:	e84a                	sd	s2,16(sp)
    8000176e:	e44e                	sd	s3,8(sp)
    80001770:	e052                	sd	s4,0(sp)
    80001772:	1800                	addi	s0,sp,48
    80001774:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001776:	00007497          	auipc	s1,0x7
    8000177a:	61a48493          	addi	s1,s1,1562 # 80008d90 <proc>
      pp->parent = initproc;
    8000177e:	00007a17          	auipc	s4,0x7
    80001782:	1a2a0a13          	addi	s4,s4,418 # 80008920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001786:	0000d997          	auipc	s3,0xd
    8000178a:	20a98993          	addi	s3,s3,522 # 8000e990 <tickslock>
    8000178e:	a029                	j	80001798 <reparent+0x34>
    80001790:	17048493          	addi	s1,s1,368
    80001794:	01348d63          	beq	s1,s3,800017ae <reparent+0x4a>
    if(pp->parent == p){
    80001798:	7c9c                	ld	a5,56(s1)
    8000179a:	ff279be3          	bne	a5,s2,80001790 <reparent+0x2c>
      pp->parent = initproc;
    8000179e:	000a3503          	ld	a0,0(s4)
    800017a2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	f4a080e7          	jalr	-182(ra) # 800016ee <wakeup>
    800017ac:	b7d5                	j	80001790 <reparent+0x2c>
}
    800017ae:	70a2                	ld	ra,40(sp)
    800017b0:	7402                	ld	s0,32(sp)
    800017b2:	64e2                	ld	s1,24(sp)
    800017b4:	6942                	ld	s2,16(sp)
    800017b6:	69a2                	ld	s3,8(sp)
    800017b8:	6a02                	ld	s4,0(sp)
    800017ba:	6145                	addi	sp,sp,48
    800017bc:	8082                	ret

00000000800017be <exit>:
{
    800017be:	7179                	addi	sp,sp,-48
    800017c0:	f406                	sd	ra,40(sp)
    800017c2:	f022                	sd	s0,32(sp)
    800017c4:	ec26                	sd	s1,24(sp)
    800017c6:	e84a                	sd	s2,16(sp)
    800017c8:	e44e                	sd	s3,8(sp)
    800017ca:	e052                	sd	s4,0(sp)
    800017cc:	1800                	addi	s0,sp,48
    800017ce:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017d0:	fffff097          	auipc	ra,0xfffff
    800017d4:	764080e7          	jalr	1892(ra) # 80000f34 <myproc>
    800017d8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017da:	00007797          	auipc	a5,0x7
    800017de:	1467b783          	ld	a5,326(a5) # 80008920 <initproc>
    800017e2:	0d850493          	addi	s1,a0,216
    800017e6:	15850913          	addi	s2,a0,344
    800017ea:	02a79363          	bne	a5,a0,80001810 <exit+0x52>
    panic("init exiting");
    800017ee:	00007517          	auipc	a0,0x7
    800017f2:	a2250513          	addi	a0,a0,-1502 # 80008210 <etext+0x210>
    800017f6:	00004097          	auipc	ra,0x4
    800017fa:	648080e7          	jalr	1608(ra) # 80005e3e <panic>
      fileclose(f);
    800017fe:	00002097          	auipc	ra,0x2
    80001802:	40a080e7          	jalr	1034(ra) # 80003c08 <fileclose>
      p->ofile[fd] = 0;
    80001806:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000180a:	04a1                	addi	s1,s1,8
    8000180c:	01248563          	beq	s1,s2,80001816 <exit+0x58>
    if(p->ofile[fd]){
    80001810:	6088                	ld	a0,0(s1)
    80001812:	f575                	bnez	a0,800017fe <exit+0x40>
    80001814:	bfdd                	j	8000180a <exit+0x4c>
  begin_op();
    80001816:	00002097          	auipc	ra,0x2
    8000181a:	f26080e7          	jalr	-218(ra) # 8000373c <begin_op>
  iput(p->cwd);
    8000181e:	1589b503          	ld	a0,344(s3)
    80001822:	00001097          	auipc	ra,0x1
    80001826:	712080e7          	jalr	1810(ra) # 80002f34 <iput>
  end_op();
    8000182a:	00002097          	auipc	ra,0x2
    8000182e:	f92080e7          	jalr	-110(ra) # 800037bc <end_op>
  p->cwd = 0;
    80001832:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001836:	00007497          	auipc	s1,0x7
    8000183a:	14248493          	addi	s1,s1,322 # 80008978 <wait_lock>
    8000183e:	8526                	mv	a0,s1
    80001840:	00005097          	auipc	ra,0x5
    80001844:	b3a080e7          	jalr	-1222(ra) # 8000637a <acquire>
  reparent(p);
    80001848:	854e                	mv	a0,s3
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	f1a080e7          	jalr	-230(ra) # 80001764 <reparent>
  wakeup(p->parent);
    80001852:	0389b503          	ld	a0,56(s3)
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	e98080e7          	jalr	-360(ra) # 800016ee <wakeup>
  acquire(&p->lock);
    8000185e:	854e                	mv	a0,s3
    80001860:	00005097          	auipc	ra,0x5
    80001864:	b1a080e7          	jalr	-1254(ra) # 8000637a <acquire>
  p->xstate = status;
    80001868:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000186c:	4795                	li	a5,5
    8000186e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	bba080e7          	jalr	-1094(ra) # 8000642e <release>
  sched();
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	cfc080e7          	jalr	-772(ra) # 80001578 <sched>
  panic("zombie exit");
    80001884:	00007517          	auipc	a0,0x7
    80001888:	99c50513          	addi	a0,a0,-1636 # 80008220 <etext+0x220>
    8000188c:	00004097          	auipc	ra,0x4
    80001890:	5b2080e7          	jalr	1458(ra) # 80005e3e <panic>

0000000080001894 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001894:	7179                	addi	sp,sp,-48
    80001896:	f406                	sd	ra,40(sp)
    80001898:	f022                	sd	s0,32(sp)
    8000189a:	ec26                	sd	s1,24(sp)
    8000189c:	e84a                	sd	s2,16(sp)
    8000189e:	e44e                	sd	s3,8(sp)
    800018a0:	1800                	addi	s0,sp,48
    800018a2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018a4:	00007497          	auipc	s1,0x7
    800018a8:	4ec48493          	addi	s1,s1,1260 # 80008d90 <proc>
    800018ac:	0000d997          	auipc	s3,0xd
    800018b0:	0e498993          	addi	s3,s3,228 # 8000e990 <tickslock>
    acquire(&p->lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	ac4080e7          	jalr	-1340(ra) # 8000637a <acquire>
    if(p->pid == pid){
    800018be:	589c                	lw	a5,48(s1)
    800018c0:	01278d63          	beq	a5,s2,800018da <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018c4:	8526                	mv	a0,s1
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	b68080e7          	jalr	-1176(ra) # 8000642e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ce:	17048493          	addi	s1,s1,368
    800018d2:	ff3491e3          	bne	s1,s3,800018b4 <kill+0x20>
  }
  return -1;
    800018d6:	557d                	li	a0,-1
    800018d8:	a829                	j	800018f2 <kill+0x5e>
      p->killed = 1;
    800018da:	4785                	li	a5,1
    800018dc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018de:	4c98                	lw	a4,24(s1)
    800018e0:	4789                	li	a5,2
    800018e2:	00f70f63          	beq	a4,a5,80001900 <kill+0x6c>
      release(&p->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	b46080e7          	jalr	-1210(ra) # 8000642e <release>
      return 0;
    800018f0:	4501                	li	a0,0
}
    800018f2:	70a2                	ld	ra,40(sp)
    800018f4:	7402                	ld	s0,32(sp)
    800018f6:	64e2                	ld	s1,24(sp)
    800018f8:	6942                	ld	s2,16(sp)
    800018fa:	69a2                	ld	s3,8(sp)
    800018fc:	6145                	addi	sp,sp,48
    800018fe:	8082                	ret
        p->state = RUNNABLE;
    80001900:	478d                	li	a5,3
    80001902:	cc9c                	sw	a5,24(s1)
    80001904:	b7cd                	j	800018e6 <kill+0x52>

0000000080001906 <setkilled>:

void
setkilled(struct proc *p)
{
    80001906:	1101                	addi	sp,sp,-32
    80001908:	ec06                	sd	ra,24(sp)
    8000190a:	e822                	sd	s0,16(sp)
    8000190c:	e426                	sd	s1,8(sp)
    8000190e:	1000                	addi	s0,sp,32
    80001910:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001912:	00005097          	auipc	ra,0x5
    80001916:	a68080e7          	jalr	-1432(ra) # 8000637a <acquire>
  p->killed = 1;
    8000191a:	4785                	li	a5,1
    8000191c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000191e:	8526                	mv	a0,s1
    80001920:	00005097          	auipc	ra,0x5
    80001924:	b0e080e7          	jalr	-1266(ra) # 8000642e <release>
}
    80001928:	60e2                	ld	ra,24(sp)
    8000192a:	6442                	ld	s0,16(sp)
    8000192c:	64a2                	ld	s1,8(sp)
    8000192e:	6105                	addi	sp,sp,32
    80001930:	8082                	ret

0000000080001932 <killed>:

int
killed(struct proc *p)
{
    80001932:	1101                	addi	sp,sp,-32
    80001934:	ec06                	sd	ra,24(sp)
    80001936:	e822                	sd	s0,16(sp)
    80001938:	e426                	sd	s1,8(sp)
    8000193a:	e04a                	sd	s2,0(sp)
    8000193c:	1000                	addi	s0,sp,32
    8000193e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001940:	00005097          	auipc	ra,0x5
    80001944:	a3a080e7          	jalr	-1478(ra) # 8000637a <acquire>
  k = p->killed;
    80001948:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000194c:	8526                	mv	a0,s1
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	ae0080e7          	jalr	-1312(ra) # 8000642e <release>
  return k;
}
    80001956:	854a                	mv	a0,s2
    80001958:	60e2                	ld	ra,24(sp)
    8000195a:	6442                	ld	s0,16(sp)
    8000195c:	64a2                	ld	s1,8(sp)
    8000195e:	6902                	ld	s2,0(sp)
    80001960:	6105                	addi	sp,sp,32
    80001962:	8082                	ret

0000000080001964 <wait>:
{
    80001964:	715d                	addi	sp,sp,-80
    80001966:	e486                	sd	ra,72(sp)
    80001968:	e0a2                	sd	s0,64(sp)
    8000196a:	fc26                	sd	s1,56(sp)
    8000196c:	f84a                	sd	s2,48(sp)
    8000196e:	f44e                	sd	s3,40(sp)
    80001970:	f052                	sd	s4,32(sp)
    80001972:	ec56                	sd	s5,24(sp)
    80001974:	e85a                	sd	s6,16(sp)
    80001976:	e45e                	sd	s7,8(sp)
    80001978:	e062                	sd	s8,0(sp)
    8000197a:	0880                	addi	s0,sp,80
    8000197c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	5b6080e7          	jalr	1462(ra) # 80000f34 <myproc>
    80001986:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001988:	00007517          	auipc	a0,0x7
    8000198c:	ff050513          	addi	a0,a0,-16 # 80008978 <wait_lock>
    80001990:	00005097          	auipc	ra,0x5
    80001994:	9ea080e7          	jalr	-1558(ra) # 8000637a <acquire>
    havekids = 0;
    80001998:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000199a:	4a15                	li	s4,5
        havekids = 1;
    8000199c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000199e:	0000d997          	auipc	s3,0xd
    800019a2:	ff298993          	addi	s3,s3,-14 # 8000e990 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019a6:	00007c17          	auipc	s8,0x7
    800019aa:	fd2c0c13          	addi	s8,s8,-46 # 80008978 <wait_lock>
    havekids = 0;
    800019ae:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019b0:	00007497          	auipc	s1,0x7
    800019b4:	3e048493          	addi	s1,s1,992 # 80008d90 <proc>
    800019b8:	a0bd                	j	80001a26 <wait+0xc2>
          pid = pp->pid;
    800019ba:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019be:	000b0e63          	beqz	s6,800019da <wait+0x76>
    800019c2:	4691                	li	a3,4
    800019c4:	02c48613          	addi	a2,s1,44
    800019c8:	85da                	mv	a1,s6
    800019ca:	05093503          	ld	a0,80(s2)
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	140080e7          	jalr	320(ra) # 80000b0e <copyout>
    800019d6:	02054563          	bltz	a0,80001a00 <wait+0x9c>
          freeproc(pp);
    800019da:	8526                	mv	a0,s1
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	77e080e7          	jalr	1918(ra) # 8000115a <freeproc>
          release(&pp->lock);
    800019e4:	8526                	mv	a0,s1
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	a48080e7          	jalr	-1464(ra) # 8000642e <release>
          release(&wait_lock);
    800019ee:	00007517          	auipc	a0,0x7
    800019f2:	f8a50513          	addi	a0,a0,-118 # 80008978 <wait_lock>
    800019f6:	00005097          	auipc	ra,0x5
    800019fa:	a38080e7          	jalr	-1480(ra) # 8000642e <release>
          return pid;
    800019fe:	a0b5                	j	80001a6a <wait+0x106>
            release(&pp->lock);
    80001a00:	8526                	mv	a0,s1
    80001a02:	00005097          	auipc	ra,0x5
    80001a06:	a2c080e7          	jalr	-1492(ra) # 8000642e <release>
            release(&wait_lock);
    80001a0a:	00007517          	auipc	a0,0x7
    80001a0e:	f6e50513          	addi	a0,a0,-146 # 80008978 <wait_lock>
    80001a12:	00005097          	auipc	ra,0x5
    80001a16:	a1c080e7          	jalr	-1508(ra) # 8000642e <release>
            return -1;
    80001a1a:	59fd                	li	s3,-1
    80001a1c:	a0b9                	j	80001a6a <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a1e:	17048493          	addi	s1,s1,368
    80001a22:	03348463          	beq	s1,s3,80001a4a <wait+0xe6>
      if(pp->parent == p){
    80001a26:	7c9c                	ld	a5,56(s1)
    80001a28:	ff279be3          	bne	a5,s2,80001a1e <wait+0xba>
        acquire(&pp->lock);
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	00005097          	auipc	ra,0x5
    80001a32:	94c080e7          	jalr	-1716(ra) # 8000637a <acquire>
        if(pp->state == ZOMBIE){
    80001a36:	4c9c                	lw	a5,24(s1)
    80001a38:	f94781e3          	beq	a5,s4,800019ba <wait+0x56>
        release(&pp->lock);
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	00005097          	auipc	ra,0x5
    80001a42:	9f0080e7          	jalr	-1552(ra) # 8000642e <release>
        havekids = 1;
    80001a46:	8756                	mv	a4,s5
    80001a48:	bfd9                	j	80001a1e <wait+0xba>
    if(!havekids || killed(p)){
    80001a4a:	c719                	beqz	a4,80001a58 <wait+0xf4>
    80001a4c:	854a                	mv	a0,s2
    80001a4e:	00000097          	auipc	ra,0x0
    80001a52:	ee4080e7          	jalr	-284(ra) # 80001932 <killed>
    80001a56:	c51d                	beqz	a0,80001a84 <wait+0x120>
      release(&wait_lock);
    80001a58:	00007517          	auipc	a0,0x7
    80001a5c:	f2050513          	addi	a0,a0,-224 # 80008978 <wait_lock>
    80001a60:	00005097          	auipc	ra,0x5
    80001a64:	9ce080e7          	jalr	-1586(ra) # 8000642e <release>
      return -1;
    80001a68:	59fd                	li	s3,-1
}
    80001a6a:	854e                	mv	a0,s3
    80001a6c:	60a6                	ld	ra,72(sp)
    80001a6e:	6406                	ld	s0,64(sp)
    80001a70:	74e2                	ld	s1,56(sp)
    80001a72:	7942                	ld	s2,48(sp)
    80001a74:	79a2                	ld	s3,40(sp)
    80001a76:	7a02                	ld	s4,32(sp)
    80001a78:	6ae2                	ld	s5,24(sp)
    80001a7a:	6b42                	ld	s6,16(sp)
    80001a7c:	6ba2                	ld	s7,8(sp)
    80001a7e:	6c02                	ld	s8,0(sp)
    80001a80:	6161                	addi	sp,sp,80
    80001a82:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a84:	85e2                	mv	a1,s8
    80001a86:	854a                	mv	a0,s2
    80001a88:	00000097          	auipc	ra,0x0
    80001a8c:	c02080e7          	jalr	-1022(ra) # 8000168a <sleep>
    havekids = 0;
    80001a90:	bf39                	j	800019ae <wait+0x4a>

0000000080001a92 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a92:	7179                	addi	sp,sp,-48
    80001a94:	f406                	sd	ra,40(sp)
    80001a96:	f022                	sd	s0,32(sp)
    80001a98:	ec26                	sd	s1,24(sp)
    80001a9a:	e84a                	sd	s2,16(sp)
    80001a9c:	e44e                	sd	s3,8(sp)
    80001a9e:	e052                	sd	s4,0(sp)
    80001aa0:	1800                	addi	s0,sp,48
    80001aa2:	84aa                	mv	s1,a0
    80001aa4:	892e                	mv	s2,a1
    80001aa6:	89b2                	mv	s3,a2
    80001aa8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aaa:	fffff097          	auipc	ra,0xfffff
    80001aae:	48a080e7          	jalr	1162(ra) # 80000f34 <myproc>
  if(user_dst){
    80001ab2:	c08d                	beqz	s1,80001ad4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ab4:	86d2                	mv	a3,s4
    80001ab6:	864e                	mv	a2,s3
    80001ab8:	85ca                	mv	a1,s2
    80001aba:	6928                	ld	a0,80(a0)
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	052080e7          	jalr	82(ra) # 80000b0e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ac4:	70a2                	ld	ra,40(sp)
    80001ac6:	7402                	ld	s0,32(sp)
    80001ac8:	64e2                	ld	s1,24(sp)
    80001aca:	6942                	ld	s2,16(sp)
    80001acc:	69a2                	ld	s3,8(sp)
    80001ace:	6a02                	ld	s4,0(sp)
    80001ad0:	6145                	addi	sp,sp,48
    80001ad2:	8082                	ret
    memmove((char *)dst, src, len);
    80001ad4:	000a061b          	sext.w	a2,s4
    80001ad8:	85ce                	mv	a1,s3
    80001ada:	854a                	mv	a0,s2
    80001adc:	ffffe097          	auipc	ra,0xffffe
    80001ae0:	6f8080e7          	jalr	1784(ra) # 800001d4 <memmove>
    return 0;
    80001ae4:	8526                	mv	a0,s1
    80001ae6:	bff9                	j	80001ac4 <either_copyout+0x32>

0000000080001ae8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ae8:	7179                	addi	sp,sp,-48
    80001aea:	f406                	sd	ra,40(sp)
    80001aec:	f022                	sd	s0,32(sp)
    80001aee:	ec26                	sd	s1,24(sp)
    80001af0:	e84a                	sd	s2,16(sp)
    80001af2:	e44e                	sd	s3,8(sp)
    80001af4:	e052                	sd	s4,0(sp)
    80001af6:	1800                	addi	s0,sp,48
    80001af8:	892a                	mv	s2,a0
    80001afa:	84ae                	mv	s1,a1
    80001afc:	89b2                	mv	s3,a2
    80001afe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b00:	fffff097          	auipc	ra,0xfffff
    80001b04:	434080e7          	jalr	1076(ra) # 80000f34 <myproc>
  if(user_src){
    80001b08:	c08d                	beqz	s1,80001b2a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b0a:	86d2                	mv	a3,s4
    80001b0c:	864e                	mv	a2,s3
    80001b0e:	85ca                	mv	a1,s2
    80001b10:	6928                	ld	a0,80(a0)
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	088080e7          	jalr	136(ra) # 80000b9a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b1a:	70a2                	ld	ra,40(sp)
    80001b1c:	7402                	ld	s0,32(sp)
    80001b1e:	64e2                	ld	s1,24(sp)
    80001b20:	6942                	ld	s2,16(sp)
    80001b22:	69a2                	ld	s3,8(sp)
    80001b24:	6a02                	ld	s4,0(sp)
    80001b26:	6145                	addi	sp,sp,48
    80001b28:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b2a:	000a061b          	sext.w	a2,s4
    80001b2e:	85ce                	mv	a1,s3
    80001b30:	854a                	mv	a0,s2
    80001b32:	ffffe097          	auipc	ra,0xffffe
    80001b36:	6a2080e7          	jalr	1698(ra) # 800001d4 <memmove>
    return 0;
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	bff9                	j	80001b1a <either_copyin+0x32>

0000000080001b3e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b3e:	715d                	addi	sp,sp,-80
    80001b40:	e486                	sd	ra,72(sp)
    80001b42:	e0a2                	sd	s0,64(sp)
    80001b44:	fc26                	sd	s1,56(sp)
    80001b46:	f84a                	sd	s2,48(sp)
    80001b48:	f44e                	sd	s3,40(sp)
    80001b4a:	f052                	sd	s4,32(sp)
    80001b4c:	ec56                	sd	s5,24(sp)
    80001b4e:	e85a                	sd	s6,16(sp)
    80001b50:	e45e                	sd	s7,8(sp)
    80001b52:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b54:	00006517          	auipc	a0,0x6
    80001b58:	4f450513          	addi	a0,a0,1268 # 80008048 <etext+0x48>
    80001b5c:	00004097          	auipc	ra,0x4
    80001b60:	32c080e7          	jalr	812(ra) # 80005e88 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b64:	00007497          	auipc	s1,0x7
    80001b68:	38c48493          	addi	s1,s1,908 # 80008ef0 <proc+0x160>
    80001b6c:	0000d917          	auipc	s2,0xd
    80001b70:	f8490913          	addi	s2,s2,-124 # 8000eaf0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b74:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b76:	00006997          	auipc	s3,0x6
    80001b7a:	6ba98993          	addi	s3,s3,1722 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b7e:	00006a97          	auipc	s5,0x6
    80001b82:	6baa8a93          	addi	s5,s5,1722 # 80008238 <etext+0x238>
    printf("\n");
    80001b86:	00006a17          	auipc	s4,0x6
    80001b8a:	4c2a0a13          	addi	s4,s4,1218 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b8e:	00006b97          	auipc	s7,0x6
    80001b92:	6eab8b93          	addi	s7,s7,1770 # 80008278 <states.0>
    80001b96:	a00d                	j	80001bb8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b98:	ed06a583          	lw	a1,-304(a3)
    80001b9c:	8556                	mv	a0,s5
    80001b9e:	00004097          	auipc	ra,0x4
    80001ba2:	2ea080e7          	jalr	746(ra) # 80005e88 <printf>
    printf("\n");
    80001ba6:	8552                	mv	a0,s4
    80001ba8:	00004097          	auipc	ra,0x4
    80001bac:	2e0080e7          	jalr	736(ra) # 80005e88 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bb0:	17048493          	addi	s1,s1,368
    80001bb4:	03248163          	beq	s1,s2,80001bd6 <procdump+0x98>
    if(p->state == UNUSED)
    80001bb8:	86a6                	mv	a3,s1
    80001bba:	eb84a783          	lw	a5,-328(s1)
    80001bbe:	dbed                	beqz	a5,80001bb0 <procdump+0x72>
      state = "???";
    80001bc0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bc2:	fcfb6be3          	bltu	s6,a5,80001b98 <procdump+0x5a>
    80001bc6:	1782                	slli	a5,a5,0x20
    80001bc8:	9381                	srli	a5,a5,0x20
    80001bca:	078e                	slli	a5,a5,0x3
    80001bcc:	97de                	add	a5,a5,s7
    80001bce:	6390                	ld	a2,0(a5)
    80001bd0:	f661                	bnez	a2,80001b98 <procdump+0x5a>
      state = "???";
    80001bd2:	864e                	mv	a2,s3
    80001bd4:	b7d1                	j	80001b98 <procdump+0x5a>
  }
}
    80001bd6:	60a6                	ld	ra,72(sp)
    80001bd8:	6406                	ld	s0,64(sp)
    80001bda:	74e2                	ld	s1,56(sp)
    80001bdc:	7942                	ld	s2,48(sp)
    80001bde:	79a2                	ld	s3,40(sp)
    80001be0:	7a02                	ld	s4,32(sp)
    80001be2:	6ae2                	ld	s5,24(sp)
    80001be4:	6b42                	ld	s6,16(sp)
    80001be6:	6ba2                	ld	s7,8(sp)
    80001be8:	6161                	addi	sp,sp,80
    80001bea:	8082                	ret

0000000080001bec <swtch>:
    80001bec:	00153023          	sd	ra,0(a0)
    80001bf0:	00253423          	sd	sp,8(a0)
    80001bf4:	e900                	sd	s0,16(a0)
    80001bf6:	ed04                	sd	s1,24(a0)
    80001bf8:	03253023          	sd	s2,32(a0)
    80001bfc:	03353423          	sd	s3,40(a0)
    80001c00:	03453823          	sd	s4,48(a0)
    80001c04:	03553c23          	sd	s5,56(a0)
    80001c08:	05653023          	sd	s6,64(a0)
    80001c0c:	05753423          	sd	s7,72(a0)
    80001c10:	05853823          	sd	s8,80(a0)
    80001c14:	05953c23          	sd	s9,88(a0)
    80001c18:	07a53023          	sd	s10,96(a0)
    80001c1c:	07b53423          	sd	s11,104(a0)
    80001c20:	0005b083          	ld	ra,0(a1)
    80001c24:	0085b103          	ld	sp,8(a1)
    80001c28:	6980                	ld	s0,16(a1)
    80001c2a:	6d84                	ld	s1,24(a1)
    80001c2c:	0205b903          	ld	s2,32(a1)
    80001c30:	0285b983          	ld	s3,40(a1)
    80001c34:	0305ba03          	ld	s4,48(a1)
    80001c38:	0385ba83          	ld	s5,56(a1)
    80001c3c:	0405bb03          	ld	s6,64(a1)
    80001c40:	0485bb83          	ld	s7,72(a1)
    80001c44:	0505bc03          	ld	s8,80(a1)
    80001c48:	0585bc83          	ld	s9,88(a1)
    80001c4c:	0605bd03          	ld	s10,96(a1)
    80001c50:	0685bd83          	ld	s11,104(a1)
    80001c54:	8082                	ret

0000000080001c56 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c56:	1141                	addi	sp,sp,-16
    80001c58:	e406                	sd	ra,8(sp)
    80001c5a:	e022                	sd	s0,0(sp)
    80001c5c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c5e:	00006597          	auipc	a1,0x6
    80001c62:	64a58593          	addi	a1,a1,1610 # 800082a8 <states.0+0x30>
    80001c66:	0000d517          	auipc	a0,0xd
    80001c6a:	d2a50513          	addi	a0,a0,-726 # 8000e990 <tickslock>
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	67c080e7          	jalr	1660(ra) # 800062ea <initlock>
}
    80001c76:	60a2                	ld	ra,8(sp)
    80001c78:	6402                	ld	s0,0(sp)
    80001c7a:	0141                	addi	sp,sp,16
    80001c7c:	8082                	ret

0000000080001c7e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c7e:	1141                	addi	sp,sp,-16
    80001c80:	e422                	sd	s0,8(sp)
    80001c82:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c84:	00003797          	auipc	a5,0x3
    80001c88:	5ec78793          	addi	a5,a5,1516 # 80005270 <kernelvec>
    80001c8c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c90:	6422                	ld	s0,8(sp)
    80001c92:	0141                	addi	sp,sp,16
    80001c94:	8082                	ret

0000000080001c96 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c96:	1141                	addi	sp,sp,-16
    80001c98:	e406                	sd	ra,8(sp)
    80001c9a:	e022                	sd	s0,0(sp)
    80001c9c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	296080e7          	jalr	662(ra) # 80000f34 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001caa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cac:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cb0:	00005617          	auipc	a2,0x5
    80001cb4:	35060613          	addi	a2,a2,848 # 80007000 <_trampoline>
    80001cb8:	00005697          	auipc	a3,0x5
    80001cbc:	34868693          	addi	a3,a3,840 # 80007000 <_trampoline>
    80001cc0:	8e91                	sub	a3,a3,a2
    80001cc2:	040007b7          	lui	a5,0x4000
    80001cc6:	17fd                	addi	a5,a5,-1
    80001cc8:	07b2                	slli	a5,a5,0xc
    80001cca:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ccc:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cd0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cd2:	180026f3          	csrr	a3,satp
    80001cd6:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cd8:	6d38                	ld	a4,88(a0)
    80001cda:	6134                	ld	a3,64(a0)
    80001cdc:	6585                	lui	a1,0x1
    80001cde:	96ae                	add	a3,a3,a1
    80001ce0:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ce2:	6d38                	ld	a4,88(a0)
    80001ce4:	00000697          	auipc	a3,0x0
    80001ce8:	13068693          	addi	a3,a3,304 # 80001e14 <usertrap>
    80001cec:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cee:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cf0:	8692                	mv	a3,tp
    80001cf2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cf8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cfc:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d00:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d04:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d06:	6f18                	ld	a4,24(a4)
    80001d08:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d0c:	6928                	ld	a0,80(a0)
    80001d0e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d10:	00005717          	auipc	a4,0x5
    80001d14:	38c70713          	addi	a4,a4,908 # 8000709c <userret>
    80001d18:	8f11                	sub	a4,a4,a2
    80001d1a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d1c:	577d                	li	a4,-1
    80001d1e:	177e                	slli	a4,a4,0x3f
    80001d20:	8d59                	or	a0,a0,a4
    80001d22:	9782                	jalr	a5
}
    80001d24:	60a2                	ld	ra,8(sp)
    80001d26:	6402                	ld	s0,0(sp)
    80001d28:	0141                	addi	sp,sp,16
    80001d2a:	8082                	ret

0000000080001d2c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d2c:	1101                	addi	sp,sp,-32
    80001d2e:	ec06                	sd	ra,24(sp)
    80001d30:	e822                	sd	s0,16(sp)
    80001d32:	e426                	sd	s1,8(sp)
    80001d34:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d36:	0000d497          	auipc	s1,0xd
    80001d3a:	c5a48493          	addi	s1,s1,-934 # 8000e990 <tickslock>
    80001d3e:	8526                	mv	a0,s1
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	63a080e7          	jalr	1594(ra) # 8000637a <acquire>
  ticks++;
    80001d48:	00007517          	auipc	a0,0x7
    80001d4c:	be050513          	addi	a0,a0,-1056 # 80008928 <ticks>
    80001d50:	411c                	lw	a5,0(a0)
    80001d52:	2785                	addiw	a5,a5,1
    80001d54:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	998080e7          	jalr	-1640(ra) # 800016ee <wakeup>
  release(&tickslock);
    80001d5e:	8526                	mv	a0,s1
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	6ce080e7          	jalr	1742(ra) # 8000642e <release>
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6105                	addi	sp,sp,32
    80001d70:	8082                	ret

0000000080001d72 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d72:	1101                	addi	sp,sp,-32
    80001d74:	ec06                	sd	ra,24(sp)
    80001d76:	e822                	sd	s0,16(sp)
    80001d78:	e426                	sd	s1,8(sp)
    80001d7a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d80:	00074d63          	bltz	a4,80001d9a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d84:	57fd                	li	a5,-1
    80001d86:	17fe                	slli	a5,a5,0x3f
    80001d88:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d8a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d8c:	06f70363          	beq	a4,a5,80001df2 <devintr+0x80>
  }
}
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	64a2                	ld	s1,8(sp)
    80001d96:	6105                	addi	sp,sp,32
    80001d98:	8082                	ret
     (scause & 0xff) == 9){
    80001d9a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d9e:	46a5                	li	a3,9
    80001da0:	fed792e3          	bne	a5,a3,80001d84 <devintr+0x12>
    int irq = plic_claim();
    80001da4:	00003097          	auipc	ra,0x3
    80001da8:	5d4080e7          	jalr	1492(ra) # 80005378 <plic_claim>
    80001dac:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dae:	47a9                	li	a5,10
    80001db0:	02f50763          	beq	a0,a5,80001dde <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001db4:	4785                	li	a5,1
    80001db6:	02f50963          	beq	a0,a5,80001de8 <devintr+0x76>
    return 1;
    80001dba:	4505                	li	a0,1
    } else if(irq){
    80001dbc:	d8f1                	beqz	s1,80001d90 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dbe:	85a6                	mv	a1,s1
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	4f050513          	addi	a0,a0,1264 # 800082b0 <states.0+0x38>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	0c0080e7          	jalr	192(ra) # 80005e88 <printf>
      plic_complete(irq);
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	00003097          	auipc	ra,0x3
    80001dd6:	5ca080e7          	jalr	1482(ra) # 8000539c <plic_complete>
    return 1;
    80001dda:	4505                	li	a0,1
    80001ddc:	bf55                	j	80001d90 <devintr+0x1e>
      uartintr();
    80001dde:	00004097          	auipc	ra,0x4
    80001de2:	4bc080e7          	jalr	1212(ra) # 8000629a <uartintr>
    80001de6:	b7ed                	j	80001dd0 <devintr+0x5e>
      virtio_disk_intr();
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	a80080e7          	jalr	-1408(ra) # 80005868 <virtio_disk_intr>
    80001df0:	b7c5                	j	80001dd0 <devintr+0x5e>
    if(cpuid() == 0){
    80001df2:	fffff097          	auipc	ra,0xfffff
    80001df6:	116080e7          	jalr	278(ra) # 80000f08 <cpuid>
    80001dfa:	c901                	beqz	a0,80001e0a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dfc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e02:	14479073          	csrw	sip,a5
    return 2;
    80001e06:	4509                	li	a0,2
    80001e08:	b761                	j	80001d90 <devintr+0x1e>
      clockintr();
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	f22080e7          	jalr	-222(ra) # 80001d2c <clockintr>
    80001e12:	b7ed                	j	80001dfc <devintr+0x8a>

0000000080001e14 <usertrap>:
{
    80001e14:	1101                	addi	sp,sp,-32
    80001e16:	ec06                	sd	ra,24(sp)
    80001e18:	e822                	sd	s0,16(sp)
    80001e1a:	e426                	sd	s1,8(sp)
    80001e1c:	e04a                	sd	s2,0(sp)
    80001e1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e20:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e24:	1007f793          	andi	a5,a5,256
    80001e28:	e3b1                	bnez	a5,80001e6c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2a:	00003797          	auipc	a5,0x3
    80001e2e:	44678793          	addi	a5,a5,1094 # 80005270 <kernelvec>
    80001e32:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	0fe080e7          	jalr	254(ra) # 80000f34 <myproc>
    80001e3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e42:	14102773          	csrr	a4,sepc
    80001e46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e48:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e4c:	47a1                	li	a5,8
    80001e4e:	02f70763          	beq	a4,a5,80001e7c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	f20080e7          	jalr	-224(ra) # 80001d72 <devintr>
    80001e5a:	892a                	mv	s2,a0
    80001e5c:	c151                	beqz	a0,80001ee0 <usertrap+0xcc>
  if(killed(p))
    80001e5e:	8526                	mv	a0,s1
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	ad2080e7          	jalr	-1326(ra) # 80001932 <killed>
    80001e68:	c929                	beqz	a0,80001eba <usertrap+0xa6>
    80001e6a:	a099                	j	80001eb0 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	46450513          	addi	a0,a0,1124 # 800082d0 <states.0+0x58>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	fca080e7          	jalr	-54(ra) # 80005e3e <panic>
    if(killed(p))
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	ab6080e7          	jalr	-1354(ra) # 80001932 <killed>
    80001e84:	e921                	bnez	a0,80001ed4 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e86:	6cb8                	ld	a4,88(s1)
    80001e88:	6f1c                	ld	a5,24(a4)
    80001e8a:	0791                	addi	a5,a5,4
    80001e8c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e92:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e96:	10079073          	csrw	sstatus,a5
    syscall();
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	2d4080e7          	jalr	724(ra) # 8000216e <syscall>
  if(killed(p))
    80001ea2:	8526                	mv	a0,s1
    80001ea4:	00000097          	auipc	ra,0x0
    80001ea8:	a8e080e7          	jalr	-1394(ra) # 80001932 <killed>
    80001eac:	c911                	beqz	a0,80001ec0 <usertrap+0xac>
    80001eae:	4901                	li	s2,0
    exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	90c080e7          	jalr	-1780(ra) # 800017be <exit>
  if(which_dev == 2)
    80001eba:	4789                	li	a5,2
    80001ebc:	04f90f63          	beq	s2,a5,80001f1a <usertrap+0x106>
  usertrapret();
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	dd6080e7          	jalr	-554(ra) # 80001c96 <usertrapret>
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6902                	ld	s2,0(sp)
    80001ed0:	6105                	addi	sp,sp,32
    80001ed2:	8082                	ret
      exit(-1);
    80001ed4:	557d                	li	a0,-1
    80001ed6:	00000097          	auipc	ra,0x0
    80001eda:	8e8080e7          	jalr	-1816(ra) # 800017be <exit>
    80001ede:	b765                	j	80001e86 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ee4:	5890                	lw	a2,48(s1)
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	40a50513          	addi	a0,a0,1034 # 800082f0 <states.0+0x78>
    80001eee:	00004097          	auipc	ra,0x4
    80001ef2:	f9a080e7          	jalr	-102(ra) # 80005e88 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efa:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	42250513          	addi	a0,a0,1058 # 80008320 <states.0+0xa8>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	f82080e7          	jalr	-126(ra) # 80005e88 <printf>
    setkilled(p);
    80001f0e:	8526                	mv	a0,s1
    80001f10:	00000097          	auipc	ra,0x0
    80001f14:	9f6080e7          	jalr	-1546(ra) # 80001906 <setkilled>
    80001f18:	b769                	j	80001ea2 <usertrap+0x8e>
    yield();
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	734080e7          	jalr	1844(ra) # 8000164e <yield>
    80001f22:	bf79                	j	80001ec0 <usertrap+0xac>

0000000080001f24 <kerneltrap>:
{
    80001f24:	7179                	addi	sp,sp,-48
    80001f26:	f406                	sd	ra,40(sp)
    80001f28:	f022                	sd	s0,32(sp)
    80001f2a:	ec26                	sd	s1,24(sp)
    80001f2c:	e84a                	sd	s2,16(sp)
    80001f2e:	e44e                	sd	s3,8(sp)
    80001f30:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f32:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f36:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f3e:	1004f793          	andi	a5,s1,256
    80001f42:	cb85                	beqz	a5,80001f72 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f48:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f4a:	ef85                	bnez	a5,80001f82 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f4c:	00000097          	auipc	ra,0x0
    80001f50:	e26080e7          	jalr	-474(ra) # 80001d72 <devintr>
    80001f54:	cd1d                	beqz	a0,80001f92 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f56:	4789                	li	a5,2
    80001f58:	06f50a63          	beq	a0,a5,80001fcc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f60:	10049073          	csrw	sstatus,s1
}
    80001f64:	70a2                	ld	ra,40(sp)
    80001f66:	7402                	ld	s0,32(sp)
    80001f68:	64e2                	ld	s1,24(sp)
    80001f6a:	6942                	ld	s2,16(sp)
    80001f6c:	69a2                	ld	s3,8(sp)
    80001f6e:	6145                	addi	sp,sp,48
    80001f70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	3ce50513          	addi	a0,a0,974 # 80008340 <states.0+0xc8>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	ec4080e7          	jalr	-316(ra) # 80005e3e <panic>
    panic("kerneltrap: interrupts enabled");
    80001f82:	00006517          	auipc	a0,0x6
    80001f86:	3e650513          	addi	a0,a0,998 # 80008368 <states.0+0xf0>
    80001f8a:	00004097          	auipc	ra,0x4
    80001f8e:	eb4080e7          	jalr	-332(ra) # 80005e3e <panic>
    printf("scause %p\n", scause);
    80001f92:	85ce                	mv	a1,s3
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	3f450513          	addi	a0,a0,1012 # 80008388 <states.0+0x110>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	eec080e7          	jalr	-276(ra) # 80005e88 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fa4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fa8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fac:	00006517          	auipc	a0,0x6
    80001fb0:	3ec50513          	addi	a0,a0,1004 # 80008398 <states.0+0x120>
    80001fb4:	00004097          	auipc	ra,0x4
    80001fb8:	ed4080e7          	jalr	-300(ra) # 80005e88 <printf>
    panic("kerneltrap");
    80001fbc:	00006517          	auipc	a0,0x6
    80001fc0:	3f450513          	addi	a0,a0,1012 # 800083b0 <states.0+0x138>
    80001fc4:	00004097          	auipc	ra,0x4
    80001fc8:	e7a080e7          	jalr	-390(ra) # 80005e3e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fcc:	fffff097          	auipc	ra,0xfffff
    80001fd0:	f68080e7          	jalr	-152(ra) # 80000f34 <myproc>
    80001fd4:	d541                	beqz	a0,80001f5c <kerneltrap+0x38>
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	f5e080e7          	jalr	-162(ra) # 80000f34 <myproc>
    80001fde:	4d18                	lw	a4,24(a0)
    80001fe0:	4791                	li	a5,4
    80001fe2:	f6f71de3          	bne	a4,a5,80001f5c <kerneltrap+0x38>
    yield();
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	668080e7          	jalr	1640(ra) # 8000164e <yield>
    80001fee:	b7bd                	j	80001f5c <kerneltrap+0x38>

0000000080001ff0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	1000                	addi	s0,sp,32
    80001ffa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	f38080e7          	jalr	-200(ra) # 80000f34 <myproc>
  switch (n) {
    80002004:	4795                	li	a5,5
    80002006:	0497e163          	bltu	a5,s1,80002048 <argraw+0x58>
    8000200a:	048a                	slli	s1,s1,0x2
    8000200c:	00006717          	auipc	a4,0x6
    80002010:	3dc70713          	addi	a4,a4,988 # 800083e8 <states.0+0x170>
    80002014:	94ba                	add	s1,s1,a4
    80002016:	409c                	lw	a5,0(s1)
    80002018:	97ba                	add	a5,a5,a4
    8000201a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000201c:	6d3c                	ld	a5,88(a0)
    8000201e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002020:	60e2                	ld	ra,24(sp)
    80002022:	6442                	ld	s0,16(sp)
    80002024:	64a2                	ld	s1,8(sp)
    80002026:	6105                	addi	sp,sp,32
    80002028:	8082                	ret
    return p->trapframe->a1;
    8000202a:	6d3c                	ld	a5,88(a0)
    8000202c:	7fa8                	ld	a0,120(a5)
    8000202e:	bfcd                	j	80002020 <argraw+0x30>
    return p->trapframe->a2;
    80002030:	6d3c                	ld	a5,88(a0)
    80002032:	63c8                	ld	a0,128(a5)
    80002034:	b7f5                	j	80002020 <argraw+0x30>
    return p->trapframe->a3;
    80002036:	6d3c                	ld	a5,88(a0)
    80002038:	67c8                	ld	a0,136(a5)
    8000203a:	b7dd                	j	80002020 <argraw+0x30>
    return p->trapframe->a4;
    8000203c:	6d3c                	ld	a5,88(a0)
    8000203e:	6bc8                	ld	a0,144(a5)
    80002040:	b7c5                	j	80002020 <argraw+0x30>
    return p->trapframe->a5;
    80002042:	6d3c                	ld	a5,88(a0)
    80002044:	6fc8                	ld	a0,152(a5)
    80002046:	bfe9                	j	80002020 <argraw+0x30>
  panic("argraw");
    80002048:	00006517          	auipc	a0,0x6
    8000204c:	37850513          	addi	a0,a0,888 # 800083c0 <states.0+0x148>
    80002050:	00004097          	auipc	ra,0x4
    80002054:	dee080e7          	jalr	-530(ra) # 80005e3e <panic>

0000000080002058 <fetchaddr>:
{
    80002058:	1101                	addi	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	e426                	sd	s1,8(sp)
    80002060:	e04a                	sd	s2,0(sp)
    80002062:	1000                	addi	s0,sp,32
    80002064:	84aa                	mv	s1,a0
    80002066:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	ecc080e7          	jalr	-308(ra) # 80000f34 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002070:	653c                	ld	a5,72(a0)
    80002072:	02f4f863          	bgeu	s1,a5,800020a2 <fetchaddr+0x4a>
    80002076:	00848713          	addi	a4,s1,8
    8000207a:	02e7e663          	bltu	a5,a4,800020a6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000207e:	46a1                	li	a3,8
    80002080:	8626                	mv	a2,s1
    80002082:	85ca                	mv	a1,s2
    80002084:	6928                	ld	a0,80(a0)
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	b14080e7          	jalr	-1260(ra) # 80000b9a <copyin>
    8000208e:	00a03533          	snez	a0,a0
    80002092:	40a00533          	neg	a0,a0
}
    80002096:	60e2                	ld	ra,24(sp)
    80002098:	6442                	ld	s0,16(sp)
    8000209a:	64a2                	ld	s1,8(sp)
    8000209c:	6902                	ld	s2,0(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret
    return -1;
    800020a2:	557d                	li	a0,-1
    800020a4:	bfcd                	j	80002096 <fetchaddr+0x3e>
    800020a6:	557d                	li	a0,-1
    800020a8:	b7fd                	j	80002096 <fetchaddr+0x3e>

00000000800020aa <fetchstr>:
{
    800020aa:	7179                	addi	sp,sp,-48
    800020ac:	f406                	sd	ra,40(sp)
    800020ae:	f022                	sd	s0,32(sp)
    800020b0:	ec26                	sd	s1,24(sp)
    800020b2:	e84a                	sd	s2,16(sp)
    800020b4:	e44e                	sd	s3,8(sp)
    800020b6:	1800                	addi	s0,sp,48
    800020b8:	892a                	mv	s2,a0
    800020ba:	84ae                	mv	s1,a1
    800020bc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	e76080e7          	jalr	-394(ra) # 80000f34 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020c6:	86ce                	mv	a3,s3
    800020c8:	864a                	mv	a2,s2
    800020ca:	85a6                	mv	a1,s1
    800020cc:	6928                	ld	a0,80(a0)
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	b5a080e7          	jalr	-1190(ra) # 80000c28 <copyinstr>
    800020d6:	00054e63          	bltz	a0,800020f2 <fetchstr+0x48>
  return strlen(buf);
    800020da:	8526                	mv	a0,s1
    800020dc:	ffffe097          	auipc	ra,0xffffe
    800020e0:	218080e7          	jalr	536(ra) # 800002f4 <strlen>
}
    800020e4:	70a2                	ld	ra,40(sp)
    800020e6:	7402                	ld	s0,32(sp)
    800020e8:	64e2                	ld	s1,24(sp)
    800020ea:	6942                	ld	s2,16(sp)
    800020ec:	69a2                	ld	s3,8(sp)
    800020ee:	6145                	addi	sp,sp,48
    800020f0:	8082                	ret
    return -1;
    800020f2:	557d                	li	a0,-1
    800020f4:	bfc5                	j	800020e4 <fetchstr+0x3a>

00000000800020f6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002102:	00000097          	auipc	ra,0x0
    80002106:	eee080e7          	jalr	-274(ra) # 80001ff0 <argraw>
    8000210a:	c088                	sw	a0,0(s1)
}
    8000210c:	60e2                	ld	ra,24(sp)
    8000210e:	6442                	ld	s0,16(sp)
    80002110:	64a2                	ld	s1,8(sp)
    80002112:	6105                	addi	sp,sp,32
    80002114:	8082                	ret

0000000080002116 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002116:	1101                	addi	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	e426                	sd	s1,8(sp)
    8000211e:	1000                	addi	s0,sp,32
    80002120:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002122:	00000097          	auipc	ra,0x0
    80002126:	ece080e7          	jalr	-306(ra) # 80001ff0 <argraw>
    8000212a:	e088                	sd	a0,0(s1)
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	64a2                	ld	s1,8(sp)
    80002132:	6105                	addi	sp,sp,32
    80002134:	8082                	ret

0000000080002136 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002136:	7179                	addi	sp,sp,-48
    80002138:	f406                	sd	ra,40(sp)
    8000213a:	f022                	sd	s0,32(sp)
    8000213c:	ec26                	sd	s1,24(sp)
    8000213e:	e84a                	sd	s2,16(sp)
    80002140:	1800                	addi	s0,sp,48
    80002142:	84ae                	mv	s1,a1
    80002144:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002146:	fd840593          	addi	a1,s0,-40
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	fcc080e7          	jalr	-52(ra) # 80002116 <argaddr>
  return fetchstr(addr, buf, max);
    80002152:	864a                	mv	a2,s2
    80002154:	85a6                	mv	a1,s1
    80002156:	fd843503          	ld	a0,-40(s0)
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	f50080e7          	jalr	-176(ra) # 800020aa <fetchstr>
}
    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6942                	ld	s2,16(sp)
    8000216a:	6145                	addi	sp,sp,48
    8000216c:	8082                	ret

000000008000216e <syscall>:



void
syscall(void)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	e04a                	sd	s2,0(sp)
    80002178:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	dba080e7          	jalr	-582(ra) # 80000f34 <myproc>
    80002182:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002184:	05853903          	ld	s2,88(a0)
    80002188:	0a893783          	ld	a5,168(s2)
    8000218c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002190:	37fd                	addiw	a5,a5,-1
    80002192:	4775                	li	a4,29
    80002194:	00f76f63          	bltu	a4,a5,800021b2 <syscall+0x44>
    80002198:	00369713          	slli	a4,a3,0x3
    8000219c:	00006797          	auipc	a5,0x6
    800021a0:	26478793          	addi	a5,a5,612 # 80008400 <syscalls>
    800021a4:	97ba                	add	a5,a5,a4
    800021a6:	639c                	ld	a5,0(a5)
    800021a8:	c789                	beqz	a5,800021b2 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021aa:	9782                	jalr	a5
    800021ac:	06a93823          	sd	a0,112(s2)
    800021b0:	a839                	j	800021ce <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021b2:	16048613          	addi	a2,s1,352
    800021b6:	588c                	lw	a1,48(s1)
    800021b8:	00006517          	auipc	a0,0x6
    800021bc:	21050513          	addi	a0,a0,528 # 800083c8 <states.0+0x150>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	cc8080e7          	jalr	-824(ra) # 80005e88 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021c8:	6cbc                	ld	a5,88(s1)
    800021ca:	577d                	li	a4,-1
    800021cc:	fbb8                	sd	a4,112(a5)
  }
}
    800021ce:	60e2                	ld	ra,24(sp)
    800021d0:	6442                	ld	s0,16(sp)
    800021d2:	64a2                	ld	s1,8(sp)
    800021d4:	6902                	ld	s2,0(sp)
    800021d6:	6105                	addi	sp,sp,32
    800021d8:	8082                	ret

00000000800021da <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021da:	1101                	addi	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021e2:	fec40593          	addi	a1,s0,-20
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	f0e080e7          	jalr	-242(ra) # 800020f6 <argint>
  exit(n);
    800021f0:	fec42503          	lw	a0,-20(s0)
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	5ca080e7          	jalr	1482(ra) # 800017be <exit>
  return 0;  // not reached
}
    800021fc:	4501                	li	a0,0
    800021fe:	60e2                	ld	ra,24(sp)
    80002200:	6442                	ld	s0,16(sp)
    80002202:	6105                	addi	sp,sp,32
    80002204:	8082                	ret

0000000080002206 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002206:	1141                	addi	sp,sp,-16
    80002208:	e406                	sd	ra,8(sp)
    8000220a:	e022                	sd	s0,0(sp)
    8000220c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	d26080e7          	jalr	-730(ra) # 80000f34 <myproc>
}
    80002216:	5908                	lw	a0,48(a0)
    80002218:	60a2                	ld	ra,8(sp)
    8000221a:	6402                	ld	s0,0(sp)
    8000221c:	0141                	addi	sp,sp,16
    8000221e:	8082                	ret

0000000080002220 <sys_fork>:

uint64
sys_fork(void)
{
    80002220:	1141                	addi	sp,sp,-16
    80002222:	e406                	sd	ra,8(sp)
    80002224:	e022                	sd	s0,0(sp)
    80002226:	0800                	addi	s0,sp,16
  return fork();
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	170080e7          	jalr	368(ra) # 80001398 <fork>
}
    80002230:	60a2                	ld	ra,8(sp)
    80002232:	6402                	ld	s0,0(sp)
    80002234:	0141                	addi	sp,sp,16
    80002236:	8082                	ret

0000000080002238 <sys_wait>:

uint64
sys_wait(void)
{
    80002238:	1101                	addi	sp,sp,-32
    8000223a:	ec06                	sd	ra,24(sp)
    8000223c:	e822                	sd	s0,16(sp)
    8000223e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002240:	fe840593          	addi	a1,s0,-24
    80002244:	4501                	li	a0,0
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	ed0080e7          	jalr	-304(ra) # 80002116 <argaddr>
  return wait(p);
    8000224e:	fe843503          	ld	a0,-24(s0)
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	712080e7          	jalr	1810(ra) # 80001964 <wait>
}
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	6105                	addi	sp,sp,32
    80002260:	8082                	ret

0000000080002262 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002262:	7179                	addi	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000226c:	fdc40593          	addi	a1,s0,-36
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	e84080e7          	jalr	-380(ra) # 800020f6 <argint>
  addr = myproc()->sz;
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	cba080e7          	jalr	-838(ra) # 80000f34 <myproc>
    80002282:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002284:	fdc42503          	lw	a0,-36(s0)
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	0b4080e7          	jalr	180(ra) # 8000133c <growproc>
    80002290:	00054863          	bltz	a0,800022a0 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002294:	8526                	mv	a0,s1
    80002296:	70a2                	ld	ra,40(sp)
    80002298:	7402                	ld	s0,32(sp)
    8000229a:	64e2                	ld	s1,24(sp)
    8000229c:	6145                	addi	sp,sp,48
    8000229e:	8082                	ret
    return -1;
    800022a0:	54fd                	li	s1,-1
    800022a2:	bfcd                	j	80002294 <sys_sbrk+0x32>

00000000800022a4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022a4:	7139                	addi	sp,sp,-64
    800022a6:	fc06                	sd	ra,56(sp)
    800022a8:	f822                	sd	s0,48(sp)
    800022aa:	f426                	sd	s1,40(sp)
    800022ac:	f04a                	sd	s2,32(sp)
    800022ae:	ec4e                	sd	s3,24(sp)
    800022b0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022b2:	fcc40593          	addi	a1,s0,-52
    800022b6:	4501                	li	a0,0
    800022b8:	00000097          	auipc	ra,0x0
    800022bc:	e3e080e7          	jalr	-450(ra) # 800020f6 <argint>
  acquire(&tickslock);
    800022c0:	0000c517          	auipc	a0,0xc
    800022c4:	6d050513          	addi	a0,a0,1744 # 8000e990 <tickslock>
    800022c8:	00004097          	auipc	ra,0x4
    800022cc:	0b2080e7          	jalr	178(ra) # 8000637a <acquire>
  ticks0 = ticks;
    800022d0:	00006917          	auipc	s2,0x6
    800022d4:	65892903          	lw	s2,1624(s2) # 80008928 <ticks>
  while(ticks - ticks0 < n){
    800022d8:	fcc42783          	lw	a5,-52(s0)
    800022dc:	cf9d                	beqz	a5,8000231a <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022de:	0000c997          	auipc	s3,0xc
    800022e2:	6b298993          	addi	s3,s3,1714 # 8000e990 <tickslock>
    800022e6:	00006497          	auipc	s1,0x6
    800022ea:	64248493          	addi	s1,s1,1602 # 80008928 <ticks>
    if(killed(myproc())){
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	c46080e7          	jalr	-954(ra) # 80000f34 <myproc>
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	63c080e7          	jalr	1596(ra) # 80001932 <killed>
    800022fe:	ed15                	bnez	a0,8000233a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002300:	85ce                	mv	a1,s3
    80002302:	8526                	mv	a0,s1
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	386080e7          	jalr	902(ra) # 8000168a <sleep>
  while(ticks - ticks0 < n){
    8000230c:	409c                	lw	a5,0(s1)
    8000230e:	412787bb          	subw	a5,a5,s2
    80002312:	fcc42703          	lw	a4,-52(s0)
    80002316:	fce7ece3          	bltu	a5,a4,800022ee <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000231a:	0000c517          	auipc	a0,0xc
    8000231e:	67650513          	addi	a0,a0,1654 # 8000e990 <tickslock>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	10c080e7          	jalr	268(ra) # 8000642e <release>
  return 0;
    8000232a:	4501                	li	a0,0
}
    8000232c:	70e2                	ld	ra,56(sp)
    8000232e:	7442                	ld	s0,48(sp)
    80002330:	74a2                	ld	s1,40(sp)
    80002332:	7902                	ld	s2,32(sp)
    80002334:	69e2                	ld	s3,24(sp)
    80002336:	6121                	addi	sp,sp,64
    80002338:	8082                	ret
      release(&tickslock);
    8000233a:	0000c517          	auipc	a0,0xc
    8000233e:	65650513          	addi	a0,a0,1622 # 8000e990 <tickslock>
    80002342:	00004097          	auipc	ra,0x4
    80002346:	0ec080e7          	jalr	236(ra) # 8000642e <release>
      return -1;
    8000234a:	557d                	li	a0,-1
    8000234c:	b7c5                	j	8000232c <sys_sleep+0x88>

000000008000234e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000234e:	7175                	addi	sp,sp,-144
    80002350:	e506                	sd	ra,136(sp)
    80002352:	e122                	sd	s0,128(sp)
    80002354:	fca6                	sd	s1,120(sp)
    80002356:	f8ca                	sd	s2,112(sp)
    80002358:	f4ce                	sd	s3,104(sp)
    8000235a:	f0d2                	sd	s4,96(sp)
    8000235c:	0900                	addi	s0,sp,144
  uint64 mask;
  struct proc *p;
  pte_t *pte;
  uint8 tmpmask[MAX_PAGE / 8];

  argaddr(0, &base);
    8000235e:	fc840593          	addi	a1,s0,-56
    80002362:	4501                	li	a0,0
    80002364:	00000097          	auipc	ra,0x0
    80002368:	db2080e7          	jalr	-590(ra) # 80002116 <argaddr>
  argint(1, &len);
    8000236c:	fc440593          	addi	a1,s0,-60
    80002370:	4505                	li	a0,1
    80002372:	00000097          	auipc	ra,0x0
    80002376:	d84080e7          	jalr	-636(ra) # 800020f6 <argint>
  argaddr(2, &mask);
    8000237a:	fb840593          	addi	a1,s0,-72
    8000237e:	4509                	li	a0,2
    80002380:	00000097          	auipc	ra,0x0
    80002384:	d96080e7          	jalr	-618(ra) # 80002116 <argaddr>

  base = PGROUNDDOWN(base);
    80002388:	777d                	lui	a4,0xfffff
    8000238a:	fc843783          	ld	a5,-56(s0)
    8000238e:	8ff9                	and	a5,a5,a4
    80002390:	fcf43423          	sd	a5,-56(s0)
  if (len > MAX_PAGE) {
    80002394:	fc442703          	lw	a4,-60(s0)
    80002398:	20000793          	li	a5,512
    8000239c:	0ce7c363          	blt	a5,a4,80002462 <sys_pgaccess+0x114>
    return -1;
  }

  memset(tmpmask, 0, MAX_PAGE / 8);
    800023a0:	04000613          	li	a2,64
    800023a4:	4581                	li	a1,0
    800023a6:	f7840513          	addi	a0,s0,-136
    800023aa:	ffffe097          	auipc	ra,0xffffe
    800023ae:	dce080e7          	jalr	-562(ra) # 80000178 <memset>

  p = myproc();
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	b82080e7          	jalr	-1150(ra) # 80000f34 <myproc>
    800023ba:	89aa                	mv	s3,a0

  for (int i = 0; i < len; i++) {
    800023bc:	fc442683          	lw	a3,-60(s0)
    800023c0:	06d05663          	blez	a3,8000242c <sys_pgaccess+0xde>
    800023c4:	4901                	li	s2,0
    if ((pte = walk(p->pagetable, base + i * PGSIZE, 0))) {
      if (*pte & PTE_A) {
        *pte = *pte & ~PTE_A;
        tmpmask[i / 8] |= (1 << (i % 8));
    800023c6:	4a05                	li	s4,1
    800023c8:	a801                	j	800023d8 <sys_pgaccess+0x8a>
  for (int i = 0; i < len; i++) {
    800023ca:	fc442683          	lw	a3,-60(s0)
    800023ce:	0905                	addi	s2,s2,1
    800023d0:	0009079b          	sext.w	a5,s2
    800023d4:	04d7dc63          	bge	a5,a3,8000242c <sys_pgaccess+0xde>
    800023d8:	0009049b          	sext.w	s1,s2
    if ((pte = walk(p->pagetable, base + i * PGSIZE, 0))) {
    800023dc:	00c91793          	slli	a5,s2,0xc
    800023e0:	4601                	li	a2,0
    800023e2:	fc843583          	ld	a1,-56(s0)
    800023e6:	95be                	add	a1,a1,a5
    800023e8:	0509b503          	ld	a0,80(s3)
    800023ec:	ffffe097          	auipc	ra,0xffffe
    800023f0:	070080e7          	jalr	112(ra) # 8000045c <walk>
    800023f4:	d979                	beqz	a0,800023ca <sys_pgaccess+0x7c>
      if (*pte & PTE_A) {
    800023f6:	611c                	ld	a5,0(a0)
    800023f8:	0407f713          	andi	a4,a5,64
    800023fc:	d779                	beqz	a4,800023ca <sys_pgaccess+0x7c>
        *pte = *pte & ~PTE_A;
    800023fe:	fbf7f793          	andi	a5,a5,-65
    80002402:	e11c                	sd	a5,0(a0)
        tmpmask[i / 8] |= (1 << (i % 8));
    80002404:	41f4d71b          	sraiw	a4,s1,0x1f
    80002408:	01d7571b          	srliw	a4,a4,0x1d
    8000240c:	9cb9                	addw	s1,s1,a4
    8000240e:	4034d79b          	sraiw	a5,s1,0x3
    80002412:	fd040693          	addi	a3,s0,-48
    80002416:	97b6                	add	a5,a5,a3
    80002418:	889d                	andi	s1,s1,7
    8000241a:	9c99                	subw	s1,s1,a4
    8000241c:	009a14bb          	sllw	s1,s4,s1
    80002420:	fa87c703          	lbu	a4,-88(a5)
    80002424:	8cd9                	or	s1,s1,a4
    80002426:	fa978423          	sb	s1,-88(a5)
    8000242a:	b745                	j	800023ca <sys_pgaccess+0x7c>
      }
    }
  }

  copyout(p->pagetable, mask, (char *)tmpmask, (len + 7) / 8);
    8000242c:	269d                	addiw	a3,a3,7
    8000242e:	41f6d79b          	sraiw	a5,a3,0x1f
    80002432:	01d7d79b          	srliw	a5,a5,0x1d
    80002436:	9ebd                	addw	a3,a3,a5
    80002438:	4036d69b          	sraiw	a3,a3,0x3
    8000243c:	f7840613          	addi	a2,s0,-136
    80002440:	fb843583          	ld	a1,-72(s0)
    80002444:	0509b503          	ld	a0,80(s3)
    80002448:	ffffe097          	auipc	ra,0xffffe
    8000244c:	6c6080e7          	jalr	1734(ra) # 80000b0e <copyout>

  return 0;
    80002450:	4501                	li	a0,0
}
    80002452:	60aa                	ld	ra,136(sp)
    80002454:	640a                	ld	s0,128(sp)
    80002456:	74e6                	ld	s1,120(sp)
    80002458:	7946                	ld	s2,112(sp)
    8000245a:	79a6                	ld	s3,104(sp)
    8000245c:	7a06                	ld	s4,96(sp)
    8000245e:	6149                	addi	sp,sp,144
    80002460:	8082                	ret
    return -1;
    80002462:	557d                	li	a0,-1
    80002464:	b7fd                	j	80002452 <sys_pgaccess+0x104>

0000000080002466 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002466:	1101                	addi	sp,sp,-32
    80002468:	ec06                	sd	ra,24(sp)
    8000246a:	e822                	sd	s0,16(sp)
    8000246c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000246e:	fec40593          	addi	a1,s0,-20
    80002472:	4501                	li	a0,0
    80002474:	00000097          	auipc	ra,0x0
    80002478:	c82080e7          	jalr	-894(ra) # 800020f6 <argint>
  return kill(pid);
    8000247c:	fec42503          	lw	a0,-20(s0)
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	414080e7          	jalr	1044(ra) # 80001894 <kill>
}
    80002488:	60e2                	ld	ra,24(sp)
    8000248a:	6442                	ld	s0,16(sp)
    8000248c:	6105                	addi	sp,sp,32
    8000248e:	8082                	ret

0000000080002490 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002490:	1101                	addi	sp,sp,-32
    80002492:	ec06                	sd	ra,24(sp)
    80002494:	e822                	sd	s0,16(sp)
    80002496:	e426                	sd	s1,8(sp)
    80002498:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000249a:	0000c517          	auipc	a0,0xc
    8000249e:	4f650513          	addi	a0,a0,1270 # 8000e990 <tickslock>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	ed8080e7          	jalr	-296(ra) # 8000637a <acquire>
  xticks = ticks;
    800024aa:	00006497          	auipc	s1,0x6
    800024ae:	47e4a483          	lw	s1,1150(s1) # 80008928 <ticks>
  release(&tickslock);
    800024b2:	0000c517          	auipc	a0,0xc
    800024b6:	4de50513          	addi	a0,a0,1246 # 8000e990 <tickslock>
    800024ba:	00004097          	auipc	ra,0x4
    800024be:	f74080e7          	jalr	-140(ra) # 8000642e <release>
  return xticks;
}
    800024c2:	02049513          	slli	a0,s1,0x20
    800024c6:	9101                	srli	a0,a0,0x20
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6105                	addi	sp,sp,32
    800024d0:	8082                	ret

00000000800024d2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024d2:	7179                	addi	sp,sp,-48
    800024d4:	f406                	sd	ra,40(sp)
    800024d6:	f022                	sd	s0,32(sp)
    800024d8:	ec26                	sd	s1,24(sp)
    800024da:	e84a                	sd	s2,16(sp)
    800024dc:	e44e                	sd	s3,8(sp)
    800024de:	e052                	sd	s4,0(sp)
    800024e0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024e2:	00006597          	auipc	a1,0x6
    800024e6:	01658593          	addi	a1,a1,22 # 800084f8 <syscalls+0xf8>
    800024ea:	0000c517          	auipc	a0,0xc
    800024ee:	4be50513          	addi	a0,a0,1214 # 8000e9a8 <bcache>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	df8080e7          	jalr	-520(ra) # 800062ea <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024fa:	00014797          	auipc	a5,0x14
    800024fe:	4ae78793          	addi	a5,a5,1198 # 800169a8 <bcache+0x8000>
    80002502:	00014717          	auipc	a4,0x14
    80002506:	70e70713          	addi	a4,a4,1806 # 80016c10 <bcache+0x8268>
    8000250a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000250e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002512:	0000c497          	auipc	s1,0xc
    80002516:	4ae48493          	addi	s1,s1,1198 # 8000e9c0 <bcache+0x18>
    b->next = bcache.head.next;
    8000251a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000251c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000251e:	00006a17          	auipc	s4,0x6
    80002522:	fe2a0a13          	addi	s4,s4,-30 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    80002526:	2b893783          	ld	a5,696(s2)
    8000252a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000252c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002530:	85d2                	mv	a1,s4
    80002532:	01048513          	addi	a0,s1,16
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	4c4080e7          	jalr	1220(ra) # 800039fa <initsleeplock>
    bcache.head.next->prev = b;
    8000253e:	2b893783          	ld	a5,696(s2)
    80002542:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002544:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002548:	45848493          	addi	s1,s1,1112
    8000254c:	fd349de3          	bne	s1,s3,80002526 <binit+0x54>
  }
}
    80002550:	70a2                	ld	ra,40(sp)
    80002552:	7402                	ld	s0,32(sp)
    80002554:	64e2                	ld	s1,24(sp)
    80002556:	6942                	ld	s2,16(sp)
    80002558:	69a2                	ld	s3,8(sp)
    8000255a:	6a02                	ld	s4,0(sp)
    8000255c:	6145                	addi	sp,sp,48
    8000255e:	8082                	ret

0000000080002560 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002560:	7179                	addi	sp,sp,-48
    80002562:	f406                	sd	ra,40(sp)
    80002564:	f022                	sd	s0,32(sp)
    80002566:	ec26                	sd	s1,24(sp)
    80002568:	e84a                	sd	s2,16(sp)
    8000256a:	e44e                	sd	s3,8(sp)
    8000256c:	1800                	addi	s0,sp,48
    8000256e:	892a                	mv	s2,a0
    80002570:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002572:	0000c517          	auipc	a0,0xc
    80002576:	43650513          	addi	a0,a0,1078 # 8000e9a8 <bcache>
    8000257a:	00004097          	auipc	ra,0x4
    8000257e:	e00080e7          	jalr	-512(ra) # 8000637a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002582:	00014497          	auipc	s1,0x14
    80002586:	6de4b483          	ld	s1,1758(s1) # 80016c60 <bcache+0x82b8>
    8000258a:	00014797          	auipc	a5,0x14
    8000258e:	68678793          	addi	a5,a5,1670 # 80016c10 <bcache+0x8268>
    80002592:	02f48f63          	beq	s1,a5,800025d0 <bread+0x70>
    80002596:	873e                	mv	a4,a5
    80002598:	a021                	j	800025a0 <bread+0x40>
    8000259a:	68a4                	ld	s1,80(s1)
    8000259c:	02e48a63          	beq	s1,a4,800025d0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025a0:	449c                	lw	a5,8(s1)
    800025a2:	ff279ce3          	bne	a5,s2,8000259a <bread+0x3a>
    800025a6:	44dc                	lw	a5,12(s1)
    800025a8:	ff3799e3          	bne	a5,s3,8000259a <bread+0x3a>
      b->refcnt++;
    800025ac:	40bc                	lw	a5,64(s1)
    800025ae:	2785                	addiw	a5,a5,1
    800025b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025b2:	0000c517          	auipc	a0,0xc
    800025b6:	3f650513          	addi	a0,a0,1014 # 8000e9a8 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	e74080e7          	jalr	-396(ra) # 8000642e <release>
      acquiresleep(&b->lock);
    800025c2:	01048513          	addi	a0,s1,16
    800025c6:	00001097          	auipc	ra,0x1
    800025ca:	46e080e7          	jalr	1134(ra) # 80003a34 <acquiresleep>
      return b;
    800025ce:	a8b9                	j	8000262c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025d0:	00014497          	auipc	s1,0x14
    800025d4:	6884b483          	ld	s1,1672(s1) # 80016c58 <bcache+0x82b0>
    800025d8:	00014797          	auipc	a5,0x14
    800025dc:	63878793          	addi	a5,a5,1592 # 80016c10 <bcache+0x8268>
    800025e0:	00f48863          	beq	s1,a5,800025f0 <bread+0x90>
    800025e4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025e6:	40bc                	lw	a5,64(s1)
    800025e8:	cf81                	beqz	a5,80002600 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025ea:	64a4                	ld	s1,72(s1)
    800025ec:	fee49de3          	bne	s1,a4,800025e6 <bread+0x86>
  panic("bget: no buffers");
    800025f0:	00006517          	auipc	a0,0x6
    800025f4:	f1850513          	addi	a0,a0,-232 # 80008508 <syscalls+0x108>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	846080e7          	jalr	-1978(ra) # 80005e3e <panic>
      b->dev = dev;
    80002600:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002604:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002608:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000260c:	4785                	li	a5,1
    8000260e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002610:	0000c517          	auipc	a0,0xc
    80002614:	39850513          	addi	a0,a0,920 # 8000e9a8 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	e16080e7          	jalr	-490(ra) # 8000642e <release>
      acquiresleep(&b->lock);
    80002620:	01048513          	addi	a0,s1,16
    80002624:	00001097          	auipc	ra,0x1
    80002628:	410080e7          	jalr	1040(ra) # 80003a34 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000262c:	409c                	lw	a5,0(s1)
    8000262e:	cb89                	beqz	a5,80002640 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002630:	8526                	mv	a0,s1
    80002632:	70a2                	ld	ra,40(sp)
    80002634:	7402                	ld	s0,32(sp)
    80002636:	64e2                	ld	s1,24(sp)
    80002638:	6942                	ld	s2,16(sp)
    8000263a:	69a2                	ld	s3,8(sp)
    8000263c:	6145                	addi	sp,sp,48
    8000263e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002640:	4581                	li	a1,0
    80002642:	8526                	mv	a0,s1
    80002644:	00003097          	auipc	ra,0x3
    80002648:	ff0080e7          	jalr	-16(ra) # 80005634 <virtio_disk_rw>
    b->valid = 1;
    8000264c:	4785                	li	a5,1
    8000264e:	c09c                	sw	a5,0(s1)
  return b;
    80002650:	b7c5                	j	80002630 <bread+0xd0>

0000000080002652 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002652:	1101                	addi	sp,sp,-32
    80002654:	ec06                	sd	ra,24(sp)
    80002656:	e822                	sd	s0,16(sp)
    80002658:	e426                	sd	s1,8(sp)
    8000265a:	1000                	addi	s0,sp,32
    8000265c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000265e:	0541                	addi	a0,a0,16
    80002660:	00001097          	auipc	ra,0x1
    80002664:	46e080e7          	jalr	1134(ra) # 80003ace <holdingsleep>
    80002668:	cd01                	beqz	a0,80002680 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000266a:	4585                	li	a1,1
    8000266c:	8526                	mv	a0,s1
    8000266e:	00003097          	auipc	ra,0x3
    80002672:	fc6080e7          	jalr	-58(ra) # 80005634 <virtio_disk_rw>
}
    80002676:	60e2                	ld	ra,24(sp)
    80002678:	6442                	ld	s0,16(sp)
    8000267a:	64a2                	ld	s1,8(sp)
    8000267c:	6105                	addi	sp,sp,32
    8000267e:	8082                	ret
    panic("bwrite");
    80002680:	00006517          	auipc	a0,0x6
    80002684:	ea050513          	addi	a0,a0,-352 # 80008520 <syscalls+0x120>
    80002688:	00003097          	auipc	ra,0x3
    8000268c:	7b6080e7          	jalr	1974(ra) # 80005e3e <panic>

0000000080002690 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002690:	1101                	addi	sp,sp,-32
    80002692:	ec06                	sd	ra,24(sp)
    80002694:	e822                	sd	s0,16(sp)
    80002696:	e426                	sd	s1,8(sp)
    80002698:	e04a                	sd	s2,0(sp)
    8000269a:	1000                	addi	s0,sp,32
    8000269c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000269e:	01050913          	addi	s2,a0,16
    800026a2:	854a                	mv	a0,s2
    800026a4:	00001097          	auipc	ra,0x1
    800026a8:	42a080e7          	jalr	1066(ra) # 80003ace <holdingsleep>
    800026ac:	c92d                	beqz	a0,8000271e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026ae:	854a                	mv	a0,s2
    800026b0:	00001097          	auipc	ra,0x1
    800026b4:	3da080e7          	jalr	986(ra) # 80003a8a <releasesleep>

  acquire(&bcache.lock);
    800026b8:	0000c517          	auipc	a0,0xc
    800026bc:	2f050513          	addi	a0,a0,752 # 8000e9a8 <bcache>
    800026c0:	00004097          	auipc	ra,0x4
    800026c4:	cba080e7          	jalr	-838(ra) # 8000637a <acquire>
  b->refcnt--;
    800026c8:	40bc                	lw	a5,64(s1)
    800026ca:	37fd                	addiw	a5,a5,-1
    800026cc:	0007871b          	sext.w	a4,a5
    800026d0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026d2:	eb05                	bnez	a4,80002702 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026d4:	68bc                	ld	a5,80(s1)
    800026d6:	64b8                	ld	a4,72(s1)
    800026d8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026da:	64bc                	ld	a5,72(s1)
    800026dc:	68b8                	ld	a4,80(s1)
    800026de:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026e0:	00014797          	auipc	a5,0x14
    800026e4:	2c878793          	addi	a5,a5,712 # 800169a8 <bcache+0x8000>
    800026e8:	2b87b703          	ld	a4,696(a5)
    800026ec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026ee:	00014717          	auipc	a4,0x14
    800026f2:	52270713          	addi	a4,a4,1314 # 80016c10 <bcache+0x8268>
    800026f6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026f8:	2b87b703          	ld	a4,696(a5)
    800026fc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026fe:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002702:	0000c517          	auipc	a0,0xc
    80002706:	2a650513          	addi	a0,a0,678 # 8000e9a8 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	d24080e7          	jalr	-732(ra) # 8000642e <release>
}
    80002712:	60e2                	ld	ra,24(sp)
    80002714:	6442                	ld	s0,16(sp)
    80002716:	64a2                	ld	s1,8(sp)
    80002718:	6902                	ld	s2,0(sp)
    8000271a:	6105                	addi	sp,sp,32
    8000271c:	8082                	ret
    panic("brelse");
    8000271e:	00006517          	auipc	a0,0x6
    80002722:	e0a50513          	addi	a0,a0,-502 # 80008528 <syscalls+0x128>
    80002726:	00003097          	auipc	ra,0x3
    8000272a:	718080e7          	jalr	1816(ra) # 80005e3e <panic>

000000008000272e <bpin>:

void
bpin(struct buf *b) {
    8000272e:	1101                	addi	sp,sp,-32
    80002730:	ec06                	sd	ra,24(sp)
    80002732:	e822                	sd	s0,16(sp)
    80002734:	e426                	sd	s1,8(sp)
    80002736:	1000                	addi	s0,sp,32
    80002738:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000273a:	0000c517          	auipc	a0,0xc
    8000273e:	26e50513          	addi	a0,a0,622 # 8000e9a8 <bcache>
    80002742:	00004097          	auipc	ra,0x4
    80002746:	c38080e7          	jalr	-968(ra) # 8000637a <acquire>
  b->refcnt++;
    8000274a:	40bc                	lw	a5,64(s1)
    8000274c:	2785                	addiw	a5,a5,1
    8000274e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002750:	0000c517          	auipc	a0,0xc
    80002754:	25850513          	addi	a0,a0,600 # 8000e9a8 <bcache>
    80002758:	00004097          	auipc	ra,0x4
    8000275c:	cd6080e7          	jalr	-810(ra) # 8000642e <release>
}
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6105                	addi	sp,sp,32
    80002768:	8082                	ret

000000008000276a <bunpin>:

void
bunpin(struct buf *b) {
    8000276a:	1101                	addi	sp,sp,-32
    8000276c:	ec06                	sd	ra,24(sp)
    8000276e:	e822                	sd	s0,16(sp)
    80002770:	e426                	sd	s1,8(sp)
    80002772:	1000                	addi	s0,sp,32
    80002774:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002776:	0000c517          	auipc	a0,0xc
    8000277a:	23250513          	addi	a0,a0,562 # 8000e9a8 <bcache>
    8000277e:	00004097          	auipc	ra,0x4
    80002782:	bfc080e7          	jalr	-1028(ra) # 8000637a <acquire>
  b->refcnt--;
    80002786:	40bc                	lw	a5,64(s1)
    80002788:	37fd                	addiw	a5,a5,-1
    8000278a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000278c:	0000c517          	auipc	a0,0xc
    80002790:	21c50513          	addi	a0,a0,540 # 8000e9a8 <bcache>
    80002794:	00004097          	auipc	ra,0x4
    80002798:	c9a080e7          	jalr	-870(ra) # 8000642e <release>
}
    8000279c:	60e2                	ld	ra,24(sp)
    8000279e:	6442                	ld	s0,16(sp)
    800027a0:	64a2                	ld	s1,8(sp)
    800027a2:	6105                	addi	sp,sp,32
    800027a4:	8082                	ret

00000000800027a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027a6:	1101                	addi	sp,sp,-32
    800027a8:	ec06                	sd	ra,24(sp)
    800027aa:	e822                	sd	s0,16(sp)
    800027ac:	e426                	sd	s1,8(sp)
    800027ae:	e04a                	sd	s2,0(sp)
    800027b0:	1000                	addi	s0,sp,32
    800027b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027b4:	00d5d59b          	srliw	a1,a1,0xd
    800027b8:	00015797          	auipc	a5,0x15
    800027bc:	8cc7a783          	lw	a5,-1844(a5) # 80017084 <sb+0x1c>
    800027c0:	9dbd                	addw	a1,a1,a5
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	d9e080e7          	jalr	-610(ra) # 80002560 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027ca:	0074f713          	andi	a4,s1,7
    800027ce:	4785                	li	a5,1
    800027d0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027d4:	14ce                	slli	s1,s1,0x33
    800027d6:	90d9                	srli	s1,s1,0x36
    800027d8:	00950733          	add	a4,a0,s1
    800027dc:	05874703          	lbu	a4,88(a4)
    800027e0:	00e7f6b3          	and	a3,a5,a4
    800027e4:	c69d                	beqz	a3,80002812 <bfree+0x6c>
    800027e6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027e8:	94aa                	add	s1,s1,a0
    800027ea:	fff7c793          	not	a5,a5
    800027ee:	8ff9                	and	a5,a5,a4
    800027f0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027f4:	00001097          	auipc	ra,0x1
    800027f8:	120080e7          	jalr	288(ra) # 80003914 <log_write>
  brelse(bp);
    800027fc:	854a                	mv	a0,s2
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	e92080e7          	jalr	-366(ra) # 80002690 <brelse>
}
    80002806:	60e2                	ld	ra,24(sp)
    80002808:	6442                	ld	s0,16(sp)
    8000280a:	64a2                	ld	s1,8(sp)
    8000280c:	6902                	ld	s2,0(sp)
    8000280e:	6105                	addi	sp,sp,32
    80002810:	8082                	ret
    panic("freeing free block");
    80002812:	00006517          	auipc	a0,0x6
    80002816:	d1e50513          	addi	a0,a0,-738 # 80008530 <syscalls+0x130>
    8000281a:	00003097          	auipc	ra,0x3
    8000281e:	624080e7          	jalr	1572(ra) # 80005e3e <panic>

0000000080002822 <balloc>:
{
    80002822:	711d                	addi	sp,sp,-96
    80002824:	ec86                	sd	ra,88(sp)
    80002826:	e8a2                	sd	s0,80(sp)
    80002828:	e4a6                	sd	s1,72(sp)
    8000282a:	e0ca                	sd	s2,64(sp)
    8000282c:	fc4e                	sd	s3,56(sp)
    8000282e:	f852                	sd	s4,48(sp)
    80002830:	f456                	sd	s5,40(sp)
    80002832:	f05a                	sd	s6,32(sp)
    80002834:	ec5e                	sd	s7,24(sp)
    80002836:	e862                	sd	s8,16(sp)
    80002838:	e466                	sd	s9,8(sp)
    8000283a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000283c:	00015797          	auipc	a5,0x15
    80002840:	8307a783          	lw	a5,-2000(a5) # 8001706c <sb+0x4>
    80002844:	10078163          	beqz	a5,80002946 <balloc+0x124>
    80002848:	8baa                	mv	s7,a0
    8000284a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000284c:	00015b17          	auipc	s6,0x15
    80002850:	81cb0b13          	addi	s6,s6,-2020 # 80017068 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002854:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002856:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002858:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000285a:	6c89                	lui	s9,0x2
    8000285c:	a061                	j	800028e4 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000285e:	974a                	add	a4,a4,s2
    80002860:	8fd5                	or	a5,a5,a3
    80002862:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002866:	854a                	mv	a0,s2
    80002868:	00001097          	auipc	ra,0x1
    8000286c:	0ac080e7          	jalr	172(ra) # 80003914 <log_write>
        brelse(bp);
    80002870:	854a                	mv	a0,s2
    80002872:	00000097          	auipc	ra,0x0
    80002876:	e1e080e7          	jalr	-482(ra) # 80002690 <brelse>
  bp = bread(dev, bno);
    8000287a:	85a6                	mv	a1,s1
    8000287c:	855e                	mv	a0,s7
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	ce2080e7          	jalr	-798(ra) # 80002560 <bread>
    80002886:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002888:	40000613          	li	a2,1024
    8000288c:	4581                	li	a1,0
    8000288e:	05850513          	addi	a0,a0,88
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	8e6080e7          	jalr	-1818(ra) # 80000178 <memset>
  log_write(bp);
    8000289a:	854a                	mv	a0,s2
    8000289c:	00001097          	auipc	ra,0x1
    800028a0:	078080e7          	jalr	120(ra) # 80003914 <log_write>
  brelse(bp);
    800028a4:	854a                	mv	a0,s2
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	dea080e7          	jalr	-534(ra) # 80002690 <brelse>
}
    800028ae:	8526                	mv	a0,s1
    800028b0:	60e6                	ld	ra,88(sp)
    800028b2:	6446                	ld	s0,80(sp)
    800028b4:	64a6                	ld	s1,72(sp)
    800028b6:	6906                	ld	s2,64(sp)
    800028b8:	79e2                	ld	s3,56(sp)
    800028ba:	7a42                	ld	s4,48(sp)
    800028bc:	7aa2                	ld	s5,40(sp)
    800028be:	7b02                	ld	s6,32(sp)
    800028c0:	6be2                	ld	s7,24(sp)
    800028c2:	6c42                	ld	s8,16(sp)
    800028c4:	6ca2                	ld	s9,8(sp)
    800028c6:	6125                	addi	sp,sp,96
    800028c8:	8082                	ret
    brelse(bp);
    800028ca:	854a                	mv	a0,s2
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	dc4080e7          	jalr	-572(ra) # 80002690 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028d4:	015c87bb          	addw	a5,s9,s5
    800028d8:	00078a9b          	sext.w	s5,a5
    800028dc:	004b2703          	lw	a4,4(s6)
    800028e0:	06eaf363          	bgeu	s5,a4,80002946 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800028e4:	41fad79b          	sraiw	a5,s5,0x1f
    800028e8:	0137d79b          	srliw	a5,a5,0x13
    800028ec:	015787bb          	addw	a5,a5,s5
    800028f0:	40d7d79b          	sraiw	a5,a5,0xd
    800028f4:	01cb2583          	lw	a1,28(s6)
    800028f8:	9dbd                	addw	a1,a1,a5
    800028fa:	855e                	mv	a0,s7
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	c64080e7          	jalr	-924(ra) # 80002560 <bread>
    80002904:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002906:	004b2503          	lw	a0,4(s6)
    8000290a:	000a849b          	sext.w	s1,s5
    8000290e:	8662                	mv	a2,s8
    80002910:	faa4fde3          	bgeu	s1,a0,800028ca <balloc+0xa8>
      m = 1 << (bi % 8);
    80002914:	41f6579b          	sraiw	a5,a2,0x1f
    80002918:	01d7d69b          	srliw	a3,a5,0x1d
    8000291c:	00c6873b          	addw	a4,a3,a2
    80002920:	00777793          	andi	a5,a4,7
    80002924:	9f95                	subw	a5,a5,a3
    80002926:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000292a:	4037571b          	sraiw	a4,a4,0x3
    8000292e:	00e906b3          	add	a3,s2,a4
    80002932:	0586c683          	lbu	a3,88(a3)
    80002936:	00d7f5b3          	and	a1,a5,a3
    8000293a:	d195                	beqz	a1,8000285e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000293c:	2605                	addiw	a2,a2,1
    8000293e:	2485                	addiw	s1,s1,1
    80002940:	fd4618e3          	bne	a2,s4,80002910 <balloc+0xee>
    80002944:	b759                	j	800028ca <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002946:	00006517          	auipc	a0,0x6
    8000294a:	c0250513          	addi	a0,a0,-1022 # 80008548 <syscalls+0x148>
    8000294e:	00003097          	auipc	ra,0x3
    80002952:	53a080e7          	jalr	1338(ra) # 80005e88 <printf>
  return 0;
    80002956:	4481                	li	s1,0
    80002958:	bf99                	j	800028ae <balloc+0x8c>

000000008000295a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000295a:	7179                	addi	sp,sp,-48
    8000295c:	f406                	sd	ra,40(sp)
    8000295e:	f022                	sd	s0,32(sp)
    80002960:	ec26                	sd	s1,24(sp)
    80002962:	e84a                	sd	s2,16(sp)
    80002964:	e44e                	sd	s3,8(sp)
    80002966:	e052                	sd	s4,0(sp)
    80002968:	1800                	addi	s0,sp,48
    8000296a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000296c:	47ad                	li	a5,11
    8000296e:	02b7e763          	bltu	a5,a1,8000299c <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002972:	02059493          	slli	s1,a1,0x20
    80002976:	9081                	srli	s1,s1,0x20
    80002978:	048a                	slli	s1,s1,0x2
    8000297a:	94aa                	add	s1,s1,a0
    8000297c:	0504a903          	lw	s2,80(s1)
    80002980:	06091e63          	bnez	s2,800029fc <bmap+0xa2>
      addr = balloc(ip->dev);
    80002984:	4108                	lw	a0,0(a0)
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	e9c080e7          	jalr	-356(ra) # 80002822 <balloc>
    8000298e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002992:	06090563          	beqz	s2,800029fc <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002996:	0524a823          	sw	s2,80(s1)
    8000299a:	a08d                	j	800029fc <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000299c:	ff45849b          	addiw	s1,a1,-12
    800029a0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029a4:	0ff00793          	li	a5,255
    800029a8:	08e7e563          	bltu	a5,a4,80002a32 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029ac:	08052903          	lw	s2,128(a0)
    800029b0:	00091d63          	bnez	s2,800029ca <bmap+0x70>
      addr = balloc(ip->dev);
    800029b4:	4108                	lw	a0,0(a0)
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	e6c080e7          	jalr	-404(ra) # 80002822 <balloc>
    800029be:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029c2:	02090d63          	beqz	s2,800029fc <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029c6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029ca:	85ca                	mv	a1,s2
    800029cc:	0009a503          	lw	a0,0(s3)
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	b90080e7          	jalr	-1136(ra) # 80002560 <bread>
    800029d8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029da:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029de:	02049593          	slli	a1,s1,0x20
    800029e2:	9181                	srli	a1,a1,0x20
    800029e4:	058a                	slli	a1,a1,0x2
    800029e6:	00b784b3          	add	s1,a5,a1
    800029ea:	0004a903          	lw	s2,0(s1)
    800029ee:	02090063          	beqz	s2,80002a0e <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029f2:	8552                	mv	a0,s4
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	c9c080e7          	jalr	-868(ra) # 80002690 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029fc:	854a                	mv	a0,s2
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6a02                	ld	s4,0(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
      addr = balloc(ip->dev);
    80002a0e:	0009a503          	lw	a0,0(s3)
    80002a12:	00000097          	auipc	ra,0x0
    80002a16:	e10080e7          	jalr	-496(ra) # 80002822 <balloc>
    80002a1a:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a1e:	fc090ae3          	beqz	s2,800029f2 <bmap+0x98>
        a[bn] = addr;
    80002a22:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a26:	8552                	mv	a0,s4
    80002a28:	00001097          	auipc	ra,0x1
    80002a2c:	eec080e7          	jalr	-276(ra) # 80003914 <log_write>
    80002a30:	b7c9                	j	800029f2 <bmap+0x98>
  panic("bmap: out of range");
    80002a32:	00006517          	auipc	a0,0x6
    80002a36:	b2e50513          	addi	a0,a0,-1234 # 80008560 <syscalls+0x160>
    80002a3a:	00003097          	auipc	ra,0x3
    80002a3e:	404080e7          	jalr	1028(ra) # 80005e3e <panic>

0000000080002a42 <iget>:
{
    80002a42:	7179                	addi	sp,sp,-48
    80002a44:	f406                	sd	ra,40(sp)
    80002a46:	f022                	sd	s0,32(sp)
    80002a48:	ec26                	sd	s1,24(sp)
    80002a4a:	e84a                	sd	s2,16(sp)
    80002a4c:	e44e                	sd	s3,8(sp)
    80002a4e:	e052                	sd	s4,0(sp)
    80002a50:	1800                	addi	s0,sp,48
    80002a52:	89aa                	mv	s3,a0
    80002a54:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a56:	00014517          	auipc	a0,0x14
    80002a5a:	63250513          	addi	a0,a0,1586 # 80017088 <itable>
    80002a5e:	00004097          	auipc	ra,0x4
    80002a62:	91c080e7          	jalr	-1764(ra) # 8000637a <acquire>
  empty = 0;
    80002a66:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a68:	00014497          	auipc	s1,0x14
    80002a6c:	63848493          	addi	s1,s1,1592 # 800170a0 <itable+0x18>
    80002a70:	00016697          	auipc	a3,0x16
    80002a74:	0c068693          	addi	a3,a3,192 # 80018b30 <log>
    80002a78:	a039                	j	80002a86 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a7a:	02090b63          	beqz	s2,80002ab0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a7e:	08848493          	addi	s1,s1,136
    80002a82:	02d48a63          	beq	s1,a3,80002ab6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a86:	449c                	lw	a5,8(s1)
    80002a88:	fef059e3          	blez	a5,80002a7a <iget+0x38>
    80002a8c:	4098                	lw	a4,0(s1)
    80002a8e:	ff3716e3          	bne	a4,s3,80002a7a <iget+0x38>
    80002a92:	40d8                	lw	a4,4(s1)
    80002a94:	ff4713e3          	bne	a4,s4,80002a7a <iget+0x38>
      ip->ref++;
    80002a98:	2785                	addiw	a5,a5,1
    80002a9a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a9c:	00014517          	auipc	a0,0x14
    80002aa0:	5ec50513          	addi	a0,a0,1516 # 80017088 <itable>
    80002aa4:	00004097          	auipc	ra,0x4
    80002aa8:	98a080e7          	jalr	-1654(ra) # 8000642e <release>
      return ip;
    80002aac:	8926                	mv	s2,s1
    80002aae:	a03d                	j	80002adc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ab0:	f7f9                	bnez	a5,80002a7e <iget+0x3c>
    80002ab2:	8926                	mv	s2,s1
    80002ab4:	b7e9                	j	80002a7e <iget+0x3c>
  if(empty == 0)
    80002ab6:	02090c63          	beqz	s2,80002aee <iget+0xac>
  ip->dev = dev;
    80002aba:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002abe:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ac2:	4785                	li	a5,1
    80002ac4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ac8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002acc:	00014517          	auipc	a0,0x14
    80002ad0:	5bc50513          	addi	a0,a0,1468 # 80017088 <itable>
    80002ad4:	00004097          	auipc	ra,0x4
    80002ad8:	95a080e7          	jalr	-1702(ra) # 8000642e <release>
}
    80002adc:	854a                	mv	a0,s2
    80002ade:	70a2                	ld	ra,40(sp)
    80002ae0:	7402                	ld	s0,32(sp)
    80002ae2:	64e2                	ld	s1,24(sp)
    80002ae4:	6942                	ld	s2,16(sp)
    80002ae6:	69a2                	ld	s3,8(sp)
    80002ae8:	6a02                	ld	s4,0(sp)
    80002aea:	6145                	addi	sp,sp,48
    80002aec:	8082                	ret
    panic("iget: no inodes");
    80002aee:	00006517          	auipc	a0,0x6
    80002af2:	a8a50513          	addi	a0,a0,-1398 # 80008578 <syscalls+0x178>
    80002af6:	00003097          	auipc	ra,0x3
    80002afa:	348080e7          	jalr	840(ra) # 80005e3e <panic>

0000000080002afe <fsinit>:
fsinit(int dev) {
    80002afe:	7179                	addi	sp,sp,-48
    80002b00:	f406                	sd	ra,40(sp)
    80002b02:	f022                	sd	s0,32(sp)
    80002b04:	ec26                	sd	s1,24(sp)
    80002b06:	e84a                	sd	s2,16(sp)
    80002b08:	e44e                	sd	s3,8(sp)
    80002b0a:	1800                	addi	s0,sp,48
    80002b0c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b0e:	4585                	li	a1,1
    80002b10:	00000097          	auipc	ra,0x0
    80002b14:	a50080e7          	jalr	-1456(ra) # 80002560 <bread>
    80002b18:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b1a:	00014997          	auipc	s3,0x14
    80002b1e:	54e98993          	addi	s3,s3,1358 # 80017068 <sb>
    80002b22:	02000613          	li	a2,32
    80002b26:	05850593          	addi	a1,a0,88
    80002b2a:	854e                	mv	a0,s3
    80002b2c:	ffffd097          	auipc	ra,0xffffd
    80002b30:	6a8080e7          	jalr	1704(ra) # 800001d4 <memmove>
  brelse(bp);
    80002b34:	8526                	mv	a0,s1
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	b5a080e7          	jalr	-1190(ra) # 80002690 <brelse>
  if(sb.magic != FSMAGIC)
    80002b3e:	0009a703          	lw	a4,0(s3)
    80002b42:	102037b7          	lui	a5,0x10203
    80002b46:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b4a:	02f71263          	bne	a4,a5,80002b6e <fsinit+0x70>
  initlog(dev, &sb);
    80002b4e:	00014597          	auipc	a1,0x14
    80002b52:	51a58593          	addi	a1,a1,1306 # 80017068 <sb>
    80002b56:	854a                	mv	a0,s2
    80002b58:	00001097          	auipc	ra,0x1
    80002b5c:	b40080e7          	jalr	-1216(ra) # 80003698 <initlog>
}
    80002b60:	70a2                	ld	ra,40(sp)
    80002b62:	7402                	ld	s0,32(sp)
    80002b64:	64e2                	ld	s1,24(sp)
    80002b66:	6942                	ld	s2,16(sp)
    80002b68:	69a2                	ld	s3,8(sp)
    80002b6a:	6145                	addi	sp,sp,48
    80002b6c:	8082                	ret
    panic("invalid file system");
    80002b6e:	00006517          	auipc	a0,0x6
    80002b72:	a1a50513          	addi	a0,a0,-1510 # 80008588 <syscalls+0x188>
    80002b76:	00003097          	auipc	ra,0x3
    80002b7a:	2c8080e7          	jalr	712(ra) # 80005e3e <panic>

0000000080002b7e <iinit>:
{
    80002b7e:	7179                	addi	sp,sp,-48
    80002b80:	f406                	sd	ra,40(sp)
    80002b82:	f022                	sd	s0,32(sp)
    80002b84:	ec26                	sd	s1,24(sp)
    80002b86:	e84a                	sd	s2,16(sp)
    80002b88:	e44e                	sd	s3,8(sp)
    80002b8a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b8c:	00006597          	auipc	a1,0x6
    80002b90:	a1458593          	addi	a1,a1,-1516 # 800085a0 <syscalls+0x1a0>
    80002b94:	00014517          	auipc	a0,0x14
    80002b98:	4f450513          	addi	a0,a0,1268 # 80017088 <itable>
    80002b9c:	00003097          	auipc	ra,0x3
    80002ba0:	74e080e7          	jalr	1870(ra) # 800062ea <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ba4:	00014497          	auipc	s1,0x14
    80002ba8:	50c48493          	addi	s1,s1,1292 # 800170b0 <itable+0x28>
    80002bac:	00016997          	auipc	s3,0x16
    80002bb0:	f9498993          	addi	s3,s3,-108 # 80018b40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bb4:	00006917          	auipc	s2,0x6
    80002bb8:	9f490913          	addi	s2,s2,-1548 # 800085a8 <syscalls+0x1a8>
    80002bbc:	85ca                	mv	a1,s2
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	e3a080e7          	jalr	-454(ra) # 800039fa <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bc8:	08848493          	addi	s1,s1,136
    80002bcc:	ff3498e3          	bne	s1,s3,80002bbc <iinit+0x3e>
}
    80002bd0:	70a2                	ld	ra,40(sp)
    80002bd2:	7402                	ld	s0,32(sp)
    80002bd4:	64e2                	ld	s1,24(sp)
    80002bd6:	6942                	ld	s2,16(sp)
    80002bd8:	69a2                	ld	s3,8(sp)
    80002bda:	6145                	addi	sp,sp,48
    80002bdc:	8082                	ret

0000000080002bde <ialloc>:
{
    80002bde:	715d                	addi	sp,sp,-80
    80002be0:	e486                	sd	ra,72(sp)
    80002be2:	e0a2                	sd	s0,64(sp)
    80002be4:	fc26                	sd	s1,56(sp)
    80002be6:	f84a                	sd	s2,48(sp)
    80002be8:	f44e                	sd	s3,40(sp)
    80002bea:	f052                	sd	s4,32(sp)
    80002bec:	ec56                	sd	s5,24(sp)
    80002bee:	e85a                	sd	s6,16(sp)
    80002bf0:	e45e                	sd	s7,8(sp)
    80002bf2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf4:	00014717          	auipc	a4,0x14
    80002bf8:	48072703          	lw	a4,1152(a4) # 80017074 <sb+0xc>
    80002bfc:	4785                	li	a5,1
    80002bfe:	04e7fa63          	bgeu	a5,a4,80002c52 <ialloc+0x74>
    80002c02:	8aaa                	mv	s5,a0
    80002c04:	8bae                	mv	s7,a1
    80002c06:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c08:	00014a17          	auipc	s4,0x14
    80002c0c:	460a0a13          	addi	s4,s4,1120 # 80017068 <sb>
    80002c10:	00048b1b          	sext.w	s6,s1
    80002c14:	0044d793          	srli	a5,s1,0x4
    80002c18:	018a2583          	lw	a1,24(s4)
    80002c1c:	9dbd                	addw	a1,a1,a5
    80002c1e:	8556                	mv	a0,s5
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	940080e7          	jalr	-1728(ra) # 80002560 <bread>
    80002c28:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c2a:	05850993          	addi	s3,a0,88
    80002c2e:	00f4f793          	andi	a5,s1,15
    80002c32:	079a                	slli	a5,a5,0x6
    80002c34:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c36:	00099783          	lh	a5,0(s3)
    80002c3a:	c3a1                	beqz	a5,80002c7a <ialloc+0x9c>
    brelse(bp);
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	a54080e7          	jalr	-1452(ra) # 80002690 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c44:	0485                	addi	s1,s1,1
    80002c46:	00ca2703          	lw	a4,12(s4)
    80002c4a:	0004879b          	sext.w	a5,s1
    80002c4e:	fce7e1e3          	bltu	a5,a4,80002c10 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	95e50513          	addi	a0,a0,-1698 # 800085b0 <syscalls+0x1b0>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	22e080e7          	jalr	558(ra) # 80005e88 <printf>
  return 0;
    80002c62:	4501                	li	a0,0
}
    80002c64:	60a6                	ld	ra,72(sp)
    80002c66:	6406                	ld	s0,64(sp)
    80002c68:	74e2                	ld	s1,56(sp)
    80002c6a:	7942                	ld	s2,48(sp)
    80002c6c:	79a2                	ld	s3,40(sp)
    80002c6e:	7a02                	ld	s4,32(sp)
    80002c70:	6ae2                	ld	s5,24(sp)
    80002c72:	6b42                	ld	s6,16(sp)
    80002c74:	6ba2                	ld	s7,8(sp)
    80002c76:	6161                	addi	sp,sp,80
    80002c78:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c7a:	04000613          	li	a2,64
    80002c7e:	4581                	li	a1,0
    80002c80:	854e                	mv	a0,s3
    80002c82:	ffffd097          	auipc	ra,0xffffd
    80002c86:	4f6080e7          	jalr	1270(ra) # 80000178 <memset>
      dip->type = type;
    80002c8a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c8e:	854a                	mv	a0,s2
    80002c90:	00001097          	auipc	ra,0x1
    80002c94:	c84080e7          	jalr	-892(ra) # 80003914 <log_write>
      brelse(bp);
    80002c98:	854a                	mv	a0,s2
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	9f6080e7          	jalr	-1546(ra) # 80002690 <brelse>
      return iget(dev, inum);
    80002ca2:	85da                	mv	a1,s6
    80002ca4:	8556                	mv	a0,s5
    80002ca6:	00000097          	auipc	ra,0x0
    80002caa:	d9c080e7          	jalr	-612(ra) # 80002a42 <iget>
    80002cae:	bf5d                	j	80002c64 <ialloc+0x86>

0000000080002cb0 <iupdate>:
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	e04a                	sd	s2,0(sp)
    80002cba:	1000                	addi	s0,sp,32
    80002cbc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cbe:	415c                	lw	a5,4(a0)
    80002cc0:	0047d79b          	srliw	a5,a5,0x4
    80002cc4:	00014597          	auipc	a1,0x14
    80002cc8:	3bc5a583          	lw	a1,956(a1) # 80017080 <sb+0x18>
    80002ccc:	9dbd                	addw	a1,a1,a5
    80002cce:	4108                	lw	a0,0(a0)
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	890080e7          	jalr	-1904(ra) # 80002560 <bread>
    80002cd8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cda:	05850793          	addi	a5,a0,88
    80002cde:	40c8                	lw	a0,4(s1)
    80002ce0:	893d                	andi	a0,a0,15
    80002ce2:	051a                	slli	a0,a0,0x6
    80002ce4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ce6:	04449703          	lh	a4,68(s1)
    80002cea:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cee:	04649703          	lh	a4,70(s1)
    80002cf2:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cf6:	04849703          	lh	a4,72(s1)
    80002cfa:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cfe:	04a49703          	lh	a4,74(s1)
    80002d02:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d06:	44f8                	lw	a4,76(s1)
    80002d08:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d0a:	03400613          	li	a2,52
    80002d0e:	05048593          	addi	a1,s1,80
    80002d12:	0531                	addi	a0,a0,12
    80002d14:	ffffd097          	auipc	ra,0xffffd
    80002d18:	4c0080e7          	jalr	1216(ra) # 800001d4 <memmove>
  log_write(bp);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	00001097          	auipc	ra,0x1
    80002d22:	bf6080e7          	jalr	-1034(ra) # 80003914 <log_write>
  brelse(bp);
    80002d26:	854a                	mv	a0,s2
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	968080e7          	jalr	-1688(ra) # 80002690 <brelse>
}
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	64a2                	ld	s1,8(sp)
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret

0000000080002d3c <idup>:
{
    80002d3c:	1101                	addi	sp,sp,-32
    80002d3e:	ec06                	sd	ra,24(sp)
    80002d40:	e822                	sd	s0,16(sp)
    80002d42:	e426                	sd	s1,8(sp)
    80002d44:	1000                	addi	s0,sp,32
    80002d46:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d48:	00014517          	auipc	a0,0x14
    80002d4c:	34050513          	addi	a0,a0,832 # 80017088 <itable>
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	62a080e7          	jalr	1578(ra) # 8000637a <acquire>
  ip->ref++;
    80002d58:	449c                	lw	a5,8(s1)
    80002d5a:	2785                	addiw	a5,a5,1
    80002d5c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d5e:	00014517          	auipc	a0,0x14
    80002d62:	32a50513          	addi	a0,a0,810 # 80017088 <itable>
    80002d66:	00003097          	auipc	ra,0x3
    80002d6a:	6c8080e7          	jalr	1736(ra) # 8000642e <release>
}
    80002d6e:	8526                	mv	a0,s1
    80002d70:	60e2                	ld	ra,24(sp)
    80002d72:	6442                	ld	s0,16(sp)
    80002d74:	64a2                	ld	s1,8(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret

0000000080002d7a <ilock>:
{
    80002d7a:	1101                	addi	sp,sp,-32
    80002d7c:	ec06                	sd	ra,24(sp)
    80002d7e:	e822                	sd	s0,16(sp)
    80002d80:	e426                	sd	s1,8(sp)
    80002d82:	e04a                	sd	s2,0(sp)
    80002d84:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d86:	c115                	beqz	a0,80002daa <ilock+0x30>
    80002d88:	84aa                	mv	s1,a0
    80002d8a:	451c                	lw	a5,8(a0)
    80002d8c:	00f05f63          	blez	a5,80002daa <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d90:	0541                	addi	a0,a0,16
    80002d92:	00001097          	auipc	ra,0x1
    80002d96:	ca2080e7          	jalr	-862(ra) # 80003a34 <acquiresleep>
  if(ip->valid == 0){
    80002d9a:	40bc                	lw	a5,64(s1)
    80002d9c:	cf99                	beqz	a5,80002dba <ilock+0x40>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret
    panic("ilock");
    80002daa:	00006517          	auipc	a0,0x6
    80002dae:	81e50513          	addi	a0,a0,-2018 # 800085c8 <syscalls+0x1c8>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	08c080e7          	jalr	140(ra) # 80005e3e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dba:	40dc                	lw	a5,4(s1)
    80002dbc:	0047d79b          	srliw	a5,a5,0x4
    80002dc0:	00014597          	auipc	a1,0x14
    80002dc4:	2c05a583          	lw	a1,704(a1) # 80017080 <sb+0x18>
    80002dc8:	9dbd                	addw	a1,a1,a5
    80002dca:	4088                	lw	a0,0(s1)
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	794080e7          	jalr	1940(ra) # 80002560 <bread>
    80002dd4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dd6:	05850593          	addi	a1,a0,88
    80002dda:	40dc                	lw	a5,4(s1)
    80002ddc:	8bbd                	andi	a5,a5,15
    80002dde:	079a                	slli	a5,a5,0x6
    80002de0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002de2:	00059783          	lh	a5,0(a1)
    80002de6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dea:	00259783          	lh	a5,2(a1)
    80002dee:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002df2:	00459783          	lh	a5,4(a1)
    80002df6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dfa:	00659783          	lh	a5,6(a1)
    80002dfe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e02:	459c                	lw	a5,8(a1)
    80002e04:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e06:	03400613          	li	a2,52
    80002e0a:	05b1                	addi	a1,a1,12
    80002e0c:	05048513          	addi	a0,s1,80
    80002e10:	ffffd097          	auipc	ra,0xffffd
    80002e14:	3c4080e7          	jalr	964(ra) # 800001d4 <memmove>
    brelse(bp);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	00000097          	auipc	ra,0x0
    80002e1e:	876080e7          	jalr	-1930(ra) # 80002690 <brelse>
    ip->valid = 1;
    80002e22:	4785                	li	a5,1
    80002e24:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e26:	04449783          	lh	a5,68(s1)
    80002e2a:	fbb5                	bnez	a5,80002d9e <ilock+0x24>
      panic("ilock: no type");
    80002e2c:	00005517          	auipc	a0,0x5
    80002e30:	7a450513          	addi	a0,a0,1956 # 800085d0 <syscalls+0x1d0>
    80002e34:	00003097          	auipc	ra,0x3
    80002e38:	00a080e7          	jalr	10(ra) # 80005e3e <panic>

0000000080002e3c <iunlock>:
{
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	e04a                	sd	s2,0(sp)
    80002e46:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e48:	c905                	beqz	a0,80002e78 <iunlock+0x3c>
    80002e4a:	84aa                	mv	s1,a0
    80002e4c:	01050913          	addi	s2,a0,16
    80002e50:	854a                	mv	a0,s2
    80002e52:	00001097          	auipc	ra,0x1
    80002e56:	c7c080e7          	jalr	-900(ra) # 80003ace <holdingsleep>
    80002e5a:	cd19                	beqz	a0,80002e78 <iunlock+0x3c>
    80002e5c:	449c                	lw	a5,8(s1)
    80002e5e:	00f05d63          	blez	a5,80002e78 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e62:	854a                	mv	a0,s2
    80002e64:	00001097          	auipc	ra,0x1
    80002e68:	c26080e7          	jalr	-986(ra) # 80003a8a <releasesleep>
}
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	6902                	ld	s2,0(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret
    panic("iunlock");
    80002e78:	00005517          	auipc	a0,0x5
    80002e7c:	76850513          	addi	a0,a0,1896 # 800085e0 <syscalls+0x1e0>
    80002e80:	00003097          	auipc	ra,0x3
    80002e84:	fbe080e7          	jalr	-66(ra) # 80005e3e <panic>

0000000080002e88 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e88:	7179                	addi	sp,sp,-48
    80002e8a:	f406                	sd	ra,40(sp)
    80002e8c:	f022                	sd	s0,32(sp)
    80002e8e:	ec26                	sd	s1,24(sp)
    80002e90:	e84a                	sd	s2,16(sp)
    80002e92:	e44e                	sd	s3,8(sp)
    80002e94:	e052                	sd	s4,0(sp)
    80002e96:	1800                	addi	s0,sp,48
    80002e98:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e9a:	05050493          	addi	s1,a0,80
    80002e9e:	08050913          	addi	s2,a0,128
    80002ea2:	a021                	j	80002eaa <itrunc+0x22>
    80002ea4:	0491                	addi	s1,s1,4
    80002ea6:	01248d63          	beq	s1,s2,80002ec0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002eaa:	408c                	lw	a1,0(s1)
    80002eac:	dde5                	beqz	a1,80002ea4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002eae:	0009a503          	lw	a0,0(s3)
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	8f4080e7          	jalr	-1804(ra) # 800027a6 <bfree>
      ip->addrs[i] = 0;
    80002eba:	0004a023          	sw	zero,0(s1)
    80002ebe:	b7dd                	j	80002ea4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ec0:	0809a583          	lw	a1,128(s3)
    80002ec4:	e185                	bnez	a1,80002ee4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ec6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eca:	854e                	mv	a0,s3
    80002ecc:	00000097          	auipc	ra,0x0
    80002ed0:	de4080e7          	jalr	-540(ra) # 80002cb0 <iupdate>
}
    80002ed4:	70a2                	ld	ra,40(sp)
    80002ed6:	7402                	ld	s0,32(sp)
    80002ed8:	64e2                	ld	s1,24(sp)
    80002eda:	6942                	ld	s2,16(sp)
    80002edc:	69a2                	ld	s3,8(sp)
    80002ede:	6a02                	ld	s4,0(sp)
    80002ee0:	6145                	addi	sp,sp,48
    80002ee2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ee4:	0009a503          	lw	a0,0(s3)
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	678080e7          	jalr	1656(ra) # 80002560 <bread>
    80002ef0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ef2:	05850493          	addi	s1,a0,88
    80002ef6:	45850913          	addi	s2,a0,1112
    80002efa:	a021                	j	80002f02 <itrunc+0x7a>
    80002efc:	0491                	addi	s1,s1,4
    80002efe:	01248b63          	beq	s1,s2,80002f14 <itrunc+0x8c>
      if(a[j])
    80002f02:	408c                	lw	a1,0(s1)
    80002f04:	dde5                	beqz	a1,80002efc <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002f06:	0009a503          	lw	a0,0(s3)
    80002f0a:	00000097          	auipc	ra,0x0
    80002f0e:	89c080e7          	jalr	-1892(ra) # 800027a6 <bfree>
    80002f12:	b7ed                	j	80002efc <itrunc+0x74>
    brelse(bp);
    80002f14:	8552                	mv	a0,s4
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	77a080e7          	jalr	1914(ra) # 80002690 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f1e:	0809a583          	lw	a1,128(s3)
    80002f22:	0009a503          	lw	a0,0(s3)
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	880080e7          	jalr	-1920(ra) # 800027a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f2e:	0809a023          	sw	zero,128(s3)
    80002f32:	bf51                	j	80002ec6 <itrunc+0x3e>

0000000080002f34 <iput>:
{
    80002f34:	1101                	addi	sp,sp,-32
    80002f36:	ec06                	sd	ra,24(sp)
    80002f38:	e822                	sd	s0,16(sp)
    80002f3a:	e426                	sd	s1,8(sp)
    80002f3c:	e04a                	sd	s2,0(sp)
    80002f3e:	1000                	addi	s0,sp,32
    80002f40:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f42:	00014517          	auipc	a0,0x14
    80002f46:	14650513          	addi	a0,a0,326 # 80017088 <itable>
    80002f4a:	00003097          	auipc	ra,0x3
    80002f4e:	430080e7          	jalr	1072(ra) # 8000637a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f52:	4498                	lw	a4,8(s1)
    80002f54:	4785                	li	a5,1
    80002f56:	02f70363          	beq	a4,a5,80002f7c <iput+0x48>
  ip->ref--;
    80002f5a:	449c                	lw	a5,8(s1)
    80002f5c:	37fd                	addiw	a5,a5,-1
    80002f5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f60:	00014517          	auipc	a0,0x14
    80002f64:	12850513          	addi	a0,a0,296 # 80017088 <itable>
    80002f68:	00003097          	auipc	ra,0x3
    80002f6c:	4c6080e7          	jalr	1222(ra) # 8000642e <release>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	64a2                	ld	s1,8(sp)
    80002f76:	6902                	ld	s2,0(sp)
    80002f78:	6105                	addi	sp,sp,32
    80002f7a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f7c:	40bc                	lw	a5,64(s1)
    80002f7e:	dff1                	beqz	a5,80002f5a <iput+0x26>
    80002f80:	04a49783          	lh	a5,74(s1)
    80002f84:	fbf9                	bnez	a5,80002f5a <iput+0x26>
    acquiresleep(&ip->lock);
    80002f86:	01048913          	addi	s2,s1,16
    80002f8a:	854a                	mv	a0,s2
    80002f8c:	00001097          	auipc	ra,0x1
    80002f90:	aa8080e7          	jalr	-1368(ra) # 80003a34 <acquiresleep>
    release(&itable.lock);
    80002f94:	00014517          	auipc	a0,0x14
    80002f98:	0f450513          	addi	a0,a0,244 # 80017088 <itable>
    80002f9c:	00003097          	auipc	ra,0x3
    80002fa0:	492080e7          	jalr	1170(ra) # 8000642e <release>
    itrunc(ip);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	ee2080e7          	jalr	-286(ra) # 80002e88 <itrunc>
    ip->type = 0;
    80002fae:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fb2:	8526                	mv	a0,s1
    80002fb4:	00000097          	auipc	ra,0x0
    80002fb8:	cfc080e7          	jalr	-772(ra) # 80002cb0 <iupdate>
    ip->valid = 0;
    80002fbc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fc0:	854a                	mv	a0,s2
    80002fc2:	00001097          	auipc	ra,0x1
    80002fc6:	ac8080e7          	jalr	-1336(ra) # 80003a8a <releasesleep>
    acquire(&itable.lock);
    80002fca:	00014517          	auipc	a0,0x14
    80002fce:	0be50513          	addi	a0,a0,190 # 80017088 <itable>
    80002fd2:	00003097          	auipc	ra,0x3
    80002fd6:	3a8080e7          	jalr	936(ra) # 8000637a <acquire>
    80002fda:	b741                	j	80002f5a <iput+0x26>

0000000080002fdc <iunlockput>:
{
    80002fdc:	1101                	addi	sp,sp,-32
    80002fde:	ec06                	sd	ra,24(sp)
    80002fe0:	e822                	sd	s0,16(sp)
    80002fe2:	e426                	sd	s1,8(sp)
    80002fe4:	1000                	addi	s0,sp,32
    80002fe6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	e54080e7          	jalr	-428(ra) # 80002e3c <iunlock>
  iput(ip);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	f42080e7          	jalr	-190(ra) # 80002f34 <iput>
}
    80002ffa:	60e2                	ld	ra,24(sp)
    80002ffc:	6442                	ld	s0,16(sp)
    80002ffe:	64a2                	ld	s1,8(sp)
    80003000:	6105                	addi	sp,sp,32
    80003002:	8082                	ret

0000000080003004 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003004:	1141                	addi	sp,sp,-16
    80003006:	e422                	sd	s0,8(sp)
    80003008:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000300a:	411c                	lw	a5,0(a0)
    8000300c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000300e:	415c                	lw	a5,4(a0)
    80003010:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003012:	04451783          	lh	a5,68(a0)
    80003016:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000301a:	04a51783          	lh	a5,74(a0)
    8000301e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003022:	04c56783          	lwu	a5,76(a0)
    80003026:	e99c                	sd	a5,16(a1)
}
    80003028:	6422                	ld	s0,8(sp)
    8000302a:	0141                	addi	sp,sp,16
    8000302c:	8082                	ret

000000008000302e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302e:	457c                	lw	a5,76(a0)
    80003030:	0ed7e963          	bltu	a5,a3,80003122 <readi+0xf4>
{
    80003034:	7159                	addi	sp,sp,-112
    80003036:	f486                	sd	ra,104(sp)
    80003038:	f0a2                	sd	s0,96(sp)
    8000303a:	eca6                	sd	s1,88(sp)
    8000303c:	e8ca                	sd	s2,80(sp)
    8000303e:	e4ce                	sd	s3,72(sp)
    80003040:	e0d2                	sd	s4,64(sp)
    80003042:	fc56                	sd	s5,56(sp)
    80003044:	f85a                	sd	s6,48(sp)
    80003046:	f45e                	sd	s7,40(sp)
    80003048:	f062                	sd	s8,32(sp)
    8000304a:	ec66                	sd	s9,24(sp)
    8000304c:	e86a                	sd	s10,16(sp)
    8000304e:	e46e                	sd	s11,8(sp)
    80003050:	1880                	addi	s0,sp,112
    80003052:	8b2a                	mv	s6,a0
    80003054:	8bae                	mv	s7,a1
    80003056:	8a32                	mv	s4,a2
    80003058:	84b6                	mv	s1,a3
    8000305a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000305c:	9f35                	addw	a4,a4,a3
    return 0;
    8000305e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003060:	0ad76063          	bltu	a4,a3,80003100 <readi+0xd2>
  if(off + n > ip->size)
    80003064:	00e7f463          	bgeu	a5,a4,8000306c <readi+0x3e>
    n = ip->size - off;
    80003068:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000306c:	0a0a8963          	beqz	s5,8000311e <readi+0xf0>
    80003070:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003072:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003076:	5c7d                	li	s8,-1
    80003078:	a82d                	j	800030b2 <readi+0x84>
    8000307a:	020d1d93          	slli	s11,s10,0x20
    8000307e:	020ddd93          	srli	s11,s11,0x20
    80003082:	05890793          	addi	a5,s2,88
    80003086:	86ee                	mv	a3,s11
    80003088:	963e                	add	a2,a2,a5
    8000308a:	85d2                	mv	a1,s4
    8000308c:	855e                	mv	a0,s7
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	a04080e7          	jalr	-1532(ra) # 80001a92 <either_copyout>
    80003096:	05850d63          	beq	a0,s8,800030f0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000309a:	854a                	mv	a0,s2
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	5f4080e7          	jalr	1524(ra) # 80002690 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030a4:	013d09bb          	addw	s3,s10,s3
    800030a8:	009d04bb          	addw	s1,s10,s1
    800030ac:	9a6e                	add	s4,s4,s11
    800030ae:	0559f763          	bgeu	s3,s5,800030fc <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030b2:	00a4d59b          	srliw	a1,s1,0xa
    800030b6:	855a                	mv	a0,s6
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	8a2080e7          	jalr	-1886(ra) # 8000295a <bmap>
    800030c0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030c4:	cd85                	beqz	a1,800030fc <readi+0xce>
    bp = bread(ip->dev, addr);
    800030c6:	000b2503          	lw	a0,0(s6)
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	496080e7          	jalr	1174(ra) # 80002560 <bread>
    800030d2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d4:	3ff4f613          	andi	a2,s1,1023
    800030d8:	40cc87bb          	subw	a5,s9,a2
    800030dc:	413a873b          	subw	a4,s5,s3
    800030e0:	8d3e                	mv	s10,a5
    800030e2:	2781                	sext.w	a5,a5
    800030e4:	0007069b          	sext.w	a3,a4
    800030e8:	f8f6f9e3          	bgeu	a3,a5,8000307a <readi+0x4c>
    800030ec:	8d3a                	mv	s10,a4
    800030ee:	b771                	j	8000307a <readi+0x4c>
      brelse(bp);
    800030f0:	854a                	mv	a0,s2
    800030f2:	fffff097          	auipc	ra,0xfffff
    800030f6:	59e080e7          	jalr	1438(ra) # 80002690 <brelse>
      tot = -1;
    800030fa:	59fd                	li	s3,-1
  }
  return tot;
    800030fc:	0009851b          	sext.w	a0,s3
}
    80003100:	70a6                	ld	ra,104(sp)
    80003102:	7406                	ld	s0,96(sp)
    80003104:	64e6                	ld	s1,88(sp)
    80003106:	6946                	ld	s2,80(sp)
    80003108:	69a6                	ld	s3,72(sp)
    8000310a:	6a06                	ld	s4,64(sp)
    8000310c:	7ae2                	ld	s5,56(sp)
    8000310e:	7b42                	ld	s6,48(sp)
    80003110:	7ba2                	ld	s7,40(sp)
    80003112:	7c02                	ld	s8,32(sp)
    80003114:	6ce2                	ld	s9,24(sp)
    80003116:	6d42                	ld	s10,16(sp)
    80003118:	6da2                	ld	s11,8(sp)
    8000311a:	6165                	addi	sp,sp,112
    8000311c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000311e:	89d6                	mv	s3,s5
    80003120:	bff1                	j	800030fc <readi+0xce>
    return 0;
    80003122:	4501                	li	a0,0
}
    80003124:	8082                	ret

0000000080003126 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003126:	457c                	lw	a5,76(a0)
    80003128:	10d7e863          	bltu	a5,a3,80003238 <writei+0x112>
{
    8000312c:	7159                	addi	sp,sp,-112
    8000312e:	f486                	sd	ra,104(sp)
    80003130:	f0a2                	sd	s0,96(sp)
    80003132:	eca6                	sd	s1,88(sp)
    80003134:	e8ca                	sd	s2,80(sp)
    80003136:	e4ce                	sd	s3,72(sp)
    80003138:	e0d2                	sd	s4,64(sp)
    8000313a:	fc56                	sd	s5,56(sp)
    8000313c:	f85a                	sd	s6,48(sp)
    8000313e:	f45e                	sd	s7,40(sp)
    80003140:	f062                	sd	s8,32(sp)
    80003142:	ec66                	sd	s9,24(sp)
    80003144:	e86a                	sd	s10,16(sp)
    80003146:	e46e                	sd	s11,8(sp)
    80003148:	1880                	addi	s0,sp,112
    8000314a:	8aaa                	mv	s5,a0
    8000314c:	8bae                	mv	s7,a1
    8000314e:	8a32                	mv	s4,a2
    80003150:	8936                	mv	s2,a3
    80003152:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003154:	00e687bb          	addw	a5,a3,a4
    80003158:	0ed7e263          	bltu	a5,a3,8000323c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000315c:	00043737          	lui	a4,0x43
    80003160:	0ef76063          	bltu	a4,a5,80003240 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003164:	0c0b0863          	beqz	s6,80003234 <writei+0x10e>
    80003168:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000316a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000316e:	5c7d                	li	s8,-1
    80003170:	a091                	j	800031b4 <writei+0x8e>
    80003172:	020d1d93          	slli	s11,s10,0x20
    80003176:	020ddd93          	srli	s11,s11,0x20
    8000317a:	05848793          	addi	a5,s1,88
    8000317e:	86ee                	mv	a3,s11
    80003180:	8652                	mv	a2,s4
    80003182:	85de                	mv	a1,s7
    80003184:	953e                	add	a0,a0,a5
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	962080e7          	jalr	-1694(ra) # 80001ae8 <either_copyin>
    8000318e:	07850263          	beq	a0,s8,800031f2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003192:	8526                	mv	a0,s1
    80003194:	00000097          	auipc	ra,0x0
    80003198:	780080e7          	jalr	1920(ra) # 80003914 <log_write>
    brelse(bp);
    8000319c:	8526                	mv	a0,s1
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	4f2080e7          	jalr	1266(ra) # 80002690 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a6:	013d09bb          	addw	s3,s10,s3
    800031aa:	012d093b          	addw	s2,s10,s2
    800031ae:	9a6e                	add	s4,s4,s11
    800031b0:	0569f663          	bgeu	s3,s6,800031fc <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031b4:	00a9559b          	srliw	a1,s2,0xa
    800031b8:	8556                	mv	a0,s5
    800031ba:	fffff097          	auipc	ra,0xfffff
    800031be:	7a0080e7          	jalr	1952(ra) # 8000295a <bmap>
    800031c2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031c6:	c99d                	beqz	a1,800031fc <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031c8:	000aa503          	lw	a0,0(s5)
    800031cc:	fffff097          	auipc	ra,0xfffff
    800031d0:	394080e7          	jalr	916(ra) # 80002560 <bread>
    800031d4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d6:	3ff97513          	andi	a0,s2,1023
    800031da:	40ac87bb          	subw	a5,s9,a0
    800031de:	413b073b          	subw	a4,s6,s3
    800031e2:	8d3e                	mv	s10,a5
    800031e4:	2781                	sext.w	a5,a5
    800031e6:	0007069b          	sext.w	a3,a4
    800031ea:	f8f6f4e3          	bgeu	a3,a5,80003172 <writei+0x4c>
    800031ee:	8d3a                	mv	s10,a4
    800031f0:	b749                	j	80003172 <writei+0x4c>
      brelse(bp);
    800031f2:	8526                	mv	a0,s1
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	49c080e7          	jalr	1180(ra) # 80002690 <brelse>
  }

  if(off > ip->size)
    800031fc:	04caa783          	lw	a5,76(s5)
    80003200:	0127f463          	bgeu	a5,s2,80003208 <writei+0xe2>
    ip->size = off;
    80003204:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003208:	8556                	mv	a0,s5
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	aa6080e7          	jalr	-1370(ra) # 80002cb0 <iupdate>

  return tot;
    80003212:	0009851b          	sext.w	a0,s3
}
    80003216:	70a6                	ld	ra,104(sp)
    80003218:	7406                	ld	s0,96(sp)
    8000321a:	64e6                	ld	s1,88(sp)
    8000321c:	6946                	ld	s2,80(sp)
    8000321e:	69a6                	ld	s3,72(sp)
    80003220:	6a06                	ld	s4,64(sp)
    80003222:	7ae2                	ld	s5,56(sp)
    80003224:	7b42                	ld	s6,48(sp)
    80003226:	7ba2                	ld	s7,40(sp)
    80003228:	7c02                	ld	s8,32(sp)
    8000322a:	6ce2                	ld	s9,24(sp)
    8000322c:	6d42                	ld	s10,16(sp)
    8000322e:	6da2                	ld	s11,8(sp)
    80003230:	6165                	addi	sp,sp,112
    80003232:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003234:	89da                	mv	s3,s6
    80003236:	bfc9                	j	80003208 <writei+0xe2>
    return -1;
    80003238:	557d                	li	a0,-1
}
    8000323a:	8082                	ret
    return -1;
    8000323c:	557d                	li	a0,-1
    8000323e:	bfe1                	j	80003216 <writei+0xf0>
    return -1;
    80003240:	557d                	li	a0,-1
    80003242:	bfd1                	j	80003216 <writei+0xf0>

0000000080003244 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003244:	1141                	addi	sp,sp,-16
    80003246:	e406                	sd	ra,8(sp)
    80003248:	e022                	sd	s0,0(sp)
    8000324a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000324c:	4639                	li	a2,14
    8000324e:	ffffd097          	auipc	ra,0xffffd
    80003252:	ffa080e7          	jalr	-6(ra) # 80000248 <strncmp>
}
    80003256:	60a2                	ld	ra,8(sp)
    80003258:	6402                	ld	s0,0(sp)
    8000325a:	0141                	addi	sp,sp,16
    8000325c:	8082                	ret

000000008000325e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000325e:	7139                	addi	sp,sp,-64
    80003260:	fc06                	sd	ra,56(sp)
    80003262:	f822                	sd	s0,48(sp)
    80003264:	f426                	sd	s1,40(sp)
    80003266:	f04a                	sd	s2,32(sp)
    80003268:	ec4e                	sd	s3,24(sp)
    8000326a:	e852                	sd	s4,16(sp)
    8000326c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000326e:	04451703          	lh	a4,68(a0)
    80003272:	4785                	li	a5,1
    80003274:	00f71a63          	bne	a4,a5,80003288 <dirlookup+0x2a>
    80003278:	892a                	mv	s2,a0
    8000327a:	89ae                	mv	s3,a1
    8000327c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327e:	457c                	lw	a5,76(a0)
    80003280:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003282:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003284:	e79d                	bnez	a5,800032b2 <dirlookup+0x54>
    80003286:	a8a5                	j	800032fe <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003288:	00005517          	auipc	a0,0x5
    8000328c:	36050513          	addi	a0,a0,864 # 800085e8 <syscalls+0x1e8>
    80003290:	00003097          	auipc	ra,0x3
    80003294:	bae080e7          	jalr	-1106(ra) # 80005e3e <panic>
      panic("dirlookup read");
    80003298:	00005517          	auipc	a0,0x5
    8000329c:	36850513          	addi	a0,a0,872 # 80008600 <syscalls+0x200>
    800032a0:	00003097          	auipc	ra,0x3
    800032a4:	b9e080e7          	jalr	-1122(ra) # 80005e3e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a8:	24c1                	addiw	s1,s1,16
    800032aa:	04c92783          	lw	a5,76(s2)
    800032ae:	04f4f763          	bgeu	s1,a5,800032fc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b2:	4741                	li	a4,16
    800032b4:	86a6                	mv	a3,s1
    800032b6:	fc040613          	addi	a2,s0,-64
    800032ba:	4581                	li	a1,0
    800032bc:	854a                	mv	a0,s2
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	d70080e7          	jalr	-656(ra) # 8000302e <readi>
    800032c6:	47c1                	li	a5,16
    800032c8:	fcf518e3          	bne	a0,a5,80003298 <dirlookup+0x3a>
    if(de.inum == 0)
    800032cc:	fc045783          	lhu	a5,-64(s0)
    800032d0:	dfe1                	beqz	a5,800032a8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032d2:	fc240593          	addi	a1,s0,-62
    800032d6:	854e                	mv	a0,s3
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	f6c080e7          	jalr	-148(ra) # 80003244 <namecmp>
    800032e0:	f561                	bnez	a0,800032a8 <dirlookup+0x4a>
      if(poff)
    800032e2:	000a0463          	beqz	s4,800032ea <dirlookup+0x8c>
        *poff = off;
    800032e6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032ea:	fc045583          	lhu	a1,-64(s0)
    800032ee:	00092503          	lw	a0,0(s2)
    800032f2:	fffff097          	auipc	ra,0xfffff
    800032f6:	750080e7          	jalr	1872(ra) # 80002a42 <iget>
    800032fa:	a011                	j	800032fe <dirlookup+0xa0>
  return 0;
    800032fc:	4501                	li	a0,0
}
    800032fe:	70e2                	ld	ra,56(sp)
    80003300:	7442                	ld	s0,48(sp)
    80003302:	74a2                	ld	s1,40(sp)
    80003304:	7902                	ld	s2,32(sp)
    80003306:	69e2                	ld	s3,24(sp)
    80003308:	6a42                	ld	s4,16(sp)
    8000330a:	6121                	addi	sp,sp,64
    8000330c:	8082                	ret

000000008000330e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000330e:	711d                	addi	sp,sp,-96
    80003310:	ec86                	sd	ra,88(sp)
    80003312:	e8a2                	sd	s0,80(sp)
    80003314:	e4a6                	sd	s1,72(sp)
    80003316:	e0ca                	sd	s2,64(sp)
    80003318:	fc4e                	sd	s3,56(sp)
    8000331a:	f852                	sd	s4,48(sp)
    8000331c:	f456                	sd	s5,40(sp)
    8000331e:	f05a                	sd	s6,32(sp)
    80003320:	ec5e                	sd	s7,24(sp)
    80003322:	e862                	sd	s8,16(sp)
    80003324:	e466                	sd	s9,8(sp)
    80003326:	1080                	addi	s0,sp,96
    80003328:	84aa                	mv	s1,a0
    8000332a:	8aae                	mv	s5,a1
    8000332c:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000332e:	00054703          	lbu	a4,0(a0)
    80003332:	02f00793          	li	a5,47
    80003336:	02f70363          	beq	a4,a5,8000335c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000333a:	ffffe097          	auipc	ra,0xffffe
    8000333e:	bfa080e7          	jalr	-1030(ra) # 80000f34 <myproc>
    80003342:	15853503          	ld	a0,344(a0)
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	9f6080e7          	jalr	-1546(ra) # 80002d3c <idup>
    8000334e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003350:	02f00913          	li	s2,47
  len = path - s;
    80003354:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003356:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003358:	4b85                	li	s7,1
    8000335a:	a865                	j	80003412 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000335c:	4585                	li	a1,1
    8000335e:	4505                	li	a0,1
    80003360:	fffff097          	auipc	ra,0xfffff
    80003364:	6e2080e7          	jalr	1762(ra) # 80002a42 <iget>
    80003368:	89aa                	mv	s3,a0
    8000336a:	b7dd                	j	80003350 <namex+0x42>
      iunlockput(ip);
    8000336c:	854e                	mv	a0,s3
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	c6e080e7          	jalr	-914(ra) # 80002fdc <iunlockput>
      return 0;
    80003376:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003378:	854e                	mv	a0,s3
    8000337a:	60e6                	ld	ra,88(sp)
    8000337c:	6446                	ld	s0,80(sp)
    8000337e:	64a6                	ld	s1,72(sp)
    80003380:	6906                	ld	s2,64(sp)
    80003382:	79e2                	ld	s3,56(sp)
    80003384:	7a42                	ld	s4,48(sp)
    80003386:	7aa2                	ld	s5,40(sp)
    80003388:	7b02                	ld	s6,32(sp)
    8000338a:	6be2                	ld	s7,24(sp)
    8000338c:	6c42                	ld	s8,16(sp)
    8000338e:	6ca2                	ld	s9,8(sp)
    80003390:	6125                	addi	sp,sp,96
    80003392:	8082                	ret
      iunlock(ip);
    80003394:	854e                	mv	a0,s3
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	aa6080e7          	jalr	-1370(ra) # 80002e3c <iunlock>
      return ip;
    8000339e:	bfe9                	j	80003378 <namex+0x6a>
      iunlockput(ip);
    800033a0:	854e                	mv	a0,s3
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	c3a080e7          	jalr	-966(ra) # 80002fdc <iunlockput>
      return 0;
    800033aa:	89e6                	mv	s3,s9
    800033ac:	b7f1                	j	80003378 <namex+0x6a>
  len = path - s;
    800033ae:	40b48633          	sub	a2,s1,a1
    800033b2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033b6:	099c5463          	bge	s8,s9,8000343e <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033ba:	4639                	li	a2,14
    800033bc:	8552                	mv	a0,s4
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	e16080e7          	jalr	-490(ra) # 800001d4 <memmove>
  while(*path == '/')
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	01279763          	bne	a5,s2,800033d8 <namex+0xca>
    path++;
    800033ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033d0:	0004c783          	lbu	a5,0(s1)
    800033d4:	ff278de3          	beq	a5,s2,800033ce <namex+0xc0>
    ilock(ip);
    800033d8:	854e                	mv	a0,s3
    800033da:	00000097          	auipc	ra,0x0
    800033de:	9a0080e7          	jalr	-1632(ra) # 80002d7a <ilock>
    if(ip->type != T_DIR){
    800033e2:	04499783          	lh	a5,68(s3)
    800033e6:	f97793e3          	bne	a5,s7,8000336c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033ea:	000a8563          	beqz	s5,800033f4 <namex+0xe6>
    800033ee:	0004c783          	lbu	a5,0(s1)
    800033f2:	d3cd                	beqz	a5,80003394 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033f4:	865a                	mv	a2,s6
    800033f6:	85d2                	mv	a1,s4
    800033f8:	854e                	mv	a0,s3
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	e64080e7          	jalr	-412(ra) # 8000325e <dirlookup>
    80003402:	8caa                	mv	s9,a0
    80003404:	dd51                	beqz	a0,800033a0 <namex+0x92>
    iunlockput(ip);
    80003406:	854e                	mv	a0,s3
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	bd4080e7          	jalr	-1068(ra) # 80002fdc <iunlockput>
    ip = next;
    80003410:	89e6                	mv	s3,s9
  while(*path == '/')
    80003412:	0004c783          	lbu	a5,0(s1)
    80003416:	05279763          	bne	a5,s2,80003464 <namex+0x156>
    path++;
    8000341a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000341c:	0004c783          	lbu	a5,0(s1)
    80003420:	ff278de3          	beq	a5,s2,8000341a <namex+0x10c>
  if(*path == 0)
    80003424:	c79d                	beqz	a5,80003452 <namex+0x144>
    path++;
    80003426:	85a6                	mv	a1,s1
  len = path - s;
    80003428:	8cda                	mv	s9,s6
    8000342a:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000342c:	01278963          	beq	a5,s2,8000343e <namex+0x130>
    80003430:	dfbd                	beqz	a5,800033ae <namex+0xa0>
    path++;
    80003432:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003434:	0004c783          	lbu	a5,0(s1)
    80003438:	ff279ce3          	bne	a5,s2,80003430 <namex+0x122>
    8000343c:	bf8d                	j	800033ae <namex+0xa0>
    memmove(name, s, len);
    8000343e:	2601                	sext.w	a2,a2
    80003440:	8552                	mv	a0,s4
    80003442:	ffffd097          	auipc	ra,0xffffd
    80003446:	d92080e7          	jalr	-622(ra) # 800001d4 <memmove>
    name[len] = 0;
    8000344a:	9cd2                	add	s9,s9,s4
    8000344c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003450:	bf9d                	j	800033c6 <namex+0xb8>
  if(nameiparent){
    80003452:	f20a83e3          	beqz	s5,80003378 <namex+0x6a>
    iput(ip);
    80003456:	854e                	mv	a0,s3
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	adc080e7          	jalr	-1316(ra) # 80002f34 <iput>
    return 0;
    80003460:	4981                	li	s3,0
    80003462:	bf19                	j	80003378 <namex+0x6a>
  if(*path == 0)
    80003464:	d7fd                	beqz	a5,80003452 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003466:	0004c783          	lbu	a5,0(s1)
    8000346a:	85a6                	mv	a1,s1
    8000346c:	b7d1                	j	80003430 <namex+0x122>

000000008000346e <dirlink>:
{
    8000346e:	7139                	addi	sp,sp,-64
    80003470:	fc06                	sd	ra,56(sp)
    80003472:	f822                	sd	s0,48(sp)
    80003474:	f426                	sd	s1,40(sp)
    80003476:	f04a                	sd	s2,32(sp)
    80003478:	ec4e                	sd	s3,24(sp)
    8000347a:	e852                	sd	s4,16(sp)
    8000347c:	0080                	addi	s0,sp,64
    8000347e:	892a                	mv	s2,a0
    80003480:	8a2e                	mv	s4,a1
    80003482:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003484:	4601                	li	a2,0
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	dd8080e7          	jalr	-552(ra) # 8000325e <dirlookup>
    8000348e:	e93d                	bnez	a0,80003504 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003490:	04c92483          	lw	s1,76(s2)
    80003494:	c49d                	beqz	s1,800034c2 <dirlink+0x54>
    80003496:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003498:	4741                	li	a4,16
    8000349a:	86a6                	mv	a3,s1
    8000349c:	fc040613          	addi	a2,s0,-64
    800034a0:	4581                	li	a1,0
    800034a2:	854a                	mv	a0,s2
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	b8a080e7          	jalr	-1142(ra) # 8000302e <readi>
    800034ac:	47c1                	li	a5,16
    800034ae:	06f51163          	bne	a0,a5,80003510 <dirlink+0xa2>
    if(de.inum == 0)
    800034b2:	fc045783          	lhu	a5,-64(s0)
    800034b6:	c791                	beqz	a5,800034c2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034b8:	24c1                	addiw	s1,s1,16
    800034ba:	04c92783          	lw	a5,76(s2)
    800034be:	fcf4ede3          	bltu	s1,a5,80003498 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034c2:	4639                	li	a2,14
    800034c4:	85d2                	mv	a1,s4
    800034c6:	fc240513          	addi	a0,s0,-62
    800034ca:	ffffd097          	auipc	ra,0xffffd
    800034ce:	dba080e7          	jalr	-582(ra) # 80000284 <strncpy>
  de.inum = inum;
    800034d2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034d6:	4741                	li	a4,16
    800034d8:	86a6                	mv	a3,s1
    800034da:	fc040613          	addi	a2,s0,-64
    800034de:	4581                	li	a1,0
    800034e0:	854a                	mv	a0,s2
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	c44080e7          	jalr	-956(ra) # 80003126 <writei>
    800034ea:	1541                	addi	a0,a0,-16
    800034ec:	00a03533          	snez	a0,a0
    800034f0:	40a00533          	neg	a0,a0
}
    800034f4:	70e2                	ld	ra,56(sp)
    800034f6:	7442                	ld	s0,48(sp)
    800034f8:	74a2                	ld	s1,40(sp)
    800034fa:	7902                	ld	s2,32(sp)
    800034fc:	69e2                	ld	s3,24(sp)
    800034fe:	6a42                	ld	s4,16(sp)
    80003500:	6121                	addi	sp,sp,64
    80003502:	8082                	ret
    iput(ip);
    80003504:	00000097          	auipc	ra,0x0
    80003508:	a30080e7          	jalr	-1488(ra) # 80002f34 <iput>
    return -1;
    8000350c:	557d                	li	a0,-1
    8000350e:	b7dd                	j	800034f4 <dirlink+0x86>
      panic("dirlink read");
    80003510:	00005517          	auipc	a0,0x5
    80003514:	10050513          	addi	a0,a0,256 # 80008610 <syscalls+0x210>
    80003518:	00003097          	auipc	ra,0x3
    8000351c:	926080e7          	jalr	-1754(ra) # 80005e3e <panic>

0000000080003520 <namei>:

struct inode*
namei(char *path)
{
    80003520:	1101                	addi	sp,sp,-32
    80003522:	ec06                	sd	ra,24(sp)
    80003524:	e822                	sd	s0,16(sp)
    80003526:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003528:	fe040613          	addi	a2,s0,-32
    8000352c:	4581                	li	a1,0
    8000352e:	00000097          	auipc	ra,0x0
    80003532:	de0080e7          	jalr	-544(ra) # 8000330e <namex>
}
    80003536:	60e2                	ld	ra,24(sp)
    80003538:	6442                	ld	s0,16(sp)
    8000353a:	6105                	addi	sp,sp,32
    8000353c:	8082                	ret

000000008000353e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000353e:	1141                	addi	sp,sp,-16
    80003540:	e406                	sd	ra,8(sp)
    80003542:	e022                	sd	s0,0(sp)
    80003544:	0800                	addi	s0,sp,16
    80003546:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003548:	4585                	li	a1,1
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	dc4080e7          	jalr	-572(ra) # 8000330e <namex>
}
    80003552:	60a2                	ld	ra,8(sp)
    80003554:	6402                	ld	s0,0(sp)
    80003556:	0141                	addi	sp,sp,16
    80003558:	8082                	ret

000000008000355a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000355a:	1101                	addi	sp,sp,-32
    8000355c:	ec06                	sd	ra,24(sp)
    8000355e:	e822                	sd	s0,16(sp)
    80003560:	e426                	sd	s1,8(sp)
    80003562:	e04a                	sd	s2,0(sp)
    80003564:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003566:	00015917          	auipc	s2,0x15
    8000356a:	5ca90913          	addi	s2,s2,1482 # 80018b30 <log>
    8000356e:	01892583          	lw	a1,24(s2)
    80003572:	02892503          	lw	a0,40(s2)
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	fea080e7          	jalr	-22(ra) # 80002560 <bread>
    8000357e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003580:	02c92683          	lw	a3,44(s2)
    80003584:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003586:	02d05763          	blez	a3,800035b4 <write_head+0x5a>
    8000358a:	00015797          	auipc	a5,0x15
    8000358e:	5d678793          	addi	a5,a5,1494 # 80018b60 <log+0x30>
    80003592:	05c50713          	addi	a4,a0,92
    80003596:	36fd                	addiw	a3,a3,-1
    80003598:	1682                	slli	a3,a3,0x20
    8000359a:	9281                	srli	a3,a3,0x20
    8000359c:	068a                	slli	a3,a3,0x2
    8000359e:	00015617          	auipc	a2,0x15
    800035a2:	5c660613          	addi	a2,a2,1478 # 80018b64 <log+0x34>
    800035a6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035a8:	4390                	lw	a2,0(a5)
    800035aa:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035ac:	0791                	addi	a5,a5,4
    800035ae:	0711                	addi	a4,a4,4
    800035b0:	fed79ce3          	bne	a5,a3,800035a8 <write_head+0x4e>
  }
  bwrite(buf);
    800035b4:	8526                	mv	a0,s1
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	09c080e7          	jalr	156(ra) # 80002652 <bwrite>
  brelse(buf);
    800035be:	8526                	mv	a0,s1
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	0d0080e7          	jalr	208(ra) # 80002690 <brelse>
}
    800035c8:	60e2                	ld	ra,24(sp)
    800035ca:	6442                	ld	s0,16(sp)
    800035cc:	64a2                	ld	s1,8(sp)
    800035ce:	6902                	ld	s2,0(sp)
    800035d0:	6105                	addi	sp,sp,32
    800035d2:	8082                	ret

00000000800035d4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d4:	00015797          	auipc	a5,0x15
    800035d8:	5887a783          	lw	a5,1416(a5) # 80018b5c <log+0x2c>
    800035dc:	0af05d63          	blez	a5,80003696 <install_trans+0xc2>
{
    800035e0:	7139                	addi	sp,sp,-64
    800035e2:	fc06                	sd	ra,56(sp)
    800035e4:	f822                	sd	s0,48(sp)
    800035e6:	f426                	sd	s1,40(sp)
    800035e8:	f04a                	sd	s2,32(sp)
    800035ea:	ec4e                	sd	s3,24(sp)
    800035ec:	e852                	sd	s4,16(sp)
    800035ee:	e456                	sd	s5,8(sp)
    800035f0:	e05a                	sd	s6,0(sp)
    800035f2:	0080                	addi	s0,sp,64
    800035f4:	8b2a                	mv	s6,a0
    800035f6:	00015a97          	auipc	s5,0x15
    800035fa:	56aa8a93          	addi	s5,s5,1386 # 80018b60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035fe:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003600:	00015997          	auipc	s3,0x15
    80003604:	53098993          	addi	s3,s3,1328 # 80018b30 <log>
    80003608:	a00d                	j	8000362a <install_trans+0x56>
    brelse(lbuf);
    8000360a:	854a                	mv	a0,s2
    8000360c:	fffff097          	auipc	ra,0xfffff
    80003610:	084080e7          	jalr	132(ra) # 80002690 <brelse>
    brelse(dbuf);
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	07a080e7          	jalr	122(ra) # 80002690 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000361e:	2a05                	addiw	s4,s4,1
    80003620:	0a91                	addi	s5,s5,4
    80003622:	02c9a783          	lw	a5,44(s3)
    80003626:	04fa5e63          	bge	s4,a5,80003682 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000362a:	0189a583          	lw	a1,24(s3)
    8000362e:	014585bb          	addw	a1,a1,s4
    80003632:	2585                	addiw	a1,a1,1
    80003634:	0289a503          	lw	a0,40(s3)
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	f28080e7          	jalr	-216(ra) # 80002560 <bread>
    80003640:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003642:	000aa583          	lw	a1,0(s5)
    80003646:	0289a503          	lw	a0,40(s3)
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	f16080e7          	jalr	-234(ra) # 80002560 <bread>
    80003652:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003654:	40000613          	li	a2,1024
    80003658:	05890593          	addi	a1,s2,88
    8000365c:	05850513          	addi	a0,a0,88
    80003660:	ffffd097          	auipc	ra,0xffffd
    80003664:	b74080e7          	jalr	-1164(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003668:	8526                	mv	a0,s1
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	fe8080e7          	jalr	-24(ra) # 80002652 <bwrite>
    if(recovering == 0)
    80003672:	f80b1ce3          	bnez	s6,8000360a <install_trans+0x36>
      bunpin(dbuf);
    80003676:	8526                	mv	a0,s1
    80003678:	fffff097          	auipc	ra,0xfffff
    8000367c:	0f2080e7          	jalr	242(ra) # 8000276a <bunpin>
    80003680:	b769                	j	8000360a <install_trans+0x36>
}
    80003682:	70e2                	ld	ra,56(sp)
    80003684:	7442                	ld	s0,48(sp)
    80003686:	74a2                	ld	s1,40(sp)
    80003688:	7902                	ld	s2,32(sp)
    8000368a:	69e2                	ld	s3,24(sp)
    8000368c:	6a42                	ld	s4,16(sp)
    8000368e:	6aa2                	ld	s5,8(sp)
    80003690:	6b02                	ld	s6,0(sp)
    80003692:	6121                	addi	sp,sp,64
    80003694:	8082                	ret
    80003696:	8082                	ret

0000000080003698 <initlog>:
{
    80003698:	7179                	addi	sp,sp,-48
    8000369a:	f406                	sd	ra,40(sp)
    8000369c:	f022                	sd	s0,32(sp)
    8000369e:	ec26                	sd	s1,24(sp)
    800036a0:	e84a                	sd	s2,16(sp)
    800036a2:	e44e                	sd	s3,8(sp)
    800036a4:	1800                	addi	s0,sp,48
    800036a6:	892a                	mv	s2,a0
    800036a8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036aa:	00015497          	auipc	s1,0x15
    800036ae:	48648493          	addi	s1,s1,1158 # 80018b30 <log>
    800036b2:	00005597          	auipc	a1,0x5
    800036b6:	f6e58593          	addi	a1,a1,-146 # 80008620 <syscalls+0x220>
    800036ba:	8526                	mv	a0,s1
    800036bc:	00003097          	auipc	ra,0x3
    800036c0:	c2e080e7          	jalr	-978(ra) # 800062ea <initlock>
  log.start = sb->logstart;
    800036c4:	0149a583          	lw	a1,20(s3)
    800036c8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036ca:	0109a783          	lw	a5,16(s3)
    800036ce:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036d0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036d4:	854a                	mv	a0,s2
    800036d6:	fffff097          	auipc	ra,0xfffff
    800036da:	e8a080e7          	jalr	-374(ra) # 80002560 <bread>
  log.lh.n = lh->n;
    800036de:	4d34                	lw	a3,88(a0)
    800036e0:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036e2:	02d05563          	blez	a3,8000370c <initlog+0x74>
    800036e6:	05c50793          	addi	a5,a0,92
    800036ea:	00015717          	auipc	a4,0x15
    800036ee:	47670713          	addi	a4,a4,1142 # 80018b60 <log+0x30>
    800036f2:	36fd                	addiw	a3,a3,-1
    800036f4:	1682                	slli	a3,a3,0x20
    800036f6:	9281                	srli	a3,a3,0x20
    800036f8:	068a                	slli	a3,a3,0x2
    800036fa:	06050613          	addi	a2,a0,96
    800036fe:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003700:	4390                	lw	a2,0(a5)
    80003702:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003704:	0791                	addi	a5,a5,4
    80003706:	0711                	addi	a4,a4,4
    80003708:	fed79ce3          	bne	a5,a3,80003700 <initlog+0x68>
  brelse(buf);
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	f84080e7          	jalr	-124(ra) # 80002690 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003714:	4505                	li	a0,1
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	ebe080e7          	jalr	-322(ra) # 800035d4 <install_trans>
  log.lh.n = 0;
    8000371e:	00015797          	auipc	a5,0x15
    80003722:	4207af23          	sw	zero,1086(a5) # 80018b5c <log+0x2c>
  write_head(); // clear the log
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	e34080e7          	jalr	-460(ra) # 8000355a <write_head>
}
    8000372e:	70a2                	ld	ra,40(sp)
    80003730:	7402                	ld	s0,32(sp)
    80003732:	64e2                	ld	s1,24(sp)
    80003734:	6942                	ld	s2,16(sp)
    80003736:	69a2                	ld	s3,8(sp)
    80003738:	6145                	addi	sp,sp,48
    8000373a:	8082                	ret

000000008000373c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003748:	00015517          	auipc	a0,0x15
    8000374c:	3e850513          	addi	a0,a0,1000 # 80018b30 <log>
    80003750:	00003097          	auipc	ra,0x3
    80003754:	c2a080e7          	jalr	-982(ra) # 8000637a <acquire>
  while(1){
    if(log.committing){
    80003758:	00015497          	auipc	s1,0x15
    8000375c:	3d848493          	addi	s1,s1,984 # 80018b30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003760:	4979                	li	s2,30
    80003762:	a039                	j	80003770 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003764:	85a6                	mv	a1,s1
    80003766:	8526                	mv	a0,s1
    80003768:	ffffe097          	auipc	ra,0xffffe
    8000376c:	f22080e7          	jalr	-222(ra) # 8000168a <sleep>
    if(log.committing){
    80003770:	50dc                	lw	a5,36(s1)
    80003772:	fbed                	bnez	a5,80003764 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003774:	509c                	lw	a5,32(s1)
    80003776:	0017871b          	addiw	a4,a5,1
    8000377a:	0007069b          	sext.w	a3,a4
    8000377e:	0027179b          	slliw	a5,a4,0x2
    80003782:	9fb9                	addw	a5,a5,a4
    80003784:	0017979b          	slliw	a5,a5,0x1
    80003788:	54d8                	lw	a4,44(s1)
    8000378a:	9fb9                	addw	a5,a5,a4
    8000378c:	00f95963          	bge	s2,a5,8000379e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003790:	85a6                	mv	a1,s1
    80003792:	8526                	mv	a0,s1
    80003794:	ffffe097          	auipc	ra,0xffffe
    80003798:	ef6080e7          	jalr	-266(ra) # 8000168a <sleep>
    8000379c:	bfd1                	j	80003770 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000379e:	00015517          	auipc	a0,0x15
    800037a2:	39250513          	addi	a0,a0,914 # 80018b30 <log>
    800037a6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	c86080e7          	jalr	-890(ra) # 8000642e <release>
      break;
    }
  }
}
    800037b0:	60e2                	ld	ra,24(sp)
    800037b2:	6442                	ld	s0,16(sp)
    800037b4:	64a2                	ld	s1,8(sp)
    800037b6:	6902                	ld	s2,0(sp)
    800037b8:	6105                	addi	sp,sp,32
    800037ba:	8082                	ret

00000000800037bc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037bc:	7139                	addi	sp,sp,-64
    800037be:	fc06                	sd	ra,56(sp)
    800037c0:	f822                	sd	s0,48(sp)
    800037c2:	f426                	sd	s1,40(sp)
    800037c4:	f04a                	sd	s2,32(sp)
    800037c6:	ec4e                	sd	s3,24(sp)
    800037c8:	e852                	sd	s4,16(sp)
    800037ca:	e456                	sd	s5,8(sp)
    800037cc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037ce:	00015497          	auipc	s1,0x15
    800037d2:	36248493          	addi	s1,s1,866 # 80018b30 <log>
    800037d6:	8526                	mv	a0,s1
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	ba2080e7          	jalr	-1118(ra) # 8000637a <acquire>
  log.outstanding -= 1;
    800037e0:	509c                	lw	a5,32(s1)
    800037e2:	37fd                	addiw	a5,a5,-1
    800037e4:	0007891b          	sext.w	s2,a5
    800037e8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037ea:	50dc                	lw	a5,36(s1)
    800037ec:	e7b9                	bnez	a5,8000383a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ee:	04091e63          	bnez	s2,8000384a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037f2:	00015497          	auipc	s1,0x15
    800037f6:	33e48493          	addi	s1,s1,830 # 80018b30 <log>
    800037fa:	4785                	li	a5,1
    800037fc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037fe:	8526                	mv	a0,s1
    80003800:	00003097          	auipc	ra,0x3
    80003804:	c2e080e7          	jalr	-978(ra) # 8000642e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003808:	54dc                	lw	a5,44(s1)
    8000380a:	06f04763          	bgtz	a5,80003878 <end_op+0xbc>
    acquire(&log.lock);
    8000380e:	00015497          	auipc	s1,0x15
    80003812:	32248493          	addi	s1,s1,802 # 80018b30 <log>
    80003816:	8526                	mv	a0,s1
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	b62080e7          	jalr	-1182(ra) # 8000637a <acquire>
    log.committing = 0;
    80003820:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003824:	8526                	mv	a0,s1
    80003826:	ffffe097          	auipc	ra,0xffffe
    8000382a:	ec8080e7          	jalr	-312(ra) # 800016ee <wakeup>
    release(&log.lock);
    8000382e:	8526                	mv	a0,s1
    80003830:	00003097          	auipc	ra,0x3
    80003834:	bfe080e7          	jalr	-1026(ra) # 8000642e <release>
}
    80003838:	a03d                	j	80003866 <end_op+0xaa>
    panic("log.committing");
    8000383a:	00005517          	auipc	a0,0x5
    8000383e:	dee50513          	addi	a0,a0,-530 # 80008628 <syscalls+0x228>
    80003842:	00002097          	auipc	ra,0x2
    80003846:	5fc080e7          	jalr	1532(ra) # 80005e3e <panic>
    wakeup(&log);
    8000384a:	00015497          	auipc	s1,0x15
    8000384e:	2e648493          	addi	s1,s1,742 # 80018b30 <log>
    80003852:	8526                	mv	a0,s1
    80003854:	ffffe097          	auipc	ra,0xffffe
    80003858:	e9a080e7          	jalr	-358(ra) # 800016ee <wakeup>
  release(&log.lock);
    8000385c:	8526                	mv	a0,s1
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	bd0080e7          	jalr	-1072(ra) # 8000642e <release>
}
    80003866:	70e2                	ld	ra,56(sp)
    80003868:	7442                	ld	s0,48(sp)
    8000386a:	74a2                	ld	s1,40(sp)
    8000386c:	7902                	ld	s2,32(sp)
    8000386e:	69e2                	ld	s3,24(sp)
    80003870:	6a42                	ld	s4,16(sp)
    80003872:	6aa2                	ld	s5,8(sp)
    80003874:	6121                	addi	sp,sp,64
    80003876:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003878:	00015a97          	auipc	s5,0x15
    8000387c:	2e8a8a93          	addi	s5,s5,744 # 80018b60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003880:	00015a17          	auipc	s4,0x15
    80003884:	2b0a0a13          	addi	s4,s4,688 # 80018b30 <log>
    80003888:	018a2583          	lw	a1,24(s4)
    8000388c:	012585bb          	addw	a1,a1,s2
    80003890:	2585                	addiw	a1,a1,1
    80003892:	028a2503          	lw	a0,40(s4)
    80003896:	fffff097          	auipc	ra,0xfffff
    8000389a:	cca080e7          	jalr	-822(ra) # 80002560 <bread>
    8000389e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038a0:	000aa583          	lw	a1,0(s5)
    800038a4:	028a2503          	lw	a0,40(s4)
    800038a8:	fffff097          	auipc	ra,0xfffff
    800038ac:	cb8080e7          	jalr	-840(ra) # 80002560 <bread>
    800038b0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038b2:	40000613          	li	a2,1024
    800038b6:	05850593          	addi	a1,a0,88
    800038ba:	05848513          	addi	a0,s1,88
    800038be:	ffffd097          	auipc	ra,0xffffd
    800038c2:	916080e7          	jalr	-1770(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    800038c6:	8526                	mv	a0,s1
    800038c8:	fffff097          	auipc	ra,0xfffff
    800038cc:	d8a080e7          	jalr	-630(ra) # 80002652 <bwrite>
    brelse(from);
    800038d0:	854e                	mv	a0,s3
    800038d2:	fffff097          	auipc	ra,0xfffff
    800038d6:	dbe080e7          	jalr	-578(ra) # 80002690 <brelse>
    brelse(to);
    800038da:	8526                	mv	a0,s1
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	db4080e7          	jalr	-588(ra) # 80002690 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038e4:	2905                	addiw	s2,s2,1
    800038e6:	0a91                	addi	s5,s5,4
    800038e8:	02ca2783          	lw	a5,44(s4)
    800038ec:	f8f94ee3          	blt	s2,a5,80003888 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038f0:	00000097          	auipc	ra,0x0
    800038f4:	c6a080e7          	jalr	-918(ra) # 8000355a <write_head>
    install_trans(0); // Now install writes to home locations
    800038f8:	4501                	li	a0,0
    800038fa:	00000097          	auipc	ra,0x0
    800038fe:	cda080e7          	jalr	-806(ra) # 800035d4 <install_trans>
    log.lh.n = 0;
    80003902:	00015797          	auipc	a5,0x15
    80003906:	2407ad23          	sw	zero,602(a5) # 80018b5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000390a:	00000097          	auipc	ra,0x0
    8000390e:	c50080e7          	jalr	-944(ra) # 8000355a <write_head>
    80003912:	bdf5                	j	8000380e <end_op+0x52>

0000000080003914 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003914:	1101                	addi	sp,sp,-32
    80003916:	ec06                	sd	ra,24(sp)
    80003918:	e822                	sd	s0,16(sp)
    8000391a:	e426                	sd	s1,8(sp)
    8000391c:	e04a                	sd	s2,0(sp)
    8000391e:	1000                	addi	s0,sp,32
    80003920:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003922:	00015917          	auipc	s2,0x15
    80003926:	20e90913          	addi	s2,s2,526 # 80018b30 <log>
    8000392a:	854a                	mv	a0,s2
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	a4e080e7          	jalr	-1458(ra) # 8000637a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003934:	02c92603          	lw	a2,44(s2)
    80003938:	47f5                	li	a5,29
    8000393a:	06c7c563          	blt	a5,a2,800039a4 <log_write+0x90>
    8000393e:	00015797          	auipc	a5,0x15
    80003942:	20e7a783          	lw	a5,526(a5) # 80018b4c <log+0x1c>
    80003946:	37fd                	addiw	a5,a5,-1
    80003948:	04f65e63          	bge	a2,a5,800039a4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000394c:	00015797          	auipc	a5,0x15
    80003950:	2047a783          	lw	a5,516(a5) # 80018b50 <log+0x20>
    80003954:	06f05063          	blez	a5,800039b4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003958:	4781                	li	a5,0
    8000395a:	06c05563          	blez	a2,800039c4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000395e:	44cc                	lw	a1,12(s1)
    80003960:	00015717          	auipc	a4,0x15
    80003964:	20070713          	addi	a4,a4,512 # 80018b60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003968:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000396a:	4314                	lw	a3,0(a4)
    8000396c:	04b68c63          	beq	a3,a1,800039c4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003970:	2785                	addiw	a5,a5,1
    80003972:	0711                	addi	a4,a4,4
    80003974:	fef61be3          	bne	a2,a5,8000396a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003978:	0621                	addi	a2,a2,8
    8000397a:	060a                	slli	a2,a2,0x2
    8000397c:	00015797          	auipc	a5,0x15
    80003980:	1b478793          	addi	a5,a5,436 # 80018b30 <log>
    80003984:	963e                	add	a2,a2,a5
    80003986:	44dc                	lw	a5,12(s1)
    80003988:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000398a:	8526                	mv	a0,s1
    8000398c:	fffff097          	auipc	ra,0xfffff
    80003990:	da2080e7          	jalr	-606(ra) # 8000272e <bpin>
    log.lh.n++;
    80003994:	00015717          	auipc	a4,0x15
    80003998:	19c70713          	addi	a4,a4,412 # 80018b30 <log>
    8000399c:	575c                	lw	a5,44(a4)
    8000399e:	2785                	addiw	a5,a5,1
    800039a0:	d75c                	sw	a5,44(a4)
    800039a2:	a835                	j	800039de <log_write+0xca>
    panic("too big a transaction");
    800039a4:	00005517          	auipc	a0,0x5
    800039a8:	c9450513          	addi	a0,a0,-876 # 80008638 <syscalls+0x238>
    800039ac:	00002097          	auipc	ra,0x2
    800039b0:	492080e7          	jalr	1170(ra) # 80005e3e <panic>
    panic("log_write outside of trans");
    800039b4:	00005517          	auipc	a0,0x5
    800039b8:	c9c50513          	addi	a0,a0,-868 # 80008650 <syscalls+0x250>
    800039bc:	00002097          	auipc	ra,0x2
    800039c0:	482080e7          	jalr	1154(ra) # 80005e3e <panic>
  log.lh.block[i] = b->blockno;
    800039c4:	00878713          	addi	a4,a5,8
    800039c8:	00271693          	slli	a3,a4,0x2
    800039cc:	00015717          	auipc	a4,0x15
    800039d0:	16470713          	addi	a4,a4,356 # 80018b30 <log>
    800039d4:	9736                	add	a4,a4,a3
    800039d6:	44d4                	lw	a3,12(s1)
    800039d8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039da:	faf608e3          	beq	a2,a5,8000398a <log_write+0x76>
  }
  release(&log.lock);
    800039de:	00015517          	auipc	a0,0x15
    800039e2:	15250513          	addi	a0,a0,338 # 80018b30 <log>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	a48080e7          	jalr	-1464(ra) # 8000642e <release>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6902                	ld	s2,0(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039fa:	1101                	addi	sp,sp,-32
    800039fc:	ec06                	sd	ra,24(sp)
    800039fe:	e822                	sd	s0,16(sp)
    80003a00:	e426                	sd	s1,8(sp)
    80003a02:	e04a                	sd	s2,0(sp)
    80003a04:	1000                	addi	s0,sp,32
    80003a06:	84aa                	mv	s1,a0
    80003a08:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a0a:	00005597          	auipc	a1,0x5
    80003a0e:	c6658593          	addi	a1,a1,-922 # 80008670 <syscalls+0x270>
    80003a12:	0521                	addi	a0,a0,8
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	8d6080e7          	jalr	-1834(ra) # 800062ea <initlock>
  lk->name = name;
    80003a1c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a20:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a24:	0204a423          	sw	zero,40(s1)
}
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	64a2                	ld	s1,8(sp)
    80003a2e:	6902                	ld	s2,0(sp)
    80003a30:	6105                	addi	sp,sp,32
    80003a32:	8082                	ret

0000000080003a34 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a34:	1101                	addi	sp,sp,-32
    80003a36:	ec06                	sd	ra,24(sp)
    80003a38:	e822                	sd	s0,16(sp)
    80003a3a:	e426                	sd	s1,8(sp)
    80003a3c:	e04a                	sd	s2,0(sp)
    80003a3e:	1000                	addi	s0,sp,32
    80003a40:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a42:	00850913          	addi	s2,a0,8
    80003a46:	854a                	mv	a0,s2
    80003a48:	00003097          	auipc	ra,0x3
    80003a4c:	932080e7          	jalr	-1742(ra) # 8000637a <acquire>
  while (lk->locked) {
    80003a50:	409c                	lw	a5,0(s1)
    80003a52:	cb89                	beqz	a5,80003a64 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a54:	85ca                	mv	a1,s2
    80003a56:	8526                	mv	a0,s1
    80003a58:	ffffe097          	auipc	ra,0xffffe
    80003a5c:	c32080e7          	jalr	-974(ra) # 8000168a <sleep>
  while (lk->locked) {
    80003a60:	409c                	lw	a5,0(s1)
    80003a62:	fbed                	bnez	a5,80003a54 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a64:	4785                	li	a5,1
    80003a66:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a68:	ffffd097          	auipc	ra,0xffffd
    80003a6c:	4cc080e7          	jalr	1228(ra) # 80000f34 <myproc>
    80003a70:	591c                	lw	a5,48(a0)
    80003a72:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a74:	854a                	mv	a0,s2
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	9b8080e7          	jalr	-1608(ra) # 8000642e <release>
}
    80003a7e:	60e2                	ld	ra,24(sp)
    80003a80:	6442                	ld	s0,16(sp)
    80003a82:	64a2                	ld	s1,8(sp)
    80003a84:	6902                	ld	s2,0(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret

0000000080003a8a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a8a:	1101                	addi	sp,sp,-32
    80003a8c:	ec06                	sd	ra,24(sp)
    80003a8e:	e822                	sd	s0,16(sp)
    80003a90:	e426                	sd	s1,8(sp)
    80003a92:	e04a                	sd	s2,0(sp)
    80003a94:	1000                	addi	s0,sp,32
    80003a96:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a98:	00850913          	addi	s2,a0,8
    80003a9c:	854a                	mv	a0,s2
    80003a9e:	00003097          	auipc	ra,0x3
    80003aa2:	8dc080e7          	jalr	-1828(ra) # 8000637a <acquire>
  lk->locked = 0;
    80003aa6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aaa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aae:	8526                	mv	a0,s1
    80003ab0:	ffffe097          	auipc	ra,0xffffe
    80003ab4:	c3e080e7          	jalr	-962(ra) # 800016ee <wakeup>
  release(&lk->lk);
    80003ab8:	854a                	mv	a0,s2
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	974080e7          	jalr	-1676(ra) # 8000642e <release>
}
    80003ac2:	60e2                	ld	ra,24(sp)
    80003ac4:	6442                	ld	s0,16(sp)
    80003ac6:	64a2                	ld	s1,8(sp)
    80003ac8:	6902                	ld	s2,0(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ace:	7179                	addi	sp,sp,-48
    80003ad0:	f406                	sd	ra,40(sp)
    80003ad2:	f022                	sd	s0,32(sp)
    80003ad4:	ec26                	sd	s1,24(sp)
    80003ad6:	e84a                	sd	s2,16(sp)
    80003ad8:	e44e                	sd	s3,8(sp)
    80003ada:	1800                	addi	s0,sp,48
    80003adc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ade:	00850913          	addi	s2,a0,8
    80003ae2:	854a                	mv	a0,s2
    80003ae4:	00003097          	auipc	ra,0x3
    80003ae8:	896080e7          	jalr	-1898(ra) # 8000637a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aec:	409c                	lw	a5,0(s1)
    80003aee:	ef99                	bnez	a5,80003b0c <holdingsleep+0x3e>
    80003af0:	4481                	li	s1,0
  release(&lk->lk);
    80003af2:	854a                	mv	a0,s2
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	93a080e7          	jalr	-1734(ra) # 8000642e <release>
  return r;
}
    80003afc:	8526                	mv	a0,s1
    80003afe:	70a2                	ld	ra,40(sp)
    80003b00:	7402                	ld	s0,32(sp)
    80003b02:	64e2                	ld	s1,24(sp)
    80003b04:	6942                	ld	s2,16(sp)
    80003b06:	69a2                	ld	s3,8(sp)
    80003b08:	6145                	addi	sp,sp,48
    80003b0a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b0c:	0284a983          	lw	s3,40(s1)
    80003b10:	ffffd097          	auipc	ra,0xffffd
    80003b14:	424080e7          	jalr	1060(ra) # 80000f34 <myproc>
    80003b18:	5904                	lw	s1,48(a0)
    80003b1a:	413484b3          	sub	s1,s1,s3
    80003b1e:	0014b493          	seqz	s1,s1
    80003b22:	bfc1                	j	80003af2 <holdingsleep+0x24>

0000000080003b24 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b24:	1141                	addi	sp,sp,-16
    80003b26:	e406                	sd	ra,8(sp)
    80003b28:	e022                	sd	s0,0(sp)
    80003b2a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b2c:	00005597          	auipc	a1,0x5
    80003b30:	b5458593          	addi	a1,a1,-1196 # 80008680 <syscalls+0x280>
    80003b34:	00015517          	auipc	a0,0x15
    80003b38:	14450513          	addi	a0,a0,324 # 80018c78 <ftable>
    80003b3c:	00002097          	auipc	ra,0x2
    80003b40:	7ae080e7          	jalr	1966(ra) # 800062ea <initlock>
}
    80003b44:	60a2                	ld	ra,8(sp)
    80003b46:	6402                	ld	s0,0(sp)
    80003b48:	0141                	addi	sp,sp,16
    80003b4a:	8082                	ret

0000000080003b4c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b4c:	1101                	addi	sp,sp,-32
    80003b4e:	ec06                	sd	ra,24(sp)
    80003b50:	e822                	sd	s0,16(sp)
    80003b52:	e426                	sd	s1,8(sp)
    80003b54:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b56:	00015517          	auipc	a0,0x15
    80003b5a:	12250513          	addi	a0,a0,290 # 80018c78 <ftable>
    80003b5e:	00003097          	auipc	ra,0x3
    80003b62:	81c080e7          	jalr	-2020(ra) # 8000637a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b66:	00015497          	auipc	s1,0x15
    80003b6a:	12a48493          	addi	s1,s1,298 # 80018c90 <ftable+0x18>
    80003b6e:	00016717          	auipc	a4,0x16
    80003b72:	0c270713          	addi	a4,a4,194 # 80019c30 <disk>
    if(f->ref == 0){
    80003b76:	40dc                	lw	a5,4(s1)
    80003b78:	cf99                	beqz	a5,80003b96 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b7a:	02848493          	addi	s1,s1,40
    80003b7e:	fee49ce3          	bne	s1,a4,80003b76 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b82:	00015517          	auipc	a0,0x15
    80003b86:	0f650513          	addi	a0,a0,246 # 80018c78 <ftable>
    80003b8a:	00003097          	auipc	ra,0x3
    80003b8e:	8a4080e7          	jalr	-1884(ra) # 8000642e <release>
  return 0;
    80003b92:	4481                	li	s1,0
    80003b94:	a819                	j	80003baa <filealloc+0x5e>
      f->ref = 1;
    80003b96:	4785                	li	a5,1
    80003b98:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b9a:	00015517          	auipc	a0,0x15
    80003b9e:	0de50513          	addi	a0,a0,222 # 80018c78 <ftable>
    80003ba2:	00003097          	auipc	ra,0x3
    80003ba6:	88c080e7          	jalr	-1908(ra) # 8000642e <release>
}
    80003baa:	8526                	mv	a0,s1
    80003bac:	60e2                	ld	ra,24(sp)
    80003bae:	6442                	ld	s0,16(sp)
    80003bb0:	64a2                	ld	s1,8(sp)
    80003bb2:	6105                	addi	sp,sp,32
    80003bb4:	8082                	ret

0000000080003bb6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bb6:	1101                	addi	sp,sp,-32
    80003bb8:	ec06                	sd	ra,24(sp)
    80003bba:	e822                	sd	s0,16(sp)
    80003bbc:	e426                	sd	s1,8(sp)
    80003bbe:	1000                	addi	s0,sp,32
    80003bc0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bc2:	00015517          	auipc	a0,0x15
    80003bc6:	0b650513          	addi	a0,a0,182 # 80018c78 <ftable>
    80003bca:	00002097          	auipc	ra,0x2
    80003bce:	7b0080e7          	jalr	1968(ra) # 8000637a <acquire>
  if(f->ref < 1)
    80003bd2:	40dc                	lw	a5,4(s1)
    80003bd4:	02f05263          	blez	a5,80003bf8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bd8:	2785                	addiw	a5,a5,1
    80003bda:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bdc:	00015517          	auipc	a0,0x15
    80003be0:	09c50513          	addi	a0,a0,156 # 80018c78 <ftable>
    80003be4:	00003097          	auipc	ra,0x3
    80003be8:	84a080e7          	jalr	-1974(ra) # 8000642e <release>
  return f;
}
    80003bec:	8526                	mv	a0,s1
    80003bee:	60e2                	ld	ra,24(sp)
    80003bf0:	6442                	ld	s0,16(sp)
    80003bf2:	64a2                	ld	s1,8(sp)
    80003bf4:	6105                	addi	sp,sp,32
    80003bf6:	8082                	ret
    panic("filedup");
    80003bf8:	00005517          	auipc	a0,0x5
    80003bfc:	a9050513          	addi	a0,a0,-1392 # 80008688 <syscalls+0x288>
    80003c00:	00002097          	auipc	ra,0x2
    80003c04:	23e080e7          	jalr	574(ra) # 80005e3e <panic>

0000000080003c08 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c08:	7139                	addi	sp,sp,-64
    80003c0a:	fc06                	sd	ra,56(sp)
    80003c0c:	f822                	sd	s0,48(sp)
    80003c0e:	f426                	sd	s1,40(sp)
    80003c10:	f04a                	sd	s2,32(sp)
    80003c12:	ec4e                	sd	s3,24(sp)
    80003c14:	e852                	sd	s4,16(sp)
    80003c16:	e456                	sd	s5,8(sp)
    80003c18:	0080                	addi	s0,sp,64
    80003c1a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c1c:	00015517          	auipc	a0,0x15
    80003c20:	05c50513          	addi	a0,a0,92 # 80018c78 <ftable>
    80003c24:	00002097          	auipc	ra,0x2
    80003c28:	756080e7          	jalr	1878(ra) # 8000637a <acquire>
  if(f->ref < 1)
    80003c2c:	40dc                	lw	a5,4(s1)
    80003c2e:	06f05163          	blez	a5,80003c90 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c32:	37fd                	addiw	a5,a5,-1
    80003c34:	0007871b          	sext.w	a4,a5
    80003c38:	c0dc                	sw	a5,4(s1)
    80003c3a:	06e04363          	bgtz	a4,80003ca0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c3e:	0004a903          	lw	s2,0(s1)
    80003c42:	0094ca83          	lbu	s5,9(s1)
    80003c46:	0104ba03          	ld	s4,16(s1)
    80003c4a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c4e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c52:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c56:	00015517          	auipc	a0,0x15
    80003c5a:	02250513          	addi	a0,a0,34 # 80018c78 <ftable>
    80003c5e:	00002097          	auipc	ra,0x2
    80003c62:	7d0080e7          	jalr	2000(ra) # 8000642e <release>

  if(ff.type == FD_PIPE){
    80003c66:	4785                	li	a5,1
    80003c68:	04f90d63          	beq	s2,a5,80003cc2 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c6c:	3979                	addiw	s2,s2,-2
    80003c6e:	4785                	li	a5,1
    80003c70:	0527e063          	bltu	a5,s2,80003cb0 <fileclose+0xa8>
    begin_op();
    80003c74:	00000097          	auipc	ra,0x0
    80003c78:	ac8080e7          	jalr	-1336(ra) # 8000373c <begin_op>
    iput(ff.ip);
    80003c7c:	854e                	mv	a0,s3
    80003c7e:	fffff097          	auipc	ra,0xfffff
    80003c82:	2b6080e7          	jalr	694(ra) # 80002f34 <iput>
    end_op();
    80003c86:	00000097          	auipc	ra,0x0
    80003c8a:	b36080e7          	jalr	-1226(ra) # 800037bc <end_op>
    80003c8e:	a00d                	j	80003cb0 <fileclose+0xa8>
    panic("fileclose");
    80003c90:	00005517          	auipc	a0,0x5
    80003c94:	a0050513          	addi	a0,a0,-1536 # 80008690 <syscalls+0x290>
    80003c98:	00002097          	auipc	ra,0x2
    80003c9c:	1a6080e7          	jalr	422(ra) # 80005e3e <panic>
    release(&ftable.lock);
    80003ca0:	00015517          	auipc	a0,0x15
    80003ca4:	fd850513          	addi	a0,a0,-40 # 80018c78 <ftable>
    80003ca8:	00002097          	auipc	ra,0x2
    80003cac:	786080e7          	jalr	1926(ra) # 8000642e <release>
  }
}
    80003cb0:	70e2                	ld	ra,56(sp)
    80003cb2:	7442                	ld	s0,48(sp)
    80003cb4:	74a2                	ld	s1,40(sp)
    80003cb6:	7902                	ld	s2,32(sp)
    80003cb8:	69e2                	ld	s3,24(sp)
    80003cba:	6a42                	ld	s4,16(sp)
    80003cbc:	6aa2                	ld	s5,8(sp)
    80003cbe:	6121                	addi	sp,sp,64
    80003cc0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cc2:	85d6                	mv	a1,s5
    80003cc4:	8552                	mv	a0,s4
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	34c080e7          	jalr	844(ra) # 80004012 <pipeclose>
    80003cce:	b7cd                	j	80003cb0 <fileclose+0xa8>

0000000080003cd0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cd0:	715d                	addi	sp,sp,-80
    80003cd2:	e486                	sd	ra,72(sp)
    80003cd4:	e0a2                	sd	s0,64(sp)
    80003cd6:	fc26                	sd	s1,56(sp)
    80003cd8:	f84a                	sd	s2,48(sp)
    80003cda:	f44e                	sd	s3,40(sp)
    80003cdc:	0880                	addi	s0,sp,80
    80003cde:	84aa                	mv	s1,a0
    80003ce0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	252080e7          	jalr	594(ra) # 80000f34 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cea:	409c                	lw	a5,0(s1)
    80003cec:	37f9                	addiw	a5,a5,-2
    80003cee:	4705                	li	a4,1
    80003cf0:	04f76763          	bltu	a4,a5,80003d3e <filestat+0x6e>
    80003cf4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cf6:	6c88                	ld	a0,24(s1)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	082080e7          	jalr	130(ra) # 80002d7a <ilock>
    stati(f->ip, &st);
    80003d00:	fb840593          	addi	a1,s0,-72
    80003d04:	6c88                	ld	a0,24(s1)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	2fe080e7          	jalr	766(ra) # 80003004 <stati>
    iunlock(f->ip);
    80003d0e:	6c88                	ld	a0,24(s1)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	12c080e7          	jalr	300(ra) # 80002e3c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d18:	46e1                	li	a3,24
    80003d1a:	fb840613          	addi	a2,s0,-72
    80003d1e:	85ce                	mv	a1,s3
    80003d20:	05093503          	ld	a0,80(s2)
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	dea080e7          	jalr	-534(ra) # 80000b0e <copyout>
    80003d2c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d30:	60a6                	ld	ra,72(sp)
    80003d32:	6406                	ld	s0,64(sp)
    80003d34:	74e2                	ld	s1,56(sp)
    80003d36:	7942                	ld	s2,48(sp)
    80003d38:	79a2                	ld	s3,40(sp)
    80003d3a:	6161                	addi	sp,sp,80
    80003d3c:	8082                	ret
  return -1;
    80003d3e:	557d                	li	a0,-1
    80003d40:	bfc5                	j	80003d30 <filestat+0x60>

0000000080003d42 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d42:	7179                	addi	sp,sp,-48
    80003d44:	f406                	sd	ra,40(sp)
    80003d46:	f022                	sd	s0,32(sp)
    80003d48:	ec26                	sd	s1,24(sp)
    80003d4a:	e84a                	sd	s2,16(sp)
    80003d4c:	e44e                	sd	s3,8(sp)
    80003d4e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d50:	00854783          	lbu	a5,8(a0)
    80003d54:	c3d5                	beqz	a5,80003df8 <fileread+0xb6>
    80003d56:	84aa                	mv	s1,a0
    80003d58:	89ae                	mv	s3,a1
    80003d5a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d5c:	411c                	lw	a5,0(a0)
    80003d5e:	4705                	li	a4,1
    80003d60:	04e78963          	beq	a5,a4,80003db2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d64:	470d                	li	a4,3
    80003d66:	04e78d63          	beq	a5,a4,80003dc0 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d6a:	4709                	li	a4,2
    80003d6c:	06e79e63          	bne	a5,a4,80003de8 <fileread+0xa6>
    ilock(f->ip);
    80003d70:	6d08                	ld	a0,24(a0)
    80003d72:	fffff097          	auipc	ra,0xfffff
    80003d76:	008080e7          	jalr	8(ra) # 80002d7a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d7a:	874a                	mv	a4,s2
    80003d7c:	5094                	lw	a3,32(s1)
    80003d7e:	864e                	mv	a2,s3
    80003d80:	4585                	li	a1,1
    80003d82:	6c88                	ld	a0,24(s1)
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	2aa080e7          	jalr	682(ra) # 8000302e <readi>
    80003d8c:	892a                	mv	s2,a0
    80003d8e:	00a05563          	blez	a0,80003d98 <fileread+0x56>
      f->off += r;
    80003d92:	509c                	lw	a5,32(s1)
    80003d94:	9fa9                	addw	a5,a5,a0
    80003d96:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d98:	6c88                	ld	a0,24(s1)
    80003d9a:	fffff097          	auipc	ra,0xfffff
    80003d9e:	0a2080e7          	jalr	162(ra) # 80002e3c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003da2:	854a                	mv	a0,s2
    80003da4:	70a2                	ld	ra,40(sp)
    80003da6:	7402                	ld	s0,32(sp)
    80003da8:	64e2                	ld	s1,24(sp)
    80003daa:	6942                	ld	s2,16(sp)
    80003dac:	69a2                	ld	s3,8(sp)
    80003dae:	6145                	addi	sp,sp,48
    80003db0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003db2:	6908                	ld	a0,16(a0)
    80003db4:	00000097          	auipc	ra,0x0
    80003db8:	3c6080e7          	jalr	966(ra) # 8000417a <piperead>
    80003dbc:	892a                	mv	s2,a0
    80003dbe:	b7d5                	j	80003da2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dc0:	02451783          	lh	a5,36(a0)
    80003dc4:	03079693          	slli	a3,a5,0x30
    80003dc8:	92c1                	srli	a3,a3,0x30
    80003dca:	4725                	li	a4,9
    80003dcc:	02d76863          	bltu	a4,a3,80003dfc <fileread+0xba>
    80003dd0:	0792                	slli	a5,a5,0x4
    80003dd2:	00015717          	auipc	a4,0x15
    80003dd6:	e0670713          	addi	a4,a4,-506 # 80018bd8 <devsw>
    80003dda:	97ba                	add	a5,a5,a4
    80003ddc:	639c                	ld	a5,0(a5)
    80003dde:	c38d                	beqz	a5,80003e00 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003de0:	4505                	li	a0,1
    80003de2:	9782                	jalr	a5
    80003de4:	892a                	mv	s2,a0
    80003de6:	bf75                	j	80003da2 <fileread+0x60>
    panic("fileread");
    80003de8:	00005517          	auipc	a0,0x5
    80003dec:	8b850513          	addi	a0,a0,-1864 # 800086a0 <syscalls+0x2a0>
    80003df0:	00002097          	auipc	ra,0x2
    80003df4:	04e080e7          	jalr	78(ra) # 80005e3e <panic>
    return -1;
    80003df8:	597d                	li	s2,-1
    80003dfa:	b765                	j	80003da2 <fileread+0x60>
      return -1;
    80003dfc:	597d                	li	s2,-1
    80003dfe:	b755                	j	80003da2 <fileread+0x60>
    80003e00:	597d                	li	s2,-1
    80003e02:	b745                	j	80003da2 <fileread+0x60>

0000000080003e04 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e04:	715d                	addi	sp,sp,-80
    80003e06:	e486                	sd	ra,72(sp)
    80003e08:	e0a2                	sd	s0,64(sp)
    80003e0a:	fc26                	sd	s1,56(sp)
    80003e0c:	f84a                	sd	s2,48(sp)
    80003e0e:	f44e                	sd	s3,40(sp)
    80003e10:	f052                	sd	s4,32(sp)
    80003e12:	ec56                	sd	s5,24(sp)
    80003e14:	e85a                	sd	s6,16(sp)
    80003e16:	e45e                	sd	s7,8(sp)
    80003e18:	e062                	sd	s8,0(sp)
    80003e1a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e1c:	00954783          	lbu	a5,9(a0)
    80003e20:	10078663          	beqz	a5,80003f2c <filewrite+0x128>
    80003e24:	892a                	mv	s2,a0
    80003e26:	8aae                	mv	s5,a1
    80003e28:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e2a:	411c                	lw	a5,0(a0)
    80003e2c:	4705                	li	a4,1
    80003e2e:	02e78263          	beq	a5,a4,80003e52 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e32:	470d                	li	a4,3
    80003e34:	02e78663          	beq	a5,a4,80003e60 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e38:	4709                	li	a4,2
    80003e3a:	0ee79163          	bne	a5,a4,80003f1c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e3e:	0ac05d63          	blez	a2,80003ef8 <filewrite+0xf4>
    int i = 0;
    80003e42:	4981                	li	s3,0
    80003e44:	6b05                	lui	s6,0x1
    80003e46:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e4a:	6b85                	lui	s7,0x1
    80003e4c:	c00b8b9b          	addiw	s7,s7,-1024
    80003e50:	a861                	j	80003ee8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e52:	6908                	ld	a0,16(a0)
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	22e080e7          	jalr	558(ra) # 80004082 <pipewrite>
    80003e5c:	8a2a                	mv	s4,a0
    80003e5e:	a045                	j	80003efe <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e60:	02451783          	lh	a5,36(a0)
    80003e64:	03079693          	slli	a3,a5,0x30
    80003e68:	92c1                	srli	a3,a3,0x30
    80003e6a:	4725                	li	a4,9
    80003e6c:	0cd76263          	bltu	a4,a3,80003f30 <filewrite+0x12c>
    80003e70:	0792                	slli	a5,a5,0x4
    80003e72:	00015717          	auipc	a4,0x15
    80003e76:	d6670713          	addi	a4,a4,-666 # 80018bd8 <devsw>
    80003e7a:	97ba                	add	a5,a5,a4
    80003e7c:	679c                	ld	a5,8(a5)
    80003e7e:	cbdd                	beqz	a5,80003f34 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e80:	4505                	li	a0,1
    80003e82:	9782                	jalr	a5
    80003e84:	8a2a                	mv	s4,a0
    80003e86:	a8a5                	j	80003efe <filewrite+0xfa>
    80003e88:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	8b0080e7          	jalr	-1872(ra) # 8000373c <begin_op>
      ilock(f->ip);
    80003e94:	01893503          	ld	a0,24(s2)
    80003e98:	fffff097          	auipc	ra,0xfffff
    80003e9c:	ee2080e7          	jalr	-286(ra) # 80002d7a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ea0:	8762                	mv	a4,s8
    80003ea2:	02092683          	lw	a3,32(s2)
    80003ea6:	01598633          	add	a2,s3,s5
    80003eaa:	4585                	li	a1,1
    80003eac:	01893503          	ld	a0,24(s2)
    80003eb0:	fffff097          	auipc	ra,0xfffff
    80003eb4:	276080e7          	jalr	630(ra) # 80003126 <writei>
    80003eb8:	84aa                	mv	s1,a0
    80003eba:	00a05763          	blez	a0,80003ec8 <filewrite+0xc4>
        f->off += r;
    80003ebe:	02092783          	lw	a5,32(s2)
    80003ec2:	9fa9                	addw	a5,a5,a0
    80003ec4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ec8:	01893503          	ld	a0,24(s2)
    80003ecc:	fffff097          	auipc	ra,0xfffff
    80003ed0:	f70080e7          	jalr	-144(ra) # 80002e3c <iunlock>
      end_op();
    80003ed4:	00000097          	auipc	ra,0x0
    80003ed8:	8e8080e7          	jalr	-1816(ra) # 800037bc <end_op>

      if(r != n1){
    80003edc:	009c1f63          	bne	s8,s1,80003efa <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ee0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ee4:	0149db63          	bge	s3,s4,80003efa <filewrite+0xf6>
      int n1 = n - i;
    80003ee8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003eec:	84be                	mv	s1,a5
    80003eee:	2781                	sext.w	a5,a5
    80003ef0:	f8fb5ce3          	bge	s6,a5,80003e88 <filewrite+0x84>
    80003ef4:	84de                	mv	s1,s7
    80003ef6:	bf49                	j	80003e88 <filewrite+0x84>
    int i = 0;
    80003ef8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003efa:	013a1f63          	bne	s4,s3,80003f18 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003efe:	8552                	mv	a0,s4
    80003f00:	60a6                	ld	ra,72(sp)
    80003f02:	6406                	ld	s0,64(sp)
    80003f04:	74e2                	ld	s1,56(sp)
    80003f06:	7942                	ld	s2,48(sp)
    80003f08:	79a2                	ld	s3,40(sp)
    80003f0a:	7a02                	ld	s4,32(sp)
    80003f0c:	6ae2                	ld	s5,24(sp)
    80003f0e:	6b42                	ld	s6,16(sp)
    80003f10:	6ba2                	ld	s7,8(sp)
    80003f12:	6c02                	ld	s8,0(sp)
    80003f14:	6161                	addi	sp,sp,80
    80003f16:	8082                	ret
    ret = (i == n ? n : -1);
    80003f18:	5a7d                	li	s4,-1
    80003f1a:	b7d5                	j	80003efe <filewrite+0xfa>
    panic("filewrite");
    80003f1c:	00004517          	auipc	a0,0x4
    80003f20:	79450513          	addi	a0,a0,1940 # 800086b0 <syscalls+0x2b0>
    80003f24:	00002097          	auipc	ra,0x2
    80003f28:	f1a080e7          	jalr	-230(ra) # 80005e3e <panic>
    return -1;
    80003f2c:	5a7d                	li	s4,-1
    80003f2e:	bfc1                	j	80003efe <filewrite+0xfa>
      return -1;
    80003f30:	5a7d                	li	s4,-1
    80003f32:	b7f1                	j	80003efe <filewrite+0xfa>
    80003f34:	5a7d                	li	s4,-1
    80003f36:	b7e1                	j	80003efe <filewrite+0xfa>

0000000080003f38 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f38:	7179                	addi	sp,sp,-48
    80003f3a:	f406                	sd	ra,40(sp)
    80003f3c:	f022                	sd	s0,32(sp)
    80003f3e:	ec26                	sd	s1,24(sp)
    80003f40:	e84a                	sd	s2,16(sp)
    80003f42:	e44e                	sd	s3,8(sp)
    80003f44:	e052                	sd	s4,0(sp)
    80003f46:	1800                	addi	s0,sp,48
    80003f48:	84aa                	mv	s1,a0
    80003f4a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f4c:	0005b023          	sd	zero,0(a1)
    80003f50:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	bf8080e7          	jalr	-1032(ra) # 80003b4c <filealloc>
    80003f5c:	e088                	sd	a0,0(s1)
    80003f5e:	c551                	beqz	a0,80003fea <pipealloc+0xb2>
    80003f60:	00000097          	auipc	ra,0x0
    80003f64:	bec080e7          	jalr	-1044(ra) # 80003b4c <filealloc>
    80003f68:	00aa3023          	sd	a0,0(s4)
    80003f6c:	c92d                	beqz	a0,80003fde <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f6e:	ffffc097          	auipc	ra,0xffffc
    80003f72:	1aa080e7          	jalr	426(ra) # 80000118 <kalloc>
    80003f76:	892a                	mv	s2,a0
    80003f78:	c125                	beqz	a0,80003fd8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f7a:	4985                	li	s3,1
    80003f7c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f80:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f84:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f88:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f8c:	00004597          	auipc	a1,0x4
    80003f90:	73458593          	addi	a1,a1,1844 # 800086c0 <syscalls+0x2c0>
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	356080e7          	jalr	854(ra) # 800062ea <initlock>
  (*f0)->type = FD_PIPE;
    80003f9c:	609c                	ld	a5,0(s1)
    80003f9e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fa2:	609c                	ld	a5,0(s1)
    80003fa4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fa8:	609c                	ld	a5,0(s1)
    80003faa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fae:	609c                	ld	a5,0(s1)
    80003fb0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fb4:	000a3783          	ld	a5,0(s4)
    80003fb8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fbc:	000a3783          	ld	a5,0(s4)
    80003fc0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fc4:	000a3783          	ld	a5,0(s4)
    80003fc8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fcc:	000a3783          	ld	a5,0(s4)
    80003fd0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fd4:	4501                	li	a0,0
    80003fd6:	a025                	j	80003ffe <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fd8:	6088                	ld	a0,0(s1)
    80003fda:	e501                	bnez	a0,80003fe2 <pipealloc+0xaa>
    80003fdc:	a039                	j	80003fea <pipealloc+0xb2>
    80003fde:	6088                	ld	a0,0(s1)
    80003fe0:	c51d                	beqz	a0,8000400e <pipealloc+0xd6>
    fileclose(*f0);
    80003fe2:	00000097          	auipc	ra,0x0
    80003fe6:	c26080e7          	jalr	-986(ra) # 80003c08 <fileclose>
  if(*f1)
    80003fea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fee:	557d                	li	a0,-1
  if(*f1)
    80003ff0:	c799                	beqz	a5,80003ffe <pipealloc+0xc6>
    fileclose(*f1);
    80003ff2:	853e                	mv	a0,a5
    80003ff4:	00000097          	auipc	ra,0x0
    80003ff8:	c14080e7          	jalr	-1004(ra) # 80003c08 <fileclose>
  return -1;
    80003ffc:	557d                	li	a0,-1
}
    80003ffe:	70a2                	ld	ra,40(sp)
    80004000:	7402                	ld	s0,32(sp)
    80004002:	64e2                	ld	s1,24(sp)
    80004004:	6942                	ld	s2,16(sp)
    80004006:	69a2                	ld	s3,8(sp)
    80004008:	6a02                	ld	s4,0(sp)
    8000400a:	6145                	addi	sp,sp,48
    8000400c:	8082                	ret
  return -1;
    8000400e:	557d                	li	a0,-1
    80004010:	b7fd                	j	80003ffe <pipealloc+0xc6>

0000000080004012 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004012:	1101                	addi	sp,sp,-32
    80004014:	ec06                	sd	ra,24(sp)
    80004016:	e822                	sd	s0,16(sp)
    80004018:	e426                	sd	s1,8(sp)
    8000401a:	e04a                	sd	s2,0(sp)
    8000401c:	1000                	addi	s0,sp,32
    8000401e:	84aa                	mv	s1,a0
    80004020:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004022:	00002097          	auipc	ra,0x2
    80004026:	358080e7          	jalr	856(ra) # 8000637a <acquire>
  if(writable){
    8000402a:	02090d63          	beqz	s2,80004064 <pipeclose+0x52>
    pi->writeopen = 0;
    8000402e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004032:	21848513          	addi	a0,s1,536
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	6b8080e7          	jalr	1720(ra) # 800016ee <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000403e:	2204b783          	ld	a5,544(s1)
    80004042:	eb95                	bnez	a5,80004076 <pipeclose+0x64>
    release(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00002097          	auipc	ra,0x2
    8000404a:	3e8080e7          	jalr	1000(ra) # 8000642e <release>
    kfree((char*)pi);
    8000404e:	8526                	mv	a0,s1
    80004050:	ffffc097          	auipc	ra,0xffffc
    80004054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004058:	60e2                	ld	ra,24(sp)
    8000405a:	6442                	ld	s0,16(sp)
    8000405c:	64a2                	ld	s1,8(sp)
    8000405e:	6902                	ld	s2,0(sp)
    80004060:	6105                	addi	sp,sp,32
    80004062:	8082                	ret
    pi->readopen = 0;
    80004064:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004068:	21c48513          	addi	a0,s1,540
    8000406c:	ffffd097          	auipc	ra,0xffffd
    80004070:	682080e7          	jalr	1666(ra) # 800016ee <wakeup>
    80004074:	b7e9                	j	8000403e <pipeclose+0x2c>
    release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	3b6080e7          	jalr	950(ra) # 8000642e <release>
}
    80004080:	bfe1                	j	80004058 <pipeclose+0x46>

0000000080004082 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004082:	711d                	addi	sp,sp,-96
    80004084:	ec86                	sd	ra,88(sp)
    80004086:	e8a2                	sd	s0,80(sp)
    80004088:	e4a6                	sd	s1,72(sp)
    8000408a:	e0ca                	sd	s2,64(sp)
    8000408c:	fc4e                	sd	s3,56(sp)
    8000408e:	f852                	sd	s4,48(sp)
    80004090:	f456                	sd	s5,40(sp)
    80004092:	f05a                	sd	s6,32(sp)
    80004094:	ec5e                	sd	s7,24(sp)
    80004096:	e862                	sd	s8,16(sp)
    80004098:	1080                	addi	s0,sp,96
    8000409a:	84aa                	mv	s1,a0
    8000409c:	8aae                	mv	s5,a1
    8000409e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	e94080e7          	jalr	-364(ra) # 80000f34 <myproc>
    800040a8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	2ce080e7          	jalr	718(ra) # 8000637a <acquire>
  while(i < n){
    800040b4:	0b405663          	blez	s4,80004160 <pipewrite+0xde>
  int i = 0;
    800040b8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ba:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040bc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040c0:	21c48b93          	addi	s7,s1,540
    800040c4:	a089                	j	80004106 <pipewrite+0x84>
      release(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	366080e7          	jalr	870(ra) # 8000642e <release>
      return -1;
    800040d0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040d2:	854a                	mv	a0,s2
    800040d4:	60e6                	ld	ra,88(sp)
    800040d6:	6446                	ld	s0,80(sp)
    800040d8:	64a6                	ld	s1,72(sp)
    800040da:	6906                	ld	s2,64(sp)
    800040dc:	79e2                	ld	s3,56(sp)
    800040de:	7a42                	ld	s4,48(sp)
    800040e0:	7aa2                	ld	s5,40(sp)
    800040e2:	7b02                	ld	s6,32(sp)
    800040e4:	6be2                	ld	s7,24(sp)
    800040e6:	6c42                	ld	s8,16(sp)
    800040e8:	6125                	addi	sp,sp,96
    800040ea:	8082                	ret
      wakeup(&pi->nread);
    800040ec:	8562                	mv	a0,s8
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	600080e7          	jalr	1536(ra) # 800016ee <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040f6:	85a6                	mv	a1,s1
    800040f8:	855e                	mv	a0,s7
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	590080e7          	jalr	1424(ra) # 8000168a <sleep>
  while(i < n){
    80004102:	07495063          	bge	s2,s4,80004162 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004106:	2204a783          	lw	a5,544(s1)
    8000410a:	dfd5                	beqz	a5,800040c6 <pipewrite+0x44>
    8000410c:	854e                	mv	a0,s3
    8000410e:	ffffe097          	auipc	ra,0xffffe
    80004112:	824080e7          	jalr	-2012(ra) # 80001932 <killed>
    80004116:	f945                	bnez	a0,800040c6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004118:	2184a783          	lw	a5,536(s1)
    8000411c:	21c4a703          	lw	a4,540(s1)
    80004120:	2007879b          	addiw	a5,a5,512
    80004124:	fcf704e3          	beq	a4,a5,800040ec <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004128:	4685                	li	a3,1
    8000412a:	01590633          	add	a2,s2,s5
    8000412e:	faf40593          	addi	a1,s0,-81
    80004132:	0509b503          	ld	a0,80(s3)
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	a64080e7          	jalr	-1436(ra) # 80000b9a <copyin>
    8000413e:	03650263          	beq	a0,s6,80004162 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004142:	21c4a783          	lw	a5,540(s1)
    80004146:	0017871b          	addiw	a4,a5,1
    8000414a:	20e4ae23          	sw	a4,540(s1)
    8000414e:	1ff7f793          	andi	a5,a5,511
    80004152:	97a6                	add	a5,a5,s1
    80004154:	faf44703          	lbu	a4,-81(s0)
    80004158:	00e78c23          	sb	a4,24(a5)
      i++;
    8000415c:	2905                	addiw	s2,s2,1
    8000415e:	b755                	j	80004102 <pipewrite+0x80>
  int i = 0;
    80004160:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004162:	21848513          	addi	a0,s1,536
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	588080e7          	jalr	1416(ra) # 800016ee <wakeup>
  release(&pi->lock);
    8000416e:	8526                	mv	a0,s1
    80004170:	00002097          	auipc	ra,0x2
    80004174:	2be080e7          	jalr	702(ra) # 8000642e <release>
  return i;
    80004178:	bfa9                	j	800040d2 <pipewrite+0x50>

000000008000417a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000417a:	715d                	addi	sp,sp,-80
    8000417c:	e486                	sd	ra,72(sp)
    8000417e:	e0a2                	sd	s0,64(sp)
    80004180:	fc26                	sd	s1,56(sp)
    80004182:	f84a                	sd	s2,48(sp)
    80004184:	f44e                	sd	s3,40(sp)
    80004186:	f052                	sd	s4,32(sp)
    80004188:	ec56                	sd	s5,24(sp)
    8000418a:	e85a                	sd	s6,16(sp)
    8000418c:	0880                	addi	s0,sp,80
    8000418e:	84aa                	mv	s1,a0
    80004190:	892e                	mv	s2,a1
    80004192:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	da0080e7          	jalr	-608(ra) # 80000f34 <myproc>
    8000419c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	1da080e7          	jalr	474(ra) # 8000637a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a8:	2184a703          	lw	a4,536(s1)
    800041ac:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b4:	02f71763          	bne	a4,a5,800041e2 <piperead+0x68>
    800041b8:	2244a783          	lw	a5,548(s1)
    800041bc:	c39d                	beqz	a5,800041e2 <piperead+0x68>
    if(killed(pr)){
    800041be:	8552                	mv	a0,s4
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	772080e7          	jalr	1906(ra) # 80001932 <killed>
    800041c8:	e941                	bnez	a0,80004258 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ca:	85a6                	mv	a1,s1
    800041cc:	854e                	mv	a0,s3
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	4bc080e7          	jalr	1212(ra) # 8000168a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d6:	2184a703          	lw	a4,536(s1)
    800041da:	21c4a783          	lw	a5,540(s1)
    800041de:	fcf70de3          	beq	a4,a5,800041b8 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041e4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e6:	05505363          	blez	s5,8000422c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800041ea:	2184a783          	lw	a5,536(s1)
    800041ee:	21c4a703          	lw	a4,540(s1)
    800041f2:	02f70d63          	beq	a4,a5,8000422c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041f6:	0017871b          	addiw	a4,a5,1
    800041fa:	20e4ac23          	sw	a4,536(s1)
    800041fe:	1ff7f793          	andi	a5,a5,511
    80004202:	97a6                	add	a5,a5,s1
    80004204:	0187c783          	lbu	a5,24(a5)
    80004208:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000420c:	4685                	li	a3,1
    8000420e:	fbf40613          	addi	a2,s0,-65
    80004212:	85ca                	mv	a1,s2
    80004214:	050a3503          	ld	a0,80(s4)
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	8f6080e7          	jalr	-1802(ra) # 80000b0e <copyout>
    80004220:	01650663          	beq	a0,s6,8000422c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004224:	2985                	addiw	s3,s3,1
    80004226:	0905                	addi	s2,s2,1
    80004228:	fd3a91e3          	bne	s5,s3,800041ea <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000422c:	21c48513          	addi	a0,s1,540
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	4be080e7          	jalr	1214(ra) # 800016ee <wakeup>
  release(&pi->lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	1f4080e7          	jalr	500(ra) # 8000642e <release>
  return i;
}
    80004242:	854e                	mv	a0,s3
    80004244:	60a6                	ld	ra,72(sp)
    80004246:	6406                	ld	s0,64(sp)
    80004248:	74e2                	ld	s1,56(sp)
    8000424a:	7942                	ld	s2,48(sp)
    8000424c:	79a2                	ld	s3,40(sp)
    8000424e:	7a02                	ld	s4,32(sp)
    80004250:	6ae2                	ld	s5,24(sp)
    80004252:	6b42                	ld	s6,16(sp)
    80004254:	6161                	addi	sp,sp,80
    80004256:	8082                	ret
      release(&pi->lock);
    80004258:	8526                	mv	a0,s1
    8000425a:	00002097          	auipc	ra,0x2
    8000425e:	1d4080e7          	jalr	468(ra) # 8000642e <release>
      return -1;
    80004262:	59fd                	li	s3,-1
    80004264:	bff9                	j	80004242 <piperead+0xc8>

0000000080004266 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004266:	1141                	addi	sp,sp,-16
    80004268:	e422                	sd	s0,8(sp)
    8000426a:	0800                	addi	s0,sp,16
    8000426c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000426e:	8905                	andi	a0,a0,1
    80004270:	c111                	beqz	a0,80004274 <flags2perm+0xe>
      perm = PTE_X;
    80004272:	4521                	li	a0,8
    if(flags & 0x2)
    80004274:	8b89                	andi	a5,a5,2
    80004276:	c399                	beqz	a5,8000427c <flags2perm+0x16>
      perm |= PTE_W;
    80004278:	00456513          	ori	a0,a0,4
    return perm;
}
    8000427c:	6422                	ld	s0,8(sp)
    8000427e:	0141                	addi	sp,sp,16
    80004280:	8082                	ret

0000000080004282 <exec>:

int
exec(char *path, char **argv)
{
    80004282:	de010113          	addi	sp,sp,-544
    80004286:	20113c23          	sd	ra,536(sp)
    8000428a:	20813823          	sd	s0,528(sp)
    8000428e:	20913423          	sd	s1,520(sp)
    80004292:	21213023          	sd	s2,512(sp)
    80004296:	ffce                	sd	s3,504(sp)
    80004298:	fbd2                	sd	s4,496(sp)
    8000429a:	f7d6                	sd	s5,488(sp)
    8000429c:	f3da                	sd	s6,480(sp)
    8000429e:	efde                	sd	s7,472(sp)
    800042a0:	ebe2                	sd	s8,464(sp)
    800042a2:	e7e6                	sd	s9,456(sp)
    800042a4:	e3ea                	sd	s10,448(sp)
    800042a6:	ff6e                	sd	s11,440(sp)
    800042a8:	1400                	addi	s0,sp,544
    800042aa:	892a                	mv	s2,a0
    800042ac:	dea43423          	sd	a0,-536(s0)
    800042b0:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	c80080e7          	jalr	-896(ra) # 80000f34 <myproc>
    800042bc:	84aa                	mv	s1,a0

  begin_op();
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	47e080e7          	jalr	1150(ra) # 8000373c <begin_op>

  if((ip = namei(path)) == 0){
    800042c6:	854a                	mv	a0,s2
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	258080e7          	jalr	600(ra) # 80003520 <namei>
    800042d0:	c93d                	beqz	a0,80004346 <exec+0xc4>
    800042d2:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	aa6080e7          	jalr	-1370(ra) # 80002d7a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042dc:	04000713          	li	a4,64
    800042e0:	4681                	li	a3,0
    800042e2:	e5040613          	addi	a2,s0,-432
    800042e6:	4581                	li	a1,0
    800042e8:	8556                	mv	a0,s5
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	d44080e7          	jalr	-700(ra) # 8000302e <readi>
    800042f2:	04000793          	li	a5,64
    800042f6:	00f51a63          	bne	a0,a5,8000430a <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042fa:	e5042703          	lw	a4,-432(s0)
    800042fe:	464c47b7          	lui	a5,0x464c4
    80004302:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004306:	04f70663          	beq	a4,a5,80004352 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000430a:	8556                	mv	a0,s5
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	cd0080e7          	jalr	-816(ra) # 80002fdc <iunlockput>
    end_op();
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	4a8080e7          	jalr	1192(ra) # 800037bc <end_op>
  }
  return -1;
    8000431c:	557d                	li	a0,-1
}
    8000431e:	21813083          	ld	ra,536(sp)
    80004322:	21013403          	ld	s0,528(sp)
    80004326:	20813483          	ld	s1,520(sp)
    8000432a:	20013903          	ld	s2,512(sp)
    8000432e:	79fe                	ld	s3,504(sp)
    80004330:	7a5e                	ld	s4,496(sp)
    80004332:	7abe                	ld	s5,488(sp)
    80004334:	7b1e                	ld	s6,480(sp)
    80004336:	6bfe                	ld	s7,472(sp)
    80004338:	6c5e                	ld	s8,464(sp)
    8000433a:	6cbe                	ld	s9,456(sp)
    8000433c:	6d1e                	ld	s10,448(sp)
    8000433e:	7dfa                	ld	s11,440(sp)
    80004340:	22010113          	addi	sp,sp,544
    80004344:	8082                	ret
    end_op();
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	476080e7          	jalr	1142(ra) # 800037bc <end_op>
    return -1;
    8000434e:	557d                	li	a0,-1
    80004350:	b7f9                	j	8000431e <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004352:	8526                	mv	a0,s1
    80004354:	ffffd097          	auipc	ra,0xffffd
    80004358:	ca4080e7          	jalr	-860(ra) # 80000ff8 <proc_pagetable>
    8000435c:	8b2a                	mv	s6,a0
    8000435e:	d555                	beqz	a0,8000430a <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004360:	e7042783          	lw	a5,-400(s0)
    80004364:	e8845703          	lhu	a4,-376(s0)
    80004368:	c735                	beqz	a4,800043d4 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000436a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000436c:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004370:	6a05                	lui	s4,0x1
    80004372:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004376:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000437a:	6d85                	lui	s11,0x1
    8000437c:	7d7d                	lui	s10,0xfffff
    8000437e:	aca1                	j	800045d6 <exec+0x354>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004380:	00004517          	auipc	a0,0x4
    80004384:	34850513          	addi	a0,a0,840 # 800086c8 <syscalls+0x2c8>
    80004388:	00002097          	auipc	ra,0x2
    8000438c:	ab6080e7          	jalr	-1354(ra) # 80005e3e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004390:	874a                	mv	a4,s2
    80004392:	009c86bb          	addw	a3,s9,s1
    80004396:	4581                	li	a1,0
    80004398:	8556                	mv	a0,s5
    8000439a:	fffff097          	auipc	ra,0xfffff
    8000439e:	c94080e7          	jalr	-876(ra) # 8000302e <readi>
    800043a2:	2501                	sext.w	a0,a0
    800043a4:	1ca91663          	bne	s2,a0,80004570 <exec+0x2ee>
  for(i = 0; i < sz; i += PGSIZE){
    800043a8:	009d84bb          	addw	s1,s11,s1
    800043ac:	013d09bb          	addw	s3,s10,s3
    800043b0:	2174f363          	bgeu	s1,s7,800045b6 <exec+0x334>
    pa = walkaddr(pagetable, va + i);
    800043b4:	02049593          	slli	a1,s1,0x20
    800043b8:	9181                	srli	a1,a1,0x20
    800043ba:	95e2                	add	a1,a1,s8
    800043bc:	855a                	mv	a0,s6
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	144080e7          	jalr	324(ra) # 80000502 <walkaddr>
    800043c6:	862a                	mv	a2,a0
    if(pa == 0)
    800043c8:	dd45                	beqz	a0,80004380 <exec+0xfe>
      n = PGSIZE;
    800043ca:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800043cc:	fd49f2e3          	bgeu	s3,s4,80004390 <exec+0x10e>
      n = sz - i;
    800043d0:	894e                	mv	s2,s3
    800043d2:	bf7d                	j	80004390 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043d4:	4901                	li	s2,0
  iunlockput(ip);
    800043d6:	8556                	mv	a0,s5
    800043d8:	fffff097          	auipc	ra,0xfffff
    800043dc:	c04080e7          	jalr	-1020(ra) # 80002fdc <iunlockput>
  end_op();
    800043e0:	fffff097          	auipc	ra,0xfffff
    800043e4:	3dc080e7          	jalr	988(ra) # 800037bc <end_op>
  p = myproc();
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	b4c080e7          	jalr	-1204(ra) # 80000f34 <myproc>
    800043f0:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800043f2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043f6:	6785                	lui	a5,0x1
    800043f8:	17fd                	addi	a5,a5,-1
    800043fa:	993e                	add	s2,s2,a5
    800043fc:	77fd                	lui	a5,0xfffff
    800043fe:	00f977b3          	and	a5,s2,a5
    80004402:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004406:	4691                	li	a3,4
    80004408:	6609                	lui	a2,0x2
    8000440a:	963e                	add	a2,a2,a5
    8000440c:	85be                	mv	a1,a5
    8000440e:	855a                	mv	a0,s6
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	4a6080e7          	jalr	1190(ra) # 800008b6 <uvmalloc>
    80004418:	8c2a                	mv	s8,a0
  ip = 0;
    8000441a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000441c:	14050a63          	beqz	a0,80004570 <exec+0x2ee>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004420:	75f9                	lui	a1,0xffffe
    80004422:	95aa                	add	a1,a1,a0
    80004424:	855a                	mv	a0,s6
    80004426:	ffffc097          	auipc	ra,0xffffc
    8000442a:	6b6080e7          	jalr	1718(ra) # 80000adc <uvmclear>
  stackbase = sp - PGSIZE;
    8000442e:	7afd                	lui	s5,0xfffff
    80004430:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004432:	df043783          	ld	a5,-528(s0)
    80004436:	6388                	ld	a0,0(a5)
    80004438:	c925                	beqz	a0,800044a8 <exec+0x226>
    8000443a:	e9040993          	addi	s3,s0,-368
    8000443e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004442:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004444:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	eae080e7          	jalr	-338(ra) # 800002f4 <strlen>
    8000444e:	0015079b          	addiw	a5,a0,1
    80004452:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004456:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000445a:	15596263          	bltu	s2,s5,8000459e <exec+0x31c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000445e:	df043d83          	ld	s11,-528(s0)
    80004462:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004466:	8552                	mv	a0,s4
    80004468:	ffffc097          	auipc	ra,0xffffc
    8000446c:	e8c080e7          	jalr	-372(ra) # 800002f4 <strlen>
    80004470:	0015069b          	addiw	a3,a0,1
    80004474:	8652                	mv	a2,s4
    80004476:	85ca                	mv	a1,s2
    80004478:	855a                	mv	a0,s6
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	694080e7          	jalr	1684(ra) # 80000b0e <copyout>
    80004482:	12054263          	bltz	a0,800045a6 <exec+0x324>
    ustack[argc] = sp;
    80004486:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000448a:	0485                	addi	s1,s1,1
    8000448c:	008d8793          	addi	a5,s11,8
    80004490:	def43823          	sd	a5,-528(s0)
    80004494:	008db503          	ld	a0,8(s11)
    80004498:	c911                	beqz	a0,800044ac <exec+0x22a>
    if(argc >= MAXARG)
    8000449a:	09a1                	addi	s3,s3,8
    8000449c:	fb3c95e3          	bne	s9,s3,80004446 <exec+0x1c4>
  sz = sz1;
    800044a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a4:	4a81                	li	s5,0
    800044a6:	a0e9                	j	80004570 <exec+0x2ee>
  sp = sz;
    800044a8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800044aa:	4481                	li	s1,0
  ustack[argc] = 0;
    800044ac:	00349793          	slli	a5,s1,0x3
    800044b0:	f9040713          	addi	a4,s0,-112
    800044b4:	97ba                	add	a5,a5,a4
    800044b6:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdcf50>
  sp -= (argc+1) * sizeof(uint64);
    800044ba:	00148693          	addi	a3,s1,1
    800044be:	068e                	slli	a3,a3,0x3
    800044c0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044c4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044c8:	01597663          	bgeu	s2,s5,800044d4 <exec+0x252>
  sz = sz1;
    800044cc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044d0:	4a81                	li	s5,0
    800044d2:	a879                	j	80004570 <exec+0x2ee>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044d4:	e9040613          	addi	a2,s0,-368
    800044d8:	85ca                	mv	a1,s2
    800044da:	855a                	mv	a0,s6
    800044dc:	ffffc097          	auipc	ra,0xffffc
    800044e0:	632080e7          	jalr	1586(ra) # 80000b0e <copyout>
    800044e4:	0c054563          	bltz	a0,800045ae <exec+0x32c>
  p->trapframe->a1 = sp;
    800044e8:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800044ec:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044f0:	de843783          	ld	a5,-536(s0)
    800044f4:	0007c703          	lbu	a4,0(a5)
    800044f8:	cf11                	beqz	a4,80004514 <exec+0x292>
    800044fa:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044fc:	02f00693          	li	a3,47
    80004500:	a039                	j	8000450e <exec+0x28c>
      last = s+1;
    80004502:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004506:	0785                	addi	a5,a5,1
    80004508:	fff7c703          	lbu	a4,-1(a5)
    8000450c:	c701                	beqz	a4,80004514 <exec+0x292>
    if(*s == '/')
    8000450e:	fed71ce3          	bne	a4,a3,80004506 <exec+0x284>
    80004512:	bfc5                	j	80004502 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004514:	4641                	li	a2,16
    80004516:	de843583          	ld	a1,-536(s0)
    8000451a:	160b8513          	addi	a0,s7,352
    8000451e:	ffffc097          	auipc	ra,0xffffc
    80004522:	da4080e7          	jalr	-604(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004526:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000452a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000452e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004532:	058bb783          	ld	a5,88(s7)
    80004536:	e6843703          	ld	a4,-408(s0)
    8000453a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000453c:	058bb783          	ld	a5,88(s7)
    80004540:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004544:	85ea                	mv	a1,s10
    80004546:	ffffd097          	auipc	ra,0xffffd
    8000454a:	ba8080e7          	jalr	-1112(ra) # 800010ee <proc_freepagetable>
  if (p->pid == 1) vmprint(p->pagetable);
    8000454e:	030ba703          	lw	a4,48(s7)
    80004552:	4785                	li	a5,1
    80004554:	00f70563          	beq	a4,a5,8000455e <exec+0x2dc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004558:	0004851b          	sext.w	a0,s1
    8000455c:	b3c9                	j	8000431e <exec+0x9c>
  if (p->pid == 1) vmprint(p->pagetable);
    8000455e:	050bb503          	ld	a0,80(s7)
    80004562:	ffffd097          	auipc	ra,0xffffd
    80004566:	82c080e7          	jalr	-2004(ra) # 80000d8e <vmprint>
    8000456a:	b7fd                	j	80004558 <exec+0x2d6>
    8000456c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004570:	df843583          	ld	a1,-520(s0)
    80004574:	855a                	mv	a0,s6
    80004576:	ffffd097          	auipc	ra,0xffffd
    8000457a:	b78080e7          	jalr	-1160(ra) # 800010ee <proc_freepagetable>
  if(ip){
    8000457e:	d80a96e3          	bnez	s5,8000430a <exec+0x88>
  return -1;
    80004582:	557d                	li	a0,-1
    80004584:	bb69                	j	8000431e <exec+0x9c>
    80004586:	df243c23          	sd	s2,-520(s0)
    8000458a:	b7dd                	j	80004570 <exec+0x2ee>
    8000458c:	df243c23          	sd	s2,-520(s0)
    80004590:	b7c5                	j	80004570 <exec+0x2ee>
    80004592:	df243c23          	sd	s2,-520(s0)
    80004596:	bfe9                	j	80004570 <exec+0x2ee>
    80004598:	df243c23          	sd	s2,-520(s0)
    8000459c:	bfd1                	j	80004570 <exec+0x2ee>
  sz = sz1;
    8000459e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045a2:	4a81                	li	s5,0
    800045a4:	b7f1                	j	80004570 <exec+0x2ee>
  sz = sz1;
    800045a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045aa:	4a81                	li	s5,0
    800045ac:	b7d1                	j	80004570 <exec+0x2ee>
  sz = sz1;
    800045ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045b2:	4a81                	li	s5,0
    800045b4:	bf75                	j	80004570 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045b6:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ba:	e0843783          	ld	a5,-504(s0)
    800045be:	0017869b          	addiw	a3,a5,1
    800045c2:	e0d43423          	sd	a3,-504(s0)
    800045c6:	e0043783          	ld	a5,-512(s0)
    800045ca:	0387879b          	addiw	a5,a5,56
    800045ce:	e8845703          	lhu	a4,-376(s0)
    800045d2:	e0e6d2e3          	bge	a3,a4,800043d6 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045d6:	2781                	sext.w	a5,a5
    800045d8:	e0f43023          	sd	a5,-512(s0)
    800045dc:	03800713          	li	a4,56
    800045e0:	86be                	mv	a3,a5
    800045e2:	e1840613          	addi	a2,s0,-488
    800045e6:	4581                	li	a1,0
    800045e8:	8556                	mv	a0,s5
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	a44080e7          	jalr	-1468(ra) # 8000302e <readi>
    800045f2:	03800793          	li	a5,56
    800045f6:	f6f51be3          	bne	a0,a5,8000456c <exec+0x2ea>
    if(ph.type != ELF_PROG_LOAD)
    800045fa:	e1842783          	lw	a5,-488(s0)
    800045fe:	4705                	li	a4,1
    80004600:	fae79de3          	bne	a5,a4,800045ba <exec+0x338>
    if(ph.memsz < ph.filesz)
    80004604:	e4043483          	ld	s1,-448(s0)
    80004608:	e3843783          	ld	a5,-456(s0)
    8000460c:	f6f4ede3          	bltu	s1,a5,80004586 <exec+0x304>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004610:	e2843783          	ld	a5,-472(s0)
    80004614:	94be                	add	s1,s1,a5
    80004616:	f6f4ebe3          	bltu	s1,a5,8000458c <exec+0x30a>
    if(ph.vaddr % PGSIZE != 0)
    8000461a:	de043703          	ld	a4,-544(s0)
    8000461e:	8ff9                	and	a5,a5,a4
    80004620:	fbad                	bnez	a5,80004592 <exec+0x310>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004622:	e1c42503          	lw	a0,-484(s0)
    80004626:	00000097          	auipc	ra,0x0
    8000462a:	c40080e7          	jalr	-960(ra) # 80004266 <flags2perm>
    8000462e:	86aa                	mv	a3,a0
    80004630:	8626                	mv	a2,s1
    80004632:	85ca                	mv	a1,s2
    80004634:	855a                	mv	a0,s6
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	280080e7          	jalr	640(ra) # 800008b6 <uvmalloc>
    8000463e:	dea43c23          	sd	a0,-520(s0)
    80004642:	d939                	beqz	a0,80004598 <exec+0x316>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004644:	e2843c03          	ld	s8,-472(s0)
    80004648:	e2042c83          	lw	s9,-480(s0)
    8000464c:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004650:	f60b83e3          	beqz	s7,800045b6 <exec+0x334>
    80004654:	89de                	mv	s3,s7
    80004656:	4481                	li	s1,0
    80004658:	bbb1                	j	800043b4 <exec+0x132>

000000008000465a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000465a:	7179                	addi	sp,sp,-48
    8000465c:	f406                	sd	ra,40(sp)
    8000465e:	f022                	sd	s0,32(sp)
    80004660:	ec26                	sd	s1,24(sp)
    80004662:	e84a                	sd	s2,16(sp)
    80004664:	1800                	addi	s0,sp,48
    80004666:	892e                	mv	s2,a1
    80004668:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000466a:	fdc40593          	addi	a1,s0,-36
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	a88080e7          	jalr	-1400(ra) # 800020f6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004676:	fdc42703          	lw	a4,-36(s0)
    8000467a:	47bd                	li	a5,15
    8000467c:	02e7eb63          	bltu	a5,a4,800046b2 <argfd+0x58>
    80004680:	ffffd097          	auipc	ra,0xffffd
    80004684:	8b4080e7          	jalr	-1868(ra) # 80000f34 <myproc>
    80004688:	fdc42703          	lw	a4,-36(s0)
    8000468c:	01a70793          	addi	a5,a4,26
    80004690:	078e                	slli	a5,a5,0x3
    80004692:	953e                	add	a0,a0,a5
    80004694:	651c                	ld	a5,8(a0)
    80004696:	c385                	beqz	a5,800046b6 <argfd+0x5c>
    return -1;
  if(pfd)
    80004698:	00090463          	beqz	s2,800046a0 <argfd+0x46>
    *pfd = fd;
    8000469c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046a0:	4501                	li	a0,0
  if(pf)
    800046a2:	c091                	beqz	s1,800046a6 <argfd+0x4c>
    *pf = f;
    800046a4:	e09c                	sd	a5,0(s1)
}
    800046a6:	70a2                	ld	ra,40(sp)
    800046a8:	7402                	ld	s0,32(sp)
    800046aa:	64e2                	ld	s1,24(sp)
    800046ac:	6942                	ld	s2,16(sp)
    800046ae:	6145                	addi	sp,sp,48
    800046b0:	8082                	ret
    return -1;
    800046b2:	557d                	li	a0,-1
    800046b4:	bfcd                	j	800046a6 <argfd+0x4c>
    800046b6:	557d                	li	a0,-1
    800046b8:	b7fd                	j	800046a6 <argfd+0x4c>

00000000800046ba <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046ba:	1101                	addi	sp,sp,-32
    800046bc:	ec06                	sd	ra,24(sp)
    800046be:	e822                	sd	s0,16(sp)
    800046c0:	e426                	sd	s1,8(sp)
    800046c2:	1000                	addi	s0,sp,32
    800046c4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046c6:	ffffd097          	auipc	ra,0xffffd
    800046ca:	86e080e7          	jalr	-1938(ra) # 80000f34 <myproc>
    800046ce:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046d0:	0d850793          	addi	a5,a0,216
    800046d4:	4501                	li	a0,0
    800046d6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046d8:	6398                	ld	a4,0(a5)
    800046da:	cb19                	beqz	a4,800046f0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046dc:	2505                	addiw	a0,a0,1
    800046de:	07a1                	addi	a5,a5,8
    800046e0:	fed51ce3          	bne	a0,a3,800046d8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046e4:	557d                	li	a0,-1
}
    800046e6:	60e2                	ld	ra,24(sp)
    800046e8:	6442                	ld	s0,16(sp)
    800046ea:	64a2                	ld	s1,8(sp)
    800046ec:	6105                	addi	sp,sp,32
    800046ee:	8082                	ret
      p->ofile[fd] = f;
    800046f0:	01a50793          	addi	a5,a0,26
    800046f4:	078e                	slli	a5,a5,0x3
    800046f6:	963e                	add	a2,a2,a5
    800046f8:	e604                	sd	s1,8(a2)
      return fd;
    800046fa:	b7f5                	j	800046e6 <fdalloc+0x2c>

00000000800046fc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046fc:	715d                	addi	sp,sp,-80
    800046fe:	e486                	sd	ra,72(sp)
    80004700:	e0a2                	sd	s0,64(sp)
    80004702:	fc26                	sd	s1,56(sp)
    80004704:	f84a                	sd	s2,48(sp)
    80004706:	f44e                	sd	s3,40(sp)
    80004708:	f052                	sd	s4,32(sp)
    8000470a:	ec56                	sd	s5,24(sp)
    8000470c:	e85a                	sd	s6,16(sp)
    8000470e:	0880                	addi	s0,sp,80
    80004710:	8b2e                	mv	s6,a1
    80004712:	89b2                	mv	s3,a2
    80004714:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004716:	fb040593          	addi	a1,s0,-80
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	e24080e7          	jalr	-476(ra) # 8000353e <nameiparent>
    80004722:	84aa                	mv	s1,a0
    80004724:	14050f63          	beqz	a0,80004882 <create+0x186>
    return 0;

  ilock(dp);
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	652080e7          	jalr	1618(ra) # 80002d7a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004730:	4601                	li	a2,0
    80004732:	fb040593          	addi	a1,s0,-80
    80004736:	8526                	mv	a0,s1
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	b26080e7          	jalr	-1242(ra) # 8000325e <dirlookup>
    80004740:	8aaa                	mv	s5,a0
    80004742:	c931                	beqz	a0,80004796 <create+0x9a>
    iunlockput(dp);
    80004744:	8526                	mv	a0,s1
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	896080e7          	jalr	-1898(ra) # 80002fdc <iunlockput>
    ilock(ip);
    8000474e:	8556                	mv	a0,s5
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	62a080e7          	jalr	1578(ra) # 80002d7a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004758:	000b059b          	sext.w	a1,s6
    8000475c:	4789                	li	a5,2
    8000475e:	02f59563          	bne	a1,a5,80004788 <create+0x8c>
    80004762:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd094>
    80004766:	37f9                	addiw	a5,a5,-2
    80004768:	17c2                	slli	a5,a5,0x30
    8000476a:	93c1                	srli	a5,a5,0x30
    8000476c:	4705                	li	a4,1
    8000476e:	00f76d63          	bltu	a4,a5,80004788 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004772:	8556                	mv	a0,s5
    80004774:	60a6                	ld	ra,72(sp)
    80004776:	6406                	ld	s0,64(sp)
    80004778:	74e2                	ld	s1,56(sp)
    8000477a:	7942                	ld	s2,48(sp)
    8000477c:	79a2                	ld	s3,40(sp)
    8000477e:	7a02                	ld	s4,32(sp)
    80004780:	6ae2                	ld	s5,24(sp)
    80004782:	6b42                	ld	s6,16(sp)
    80004784:	6161                	addi	sp,sp,80
    80004786:	8082                	ret
    iunlockput(ip);
    80004788:	8556                	mv	a0,s5
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	852080e7          	jalr	-1966(ra) # 80002fdc <iunlockput>
    return 0;
    80004792:	4a81                	li	s5,0
    80004794:	bff9                	j	80004772 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004796:	85da                	mv	a1,s6
    80004798:	4088                	lw	a0,0(s1)
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	444080e7          	jalr	1092(ra) # 80002bde <ialloc>
    800047a2:	8a2a                	mv	s4,a0
    800047a4:	c539                	beqz	a0,800047f2 <create+0xf6>
  ilock(ip);
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	5d4080e7          	jalr	1492(ra) # 80002d7a <ilock>
  ip->major = major;
    800047ae:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047b2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047b6:	4905                	li	s2,1
    800047b8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047bc:	8552                	mv	a0,s4
    800047be:	ffffe097          	auipc	ra,0xffffe
    800047c2:	4f2080e7          	jalr	1266(ra) # 80002cb0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047c6:	000b059b          	sext.w	a1,s6
    800047ca:	03258b63          	beq	a1,s2,80004800 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ce:	004a2603          	lw	a2,4(s4)
    800047d2:	fb040593          	addi	a1,s0,-80
    800047d6:	8526                	mv	a0,s1
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	c96080e7          	jalr	-874(ra) # 8000346e <dirlink>
    800047e0:	06054f63          	bltz	a0,8000485e <create+0x162>
  iunlockput(dp);
    800047e4:	8526                	mv	a0,s1
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	7f6080e7          	jalr	2038(ra) # 80002fdc <iunlockput>
  return ip;
    800047ee:	8ad2                	mv	s5,s4
    800047f0:	b749                	j	80004772 <create+0x76>
    iunlockput(dp);
    800047f2:	8526                	mv	a0,s1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	7e8080e7          	jalr	2024(ra) # 80002fdc <iunlockput>
    return 0;
    800047fc:	8ad2                	mv	s5,s4
    800047fe:	bf95                	j	80004772 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004800:	004a2603          	lw	a2,4(s4)
    80004804:	00004597          	auipc	a1,0x4
    80004808:	ee458593          	addi	a1,a1,-284 # 800086e8 <syscalls+0x2e8>
    8000480c:	8552                	mv	a0,s4
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	c60080e7          	jalr	-928(ra) # 8000346e <dirlink>
    80004816:	04054463          	bltz	a0,8000485e <create+0x162>
    8000481a:	40d0                	lw	a2,4(s1)
    8000481c:	00004597          	auipc	a1,0x4
    80004820:	ed458593          	addi	a1,a1,-300 # 800086f0 <syscalls+0x2f0>
    80004824:	8552                	mv	a0,s4
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	c48080e7          	jalr	-952(ra) # 8000346e <dirlink>
    8000482e:	02054863          	bltz	a0,8000485e <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004832:	004a2603          	lw	a2,4(s4)
    80004836:	fb040593          	addi	a1,s0,-80
    8000483a:	8526                	mv	a0,s1
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	c32080e7          	jalr	-974(ra) # 8000346e <dirlink>
    80004844:	00054d63          	bltz	a0,8000485e <create+0x162>
    dp->nlink++;  // for ".."
    80004848:	04a4d783          	lhu	a5,74(s1)
    8000484c:	2785                	addiw	a5,a5,1
    8000484e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004852:	8526                	mv	a0,s1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	45c080e7          	jalr	1116(ra) # 80002cb0 <iupdate>
    8000485c:	b761                	j	800047e4 <create+0xe8>
  ip->nlink = 0;
    8000485e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004862:	8552                	mv	a0,s4
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	44c080e7          	jalr	1100(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    8000486c:	8552                	mv	a0,s4
    8000486e:	ffffe097          	auipc	ra,0xffffe
    80004872:	76e080e7          	jalr	1902(ra) # 80002fdc <iunlockput>
  iunlockput(dp);
    80004876:	8526                	mv	a0,s1
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	764080e7          	jalr	1892(ra) # 80002fdc <iunlockput>
  return 0;
    80004880:	bdcd                	j	80004772 <create+0x76>
    return 0;
    80004882:	8aaa                	mv	s5,a0
    80004884:	b5fd                	j	80004772 <create+0x76>

0000000080004886 <sys_dup>:
{
    80004886:	7179                	addi	sp,sp,-48
    80004888:	f406                	sd	ra,40(sp)
    8000488a:	f022                	sd	s0,32(sp)
    8000488c:	ec26                	sd	s1,24(sp)
    8000488e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004890:	fd840613          	addi	a2,s0,-40
    80004894:	4581                	li	a1,0
    80004896:	4501                	li	a0,0
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	dc2080e7          	jalr	-574(ra) # 8000465a <argfd>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048a2:	02054363          	bltz	a0,800048c8 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048a6:	fd843503          	ld	a0,-40(s0)
    800048aa:	00000097          	auipc	ra,0x0
    800048ae:	e10080e7          	jalr	-496(ra) # 800046ba <fdalloc>
    800048b2:	84aa                	mv	s1,a0
    return -1;
    800048b4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048b6:	00054963          	bltz	a0,800048c8 <sys_dup+0x42>
  filedup(f);
    800048ba:	fd843503          	ld	a0,-40(s0)
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	2f8080e7          	jalr	760(ra) # 80003bb6 <filedup>
  return fd;
    800048c6:	87a6                	mv	a5,s1
}
    800048c8:	853e                	mv	a0,a5
    800048ca:	70a2                	ld	ra,40(sp)
    800048cc:	7402                	ld	s0,32(sp)
    800048ce:	64e2                	ld	s1,24(sp)
    800048d0:	6145                	addi	sp,sp,48
    800048d2:	8082                	ret

00000000800048d4 <sys_read>:
{
    800048d4:	7179                	addi	sp,sp,-48
    800048d6:	f406                	sd	ra,40(sp)
    800048d8:	f022                	sd	s0,32(sp)
    800048da:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048dc:	fd840593          	addi	a1,s0,-40
    800048e0:	4505                	li	a0,1
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	834080e7          	jalr	-1996(ra) # 80002116 <argaddr>
  argint(2, &n);
    800048ea:	fe440593          	addi	a1,s0,-28
    800048ee:	4509                	li	a0,2
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	806080e7          	jalr	-2042(ra) # 800020f6 <argint>
  if(argfd(0, 0, &f) < 0)
    800048f8:	fe840613          	addi	a2,s0,-24
    800048fc:	4581                	li	a1,0
    800048fe:	4501                	li	a0,0
    80004900:	00000097          	auipc	ra,0x0
    80004904:	d5a080e7          	jalr	-678(ra) # 8000465a <argfd>
    80004908:	87aa                	mv	a5,a0
    return -1;
    8000490a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000490c:	0007cc63          	bltz	a5,80004924 <sys_read+0x50>
  return fileread(f, p, n);
    80004910:	fe442603          	lw	a2,-28(s0)
    80004914:	fd843583          	ld	a1,-40(s0)
    80004918:	fe843503          	ld	a0,-24(s0)
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	426080e7          	jalr	1062(ra) # 80003d42 <fileread>
}
    80004924:	70a2                	ld	ra,40(sp)
    80004926:	7402                	ld	s0,32(sp)
    80004928:	6145                	addi	sp,sp,48
    8000492a:	8082                	ret

000000008000492c <sys_write>:
{
    8000492c:	7179                	addi	sp,sp,-48
    8000492e:	f406                	sd	ra,40(sp)
    80004930:	f022                	sd	s0,32(sp)
    80004932:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004934:	fd840593          	addi	a1,s0,-40
    80004938:	4505                	li	a0,1
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	7dc080e7          	jalr	2012(ra) # 80002116 <argaddr>
  argint(2, &n);
    80004942:	fe440593          	addi	a1,s0,-28
    80004946:	4509                	li	a0,2
    80004948:	ffffd097          	auipc	ra,0xffffd
    8000494c:	7ae080e7          	jalr	1966(ra) # 800020f6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004950:	fe840613          	addi	a2,s0,-24
    80004954:	4581                	li	a1,0
    80004956:	4501                	li	a0,0
    80004958:	00000097          	auipc	ra,0x0
    8000495c:	d02080e7          	jalr	-766(ra) # 8000465a <argfd>
    80004960:	87aa                	mv	a5,a0
    return -1;
    80004962:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004964:	0007cc63          	bltz	a5,8000497c <sys_write+0x50>
  return filewrite(f, p, n);
    80004968:	fe442603          	lw	a2,-28(s0)
    8000496c:	fd843583          	ld	a1,-40(s0)
    80004970:	fe843503          	ld	a0,-24(s0)
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	490080e7          	jalr	1168(ra) # 80003e04 <filewrite>
}
    8000497c:	70a2                	ld	ra,40(sp)
    8000497e:	7402                	ld	s0,32(sp)
    80004980:	6145                	addi	sp,sp,48
    80004982:	8082                	ret

0000000080004984 <sys_close>:
{
    80004984:	1101                	addi	sp,sp,-32
    80004986:	ec06                	sd	ra,24(sp)
    80004988:	e822                	sd	s0,16(sp)
    8000498a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000498c:	fe040613          	addi	a2,s0,-32
    80004990:	fec40593          	addi	a1,s0,-20
    80004994:	4501                	li	a0,0
    80004996:	00000097          	auipc	ra,0x0
    8000499a:	cc4080e7          	jalr	-828(ra) # 8000465a <argfd>
    return -1;
    8000499e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049a0:	02054463          	bltz	a0,800049c8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049a4:	ffffc097          	auipc	ra,0xffffc
    800049a8:	590080e7          	jalr	1424(ra) # 80000f34 <myproc>
    800049ac:	fec42783          	lw	a5,-20(s0)
    800049b0:	07e9                	addi	a5,a5,26
    800049b2:	078e                	slli	a5,a5,0x3
    800049b4:	97aa                	add	a5,a5,a0
    800049b6:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800049ba:	fe043503          	ld	a0,-32(s0)
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	24a080e7          	jalr	586(ra) # 80003c08 <fileclose>
  return 0;
    800049c6:	4781                	li	a5,0
}
    800049c8:	853e                	mv	a0,a5
    800049ca:	60e2                	ld	ra,24(sp)
    800049cc:	6442                	ld	s0,16(sp)
    800049ce:	6105                	addi	sp,sp,32
    800049d0:	8082                	ret

00000000800049d2 <sys_fstat>:
{
    800049d2:	1101                	addi	sp,sp,-32
    800049d4:	ec06                	sd	ra,24(sp)
    800049d6:	e822                	sd	s0,16(sp)
    800049d8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049da:	fe040593          	addi	a1,s0,-32
    800049de:	4505                	li	a0,1
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	736080e7          	jalr	1846(ra) # 80002116 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049e8:	fe840613          	addi	a2,s0,-24
    800049ec:	4581                	li	a1,0
    800049ee:	4501                	li	a0,0
    800049f0:	00000097          	auipc	ra,0x0
    800049f4:	c6a080e7          	jalr	-918(ra) # 8000465a <argfd>
    800049f8:	87aa                	mv	a5,a0
    return -1;
    800049fa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049fc:	0007ca63          	bltz	a5,80004a10 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a00:	fe043583          	ld	a1,-32(s0)
    80004a04:	fe843503          	ld	a0,-24(s0)
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	2c8080e7          	jalr	712(ra) # 80003cd0 <filestat>
}
    80004a10:	60e2                	ld	ra,24(sp)
    80004a12:	6442                	ld	s0,16(sp)
    80004a14:	6105                	addi	sp,sp,32
    80004a16:	8082                	ret

0000000080004a18 <sys_link>:
{
    80004a18:	7169                	addi	sp,sp,-304
    80004a1a:	f606                	sd	ra,296(sp)
    80004a1c:	f222                	sd	s0,288(sp)
    80004a1e:	ee26                	sd	s1,280(sp)
    80004a20:	ea4a                	sd	s2,272(sp)
    80004a22:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a24:	08000613          	li	a2,128
    80004a28:	ed040593          	addi	a1,s0,-304
    80004a2c:	4501                	li	a0,0
    80004a2e:	ffffd097          	auipc	ra,0xffffd
    80004a32:	708080e7          	jalr	1800(ra) # 80002136 <argstr>
    return -1;
    80004a36:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a38:	10054e63          	bltz	a0,80004b54 <sys_link+0x13c>
    80004a3c:	08000613          	li	a2,128
    80004a40:	f5040593          	addi	a1,s0,-176
    80004a44:	4505                	li	a0,1
    80004a46:	ffffd097          	auipc	ra,0xffffd
    80004a4a:	6f0080e7          	jalr	1776(ra) # 80002136 <argstr>
    return -1;
    80004a4e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a50:	10054263          	bltz	a0,80004b54 <sys_link+0x13c>
  begin_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	ce8080e7          	jalr	-792(ra) # 8000373c <begin_op>
  if((ip = namei(old)) == 0){
    80004a5c:	ed040513          	addi	a0,s0,-304
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	ac0080e7          	jalr	-1344(ra) # 80003520 <namei>
    80004a68:	84aa                	mv	s1,a0
    80004a6a:	c551                	beqz	a0,80004af6 <sys_link+0xde>
  ilock(ip);
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	30e080e7          	jalr	782(ra) # 80002d7a <ilock>
  if(ip->type == T_DIR){
    80004a74:	04449703          	lh	a4,68(s1)
    80004a78:	4785                	li	a5,1
    80004a7a:	08f70463          	beq	a4,a5,80004b02 <sys_link+0xea>
  ip->nlink++;
    80004a7e:	04a4d783          	lhu	a5,74(s1)
    80004a82:	2785                	addiw	a5,a5,1
    80004a84:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	226080e7          	jalr	550(ra) # 80002cb0 <iupdate>
  iunlock(ip);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	3a8080e7          	jalr	936(ra) # 80002e3c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a9c:	fd040593          	addi	a1,s0,-48
    80004aa0:	f5040513          	addi	a0,s0,-176
    80004aa4:	fffff097          	auipc	ra,0xfffff
    80004aa8:	a9a080e7          	jalr	-1382(ra) # 8000353e <nameiparent>
    80004aac:	892a                	mv	s2,a0
    80004aae:	c935                	beqz	a0,80004b22 <sys_link+0x10a>
  ilock(dp);
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	2ca080e7          	jalr	714(ra) # 80002d7a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ab8:	00092703          	lw	a4,0(s2)
    80004abc:	409c                	lw	a5,0(s1)
    80004abe:	04f71d63          	bne	a4,a5,80004b18 <sys_link+0x100>
    80004ac2:	40d0                	lw	a2,4(s1)
    80004ac4:	fd040593          	addi	a1,s0,-48
    80004ac8:	854a                	mv	a0,s2
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	9a4080e7          	jalr	-1628(ra) # 8000346e <dirlink>
    80004ad2:	04054363          	bltz	a0,80004b18 <sys_link+0x100>
  iunlockput(dp);
    80004ad6:	854a                	mv	a0,s2
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	504080e7          	jalr	1284(ra) # 80002fdc <iunlockput>
  iput(ip);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	452080e7          	jalr	1106(ra) # 80002f34 <iput>
  end_op();
    80004aea:	fffff097          	auipc	ra,0xfffff
    80004aee:	cd2080e7          	jalr	-814(ra) # 800037bc <end_op>
  return 0;
    80004af2:	4781                	li	a5,0
    80004af4:	a085                	j	80004b54 <sys_link+0x13c>
    end_op();
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	cc6080e7          	jalr	-826(ra) # 800037bc <end_op>
    return -1;
    80004afe:	57fd                	li	a5,-1
    80004b00:	a891                	j	80004b54 <sys_link+0x13c>
    iunlockput(ip);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	4d8080e7          	jalr	1240(ra) # 80002fdc <iunlockput>
    end_op();
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	cb0080e7          	jalr	-848(ra) # 800037bc <end_op>
    return -1;
    80004b14:	57fd                	li	a5,-1
    80004b16:	a83d                	j	80004b54 <sys_link+0x13c>
    iunlockput(dp);
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	4c2080e7          	jalr	1218(ra) # 80002fdc <iunlockput>
  ilock(ip);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	256080e7          	jalr	598(ra) # 80002d7a <ilock>
  ip->nlink--;
    80004b2c:	04a4d783          	lhu	a5,74(s1)
    80004b30:	37fd                	addiw	a5,a5,-1
    80004b32:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	178080e7          	jalr	376(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	49a080e7          	jalr	1178(ra) # 80002fdc <iunlockput>
  end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	c72080e7          	jalr	-910(ra) # 800037bc <end_op>
  return -1;
    80004b52:	57fd                	li	a5,-1
}
    80004b54:	853e                	mv	a0,a5
    80004b56:	70b2                	ld	ra,296(sp)
    80004b58:	7412                	ld	s0,288(sp)
    80004b5a:	64f2                	ld	s1,280(sp)
    80004b5c:	6952                	ld	s2,272(sp)
    80004b5e:	6155                	addi	sp,sp,304
    80004b60:	8082                	ret

0000000080004b62 <sys_unlink>:
{
    80004b62:	7151                	addi	sp,sp,-240
    80004b64:	f586                	sd	ra,232(sp)
    80004b66:	f1a2                	sd	s0,224(sp)
    80004b68:	eda6                	sd	s1,216(sp)
    80004b6a:	e9ca                	sd	s2,208(sp)
    80004b6c:	e5ce                	sd	s3,200(sp)
    80004b6e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b70:	08000613          	li	a2,128
    80004b74:	f3040593          	addi	a1,s0,-208
    80004b78:	4501                	li	a0,0
    80004b7a:	ffffd097          	auipc	ra,0xffffd
    80004b7e:	5bc080e7          	jalr	1468(ra) # 80002136 <argstr>
    80004b82:	18054163          	bltz	a0,80004d04 <sys_unlink+0x1a2>
  begin_op();
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	bb6080e7          	jalr	-1098(ra) # 8000373c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b8e:	fb040593          	addi	a1,s0,-80
    80004b92:	f3040513          	addi	a0,s0,-208
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	9a8080e7          	jalr	-1624(ra) # 8000353e <nameiparent>
    80004b9e:	84aa                	mv	s1,a0
    80004ba0:	c979                	beqz	a0,80004c76 <sys_unlink+0x114>
  ilock(dp);
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	1d8080e7          	jalr	472(ra) # 80002d7a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004baa:	00004597          	auipc	a1,0x4
    80004bae:	b3e58593          	addi	a1,a1,-1218 # 800086e8 <syscalls+0x2e8>
    80004bb2:	fb040513          	addi	a0,s0,-80
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	68e080e7          	jalr	1678(ra) # 80003244 <namecmp>
    80004bbe:	14050a63          	beqz	a0,80004d12 <sys_unlink+0x1b0>
    80004bc2:	00004597          	auipc	a1,0x4
    80004bc6:	b2e58593          	addi	a1,a1,-1234 # 800086f0 <syscalls+0x2f0>
    80004bca:	fb040513          	addi	a0,s0,-80
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	676080e7          	jalr	1654(ra) # 80003244 <namecmp>
    80004bd6:	12050e63          	beqz	a0,80004d12 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bda:	f2c40613          	addi	a2,s0,-212
    80004bde:	fb040593          	addi	a1,s0,-80
    80004be2:	8526                	mv	a0,s1
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	67a080e7          	jalr	1658(ra) # 8000325e <dirlookup>
    80004bec:	892a                	mv	s2,a0
    80004bee:	12050263          	beqz	a0,80004d12 <sys_unlink+0x1b0>
  ilock(ip);
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	188080e7          	jalr	392(ra) # 80002d7a <ilock>
  if(ip->nlink < 1)
    80004bfa:	04a91783          	lh	a5,74(s2)
    80004bfe:	08f05263          	blez	a5,80004c82 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c02:	04491703          	lh	a4,68(s2)
    80004c06:	4785                	li	a5,1
    80004c08:	08f70563          	beq	a4,a5,80004c92 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c0c:	4641                	li	a2,16
    80004c0e:	4581                	li	a1,0
    80004c10:	fc040513          	addi	a0,s0,-64
    80004c14:	ffffb097          	auipc	ra,0xffffb
    80004c18:	564080e7          	jalr	1380(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c1c:	4741                	li	a4,16
    80004c1e:	f2c42683          	lw	a3,-212(s0)
    80004c22:	fc040613          	addi	a2,s0,-64
    80004c26:	4581                	li	a1,0
    80004c28:	8526                	mv	a0,s1
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	4fc080e7          	jalr	1276(ra) # 80003126 <writei>
    80004c32:	47c1                	li	a5,16
    80004c34:	0af51563          	bne	a0,a5,80004cde <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c38:	04491703          	lh	a4,68(s2)
    80004c3c:	4785                	li	a5,1
    80004c3e:	0af70863          	beq	a4,a5,80004cee <sys_unlink+0x18c>
  iunlockput(dp);
    80004c42:	8526                	mv	a0,s1
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	398080e7          	jalr	920(ra) # 80002fdc <iunlockput>
  ip->nlink--;
    80004c4c:	04a95783          	lhu	a5,74(s2)
    80004c50:	37fd                	addiw	a5,a5,-1
    80004c52:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c56:	854a                	mv	a0,s2
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	058080e7          	jalr	88(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    80004c60:	854a                	mv	a0,s2
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	37a080e7          	jalr	890(ra) # 80002fdc <iunlockput>
  end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	b52080e7          	jalr	-1198(ra) # 800037bc <end_op>
  return 0;
    80004c72:	4501                	li	a0,0
    80004c74:	a84d                	j	80004d26 <sys_unlink+0x1c4>
    end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	b46080e7          	jalr	-1210(ra) # 800037bc <end_op>
    return -1;
    80004c7e:	557d                	li	a0,-1
    80004c80:	a05d                	j	80004d26 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c82:	00004517          	auipc	a0,0x4
    80004c86:	a7650513          	addi	a0,a0,-1418 # 800086f8 <syscalls+0x2f8>
    80004c8a:	00001097          	auipc	ra,0x1
    80004c8e:	1b4080e7          	jalr	436(ra) # 80005e3e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c92:	04c92703          	lw	a4,76(s2)
    80004c96:	02000793          	li	a5,32
    80004c9a:	f6e7f9e3          	bgeu	a5,a4,80004c0c <sys_unlink+0xaa>
    80004c9e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ca2:	4741                	li	a4,16
    80004ca4:	86ce                	mv	a3,s3
    80004ca6:	f1840613          	addi	a2,s0,-232
    80004caa:	4581                	li	a1,0
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	380080e7          	jalr	896(ra) # 8000302e <readi>
    80004cb6:	47c1                	li	a5,16
    80004cb8:	00f51b63          	bne	a0,a5,80004cce <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cbc:	f1845783          	lhu	a5,-232(s0)
    80004cc0:	e7a1                	bnez	a5,80004d08 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cc2:	29c1                	addiw	s3,s3,16
    80004cc4:	04c92783          	lw	a5,76(s2)
    80004cc8:	fcf9ede3          	bltu	s3,a5,80004ca2 <sys_unlink+0x140>
    80004ccc:	b781                	j	80004c0c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cce:	00004517          	auipc	a0,0x4
    80004cd2:	a4250513          	addi	a0,a0,-1470 # 80008710 <syscalls+0x310>
    80004cd6:	00001097          	auipc	ra,0x1
    80004cda:	168080e7          	jalr	360(ra) # 80005e3e <panic>
    panic("unlink: writei");
    80004cde:	00004517          	auipc	a0,0x4
    80004ce2:	a4a50513          	addi	a0,a0,-1462 # 80008728 <syscalls+0x328>
    80004ce6:	00001097          	auipc	ra,0x1
    80004cea:	158080e7          	jalr	344(ra) # 80005e3e <panic>
    dp->nlink--;
    80004cee:	04a4d783          	lhu	a5,74(s1)
    80004cf2:	37fd                	addiw	a5,a5,-1
    80004cf4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	fb6080e7          	jalr	-74(ra) # 80002cb0 <iupdate>
    80004d02:	b781                	j	80004c42 <sys_unlink+0xe0>
    return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	a005                	j	80004d26 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d08:	854a                	mv	a0,s2
    80004d0a:	ffffe097          	auipc	ra,0xffffe
    80004d0e:	2d2080e7          	jalr	722(ra) # 80002fdc <iunlockput>
  iunlockput(dp);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	2c8080e7          	jalr	712(ra) # 80002fdc <iunlockput>
  end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	aa0080e7          	jalr	-1376(ra) # 800037bc <end_op>
  return -1;
    80004d24:	557d                	li	a0,-1
}
    80004d26:	70ae                	ld	ra,232(sp)
    80004d28:	740e                	ld	s0,224(sp)
    80004d2a:	64ee                	ld	s1,216(sp)
    80004d2c:	694e                	ld	s2,208(sp)
    80004d2e:	69ae                	ld	s3,200(sp)
    80004d30:	616d                	addi	sp,sp,240
    80004d32:	8082                	ret

0000000080004d34 <sys_open>:

uint64
sys_open(void)
{
    80004d34:	7131                	addi	sp,sp,-192
    80004d36:	fd06                	sd	ra,184(sp)
    80004d38:	f922                	sd	s0,176(sp)
    80004d3a:	f526                	sd	s1,168(sp)
    80004d3c:	f14a                	sd	s2,160(sp)
    80004d3e:	ed4e                	sd	s3,152(sp)
    80004d40:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d42:	f4c40593          	addi	a1,s0,-180
    80004d46:	4505                	li	a0,1
    80004d48:	ffffd097          	auipc	ra,0xffffd
    80004d4c:	3ae080e7          	jalr	942(ra) # 800020f6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d50:	08000613          	li	a2,128
    80004d54:	f5040593          	addi	a1,s0,-176
    80004d58:	4501                	li	a0,0
    80004d5a:	ffffd097          	auipc	ra,0xffffd
    80004d5e:	3dc080e7          	jalr	988(ra) # 80002136 <argstr>
    80004d62:	87aa                	mv	a5,a0
    return -1;
    80004d64:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d66:	0a07c963          	bltz	a5,80004e18 <sys_open+0xe4>

  begin_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	9d2080e7          	jalr	-1582(ra) # 8000373c <begin_op>

  if(omode & O_CREATE){
    80004d72:	f4c42783          	lw	a5,-180(s0)
    80004d76:	2007f793          	andi	a5,a5,512
    80004d7a:	cfc5                	beqz	a5,80004e32 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d7c:	4681                	li	a3,0
    80004d7e:	4601                	li	a2,0
    80004d80:	4589                	li	a1,2
    80004d82:	f5040513          	addi	a0,s0,-176
    80004d86:	00000097          	auipc	ra,0x0
    80004d8a:	976080e7          	jalr	-1674(ra) # 800046fc <create>
    80004d8e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d90:	c959                	beqz	a0,80004e26 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d92:	04449703          	lh	a4,68(s1)
    80004d96:	478d                	li	a5,3
    80004d98:	00f71763          	bne	a4,a5,80004da6 <sys_open+0x72>
    80004d9c:	0464d703          	lhu	a4,70(s1)
    80004da0:	47a5                	li	a5,9
    80004da2:	0ce7ed63          	bltu	a5,a4,80004e7c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	da6080e7          	jalr	-602(ra) # 80003b4c <filealloc>
    80004dae:	89aa                	mv	s3,a0
    80004db0:	10050363          	beqz	a0,80004eb6 <sys_open+0x182>
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	906080e7          	jalr	-1786(ra) # 800046ba <fdalloc>
    80004dbc:	892a                	mv	s2,a0
    80004dbe:	0e054763          	bltz	a0,80004eac <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dc2:	04449703          	lh	a4,68(s1)
    80004dc6:	478d                	li	a5,3
    80004dc8:	0cf70563          	beq	a4,a5,80004e92 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dcc:	4789                	li	a5,2
    80004dce:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dd2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dd6:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dda:	f4c42783          	lw	a5,-180(s0)
    80004dde:	0017c713          	xori	a4,a5,1
    80004de2:	8b05                	andi	a4,a4,1
    80004de4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004de8:	0037f713          	andi	a4,a5,3
    80004dec:	00e03733          	snez	a4,a4
    80004df0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004df4:	4007f793          	andi	a5,a5,1024
    80004df8:	c791                	beqz	a5,80004e04 <sys_open+0xd0>
    80004dfa:	04449703          	lh	a4,68(s1)
    80004dfe:	4789                	li	a5,2
    80004e00:	0af70063          	beq	a4,a5,80004ea0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e04:	8526                	mv	a0,s1
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	036080e7          	jalr	54(ra) # 80002e3c <iunlock>
  end_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	9ae080e7          	jalr	-1618(ra) # 800037bc <end_op>

  return fd;
    80004e16:	854a                	mv	a0,s2
}
    80004e18:	70ea                	ld	ra,184(sp)
    80004e1a:	744a                	ld	s0,176(sp)
    80004e1c:	74aa                	ld	s1,168(sp)
    80004e1e:	790a                	ld	s2,160(sp)
    80004e20:	69ea                	ld	s3,152(sp)
    80004e22:	6129                	addi	sp,sp,192
    80004e24:	8082                	ret
      end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	996080e7          	jalr	-1642(ra) # 800037bc <end_op>
      return -1;
    80004e2e:	557d                	li	a0,-1
    80004e30:	b7e5                	j	80004e18 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e32:	f5040513          	addi	a0,s0,-176
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	6ea080e7          	jalr	1770(ra) # 80003520 <namei>
    80004e3e:	84aa                	mv	s1,a0
    80004e40:	c905                	beqz	a0,80004e70 <sys_open+0x13c>
    ilock(ip);
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	f38080e7          	jalr	-200(ra) # 80002d7a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e4a:	04449703          	lh	a4,68(s1)
    80004e4e:	4785                	li	a5,1
    80004e50:	f4f711e3          	bne	a4,a5,80004d92 <sys_open+0x5e>
    80004e54:	f4c42783          	lw	a5,-180(s0)
    80004e58:	d7b9                	beqz	a5,80004da6 <sys_open+0x72>
      iunlockput(ip);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	180080e7          	jalr	384(ra) # 80002fdc <iunlockput>
      end_op();
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	958080e7          	jalr	-1704(ra) # 800037bc <end_op>
      return -1;
    80004e6c:	557d                	li	a0,-1
    80004e6e:	b76d                	j	80004e18 <sys_open+0xe4>
      end_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	94c080e7          	jalr	-1716(ra) # 800037bc <end_op>
      return -1;
    80004e78:	557d                	li	a0,-1
    80004e7a:	bf79                	j	80004e18 <sys_open+0xe4>
    iunlockput(ip);
    80004e7c:	8526                	mv	a0,s1
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	15e080e7          	jalr	350(ra) # 80002fdc <iunlockput>
    end_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	936080e7          	jalr	-1738(ra) # 800037bc <end_op>
    return -1;
    80004e8e:	557d                	li	a0,-1
    80004e90:	b761                	j	80004e18 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e92:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e96:	04649783          	lh	a5,70(s1)
    80004e9a:	02f99223          	sh	a5,36(s3)
    80004e9e:	bf25                	j	80004dd6 <sys_open+0xa2>
    itrunc(ip);
    80004ea0:	8526                	mv	a0,s1
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	fe6080e7          	jalr	-26(ra) # 80002e88 <itrunc>
    80004eaa:	bfa9                	j	80004e04 <sys_open+0xd0>
      fileclose(f);
    80004eac:	854e                	mv	a0,s3
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	d5a080e7          	jalr	-678(ra) # 80003c08 <fileclose>
    iunlockput(ip);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	124080e7          	jalr	292(ra) # 80002fdc <iunlockput>
    end_op();
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	8fc080e7          	jalr	-1796(ra) # 800037bc <end_op>
    return -1;
    80004ec8:	557d                	li	a0,-1
    80004eca:	b7b9                	j	80004e18 <sys_open+0xe4>

0000000080004ecc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ecc:	7175                	addi	sp,sp,-144
    80004ece:	e506                	sd	ra,136(sp)
    80004ed0:	e122                	sd	s0,128(sp)
    80004ed2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	868080e7          	jalr	-1944(ra) # 8000373c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004edc:	08000613          	li	a2,128
    80004ee0:	f7040593          	addi	a1,s0,-144
    80004ee4:	4501                	li	a0,0
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	250080e7          	jalr	592(ra) # 80002136 <argstr>
    80004eee:	02054963          	bltz	a0,80004f20 <sys_mkdir+0x54>
    80004ef2:	4681                	li	a3,0
    80004ef4:	4601                	li	a2,0
    80004ef6:	4585                	li	a1,1
    80004ef8:	f7040513          	addi	a0,s0,-144
    80004efc:	00000097          	auipc	ra,0x0
    80004f00:	800080e7          	jalr	-2048(ra) # 800046fc <create>
    80004f04:	cd11                	beqz	a0,80004f20 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	0d6080e7          	jalr	214(ra) # 80002fdc <iunlockput>
  end_op();
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	8ae080e7          	jalr	-1874(ra) # 800037bc <end_op>
  return 0;
    80004f16:	4501                	li	a0,0
}
    80004f18:	60aa                	ld	ra,136(sp)
    80004f1a:	640a                	ld	s0,128(sp)
    80004f1c:	6149                	addi	sp,sp,144
    80004f1e:	8082                	ret
    end_op();
    80004f20:	fffff097          	auipc	ra,0xfffff
    80004f24:	89c080e7          	jalr	-1892(ra) # 800037bc <end_op>
    return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	b7fd                	j	80004f18 <sys_mkdir+0x4c>

0000000080004f2c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f2c:	7135                	addi	sp,sp,-160
    80004f2e:	ed06                	sd	ra,152(sp)
    80004f30:	e922                	sd	s0,144(sp)
    80004f32:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	808080e7          	jalr	-2040(ra) # 8000373c <begin_op>
  argint(1, &major);
    80004f3c:	f6c40593          	addi	a1,s0,-148
    80004f40:	4505                	li	a0,1
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	1b4080e7          	jalr	436(ra) # 800020f6 <argint>
  argint(2, &minor);
    80004f4a:	f6840593          	addi	a1,s0,-152
    80004f4e:	4509                	li	a0,2
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	1a6080e7          	jalr	422(ra) # 800020f6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f58:	08000613          	li	a2,128
    80004f5c:	f7040593          	addi	a1,s0,-144
    80004f60:	4501                	li	a0,0
    80004f62:	ffffd097          	auipc	ra,0xffffd
    80004f66:	1d4080e7          	jalr	468(ra) # 80002136 <argstr>
    80004f6a:	02054b63          	bltz	a0,80004fa0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f6e:	f6841683          	lh	a3,-152(s0)
    80004f72:	f6c41603          	lh	a2,-148(s0)
    80004f76:	458d                	li	a1,3
    80004f78:	f7040513          	addi	a0,s0,-144
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	780080e7          	jalr	1920(ra) # 800046fc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f84:	cd11                	beqz	a0,80004fa0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	056080e7          	jalr	86(ra) # 80002fdc <iunlockput>
  end_op();
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	82e080e7          	jalr	-2002(ra) # 800037bc <end_op>
  return 0;
    80004f96:	4501                	li	a0,0
}
    80004f98:	60ea                	ld	ra,152(sp)
    80004f9a:	644a                	ld	s0,144(sp)
    80004f9c:	610d                	addi	sp,sp,160
    80004f9e:	8082                	ret
    end_op();
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	81c080e7          	jalr	-2020(ra) # 800037bc <end_op>
    return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	b7fd                	j	80004f98 <sys_mknod+0x6c>

0000000080004fac <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fac:	7135                	addi	sp,sp,-160
    80004fae:	ed06                	sd	ra,152(sp)
    80004fb0:	e922                	sd	s0,144(sp)
    80004fb2:	e526                	sd	s1,136(sp)
    80004fb4:	e14a                	sd	s2,128(sp)
    80004fb6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	f7c080e7          	jalr	-132(ra) # 80000f34 <myproc>
    80004fc0:	892a                	mv	s2,a0
  
  begin_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	77a080e7          	jalr	1914(ra) # 8000373c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fca:	08000613          	li	a2,128
    80004fce:	f6040593          	addi	a1,s0,-160
    80004fd2:	4501                	li	a0,0
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	162080e7          	jalr	354(ra) # 80002136 <argstr>
    80004fdc:	04054b63          	bltz	a0,80005032 <sys_chdir+0x86>
    80004fe0:	f6040513          	addi	a0,s0,-160
    80004fe4:	ffffe097          	auipc	ra,0xffffe
    80004fe8:	53c080e7          	jalr	1340(ra) # 80003520 <namei>
    80004fec:	84aa                	mv	s1,a0
    80004fee:	c131                	beqz	a0,80005032 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	d8a080e7          	jalr	-630(ra) # 80002d7a <ilock>
  if(ip->type != T_DIR){
    80004ff8:	04449703          	lh	a4,68(s1)
    80004ffc:	4785                	li	a5,1
    80004ffe:	04f71063          	bne	a4,a5,8000503e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005002:	8526                	mv	a0,s1
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	e38080e7          	jalr	-456(ra) # 80002e3c <iunlock>
  iput(p->cwd);
    8000500c:	15893503          	ld	a0,344(s2)
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	f24080e7          	jalr	-220(ra) # 80002f34 <iput>
  end_op();
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	7a4080e7          	jalr	1956(ra) # 800037bc <end_op>
  p->cwd = ip;
    80005020:	14993c23          	sd	s1,344(s2)
  return 0;
    80005024:	4501                	li	a0,0
}
    80005026:	60ea                	ld	ra,152(sp)
    80005028:	644a                	ld	s0,144(sp)
    8000502a:	64aa                	ld	s1,136(sp)
    8000502c:	690a                	ld	s2,128(sp)
    8000502e:	610d                	addi	sp,sp,160
    80005030:	8082                	ret
    end_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	78a080e7          	jalr	1930(ra) # 800037bc <end_op>
    return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	b7ed                	j	80005026 <sys_chdir+0x7a>
    iunlockput(ip);
    8000503e:	8526                	mv	a0,s1
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	f9c080e7          	jalr	-100(ra) # 80002fdc <iunlockput>
    end_op();
    80005048:	ffffe097          	auipc	ra,0xffffe
    8000504c:	774080e7          	jalr	1908(ra) # 800037bc <end_op>
    return -1;
    80005050:	557d                	li	a0,-1
    80005052:	bfd1                	j	80005026 <sys_chdir+0x7a>

0000000080005054 <sys_exec>:

uint64
sys_exec(void)
{
    80005054:	7145                	addi	sp,sp,-464
    80005056:	e786                	sd	ra,456(sp)
    80005058:	e3a2                	sd	s0,448(sp)
    8000505a:	ff26                	sd	s1,440(sp)
    8000505c:	fb4a                	sd	s2,432(sp)
    8000505e:	f74e                	sd	s3,424(sp)
    80005060:	f352                	sd	s4,416(sp)
    80005062:	ef56                	sd	s5,408(sp)
    80005064:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005066:	e3840593          	addi	a1,s0,-456
    8000506a:	4505                	li	a0,1
    8000506c:	ffffd097          	auipc	ra,0xffffd
    80005070:	0aa080e7          	jalr	170(ra) # 80002116 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005074:	08000613          	li	a2,128
    80005078:	f4040593          	addi	a1,s0,-192
    8000507c:	4501                	li	a0,0
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	0b8080e7          	jalr	184(ra) # 80002136 <argstr>
    80005086:	87aa                	mv	a5,a0
    return -1;
    80005088:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000508a:	0c07c263          	bltz	a5,8000514e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000508e:	10000613          	li	a2,256
    80005092:	4581                	li	a1,0
    80005094:	e4040513          	addi	a0,s0,-448
    80005098:	ffffb097          	auipc	ra,0xffffb
    8000509c:	0e0080e7          	jalr	224(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050a0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050a4:	89a6                	mv	s3,s1
    800050a6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050a8:	02000a13          	li	s4,32
    800050ac:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050b0:	00391793          	slli	a5,s2,0x3
    800050b4:	e3040593          	addi	a1,s0,-464
    800050b8:	e3843503          	ld	a0,-456(s0)
    800050bc:	953e                	add	a0,a0,a5
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	f9a080e7          	jalr	-102(ra) # 80002058 <fetchaddr>
    800050c6:	02054a63          	bltz	a0,800050fa <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800050ca:	e3043783          	ld	a5,-464(s0)
    800050ce:	c3b9                	beqz	a5,80005114 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050d0:	ffffb097          	auipc	ra,0xffffb
    800050d4:	048080e7          	jalr	72(ra) # 80000118 <kalloc>
    800050d8:	85aa                	mv	a1,a0
    800050da:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050de:	cd11                	beqz	a0,800050fa <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050e0:	6605                	lui	a2,0x1
    800050e2:	e3043503          	ld	a0,-464(s0)
    800050e6:	ffffd097          	auipc	ra,0xffffd
    800050ea:	fc4080e7          	jalr	-60(ra) # 800020aa <fetchstr>
    800050ee:	00054663          	bltz	a0,800050fa <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050f2:	0905                	addi	s2,s2,1
    800050f4:	09a1                	addi	s3,s3,8
    800050f6:	fb491be3          	bne	s2,s4,800050ac <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fa:	10048913          	addi	s2,s1,256
    800050fe:	6088                	ld	a0,0(s1)
    80005100:	c531                	beqz	a0,8000514c <sys_exec+0xf8>
    kfree(argv[i]);
    80005102:	ffffb097          	auipc	ra,0xffffb
    80005106:	f1a080e7          	jalr	-230(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000510a:	04a1                	addi	s1,s1,8
    8000510c:	ff2499e3          	bne	s1,s2,800050fe <sys_exec+0xaa>
  return -1;
    80005110:	557d                	li	a0,-1
    80005112:	a835                	j	8000514e <sys_exec+0xfa>
      argv[i] = 0;
    80005114:	0a8e                	slli	s5,s5,0x3
    80005116:	fc040793          	addi	a5,s0,-64
    8000511a:	9abe                	add	s5,s5,a5
    8000511c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005120:	e4040593          	addi	a1,s0,-448
    80005124:	f4040513          	addi	a0,s0,-192
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	15a080e7          	jalr	346(ra) # 80004282 <exec>
    80005130:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005132:	10048993          	addi	s3,s1,256
    80005136:	6088                	ld	a0,0(s1)
    80005138:	c901                	beqz	a0,80005148 <sys_exec+0xf4>
    kfree(argv[i]);
    8000513a:	ffffb097          	auipc	ra,0xffffb
    8000513e:	ee2080e7          	jalr	-286(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005142:	04a1                	addi	s1,s1,8
    80005144:	ff3499e3          	bne	s1,s3,80005136 <sys_exec+0xe2>
  return ret;
    80005148:	854a                	mv	a0,s2
    8000514a:	a011                	j	8000514e <sys_exec+0xfa>
  return -1;
    8000514c:	557d                	li	a0,-1
}
    8000514e:	60be                	ld	ra,456(sp)
    80005150:	641e                	ld	s0,448(sp)
    80005152:	74fa                	ld	s1,440(sp)
    80005154:	795a                	ld	s2,432(sp)
    80005156:	79ba                	ld	s3,424(sp)
    80005158:	7a1a                	ld	s4,416(sp)
    8000515a:	6afa                	ld	s5,408(sp)
    8000515c:	6179                	addi	sp,sp,464
    8000515e:	8082                	ret

0000000080005160 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005160:	7139                	addi	sp,sp,-64
    80005162:	fc06                	sd	ra,56(sp)
    80005164:	f822                	sd	s0,48(sp)
    80005166:	f426                	sd	s1,40(sp)
    80005168:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000516a:	ffffc097          	auipc	ra,0xffffc
    8000516e:	dca080e7          	jalr	-566(ra) # 80000f34 <myproc>
    80005172:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005174:	fd840593          	addi	a1,s0,-40
    80005178:	4501                	li	a0,0
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	f9c080e7          	jalr	-100(ra) # 80002116 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005182:	fc840593          	addi	a1,s0,-56
    80005186:	fd040513          	addi	a0,s0,-48
    8000518a:	fffff097          	auipc	ra,0xfffff
    8000518e:	dae080e7          	jalr	-594(ra) # 80003f38 <pipealloc>
    return -1;
    80005192:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005194:	0c054463          	bltz	a0,8000525c <sys_pipe+0xfc>
  fd0 = -1;
    80005198:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000519c:	fd043503          	ld	a0,-48(s0)
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	51a080e7          	jalr	1306(ra) # 800046ba <fdalloc>
    800051a8:	fca42223          	sw	a0,-60(s0)
    800051ac:	08054b63          	bltz	a0,80005242 <sys_pipe+0xe2>
    800051b0:	fc843503          	ld	a0,-56(s0)
    800051b4:	fffff097          	auipc	ra,0xfffff
    800051b8:	506080e7          	jalr	1286(ra) # 800046ba <fdalloc>
    800051bc:	fca42023          	sw	a0,-64(s0)
    800051c0:	06054863          	bltz	a0,80005230 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051c4:	4691                	li	a3,4
    800051c6:	fc440613          	addi	a2,s0,-60
    800051ca:	fd843583          	ld	a1,-40(s0)
    800051ce:	68a8                	ld	a0,80(s1)
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	93e080e7          	jalr	-1730(ra) # 80000b0e <copyout>
    800051d8:	02054063          	bltz	a0,800051f8 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051dc:	4691                	li	a3,4
    800051de:	fc040613          	addi	a2,s0,-64
    800051e2:	fd843583          	ld	a1,-40(s0)
    800051e6:	0591                	addi	a1,a1,4
    800051e8:	68a8                	ld	a0,80(s1)
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	924080e7          	jalr	-1756(ra) # 80000b0e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051f2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051f4:	06055463          	bgez	a0,8000525c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051f8:	fc442783          	lw	a5,-60(s0)
    800051fc:	07e9                	addi	a5,a5,26
    800051fe:	078e                	slli	a5,a5,0x3
    80005200:	97a6                	add	a5,a5,s1
    80005202:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005206:	fc042503          	lw	a0,-64(s0)
    8000520a:	0569                	addi	a0,a0,26
    8000520c:	050e                	slli	a0,a0,0x3
    8000520e:	94aa                	add	s1,s1,a0
    80005210:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005214:	fd043503          	ld	a0,-48(s0)
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	9f0080e7          	jalr	-1552(ra) # 80003c08 <fileclose>
    fileclose(wf);
    80005220:	fc843503          	ld	a0,-56(s0)
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	9e4080e7          	jalr	-1564(ra) # 80003c08 <fileclose>
    return -1;
    8000522c:	57fd                	li	a5,-1
    8000522e:	a03d                	j	8000525c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005230:	fc442783          	lw	a5,-60(s0)
    80005234:	0007c763          	bltz	a5,80005242 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005238:	07e9                	addi	a5,a5,26
    8000523a:	078e                	slli	a5,a5,0x3
    8000523c:	94be                	add	s1,s1,a5
    8000523e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005242:	fd043503          	ld	a0,-48(s0)
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	9c2080e7          	jalr	-1598(ra) # 80003c08 <fileclose>
    fileclose(wf);
    8000524e:	fc843503          	ld	a0,-56(s0)
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	9b6080e7          	jalr	-1610(ra) # 80003c08 <fileclose>
    return -1;
    8000525a:	57fd                	li	a5,-1
}
    8000525c:	853e                	mv	a0,a5
    8000525e:	70e2                	ld	ra,56(sp)
    80005260:	7442                	ld	s0,48(sp)
    80005262:	74a2                	ld	s1,40(sp)
    80005264:	6121                	addi	sp,sp,64
    80005266:	8082                	ret
	...

0000000080005270 <kernelvec>:
    80005270:	7111                	addi	sp,sp,-256
    80005272:	e006                	sd	ra,0(sp)
    80005274:	e40a                	sd	sp,8(sp)
    80005276:	e80e                	sd	gp,16(sp)
    80005278:	ec12                	sd	tp,24(sp)
    8000527a:	f016                	sd	t0,32(sp)
    8000527c:	f41a                	sd	t1,40(sp)
    8000527e:	f81e                	sd	t2,48(sp)
    80005280:	fc22                	sd	s0,56(sp)
    80005282:	e0a6                	sd	s1,64(sp)
    80005284:	e4aa                	sd	a0,72(sp)
    80005286:	e8ae                	sd	a1,80(sp)
    80005288:	ecb2                	sd	a2,88(sp)
    8000528a:	f0b6                	sd	a3,96(sp)
    8000528c:	f4ba                	sd	a4,104(sp)
    8000528e:	f8be                	sd	a5,112(sp)
    80005290:	fcc2                	sd	a6,120(sp)
    80005292:	e146                	sd	a7,128(sp)
    80005294:	e54a                	sd	s2,136(sp)
    80005296:	e94e                	sd	s3,144(sp)
    80005298:	ed52                	sd	s4,152(sp)
    8000529a:	f156                	sd	s5,160(sp)
    8000529c:	f55a                	sd	s6,168(sp)
    8000529e:	f95e                	sd	s7,176(sp)
    800052a0:	fd62                	sd	s8,184(sp)
    800052a2:	e1e6                	sd	s9,192(sp)
    800052a4:	e5ea                	sd	s10,200(sp)
    800052a6:	e9ee                	sd	s11,208(sp)
    800052a8:	edf2                	sd	t3,216(sp)
    800052aa:	f1f6                	sd	t4,224(sp)
    800052ac:	f5fa                	sd	t5,232(sp)
    800052ae:	f9fe                	sd	t6,240(sp)
    800052b0:	c75fc0ef          	jal	ra,80001f24 <kerneltrap>
    800052b4:	6082                	ld	ra,0(sp)
    800052b6:	6122                	ld	sp,8(sp)
    800052b8:	61c2                	ld	gp,16(sp)
    800052ba:	7282                	ld	t0,32(sp)
    800052bc:	7322                	ld	t1,40(sp)
    800052be:	73c2                	ld	t2,48(sp)
    800052c0:	7462                	ld	s0,56(sp)
    800052c2:	6486                	ld	s1,64(sp)
    800052c4:	6526                	ld	a0,72(sp)
    800052c6:	65c6                	ld	a1,80(sp)
    800052c8:	6666                	ld	a2,88(sp)
    800052ca:	7686                	ld	a3,96(sp)
    800052cc:	7726                	ld	a4,104(sp)
    800052ce:	77c6                	ld	a5,112(sp)
    800052d0:	7866                	ld	a6,120(sp)
    800052d2:	688a                	ld	a7,128(sp)
    800052d4:	692a                	ld	s2,136(sp)
    800052d6:	69ca                	ld	s3,144(sp)
    800052d8:	6a6a                	ld	s4,152(sp)
    800052da:	7a8a                	ld	s5,160(sp)
    800052dc:	7b2a                	ld	s6,168(sp)
    800052de:	7bca                	ld	s7,176(sp)
    800052e0:	7c6a                	ld	s8,184(sp)
    800052e2:	6c8e                	ld	s9,192(sp)
    800052e4:	6d2e                	ld	s10,200(sp)
    800052e6:	6dce                	ld	s11,208(sp)
    800052e8:	6e6e                	ld	t3,216(sp)
    800052ea:	7e8e                	ld	t4,224(sp)
    800052ec:	7f2e                	ld	t5,232(sp)
    800052ee:	7fce                	ld	t6,240(sp)
    800052f0:	6111                	addi	sp,sp,256
    800052f2:	10200073          	sret
    800052f6:	00000013          	nop
    800052fa:	00000013          	nop
    800052fe:	0001                	nop

0000000080005300 <timervec>:
    80005300:	34051573          	csrrw	a0,mscratch,a0
    80005304:	e10c                	sd	a1,0(a0)
    80005306:	e510                	sd	a2,8(a0)
    80005308:	e914                	sd	a3,16(a0)
    8000530a:	6d0c                	ld	a1,24(a0)
    8000530c:	7110                	ld	a2,32(a0)
    8000530e:	6194                	ld	a3,0(a1)
    80005310:	96b2                	add	a3,a3,a2
    80005312:	e194                	sd	a3,0(a1)
    80005314:	4589                	li	a1,2
    80005316:	14459073          	csrw	sip,a1
    8000531a:	6914                	ld	a3,16(a0)
    8000531c:	6510                	ld	a2,8(a0)
    8000531e:	610c                	ld	a1,0(a0)
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	30200073          	mret
	...

000000008000532a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000532a:	1141                	addi	sp,sp,-16
    8000532c:	e422                	sd	s0,8(sp)
    8000532e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005330:	0c0007b7          	lui	a5,0xc000
    80005334:	4705                	li	a4,1
    80005336:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005338:	c3d8                	sw	a4,4(a5)
}
    8000533a:	6422                	ld	s0,8(sp)
    8000533c:	0141                	addi	sp,sp,16
    8000533e:	8082                	ret

0000000080005340 <plicinithart>:

void
plicinithart(void)
{
    80005340:	1141                	addi	sp,sp,-16
    80005342:	e406                	sd	ra,8(sp)
    80005344:	e022                	sd	s0,0(sp)
    80005346:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	bc0080e7          	jalr	-1088(ra) # 80000f08 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005350:	0085171b          	slliw	a4,a0,0x8
    80005354:	0c0027b7          	lui	a5,0xc002
    80005358:	97ba                	add	a5,a5,a4
    8000535a:	40200713          	li	a4,1026
    8000535e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005362:	00d5151b          	slliw	a0,a0,0xd
    80005366:	0c2017b7          	lui	a5,0xc201
    8000536a:	953e                	add	a0,a0,a5
    8000536c:	00052023          	sw	zero,0(a0)
}
    80005370:	60a2                	ld	ra,8(sp)
    80005372:	6402                	ld	s0,0(sp)
    80005374:	0141                	addi	sp,sp,16
    80005376:	8082                	ret

0000000080005378 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005378:	1141                	addi	sp,sp,-16
    8000537a:	e406                	sd	ra,8(sp)
    8000537c:	e022                	sd	s0,0(sp)
    8000537e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005380:	ffffc097          	auipc	ra,0xffffc
    80005384:	b88080e7          	jalr	-1144(ra) # 80000f08 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005388:	00d5179b          	slliw	a5,a0,0xd
    8000538c:	0c201537          	lui	a0,0xc201
    80005390:	953e                	add	a0,a0,a5
  return irq;
}
    80005392:	4148                	lw	a0,4(a0)
    80005394:	60a2                	ld	ra,8(sp)
    80005396:	6402                	ld	s0,0(sp)
    80005398:	0141                	addi	sp,sp,16
    8000539a:	8082                	ret

000000008000539c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000539c:	1101                	addi	sp,sp,-32
    8000539e:	ec06                	sd	ra,24(sp)
    800053a0:	e822                	sd	s0,16(sp)
    800053a2:	e426                	sd	s1,8(sp)
    800053a4:	1000                	addi	s0,sp,32
    800053a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053a8:	ffffc097          	auipc	ra,0xffffc
    800053ac:	b60080e7          	jalr	-1184(ra) # 80000f08 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053b0:	00d5151b          	slliw	a0,a0,0xd
    800053b4:	0c2017b7          	lui	a5,0xc201
    800053b8:	97aa                	add	a5,a5,a0
    800053ba:	c3c4                	sw	s1,4(a5)
}
    800053bc:	60e2                	ld	ra,24(sp)
    800053be:	6442                	ld	s0,16(sp)
    800053c0:	64a2                	ld	s1,8(sp)
    800053c2:	6105                	addi	sp,sp,32
    800053c4:	8082                	ret

00000000800053c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053c6:	1141                	addi	sp,sp,-16
    800053c8:	e406                	sd	ra,8(sp)
    800053ca:	e022                	sd	s0,0(sp)
    800053cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ce:	479d                	li	a5,7
    800053d0:	04a7cc63          	blt	a5,a0,80005428 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053d4:	00015797          	auipc	a5,0x15
    800053d8:	85c78793          	addi	a5,a5,-1956 # 80019c30 <disk>
    800053dc:	97aa                	add	a5,a5,a0
    800053de:	0187c783          	lbu	a5,24(a5)
    800053e2:	ebb9                	bnez	a5,80005438 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053e4:	00451613          	slli	a2,a0,0x4
    800053e8:	00015797          	auipc	a5,0x15
    800053ec:	84878793          	addi	a5,a5,-1976 # 80019c30 <disk>
    800053f0:	6394                	ld	a3,0(a5)
    800053f2:	96b2                	add	a3,a3,a2
    800053f4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053f8:	6398                	ld	a4,0(a5)
    800053fa:	9732                	add	a4,a4,a2
    800053fc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005400:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005404:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005408:	953e                	add	a0,a0,a5
    8000540a:	4785                	li	a5,1
    8000540c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005410:	00015517          	auipc	a0,0x15
    80005414:	83850513          	addi	a0,a0,-1992 # 80019c48 <disk+0x18>
    80005418:	ffffc097          	auipc	ra,0xffffc
    8000541c:	2d6080e7          	jalr	726(ra) # 800016ee <wakeup>
}
    80005420:	60a2                	ld	ra,8(sp)
    80005422:	6402                	ld	s0,0(sp)
    80005424:	0141                	addi	sp,sp,16
    80005426:	8082                	ret
    panic("free_desc 1");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	31050513          	addi	a0,a0,784 # 80008738 <syscalls+0x338>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	a0e080e7          	jalr	-1522(ra) # 80005e3e <panic>
    panic("free_desc 2");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	31050513          	addi	a0,a0,784 # 80008748 <syscalls+0x348>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	9fe080e7          	jalr	-1538(ra) # 80005e3e <panic>

0000000080005448 <virtio_disk_init>:
{
    80005448:	1101                	addi	sp,sp,-32
    8000544a:	ec06                	sd	ra,24(sp)
    8000544c:	e822                	sd	s0,16(sp)
    8000544e:	e426                	sd	s1,8(sp)
    80005450:	e04a                	sd	s2,0(sp)
    80005452:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005454:	00003597          	auipc	a1,0x3
    80005458:	30458593          	addi	a1,a1,772 # 80008758 <syscalls+0x358>
    8000545c:	00015517          	auipc	a0,0x15
    80005460:	8fc50513          	addi	a0,a0,-1796 # 80019d58 <disk+0x128>
    80005464:	00001097          	auipc	ra,0x1
    80005468:	e86080e7          	jalr	-378(ra) # 800062ea <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000546c:	100017b7          	lui	a5,0x10001
    80005470:	4398                	lw	a4,0(a5)
    80005472:	2701                	sext.w	a4,a4
    80005474:	747277b7          	lui	a5,0x74727
    80005478:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000547c:	14f71c63          	bne	a4,a5,800055d4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005480:	100017b7          	lui	a5,0x10001
    80005484:	43dc                	lw	a5,4(a5)
    80005486:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005488:	4709                	li	a4,2
    8000548a:	14e79563          	bne	a5,a4,800055d4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000548e:	100017b7          	lui	a5,0x10001
    80005492:	479c                	lw	a5,8(a5)
    80005494:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005496:	12e79f63          	bne	a5,a4,800055d4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000549a:	100017b7          	lui	a5,0x10001
    8000549e:	47d8                	lw	a4,12(a5)
    800054a0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054a2:	554d47b7          	lui	a5,0x554d4
    800054a6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054aa:	12f71563          	bne	a4,a5,800055d4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ae:	100017b7          	lui	a5,0x10001
    800054b2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b6:	4705                	li	a4,1
    800054b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ba:	470d                	li	a4,3
    800054bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054be:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054c0:	c7ffe737          	lui	a4,0xc7ffe
    800054c4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc7af>
    800054c8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054ca:	2701                	sext.w	a4,a4
    800054cc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ce:	472d                	li	a4,11
    800054d0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054d2:	5bbc                	lw	a5,112(a5)
    800054d4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054d8:	8ba1                	andi	a5,a5,8
    800054da:	10078563          	beqz	a5,800055e4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054de:	100017b7          	lui	a5,0x10001
    800054e2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054e6:	43fc                	lw	a5,68(a5)
    800054e8:	2781                	sext.w	a5,a5
    800054ea:	10079563          	bnez	a5,800055f4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054ee:	100017b7          	lui	a5,0x10001
    800054f2:	5bdc                	lw	a5,52(a5)
    800054f4:	2781                	sext.w	a5,a5
  if(max == 0)
    800054f6:	10078763          	beqz	a5,80005604 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800054fa:	471d                	li	a4,7
    800054fc:	10f77c63          	bgeu	a4,a5,80005614 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005500:	ffffb097          	auipc	ra,0xffffb
    80005504:	c18080e7          	jalr	-1000(ra) # 80000118 <kalloc>
    80005508:	00014497          	auipc	s1,0x14
    8000550c:	72848493          	addi	s1,s1,1832 # 80019c30 <disk>
    80005510:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005512:	ffffb097          	auipc	ra,0xffffb
    80005516:	c06080e7          	jalr	-1018(ra) # 80000118 <kalloc>
    8000551a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000551c:	ffffb097          	auipc	ra,0xffffb
    80005520:	bfc080e7          	jalr	-1028(ra) # 80000118 <kalloc>
    80005524:	87aa                	mv	a5,a0
    80005526:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005528:	6088                	ld	a0,0(s1)
    8000552a:	cd6d                	beqz	a0,80005624 <virtio_disk_init+0x1dc>
    8000552c:	00014717          	auipc	a4,0x14
    80005530:	70c73703          	ld	a4,1804(a4) # 80019c38 <disk+0x8>
    80005534:	cb65                	beqz	a4,80005624 <virtio_disk_init+0x1dc>
    80005536:	c7fd                	beqz	a5,80005624 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005538:	6605                	lui	a2,0x1
    8000553a:	4581                	li	a1,0
    8000553c:	ffffb097          	auipc	ra,0xffffb
    80005540:	c3c080e7          	jalr	-964(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005544:	00014497          	auipc	s1,0x14
    80005548:	6ec48493          	addi	s1,s1,1772 # 80019c30 <disk>
    8000554c:	6605                	lui	a2,0x1
    8000554e:	4581                	li	a1,0
    80005550:	6488                	ld	a0,8(s1)
    80005552:	ffffb097          	auipc	ra,0xffffb
    80005556:	c26080e7          	jalr	-986(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000555a:	6605                	lui	a2,0x1
    8000555c:	4581                	li	a1,0
    8000555e:	6888                	ld	a0,16(s1)
    80005560:	ffffb097          	auipc	ra,0xffffb
    80005564:	c18080e7          	jalr	-1000(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005568:	100017b7          	lui	a5,0x10001
    8000556c:	4721                	li	a4,8
    8000556e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005570:	4098                	lw	a4,0(s1)
    80005572:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005576:	40d8                	lw	a4,4(s1)
    80005578:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000557c:	6498                	ld	a4,8(s1)
    8000557e:	0007069b          	sext.w	a3,a4
    80005582:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005586:	9701                	srai	a4,a4,0x20
    80005588:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000558c:	6898                	ld	a4,16(s1)
    8000558e:	0007069b          	sext.w	a3,a4
    80005592:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005596:	9701                	srai	a4,a4,0x20
    80005598:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000559c:	4705                	li	a4,1
    8000559e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055a0:	00e48c23          	sb	a4,24(s1)
    800055a4:	00e48ca3          	sb	a4,25(s1)
    800055a8:	00e48d23          	sb	a4,26(s1)
    800055ac:	00e48da3          	sb	a4,27(s1)
    800055b0:	00e48e23          	sb	a4,28(s1)
    800055b4:	00e48ea3          	sb	a4,29(s1)
    800055b8:	00e48f23          	sb	a4,30(s1)
    800055bc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055c0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c4:	0727a823          	sw	s2,112(a5)
}
    800055c8:	60e2                	ld	ra,24(sp)
    800055ca:	6442                	ld	s0,16(sp)
    800055cc:	64a2                	ld	s1,8(sp)
    800055ce:	6902                	ld	s2,0(sp)
    800055d0:	6105                	addi	sp,sp,32
    800055d2:	8082                	ret
    panic("could not find virtio disk");
    800055d4:	00003517          	auipc	a0,0x3
    800055d8:	19450513          	addi	a0,a0,404 # 80008768 <syscalls+0x368>
    800055dc:	00001097          	auipc	ra,0x1
    800055e0:	862080e7          	jalr	-1950(ra) # 80005e3e <panic>
    panic("virtio disk FEATURES_OK unset");
    800055e4:	00003517          	auipc	a0,0x3
    800055e8:	1a450513          	addi	a0,a0,420 # 80008788 <syscalls+0x388>
    800055ec:	00001097          	auipc	ra,0x1
    800055f0:	852080e7          	jalr	-1966(ra) # 80005e3e <panic>
    panic("virtio disk should not be ready");
    800055f4:	00003517          	auipc	a0,0x3
    800055f8:	1b450513          	addi	a0,a0,436 # 800087a8 <syscalls+0x3a8>
    800055fc:	00001097          	auipc	ra,0x1
    80005600:	842080e7          	jalr	-1982(ra) # 80005e3e <panic>
    panic("virtio disk has no queue 0");
    80005604:	00003517          	auipc	a0,0x3
    80005608:	1c450513          	addi	a0,a0,452 # 800087c8 <syscalls+0x3c8>
    8000560c:	00001097          	auipc	ra,0x1
    80005610:	832080e7          	jalr	-1998(ra) # 80005e3e <panic>
    panic("virtio disk max queue too short");
    80005614:	00003517          	auipc	a0,0x3
    80005618:	1d450513          	addi	a0,a0,468 # 800087e8 <syscalls+0x3e8>
    8000561c:	00001097          	auipc	ra,0x1
    80005620:	822080e7          	jalr	-2014(ra) # 80005e3e <panic>
    panic("virtio disk kalloc");
    80005624:	00003517          	auipc	a0,0x3
    80005628:	1e450513          	addi	a0,a0,484 # 80008808 <syscalls+0x408>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	812080e7          	jalr	-2030(ra) # 80005e3e <panic>

0000000080005634 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005634:	7119                	addi	sp,sp,-128
    80005636:	fc86                	sd	ra,120(sp)
    80005638:	f8a2                	sd	s0,112(sp)
    8000563a:	f4a6                	sd	s1,104(sp)
    8000563c:	f0ca                	sd	s2,96(sp)
    8000563e:	ecce                	sd	s3,88(sp)
    80005640:	e8d2                	sd	s4,80(sp)
    80005642:	e4d6                	sd	s5,72(sp)
    80005644:	e0da                	sd	s6,64(sp)
    80005646:	fc5e                	sd	s7,56(sp)
    80005648:	f862                	sd	s8,48(sp)
    8000564a:	f466                	sd	s9,40(sp)
    8000564c:	f06a                	sd	s10,32(sp)
    8000564e:	ec6e                	sd	s11,24(sp)
    80005650:	0100                	addi	s0,sp,128
    80005652:	8aaa                	mv	s5,a0
    80005654:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005656:	00c52d03          	lw	s10,12(a0)
    8000565a:	001d1d1b          	slliw	s10,s10,0x1
    8000565e:	1d02                	slli	s10,s10,0x20
    80005660:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005664:	00014517          	auipc	a0,0x14
    80005668:	6f450513          	addi	a0,a0,1780 # 80019d58 <disk+0x128>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	d0e080e7          	jalr	-754(ra) # 8000637a <acquire>
  for(int i = 0; i < 3; i++){
    80005674:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005676:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005678:	00014b97          	auipc	s7,0x14
    8000567c:	5b8b8b93          	addi	s7,s7,1464 # 80019c30 <disk>
  for(int i = 0; i < 3; i++){
    80005680:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005682:	00014c97          	auipc	s9,0x14
    80005686:	6d6c8c93          	addi	s9,s9,1750 # 80019d58 <disk+0x128>
    8000568a:	a08d                	j	800056ec <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000568c:	00fb8733          	add	a4,s7,a5
    80005690:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005694:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005696:	0207c563          	bltz	a5,800056c0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000569a:	2905                	addiw	s2,s2,1
    8000569c:	0611                	addi	a2,a2,4
    8000569e:	05690c63          	beq	s2,s6,800056f6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800056a2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056a4:	00014717          	auipc	a4,0x14
    800056a8:	58c70713          	addi	a4,a4,1420 # 80019c30 <disk>
    800056ac:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056ae:	01874683          	lbu	a3,24(a4)
    800056b2:	fee9                	bnez	a3,8000568c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056b4:	2785                	addiw	a5,a5,1
    800056b6:	0705                	addi	a4,a4,1
    800056b8:	fe979be3          	bne	a5,s1,800056ae <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056bc:	57fd                	li	a5,-1
    800056be:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056c0:	01205d63          	blez	s2,800056da <virtio_disk_rw+0xa6>
    800056c4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800056c6:	000a2503          	lw	a0,0(s4)
    800056ca:	00000097          	auipc	ra,0x0
    800056ce:	cfc080e7          	jalr	-772(ra) # 800053c6 <free_desc>
      for(int j = 0; j < i; j++)
    800056d2:	2d85                	addiw	s11,s11,1
    800056d4:	0a11                	addi	s4,s4,4
    800056d6:	ffb918e3          	bne	s2,s11,800056c6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056da:	85e6                	mv	a1,s9
    800056dc:	00014517          	auipc	a0,0x14
    800056e0:	56c50513          	addi	a0,a0,1388 # 80019c48 <disk+0x18>
    800056e4:	ffffc097          	auipc	ra,0xffffc
    800056e8:	fa6080e7          	jalr	-90(ra) # 8000168a <sleep>
  for(int i = 0; i < 3; i++){
    800056ec:	f8040a13          	addi	s4,s0,-128
{
    800056f0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800056f2:	894e                	mv	s2,s3
    800056f4:	b77d                	j	800056a2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056f6:	f8042583          	lw	a1,-128(s0)
    800056fa:	00a58793          	addi	a5,a1,10
    800056fe:	0792                	slli	a5,a5,0x4

  if(write)
    80005700:	00014617          	auipc	a2,0x14
    80005704:	53060613          	addi	a2,a2,1328 # 80019c30 <disk>
    80005708:	00f60733          	add	a4,a2,a5
    8000570c:	018036b3          	snez	a3,s8
    80005710:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005712:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005716:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000571a:	f6078693          	addi	a3,a5,-160
    8000571e:	6218                	ld	a4,0(a2)
    80005720:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005722:	00878513          	addi	a0,a5,8
    80005726:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005728:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000572a:	6208                	ld	a0,0(a2)
    8000572c:	96aa                	add	a3,a3,a0
    8000572e:	4741                	li	a4,16
    80005730:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005732:	4705                	li	a4,1
    80005734:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005738:	f8442703          	lw	a4,-124(s0)
    8000573c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005740:	0712                	slli	a4,a4,0x4
    80005742:	953a                	add	a0,a0,a4
    80005744:	058a8693          	addi	a3,s5,88
    80005748:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000574a:	6208                	ld	a0,0(a2)
    8000574c:	972a                	add	a4,a4,a0
    8000574e:	40000693          	li	a3,1024
    80005752:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005754:	001c3c13          	seqz	s8,s8
    80005758:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000575a:	001c6c13          	ori	s8,s8,1
    8000575e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005762:	f8842603          	lw	a2,-120(s0)
    80005766:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000576a:	00014697          	auipc	a3,0x14
    8000576e:	4c668693          	addi	a3,a3,1222 # 80019c30 <disk>
    80005772:	00258713          	addi	a4,a1,2
    80005776:	0712                	slli	a4,a4,0x4
    80005778:	9736                	add	a4,a4,a3
    8000577a:	587d                	li	a6,-1
    8000577c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005780:	0612                	slli	a2,a2,0x4
    80005782:	9532                	add	a0,a0,a2
    80005784:	f9078793          	addi	a5,a5,-112
    80005788:	97b6                	add	a5,a5,a3
    8000578a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000578c:	629c                	ld	a5,0(a3)
    8000578e:	97b2                	add	a5,a5,a2
    80005790:	4605                	li	a2,1
    80005792:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005794:	4509                	li	a0,2
    80005796:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000579a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000579e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800057a2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057a6:	6698                	ld	a4,8(a3)
    800057a8:	00275783          	lhu	a5,2(a4)
    800057ac:	8b9d                	andi	a5,a5,7
    800057ae:	0786                	slli	a5,a5,0x1
    800057b0:	97ba                	add	a5,a5,a4
    800057b2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800057b6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ba:	6698                	ld	a4,8(a3)
    800057bc:	00275783          	lhu	a5,2(a4)
    800057c0:	2785                	addiw	a5,a5,1
    800057c2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057c6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057ca:	100017b7          	lui	a5,0x10001
    800057ce:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057d2:	004aa783          	lw	a5,4(s5)
    800057d6:	02c79163          	bne	a5,a2,800057f8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057da:	00014917          	auipc	s2,0x14
    800057de:	57e90913          	addi	s2,s2,1406 # 80019d58 <disk+0x128>
  while(b->disk == 1) {
    800057e2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057e4:	85ca                	mv	a1,s2
    800057e6:	8556                	mv	a0,s5
    800057e8:	ffffc097          	auipc	ra,0xffffc
    800057ec:	ea2080e7          	jalr	-350(ra) # 8000168a <sleep>
  while(b->disk == 1) {
    800057f0:	004aa783          	lw	a5,4(s5)
    800057f4:	fe9788e3          	beq	a5,s1,800057e4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800057f8:	f8042903          	lw	s2,-128(s0)
    800057fc:	00290793          	addi	a5,s2,2
    80005800:	00479713          	slli	a4,a5,0x4
    80005804:	00014797          	auipc	a5,0x14
    80005808:	42c78793          	addi	a5,a5,1068 # 80019c30 <disk>
    8000580c:	97ba                	add	a5,a5,a4
    8000580e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005812:	00014997          	auipc	s3,0x14
    80005816:	41e98993          	addi	s3,s3,1054 # 80019c30 <disk>
    8000581a:	00491713          	slli	a4,s2,0x4
    8000581e:	0009b783          	ld	a5,0(s3)
    80005822:	97ba                	add	a5,a5,a4
    80005824:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005828:	854a                	mv	a0,s2
    8000582a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000582e:	00000097          	auipc	ra,0x0
    80005832:	b98080e7          	jalr	-1128(ra) # 800053c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005836:	8885                	andi	s1,s1,1
    80005838:	f0ed                	bnez	s1,8000581a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000583a:	00014517          	auipc	a0,0x14
    8000583e:	51e50513          	addi	a0,a0,1310 # 80019d58 <disk+0x128>
    80005842:	00001097          	auipc	ra,0x1
    80005846:	bec080e7          	jalr	-1044(ra) # 8000642e <release>
}
    8000584a:	70e6                	ld	ra,120(sp)
    8000584c:	7446                	ld	s0,112(sp)
    8000584e:	74a6                	ld	s1,104(sp)
    80005850:	7906                	ld	s2,96(sp)
    80005852:	69e6                	ld	s3,88(sp)
    80005854:	6a46                	ld	s4,80(sp)
    80005856:	6aa6                	ld	s5,72(sp)
    80005858:	6b06                	ld	s6,64(sp)
    8000585a:	7be2                	ld	s7,56(sp)
    8000585c:	7c42                	ld	s8,48(sp)
    8000585e:	7ca2                	ld	s9,40(sp)
    80005860:	7d02                	ld	s10,32(sp)
    80005862:	6de2                	ld	s11,24(sp)
    80005864:	6109                	addi	sp,sp,128
    80005866:	8082                	ret

0000000080005868 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005868:	1101                	addi	sp,sp,-32
    8000586a:	ec06                	sd	ra,24(sp)
    8000586c:	e822                	sd	s0,16(sp)
    8000586e:	e426                	sd	s1,8(sp)
    80005870:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005872:	00014497          	auipc	s1,0x14
    80005876:	3be48493          	addi	s1,s1,958 # 80019c30 <disk>
    8000587a:	00014517          	auipc	a0,0x14
    8000587e:	4de50513          	addi	a0,a0,1246 # 80019d58 <disk+0x128>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	af8080e7          	jalr	-1288(ra) # 8000637a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000588a:	10001737          	lui	a4,0x10001
    8000588e:	533c                	lw	a5,96(a4)
    80005890:	8b8d                	andi	a5,a5,3
    80005892:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005894:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005898:	689c                	ld	a5,16(s1)
    8000589a:	0204d703          	lhu	a4,32(s1)
    8000589e:	0027d783          	lhu	a5,2(a5)
    800058a2:	04f70863          	beq	a4,a5,800058f2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058a6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058aa:	6898                	ld	a4,16(s1)
    800058ac:	0204d783          	lhu	a5,32(s1)
    800058b0:	8b9d                	andi	a5,a5,7
    800058b2:	078e                	slli	a5,a5,0x3
    800058b4:	97ba                	add	a5,a5,a4
    800058b6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058b8:	00278713          	addi	a4,a5,2
    800058bc:	0712                	slli	a4,a4,0x4
    800058be:	9726                	add	a4,a4,s1
    800058c0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058c4:	e721                	bnez	a4,8000590c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058c6:	0789                	addi	a5,a5,2
    800058c8:	0792                	slli	a5,a5,0x4
    800058ca:	97a6                	add	a5,a5,s1
    800058cc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058ce:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058d2:	ffffc097          	auipc	ra,0xffffc
    800058d6:	e1c080e7          	jalr	-484(ra) # 800016ee <wakeup>

    disk.used_idx += 1;
    800058da:	0204d783          	lhu	a5,32(s1)
    800058de:	2785                	addiw	a5,a5,1
    800058e0:	17c2                	slli	a5,a5,0x30
    800058e2:	93c1                	srli	a5,a5,0x30
    800058e4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058e8:	6898                	ld	a4,16(s1)
    800058ea:	00275703          	lhu	a4,2(a4)
    800058ee:	faf71ce3          	bne	a4,a5,800058a6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058f2:	00014517          	auipc	a0,0x14
    800058f6:	46650513          	addi	a0,a0,1126 # 80019d58 <disk+0x128>
    800058fa:	00001097          	auipc	ra,0x1
    800058fe:	b34080e7          	jalr	-1228(ra) # 8000642e <release>
}
    80005902:	60e2                	ld	ra,24(sp)
    80005904:	6442                	ld	s0,16(sp)
    80005906:	64a2                	ld	s1,8(sp)
    80005908:	6105                	addi	sp,sp,32
    8000590a:	8082                	ret
      panic("virtio_disk_intr status");
    8000590c:	00003517          	auipc	a0,0x3
    80005910:	f1450513          	addi	a0,a0,-236 # 80008820 <syscalls+0x420>
    80005914:	00000097          	auipc	ra,0x0
    80005918:	52a080e7          	jalr	1322(ra) # 80005e3e <panic>

000000008000591c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000591c:	1141                	addi	sp,sp,-16
    8000591e:	e422                	sd	s0,8(sp)
    80005920:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005922:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005926:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000592a:	0037979b          	slliw	a5,a5,0x3
    8000592e:	02004737          	lui	a4,0x2004
    80005932:	97ba                	add	a5,a5,a4
    80005934:	0200c737          	lui	a4,0x200c
    80005938:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000593c:	000f4637          	lui	a2,0xf4
    80005940:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005944:	95b2                	add	a1,a1,a2
    80005946:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005948:	00269713          	slli	a4,a3,0x2
    8000594c:	9736                	add	a4,a4,a3
    8000594e:	00371693          	slli	a3,a4,0x3
    80005952:	00014717          	auipc	a4,0x14
    80005956:	41e70713          	addi	a4,a4,1054 # 80019d70 <timer_scratch>
    8000595a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000595c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000595e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005960:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005964:	00000797          	auipc	a5,0x0
    80005968:	99c78793          	addi	a5,a5,-1636 # 80005300 <timervec>
    8000596c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005970:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005974:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005978:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000597c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005980:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005984:	30479073          	csrw	mie,a5
}
    80005988:	6422                	ld	s0,8(sp)
    8000598a:	0141                	addi	sp,sp,16
    8000598c:	8082                	ret

000000008000598e <start>:
{
    8000598e:	1141                	addi	sp,sp,-16
    80005990:	e406                	sd	ra,8(sp)
    80005992:	e022                	sd	s0,0(sp)
    80005994:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005996:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000599a:	7779                	lui	a4,0xffffe
    8000599c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc84f>
    800059a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059a2:	6705                	lui	a4,0x1
    800059a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059ae:	ffffb797          	auipc	a5,0xffffb
    800059b2:	97078793          	addi	a5,a5,-1680 # 8000031e <main>
    800059b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059ba:	4781                	li	a5,0
    800059bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059c0:	67c1                	lui	a5,0x10
    800059c2:	17fd                	addi	a5,a5,-1
    800059c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059d8:	57fd                	li	a5,-1
    800059da:	83a9                	srli	a5,a5,0xa
    800059dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059e0:	47bd                	li	a5,15
    800059e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	f36080e7          	jalr	-202(ra) # 8000591c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059f2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800059f6:	30200073          	mret
}
    800059fa:	60a2                	ld	ra,8(sp)
    800059fc:	6402                	ld	s0,0(sp)
    800059fe:	0141                	addi	sp,sp,16
    80005a00:	8082                	ret

0000000080005a02 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a02:	715d                	addi	sp,sp,-80
    80005a04:	e486                	sd	ra,72(sp)
    80005a06:	e0a2                	sd	s0,64(sp)
    80005a08:	fc26                	sd	s1,56(sp)
    80005a0a:	f84a                	sd	s2,48(sp)
    80005a0c:	f44e                	sd	s3,40(sp)
    80005a0e:	f052                	sd	s4,32(sp)
    80005a10:	ec56                	sd	s5,24(sp)
    80005a12:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a14:	04c05663          	blez	a2,80005a60 <consolewrite+0x5e>
    80005a18:	8a2a                	mv	s4,a0
    80005a1a:	84ae                	mv	s1,a1
    80005a1c:	89b2                	mv	s3,a2
    80005a1e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a20:	5afd                	li	s5,-1
    80005a22:	4685                	li	a3,1
    80005a24:	8626                	mv	a2,s1
    80005a26:	85d2                	mv	a1,s4
    80005a28:	fbf40513          	addi	a0,s0,-65
    80005a2c:	ffffc097          	auipc	ra,0xffffc
    80005a30:	0bc080e7          	jalr	188(ra) # 80001ae8 <either_copyin>
    80005a34:	01550c63          	beq	a0,s5,80005a4c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a38:	fbf44503          	lbu	a0,-65(s0)
    80005a3c:	00000097          	auipc	ra,0x0
    80005a40:	780080e7          	jalr	1920(ra) # 800061bc <uartputc>
  for(i = 0; i < n; i++){
    80005a44:	2905                	addiw	s2,s2,1
    80005a46:	0485                	addi	s1,s1,1
    80005a48:	fd299de3          	bne	s3,s2,80005a22 <consolewrite+0x20>
  }

  return i;
}
    80005a4c:	854a                	mv	a0,s2
    80005a4e:	60a6                	ld	ra,72(sp)
    80005a50:	6406                	ld	s0,64(sp)
    80005a52:	74e2                	ld	s1,56(sp)
    80005a54:	7942                	ld	s2,48(sp)
    80005a56:	79a2                	ld	s3,40(sp)
    80005a58:	7a02                	ld	s4,32(sp)
    80005a5a:	6ae2                	ld	s5,24(sp)
    80005a5c:	6161                	addi	sp,sp,80
    80005a5e:	8082                	ret
  for(i = 0; i < n; i++){
    80005a60:	4901                	li	s2,0
    80005a62:	b7ed                	j	80005a4c <consolewrite+0x4a>

0000000080005a64 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a64:	7159                	addi	sp,sp,-112
    80005a66:	f486                	sd	ra,104(sp)
    80005a68:	f0a2                	sd	s0,96(sp)
    80005a6a:	eca6                	sd	s1,88(sp)
    80005a6c:	e8ca                	sd	s2,80(sp)
    80005a6e:	e4ce                	sd	s3,72(sp)
    80005a70:	e0d2                	sd	s4,64(sp)
    80005a72:	fc56                	sd	s5,56(sp)
    80005a74:	f85a                	sd	s6,48(sp)
    80005a76:	f45e                	sd	s7,40(sp)
    80005a78:	f062                	sd	s8,32(sp)
    80005a7a:	ec66                	sd	s9,24(sp)
    80005a7c:	e86a                	sd	s10,16(sp)
    80005a7e:	1880                	addi	s0,sp,112
    80005a80:	8aaa                	mv	s5,a0
    80005a82:	8a2e                	mv	s4,a1
    80005a84:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a86:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a8a:	0001c517          	auipc	a0,0x1c
    80005a8e:	42650513          	addi	a0,a0,1062 # 80021eb0 <cons>
    80005a92:	00001097          	auipc	ra,0x1
    80005a96:	8e8080e7          	jalr	-1816(ra) # 8000637a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a9a:	0001c497          	auipc	s1,0x1c
    80005a9e:	41648493          	addi	s1,s1,1046 # 80021eb0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005aa2:	0001c917          	auipc	s2,0x1c
    80005aa6:	4a690913          	addi	s2,s2,1190 # 80021f48 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005aaa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005aae:	4ca9                	li	s9,10
  while(n > 0){
    80005ab0:	07305b63          	blez	s3,80005b26 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005ab4:	0984a783          	lw	a5,152(s1)
    80005ab8:	09c4a703          	lw	a4,156(s1)
    80005abc:	02f71763          	bne	a4,a5,80005aea <consoleread+0x86>
      if(killed(myproc())){
    80005ac0:	ffffb097          	auipc	ra,0xffffb
    80005ac4:	474080e7          	jalr	1140(ra) # 80000f34 <myproc>
    80005ac8:	ffffc097          	auipc	ra,0xffffc
    80005acc:	e6a080e7          	jalr	-406(ra) # 80001932 <killed>
    80005ad0:	e535                	bnez	a0,80005b3c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005ad2:	85a6                	mv	a1,s1
    80005ad4:	854a                	mv	a0,s2
    80005ad6:	ffffc097          	auipc	ra,0xffffc
    80005ada:	bb4080e7          	jalr	-1100(ra) # 8000168a <sleep>
    while(cons.r == cons.w){
    80005ade:	0984a783          	lw	a5,152(s1)
    80005ae2:	09c4a703          	lw	a4,156(s1)
    80005ae6:	fcf70de3          	beq	a4,a5,80005ac0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005aea:	0017871b          	addiw	a4,a5,1
    80005aee:	08e4ac23          	sw	a4,152(s1)
    80005af2:	07f7f713          	andi	a4,a5,127
    80005af6:	9726                	add	a4,a4,s1
    80005af8:	01874703          	lbu	a4,24(a4)
    80005afc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005b00:	077d0563          	beq	s10,s7,80005b6a <consoleread+0x106>
    cbuf = c;
    80005b04:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b08:	4685                	li	a3,1
    80005b0a:	f9f40613          	addi	a2,s0,-97
    80005b0e:	85d2                	mv	a1,s4
    80005b10:	8556                	mv	a0,s5
    80005b12:	ffffc097          	auipc	ra,0xffffc
    80005b16:	f80080e7          	jalr	-128(ra) # 80001a92 <either_copyout>
    80005b1a:	01850663          	beq	a0,s8,80005b26 <consoleread+0xc2>
    dst++;
    80005b1e:	0a05                	addi	s4,s4,1
    --n;
    80005b20:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005b22:	f99d17e3          	bne	s10,s9,80005ab0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b26:	0001c517          	auipc	a0,0x1c
    80005b2a:	38a50513          	addi	a0,a0,906 # 80021eb0 <cons>
    80005b2e:	00001097          	auipc	ra,0x1
    80005b32:	900080e7          	jalr	-1792(ra) # 8000642e <release>

  return target - n;
    80005b36:	413b053b          	subw	a0,s6,s3
    80005b3a:	a811                	j	80005b4e <consoleread+0xea>
        release(&cons.lock);
    80005b3c:	0001c517          	auipc	a0,0x1c
    80005b40:	37450513          	addi	a0,a0,884 # 80021eb0 <cons>
    80005b44:	00001097          	auipc	ra,0x1
    80005b48:	8ea080e7          	jalr	-1814(ra) # 8000642e <release>
        return -1;
    80005b4c:	557d                	li	a0,-1
}
    80005b4e:	70a6                	ld	ra,104(sp)
    80005b50:	7406                	ld	s0,96(sp)
    80005b52:	64e6                	ld	s1,88(sp)
    80005b54:	6946                	ld	s2,80(sp)
    80005b56:	69a6                	ld	s3,72(sp)
    80005b58:	6a06                	ld	s4,64(sp)
    80005b5a:	7ae2                	ld	s5,56(sp)
    80005b5c:	7b42                	ld	s6,48(sp)
    80005b5e:	7ba2                	ld	s7,40(sp)
    80005b60:	7c02                	ld	s8,32(sp)
    80005b62:	6ce2                	ld	s9,24(sp)
    80005b64:	6d42                	ld	s10,16(sp)
    80005b66:	6165                	addi	sp,sp,112
    80005b68:	8082                	ret
      if(n < target){
    80005b6a:	0009871b          	sext.w	a4,s3
    80005b6e:	fb677ce3          	bgeu	a4,s6,80005b26 <consoleread+0xc2>
        cons.r--;
    80005b72:	0001c717          	auipc	a4,0x1c
    80005b76:	3cf72b23          	sw	a5,982(a4) # 80021f48 <cons+0x98>
    80005b7a:	b775                	j	80005b26 <consoleread+0xc2>

0000000080005b7c <consputc>:
{
    80005b7c:	1141                	addi	sp,sp,-16
    80005b7e:	e406                	sd	ra,8(sp)
    80005b80:	e022                	sd	s0,0(sp)
    80005b82:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b84:	10000793          	li	a5,256
    80005b88:	00f50a63          	beq	a0,a5,80005b9c <consputc+0x20>
    uartputc_sync(c);
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	55e080e7          	jalr	1374(ra) # 800060ea <uartputc_sync>
}
    80005b94:	60a2                	ld	ra,8(sp)
    80005b96:	6402                	ld	s0,0(sp)
    80005b98:	0141                	addi	sp,sp,16
    80005b9a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b9c:	4521                	li	a0,8
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	54c080e7          	jalr	1356(ra) # 800060ea <uartputc_sync>
    80005ba6:	02000513          	li	a0,32
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	540080e7          	jalr	1344(ra) # 800060ea <uartputc_sync>
    80005bb2:	4521                	li	a0,8
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	536080e7          	jalr	1334(ra) # 800060ea <uartputc_sync>
    80005bbc:	bfe1                	j	80005b94 <consputc+0x18>

0000000080005bbe <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bbe:	1101                	addi	sp,sp,-32
    80005bc0:	ec06                	sd	ra,24(sp)
    80005bc2:	e822                	sd	s0,16(sp)
    80005bc4:	e426                	sd	s1,8(sp)
    80005bc6:	e04a                	sd	s2,0(sp)
    80005bc8:	1000                	addi	s0,sp,32
    80005bca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bcc:	0001c517          	auipc	a0,0x1c
    80005bd0:	2e450513          	addi	a0,a0,740 # 80021eb0 <cons>
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	7a6080e7          	jalr	1958(ra) # 8000637a <acquire>

  switch(c){
    80005bdc:	47d5                	li	a5,21
    80005bde:	0af48663          	beq	s1,a5,80005c8a <consoleintr+0xcc>
    80005be2:	0297ca63          	blt	a5,s1,80005c16 <consoleintr+0x58>
    80005be6:	47a1                	li	a5,8
    80005be8:	0ef48763          	beq	s1,a5,80005cd6 <consoleintr+0x118>
    80005bec:	47c1                	li	a5,16
    80005bee:	10f49a63          	bne	s1,a5,80005d02 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bf2:	ffffc097          	auipc	ra,0xffffc
    80005bf6:	f4c080e7          	jalr	-180(ra) # 80001b3e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bfa:	0001c517          	auipc	a0,0x1c
    80005bfe:	2b650513          	addi	a0,a0,694 # 80021eb0 <cons>
    80005c02:	00001097          	auipc	ra,0x1
    80005c06:	82c080e7          	jalr	-2004(ra) # 8000642e <release>
}
    80005c0a:	60e2                	ld	ra,24(sp)
    80005c0c:	6442                	ld	s0,16(sp)
    80005c0e:	64a2                	ld	s1,8(sp)
    80005c10:	6902                	ld	s2,0(sp)
    80005c12:	6105                	addi	sp,sp,32
    80005c14:	8082                	ret
  switch(c){
    80005c16:	07f00793          	li	a5,127
    80005c1a:	0af48e63          	beq	s1,a5,80005cd6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c1e:	0001c717          	auipc	a4,0x1c
    80005c22:	29270713          	addi	a4,a4,658 # 80021eb0 <cons>
    80005c26:	0a072783          	lw	a5,160(a4)
    80005c2a:	09872703          	lw	a4,152(a4)
    80005c2e:	9f99                	subw	a5,a5,a4
    80005c30:	07f00713          	li	a4,127
    80005c34:	fcf763e3          	bltu	a4,a5,80005bfa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c38:	47b5                	li	a5,13
    80005c3a:	0cf48763          	beq	s1,a5,80005d08 <consoleintr+0x14a>
      consputc(c);
    80005c3e:	8526                	mv	a0,s1
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	f3c080e7          	jalr	-196(ra) # 80005b7c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c48:	0001c797          	auipc	a5,0x1c
    80005c4c:	26878793          	addi	a5,a5,616 # 80021eb0 <cons>
    80005c50:	0a07a683          	lw	a3,160(a5)
    80005c54:	0016871b          	addiw	a4,a3,1
    80005c58:	0007061b          	sext.w	a2,a4
    80005c5c:	0ae7a023          	sw	a4,160(a5)
    80005c60:	07f6f693          	andi	a3,a3,127
    80005c64:	97b6                	add	a5,a5,a3
    80005c66:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c6a:	47a9                	li	a5,10
    80005c6c:	0cf48563          	beq	s1,a5,80005d36 <consoleintr+0x178>
    80005c70:	4791                	li	a5,4
    80005c72:	0cf48263          	beq	s1,a5,80005d36 <consoleintr+0x178>
    80005c76:	0001c797          	auipc	a5,0x1c
    80005c7a:	2d27a783          	lw	a5,722(a5) # 80021f48 <cons+0x98>
    80005c7e:	9f1d                	subw	a4,a4,a5
    80005c80:	08000793          	li	a5,128
    80005c84:	f6f71be3          	bne	a4,a5,80005bfa <consoleintr+0x3c>
    80005c88:	a07d                	j	80005d36 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c8a:	0001c717          	auipc	a4,0x1c
    80005c8e:	22670713          	addi	a4,a4,550 # 80021eb0 <cons>
    80005c92:	0a072783          	lw	a5,160(a4)
    80005c96:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c9a:	0001c497          	auipc	s1,0x1c
    80005c9e:	21648493          	addi	s1,s1,534 # 80021eb0 <cons>
    while(cons.e != cons.w &&
    80005ca2:	4929                	li	s2,10
    80005ca4:	f4f70be3          	beq	a4,a5,80005bfa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ca8:	37fd                	addiw	a5,a5,-1
    80005caa:	07f7f713          	andi	a4,a5,127
    80005cae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cb0:	01874703          	lbu	a4,24(a4)
    80005cb4:	f52703e3          	beq	a4,s2,80005bfa <consoleintr+0x3c>
      cons.e--;
    80005cb8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cbc:	10000513          	li	a0,256
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	ebc080e7          	jalr	-324(ra) # 80005b7c <consputc>
    while(cons.e != cons.w &&
    80005cc8:	0a04a783          	lw	a5,160(s1)
    80005ccc:	09c4a703          	lw	a4,156(s1)
    80005cd0:	fcf71ce3          	bne	a4,a5,80005ca8 <consoleintr+0xea>
    80005cd4:	b71d                	j	80005bfa <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cd6:	0001c717          	auipc	a4,0x1c
    80005cda:	1da70713          	addi	a4,a4,474 # 80021eb0 <cons>
    80005cde:	0a072783          	lw	a5,160(a4)
    80005ce2:	09c72703          	lw	a4,156(a4)
    80005ce6:	f0f70ae3          	beq	a4,a5,80005bfa <consoleintr+0x3c>
      cons.e--;
    80005cea:	37fd                	addiw	a5,a5,-1
    80005cec:	0001c717          	auipc	a4,0x1c
    80005cf0:	26f72223          	sw	a5,612(a4) # 80021f50 <cons+0xa0>
      consputc(BACKSPACE);
    80005cf4:	10000513          	li	a0,256
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	e84080e7          	jalr	-380(ra) # 80005b7c <consputc>
    80005d00:	bded                	j	80005bfa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d02:	ee048ce3          	beqz	s1,80005bfa <consoleintr+0x3c>
    80005d06:	bf21                	j	80005c1e <consoleintr+0x60>
      consputc(c);
    80005d08:	4529                	li	a0,10
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	e72080e7          	jalr	-398(ra) # 80005b7c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d12:	0001c797          	auipc	a5,0x1c
    80005d16:	19e78793          	addi	a5,a5,414 # 80021eb0 <cons>
    80005d1a:	0a07a703          	lw	a4,160(a5)
    80005d1e:	0017069b          	addiw	a3,a4,1
    80005d22:	0006861b          	sext.w	a2,a3
    80005d26:	0ad7a023          	sw	a3,160(a5)
    80005d2a:	07f77713          	andi	a4,a4,127
    80005d2e:	97ba                	add	a5,a5,a4
    80005d30:	4729                	li	a4,10
    80005d32:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d36:	0001c797          	auipc	a5,0x1c
    80005d3a:	20c7ab23          	sw	a2,534(a5) # 80021f4c <cons+0x9c>
        wakeup(&cons.r);
    80005d3e:	0001c517          	auipc	a0,0x1c
    80005d42:	20a50513          	addi	a0,a0,522 # 80021f48 <cons+0x98>
    80005d46:	ffffc097          	auipc	ra,0xffffc
    80005d4a:	9a8080e7          	jalr	-1624(ra) # 800016ee <wakeup>
    80005d4e:	b575                	j	80005bfa <consoleintr+0x3c>

0000000080005d50 <consoleinit>:

void
consoleinit(void)
{
    80005d50:	1141                	addi	sp,sp,-16
    80005d52:	e406                	sd	ra,8(sp)
    80005d54:	e022                	sd	s0,0(sp)
    80005d56:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d58:	00003597          	auipc	a1,0x3
    80005d5c:	ae058593          	addi	a1,a1,-1312 # 80008838 <syscalls+0x438>
    80005d60:	0001c517          	auipc	a0,0x1c
    80005d64:	15050513          	addi	a0,a0,336 # 80021eb0 <cons>
    80005d68:	00000097          	auipc	ra,0x0
    80005d6c:	582080e7          	jalr	1410(ra) # 800062ea <initlock>

  uartinit();
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	32a080e7          	jalr	810(ra) # 8000609a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d78:	00013797          	auipc	a5,0x13
    80005d7c:	e6078793          	addi	a5,a5,-416 # 80018bd8 <devsw>
    80005d80:	00000717          	auipc	a4,0x0
    80005d84:	ce470713          	addi	a4,a4,-796 # 80005a64 <consoleread>
    80005d88:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d8a:	00000717          	auipc	a4,0x0
    80005d8e:	c7870713          	addi	a4,a4,-904 # 80005a02 <consolewrite>
    80005d92:	ef98                	sd	a4,24(a5)
}
    80005d94:	60a2                	ld	ra,8(sp)
    80005d96:	6402                	ld	s0,0(sp)
    80005d98:	0141                	addi	sp,sp,16
    80005d9a:	8082                	ret

0000000080005d9c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d9c:	7179                	addi	sp,sp,-48
    80005d9e:	f406                	sd	ra,40(sp)
    80005da0:	f022                	sd	s0,32(sp)
    80005da2:	ec26                	sd	s1,24(sp)
    80005da4:	e84a                	sd	s2,16(sp)
    80005da6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005da8:	c219                	beqz	a2,80005dae <printint+0x12>
    80005daa:	08054663          	bltz	a0,80005e36 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005dae:	2501                	sext.w	a0,a0
    80005db0:	4881                	li	a7,0
    80005db2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005db6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005db8:	2581                	sext.w	a1,a1
    80005dba:	00003617          	auipc	a2,0x3
    80005dbe:	aae60613          	addi	a2,a2,-1362 # 80008868 <digits>
    80005dc2:	883a                	mv	a6,a4
    80005dc4:	2705                	addiw	a4,a4,1
    80005dc6:	02b577bb          	remuw	a5,a0,a1
    80005dca:	1782                	slli	a5,a5,0x20
    80005dcc:	9381                	srli	a5,a5,0x20
    80005dce:	97b2                	add	a5,a5,a2
    80005dd0:	0007c783          	lbu	a5,0(a5)
    80005dd4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dd8:	0005079b          	sext.w	a5,a0
    80005ddc:	02b5553b          	divuw	a0,a0,a1
    80005de0:	0685                	addi	a3,a3,1
    80005de2:	feb7f0e3          	bgeu	a5,a1,80005dc2 <printint+0x26>

  if(sign)
    80005de6:	00088b63          	beqz	a7,80005dfc <printint+0x60>
    buf[i++] = '-';
    80005dea:	fe040793          	addi	a5,s0,-32
    80005dee:	973e                	add	a4,a4,a5
    80005df0:	02d00793          	li	a5,45
    80005df4:	fef70823          	sb	a5,-16(a4)
    80005df8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005dfc:	02e05763          	blez	a4,80005e2a <printint+0x8e>
    80005e00:	fd040793          	addi	a5,s0,-48
    80005e04:	00e784b3          	add	s1,a5,a4
    80005e08:	fff78913          	addi	s2,a5,-1
    80005e0c:	993a                	add	s2,s2,a4
    80005e0e:	377d                	addiw	a4,a4,-1
    80005e10:	1702                	slli	a4,a4,0x20
    80005e12:	9301                	srli	a4,a4,0x20
    80005e14:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e18:	fff4c503          	lbu	a0,-1(s1)
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	d60080e7          	jalr	-672(ra) # 80005b7c <consputc>
  while(--i >= 0)
    80005e24:	14fd                	addi	s1,s1,-1
    80005e26:	ff2499e3          	bne	s1,s2,80005e18 <printint+0x7c>
}
    80005e2a:	70a2                	ld	ra,40(sp)
    80005e2c:	7402                	ld	s0,32(sp)
    80005e2e:	64e2                	ld	s1,24(sp)
    80005e30:	6942                	ld	s2,16(sp)
    80005e32:	6145                	addi	sp,sp,48
    80005e34:	8082                	ret
    x = -xx;
    80005e36:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e3a:	4885                	li	a7,1
    x = -xx;
    80005e3c:	bf9d                	j	80005db2 <printint+0x16>

0000000080005e3e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e3e:	1101                	addi	sp,sp,-32
    80005e40:	ec06                	sd	ra,24(sp)
    80005e42:	e822                	sd	s0,16(sp)
    80005e44:	e426                	sd	s1,8(sp)
    80005e46:	1000                	addi	s0,sp,32
    80005e48:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e4a:	0001c797          	auipc	a5,0x1c
    80005e4e:	1207a323          	sw	zero,294(a5) # 80021f70 <pr+0x18>
  printf("panic: ");
    80005e52:	00003517          	auipc	a0,0x3
    80005e56:	9ee50513          	addi	a0,a0,-1554 # 80008840 <syscalls+0x440>
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	02e080e7          	jalr	46(ra) # 80005e88 <printf>
  printf(s);
    80005e62:	8526                	mv	a0,s1
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	024080e7          	jalr	36(ra) # 80005e88 <printf>
  printf("\n");
    80005e6c:	00002517          	auipc	a0,0x2
    80005e70:	1dc50513          	addi	a0,a0,476 # 80008048 <etext+0x48>
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	014080e7          	jalr	20(ra) # 80005e88 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e7c:	4785                	li	a5,1
    80005e7e:	00003717          	auipc	a4,0x3
    80005e82:	aaf72723          	sw	a5,-1362(a4) # 8000892c <panicked>
  for(;;)
    80005e86:	a001                	j	80005e86 <panic+0x48>

0000000080005e88 <printf>:
{
    80005e88:	7131                	addi	sp,sp,-192
    80005e8a:	fc86                	sd	ra,120(sp)
    80005e8c:	f8a2                	sd	s0,112(sp)
    80005e8e:	f4a6                	sd	s1,104(sp)
    80005e90:	f0ca                	sd	s2,96(sp)
    80005e92:	ecce                	sd	s3,88(sp)
    80005e94:	e8d2                	sd	s4,80(sp)
    80005e96:	e4d6                	sd	s5,72(sp)
    80005e98:	e0da                	sd	s6,64(sp)
    80005e9a:	fc5e                	sd	s7,56(sp)
    80005e9c:	f862                	sd	s8,48(sp)
    80005e9e:	f466                	sd	s9,40(sp)
    80005ea0:	f06a                	sd	s10,32(sp)
    80005ea2:	ec6e                	sd	s11,24(sp)
    80005ea4:	0100                	addi	s0,sp,128
    80005ea6:	8a2a                	mv	s4,a0
    80005ea8:	e40c                	sd	a1,8(s0)
    80005eaa:	e810                	sd	a2,16(s0)
    80005eac:	ec14                	sd	a3,24(s0)
    80005eae:	f018                	sd	a4,32(s0)
    80005eb0:	f41c                	sd	a5,40(s0)
    80005eb2:	03043823          	sd	a6,48(s0)
    80005eb6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005eba:	0001cd97          	auipc	s11,0x1c
    80005ebe:	0b6dad83          	lw	s11,182(s11) # 80021f70 <pr+0x18>
  if(locking)
    80005ec2:	020d9b63          	bnez	s11,80005ef8 <printf+0x70>
  if (fmt == 0)
    80005ec6:	040a0263          	beqz	s4,80005f0a <printf+0x82>
  va_start(ap, fmt);
    80005eca:	00840793          	addi	a5,s0,8
    80005ece:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ed2:	000a4503          	lbu	a0,0(s4)
    80005ed6:	14050f63          	beqz	a0,80006034 <printf+0x1ac>
    80005eda:	4981                	li	s3,0
    if(c != '%'){
    80005edc:	02500a93          	li	s5,37
    switch(c){
    80005ee0:	07000b93          	li	s7,112
  consputc('x');
    80005ee4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ee6:	00003b17          	auipc	s6,0x3
    80005eea:	982b0b13          	addi	s6,s6,-1662 # 80008868 <digits>
    switch(c){
    80005eee:	07300c93          	li	s9,115
    80005ef2:	06400c13          	li	s8,100
    80005ef6:	a82d                	j	80005f30 <printf+0xa8>
    acquire(&pr.lock);
    80005ef8:	0001c517          	auipc	a0,0x1c
    80005efc:	06050513          	addi	a0,a0,96 # 80021f58 <pr>
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	47a080e7          	jalr	1146(ra) # 8000637a <acquire>
    80005f08:	bf7d                	j	80005ec6 <printf+0x3e>
    panic("null fmt");
    80005f0a:	00003517          	auipc	a0,0x3
    80005f0e:	94650513          	addi	a0,a0,-1722 # 80008850 <syscalls+0x450>
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	f2c080e7          	jalr	-212(ra) # 80005e3e <panic>
      consputc(c);
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	c62080e7          	jalr	-926(ra) # 80005b7c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f22:	2985                	addiw	s3,s3,1
    80005f24:	013a07b3          	add	a5,s4,s3
    80005f28:	0007c503          	lbu	a0,0(a5)
    80005f2c:	10050463          	beqz	a0,80006034 <printf+0x1ac>
    if(c != '%'){
    80005f30:	ff5515e3          	bne	a0,s5,80005f1a <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f34:	2985                	addiw	s3,s3,1
    80005f36:	013a07b3          	add	a5,s4,s3
    80005f3a:	0007c783          	lbu	a5,0(a5)
    80005f3e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f42:	cbed                	beqz	a5,80006034 <printf+0x1ac>
    switch(c){
    80005f44:	05778a63          	beq	a5,s7,80005f98 <printf+0x110>
    80005f48:	02fbf663          	bgeu	s7,a5,80005f74 <printf+0xec>
    80005f4c:	09978863          	beq	a5,s9,80005fdc <printf+0x154>
    80005f50:	07800713          	li	a4,120
    80005f54:	0ce79563          	bne	a5,a4,8000601e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f58:	f8843783          	ld	a5,-120(s0)
    80005f5c:	00878713          	addi	a4,a5,8
    80005f60:	f8e43423          	sd	a4,-120(s0)
    80005f64:	4605                	li	a2,1
    80005f66:	85ea                	mv	a1,s10
    80005f68:	4388                	lw	a0,0(a5)
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	e32080e7          	jalr	-462(ra) # 80005d9c <printint>
      break;
    80005f72:	bf45                	j	80005f22 <printf+0x9a>
    switch(c){
    80005f74:	09578f63          	beq	a5,s5,80006012 <printf+0x18a>
    80005f78:	0b879363          	bne	a5,s8,8000601e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f7c:	f8843783          	ld	a5,-120(s0)
    80005f80:	00878713          	addi	a4,a5,8
    80005f84:	f8e43423          	sd	a4,-120(s0)
    80005f88:	4605                	li	a2,1
    80005f8a:	45a9                	li	a1,10
    80005f8c:	4388                	lw	a0,0(a5)
    80005f8e:	00000097          	auipc	ra,0x0
    80005f92:	e0e080e7          	jalr	-498(ra) # 80005d9c <printint>
      break;
    80005f96:	b771                	j	80005f22 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f98:	f8843783          	ld	a5,-120(s0)
    80005f9c:	00878713          	addi	a4,a5,8
    80005fa0:	f8e43423          	sd	a4,-120(s0)
    80005fa4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005fa8:	03000513          	li	a0,48
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	bd0080e7          	jalr	-1072(ra) # 80005b7c <consputc>
  consputc('x');
    80005fb4:	07800513          	li	a0,120
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	bc4080e7          	jalr	-1084(ra) # 80005b7c <consputc>
    80005fc0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fc2:	03c95793          	srli	a5,s2,0x3c
    80005fc6:	97da                	add	a5,a5,s6
    80005fc8:	0007c503          	lbu	a0,0(a5)
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	bb0080e7          	jalr	-1104(ra) # 80005b7c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fd4:	0912                	slli	s2,s2,0x4
    80005fd6:	34fd                	addiw	s1,s1,-1
    80005fd8:	f4ed                	bnez	s1,80005fc2 <printf+0x13a>
    80005fda:	b7a1                	j	80005f22 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fdc:	f8843783          	ld	a5,-120(s0)
    80005fe0:	00878713          	addi	a4,a5,8
    80005fe4:	f8e43423          	sd	a4,-120(s0)
    80005fe8:	6384                	ld	s1,0(a5)
    80005fea:	cc89                	beqz	s1,80006004 <printf+0x17c>
      for(; *s; s++)
    80005fec:	0004c503          	lbu	a0,0(s1)
    80005ff0:	d90d                	beqz	a0,80005f22 <printf+0x9a>
        consputc(*s);
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	b8a080e7          	jalr	-1142(ra) # 80005b7c <consputc>
      for(; *s; s++)
    80005ffa:	0485                	addi	s1,s1,1
    80005ffc:	0004c503          	lbu	a0,0(s1)
    80006000:	f96d                	bnez	a0,80005ff2 <printf+0x16a>
    80006002:	b705                	j	80005f22 <printf+0x9a>
        s = "(null)";
    80006004:	00003497          	auipc	s1,0x3
    80006008:	84448493          	addi	s1,s1,-1980 # 80008848 <syscalls+0x448>
      for(; *s; s++)
    8000600c:	02800513          	li	a0,40
    80006010:	b7cd                	j	80005ff2 <printf+0x16a>
      consputc('%');
    80006012:	8556                	mv	a0,s5
    80006014:	00000097          	auipc	ra,0x0
    80006018:	b68080e7          	jalr	-1176(ra) # 80005b7c <consputc>
      break;
    8000601c:	b719                	j	80005f22 <printf+0x9a>
      consputc('%');
    8000601e:	8556                	mv	a0,s5
    80006020:	00000097          	auipc	ra,0x0
    80006024:	b5c080e7          	jalr	-1188(ra) # 80005b7c <consputc>
      consputc(c);
    80006028:	8526                	mv	a0,s1
    8000602a:	00000097          	auipc	ra,0x0
    8000602e:	b52080e7          	jalr	-1198(ra) # 80005b7c <consputc>
      break;
    80006032:	bdc5                	j	80005f22 <printf+0x9a>
  if(locking)
    80006034:	020d9163          	bnez	s11,80006056 <printf+0x1ce>
}
    80006038:	70e6                	ld	ra,120(sp)
    8000603a:	7446                	ld	s0,112(sp)
    8000603c:	74a6                	ld	s1,104(sp)
    8000603e:	7906                	ld	s2,96(sp)
    80006040:	69e6                	ld	s3,88(sp)
    80006042:	6a46                	ld	s4,80(sp)
    80006044:	6aa6                	ld	s5,72(sp)
    80006046:	6b06                	ld	s6,64(sp)
    80006048:	7be2                	ld	s7,56(sp)
    8000604a:	7c42                	ld	s8,48(sp)
    8000604c:	7ca2                	ld	s9,40(sp)
    8000604e:	7d02                	ld	s10,32(sp)
    80006050:	6de2                	ld	s11,24(sp)
    80006052:	6129                	addi	sp,sp,192
    80006054:	8082                	ret
    release(&pr.lock);
    80006056:	0001c517          	auipc	a0,0x1c
    8000605a:	f0250513          	addi	a0,a0,-254 # 80021f58 <pr>
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	3d0080e7          	jalr	976(ra) # 8000642e <release>
}
    80006066:	bfc9                	j	80006038 <printf+0x1b0>

0000000080006068 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006068:	1101                	addi	sp,sp,-32
    8000606a:	ec06                	sd	ra,24(sp)
    8000606c:	e822                	sd	s0,16(sp)
    8000606e:	e426                	sd	s1,8(sp)
    80006070:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006072:	0001c497          	auipc	s1,0x1c
    80006076:	ee648493          	addi	s1,s1,-282 # 80021f58 <pr>
    8000607a:	00002597          	auipc	a1,0x2
    8000607e:	7e658593          	addi	a1,a1,2022 # 80008860 <syscalls+0x460>
    80006082:	8526                	mv	a0,s1
    80006084:	00000097          	auipc	ra,0x0
    80006088:	266080e7          	jalr	614(ra) # 800062ea <initlock>
  pr.locking = 1;
    8000608c:	4785                	li	a5,1
    8000608e:	cc9c                	sw	a5,24(s1)
}
    80006090:	60e2                	ld	ra,24(sp)
    80006092:	6442                	ld	s0,16(sp)
    80006094:	64a2                	ld	s1,8(sp)
    80006096:	6105                	addi	sp,sp,32
    80006098:	8082                	ret

000000008000609a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000609a:	1141                	addi	sp,sp,-16
    8000609c:	e406                	sd	ra,8(sp)
    8000609e:	e022                	sd	s0,0(sp)
    800060a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060a2:	100007b7          	lui	a5,0x10000
    800060a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060aa:	f8000713          	li	a4,-128
    800060ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060b2:	470d                	li	a4,3
    800060b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060c0:	469d                	li	a3,7
    800060c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060ca:	00002597          	auipc	a1,0x2
    800060ce:	7b658593          	addi	a1,a1,1974 # 80008880 <digits+0x18>
    800060d2:	0001c517          	auipc	a0,0x1c
    800060d6:	ea650513          	addi	a0,a0,-346 # 80021f78 <uart_tx_lock>
    800060da:	00000097          	auipc	ra,0x0
    800060de:	210080e7          	jalr	528(ra) # 800062ea <initlock>
}
    800060e2:	60a2                	ld	ra,8(sp)
    800060e4:	6402                	ld	s0,0(sp)
    800060e6:	0141                	addi	sp,sp,16
    800060e8:	8082                	ret

00000000800060ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060ea:	1101                	addi	sp,sp,-32
    800060ec:	ec06                	sd	ra,24(sp)
    800060ee:	e822                	sd	s0,16(sp)
    800060f0:	e426                	sd	s1,8(sp)
    800060f2:	1000                	addi	s0,sp,32
    800060f4:	84aa                	mv	s1,a0
  push_off();
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	238080e7          	jalr	568(ra) # 8000632e <push_off>

  if(panicked){
    800060fe:	00003797          	auipc	a5,0x3
    80006102:	82e7a783          	lw	a5,-2002(a5) # 8000892c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006106:	10000737          	lui	a4,0x10000
  if(panicked){
    8000610a:	c391                	beqz	a5,8000610e <uartputc_sync+0x24>
    for(;;)
    8000610c:	a001                	j	8000610c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000610e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006112:	0207f793          	andi	a5,a5,32
    80006116:	dfe5                	beqz	a5,8000610e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006118:	0ff4f513          	andi	a0,s1,255
    8000611c:	100007b7          	lui	a5,0x10000
    80006120:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006124:	00000097          	auipc	ra,0x0
    80006128:	2aa080e7          	jalr	682(ra) # 800063ce <pop_off>
}
    8000612c:	60e2                	ld	ra,24(sp)
    8000612e:	6442                	ld	s0,16(sp)
    80006130:	64a2                	ld	s1,8(sp)
    80006132:	6105                	addi	sp,sp,32
    80006134:	8082                	ret

0000000080006136 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006136:	00002797          	auipc	a5,0x2
    8000613a:	7fa7b783          	ld	a5,2042(a5) # 80008930 <uart_tx_r>
    8000613e:	00002717          	auipc	a4,0x2
    80006142:	7fa73703          	ld	a4,2042(a4) # 80008938 <uart_tx_w>
    80006146:	06f70a63          	beq	a4,a5,800061ba <uartstart+0x84>
{
    8000614a:	7139                	addi	sp,sp,-64
    8000614c:	fc06                	sd	ra,56(sp)
    8000614e:	f822                	sd	s0,48(sp)
    80006150:	f426                	sd	s1,40(sp)
    80006152:	f04a                	sd	s2,32(sp)
    80006154:	ec4e                	sd	s3,24(sp)
    80006156:	e852                	sd	s4,16(sp)
    80006158:	e456                	sd	s5,8(sp)
    8000615a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000615c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006160:	0001ca17          	auipc	s4,0x1c
    80006164:	e18a0a13          	addi	s4,s4,-488 # 80021f78 <uart_tx_lock>
    uart_tx_r += 1;
    80006168:	00002497          	auipc	s1,0x2
    8000616c:	7c848493          	addi	s1,s1,1992 # 80008930 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006170:	00002997          	auipc	s3,0x2
    80006174:	7c898993          	addi	s3,s3,1992 # 80008938 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006178:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000617c:	02077713          	andi	a4,a4,32
    80006180:	c705                	beqz	a4,800061a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006182:	01f7f713          	andi	a4,a5,31
    80006186:	9752                	add	a4,a4,s4
    80006188:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000618c:	0785                	addi	a5,a5,1
    8000618e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006190:	8526                	mv	a0,s1
    80006192:	ffffb097          	auipc	ra,0xffffb
    80006196:	55c080e7          	jalr	1372(ra) # 800016ee <wakeup>
    
    WriteReg(THR, c);
    8000619a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000619e:	609c                	ld	a5,0(s1)
    800061a0:	0009b703          	ld	a4,0(s3)
    800061a4:	fcf71ae3          	bne	a4,a5,80006178 <uartstart+0x42>
  }
}
    800061a8:	70e2                	ld	ra,56(sp)
    800061aa:	7442                	ld	s0,48(sp)
    800061ac:	74a2                	ld	s1,40(sp)
    800061ae:	7902                	ld	s2,32(sp)
    800061b0:	69e2                	ld	s3,24(sp)
    800061b2:	6a42                	ld	s4,16(sp)
    800061b4:	6aa2                	ld	s5,8(sp)
    800061b6:	6121                	addi	sp,sp,64
    800061b8:	8082                	ret
    800061ba:	8082                	ret

00000000800061bc <uartputc>:
{
    800061bc:	7179                	addi	sp,sp,-48
    800061be:	f406                	sd	ra,40(sp)
    800061c0:	f022                	sd	s0,32(sp)
    800061c2:	ec26                	sd	s1,24(sp)
    800061c4:	e84a                	sd	s2,16(sp)
    800061c6:	e44e                	sd	s3,8(sp)
    800061c8:	e052                	sd	s4,0(sp)
    800061ca:	1800                	addi	s0,sp,48
    800061cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061ce:	0001c517          	auipc	a0,0x1c
    800061d2:	daa50513          	addi	a0,a0,-598 # 80021f78 <uart_tx_lock>
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	1a4080e7          	jalr	420(ra) # 8000637a <acquire>
  if(panicked){
    800061de:	00002797          	auipc	a5,0x2
    800061e2:	74e7a783          	lw	a5,1870(a5) # 8000892c <panicked>
    800061e6:	e7c9                	bnez	a5,80006270 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e8:	00002717          	auipc	a4,0x2
    800061ec:	75073703          	ld	a4,1872(a4) # 80008938 <uart_tx_w>
    800061f0:	00002797          	auipc	a5,0x2
    800061f4:	7407b783          	ld	a5,1856(a5) # 80008930 <uart_tx_r>
    800061f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800061fc:	0001c997          	auipc	s3,0x1c
    80006200:	d7c98993          	addi	s3,s3,-644 # 80021f78 <uart_tx_lock>
    80006204:	00002497          	auipc	s1,0x2
    80006208:	72c48493          	addi	s1,s1,1836 # 80008930 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000620c:	00002917          	auipc	s2,0x2
    80006210:	72c90913          	addi	s2,s2,1836 # 80008938 <uart_tx_w>
    80006214:	00e79f63          	bne	a5,a4,80006232 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006218:	85ce                	mv	a1,s3
    8000621a:	8526                	mv	a0,s1
    8000621c:	ffffb097          	auipc	ra,0xffffb
    80006220:	46e080e7          	jalr	1134(ra) # 8000168a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006224:	00093703          	ld	a4,0(s2)
    80006228:	609c                	ld	a5,0(s1)
    8000622a:	02078793          	addi	a5,a5,32
    8000622e:	fee785e3          	beq	a5,a4,80006218 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006232:	0001c497          	auipc	s1,0x1c
    80006236:	d4648493          	addi	s1,s1,-698 # 80021f78 <uart_tx_lock>
    8000623a:	01f77793          	andi	a5,a4,31
    8000623e:	97a6                	add	a5,a5,s1
    80006240:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006244:	0705                	addi	a4,a4,1
    80006246:	00002797          	auipc	a5,0x2
    8000624a:	6ee7b923          	sd	a4,1778(a5) # 80008938 <uart_tx_w>
  uartstart();
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	ee8080e7          	jalr	-280(ra) # 80006136 <uartstart>
  release(&uart_tx_lock);
    80006256:	8526                	mv	a0,s1
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	1d6080e7          	jalr	470(ra) # 8000642e <release>
}
    80006260:	70a2                	ld	ra,40(sp)
    80006262:	7402                	ld	s0,32(sp)
    80006264:	64e2                	ld	s1,24(sp)
    80006266:	6942                	ld	s2,16(sp)
    80006268:	69a2                	ld	s3,8(sp)
    8000626a:	6a02                	ld	s4,0(sp)
    8000626c:	6145                	addi	sp,sp,48
    8000626e:	8082                	ret
    for(;;)
    80006270:	a001                	j	80006270 <uartputc+0xb4>

0000000080006272 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006272:	1141                	addi	sp,sp,-16
    80006274:	e422                	sd	s0,8(sp)
    80006276:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006278:	100007b7          	lui	a5,0x10000
    8000627c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006280:	8b85                	andi	a5,a5,1
    80006282:	cb91                	beqz	a5,80006296 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006284:	100007b7          	lui	a5,0x10000
    80006288:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000628c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006290:	6422                	ld	s0,8(sp)
    80006292:	0141                	addi	sp,sp,16
    80006294:	8082                	ret
    return -1;
    80006296:	557d                	li	a0,-1
    80006298:	bfe5                	j	80006290 <uartgetc+0x1e>

000000008000629a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062a4:	54fd                	li	s1,-1
    800062a6:	a029                	j	800062b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	916080e7          	jalr	-1770(ra) # 80005bbe <consoleintr>
    int c = uartgetc();
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	fc2080e7          	jalr	-62(ra) # 80006272 <uartgetc>
    if(c == -1)
    800062b8:	fe9518e3          	bne	a0,s1,800062a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062bc:	0001c497          	auipc	s1,0x1c
    800062c0:	cbc48493          	addi	s1,s1,-836 # 80021f78 <uart_tx_lock>
    800062c4:	8526                	mv	a0,s1
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	0b4080e7          	jalr	180(ra) # 8000637a <acquire>
  uartstart();
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	e68080e7          	jalr	-408(ra) # 80006136 <uartstart>
  release(&uart_tx_lock);
    800062d6:	8526                	mv	a0,s1
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	156080e7          	jalr	342(ra) # 8000642e <release>
}
    800062e0:	60e2                	ld	ra,24(sp)
    800062e2:	6442                	ld	s0,16(sp)
    800062e4:	64a2                	ld	s1,8(sp)
    800062e6:	6105                	addi	sp,sp,32
    800062e8:	8082                	ret

00000000800062ea <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062ea:	1141                	addi	sp,sp,-16
    800062ec:	e422                	sd	s0,8(sp)
    800062ee:	0800                	addi	s0,sp,16
  lk->name = name;
    800062f0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062f2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062f6:	00053823          	sd	zero,16(a0)
}
    800062fa:	6422                	ld	s0,8(sp)
    800062fc:	0141                	addi	sp,sp,16
    800062fe:	8082                	ret

0000000080006300 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006300:	411c                	lw	a5,0(a0)
    80006302:	e399                	bnez	a5,80006308 <holding+0x8>
    80006304:	4501                	li	a0,0
  return r;
}
    80006306:	8082                	ret
{
    80006308:	1101                	addi	sp,sp,-32
    8000630a:	ec06                	sd	ra,24(sp)
    8000630c:	e822                	sd	s0,16(sp)
    8000630e:	e426                	sd	s1,8(sp)
    80006310:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006312:	6904                	ld	s1,16(a0)
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	c04080e7          	jalr	-1020(ra) # 80000f18 <mycpu>
    8000631c:	40a48533          	sub	a0,s1,a0
    80006320:	00153513          	seqz	a0,a0
}
    80006324:	60e2                	ld	ra,24(sp)
    80006326:	6442                	ld	s0,16(sp)
    80006328:	64a2                	ld	s1,8(sp)
    8000632a:	6105                	addi	sp,sp,32
    8000632c:	8082                	ret

000000008000632e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000632e:	1101                	addi	sp,sp,-32
    80006330:	ec06                	sd	ra,24(sp)
    80006332:	e822                	sd	s0,16(sp)
    80006334:	e426                	sd	s1,8(sp)
    80006336:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006338:	100024f3          	csrr	s1,sstatus
    8000633c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006340:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006342:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006346:	ffffb097          	auipc	ra,0xffffb
    8000634a:	bd2080e7          	jalr	-1070(ra) # 80000f18 <mycpu>
    8000634e:	5d3c                	lw	a5,120(a0)
    80006350:	cf89                	beqz	a5,8000636a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006352:	ffffb097          	auipc	ra,0xffffb
    80006356:	bc6080e7          	jalr	-1082(ra) # 80000f18 <mycpu>
    8000635a:	5d3c                	lw	a5,120(a0)
    8000635c:	2785                	addiw	a5,a5,1
    8000635e:	dd3c                	sw	a5,120(a0)
}
    80006360:	60e2                	ld	ra,24(sp)
    80006362:	6442                	ld	s0,16(sp)
    80006364:	64a2                	ld	s1,8(sp)
    80006366:	6105                	addi	sp,sp,32
    80006368:	8082                	ret
    mycpu()->intena = old;
    8000636a:	ffffb097          	auipc	ra,0xffffb
    8000636e:	bae080e7          	jalr	-1106(ra) # 80000f18 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006372:	8085                	srli	s1,s1,0x1
    80006374:	8885                	andi	s1,s1,1
    80006376:	dd64                	sw	s1,124(a0)
    80006378:	bfe9                	j	80006352 <push_off+0x24>

000000008000637a <acquire>:
{
    8000637a:	1101                	addi	sp,sp,-32
    8000637c:	ec06                	sd	ra,24(sp)
    8000637e:	e822                	sd	s0,16(sp)
    80006380:	e426                	sd	s1,8(sp)
    80006382:	1000                	addi	s0,sp,32
    80006384:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	fa8080e7          	jalr	-88(ra) # 8000632e <push_off>
  if(holding(lk))
    8000638e:	8526                	mv	a0,s1
    80006390:	00000097          	auipc	ra,0x0
    80006394:	f70080e7          	jalr	-144(ra) # 80006300 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006398:	4705                	li	a4,1
  if(holding(lk))
    8000639a:	e115                	bnez	a0,800063be <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000639c:	87ba                	mv	a5,a4
    8000639e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063a2:	2781                	sext.w	a5,a5
    800063a4:	ffe5                	bnez	a5,8000639c <acquire+0x22>
  __sync_synchronize();
    800063a6:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063aa:	ffffb097          	auipc	ra,0xffffb
    800063ae:	b6e080e7          	jalr	-1170(ra) # 80000f18 <mycpu>
    800063b2:	e888                	sd	a0,16(s1)
}
    800063b4:	60e2                	ld	ra,24(sp)
    800063b6:	6442                	ld	s0,16(sp)
    800063b8:	64a2                	ld	s1,8(sp)
    800063ba:	6105                	addi	sp,sp,32
    800063bc:	8082                	ret
    panic("acquire");
    800063be:	00002517          	auipc	a0,0x2
    800063c2:	4ca50513          	addi	a0,a0,1226 # 80008888 <digits+0x20>
    800063c6:	00000097          	auipc	ra,0x0
    800063ca:	a78080e7          	jalr	-1416(ra) # 80005e3e <panic>

00000000800063ce <pop_off>:

void
pop_off(void)
{
    800063ce:	1141                	addi	sp,sp,-16
    800063d0:	e406                	sd	ra,8(sp)
    800063d2:	e022                	sd	s0,0(sp)
    800063d4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063d6:	ffffb097          	auipc	ra,0xffffb
    800063da:	b42080e7          	jalr	-1214(ra) # 80000f18 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063de:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063e2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063e4:	e78d                	bnez	a5,8000640e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063e6:	5d3c                	lw	a5,120(a0)
    800063e8:	02f05b63          	blez	a5,8000641e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063ec:	37fd                	addiw	a5,a5,-1
    800063ee:	0007871b          	sext.w	a4,a5
    800063f2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063f4:	eb09                	bnez	a4,80006406 <pop_off+0x38>
    800063f6:	5d7c                	lw	a5,124(a0)
    800063f8:	c799                	beqz	a5,80006406 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006402:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006406:	60a2                	ld	ra,8(sp)
    80006408:	6402                	ld	s0,0(sp)
    8000640a:	0141                	addi	sp,sp,16
    8000640c:	8082                	ret
    panic("pop_off - interruptible");
    8000640e:	00002517          	auipc	a0,0x2
    80006412:	48250513          	addi	a0,a0,1154 # 80008890 <digits+0x28>
    80006416:	00000097          	auipc	ra,0x0
    8000641a:	a28080e7          	jalr	-1496(ra) # 80005e3e <panic>
    panic("pop_off");
    8000641e:	00002517          	auipc	a0,0x2
    80006422:	48a50513          	addi	a0,a0,1162 # 800088a8 <digits+0x40>
    80006426:	00000097          	auipc	ra,0x0
    8000642a:	a18080e7          	jalr	-1512(ra) # 80005e3e <panic>

000000008000642e <release>:
{
    8000642e:	1101                	addi	sp,sp,-32
    80006430:	ec06                	sd	ra,24(sp)
    80006432:	e822                	sd	s0,16(sp)
    80006434:	e426                	sd	s1,8(sp)
    80006436:	1000                	addi	s0,sp,32
    80006438:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000643a:	00000097          	auipc	ra,0x0
    8000643e:	ec6080e7          	jalr	-314(ra) # 80006300 <holding>
    80006442:	c115                	beqz	a0,80006466 <release+0x38>
  lk->cpu = 0;
    80006444:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006448:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000644c:	0f50000f          	fence	iorw,ow
    80006450:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006454:	00000097          	auipc	ra,0x0
    80006458:	f7a080e7          	jalr	-134(ra) # 800063ce <pop_off>
}
    8000645c:	60e2                	ld	ra,24(sp)
    8000645e:	6442                	ld	s0,16(sp)
    80006460:	64a2                	ld	s1,8(sp)
    80006462:	6105                	addi	sp,sp,32
    80006464:	8082                	ret
    panic("release");
    80006466:	00002517          	auipc	a0,0x2
    8000646a:	44a50513          	addi	a0,a0,1098 # 800088b0 <digits+0x48>
    8000646e:	00000097          	auipc	ra,0x0
    80006472:	9d0080e7          	jalr	-1584(ra) # 80005e3e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
