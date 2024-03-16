/* Call a simple assembly function */
.data
plain_text:
.word 0x12345678, 0xfff80000, 0x0007ffff, 0x44556677, 0x00112233, 0xccddeeff, 0x8899aabb

.text
.global MAIN

MAIN:

jal RECTANGLE
jal KATAN32

ret

KATAN32:

la t0, plain_text
lw s0, (t0)
lw s1, 4(t0) // L1 register mask
lw s2, 8(t0) // L2 register mask

and s3, s0, s1 // get L1
srli s3, s3, 19
and s4, s0, s2 // get L2

// index can be simulated by mask (e.g. 1 => 0b00..10, which is 0x1 << 1)
addi a0, s3, 0
addi a1, x0, 1
addi a2, x0, 0
jal katan_fn_a // jal instead of j, jal will store PC+4 in rp.
addi s0, a0, 0 // get the result of fn_a

addi a0, s4, 0
addi a1, x0, 1
jal katan_fn_b
addi s1, a0, 0

slli s3, s3, 20 // drop 1 bit
srli s3, s3, 19

slli s4, s4, 14 // drop 1 bit
srli s4, s4, 13

add s3, s3, s1
add s4, s4, s0
slli s3, s3, 19 // This round will hold a 0x048d in L1.
add a0, s3, s4 // This is the sum of the L1 and L2.

ret

katan_fn_a:
// a0: L1 register, a1: ir, a2: key a
addi sp, sp, -20
sw s0, 0(sp)
sw s1, 4(sp)
sw s2, 8(sp)
sw s3, 12(sp)
sw s4, 16(sp)

addi t0, x0, 1 // Init index.
slli t1, t0, 12 // x1 = 12
slli t2, t0, 7 // x2 = 7
slli t3, t0, 8 // x3 = 8
slli t4, t0, 5 // x4 = 5
slli t5, t0, 3 // x5 = 3

and t1, t1, a0
srli t1, t1, 12
and t2, t2, a0
srli t2, t2, 7
and t3, t3, a0
srli t3, t3, 8
and t4, t4, a0
srli t4, t4, 5
and t5, t5, a0
srli t5, t5, 3

xor s0, t1, t2 // L[x1] ^ L[x2]
and s1, t3, t4 // L[x3] & L[x4]
and s2, t5, a1 // L[x5] & ir

xor a0, s0, s1
xor a0, a0, s2
xor a0, a2, a0

lw s0, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw s3, 12(sp)
lw s4, 16(sp)
addi sp, sp, 20
ret

katan_fn_b:
// a0: L1 register, a1: key b
addi sp, sp, -20
sw s0, 0(sp)
sw s1, 4(sp)
sw s2, 8(sp)
sw s3, 12(sp)
sw s4, 16(sp)

addi t0, x0, 1 // Init index.
slli t1, t0, 18 // y1 = 18
slli t2, t0, 7 // y2 = 7
slli t3, t0, 12 // y3 = 12
slli t4, t0, 10 // y4 = 10
slli t5, t0, 8 // y5 = 8
slli t6, t0, 3 // y6 = 3

and t1, t1, a0
srli t1, t1, 18
and t2, t2, a0
srli t2, t2, 7
and t3, t3, a0
srli t3, t3, 12
and t4, t4, a0
srli t4, t4, 10
and t5, t5, a0
srli t5, t5, 8
and t6, t6, a0
srli t6, t6, 3

xor s0, t1, t2 // L[y1] ^ L[y2]
and s1, t3, t4 // L[y3] & L[y4]
and s2, t5, t6 // L[y5] & L[y6]

xor a0, s0, s1
xor a0, a0, s2
xor a0, a2, a1

lw s0, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw s3, 12(sp)
lw s4, 16(sp)
addi sp, sp, 20
ret

RECTANGLE:
addi sp, sp, -4
sw s0, 0(sp)

la t0, plain_text

lhu a0, 12(t0) // 0th row
lhu a1, 14(t0) // 1st row
lhu a2, 16(t0) // 2nd row
lhu a3, 18(t0) // 3rd row

lhu a4, 20(t0) // lowest part of the round key.
lhu a5, 22(t0)
lhu a6, 24(t0)
lhu a7, 26(t0) // highest part of the round key.

// add round key.
xor a0, a0, a4
xor a1, a1, a5
xor a2, a2, a6
xor a3, a3, a7

not s1, a1
and s2, a0, s1
xor s3, a2, a3
xor a4, s2, s3 // a4 as B0
or  s4, a3, s1
xor s5, a0, s4
xor a5, a2, s5 // a5 as B1
xor s7, a1, a2
and s8, s3, s5
xor a7, s7, s8 // a7 as B3
or  s9, a4, s7
xor a6, s5, s9 // a6 as B2 

addi a0, a4, 0
addi a1, a5, 0
addi a2, a6, 0
addi a3, a7, 0

// masks
li t0, 0x8000
li t1, 0x7fff

and s0, a1, t0 // left hand side part
and s1, a1, t1 // right hand side part
srl s0, s0, 15
sll s1, s1, 1
add a1, s0, s1

li t0, 0xf000
li t1, 0x0fff
and s0, a2, t0
and s1, a2, t1
srl s0, s0, 12
sll s1, s1, 4
add a2, s0, s1

li t0, 0xe000
li t1, 0x1fff
and s0, a3, t0
and s1, a3, t1
srl s0, s0, 13
sll s1, s1, 3
add a3, s0, s1

// The result is: {a3, a2, a1, a0}.

nop
lw s0, 0(sp)
addi sp, sp, 4

ret
