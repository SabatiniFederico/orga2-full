
section .rodata

section .text

extern malloc
extern free
extern fprintf

global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global hashTableNew
global hashTableAdd
global hashTableDeleteSlot
global hashTableDelete

;-- -- -- -- -- -- -- --
;rdi = *chars
strLen:
    push rbp
    mov rbp, rsp

    mov rax, 0
_lenLoop:
    inc rax
    mov cl, [rdi]
    inc rdi
    cmp cl, 0
    jne _lenLoop
    dec rax
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = *chars
strClone:
    push rbp  
    mov rbp, rsp

    mov rsi, rdi
    mov r8, rdi
    mov rdi, 0

_cloneLoop:
    inc rdi
    mov cl, [r8]
    inc r8
    cmp cl, 0
    jne _cloneLoop

    dec rdi

    push rdi
    push rsi
    call malloc
    pop rsi
    pop rdi

    mov r8, rax

;r9 = *chars origen
;r8 = *chars destino
;rdi = lenght
_copyLoop:
    dec rdi

    mov cl, [rsi]
    mov [r8], cl

    inc r8
    inc rsi

    cmp rdi, 0
    jne _copyLoop

    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = chars* cmpA
;rsi = chars* cmpB 
strCmp:
    push rbp  
    mov rbp, rsp

_cmpLoop:

    mov cl, [rdi]
    mov bl, [rsi]

    cmp cl, bl

    jg _Apeor
    jl _Bpeor

    cmp cl, 0
    je _ABiguales

    inc rdi
    inc rsi
    jmp _cmpLoop

_ABiguales:
    mov rax, 0
    jmp _endcmp
_Apeor:
    mov rax, -1
    jmp _endcmp
_Bpeor:
    mov rax, 1

_endcmp:
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = chars* cmpA
;rsi = chars* cmpB 
strConcat:
    push rbp  
    push rdi
    push rsi
    mov rbp, rsp

    call strLen
    push rax
    mov rdi, rsi
    call strLen
    pop rdi
    add rdi, rax

    call malloc 

    mov r8, rax
    pop rsi
    pop rdi

_addcmpA:
    mov cl, [rdi]
    inc rdi
    cmp cl, 0
    je _addcmpB

    mov [r8], cl    
    inc r8
    jmp _addcmpA

_addcmpB:
    mov cl, [rsi]
    mov [r8], cl 
    inc rsi    
    inc r8
    cmp cl, 0
    jne _addcmpB

    pop rbp
    ret

;-- -- -- -- -- -- -- --
strDelete:
    call free
    ret
 
strPrint:
    ret
    
listNew:
    ret

listAddFirst:
    ret

listAddLast:
    ret

listAdd:
    ret

listRemove:
    ret

listRemoveFirst:
    ret

listRemoveLast:
    ret

listDelete:
    ret

listPrint:
    ret

hashTableNew:
    ret

hashTableAdd:
    ret
    
hashTableDeleteSlot:
    ret

hashTableDelete:
    ret
