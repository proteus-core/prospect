	.file	"Hacl_Hash_SHA2.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.type	update_256, @function
update_256:
	addi	sp,sp,-48
	lui	a4,%hi(.LANCHOR0)
	sw	s1,36(sp)
	li	t4,65536
	lui	s1,%hi(.LANCHOR0+256)
	sw	s0,40(sp)
	sw	s2,32(sp)
	sw	s3,28(sp)
	addi	s0,a4,%lo(.LANCHOR0)
	addi	s2,a4,%lo(.LANCHOR0)
	sw	ra,44(sp)
	sw	s4,24(sp)
	sw	s5,20(sp)
	sw	s6,16(sp)
	sw	s7,12(sp)
	sw	s8,8(sp)
	sw	s9,4(sp)
	sw	s10,0(sp)
	mv	s3,a0
	addi	a4,a4,%lo(.LANCHOR0)
	li	a5,0
	addi	s1,s1,%lo(.LANCHOR0+256)
	li	t1,15
	li	t3,64
	addi	t4,t4,-256
	li	t5,16711680
	j	.L5
.L2:
	lw	a0,-8(a4)
	lw	a2,-60(a4)
	lw	a6,-64(a4)
	srli	t6,a0,17
	srli	a3,a0,19
	slli	a5,a0,15
	slli	t0,a0,13
	lw	t2,-28(a4)
	or	a5,a5,t6
	or	t0,t0,a3
	slli	s5,a2,25
	srli	a3,a2,7
	slli	t6,a2,14
	srli	s4,a2,18
	srli	a0,a0,10
	xor	a5,a5,t0
	or	a3,a3,s5
	or	t6,t6,s4
	xor	a5,a5,a0
	xor	a3,a3,t6
	add	a0,a6,t2
	srli	a2,a2,3
	add	a5,a5,a0
	xor	a3,a3,a2
	add	a5,a5,a3
	sw	a5,0(a4)
	beq	a7,t3,.L4
.L3:
	addi	a1,a1,4
	addi	a4,a4,4
	mv	a5,a7
.L5:
	addi	a7,a5,1
	bgtu	a5,t1,.L2
	lbu	a0,0(a1)
	lbu	a2,1(a1)
	lbu	a3,2(a1)
	lbu	a5,3(a1)
	sb	a0,0(s1)
	sb	a2,1(s1)
	sb	a3,2(s1)
	sb	a5,3(s1)
	lw	a5,256(s2)
	srli	a3,a5,24
	slli	a0,a5,24
	srli	a2,a5,8
	or	a3,a3,a0
	and	a2,a2,t4
	slli	a5,a5,8
	or	a3,a3,a2
	and	a5,a5,t5
	or	a5,a3,a5
	sw	a5,0(a4)
	j	.L3
.L4:
	addi	t4,s2,260
	li	a2,32
	mv	a1,s3
	mv	a0,t4
	call	memcpy
	mv	t4,a0
	lui	a0,%hi(.LANCHOR1)
	lw	a6,260(s2)
	lw	a1,264(s2)
	lw	t5,268(s2)
	lw	t0,272(s2)
	lw	a2,276(s2)
	lw	t6,280(s2)
	lw	t3,284(s2)
	lw	t2,288(s2)
	addi	a0,a0,%lo(.LANCHOR1)
	j	.L6
.L9:
	mv	t3,t6
	mv	t5,a1
	mv	t6,a2
	mv	a1,a6
	mv	a2,a3
	mv	a6,a5
