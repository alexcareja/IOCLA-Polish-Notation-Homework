%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main

atoi:
    push ebp
    mov ebp, esp
    mov edi, [ebp + 8]
    mov ecx, 0 ;ecx = 0 -> pozitiv; ecx = 1 -> negativ
    mov eax, 0
    
while:
    movzx esi, byte [edi]
    cmp esi, 0x00000000
    je finished_string
    
    cmp esi, 45 ;ascii for '-'
    je negative
    
    cmp esi, 48 ;ascii for '0'
    jl error
    
    cmp esi, 57; ascii for '9'
    jg error
    
    sub esi, 48
    mov edx, 10
    imul edx
    add eax, esi
    
    inc edi
    jmp while
    
negative:
    mov ecx, 1
    inc edi
    jmp while    
 
error:
    mov eax, 0
    
finished_string:
    cmp ecx, 0
    je return_atoi
    mov edx, -1
    imul edx
    
return_atoi:
    leave
    ret


is_operation:
    push ebp
    mov ebp, esp
    mov edi, [ebp + 8]
    mov edx, 0 ; edx = 0 -> not operation; eax = 1 -> operation
    movzx esi, byte [edi]
    
    cmp esi, 42 ;'*'
    je is_op
    cmp esi, 43 ;'+'
    je is_op
    cmp esi, 45 ;'-'
    je is_op
    cmp esi, 47 ;'/'
    je is_op
    jmp not_op
    
is_op:
    inc edi
    movzx esi, byte [edi]
    mov edx, 1
    cmp esi, 0x00000000
    je return_is_op
    
not_op:
    mov edx, 0
    
return_is_op:
    leave
    ret


solve:  ;result stored in eax
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 8]
    ;mov eax, [ebx]     ;asa se afiseaza
    ;PRINT_STRING [eax] ;operatia +-*/
    mov eax, [ebx]  ;Data
    push eax
    call is_operation
    cmp edx, 1
    je calc_result  ;Daca e numar il returnez
    mov eax, [ebx]  ;Data
    push eax
    call atoi
    jmp end_solve
    
calc_result:
    ;get left result
    mov eax, [ebx + 4]
    push ebx    ;current node address
    push eax    ;left node address
    call solve
    pop ebx
    pop ebx
    
    ;get right result
    push eax    ;left node value
    mov eax, [ebx + 8]
    push ebx    ;current node address
    push eax    ;right node address
    call solve
    pop ebx
    pop ebx
    pop edx
    xchg eax, edx
    
    ;discover operation
    mov edi, [ebx]
    movzx esi, byte [edi]
    cmp esi, 43 ;'+'
    jz addition
    cmp esi, 42 ;'*'
    jz multiplication
    cmp esi, 45 ;'-'
    jz subtraction
    cmp esi, 47 ;'/'
    jz division

multiplication:
    imul edx
    jmp end_solve
addition:
    add eax, edx
    jmp end_solve
subtraction:
    sub eax, edx
    jmp end_solve
division:
    mov ecx, edx    ;avoid floating
    mov edx, 0      ;point exception
    cdq				;sign extension for edx:eax
    idiv ecx
    
end_solve:  
    leave
    ret

main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    mov eax, [root]
    ;mov ebx, [eax]
    ;PRINT_STRING [ebx]
    ;mov ebx, [eax + 32]
    ;PRINT_STRING [ebx]
    ;push ebx
    ;call atoi
    ;PRINT_DEC 4, eax
    push eax
    call solve
    PRINT_DEC 4, eax
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret
