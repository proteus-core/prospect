	.file	"sort.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	djbsort_int32
	.type	djbsort_int32, @function
djbsort_int32:
	addi	sp,sp,-32
	sw	s1,24(sp)
	sw	s2,20(sp)
	sw	s0,28(sp)
	sw	s3,16(sp)
	sw	s4,12(sp)
	sw	s5,8(sp)
	sw	s6,4(sp)
	sw	s7,0(sp)
	mv	s2,a2
	mv	t4,a0
	mv	s1,a1
	ble	a2,zero,.L45
.L30:
	li	a5,2
	li	s4,1
	li	s3,0
	beq	s1,a5,.L46
.L36:
	srli	a5,s4,31
	slli	s3,s3,1
	slli	s4,s4,1
	or	s3,a5,s3
	sub	a4,s1,s4
	sgtu	a3,a4,s1
	sub	a5,s2,s3
	sub	a5,a5,a3
	bgt	a5,s3,.L36
	bne	a5,s3,.L4
	bgtu	a4,s4,.L36
.L4:
	mv	t5,s4
	mv	a7,s3
.L8:
	sub	t3,s1,t5
	sgtu	a5,t3,s1
	sub	t6,s2,a7
	sub	t6,t6,a5
	ble	t6,zero,.L47
.L25:
	slli	a2,t5,2
	add	a2,t4,a2
	mv	a0,t4
	li	a4,0
	li	a1,0
.L37:
	and	a5,a4,t5
	and	a3,a1,a7
	addi	a6,a4,1
	or	a5,a5,a3
	sltu	t1,a6,a4
	mv	a4,a6
	bne	a5,zero,.L9
	lw	a5,0(a2)
	lw	a3,0(a0)
	sub	t0,a5,a3
	xor	a6,a5,a3
	xor	a5,a5,t0
	and	a5,a5,a6
	xor	a5,a5,t0
	srai	a5,a5,31
	and	a5,a5,a6
	xor	a3,a3,a5
	sw	a3,0(a0)
	lw	a3,0(a2)
	xor	a5,a3,a5
	sw	a5,0(a2)
.L9:
	add	a1,t1,a1
	addi	a2,a2,4
	addi	a0,a0,4
	bne	a4,t3,.L37
	bne	a1,t6,.L37
.L27:
	ble	s3,a7,.L48
.L29:
	mv	t2,s4
	mv	t0,s3
	li	a6,0
	li	t1,0
.L11:
	sub	t6,s1,t2
	sgtu	a5,t6,s1
	sub	s0,s2,t0
	sub	s0,s0,a5
	ble	s0,t1,.L49
.L21:
	add	t3,t5,a6
	slli	t3,t3,2
	add	t3,t4,t3
	j	.L39
.L14:
	addi	a5,a6,1
	sltu	a4,a5,a6
	add	t1,a4,t1
	mv	a6,a5
	addi	t3,t3,4
	beq	t6,a5,.L50
.L39:
	and	a5,a6,t5
	and	a4,t1,a7
	or	a5,a5,a4
	bne	a5,zero,.L14
	lw	a1,0(t3)
	ble	t0,a7,.L51
.L32:
	mv	a2,t2
	mv	a0,t0
.L38:
	add	a4,a6,a2
	slli	a4,a4,2
	add	a4,t4,a4
	lw	a3,0(a4)
	slli	s5,a0,31
	srli	a2,a2,1
	sub	s7,a3,a1
	xor	s6,a3,a1
	xor	a5,a3,s7
	and	a5,a5,s6
	xor	a5,a5,s7
	srai	a5,a5,31
	and	a5,a5,s6
	xor	a3,a3,a5
	sw	a3,0(a4)
	srai	a0,a0,1
	or	a2,s5,a2
	xor	a1,a1,a5
	bgt	a0,a7,.L38
	bne	a0,a7,.L15
	bgtu	a2,t5,.L38
.L15:
	sw	a1,0(t3)
.L52:
	addi	a5,a6,1
	sltu	a4,a5,a6
	add	t1,a4,t1
	mv	a6,a5
	addi	t3,t3,4
	bne	t6,a5,.L39
.L50:
	bne	s0,t1,.L39
.L23:
	slli	a5,t0,31
	srli	t2,t2,1
	srai	t0,t0,1
	or	t2,a5,t2
	bgt	t0,a7,.L11
.L53:
	bne	t0,a7,.L13
	bgtu	t2,t5,.L11
.L13:
	slli	a5,a7,31
	srli	t5,t5,1
	or	t5,a5,t5
	srai	a7,a7,1
	or	a5,t5,a7
	bne	a5,zero,.L8
.L1:
	lw	s0,28(sp)
	lw	s1,24(sp)
	lw	s2,20(sp)
	lw	s3,16(sp)
	lw	s4,12(sp)
	lw	s5,8(sp)
	lw	s6,4(sp)
	lw	s7,0(sp)
	addi	sp,sp,32
	jr	ra
.L51:
	bne	t0,a7,.L15
	bgtu	t2,t5,.L32
	sw	a1,0(t3)
	j	.L52
.L49:
	bne	s0,t1,.L23
	bgtu	t6,a6,.L21
	slli	a5,t0,31
	srli	t2,t2,1
	srai	t0,t0,1
	or	t2,a5,t2
	bgt	t0,a7,.L11
	j	.L53
.L47:
	bne	t6,zero,.L27
	bne	t3,zero,.L25
	bgt	s3,a7,.L29
.L48:
	bne	s3,a7,.L13
	bgtu	s4,t5,.L29
	j	.L13
.L45:
	bne	a2,zero,.L1
	li	a5,1
	bgtu	a1,a5,.L30
	j	.L1
.L46:
	bne	s2,zero,.L36
	j	.L4
	.size	djbsort_int32, .-djbsort_int32
	.ident	"GCC: (GNU) 11.1.0"
