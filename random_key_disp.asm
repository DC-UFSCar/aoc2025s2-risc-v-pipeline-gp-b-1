.text

.globl _start

_start:
	li a0, 0x104 #LEDR
	li a1, 0x108 #HEX
	li a2, 0x110 #KEYS
	li a3, 0x120 #SW
	li a4, 0x204 #TRNG
	
	lw s0, 0(a4)
	
loop:
	lw t0, 0(a4)
	sw t0, 0(a0)
	bne t0, s0, loop
	lw s0, 0(a4)
	j loop



	

