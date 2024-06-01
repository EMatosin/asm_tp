sys_stdin   equ 0
sys_stdout  equ 1

sys_read    equ 0
sys_write   equ 1
sys_exit    equ 60

section .data

section .bss
    buffer resb 100

section .text
    global _start

_start:

.read_input:
    ; Lire l'entrée user
    mov rax, sys_read
    mov rdi, sys_stdin
    mov rsi, buffer
    mov rdx, 100
    syscall

    ; Conversion en entier
    mov rdi, rsi
    call str_to_int
    mov rbx, rax

.calc_sqrt:
    ; Convertir l'entier en double précision
    cvtsi2sd xmm0, rbx
    ; Calculer racine carrée
    sqrtsd xmm0, xmm0
    ; Reconversion en entier
    cvttsd2si rbx, xmm0

    mov rdi, rbx
    mov rsi, rax
    mov rcx, 2

.check_prime:
    ; Vérifier si nombre premier
    xor rdx, rdx
    mov rax, rsi
    mov rbx, rcx
    div rbx

    ; Si modulo  0, pas premier
    cmp rdx, 0
    jz .fail_exit

    cmp rcx, rdi
    jz .success_exit

    inc rcx
    jmp .check_prime

.success_exit:
    mov rax, sys_exit
    mov rdi, 0
    syscall

.fail_exit:
    mov rax, sys_exit
    mov rdi, 1
    syscall

str_to_int:
    xor rsi, rsi
    call str_length
    mov rcx, rax
    xor rax, rax

.str_to_int_loop:
    cmp rsi, rcx
    jge .str_to_int_end

    mov dl, byte [rdi + rsi]

    cmp dl, 10
    jz .str_to_int_end

    cmp dl, '0'
    jl .str_to_int_err

    cmp dl, '9'
    jg .str_to_int_err

    add rax, rax
    lea rax, [4 * rax + rax]

    sub dl, "0"
    movzx rdx, dl
    add rax, rdx

.str_to_int_inc:
    inc rsi
    jmp .str_to_int_loop

.str_to_int_err:
    mov rax, -1
    ret

.str_to_int_end:
    xor rdx, rdx
    ret

str_length:
    xor rax, rax

.str_length_loop:
    cmp [rdi + rax], byte 0
    jz .str_length_end

    inc rax
    jmp .str_length_loop

.str_length_end:
    ret
