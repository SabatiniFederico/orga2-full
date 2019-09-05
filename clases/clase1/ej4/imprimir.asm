section .text
    global imprimir
 
imprimir:
	push rbp
	mov rbp rsp
	push r12
	
    mov rax, [rdi]
    call _print
    ret

;input: rax as pointer to string
;output: print string at rax
_print:
    push rax
    mov rbx, 0
_printLoop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _printLoop
 
    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
 
    ret