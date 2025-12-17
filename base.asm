.text

.globl _start

_start:
	li a0, 0x104 #LEDR
	li a1, 0x108 #HEX
	li a2, 0x110 #KEY 
	li a3, 0x120 #SW
	li a4, 0x204 #TRNG
	li a5, 0x208 #AES
	li a6, 0x210 #AES READY
	li s0, 0
loop:
	addi s0, s0, 1
	sw s0, 0(a0)
	sw s0, 0(a4)
	j loop

	

