section .text
    global suma
 
suma:
	MOV RAX, RDI 
	ADD RAX, RSI
	RET