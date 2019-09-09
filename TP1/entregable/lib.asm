
section .rodata
textnull: db "NULL",0
textString: db "%s",0

listaCorcheteIzq: db  "[",0
listaCorcheteDer:  db  "]",0
listaSeparador:  db  ",",0

%define l_size 16
%define l_offset_first 0
%define l_offset_last 8

%define node_size 24
%define node_offset_data 0
%define node_offset_next 8
%define node_offset_prev 16

%define hash_size 24
%define hash_offset_listArray 0
%define hash_offset_size 8
%define hash_offset_funcHash 16 ; el alineamiento me hace desperdiciar 4 bytes, uint32 = 4.


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
    mov rbp, rsp

    push r12
    push r13

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
    mov rbp, rsp
    sub rsp, 8 ; Alineo los push.

    push r12
    push r13
    push r14

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
    add rsp, 8
    pop rbp
    ret

;-- -- -- -- -- -- -- --
strDelete:
    push rbp
    mov rbp, rsp

    call free

    pop rbp
    ret
 
%define NULL 0


;-- -- -- -- -- -- -- --
;rdi = chars* nombre
;rsi = fichero
strPrint:
    push rbp
    mov rbp, rsp

    mov rdx, rdi ; chars* en rdx
    mov rdi, rsi ; fichero en rdi
    mov rsi, textString ; %s en rsi

    cmp BYTE [rdx], NULL
    jne .printIsNotNull

    mov rsi, textnull
.printIsNotNull:
    call fprintf

    pop rbp 
    ret

listNew:
    push rbp 
    mov rbp, rsp

    mov rdi, l_size
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
    mov rbp, rsp

    push r12
    push r13

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
    mov rbp, rsp

    push r12
    push r13


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
    mov rbp, rsp    
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; puntero a lista
    mov r13, rsi ; puntero a data
    mov r14, rdx ; puntero a compare function     

    ;Chequeo si la lista no esta vacia 
    cmp QWORD [r12 + l_offset_first], NULL
    je .listAddFirst

    mov r8, [r12 + l_offset_first]
    mov r8, [r8]
    mov rdi, r8
    mov rsi, r13

    ;Chequeo si nuevo elemento debe ser colocado en la primera casilla.
    call QWORD r14
    cmp rax, 1
    jne .listAddFirst

    mov r8, [r12 + l_offset_last]
    mov r8, [r8]
    mov rdi, r8
    mov rsi, r13

    ;Chequeo si nuevo elemento debe ser colocado en la ultima casilla.
    call QWORD r14
    cmp rax, -1
    jne .listAddLast

    ;No tengo mas casos borde, creo el nodo, loopeo y termino.
    mov rdi, node_size
    call malloc 

    mov r15, rax ; puntero a nuevo nodo


    mov r12, [r12 + l_offset_first]
    ;tengo que hacer sucesivos llamados a cmp.
.siguienteAdd:
    
    mov rdi, [r12 + node_offset_data]
    mov rsi, r13

    call QWORD r14
    cmp rax, 1
    jne .insertNewNode

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
    mov [r12 + node_offset_prev], r15
    mov [rsi + node_offset_next], r15
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
    mov rbp, rsp
    sub rsp, 8

    push r12

    mov r12, rdi ; r12 es lista

    cmp QWORD [rdi + l_offset_first], NULL
    je .end

    ;Chequeo que fd no sea cero.
    cmp QWORD rsi, NULL
    je .noFd

    mov rdi, [rdi + l_offset_first]         ; l -> first
    mov rdi, [rdi + node_offset_data]       ; l -> first-> data
    call rsi                                ; data removed
.noFd:

    mov rdi, [r12 + l_offset_first]         ; l->first
    mov rsi, [r12 + l_offset_first]

    mov rdi, [rdi+ node_offset_next]        ; new_first = l - >first -> next

    cmp QWORD rdi, NULL ; reviso que exista el next.
    je .noNext

    mov QWORD [rdi + node_offset_prev], NULL       ; l -> first -> next -> prev = NULL
    mov [r12 + l_offset_first], rdi         ; l -> first = l -> first -> next -> prev
    jmp .endRemoveFirst
.noNext:
    mov QWORD [r12 + l_offset_first], NULL  ; l -> first = NULL 
    mov QWORD [r12 + l_offset_last], NULL  

.endRemoveFirst:
    mov rdi, rsi
    call free ; Elmino efectivamente el nodo.