.L6:
	slli	t1,a2,26
	slli	a3,a2,21
	srli	a4,a2,6
	srli	s4,a2,11
	or	a4,a4,t1
	or	s4,s4,a3
	slli	s8,a2,7
	srli	s7,a2,25
	xor	a7,a4,s4
	or	a4,s8,s7
	xor	a4,a7,a4
	lw	a5,0(s0)
	lw	a7,0(a0)
	slli	s5,a6,19
	not	t1,a2
	srli	a3,a6,2
	slli	s10,a6,30
	srli	s6,a6,13
	add	a5,a5,a7
	or	a3,a3,s10
	or	s6,s6,s5
	and	s8,a2,t6
	xor	s9,a6,a1
	and	t1,t1,t3
	slli	s4,a6,10
	srli	s7,a6,22
	add	a5,a4,a5
	and	s5,a6,a1
	xor	a4,a3,s6
	and	a7,s9,t5
	or	a3,s4,s7
	xor	t1,t1,s8
	xor	a4,a4,a3
	add	a5,a5,t1
	xor	a7,a7,s5
	add	a5,a5,t2
	add	a4,a4,a7
	addi	s0,s0,4
	add	a3,t0,a5
	mv	t2,t3
	add	a5,a5,a4
	mv	t0,t5
	addi	a0,a0,4
	bne	s1,s0,.L9
	sw	a3,276(s2)
	sw	a5,260(s2)
	sw	a6,264(s2)
	sw	a1,268(s2)
	sw	t5,272(s2)
	sw	a2,280(s2)
	sw	t6,284(s2)
	sw	t3,288(s2)
	addi	a3,s3,32
	j	.L8
.L12:
	lw	a5,0(t4)
.L8:
	lw	a4,0(s3)
	addi	s3,s3,4
	addi	t4,t4,4
	add	a5,a4,a5
	sw	a5,-4(s3)
	bne	a3,s3,.L12
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s5,20(sp)
	lw	s6,16(sp)
	lw	s7,12(sp)
	lw	s8,8(sp)
	lw	s9,4(sp)
	lw	s10,0(sp)
	addi	sp,sp,48
	jr	ra
	.size	update_256, .-update_256
	.align	2
	.globl	Hacl_Hash_Core_SHA2_init_256
	.type	Hacl_Hash_Core_SHA2_init_256, @function
Hacl_Hash_Core_SHA2_init_256:
	lui	a1,%hi(.LANCHOR1+256)
	li	a2,32
	addi	a1,a1,%lo(.LANCHOR1+256)
	tail	memcpy
	.size	Hacl_Hash_Core_SHA2_init_256, .-Hacl_Hash_Core_SHA2_init_256
	.align	2
	.globl	Hacl_Hash_Core_SHA2_pad_256
	.type	Hacl_Hash_Core_SHA2_pad_256, @function
