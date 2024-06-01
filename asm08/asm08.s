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
    pop r8 ; Récupérer nombre d'arguments

    cmp r8, 2
    jnz .sortie_echec

    pop rdi
    pop rdi

    call chaine_en_entier

    cmp rax, -1
    jnz .sortie_echec

    mov r9, rax

.convertir_en_binaire:
    mov rbx, 2

.convertir_en_binaire_boucle:
    cmp rax, 1
    jl .afficher_binaire
    div rbx
    add rdx, byte 48 ; Conversion en caractère

    push rdx
    xor rdx, rdx

    jmp .convertir_en_binaire_boucle

.afficher_binaire:
    pop rdx

    test rdx, rdx
    jz .afficher_binaire_fin

    mov rax, sys_write
    mov rdi, sys_stdout
    mov [char_buf], rdx
    mov rsi, char_buf
    mov rdx, 1
    syscall

    jmp .afficher_binaire

.afficher_binaire_fin:
    mov rax, sys_write
    mov rdi, sys_stdout
    mov [char_buf], byte 10
    mov rsi, char_buf
    mov rdx, 1
    syscall

    jmp .sortie_succes

.sortie_echec:
    mov rax, sys_exit
    mov rdi, 1
    syscall

.sortie_succes:
    mov rax, sys_exit
    mov rdi, 0
    syscall

chaine_en_entier:
    xor rsi, rsi
    call longueur_chaine
    mov rcx, rax
    xor rax, rax

.chaine_en_entier_boucle:
    cmp rsi, rcx
    jge .chaine_en_entier_fin

    mov dl, byte [rdi + rsi]

    cmp dl, 10
    jz .chaine_en_entier_fin

    ; Vérifier si le caractère est un chiffre
    cmp dl, '0'
    jl .chaine_en_entier_err

    cmp dl, '9'
    jg .chaine_en_entier_err

    add rax, rax
    lea rax, [4 * rax + rax]

    sub dl, "0" ; Conversion ASCII
    movzx rdx, dl
    add rax, rdx

.chaine_en_entier_inc:
    inc rsi
    jmp .chaine_en_entier_boucle

.chaine_en_entier_err:
    mov rax, -1
    ret

.chaine_en_entier_fin:
    xor rdx, rdx
    ret

longueur_chaine:
    xor rax, rax

.longueur_chaine_boucle:
    cmp [rdi + rax], byte 0
    jz .longueur_chaine_fin

    inc rax
    jmp .longueur_chaine_boucle

.longueur_chaine_fin:
    ret
