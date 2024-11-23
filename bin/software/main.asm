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
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	nop
$L2:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L2
	nop

	li	$2,1000			# 0x3e8
	li	$3,72			# 0x48
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L3:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L3
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L4:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L4
	nop

	li	$2,1000			# 0x3e8
	li	$3,101			# 0x65
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L5:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L5
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L6:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L6
	nop

	li	$2,1000			# 0x3e8
	li	$3,108			# 0x6c
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L7:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L7
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L8:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L8
	nop

	li	$2,1000			# 0x3e8
	li	$3,108			# 0x6c
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L9:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L9
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L10:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L10
	nop

	li	$2,1000			# 0x3e8
	li	$3,111			# 0x6f
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L11:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L11
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L12:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L12
	nop

	li	$2,1000			# 0x3e8
	li	$3,32			# 0x20
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L13:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L13
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L14:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L14
	nop

	li	$2,1000			# 0x3e8
	li	$3,87			# 0x57
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L15:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L15
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L16:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L16
	nop

	li	$2,1000			# 0x3e8
	li	$3,111			# 0x6f
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L17:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L17
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L18:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L18
	nop

	li	$2,1000			# 0x3e8
	li	$3,114			# 0x72
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L19:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L19
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L20:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L20
	nop

	li	$2,1000			# 0x3e8
	li	$3,108			# 0x6c
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L21:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L21
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L22:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L22
	nop

	li	$2,1000			# 0x3e8
	li	$3,100			# 0x64
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L23:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L23
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
$L24:
	li	$2,1003			# 0x3eb
	lb	$2,0($2)
	nop
	bne	$2,$0,$L24
	nop

	li	$2,1000			# 0x3e8
	li	$3,33			# 0x21
	sb	$3,0($2)
	li	$2,1001			# 0x3e9
	li	$3,1			# 0x1
	sb	$3,0($2)
$L25:
	li	$2,1002			# 0x3ea
	lb	$2,0($2)
	nop
	beq	$2,$0,$L25
	nop

	li	$2,1001			# 0x3e9
	sb	$0,0($2)
	b	$L2
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 12.3.0-17ubuntu1) 12.3.0"
	.section	.note.GNU-stack,"",@progbits
