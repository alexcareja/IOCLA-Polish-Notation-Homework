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
    mov ebx, 0 ;ebx = 0 -> pozitiv; ebx = 1 -> negativ
    mov eax, 0
    
while:
    movzx esi, byte [edi]
    ;test esi, esi
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
    mov ebx, 1
    inc edi
    jmp while    
 
error:
    mov eax, 0
    
finished_string:
    cmp ebx, 0
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


solve:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 8]
    ;mov eax, [ebx]     ;asa se afiseaza
    ;PRINT_STRING [eax] ;operatia +-*/
    mov eax, [ebx + 32] ;left
    push eax
    call is_operation
    cmp edx, 0
    je calc_right   ;in nodul din stanga este deja un nr
    ;TODO call operatie stanga + modific nod
    
calc_right:
    mov eax, [ebx + 64] ;right
    push eax
    call is_operation
    cmp edx, 0
    je calc_result
    ;TODO call operatie dreapta + modific nod
    
calc_result:
    ;parse left
    mov eax, [ebx + 32]
    push eax
    call atoi
    mov edx, eax
    ;parse right
    mov eax, [ebx + 64]
    push eax
    call atoi
    ;discover operation
    movzx esi, byte [ebx]
    cmp esi, 42 ;'*'
    je multiplication
    cmp esi, 43 ;'+'
    je addition
    cmp esi, 45 ;'-'
    je subtraction
    cmp esi, 47 ;'/'
    je division

multiplication:
    imul edx
    jmp end_fn
addition:
    add eax, edx
    jmp end_fn
subtraction:
    sub eax, edx
    jmp end_fn
division:
    idiv edx
    
end_fn:
    PRINT_DEC 4, eax
    
    leave
    ret

main:
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
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret