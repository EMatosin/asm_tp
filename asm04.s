section .data
    msg1 db "Entrez un nombre: ", 0
    msg2 db "0", 0
    msg3 db "1", 0

section .bss
    nombre resb 10

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, 19
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, nombre
    mov rdx, 9
    syscall

    movzx rax, byte [nombre]
    sub rax, '0'

    test rax, 1
    jnz impair

    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, 1
    syscall
    jmp exit

impair:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

exit:
    mov rax, 60
    mov rdi, 0
    syscall
