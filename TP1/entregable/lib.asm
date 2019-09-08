
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

    xor rax, rax
.lenLoop:
    inc rax
    mov cl, [rdi]
    inc rdi
    cmp cl, 0
    jne .lenLoop
    dec rax
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = *chars
strClone:
    push rbp  
    push r12
    push r13

    mov rbp, rsp
    xor rax, rax
    mov r12, rdi ; puntero original

    call strLen
    mov rdi, rax
    inc rdi

    call malloc
    mov r13, rax ; direccion copia

.copyLoop:
    
    mov cl, [r12]
    mov [r13], cl

    inc r12 
    inc r13

    cmp cl, 0
    jne .copyLoop

    pop r13
    pop r12
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = chars* cmpA
;rsi = chars* cmpB 
strCmp:

    push rbp  
    mov rbp, rsp
    xor rax, rax

.cmpLoop:

    mov cl, [rdi]
    mov bl, [rsi]

    cmp cl, bl

    jg .Apeor
    jl .Bpeor

    cmp cl, 0
    je .ABiguales

    inc rdi
    inc rsi
    jmp .cmpLoop

.ABiguales:
    mov rax, 0
    jmp .endcmp
.Apeor:
    mov rax, -1
    jmp .endcmp
.Bpeor:
    mov rax, 1

.endcmp:
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi = chars* cmpA
;rsi = chars* cmpB 
strConcat:
    push rbp  
    push r12
    push r13
    push r14

    mov rbp, rsp
    mov r12, rdi; cmpA
    mov r13, rsi; cmpB
    xor rax, rax

    call strLen
    push rax

    mov rdi, rsi
    call strLen
    pop rdi
    add rdi, rax
    inc rdi
    call malloc 

    mov r8, rax
    mov r14, rax
    mov rdi, r12
    mov rsi, r13

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

    mov rdi, r12
    call free
    cmp r12, r13

    je _avoidStrFreeDuplication
    mov rdi, r13
    call free
_avoidStrFreeDuplication: 
    mov rax, r14

    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;-- -- -- -- -- -- -- --
strDelete:
    call free
    ret
 
%define NULL 0
textnull db "NULL",0
;-- -- -- -- -- -- -- --
;rdi = chars* nombre
;rsi = fichero
strPrint:
    push rbp  
    mov rbp, rsp

    mov rdx, rsi
    mov rsi, rdi
    mov rdi, rdx

    cmp BYTE [rsi], NULL
    jne _strprintNoNull
    mov rsi, textnull

_strprintNoNull:
    call fprintf
    pop rbp 
    ret
    
%define l_offset_first 0
%define l_offset_last 8

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


;-- -- -- -- -- -- -- --
listAdd:
    push rbp    
    push r12
    push r13
    push r14
    push r15

    mov rbp, rsp
    mov r12, rdi ; puntero a lista
    mov r13, rsi ; puntero a data
    mov r14, rdx ; puntero a compare function     

    mov rdi, node_size
    call malloc

    mov r15, rax ; puntero a nuevo nodo

    ;Chequeo si la lista no esta vacia 
    cmp QWORD [r12 + l_offset_first], NULL
    je _listAddFirst

    mov r8, [r12 + l_offset_first]
    mov r8, [r8]
    mov rdi, r8
    mov rsi, r13

    ;Chequeo si nuevo elemento debe ser colocado en la primera casilla.
    call QWORD r14
    cmp rax, -1
    je _listAddFirst

    mov r8, [r12 + l_offset_last]
    mov r8, [r8]
    mov rdi, r8
    mov rsi, r13

    ;Chequeo si nuevo elemento debe ser colocado en la ultima casilla.
    call QWORD r14
    cmp rax, 1
    je _listAddLast

    ;No tengo mas casos borde, loopeo y termino.
    mov r12, [r12 + l_offset_first]
    ;tengo que hacer sucesivos llamados a cmp.
_siguiente:
    
    mov rdi, [r12 + node_offset_data]
    mov rsi, r13


    call QWORD r14
    cmp rax, -1
    je _insertNewNode

    mov r12, [r12 + node_offset_next]
    jmp _siguiente

_insertNewNode:
    mov [r15 + node_offset_data], r13 ; inserto la data en rax.

    ;acomodo los punteros en nuevo nodo.
    mov rsi, r12
    mov [r15 + node_offset_next], rsi
    mov rsi, [r12 + node_offset_prev] 
    mov [r15 + node_offset_prev], rsi

    ;acomodo los punteros en prev y next
    mov rdi, [r12 + node_offset_prev]

    mov rsi, [r15 + node_offset_prev]
    mov [rdi + node_offset_next], rsi

    mov rsi, [r15 + node_offset_next]
    mov [r12 + node_offset_prev], rsi
    jmp _endListAdd
;si lista esta vacia listAdd es igual a listAddFirst,
;si primer elemento mayor a data, listAdd es igual a listAddFirst
_listAddFirst:
    mov rdi, r12
    mov rsi, r13
    call listAddFirst
    jmp _endListAdd

;Si ultimo elemento menor a data, 
_listAddLast:
    mov rdi, r12
    mov rsi, r13
    call listAddLast
    jmp _endListAdd

_endListAdd:

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
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
