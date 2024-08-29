
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c3010113          	addi	sp,sp,-976 # 80019c30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6b8050ef          	jal	ra,800056ce <start>

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
    80000034:	d0078793          	addi	a5,a5,-768 # 80021d30 <end>
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
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	060080e7          	jalr	96(ra) # 800060ba <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	100080e7          	jalr	256(ra) # 8000616e <release>
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
    8000008e:	af4080e7          	jalr	-1292(ra) # 80005b7e <panic>

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
    800000ec:	00008517          	auipc	a0,0x8
    800000f0:	7d450513          	addi	a0,a0,2004 # 800088c0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	f36080e7          	jalr	-202(ra) # 8000602a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	c3050513          	addi	a0,a0,-976 # 80021d30 <end>
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
    80000122:	00008497          	auipc	s1,0x8
    80000126:	79e48493          	addi	s1,s1,1950 # 800088c0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	f8e080e7          	jalr	-114(ra) # 800060ba <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	78650513          	addi	a0,a0,1926 # 800088c0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	02a080e7          	jalr	42(ra) # 8000616e <release>

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
    8000016a:	75a50513          	addi	a0,a0,1882 # 800088c0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	000080e7          	jalr	ra # 8000616e <release>
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
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	56270713          	addi	a4,a4,1378 # 80008890 <started>
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
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	874080e7          	jalr	-1932(ra) # 80005bc8 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	78a080e7          	jalr	1930(ra) # 80001aee <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	d14080e7          	jalr	-748(ra) # 80005080 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fd4080e7          	jalr	-44(ra) # 80001348 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	714080e7          	jalr	1812(ra) # 80005a90 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a24080e7          	jalr	-1500(ra) # 80005da8 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	834080e7          	jalr	-1996(ra) # 80005bc8 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	824080e7          	jalr	-2012(ra) # 80005bc8 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	814080e7          	jalr	-2028(ra) # 80005bc8 <printf>
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
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6ea080e7          	jalr	1770(ra) # 80001ac6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	70a080e7          	jalr	1802(ra) # 80001aee <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	c7e080e7          	jalr	-898(ra) # 8000506a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c8c080e7          	jalr	-884(ra) # 80005080 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e2e080e7          	jalr	-466(ra) # 8000222a <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	4d2080e7          	jalr	1234(ra) # 800028d6 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	470080e7          	jalr	1136(ra) # 8000387c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d74080e7          	jalr	-652(ra) # 80005188 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	46f72323          	sw	a5,1126(a4) # 80008890 <started>
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
    80000442:	45a7b783          	ld	a5,1114(a5) # 80008898 <kernel_pagetable>
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
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	6f4080e7          	jalr	1780(ra) # 80005b7e <panic>
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
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	5ce080e7          	jalr	1486(ra) # 80005b7e <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	5be080e7          	jalr	1470(ra) # 80005b7e <panic>
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
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	572080e7          	jalr	1394(ra) # 80005b7e <panic>

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
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
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
    800006fe:	18a7bf23          	sd	a0,414(a5) # 80008898 <kernel_pagetable>
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
    8000075c:	426080e7          	jalr	1062(ra) # 80005b7e <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	416080e7          	jalr	1046(ra) # 80005b7e <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	406080e7          	jalr	1030(ra) # 80005b7e <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	3f6080e7          	jalr	1014(ra) # 80005b7e <panic>
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
    8000086a:	318080e7          	jalr	792(ra) # 80005b7e <panic>

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
    800009b4:	1ce080e7          	jalr	462(ra) # 80005b7e <panic>
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
    80000a90:	0f2080e7          	jalr	242(ra) # 80005b7e <panic>
      panic("uvmcopy: page not present");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	69450513          	addi	a0,a0,1684 # 80008128 <etext+0x128>
    80000a9c:	00005097          	auipc	ra,0x5
    80000aa0:	0e2080e7          	jalr	226(ra) # 80005b7e <panic>
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
    80000b0a:	078080e7          	jalr	120(ra) # 80005b7e <panic>

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

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	01e48493          	addi	s1,s1,30 # 80008d10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	a04a0a13          	addi	s4,s4,-1532 # 8000e710 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	404080e7          	jalr	1028(ra) # 80000118 <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	858d                	srai	a1,a1,0x3
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	16848493          	addi	s1,s1,360
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	e14080e7          	jalr	-492(ra) # 80005b7e <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b5250513          	addi	a0,a0,-1198 # 800088e0 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	294080e7          	jalr	660(ra) # 8000602a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b5250513          	addi	a0,a0,-1198 # 800088f8 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	27c080e7          	jalr	636(ra) # 8000602a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f5a48493          	addi	s1,s1,-166 # 80008d10 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	0000e997          	auipc	s3,0xe
    80000ddc:	93898993          	addi	s3,s3,-1736 # 8000e710 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	246080e7          	jalr	582(ra) # 8000602a <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	16848493          	addi	s1,s1,360
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	ace50513          	addi	a0,a0,-1330 # 80008910 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	212080e7          	jalr	530(ra) # 8000606e <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a7670713          	addi	a4,a4,-1418 # 800088e0 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	298080e7          	jalr	664(ra) # 8000610e <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	2d4080e7          	jalr	724(ra) # 8000616e <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c5a080e7          	jalr	-934(ra) # 80001b06 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	990080e7          	jalr	-1648(ra) # 80002856 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a0490913          	addi	s2,s2,-1532 # 800088e0 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	1d4080e7          	jalr	468(ra) # 800060ba <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	26e080e7          	jalr	622(ra) # 8000616e <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a52080e7          	jalr	-1454(ra) # 800009d2 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2c080e7          	jalr	-1492(ra) # 800009d2 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e2080e7          	jalr	-1566(ra) # 800009d2 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	ca848493          	addi	s1,s1,-856 # 80008d10 <proc>
    80001070:	0000d917          	auipc	s2,0xd
    80001074:	6a090913          	addi	s2,s2,1696 # 8000e710 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	040080e7          	jalr	64(ra) # 800060ba <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	cf81                	beqz	a5,8000109c <allocproc+0x40>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	0e6080e7          	jalr	230(ra) # 8000616e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	16848493          	addi	s1,s1,360
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
    8000109a:	a889                	j	800010ec <allocproc+0x90>
  p->pid = allocpid();
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	e34080e7          	jalr	-460(ra) # 80000ed0 <allocpid>
    800010a4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a6:	4785                	li	a5,1
    800010a8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	06e080e7          	jalr	110(ra) # 80000118 <kalloc>
    800010b2:	892a                	mv	s2,a0
    800010b4:	eca8                	sd	a0,88(s1)
    800010b6:	c131                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	e5c080e7          	jalr	-420(ra) # 80000f16 <proc_pagetable>
    800010c2:	892a                	mv	s2,a0
    800010c4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c6:	c531                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c8:	07000613          	li	a2,112
    800010cc:	4581                	li	a1,0
    800010ce:	06048513          	addi	a0,s1,96
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	0a6080e7          	jalr	166(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010da:	00000797          	auipc	a5,0x0
    800010de:	db078793          	addi	a5,a5,-592 # 80000e8a <forkret>
    800010e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e4:	60bc                	ld	a5,64(s1)
    800010e6:	6705                	lui	a4,0x1
    800010e8:	97ba                	add	a5,a5,a4
    800010ea:	f4bc                	sd	a5,104(s1)
}
    800010ec:	8526                	mv	a0,s1
    800010ee:	60e2                	ld	ra,24(sp)
    800010f0:	6442                	ld	s0,16(sp)
    800010f2:	64a2                	ld	s1,8(sp)
    800010f4:	6902                	ld	s2,0(sp)
    800010f6:	6105                	addi	sp,sp,32
    800010f8:	8082                	ret
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	068080e7          	jalr	104(ra) # 8000616e <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	bff1                	j	800010ec <allocproc+0x90>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	050080e7          	jalr	80(ra) # 8000616e <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	b7d1                	j	800010ec <allocproc+0x90>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	76a7b123          	sd	a0,1890(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	0f0080e7          	jalr	240(ra) # 80003278 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	fd4080e7          	jalr	-44(ra) # 8000616e <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	10050c63          	beqz	a0,80001344 <fork+0x13c>
    80001230:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7ce080e7          	jalr	1998(ra) # 80000a0a <uvmcopy>
    80001244:	04054863          	bltz	a0,80001294 <fork+0x8c>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001250:	058ab683          	ld	a3,88(s5)
    80001254:	87b6                	mv	a5,a3
    80001256:	058a3703          	ld	a4,88(s4)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x56>
  np->trapframe->a0 = 0;
    8000127e:	058a3783          	ld	a5,88(s4)
    80001282:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001286:	0d0a8493          	addi	s1,s5,208
    8000128a:	0d0a0913          	addi	s2,s4,208
    8000128e:	150a8993          	addi	s3,s5,336
    80001292:	a00d                	j	800012b4 <fork+0xac>
    freeproc(np);
    80001294:	8552                	mv	a0,s4
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d6e080e7          	jalr	-658(ra) # 80001004 <freeproc>
    release(&np->lock);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	ece080e7          	jalr	-306(ra) # 8000616e <release>
    return -1;
    800012a8:	597d                	li	s2,-1
    800012aa:	a059                	j	80001330 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ac:	04a1                	addi	s1,s1,8
    800012ae:	0921                	addi	s2,s2,8
    800012b0:	01348b63          	beq	s1,s3,800012c6 <fork+0xbe>
    if(p->ofile[i])
    800012b4:	6088                	ld	a0,0(s1)
    800012b6:	d97d                	beqz	a0,800012ac <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	656080e7          	jalr	1622(ra) # 8000390e <filedup>
    800012c0:	00a93023          	sd	a0,0(s2)
    800012c4:	b7e5                	j	800012ac <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c6:	150ab503          	ld	a0,336(s5)
    800012ca:	00001097          	auipc	ra,0x1
    800012ce:	7ca080e7          	jalr	1994(ra) # 80002a94 <idup>
    800012d2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	158a8593          	addi	a1,s5,344
    800012dc:	158a0513          	addi	a0,s4,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012e8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	e80080e7          	jalr	-384(ra) # 8000616e <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	60248493          	addi	s1,s1,1538 # 800088f8 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	dba080e7          	jalr	-582(ra) # 800060ba <acquire>
  np->parent = p;
    80001308:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	e60080e7          	jalr	-416(ra) # 8000616e <release>
  acquire(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	da2080e7          	jalr	-606(ra) # 800060ba <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001326:	8552                	mv	a0,s4
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	e46080e7          	jalr	-442(ra) # 8000616e <release>
}
    80001330:	854a                	mv	a0,s2
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	74a2                	ld	s1,40(sp)
    80001338:	7902                	ld	s2,32(sp)
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	6a42                	ld	s4,16(sp)
    8000133e:	6aa2                	ld	s5,8(sp)
    80001340:	6121                	addi	sp,sp,64
    80001342:	8082                	ret
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	b7ed                	j	80001330 <fork+0x128>

0000000080001348 <scheduler>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f426                	sd	s1,40(sp)
    80001350:	f04a                	sd	s2,32(sp)
    80001352:	ec4e                	sd	s3,24(sp)
    80001354:	e852                	sd	s4,16(sp)
    80001356:	e456                	sd	s5,8(sp)
    80001358:	e05a                	sd	s6,0(sp)
    8000135a:	0080                	addi	s0,sp,64
    8000135c:	8792                	mv	a5,tp
  int id = r_tp();
    8000135e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001360:	00779a93          	slli	s5,a5,0x7
    80001364:	00007717          	auipc	a4,0x7
    80001368:	57c70713          	addi	a4,a4,1404 # 800088e0 <pid_lock>
    8000136c:	9756                	add	a4,a4,s5
    8000136e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5a670713          	addi	a4,a4,1446 # 80008918 <cpus+0x8>
    8000137a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137c:	498d                	li	s3,3
        p->state = RUNNING;
    8000137e:	4b11                	li	s6,4
        c->proc = p;
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00007a17          	auipc	s4,0x7
    80001386:	55ea0a13          	addi	s4,s4,1374 # 800088e0 <pid_lock>
    8000138a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	0000d917          	auipc	s2,0xd
    80001390:	38490913          	addi	s2,s2,900 # 8000e710 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139c:	10079073          	csrw	sstatus,a5
    800013a0:	00008497          	auipc	s1,0x8
    800013a4:	97048493          	addi	s1,s1,-1680 # 80008d10 <proc>
    800013a8:	a811                	j	800013bc <scheduler+0x74>
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	dc2080e7          	jalr	-574(ra) # 8000616e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b4:	16848493          	addi	s1,s1,360
    800013b8:	fd248ee3          	beq	s1,s2,80001394 <scheduler+0x4c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	cfc080e7          	jalr	-772(ra) # 800060ba <acquire>
      if(p->state == RUNNABLE) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <scheduler+0x62>
        p->state = RUNNING;
    800013cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d4:	06048593          	addi	a1,s1,96
    800013d8:	8556                	mv	a0,s5
    800013da:	00000097          	auipc	ra,0x0
    800013de:	682080e7          	jalr	1666(ra) # 80001a5c <swtch>
        c->proc = 0;
    800013e2:	020a3823          	sd	zero,48(s4)
    800013e6:	b7d1                	j	800013aa <scheduler+0x62>

00000000800013e8 <sched>:
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	a5c080e7          	jalr	-1444(ra) # 80000e52 <myproc>
    800013fe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001400:	00005097          	auipc	ra,0x5
    80001404:	c40080e7          	jalr	-960(ra) # 80006040 <holding>
    80001408:	c93d                	beqz	a0,8000147e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140c:	2781                	sext.w	a5,a5
    8000140e:	079e                	slli	a5,a5,0x7
    80001410:	00007717          	auipc	a4,0x7
    80001414:	4d070713          	addi	a4,a4,1232 # 800088e0 <pid_lock>
    80001418:	97ba                	add	a5,a5,a4
    8000141a:	0a87a703          	lw	a4,168(a5)
    8000141e:	4785                	li	a5,1
    80001420:	06f71763          	bne	a4,a5,8000148e <sched+0xa6>
  if(p->state == RUNNING)
    80001424:	4c98                	lw	a4,24(s1)
    80001426:	4791                	li	a5,4
    80001428:	06f70b63          	beq	a4,a5,8000149e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001430:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001432:	efb5                	bnez	a5,800014ae <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001434:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001436:	00007917          	auipc	s2,0x7
    8000143a:	4aa90913          	addi	s2,s2,1194 # 800088e0 <pid_lock>
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	97ca                	add	a5,a5,s2
    80001444:	0ac7a983          	lw	s3,172(a5)
    80001448:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	00007597          	auipc	a1,0x7
    80001452:	4ca58593          	addi	a1,a1,1226 # 80008918 <cpus+0x8>
    80001456:	95be                	add	a1,a1,a5
    80001458:	06048513          	addi	a0,s1,96
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	600080e7          	jalr	1536(ra) # 80001a5c <swtch>
    80001464:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	97ca                	add	a5,a5,s2
    8000146c:	0b37a623          	sw	s3,172(a5)
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    panic("sched p->lock");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1a50513          	addi	a0,a0,-742 # 80008198 <etext+0x198>
    80001486:	00004097          	auipc	ra,0x4
    8000148a:	6f8080e7          	jalr	1784(ra) # 80005b7e <panic>
    panic("sched locks");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d1a50513          	addi	a0,a0,-742 # 800081a8 <etext+0x1a8>
    80001496:	00004097          	auipc	ra,0x4
    8000149a:	6e8080e7          	jalr	1768(ra) # 80005b7e <panic>
    panic("sched running");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	d1a50513          	addi	a0,a0,-742 # 800081b8 <etext+0x1b8>
    800014a6:	00004097          	auipc	ra,0x4
    800014aa:	6d8080e7          	jalr	1752(ra) # 80005b7e <panic>
    panic("sched interruptible");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	d1a50513          	addi	a0,a0,-742 # 800081c8 <etext+0x1c8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	6c8080e7          	jalr	1736(ra) # 80005b7e <panic>

00000000800014be <yield>:
{
    800014be:	1101                	addi	sp,sp,-32
    800014c0:	ec06                	sd	ra,24(sp)
    800014c2:	e822                	sd	s0,16(sp)
    800014c4:	e426                	sd	s1,8(sp)
    800014c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	98a080e7          	jalr	-1654(ra) # 80000e52 <myproc>
    800014d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	be8080e7          	jalr	-1048(ra) # 800060ba <acquire>
  p->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	cc9c                	sw	a5,24(s1)
  sched();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f0a080e7          	jalr	-246(ra) # 800013e8 <sched>
  release(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	c86080e7          	jalr	-890(ra) # 8000616e <release>
}
    800014f0:	60e2                	ld	ra,24(sp)
    800014f2:	6442                	ld	s0,16(sp)
    800014f4:	64a2                	ld	s1,8(sp)
    800014f6:	6105                	addi	sp,sp,32
    800014f8:	8082                	ret

00000000800014fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	ec26                	sd	s1,24(sp)
    80001502:	e84a                	sd	s2,16(sp)
    80001504:	e44e                	sd	s3,8(sp)
    80001506:	1800                	addi	s0,sp,48
    80001508:	89aa                	mv	s3,a0
    8000150a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	946080e7          	jalr	-1722(ra) # 80000e52 <myproc>
    80001514:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	ba4080e7          	jalr	-1116(ra) # 800060ba <acquire>
  release(lk);
    8000151e:	854a                	mv	a0,s2
    80001520:	00005097          	auipc	ra,0x5
    80001524:	c4e080e7          	jalr	-946(ra) # 8000616e <release>

  // Go to sleep.
  p->chan = chan;
    80001528:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152c:	4789                	li	a5,2
    8000152e:	cc9c                	sw	a5,24(s1)

  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	eb8080e7          	jalr	-328(ra) # 800013e8 <sched>

  // Tidy up.
  p->chan = 0;
    80001538:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	c30080e7          	jalr	-976(ra) # 8000616e <release>
  acquire(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	b72080e7          	jalr	-1166(ra) # 800060ba <acquire>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6145                	addi	sp,sp,48
    8000155c:	8082                	ret

000000008000155e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155e:	7139                	addi	sp,sp,-64
    80001560:	fc06                	sd	ra,56(sp)
    80001562:	f822                	sd	s0,48(sp)
    80001564:	f426                	sd	s1,40(sp)
    80001566:	f04a                	sd	s2,32(sp)
    80001568:	ec4e                	sd	s3,24(sp)
    8000156a:	e852                	sd	s4,16(sp)
    8000156c:	e456                	sd	s5,8(sp)
    8000156e:	0080                	addi	s0,sp,64
    80001570:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	00007497          	auipc	s1,0x7
    80001576:	79e48493          	addi	s1,s1,1950 # 80008d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	0000d917          	auipc	s2,0xd
    80001582:	19290913          	addi	s2,s2,402 # 8000e710 <tickslock>
    80001586:	a811                	j	8000159a <wakeup+0x3c>
      }
      release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	be4080e7          	jalr	-1052(ra) # 8000616e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001592:	16848493          	addi	s1,s1,360
    80001596:	03248663          	beq	s1,s2,800015c2 <wakeup+0x64>
    if(p != myproc()){
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	8b8080e7          	jalr	-1864(ra) # 80000e52 <myproc>
    800015a2:	fea488e3          	beq	s1,a0,80001592 <wakeup+0x34>
      acquire(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	b12080e7          	jalr	-1262(ra) # 800060ba <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b0:	4c9c                	lw	a5,24(s1)
    800015b2:	fd379be3          	bne	a5,s3,80001588 <wakeup+0x2a>
    800015b6:	709c                	ld	a5,32(s1)
    800015b8:	fd4798e3          	bne	a5,s4,80001588 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015bc:	0154ac23          	sw	s5,24(s1)
    800015c0:	b7e1                	j	80001588 <wakeup+0x2a>
    }
  }
}
    800015c2:	70e2                	ld	ra,56(sp)
    800015c4:	7442                	ld	s0,48(sp)
    800015c6:	74a2                	ld	s1,40(sp)
    800015c8:	7902                	ld	s2,32(sp)
    800015ca:	69e2                	ld	s3,24(sp)
    800015cc:	6a42                	ld	s4,16(sp)
    800015ce:	6aa2                	ld	s5,8(sp)
    800015d0:	6121                	addi	sp,sp,64
    800015d2:	8082                	ret

00000000800015d4 <reparent>:
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	ec26                	sd	s1,24(sp)
    800015dc:	e84a                	sd	s2,16(sp)
    800015de:	e44e                	sd	s3,8(sp)
    800015e0:	e052                	sd	s4,0(sp)
    800015e2:	1800                	addi	s0,sp,48
    800015e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e6:	00007497          	auipc	s1,0x7
    800015ea:	72a48493          	addi	s1,s1,1834 # 80008d10 <proc>
      pp->parent = initproc;
    800015ee:	00007a17          	auipc	s4,0x7
    800015f2:	2b2a0a13          	addi	s4,s4,690 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f6:	0000d997          	auipc	s3,0xd
    800015fa:	11a98993          	addi	s3,s3,282 # 8000e710 <tickslock>
    800015fe:	a029                	j	80001608 <reparent+0x34>
    80001600:	16848493          	addi	s1,s1,360
    80001604:	01348d63          	beq	s1,s3,8000161e <reparent+0x4a>
    if(pp->parent == p){
    80001608:	7c9c                	ld	a5,56(s1)
    8000160a:	ff279be3          	bne	a5,s2,80001600 <reparent+0x2c>
      pp->parent = initproc;
    8000160e:	000a3503          	ld	a0,0(s4)
    80001612:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001614:	00000097          	auipc	ra,0x0
    80001618:	f4a080e7          	jalr	-182(ra) # 8000155e <wakeup>
    8000161c:	b7d5                	j	80001600 <reparent+0x2c>
}
    8000161e:	70a2                	ld	ra,40(sp)
    80001620:	7402                	ld	s0,32(sp)
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6942                	ld	s2,16(sp)
    80001626:	69a2                	ld	s3,8(sp)
    80001628:	6a02                	ld	s4,0(sp)
    8000162a:	6145                	addi	sp,sp,48
    8000162c:	8082                	ret

000000008000162e <exit>:
{
    8000162e:	7179                	addi	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	e052                	sd	s4,0(sp)
    8000163c:	1800                	addi	s0,sp,48
    8000163e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	812080e7          	jalr	-2030(ra) # 80000e52 <myproc>
    80001648:	89aa                	mv	s3,a0
  if(p == initproc)
    8000164a:	00007797          	auipc	a5,0x7
    8000164e:	2567b783          	ld	a5,598(a5) # 800088a0 <initproc>
    80001652:	0d050493          	addi	s1,a0,208
    80001656:	15050913          	addi	s2,a0,336
    8000165a:	02a79363          	bne	a5,a0,80001680 <exit+0x52>
    panic("init exiting");
    8000165e:	00007517          	auipc	a0,0x7
    80001662:	b8250513          	addi	a0,a0,-1150 # 800081e0 <etext+0x1e0>
    80001666:	00004097          	auipc	ra,0x4
    8000166a:	518080e7          	jalr	1304(ra) # 80005b7e <panic>
      fileclose(f);
    8000166e:	00002097          	auipc	ra,0x2
    80001672:	2f2080e7          	jalr	754(ra) # 80003960 <fileclose>
      p->ofile[fd] = 0;
    80001676:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000167a:	04a1                	addi	s1,s1,8
    8000167c:	01248563          	beq	s1,s2,80001686 <exit+0x58>
    if(p->ofile[fd]){
    80001680:	6088                	ld	a0,0(s1)
    80001682:	f575                	bnez	a0,8000166e <exit+0x40>
    80001684:	bfdd                	j	8000167a <exit+0x4c>
  begin_op();
    80001686:	00002097          	auipc	ra,0x2
    8000168a:	e0e080e7          	jalr	-498(ra) # 80003494 <begin_op>
  iput(p->cwd);
    8000168e:	1509b503          	ld	a0,336(s3)
    80001692:	00001097          	auipc	ra,0x1
    80001696:	5fa080e7          	jalr	1530(ra) # 80002c8c <iput>
  end_op();
    8000169a:	00002097          	auipc	ra,0x2
    8000169e:	e7a080e7          	jalr	-390(ra) # 80003514 <end_op>
  p->cwd = 0;
    800016a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a6:	00007497          	auipc	s1,0x7
    800016aa:	25248493          	addi	s1,s1,594 # 800088f8 <wait_lock>
    800016ae:	8526                	mv	a0,s1
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	a0a080e7          	jalr	-1526(ra) # 800060ba <acquire>
  reparent(p);
    800016b8:	854e                	mv	a0,s3
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	f1a080e7          	jalr	-230(ra) # 800015d4 <reparent>
  wakeup(p->parent);
    800016c2:	0389b503          	ld	a0,56(s3)
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	e98080e7          	jalr	-360(ra) # 8000155e <wakeup>
  acquire(&p->lock);
    800016ce:	854e                	mv	a0,s3
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	9ea080e7          	jalr	-1558(ra) # 800060ba <acquire>
  p->xstate = status;
    800016d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016dc:	4795                	li	a5,5
    800016de:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	a8a080e7          	jalr	-1398(ra) # 8000616e <release>
  sched();
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	cfc080e7          	jalr	-772(ra) # 800013e8 <sched>
  panic("zombie exit");
    800016f4:	00007517          	auipc	a0,0x7
    800016f8:	afc50513          	addi	a0,a0,-1284 # 800081f0 <etext+0x1f0>
    800016fc:	00004097          	auipc	ra,0x4
    80001700:	482080e7          	jalr	1154(ra) # 80005b7e <panic>

0000000080001704 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001704:	7179                	addi	sp,sp,-48
    80001706:	f406                	sd	ra,40(sp)
    80001708:	f022                	sd	s0,32(sp)
    8000170a:	ec26                	sd	s1,24(sp)
    8000170c:	e84a                	sd	s2,16(sp)
    8000170e:	e44e                	sd	s3,8(sp)
    80001710:	1800                	addi	s0,sp,48
    80001712:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001714:	00007497          	auipc	s1,0x7
    80001718:	5fc48493          	addi	s1,s1,1532 # 80008d10 <proc>
    8000171c:	0000d997          	auipc	s3,0xd
    80001720:	ff498993          	addi	s3,s3,-12 # 8000e710 <tickslock>
    acquire(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	994080e7          	jalr	-1644(ra) # 800060ba <acquire>
    if(p->pid == pid){
    8000172e:	589c                	lw	a5,48(s1)
    80001730:	01278d63          	beq	a5,s2,8000174a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	a38080e7          	jalr	-1480(ra) # 8000616e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000173e:	16848493          	addi	s1,s1,360
    80001742:	ff3491e3          	bne	s1,s3,80001724 <kill+0x20>
  }
  return -1;
    80001746:	557d                	li	a0,-1
    80001748:	a829                	j	80001762 <kill+0x5e>
      p->killed = 1;
    8000174a:	4785                	li	a5,1
    8000174c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000174e:	4c98                	lw	a4,24(s1)
    80001750:	4789                	li	a5,2
    80001752:	00f70f63          	beq	a4,a5,80001770 <kill+0x6c>
      release(&p->lock);
    80001756:	8526                	mv	a0,s1
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	a16080e7          	jalr	-1514(ra) # 8000616e <release>
      return 0;
    80001760:	4501                	li	a0,0
}
    80001762:	70a2                	ld	ra,40(sp)
    80001764:	7402                	ld	s0,32(sp)
    80001766:	64e2                	ld	s1,24(sp)
    80001768:	6942                	ld	s2,16(sp)
    8000176a:	69a2                	ld	s3,8(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret
        p->state = RUNNABLE;
    80001770:	478d                	li	a5,3
    80001772:	cc9c                	sw	a5,24(s1)
    80001774:	b7cd                	j	80001756 <kill+0x52>

0000000080001776 <setkilled>:

void
setkilled(struct proc *p)
{
    80001776:	1101                	addi	sp,sp,-32
    80001778:	ec06                	sd	ra,24(sp)
    8000177a:	e822                	sd	s0,16(sp)
    8000177c:	e426                	sd	s1,8(sp)
    8000177e:	1000                	addi	s0,sp,32
    80001780:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001782:	00005097          	auipc	ra,0x5
    80001786:	938080e7          	jalr	-1736(ra) # 800060ba <acquire>
  p->killed = 1;
    8000178a:	4785                	li	a5,1
    8000178c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	9de080e7          	jalr	-1570(ra) # 8000616e <release>
}
    80001798:	60e2                	ld	ra,24(sp)
    8000179a:	6442                	ld	s0,16(sp)
    8000179c:	64a2                	ld	s1,8(sp)
    8000179e:	6105                	addi	sp,sp,32
    800017a0:	8082                	ret

00000000800017a2 <killed>:

int
killed(struct proc *p)
{
    800017a2:	1101                	addi	sp,sp,-32
    800017a4:	ec06                	sd	ra,24(sp)
    800017a6:	e822                	sd	s0,16(sp)
    800017a8:	e426                	sd	s1,8(sp)
    800017aa:	e04a                	sd	s2,0(sp)
    800017ac:	1000                	addi	s0,sp,32
    800017ae:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	90a080e7          	jalr	-1782(ra) # 800060ba <acquire>
  k = p->killed;
    800017b8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	9b0080e7          	jalr	-1616(ra) # 8000616e <release>
  return k;
}
    800017c6:	854a                	mv	a0,s2
    800017c8:	60e2                	ld	ra,24(sp)
    800017ca:	6442                	ld	s0,16(sp)
    800017cc:	64a2                	ld	s1,8(sp)
    800017ce:	6902                	ld	s2,0(sp)
    800017d0:	6105                	addi	sp,sp,32
    800017d2:	8082                	ret

00000000800017d4 <wait>:
{
    800017d4:	715d                	addi	sp,sp,-80
    800017d6:	e486                	sd	ra,72(sp)
    800017d8:	e0a2                	sd	s0,64(sp)
    800017da:	fc26                	sd	s1,56(sp)
    800017dc:	f84a                	sd	s2,48(sp)
    800017de:	f44e                	sd	s3,40(sp)
    800017e0:	f052                	sd	s4,32(sp)
    800017e2:	ec56                	sd	s5,24(sp)
    800017e4:	e85a                	sd	s6,16(sp)
    800017e6:	e45e                	sd	s7,8(sp)
    800017e8:	e062                	sd	s8,0(sp)
    800017ea:	0880                	addi	s0,sp,80
    800017ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ee:	fffff097          	auipc	ra,0xfffff
    800017f2:	664080e7          	jalr	1636(ra) # 80000e52 <myproc>
    800017f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	10050513          	addi	a0,a0,256 # 800088f8 <wait_lock>
    80001800:	00005097          	auipc	ra,0x5
    80001804:	8ba080e7          	jalr	-1862(ra) # 800060ba <acquire>
    havekids = 0;
    80001808:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180a:	4a15                	li	s4,5
        havekids = 1;
    8000180c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180e:	0000d997          	auipc	s3,0xd
    80001812:	f0298993          	addi	s3,s3,-254 # 8000e710 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001816:	00007c17          	auipc	s8,0x7
    8000181a:	0e2c0c13          	addi	s8,s8,226 # 800088f8 <wait_lock>
    havekids = 0;
    8000181e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001820:	00007497          	auipc	s1,0x7
    80001824:	4f048493          	addi	s1,s1,1264 # 80008d10 <proc>
    80001828:	a0bd                	j	80001896 <wait+0xc2>
          pid = pp->pid;
    8000182a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000182e:	000b0e63          	beqz	s6,8000184a <wait+0x76>
    80001832:	4691                	li	a3,4
    80001834:	02c48613          	addi	a2,s1,44
    80001838:	85da                	mv	a1,s6
    8000183a:	05093503          	ld	a0,80(s2)
    8000183e:	fffff097          	auipc	ra,0xfffff
    80001842:	2d0080e7          	jalr	720(ra) # 80000b0e <copyout>
    80001846:	02054563          	bltz	a0,80001870 <wait+0x9c>
          freeproc(pp);
    8000184a:	8526                	mv	a0,s1
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	7b8080e7          	jalr	1976(ra) # 80001004 <freeproc>
          release(&pp->lock);
    80001854:	8526                	mv	a0,s1
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	918080e7          	jalr	-1768(ra) # 8000616e <release>
          release(&wait_lock);
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	09a50513          	addi	a0,a0,154 # 800088f8 <wait_lock>
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	908080e7          	jalr	-1784(ra) # 8000616e <release>
          return pid;
    8000186e:	a0b5                	j	800018da <wait+0x106>
            release(&pp->lock);
    80001870:	8526                	mv	a0,s1
    80001872:	00005097          	auipc	ra,0x5
    80001876:	8fc080e7          	jalr	-1796(ra) # 8000616e <release>
            release(&wait_lock);
    8000187a:	00007517          	auipc	a0,0x7
    8000187e:	07e50513          	addi	a0,a0,126 # 800088f8 <wait_lock>
    80001882:	00005097          	auipc	ra,0x5
    80001886:	8ec080e7          	jalr	-1812(ra) # 8000616e <release>
            return -1;
    8000188a:	59fd                	li	s3,-1
    8000188c:	a0b9                	j	800018da <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000188e:	16848493          	addi	s1,s1,360
    80001892:	03348463          	beq	s1,s3,800018ba <wait+0xe6>
      if(pp->parent == p){
    80001896:	7c9c                	ld	a5,56(s1)
    80001898:	ff279be3          	bne	a5,s2,8000188e <wait+0xba>
        acquire(&pp->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	81c080e7          	jalr	-2020(ra) # 800060ba <acquire>
        if(pp->state == ZOMBIE){
    800018a6:	4c9c                	lw	a5,24(s1)
    800018a8:	f94781e3          	beq	a5,s4,8000182a <wait+0x56>
        release(&pp->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	8c0080e7          	jalr	-1856(ra) # 8000616e <release>
        havekids = 1;
    800018b6:	8756                	mv	a4,s5
    800018b8:	bfd9                	j	8000188e <wait+0xba>
    if(!havekids || killed(p)){
    800018ba:	c719                	beqz	a4,800018c8 <wait+0xf4>
    800018bc:	854a                	mv	a0,s2
    800018be:	00000097          	auipc	ra,0x0
    800018c2:	ee4080e7          	jalr	-284(ra) # 800017a2 <killed>
    800018c6:	c51d                	beqz	a0,800018f4 <wait+0x120>
      release(&wait_lock);
    800018c8:	00007517          	auipc	a0,0x7
    800018cc:	03050513          	addi	a0,a0,48 # 800088f8 <wait_lock>
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	89e080e7          	jalr	-1890(ra) # 8000616e <release>
      return -1;
    800018d8:	59fd                	li	s3,-1
}
    800018da:	854e                	mv	a0,s3
    800018dc:	60a6                	ld	ra,72(sp)
    800018de:	6406                	ld	s0,64(sp)
    800018e0:	74e2                	ld	s1,56(sp)
    800018e2:	7942                	ld	s2,48(sp)
    800018e4:	79a2                	ld	s3,40(sp)
    800018e6:	7a02                	ld	s4,32(sp)
    800018e8:	6ae2                	ld	s5,24(sp)
    800018ea:	6b42                	ld	s6,16(sp)
    800018ec:	6ba2                	ld	s7,8(sp)
    800018ee:	6c02                	ld	s8,0(sp)
    800018f0:	6161                	addi	sp,sp,80
    800018f2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f4:	85e2                	mv	a1,s8
    800018f6:	854a                	mv	a0,s2
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	c02080e7          	jalr	-1022(ra) # 800014fa <sleep>
    havekids = 0;
    80001900:	bf39                	j	8000181e <wait+0x4a>

0000000080001902 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	84aa                	mv	s1,a0
    80001914:	892e                	mv	s2,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	538080e7          	jalr	1336(ra) # 80000e52 <myproc>
  if(user_dst){
    80001922:	c08d                	beqz	s1,80001944 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	1e2080e7          	jalr	482(ra) # 80000b0e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove((char *)dst, src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	888080e7          	jalr	-1912(ra) # 800001d4 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyout+0x32>

0000000080001958 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
    8000196a:	84ae                	mv	s1,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	4e2080e7          	jalr	1250(ra) # 80000e52 <myproc>
  if(user_src){
    80001978:	c08d                	beqz	s1,8000199a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	218080e7          	jalr	536(ra) # 80000b9a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	832080e7          	jalr	-1998(ra) # 800001d4 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyin+0x32>

00000000800019ae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c4:	00006517          	auipc	a0,0x6
    800019c8:	68450513          	addi	a0,a0,1668 # 80008048 <etext+0x48>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	1fc080e7          	jalr	508(ra) # 80005bc8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00007497          	auipc	s1,0x7
    800019d8:	49448493          	addi	s1,s1,1172 # 80008e68 <proc+0x158>
    800019dc:	0000d917          	auipc	s2,0xd
    800019e0:	e8c90913          	addi	s2,s2,-372 # 8000e868 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e6:	00007997          	auipc	s3,0x7
    800019ea:	81a98993          	addi	s3,s3,-2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00007a97          	auipc	s5,0x7
    800019f2:	81aa8a93          	addi	s5,s5,-2022 # 80008208 <etext+0x208>
    printf("\n");
    800019f6:	00006a17          	auipc	s4,0x6
    800019fa:	652a0a13          	addi	s4,s4,1618 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fe:	00007b97          	auipc	s7,0x7
    80001a02:	84ab8b93          	addi	s7,s7,-1974 # 80008248 <states.0>
    80001a06:	a00d                	j	80001a28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a08:	ed86a583          	lw	a1,-296(a3)
    80001a0c:	8556                	mv	a0,s5
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	1ba080e7          	jalr	442(ra) # 80005bc8 <printf>
    printf("\n");
    80001a16:	8552                	mv	a0,s4
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	1b0080e7          	jalr	432(ra) # 80005bc8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	16848493          	addi	s1,s1,360
    80001a24:	03248163          	beq	s1,s2,80001a46 <procdump+0x98>
    if(p->state == UNUSED)
    80001a28:	86a6                	mv	a3,s1
    80001a2a:	ec04a783          	lw	a5,-320(s1)
    80001a2e:	dbed                	beqz	a5,80001a20 <procdump+0x72>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	fcfb6be3          	bltu	s6,a5,80001a08 <procdump+0x5a>
    80001a36:	1782                	slli	a5,a5,0x20
    80001a38:	9381                	srli	a5,a5,0x20
    80001a3a:	078e                	slli	a5,a5,0x3
    80001a3c:	97de                	add	a5,a5,s7
    80001a3e:	6390                	ld	a2,0(a5)
    80001a40:	f661                	bnez	a2,80001a08 <procdump+0x5a>
      state = "???";
    80001a42:	864e                	mv	a2,s3
    80001a44:	b7d1                	j	80001a08 <procdump+0x5a>
  }
}
    80001a46:	60a6                	ld	ra,72(sp)
    80001a48:	6406                	ld	s0,64(sp)
    80001a4a:	74e2                	ld	s1,56(sp)
    80001a4c:	7942                	ld	s2,48(sp)
    80001a4e:	79a2                	ld	s3,40(sp)
    80001a50:	7a02                	ld	s4,32(sp)
    80001a52:	6ae2                	ld	s5,24(sp)
    80001a54:	6b42                	ld	s6,16(sp)
    80001a56:	6ba2                	ld	s7,8(sp)
    80001a58:	6161                	addi	sp,sp,80
    80001a5a:	8082                	ret

0000000080001a5c <swtch>:
    80001a5c:	00153023          	sd	ra,0(a0)
    80001a60:	00253423          	sd	sp,8(a0)
    80001a64:	e900                	sd	s0,16(a0)
    80001a66:	ed04                	sd	s1,24(a0)
    80001a68:	03253023          	sd	s2,32(a0)
    80001a6c:	03353423          	sd	s3,40(a0)
    80001a70:	03453823          	sd	s4,48(a0)
    80001a74:	03553c23          	sd	s5,56(a0)
    80001a78:	05653023          	sd	s6,64(a0)
    80001a7c:	05753423          	sd	s7,72(a0)
    80001a80:	05853823          	sd	s8,80(a0)
    80001a84:	05953c23          	sd	s9,88(a0)
    80001a88:	07a53023          	sd	s10,96(a0)
    80001a8c:	07b53423          	sd	s11,104(a0)
    80001a90:	0005b083          	ld	ra,0(a1)
    80001a94:	0085b103          	ld	sp,8(a1)
    80001a98:	6980                	ld	s0,16(a1)
    80001a9a:	6d84                	ld	s1,24(a1)
    80001a9c:	0205b903          	ld	s2,32(a1)
    80001aa0:	0285b983          	ld	s3,40(a1)
    80001aa4:	0305ba03          	ld	s4,48(a1)
    80001aa8:	0385ba83          	ld	s5,56(a1)
    80001aac:	0405bb03          	ld	s6,64(a1)
    80001ab0:	0485bb83          	ld	s7,72(a1)
    80001ab4:	0505bc03          	ld	s8,80(a1)
    80001ab8:	0585bc83          	ld	s9,88(a1)
    80001abc:	0605bd03          	ld	s10,96(a1)
    80001ac0:	0685bd83          	ld	s11,104(a1)
    80001ac4:	8082                	ret

0000000080001ac6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac6:	1141                	addi	sp,sp,-16
    80001ac8:	e406                	sd	ra,8(sp)
    80001aca:	e022                	sd	s0,0(sp)
    80001acc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ace:	00006597          	auipc	a1,0x6
    80001ad2:	7aa58593          	addi	a1,a1,1962 # 80008278 <states.0+0x30>
    80001ad6:	0000d517          	auipc	a0,0xd
    80001ada:	c3a50513          	addi	a0,a0,-966 # 8000e710 <tickslock>
    80001ade:	00004097          	auipc	ra,0x4
    80001ae2:	54c080e7          	jalr	1356(ra) # 8000602a <initlock>
}
    80001ae6:	60a2                	ld	ra,8(sp)
    80001ae8:	6402                	ld	s0,0(sp)
    80001aea:	0141                	addi	sp,sp,16
    80001aec:	8082                	ret

0000000080001aee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aee:	1141                	addi	sp,sp,-16
    80001af0:	e422                	sd	s0,8(sp)
    80001af2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af4:	00003797          	auipc	a5,0x3
    80001af8:	4bc78793          	addi	a5,a5,1212 # 80004fb0 <kernelvec>
    80001afc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b00:	6422                	ld	s0,8(sp)
    80001b02:	0141                	addi	sp,sp,16
    80001b04:	8082                	ret

0000000080001b06 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b06:	1141                	addi	sp,sp,-16
    80001b08:	e406                	sd	ra,8(sp)
    80001b0a:	e022                	sd	s0,0(sp)
    80001b0c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	344080e7          	jalr	836(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b20:	00005617          	auipc	a2,0x5
    80001b24:	4e060613          	addi	a2,a2,1248 # 80007000 <_trampoline>
    80001b28:	00005697          	auipc	a3,0x5
    80001b2c:	4d868693          	addi	a3,a3,1240 # 80007000 <_trampoline>
    80001b30:	8e91                	sub	a3,a3,a2
    80001b32:	040007b7          	lui	a5,0x4000
    80001b36:	17fd                	addi	a5,a5,-1
    80001b38:	07b2                	slli	a5,a5,0xc
    80001b3a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3c:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b40:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b42:	180026f3          	csrr	a3,satp
    80001b46:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b48:	6d38                	ld	a4,88(a0)
    80001b4a:	6134                	ld	a3,64(a0)
    80001b4c:	6585                	lui	a1,0x1
    80001b4e:	96ae                	add	a3,a3,a1
    80001b50:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b52:	6d38                	ld	a4,88(a0)
    80001b54:	00000697          	auipc	a3,0x0
    80001b58:	13068693          	addi	a3,a3,304 # 80001c84 <usertrap>
    80001b5c:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b60:	8692                	mv	a3,tp
    80001b62:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b64:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b68:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b70:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b74:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b76:	6f18                	ld	a4,24(a4)
    80001b78:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7c:	6928                	ld	a0,80(a0)
    80001b7e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b80:	00005717          	auipc	a4,0x5
    80001b84:	51c70713          	addi	a4,a4,1308 # 8000709c <userret>
    80001b88:	8f11                	sub	a4,a4,a2
    80001b8a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8c:	577d                	li	a4,-1
    80001b8e:	177e                	slli	a4,a4,0x3f
    80001b90:	8d59                	or	a0,a0,a4
    80001b92:	9782                	jalr	a5
}
    80001b94:	60a2                	ld	ra,8(sp)
    80001b96:	6402                	ld	s0,0(sp)
    80001b98:	0141                	addi	sp,sp,16
    80001b9a:	8082                	ret

0000000080001b9c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9c:	1101                	addi	sp,sp,-32
    80001b9e:	ec06                	sd	ra,24(sp)
    80001ba0:	e822                	sd	s0,16(sp)
    80001ba2:	e426                	sd	s1,8(sp)
    80001ba4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba6:	0000d497          	auipc	s1,0xd
    80001baa:	b6a48493          	addi	s1,s1,-1174 # 8000e710 <tickslock>
    80001bae:	8526                	mv	a0,s1
    80001bb0:	00004097          	auipc	ra,0x4
    80001bb4:	50a080e7          	jalr	1290(ra) # 800060ba <acquire>
  ticks++;
    80001bb8:	00007517          	auipc	a0,0x7
    80001bbc:	cf050513          	addi	a0,a0,-784 # 800088a8 <ticks>
    80001bc0:	411c                	lw	a5,0(a0)
    80001bc2:	2785                	addiw	a5,a5,1
    80001bc4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc6:	00000097          	auipc	ra,0x0
    80001bca:	998080e7          	jalr	-1640(ra) # 8000155e <wakeup>
  release(&tickslock);
    80001bce:	8526                	mv	a0,s1
    80001bd0:	00004097          	auipc	ra,0x4
    80001bd4:	59e080e7          	jalr	1438(ra) # 8000616e <release>
}
    80001bd8:	60e2                	ld	ra,24(sp)
    80001bda:	6442                	ld	s0,16(sp)
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	6105                	addi	sp,sp,32
    80001be0:	8082                	ret

0000000080001be2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	e426                	sd	s1,8(sp)
    80001bea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bec:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf0:	00074d63          	bltz	a4,80001c0a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf4:	57fd                	li	a5,-1
    80001bf6:	17fe                	slli	a5,a5,0x3f
    80001bf8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bfa:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfc:	06f70363          	beq	a4,a5,80001c62 <devintr+0x80>
  }
}
    80001c00:	60e2                	ld	ra,24(sp)
    80001c02:	6442                	ld	s0,16(sp)
    80001c04:	64a2                	ld	s1,8(sp)
    80001c06:	6105                	addi	sp,sp,32
    80001c08:	8082                	ret
     (scause & 0xff) == 9){
    80001c0a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c0e:	46a5                	li	a3,9
    80001c10:	fed792e3          	bne	a5,a3,80001bf4 <devintr+0x12>
    int irq = plic_claim();
    80001c14:	00003097          	auipc	ra,0x3
    80001c18:	4a4080e7          	jalr	1188(ra) # 800050b8 <plic_claim>
    80001c1c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1e:	47a9                	li	a5,10
    80001c20:	02f50763          	beq	a0,a5,80001c4e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c24:	4785                	li	a5,1
    80001c26:	02f50963          	beq	a0,a5,80001c58 <devintr+0x76>
    return 1;
    80001c2a:	4505                	li	a0,1
    } else if(irq){
    80001c2c:	d8f1                	beqz	s1,80001c00 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2e:	85a6                	mv	a1,s1
    80001c30:	00006517          	auipc	a0,0x6
    80001c34:	65050513          	addi	a0,a0,1616 # 80008280 <states.0+0x38>
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	f90080e7          	jalr	-112(ra) # 80005bc8 <printf>
      plic_complete(irq);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00003097          	auipc	ra,0x3
    80001c46:	49a080e7          	jalr	1178(ra) # 800050dc <plic_complete>
    return 1;
    80001c4a:	4505                	li	a0,1
    80001c4c:	bf55                	j	80001c00 <devintr+0x1e>
      uartintr();
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	38c080e7          	jalr	908(ra) # 80005fda <uartintr>
    80001c56:	b7ed                	j	80001c40 <devintr+0x5e>
      virtio_disk_intr();
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	950080e7          	jalr	-1712(ra) # 800055a8 <virtio_disk_intr>
    80001c60:	b7c5                	j	80001c40 <devintr+0x5e>
    if(cpuid() == 0){
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	1c4080e7          	jalr	452(ra) # 80000e26 <cpuid>
    80001c6a:	c901                	beqz	a0,80001c7a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c70:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c72:	14479073          	csrw	sip,a5
    return 2;
    80001c76:	4509                	li	a0,2
    80001c78:	b761                	j	80001c00 <devintr+0x1e>
      clockintr();
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	f22080e7          	jalr	-222(ra) # 80001b9c <clockintr>
    80001c82:	b7ed                	j	80001c6c <devintr+0x8a>

0000000080001c84 <usertrap>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	e04a                	sd	s2,0(sp)
    80001c8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c90:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c94:	1007f793          	andi	a5,a5,256
    80001c98:	e3b1                	bnez	a5,80001cdc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9a:	00003797          	auipc	a5,0x3
    80001c9e:	31678793          	addi	a5,a5,790 # 80004fb0 <kernelvec>
    80001ca2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	1ac080e7          	jalr	428(ra) # 80000e52 <myproc>
    80001cae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb2:	14102773          	csrr	a4,sepc
    80001cb6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cbc:	47a1                	li	a5,8
    80001cbe:	02f70763          	beq	a4,a5,80001cec <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	f20080e7          	jalr	-224(ra) # 80001be2 <devintr>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	c151                	beqz	a0,80001d50 <usertrap+0xcc>
  if(killed(p))
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	ad2080e7          	jalr	-1326(ra) # 800017a2 <killed>
    80001cd8:	c929                	beqz	a0,80001d2a <usertrap+0xa6>
    80001cda:	a099                	j	80001d20 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5c450513          	addi	a0,a0,1476 # 800082a0 <states.0+0x58>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	e9a080e7          	jalr	-358(ra) # 80005b7e <panic>
    if(killed(p))
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	ab6080e7          	jalr	-1354(ra) # 800017a2 <killed>
    80001cf4:	e921                	bnez	a0,80001d44 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cf6:	6cb8                	ld	a4,88(s1)
    80001cf8:	6f1c                	ld	a5,24(a4)
    80001cfa:	0791                	addi	a5,a5,4
    80001cfc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d02:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d06:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	2d4080e7          	jalr	724(ra) # 80001fde <syscall>
  if(killed(p))
    80001d12:	8526                	mv	a0,s1
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a8e080e7          	jalr	-1394(ra) # 800017a2 <killed>
    80001d1c:	c911                	beqz	a0,80001d30 <usertrap+0xac>
    80001d1e:	4901                	li	s2,0
    exit(-1);
    80001d20:	557d                	li	a0,-1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	90c080e7          	jalr	-1780(ra) # 8000162e <exit>
  if(which_dev == 2)
    80001d2a:	4789                	li	a5,2
    80001d2c:	04f90f63          	beq	s2,a5,80001d8a <usertrap+0x106>
  usertrapret();
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	dd6080e7          	jalr	-554(ra) # 80001b06 <usertrapret>
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
      exit(-1);
    80001d44:	557d                	li	a0,-1
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	8e8080e7          	jalr	-1816(ra) # 8000162e <exit>
    80001d4e:	b765                	j	80001cf6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d50:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d54:	5890                	lw	a2,48(s1)
    80001d56:	00006517          	auipc	a0,0x6
    80001d5a:	56a50513          	addi	a0,a0,1386 # 800082c0 <states.0+0x78>
    80001d5e:	00004097          	auipc	ra,0x4
    80001d62:	e6a080e7          	jalr	-406(ra) # 80005bc8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d66:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6e:	00006517          	auipc	a0,0x6
    80001d72:	58250513          	addi	a0,a0,1410 # 800082f0 <states.0+0xa8>
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	e52080e7          	jalr	-430(ra) # 80005bc8 <printf>
    setkilled(p);
    80001d7e:	8526                	mv	a0,s1
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	9f6080e7          	jalr	-1546(ra) # 80001776 <setkilled>
    80001d88:	b769                	j	80001d12 <usertrap+0x8e>
    yield();
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	734080e7          	jalr	1844(ra) # 800014be <yield>
    80001d92:	bf79                	j	80001d30 <usertrap+0xac>

0000000080001d94 <kerneltrap>:
{
    80001d94:	7179                	addi	sp,sp,-48
    80001d96:	f406                	sd	ra,40(sp)
    80001d98:	f022                	sd	s0,32(sp)
    80001d9a:	ec26                	sd	s1,24(sp)
    80001d9c:	e84a                	sd	s2,16(sp)
    80001d9e:	e44e                	sd	s3,8(sp)
    80001da0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001daa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dae:	1004f793          	andi	a5,s1,256
    80001db2:	cb85                	beqz	a5,80001de2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dba:	ef85                	bnez	a5,80001df2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	e26080e7          	jalr	-474(ra) # 80001be2 <devintr>
    80001dc4:	cd1d                	beqz	a0,80001e02 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc6:	4789                	li	a5,2
    80001dc8:	06f50a63          	beq	a0,a5,80001e3c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dcc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd0:	10049073          	csrw	sstatus,s1
}
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6145                	addi	sp,sp,48
    80001de0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	52e50513          	addi	a0,a0,1326 # 80008310 <states.0+0xc8>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	d94080e7          	jalr	-620(ra) # 80005b7e <panic>
    panic("kerneltrap: interrupts enabled");
    80001df2:	00006517          	auipc	a0,0x6
    80001df6:	54650513          	addi	a0,a0,1350 # 80008338 <states.0+0xf0>
    80001dfa:	00004097          	auipc	ra,0x4
    80001dfe:	d84080e7          	jalr	-636(ra) # 80005b7e <panic>
    printf("scause %p\n", scause);
    80001e02:	85ce                	mv	a1,s3
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	55450513          	addi	a0,a0,1364 # 80008358 <states.0+0x110>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	dbc080e7          	jalr	-580(ra) # 80005bc8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e18:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	54c50513          	addi	a0,a0,1356 # 80008368 <states.0+0x120>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	da4080e7          	jalr	-604(ra) # 80005bc8 <printf>
    panic("kerneltrap");
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	55450513          	addi	a0,a0,1364 # 80008380 <states.0+0x138>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	d4a080e7          	jalr	-694(ra) # 80005b7e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	016080e7          	jalr	22(ra) # 80000e52 <myproc>
    80001e44:	d541                	beqz	a0,80001dcc <kerneltrap+0x38>
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	00c080e7          	jalr	12(ra) # 80000e52 <myproc>
    80001e4e:	4d18                	lw	a4,24(a0)
    80001e50:	4791                	li	a5,4
    80001e52:	f6f71de3          	bne	a4,a5,80001dcc <kerneltrap+0x38>
    yield();
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	668080e7          	jalr	1640(ra) # 800014be <yield>
    80001e5e:	b7bd                	j	80001dcc <kerneltrap+0x38>

0000000080001e60 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	1000                	addi	s0,sp,32
    80001e6a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	fe6080e7          	jalr	-26(ra) # 80000e52 <myproc>
  switch (n) {
    80001e74:	4795                	li	a5,5
    80001e76:	0497e163          	bltu	a5,s1,80001eb8 <argraw+0x58>
    80001e7a:	048a                	slli	s1,s1,0x2
    80001e7c:	00006717          	auipc	a4,0x6
    80001e80:	53c70713          	addi	a4,a4,1340 # 800083b8 <states.0+0x170>
    80001e84:	94ba                	add	s1,s1,a4
    80001e86:	409c                	lw	a5,0(s1)
    80001e88:	97ba                	add	a5,a5,a4
    80001e8a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e90:	60e2                	ld	ra,24(sp)
    80001e92:	6442                	ld	s0,16(sp)
    80001e94:	64a2                	ld	s1,8(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret
    return p->trapframe->a1;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7fa8                	ld	a0,120(a5)
    80001e9e:	bfcd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a2;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	63c8                	ld	a0,128(a5)
    80001ea4:	b7f5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a3;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	67c8                	ld	a0,136(a5)
    80001eaa:	b7dd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a4;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	6bc8                	ld	a0,144(a5)
    80001eb0:	b7c5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a5;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6fc8                	ld	a0,152(a5)
    80001eb6:	bfe9                	j	80001e90 <argraw+0x30>
  panic("argraw");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	4d850513          	addi	a0,a0,1240 # 80008390 <states.0+0x148>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	cbe080e7          	jalr	-834(ra) # 80005b7e <panic>

0000000080001ec8 <fetchaddr>:
{
    80001ec8:	1101                	addi	sp,sp,-32
    80001eca:	ec06                	sd	ra,24(sp)
    80001ecc:	e822                	sd	s0,16(sp)
    80001ece:	e426                	sd	s1,8(sp)
    80001ed0:	e04a                	sd	s2,0(sp)
    80001ed2:	1000                	addi	s0,sp,32
    80001ed4:	84aa                	mv	s1,a0
    80001ed6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	f7a080e7          	jalr	-134(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee0:	653c                	ld	a5,72(a0)
    80001ee2:	02f4f863          	bgeu	s1,a5,80001f12 <fetchaddr+0x4a>
    80001ee6:	00848713          	addi	a4,s1,8
    80001eea:	02e7e663          	bltu	a5,a4,80001f16 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001eee:	46a1                	li	a3,8
    80001ef0:	8626                	mv	a2,s1
    80001ef2:	85ca                	mv	a1,s2
    80001ef4:	6928                	ld	a0,80(a0)
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	ca4080e7          	jalr	-860(ra) # 80000b9a <copyin>
    80001efe:	00a03533          	snez	a0,a0
    80001f02:	40a00533          	neg	a0,a0
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6902                	ld	s2,0(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret
    return -1;
    80001f12:	557d                	li	a0,-1
    80001f14:	bfcd                	j	80001f06 <fetchaddr+0x3e>
    80001f16:	557d                	li	a0,-1
    80001f18:	b7fd                	j	80001f06 <fetchaddr+0x3e>

0000000080001f1a <fetchstr>:
{
    80001f1a:	7179                	addi	sp,sp,-48
    80001f1c:	f406                	sd	ra,40(sp)
    80001f1e:	f022                	sd	s0,32(sp)
    80001f20:	ec26                	sd	s1,24(sp)
    80001f22:	e84a                	sd	s2,16(sp)
    80001f24:	e44e                	sd	s3,8(sp)
    80001f26:	1800                	addi	s0,sp,48
    80001f28:	892a                	mv	s2,a0
    80001f2a:	84ae                	mv	s1,a1
    80001f2c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	f24080e7          	jalr	-220(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f36:	86ce                	mv	a3,s3
    80001f38:	864a                	mv	a2,s2
    80001f3a:	85a6                	mv	a1,s1
    80001f3c:	6928                	ld	a0,80(a0)
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	cea080e7          	jalr	-790(ra) # 80000c28 <copyinstr>
    80001f46:	00054e63          	bltz	a0,80001f62 <fetchstr+0x48>
  return strlen(buf);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	ffffe097          	auipc	ra,0xffffe
    80001f50:	3a8080e7          	jalr	936(ra) # 800002f4 <strlen>
}
    80001f54:	70a2                	ld	ra,40(sp)
    80001f56:	7402                	ld	s0,32(sp)
    80001f58:	64e2                	ld	s1,24(sp)
    80001f5a:	6942                	ld	s2,16(sp)
    80001f5c:	69a2                	ld	s3,8(sp)
    80001f5e:	6145                	addi	sp,sp,48
    80001f60:	8082                	ret
    return -1;
    80001f62:	557d                	li	a0,-1
    80001f64:	bfc5                	j	80001f54 <fetchstr+0x3a>

0000000080001f66 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	eee080e7          	jalr	-274(ra) # 80001e60 <argraw>
    80001f7a:	c088                	sw	a0,0(s1)
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	ece080e7          	jalr	-306(ra) # 80001e60 <argraw>
    80001f9a:	e088                	sd	a0,0(s1)
}
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa6:	7179                	addi	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	84ae                	mv	s1,a1
    80001fb4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fb6:	fd840593          	addi	a1,s0,-40
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	fcc080e7          	jalr	-52(ra) # 80001f86 <argaddr>
  return fetchstr(addr, buf, max);
    80001fc2:	864a                	mv	a2,s2
    80001fc4:	85a6                	mv	a1,s1
    80001fc6:	fd843503          	ld	a0,-40(s0)
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	f50080e7          	jalr	-176(ra) # 80001f1a <fetchstr>
}
    80001fd2:	70a2                	ld	ra,40(sp)
    80001fd4:	7402                	ld	s0,32(sp)
    80001fd6:	64e2                	ld	s1,24(sp)
    80001fd8:	6942                	ld	s2,16(sp)
    80001fda:	6145                	addi	sp,sp,48
    80001fdc:	8082                	ret

0000000080001fde <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e68080e7          	jalr	-408(ra) # 80000e52 <myproc>
    80001ff2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff4:	05853903          	ld	s2,88(a0)
    80001ff8:	0a893783          	ld	a5,168(s2)
    80001ffc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002000:	37fd                	addiw	a5,a5,-1
    80002002:	4751                	li	a4,20
    80002004:	00f76f63          	bltu	a4,a5,80002022 <syscall+0x44>
    80002008:	00369713          	slli	a4,a3,0x3
    8000200c:	00006797          	auipc	a5,0x6
    80002010:	3c478793          	addi	a5,a5,964 # 800083d0 <syscalls>
    80002014:	97ba                	add	a5,a5,a4
    80002016:	639c                	ld	a5,0(a5)
    80002018:	c789                	beqz	a5,80002022 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000201a:	9782                	jalr	a5
    8000201c:	06a93823          	sd	a0,112(s2)
    80002020:	a839                	j	8000203e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002022:	15848613          	addi	a2,s1,344
    80002026:	588c                	lw	a1,48(s1)
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	37050513          	addi	a0,a0,880 # 80008398 <states.0+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	b98080e7          	jalr	-1128(ra) # 80005bc8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	577d                	li	a4,-1
    8000203c:	fbb8                	sd	a4,112(a5)
  }
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002052:	fec40593          	addi	a1,s0,-20
    80002056:	4501                	li	a0,0
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	f0e080e7          	jalr	-242(ra) # 80001f66 <argint>
  exit(n);
    80002060:	fec42503          	lw	a0,-20(s0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	5ca080e7          	jalr	1482(ra) # 8000162e <exit>
  return 0;  // not reached
}
    8000206c:	4501                	li	a0,0
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	6105                	addi	sp,sp,32
    80002074:	8082                	ret

0000000080002076 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002076:	1141                	addi	sp,sp,-16
    80002078:	e406                	sd	ra,8(sp)
    8000207a:	e022                	sd	s0,0(sp)
    8000207c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	dd4080e7          	jalr	-556(ra) # 80000e52 <myproc>
}
    80002086:	5908                	lw	a0,48(a0)
    80002088:	60a2                	ld	ra,8(sp)
    8000208a:	6402                	ld	s0,0(sp)
    8000208c:	0141                	addi	sp,sp,16
    8000208e:	8082                	ret

0000000080002090 <sys_fork>:

uint64
sys_fork(void)
{
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
  return fork();
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	170080e7          	jalr	368(ra) # 80001208 <fork>
}
    800020a0:	60a2                	ld	ra,8(sp)
    800020a2:	6402                	ld	s0,0(sp)
    800020a4:	0141                	addi	sp,sp,16
    800020a6:	8082                	ret

00000000800020a8 <sys_wait>:

uint64
sys_wait(void)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b0:	fe840593          	addi	a1,s0,-24
    800020b4:	4501                	li	a0,0
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	ed0080e7          	jalr	-304(ra) # 80001f86 <argaddr>
  return wait(p);
    800020be:	fe843503          	ld	a0,-24(s0)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	712080e7          	jalr	1810(ra) # 800017d4 <wait>
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020dc:	fdc40593          	addi	a1,s0,-36
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	e84080e7          	jalr	-380(ra) # 80001f66 <argint>
  addr = myproc()->sz;
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	d68080e7          	jalr	-664(ra) # 80000e52 <myproc>
    800020f2:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f4:	fdc42503          	lw	a0,-36(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	0b4080e7          	jalr	180(ra) # 800011ac <growproc>
    80002100:	00054863          	bltz	a0,80002110 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002104:	8526                	mv	a0,s1
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6145                	addi	sp,sp,48
    8000210e:	8082                	ret
    return -1;
    80002110:	54fd                	li	s1,-1
    80002112:	bfcd                	j	80002104 <sys_sbrk+0x32>

0000000080002114 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002114:	7139                	addi	sp,sp,-64
    80002116:	fc06                	sd	ra,56(sp)
    80002118:	f822                	sd	s0,48(sp)
    8000211a:	f426                	sd	s1,40(sp)
    8000211c:	f04a                	sd	s2,32(sp)
    8000211e:	ec4e                	sd	s3,24(sp)
    80002120:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002122:	fcc40593          	addi	a1,s0,-52
    80002126:	4501                	li	a0,0
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	e3e080e7          	jalr	-450(ra) # 80001f66 <argint>
  acquire(&tickslock);
    80002130:	0000c517          	auipc	a0,0xc
    80002134:	5e050513          	addi	a0,a0,1504 # 8000e710 <tickslock>
    80002138:	00004097          	auipc	ra,0x4
    8000213c:	f82080e7          	jalr	-126(ra) # 800060ba <acquire>
  ticks0 = ticks;
    80002140:	00006917          	auipc	s2,0x6
    80002144:	76892903          	lw	s2,1896(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    80002148:	fcc42783          	lw	a5,-52(s0)
    8000214c:	cf9d                	beqz	a5,8000218a <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000214e:	0000c997          	auipc	s3,0xc
    80002152:	5c298993          	addi	s3,s3,1474 # 8000e710 <tickslock>
    80002156:	00006497          	auipc	s1,0x6
    8000215a:	75248493          	addi	s1,s1,1874 # 800088a8 <ticks>
    if(killed(myproc())){
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	cf4080e7          	jalr	-780(ra) # 80000e52 <myproc>
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	63c080e7          	jalr	1596(ra) # 800017a2 <killed>
    8000216e:	ed15                	bnez	a0,800021aa <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002170:	85ce                	mv	a1,s3
    80002172:	8526                	mv	a0,s1
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	386080e7          	jalr	902(ra) # 800014fa <sleep>
  while(ticks - ticks0 < n){
    8000217c:	409c                	lw	a5,0(s1)
    8000217e:	412787bb          	subw	a5,a5,s2
    80002182:	fcc42703          	lw	a4,-52(s0)
    80002186:	fce7ece3          	bltu	a5,a4,8000215e <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000218a:	0000c517          	auipc	a0,0xc
    8000218e:	58650513          	addi	a0,a0,1414 # 8000e710 <tickslock>
    80002192:	00004097          	auipc	ra,0x4
    80002196:	fdc080e7          	jalr	-36(ra) # 8000616e <release>
  return 0;
    8000219a:	4501                	li	a0,0
}
    8000219c:	70e2                	ld	ra,56(sp)
    8000219e:	7442                	ld	s0,48(sp)
    800021a0:	74a2                	ld	s1,40(sp)
    800021a2:	7902                	ld	s2,32(sp)
    800021a4:	69e2                	ld	s3,24(sp)
    800021a6:	6121                	addi	sp,sp,64
    800021a8:	8082                	ret
      release(&tickslock);
    800021aa:	0000c517          	auipc	a0,0xc
    800021ae:	56650513          	addi	a0,a0,1382 # 8000e710 <tickslock>
    800021b2:	00004097          	auipc	ra,0x4
    800021b6:	fbc080e7          	jalr	-68(ra) # 8000616e <release>
      return -1;
    800021ba:	557d                	li	a0,-1
    800021bc:	b7c5                	j	8000219c <sys_sleep+0x88>

00000000800021be <sys_kill>:

uint64
sys_kill(void)
{
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021c6:	fec40593          	addi	a1,s0,-20
    800021ca:	4501                	li	a0,0
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	d9a080e7          	jalr	-614(ra) # 80001f66 <argint>
  return kill(pid);
    800021d4:	fec42503          	lw	a0,-20(s0)
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	52c080e7          	jalr	1324(ra) # 80001704 <kill>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	e426                	sd	s1,8(sp)
    800021f0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021f2:	0000c517          	auipc	a0,0xc
    800021f6:	51e50513          	addi	a0,a0,1310 # 8000e710 <tickslock>
    800021fa:	00004097          	auipc	ra,0x4
    800021fe:	ec0080e7          	jalr	-320(ra) # 800060ba <acquire>
  xticks = ticks;
    80002202:	00006497          	auipc	s1,0x6
    80002206:	6a64a483          	lw	s1,1702(s1) # 800088a8 <ticks>
  release(&tickslock);
    8000220a:	0000c517          	auipc	a0,0xc
    8000220e:	50650513          	addi	a0,a0,1286 # 8000e710 <tickslock>
    80002212:	00004097          	auipc	ra,0x4
    80002216:	f5c080e7          	jalr	-164(ra) # 8000616e <release>
  return xticks;
}
    8000221a:	02049513          	slli	a0,s1,0x20
    8000221e:	9101                	srli	a0,a0,0x20
    80002220:	60e2                	ld	ra,24(sp)
    80002222:	6442                	ld	s0,16(sp)
    80002224:	64a2                	ld	s1,8(sp)
    80002226:	6105                	addi	sp,sp,32
    80002228:	8082                	ret

000000008000222a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000222a:	7179                	addi	sp,sp,-48
    8000222c:	f406                	sd	ra,40(sp)
    8000222e:	f022                	sd	s0,32(sp)
    80002230:	ec26                	sd	s1,24(sp)
    80002232:	e84a                	sd	s2,16(sp)
    80002234:	e44e                	sd	s3,8(sp)
    80002236:	e052                	sd	s4,0(sp)
    80002238:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000223a:	00006597          	auipc	a1,0x6
    8000223e:	24658593          	addi	a1,a1,582 # 80008480 <syscalls+0xb0>
    80002242:	0000c517          	auipc	a0,0xc
    80002246:	4e650513          	addi	a0,a0,1254 # 8000e728 <bcache>
    8000224a:	00004097          	auipc	ra,0x4
    8000224e:	de0080e7          	jalr	-544(ra) # 8000602a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002252:	00014797          	auipc	a5,0x14
    80002256:	4d678793          	addi	a5,a5,1238 # 80016728 <bcache+0x8000>
    8000225a:	00014717          	auipc	a4,0x14
    8000225e:	73670713          	addi	a4,a4,1846 # 80016990 <bcache+0x8268>
    80002262:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002266:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000226a:	0000c497          	auipc	s1,0xc
    8000226e:	4d648493          	addi	s1,s1,1238 # 8000e740 <bcache+0x18>
    b->next = bcache.head.next;
    80002272:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002274:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002276:	00006a17          	auipc	s4,0x6
    8000227a:	212a0a13          	addi	s4,s4,530 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000227e:	2b893783          	ld	a5,696(s2)
    80002282:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002284:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002288:	85d2                	mv	a1,s4
    8000228a:	01048513          	addi	a0,s1,16
    8000228e:	00001097          	auipc	ra,0x1
    80002292:	4c4080e7          	jalr	1220(ra) # 80003752 <initsleeplock>
    bcache.head.next->prev = b;
    80002296:	2b893783          	ld	a5,696(s2)
    8000229a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000229c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022a0:	45848493          	addi	s1,s1,1112
    800022a4:	fd349de3          	bne	s1,s3,8000227e <binit+0x54>
  }
}
    800022a8:	70a2                	ld	ra,40(sp)
    800022aa:	7402                	ld	s0,32(sp)
    800022ac:	64e2                	ld	s1,24(sp)
    800022ae:	6942                	ld	s2,16(sp)
    800022b0:	69a2                	ld	s3,8(sp)
    800022b2:	6a02                	ld	s4,0(sp)
    800022b4:	6145                	addi	sp,sp,48
    800022b6:	8082                	ret

00000000800022b8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022b8:	7179                	addi	sp,sp,-48
    800022ba:	f406                	sd	ra,40(sp)
    800022bc:	f022                	sd	s0,32(sp)
    800022be:	ec26                	sd	s1,24(sp)
    800022c0:	e84a                	sd	s2,16(sp)
    800022c2:	e44e                	sd	s3,8(sp)
    800022c4:	1800                	addi	s0,sp,48
    800022c6:	892a                	mv	s2,a0
    800022c8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ca:	0000c517          	auipc	a0,0xc
    800022ce:	45e50513          	addi	a0,a0,1118 # 8000e728 <bcache>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	de8080e7          	jalr	-536(ra) # 800060ba <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022da:	00014497          	auipc	s1,0x14
    800022de:	7064b483          	ld	s1,1798(s1) # 800169e0 <bcache+0x82b8>
    800022e2:	00014797          	auipc	a5,0x14
    800022e6:	6ae78793          	addi	a5,a5,1710 # 80016990 <bcache+0x8268>
    800022ea:	02f48f63          	beq	s1,a5,80002328 <bread+0x70>
    800022ee:	873e                	mv	a4,a5
    800022f0:	a021                	j	800022f8 <bread+0x40>
    800022f2:	68a4                	ld	s1,80(s1)
    800022f4:	02e48a63          	beq	s1,a4,80002328 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022f8:	449c                	lw	a5,8(s1)
    800022fa:	ff279ce3          	bne	a5,s2,800022f2 <bread+0x3a>
    800022fe:	44dc                	lw	a5,12(s1)
    80002300:	ff3799e3          	bne	a5,s3,800022f2 <bread+0x3a>
      b->refcnt++;
    80002304:	40bc                	lw	a5,64(s1)
    80002306:	2785                	addiw	a5,a5,1
    80002308:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000230a:	0000c517          	auipc	a0,0xc
    8000230e:	41e50513          	addi	a0,a0,1054 # 8000e728 <bcache>
    80002312:	00004097          	auipc	ra,0x4
    80002316:	e5c080e7          	jalr	-420(ra) # 8000616e <release>
      acquiresleep(&b->lock);
    8000231a:	01048513          	addi	a0,s1,16
    8000231e:	00001097          	auipc	ra,0x1
    80002322:	46e080e7          	jalr	1134(ra) # 8000378c <acquiresleep>
      return b;
    80002326:	a8b9                	j	80002384 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002328:	00014497          	auipc	s1,0x14
    8000232c:	6b04b483          	ld	s1,1712(s1) # 800169d8 <bcache+0x82b0>
    80002330:	00014797          	auipc	a5,0x14
    80002334:	66078793          	addi	a5,a5,1632 # 80016990 <bcache+0x8268>
    80002338:	00f48863          	beq	s1,a5,80002348 <bread+0x90>
    8000233c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000233e:	40bc                	lw	a5,64(s1)
    80002340:	cf81                	beqz	a5,80002358 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002342:	64a4                	ld	s1,72(s1)
    80002344:	fee49de3          	bne	s1,a4,8000233e <bread+0x86>
  panic("bget: no buffers");
    80002348:	00006517          	auipc	a0,0x6
    8000234c:	14850513          	addi	a0,a0,328 # 80008490 <syscalls+0xc0>
    80002350:	00004097          	auipc	ra,0x4
    80002354:	82e080e7          	jalr	-2002(ra) # 80005b7e <panic>
      b->dev = dev;
    80002358:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000235c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002360:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002364:	4785                	li	a5,1
    80002366:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002368:	0000c517          	auipc	a0,0xc
    8000236c:	3c050513          	addi	a0,a0,960 # 8000e728 <bcache>
    80002370:	00004097          	auipc	ra,0x4
    80002374:	dfe080e7          	jalr	-514(ra) # 8000616e <release>
      acquiresleep(&b->lock);
    80002378:	01048513          	addi	a0,s1,16
    8000237c:	00001097          	auipc	ra,0x1
    80002380:	410080e7          	jalr	1040(ra) # 8000378c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002384:	409c                	lw	a5,0(s1)
    80002386:	cb89                	beqz	a5,80002398 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002388:	8526                	mv	a0,s1
    8000238a:	70a2                	ld	ra,40(sp)
    8000238c:	7402                	ld	s0,32(sp)
    8000238e:	64e2                	ld	s1,24(sp)
    80002390:	6942                	ld	s2,16(sp)
    80002392:	69a2                	ld	s3,8(sp)
    80002394:	6145                	addi	sp,sp,48
    80002396:	8082                	ret
    virtio_disk_rw(b, 0);
    80002398:	4581                	li	a1,0
    8000239a:	8526                	mv	a0,s1
    8000239c:	00003097          	auipc	ra,0x3
    800023a0:	fd8080e7          	jalr	-40(ra) # 80005374 <virtio_disk_rw>
    b->valid = 1;
    800023a4:	4785                	li	a5,1
    800023a6:	c09c                	sw	a5,0(s1)
  return b;
    800023a8:	b7c5                	j	80002388 <bread+0xd0>

00000000800023aa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023aa:	1101                	addi	sp,sp,-32
    800023ac:	ec06                	sd	ra,24(sp)
    800023ae:	e822                	sd	s0,16(sp)
    800023b0:	e426                	sd	s1,8(sp)
    800023b2:	1000                	addi	s0,sp,32
    800023b4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023b6:	0541                	addi	a0,a0,16
    800023b8:	00001097          	auipc	ra,0x1
    800023bc:	46e080e7          	jalr	1134(ra) # 80003826 <holdingsleep>
    800023c0:	cd01                	beqz	a0,800023d8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023c2:	4585                	li	a1,1
    800023c4:	8526                	mv	a0,s1
    800023c6:	00003097          	auipc	ra,0x3
    800023ca:	fae080e7          	jalr	-82(ra) # 80005374 <virtio_disk_rw>
}
    800023ce:	60e2                	ld	ra,24(sp)
    800023d0:	6442                	ld	s0,16(sp)
    800023d2:	64a2                	ld	s1,8(sp)
    800023d4:	6105                	addi	sp,sp,32
    800023d6:	8082                	ret
    panic("bwrite");
    800023d8:	00006517          	auipc	a0,0x6
    800023dc:	0d050513          	addi	a0,a0,208 # 800084a8 <syscalls+0xd8>
    800023e0:	00003097          	auipc	ra,0x3
    800023e4:	79e080e7          	jalr	1950(ra) # 80005b7e <panic>

00000000800023e8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023e8:	1101                	addi	sp,sp,-32
    800023ea:	ec06                	sd	ra,24(sp)
    800023ec:	e822                	sd	s0,16(sp)
    800023ee:	e426                	sd	s1,8(sp)
    800023f0:	e04a                	sd	s2,0(sp)
    800023f2:	1000                	addi	s0,sp,32
    800023f4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023f6:	01050913          	addi	s2,a0,16
    800023fa:	854a                	mv	a0,s2
    800023fc:	00001097          	auipc	ra,0x1
    80002400:	42a080e7          	jalr	1066(ra) # 80003826 <holdingsleep>
    80002404:	c92d                	beqz	a0,80002476 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002406:	854a                	mv	a0,s2
    80002408:	00001097          	auipc	ra,0x1
    8000240c:	3da080e7          	jalr	986(ra) # 800037e2 <releasesleep>

  acquire(&bcache.lock);
    80002410:	0000c517          	auipc	a0,0xc
    80002414:	31850513          	addi	a0,a0,792 # 8000e728 <bcache>
    80002418:	00004097          	auipc	ra,0x4
    8000241c:	ca2080e7          	jalr	-862(ra) # 800060ba <acquire>
  b->refcnt--;
    80002420:	40bc                	lw	a5,64(s1)
    80002422:	37fd                	addiw	a5,a5,-1
    80002424:	0007871b          	sext.w	a4,a5
    80002428:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000242a:	eb05                	bnez	a4,8000245a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000242c:	68bc                	ld	a5,80(s1)
    8000242e:	64b8                	ld	a4,72(s1)
    80002430:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002432:	64bc                	ld	a5,72(s1)
    80002434:	68b8                	ld	a4,80(s1)
    80002436:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002438:	00014797          	auipc	a5,0x14
    8000243c:	2f078793          	addi	a5,a5,752 # 80016728 <bcache+0x8000>
    80002440:	2b87b703          	ld	a4,696(a5)
    80002444:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002446:	00014717          	auipc	a4,0x14
    8000244a:	54a70713          	addi	a4,a4,1354 # 80016990 <bcache+0x8268>
    8000244e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002450:	2b87b703          	ld	a4,696(a5)
    80002454:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002456:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000245a:	0000c517          	auipc	a0,0xc
    8000245e:	2ce50513          	addi	a0,a0,718 # 8000e728 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	d0c080e7          	jalr	-756(ra) # 8000616e <release>
}
    8000246a:	60e2                	ld	ra,24(sp)
    8000246c:	6442                	ld	s0,16(sp)
    8000246e:	64a2                	ld	s1,8(sp)
    80002470:	6902                	ld	s2,0(sp)
    80002472:	6105                	addi	sp,sp,32
    80002474:	8082                	ret
    panic("brelse");
    80002476:	00006517          	auipc	a0,0x6
    8000247a:	03a50513          	addi	a0,a0,58 # 800084b0 <syscalls+0xe0>
    8000247e:	00003097          	auipc	ra,0x3
    80002482:	700080e7          	jalr	1792(ra) # 80005b7e <panic>

0000000080002486 <bpin>:

void
bpin(struct buf *b) {
    80002486:	1101                	addi	sp,sp,-32
    80002488:	ec06                	sd	ra,24(sp)
    8000248a:	e822                	sd	s0,16(sp)
    8000248c:	e426                	sd	s1,8(sp)
    8000248e:	1000                	addi	s0,sp,32
    80002490:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002492:	0000c517          	auipc	a0,0xc
    80002496:	29650513          	addi	a0,a0,662 # 8000e728 <bcache>
    8000249a:	00004097          	auipc	ra,0x4
    8000249e:	c20080e7          	jalr	-992(ra) # 800060ba <acquire>
  b->refcnt++;
    800024a2:	40bc                	lw	a5,64(s1)
    800024a4:	2785                	addiw	a5,a5,1
    800024a6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024a8:	0000c517          	auipc	a0,0xc
    800024ac:	28050513          	addi	a0,a0,640 # 8000e728 <bcache>
    800024b0:	00004097          	auipc	ra,0x4
    800024b4:	cbe080e7          	jalr	-834(ra) # 8000616e <release>
}
    800024b8:	60e2                	ld	ra,24(sp)
    800024ba:	6442                	ld	s0,16(sp)
    800024bc:	64a2                	ld	s1,8(sp)
    800024be:	6105                	addi	sp,sp,32
    800024c0:	8082                	ret

00000000800024c2 <bunpin>:

void
bunpin(struct buf *b) {
    800024c2:	1101                	addi	sp,sp,-32
    800024c4:	ec06                	sd	ra,24(sp)
    800024c6:	e822                	sd	s0,16(sp)
    800024c8:	e426                	sd	s1,8(sp)
    800024ca:	1000                	addi	s0,sp,32
    800024cc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ce:	0000c517          	auipc	a0,0xc
    800024d2:	25a50513          	addi	a0,a0,602 # 8000e728 <bcache>
    800024d6:	00004097          	auipc	ra,0x4
    800024da:	be4080e7          	jalr	-1052(ra) # 800060ba <acquire>
  b->refcnt--;
    800024de:	40bc                	lw	a5,64(s1)
    800024e0:	37fd                	addiw	a5,a5,-1
    800024e2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024e4:	0000c517          	auipc	a0,0xc
    800024e8:	24450513          	addi	a0,a0,580 # 8000e728 <bcache>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	c82080e7          	jalr	-894(ra) # 8000616e <release>
}
    800024f4:	60e2                	ld	ra,24(sp)
    800024f6:	6442                	ld	s0,16(sp)
    800024f8:	64a2                	ld	s1,8(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret

00000000800024fe <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024fe:	1101                	addi	sp,sp,-32
    80002500:	ec06                	sd	ra,24(sp)
    80002502:	e822                	sd	s0,16(sp)
    80002504:	e426                	sd	s1,8(sp)
    80002506:	e04a                	sd	s2,0(sp)
    80002508:	1000                	addi	s0,sp,32
    8000250a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000250c:	00d5d59b          	srliw	a1,a1,0xd
    80002510:	00015797          	auipc	a5,0x15
    80002514:	8f47a783          	lw	a5,-1804(a5) # 80016e04 <sb+0x1c>
    80002518:	9dbd                	addw	a1,a1,a5
    8000251a:	00000097          	auipc	ra,0x0
    8000251e:	d9e080e7          	jalr	-610(ra) # 800022b8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002522:	0074f713          	andi	a4,s1,7
    80002526:	4785                	li	a5,1
    80002528:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000252c:	14ce                	slli	s1,s1,0x33
    8000252e:	90d9                	srli	s1,s1,0x36
    80002530:	00950733          	add	a4,a0,s1
    80002534:	05874703          	lbu	a4,88(a4)
    80002538:	00e7f6b3          	and	a3,a5,a4
    8000253c:	c69d                	beqz	a3,8000256a <bfree+0x6c>
    8000253e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002540:	94aa                	add	s1,s1,a0
    80002542:	fff7c793          	not	a5,a5
    80002546:	8ff9                	and	a5,a5,a4
    80002548:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000254c:	00001097          	auipc	ra,0x1
    80002550:	120080e7          	jalr	288(ra) # 8000366c <log_write>
  brelse(bp);
    80002554:	854a                	mv	a0,s2
    80002556:	00000097          	auipc	ra,0x0
    8000255a:	e92080e7          	jalr	-366(ra) # 800023e8 <brelse>
}
    8000255e:	60e2                	ld	ra,24(sp)
    80002560:	6442                	ld	s0,16(sp)
    80002562:	64a2                	ld	s1,8(sp)
    80002564:	6902                	ld	s2,0(sp)
    80002566:	6105                	addi	sp,sp,32
    80002568:	8082                	ret
    panic("freeing free block");
    8000256a:	00006517          	auipc	a0,0x6
    8000256e:	f4e50513          	addi	a0,a0,-178 # 800084b8 <syscalls+0xe8>
    80002572:	00003097          	auipc	ra,0x3
    80002576:	60c080e7          	jalr	1548(ra) # 80005b7e <panic>

000000008000257a <balloc>:
{
    8000257a:	711d                	addi	sp,sp,-96
    8000257c:	ec86                	sd	ra,88(sp)
    8000257e:	e8a2                	sd	s0,80(sp)
    80002580:	e4a6                	sd	s1,72(sp)
    80002582:	e0ca                	sd	s2,64(sp)
    80002584:	fc4e                	sd	s3,56(sp)
    80002586:	f852                	sd	s4,48(sp)
    80002588:	f456                	sd	s5,40(sp)
    8000258a:	f05a                	sd	s6,32(sp)
    8000258c:	ec5e                	sd	s7,24(sp)
    8000258e:	e862                	sd	s8,16(sp)
    80002590:	e466                	sd	s9,8(sp)
    80002592:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002594:	00015797          	auipc	a5,0x15
    80002598:	8587a783          	lw	a5,-1960(a5) # 80016dec <sb+0x4>
    8000259c:	10078163          	beqz	a5,8000269e <balloc+0x124>
    800025a0:	8baa                	mv	s7,a0
    800025a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025a4:	00015b17          	auipc	s6,0x15
    800025a8:	844b0b13          	addi	s6,s6,-1980 # 80016de8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025b2:	6c89                	lui	s9,0x2
    800025b4:	a061                	j	8000263c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025b6:	974a                	add	a4,a4,s2
    800025b8:	8fd5                	or	a5,a5,a3
    800025ba:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025be:	854a                	mv	a0,s2
    800025c0:	00001097          	auipc	ra,0x1
    800025c4:	0ac080e7          	jalr	172(ra) # 8000366c <log_write>
        brelse(bp);
    800025c8:	854a                	mv	a0,s2
    800025ca:	00000097          	auipc	ra,0x0
    800025ce:	e1e080e7          	jalr	-482(ra) # 800023e8 <brelse>
  bp = bread(dev, bno);
    800025d2:	85a6                	mv	a1,s1
    800025d4:	855e                	mv	a0,s7
    800025d6:	00000097          	auipc	ra,0x0
    800025da:	ce2080e7          	jalr	-798(ra) # 800022b8 <bread>
    800025de:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025e0:	40000613          	li	a2,1024
    800025e4:	4581                	li	a1,0
    800025e6:	05850513          	addi	a0,a0,88
    800025ea:	ffffe097          	auipc	ra,0xffffe
    800025ee:	b8e080e7          	jalr	-1138(ra) # 80000178 <memset>
  log_write(bp);
    800025f2:	854a                	mv	a0,s2
    800025f4:	00001097          	auipc	ra,0x1
    800025f8:	078080e7          	jalr	120(ra) # 8000366c <log_write>
  brelse(bp);
    800025fc:	854a                	mv	a0,s2
    800025fe:	00000097          	auipc	ra,0x0
    80002602:	dea080e7          	jalr	-534(ra) # 800023e8 <brelse>
}
    80002606:	8526                	mv	a0,s1
    80002608:	60e6                	ld	ra,88(sp)
    8000260a:	6446                	ld	s0,80(sp)
    8000260c:	64a6                	ld	s1,72(sp)
    8000260e:	6906                	ld	s2,64(sp)
    80002610:	79e2                	ld	s3,56(sp)
    80002612:	7a42                	ld	s4,48(sp)
    80002614:	7aa2                	ld	s5,40(sp)
    80002616:	7b02                	ld	s6,32(sp)
    80002618:	6be2                	ld	s7,24(sp)
    8000261a:	6c42                	ld	s8,16(sp)
    8000261c:	6ca2                	ld	s9,8(sp)
    8000261e:	6125                	addi	sp,sp,96
    80002620:	8082                	ret
    brelse(bp);
    80002622:	854a                	mv	a0,s2
    80002624:	00000097          	auipc	ra,0x0
    80002628:	dc4080e7          	jalr	-572(ra) # 800023e8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000262c:	015c87bb          	addw	a5,s9,s5
    80002630:	00078a9b          	sext.w	s5,a5
    80002634:	004b2703          	lw	a4,4(s6)
    80002638:	06eaf363          	bgeu	s5,a4,8000269e <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000263c:	41fad79b          	sraiw	a5,s5,0x1f
    80002640:	0137d79b          	srliw	a5,a5,0x13
    80002644:	015787bb          	addw	a5,a5,s5
    80002648:	40d7d79b          	sraiw	a5,a5,0xd
    8000264c:	01cb2583          	lw	a1,28(s6)
    80002650:	9dbd                	addw	a1,a1,a5
    80002652:	855e                	mv	a0,s7
    80002654:	00000097          	auipc	ra,0x0
    80002658:	c64080e7          	jalr	-924(ra) # 800022b8 <bread>
    8000265c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000265e:	004b2503          	lw	a0,4(s6)
    80002662:	000a849b          	sext.w	s1,s5
    80002666:	8662                	mv	a2,s8
    80002668:	faa4fde3          	bgeu	s1,a0,80002622 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000266c:	41f6579b          	sraiw	a5,a2,0x1f
    80002670:	01d7d69b          	srliw	a3,a5,0x1d
    80002674:	00c6873b          	addw	a4,a3,a2
    80002678:	00777793          	andi	a5,a4,7
    8000267c:	9f95                	subw	a5,a5,a3
    8000267e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002682:	4037571b          	sraiw	a4,a4,0x3
    80002686:	00e906b3          	add	a3,s2,a4
    8000268a:	0586c683          	lbu	a3,88(a3)
    8000268e:	00d7f5b3          	and	a1,a5,a3
    80002692:	d195                	beqz	a1,800025b6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002694:	2605                	addiw	a2,a2,1
    80002696:	2485                	addiw	s1,s1,1
    80002698:	fd4618e3          	bne	a2,s4,80002668 <balloc+0xee>
    8000269c:	b759                	j	80002622 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000269e:	00006517          	auipc	a0,0x6
    800026a2:	e3250513          	addi	a0,a0,-462 # 800084d0 <syscalls+0x100>
    800026a6:	00003097          	auipc	ra,0x3
    800026aa:	522080e7          	jalr	1314(ra) # 80005bc8 <printf>
  return 0;
    800026ae:	4481                	li	s1,0
    800026b0:	bf99                	j	80002606 <balloc+0x8c>

00000000800026b2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026b2:	7179                	addi	sp,sp,-48
    800026b4:	f406                	sd	ra,40(sp)
    800026b6:	f022                	sd	s0,32(sp)
    800026b8:	ec26                	sd	s1,24(sp)
    800026ba:	e84a                	sd	s2,16(sp)
    800026bc:	e44e                	sd	s3,8(sp)
    800026be:	e052                	sd	s4,0(sp)
    800026c0:	1800                	addi	s0,sp,48
    800026c2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026c4:	47ad                	li	a5,11
    800026c6:	02b7e763          	bltu	a5,a1,800026f4 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800026ca:	02059493          	slli	s1,a1,0x20
    800026ce:	9081                	srli	s1,s1,0x20
    800026d0:	048a                	slli	s1,s1,0x2
    800026d2:	94aa                	add	s1,s1,a0
    800026d4:	0504a903          	lw	s2,80(s1)
    800026d8:	06091e63          	bnez	s2,80002754 <bmap+0xa2>
      addr = balloc(ip->dev);
    800026dc:	4108                	lw	a0,0(a0)
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	e9c080e7          	jalr	-356(ra) # 8000257a <balloc>
    800026e6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026ea:	06090563          	beqz	s2,80002754 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800026ee:	0524a823          	sw	s2,80(s1)
    800026f2:	a08d                	j	80002754 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800026f4:	ff45849b          	addiw	s1,a1,-12
    800026f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026fc:	0ff00793          	li	a5,255
    80002700:	08e7e563          	bltu	a5,a4,8000278a <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002704:	08052903          	lw	s2,128(a0)
    80002708:	00091d63          	bnez	s2,80002722 <bmap+0x70>
      addr = balloc(ip->dev);
    8000270c:	4108                	lw	a0,0(a0)
    8000270e:	00000097          	auipc	ra,0x0
    80002712:	e6c080e7          	jalr	-404(ra) # 8000257a <balloc>
    80002716:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000271a:	02090d63          	beqz	s2,80002754 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000271e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002722:	85ca                	mv	a1,s2
    80002724:	0009a503          	lw	a0,0(s3)
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	b90080e7          	jalr	-1136(ra) # 800022b8 <bread>
    80002730:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002732:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002736:	02049593          	slli	a1,s1,0x20
    8000273a:	9181                	srli	a1,a1,0x20
    8000273c:	058a                	slli	a1,a1,0x2
    8000273e:	00b784b3          	add	s1,a5,a1
    80002742:	0004a903          	lw	s2,0(s1)
    80002746:	02090063          	beqz	s2,80002766 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000274a:	8552                	mv	a0,s4
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	c9c080e7          	jalr	-868(ra) # 800023e8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002754:	854a                	mv	a0,s2
    80002756:	70a2                	ld	ra,40(sp)
    80002758:	7402                	ld	s0,32(sp)
    8000275a:	64e2                	ld	s1,24(sp)
    8000275c:	6942                	ld	s2,16(sp)
    8000275e:	69a2                	ld	s3,8(sp)
    80002760:	6a02                	ld	s4,0(sp)
    80002762:	6145                	addi	sp,sp,48
    80002764:	8082                	ret
      addr = balloc(ip->dev);
    80002766:	0009a503          	lw	a0,0(s3)
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e10080e7          	jalr	-496(ra) # 8000257a <balloc>
    80002772:	0005091b          	sext.w	s2,a0
      if(addr){
    80002776:	fc090ae3          	beqz	s2,8000274a <bmap+0x98>
        a[bn] = addr;
    8000277a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000277e:	8552                	mv	a0,s4
    80002780:	00001097          	auipc	ra,0x1
    80002784:	eec080e7          	jalr	-276(ra) # 8000366c <log_write>
    80002788:	b7c9                	j	8000274a <bmap+0x98>
  panic("bmap: out of range");
    8000278a:	00006517          	auipc	a0,0x6
    8000278e:	d5e50513          	addi	a0,a0,-674 # 800084e8 <syscalls+0x118>
    80002792:	00003097          	auipc	ra,0x3
    80002796:	3ec080e7          	jalr	1004(ra) # 80005b7e <panic>

000000008000279a <iget>:
{
    8000279a:	7179                	addi	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	e052                	sd	s4,0(sp)
    800027a8:	1800                	addi	s0,sp,48
    800027aa:	89aa                	mv	s3,a0
    800027ac:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ae:	00014517          	auipc	a0,0x14
    800027b2:	65a50513          	addi	a0,a0,1626 # 80016e08 <itable>
    800027b6:	00004097          	auipc	ra,0x4
    800027ba:	904080e7          	jalr	-1788(ra) # 800060ba <acquire>
  empty = 0;
    800027be:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027c0:	00014497          	auipc	s1,0x14
    800027c4:	66048493          	addi	s1,s1,1632 # 80016e20 <itable+0x18>
    800027c8:	00016697          	auipc	a3,0x16
    800027cc:	0e868693          	addi	a3,a3,232 # 800188b0 <log>
    800027d0:	a039                	j	800027de <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027d2:	02090b63          	beqz	s2,80002808 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027d6:	08848493          	addi	s1,s1,136
    800027da:	02d48a63          	beq	s1,a3,8000280e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027de:	449c                	lw	a5,8(s1)
    800027e0:	fef059e3          	blez	a5,800027d2 <iget+0x38>
    800027e4:	4098                	lw	a4,0(s1)
    800027e6:	ff3716e3          	bne	a4,s3,800027d2 <iget+0x38>
    800027ea:	40d8                	lw	a4,4(s1)
    800027ec:	ff4713e3          	bne	a4,s4,800027d2 <iget+0x38>
      ip->ref++;
    800027f0:	2785                	addiw	a5,a5,1
    800027f2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027f4:	00014517          	auipc	a0,0x14
    800027f8:	61450513          	addi	a0,a0,1556 # 80016e08 <itable>
    800027fc:	00004097          	auipc	ra,0x4
    80002800:	972080e7          	jalr	-1678(ra) # 8000616e <release>
      return ip;
    80002804:	8926                	mv	s2,s1
    80002806:	a03d                	j	80002834 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002808:	f7f9                	bnez	a5,800027d6 <iget+0x3c>
    8000280a:	8926                	mv	s2,s1
    8000280c:	b7e9                	j	800027d6 <iget+0x3c>
  if(empty == 0)
    8000280e:	02090c63          	beqz	s2,80002846 <iget+0xac>
  ip->dev = dev;
    80002812:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002816:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000281a:	4785                	li	a5,1
    8000281c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002820:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002824:	00014517          	auipc	a0,0x14
    80002828:	5e450513          	addi	a0,a0,1508 # 80016e08 <itable>
    8000282c:	00004097          	auipc	ra,0x4
    80002830:	942080e7          	jalr	-1726(ra) # 8000616e <release>
}
    80002834:	854a                	mv	a0,s2
    80002836:	70a2                	ld	ra,40(sp)
    80002838:	7402                	ld	s0,32(sp)
    8000283a:	64e2                	ld	s1,24(sp)
    8000283c:	6942                	ld	s2,16(sp)
    8000283e:	69a2                	ld	s3,8(sp)
    80002840:	6a02                	ld	s4,0(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    panic("iget: no inodes");
    80002846:	00006517          	auipc	a0,0x6
    8000284a:	cba50513          	addi	a0,a0,-838 # 80008500 <syscalls+0x130>
    8000284e:	00003097          	auipc	ra,0x3
    80002852:	330080e7          	jalr	816(ra) # 80005b7e <panic>

0000000080002856 <fsinit>:
fsinit(int dev) {
    80002856:	7179                	addi	sp,sp,-48
    80002858:	f406                	sd	ra,40(sp)
    8000285a:	f022                	sd	s0,32(sp)
    8000285c:	ec26                	sd	s1,24(sp)
    8000285e:	e84a                	sd	s2,16(sp)
    80002860:	e44e                	sd	s3,8(sp)
    80002862:	1800                	addi	s0,sp,48
    80002864:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002866:	4585                	li	a1,1
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	a50080e7          	jalr	-1456(ra) # 800022b8 <bread>
    80002870:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002872:	00014997          	auipc	s3,0x14
    80002876:	57698993          	addi	s3,s3,1398 # 80016de8 <sb>
    8000287a:	02000613          	li	a2,32
    8000287e:	05850593          	addi	a1,a0,88
    80002882:	854e                	mv	a0,s3
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	950080e7          	jalr	-1712(ra) # 800001d4 <memmove>
  brelse(bp);
    8000288c:	8526                	mv	a0,s1
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	b5a080e7          	jalr	-1190(ra) # 800023e8 <brelse>
  if(sb.magic != FSMAGIC)
    80002896:	0009a703          	lw	a4,0(s3)
    8000289a:	102037b7          	lui	a5,0x10203
    8000289e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028a2:	02f71263          	bne	a4,a5,800028c6 <fsinit+0x70>
  initlog(dev, &sb);
    800028a6:	00014597          	auipc	a1,0x14
    800028aa:	54258593          	addi	a1,a1,1346 # 80016de8 <sb>
    800028ae:	854a                	mv	a0,s2
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	b40080e7          	jalr	-1216(ra) # 800033f0 <initlog>
}
    800028b8:	70a2                	ld	ra,40(sp)
    800028ba:	7402                	ld	s0,32(sp)
    800028bc:	64e2                	ld	s1,24(sp)
    800028be:	6942                	ld	s2,16(sp)
    800028c0:	69a2                	ld	s3,8(sp)
    800028c2:	6145                	addi	sp,sp,48
    800028c4:	8082                	ret
    panic("invalid file system");
    800028c6:	00006517          	auipc	a0,0x6
    800028ca:	c4a50513          	addi	a0,a0,-950 # 80008510 <syscalls+0x140>
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	2b0080e7          	jalr	688(ra) # 80005b7e <panic>

00000000800028d6 <iinit>:
{
    800028d6:	7179                	addi	sp,sp,-48
    800028d8:	f406                	sd	ra,40(sp)
    800028da:	f022                	sd	s0,32(sp)
    800028dc:	ec26                	sd	s1,24(sp)
    800028de:	e84a                	sd	s2,16(sp)
    800028e0:	e44e                	sd	s3,8(sp)
    800028e2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028e4:	00006597          	auipc	a1,0x6
    800028e8:	c4458593          	addi	a1,a1,-956 # 80008528 <syscalls+0x158>
    800028ec:	00014517          	auipc	a0,0x14
    800028f0:	51c50513          	addi	a0,a0,1308 # 80016e08 <itable>
    800028f4:	00003097          	auipc	ra,0x3
    800028f8:	736080e7          	jalr	1846(ra) # 8000602a <initlock>
  for(i = 0; i < NINODE; i++) {
    800028fc:	00014497          	auipc	s1,0x14
    80002900:	53448493          	addi	s1,s1,1332 # 80016e30 <itable+0x28>
    80002904:	00016997          	auipc	s3,0x16
    80002908:	fbc98993          	addi	s3,s3,-68 # 800188c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000290c:	00006917          	auipc	s2,0x6
    80002910:	c2490913          	addi	s2,s2,-988 # 80008530 <syscalls+0x160>
    80002914:	85ca                	mv	a1,s2
    80002916:	8526                	mv	a0,s1
    80002918:	00001097          	auipc	ra,0x1
    8000291c:	e3a080e7          	jalr	-454(ra) # 80003752 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002920:	08848493          	addi	s1,s1,136
    80002924:	ff3498e3          	bne	s1,s3,80002914 <iinit+0x3e>
}
    80002928:	70a2                	ld	ra,40(sp)
    8000292a:	7402                	ld	s0,32(sp)
    8000292c:	64e2                	ld	s1,24(sp)
    8000292e:	6942                	ld	s2,16(sp)
    80002930:	69a2                	ld	s3,8(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret

0000000080002936 <ialloc>:
{
    80002936:	715d                	addi	sp,sp,-80
    80002938:	e486                	sd	ra,72(sp)
    8000293a:	e0a2                	sd	s0,64(sp)
    8000293c:	fc26                	sd	s1,56(sp)
    8000293e:	f84a                	sd	s2,48(sp)
    80002940:	f44e                	sd	s3,40(sp)
    80002942:	f052                	sd	s4,32(sp)
    80002944:	ec56                	sd	s5,24(sp)
    80002946:	e85a                	sd	s6,16(sp)
    80002948:	e45e                	sd	s7,8(sp)
    8000294a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000294c:	00014717          	auipc	a4,0x14
    80002950:	4a872703          	lw	a4,1192(a4) # 80016df4 <sb+0xc>
    80002954:	4785                	li	a5,1
    80002956:	04e7fa63          	bgeu	a5,a4,800029aa <ialloc+0x74>
    8000295a:	8aaa                	mv	s5,a0
    8000295c:	8bae                	mv	s7,a1
    8000295e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002960:	00014a17          	auipc	s4,0x14
    80002964:	488a0a13          	addi	s4,s4,1160 # 80016de8 <sb>
    80002968:	00048b1b          	sext.w	s6,s1
    8000296c:	0044d793          	srli	a5,s1,0x4
    80002970:	018a2583          	lw	a1,24(s4)
    80002974:	9dbd                	addw	a1,a1,a5
    80002976:	8556                	mv	a0,s5
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	940080e7          	jalr	-1728(ra) # 800022b8 <bread>
    80002980:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002982:	05850993          	addi	s3,a0,88
    80002986:	00f4f793          	andi	a5,s1,15
    8000298a:	079a                	slli	a5,a5,0x6
    8000298c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000298e:	00099783          	lh	a5,0(s3)
    80002992:	c3a1                	beqz	a5,800029d2 <ialloc+0x9c>
    brelse(bp);
    80002994:	00000097          	auipc	ra,0x0
    80002998:	a54080e7          	jalr	-1452(ra) # 800023e8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000299c:	0485                	addi	s1,s1,1
    8000299e:	00ca2703          	lw	a4,12(s4)
    800029a2:	0004879b          	sext.w	a5,s1
    800029a6:	fce7e1e3          	bltu	a5,a4,80002968 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	b8e50513          	addi	a0,a0,-1138 # 80008538 <syscalls+0x168>
    800029b2:	00003097          	auipc	ra,0x3
    800029b6:	216080e7          	jalr	534(ra) # 80005bc8 <printf>
  return 0;
    800029ba:	4501                	li	a0,0
}
    800029bc:	60a6                	ld	ra,72(sp)
    800029be:	6406                	ld	s0,64(sp)
    800029c0:	74e2                	ld	s1,56(sp)
    800029c2:	7942                	ld	s2,48(sp)
    800029c4:	79a2                	ld	s3,40(sp)
    800029c6:	7a02                	ld	s4,32(sp)
    800029c8:	6ae2                	ld	s5,24(sp)
    800029ca:	6b42                	ld	s6,16(sp)
    800029cc:	6ba2                	ld	s7,8(sp)
    800029ce:	6161                	addi	sp,sp,80
    800029d0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029d2:	04000613          	li	a2,64
    800029d6:	4581                	li	a1,0
    800029d8:	854e                	mv	a0,s3
    800029da:	ffffd097          	auipc	ra,0xffffd
    800029de:	79e080e7          	jalr	1950(ra) # 80000178 <memset>
      dip->type = type;
    800029e2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029e6:	854a                	mv	a0,s2
    800029e8:	00001097          	auipc	ra,0x1
    800029ec:	c84080e7          	jalr	-892(ra) # 8000366c <log_write>
      brelse(bp);
    800029f0:	854a                	mv	a0,s2
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	9f6080e7          	jalr	-1546(ra) # 800023e8 <brelse>
      return iget(dev, inum);
    800029fa:	85da                	mv	a1,s6
    800029fc:	8556                	mv	a0,s5
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	d9c080e7          	jalr	-612(ra) # 8000279a <iget>
    80002a06:	bf5d                	j	800029bc <ialloc+0x86>

0000000080002a08 <iupdate>:
{
    80002a08:	1101                	addi	sp,sp,-32
    80002a0a:	ec06                	sd	ra,24(sp)
    80002a0c:	e822                	sd	s0,16(sp)
    80002a0e:	e426                	sd	s1,8(sp)
    80002a10:	e04a                	sd	s2,0(sp)
    80002a12:	1000                	addi	s0,sp,32
    80002a14:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a16:	415c                	lw	a5,4(a0)
    80002a18:	0047d79b          	srliw	a5,a5,0x4
    80002a1c:	00014597          	auipc	a1,0x14
    80002a20:	3e45a583          	lw	a1,996(a1) # 80016e00 <sb+0x18>
    80002a24:	9dbd                	addw	a1,a1,a5
    80002a26:	4108                	lw	a0,0(a0)
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	890080e7          	jalr	-1904(ra) # 800022b8 <bread>
    80002a30:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a32:	05850793          	addi	a5,a0,88
    80002a36:	40c8                	lw	a0,4(s1)
    80002a38:	893d                	andi	a0,a0,15
    80002a3a:	051a                	slli	a0,a0,0x6
    80002a3c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a3e:	04449703          	lh	a4,68(s1)
    80002a42:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a46:	04649703          	lh	a4,70(s1)
    80002a4a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a4e:	04849703          	lh	a4,72(s1)
    80002a52:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a56:	04a49703          	lh	a4,74(s1)
    80002a5a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a5e:	44f8                	lw	a4,76(s1)
    80002a60:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a62:	03400613          	li	a2,52
    80002a66:	05048593          	addi	a1,s1,80
    80002a6a:	0531                	addi	a0,a0,12
    80002a6c:	ffffd097          	auipc	ra,0xffffd
    80002a70:	768080e7          	jalr	1896(ra) # 800001d4 <memmove>
  log_write(bp);
    80002a74:	854a                	mv	a0,s2
    80002a76:	00001097          	auipc	ra,0x1
    80002a7a:	bf6080e7          	jalr	-1034(ra) # 8000366c <log_write>
  brelse(bp);
    80002a7e:	854a                	mv	a0,s2
    80002a80:	00000097          	auipc	ra,0x0
    80002a84:	968080e7          	jalr	-1688(ra) # 800023e8 <brelse>
}
    80002a88:	60e2                	ld	ra,24(sp)
    80002a8a:	6442                	ld	s0,16(sp)
    80002a8c:	64a2                	ld	s1,8(sp)
    80002a8e:	6902                	ld	s2,0(sp)
    80002a90:	6105                	addi	sp,sp,32
    80002a92:	8082                	ret

0000000080002a94 <idup>:
{
    80002a94:	1101                	addi	sp,sp,-32
    80002a96:	ec06                	sd	ra,24(sp)
    80002a98:	e822                	sd	s0,16(sp)
    80002a9a:	e426                	sd	s1,8(sp)
    80002a9c:	1000                	addi	s0,sp,32
    80002a9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aa0:	00014517          	auipc	a0,0x14
    80002aa4:	36850513          	addi	a0,a0,872 # 80016e08 <itable>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	612080e7          	jalr	1554(ra) # 800060ba <acquire>
  ip->ref++;
    80002ab0:	449c                	lw	a5,8(s1)
    80002ab2:	2785                	addiw	a5,a5,1
    80002ab4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ab6:	00014517          	auipc	a0,0x14
    80002aba:	35250513          	addi	a0,a0,850 # 80016e08 <itable>
    80002abe:	00003097          	auipc	ra,0x3
    80002ac2:	6b0080e7          	jalr	1712(ra) # 8000616e <release>
}
    80002ac6:	8526                	mv	a0,s1
    80002ac8:	60e2                	ld	ra,24(sp)
    80002aca:	6442                	ld	s0,16(sp)
    80002acc:	64a2                	ld	s1,8(sp)
    80002ace:	6105                	addi	sp,sp,32
    80002ad0:	8082                	ret

0000000080002ad2 <ilock>:
{
    80002ad2:	1101                	addi	sp,sp,-32
    80002ad4:	ec06                	sd	ra,24(sp)
    80002ad6:	e822                	sd	s0,16(sp)
    80002ad8:	e426                	sd	s1,8(sp)
    80002ada:	e04a                	sd	s2,0(sp)
    80002adc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ade:	c115                	beqz	a0,80002b02 <ilock+0x30>
    80002ae0:	84aa                	mv	s1,a0
    80002ae2:	451c                	lw	a5,8(a0)
    80002ae4:	00f05f63          	blez	a5,80002b02 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ae8:	0541                	addi	a0,a0,16
    80002aea:	00001097          	auipc	ra,0x1
    80002aee:	ca2080e7          	jalr	-862(ra) # 8000378c <acquiresleep>
  if(ip->valid == 0){
    80002af2:	40bc                	lw	a5,64(s1)
    80002af4:	cf99                	beqz	a5,80002b12 <ilock+0x40>
}
    80002af6:	60e2                	ld	ra,24(sp)
    80002af8:	6442                	ld	s0,16(sp)
    80002afa:	64a2                	ld	s1,8(sp)
    80002afc:	6902                	ld	s2,0(sp)
    80002afe:	6105                	addi	sp,sp,32
    80002b00:	8082                	ret
    panic("ilock");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	a4e50513          	addi	a0,a0,-1458 # 80008550 <syscalls+0x180>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	074080e7          	jalr	116(ra) # 80005b7e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b12:	40dc                	lw	a5,4(s1)
    80002b14:	0047d79b          	srliw	a5,a5,0x4
    80002b18:	00014597          	auipc	a1,0x14
    80002b1c:	2e85a583          	lw	a1,744(a1) # 80016e00 <sb+0x18>
    80002b20:	9dbd                	addw	a1,a1,a5
    80002b22:	4088                	lw	a0,0(s1)
    80002b24:	fffff097          	auipc	ra,0xfffff
    80002b28:	794080e7          	jalr	1940(ra) # 800022b8 <bread>
    80002b2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b2e:	05850593          	addi	a1,a0,88
    80002b32:	40dc                	lw	a5,4(s1)
    80002b34:	8bbd                	andi	a5,a5,15
    80002b36:	079a                	slli	a5,a5,0x6
    80002b38:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b3a:	00059783          	lh	a5,0(a1)
    80002b3e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b42:	00259783          	lh	a5,2(a1)
    80002b46:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b4a:	00459783          	lh	a5,4(a1)
    80002b4e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b52:	00659783          	lh	a5,6(a1)
    80002b56:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b5a:	459c                	lw	a5,8(a1)
    80002b5c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b5e:	03400613          	li	a2,52
    80002b62:	05b1                	addi	a1,a1,12
    80002b64:	05048513          	addi	a0,s1,80
    80002b68:	ffffd097          	auipc	ra,0xffffd
    80002b6c:	66c080e7          	jalr	1644(ra) # 800001d4 <memmove>
    brelse(bp);
    80002b70:	854a                	mv	a0,s2
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	876080e7          	jalr	-1930(ra) # 800023e8 <brelse>
    ip->valid = 1;
    80002b7a:	4785                	li	a5,1
    80002b7c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b7e:	04449783          	lh	a5,68(s1)
    80002b82:	fbb5                	bnez	a5,80002af6 <ilock+0x24>
      panic("ilock: no type");
    80002b84:	00006517          	auipc	a0,0x6
    80002b88:	9d450513          	addi	a0,a0,-1580 # 80008558 <syscalls+0x188>
    80002b8c:	00003097          	auipc	ra,0x3
    80002b90:	ff2080e7          	jalr	-14(ra) # 80005b7e <panic>

0000000080002b94 <iunlock>:
{
    80002b94:	1101                	addi	sp,sp,-32
    80002b96:	ec06                	sd	ra,24(sp)
    80002b98:	e822                	sd	s0,16(sp)
    80002b9a:	e426                	sd	s1,8(sp)
    80002b9c:	e04a                	sd	s2,0(sp)
    80002b9e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ba0:	c905                	beqz	a0,80002bd0 <iunlock+0x3c>
    80002ba2:	84aa                	mv	s1,a0
    80002ba4:	01050913          	addi	s2,a0,16
    80002ba8:	854a                	mv	a0,s2
    80002baa:	00001097          	auipc	ra,0x1
    80002bae:	c7c080e7          	jalr	-900(ra) # 80003826 <holdingsleep>
    80002bb2:	cd19                	beqz	a0,80002bd0 <iunlock+0x3c>
    80002bb4:	449c                	lw	a5,8(s1)
    80002bb6:	00f05d63          	blez	a5,80002bd0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bba:	854a                	mv	a0,s2
    80002bbc:	00001097          	auipc	ra,0x1
    80002bc0:	c26080e7          	jalr	-986(ra) # 800037e2 <releasesleep>
}
    80002bc4:	60e2                	ld	ra,24(sp)
    80002bc6:	6442                	ld	s0,16(sp)
    80002bc8:	64a2                	ld	s1,8(sp)
    80002bca:	6902                	ld	s2,0(sp)
    80002bcc:	6105                	addi	sp,sp,32
    80002bce:	8082                	ret
    panic("iunlock");
    80002bd0:	00006517          	auipc	a0,0x6
    80002bd4:	99850513          	addi	a0,a0,-1640 # 80008568 <syscalls+0x198>
    80002bd8:	00003097          	auipc	ra,0x3
    80002bdc:	fa6080e7          	jalr	-90(ra) # 80005b7e <panic>

0000000080002be0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002be0:	7179                	addi	sp,sp,-48
    80002be2:	f406                	sd	ra,40(sp)
    80002be4:	f022                	sd	s0,32(sp)
    80002be6:	ec26                	sd	s1,24(sp)
    80002be8:	e84a                	sd	s2,16(sp)
    80002bea:	e44e                	sd	s3,8(sp)
    80002bec:	e052                	sd	s4,0(sp)
    80002bee:	1800                	addi	s0,sp,48
    80002bf0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bf2:	05050493          	addi	s1,a0,80
    80002bf6:	08050913          	addi	s2,a0,128
    80002bfa:	a021                	j	80002c02 <itrunc+0x22>
    80002bfc:	0491                	addi	s1,s1,4
    80002bfe:	01248d63          	beq	s1,s2,80002c18 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c02:	408c                	lw	a1,0(s1)
    80002c04:	dde5                	beqz	a1,80002bfc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c06:	0009a503          	lw	a0,0(s3)
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	8f4080e7          	jalr	-1804(ra) # 800024fe <bfree>
      ip->addrs[i] = 0;
    80002c12:	0004a023          	sw	zero,0(s1)
    80002c16:	b7dd                	j	80002bfc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c18:	0809a583          	lw	a1,128(s3)
    80002c1c:	e185                	bnez	a1,80002c3c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c1e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c22:	854e                	mv	a0,s3
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	de4080e7          	jalr	-540(ra) # 80002a08 <iupdate>
}
    80002c2c:	70a2                	ld	ra,40(sp)
    80002c2e:	7402                	ld	s0,32(sp)
    80002c30:	64e2                	ld	s1,24(sp)
    80002c32:	6942                	ld	s2,16(sp)
    80002c34:	69a2                	ld	s3,8(sp)
    80002c36:	6a02                	ld	s4,0(sp)
    80002c38:	6145                	addi	sp,sp,48
    80002c3a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c3c:	0009a503          	lw	a0,0(s3)
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	678080e7          	jalr	1656(ra) # 800022b8 <bread>
    80002c48:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c4a:	05850493          	addi	s1,a0,88
    80002c4e:	45850913          	addi	s2,a0,1112
    80002c52:	a021                	j	80002c5a <itrunc+0x7a>
    80002c54:	0491                	addi	s1,s1,4
    80002c56:	01248b63          	beq	s1,s2,80002c6c <itrunc+0x8c>
      if(a[j])
    80002c5a:	408c                	lw	a1,0(s1)
    80002c5c:	dde5                	beqz	a1,80002c54 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c5e:	0009a503          	lw	a0,0(s3)
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	89c080e7          	jalr	-1892(ra) # 800024fe <bfree>
    80002c6a:	b7ed                	j	80002c54 <itrunc+0x74>
    brelse(bp);
    80002c6c:	8552                	mv	a0,s4
    80002c6e:	fffff097          	auipc	ra,0xfffff
    80002c72:	77a080e7          	jalr	1914(ra) # 800023e8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c76:	0809a583          	lw	a1,128(s3)
    80002c7a:	0009a503          	lw	a0,0(s3)
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	880080e7          	jalr	-1920(ra) # 800024fe <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c86:	0809a023          	sw	zero,128(s3)
    80002c8a:	bf51                	j	80002c1e <itrunc+0x3e>

0000000080002c8c <iput>:
{
    80002c8c:	1101                	addi	sp,sp,-32
    80002c8e:	ec06                	sd	ra,24(sp)
    80002c90:	e822                	sd	s0,16(sp)
    80002c92:	e426                	sd	s1,8(sp)
    80002c94:	e04a                	sd	s2,0(sp)
    80002c96:	1000                	addi	s0,sp,32
    80002c98:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c9a:	00014517          	auipc	a0,0x14
    80002c9e:	16e50513          	addi	a0,a0,366 # 80016e08 <itable>
    80002ca2:	00003097          	auipc	ra,0x3
    80002ca6:	418080e7          	jalr	1048(ra) # 800060ba <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002caa:	4498                	lw	a4,8(s1)
    80002cac:	4785                	li	a5,1
    80002cae:	02f70363          	beq	a4,a5,80002cd4 <iput+0x48>
  ip->ref--;
    80002cb2:	449c                	lw	a5,8(s1)
    80002cb4:	37fd                	addiw	a5,a5,-1
    80002cb6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cb8:	00014517          	auipc	a0,0x14
    80002cbc:	15050513          	addi	a0,a0,336 # 80016e08 <itable>
    80002cc0:	00003097          	auipc	ra,0x3
    80002cc4:	4ae080e7          	jalr	1198(ra) # 8000616e <release>
}
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6902                	ld	s2,0(sp)
    80002cd0:	6105                	addi	sp,sp,32
    80002cd2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cd4:	40bc                	lw	a5,64(s1)
    80002cd6:	dff1                	beqz	a5,80002cb2 <iput+0x26>
    80002cd8:	04a49783          	lh	a5,74(s1)
    80002cdc:	fbf9                	bnez	a5,80002cb2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002cde:	01048913          	addi	s2,s1,16
    80002ce2:	854a                	mv	a0,s2
    80002ce4:	00001097          	auipc	ra,0x1
    80002ce8:	aa8080e7          	jalr	-1368(ra) # 8000378c <acquiresleep>
    release(&itable.lock);
    80002cec:	00014517          	auipc	a0,0x14
    80002cf0:	11c50513          	addi	a0,a0,284 # 80016e08 <itable>
    80002cf4:	00003097          	auipc	ra,0x3
    80002cf8:	47a080e7          	jalr	1146(ra) # 8000616e <release>
    itrunc(ip);
    80002cfc:	8526                	mv	a0,s1
    80002cfe:	00000097          	auipc	ra,0x0
    80002d02:	ee2080e7          	jalr	-286(ra) # 80002be0 <itrunc>
    ip->type = 0;
    80002d06:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d0a:	8526                	mv	a0,s1
    80002d0c:	00000097          	auipc	ra,0x0
    80002d10:	cfc080e7          	jalr	-772(ra) # 80002a08 <iupdate>
    ip->valid = 0;
    80002d14:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d18:	854a                	mv	a0,s2
    80002d1a:	00001097          	auipc	ra,0x1
    80002d1e:	ac8080e7          	jalr	-1336(ra) # 800037e2 <releasesleep>
    acquire(&itable.lock);
    80002d22:	00014517          	auipc	a0,0x14
    80002d26:	0e650513          	addi	a0,a0,230 # 80016e08 <itable>
    80002d2a:	00003097          	auipc	ra,0x3
    80002d2e:	390080e7          	jalr	912(ra) # 800060ba <acquire>
    80002d32:	b741                	j	80002cb2 <iput+0x26>

0000000080002d34 <iunlockput>:
{
    80002d34:	1101                	addi	sp,sp,-32
    80002d36:	ec06                	sd	ra,24(sp)
    80002d38:	e822                	sd	s0,16(sp)
    80002d3a:	e426                	sd	s1,8(sp)
    80002d3c:	1000                	addi	s0,sp,32
    80002d3e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	e54080e7          	jalr	-428(ra) # 80002b94 <iunlock>
  iput(ip);
    80002d48:	8526                	mv	a0,s1
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	f42080e7          	jalr	-190(ra) # 80002c8c <iput>
}
    80002d52:	60e2                	ld	ra,24(sp)
    80002d54:	6442                	ld	s0,16(sp)
    80002d56:	64a2                	ld	s1,8(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret

0000000080002d5c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d5c:	1141                	addi	sp,sp,-16
    80002d5e:	e422                	sd	s0,8(sp)
    80002d60:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d62:	411c                	lw	a5,0(a0)
    80002d64:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d66:	415c                	lw	a5,4(a0)
    80002d68:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d6a:	04451783          	lh	a5,68(a0)
    80002d6e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d72:	04a51783          	lh	a5,74(a0)
    80002d76:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d7a:	04c56783          	lwu	a5,76(a0)
    80002d7e:	e99c                	sd	a5,16(a1)
}
    80002d80:	6422                	ld	s0,8(sp)
    80002d82:	0141                	addi	sp,sp,16
    80002d84:	8082                	ret

0000000080002d86 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d86:	457c                	lw	a5,76(a0)
    80002d88:	0ed7e963          	bltu	a5,a3,80002e7a <readi+0xf4>
{
    80002d8c:	7159                	addi	sp,sp,-112
    80002d8e:	f486                	sd	ra,104(sp)
    80002d90:	f0a2                	sd	s0,96(sp)
    80002d92:	eca6                	sd	s1,88(sp)
    80002d94:	e8ca                	sd	s2,80(sp)
    80002d96:	e4ce                	sd	s3,72(sp)
    80002d98:	e0d2                	sd	s4,64(sp)
    80002d9a:	fc56                	sd	s5,56(sp)
    80002d9c:	f85a                	sd	s6,48(sp)
    80002d9e:	f45e                	sd	s7,40(sp)
    80002da0:	f062                	sd	s8,32(sp)
    80002da2:	ec66                	sd	s9,24(sp)
    80002da4:	e86a                	sd	s10,16(sp)
    80002da6:	e46e                	sd	s11,8(sp)
    80002da8:	1880                	addi	s0,sp,112
    80002daa:	8b2a                	mv	s6,a0
    80002dac:	8bae                	mv	s7,a1
    80002dae:	8a32                	mv	s4,a2
    80002db0:	84b6                	mv	s1,a3
    80002db2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002db4:	9f35                	addw	a4,a4,a3
    return 0;
    80002db6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002db8:	0ad76063          	bltu	a4,a3,80002e58 <readi+0xd2>
  if(off + n > ip->size)
    80002dbc:	00e7f463          	bgeu	a5,a4,80002dc4 <readi+0x3e>
    n = ip->size - off;
    80002dc0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dc4:	0a0a8963          	beqz	s5,80002e76 <readi+0xf0>
    80002dc8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dca:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dce:	5c7d                	li	s8,-1
    80002dd0:	a82d                	j	80002e0a <readi+0x84>
    80002dd2:	020d1d93          	slli	s11,s10,0x20
    80002dd6:	020ddd93          	srli	s11,s11,0x20
    80002dda:	05890793          	addi	a5,s2,88
    80002dde:	86ee                	mv	a3,s11
    80002de0:	963e                	add	a2,a2,a5
    80002de2:	85d2                	mv	a1,s4
    80002de4:	855e                	mv	a0,s7
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	b1c080e7          	jalr	-1252(ra) # 80001902 <either_copyout>
    80002dee:	05850d63          	beq	a0,s8,80002e48 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002df2:	854a                	mv	a0,s2
    80002df4:	fffff097          	auipc	ra,0xfffff
    80002df8:	5f4080e7          	jalr	1524(ra) # 800023e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dfc:	013d09bb          	addw	s3,s10,s3
    80002e00:	009d04bb          	addw	s1,s10,s1
    80002e04:	9a6e                	add	s4,s4,s11
    80002e06:	0559f763          	bgeu	s3,s5,80002e54 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e0a:	00a4d59b          	srliw	a1,s1,0xa
    80002e0e:	855a                	mv	a0,s6
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	8a2080e7          	jalr	-1886(ra) # 800026b2 <bmap>
    80002e18:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e1c:	cd85                	beqz	a1,80002e54 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e1e:	000b2503          	lw	a0,0(s6)
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	496080e7          	jalr	1174(ra) # 800022b8 <bread>
    80002e2a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e2c:	3ff4f613          	andi	a2,s1,1023
    80002e30:	40cc87bb          	subw	a5,s9,a2
    80002e34:	413a873b          	subw	a4,s5,s3
    80002e38:	8d3e                	mv	s10,a5
    80002e3a:	2781                	sext.w	a5,a5
    80002e3c:	0007069b          	sext.w	a3,a4
    80002e40:	f8f6f9e3          	bgeu	a3,a5,80002dd2 <readi+0x4c>
    80002e44:	8d3a                	mv	s10,a4
    80002e46:	b771                	j	80002dd2 <readi+0x4c>
      brelse(bp);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	fffff097          	auipc	ra,0xfffff
    80002e4e:	59e080e7          	jalr	1438(ra) # 800023e8 <brelse>
      tot = -1;
    80002e52:	59fd                	li	s3,-1
  }
  return tot;
    80002e54:	0009851b          	sext.w	a0,s3
}
    80002e58:	70a6                	ld	ra,104(sp)
    80002e5a:	7406                	ld	s0,96(sp)
    80002e5c:	64e6                	ld	s1,88(sp)
    80002e5e:	6946                	ld	s2,80(sp)
    80002e60:	69a6                	ld	s3,72(sp)
    80002e62:	6a06                	ld	s4,64(sp)
    80002e64:	7ae2                	ld	s5,56(sp)
    80002e66:	7b42                	ld	s6,48(sp)
    80002e68:	7ba2                	ld	s7,40(sp)
    80002e6a:	7c02                	ld	s8,32(sp)
    80002e6c:	6ce2                	ld	s9,24(sp)
    80002e6e:	6d42                	ld	s10,16(sp)
    80002e70:	6da2                	ld	s11,8(sp)
    80002e72:	6165                	addi	sp,sp,112
    80002e74:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e76:	89d6                	mv	s3,s5
    80002e78:	bff1                	j	80002e54 <readi+0xce>
    return 0;
    80002e7a:	4501                	li	a0,0
}
    80002e7c:	8082                	ret

0000000080002e7e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7e:	457c                	lw	a5,76(a0)
    80002e80:	10d7e863          	bltu	a5,a3,80002f90 <writei+0x112>
{
    80002e84:	7159                	addi	sp,sp,-112
    80002e86:	f486                	sd	ra,104(sp)
    80002e88:	f0a2                	sd	s0,96(sp)
    80002e8a:	eca6                	sd	s1,88(sp)
    80002e8c:	e8ca                	sd	s2,80(sp)
    80002e8e:	e4ce                	sd	s3,72(sp)
    80002e90:	e0d2                	sd	s4,64(sp)
    80002e92:	fc56                	sd	s5,56(sp)
    80002e94:	f85a                	sd	s6,48(sp)
    80002e96:	f45e                	sd	s7,40(sp)
    80002e98:	f062                	sd	s8,32(sp)
    80002e9a:	ec66                	sd	s9,24(sp)
    80002e9c:	e86a                	sd	s10,16(sp)
    80002e9e:	e46e                	sd	s11,8(sp)
    80002ea0:	1880                	addi	s0,sp,112
    80002ea2:	8aaa                	mv	s5,a0
    80002ea4:	8bae                	mv	s7,a1
    80002ea6:	8a32                	mv	s4,a2
    80002ea8:	8936                	mv	s2,a3
    80002eaa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eac:	00e687bb          	addw	a5,a3,a4
    80002eb0:	0ed7e263          	bltu	a5,a3,80002f94 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002eb4:	00043737          	lui	a4,0x43
    80002eb8:	0ef76063          	bltu	a4,a5,80002f98 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ebc:	0c0b0863          	beqz	s6,80002f8c <writei+0x10e>
    80002ec0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ec6:	5c7d                	li	s8,-1
    80002ec8:	a091                	j	80002f0c <writei+0x8e>
    80002eca:	020d1d93          	slli	s11,s10,0x20
    80002ece:	020ddd93          	srli	s11,s11,0x20
    80002ed2:	05848793          	addi	a5,s1,88
    80002ed6:	86ee                	mv	a3,s11
    80002ed8:	8652                	mv	a2,s4
    80002eda:	85de                	mv	a1,s7
    80002edc:	953e                	add	a0,a0,a5
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	a7a080e7          	jalr	-1414(ra) # 80001958 <either_copyin>
    80002ee6:	07850263          	beq	a0,s8,80002f4a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002eea:	8526                	mv	a0,s1
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	780080e7          	jalr	1920(ra) # 8000366c <log_write>
    brelse(bp);
    80002ef4:	8526                	mv	a0,s1
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	4f2080e7          	jalr	1266(ra) # 800023e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002efe:	013d09bb          	addw	s3,s10,s3
    80002f02:	012d093b          	addw	s2,s10,s2
    80002f06:	9a6e                	add	s4,s4,s11
    80002f08:	0569f663          	bgeu	s3,s6,80002f54 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f0c:	00a9559b          	srliw	a1,s2,0xa
    80002f10:	8556                	mv	a0,s5
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	7a0080e7          	jalr	1952(ra) # 800026b2 <bmap>
    80002f1a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f1e:	c99d                	beqz	a1,80002f54 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f20:	000aa503          	lw	a0,0(s5)
    80002f24:	fffff097          	auipc	ra,0xfffff
    80002f28:	394080e7          	jalr	916(ra) # 800022b8 <bread>
    80002f2c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2e:	3ff97513          	andi	a0,s2,1023
    80002f32:	40ac87bb          	subw	a5,s9,a0
    80002f36:	413b073b          	subw	a4,s6,s3
    80002f3a:	8d3e                	mv	s10,a5
    80002f3c:	2781                	sext.w	a5,a5
    80002f3e:	0007069b          	sext.w	a3,a4
    80002f42:	f8f6f4e3          	bgeu	a3,a5,80002eca <writei+0x4c>
    80002f46:	8d3a                	mv	s10,a4
    80002f48:	b749                	j	80002eca <writei+0x4c>
      brelse(bp);
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	49c080e7          	jalr	1180(ra) # 800023e8 <brelse>
  }

  if(off > ip->size)
    80002f54:	04caa783          	lw	a5,76(s5)
    80002f58:	0127f463          	bgeu	a5,s2,80002f60 <writei+0xe2>
    ip->size = off;
    80002f5c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f60:	8556                	mv	a0,s5
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	aa6080e7          	jalr	-1370(ra) # 80002a08 <iupdate>

  return tot;
    80002f6a:	0009851b          	sext.w	a0,s3
}
    80002f6e:	70a6                	ld	ra,104(sp)
    80002f70:	7406                	ld	s0,96(sp)
    80002f72:	64e6                	ld	s1,88(sp)
    80002f74:	6946                	ld	s2,80(sp)
    80002f76:	69a6                	ld	s3,72(sp)
    80002f78:	6a06                	ld	s4,64(sp)
    80002f7a:	7ae2                	ld	s5,56(sp)
    80002f7c:	7b42                	ld	s6,48(sp)
    80002f7e:	7ba2                	ld	s7,40(sp)
    80002f80:	7c02                	ld	s8,32(sp)
    80002f82:	6ce2                	ld	s9,24(sp)
    80002f84:	6d42                	ld	s10,16(sp)
    80002f86:	6da2                	ld	s11,8(sp)
    80002f88:	6165                	addi	sp,sp,112
    80002f8a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8c:	89da                	mv	s3,s6
    80002f8e:	bfc9                	j	80002f60 <writei+0xe2>
    return -1;
    80002f90:	557d                	li	a0,-1
}
    80002f92:	8082                	ret
    return -1;
    80002f94:	557d                	li	a0,-1
    80002f96:	bfe1                	j	80002f6e <writei+0xf0>
    return -1;
    80002f98:	557d                	li	a0,-1
    80002f9a:	bfd1                	j	80002f6e <writei+0xf0>

0000000080002f9c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f9c:	1141                	addi	sp,sp,-16
    80002f9e:	e406                	sd	ra,8(sp)
    80002fa0:	e022                	sd	s0,0(sp)
    80002fa2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fa4:	4639                	li	a2,14
    80002fa6:	ffffd097          	auipc	ra,0xffffd
    80002faa:	2a2080e7          	jalr	674(ra) # 80000248 <strncmp>
}
    80002fae:	60a2                	ld	ra,8(sp)
    80002fb0:	6402                	ld	s0,0(sp)
    80002fb2:	0141                	addi	sp,sp,16
    80002fb4:	8082                	ret

0000000080002fb6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fb6:	7139                	addi	sp,sp,-64
    80002fb8:	fc06                	sd	ra,56(sp)
    80002fba:	f822                	sd	s0,48(sp)
    80002fbc:	f426                	sd	s1,40(sp)
    80002fbe:	f04a                	sd	s2,32(sp)
    80002fc0:	ec4e                	sd	s3,24(sp)
    80002fc2:	e852                	sd	s4,16(sp)
    80002fc4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fc6:	04451703          	lh	a4,68(a0)
    80002fca:	4785                	li	a5,1
    80002fcc:	00f71a63          	bne	a4,a5,80002fe0 <dirlookup+0x2a>
    80002fd0:	892a                	mv	s2,a0
    80002fd2:	89ae                	mv	s3,a1
    80002fd4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd6:	457c                	lw	a5,76(a0)
    80002fd8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fda:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fdc:	e79d                	bnez	a5,8000300a <dirlookup+0x54>
    80002fde:	a8a5                	j	80003056 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fe0:	00005517          	auipc	a0,0x5
    80002fe4:	59050513          	addi	a0,a0,1424 # 80008570 <syscalls+0x1a0>
    80002fe8:	00003097          	auipc	ra,0x3
    80002fec:	b96080e7          	jalr	-1130(ra) # 80005b7e <panic>
      panic("dirlookup read");
    80002ff0:	00005517          	auipc	a0,0x5
    80002ff4:	59850513          	addi	a0,a0,1432 # 80008588 <syscalls+0x1b8>
    80002ff8:	00003097          	auipc	ra,0x3
    80002ffc:	b86080e7          	jalr	-1146(ra) # 80005b7e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003000:	24c1                	addiw	s1,s1,16
    80003002:	04c92783          	lw	a5,76(s2)
    80003006:	04f4f763          	bgeu	s1,a5,80003054 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000300a:	4741                	li	a4,16
    8000300c:	86a6                	mv	a3,s1
    8000300e:	fc040613          	addi	a2,s0,-64
    80003012:	4581                	li	a1,0
    80003014:	854a                	mv	a0,s2
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	d70080e7          	jalr	-656(ra) # 80002d86 <readi>
    8000301e:	47c1                	li	a5,16
    80003020:	fcf518e3          	bne	a0,a5,80002ff0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003024:	fc045783          	lhu	a5,-64(s0)
    80003028:	dfe1                	beqz	a5,80003000 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000302a:	fc240593          	addi	a1,s0,-62
    8000302e:	854e                	mv	a0,s3
    80003030:	00000097          	auipc	ra,0x0
    80003034:	f6c080e7          	jalr	-148(ra) # 80002f9c <namecmp>
    80003038:	f561                	bnez	a0,80003000 <dirlookup+0x4a>
      if(poff)
    8000303a:	000a0463          	beqz	s4,80003042 <dirlookup+0x8c>
        *poff = off;
    8000303e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003042:	fc045583          	lhu	a1,-64(s0)
    80003046:	00092503          	lw	a0,0(s2)
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	750080e7          	jalr	1872(ra) # 8000279a <iget>
    80003052:	a011                	j	80003056 <dirlookup+0xa0>
  return 0;
    80003054:	4501                	li	a0,0
}
    80003056:	70e2                	ld	ra,56(sp)
    80003058:	7442                	ld	s0,48(sp)
    8000305a:	74a2                	ld	s1,40(sp)
    8000305c:	7902                	ld	s2,32(sp)
    8000305e:	69e2                	ld	s3,24(sp)
    80003060:	6a42                	ld	s4,16(sp)
    80003062:	6121                	addi	sp,sp,64
    80003064:	8082                	ret

0000000080003066 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003066:	711d                	addi	sp,sp,-96
    80003068:	ec86                	sd	ra,88(sp)
    8000306a:	e8a2                	sd	s0,80(sp)
    8000306c:	e4a6                	sd	s1,72(sp)
    8000306e:	e0ca                	sd	s2,64(sp)
    80003070:	fc4e                	sd	s3,56(sp)
    80003072:	f852                	sd	s4,48(sp)
    80003074:	f456                	sd	s5,40(sp)
    80003076:	f05a                	sd	s6,32(sp)
    80003078:	ec5e                	sd	s7,24(sp)
    8000307a:	e862                	sd	s8,16(sp)
    8000307c:	e466                	sd	s9,8(sp)
    8000307e:	1080                	addi	s0,sp,96
    80003080:	84aa                	mv	s1,a0
    80003082:	8aae                	mv	s5,a1
    80003084:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003086:	00054703          	lbu	a4,0(a0)
    8000308a:	02f00793          	li	a5,47
    8000308e:	02f70363          	beq	a4,a5,800030b4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	dc0080e7          	jalr	-576(ra) # 80000e52 <myproc>
    8000309a:	15053503          	ld	a0,336(a0)
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	9f6080e7          	jalr	-1546(ra) # 80002a94 <idup>
    800030a6:	89aa                	mv	s3,a0
  while(*path == '/')
    800030a8:	02f00913          	li	s2,47
  len = path - s;
    800030ac:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800030ae:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030b0:	4b85                	li	s7,1
    800030b2:	a865                	j	8000316a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030b4:	4585                	li	a1,1
    800030b6:	4505                	li	a0,1
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	6e2080e7          	jalr	1762(ra) # 8000279a <iget>
    800030c0:	89aa                	mv	s3,a0
    800030c2:	b7dd                	j	800030a8 <namex+0x42>
      iunlockput(ip);
    800030c4:	854e                	mv	a0,s3
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	c6e080e7          	jalr	-914(ra) # 80002d34 <iunlockput>
      return 0;
    800030ce:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030d0:	854e                	mv	a0,s3
    800030d2:	60e6                	ld	ra,88(sp)
    800030d4:	6446                	ld	s0,80(sp)
    800030d6:	64a6                	ld	s1,72(sp)
    800030d8:	6906                	ld	s2,64(sp)
    800030da:	79e2                	ld	s3,56(sp)
    800030dc:	7a42                	ld	s4,48(sp)
    800030de:	7aa2                	ld	s5,40(sp)
    800030e0:	7b02                	ld	s6,32(sp)
    800030e2:	6be2                	ld	s7,24(sp)
    800030e4:	6c42                	ld	s8,16(sp)
    800030e6:	6ca2                	ld	s9,8(sp)
    800030e8:	6125                	addi	sp,sp,96
    800030ea:	8082                	ret
      iunlock(ip);
    800030ec:	854e                	mv	a0,s3
    800030ee:	00000097          	auipc	ra,0x0
    800030f2:	aa6080e7          	jalr	-1370(ra) # 80002b94 <iunlock>
      return ip;
    800030f6:	bfe9                	j	800030d0 <namex+0x6a>
      iunlockput(ip);
    800030f8:	854e                	mv	a0,s3
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	c3a080e7          	jalr	-966(ra) # 80002d34 <iunlockput>
      return 0;
    80003102:	89e6                	mv	s3,s9
    80003104:	b7f1                	j	800030d0 <namex+0x6a>
  len = path - s;
    80003106:	40b48633          	sub	a2,s1,a1
    8000310a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000310e:	099c5463          	bge	s8,s9,80003196 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003112:	4639                	li	a2,14
    80003114:	8552                	mv	a0,s4
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	0be080e7          	jalr	190(ra) # 800001d4 <memmove>
  while(*path == '/')
    8000311e:	0004c783          	lbu	a5,0(s1)
    80003122:	01279763          	bne	a5,s2,80003130 <namex+0xca>
    path++;
    80003126:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003128:	0004c783          	lbu	a5,0(s1)
    8000312c:	ff278de3          	beq	a5,s2,80003126 <namex+0xc0>
    ilock(ip);
    80003130:	854e                	mv	a0,s3
    80003132:	00000097          	auipc	ra,0x0
    80003136:	9a0080e7          	jalr	-1632(ra) # 80002ad2 <ilock>
    if(ip->type != T_DIR){
    8000313a:	04499783          	lh	a5,68(s3)
    8000313e:	f97793e3          	bne	a5,s7,800030c4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003142:	000a8563          	beqz	s5,8000314c <namex+0xe6>
    80003146:	0004c783          	lbu	a5,0(s1)
    8000314a:	d3cd                	beqz	a5,800030ec <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000314c:	865a                	mv	a2,s6
    8000314e:	85d2                	mv	a1,s4
    80003150:	854e                	mv	a0,s3
    80003152:	00000097          	auipc	ra,0x0
    80003156:	e64080e7          	jalr	-412(ra) # 80002fb6 <dirlookup>
    8000315a:	8caa                	mv	s9,a0
    8000315c:	dd51                	beqz	a0,800030f8 <namex+0x92>
    iunlockput(ip);
    8000315e:	854e                	mv	a0,s3
    80003160:	00000097          	auipc	ra,0x0
    80003164:	bd4080e7          	jalr	-1068(ra) # 80002d34 <iunlockput>
    ip = next;
    80003168:	89e6                	mv	s3,s9
  while(*path == '/')
    8000316a:	0004c783          	lbu	a5,0(s1)
    8000316e:	05279763          	bne	a5,s2,800031bc <namex+0x156>
    path++;
    80003172:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003174:	0004c783          	lbu	a5,0(s1)
    80003178:	ff278de3          	beq	a5,s2,80003172 <namex+0x10c>
  if(*path == 0)
    8000317c:	c79d                	beqz	a5,800031aa <namex+0x144>
    path++;
    8000317e:	85a6                	mv	a1,s1
  len = path - s;
    80003180:	8cda                	mv	s9,s6
    80003182:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003184:	01278963          	beq	a5,s2,80003196 <namex+0x130>
    80003188:	dfbd                	beqz	a5,80003106 <namex+0xa0>
    path++;
    8000318a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000318c:	0004c783          	lbu	a5,0(s1)
    80003190:	ff279ce3          	bne	a5,s2,80003188 <namex+0x122>
    80003194:	bf8d                	j	80003106 <namex+0xa0>
    memmove(name, s, len);
    80003196:	2601                	sext.w	a2,a2
    80003198:	8552                	mv	a0,s4
    8000319a:	ffffd097          	auipc	ra,0xffffd
    8000319e:	03a080e7          	jalr	58(ra) # 800001d4 <memmove>
    name[len] = 0;
    800031a2:	9cd2                	add	s9,s9,s4
    800031a4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031a8:	bf9d                	j	8000311e <namex+0xb8>
  if(nameiparent){
    800031aa:	f20a83e3          	beqz	s5,800030d0 <namex+0x6a>
    iput(ip);
    800031ae:	854e                	mv	a0,s3
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	adc080e7          	jalr	-1316(ra) # 80002c8c <iput>
    return 0;
    800031b8:	4981                	li	s3,0
    800031ba:	bf19                	j	800030d0 <namex+0x6a>
  if(*path == 0)
    800031bc:	d7fd                	beqz	a5,800031aa <namex+0x144>
  while(*path != '/' && *path != 0)
    800031be:	0004c783          	lbu	a5,0(s1)
    800031c2:	85a6                	mv	a1,s1
    800031c4:	b7d1                	j	80003188 <namex+0x122>

00000000800031c6 <dirlink>:
{
    800031c6:	7139                	addi	sp,sp,-64
    800031c8:	fc06                	sd	ra,56(sp)
    800031ca:	f822                	sd	s0,48(sp)
    800031cc:	f426                	sd	s1,40(sp)
    800031ce:	f04a                	sd	s2,32(sp)
    800031d0:	ec4e                	sd	s3,24(sp)
    800031d2:	e852                	sd	s4,16(sp)
    800031d4:	0080                	addi	s0,sp,64
    800031d6:	892a                	mv	s2,a0
    800031d8:	8a2e                	mv	s4,a1
    800031da:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031dc:	4601                	li	a2,0
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	dd8080e7          	jalr	-552(ra) # 80002fb6 <dirlookup>
    800031e6:	e93d                	bnez	a0,8000325c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e8:	04c92483          	lw	s1,76(s2)
    800031ec:	c49d                	beqz	s1,8000321a <dirlink+0x54>
    800031ee:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f0:	4741                	li	a4,16
    800031f2:	86a6                	mv	a3,s1
    800031f4:	fc040613          	addi	a2,s0,-64
    800031f8:	4581                	li	a1,0
    800031fa:	854a                	mv	a0,s2
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	b8a080e7          	jalr	-1142(ra) # 80002d86 <readi>
    80003204:	47c1                	li	a5,16
    80003206:	06f51163          	bne	a0,a5,80003268 <dirlink+0xa2>
    if(de.inum == 0)
    8000320a:	fc045783          	lhu	a5,-64(s0)
    8000320e:	c791                	beqz	a5,8000321a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003210:	24c1                	addiw	s1,s1,16
    80003212:	04c92783          	lw	a5,76(s2)
    80003216:	fcf4ede3          	bltu	s1,a5,800031f0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000321a:	4639                	li	a2,14
    8000321c:	85d2                	mv	a1,s4
    8000321e:	fc240513          	addi	a0,s0,-62
    80003222:	ffffd097          	auipc	ra,0xffffd
    80003226:	062080e7          	jalr	98(ra) # 80000284 <strncpy>
  de.inum = inum;
    8000322a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000322e:	4741                	li	a4,16
    80003230:	86a6                	mv	a3,s1
    80003232:	fc040613          	addi	a2,s0,-64
    80003236:	4581                	li	a1,0
    80003238:	854a                	mv	a0,s2
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	c44080e7          	jalr	-956(ra) # 80002e7e <writei>
    80003242:	1541                	addi	a0,a0,-16
    80003244:	00a03533          	snez	a0,a0
    80003248:	40a00533          	neg	a0,a0
}
    8000324c:	70e2                	ld	ra,56(sp)
    8000324e:	7442                	ld	s0,48(sp)
    80003250:	74a2                	ld	s1,40(sp)
    80003252:	7902                	ld	s2,32(sp)
    80003254:	69e2                	ld	s3,24(sp)
    80003256:	6a42                	ld	s4,16(sp)
    80003258:	6121                	addi	sp,sp,64
    8000325a:	8082                	ret
    iput(ip);
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	a30080e7          	jalr	-1488(ra) # 80002c8c <iput>
    return -1;
    80003264:	557d                	li	a0,-1
    80003266:	b7dd                	j	8000324c <dirlink+0x86>
      panic("dirlink read");
    80003268:	00005517          	auipc	a0,0x5
    8000326c:	33050513          	addi	a0,a0,816 # 80008598 <syscalls+0x1c8>
    80003270:	00003097          	auipc	ra,0x3
    80003274:	90e080e7          	jalr	-1778(ra) # 80005b7e <panic>

0000000080003278 <namei>:

struct inode*
namei(char *path)
{
    80003278:	1101                	addi	sp,sp,-32
    8000327a:	ec06                	sd	ra,24(sp)
    8000327c:	e822                	sd	s0,16(sp)
    8000327e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003280:	fe040613          	addi	a2,s0,-32
    80003284:	4581                	li	a1,0
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	de0080e7          	jalr	-544(ra) # 80003066 <namex>
}
    8000328e:	60e2                	ld	ra,24(sp)
    80003290:	6442                	ld	s0,16(sp)
    80003292:	6105                	addi	sp,sp,32
    80003294:	8082                	ret

0000000080003296 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003296:	1141                	addi	sp,sp,-16
    80003298:	e406                	sd	ra,8(sp)
    8000329a:	e022                	sd	s0,0(sp)
    8000329c:	0800                	addi	s0,sp,16
    8000329e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032a0:	4585                	li	a1,1
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	dc4080e7          	jalr	-572(ra) # 80003066 <namex>
}
    800032aa:	60a2                	ld	ra,8(sp)
    800032ac:	6402                	ld	s0,0(sp)
    800032ae:	0141                	addi	sp,sp,16
    800032b0:	8082                	ret

00000000800032b2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032b2:	1101                	addi	sp,sp,-32
    800032b4:	ec06                	sd	ra,24(sp)
    800032b6:	e822                	sd	s0,16(sp)
    800032b8:	e426                	sd	s1,8(sp)
    800032ba:	e04a                	sd	s2,0(sp)
    800032bc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032be:	00015917          	auipc	s2,0x15
    800032c2:	5f290913          	addi	s2,s2,1522 # 800188b0 <log>
    800032c6:	01892583          	lw	a1,24(s2)
    800032ca:	02892503          	lw	a0,40(s2)
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	fea080e7          	jalr	-22(ra) # 800022b8 <bread>
    800032d6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032d8:	02c92683          	lw	a3,44(s2)
    800032dc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032de:	02d05763          	blez	a3,8000330c <write_head+0x5a>
    800032e2:	00015797          	auipc	a5,0x15
    800032e6:	5fe78793          	addi	a5,a5,1534 # 800188e0 <log+0x30>
    800032ea:	05c50713          	addi	a4,a0,92
    800032ee:	36fd                	addiw	a3,a3,-1
    800032f0:	1682                	slli	a3,a3,0x20
    800032f2:	9281                	srli	a3,a3,0x20
    800032f4:	068a                	slli	a3,a3,0x2
    800032f6:	00015617          	auipc	a2,0x15
    800032fa:	5ee60613          	addi	a2,a2,1518 # 800188e4 <log+0x34>
    800032fe:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003300:	4390                	lw	a2,0(a5)
    80003302:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003304:	0791                	addi	a5,a5,4
    80003306:	0711                	addi	a4,a4,4
    80003308:	fed79ce3          	bne	a5,a3,80003300 <write_head+0x4e>
  }
  bwrite(buf);
    8000330c:	8526                	mv	a0,s1
    8000330e:	fffff097          	auipc	ra,0xfffff
    80003312:	09c080e7          	jalr	156(ra) # 800023aa <bwrite>
  brelse(buf);
    80003316:	8526                	mv	a0,s1
    80003318:	fffff097          	auipc	ra,0xfffff
    8000331c:	0d0080e7          	jalr	208(ra) # 800023e8 <brelse>
}
    80003320:	60e2                	ld	ra,24(sp)
    80003322:	6442                	ld	s0,16(sp)
    80003324:	64a2                	ld	s1,8(sp)
    80003326:	6902                	ld	s2,0(sp)
    80003328:	6105                	addi	sp,sp,32
    8000332a:	8082                	ret

000000008000332c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000332c:	00015797          	auipc	a5,0x15
    80003330:	5b07a783          	lw	a5,1456(a5) # 800188dc <log+0x2c>
    80003334:	0af05d63          	blez	a5,800033ee <install_trans+0xc2>
{
    80003338:	7139                	addi	sp,sp,-64
    8000333a:	fc06                	sd	ra,56(sp)
    8000333c:	f822                	sd	s0,48(sp)
    8000333e:	f426                	sd	s1,40(sp)
    80003340:	f04a                	sd	s2,32(sp)
    80003342:	ec4e                	sd	s3,24(sp)
    80003344:	e852                	sd	s4,16(sp)
    80003346:	e456                	sd	s5,8(sp)
    80003348:	e05a                	sd	s6,0(sp)
    8000334a:	0080                	addi	s0,sp,64
    8000334c:	8b2a                	mv	s6,a0
    8000334e:	00015a97          	auipc	s5,0x15
    80003352:	592a8a93          	addi	s5,s5,1426 # 800188e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003356:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003358:	00015997          	auipc	s3,0x15
    8000335c:	55898993          	addi	s3,s3,1368 # 800188b0 <log>
    80003360:	a00d                	j	80003382 <install_trans+0x56>
    brelse(lbuf);
    80003362:	854a                	mv	a0,s2
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	084080e7          	jalr	132(ra) # 800023e8 <brelse>
    brelse(dbuf);
    8000336c:	8526                	mv	a0,s1
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	07a080e7          	jalr	122(ra) # 800023e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003376:	2a05                	addiw	s4,s4,1
    80003378:	0a91                	addi	s5,s5,4
    8000337a:	02c9a783          	lw	a5,44(s3)
    8000337e:	04fa5e63          	bge	s4,a5,800033da <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003382:	0189a583          	lw	a1,24(s3)
    80003386:	014585bb          	addw	a1,a1,s4
    8000338a:	2585                	addiw	a1,a1,1
    8000338c:	0289a503          	lw	a0,40(s3)
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	f28080e7          	jalr	-216(ra) # 800022b8 <bread>
    80003398:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000339a:	000aa583          	lw	a1,0(s5)
    8000339e:	0289a503          	lw	a0,40(s3)
    800033a2:	fffff097          	auipc	ra,0xfffff
    800033a6:	f16080e7          	jalr	-234(ra) # 800022b8 <bread>
    800033aa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ac:	40000613          	li	a2,1024
    800033b0:	05890593          	addi	a1,s2,88
    800033b4:	05850513          	addi	a0,a0,88
    800033b8:	ffffd097          	auipc	ra,0xffffd
    800033bc:	e1c080e7          	jalr	-484(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033c0:	8526                	mv	a0,s1
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	fe8080e7          	jalr	-24(ra) # 800023aa <bwrite>
    if(recovering == 0)
    800033ca:	f80b1ce3          	bnez	s6,80003362 <install_trans+0x36>
      bunpin(dbuf);
    800033ce:	8526                	mv	a0,s1
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	0f2080e7          	jalr	242(ra) # 800024c2 <bunpin>
    800033d8:	b769                	j	80003362 <install_trans+0x36>
}
    800033da:	70e2                	ld	ra,56(sp)
    800033dc:	7442                	ld	s0,48(sp)
    800033de:	74a2                	ld	s1,40(sp)
    800033e0:	7902                	ld	s2,32(sp)
    800033e2:	69e2                	ld	s3,24(sp)
    800033e4:	6a42                	ld	s4,16(sp)
    800033e6:	6aa2                	ld	s5,8(sp)
    800033e8:	6b02                	ld	s6,0(sp)
    800033ea:	6121                	addi	sp,sp,64
    800033ec:	8082                	ret
    800033ee:	8082                	ret

00000000800033f0 <initlog>:
{
    800033f0:	7179                	addi	sp,sp,-48
    800033f2:	f406                	sd	ra,40(sp)
    800033f4:	f022                	sd	s0,32(sp)
    800033f6:	ec26                	sd	s1,24(sp)
    800033f8:	e84a                	sd	s2,16(sp)
    800033fa:	e44e                	sd	s3,8(sp)
    800033fc:	1800                	addi	s0,sp,48
    800033fe:	892a                	mv	s2,a0
    80003400:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003402:	00015497          	auipc	s1,0x15
    80003406:	4ae48493          	addi	s1,s1,1198 # 800188b0 <log>
    8000340a:	00005597          	auipc	a1,0x5
    8000340e:	19e58593          	addi	a1,a1,414 # 800085a8 <syscalls+0x1d8>
    80003412:	8526                	mv	a0,s1
    80003414:	00003097          	auipc	ra,0x3
    80003418:	c16080e7          	jalr	-1002(ra) # 8000602a <initlock>
  log.start = sb->logstart;
    8000341c:	0149a583          	lw	a1,20(s3)
    80003420:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003422:	0109a783          	lw	a5,16(s3)
    80003426:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003428:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000342c:	854a                	mv	a0,s2
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	e8a080e7          	jalr	-374(ra) # 800022b8 <bread>
  log.lh.n = lh->n;
    80003436:	4d34                	lw	a3,88(a0)
    80003438:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000343a:	02d05563          	blez	a3,80003464 <initlog+0x74>
    8000343e:	05c50793          	addi	a5,a0,92
    80003442:	00015717          	auipc	a4,0x15
    80003446:	49e70713          	addi	a4,a4,1182 # 800188e0 <log+0x30>
    8000344a:	36fd                	addiw	a3,a3,-1
    8000344c:	1682                	slli	a3,a3,0x20
    8000344e:	9281                	srli	a3,a3,0x20
    80003450:	068a                	slli	a3,a3,0x2
    80003452:	06050613          	addi	a2,a0,96
    80003456:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003458:	4390                	lw	a2,0(a5)
    8000345a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	0791                	addi	a5,a5,4
    8000345e:	0711                	addi	a4,a4,4
    80003460:	fed79ce3          	bne	a5,a3,80003458 <initlog+0x68>
  brelse(buf);
    80003464:	fffff097          	auipc	ra,0xfffff
    80003468:	f84080e7          	jalr	-124(ra) # 800023e8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000346c:	4505                	li	a0,1
    8000346e:	00000097          	auipc	ra,0x0
    80003472:	ebe080e7          	jalr	-322(ra) # 8000332c <install_trans>
  log.lh.n = 0;
    80003476:	00015797          	auipc	a5,0x15
    8000347a:	4607a323          	sw	zero,1126(a5) # 800188dc <log+0x2c>
  write_head(); // clear the log
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	e34080e7          	jalr	-460(ra) # 800032b2 <write_head>
}
    80003486:	70a2                	ld	ra,40(sp)
    80003488:	7402                	ld	s0,32(sp)
    8000348a:	64e2                	ld	s1,24(sp)
    8000348c:	6942                	ld	s2,16(sp)
    8000348e:	69a2                	ld	s3,8(sp)
    80003490:	6145                	addi	sp,sp,48
    80003492:	8082                	ret

0000000080003494 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003494:	1101                	addi	sp,sp,-32
    80003496:	ec06                	sd	ra,24(sp)
    80003498:	e822                	sd	s0,16(sp)
    8000349a:	e426                	sd	s1,8(sp)
    8000349c:	e04a                	sd	s2,0(sp)
    8000349e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034a0:	00015517          	auipc	a0,0x15
    800034a4:	41050513          	addi	a0,a0,1040 # 800188b0 <log>
    800034a8:	00003097          	auipc	ra,0x3
    800034ac:	c12080e7          	jalr	-1006(ra) # 800060ba <acquire>
  while(1){
    if(log.committing){
    800034b0:	00015497          	auipc	s1,0x15
    800034b4:	40048493          	addi	s1,s1,1024 # 800188b0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034b8:	4979                	li	s2,30
    800034ba:	a039                	j	800034c8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034bc:	85a6                	mv	a1,s1
    800034be:	8526                	mv	a0,s1
    800034c0:	ffffe097          	auipc	ra,0xffffe
    800034c4:	03a080e7          	jalr	58(ra) # 800014fa <sleep>
    if(log.committing){
    800034c8:	50dc                	lw	a5,36(s1)
    800034ca:	fbed                	bnez	a5,800034bc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034cc:	509c                	lw	a5,32(s1)
    800034ce:	0017871b          	addiw	a4,a5,1
    800034d2:	0007069b          	sext.w	a3,a4
    800034d6:	0027179b          	slliw	a5,a4,0x2
    800034da:	9fb9                	addw	a5,a5,a4
    800034dc:	0017979b          	slliw	a5,a5,0x1
    800034e0:	54d8                	lw	a4,44(s1)
    800034e2:	9fb9                	addw	a5,a5,a4
    800034e4:	00f95963          	bge	s2,a5,800034f6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034e8:	85a6                	mv	a1,s1
    800034ea:	8526                	mv	a0,s1
    800034ec:	ffffe097          	auipc	ra,0xffffe
    800034f0:	00e080e7          	jalr	14(ra) # 800014fa <sleep>
    800034f4:	bfd1                	j	800034c8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034f6:	00015517          	auipc	a0,0x15
    800034fa:	3ba50513          	addi	a0,a0,954 # 800188b0 <log>
    800034fe:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003500:	00003097          	auipc	ra,0x3
    80003504:	c6e080e7          	jalr	-914(ra) # 8000616e <release>
      break;
    }
  }
}
    80003508:	60e2                	ld	ra,24(sp)
    8000350a:	6442                	ld	s0,16(sp)
    8000350c:	64a2                	ld	s1,8(sp)
    8000350e:	6902                	ld	s2,0(sp)
    80003510:	6105                	addi	sp,sp,32
    80003512:	8082                	ret

0000000080003514 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003514:	7139                	addi	sp,sp,-64
    80003516:	fc06                	sd	ra,56(sp)
    80003518:	f822                	sd	s0,48(sp)
    8000351a:	f426                	sd	s1,40(sp)
    8000351c:	f04a                	sd	s2,32(sp)
    8000351e:	ec4e                	sd	s3,24(sp)
    80003520:	e852                	sd	s4,16(sp)
    80003522:	e456                	sd	s5,8(sp)
    80003524:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003526:	00015497          	auipc	s1,0x15
    8000352a:	38a48493          	addi	s1,s1,906 # 800188b0 <log>
    8000352e:	8526                	mv	a0,s1
    80003530:	00003097          	auipc	ra,0x3
    80003534:	b8a080e7          	jalr	-1142(ra) # 800060ba <acquire>
  log.outstanding -= 1;
    80003538:	509c                	lw	a5,32(s1)
    8000353a:	37fd                	addiw	a5,a5,-1
    8000353c:	0007891b          	sext.w	s2,a5
    80003540:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003542:	50dc                	lw	a5,36(s1)
    80003544:	e7b9                	bnez	a5,80003592 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003546:	04091e63          	bnez	s2,800035a2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000354a:	00015497          	auipc	s1,0x15
    8000354e:	36648493          	addi	s1,s1,870 # 800188b0 <log>
    80003552:	4785                	li	a5,1
    80003554:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003556:	8526                	mv	a0,s1
    80003558:	00003097          	auipc	ra,0x3
    8000355c:	c16080e7          	jalr	-1002(ra) # 8000616e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003560:	54dc                	lw	a5,44(s1)
    80003562:	06f04763          	bgtz	a5,800035d0 <end_op+0xbc>
    acquire(&log.lock);
    80003566:	00015497          	auipc	s1,0x15
    8000356a:	34a48493          	addi	s1,s1,842 # 800188b0 <log>
    8000356e:	8526                	mv	a0,s1
    80003570:	00003097          	auipc	ra,0x3
    80003574:	b4a080e7          	jalr	-1206(ra) # 800060ba <acquire>
    log.committing = 0;
    80003578:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000357c:	8526                	mv	a0,s1
    8000357e:	ffffe097          	auipc	ra,0xffffe
    80003582:	fe0080e7          	jalr	-32(ra) # 8000155e <wakeup>
    release(&log.lock);
    80003586:	8526                	mv	a0,s1
    80003588:	00003097          	auipc	ra,0x3
    8000358c:	be6080e7          	jalr	-1050(ra) # 8000616e <release>
}
    80003590:	a03d                	j	800035be <end_op+0xaa>
    panic("log.committing");
    80003592:	00005517          	auipc	a0,0x5
    80003596:	01e50513          	addi	a0,a0,30 # 800085b0 <syscalls+0x1e0>
    8000359a:	00002097          	auipc	ra,0x2
    8000359e:	5e4080e7          	jalr	1508(ra) # 80005b7e <panic>
    wakeup(&log);
    800035a2:	00015497          	auipc	s1,0x15
    800035a6:	30e48493          	addi	s1,s1,782 # 800188b0 <log>
    800035aa:	8526                	mv	a0,s1
    800035ac:	ffffe097          	auipc	ra,0xffffe
    800035b0:	fb2080e7          	jalr	-78(ra) # 8000155e <wakeup>
  release(&log.lock);
    800035b4:	8526                	mv	a0,s1
    800035b6:	00003097          	auipc	ra,0x3
    800035ba:	bb8080e7          	jalr	-1096(ra) # 8000616e <release>
}
    800035be:	70e2                	ld	ra,56(sp)
    800035c0:	7442                	ld	s0,48(sp)
    800035c2:	74a2                	ld	s1,40(sp)
    800035c4:	7902                	ld	s2,32(sp)
    800035c6:	69e2                	ld	s3,24(sp)
    800035c8:	6a42                	ld	s4,16(sp)
    800035ca:	6aa2                	ld	s5,8(sp)
    800035cc:	6121                	addi	sp,sp,64
    800035ce:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d0:	00015a97          	auipc	s5,0x15
    800035d4:	310a8a93          	addi	s5,s5,784 # 800188e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035d8:	00015a17          	auipc	s4,0x15
    800035dc:	2d8a0a13          	addi	s4,s4,728 # 800188b0 <log>
    800035e0:	018a2583          	lw	a1,24(s4)
    800035e4:	012585bb          	addw	a1,a1,s2
    800035e8:	2585                	addiw	a1,a1,1
    800035ea:	028a2503          	lw	a0,40(s4)
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	cca080e7          	jalr	-822(ra) # 800022b8 <bread>
    800035f6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035f8:	000aa583          	lw	a1,0(s5)
    800035fc:	028a2503          	lw	a0,40(s4)
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	cb8080e7          	jalr	-840(ra) # 800022b8 <bread>
    80003608:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000360a:	40000613          	li	a2,1024
    8000360e:	05850593          	addi	a1,a0,88
    80003612:	05848513          	addi	a0,s1,88
    80003616:	ffffd097          	auipc	ra,0xffffd
    8000361a:	bbe080e7          	jalr	-1090(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    8000361e:	8526                	mv	a0,s1
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	d8a080e7          	jalr	-630(ra) # 800023aa <bwrite>
    brelse(from);
    80003628:	854e                	mv	a0,s3
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	dbe080e7          	jalr	-578(ra) # 800023e8 <brelse>
    brelse(to);
    80003632:	8526                	mv	a0,s1
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	db4080e7          	jalr	-588(ra) # 800023e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363c:	2905                	addiw	s2,s2,1
    8000363e:	0a91                	addi	s5,s5,4
    80003640:	02ca2783          	lw	a5,44(s4)
    80003644:	f8f94ee3          	blt	s2,a5,800035e0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	c6a080e7          	jalr	-918(ra) # 800032b2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003650:	4501                	li	a0,0
    80003652:	00000097          	auipc	ra,0x0
    80003656:	cda080e7          	jalr	-806(ra) # 8000332c <install_trans>
    log.lh.n = 0;
    8000365a:	00015797          	auipc	a5,0x15
    8000365e:	2807a123          	sw	zero,642(a5) # 800188dc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003662:	00000097          	auipc	ra,0x0
    80003666:	c50080e7          	jalr	-944(ra) # 800032b2 <write_head>
    8000366a:	bdf5                	j	80003566 <end_op+0x52>

000000008000366c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000366c:	1101                	addi	sp,sp,-32
    8000366e:	ec06                	sd	ra,24(sp)
    80003670:	e822                	sd	s0,16(sp)
    80003672:	e426                	sd	s1,8(sp)
    80003674:	e04a                	sd	s2,0(sp)
    80003676:	1000                	addi	s0,sp,32
    80003678:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000367a:	00015917          	auipc	s2,0x15
    8000367e:	23690913          	addi	s2,s2,566 # 800188b0 <log>
    80003682:	854a                	mv	a0,s2
    80003684:	00003097          	auipc	ra,0x3
    80003688:	a36080e7          	jalr	-1482(ra) # 800060ba <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000368c:	02c92603          	lw	a2,44(s2)
    80003690:	47f5                	li	a5,29
    80003692:	06c7c563          	blt	a5,a2,800036fc <log_write+0x90>
    80003696:	00015797          	auipc	a5,0x15
    8000369a:	2367a783          	lw	a5,566(a5) # 800188cc <log+0x1c>
    8000369e:	37fd                	addiw	a5,a5,-1
    800036a0:	04f65e63          	bge	a2,a5,800036fc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036a4:	00015797          	auipc	a5,0x15
    800036a8:	22c7a783          	lw	a5,556(a5) # 800188d0 <log+0x20>
    800036ac:	06f05063          	blez	a5,8000370c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036b0:	4781                	li	a5,0
    800036b2:	06c05563          	blez	a2,8000371c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036b6:	44cc                	lw	a1,12(s1)
    800036b8:	00015717          	auipc	a4,0x15
    800036bc:	22870713          	addi	a4,a4,552 # 800188e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036c0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036c2:	4314                	lw	a3,0(a4)
    800036c4:	04b68c63          	beq	a3,a1,8000371c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036c8:	2785                	addiw	a5,a5,1
    800036ca:	0711                	addi	a4,a4,4
    800036cc:	fef61be3          	bne	a2,a5,800036c2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036d0:	0621                	addi	a2,a2,8
    800036d2:	060a                	slli	a2,a2,0x2
    800036d4:	00015797          	auipc	a5,0x15
    800036d8:	1dc78793          	addi	a5,a5,476 # 800188b0 <log>
    800036dc:	963e                	add	a2,a2,a5
    800036de:	44dc                	lw	a5,12(s1)
    800036e0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036e2:	8526                	mv	a0,s1
    800036e4:	fffff097          	auipc	ra,0xfffff
    800036e8:	da2080e7          	jalr	-606(ra) # 80002486 <bpin>
    log.lh.n++;
    800036ec:	00015717          	auipc	a4,0x15
    800036f0:	1c470713          	addi	a4,a4,452 # 800188b0 <log>
    800036f4:	575c                	lw	a5,44(a4)
    800036f6:	2785                	addiw	a5,a5,1
    800036f8:	d75c                	sw	a5,44(a4)
    800036fa:	a835                	j	80003736 <log_write+0xca>
    panic("too big a transaction");
    800036fc:	00005517          	auipc	a0,0x5
    80003700:	ec450513          	addi	a0,a0,-316 # 800085c0 <syscalls+0x1f0>
    80003704:	00002097          	auipc	ra,0x2
    80003708:	47a080e7          	jalr	1146(ra) # 80005b7e <panic>
    panic("log_write outside of trans");
    8000370c:	00005517          	auipc	a0,0x5
    80003710:	ecc50513          	addi	a0,a0,-308 # 800085d8 <syscalls+0x208>
    80003714:	00002097          	auipc	ra,0x2
    80003718:	46a080e7          	jalr	1130(ra) # 80005b7e <panic>
  log.lh.block[i] = b->blockno;
    8000371c:	00878713          	addi	a4,a5,8
    80003720:	00271693          	slli	a3,a4,0x2
    80003724:	00015717          	auipc	a4,0x15
    80003728:	18c70713          	addi	a4,a4,396 # 800188b0 <log>
    8000372c:	9736                	add	a4,a4,a3
    8000372e:	44d4                	lw	a3,12(s1)
    80003730:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003732:	faf608e3          	beq	a2,a5,800036e2 <log_write+0x76>
  }
  release(&log.lock);
    80003736:	00015517          	auipc	a0,0x15
    8000373a:	17a50513          	addi	a0,a0,378 # 800188b0 <log>
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	a30080e7          	jalr	-1488(ra) # 8000616e <release>
}
    80003746:	60e2                	ld	ra,24(sp)
    80003748:	6442                	ld	s0,16(sp)
    8000374a:	64a2                	ld	s1,8(sp)
    8000374c:	6902                	ld	s2,0(sp)
    8000374e:	6105                	addi	sp,sp,32
    80003750:	8082                	ret

0000000080003752 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003752:	1101                	addi	sp,sp,-32
    80003754:	ec06                	sd	ra,24(sp)
    80003756:	e822                	sd	s0,16(sp)
    80003758:	e426                	sd	s1,8(sp)
    8000375a:	e04a                	sd	s2,0(sp)
    8000375c:	1000                	addi	s0,sp,32
    8000375e:	84aa                	mv	s1,a0
    80003760:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003762:	00005597          	auipc	a1,0x5
    80003766:	e9658593          	addi	a1,a1,-362 # 800085f8 <syscalls+0x228>
    8000376a:	0521                	addi	a0,a0,8
    8000376c:	00003097          	auipc	ra,0x3
    80003770:	8be080e7          	jalr	-1858(ra) # 8000602a <initlock>
  lk->name = name;
    80003774:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003778:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000377c:	0204a423          	sw	zero,40(s1)
}
    80003780:	60e2                	ld	ra,24(sp)
    80003782:	6442                	ld	s0,16(sp)
    80003784:	64a2                	ld	s1,8(sp)
    80003786:	6902                	ld	s2,0(sp)
    80003788:	6105                	addi	sp,sp,32
    8000378a:	8082                	ret

000000008000378c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000378c:	1101                	addi	sp,sp,-32
    8000378e:	ec06                	sd	ra,24(sp)
    80003790:	e822                	sd	s0,16(sp)
    80003792:	e426                	sd	s1,8(sp)
    80003794:	e04a                	sd	s2,0(sp)
    80003796:	1000                	addi	s0,sp,32
    80003798:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000379a:	00850913          	addi	s2,a0,8
    8000379e:	854a                	mv	a0,s2
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	91a080e7          	jalr	-1766(ra) # 800060ba <acquire>
  while (lk->locked) {
    800037a8:	409c                	lw	a5,0(s1)
    800037aa:	cb89                	beqz	a5,800037bc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037ac:	85ca                	mv	a1,s2
    800037ae:	8526                	mv	a0,s1
    800037b0:	ffffe097          	auipc	ra,0xffffe
    800037b4:	d4a080e7          	jalr	-694(ra) # 800014fa <sleep>
  while (lk->locked) {
    800037b8:	409c                	lw	a5,0(s1)
    800037ba:	fbed                	bnez	a5,800037ac <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037bc:	4785                	li	a5,1
    800037be:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037c0:	ffffd097          	auipc	ra,0xffffd
    800037c4:	692080e7          	jalr	1682(ra) # 80000e52 <myproc>
    800037c8:	591c                	lw	a5,48(a0)
    800037ca:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037cc:	854a                	mv	a0,s2
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	9a0080e7          	jalr	-1632(ra) # 8000616e <release>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6902                	ld	s2,0(sp)
    800037de:	6105                	addi	sp,sp,32
    800037e0:	8082                	ret

00000000800037e2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037e2:	1101                	addi	sp,sp,-32
    800037e4:	ec06                	sd	ra,24(sp)
    800037e6:	e822                	sd	s0,16(sp)
    800037e8:	e426                	sd	s1,8(sp)
    800037ea:	e04a                	sd	s2,0(sp)
    800037ec:	1000                	addi	s0,sp,32
    800037ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037f0:	00850913          	addi	s2,a0,8
    800037f4:	854a                	mv	a0,s2
    800037f6:	00003097          	auipc	ra,0x3
    800037fa:	8c4080e7          	jalr	-1852(ra) # 800060ba <acquire>
  lk->locked = 0;
    800037fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003802:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003806:	8526                	mv	a0,s1
    80003808:	ffffe097          	auipc	ra,0xffffe
    8000380c:	d56080e7          	jalr	-682(ra) # 8000155e <wakeup>
  release(&lk->lk);
    80003810:	854a                	mv	a0,s2
    80003812:	00003097          	auipc	ra,0x3
    80003816:	95c080e7          	jalr	-1700(ra) # 8000616e <release>
}
    8000381a:	60e2                	ld	ra,24(sp)
    8000381c:	6442                	ld	s0,16(sp)
    8000381e:	64a2                	ld	s1,8(sp)
    80003820:	6902                	ld	s2,0(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003826:	7179                	addi	sp,sp,-48
    80003828:	f406                	sd	ra,40(sp)
    8000382a:	f022                	sd	s0,32(sp)
    8000382c:	ec26                	sd	s1,24(sp)
    8000382e:	e84a                	sd	s2,16(sp)
    80003830:	e44e                	sd	s3,8(sp)
    80003832:	1800                	addi	s0,sp,48
    80003834:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003836:	00850913          	addi	s2,a0,8
    8000383a:	854a                	mv	a0,s2
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	87e080e7          	jalr	-1922(ra) # 800060ba <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003844:	409c                	lw	a5,0(s1)
    80003846:	ef99                	bnez	a5,80003864 <holdingsleep+0x3e>
    80003848:	4481                	li	s1,0
  release(&lk->lk);
    8000384a:	854a                	mv	a0,s2
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	922080e7          	jalr	-1758(ra) # 8000616e <release>
  return r;
}
    80003854:	8526                	mv	a0,s1
    80003856:	70a2                	ld	ra,40(sp)
    80003858:	7402                	ld	s0,32(sp)
    8000385a:	64e2                	ld	s1,24(sp)
    8000385c:	6942                	ld	s2,16(sp)
    8000385e:	69a2                	ld	s3,8(sp)
    80003860:	6145                	addi	sp,sp,48
    80003862:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003864:	0284a983          	lw	s3,40(s1)
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	5ea080e7          	jalr	1514(ra) # 80000e52 <myproc>
    80003870:	5904                	lw	s1,48(a0)
    80003872:	413484b3          	sub	s1,s1,s3
    80003876:	0014b493          	seqz	s1,s1
    8000387a:	bfc1                	j	8000384a <holdingsleep+0x24>

000000008000387c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000387c:	1141                	addi	sp,sp,-16
    8000387e:	e406                	sd	ra,8(sp)
    80003880:	e022                	sd	s0,0(sp)
    80003882:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003884:	00005597          	auipc	a1,0x5
    80003888:	d8458593          	addi	a1,a1,-636 # 80008608 <syscalls+0x238>
    8000388c:	00015517          	auipc	a0,0x15
    80003890:	16c50513          	addi	a0,a0,364 # 800189f8 <ftable>
    80003894:	00002097          	auipc	ra,0x2
    80003898:	796080e7          	jalr	1942(ra) # 8000602a <initlock>
}
    8000389c:	60a2                	ld	ra,8(sp)
    8000389e:	6402                	ld	s0,0(sp)
    800038a0:	0141                	addi	sp,sp,16
    800038a2:	8082                	ret

00000000800038a4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038a4:	1101                	addi	sp,sp,-32
    800038a6:	ec06                	sd	ra,24(sp)
    800038a8:	e822                	sd	s0,16(sp)
    800038aa:	e426                	sd	s1,8(sp)
    800038ac:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038ae:	00015517          	auipc	a0,0x15
    800038b2:	14a50513          	addi	a0,a0,330 # 800189f8 <ftable>
    800038b6:	00003097          	auipc	ra,0x3
    800038ba:	804080e7          	jalr	-2044(ra) # 800060ba <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038be:	00015497          	auipc	s1,0x15
    800038c2:	15248493          	addi	s1,s1,338 # 80018a10 <ftable+0x18>
    800038c6:	00016717          	auipc	a4,0x16
    800038ca:	0ea70713          	addi	a4,a4,234 # 800199b0 <disk>
    if(f->ref == 0){
    800038ce:	40dc                	lw	a5,4(s1)
    800038d0:	cf99                	beqz	a5,800038ee <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038d2:	02848493          	addi	s1,s1,40
    800038d6:	fee49ce3          	bne	s1,a4,800038ce <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038da:	00015517          	auipc	a0,0x15
    800038de:	11e50513          	addi	a0,a0,286 # 800189f8 <ftable>
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	88c080e7          	jalr	-1908(ra) # 8000616e <release>
  return 0;
    800038ea:	4481                	li	s1,0
    800038ec:	a819                	j	80003902 <filealloc+0x5e>
      f->ref = 1;
    800038ee:	4785                	li	a5,1
    800038f0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038f2:	00015517          	auipc	a0,0x15
    800038f6:	10650513          	addi	a0,a0,262 # 800189f8 <ftable>
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	874080e7          	jalr	-1932(ra) # 8000616e <release>
}
    80003902:	8526                	mv	a0,s1
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6105                	addi	sp,sp,32
    8000390c:	8082                	ret

000000008000390e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000390e:	1101                	addi	sp,sp,-32
    80003910:	ec06                	sd	ra,24(sp)
    80003912:	e822                	sd	s0,16(sp)
    80003914:	e426                	sd	s1,8(sp)
    80003916:	1000                	addi	s0,sp,32
    80003918:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000391a:	00015517          	auipc	a0,0x15
    8000391e:	0de50513          	addi	a0,a0,222 # 800189f8 <ftable>
    80003922:	00002097          	auipc	ra,0x2
    80003926:	798080e7          	jalr	1944(ra) # 800060ba <acquire>
  if(f->ref < 1)
    8000392a:	40dc                	lw	a5,4(s1)
    8000392c:	02f05263          	blez	a5,80003950 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003930:	2785                	addiw	a5,a5,1
    80003932:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003934:	00015517          	auipc	a0,0x15
    80003938:	0c450513          	addi	a0,a0,196 # 800189f8 <ftable>
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	832080e7          	jalr	-1998(ra) # 8000616e <release>
  return f;
}
    80003944:	8526                	mv	a0,s1
    80003946:	60e2                	ld	ra,24(sp)
    80003948:	6442                	ld	s0,16(sp)
    8000394a:	64a2                	ld	s1,8(sp)
    8000394c:	6105                	addi	sp,sp,32
    8000394e:	8082                	ret
    panic("filedup");
    80003950:	00005517          	auipc	a0,0x5
    80003954:	cc050513          	addi	a0,a0,-832 # 80008610 <syscalls+0x240>
    80003958:	00002097          	auipc	ra,0x2
    8000395c:	226080e7          	jalr	550(ra) # 80005b7e <panic>

0000000080003960 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003960:	7139                	addi	sp,sp,-64
    80003962:	fc06                	sd	ra,56(sp)
    80003964:	f822                	sd	s0,48(sp)
    80003966:	f426                	sd	s1,40(sp)
    80003968:	f04a                	sd	s2,32(sp)
    8000396a:	ec4e                	sd	s3,24(sp)
    8000396c:	e852                	sd	s4,16(sp)
    8000396e:	e456                	sd	s5,8(sp)
    80003970:	0080                	addi	s0,sp,64
    80003972:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003974:	00015517          	auipc	a0,0x15
    80003978:	08450513          	addi	a0,a0,132 # 800189f8 <ftable>
    8000397c:	00002097          	auipc	ra,0x2
    80003980:	73e080e7          	jalr	1854(ra) # 800060ba <acquire>
  if(f->ref < 1)
    80003984:	40dc                	lw	a5,4(s1)
    80003986:	06f05163          	blez	a5,800039e8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000398a:	37fd                	addiw	a5,a5,-1
    8000398c:	0007871b          	sext.w	a4,a5
    80003990:	c0dc                	sw	a5,4(s1)
    80003992:	06e04363          	bgtz	a4,800039f8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003996:	0004a903          	lw	s2,0(s1)
    8000399a:	0094ca83          	lbu	s5,9(s1)
    8000399e:	0104ba03          	ld	s4,16(s1)
    800039a2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039a6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039aa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039ae:	00015517          	auipc	a0,0x15
    800039b2:	04a50513          	addi	a0,a0,74 # 800189f8 <ftable>
    800039b6:	00002097          	auipc	ra,0x2
    800039ba:	7b8080e7          	jalr	1976(ra) # 8000616e <release>

  if(ff.type == FD_PIPE){
    800039be:	4785                	li	a5,1
    800039c0:	04f90d63          	beq	s2,a5,80003a1a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039c4:	3979                	addiw	s2,s2,-2
    800039c6:	4785                	li	a5,1
    800039c8:	0527e063          	bltu	a5,s2,80003a08 <fileclose+0xa8>
    begin_op();
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	ac8080e7          	jalr	-1336(ra) # 80003494 <begin_op>
    iput(ff.ip);
    800039d4:	854e                	mv	a0,s3
    800039d6:	fffff097          	auipc	ra,0xfffff
    800039da:	2b6080e7          	jalr	694(ra) # 80002c8c <iput>
    end_op();
    800039de:	00000097          	auipc	ra,0x0
    800039e2:	b36080e7          	jalr	-1226(ra) # 80003514 <end_op>
    800039e6:	a00d                	j	80003a08 <fileclose+0xa8>
    panic("fileclose");
    800039e8:	00005517          	auipc	a0,0x5
    800039ec:	c3050513          	addi	a0,a0,-976 # 80008618 <syscalls+0x248>
    800039f0:	00002097          	auipc	ra,0x2
    800039f4:	18e080e7          	jalr	398(ra) # 80005b7e <panic>
    release(&ftable.lock);
    800039f8:	00015517          	auipc	a0,0x15
    800039fc:	00050513          	mv	a0,a0
    80003a00:	00002097          	auipc	ra,0x2
    80003a04:	76e080e7          	jalr	1902(ra) # 8000616e <release>
  }
}
    80003a08:	70e2                	ld	ra,56(sp)
    80003a0a:	7442                	ld	s0,48(sp)
    80003a0c:	74a2                	ld	s1,40(sp)
    80003a0e:	7902                	ld	s2,32(sp)
    80003a10:	69e2                	ld	s3,24(sp)
    80003a12:	6a42                	ld	s4,16(sp)
    80003a14:	6aa2                	ld	s5,8(sp)
    80003a16:	6121                	addi	sp,sp,64
    80003a18:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a1a:	85d6                	mv	a1,s5
    80003a1c:	8552                	mv	a0,s4
    80003a1e:	00000097          	auipc	ra,0x0
    80003a22:	34c080e7          	jalr	844(ra) # 80003d6a <pipeclose>
    80003a26:	b7cd                	j	80003a08 <fileclose+0xa8>

0000000080003a28 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a28:	715d                	addi	sp,sp,-80
    80003a2a:	e486                	sd	ra,72(sp)
    80003a2c:	e0a2                	sd	s0,64(sp)
    80003a2e:	fc26                	sd	s1,56(sp)
    80003a30:	f84a                	sd	s2,48(sp)
    80003a32:	f44e                	sd	s3,40(sp)
    80003a34:	0880                	addi	s0,sp,80
    80003a36:	84aa                	mv	s1,a0
    80003a38:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a3a:	ffffd097          	auipc	ra,0xffffd
    80003a3e:	418080e7          	jalr	1048(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a42:	409c                	lw	a5,0(s1)
    80003a44:	37f9                	addiw	a5,a5,-2
    80003a46:	4705                	li	a4,1
    80003a48:	04f76763          	bltu	a4,a5,80003a96 <filestat+0x6e>
    80003a4c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a4e:	6c88                	ld	a0,24(s1)
    80003a50:	fffff097          	auipc	ra,0xfffff
    80003a54:	082080e7          	jalr	130(ra) # 80002ad2 <ilock>
    stati(f->ip, &st);
    80003a58:	fb840593          	addi	a1,s0,-72
    80003a5c:	6c88                	ld	a0,24(s1)
    80003a5e:	fffff097          	auipc	ra,0xfffff
    80003a62:	2fe080e7          	jalr	766(ra) # 80002d5c <stati>
    iunlock(f->ip);
    80003a66:	6c88                	ld	a0,24(s1)
    80003a68:	fffff097          	auipc	ra,0xfffff
    80003a6c:	12c080e7          	jalr	300(ra) # 80002b94 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a70:	46e1                	li	a3,24
    80003a72:	fb840613          	addi	a2,s0,-72
    80003a76:	85ce                	mv	a1,s3
    80003a78:	05093503          	ld	a0,80(s2)
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	092080e7          	jalr	146(ra) # 80000b0e <copyout>
    80003a84:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a88:	60a6                	ld	ra,72(sp)
    80003a8a:	6406                	ld	s0,64(sp)
    80003a8c:	74e2                	ld	s1,56(sp)
    80003a8e:	7942                	ld	s2,48(sp)
    80003a90:	79a2                	ld	s3,40(sp)
    80003a92:	6161                	addi	sp,sp,80
    80003a94:	8082                	ret
  return -1;
    80003a96:	557d                	li	a0,-1
    80003a98:	bfc5                	j	80003a88 <filestat+0x60>

0000000080003a9a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a9a:	7179                	addi	sp,sp,-48
    80003a9c:	f406                	sd	ra,40(sp)
    80003a9e:	f022                	sd	s0,32(sp)
    80003aa0:	ec26                	sd	s1,24(sp)
    80003aa2:	e84a                	sd	s2,16(sp)
    80003aa4:	e44e                	sd	s3,8(sp)
    80003aa6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003aa8:	00854783          	lbu	a5,8(a0) # 80018a00 <ftable+0x8>
    80003aac:	c3d5                	beqz	a5,80003b50 <fileread+0xb6>
    80003aae:	84aa                	mv	s1,a0
    80003ab0:	89ae                	mv	s3,a1
    80003ab2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ab4:	411c                	lw	a5,0(a0)
    80003ab6:	4705                	li	a4,1
    80003ab8:	04e78963          	beq	a5,a4,80003b0a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003abc:	470d                	li	a4,3
    80003abe:	04e78d63          	beq	a5,a4,80003b18 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ac2:	4709                	li	a4,2
    80003ac4:	06e79e63          	bne	a5,a4,80003b40 <fileread+0xa6>
    ilock(f->ip);
    80003ac8:	6d08                	ld	a0,24(a0)
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	008080e7          	jalr	8(ra) # 80002ad2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ad2:	874a                	mv	a4,s2
    80003ad4:	5094                	lw	a3,32(s1)
    80003ad6:	864e                	mv	a2,s3
    80003ad8:	4585                	li	a1,1
    80003ada:	6c88                	ld	a0,24(s1)
    80003adc:	fffff097          	auipc	ra,0xfffff
    80003ae0:	2aa080e7          	jalr	682(ra) # 80002d86 <readi>
    80003ae4:	892a                	mv	s2,a0
    80003ae6:	00a05563          	blez	a0,80003af0 <fileread+0x56>
      f->off += r;
    80003aea:	509c                	lw	a5,32(s1)
    80003aec:	9fa9                	addw	a5,a5,a0
    80003aee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003af0:	6c88                	ld	a0,24(s1)
    80003af2:	fffff097          	auipc	ra,0xfffff
    80003af6:	0a2080e7          	jalr	162(ra) # 80002b94 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003afa:	854a                	mv	a0,s2
    80003afc:	70a2                	ld	ra,40(sp)
    80003afe:	7402                	ld	s0,32(sp)
    80003b00:	64e2                	ld	s1,24(sp)
    80003b02:	6942                	ld	s2,16(sp)
    80003b04:	69a2                	ld	s3,8(sp)
    80003b06:	6145                	addi	sp,sp,48
    80003b08:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b0a:	6908                	ld	a0,16(a0)
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	3c6080e7          	jalr	966(ra) # 80003ed2 <piperead>
    80003b14:	892a                	mv	s2,a0
    80003b16:	b7d5                	j	80003afa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b18:	02451783          	lh	a5,36(a0)
    80003b1c:	03079693          	slli	a3,a5,0x30
    80003b20:	92c1                	srli	a3,a3,0x30
    80003b22:	4725                	li	a4,9
    80003b24:	02d76863          	bltu	a4,a3,80003b54 <fileread+0xba>
    80003b28:	0792                	slli	a5,a5,0x4
    80003b2a:	00015717          	auipc	a4,0x15
    80003b2e:	e2e70713          	addi	a4,a4,-466 # 80018958 <devsw>
    80003b32:	97ba                	add	a5,a5,a4
    80003b34:	639c                	ld	a5,0(a5)
    80003b36:	c38d                	beqz	a5,80003b58 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b38:	4505                	li	a0,1
    80003b3a:	9782                	jalr	a5
    80003b3c:	892a                	mv	s2,a0
    80003b3e:	bf75                	j	80003afa <fileread+0x60>
    panic("fileread");
    80003b40:	00005517          	auipc	a0,0x5
    80003b44:	ae850513          	addi	a0,a0,-1304 # 80008628 <syscalls+0x258>
    80003b48:	00002097          	auipc	ra,0x2
    80003b4c:	036080e7          	jalr	54(ra) # 80005b7e <panic>
    return -1;
    80003b50:	597d                	li	s2,-1
    80003b52:	b765                	j	80003afa <fileread+0x60>
      return -1;
    80003b54:	597d                	li	s2,-1
    80003b56:	b755                	j	80003afa <fileread+0x60>
    80003b58:	597d                	li	s2,-1
    80003b5a:	b745                	j	80003afa <fileread+0x60>

0000000080003b5c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b5c:	715d                	addi	sp,sp,-80
    80003b5e:	e486                	sd	ra,72(sp)
    80003b60:	e0a2                	sd	s0,64(sp)
    80003b62:	fc26                	sd	s1,56(sp)
    80003b64:	f84a                	sd	s2,48(sp)
    80003b66:	f44e                	sd	s3,40(sp)
    80003b68:	f052                	sd	s4,32(sp)
    80003b6a:	ec56                	sd	s5,24(sp)
    80003b6c:	e85a                	sd	s6,16(sp)
    80003b6e:	e45e                	sd	s7,8(sp)
    80003b70:	e062                	sd	s8,0(sp)
    80003b72:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b74:	00954783          	lbu	a5,9(a0)
    80003b78:	10078663          	beqz	a5,80003c84 <filewrite+0x128>
    80003b7c:	892a                	mv	s2,a0
    80003b7e:	8aae                	mv	s5,a1
    80003b80:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b82:	411c                	lw	a5,0(a0)
    80003b84:	4705                	li	a4,1
    80003b86:	02e78263          	beq	a5,a4,80003baa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b8a:	470d                	li	a4,3
    80003b8c:	02e78663          	beq	a5,a4,80003bb8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b90:	4709                	li	a4,2
    80003b92:	0ee79163          	bne	a5,a4,80003c74 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b96:	0ac05d63          	blez	a2,80003c50 <filewrite+0xf4>
    int i = 0;
    80003b9a:	4981                	li	s3,0
    80003b9c:	6b05                	lui	s6,0x1
    80003b9e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ba2:	6b85                	lui	s7,0x1
    80003ba4:	c00b8b9b          	addiw	s7,s7,-1024
    80003ba8:	a861                	j	80003c40 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003baa:	6908                	ld	a0,16(a0)
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	22e080e7          	jalr	558(ra) # 80003dda <pipewrite>
    80003bb4:	8a2a                	mv	s4,a0
    80003bb6:	a045                	j	80003c56 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bb8:	02451783          	lh	a5,36(a0)
    80003bbc:	03079693          	slli	a3,a5,0x30
    80003bc0:	92c1                	srli	a3,a3,0x30
    80003bc2:	4725                	li	a4,9
    80003bc4:	0cd76263          	bltu	a4,a3,80003c88 <filewrite+0x12c>
    80003bc8:	0792                	slli	a5,a5,0x4
    80003bca:	00015717          	auipc	a4,0x15
    80003bce:	d8e70713          	addi	a4,a4,-626 # 80018958 <devsw>
    80003bd2:	97ba                	add	a5,a5,a4
    80003bd4:	679c                	ld	a5,8(a5)
    80003bd6:	cbdd                	beqz	a5,80003c8c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003bd8:	4505                	li	a0,1
    80003bda:	9782                	jalr	a5
    80003bdc:	8a2a                	mv	s4,a0
    80003bde:	a8a5                	j	80003c56 <filewrite+0xfa>
    80003be0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	8b0080e7          	jalr	-1872(ra) # 80003494 <begin_op>
      ilock(f->ip);
    80003bec:	01893503          	ld	a0,24(s2)
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	ee2080e7          	jalr	-286(ra) # 80002ad2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003bf8:	8762                	mv	a4,s8
    80003bfa:	02092683          	lw	a3,32(s2)
    80003bfe:	01598633          	add	a2,s3,s5
    80003c02:	4585                	li	a1,1
    80003c04:	01893503          	ld	a0,24(s2)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	276080e7          	jalr	630(ra) # 80002e7e <writei>
    80003c10:	84aa                	mv	s1,a0
    80003c12:	00a05763          	blez	a0,80003c20 <filewrite+0xc4>
        f->off += r;
    80003c16:	02092783          	lw	a5,32(s2)
    80003c1a:	9fa9                	addw	a5,a5,a0
    80003c1c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c20:	01893503          	ld	a0,24(s2)
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	f70080e7          	jalr	-144(ra) # 80002b94 <iunlock>
      end_op();
    80003c2c:	00000097          	auipc	ra,0x0
    80003c30:	8e8080e7          	jalr	-1816(ra) # 80003514 <end_op>

      if(r != n1){
    80003c34:	009c1f63          	bne	s8,s1,80003c52 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c38:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c3c:	0149db63          	bge	s3,s4,80003c52 <filewrite+0xf6>
      int n1 = n - i;
    80003c40:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003c44:	84be                	mv	s1,a5
    80003c46:	2781                	sext.w	a5,a5
    80003c48:	f8fb5ce3          	bge	s6,a5,80003be0 <filewrite+0x84>
    80003c4c:	84de                	mv	s1,s7
    80003c4e:	bf49                	j	80003be0 <filewrite+0x84>
    int i = 0;
    80003c50:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c52:	013a1f63          	bne	s4,s3,80003c70 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c56:	8552                	mv	a0,s4
    80003c58:	60a6                	ld	ra,72(sp)
    80003c5a:	6406                	ld	s0,64(sp)
    80003c5c:	74e2                	ld	s1,56(sp)
    80003c5e:	7942                	ld	s2,48(sp)
    80003c60:	79a2                	ld	s3,40(sp)
    80003c62:	7a02                	ld	s4,32(sp)
    80003c64:	6ae2                	ld	s5,24(sp)
    80003c66:	6b42                	ld	s6,16(sp)
    80003c68:	6ba2                	ld	s7,8(sp)
    80003c6a:	6c02                	ld	s8,0(sp)
    80003c6c:	6161                	addi	sp,sp,80
    80003c6e:	8082                	ret
    ret = (i == n ? n : -1);
    80003c70:	5a7d                	li	s4,-1
    80003c72:	b7d5                	j	80003c56 <filewrite+0xfa>
    panic("filewrite");
    80003c74:	00005517          	auipc	a0,0x5
    80003c78:	9c450513          	addi	a0,a0,-1596 # 80008638 <syscalls+0x268>
    80003c7c:	00002097          	auipc	ra,0x2
    80003c80:	f02080e7          	jalr	-254(ra) # 80005b7e <panic>
    return -1;
    80003c84:	5a7d                	li	s4,-1
    80003c86:	bfc1                	j	80003c56 <filewrite+0xfa>
      return -1;
    80003c88:	5a7d                	li	s4,-1
    80003c8a:	b7f1                	j	80003c56 <filewrite+0xfa>
    80003c8c:	5a7d                	li	s4,-1
    80003c8e:	b7e1                	j	80003c56 <filewrite+0xfa>

0000000080003c90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c90:	7179                	addi	sp,sp,-48
    80003c92:	f406                	sd	ra,40(sp)
    80003c94:	f022                	sd	s0,32(sp)
    80003c96:	ec26                	sd	s1,24(sp)
    80003c98:	e84a                	sd	s2,16(sp)
    80003c9a:	e44e                	sd	s3,8(sp)
    80003c9c:	e052                	sd	s4,0(sp)
    80003c9e:	1800                	addi	s0,sp,48
    80003ca0:	84aa                	mv	s1,a0
    80003ca2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ca4:	0005b023          	sd	zero,0(a1)
    80003ca8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	bf8080e7          	jalr	-1032(ra) # 800038a4 <filealloc>
    80003cb4:	e088                	sd	a0,0(s1)
    80003cb6:	c551                	beqz	a0,80003d42 <pipealloc+0xb2>
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	bec080e7          	jalr	-1044(ra) # 800038a4 <filealloc>
    80003cc0:	00aa3023          	sd	a0,0(s4)
    80003cc4:	c92d                	beqz	a0,80003d36 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cc6:	ffffc097          	auipc	ra,0xffffc
    80003cca:	452080e7          	jalr	1106(ra) # 80000118 <kalloc>
    80003cce:	892a                	mv	s2,a0
    80003cd0:	c125                	beqz	a0,80003d30 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cd2:	4985                	li	s3,1
    80003cd4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cd8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cdc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ce0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ce4:	00005597          	auipc	a1,0x5
    80003ce8:	96458593          	addi	a1,a1,-1692 # 80008648 <syscalls+0x278>
    80003cec:	00002097          	auipc	ra,0x2
    80003cf0:	33e080e7          	jalr	830(ra) # 8000602a <initlock>
  (*f0)->type = FD_PIPE;
    80003cf4:	609c                	ld	a5,0(s1)
    80003cf6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003cfa:	609c                	ld	a5,0(s1)
    80003cfc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d00:	609c                	ld	a5,0(s1)
    80003d02:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d06:	609c                	ld	a5,0(s1)
    80003d08:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d0c:	000a3783          	ld	a5,0(s4)
    80003d10:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d14:	000a3783          	ld	a5,0(s4)
    80003d18:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d1c:	000a3783          	ld	a5,0(s4)
    80003d20:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d24:	000a3783          	ld	a5,0(s4)
    80003d28:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d2c:	4501                	li	a0,0
    80003d2e:	a025                	j	80003d56 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d30:	6088                	ld	a0,0(s1)
    80003d32:	e501                	bnez	a0,80003d3a <pipealloc+0xaa>
    80003d34:	a039                	j	80003d42 <pipealloc+0xb2>
    80003d36:	6088                	ld	a0,0(s1)
    80003d38:	c51d                	beqz	a0,80003d66 <pipealloc+0xd6>
    fileclose(*f0);
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	c26080e7          	jalr	-986(ra) # 80003960 <fileclose>
  if(*f1)
    80003d42:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d46:	557d                	li	a0,-1
  if(*f1)
    80003d48:	c799                	beqz	a5,80003d56 <pipealloc+0xc6>
    fileclose(*f1);
    80003d4a:	853e                	mv	a0,a5
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	c14080e7          	jalr	-1004(ra) # 80003960 <fileclose>
  return -1;
    80003d54:	557d                	li	a0,-1
}
    80003d56:	70a2                	ld	ra,40(sp)
    80003d58:	7402                	ld	s0,32(sp)
    80003d5a:	64e2                	ld	s1,24(sp)
    80003d5c:	6942                	ld	s2,16(sp)
    80003d5e:	69a2                	ld	s3,8(sp)
    80003d60:	6a02                	ld	s4,0(sp)
    80003d62:	6145                	addi	sp,sp,48
    80003d64:	8082                	ret
  return -1;
    80003d66:	557d                	li	a0,-1
    80003d68:	b7fd                	j	80003d56 <pipealloc+0xc6>

0000000080003d6a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d6a:	1101                	addi	sp,sp,-32
    80003d6c:	ec06                	sd	ra,24(sp)
    80003d6e:	e822                	sd	s0,16(sp)
    80003d70:	e426                	sd	s1,8(sp)
    80003d72:	e04a                	sd	s2,0(sp)
    80003d74:	1000                	addi	s0,sp,32
    80003d76:	84aa                	mv	s1,a0
    80003d78:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d7a:	00002097          	auipc	ra,0x2
    80003d7e:	340080e7          	jalr	832(ra) # 800060ba <acquire>
  if(writable){
    80003d82:	02090d63          	beqz	s2,80003dbc <pipeclose+0x52>
    pi->writeopen = 0;
    80003d86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d8a:	21848513          	addi	a0,s1,536
    80003d8e:	ffffd097          	auipc	ra,0xffffd
    80003d92:	7d0080e7          	jalr	2000(ra) # 8000155e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d96:	2204b783          	ld	a5,544(s1)
    80003d9a:	eb95                	bnez	a5,80003dce <pipeclose+0x64>
    release(&pi->lock);
    80003d9c:	8526                	mv	a0,s1
    80003d9e:	00002097          	auipc	ra,0x2
    80003da2:	3d0080e7          	jalr	976(ra) # 8000616e <release>
    kfree((char*)pi);
    80003da6:	8526                	mv	a0,s1
    80003da8:	ffffc097          	auipc	ra,0xffffc
    80003dac:	274080e7          	jalr	628(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003db0:	60e2                	ld	ra,24(sp)
    80003db2:	6442                	ld	s0,16(sp)
    80003db4:	64a2                	ld	s1,8(sp)
    80003db6:	6902                	ld	s2,0(sp)
    80003db8:	6105                	addi	sp,sp,32
    80003dba:	8082                	ret
    pi->readopen = 0;
    80003dbc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dc0:	21c48513          	addi	a0,s1,540
    80003dc4:	ffffd097          	auipc	ra,0xffffd
    80003dc8:	79a080e7          	jalr	1946(ra) # 8000155e <wakeup>
    80003dcc:	b7e9                	j	80003d96 <pipeclose+0x2c>
    release(&pi->lock);
    80003dce:	8526                	mv	a0,s1
    80003dd0:	00002097          	auipc	ra,0x2
    80003dd4:	39e080e7          	jalr	926(ra) # 8000616e <release>
}
    80003dd8:	bfe1                	j	80003db0 <pipeclose+0x46>

0000000080003dda <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dda:	711d                	addi	sp,sp,-96
    80003ddc:	ec86                	sd	ra,88(sp)
    80003dde:	e8a2                	sd	s0,80(sp)
    80003de0:	e4a6                	sd	s1,72(sp)
    80003de2:	e0ca                	sd	s2,64(sp)
    80003de4:	fc4e                	sd	s3,56(sp)
    80003de6:	f852                	sd	s4,48(sp)
    80003de8:	f456                	sd	s5,40(sp)
    80003dea:	f05a                	sd	s6,32(sp)
    80003dec:	ec5e                	sd	s7,24(sp)
    80003dee:	e862                	sd	s8,16(sp)
    80003df0:	1080                	addi	s0,sp,96
    80003df2:	84aa                	mv	s1,a0
    80003df4:	8aae                	mv	s5,a1
    80003df6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003df8:	ffffd097          	auipc	ra,0xffffd
    80003dfc:	05a080e7          	jalr	90(ra) # 80000e52 <myproc>
    80003e00:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e02:	8526                	mv	a0,s1
    80003e04:	00002097          	auipc	ra,0x2
    80003e08:	2b6080e7          	jalr	694(ra) # 800060ba <acquire>
  while(i < n){
    80003e0c:	0b405663          	blez	s4,80003eb8 <pipewrite+0xde>
  int i = 0;
    80003e10:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e12:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e14:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e18:	21c48b93          	addi	s7,s1,540
    80003e1c:	a089                	j	80003e5e <pipewrite+0x84>
      release(&pi->lock);
    80003e1e:	8526                	mv	a0,s1
    80003e20:	00002097          	auipc	ra,0x2
    80003e24:	34e080e7          	jalr	846(ra) # 8000616e <release>
      return -1;
    80003e28:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e2a:	854a                	mv	a0,s2
    80003e2c:	60e6                	ld	ra,88(sp)
    80003e2e:	6446                	ld	s0,80(sp)
    80003e30:	64a6                	ld	s1,72(sp)
    80003e32:	6906                	ld	s2,64(sp)
    80003e34:	79e2                	ld	s3,56(sp)
    80003e36:	7a42                	ld	s4,48(sp)
    80003e38:	7aa2                	ld	s5,40(sp)
    80003e3a:	7b02                	ld	s6,32(sp)
    80003e3c:	6be2                	ld	s7,24(sp)
    80003e3e:	6c42                	ld	s8,16(sp)
    80003e40:	6125                	addi	sp,sp,96
    80003e42:	8082                	ret
      wakeup(&pi->nread);
    80003e44:	8562                	mv	a0,s8
    80003e46:	ffffd097          	auipc	ra,0xffffd
    80003e4a:	718080e7          	jalr	1816(ra) # 8000155e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e4e:	85a6                	mv	a1,s1
    80003e50:	855e                	mv	a0,s7
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	6a8080e7          	jalr	1704(ra) # 800014fa <sleep>
  while(i < n){
    80003e5a:	07495063          	bge	s2,s4,80003eba <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e5e:	2204a783          	lw	a5,544(s1)
    80003e62:	dfd5                	beqz	a5,80003e1e <pipewrite+0x44>
    80003e64:	854e                	mv	a0,s3
    80003e66:	ffffe097          	auipc	ra,0xffffe
    80003e6a:	93c080e7          	jalr	-1732(ra) # 800017a2 <killed>
    80003e6e:	f945                	bnez	a0,80003e1e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e70:	2184a783          	lw	a5,536(s1)
    80003e74:	21c4a703          	lw	a4,540(s1)
    80003e78:	2007879b          	addiw	a5,a5,512
    80003e7c:	fcf704e3          	beq	a4,a5,80003e44 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e80:	4685                	li	a3,1
    80003e82:	01590633          	add	a2,s2,s5
    80003e86:	faf40593          	addi	a1,s0,-81
    80003e8a:	0509b503          	ld	a0,80(s3)
    80003e8e:	ffffd097          	auipc	ra,0xffffd
    80003e92:	d0c080e7          	jalr	-756(ra) # 80000b9a <copyin>
    80003e96:	03650263          	beq	a0,s6,80003eba <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e9a:	21c4a783          	lw	a5,540(s1)
    80003e9e:	0017871b          	addiw	a4,a5,1
    80003ea2:	20e4ae23          	sw	a4,540(s1)
    80003ea6:	1ff7f793          	andi	a5,a5,511
    80003eaa:	97a6                	add	a5,a5,s1
    80003eac:	faf44703          	lbu	a4,-81(s0)
    80003eb0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003eb4:	2905                	addiw	s2,s2,1
    80003eb6:	b755                	j	80003e5a <pipewrite+0x80>
  int i = 0;
    80003eb8:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003eba:	21848513          	addi	a0,s1,536
    80003ebe:	ffffd097          	auipc	ra,0xffffd
    80003ec2:	6a0080e7          	jalr	1696(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	00002097          	auipc	ra,0x2
    80003ecc:	2a6080e7          	jalr	678(ra) # 8000616e <release>
  return i;
    80003ed0:	bfa9                	j	80003e2a <pipewrite+0x50>

0000000080003ed2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ed2:	715d                	addi	sp,sp,-80
    80003ed4:	e486                	sd	ra,72(sp)
    80003ed6:	e0a2                	sd	s0,64(sp)
    80003ed8:	fc26                	sd	s1,56(sp)
    80003eda:	f84a                	sd	s2,48(sp)
    80003edc:	f44e                	sd	s3,40(sp)
    80003ede:	f052                	sd	s4,32(sp)
    80003ee0:	ec56                	sd	s5,24(sp)
    80003ee2:	e85a                	sd	s6,16(sp)
    80003ee4:	0880                	addi	s0,sp,80
    80003ee6:	84aa                	mv	s1,a0
    80003ee8:	892e                	mv	s2,a1
    80003eea:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003eec:	ffffd097          	auipc	ra,0xffffd
    80003ef0:	f66080e7          	jalr	-154(ra) # 80000e52 <myproc>
    80003ef4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ef6:	8526                	mv	a0,s1
    80003ef8:	00002097          	auipc	ra,0x2
    80003efc:	1c2080e7          	jalr	450(ra) # 800060ba <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f00:	2184a703          	lw	a4,536(s1)
    80003f04:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f08:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f0c:	02f71763          	bne	a4,a5,80003f3a <piperead+0x68>
    80003f10:	2244a783          	lw	a5,548(s1)
    80003f14:	c39d                	beqz	a5,80003f3a <piperead+0x68>
    if(killed(pr)){
    80003f16:	8552                	mv	a0,s4
    80003f18:	ffffe097          	auipc	ra,0xffffe
    80003f1c:	88a080e7          	jalr	-1910(ra) # 800017a2 <killed>
    80003f20:	e941                	bnez	a0,80003fb0 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f22:	85a6                	mv	a1,s1
    80003f24:	854e                	mv	a0,s3
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	5d4080e7          	jalr	1492(ra) # 800014fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f2e:	2184a703          	lw	a4,536(s1)
    80003f32:	21c4a783          	lw	a5,540(s1)
    80003f36:	fcf70de3          	beq	a4,a5,80003f10 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f3a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f3c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f3e:	05505363          	blez	s5,80003f84 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003f42:	2184a783          	lw	a5,536(s1)
    80003f46:	21c4a703          	lw	a4,540(s1)
    80003f4a:	02f70d63          	beq	a4,a5,80003f84 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f4e:	0017871b          	addiw	a4,a5,1
    80003f52:	20e4ac23          	sw	a4,536(s1)
    80003f56:	1ff7f793          	andi	a5,a5,511
    80003f5a:	97a6                	add	a5,a5,s1
    80003f5c:	0187c783          	lbu	a5,24(a5)
    80003f60:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f64:	4685                	li	a3,1
    80003f66:	fbf40613          	addi	a2,s0,-65
    80003f6a:	85ca                	mv	a1,s2
    80003f6c:	050a3503          	ld	a0,80(s4)
    80003f70:	ffffd097          	auipc	ra,0xffffd
    80003f74:	b9e080e7          	jalr	-1122(ra) # 80000b0e <copyout>
    80003f78:	01650663          	beq	a0,s6,80003f84 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f7c:	2985                	addiw	s3,s3,1
    80003f7e:	0905                	addi	s2,s2,1
    80003f80:	fd3a91e3          	bne	s5,s3,80003f42 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f84:	21c48513          	addi	a0,s1,540
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	5d6080e7          	jalr	1494(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	1dc080e7          	jalr	476(ra) # 8000616e <release>
  return i;
}
    80003f9a:	854e                	mv	a0,s3
    80003f9c:	60a6                	ld	ra,72(sp)
    80003f9e:	6406                	ld	s0,64(sp)
    80003fa0:	74e2                	ld	s1,56(sp)
    80003fa2:	7942                	ld	s2,48(sp)
    80003fa4:	79a2                	ld	s3,40(sp)
    80003fa6:	7a02                	ld	s4,32(sp)
    80003fa8:	6ae2                	ld	s5,24(sp)
    80003faa:	6b42                	ld	s6,16(sp)
    80003fac:	6161                	addi	sp,sp,80
    80003fae:	8082                	ret
      release(&pi->lock);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	00002097          	auipc	ra,0x2
    80003fb6:	1bc080e7          	jalr	444(ra) # 8000616e <release>
      return -1;
    80003fba:	59fd                	li	s3,-1
    80003fbc:	bff9                	j	80003f9a <piperead+0xc8>

0000000080003fbe <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fbe:	1141                	addi	sp,sp,-16
    80003fc0:	e422                	sd	s0,8(sp)
    80003fc2:	0800                	addi	s0,sp,16
    80003fc4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fc6:	8905                	andi	a0,a0,1
    80003fc8:	c111                	beqz	a0,80003fcc <flags2perm+0xe>
      perm = PTE_X;
    80003fca:	4521                	li	a0,8
    if(flags & 0x2)
    80003fcc:	8b89                	andi	a5,a5,2
    80003fce:	c399                	beqz	a5,80003fd4 <flags2perm+0x16>
      perm |= PTE_W;
    80003fd0:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fd4:	6422                	ld	s0,8(sp)
    80003fd6:	0141                	addi	sp,sp,16
    80003fd8:	8082                	ret

0000000080003fda <exec>:

int
exec(char *path, char **argv)
{
    80003fda:	de010113          	addi	sp,sp,-544
    80003fde:	20113c23          	sd	ra,536(sp)
    80003fe2:	20813823          	sd	s0,528(sp)
    80003fe6:	20913423          	sd	s1,520(sp)
    80003fea:	21213023          	sd	s2,512(sp)
    80003fee:	ffce                	sd	s3,504(sp)
    80003ff0:	fbd2                	sd	s4,496(sp)
    80003ff2:	f7d6                	sd	s5,488(sp)
    80003ff4:	f3da                	sd	s6,480(sp)
    80003ff6:	efde                	sd	s7,472(sp)
    80003ff8:	ebe2                	sd	s8,464(sp)
    80003ffa:	e7e6                	sd	s9,456(sp)
    80003ffc:	e3ea                	sd	s10,448(sp)
    80003ffe:	ff6e                	sd	s11,440(sp)
    80004000:	1400                	addi	s0,sp,544
    80004002:	892a                	mv	s2,a0
    80004004:	dea43423          	sd	a0,-536(s0)
    80004008:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	e46080e7          	jalr	-442(ra) # 80000e52 <myproc>
    80004014:	84aa                	mv	s1,a0

  begin_op();
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	47e080e7          	jalr	1150(ra) # 80003494 <begin_op>

  if((ip = namei(path)) == 0){
    8000401e:	854a                	mv	a0,s2
    80004020:	fffff097          	auipc	ra,0xfffff
    80004024:	258080e7          	jalr	600(ra) # 80003278 <namei>
    80004028:	c93d                	beqz	a0,8000409e <exec+0xc4>
    8000402a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000402c:	fffff097          	auipc	ra,0xfffff
    80004030:	aa6080e7          	jalr	-1370(ra) # 80002ad2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004034:	04000713          	li	a4,64
    80004038:	4681                	li	a3,0
    8000403a:	e5040613          	addi	a2,s0,-432
    8000403e:	4581                	li	a1,0
    80004040:	8556                	mv	a0,s5
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	d44080e7          	jalr	-700(ra) # 80002d86 <readi>
    8000404a:	04000793          	li	a5,64
    8000404e:	00f51a63          	bne	a0,a5,80004062 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004052:	e5042703          	lw	a4,-432(s0)
    80004056:	464c47b7          	lui	a5,0x464c4
    8000405a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000405e:	04f70663          	beq	a4,a5,800040aa <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004062:	8556                	mv	a0,s5
    80004064:	fffff097          	auipc	ra,0xfffff
    80004068:	cd0080e7          	jalr	-816(ra) # 80002d34 <iunlockput>
    end_op();
    8000406c:	fffff097          	auipc	ra,0xfffff
    80004070:	4a8080e7          	jalr	1192(ra) # 80003514 <end_op>
  }
  return -1;
    80004074:	557d                	li	a0,-1
}
    80004076:	21813083          	ld	ra,536(sp)
    8000407a:	21013403          	ld	s0,528(sp)
    8000407e:	20813483          	ld	s1,520(sp)
    80004082:	20013903          	ld	s2,512(sp)
    80004086:	79fe                	ld	s3,504(sp)
    80004088:	7a5e                	ld	s4,496(sp)
    8000408a:	7abe                	ld	s5,488(sp)
    8000408c:	7b1e                	ld	s6,480(sp)
    8000408e:	6bfe                	ld	s7,472(sp)
    80004090:	6c5e                	ld	s8,464(sp)
    80004092:	6cbe                	ld	s9,456(sp)
    80004094:	6d1e                	ld	s10,448(sp)
    80004096:	7dfa                	ld	s11,440(sp)
    80004098:	22010113          	addi	sp,sp,544
    8000409c:	8082                	ret
    end_op();
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	476080e7          	jalr	1142(ra) # 80003514 <end_op>
    return -1;
    800040a6:	557d                	li	a0,-1
    800040a8:	b7f9                	j	80004076 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040aa:	8526                	mv	a0,s1
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	e6a080e7          	jalr	-406(ra) # 80000f16 <proc_pagetable>
    800040b4:	8b2a                	mv	s6,a0
    800040b6:	d555                	beqz	a0,80004062 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040b8:	e7042783          	lw	a5,-400(s0)
    800040bc:	e8845703          	lhu	a4,-376(s0)
    800040c0:	c735                	beqz	a4,8000412c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040c2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040c4:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800040c8:	6a05                	lui	s4,0x1
    800040ca:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040ce:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040d2:	6d85                	lui	s11,0x1
    800040d4:	7d7d                	lui	s10,0xfffff
    800040d6:	a481                	j	80004316 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040d8:	00004517          	auipc	a0,0x4
    800040dc:	57850513          	addi	a0,a0,1400 # 80008650 <syscalls+0x280>
    800040e0:	00002097          	auipc	ra,0x2
    800040e4:	a9e080e7          	jalr	-1378(ra) # 80005b7e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040e8:	874a                	mv	a4,s2
    800040ea:	009c86bb          	addw	a3,s9,s1
    800040ee:	4581                	li	a1,0
    800040f0:	8556                	mv	a0,s5
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	c94080e7          	jalr	-876(ra) # 80002d86 <readi>
    800040fa:	2501                	sext.w	a0,a0
    800040fc:	1aa91a63          	bne	s2,a0,800042b0 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004100:	009d84bb          	addw	s1,s11,s1
    80004104:	013d09bb          	addw	s3,s10,s3
    80004108:	1f74f763          	bgeu	s1,s7,800042f6 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    8000410c:	02049593          	slli	a1,s1,0x20
    80004110:	9181                	srli	a1,a1,0x20
    80004112:	95e2                	add	a1,a1,s8
    80004114:	855a                	mv	a0,s6
    80004116:	ffffc097          	auipc	ra,0xffffc
    8000411a:	3ec080e7          	jalr	1004(ra) # 80000502 <walkaddr>
    8000411e:	862a                	mv	a2,a0
    if(pa == 0)
    80004120:	dd45                	beqz	a0,800040d8 <exec+0xfe>
      n = PGSIZE;
    80004122:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004124:	fd49f2e3          	bgeu	s3,s4,800040e8 <exec+0x10e>
      n = sz - i;
    80004128:	894e                	mv	s2,s3
    8000412a:	bf7d                	j	800040e8 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000412c:	4901                	li	s2,0
  iunlockput(ip);
    8000412e:	8556                	mv	a0,s5
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	c04080e7          	jalr	-1020(ra) # 80002d34 <iunlockput>
  end_op();
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	3dc080e7          	jalr	988(ra) # 80003514 <end_op>
  p = myproc();
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	d12080e7          	jalr	-750(ra) # 80000e52 <myproc>
    80004148:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000414a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000414e:	6785                	lui	a5,0x1
    80004150:	17fd                	addi	a5,a5,-1
    80004152:	993e                	add	s2,s2,a5
    80004154:	77fd                	lui	a5,0xfffff
    80004156:	00f977b3          	and	a5,s2,a5
    8000415a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000415e:	4691                	li	a3,4
    80004160:	6609                	lui	a2,0x2
    80004162:	963e                	add	a2,a2,a5
    80004164:	85be                	mv	a1,a5
    80004166:	855a                	mv	a0,s6
    80004168:	ffffc097          	auipc	ra,0xffffc
    8000416c:	74e080e7          	jalr	1870(ra) # 800008b6 <uvmalloc>
    80004170:	8c2a                	mv	s8,a0
  ip = 0;
    80004172:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004174:	12050e63          	beqz	a0,800042b0 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004178:	75f9                	lui	a1,0xffffe
    8000417a:	95aa                	add	a1,a1,a0
    8000417c:	855a                	mv	a0,s6
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	95e080e7          	jalr	-1698(ra) # 80000adc <uvmclear>
  stackbase = sp - PGSIZE;
    80004186:	7afd                	lui	s5,0xfffff
    80004188:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000418a:	df043783          	ld	a5,-528(s0)
    8000418e:	6388                	ld	a0,0(a5)
    80004190:	c925                	beqz	a0,80004200 <exec+0x226>
    80004192:	e9040993          	addi	s3,s0,-368
    80004196:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000419a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000419c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000419e:	ffffc097          	auipc	ra,0xffffc
    800041a2:	156080e7          	jalr	342(ra) # 800002f4 <strlen>
    800041a6:	0015079b          	addiw	a5,a0,1
    800041aa:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041ae:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041b2:	13596663          	bltu	s2,s5,800042de <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041b6:	df043d83          	ld	s11,-528(s0)
    800041ba:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041be:	8552                	mv	a0,s4
    800041c0:	ffffc097          	auipc	ra,0xffffc
    800041c4:	134080e7          	jalr	308(ra) # 800002f4 <strlen>
    800041c8:	0015069b          	addiw	a3,a0,1
    800041cc:	8652                	mv	a2,s4
    800041ce:	85ca                	mv	a1,s2
    800041d0:	855a                	mv	a0,s6
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	93c080e7          	jalr	-1732(ra) # 80000b0e <copyout>
    800041da:	10054663          	bltz	a0,800042e6 <exec+0x30c>
    ustack[argc] = sp;
    800041de:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041e2:	0485                	addi	s1,s1,1
    800041e4:	008d8793          	addi	a5,s11,8
    800041e8:	def43823          	sd	a5,-528(s0)
    800041ec:	008db503          	ld	a0,8(s11)
    800041f0:	c911                	beqz	a0,80004204 <exec+0x22a>
    if(argc >= MAXARG)
    800041f2:	09a1                	addi	s3,s3,8
    800041f4:	fb3c95e3          	bne	s9,s3,8000419e <exec+0x1c4>
  sz = sz1;
    800041f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800041fc:	4a81                	li	s5,0
    800041fe:	a84d                	j	800042b0 <exec+0x2d6>
  sp = sz;
    80004200:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004202:	4481                	li	s1,0
  ustack[argc] = 0;
    80004204:	00349793          	slli	a5,s1,0x3
    80004208:	f9040713          	addi	a4,s0,-112
    8000420c:	97ba                	add	a5,a5,a4
    8000420e:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdd1d0>
  sp -= (argc+1) * sizeof(uint64);
    80004212:	00148693          	addi	a3,s1,1
    80004216:	068e                	slli	a3,a3,0x3
    80004218:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000421c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004220:	01597663          	bgeu	s2,s5,8000422c <exec+0x252>
  sz = sz1;
    80004224:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004228:	4a81                	li	s5,0
    8000422a:	a059                	j	800042b0 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000422c:	e9040613          	addi	a2,s0,-368
    80004230:	85ca                	mv	a1,s2
    80004232:	855a                	mv	a0,s6
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	8da080e7          	jalr	-1830(ra) # 80000b0e <copyout>
    8000423c:	0a054963          	bltz	a0,800042ee <exec+0x314>
  p->trapframe->a1 = sp;
    80004240:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004244:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004248:	de843783          	ld	a5,-536(s0)
    8000424c:	0007c703          	lbu	a4,0(a5)
    80004250:	cf11                	beqz	a4,8000426c <exec+0x292>
    80004252:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004254:	02f00693          	li	a3,47
    80004258:	a039                	j	80004266 <exec+0x28c>
      last = s+1;
    8000425a:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000425e:	0785                	addi	a5,a5,1
    80004260:	fff7c703          	lbu	a4,-1(a5)
    80004264:	c701                	beqz	a4,8000426c <exec+0x292>
    if(*s == '/')
    80004266:	fed71ce3          	bne	a4,a3,8000425e <exec+0x284>
    8000426a:	bfc5                	j	8000425a <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000426c:	4641                	li	a2,16
    8000426e:	de843583          	ld	a1,-536(s0)
    80004272:	158b8513          	addi	a0,s7,344
    80004276:	ffffc097          	auipc	ra,0xffffc
    8000427a:	04c080e7          	jalr	76(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000427e:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004282:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004286:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000428a:	058bb783          	ld	a5,88(s7)
    8000428e:	e6843703          	ld	a4,-408(s0)
    80004292:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004294:	058bb783          	ld	a5,88(s7)
    80004298:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000429c:	85ea                	mv	a1,s10
    8000429e:	ffffd097          	auipc	ra,0xffffd
    800042a2:	d14080e7          	jalr	-748(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042a6:	0004851b          	sext.w	a0,s1
    800042aa:	b3f1                	j	80004076 <exec+0x9c>
    800042ac:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042b0:	df843583          	ld	a1,-520(s0)
    800042b4:	855a                	mv	a0,s6
    800042b6:	ffffd097          	auipc	ra,0xffffd
    800042ba:	cfc080e7          	jalr	-772(ra) # 80000fb2 <proc_freepagetable>
  if(ip){
    800042be:	da0a92e3          	bnez	s5,80004062 <exec+0x88>
  return -1;
    800042c2:	557d                	li	a0,-1
    800042c4:	bb4d                	j	80004076 <exec+0x9c>
    800042c6:	df243c23          	sd	s2,-520(s0)
    800042ca:	b7dd                	j	800042b0 <exec+0x2d6>
    800042cc:	df243c23          	sd	s2,-520(s0)
    800042d0:	b7c5                	j	800042b0 <exec+0x2d6>
    800042d2:	df243c23          	sd	s2,-520(s0)
    800042d6:	bfe9                	j	800042b0 <exec+0x2d6>
    800042d8:	df243c23          	sd	s2,-520(s0)
    800042dc:	bfd1                	j	800042b0 <exec+0x2d6>
  sz = sz1;
    800042de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042e2:	4a81                	li	s5,0
    800042e4:	b7f1                	j	800042b0 <exec+0x2d6>
  sz = sz1;
    800042e6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042ea:	4a81                	li	s5,0
    800042ec:	b7d1                	j	800042b0 <exec+0x2d6>
  sz = sz1;
    800042ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f2:	4a81                	li	s5,0
    800042f4:	bf75                	j	800042b0 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042f6:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042fa:	e0843783          	ld	a5,-504(s0)
    800042fe:	0017869b          	addiw	a3,a5,1
    80004302:	e0d43423          	sd	a3,-504(s0)
    80004306:	e0043783          	ld	a5,-512(s0)
    8000430a:	0387879b          	addiw	a5,a5,56
    8000430e:	e8845703          	lhu	a4,-376(s0)
    80004312:	e0e6dee3          	bge	a3,a4,8000412e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004316:	2781                	sext.w	a5,a5
    80004318:	e0f43023          	sd	a5,-512(s0)
    8000431c:	03800713          	li	a4,56
    80004320:	86be                	mv	a3,a5
    80004322:	e1840613          	addi	a2,s0,-488
    80004326:	4581                	li	a1,0
    80004328:	8556                	mv	a0,s5
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	a5c080e7          	jalr	-1444(ra) # 80002d86 <readi>
    80004332:	03800793          	li	a5,56
    80004336:	f6f51be3          	bne	a0,a5,800042ac <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    8000433a:	e1842783          	lw	a5,-488(s0)
    8000433e:	4705                	li	a4,1
    80004340:	fae79de3          	bne	a5,a4,800042fa <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004344:	e4043483          	ld	s1,-448(s0)
    80004348:	e3843783          	ld	a5,-456(s0)
    8000434c:	f6f4ede3          	bltu	s1,a5,800042c6 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004350:	e2843783          	ld	a5,-472(s0)
    80004354:	94be                	add	s1,s1,a5
    80004356:	f6f4ebe3          	bltu	s1,a5,800042cc <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    8000435a:	de043703          	ld	a4,-544(s0)
    8000435e:	8ff9                	and	a5,a5,a4
    80004360:	fbad                	bnez	a5,800042d2 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004362:	e1c42503          	lw	a0,-484(s0)
    80004366:	00000097          	auipc	ra,0x0
    8000436a:	c58080e7          	jalr	-936(ra) # 80003fbe <flags2perm>
    8000436e:	86aa                	mv	a3,a0
    80004370:	8626                	mv	a2,s1
    80004372:	85ca                	mv	a1,s2
    80004374:	855a                	mv	a0,s6
    80004376:	ffffc097          	auipc	ra,0xffffc
    8000437a:	540080e7          	jalr	1344(ra) # 800008b6 <uvmalloc>
    8000437e:	dea43c23          	sd	a0,-520(s0)
    80004382:	d939                	beqz	a0,800042d8 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004384:	e2843c03          	ld	s8,-472(s0)
    80004388:	e2042c83          	lw	s9,-480(s0)
    8000438c:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004390:	f60b83e3          	beqz	s7,800042f6 <exec+0x31c>
    80004394:	89de                	mv	s3,s7
    80004396:	4481                	li	s1,0
    80004398:	bb95                	j	8000410c <exec+0x132>

000000008000439a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000439a:	7179                	addi	sp,sp,-48
    8000439c:	f406                	sd	ra,40(sp)
    8000439e:	f022                	sd	s0,32(sp)
    800043a0:	ec26                	sd	s1,24(sp)
    800043a2:	e84a                	sd	s2,16(sp)
    800043a4:	1800                	addi	s0,sp,48
    800043a6:	892e                	mv	s2,a1
    800043a8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043aa:	fdc40593          	addi	a1,s0,-36
    800043ae:	ffffe097          	auipc	ra,0xffffe
    800043b2:	bb8080e7          	jalr	-1096(ra) # 80001f66 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043b6:	fdc42703          	lw	a4,-36(s0)
    800043ba:	47bd                	li	a5,15
    800043bc:	02e7eb63          	bltu	a5,a4,800043f2 <argfd+0x58>
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	a92080e7          	jalr	-1390(ra) # 80000e52 <myproc>
    800043c8:	fdc42703          	lw	a4,-36(s0)
    800043cc:	01a70793          	addi	a5,a4,26
    800043d0:	078e                	slli	a5,a5,0x3
    800043d2:	953e                	add	a0,a0,a5
    800043d4:	611c                	ld	a5,0(a0)
    800043d6:	c385                	beqz	a5,800043f6 <argfd+0x5c>
    return -1;
  if(pfd)
    800043d8:	00090463          	beqz	s2,800043e0 <argfd+0x46>
    *pfd = fd;
    800043dc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043e0:	4501                	li	a0,0
  if(pf)
    800043e2:	c091                	beqz	s1,800043e6 <argfd+0x4c>
    *pf = f;
    800043e4:	e09c                	sd	a5,0(s1)
}
    800043e6:	70a2                	ld	ra,40(sp)
    800043e8:	7402                	ld	s0,32(sp)
    800043ea:	64e2                	ld	s1,24(sp)
    800043ec:	6942                	ld	s2,16(sp)
    800043ee:	6145                	addi	sp,sp,48
    800043f0:	8082                	ret
    return -1;
    800043f2:	557d                	li	a0,-1
    800043f4:	bfcd                	j	800043e6 <argfd+0x4c>
    800043f6:	557d                	li	a0,-1
    800043f8:	b7fd                	j	800043e6 <argfd+0x4c>

00000000800043fa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043fa:	1101                	addi	sp,sp,-32
    800043fc:	ec06                	sd	ra,24(sp)
    800043fe:	e822                	sd	s0,16(sp)
    80004400:	e426                	sd	s1,8(sp)
    80004402:	1000                	addi	s0,sp,32
    80004404:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004406:	ffffd097          	auipc	ra,0xffffd
    8000440a:	a4c080e7          	jalr	-1460(ra) # 80000e52 <myproc>
    8000440e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004410:	0d050793          	addi	a5,a0,208
    80004414:	4501                	li	a0,0
    80004416:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004418:	6398                	ld	a4,0(a5)
    8000441a:	cb19                	beqz	a4,80004430 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000441c:	2505                	addiw	a0,a0,1
    8000441e:	07a1                	addi	a5,a5,8
    80004420:	fed51ce3          	bne	a0,a3,80004418 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004424:	557d                	li	a0,-1
}
    80004426:	60e2                	ld	ra,24(sp)
    80004428:	6442                	ld	s0,16(sp)
    8000442a:	64a2                	ld	s1,8(sp)
    8000442c:	6105                	addi	sp,sp,32
    8000442e:	8082                	ret
      p->ofile[fd] = f;
    80004430:	01a50793          	addi	a5,a0,26
    80004434:	078e                	slli	a5,a5,0x3
    80004436:	963e                	add	a2,a2,a5
    80004438:	e204                	sd	s1,0(a2)
      return fd;
    8000443a:	b7f5                	j	80004426 <fdalloc+0x2c>

000000008000443c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000443c:	715d                	addi	sp,sp,-80
    8000443e:	e486                	sd	ra,72(sp)
    80004440:	e0a2                	sd	s0,64(sp)
    80004442:	fc26                	sd	s1,56(sp)
    80004444:	f84a                	sd	s2,48(sp)
    80004446:	f44e                	sd	s3,40(sp)
    80004448:	f052                	sd	s4,32(sp)
    8000444a:	ec56                	sd	s5,24(sp)
    8000444c:	e85a                	sd	s6,16(sp)
    8000444e:	0880                	addi	s0,sp,80
    80004450:	8b2e                	mv	s6,a1
    80004452:	89b2                	mv	s3,a2
    80004454:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004456:	fb040593          	addi	a1,s0,-80
    8000445a:	fffff097          	auipc	ra,0xfffff
    8000445e:	e3c080e7          	jalr	-452(ra) # 80003296 <nameiparent>
    80004462:	84aa                	mv	s1,a0
    80004464:	14050f63          	beqz	a0,800045c2 <create+0x186>
    return 0;

  ilock(dp);
    80004468:	ffffe097          	auipc	ra,0xffffe
    8000446c:	66a080e7          	jalr	1642(ra) # 80002ad2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004470:	4601                	li	a2,0
    80004472:	fb040593          	addi	a1,s0,-80
    80004476:	8526                	mv	a0,s1
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	b3e080e7          	jalr	-1218(ra) # 80002fb6 <dirlookup>
    80004480:	8aaa                	mv	s5,a0
    80004482:	c931                	beqz	a0,800044d6 <create+0x9a>
    iunlockput(dp);
    80004484:	8526                	mv	a0,s1
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	8ae080e7          	jalr	-1874(ra) # 80002d34 <iunlockput>
    ilock(ip);
    8000448e:	8556                	mv	a0,s5
    80004490:	ffffe097          	auipc	ra,0xffffe
    80004494:	642080e7          	jalr	1602(ra) # 80002ad2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004498:	000b059b          	sext.w	a1,s6
    8000449c:	4789                	li	a5,2
    8000449e:	02f59563          	bne	a1,a5,800044c8 <create+0x8c>
    800044a2:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd314>
    800044a6:	37f9                	addiw	a5,a5,-2
    800044a8:	17c2                	slli	a5,a5,0x30
    800044aa:	93c1                	srli	a5,a5,0x30
    800044ac:	4705                	li	a4,1
    800044ae:	00f76d63          	bltu	a4,a5,800044c8 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044b2:	8556                	mv	a0,s5
    800044b4:	60a6                	ld	ra,72(sp)
    800044b6:	6406                	ld	s0,64(sp)
    800044b8:	74e2                	ld	s1,56(sp)
    800044ba:	7942                	ld	s2,48(sp)
    800044bc:	79a2                	ld	s3,40(sp)
    800044be:	7a02                	ld	s4,32(sp)
    800044c0:	6ae2                	ld	s5,24(sp)
    800044c2:	6b42                	ld	s6,16(sp)
    800044c4:	6161                	addi	sp,sp,80
    800044c6:	8082                	ret
    iunlockput(ip);
    800044c8:	8556                	mv	a0,s5
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	86a080e7          	jalr	-1942(ra) # 80002d34 <iunlockput>
    return 0;
    800044d2:	4a81                	li	s5,0
    800044d4:	bff9                	j	800044b2 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044d6:	85da                	mv	a1,s6
    800044d8:	4088                	lw	a0,0(s1)
    800044da:	ffffe097          	auipc	ra,0xffffe
    800044de:	45c080e7          	jalr	1116(ra) # 80002936 <ialloc>
    800044e2:	8a2a                	mv	s4,a0
    800044e4:	c539                	beqz	a0,80004532 <create+0xf6>
  ilock(ip);
    800044e6:	ffffe097          	auipc	ra,0xffffe
    800044ea:	5ec080e7          	jalr	1516(ra) # 80002ad2 <ilock>
  ip->major = major;
    800044ee:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044f2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044f6:	4905                	li	s2,1
    800044f8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800044fc:	8552                	mv	a0,s4
    800044fe:	ffffe097          	auipc	ra,0xffffe
    80004502:	50a080e7          	jalr	1290(ra) # 80002a08 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004506:	000b059b          	sext.w	a1,s6
    8000450a:	03258b63          	beq	a1,s2,80004540 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    8000450e:	004a2603          	lw	a2,4(s4)
    80004512:	fb040593          	addi	a1,s0,-80
    80004516:	8526                	mv	a0,s1
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	cae080e7          	jalr	-850(ra) # 800031c6 <dirlink>
    80004520:	06054f63          	bltz	a0,8000459e <create+0x162>
  iunlockput(dp);
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	80e080e7          	jalr	-2034(ra) # 80002d34 <iunlockput>
  return ip;
    8000452e:	8ad2                	mv	s5,s4
    80004530:	b749                	j	800044b2 <create+0x76>
    iunlockput(dp);
    80004532:	8526                	mv	a0,s1
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	800080e7          	jalr	-2048(ra) # 80002d34 <iunlockput>
    return 0;
    8000453c:	8ad2                	mv	s5,s4
    8000453e:	bf95                	j	800044b2 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004540:	004a2603          	lw	a2,4(s4)
    80004544:	00004597          	auipc	a1,0x4
    80004548:	12c58593          	addi	a1,a1,300 # 80008670 <syscalls+0x2a0>
    8000454c:	8552                	mv	a0,s4
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	c78080e7          	jalr	-904(ra) # 800031c6 <dirlink>
    80004556:	04054463          	bltz	a0,8000459e <create+0x162>
    8000455a:	40d0                	lw	a2,4(s1)
    8000455c:	00004597          	auipc	a1,0x4
    80004560:	11c58593          	addi	a1,a1,284 # 80008678 <syscalls+0x2a8>
    80004564:	8552                	mv	a0,s4
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	c60080e7          	jalr	-928(ra) # 800031c6 <dirlink>
    8000456e:	02054863          	bltz	a0,8000459e <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004572:	004a2603          	lw	a2,4(s4)
    80004576:	fb040593          	addi	a1,s0,-80
    8000457a:	8526                	mv	a0,s1
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	c4a080e7          	jalr	-950(ra) # 800031c6 <dirlink>
    80004584:	00054d63          	bltz	a0,8000459e <create+0x162>
    dp->nlink++;  // for ".."
    80004588:	04a4d783          	lhu	a5,74(s1)
    8000458c:	2785                	addiw	a5,a5,1
    8000458e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004592:	8526                	mv	a0,s1
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	474080e7          	jalr	1140(ra) # 80002a08 <iupdate>
    8000459c:	b761                	j	80004524 <create+0xe8>
  ip->nlink = 0;
    8000459e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045a2:	8552                	mv	a0,s4
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	464080e7          	jalr	1124(ra) # 80002a08 <iupdate>
  iunlockput(ip);
    800045ac:	8552                	mv	a0,s4
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	786080e7          	jalr	1926(ra) # 80002d34 <iunlockput>
  iunlockput(dp);
    800045b6:	8526                	mv	a0,s1
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	77c080e7          	jalr	1916(ra) # 80002d34 <iunlockput>
  return 0;
    800045c0:	bdcd                	j	800044b2 <create+0x76>
    return 0;
    800045c2:	8aaa                	mv	s5,a0
    800045c4:	b5fd                	j	800044b2 <create+0x76>

00000000800045c6 <sys_dup>:
{
    800045c6:	7179                	addi	sp,sp,-48
    800045c8:	f406                	sd	ra,40(sp)
    800045ca:	f022                	sd	s0,32(sp)
    800045cc:	ec26                	sd	s1,24(sp)
    800045ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045d0:	fd840613          	addi	a2,s0,-40
    800045d4:	4581                	li	a1,0
    800045d6:	4501                	li	a0,0
    800045d8:	00000097          	auipc	ra,0x0
    800045dc:	dc2080e7          	jalr	-574(ra) # 8000439a <argfd>
    return -1;
    800045e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045e2:	02054363          	bltz	a0,80004608 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045e6:	fd843503          	ld	a0,-40(s0)
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	e10080e7          	jalr	-496(ra) # 800043fa <fdalloc>
    800045f2:	84aa                	mv	s1,a0
    return -1;
    800045f4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045f6:	00054963          	bltz	a0,80004608 <sys_dup+0x42>
  filedup(f);
    800045fa:	fd843503          	ld	a0,-40(s0)
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	310080e7          	jalr	784(ra) # 8000390e <filedup>
  return fd;
    80004606:	87a6                	mv	a5,s1
}
    80004608:	853e                	mv	a0,a5
    8000460a:	70a2                	ld	ra,40(sp)
    8000460c:	7402                	ld	s0,32(sp)
    8000460e:	64e2                	ld	s1,24(sp)
    80004610:	6145                	addi	sp,sp,48
    80004612:	8082                	ret

0000000080004614 <sys_read>:
{
    80004614:	7179                	addi	sp,sp,-48
    80004616:	f406                	sd	ra,40(sp)
    80004618:	f022                	sd	s0,32(sp)
    8000461a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000461c:	fd840593          	addi	a1,s0,-40
    80004620:	4505                	li	a0,1
    80004622:	ffffe097          	auipc	ra,0xffffe
    80004626:	964080e7          	jalr	-1692(ra) # 80001f86 <argaddr>
  argint(2, &n);
    8000462a:	fe440593          	addi	a1,s0,-28
    8000462e:	4509                	li	a0,2
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	936080e7          	jalr	-1738(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    80004638:	fe840613          	addi	a2,s0,-24
    8000463c:	4581                	li	a1,0
    8000463e:	4501                	li	a0,0
    80004640:	00000097          	auipc	ra,0x0
    80004644:	d5a080e7          	jalr	-678(ra) # 8000439a <argfd>
    80004648:	87aa                	mv	a5,a0
    return -1;
    8000464a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000464c:	0007cc63          	bltz	a5,80004664 <sys_read+0x50>
  return fileread(f, p, n);
    80004650:	fe442603          	lw	a2,-28(s0)
    80004654:	fd843583          	ld	a1,-40(s0)
    80004658:	fe843503          	ld	a0,-24(s0)
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	43e080e7          	jalr	1086(ra) # 80003a9a <fileread>
}
    80004664:	70a2                	ld	ra,40(sp)
    80004666:	7402                	ld	s0,32(sp)
    80004668:	6145                	addi	sp,sp,48
    8000466a:	8082                	ret

000000008000466c <sys_write>:
{
    8000466c:	7179                	addi	sp,sp,-48
    8000466e:	f406                	sd	ra,40(sp)
    80004670:	f022                	sd	s0,32(sp)
    80004672:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004674:	fd840593          	addi	a1,s0,-40
    80004678:	4505                	li	a0,1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	90c080e7          	jalr	-1780(ra) # 80001f86 <argaddr>
  argint(2, &n);
    80004682:	fe440593          	addi	a1,s0,-28
    80004686:	4509                	li	a0,2
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	8de080e7          	jalr	-1826(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    80004690:	fe840613          	addi	a2,s0,-24
    80004694:	4581                	li	a1,0
    80004696:	4501                	li	a0,0
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	d02080e7          	jalr	-766(ra) # 8000439a <argfd>
    800046a0:	87aa                	mv	a5,a0
    return -1;
    800046a2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046a4:	0007cc63          	bltz	a5,800046bc <sys_write+0x50>
  return filewrite(f, p, n);
    800046a8:	fe442603          	lw	a2,-28(s0)
    800046ac:	fd843583          	ld	a1,-40(s0)
    800046b0:	fe843503          	ld	a0,-24(s0)
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	4a8080e7          	jalr	1192(ra) # 80003b5c <filewrite>
}
    800046bc:	70a2                	ld	ra,40(sp)
    800046be:	7402                	ld	s0,32(sp)
    800046c0:	6145                	addi	sp,sp,48
    800046c2:	8082                	ret

00000000800046c4 <sys_close>:
{
    800046c4:	1101                	addi	sp,sp,-32
    800046c6:	ec06                	sd	ra,24(sp)
    800046c8:	e822                	sd	s0,16(sp)
    800046ca:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046cc:	fe040613          	addi	a2,s0,-32
    800046d0:	fec40593          	addi	a1,s0,-20
    800046d4:	4501                	li	a0,0
    800046d6:	00000097          	auipc	ra,0x0
    800046da:	cc4080e7          	jalr	-828(ra) # 8000439a <argfd>
    return -1;
    800046de:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046e0:	02054463          	bltz	a0,80004708 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	76e080e7          	jalr	1902(ra) # 80000e52 <myproc>
    800046ec:	fec42783          	lw	a5,-20(s0)
    800046f0:	07e9                	addi	a5,a5,26
    800046f2:	078e                	slli	a5,a5,0x3
    800046f4:	97aa                	add	a5,a5,a0
    800046f6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800046fa:	fe043503          	ld	a0,-32(s0)
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	262080e7          	jalr	610(ra) # 80003960 <fileclose>
  return 0;
    80004706:	4781                	li	a5,0
}
    80004708:	853e                	mv	a0,a5
    8000470a:	60e2                	ld	ra,24(sp)
    8000470c:	6442                	ld	s0,16(sp)
    8000470e:	6105                	addi	sp,sp,32
    80004710:	8082                	ret

0000000080004712 <sys_fstat>:
{
    80004712:	1101                	addi	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000471a:	fe040593          	addi	a1,s0,-32
    8000471e:	4505                	li	a0,1
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	866080e7          	jalr	-1946(ra) # 80001f86 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004728:	fe840613          	addi	a2,s0,-24
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	c6a080e7          	jalr	-918(ra) # 8000439a <argfd>
    80004738:	87aa                	mv	a5,a0
    return -1;
    8000473a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000473c:	0007ca63          	bltz	a5,80004750 <sys_fstat+0x3e>
  return filestat(f, st);
    80004740:	fe043583          	ld	a1,-32(s0)
    80004744:	fe843503          	ld	a0,-24(s0)
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	2e0080e7          	jalr	736(ra) # 80003a28 <filestat>
}
    80004750:	60e2                	ld	ra,24(sp)
    80004752:	6442                	ld	s0,16(sp)
    80004754:	6105                	addi	sp,sp,32
    80004756:	8082                	ret

0000000080004758 <sys_link>:
{
    80004758:	7169                	addi	sp,sp,-304
    8000475a:	f606                	sd	ra,296(sp)
    8000475c:	f222                	sd	s0,288(sp)
    8000475e:	ee26                	sd	s1,280(sp)
    80004760:	ea4a                	sd	s2,272(sp)
    80004762:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004764:	08000613          	li	a2,128
    80004768:	ed040593          	addi	a1,s0,-304
    8000476c:	4501                	li	a0,0
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	838080e7          	jalr	-1992(ra) # 80001fa6 <argstr>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004778:	10054e63          	bltz	a0,80004894 <sys_link+0x13c>
    8000477c:	08000613          	li	a2,128
    80004780:	f5040593          	addi	a1,s0,-176
    80004784:	4505                	li	a0,1
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	820080e7          	jalr	-2016(ra) # 80001fa6 <argstr>
    return -1;
    8000478e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004790:	10054263          	bltz	a0,80004894 <sys_link+0x13c>
  begin_op();
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	d00080e7          	jalr	-768(ra) # 80003494 <begin_op>
  if((ip = namei(old)) == 0){
    8000479c:	ed040513          	addi	a0,s0,-304
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	ad8080e7          	jalr	-1320(ra) # 80003278 <namei>
    800047a8:	84aa                	mv	s1,a0
    800047aa:	c551                	beqz	a0,80004836 <sys_link+0xde>
  ilock(ip);
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	326080e7          	jalr	806(ra) # 80002ad2 <ilock>
  if(ip->type == T_DIR){
    800047b4:	04449703          	lh	a4,68(s1)
    800047b8:	4785                	li	a5,1
    800047ba:	08f70463          	beq	a4,a5,80004842 <sys_link+0xea>
  ip->nlink++;
    800047be:	04a4d783          	lhu	a5,74(s1)
    800047c2:	2785                	addiw	a5,a5,1
    800047c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047c8:	8526                	mv	a0,s1
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	23e080e7          	jalr	574(ra) # 80002a08 <iupdate>
  iunlock(ip);
    800047d2:	8526                	mv	a0,s1
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	3c0080e7          	jalr	960(ra) # 80002b94 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047dc:	fd040593          	addi	a1,s0,-48
    800047e0:	f5040513          	addi	a0,s0,-176
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	ab2080e7          	jalr	-1358(ra) # 80003296 <nameiparent>
    800047ec:	892a                	mv	s2,a0
    800047ee:	c935                	beqz	a0,80004862 <sys_link+0x10a>
  ilock(dp);
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	2e2080e7          	jalr	738(ra) # 80002ad2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047f8:	00092703          	lw	a4,0(s2)
    800047fc:	409c                	lw	a5,0(s1)
    800047fe:	04f71d63          	bne	a4,a5,80004858 <sys_link+0x100>
    80004802:	40d0                	lw	a2,4(s1)
    80004804:	fd040593          	addi	a1,s0,-48
    80004808:	854a                	mv	a0,s2
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	9bc080e7          	jalr	-1604(ra) # 800031c6 <dirlink>
    80004812:	04054363          	bltz	a0,80004858 <sys_link+0x100>
  iunlockput(dp);
    80004816:	854a                	mv	a0,s2
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	51c080e7          	jalr	1308(ra) # 80002d34 <iunlockput>
  iput(ip);
    80004820:	8526                	mv	a0,s1
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	46a080e7          	jalr	1130(ra) # 80002c8c <iput>
  end_op();
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	cea080e7          	jalr	-790(ra) # 80003514 <end_op>
  return 0;
    80004832:	4781                	li	a5,0
    80004834:	a085                	j	80004894 <sys_link+0x13c>
    end_op();
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	cde080e7          	jalr	-802(ra) # 80003514 <end_op>
    return -1;
    8000483e:	57fd                	li	a5,-1
    80004840:	a891                	j	80004894 <sys_link+0x13c>
    iunlockput(ip);
    80004842:	8526                	mv	a0,s1
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	4f0080e7          	jalr	1264(ra) # 80002d34 <iunlockput>
    end_op();
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	cc8080e7          	jalr	-824(ra) # 80003514 <end_op>
    return -1;
    80004854:	57fd                	li	a5,-1
    80004856:	a83d                	j	80004894 <sys_link+0x13c>
    iunlockput(dp);
    80004858:	854a                	mv	a0,s2
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	4da080e7          	jalr	1242(ra) # 80002d34 <iunlockput>
  ilock(ip);
    80004862:	8526                	mv	a0,s1
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	26e080e7          	jalr	622(ra) # 80002ad2 <ilock>
  ip->nlink--;
    8000486c:	04a4d783          	lhu	a5,74(s1)
    80004870:	37fd                	addiw	a5,a5,-1
    80004872:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004876:	8526                	mv	a0,s1
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	190080e7          	jalr	400(ra) # 80002a08 <iupdate>
  iunlockput(ip);
    80004880:	8526                	mv	a0,s1
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	4b2080e7          	jalr	1202(ra) # 80002d34 <iunlockput>
  end_op();
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	c8a080e7          	jalr	-886(ra) # 80003514 <end_op>
  return -1;
    80004892:	57fd                	li	a5,-1
}
    80004894:	853e                	mv	a0,a5
    80004896:	70b2                	ld	ra,296(sp)
    80004898:	7412                	ld	s0,288(sp)
    8000489a:	64f2                	ld	s1,280(sp)
    8000489c:	6952                	ld	s2,272(sp)
    8000489e:	6155                	addi	sp,sp,304
    800048a0:	8082                	ret

00000000800048a2 <sys_unlink>:
{
    800048a2:	7151                	addi	sp,sp,-240
    800048a4:	f586                	sd	ra,232(sp)
    800048a6:	f1a2                	sd	s0,224(sp)
    800048a8:	eda6                	sd	s1,216(sp)
    800048aa:	e9ca                	sd	s2,208(sp)
    800048ac:	e5ce                	sd	s3,200(sp)
    800048ae:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048b0:	08000613          	li	a2,128
    800048b4:	f3040593          	addi	a1,s0,-208
    800048b8:	4501                	li	a0,0
    800048ba:	ffffd097          	auipc	ra,0xffffd
    800048be:	6ec080e7          	jalr	1772(ra) # 80001fa6 <argstr>
    800048c2:	18054163          	bltz	a0,80004a44 <sys_unlink+0x1a2>
  begin_op();
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	bce080e7          	jalr	-1074(ra) # 80003494 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048ce:	fb040593          	addi	a1,s0,-80
    800048d2:	f3040513          	addi	a0,s0,-208
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	9c0080e7          	jalr	-1600(ra) # 80003296 <nameiparent>
    800048de:	84aa                	mv	s1,a0
    800048e0:	c979                	beqz	a0,800049b6 <sys_unlink+0x114>
  ilock(dp);
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	1f0080e7          	jalr	496(ra) # 80002ad2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048ea:	00004597          	auipc	a1,0x4
    800048ee:	d8658593          	addi	a1,a1,-634 # 80008670 <syscalls+0x2a0>
    800048f2:	fb040513          	addi	a0,s0,-80
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	6a6080e7          	jalr	1702(ra) # 80002f9c <namecmp>
    800048fe:	14050a63          	beqz	a0,80004a52 <sys_unlink+0x1b0>
    80004902:	00004597          	auipc	a1,0x4
    80004906:	d7658593          	addi	a1,a1,-650 # 80008678 <syscalls+0x2a8>
    8000490a:	fb040513          	addi	a0,s0,-80
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	68e080e7          	jalr	1678(ra) # 80002f9c <namecmp>
    80004916:	12050e63          	beqz	a0,80004a52 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000491a:	f2c40613          	addi	a2,s0,-212
    8000491e:	fb040593          	addi	a1,s0,-80
    80004922:	8526                	mv	a0,s1
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	692080e7          	jalr	1682(ra) # 80002fb6 <dirlookup>
    8000492c:	892a                	mv	s2,a0
    8000492e:	12050263          	beqz	a0,80004a52 <sys_unlink+0x1b0>
  ilock(ip);
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	1a0080e7          	jalr	416(ra) # 80002ad2 <ilock>
  if(ip->nlink < 1)
    8000493a:	04a91783          	lh	a5,74(s2)
    8000493e:	08f05263          	blez	a5,800049c2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004942:	04491703          	lh	a4,68(s2)
    80004946:	4785                	li	a5,1
    80004948:	08f70563          	beq	a4,a5,800049d2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000494c:	4641                	li	a2,16
    8000494e:	4581                	li	a1,0
    80004950:	fc040513          	addi	a0,s0,-64
    80004954:	ffffc097          	auipc	ra,0xffffc
    80004958:	824080e7          	jalr	-2012(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000495c:	4741                	li	a4,16
    8000495e:	f2c42683          	lw	a3,-212(s0)
    80004962:	fc040613          	addi	a2,s0,-64
    80004966:	4581                	li	a1,0
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	514080e7          	jalr	1300(ra) # 80002e7e <writei>
    80004972:	47c1                	li	a5,16
    80004974:	0af51563          	bne	a0,a5,80004a1e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004978:	04491703          	lh	a4,68(s2)
    8000497c:	4785                	li	a5,1
    8000497e:	0af70863          	beq	a4,a5,80004a2e <sys_unlink+0x18c>
  iunlockput(dp);
    80004982:	8526                	mv	a0,s1
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	3b0080e7          	jalr	944(ra) # 80002d34 <iunlockput>
  ip->nlink--;
    8000498c:	04a95783          	lhu	a5,74(s2)
    80004990:	37fd                	addiw	a5,a5,-1
    80004992:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004996:	854a                	mv	a0,s2
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	070080e7          	jalr	112(ra) # 80002a08 <iupdate>
  iunlockput(ip);
    800049a0:	854a                	mv	a0,s2
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	392080e7          	jalr	914(ra) # 80002d34 <iunlockput>
  end_op();
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	b6a080e7          	jalr	-1174(ra) # 80003514 <end_op>
  return 0;
    800049b2:	4501                	li	a0,0
    800049b4:	a84d                	j	80004a66 <sys_unlink+0x1c4>
    end_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	b5e080e7          	jalr	-1186(ra) # 80003514 <end_op>
    return -1;
    800049be:	557d                	li	a0,-1
    800049c0:	a05d                	j	80004a66 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049c2:	00004517          	auipc	a0,0x4
    800049c6:	cbe50513          	addi	a0,a0,-834 # 80008680 <syscalls+0x2b0>
    800049ca:	00001097          	auipc	ra,0x1
    800049ce:	1b4080e7          	jalr	436(ra) # 80005b7e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049d2:	04c92703          	lw	a4,76(s2)
    800049d6:	02000793          	li	a5,32
    800049da:	f6e7f9e3          	bgeu	a5,a4,8000494c <sys_unlink+0xaa>
    800049de:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049e2:	4741                	li	a4,16
    800049e4:	86ce                	mv	a3,s3
    800049e6:	f1840613          	addi	a2,s0,-232
    800049ea:	4581                	li	a1,0
    800049ec:	854a                	mv	a0,s2
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	398080e7          	jalr	920(ra) # 80002d86 <readi>
    800049f6:	47c1                	li	a5,16
    800049f8:	00f51b63          	bne	a0,a5,80004a0e <sys_unlink+0x16c>
    if(de.inum != 0)
    800049fc:	f1845783          	lhu	a5,-232(s0)
    80004a00:	e7a1                	bnez	a5,80004a48 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a02:	29c1                	addiw	s3,s3,16
    80004a04:	04c92783          	lw	a5,76(s2)
    80004a08:	fcf9ede3          	bltu	s3,a5,800049e2 <sys_unlink+0x140>
    80004a0c:	b781                	j	8000494c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a0e:	00004517          	auipc	a0,0x4
    80004a12:	c8a50513          	addi	a0,a0,-886 # 80008698 <syscalls+0x2c8>
    80004a16:	00001097          	auipc	ra,0x1
    80004a1a:	168080e7          	jalr	360(ra) # 80005b7e <panic>
    panic("unlink: writei");
    80004a1e:	00004517          	auipc	a0,0x4
    80004a22:	c9250513          	addi	a0,a0,-878 # 800086b0 <syscalls+0x2e0>
    80004a26:	00001097          	auipc	ra,0x1
    80004a2a:	158080e7          	jalr	344(ra) # 80005b7e <panic>
    dp->nlink--;
    80004a2e:	04a4d783          	lhu	a5,74(s1)
    80004a32:	37fd                	addiw	a5,a5,-1
    80004a34:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	fce080e7          	jalr	-50(ra) # 80002a08 <iupdate>
    80004a42:	b781                	j	80004982 <sys_unlink+0xe0>
    return -1;
    80004a44:	557d                	li	a0,-1
    80004a46:	a005                	j	80004a66 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a48:	854a                	mv	a0,s2
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	2ea080e7          	jalr	746(ra) # 80002d34 <iunlockput>
  iunlockput(dp);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	2e0080e7          	jalr	736(ra) # 80002d34 <iunlockput>
  end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	ab8080e7          	jalr	-1352(ra) # 80003514 <end_op>
  return -1;
    80004a64:	557d                	li	a0,-1
}
    80004a66:	70ae                	ld	ra,232(sp)
    80004a68:	740e                	ld	s0,224(sp)
    80004a6a:	64ee                	ld	s1,216(sp)
    80004a6c:	694e                	ld	s2,208(sp)
    80004a6e:	69ae                	ld	s3,200(sp)
    80004a70:	616d                	addi	sp,sp,240
    80004a72:	8082                	ret

0000000080004a74 <sys_open>:

uint64
sys_open(void)
{
    80004a74:	7131                	addi	sp,sp,-192
    80004a76:	fd06                	sd	ra,184(sp)
    80004a78:	f922                	sd	s0,176(sp)
    80004a7a:	f526                	sd	s1,168(sp)
    80004a7c:	f14a                	sd	s2,160(sp)
    80004a7e:	ed4e                	sd	s3,152(sp)
    80004a80:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a82:	f4c40593          	addi	a1,s0,-180
    80004a86:	4505                	li	a0,1
    80004a88:	ffffd097          	auipc	ra,0xffffd
    80004a8c:	4de080e7          	jalr	1246(ra) # 80001f66 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a90:	08000613          	li	a2,128
    80004a94:	f5040593          	addi	a1,s0,-176
    80004a98:	4501                	li	a0,0
    80004a9a:	ffffd097          	auipc	ra,0xffffd
    80004a9e:	50c080e7          	jalr	1292(ra) # 80001fa6 <argstr>
    80004aa2:	87aa                	mv	a5,a0
    return -1;
    80004aa4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004aa6:	0a07c963          	bltz	a5,80004b58 <sys_open+0xe4>

  begin_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	9ea080e7          	jalr	-1558(ra) # 80003494 <begin_op>

  if(omode & O_CREATE){
    80004ab2:	f4c42783          	lw	a5,-180(s0)
    80004ab6:	2007f793          	andi	a5,a5,512
    80004aba:	cfc5                	beqz	a5,80004b72 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004abc:	4681                	li	a3,0
    80004abe:	4601                	li	a2,0
    80004ac0:	4589                	li	a1,2
    80004ac2:	f5040513          	addi	a0,s0,-176
    80004ac6:	00000097          	auipc	ra,0x0
    80004aca:	976080e7          	jalr	-1674(ra) # 8000443c <create>
    80004ace:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ad0:	c959                	beqz	a0,80004b66 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ad2:	04449703          	lh	a4,68(s1)
    80004ad6:	478d                	li	a5,3
    80004ad8:	00f71763          	bne	a4,a5,80004ae6 <sys_open+0x72>
    80004adc:	0464d703          	lhu	a4,70(s1)
    80004ae0:	47a5                	li	a5,9
    80004ae2:	0ce7ed63          	bltu	a5,a4,80004bbc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	dbe080e7          	jalr	-578(ra) # 800038a4 <filealloc>
    80004aee:	89aa                	mv	s3,a0
    80004af0:	10050363          	beqz	a0,80004bf6 <sys_open+0x182>
    80004af4:	00000097          	auipc	ra,0x0
    80004af8:	906080e7          	jalr	-1786(ra) # 800043fa <fdalloc>
    80004afc:	892a                	mv	s2,a0
    80004afe:	0e054763          	bltz	a0,80004bec <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b02:	04449703          	lh	a4,68(s1)
    80004b06:	478d                	li	a5,3
    80004b08:	0cf70563          	beq	a4,a5,80004bd2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b0c:	4789                	li	a5,2
    80004b0e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b12:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b16:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b1a:	f4c42783          	lw	a5,-180(s0)
    80004b1e:	0017c713          	xori	a4,a5,1
    80004b22:	8b05                	andi	a4,a4,1
    80004b24:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b28:	0037f713          	andi	a4,a5,3
    80004b2c:	00e03733          	snez	a4,a4
    80004b30:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b34:	4007f793          	andi	a5,a5,1024
    80004b38:	c791                	beqz	a5,80004b44 <sys_open+0xd0>
    80004b3a:	04449703          	lh	a4,68(s1)
    80004b3e:	4789                	li	a5,2
    80004b40:	0af70063          	beq	a4,a5,80004be0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	04e080e7          	jalr	78(ra) # 80002b94 <iunlock>
  end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	9c6080e7          	jalr	-1594(ra) # 80003514 <end_op>

  return fd;
    80004b56:	854a                	mv	a0,s2
}
    80004b58:	70ea                	ld	ra,184(sp)
    80004b5a:	744a                	ld	s0,176(sp)
    80004b5c:	74aa                	ld	s1,168(sp)
    80004b5e:	790a                	ld	s2,160(sp)
    80004b60:	69ea                	ld	s3,152(sp)
    80004b62:	6129                	addi	sp,sp,192
    80004b64:	8082                	ret
      end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	9ae080e7          	jalr	-1618(ra) # 80003514 <end_op>
      return -1;
    80004b6e:	557d                	li	a0,-1
    80004b70:	b7e5                	j	80004b58 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b72:	f5040513          	addi	a0,s0,-176
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	702080e7          	jalr	1794(ra) # 80003278 <namei>
    80004b7e:	84aa                	mv	s1,a0
    80004b80:	c905                	beqz	a0,80004bb0 <sys_open+0x13c>
    ilock(ip);
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	f50080e7          	jalr	-176(ra) # 80002ad2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b8a:	04449703          	lh	a4,68(s1)
    80004b8e:	4785                	li	a5,1
    80004b90:	f4f711e3          	bne	a4,a5,80004ad2 <sys_open+0x5e>
    80004b94:	f4c42783          	lw	a5,-180(s0)
    80004b98:	d7b9                	beqz	a5,80004ae6 <sys_open+0x72>
      iunlockput(ip);
    80004b9a:	8526                	mv	a0,s1
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	198080e7          	jalr	408(ra) # 80002d34 <iunlockput>
      end_op();
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	970080e7          	jalr	-1680(ra) # 80003514 <end_op>
      return -1;
    80004bac:	557d                	li	a0,-1
    80004bae:	b76d                	j	80004b58 <sys_open+0xe4>
      end_op();
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	964080e7          	jalr	-1692(ra) # 80003514 <end_op>
      return -1;
    80004bb8:	557d                	li	a0,-1
    80004bba:	bf79                	j	80004b58 <sys_open+0xe4>
    iunlockput(ip);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	176080e7          	jalr	374(ra) # 80002d34 <iunlockput>
    end_op();
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	94e080e7          	jalr	-1714(ra) # 80003514 <end_op>
    return -1;
    80004bce:	557d                	li	a0,-1
    80004bd0:	b761                	j	80004b58 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bd2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bd6:	04649783          	lh	a5,70(s1)
    80004bda:	02f99223          	sh	a5,36(s3)
    80004bde:	bf25                	j	80004b16 <sys_open+0xa2>
    itrunc(ip);
    80004be0:	8526                	mv	a0,s1
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	ffe080e7          	jalr	-2(ra) # 80002be0 <itrunc>
    80004bea:	bfa9                	j	80004b44 <sys_open+0xd0>
      fileclose(f);
    80004bec:	854e                	mv	a0,s3
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	d72080e7          	jalr	-654(ra) # 80003960 <fileclose>
    iunlockput(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	13c080e7          	jalr	316(ra) # 80002d34 <iunlockput>
    end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	914080e7          	jalr	-1772(ra) # 80003514 <end_op>
    return -1;
    80004c08:	557d                	li	a0,-1
    80004c0a:	b7b9                	j	80004b58 <sys_open+0xe4>

0000000080004c0c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c0c:	7175                	addi	sp,sp,-144
    80004c0e:	e506                	sd	ra,136(sp)
    80004c10:	e122                	sd	s0,128(sp)
    80004c12:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	880080e7          	jalr	-1920(ra) # 80003494 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c1c:	08000613          	li	a2,128
    80004c20:	f7040593          	addi	a1,s0,-144
    80004c24:	4501                	li	a0,0
    80004c26:	ffffd097          	auipc	ra,0xffffd
    80004c2a:	380080e7          	jalr	896(ra) # 80001fa6 <argstr>
    80004c2e:	02054963          	bltz	a0,80004c60 <sys_mkdir+0x54>
    80004c32:	4681                	li	a3,0
    80004c34:	4601                	li	a2,0
    80004c36:	4585                	li	a1,1
    80004c38:	f7040513          	addi	a0,s0,-144
    80004c3c:	00000097          	auipc	ra,0x0
    80004c40:	800080e7          	jalr	-2048(ra) # 8000443c <create>
    80004c44:	cd11                	beqz	a0,80004c60 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	0ee080e7          	jalr	238(ra) # 80002d34 <iunlockput>
  end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	8c6080e7          	jalr	-1850(ra) # 80003514 <end_op>
  return 0;
    80004c56:	4501                	li	a0,0
}
    80004c58:	60aa                	ld	ra,136(sp)
    80004c5a:	640a                	ld	s0,128(sp)
    80004c5c:	6149                	addi	sp,sp,144
    80004c5e:	8082                	ret
    end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	8b4080e7          	jalr	-1868(ra) # 80003514 <end_op>
    return -1;
    80004c68:	557d                	li	a0,-1
    80004c6a:	b7fd                	j	80004c58 <sys_mkdir+0x4c>

0000000080004c6c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c6c:	7135                	addi	sp,sp,-160
    80004c6e:	ed06                	sd	ra,152(sp)
    80004c70:	e922                	sd	s0,144(sp)
    80004c72:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	820080e7          	jalr	-2016(ra) # 80003494 <begin_op>
  argint(1, &major);
    80004c7c:	f6c40593          	addi	a1,s0,-148
    80004c80:	4505                	li	a0,1
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	2e4080e7          	jalr	740(ra) # 80001f66 <argint>
  argint(2, &minor);
    80004c8a:	f6840593          	addi	a1,s0,-152
    80004c8e:	4509                	li	a0,2
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	2d6080e7          	jalr	726(ra) # 80001f66 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c98:	08000613          	li	a2,128
    80004c9c:	f7040593          	addi	a1,s0,-144
    80004ca0:	4501                	li	a0,0
    80004ca2:	ffffd097          	auipc	ra,0xffffd
    80004ca6:	304080e7          	jalr	772(ra) # 80001fa6 <argstr>
    80004caa:	02054b63          	bltz	a0,80004ce0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cae:	f6841683          	lh	a3,-152(s0)
    80004cb2:	f6c41603          	lh	a2,-148(s0)
    80004cb6:	458d                	li	a1,3
    80004cb8:	f7040513          	addi	a0,s0,-144
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	780080e7          	jalr	1920(ra) # 8000443c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cc4:	cd11                	beqz	a0,80004ce0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	06e080e7          	jalr	110(ra) # 80002d34 <iunlockput>
  end_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	846080e7          	jalr	-1978(ra) # 80003514 <end_op>
  return 0;
    80004cd6:	4501                	li	a0,0
}
    80004cd8:	60ea                	ld	ra,152(sp)
    80004cda:	644a                	ld	s0,144(sp)
    80004cdc:	610d                	addi	sp,sp,160
    80004cde:	8082                	ret
    end_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	834080e7          	jalr	-1996(ra) # 80003514 <end_op>
    return -1;
    80004ce8:	557d                	li	a0,-1
    80004cea:	b7fd                	j	80004cd8 <sys_mknod+0x6c>

0000000080004cec <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cec:	7135                	addi	sp,sp,-160
    80004cee:	ed06                	sd	ra,152(sp)
    80004cf0:	e922                	sd	s0,144(sp)
    80004cf2:	e526                	sd	s1,136(sp)
    80004cf4:	e14a                	sd	s2,128(sp)
    80004cf6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	15a080e7          	jalr	346(ra) # 80000e52 <myproc>
    80004d00:	892a                	mv	s2,a0
  
  begin_op();
    80004d02:	ffffe097          	auipc	ra,0xffffe
    80004d06:	792080e7          	jalr	1938(ra) # 80003494 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d0a:	08000613          	li	a2,128
    80004d0e:	f6040593          	addi	a1,s0,-160
    80004d12:	4501                	li	a0,0
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	292080e7          	jalr	658(ra) # 80001fa6 <argstr>
    80004d1c:	04054b63          	bltz	a0,80004d72 <sys_chdir+0x86>
    80004d20:	f6040513          	addi	a0,s0,-160
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	554080e7          	jalr	1364(ra) # 80003278 <namei>
    80004d2c:	84aa                	mv	s1,a0
    80004d2e:	c131                	beqz	a0,80004d72 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	da2080e7          	jalr	-606(ra) # 80002ad2 <ilock>
  if(ip->type != T_DIR){
    80004d38:	04449703          	lh	a4,68(s1)
    80004d3c:	4785                	li	a5,1
    80004d3e:	04f71063          	bne	a4,a5,80004d7e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	e50080e7          	jalr	-432(ra) # 80002b94 <iunlock>
  iput(p->cwd);
    80004d4c:	15093503          	ld	a0,336(s2)
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	f3c080e7          	jalr	-196(ra) # 80002c8c <iput>
  end_op();
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	7bc080e7          	jalr	1980(ra) # 80003514 <end_op>
  p->cwd = ip;
    80004d60:	14993823          	sd	s1,336(s2)
  return 0;
    80004d64:	4501                	li	a0,0
}
    80004d66:	60ea                	ld	ra,152(sp)
    80004d68:	644a                	ld	s0,144(sp)
    80004d6a:	64aa                	ld	s1,136(sp)
    80004d6c:	690a                	ld	s2,128(sp)
    80004d6e:	610d                	addi	sp,sp,160
    80004d70:	8082                	ret
    end_op();
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	7a2080e7          	jalr	1954(ra) # 80003514 <end_op>
    return -1;
    80004d7a:	557d                	li	a0,-1
    80004d7c:	b7ed                	j	80004d66 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	fb4080e7          	jalr	-76(ra) # 80002d34 <iunlockput>
    end_op();
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	78c080e7          	jalr	1932(ra) # 80003514 <end_op>
    return -1;
    80004d90:	557d                	li	a0,-1
    80004d92:	bfd1                	j	80004d66 <sys_chdir+0x7a>

0000000080004d94 <sys_exec>:

uint64
sys_exec(void)
{
    80004d94:	7145                	addi	sp,sp,-464
    80004d96:	e786                	sd	ra,456(sp)
    80004d98:	e3a2                	sd	s0,448(sp)
    80004d9a:	ff26                	sd	s1,440(sp)
    80004d9c:	fb4a                	sd	s2,432(sp)
    80004d9e:	f74e                	sd	s3,424(sp)
    80004da0:	f352                	sd	s4,416(sp)
    80004da2:	ef56                	sd	s5,408(sp)
    80004da4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004da6:	e3840593          	addi	a1,s0,-456
    80004daa:	4505                	li	a0,1
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	1da080e7          	jalr	474(ra) # 80001f86 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004db4:	08000613          	li	a2,128
    80004db8:	f4040593          	addi	a1,s0,-192
    80004dbc:	4501                	li	a0,0
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	1e8080e7          	jalr	488(ra) # 80001fa6 <argstr>
    80004dc6:	87aa                	mv	a5,a0
    return -1;
    80004dc8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004dca:	0c07c263          	bltz	a5,80004e8e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004dce:	10000613          	li	a2,256
    80004dd2:	4581                	li	a1,0
    80004dd4:	e4040513          	addi	a0,s0,-448
    80004dd8:	ffffb097          	auipc	ra,0xffffb
    80004ddc:	3a0080e7          	jalr	928(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004de0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004de4:	89a6                	mv	s3,s1
    80004de6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004de8:	02000a13          	li	s4,32
    80004dec:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004df0:	00391793          	slli	a5,s2,0x3
    80004df4:	e3040593          	addi	a1,s0,-464
    80004df8:	e3843503          	ld	a0,-456(s0)
    80004dfc:	953e                	add	a0,a0,a5
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	0ca080e7          	jalr	202(ra) # 80001ec8 <fetchaddr>
    80004e06:	02054a63          	bltz	a0,80004e3a <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e0a:	e3043783          	ld	a5,-464(s0)
    80004e0e:	c3b9                	beqz	a5,80004e54 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e10:	ffffb097          	auipc	ra,0xffffb
    80004e14:	308080e7          	jalr	776(ra) # 80000118 <kalloc>
    80004e18:	85aa                	mv	a1,a0
    80004e1a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e1e:	cd11                	beqz	a0,80004e3a <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e20:	6605                	lui	a2,0x1
    80004e22:	e3043503          	ld	a0,-464(s0)
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	0f4080e7          	jalr	244(ra) # 80001f1a <fetchstr>
    80004e2e:	00054663          	bltz	a0,80004e3a <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e32:	0905                	addi	s2,s2,1
    80004e34:	09a1                	addi	s3,s3,8
    80004e36:	fb491be3          	bne	s2,s4,80004dec <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e3a:	10048913          	addi	s2,s1,256
    80004e3e:	6088                	ld	a0,0(s1)
    80004e40:	c531                	beqz	a0,80004e8c <sys_exec+0xf8>
    kfree(argv[i]);
    80004e42:	ffffb097          	auipc	ra,0xffffb
    80004e46:	1da080e7          	jalr	474(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e4a:	04a1                	addi	s1,s1,8
    80004e4c:	ff2499e3          	bne	s1,s2,80004e3e <sys_exec+0xaa>
  return -1;
    80004e50:	557d                	li	a0,-1
    80004e52:	a835                	j	80004e8e <sys_exec+0xfa>
      argv[i] = 0;
    80004e54:	0a8e                	slli	s5,s5,0x3
    80004e56:	fc040793          	addi	a5,s0,-64
    80004e5a:	9abe                	add	s5,s5,a5
    80004e5c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e60:	e4040593          	addi	a1,s0,-448
    80004e64:	f4040513          	addi	a0,s0,-192
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	172080e7          	jalr	370(ra) # 80003fda <exec>
    80004e70:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e72:	10048993          	addi	s3,s1,256
    80004e76:	6088                	ld	a0,0(s1)
    80004e78:	c901                	beqz	a0,80004e88 <sys_exec+0xf4>
    kfree(argv[i]);
    80004e7a:	ffffb097          	auipc	ra,0xffffb
    80004e7e:	1a2080e7          	jalr	418(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e82:	04a1                	addi	s1,s1,8
    80004e84:	ff3499e3          	bne	s1,s3,80004e76 <sys_exec+0xe2>
  return ret;
    80004e88:	854a                	mv	a0,s2
    80004e8a:	a011                	j	80004e8e <sys_exec+0xfa>
  return -1;
    80004e8c:	557d                	li	a0,-1
}
    80004e8e:	60be                	ld	ra,456(sp)
    80004e90:	641e                	ld	s0,448(sp)
    80004e92:	74fa                	ld	s1,440(sp)
    80004e94:	795a                	ld	s2,432(sp)
    80004e96:	79ba                	ld	s3,424(sp)
    80004e98:	7a1a                	ld	s4,416(sp)
    80004e9a:	6afa                	ld	s5,408(sp)
    80004e9c:	6179                	addi	sp,sp,464
    80004e9e:	8082                	ret

0000000080004ea0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ea0:	7139                	addi	sp,sp,-64
    80004ea2:	fc06                	sd	ra,56(sp)
    80004ea4:	f822                	sd	s0,48(sp)
    80004ea6:	f426                	sd	s1,40(sp)
    80004ea8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	fa8080e7          	jalr	-88(ra) # 80000e52 <myproc>
    80004eb2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004eb4:	fd840593          	addi	a1,s0,-40
    80004eb8:	4501                	li	a0,0
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	0cc080e7          	jalr	204(ra) # 80001f86 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ec2:	fc840593          	addi	a1,s0,-56
    80004ec6:	fd040513          	addi	a0,s0,-48
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	dc6080e7          	jalr	-570(ra) # 80003c90 <pipealloc>
    return -1;
    80004ed2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ed4:	0c054463          	bltz	a0,80004f9c <sys_pipe+0xfc>
  fd0 = -1;
    80004ed8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004edc:	fd043503          	ld	a0,-48(s0)
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	51a080e7          	jalr	1306(ra) # 800043fa <fdalloc>
    80004ee8:	fca42223          	sw	a0,-60(s0)
    80004eec:	08054b63          	bltz	a0,80004f82 <sys_pipe+0xe2>
    80004ef0:	fc843503          	ld	a0,-56(s0)
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	506080e7          	jalr	1286(ra) # 800043fa <fdalloc>
    80004efc:	fca42023          	sw	a0,-64(s0)
    80004f00:	06054863          	bltz	a0,80004f70 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f04:	4691                	li	a3,4
    80004f06:	fc440613          	addi	a2,s0,-60
    80004f0a:	fd843583          	ld	a1,-40(s0)
    80004f0e:	68a8                	ld	a0,80(s1)
    80004f10:	ffffc097          	auipc	ra,0xffffc
    80004f14:	bfe080e7          	jalr	-1026(ra) # 80000b0e <copyout>
    80004f18:	02054063          	bltz	a0,80004f38 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f1c:	4691                	li	a3,4
    80004f1e:	fc040613          	addi	a2,s0,-64
    80004f22:	fd843583          	ld	a1,-40(s0)
    80004f26:	0591                	addi	a1,a1,4
    80004f28:	68a8                	ld	a0,80(s1)
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	be4080e7          	jalr	-1052(ra) # 80000b0e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f32:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f34:	06055463          	bgez	a0,80004f9c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f38:	fc442783          	lw	a5,-60(s0)
    80004f3c:	07e9                	addi	a5,a5,26
    80004f3e:	078e                	slli	a5,a5,0x3
    80004f40:	97a6                	add	a5,a5,s1
    80004f42:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f46:	fc042503          	lw	a0,-64(s0)
    80004f4a:	0569                	addi	a0,a0,26
    80004f4c:	050e                	slli	a0,a0,0x3
    80004f4e:	94aa                	add	s1,s1,a0
    80004f50:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f54:	fd043503          	ld	a0,-48(s0)
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	a08080e7          	jalr	-1528(ra) # 80003960 <fileclose>
    fileclose(wf);
    80004f60:	fc843503          	ld	a0,-56(s0)
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	9fc080e7          	jalr	-1540(ra) # 80003960 <fileclose>
    return -1;
    80004f6c:	57fd                	li	a5,-1
    80004f6e:	a03d                	j	80004f9c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f70:	fc442783          	lw	a5,-60(s0)
    80004f74:	0007c763          	bltz	a5,80004f82 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f78:	07e9                	addi	a5,a5,26
    80004f7a:	078e                	slli	a5,a5,0x3
    80004f7c:	94be                	add	s1,s1,a5
    80004f7e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f82:	fd043503          	ld	a0,-48(s0)
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	9da080e7          	jalr	-1574(ra) # 80003960 <fileclose>
    fileclose(wf);
    80004f8e:	fc843503          	ld	a0,-56(s0)
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	9ce080e7          	jalr	-1586(ra) # 80003960 <fileclose>
    return -1;
    80004f9a:	57fd                	li	a5,-1
}
    80004f9c:	853e                	mv	a0,a5
    80004f9e:	70e2                	ld	ra,56(sp)
    80004fa0:	7442                	ld	s0,48(sp)
    80004fa2:	74a2                	ld	s1,40(sp)
    80004fa4:	6121                	addi	sp,sp,64
    80004fa6:	8082                	ret
	...

0000000080004fb0 <kernelvec>:
    80004fb0:	7111                	addi	sp,sp,-256
    80004fb2:	e006                	sd	ra,0(sp)
    80004fb4:	e40a                	sd	sp,8(sp)
    80004fb6:	e80e                	sd	gp,16(sp)
    80004fb8:	ec12                	sd	tp,24(sp)
    80004fba:	f016                	sd	t0,32(sp)
    80004fbc:	f41a                	sd	t1,40(sp)
    80004fbe:	f81e                	sd	t2,48(sp)
    80004fc0:	fc22                	sd	s0,56(sp)
    80004fc2:	e0a6                	sd	s1,64(sp)
    80004fc4:	e4aa                	sd	a0,72(sp)
    80004fc6:	e8ae                	sd	a1,80(sp)
    80004fc8:	ecb2                	sd	a2,88(sp)
    80004fca:	f0b6                	sd	a3,96(sp)
    80004fcc:	f4ba                	sd	a4,104(sp)
    80004fce:	f8be                	sd	a5,112(sp)
    80004fd0:	fcc2                	sd	a6,120(sp)
    80004fd2:	e146                	sd	a7,128(sp)
    80004fd4:	e54a                	sd	s2,136(sp)
    80004fd6:	e94e                	sd	s3,144(sp)
    80004fd8:	ed52                	sd	s4,152(sp)
    80004fda:	f156                	sd	s5,160(sp)
    80004fdc:	f55a                	sd	s6,168(sp)
    80004fde:	f95e                	sd	s7,176(sp)
    80004fe0:	fd62                	sd	s8,184(sp)
    80004fe2:	e1e6                	sd	s9,192(sp)
    80004fe4:	e5ea                	sd	s10,200(sp)
    80004fe6:	e9ee                	sd	s11,208(sp)
    80004fe8:	edf2                	sd	t3,216(sp)
    80004fea:	f1f6                	sd	t4,224(sp)
    80004fec:	f5fa                	sd	t5,232(sp)
    80004fee:	f9fe                	sd	t6,240(sp)
    80004ff0:	da5fc0ef          	jal	ra,80001d94 <kerneltrap>
    80004ff4:	6082                	ld	ra,0(sp)
    80004ff6:	6122                	ld	sp,8(sp)
    80004ff8:	61c2                	ld	gp,16(sp)
    80004ffa:	7282                	ld	t0,32(sp)
    80004ffc:	7322                	ld	t1,40(sp)
    80004ffe:	73c2                	ld	t2,48(sp)
    80005000:	7462                	ld	s0,56(sp)
    80005002:	6486                	ld	s1,64(sp)
    80005004:	6526                	ld	a0,72(sp)
    80005006:	65c6                	ld	a1,80(sp)
    80005008:	6666                	ld	a2,88(sp)
    8000500a:	7686                	ld	a3,96(sp)
    8000500c:	7726                	ld	a4,104(sp)
    8000500e:	77c6                	ld	a5,112(sp)
    80005010:	7866                	ld	a6,120(sp)
    80005012:	688a                	ld	a7,128(sp)
    80005014:	692a                	ld	s2,136(sp)
    80005016:	69ca                	ld	s3,144(sp)
    80005018:	6a6a                	ld	s4,152(sp)
    8000501a:	7a8a                	ld	s5,160(sp)
    8000501c:	7b2a                	ld	s6,168(sp)
    8000501e:	7bca                	ld	s7,176(sp)
    80005020:	7c6a                	ld	s8,184(sp)
    80005022:	6c8e                	ld	s9,192(sp)
    80005024:	6d2e                	ld	s10,200(sp)
    80005026:	6dce                	ld	s11,208(sp)
    80005028:	6e6e                	ld	t3,216(sp)
    8000502a:	7e8e                	ld	t4,224(sp)
    8000502c:	7f2e                	ld	t5,232(sp)
    8000502e:	7fce                	ld	t6,240(sp)
    80005030:	6111                	addi	sp,sp,256
    80005032:	10200073          	sret
    80005036:	00000013          	nop
    8000503a:	00000013          	nop
    8000503e:	0001                	nop

0000000080005040 <timervec>:
    80005040:	34051573          	csrrw	a0,mscratch,a0
    80005044:	e10c                	sd	a1,0(a0)
    80005046:	e510                	sd	a2,8(a0)
    80005048:	e914                	sd	a3,16(a0)
    8000504a:	6d0c                	ld	a1,24(a0)
    8000504c:	7110                	ld	a2,32(a0)
    8000504e:	6194                	ld	a3,0(a1)
    80005050:	96b2                	add	a3,a3,a2
    80005052:	e194                	sd	a3,0(a1)
    80005054:	4589                	li	a1,2
    80005056:	14459073          	csrw	sip,a1
    8000505a:	6914                	ld	a3,16(a0)
    8000505c:	6510                	ld	a2,8(a0)
    8000505e:	610c                	ld	a1,0(a0)
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	30200073          	mret
	...

000000008000506a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000506a:	1141                	addi	sp,sp,-16
    8000506c:	e422                	sd	s0,8(sp)
    8000506e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005070:	0c0007b7          	lui	a5,0xc000
    80005074:	4705                	li	a4,1
    80005076:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005078:	c3d8                	sw	a4,4(a5)
}
    8000507a:	6422                	ld	s0,8(sp)
    8000507c:	0141                	addi	sp,sp,16
    8000507e:	8082                	ret

0000000080005080 <plicinithart>:

void
plicinithart(void)
{
    80005080:	1141                	addi	sp,sp,-16
    80005082:	e406                	sd	ra,8(sp)
    80005084:	e022                	sd	s0,0(sp)
    80005086:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	d9e080e7          	jalr	-610(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005090:	0085171b          	slliw	a4,a0,0x8
    80005094:	0c0027b7          	lui	a5,0xc002
    80005098:	97ba                	add	a5,a5,a4
    8000509a:	40200713          	li	a4,1026
    8000509e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050a2:	00d5151b          	slliw	a0,a0,0xd
    800050a6:	0c2017b7          	lui	a5,0xc201
    800050aa:	953e                	add	a0,a0,a5
    800050ac:	00052023          	sw	zero,0(a0)
}
    800050b0:	60a2                	ld	ra,8(sp)
    800050b2:	6402                	ld	s0,0(sp)
    800050b4:	0141                	addi	sp,sp,16
    800050b6:	8082                	ret

00000000800050b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e406                	sd	ra,8(sp)
    800050bc:	e022                	sd	s0,0(sp)
    800050be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d66080e7          	jalr	-666(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050c8:	00d5179b          	slliw	a5,a0,0xd
    800050cc:	0c201537          	lui	a0,0xc201
    800050d0:	953e                	add	a0,a0,a5
  return irq;
}
    800050d2:	4148                	lw	a0,4(a0)
    800050d4:	60a2                	ld	ra,8(sp)
    800050d6:	6402                	ld	s0,0(sp)
    800050d8:	0141                	addi	sp,sp,16
    800050da:	8082                	ret

00000000800050dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050dc:	1101                	addi	sp,sp,-32
    800050de:	ec06                	sd	ra,24(sp)
    800050e0:	e822                	sd	s0,16(sp)
    800050e2:	e426                	sd	s1,8(sp)
    800050e4:	1000                	addi	s0,sp,32
    800050e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d3e080e7          	jalr	-706(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050f0:	00d5151b          	slliw	a0,a0,0xd
    800050f4:	0c2017b7          	lui	a5,0xc201
    800050f8:	97aa                	add	a5,a5,a0
    800050fa:	c3c4                	sw	s1,4(a5)
}
    800050fc:	60e2                	ld	ra,24(sp)
    800050fe:	6442                	ld	s0,16(sp)
    80005100:	64a2                	ld	s1,8(sp)
    80005102:	6105                	addi	sp,sp,32
    80005104:	8082                	ret

0000000080005106 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005106:	1141                	addi	sp,sp,-16
    80005108:	e406                	sd	ra,8(sp)
    8000510a:	e022                	sd	s0,0(sp)
    8000510c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000510e:	479d                	li	a5,7
    80005110:	04a7cc63          	blt	a5,a0,80005168 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005114:	00015797          	auipc	a5,0x15
    80005118:	89c78793          	addi	a5,a5,-1892 # 800199b0 <disk>
    8000511c:	97aa                	add	a5,a5,a0
    8000511e:	0187c783          	lbu	a5,24(a5)
    80005122:	ebb9                	bnez	a5,80005178 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005124:	00451613          	slli	a2,a0,0x4
    80005128:	00015797          	auipc	a5,0x15
    8000512c:	88878793          	addi	a5,a5,-1912 # 800199b0 <disk>
    80005130:	6394                	ld	a3,0(a5)
    80005132:	96b2                	add	a3,a3,a2
    80005134:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005138:	6398                	ld	a4,0(a5)
    8000513a:	9732                	add	a4,a4,a2
    8000513c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005140:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005144:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005148:	953e                	add	a0,a0,a5
    8000514a:	4785                	li	a5,1
    8000514c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005150:	00015517          	auipc	a0,0x15
    80005154:	87850513          	addi	a0,a0,-1928 # 800199c8 <disk+0x18>
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	406080e7          	jalr	1030(ra) # 8000155e <wakeup>
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret
    panic("free_desc 1");
    80005168:	00003517          	auipc	a0,0x3
    8000516c:	55850513          	addi	a0,a0,1368 # 800086c0 <syscalls+0x2f0>
    80005170:	00001097          	auipc	ra,0x1
    80005174:	a0e080e7          	jalr	-1522(ra) # 80005b7e <panic>
    panic("free_desc 2");
    80005178:	00003517          	auipc	a0,0x3
    8000517c:	55850513          	addi	a0,a0,1368 # 800086d0 <syscalls+0x300>
    80005180:	00001097          	auipc	ra,0x1
    80005184:	9fe080e7          	jalr	-1538(ra) # 80005b7e <panic>

0000000080005188 <virtio_disk_init>:
{
    80005188:	1101                	addi	sp,sp,-32
    8000518a:	ec06                	sd	ra,24(sp)
    8000518c:	e822                	sd	s0,16(sp)
    8000518e:	e426                	sd	s1,8(sp)
    80005190:	e04a                	sd	s2,0(sp)
    80005192:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005194:	00003597          	auipc	a1,0x3
    80005198:	54c58593          	addi	a1,a1,1356 # 800086e0 <syscalls+0x310>
    8000519c:	00015517          	auipc	a0,0x15
    800051a0:	93c50513          	addi	a0,a0,-1732 # 80019ad8 <disk+0x128>
    800051a4:	00001097          	auipc	ra,0x1
    800051a8:	e86080e7          	jalr	-378(ra) # 8000602a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051ac:	100017b7          	lui	a5,0x10001
    800051b0:	4398                	lw	a4,0(a5)
    800051b2:	2701                	sext.w	a4,a4
    800051b4:	747277b7          	lui	a5,0x74727
    800051b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051bc:	14f71c63          	bne	a4,a5,80005314 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051c0:	100017b7          	lui	a5,0x10001
    800051c4:	43dc                	lw	a5,4(a5)
    800051c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c8:	4709                	li	a4,2
    800051ca:	14e79563          	bne	a5,a4,80005314 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ce:	100017b7          	lui	a5,0x10001
    800051d2:	479c                	lw	a5,8(a5)
    800051d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d6:	12e79f63          	bne	a5,a4,80005314 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051da:	100017b7          	lui	a5,0x10001
    800051de:	47d8                	lw	a4,12(a5)
    800051e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e2:	554d47b7          	lui	a5,0x554d4
    800051e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051ea:	12f71563          	bne	a4,a5,80005314 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051f6:	4705                	li	a4,1
    800051f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051fa:	470d                	li	a4,3
    800051fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051fe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005200:	c7ffe737          	lui	a4,0xc7ffe
    80005204:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca2f>
    80005208:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000520a:	2701                	sext.w	a4,a4
    8000520c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	472d                	li	a4,11
    80005210:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005212:	5bbc                	lw	a5,112(a5)
    80005214:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005218:	8ba1                	andi	a5,a5,8
    8000521a:	10078563          	beqz	a5,80005324 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000521e:	100017b7          	lui	a5,0x10001
    80005222:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005226:	43fc                	lw	a5,68(a5)
    80005228:	2781                	sext.w	a5,a5
    8000522a:	10079563          	bnez	a5,80005334 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000522e:	100017b7          	lui	a5,0x10001
    80005232:	5bdc                	lw	a5,52(a5)
    80005234:	2781                	sext.w	a5,a5
  if(max == 0)
    80005236:	10078763          	beqz	a5,80005344 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000523a:	471d                	li	a4,7
    8000523c:	10f77c63          	bgeu	a4,a5,80005354 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005240:	ffffb097          	auipc	ra,0xffffb
    80005244:	ed8080e7          	jalr	-296(ra) # 80000118 <kalloc>
    80005248:	00014497          	auipc	s1,0x14
    8000524c:	76848493          	addi	s1,s1,1896 # 800199b0 <disk>
    80005250:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005252:	ffffb097          	auipc	ra,0xffffb
    80005256:	ec6080e7          	jalr	-314(ra) # 80000118 <kalloc>
    8000525a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000525c:	ffffb097          	auipc	ra,0xffffb
    80005260:	ebc080e7          	jalr	-324(ra) # 80000118 <kalloc>
    80005264:	87aa                	mv	a5,a0
    80005266:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005268:	6088                	ld	a0,0(s1)
    8000526a:	cd6d                	beqz	a0,80005364 <virtio_disk_init+0x1dc>
    8000526c:	00014717          	auipc	a4,0x14
    80005270:	74c73703          	ld	a4,1868(a4) # 800199b8 <disk+0x8>
    80005274:	cb65                	beqz	a4,80005364 <virtio_disk_init+0x1dc>
    80005276:	c7fd                	beqz	a5,80005364 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005278:	6605                	lui	a2,0x1
    8000527a:	4581                	li	a1,0
    8000527c:	ffffb097          	auipc	ra,0xffffb
    80005280:	efc080e7          	jalr	-260(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005284:	00014497          	auipc	s1,0x14
    80005288:	72c48493          	addi	s1,s1,1836 # 800199b0 <disk>
    8000528c:	6605                	lui	a2,0x1
    8000528e:	4581                	li	a1,0
    80005290:	6488                	ld	a0,8(s1)
    80005292:	ffffb097          	auipc	ra,0xffffb
    80005296:	ee6080e7          	jalr	-282(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000529a:	6605                	lui	a2,0x1
    8000529c:	4581                	li	a1,0
    8000529e:	6888                	ld	a0,16(s1)
    800052a0:	ffffb097          	auipc	ra,0xffffb
    800052a4:	ed8080e7          	jalr	-296(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052a8:	100017b7          	lui	a5,0x10001
    800052ac:	4721                	li	a4,8
    800052ae:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052b0:	4098                	lw	a4,0(s1)
    800052b2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052b6:	40d8                	lw	a4,4(s1)
    800052b8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052bc:	6498                	ld	a4,8(s1)
    800052be:	0007069b          	sext.w	a3,a4
    800052c2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052c6:	9701                	srai	a4,a4,0x20
    800052c8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052cc:	6898                	ld	a4,16(s1)
    800052ce:	0007069b          	sext.w	a3,a4
    800052d2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052d6:	9701                	srai	a4,a4,0x20
    800052d8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052dc:	4705                	li	a4,1
    800052de:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052e0:	00e48c23          	sb	a4,24(s1)
    800052e4:	00e48ca3          	sb	a4,25(s1)
    800052e8:	00e48d23          	sb	a4,26(s1)
    800052ec:	00e48da3          	sb	a4,27(s1)
    800052f0:	00e48e23          	sb	a4,28(s1)
    800052f4:	00e48ea3          	sb	a4,29(s1)
    800052f8:	00e48f23          	sb	a4,30(s1)
    800052fc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005300:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005304:	0727a823          	sw	s2,112(a5)
}
    80005308:	60e2                	ld	ra,24(sp)
    8000530a:	6442                	ld	s0,16(sp)
    8000530c:	64a2                	ld	s1,8(sp)
    8000530e:	6902                	ld	s2,0(sp)
    80005310:	6105                	addi	sp,sp,32
    80005312:	8082                	ret
    panic("could not find virtio disk");
    80005314:	00003517          	auipc	a0,0x3
    80005318:	3dc50513          	addi	a0,a0,988 # 800086f0 <syscalls+0x320>
    8000531c:	00001097          	auipc	ra,0x1
    80005320:	862080e7          	jalr	-1950(ra) # 80005b7e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005324:	00003517          	auipc	a0,0x3
    80005328:	3ec50513          	addi	a0,a0,1004 # 80008710 <syscalls+0x340>
    8000532c:	00001097          	auipc	ra,0x1
    80005330:	852080e7          	jalr	-1966(ra) # 80005b7e <panic>
    panic("virtio disk should not be ready");
    80005334:	00003517          	auipc	a0,0x3
    80005338:	3fc50513          	addi	a0,a0,1020 # 80008730 <syscalls+0x360>
    8000533c:	00001097          	auipc	ra,0x1
    80005340:	842080e7          	jalr	-1982(ra) # 80005b7e <panic>
    panic("virtio disk has no queue 0");
    80005344:	00003517          	auipc	a0,0x3
    80005348:	40c50513          	addi	a0,a0,1036 # 80008750 <syscalls+0x380>
    8000534c:	00001097          	auipc	ra,0x1
    80005350:	832080e7          	jalr	-1998(ra) # 80005b7e <panic>
    panic("virtio disk max queue too short");
    80005354:	00003517          	auipc	a0,0x3
    80005358:	41c50513          	addi	a0,a0,1052 # 80008770 <syscalls+0x3a0>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	822080e7          	jalr	-2014(ra) # 80005b7e <panic>
    panic("virtio disk kalloc");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	42c50513          	addi	a0,a0,1068 # 80008790 <syscalls+0x3c0>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	812080e7          	jalr	-2030(ra) # 80005b7e <panic>

0000000080005374 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005374:	7119                	addi	sp,sp,-128
    80005376:	fc86                	sd	ra,120(sp)
    80005378:	f8a2                	sd	s0,112(sp)
    8000537a:	f4a6                	sd	s1,104(sp)
    8000537c:	f0ca                	sd	s2,96(sp)
    8000537e:	ecce                	sd	s3,88(sp)
    80005380:	e8d2                	sd	s4,80(sp)
    80005382:	e4d6                	sd	s5,72(sp)
    80005384:	e0da                	sd	s6,64(sp)
    80005386:	fc5e                	sd	s7,56(sp)
    80005388:	f862                	sd	s8,48(sp)
    8000538a:	f466                	sd	s9,40(sp)
    8000538c:	f06a                	sd	s10,32(sp)
    8000538e:	ec6e                	sd	s11,24(sp)
    80005390:	0100                	addi	s0,sp,128
    80005392:	8aaa                	mv	s5,a0
    80005394:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005396:	00c52d03          	lw	s10,12(a0)
    8000539a:	001d1d1b          	slliw	s10,s10,0x1
    8000539e:	1d02                	slli	s10,s10,0x20
    800053a0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800053a4:	00014517          	auipc	a0,0x14
    800053a8:	73450513          	addi	a0,a0,1844 # 80019ad8 <disk+0x128>
    800053ac:	00001097          	auipc	ra,0x1
    800053b0:	d0e080e7          	jalr	-754(ra) # 800060ba <acquire>
  for(int i = 0; i < 3; i++){
    800053b4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053b6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053b8:	00014b97          	auipc	s7,0x14
    800053bc:	5f8b8b93          	addi	s7,s7,1528 # 800199b0 <disk>
  for(int i = 0; i < 3; i++){
    800053c0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053c2:	00014c97          	auipc	s9,0x14
    800053c6:	716c8c93          	addi	s9,s9,1814 # 80019ad8 <disk+0x128>
    800053ca:	a08d                	j	8000542c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800053cc:	00fb8733          	add	a4,s7,a5
    800053d0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053d4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053d6:	0207c563          	bltz	a5,80005400 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053da:	2905                	addiw	s2,s2,1
    800053dc:	0611                	addi	a2,a2,4
    800053de:	05690c63          	beq	s2,s6,80005436 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800053e2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053e4:	00014717          	auipc	a4,0x14
    800053e8:	5cc70713          	addi	a4,a4,1484 # 800199b0 <disk>
    800053ec:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053ee:	01874683          	lbu	a3,24(a4)
    800053f2:	fee9                	bnez	a3,800053cc <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800053f4:	2785                	addiw	a5,a5,1
    800053f6:	0705                	addi	a4,a4,1
    800053f8:	fe979be3          	bne	a5,s1,800053ee <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800053fc:	57fd                	li	a5,-1
    800053fe:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005400:	01205d63          	blez	s2,8000541a <virtio_disk_rw+0xa6>
    80005404:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005406:	000a2503          	lw	a0,0(s4)
    8000540a:	00000097          	auipc	ra,0x0
    8000540e:	cfc080e7          	jalr	-772(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    80005412:	2d85                	addiw	s11,s11,1
    80005414:	0a11                	addi	s4,s4,4
    80005416:	ffb918e3          	bne	s2,s11,80005406 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000541a:	85e6                	mv	a1,s9
    8000541c:	00014517          	auipc	a0,0x14
    80005420:	5ac50513          	addi	a0,a0,1452 # 800199c8 <disk+0x18>
    80005424:	ffffc097          	auipc	ra,0xffffc
    80005428:	0d6080e7          	jalr	214(ra) # 800014fa <sleep>
  for(int i = 0; i < 3; i++){
    8000542c:	f8040a13          	addi	s4,s0,-128
{
    80005430:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005432:	894e                	mv	s2,s3
    80005434:	b77d                	j	800053e2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005436:	f8042583          	lw	a1,-128(s0)
    8000543a:	00a58793          	addi	a5,a1,10
    8000543e:	0792                	slli	a5,a5,0x4

  if(write)
    80005440:	00014617          	auipc	a2,0x14
    80005444:	57060613          	addi	a2,a2,1392 # 800199b0 <disk>
    80005448:	00f60733          	add	a4,a2,a5
    8000544c:	018036b3          	snez	a3,s8
    80005450:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005452:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005456:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000545a:	f6078693          	addi	a3,a5,-160
    8000545e:	6218                	ld	a4,0(a2)
    80005460:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005462:	00878513          	addi	a0,a5,8
    80005466:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005468:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000546a:	6208                	ld	a0,0(a2)
    8000546c:	96aa                	add	a3,a3,a0
    8000546e:	4741                	li	a4,16
    80005470:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005472:	4705                	li	a4,1
    80005474:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005478:	f8442703          	lw	a4,-124(s0)
    8000547c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005480:	0712                	slli	a4,a4,0x4
    80005482:	953a                	add	a0,a0,a4
    80005484:	058a8693          	addi	a3,s5,88
    80005488:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000548a:	6208                	ld	a0,0(a2)
    8000548c:	972a                	add	a4,a4,a0
    8000548e:	40000693          	li	a3,1024
    80005492:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005494:	001c3c13          	seqz	s8,s8
    80005498:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000549a:	001c6c13          	ori	s8,s8,1
    8000549e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800054a2:	f8842603          	lw	a2,-120(s0)
    800054a6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054aa:	00014697          	auipc	a3,0x14
    800054ae:	50668693          	addi	a3,a3,1286 # 800199b0 <disk>
    800054b2:	00258713          	addi	a4,a1,2
    800054b6:	0712                	slli	a4,a4,0x4
    800054b8:	9736                	add	a4,a4,a3
    800054ba:	587d                	li	a6,-1
    800054bc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054c0:	0612                	slli	a2,a2,0x4
    800054c2:	9532                	add	a0,a0,a2
    800054c4:	f9078793          	addi	a5,a5,-112
    800054c8:	97b6                	add	a5,a5,a3
    800054ca:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800054cc:	629c                	ld	a5,0(a3)
    800054ce:	97b2                	add	a5,a5,a2
    800054d0:	4605                	li	a2,1
    800054d2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054d4:	4509                	li	a0,2
    800054d6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800054da:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054de:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054e2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054e6:	6698                	ld	a4,8(a3)
    800054e8:	00275783          	lhu	a5,2(a4)
    800054ec:	8b9d                	andi	a5,a5,7
    800054ee:	0786                	slli	a5,a5,0x1
    800054f0:	97ba                	add	a5,a5,a4
    800054f2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800054f6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054fa:	6698                	ld	a4,8(a3)
    800054fc:	00275783          	lhu	a5,2(a4)
    80005500:	2785                	addiw	a5,a5,1
    80005502:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005506:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000550a:	100017b7          	lui	a5,0x10001
    8000550e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005512:	004aa783          	lw	a5,4(s5)
    80005516:	02c79163          	bne	a5,a2,80005538 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000551a:	00014917          	auipc	s2,0x14
    8000551e:	5be90913          	addi	s2,s2,1470 # 80019ad8 <disk+0x128>
  while(b->disk == 1) {
    80005522:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005524:	85ca                	mv	a1,s2
    80005526:	8556                	mv	a0,s5
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	fd2080e7          	jalr	-46(ra) # 800014fa <sleep>
  while(b->disk == 1) {
    80005530:	004aa783          	lw	a5,4(s5)
    80005534:	fe9788e3          	beq	a5,s1,80005524 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005538:	f8042903          	lw	s2,-128(s0)
    8000553c:	00290793          	addi	a5,s2,2
    80005540:	00479713          	slli	a4,a5,0x4
    80005544:	00014797          	auipc	a5,0x14
    80005548:	46c78793          	addi	a5,a5,1132 # 800199b0 <disk>
    8000554c:	97ba                	add	a5,a5,a4
    8000554e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005552:	00014997          	auipc	s3,0x14
    80005556:	45e98993          	addi	s3,s3,1118 # 800199b0 <disk>
    8000555a:	00491713          	slli	a4,s2,0x4
    8000555e:	0009b783          	ld	a5,0(s3)
    80005562:	97ba                	add	a5,a5,a4
    80005564:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005568:	854a                	mv	a0,s2
    8000556a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000556e:	00000097          	auipc	ra,0x0
    80005572:	b98080e7          	jalr	-1128(ra) # 80005106 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005576:	8885                	andi	s1,s1,1
    80005578:	f0ed                	bnez	s1,8000555a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000557a:	00014517          	auipc	a0,0x14
    8000557e:	55e50513          	addi	a0,a0,1374 # 80019ad8 <disk+0x128>
    80005582:	00001097          	auipc	ra,0x1
    80005586:	bec080e7          	jalr	-1044(ra) # 8000616e <release>
}
    8000558a:	70e6                	ld	ra,120(sp)
    8000558c:	7446                	ld	s0,112(sp)
    8000558e:	74a6                	ld	s1,104(sp)
    80005590:	7906                	ld	s2,96(sp)
    80005592:	69e6                	ld	s3,88(sp)
    80005594:	6a46                	ld	s4,80(sp)
    80005596:	6aa6                	ld	s5,72(sp)
    80005598:	6b06                	ld	s6,64(sp)
    8000559a:	7be2                	ld	s7,56(sp)
    8000559c:	7c42                	ld	s8,48(sp)
    8000559e:	7ca2                	ld	s9,40(sp)
    800055a0:	7d02                	ld	s10,32(sp)
    800055a2:	6de2                	ld	s11,24(sp)
    800055a4:	6109                	addi	sp,sp,128
    800055a6:	8082                	ret

00000000800055a8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055a8:	1101                	addi	sp,sp,-32
    800055aa:	ec06                	sd	ra,24(sp)
    800055ac:	e822                	sd	s0,16(sp)
    800055ae:	e426                	sd	s1,8(sp)
    800055b0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055b2:	00014497          	auipc	s1,0x14
    800055b6:	3fe48493          	addi	s1,s1,1022 # 800199b0 <disk>
    800055ba:	00014517          	auipc	a0,0x14
    800055be:	51e50513          	addi	a0,a0,1310 # 80019ad8 <disk+0x128>
    800055c2:	00001097          	auipc	ra,0x1
    800055c6:	af8080e7          	jalr	-1288(ra) # 800060ba <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055ca:	10001737          	lui	a4,0x10001
    800055ce:	533c                	lw	a5,96(a4)
    800055d0:	8b8d                	andi	a5,a5,3
    800055d2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055d4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055d8:	689c                	ld	a5,16(s1)
    800055da:	0204d703          	lhu	a4,32(s1)
    800055de:	0027d783          	lhu	a5,2(a5)
    800055e2:	04f70863          	beq	a4,a5,80005632 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800055e6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055ea:	6898                	ld	a4,16(s1)
    800055ec:	0204d783          	lhu	a5,32(s1)
    800055f0:	8b9d                	andi	a5,a5,7
    800055f2:	078e                	slli	a5,a5,0x3
    800055f4:	97ba                	add	a5,a5,a4
    800055f6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055f8:	00278713          	addi	a4,a5,2
    800055fc:	0712                	slli	a4,a4,0x4
    800055fe:	9726                	add	a4,a4,s1
    80005600:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005604:	e721                	bnez	a4,8000564c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005606:	0789                	addi	a5,a5,2
    80005608:	0792                	slli	a5,a5,0x4
    8000560a:	97a6                	add	a5,a5,s1
    8000560c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000560e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005612:	ffffc097          	auipc	ra,0xffffc
    80005616:	f4c080e7          	jalr	-180(ra) # 8000155e <wakeup>

    disk.used_idx += 1;
    8000561a:	0204d783          	lhu	a5,32(s1)
    8000561e:	2785                	addiw	a5,a5,1
    80005620:	17c2                	slli	a5,a5,0x30
    80005622:	93c1                	srli	a5,a5,0x30
    80005624:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005628:	6898                	ld	a4,16(s1)
    8000562a:	00275703          	lhu	a4,2(a4)
    8000562e:	faf71ce3          	bne	a4,a5,800055e6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005632:	00014517          	auipc	a0,0x14
    80005636:	4a650513          	addi	a0,a0,1190 # 80019ad8 <disk+0x128>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	b34080e7          	jalr	-1228(ra) # 8000616e <release>
}
    80005642:	60e2                	ld	ra,24(sp)
    80005644:	6442                	ld	s0,16(sp)
    80005646:	64a2                	ld	s1,8(sp)
    80005648:	6105                	addi	sp,sp,32
    8000564a:	8082                	ret
      panic("virtio_disk_intr status");
    8000564c:	00003517          	auipc	a0,0x3
    80005650:	15c50513          	addi	a0,a0,348 # 800087a8 <syscalls+0x3d8>
    80005654:	00000097          	auipc	ra,0x0
    80005658:	52a080e7          	jalr	1322(ra) # 80005b7e <panic>

000000008000565c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000565c:	1141                	addi	sp,sp,-16
    8000565e:	e422                	sd	s0,8(sp)
    80005660:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005662:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005666:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000566a:	0037979b          	slliw	a5,a5,0x3
    8000566e:	02004737          	lui	a4,0x2004
    80005672:	97ba                	add	a5,a5,a4
    80005674:	0200c737          	lui	a4,0x200c
    80005678:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000567c:	000f4637          	lui	a2,0xf4
    80005680:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005684:	95b2                	add	a1,a1,a2
    80005686:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005688:	00269713          	slli	a4,a3,0x2
    8000568c:	9736                	add	a4,a4,a3
    8000568e:	00371693          	slli	a3,a4,0x3
    80005692:	00014717          	auipc	a4,0x14
    80005696:	45e70713          	addi	a4,a4,1118 # 80019af0 <timer_scratch>
    8000569a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000569c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000569e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056a0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056a4:	00000797          	auipc	a5,0x0
    800056a8:	99c78793          	addi	a5,a5,-1636 # 80005040 <timervec>
    800056ac:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056b0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056b4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056b8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056bc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056c0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056c4:	30479073          	csrw	mie,a5
}
    800056c8:	6422                	ld	s0,8(sp)
    800056ca:	0141                	addi	sp,sp,16
    800056cc:	8082                	ret

00000000800056ce <start>:
{
    800056ce:	1141                	addi	sp,sp,-16
    800056d0:	e406                	sd	ra,8(sp)
    800056d2:	e022                	sd	s0,0(sp)
    800056d4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056d6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056da:	7779                	lui	a4,0xffffe
    800056dc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcacf>
    800056e0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056e2:	6705                	lui	a4,0x1
    800056e4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056e8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056ea:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056ee:	ffffb797          	auipc	a5,0xffffb
    800056f2:	c3078793          	addi	a5,a5,-976 # 8000031e <main>
    800056f6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056fa:	4781                	li	a5,0
    800056fc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005700:	67c1                	lui	a5,0x10
    80005702:	17fd                	addi	a5,a5,-1
    80005704:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005708:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000570c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005710:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005714:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005718:	57fd                	li	a5,-1
    8000571a:	83a9                	srli	a5,a5,0xa
    8000571c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005720:	47bd                	li	a5,15
    80005722:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005726:	00000097          	auipc	ra,0x0
    8000572a:	f36080e7          	jalr	-202(ra) # 8000565c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000572e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005732:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005734:	823e                	mv	tp,a5
  asm volatile("mret");
    80005736:	30200073          	mret
}
    8000573a:	60a2                	ld	ra,8(sp)
    8000573c:	6402                	ld	s0,0(sp)
    8000573e:	0141                	addi	sp,sp,16
    80005740:	8082                	ret

0000000080005742 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005742:	715d                	addi	sp,sp,-80
    80005744:	e486                	sd	ra,72(sp)
    80005746:	e0a2                	sd	s0,64(sp)
    80005748:	fc26                	sd	s1,56(sp)
    8000574a:	f84a                	sd	s2,48(sp)
    8000574c:	f44e                	sd	s3,40(sp)
    8000574e:	f052                	sd	s4,32(sp)
    80005750:	ec56                	sd	s5,24(sp)
    80005752:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005754:	04c05663          	blez	a2,800057a0 <consolewrite+0x5e>
    80005758:	8a2a                	mv	s4,a0
    8000575a:	84ae                	mv	s1,a1
    8000575c:	89b2                	mv	s3,a2
    8000575e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005760:	5afd                	li	s5,-1
    80005762:	4685                	li	a3,1
    80005764:	8626                	mv	a2,s1
    80005766:	85d2                	mv	a1,s4
    80005768:	fbf40513          	addi	a0,s0,-65
    8000576c:	ffffc097          	auipc	ra,0xffffc
    80005770:	1ec080e7          	jalr	492(ra) # 80001958 <either_copyin>
    80005774:	01550c63          	beq	a0,s5,8000578c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005778:	fbf44503          	lbu	a0,-65(s0)
    8000577c:	00000097          	auipc	ra,0x0
    80005780:	780080e7          	jalr	1920(ra) # 80005efc <uartputc>
  for(i = 0; i < n; i++){
    80005784:	2905                	addiw	s2,s2,1
    80005786:	0485                	addi	s1,s1,1
    80005788:	fd299de3          	bne	s3,s2,80005762 <consolewrite+0x20>
  }

  return i;
}
    8000578c:	854a                	mv	a0,s2
    8000578e:	60a6                	ld	ra,72(sp)
    80005790:	6406                	ld	s0,64(sp)
    80005792:	74e2                	ld	s1,56(sp)
    80005794:	7942                	ld	s2,48(sp)
    80005796:	79a2                	ld	s3,40(sp)
    80005798:	7a02                	ld	s4,32(sp)
    8000579a:	6ae2                	ld	s5,24(sp)
    8000579c:	6161                	addi	sp,sp,80
    8000579e:	8082                	ret
  for(i = 0; i < n; i++){
    800057a0:	4901                	li	s2,0
    800057a2:	b7ed                	j	8000578c <consolewrite+0x4a>

00000000800057a4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057a4:	7159                	addi	sp,sp,-112
    800057a6:	f486                	sd	ra,104(sp)
    800057a8:	f0a2                	sd	s0,96(sp)
    800057aa:	eca6                	sd	s1,88(sp)
    800057ac:	e8ca                	sd	s2,80(sp)
    800057ae:	e4ce                	sd	s3,72(sp)
    800057b0:	e0d2                	sd	s4,64(sp)
    800057b2:	fc56                	sd	s5,56(sp)
    800057b4:	f85a                	sd	s6,48(sp)
    800057b6:	f45e                	sd	s7,40(sp)
    800057b8:	f062                	sd	s8,32(sp)
    800057ba:	ec66                	sd	s9,24(sp)
    800057bc:	e86a                	sd	s10,16(sp)
    800057be:	1880                	addi	s0,sp,112
    800057c0:	8aaa                	mv	s5,a0
    800057c2:	8a2e                	mv	s4,a1
    800057c4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057c6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057ca:	0001c517          	auipc	a0,0x1c
    800057ce:	46650513          	addi	a0,a0,1126 # 80021c30 <cons>
    800057d2:	00001097          	auipc	ra,0x1
    800057d6:	8e8080e7          	jalr	-1816(ra) # 800060ba <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057da:	0001c497          	auipc	s1,0x1c
    800057de:	45648493          	addi	s1,s1,1110 # 80021c30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057e2:	0001c917          	auipc	s2,0x1c
    800057e6:	4e690913          	addi	s2,s2,1254 # 80021cc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800057ea:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057ec:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800057ee:	4ca9                	li	s9,10
  while(n > 0){
    800057f0:	07305b63          	blez	s3,80005866 <consoleread+0xc2>
    while(cons.r == cons.w){
    800057f4:	0984a783          	lw	a5,152(s1)
    800057f8:	09c4a703          	lw	a4,156(s1)
    800057fc:	02f71763          	bne	a4,a5,8000582a <consoleread+0x86>
      if(killed(myproc())){
    80005800:	ffffb097          	auipc	ra,0xffffb
    80005804:	652080e7          	jalr	1618(ra) # 80000e52 <myproc>
    80005808:	ffffc097          	auipc	ra,0xffffc
    8000580c:	f9a080e7          	jalr	-102(ra) # 800017a2 <killed>
    80005810:	e535                	bnez	a0,8000587c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005812:	85a6                	mv	a1,s1
    80005814:	854a                	mv	a0,s2
    80005816:	ffffc097          	auipc	ra,0xffffc
    8000581a:	ce4080e7          	jalr	-796(ra) # 800014fa <sleep>
    while(cons.r == cons.w){
    8000581e:	0984a783          	lw	a5,152(s1)
    80005822:	09c4a703          	lw	a4,156(s1)
    80005826:	fcf70de3          	beq	a4,a5,80005800 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000582a:	0017871b          	addiw	a4,a5,1
    8000582e:	08e4ac23          	sw	a4,152(s1)
    80005832:	07f7f713          	andi	a4,a5,127
    80005836:	9726                	add	a4,a4,s1
    80005838:	01874703          	lbu	a4,24(a4)
    8000583c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005840:	077d0563          	beq	s10,s7,800058aa <consoleread+0x106>
    cbuf = c;
    80005844:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005848:	4685                	li	a3,1
    8000584a:	f9f40613          	addi	a2,s0,-97
    8000584e:	85d2                	mv	a1,s4
    80005850:	8556                	mv	a0,s5
    80005852:	ffffc097          	auipc	ra,0xffffc
    80005856:	0b0080e7          	jalr	176(ra) # 80001902 <either_copyout>
    8000585a:	01850663          	beq	a0,s8,80005866 <consoleread+0xc2>
    dst++;
    8000585e:	0a05                	addi	s4,s4,1
    --n;
    80005860:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005862:	f99d17e3          	bne	s10,s9,800057f0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005866:	0001c517          	auipc	a0,0x1c
    8000586a:	3ca50513          	addi	a0,a0,970 # 80021c30 <cons>
    8000586e:	00001097          	auipc	ra,0x1
    80005872:	900080e7          	jalr	-1792(ra) # 8000616e <release>

  return target - n;
    80005876:	413b053b          	subw	a0,s6,s3
    8000587a:	a811                	j	8000588e <consoleread+0xea>
        release(&cons.lock);
    8000587c:	0001c517          	auipc	a0,0x1c
    80005880:	3b450513          	addi	a0,a0,948 # 80021c30 <cons>
    80005884:	00001097          	auipc	ra,0x1
    80005888:	8ea080e7          	jalr	-1814(ra) # 8000616e <release>
        return -1;
    8000588c:	557d                	li	a0,-1
}
    8000588e:	70a6                	ld	ra,104(sp)
    80005890:	7406                	ld	s0,96(sp)
    80005892:	64e6                	ld	s1,88(sp)
    80005894:	6946                	ld	s2,80(sp)
    80005896:	69a6                	ld	s3,72(sp)
    80005898:	6a06                	ld	s4,64(sp)
    8000589a:	7ae2                	ld	s5,56(sp)
    8000589c:	7b42                	ld	s6,48(sp)
    8000589e:	7ba2                	ld	s7,40(sp)
    800058a0:	7c02                	ld	s8,32(sp)
    800058a2:	6ce2                	ld	s9,24(sp)
    800058a4:	6d42                	ld	s10,16(sp)
    800058a6:	6165                	addi	sp,sp,112
    800058a8:	8082                	ret
      if(n < target){
    800058aa:	0009871b          	sext.w	a4,s3
    800058ae:	fb677ce3          	bgeu	a4,s6,80005866 <consoleread+0xc2>
        cons.r--;
    800058b2:	0001c717          	auipc	a4,0x1c
    800058b6:	40f72b23          	sw	a5,1046(a4) # 80021cc8 <cons+0x98>
    800058ba:	b775                	j	80005866 <consoleread+0xc2>

00000000800058bc <consputc>:
{
    800058bc:	1141                	addi	sp,sp,-16
    800058be:	e406                	sd	ra,8(sp)
    800058c0:	e022                	sd	s0,0(sp)
    800058c2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058c4:	10000793          	li	a5,256
    800058c8:	00f50a63          	beq	a0,a5,800058dc <consputc+0x20>
    uartputc_sync(c);
    800058cc:	00000097          	auipc	ra,0x0
    800058d0:	55e080e7          	jalr	1374(ra) # 80005e2a <uartputc_sync>
}
    800058d4:	60a2                	ld	ra,8(sp)
    800058d6:	6402                	ld	s0,0(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058dc:	4521                	li	a0,8
    800058de:	00000097          	auipc	ra,0x0
    800058e2:	54c080e7          	jalr	1356(ra) # 80005e2a <uartputc_sync>
    800058e6:	02000513          	li	a0,32
    800058ea:	00000097          	auipc	ra,0x0
    800058ee:	540080e7          	jalr	1344(ra) # 80005e2a <uartputc_sync>
    800058f2:	4521                	li	a0,8
    800058f4:	00000097          	auipc	ra,0x0
    800058f8:	536080e7          	jalr	1334(ra) # 80005e2a <uartputc_sync>
    800058fc:	bfe1                	j	800058d4 <consputc+0x18>

00000000800058fe <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058fe:	1101                	addi	sp,sp,-32
    80005900:	ec06                	sd	ra,24(sp)
    80005902:	e822                	sd	s0,16(sp)
    80005904:	e426                	sd	s1,8(sp)
    80005906:	e04a                	sd	s2,0(sp)
    80005908:	1000                	addi	s0,sp,32
    8000590a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000590c:	0001c517          	auipc	a0,0x1c
    80005910:	32450513          	addi	a0,a0,804 # 80021c30 <cons>
    80005914:	00000097          	auipc	ra,0x0
    80005918:	7a6080e7          	jalr	1958(ra) # 800060ba <acquire>

  switch(c){
    8000591c:	47d5                	li	a5,21
    8000591e:	0af48663          	beq	s1,a5,800059ca <consoleintr+0xcc>
    80005922:	0297ca63          	blt	a5,s1,80005956 <consoleintr+0x58>
    80005926:	47a1                	li	a5,8
    80005928:	0ef48763          	beq	s1,a5,80005a16 <consoleintr+0x118>
    8000592c:	47c1                	li	a5,16
    8000592e:	10f49a63          	bne	s1,a5,80005a42 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	07c080e7          	jalr	124(ra) # 800019ae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000593a:	0001c517          	auipc	a0,0x1c
    8000593e:	2f650513          	addi	a0,a0,758 # 80021c30 <cons>
    80005942:	00001097          	auipc	ra,0x1
    80005946:	82c080e7          	jalr	-2004(ra) # 8000616e <release>
}
    8000594a:	60e2                	ld	ra,24(sp)
    8000594c:	6442                	ld	s0,16(sp)
    8000594e:	64a2                	ld	s1,8(sp)
    80005950:	6902                	ld	s2,0(sp)
    80005952:	6105                	addi	sp,sp,32
    80005954:	8082                	ret
  switch(c){
    80005956:	07f00793          	li	a5,127
    8000595a:	0af48e63          	beq	s1,a5,80005a16 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000595e:	0001c717          	auipc	a4,0x1c
    80005962:	2d270713          	addi	a4,a4,722 # 80021c30 <cons>
    80005966:	0a072783          	lw	a5,160(a4)
    8000596a:	09872703          	lw	a4,152(a4)
    8000596e:	9f99                	subw	a5,a5,a4
    80005970:	07f00713          	li	a4,127
    80005974:	fcf763e3          	bltu	a4,a5,8000593a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005978:	47b5                	li	a5,13
    8000597a:	0cf48763          	beq	s1,a5,80005a48 <consoleintr+0x14a>
      consputc(c);
    8000597e:	8526                	mv	a0,s1
    80005980:	00000097          	auipc	ra,0x0
    80005984:	f3c080e7          	jalr	-196(ra) # 800058bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005988:	0001c797          	auipc	a5,0x1c
    8000598c:	2a878793          	addi	a5,a5,680 # 80021c30 <cons>
    80005990:	0a07a683          	lw	a3,160(a5)
    80005994:	0016871b          	addiw	a4,a3,1
    80005998:	0007061b          	sext.w	a2,a4
    8000599c:	0ae7a023          	sw	a4,160(a5)
    800059a0:	07f6f693          	andi	a3,a3,127
    800059a4:	97b6                	add	a5,a5,a3
    800059a6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059aa:	47a9                	li	a5,10
    800059ac:	0cf48563          	beq	s1,a5,80005a76 <consoleintr+0x178>
    800059b0:	4791                	li	a5,4
    800059b2:	0cf48263          	beq	s1,a5,80005a76 <consoleintr+0x178>
    800059b6:	0001c797          	auipc	a5,0x1c
    800059ba:	3127a783          	lw	a5,786(a5) # 80021cc8 <cons+0x98>
    800059be:	9f1d                	subw	a4,a4,a5
    800059c0:	08000793          	li	a5,128
    800059c4:	f6f71be3          	bne	a4,a5,8000593a <consoleintr+0x3c>
    800059c8:	a07d                	j	80005a76 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059ca:	0001c717          	auipc	a4,0x1c
    800059ce:	26670713          	addi	a4,a4,614 # 80021c30 <cons>
    800059d2:	0a072783          	lw	a5,160(a4)
    800059d6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059da:	0001c497          	auipc	s1,0x1c
    800059de:	25648493          	addi	s1,s1,598 # 80021c30 <cons>
    while(cons.e != cons.w &&
    800059e2:	4929                	li	s2,10
    800059e4:	f4f70be3          	beq	a4,a5,8000593a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059e8:	37fd                	addiw	a5,a5,-1
    800059ea:	07f7f713          	andi	a4,a5,127
    800059ee:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059f0:	01874703          	lbu	a4,24(a4)
    800059f4:	f52703e3          	beq	a4,s2,8000593a <consoleintr+0x3c>
      cons.e--;
    800059f8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059fc:	10000513          	li	a0,256
    80005a00:	00000097          	auipc	ra,0x0
    80005a04:	ebc080e7          	jalr	-324(ra) # 800058bc <consputc>
    while(cons.e != cons.w &&
    80005a08:	0a04a783          	lw	a5,160(s1)
    80005a0c:	09c4a703          	lw	a4,156(s1)
    80005a10:	fcf71ce3          	bne	a4,a5,800059e8 <consoleintr+0xea>
    80005a14:	b71d                	j	8000593a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a16:	0001c717          	auipc	a4,0x1c
    80005a1a:	21a70713          	addi	a4,a4,538 # 80021c30 <cons>
    80005a1e:	0a072783          	lw	a5,160(a4)
    80005a22:	09c72703          	lw	a4,156(a4)
    80005a26:	f0f70ae3          	beq	a4,a5,8000593a <consoleintr+0x3c>
      cons.e--;
    80005a2a:	37fd                	addiw	a5,a5,-1
    80005a2c:	0001c717          	auipc	a4,0x1c
    80005a30:	2af72223          	sw	a5,676(a4) # 80021cd0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a34:	10000513          	li	a0,256
    80005a38:	00000097          	auipc	ra,0x0
    80005a3c:	e84080e7          	jalr	-380(ra) # 800058bc <consputc>
    80005a40:	bded                	j	8000593a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a42:	ee048ce3          	beqz	s1,8000593a <consoleintr+0x3c>
    80005a46:	bf21                	j	8000595e <consoleintr+0x60>
      consputc(c);
    80005a48:	4529                	li	a0,10
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	e72080e7          	jalr	-398(ra) # 800058bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a52:	0001c797          	auipc	a5,0x1c
    80005a56:	1de78793          	addi	a5,a5,478 # 80021c30 <cons>
    80005a5a:	0a07a703          	lw	a4,160(a5)
    80005a5e:	0017069b          	addiw	a3,a4,1
    80005a62:	0006861b          	sext.w	a2,a3
    80005a66:	0ad7a023          	sw	a3,160(a5)
    80005a6a:	07f77713          	andi	a4,a4,127
    80005a6e:	97ba                	add	a5,a5,a4
    80005a70:	4729                	li	a4,10
    80005a72:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a76:	0001c797          	auipc	a5,0x1c
    80005a7a:	24c7ab23          	sw	a2,598(a5) # 80021ccc <cons+0x9c>
        wakeup(&cons.r);
    80005a7e:	0001c517          	auipc	a0,0x1c
    80005a82:	24a50513          	addi	a0,a0,586 # 80021cc8 <cons+0x98>
    80005a86:	ffffc097          	auipc	ra,0xffffc
    80005a8a:	ad8080e7          	jalr	-1320(ra) # 8000155e <wakeup>
    80005a8e:	b575                	j	8000593a <consoleintr+0x3c>

0000000080005a90 <consoleinit>:

void
consoleinit(void)
{
    80005a90:	1141                	addi	sp,sp,-16
    80005a92:	e406                	sd	ra,8(sp)
    80005a94:	e022                	sd	s0,0(sp)
    80005a96:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a98:	00003597          	auipc	a1,0x3
    80005a9c:	d2858593          	addi	a1,a1,-728 # 800087c0 <syscalls+0x3f0>
    80005aa0:	0001c517          	auipc	a0,0x1c
    80005aa4:	19050513          	addi	a0,a0,400 # 80021c30 <cons>
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	582080e7          	jalr	1410(ra) # 8000602a <initlock>

  uartinit();
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	32a080e7          	jalr	810(ra) # 80005dda <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ab8:	00013797          	auipc	a5,0x13
    80005abc:	ea078793          	addi	a5,a5,-352 # 80018958 <devsw>
    80005ac0:	00000717          	auipc	a4,0x0
    80005ac4:	ce470713          	addi	a4,a4,-796 # 800057a4 <consoleread>
    80005ac8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005aca:	00000717          	auipc	a4,0x0
    80005ace:	c7870713          	addi	a4,a4,-904 # 80005742 <consolewrite>
    80005ad2:	ef98                	sd	a4,24(a5)
}
    80005ad4:	60a2                	ld	ra,8(sp)
    80005ad6:	6402                	ld	s0,0(sp)
    80005ad8:	0141                	addi	sp,sp,16
    80005ada:	8082                	ret

0000000080005adc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005adc:	7179                	addi	sp,sp,-48
    80005ade:	f406                	sd	ra,40(sp)
    80005ae0:	f022                	sd	s0,32(sp)
    80005ae2:	ec26                	sd	s1,24(sp)
    80005ae4:	e84a                	sd	s2,16(sp)
    80005ae6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ae8:	c219                	beqz	a2,80005aee <printint+0x12>
    80005aea:	08054663          	bltz	a0,80005b76 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005aee:	2501                	sext.w	a0,a0
    80005af0:	4881                	li	a7,0
    80005af2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005af6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005af8:	2581                	sext.w	a1,a1
    80005afa:	00003617          	auipc	a2,0x3
    80005afe:	cf660613          	addi	a2,a2,-778 # 800087f0 <digits>
    80005b02:	883a                	mv	a6,a4
    80005b04:	2705                	addiw	a4,a4,1
    80005b06:	02b577bb          	remuw	a5,a0,a1
    80005b0a:	1782                	slli	a5,a5,0x20
    80005b0c:	9381                	srli	a5,a5,0x20
    80005b0e:	97b2                	add	a5,a5,a2
    80005b10:	0007c783          	lbu	a5,0(a5)
    80005b14:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b18:	0005079b          	sext.w	a5,a0
    80005b1c:	02b5553b          	divuw	a0,a0,a1
    80005b20:	0685                	addi	a3,a3,1
    80005b22:	feb7f0e3          	bgeu	a5,a1,80005b02 <printint+0x26>

  if(sign)
    80005b26:	00088b63          	beqz	a7,80005b3c <printint+0x60>
    buf[i++] = '-';
    80005b2a:	fe040793          	addi	a5,s0,-32
    80005b2e:	973e                	add	a4,a4,a5
    80005b30:	02d00793          	li	a5,45
    80005b34:	fef70823          	sb	a5,-16(a4)
    80005b38:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b3c:	02e05763          	blez	a4,80005b6a <printint+0x8e>
    80005b40:	fd040793          	addi	a5,s0,-48
    80005b44:	00e784b3          	add	s1,a5,a4
    80005b48:	fff78913          	addi	s2,a5,-1
    80005b4c:	993a                	add	s2,s2,a4
    80005b4e:	377d                	addiw	a4,a4,-1
    80005b50:	1702                	slli	a4,a4,0x20
    80005b52:	9301                	srli	a4,a4,0x20
    80005b54:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b58:	fff4c503          	lbu	a0,-1(s1)
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	d60080e7          	jalr	-672(ra) # 800058bc <consputc>
  while(--i >= 0)
    80005b64:	14fd                	addi	s1,s1,-1
    80005b66:	ff2499e3          	bne	s1,s2,80005b58 <printint+0x7c>
}
    80005b6a:	70a2                	ld	ra,40(sp)
    80005b6c:	7402                	ld	s0,32(sp)
    80005b6e:	64e2                	ld	s1,24(sp)
    80005b70:	6942                	ld	s2,16(sp)
    80005b72:	6145                	addi	sp,sp,48
    80005b74:	8082                	ret
    x = -xx;
    80005b76:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b7a:	4885                	li	a7,1
    x = -xx;
    80005b7c:	bf9d                	j	80005af2 <printint+0x16>

0000000080005b7e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b7e:	1101                	addi	sp,sp,-32
    80005b80:	ec06                	sd	ra,24(sp)
    80005b82:	e822                	sd	s0,16(sp)
    80005b84:	e426                	sd	s1,8(sp)
    80005b86:	1000                	addi	s0,sp,32
    80005b88:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b8a:	0001c797          	auipc	a5,0x1c
    80005b8e:	1607a323          	sw	zero,358(a5) # 80021cf0 <pr+0x18>
  printf("panic: ");
    80005b92:	00003517          	auipc	a0,0x3
    80005b96:	c3650513          	addi	a0,a0,-970 # 800087c8 <syscalls+0x3f8>
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	02e080e7          	jalr	46(ra) # 80005bc8 <printf>
  printf(s);
    80005ba2:	8526                	mv	a0,s1
    80005ba4:	00000097          	auipc	ra,0x0
    80005ba8:	024080e7          	jalr	36(ra) # 80005bc8 <printf>
  printf("\n");
    80005bac:	00002517          	auipc	a0,0x2
    80005bb0:	49c50513          	addi	a0,a0,1180 # 80008048 <etext+0x48>
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	014080e7          	jalr	20(ra) # 80005bc8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bbc:	4785                	li	a5,1
    80005bbe:	00003717          	auipc	a4,0x3
    80005bc2:	cef72723          	sw	a5,-786(a4) # 800088ac <panicked>
  for(;;)
    80005bc6:	a001                	j	80005bc6 <panic+0x48>

0000000080005bc8 <printf>:
{
    80005bc8:	7131                	addi	sp,sp,-192
    80005bca:	fc86                	sd	ra,120(sp)
    80005bcc:	f8a2                	sd	s0,112(sp)
    80005bce:	f4a6                	sd	s1,104(sp)
    80005bd0:	f0ca                	sd	s2,96(sp)
    80005bd2:	ecce                	sd	s3,88(sp)
    80005bd4:	e8d2                	sd	s4,80(sp)
    80005bd6:	e4d6                	sd	s5,72(sp)
    80005bd8:	e0da                	sd	s6,64(sp)
    80005bda:	fc5e                	sd	s7,56(sp)
    80005bdc:	f862                	sd	s8,48(sp)
    80005bde:	f466                	sd	s9,40(sp)
    80005be0:	f06a                	sd	s10,32(sp)
    80005be2:	ec6e                	sd	s11,24(sp)
    80005be4:	0100                	addi	s0,sp,128
    80005be6:	8a2a                	mv	s4,a0
    80005be8:	e40c                	sd	a1,8(s0)
    80005bea:	e810                	sd	a2,16(s0)
    80005bec:	ec14                	sd	a3,24(s0)
    80005bee:	f018                	sd	a4,32(s0)
    80005bf0:	f41c                	sd	a5,40(s0)
    80005bf2:	03043823          	sd	a6,48(s0)
    80005bf6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005bfa:	0001cd97          	auipc	s11,0x1c
    80005bfe:	0f6dad83          	lw	s11,246(s11) # 80021cf0 <pr+0x18>
  if(locking)
    80005c02:	020d9b63          	bnez	s11,80005c38 <printf+0x70>
  if (fmt == 0)
    80005c06:	040a0263          	beqz	s4,80005c4a <printf+0x82>
  va_start(ap, fmt);
    80005c0a:	00840793          	addi	a5,s0,8
    80005c0e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c12:	000a4503          	lbu	a0,0(s4)
    80005c16:	14050f63          	beqz	a0,80005d74 <printf+0x1ac>
    80005c1a:	4981                	li	s3,0
    if(c != '%'){
    80005c1c:	02500a93          	li	s5,37
    switch(c){
    80005c20:	07000b93          	li	s7,112
  consputc('x');
    80005c24:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c26:	00003b17          	auipc	s6,0x3
    80005c2a:	bcab0b13          	addi	s6,s6,-1078 # 800087f0 <digits>
    switch(c){
    80005c2e:	07300c93          	li	s9,115
    80005c32:	06400c13          	li	s8,100
    80005c36:	a82d                	j	80005c70 <printf+0xa8>
    acquire(&pr.lock);
    80005c38:	0001c517          	auipc	a0,0x1c
    80005c3c:	0a050513          	addi	a0,a0,160 # 80021cd8 <pr>
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	47a080e7          	jalr	1146(ra) # 800060ba <acquire>
    80005c48:	bf7d                	j	80005c06 <printf+0x3e>
    panic("null fmt");
    80005c4a:	00003517          	auipc	a0,0x3
    80005c4e:	b8e50513          	addi	a0,a0,-1138 # 800087d8 <syscalls+0x408>
    80005c52:	00000097          	auipc	ra,0x0
    80005c56:	f2c080e7          	jalr	-212(ra) # 80005b7e <panic>
      consputc(c);
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	c62080e7          	jalr	-926(ra) # 800058bc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c62:	2985                	addiw	s3,s3,1
    80005c64:	013a07b3          	add	a5,s4,s3
    80005c68:	0007c503          	lbu	a0,0(a5)
    80005c6c:	10050463          	beqz	a0,80005d74 <printf+0x1ac>
    if(c != '%'){
    80005c70:	ff5515e3          	bne	a0,s5,80005c5a <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c74:	2985                	addiw	s3,s3,1
    80005c76:	013a07b3          	add	a5,s4,s3
    80005c7a:	0007c783          	lbu	a5,0(a5)
    80005c7e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c82:	cbed                	beqz	a5,80005d74 <printf+0x1ac>
    switch(c){
    80005c84:	05778a63          	beq	a5,s7,80005cd8 <printf+0x110>
    80005c88:	02fbf663          	bgeu	s7,a5,80005cb4 <printf+0xec>
    80005c8c:	09978863          	beq	a5,s9,80005d1c <printf+0x154>
    80005c90:	07800713          	li	a4,120
    80005c94:	0ce79563          	bne	a5,a4,80005d5e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005c98:	f8843783          	ld	a5,-120(s0)
    80005c9c:	00878713          	addi	a4,a5,8
    80005ca0:	f8e43423          	sd	a4,-120(s0)
    80005ca4:	4605                	li	a2,1
    80005ca6:	85ea                	mv	a1,s10
    80005ca8:	4388                	lw	a0,0(a5)
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	e32080e7          	jalr	-462(ra) # 80005adc <printint>
      break;
    80005cb2:	bf45                	j	80005c62 <printf+0x9a>
    switch(c){
    80005cb4:	09578f63          	beq	a5,s5,80005d52 <printf+0x18a>
    80005cb8:	0b879363          	bne	a5,s8,80005d5e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cbc:	f8843783          	ld	a5,-120(s0)
    80005cc0:	00878713          	addi	a4,a5,8
    80005cc4:	f8e43423          	sd	a4,-120(s0)
    80005cc8:	4605                	li	a2,1
    80005cca:	45a9                	li	a1,10
    80005ccc:	4388                	lw	a0,0(a5)
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	e0e080e7          	jalr	-498(ra) # 80005adc <printint>
      break;
    80005cd6:	b771                	j	80005c62 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005cd8:	f8843783          	ld	a5,-120(s0)
    80005cdc:	00878713          	addi	a4,a5,8
    80005ce0:	f8e43423          	sd	a4,-120(s0)
    80005ce4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ce8:	03000513          	li	a0,48
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	bd0080e7          	jalr	-1072(ra) # 800058bc <consputc>
  consputc('x');
    80005cf4:	07800513          	li	a0,120
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	bc4080e7          	jalr	-1084(ra) # 800058bc <consputc>
    80005d00:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d02:	03c95793          	srli	a5,s2,0x3c
    80005d06:	97da                	add	a5,a5,s6
    80005d08:	0007c503          	lbu	a0,0(a5)
    80005d0c:	00000097          	auipc	ra,0x0
    80005d10:	bb0080e7          	jalr	-1104(ra) # 800058bc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d14:	0912                	slli	s2,s2,0x4
    80005d16:	34fd                	addiw	s1,s1,-1
    80005d18:	f4ed                	bnez	s1,80005d02 <printf+0x13a>
    80005d1a:	b7a1                	j	80005c62 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d1c:	f8843783          	ld	a5,-120(s0)
    80005d20:	00878713          	addi	a4,a5,8
    80005d24:	f8e43423          	sd	a4,-120(s0)
    80005d28:	6384                	ld	s1,0(a5)
    80005d2a:	cc89                	beqz	s1,80005d44 <printf+0x17c>
      for(; *s; s++)
    80005d2c:	0004c503          	lbu	a0,0(s1)
    80005d30:	d90d                	beqz	a0,80005c62 <printf+0x9a>
        consputc(*s);
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	b8a080e7          	jalr	-1142(ra) # 800058bc <consputc>
      for(; *s; s++)
    80005d3a:	0485                	addi	s1,s1,1
    80005d3c:	0004c503          	lbu	a0,0(s1)
    80005d40:	f96d                	bnez	a0,80005d32 <printf+0x16a>
    80005d42:	b705                	j	80005c62 <printf+0x9a>
        s = "(null)";
    80005d44:	00003497          	auipc	s1,0x3
    80005d48:	a8c48493          	addi	s1,s1,-1396 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005d4c:	02800513          	li	a0,40
    80005d50:	b7cd                	j	80005d32 <printf+0x16a>
      consputc('%');
    80005d52:	8556                	mv	a0,s5
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	b68080e7          	jalr	-1176(ra) # 800058bc <consputc>
      break;
    80005d5c:	b719                	j	80005c62 <printf+0x9a>
      consputc('%');
    80005d5e:	8556                	mv	a0,s5
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	b5c080e7          	jalr	-1188(ra) # 800058bc <consputc>
      consputc(c);
    80005d68:	8526                	mv	a0,s1
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	b52080e7          	jalr	-1198(ra) # 800058bc <consputc>
      break;
    80005d72:	bdc5                	j	80005c62 <printf+0x9a>
  if(locking)
    80005d74:	020d9163          	bnez	s11,80005d96 <printf+0x1ce>
}
    80005d78:	70e6                	ld	ra,120(sp)
    80005d7a:	7446                	ld	s0,112(sp)
    80005d7c:	74a6                	ld	s1,104(sp)
    80005d7e:	7906                	ld	s2,96(sp)
    80005d80:	69e6                	ld	s3,88(sp)
    80005d82:	6a46                	ld	s4,80(sp)
    80005d84:	6aa6                	ld	s5,72(sp)
    80005d86:	6b06                	ld	s6,64(sp)
    80005d88:	7be2                	ld	s7,56(sp)
    80005d8a:	7c42                	ld	s8,48(sp)
    80005d8c:	7ca2                	ld	s9,40(sp)
    80005d8e:	7d02                	ld	s10,32(sp)
    80005d90:	6de2                	ld	s11,24(sp)
    80005d92:	6129                	addi	sp,sp,192
    80005d94:	8082                	ret
    release(&pr.lock);
    80005d96:	0001c517          	auipc	a0,0x1c
    80005d9a:	f4250513          	addi	a0,a0,-190 # 80021cd8 <pr>
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	3d0080e7          	jalr	976(ra) # 8000616e <release>
}
    80005da6:	bfc9                	j	80005d78 <printf+0x1b0>

0000000080005da8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005da8:	1101                	addi	sp,sp,-32
    80005daa:	ec06                	sd	ra,24(sp)
    80005dac:	e822                	sd	s0,16(sp)
    80005dae:	e426                	sd	s1,8(sp)
    80005db0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005db2:	0001c497          	auipc	s1,0x1c
    80005db6:	f2648493          	addi	s1,s1,-218 # 80021cd8 <pr>
    80005dba:	00003597          	auipc	a1,0x3
    80005dbe:	a2e58593          	addi	a1,a1,-1490 # 800087e8 <syscalls+0x418>
    80005dc2:	8526                	mv	a0,s1
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	266080e7          	jalr	614(ra) # 8000602a <initlock>
  pr.locking = 1;
    80005dcc:	4785                	li	a5,1
    80005dce:	cc9c                	sw	a5,24(s1)
}
    80005dd0:	60e2                	ld	ra,24(sp)
    80005dd2:	6442                	ld	s0,16(sp)
    80005dd4:	64a2                	ld	s1,8(sp)
    80005dd6:	6105                	addi	sp,sp,32
    80005dd8:	8082                	ret

0000000080005dda <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005dda:	1141                	addi	sp,sp,-16
    80005ddc:	e406                	sd	ra,8(sp)
    80005dde:	e022                	sd	s0,0(sp)
    80005de0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005de2:	100007b7          	lui	a5,0x10000
    80005de6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005dea:	f8000713          	li	a4,-128
    80005dee:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005df2:	470d                	li	a4,3
    80005df4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005df8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005dfc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e00:	469d                	li	a3,7
    80005e02:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e06:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e0a:	00003597          	auipc	a1,0x3
    80005e0e:	9fe58593          	addi	a1,a1,-1538 # 80008808 <digits+0x18>
    80005e12:	0001c517          	auipc	a0,0x1c
    80005e16:	ee650513          	addi	a0,a0,-282 # 80021cf8 <uart_tx_lock>
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	210080e7          	jalr	528(ra) # 8000602a <initlock>
}
    80005e22:	60a2                	ld	ra,8(sp)
    80005e24:	6402                	ld	s0,0(sp)
    80005e26:	0141                	addi	sp,sp,16
    80005e28:	8082                	ret

0000000080005e2a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e2a:	1101                	addi	sp,sp,-32
    80005e2c:	ec06                	sd	ra,24(sp)
    80005e2e:	e822                	sd	s0,16(sp)
    80005e30:	e426                	sd	s1,8(sp)
    80005e32:	1000                	addi	s0,sp,32
    80005e34:	84aa                	mv	s1,a0
  push_off();
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	238080e7          	jalr	568(ra) # 8000606e <push_off>

  if(panicked){
    80005e3e:	00003797          	auipc	a5,0x3
    80005e42:	a6e7a783          	lw	a5,-1426(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e46:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e4a:	c391                	beqz	a5,80005e4e <uartputc_sync+0x24>
    for(;;)
    80005e4c:	a001                	j	80005e4c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e4e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e52:	0207f793          	andi	a5,a5,32
    80005e56:	dfe5                	beqz	a5,80005e4e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e58:	0ff4f513          	andi	a0,s1,255
    80005e5c:	100007b7          	lui	a5,0x10000
    80005e60:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	2aa080e7          	jalr	682(ra) # 8000610e <pop_off>
}
    80005e6c:	60e2                	ld	ra,24(sp)
    80005e6e:	6442                	ld	s0,16(sp)
    80005e70:	64a2                	ld	s1,8(sp)
    80005e72:	6105                	addi	sp,sp,32
    80005e74:	8082                	ret

0000000080005e76 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e76:	00003797          	auipc	a5,0x3
    80005e7a:	a3a7b783          	ld	a5,-1478(a5) # 800088b0 <uart_tx_r>
    80005e7e:	00003717          	auipc	a4,0x3
    80005e82:	a3a73703          	ld	a4,-1478(a4) # 800088b8 <uart_tx_w>
    80005e86:	06f70a63          	beq	a4,a5,80005efa <uartstart+0x84>
{
    80005e8a:	7139                	addi	sp,sp,-64
    80005e8c:	fc06                	sd	ra,56(sp)
    80005e8e:	f822                	sd	s0,48(sp)
    80005e90:	f426                	sd	s1,40(sp)
    80005e92:	f04a                	sd	s2,32(sp)
    80005e94:	ec4e                	sd	s3,24(sp)
    80005e96:	e852                	sd	s4,16(sp)
    80005e98:	e456                	sd	s5,8(sp)
    80005e9a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e9c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ea0:	0001ca17          	auipc	s4,0x1c
    80005ea4:	e58a0a13          	addi	s4,s4,-424 # 80021cf8 <uart_tx_lock>
    uart_tx_r += 1;
    80005ea8:	00003497          	auipc	s1,0x3
    80005eac:	a0848493          	addi	s1,s1,-1528 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005eb0:	00003997          	auipc	s3,0x3
    80005eb4:	a0898993          	addi	s3,s3,-1528 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eb8:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ebc:	02077713          	andi	a4,a4,32
    80005ec0:	c705                	beqz	a4,80005ee8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ec2:	01f7f713          	andi	a4,a5,31
    80005ec6:	9752                	add	a4,a4,s4
    80005ec8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005ecc:	0785                	addi	a5,a5,1
    80005ece:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ed0:	8526                	mv	a0,s1
    80005ed2:	ffffb097          	auipc	ra,0xffffb
    80005ed6:	68c080e7          	jalr	1676(ra) # 8000155e <wakeup>
    
    WriteReg(THR, c);
    80005eda:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ede:	609c                	ld	a5,0(s1)
    80005ee0:	0009b703          	ld	a4,0(s3)
    80005ee4:	fcf71ae3          	bne	a4,a5,80005eb8 <uartstart+0x42>
  }
}
    80005ee8:	70e2                	ld	ra,56(sp)
    80005eea:	7442                	ld	s0,48(sp)
    80005eec:	74a2                	ld	s1,40(sp)
    80005eee:	7902                	ld	s2,32(sp)
    80005ef0:	69e2                	ld	s3,24(sp)
    80005ef2:	6a42                	ld	s4,16(sp)
    80005ef4:	6aa2                	ld	s5,8(sp)
    80005ef6:	6121                	addi	sp,sp,64
    80005ef8:	8082                	ret
    80005efa:	8082                	ret

0000000080005efc <uartputc>:
{
    80005efc:	7179                	addi	sp,sp,-48
    80005efe:	f406                	sd	ra,40(sp)
    80005f00:	f022                	sd	s0,32(sp)
    80005f02:	ec26                	sd	s1,24(sp)
    80005f04:	e84a                	sd	s2,16(sp)
    80005f06:	e44e                	sd	s3,8(sp)
    80005f08:	e052                	sd	s4,0(sp)
    80005f0a:	1800                	addi	s0,sp,48
    80005f0c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f0e:	0001c517          	auipc	a0,0x1c
    80005f12:	dea50513          	addi	a0,a0,-534 # 80021cf8 <uart_tx_lock>
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	1a4080e7          	jalr	420(ra) # 800060ba <acquire>
  if(panicked){
    80005f1e:	00003797          	auipc	a5,0x3
    80005f22:	98e7a783          	lw	a5,-1650(a5) # 800088ac <panicked>
    80005f26:	e7c9                	bnez	a5,80005fb0 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f28:	00003717          	auipc	a4,0x3
    80005f2c:	99073703          	ld	a4,-1648(a4) # 800088b8 <uart_tx_w>
    80005f30:	00003797          	auipc	a5,0x3
    80005f34:	9807b783          	ld	a5,-1664(a5) # 800088b0 <uart_tx_r>
    80005f38:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f3c:	0001c997          	auipc	s3,0x1c
    80005f40:	dbc98993          	addi	s3,s3,-580 # 80021cf8 <uart_tx_lock>
    80005f44:	00003497          	auipc	s1,0x3
    80005f48:	96c48493          	addi	s1,s1,-1684 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f4c:	00003917          	auipc	s2,0x3
    80005f50:	96c90913          	addi	s2,s2,-1684 # 800088b8 <uart_tx_w>
    80005f54:	00e79f63          	bne	a5,a4,80005f72 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f58:	85ce                	mv	a1,s3
    80005f5a:	8526                	mv	a0,s1
    80005f5c:	ffffb097          	auipc	ra,0xffffb
    80005f60:	59e080e7          	jalr	1438(ra) # 800014fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f64:	00093703          	ld	a4,0(s2)
    80005f68:	609c                	ld	a5,0(s1)
    80005f6a:	02078793          	addi	a5,a5,32
    80005f6e:	fee785e3          	beq	a5,a4,80005f58 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f72:	0001c497          	auipc	s1,0x1c
    80005f76:	d8648493          	addi	s1,s1,-634 # 80021cf8 <uart_tx_lock>
    80005f7a:	01f77793          	andi	a5,a4,31
    80005f7e:	97a6                	add	a5,a5,s1
    80005f80:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005f84:	0705                	addi	a4,a4,1
    80005f86:	00003797          	auipc	a5,0x3
    80005f8a:	92e7b923          	sd	a4,-1742(a5) # 800088b8 <uart_tx_w>
  uartstart();
    80005f8e:	00000097          	auipc	ra,0x0
    80005f92:	ee8080e7          	jalr	-280(ra) # 80005e76 <uartstart>
  release(&uart_tx_lock);
    80005f96:	8526                	mv	a0,s1
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	1d6080e7          	jalr	470(ra) # 8000616e <release>
}
    80005fa0:	70a2                	ld	ra,40(sp)
    80005fa2:	7402                	ld	s0,32(sp)
    80005fa4:	64e2                	ld	s1,24(sp)
    80005fa6:	6942                	ld	s2,16(sp)
    80005fa8:	69a2                	ld	s3,8(sp)
    80005faa:	6a02                	ld	s4,0(sp)
    80005fac:	6145                	addi	sp,sp,48
    80005fae:	8082                	ret
    for(;;)
    80005fb0:	a001                	j	80005fb0 <uartputc+0xb4>

0000000080005fb2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fb2:	1141                	addi	sp,sp,-16
    80005fb4:	e422                	sd	s0,8(sp)
    80005fb6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fb8:	100007b7          	lui	a5,0x10000
    80005fbc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fc0:	8b85                	andi	a5,a5,1
    80005fc2:	cb91                	beqz	a5,80005fd6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005fc4:	100007b7          	lui	a5,0x10000
    80005fc8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005fcc:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005fd0:	6422                	ld	s0,8(sp)
    80005fd2:	0141                	addi	sp,sp,16
    80005fd4:	8082                	ret
    return -1;
    80005fd6:	557d                	li	a0,-1
    80005fd8:	bfe5                	j	80005fd0 <uartgetc+0x1e>

0000000080005fda <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005fda:	1101                	addi	sp,sp,-32
    80005fdc:	ec06                	sd	ra,24(sp)
    80005fde:	e822                	sd	s0,16(sp)
    80005fe0:	e426                	sd	s1,8(sp)
    80005fe2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005fe4:	54fd                	li	s1,-1
    80005fe6:	a029                	j	80005ff0 <uartintr+0x16>
      break;
    consoleintr(c);
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	916080e7          	jalr	-1770(ra) # 800058fe <consoleintr>
    int c = uartgetc();
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	fc2080e7          	jalr	-62(ra) # 80005fb2 <uartgetc>
    if(c == -1)
    80005ff8:	fe9518e3          	bne	a0,s1,80005fe8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005ffc:	0001c497          	auipc	s1,0x1c
    80006000:	cfc48493          	addi	s1,s1,-772 # 80021cf8 <uart_tx_lock>
    80006004:	8526                	mv	a0,s1
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	0b4080e7          	jalr	180(ra) # 800060ba <acquire>
  uartstart();
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	e68080e7          	jalr	-408(ra) # 80005e76 <uartstart>
  release(&uart_tx_lock);
    80006016:	8526                	mv	a0,s1
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	156080e7          	jalr	342(ra) # 8000616e <release>
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e422                	sd	s0,8(sp)
    8000602e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006030:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006032:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006036:	00053823          	sd	zero,16(a0)
}
    8000603a:	6422                	ld	s0,8(sp)
    8000603c:	0141                	addi	sp,sp,16
    8000603e:	8082                	ret

0000000080006040 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006040:	411c                	lw	a5,0(a0)
    80006042:	e399                	bnez	a5,80006048 <holding+0x8>
    80006044:	4501                	li	a0,0
  return r;
}
    80006046:	8082                	ret
{
    80006048:	1101                	addi	sp,sp,-32
    8000604a:	ec06                	sd	ra,24(sp)
    8000604c:	e822                	sd	s0,16(sp)
    8000604e:	e426                	sd	s1,8(sp)
    80006050:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006052:	6904                	ld	s1,16(a0)
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	de2080e7          	jalr	-542(ra) # 80000e36 <mycpu>
    8000605c:	40a48533          	sub	a0,s1,a0
    80006060:	00153513          	seqz	a0,a0
}
    80006064:	60e2                	ld	ra,24(sp)
    80006066:	6442                	ld	s0,16(sp)
    80006068:	64a2                	ld	s1,8(sp)
    8000606a:	6105                	addi	sp,sp,32
    8000606c:	8082                	ret

000000008000606e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000606e:	1101                	addi	sp,sp,-32
    80006070:	ec06                	sd	ra,24(sp)
    80006072:	e822                	sd	s0,16(sp)
    80006074:	e426                	sd	s1,8(sp)
    80006076:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006078:	100024f3          	csrr	s1,sstatus
    8000607c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006080:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006082:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006086:	ffffb097          	auipc	ra,0xffffb
    8000608a:	db0080e7          	jalr	-592(ra) # 80000e36 <mycpu>
    8000608e:	5d3c                	lw	a5,120(a0)
    80006090:	cf89                	beqz	a5,800060aa <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006092:	ffffb097          	auipc	ra,0xffffb
    80006096:	da4080e7          	jalr	-604(ra) # 80000e36 <mycpu>
    8000609a:	5d3c                	lw	a5,120(a0)
    8000609c:	2785                	addiw	a5,a5,1
    8000609e:	dd3c                	sw	a5,120(a0)
}
    800060a0:	60e2                	ld	ra,24(sp)
    800060a2:	6442                	ld	s0,16(sp)
    800060a4:	64a2                	ld	s1,8(sp)
    800060a6:	6105                	addi	sp,sp,32
    800060a8:	8082                	ret
    mycpu()->intena = old;
    800060aa:	ffffb097          	auipc	ra,0xffffb
    800060ae:	d8c080e7          	jalr	-628(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060b2:	8085                	srli	s1,s1,0x1
    800060b4:	8885                	andi	s1,s1,1
    800060b6:	dd64                	sw	s1,124(a0)
    800060b8:	bfe9                	j	80006092 <push_off+0x24>

00000000800060ba <acquire>:
{
    800060ba:	1101                	addi	sp,sp,-32
    800060bc:	ec06                	sd	ra,24(sp)
    800060be:	e822                	sd	s0,16(sp)
    800060c0:	e426                	sd	s1,8(sp)
    800060c2:	1000                	addi	s0,sp,32
    800060c4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	fa8080e7          	jalr	-88(ra) # 8000606e <push_off>
  if(holding(lk))
    800060ce:	8526                	mv	a0,s1
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	f70080e7          	jalr	-144(ra) # 80006040 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060d8:	4705                	li	a4,1
  if(holding(lk))
    800060da:	e115                	bnez	a0,800060fe <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060dc:	87ba                	mv	a5,a4
    800060de:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060e2:	2781                	sext.w	a5,a5
    800060e4:	ffe5                	bnez	a5,800060dc <acquire+0x22>
  __sync_synchronize();
    800060e6:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060ea:	ffffb097          	auipc	ra,0xffffb
    800060ee:	d4c080e7          	jalr	-692(ra) # 80000e36 <mycpu>
    800060f2:	e888                	sd	a0,16(s1)
}
    800060f4:	60e2                	ld	ra,24(sp)
    800060f6:	6442                	ld	s0,16(sp)
    800060f8:	64a2                	ld	s1,8(sp)
    800060fa:	6105                	addi	sp,sp,32
    800060fc:	8082                	ret
    panic("acquire");
    800060fe:	00002517          	auipc	a0,0x2
    80006102:	71250513          	addi	a0,a0,1810 # 80008810 <digits+0x20>
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	a78080e7          	jalr	-1416(ra) # 80005b7e <panic>

000000008000610e <pop_off>:

void
pop_off(void)
{
    8000610e:	1141                	addi	sp,sp,-16
    80006110:	e406                	sd	ra,8(sp)
    80006112:	e022                	sd	s0,0(sp)
    80006114:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006116:	ffffb097          	auipc	ra,0xffffb
    8000611a:	d20080e7          	jalr	-736(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000611e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006122:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006124:	e78d                	bnez	a5,8000614e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006126:	5d3c                	lw	a5,120(a0)
    80006128:	02f05b63          	blez	a5,8000615e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000612c:	37fd                	addiw	a5,a5,-1
    8000612e:	0007871b          	sext.w	a4,a5
    80006132:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006134:	eb09                	bnez	a4,80006146 <pop_off+0x38>
    80006136:	5d7c                	lw	a5,124(a0)
    80006138:	c799                	beqz	a5,80006146 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000613a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000613e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006142:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006146:	60a2                	ld	ra,8(sp)
    80006148:	6402                	ld	s0,0(sp)
    8000614a:	0141                	addi	sp,sp,16
    8000614c:	8082                	ret
    panic("pop_off - interruptible");
    8000614e:	00002517          	auipc	a0,0x2
    80006152:	6ca50513          	addi	a0,a0,1738 # 80008818 <digits+0x28>
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	a28080e7          	jalr	-1496(ra) # 80005b7e <panic>
    panic("pop_off");
    8000615e:	00002517          	auipc	a0,0x2
    80006162:	6d250513          	addi	a0,a0,1746 # 80008830 <digits+0x40>
    80006166:	00000097          	auipc	ra,0x0
    8000616a:	a18080e7          	jalr	-1512(ra) # 80005b7e <panic>

000000008000616e <release>:
{
    8000616e:	1101                	addi	sp,sp,-32
    80006170:	ec06                	sd	ra,24(sp)
    80006172:	e822                	sd	s0,16(sp)
    80006174:	e426                	sd	s1,8(sp)
    80006176:	1000                	addi	s0,sp,32
    80006178:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	ec6080e7          	jalr	-314(ra) # 80006040 <holding>
    80006182:	c115                	beqz	a0,800061a6 <release+0x38>
  lk->cpu = 0;
    80006184:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006188:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000618c:	0f50000f          	fence	iorw,ow
    80006190:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006194:	00000097          	auipc	ra,0x0
    80006198:	f7a080e7          	jalr	-134(ra) # 8000610e <pop_off>
}
    8000619c:	60e2                	ld	ra,24(sp)
    8000619e:	6442                	ld	s0,16(sp)
    800061a0:	64a2                	ld	s1,8(sp)
    800061a2:	6105                	addi	sp,sp,32
    800061a4:	8082                	ret
    panic("release");
    800061a6:	00002517          	auipc	a0,0x2
    800061aa:	69250513          	addi	a0,a0,1682 # 80008838 <digits+0x48>
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	9d0080e7          	jalr	-1584(ra) # 80005b7e <panic>
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
