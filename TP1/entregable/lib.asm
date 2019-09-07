
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
 
;-- -- -- -- -- -- -- --
;rdi = chars* nombre
;rsi = fichero
strPrint:
    mov rdx, rsi
    mov rsi, rdi
    mov rdi, rdx
    call fprintf
    ret
    



%define l_offset_first 0
%define l_offset_last 8

%define NULL 0

%define node_size 24
%define node_offset_data 0
%define node_offset_next 8
%define node_offset_prev 16

listNew:
    push rbp 
    mov rbp, rsp
    mov rdi, 16
    call malloc 
    mov QWORD [rax + l_offset_first], NULL
    mov QWORD [rax + l_offset_last], NULL
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = puntero a lista
;rsi = puntero a data
listAddFirst:
    push rbp    
    push r12
    push r13

    mov rbp, rsp
    mov r12, rsi
    mov r13, rdi

    mov rdi, node_size
    call malloc

    mov rdi, [r13 + l_offset_first]


    mov [rax + node_offset_data], r12 ; r12 es puntero a data.
    mov [rax + node_offset_next], rdi ; next es rdi
    mov QWORD [rax + node_offset_prev], NULL ; addFirst no posee valor previo.

    cmp QWORD rdi, NULL 
    je _noNextElement
    mov [rdi + node_offset_prev], rax

_noNextElement:   
    mov [r13 + l_offset_first], rax ; r13 es puntero a lista

    cmp QWORD [r13 + l_offset_last], NULL
    jne _endlistAddFirst
    mov [r13 + l_offset_last], rax

_endlistAddFirst:
    pop r13
    pop r12
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = puntero a lista
;rsi = puntero a data
listAddLast:
    push rbp    
    push r12
    push r13

    mov rbp, rsp
    mov r12, rsi
    mov r13, rdi

    mov rdi, node_size
    call malloc

    mov rdi, [r13 + l_offset_last]

    mov [rax + node_offset_data], r12 ; r12 es puntero a data.
    mov QWORD [rax + node_offset_next], NULL ; addLast no posee valor siguiente.
    mov [rax + node_offset_prev], rdi ; prev es rdi

    cmp QWORD rdi, NULL 
    je _noPrevElement
    mov [rdi + node_offset_next], rax

_noPrevElement:   
    mov [r13 + l_offset_last], rax ; r13 es puntero a lista

    cmp QWORD [r13 + l_offset_first], NULL
    jne _endlistAddLast
    mov [r13 + l_offset_first], rax

_endlistAddLast:
    pop r13
    pop r12
    pop rbp
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
