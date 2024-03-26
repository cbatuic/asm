; This program that takes a string input from the user, converts each letter in the string to lowercase, and then displays the modified string.

section .data
    prompt db 'Enter a string: ', 0
    newline db 10, 0
    result_msg db 'Modified string (lowercase): ', 0

section .bss
    user_input resb 255        ; Reserve space for user input string
    str_length resd 1          ; Reserve space for string length (as a dword)

section .text
    global _start

_start:
    ; Print the prompt to enter a string
    mov eax, 4                  ; Syscall number for sys_write
    mov ebx, 1                  ; File descriptor 1 (stdout)
    mov ecx, prompt             ; Address of the prompt message
    mov edx, 18                 ; Length of the prompt message
    int 0x80                    ; Call kernel to print the prompt

    ; Read the input string from the user
    mov eax, 3                  ; Syscall number for sys_read
    mov ebx, 0                  ; File descriptor 0 (stdin)
    mov ecx, user_input         ; Address to store the input string
    mov edx, 255                ; Maximum number of bytes to read
    int 0x80                    ; Call kernel to read the input string

    ; Convert each letter in the string to lowercase
    mov esi, user_input         ; Point ESI to the start of the input string
convert_loop:
    mov al, byte [esi]         ; Move the current character to AL register
    cmp al, 0                   ; Check for end of string
    je end_conversion           ; Jump to end_conversion if end of string

    cmp al, 'A'                 ; Compare with 'A'
    jl not_uppercase            ; Jump if less than 'A' (not uppercase)
    cmp al, 'Z'                 ; Compare with 'Z'
    jg not_uppercase            ; Jump if greater than 'Z' (not uppercase)

    ; Convert uppercase to lowercase (ASCII arithmetic)
    add al, 32                  ; Convert uppercase to lowercase
    mov byte [esi], al          ; Store the converted character back in the string

not_uppercase:
    inc esi                     ; Move to the next character in the string
    jmp convert_loop            ; Jump back to convert_loop

end_conversion:
    ; Calculate the length of the modified string
    mov esi, user_input         ; Point ESI to the start of the modified string
    xor ecx, ecx                ; Clear ECX register (for string length calculation)
strlen_loop:
    cmp byte [esi], 0           ; Check for null terminator
    je strlen_done              ; Jump if null terminator found
    inc esi                     ; Move to the next character in the string
    inc ecx                     ; Increment the length counter
    jmp strlen_loop             ; Jump back to strlen_loop

strlen_done:
    mov [str_length], ecx       ; Store the length of the modified string in str_length

    ; Print the modified string (lowercase)
    mov eax, 4                  ; Syscall number for sys_write
    mov ebx, 1                  ; File descriptor 1 (stdout)
    mov ecx, result_msg         ; Address of the result_msg
    mov edx, 30                 ; Length of the result_msg
    int 0x80                    ; Call kernel to print the result_msg

    ; Print the modified string
    mov eax, 4                  ; Syscall number for sys_write
    mov ebx, 1                  ; File descriptor 1 (stdout)
    mov ecx, user_input         ; Address of the modified string
    mov edx, [str_length]       ; Length of the modified string
    int 0x80                    ; Call kernel to print the modified string

    ; Print a newline character
    mov eax, 4                  ; Syscall number for sys_write
    mov ebx, 1                  ; File descriptor 1 (stdout)
    mov ecx, newline            ; Address of the newline character
    mov edx, 1                  ; Length of the newline character
    int 0x80                    ; Call kernel to print the newline

    ; Exit the program
    mov eax, 1                  ; Syscall number for sys_exit
    xor ebx, ebx                ; Exit code 0
    int 0x80                    ; Call kernel to exit the program


;sudo apt-get update
;sudo apt-get -y install nasm
;nasm -f elf act3.asm
;ld -m  elf_i386 act3.o -o act3
;./act3
