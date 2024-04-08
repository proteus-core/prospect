	.file	"curve25519.c"
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
	addi	sp,sp,-32
	sw	s0,24(sp)
	lui	s0,%hi(.LANCHOR0)
	addi	a0,s0,%lo(.LANCHOR0)
	addi	a1,a0,32
	addi	a2,s0,%lo(.LANCHOR0)
	addi	a0,a0,64
	sw	s1,20(sp)
	sw	ra,28(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	lui	s1,%hi(.LANCHOR1)
	call	curve25519_donna
	addi	a4,s0,%lo(.LANCHOR0)
	li	a5,0
	addi	s1,s1,%lo(.LANCHOR1)
	li	a1,32
.L2:
	lbu	a2,0(a4)
	add	a3,s1,a5
	addi	a5,a5,1
	sb	a2,0(a3)
	addi	a4,a4,1
	bne	a5,a1,.L2
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
	li	s2,32
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
	.globl	declassified
	.globl	private
	.globl	public
	.globl	out
	.section	.declassified,"aw"
	.align	2
	.set	.LANCHOR1,. + 0
	.type	declassified, @object
	.size	declassified, 32
declassified:
	.zero	32
	.section	.secret,"aw"
	.align	2
	.set	.LANCHOR0,. + 0
	.type	out, @object
	.size	out, 32
out:
	.ascii	"\245F\343k\360R|\235;\026\025K\202F^\335b\024L\n\301\374Z\030"
	.ascii	"Pj\"D\272D\232\304"
	.type	public, @object
	.size	public, 32
public:
	.ascii	"\346\333hgX00\3335\224\301\244$\261_|rf$\354&\2635;\020\251\003"
	.ascii	"\246\320\253\034L"
	.type	private, @object
	.size	private, 32
private:
	.ascii	"\303\332U7\235\351\306\220\216\224\352M\362\215\bO2\354\317\003"
	.ascii	"I\034q\367T\264\007Uw\242\205R"
	.ident	"GCC: (GNU) 11.1.0"
