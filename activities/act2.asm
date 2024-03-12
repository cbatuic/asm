section .data
    newline db 10        ; newline character

section .bss
    buffer resb 1

section .text
    global _start

_start:
    ; Read a character from stdin
    mov eax, 3           ; sys_read system call number
    mov ebx, 0           ; file descriptor: stdin
    mov ecx, buffer      ; buffer to read into
    mov edx, 1           ; number of bytes to read
    int 0x80             ; invoke system call

    ; Display the entered character
    mov eax, 4           ; sys_write system call number
    mov ebx, 1           ; file descriptor: stdout
    mov ecx, buffer      ; pointer to the entered character
    mov edx, 1           ; length of the character
    int 0x80             ; invoke system call

    ; Display a new line
    mov eax, 4           ; sys_write system call number
    mov ebx, 1           ; file descriptor: stdout
    mov ecx, newline     ; pointer to the newline character
    mov edx, 1           ; length of the newline character
    int 0x80             ; invoke system call

    ; Exit the program
    mov eax, 1           ; sys_exit system call number
    xor ebx, ebx         ; exit code 0
    int 0x80             ; invoke system call
