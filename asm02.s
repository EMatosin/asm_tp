section .data
    msg1 db "Entrez un nombre: ", 0
    nb db "42", 0
    msg_equal db "1337", 0

section .bss
    input resb 10

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
    mov rsi, input
    mov rdx, 10
    syscall

    ; Nettoyage de la chaîne saisie en remplaçant le caractère de retour à la ligne par un zéro
    mov rsi, input
    mov rcx, 10
.loop_clean:
    cmp byte [rsi], 0
    je .loop_compare
    cmp byte [rsi], 10
    je .found_newline
    inc rsi
    loop .loop_clean
.found_newline:
    mov byte [rsi], 0
    jmp .loop_clean
.loop_compare:
    ; Comparaison caractère par caractère
    mov rsi, input
    mov rdi, nb
    mov rcx, 2
.loop:
    mov al, byte [rsi]
    mov bl, byte [rdi]
    cmp al, bl
    jne _not_equal
    cmp al, 0
    je _equal
    inc rsi
    inc rdi
    loop .loop

_equal:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_equal
    mov rdx, 5
    syscall

    jmp _exit

_not_equal:
    mov rax, 60
    mov rdi, 1
    syscall

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
