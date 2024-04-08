	.file	"sha2.c"
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
	li	a1,300
	addi	a2,s0,%lo(.LANCHOR0)
	addi	a0,a0,32
	sw	s1,20(sp)
	sw	ra,28(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	lui	s1,%hi(.LANCHOR1)
	call	Hacl_Hash_SHA2_hash_256
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
	.globl	public
	.globl	hash
	.globl	secret
	.section	.declassified,"aw"
	.align	2
	.set	.LANCHOR1,. + 0
	.type	public, @object
	.size	public, 32
public:
	.zero	32
	.section	.secret,"aw"
	.align	2
	.set	.LANCHOR0,. + 0
	.type	hash, @object
	.size	hash, 32
hash:
	.zero	32
	.type	secret, @object
	.size	secret, 300
secret:
	.ascii	"Q\353\330\273\225_\242\221o\207'\266{<\323\340\025\300qT\031"
	.ascii	"@\2712[\024A\277S\276j\304\340\252\317\222\244\254]E\233rI\r"
	.ascii	"\271\221T\227N\342\246\331\251\332\001\005:\325beJ<\335\2571"
	.ascii	"\007\026\314\030Z\231\333P\21142/7\034\263A\002\"\263]{2\360"
	.ascii	"\221w\363L9\245\247\371\302s\201\261\232Pq9\306\263\345\022\355"
	.ascii	">\207\313\305F\034|\210IQ}\214T\244\332Xx\207\340o\032+\322@"
	.ascii	"\013Grv[\007\273;\326\3458\\F|`\320\003\307\345\227\026|#E&)"
	.ascii	"\274A\021\027\210x\344\3162-\243\2274s:\271&[\335\322\016\250"
	.ascii	"\275\324\250q\256\230i@%\223\350\211\201\305\021\343\230[\312"
	.ascii	"\334\270\213\177\222\310\322\276\355\304\205\206\017:)\034\t"
	.ascii	"\b\374L\342\213j\200\235\274\244\262Z\374f+\3045&\257i\363\264"
	.ascii	"\377\342\016eX*iw\267l\332G\212x\316\201\2364\373(\226\202\332"
	.ascii	"\306np\240F\251|\035\250\212\224fF>\240t\016\016\026%\307\257"
	.ascii	"s\372\253\036R,t\275\021)\351\032\230\223[:"
	.ident	"GCC: (GNU) 11.1.0"