Hacl_Hash_Core_SHA2_pad_256:
	addi	sp,sp,-48
	sw	s3,28(sp)
	li	s3,119
	sw	s0,40(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	sw	ra,44(sp)
	sub	s3,s3,a0
	li	a5,-128
	sb	a5,0(a2)
	andi	s3,s3,63
	mv	s2,a0
	mv	s1,a2
	mv	s0,a1
	beq	s3,zero,.L16
	mv	a2,s3
	li	a1,0
	addi	a0,s1,1
	call	memset
	addi	s3,s3,1
.L15:
	srli	a5,s2,29
	slli	a1,s0,3
	or	a1,a5,a1
	slli	a4,s2,3
	li	a2,65536
	slli	t1,s2,27
	slli	a7,a1,24
	srli	a0,a1,8
	addi	a2,a2,-256
	srli	a5,a4,24
	srli	a3,a4,8
	srli	a4,a1,24
	li	a6,16711680
	and	a3,a3,a2
	or	a5,a5,t1
	and	a2,a0,a2
	or	a4,a4,a7
	slli	s2,s2,11
	slli	a1,a1,8
	and	s2,s2,a6
	and	a1,a1,a6
	or	a5,a5,a3
	or	a4,a4,a2
	or	a5,a5,s2
	or	a4,a4,a1
	add	a2,s1,s3
	srli	t1,a4,8
	srli	a7,a4,16
	srli	a0,a5,8
	srli	a1,a5,16
	srli	a6,a4,24
	srli	a3,a5,24
	sb	a4,0(a2)
	sb	t1,1(a2)
	sb	a7,2(a2)
	sb	a6,3(a2)
	sb	a5,4(a2)
	sb	a0,5(a2)
	sb	a1,6(a2)
	sb	a3,7(a2)
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	addi	sp,sp,48
	jr	ra
.L16:
	li	s3,1
	j	.L15
	.size	Hacl_Hash_Core_SHA2_pad_256, .-Hacl_Hash_Core_SHA2_pad_256
	.align	2
	.globl	Hacl_Hash_Core_SHA2_finish_256
	.type	Hacl_Hash_Core_SHA2_finish_256, @function
Hacl_Hash_Core_SHA2_finish_256:
	li	a6,65536
	addi	sp,sp,-16
	addi	t1,a0,32
	addi	a6,a6,-256
	li	a7,16711680
.L19:
	lw	a4,0(a0)
	addi	a1,a1,4
	addi	a0,a0,4
	slli	a2,a4,24
	srli	a5,a4,24
	srli	a3,a4,8
	or	a5,a5,a2
	and	a3,a3,a6
	slli	a4,a4,8
	or	a5,a5,a3
	and	a4,a4,a7
	or	a5,a5,a4
	srli	a2,a5,8
	srli	a3,a5,16
	srli	a4,a5,24
	sb	a5,-4(a1)
	sb	a2,-3(a1)
	sb	a3,-2(a1)
	sb	a4,-1(a1)
	bne	t1,a0,.L19
	addi	sp,sp,16
	jr	ra
	.size	Hacl_Hash_Core_SHA2_finish_256, .-Hacl_Hash_Core_SHA2_finish_256
	.align	2
	.globl	Hacl_Hash_SHA2_update_multi_256
	.type	Hacl_Hash_SHA2_update_multi_256, @function
Hacl_Hash_SHA2_update_multi_256:
	beq	a2,zero,.L30
	addi	sp,sp,-32
	sw	s0,24(sp)
	sw	s1,20(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	sw	ra,28(sp)
	mv	s2,a2
	mv	s3,a0
	mv	s0,a1
	li	s1,0
.L24:
	mv	a1,s0
	mv	a0,s3
	addi	s1,s1,1
	call	update_256
	addi	s0,s0,64
	bne	s2,s1,.L24
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	addi	sp,sp,32
	jr	ra
.L30:
	ret
	.size	Hacl_Hash_SHA2_update_multi_256, .-Hacl_Hash_SHA2_update_multi_256
	.align	2
	.globl	Hacl_Hash_SHA2_update_last_256
	.type	Hacl_Hash_SHA2_update_last_256, @function
Hacl_Hash_SHA2_update_last_256:
	addi	sp,sp,-48
	sw	s1,36(sp)
	sw	s2,32(sp)
	sw	s3,28(sp)
	sw	s4,24(sp)
	sw	s5,20(sp)
	sw	s6,16(sp)
	sw	s7,12(sp)
	andi	s6,a4,-64
	sw	ra,44(sp)
	sw	s0,40(sp)
	srli	s1,a4,6
	mv	s3,a4
	mv	s2,a0
	mv	s7,a1
	mv	s5,a2
	andi	s4,a4,63
	add	s6,a3,s6
	beq	s1,zero,.L34
	slli	s1,s1,6
	mv	s0,a3
	add	s1,a3,s1
.L35:
	mv	a1,s0
	mv	a0,s2
	addi	s0,s0,64
	call	update_256
	bne	s0,s1,.L35
.L34:
	add	s7,s3,s7
	lui	s0,%hi(.LANCHOR0+292)
	li	s1,119
	addi	s0,s0,%lo(.LANCHOR0+292)
	sub	s1,s1,s7
	addi	a5,s4,9
	mv	a2,s4
	mv	a1,s6
	andi	s1,s1,63
	sltu	s3,s7,s3
	mv	a0,s0
	add	s1,s1,a5
	add	s3,s3,s5
	call	memcpy
	add	a2,s0,s4
	mv	a0,s7
	mv	a1,s3
	srli	s1,s1,6
	call	Hacl_Hash_Core_SHA2_pad_256
	beq	s1,zero,.L33
	slli	s1,s1,6
	add	s1,s0,s1
.L37:
	mv	a1,s0
	mv	a0,s2
	addi	s0,s0,64
	call	update_256
	bne	s1,s0,.L37
.L33:
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s5,20(sp)
	lw	s6,16(sp)
	lw	s7,12(sp)
	addi	sp,sp,48
	jr	ra
	.size	Hacl_Hash_SHA2_update_last_256, .-Hacl_Hash_SHA2_update_last_256
	.align	2
	.globl	Hacl_Hash_SHA2_hash_256
	.type	Hacl_Hash_SHA2_hash_256, @function
Hacl_Hash_SHA2_hash_256:
	addi	sp,sp,-48
	sw	s0,40(sp)
	sw	s3,28(sp)
	sw	s5,20(sp)
	sw	ra,44(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	sw	s4,24(sp)
	sw	s6,16(sp)
	sw	s7,12(sp)
	andi	a5,a1,63
	mv	s0,a0
	mv	s5,a2
	srli	s3,a1,6
	bne	a5,zero,.L48
	li	a5,63
	sgtu	a5,a1,a5
	sub	s3,s3,a5
.L48:
	slli	s6,s3,6
	lui	s2,%hi(.LANCHOR0+420)
	sub	s4,a1,s6
	add	s7,s0,s6
	addi	s2,s2,%lo(.LANCHOR0+420)
	beq	s3,zero,.L49
	lui	s2,%hi(.LANCHOR0+420)
	li	s1,0
	addi	s2,s2,%lo(.LANCHOR0+420)
.L50:
	mv	a1,s0
	mv	a0,s2
	addi	s1,s1,1
	call	update_256
	addi	s0,s0,64
	bne	s3,s1,.L50
.L49:
	mv	a1,s6
	mv	a0,s2
	mv	a4,s4
	mv	a3,s7
	li	a2,0
	call	Hacl_Hash_SHA2_update_last_256
	lw	s0,40(sp)
	lw	ra,44(sp)
	lw	s1,36(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s6,16(sp)
	lw	s7,12(sp)
	mv	a1,s5
	mv	a0,s2
	lw	s5,20(sp)
	lw	s2,32(sp)
	addi	sp,sp,48
	tail	Hacl_Hash_Core_SHA2_finish_256
	.size	Hacl_Hash_SHA2_hash_256, .-Hacl_Hash_SHA2_hash_256
	.section	.public,"aw"
	.align	2
	.set	.LANCHOR1,. + 0
	.type	k224_256, @object
	.size	k224_256, 256
k224_256:
	.word	1116352408
	.word	1899447441
	.word	-1245643825
	.word	-373957723
	.word	961987163
	.word	1508970993
	.word	-1841331548
	.word	-1424204075
	.word	-670586216
	.word	310598401
	.word	607225278
	.word	1426881987
	.word	1925078388
	.word	-2132889090
	.word	-1680079193
	.word	-1046744716
	.word	-459576895
	.word	-272742522
	.word	264347078
	.word	604807628
	.word	770255983
	.word	1249150122
	.word	1555081692
	.word	1996064986
	.word	-1740746414
	.word	-1473132947
	.word	-1341970488
	.word	-1084653625
	.word	-958395405
	.word	-710438585
	.word	113926993
	.word	338241895
	.word	666307205
	.word	773529912
	.word	1294757372
	.word	1396182291
	.word	1695183700
	.word	1986661051
	.word	-2117940946
	.word	-1838011259
	.word	-1564481375
	.word	-1474664885
	.word	-1035236496
	.word	-949202525
	.word	-778901479
	.word	-694614492
	.word	-200395387
	.word	275423344
	.word	430227734
	.word	506948616
	.word	659060556
	.word	883997877
	.word	958139571
	.word	1322822218
	.word	1537002063
	.word	1747873779
	.word	1955562222
	.word	2024104815
	.word	-2067236844
	.word	-1933114872
	.word	-1866530822
	.word	-1538233109
	.word	-1090935817
	.word	-965641998
	.type	h256, @object
	.size	h256, 32
h256:
	.word	1779033703
	.word	-1150833019
	.word	1013904242
	.word	-1521486534
	.word	1359893119
	.word	-1694144372
	.word	528734635
	.word	1541459225
	.section	.secret,"aw"
	.align	2
	.set	.LANCHOR0,. + 0
	.type	computed_ws.30, @object
	.size	computed_ws.30, 256
computed_ws.30:
	.zero	256
	.type	x.32, @object
	.size	x.32, 4
x.32:
	.zero	4
	.type	hash1.31, @object
	.size	hash1.31, 32
hash1.31:
	.zero	32
	.type	tmp_twoblocks.1, @object
	.size	tmp_twoblocks.1, 128
tmp_twoblocks.1:
	.zero	128
	.type	scrut.0, @object
	.size	scrut.0, 32
scrut.0:
	.word	1779033703
	.word	-1150833019
	.word	1013904242
	.word	-1521486534
	.word	1359893119
	.word	-1694144372
	.word	528734635
	.word	1541459225
	.ident	"GCC: (GNU) 11.1.0"
