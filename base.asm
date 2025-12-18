.text

.globl _start

_start:
	li a0, 0x104 #LEDR
	li a1, 0x108 #HEX
	li a2, 0x110 #KEYS
	li a3, 0x120 #SWITCHES
	li a4, 0x202 #TRNG
	li a5, 0x204 #SET PT
	li a6, 0x208 #GET CIPHERTEXT
	
	lw s0, 0(a4) # Pegamos uma chave primária para comparação.
	lw s1, 0(a3) # Pegamos o conteúdo dos switches
	sw s1, 0(a5) # Salvamos o conteúdo dos switches como a sequência que será criptografada.
	
loop:	
	lw s1, 0(a3) # Pegamos o conteúdo dos switches
	sw s1, 0(a5) # Salvamos o conteúdo dos switches como a sequência que será criptografada.
	lw t0, 0(a4) # Pega uma chave nova.
	sw s2, 0(a0) # Mostra o dado criptografado nos leds.
	beq t0, s0, loop # Compara a chave nova com a velha. Se a chave trocou, tem que recriptografar a informação.
	add s0, zero, t0 # Pega a chave antiga para comparação.
	lw s2, 0(a6) # Pega o dado criptografado.
	j loop



	

