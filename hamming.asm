
section .data
    string1 db 'foo'
    string2 db 'bar'
    newline db 0xA
    
section .bss
    output resb 2

section .text
global _start

    ; start
_start:
    mov esi, string1
    mov edi, string2
    mov ecx, 3
    xor ebx, ebx

    ; loop and increment each character pair from the strings
char_loop:
    mov al, [esi]
    xor al, [edi]

    ; Inner loop to count differing bits in the current XOR result
bit_count:
    xor edx, edx
    mov ebp, 8

    ; Loop to check each bit of the XOR result
bit_count_loop:
    test al, 1
    jz no_bit
    inc edx

    ; Skip incrementing the bit counter if the bit is 0
no_bit:
    shr al, 1
    dec ebp
    jnz bit_count_loop
    add ebx, edx
    inc esi
    inc edi
    loop char_loop

    ; Prepare the total differing bits for output as an ASCII character
output_prep:
    mov al, bl
    add al, '0'
    mov [output], al

    ; System call to print the result to the console
print:
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 2
    int 0x80

    ; System call to print a newline character
printnewline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

// exit program
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80