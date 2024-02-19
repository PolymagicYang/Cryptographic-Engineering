/* Call a simple assembly function */


.data
plain_text:
.word 0x12345678, 0xfff80000, 0x0007ffff

.text
.global KATAN32

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
slli s3, s3, 19
add a0, s3, s4

nop

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
