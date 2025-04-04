section .data
    pathname db "randomint100.txt", 0
    newline db 10, 0
    sum_msg db "Sum: ", 0

section .bss
    buffer resb 1000
    sum resd 1
    num resd 1
    sum_str resb 12

section .text
    global _start

_start:
    mov eax, 5       
    mov ebx, pathname
    mov ecx, 0       
    int 0x80

    mov ebx, eax     

    mov eax, 3       
    mov ecx, buffer
    mov edx, 1000
    int 0x80

    mov edx, eax     

    mov dword [sum], 0
    mov dword [num], 0
    mov esi, buffer

parse_loop:
    mov al, [esi]
    cmp al, 0
    je finalize_sum   
    cmp al, '0'
    jl handle_delimiter
    cmp al, '9'
    jg handle_delimiter

    sub al, '0'
    movzx eax, al
    mov ebx, [num]
    imul ebx, ebx, 10
    add ebx, eax
    mov [num], ebx

    jmp next_char

handle_delimiter:
    mov eax, [num]
    add [sum], eax
    mov dword [num], 0   

next_char:
    inc esi
    jmp parse_loop

finalize_sum:
    mov eax, [num]
    add [sum], eax

    mov eax, [sum]
    mov edi, sum_str
    call int_to_str

    mov eax, 4
    mov ebx, 1
    mov ecx, sum_msg
    mov edx, 5
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, sum_str
    mov edx, 12
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

int_to_str:
    mov ecx, 10
    mov ebx, 0         
    mov edi, sum_str + 11 
    mov byte [edi], 0  
    dec edi

convert_loop:
    mov edx, 0
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    inc ebx
    test eax, eax
    jnz convert_loop

    inc edi
    ret