.end:
    pop r12
    add rsp, 8
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi es puntero a lista
;rsi es puntero a delete func.
listRemoveLast:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push r12

    mov r12, rdi ; r12 es lista

    cmp QWORD [rdi + l_offset_last], NULL
    je .end

    ;Chequeo que fd no sea cero.
    cmp QWORD rsi, NULL
    je .noFd

    mov rdi, [rdi + l_offset_last]          ; l -> last
    mov rdi, [rdi + node_offset_data]       ; l -> last-> data
    call rsi                                ; data removed
.noFd:

    mov rdi, [r12 + l_offset_last]          ; l -> last
    mov rsi, [r12 + l_offset_last]

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
    mov QWORD [r12 + l_offset_last], NULL  


.endRemoveLast:
    mov rdi, rsi
    call free

.end:
    pop r12
    add rsp, 8
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi es puntero a lista
;rsi es puntero a data
;rdx es puntero a func compare
;rcx es puntero a delete func.
listRemove:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi    ; list
    mov r13, rsi    ; data
    mov r14, rdx    ; cmp func
    mov r15, rcx    ; del func

    ; Aclaración del TP, casi siempre trato de pasar los scratch registers
    ; a registros que se preservan en especial si los voy a usar, por que por ejemplo 

    ; r15 y r14 son funciones que necesito realizar Call, es re molesto laburar sin mantenerlas.
    ; r13 es la data que tengo que eliminar, y hacer el CMP, en general lo voy a usar varias veces en el loop
    ; r12 inicia en lista, y minimamente necesito usarlo para iterar.

.revisarCasosBorde:

    ;Primero chequeo si la lista no esta vacia 
    cmp QWORD [r12 + l_offset_first], NULL
    je .endDelete                               ; -> Si esta vacia termine.

    mov rdi, [r12 + l_offset_first]
    mov rdi, [rdi]
    mov rsi, r13

    ;Chequeo si El primer elemento debe ser eliminado.
    call QWORD r14
    cmp rax, 0
    jne .siguiente

    ;Necesito eliminar el primer elemento, son iguales.
    mov rdi, r12
    mov rsi, r15
    call listRemoveFirst    ;Elimino el primer elemento.
    jmp .revisarCasosBorde  ;Mi lista a sido modificada! debo revalidar si no esta vacia, (ademas el primer elemento podría estar repetido)

.siguiente:

    mov rdi, [r12 + l_offset_last]
    mov rdi, [rdi]
    mov rsi, r13
    ;Chequeo si el último elemento debe ser eliminado.
    call QWORD r14
    cmp rax, 0
    jne .buscarEnMedio

    ;Necesito eliminar el ultimo elemento, son iguales.
    mov rdi, r12
    mov rsi, r15
    call listRemoveLast     ;Elimino el primer elemento.
    jmp .revisarCasosBorde  ;Mi lista a sido modificada! debo revalidar si no esta vacia, (ademas el ultimo elemento podría estar repetido)

.buscarEnMedio:

    ;Llegado a este punto no hay mas casos borde, solo tengo que revisar el medio con un loop y termino.
    mov r12, [r12 + l_offset_first]

.loopMedio:
    ;reviso si es el último elemento, ya que si es el caso, termine
    cmp QWORD r12, NULL
    je .endDelete

    mov rdi, r13
    mov rsi, [r12 + node_offset_data]


    mov r12, [r12 + node_offset_next]
    call QWORD r14                      ; -> Comparo
    cmp rax, 0
    jne .loopMedio

    mov rdi, [r12 + node_offset_prev]

    push QWORD [rdi + node_offset_prev]
    push QWORD [rdi + node_offset_next] ; -> esto lo hago de vago, pusheo los punteros del nodo que voy a eliminar
                                        ; -> para luego hacer pop y actualizarlos, (pido disculpas por la falta de elegancia)
    
    ;Chequeo que fd no sea cero.
    cmp QWORD r15, NULL
    je .noFd

    mov rdi, [rdi + node_offset_data]   ; asigno data a rdi y la elimino
    call r15    
.noFd:                                 
    mov rdi, [r12 + node_offset_prev]   ; elimino el nodo
    call free
    pop rdi                         ; al ser 2 push se mantiene la alineacion.
    pop rsi                         ; y al guardarlos los actualizo en el acto.

    mov [rdi + node_offset_prev], rsi
    mov [rsi + node_offset_next], rdi

    jmp .loopMedio


