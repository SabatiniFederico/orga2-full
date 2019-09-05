section .text
    global suma

suma:
	;RDI = vector
	;SI = n

	push rbp
	mov rbp, rsp
	push r12

	xor r12, r12
	xor rcx, rcx
	mov cx, si

.cicloSuma:
	add r12w, [rdi]
	lea rdi, [rdi+2]
	loop .cicloSuma

	mov rax, r12

;fin
	pop r12
	pop rbp
	ret