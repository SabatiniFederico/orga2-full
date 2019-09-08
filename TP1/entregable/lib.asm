
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

.addcmpA:
    mov cl, [rdi]
    inc rdi
    cmp cl, 0
    je .addcmpB

    mov [r8], cl    
    inc r8
    jmp .addcmpA

.addcmpB:
    mov cl, [rsi]
    mov [r8], cl 
    inc rsi    
    inc r8
    cmp cl, 0
    jne .addcmpB

    mov rdi, r12
    call free
    cmp r12, r13

    je .avoidFreeDuplication
    mov rdi, r13
    call free

.avoidFreeDuplication: 
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
    jne .printIsNotNull
    mov rsi, textnull

.printIsNotNull:
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
    je .noNextElement
    mov [rdi + node_offset_prev], rax

.noNextElement:   
    mov [r13 + l_offset_first], rax ; r13 es puntero a lista

    cmp QWORD [r13 + l_offset_last], NULL
    jne .endAddFirst
    mov [r13 + l_offset_last], rax

.endAddFirst:
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
    je .noPrevElement
    mov [rdi + node_offset_next], rax

.noPrevElement:   
    mov [r13 + l_offset_last], rax ; r13 es puntero a lista

    cmp QWORD [r13 + l_offset_first], NULL
    jne .endAddLast
    mov [r13 + l_offset_first], rax

.endAddLast:
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
    je .listAddFirst

    mov r8, [r12 + l_offset_first]
    mov r8, [r8]
    mov rdi, r8
    mov rsi, r13

    ;Chequeo si nuevo elemento debe ser colocado en la primera casilla.
    call QWORD r14
    cmp rax, -1
    je .listAddFirst

    mov r8, [r12 + l_offset_last]
    mov r8, [r8]
    mov rdi, r8
    mov rsi, r13

    ;Chequeo si nuevo elemento debe ser colocado en la ultima casilla.
    call QWORD r14
    cmp rax, 1
    je .listAddLast

    ;No tengo mas casos borde, loopeo y termino.
    mov r12, [r12 + l_offset_first]
    ;tengo que hacer sucesivos llamados a cmp.
.siguienteAdd:
    
    mov rdi, [r12 + node_offset_data]
    mov rsi, r13


    call QWORD r14
    cmp rax, -1
    je .insertNewNode

    mov r12, [r12 + node_offset_next]
    jmp .siguienteAdd

.insertNewNode:
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
    jmp .endAdd
;si lista esta vacia listAdd es igual a listAddFirst,
;si primer elemento mayor a data, listAdd es igual a listAddFirst
.listAddFirst:
    mov rdi, r12
    mov rsi, r13
    call listAddFirst
    jmp .endAdd

;Si ultimo elemento menor a data, 
.listAddLast:
    mov rdi, r12
    mov rsi, r13
    call listAddLast
    jmp .endAdd

.endAdd:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret


;-- -- -- -- -- -- -- --
;rdi es puntero a lista
;rsi es puntero a delete func.
listRemoveFirst:
    push rbp    
    push r12

    mov rbp, rsp
    mov r12, rdi ; r12 es lista

    mov rdi, [rdi + l_offset_first]         ; l -> first
    mov rdi, [rdi + node_offset_data]       ; l -> first-> data
    call rsi                                ; data removed

    mov rdi, [r12 + l_offset_first]         ; l->first
    mov rdi, [rdi+ node_offset_next]        ; new_first = l - >first -> next

    cmp QWORD rdi, NULL ; reviso que exista el next.
    je .noNext

    mov [rdi + node_offset_prev], r12       ; l -> first -> next -> prev = NULL
    mov [r12 + l_offset_first], rdi         ; l -> first = l -> first -> next -> prev
    jmp .endRemoveFirst
.noNext:
    mov QWORD [r12 + l_offset_first], NULL  ; l -> first = NULL

.endRemoveFirst:
    pop r12
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi es puntero a lista
;rsi es puntero a delete func.
listRemoveLast:
    push rbp
    push r12

    mov rbp, rsp
    mov r12, rdi ; r12 es lista

    mov rdi, [rdi + l_offset_last]          ; l -> last
    mov rdi, [rdi + node_offset_data]       ; l -> last-> data
    call rsi                                ; data removed

    mov rdi, [r12 + l_offset_last]          ; l -> last
    mov rdi, [rdi + node_offset_prev]       ; new_last = l -> last -> prev

    cmp QWORD rdi, NULL ; reviso que exista el next.
    je .noPrev

    mov [r12 + l_offset_last], rdi   

    add r12, l_offset_last
    mov QWORD [rdi + node_offset_next], NULL       ; l -> last -> prev -> next = NULL
    sub r12, l_offset_last
    
    jmp .endRemoveLast
.noPrev:
    mov QWORD [r12 + l_offset_first], NULL  ; l -> first = NULL (es lo mismo que last en este caso)

.endRemoveLast:
    pop r12
    pop rbp
    ret

listRemove:
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
