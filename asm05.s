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
    pop r9
    pop rdi
    ; Récupérer le premier argument
    pop rdi

    ; Conversion du premier argument en entier
    call str_to_int
    cmp rax, -1
    jz .fail_exit

    mov r10, rax

    ; Récupérer le second argument
    pop rdi
    ; Convertir le second argument en entier
    call str_to_int
    cmp rax, -1
    jz .fail_exit

    mov r11, rax

    ; Ajouter les deux entiers
    add r10, r11
    mov rax, r10

.print_num:
    ; Boucle pour convertir le nombre en chaîne de caractère
.push_num_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx

    add rdx, '0'
    push rdx

    ; Vérifier si fin de la conversion
    cmp rax, 1
    jl .show_nums

    jmp .push_num_loop

.show_nums:
    ; Boucle pour afficher les chiffres un par un
    pop rdx

    test rdx, rdx
    jz .print_num_end

    mov rax, sys_write
    mov rdi, sys_stdout
    mov [char_buf], rdx
    mov rsi, char_buf
    mov rdx, 1
    syscall

    jmp .show_nums

.print_num_end:
    mov rax, sys_write
    mov rdi, sys_stdout
    mov [char_buf], byte 10
    mov rsi, char_buf
    mov rdx, 1
    syscall

    xor rcx, rcx

.success_exit:
    mov rax, sys_exit
    mov rdi, 0
    syscall

.fail_exit:
    ; Retourner avec un code d'erreur 1
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

    cmp dl, '0'
    jl .str_to_int_err

    cmp dl, '9'
    jg .str_to_int_err

    ; Multiplier par 10
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
