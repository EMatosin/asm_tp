sys_stdin   equ 0
sys_stdout  equ 1

sys_read    equ 0
sys_write   equ 1
sys_exit    equ 60

section .data
    char_buf db " "

section .text
    global _start

_start:
    ; Récupérer le nombre d'arguments
    pop r8

    ; Vérification si suffisamment d'arguments
    cmp r8, 2
    jnz .exit_failure

    pop rdi
    ; premier argument
    pop rdi

    ; Conversion en  entier
    call str_to_int

    cmp rax, -1
    jz .exit_failure

    cmp rax, -1
    jz .exit_failure

    ; Vérifier si inférieur à 1
    cmp rax, 0
    jl .exit_failure

    mov rcx, rax
    dec rcx

.loop:
    cmp rcx, 0
    jl .print_number
    add rax, rcx
    dec rcx
    jmp .loop

.print_number:

.push_num_loop:
    ; Réinitialiser rdx pour stocker le résultat du modulo
    xor rdx, rdx
    ; Définir le diviseur
    mov rbx, 10
    div rbx

    add rdx, '0'
    push rdx

    ; Finir lorsque strictement inférieur a 1
    cmp rax, 1
    jl .display_nums

    jmp .push_num_loop

.display_nums:
    pop rdx

    test rdx, rdx
    jz .print_num_end

    ; Afficher le caractère
    mov rax, sys_write
    mov rdi, sys_stdout
    mov [char_buf], rdx
    mov rsi, char_buf
    mov rdx, 1
    syscall

    jmp .display_nums

.print_num_end:
    mov rax, sys_write
    mov rdi, sys_stdout
    mov [char_buf], byte 10
    mov rsi, char_buf
    mov rdx, 1
    syscall

    xor rcx, rcx

.exit_success:
    mov rax, sys_exit
    mov rdi, 0
    syscall

.exit_failure:
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
