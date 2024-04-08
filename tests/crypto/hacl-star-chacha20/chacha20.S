	.file	"chacha20.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"%02x"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lui	a3,%hi(.LANCHOR1)
	addi	sp,sp,-32
	addi	a2,a3,%lo(.LANCHOR1)
	sw	s0,24(sp)
	lui	a4,%hi(.LANCHOR0)
	addi	s0,a2,104
	li	a5,0
	addi	a2,a2,32
	mv	a1,s0
	addi	a4,a4,%lo(.LANCHOR0)
	addi	a3,a3,%lo(.LANCHOR1)
	li	a0,72
	sw	s1,20(sp)
	sw	ra,28(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	lui	s1,%hi(.LANCHOR2)
	call	Hacl_Chacha20_chacha20_encrypt
	mv	a1,s0
	li	a5,0
	addi	s1,s1,%lo(.LANCHOR2)
	li	a2,72
.L2:
	lbu	a3,0(a1)
	add	a4,s1,a5
	addi	a5,a5,1
	sb	a3,0(a4)
	addi	a1,a1,1
	bne	a5,a2,.L2
	# Begin: Extra code to clear secrets from registers
	addi    sp,sp,-4
    sw      s1,0(sp)
	call clear_s_regs
	call clear_t_regs
    lw      s1,0(sp)
    addi    sp,sp,4
	# End
	li	s0,0
	lui	s3,%hi(.LC0)
	li	s2,72
.L3:
	add	a5,s1,s0
	lbu	a1,0(a5)
	addi	s0,s0,1
	addi	a0,s3,%lo(.LC0)
	call	printf
	bne	s0,s2,.L3
	li	a0,10
	call	putchar
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	li	a0,0
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.section	.declassify,"aw"
	.align	2
	.set	.LANCHOR2,. + 0
	.type	declassified, @object
	.size	declassified, 72
declassified:
	.zero	72
	.section	.public,"aw"
	.align	2
	.set	.LANCHOR0,. + 0
	.type	nonce, @object
	.size	nonce, 12
nonce:
	.string	""
	.ascii	"\001\002\003\004\005\006\007\b\t\020\021"
	.section	.secret,"aw"
	.align	2
	.set	.LANCHOR1,. + 0
	.type	key, @object
	.size	key, 32
key:
	.ascii	"\205\326\276xWUm3\177DR\376B\325\006\250\001\003\200\212\373"
	.ascii	"\r\262\375J\277\366\257AI\365\033"
	.type	message, @object
	.size	message, 72
message:
	.string	""
	.string	"\001\002\003\004\005\006\007\b\t\020\021\022\023\024\025\026\027\030\031 !\"#"
	.string	"\001\002\003\004\005\006\007\b\t\020\021\022\023\024\025\026\027\030\031 !\"#"
	.ascii	"\001\002\003\004\005\006\007\b\t\020\021\022\023\024\025\026"
	.ascii	"\027\030\031 !\"#"
	.type	ciphertext, @object
	.size	ciphertext, 72
ciphertext:
	.zero	72
	.ident	"GCC: (GNU) 11.1.0"
