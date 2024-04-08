.option nopic
.attribute arch, "rv32i2p0_m2p0"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	clear_t_regs
.type	clear_t_regs, @function
clear_t_regs:
    li t0,0
    li t1,0
    li t2,0
    li t3,0
    li t4,0
    li t5,0
    li t6,0
    li a0,0
    li a1,0
    li a2,0
    li a3,0
    li a4,0
    li a5,0
    li a6,0
    li a7,0
    ret

.globl	clear_s_regs
.type	clear_s_regs, @function
clear_s_regs:
    li s0,0
    li s1,0
    li s2,0
    li s3,0
    li s4,0
    li s5,0
    li s6,0
    li s7,0
    li s8,0
    li s9,0
    li s10,0
    li s11,0
    ret

.globl	clear_all_regs
.type	clear_all_regs, @function
clear_all_regs:
    addi    sp,sp,-4
    sw      ra,0(sp)
    jal     clear_t_regs
    jal     clear_s_regs
    lw      ra,0(sp)
    addi    sp,sp,4
