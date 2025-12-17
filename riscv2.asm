_start:
    # Declaração de variaveis
    li x2, 0x104      # x2 = LEDr
    li x3, 0x120      # x3 = Switches
	li x7, 0x200		#verifica o key3
	li x4, 0x110      #x4 = Key
loop:
	#LEDr = SW
    lw x1, 0(x3) #x1 = MEM[SW]
	sw x1, 0(x2) #MEM[LEDr] = x1

	lw x6, 0(x4) #x6 = MEM[Key]
    #beq  x0, x0, loop
	#Tentando alterar


	j loop

verifica:

certo:
	#mensagem de correto
errado:
	#mensagem de incorreto
