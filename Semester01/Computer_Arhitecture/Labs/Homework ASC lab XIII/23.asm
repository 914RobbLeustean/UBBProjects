bits 32
global start

extern exit, fopen, fclose, fread, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    input_fd dd -1
    output_fd dd -1
    
    input_name db "23in.txt", 0
    output_name db "23out.txt", 0
    
    read_access db "r", 0
    write_access db "w", 0
    format_write db "%c", 0
    
    text resb 100
    len equ 100
    
    alfabet db 'OPQRSTUVWXYZABCDEFGHIJKLMN', 0


segment code use32 class=code
    start:
    ; open the input file
    push dword read_access
    push dword input_name
    call [fopen]
    add esp, 4 * 2
    cmp eax, 0
    je finish
    mov [input_fd], eax
    
    ; open the output file
    push dword write_access
    push dword output_name
    call [fopen]
    add esp, 4 * 2
    cmp eax, 0
    je close_input
    mov [output_fd], eax
    
    
    ; read the text
    push dword [input_fd]
    push dword len
    push dword 1
    push dword text
    call [fread]
    add esp, 4 * 4
    ;mov ecx, eax
    mov esi, text
   ; mov ecx, eax
    
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    
    mov ebx, alfabet
    
    repeta:
        lodsb
        
        cmp al, 0
        je close_files
        
        sub al, 'a'
        xlat
        
        ; print it
        push dword eax
        push dword format_write
        push dword [output_fd]
        call [fprintf]
        add esp, 4 * 3
        
        jmp repeta
        
        
    close_files:
    
    close_output:
        push dword [output_fd]
        call [fclose]
        add esp, 4

    close_input:
        push dword [input_fd]
        call [fclose]
        add esp, 4

    finish:
        push dword 0
        call [exit]
    
        
