stdout_fd    equ 1
syscall_write  equ 1
syscall_exit   equ 60

section .data
    output_msg db '1337', 10
    output_len equ $-output_msg
    compare_str db '42', byte 0

section .text
    global _start

_start:

.check_input:
    pop r9

    cmp r9, 2
    jnz .fail_exit

    pop rbx
    pop rbx

    xor rdi, rdi
    mov rdi, compare_str

.loop_check:
    cmp [rdi], byte 0
    jz .compare_end

    mov al, [rbx]

    cmp al, [rdi]
    jnz .fail_exit

    inc rbx
    inc rdi

    jmp .loop_check

.fail_exit: ; Exit with code 1
    mov rax, syscall_exit
    mov rdi, 1
    syscall

.compare_end:
    cmp [rbx], byte 0
    jnz .fail_exit

.success_exit: ; Exit with code 0 printing 1337
    mov rax, syscall_write
    mov rdi, stdout_fd
    mov rsi, output_msg
    mov rdx, output_len
    syscall

    mov rax, syscall_exit
    mov rdi, 0
    syscall