.endDelete:

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;-- -- -- -- -- -- -- --
;rdi es puntero a lista
;rsi es delete func
listDelete:

    ;Bueno. Esto se puede hacer de 2 maneras, una fácil es abusar de listRemoveFirst
    ;hasta que la lista este vacia.

    ;entiendo que eso pierde un poco de performance. así que voy a loopear.
    push rbp
    mov rbp, rsp
    sub rsp, 8

    push r12 
    push r13
    push r14

    mov r12, rdi ; r12 es lista
    mov r13, [r12 + l_offset_first] ; mi iterador
    mov r14, rsi ; my delete func.

.deleteLoop:
    cmp QWORD r13, NULL ; reviso que exista el next.
    je .endDelete

    ;Chequeo que fd no sea cero.
    cmp QWORD r14, NULL
    je .noFd

    mov rdi, [r13 + node_offset_data] ; asigno data a rdi y la elimino
    call r14
.noFd:

    mov rdi, r13; elimino el nodo
    mov r13, [r13 + node_offset_next]
    call free

    jmp .deleteLoop

.endDelete:
    ; Finalmente tengo que eliminar la lista.
    mov rdi, r12
    call free

    pop r14
    pop r13
    pop r12
    add rsp, 8
    pop rbp
    ret

;-- -- -- -- -- -- -- --
listPrint:
    push rbp
    mov rbp, rsp
    sub rsp, 8 ;
    push r12 
    push r13
    push r14

    mov r12, rdi ; r12 es lista
    mov r13, rsi ; r13 es FILE
    mov r14, rdx ; r14 es funcPrint

    mov rdi, listaCorcheteIzq
    mov rsi, r13
    call strPrint                               ; -> prints "["

    cmp QWORD [r12+ l_offset_first], NULL       ; Reviso que exista first elem
    je .endPrint

    mov r12, [r12 + l_offset_first]             ; -> itero al primer elem
    mov rdi, [r12 + node_offset_data]       
    mov rsi, r13        
    call QWORD r14                               ; -> prints "data"

.loopPrint:
    cmp QWORD [r12 + node_offset_next], NULL    ; Reviso que exista sig elem
    je .endPrint

    mov rdi, listaSeparador
    mov rsi, r13
    call strPrint                               ; -> prints ","

    mov r12, [r12 + node_offset_next]           ; -> itero al siig elem
    mov rdi, [r12 + node_offset_data]       
    mov rsi, r13
    call QWORD r14                               ; -> prints "data"

    jmp .loopPrint

.endPrint:
    mov rdi, listaCorcheteDer
    mov rsi, r13
    call strPrint                           ; -> prints "]"

    pop r14
    pop r13
    pop r12
    add rsp, 8
    pop rbp
    ret



;rdi -> Size
;rsi -> funcHasH
hashTableNew:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push r12    
    push r13
    push r14

    xor r12, r12        ; <- limpio r12, ya que unint_32 no ocupa 64bits.
    mov r12, rdi        ; <- size
    mov r13, rsi        ; <- puntero a funcHash

    mov rdi, hash_size
    call malloc
    mov r14, rax        ; <- puntero a hash

    mov [r14 + hash_offset_size], r12
    mov [r14 + hash_offset_funcHash], r13   ; <- seteo funcHash, y size, registros r12 y r13 ya no los necesito
                                            ; <- puedo usarlos como quiera.

    ;Primero necesito crear una lista Principal de punteros a listas.
    ;Nota personal: una hashTable en este contexto es literalmente una matriz,
    ; con un ordenamiento especial, dado por una funcion de hash.

    call listNew
    mov [r14 + hash_offset_listArray], rax  ; <- seteo el puntero a la lista principal.

    ;tengo que crear r12 (size) listas. Refrescar fd* a 0, ya que es lista de punteros.

.loopTablas:
    dec r12 ; <- NOTA: Unsigned int no puede contener negativos, uno de mis errores fue que si
            ; <- se decrementa r12 = 0, r12 = MAX_INT positivo. Y loopea infinitamente.

    call listNew
    mov rdi, [r14] ;rdi = puntero a lista principal
    mov rsi, rax   ;rsi = puntero a lista interna

    call listAddFirst

    cmp r12, 0
    jne .loopTablas

    ;termine de crear todas las listas que necesitaba

    mov rax, r14
    pop r14
    pop r13
    pop r12
    add rsp, 8
    pop rbp
    ret

hashTableAdd:
    ret
    
hashTableDeleteSlot:
    ret

hashTableDelete:
    ret
