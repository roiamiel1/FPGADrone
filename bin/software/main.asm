	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=32
	.module	nooddspreg
	.module	arch=r2000
	.abicalls
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,32,$31		# vars= 16, regs= 1/0, args= 0, gp= 8
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$fp,28($sp)
	move	$fp,$sp
	li	$2,5			# 0x5
	sw	$2,16($fp)
	lui	$2,%hi($LC0)
	lwc1	$f0,%lo($LC0)($2)
	nop
	swc1	$f0,8($fp)
	lw	$2,16($fp)
	nop
	mtc1	$2,$f0
	nop
	cvt.s.w	$f0,$f0
	lwc1	$f2,8($fp)
	nop
	add.s	$f0,$f2,$f0
	swc1	$f0,8($fp)
	sw	$0,12($fp)
	.option	pic0
	b	$L2
	nop

	.option	pic2
$L3:
	lw	$2,16($fp)
	nop
	mtc1	$2,$f0
	nop
	cvt.s.w	$f0,$f0
	lwc1	$f2,8($fp)
	nop
	add.s	$f0,$f2,$f0
	swc1	$f0,8($fp)
	lw	$2,12($fp)
	nop
	addiu	$2,$2,1
	sw	$2,12($fp)
$L2:
	lw	$2,12($fp)
	nop
	slt	$2,$2,10
	bne	$2,$0,$L3
	nop

	move	$2,$0
	move	$sp,$fp
	lw	$fp,28($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.rdata
	.align	2
$LC0:
	.word	1089680179
	.ident	"GCC: (Ubuntu 12.3.0-17ubuntu1) 12.3.0"
	.section	.note.GNU-stack,"",@progbits
