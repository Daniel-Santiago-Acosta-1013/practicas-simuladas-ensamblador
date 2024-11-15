; Programa en ensamblador NASM para sumar dos dígitos ingresados por teclado

section .bss
    num1 resb 1          ; Reserva 1 byte para el primer dígito
    discard1 resb 1      ; Reserva 1 byte para descartar el primer '\n'
    num2 resb 1          ; Reserva 1 byte para el segundo dígito
    discard2 resb 1      ; Reserva 1 byte para descartar el segundo '\n'
    result resb 3        ; Reserva 3 bytes para el resultado (dos dígitos y terminador)

section .data
    prompt1 db "Ingrese el primer dígito: ", 0
    len_prompt1 equ $ - prompt1
    prompt2 db "Ingrese el segundo dígito: ", 0
    len_prompt2 equ $ - prompt2
    result_msg db "La suma es: ", 0
    len_result_msg equ $ - result_msg
    newline db 0xA, 0    ; Salto de línea

section .text
    global _start

_start:
    ; Mostrar prompt1
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, prompt1      ; mensaje a escribir
    mov edx, len_prompt1  ; longitud del mensaje
    int 0x80

    ; Leer num1
    mov eax, 3            ; syscall: sys_read
    mov ebx, 0            ; file descriptor: stdin
    mov ecx, num1         ; buffer para almacenar el dígito
    mov edx, 1            ; número de bytes a leer
    int 0x80

    ; Leer y descartar el '\n' después del primer dígito
    mov eax, 3            ; syscall: sys_read
    mov ebx, 0            ; file descriptor: stdin
    mov ecx, discard1     ; buffer para descartar
    mov edx, 1            ; número de bytes a leer
    int 0x80

    ; Mostrar prompt2
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len_prompt2
    int 0x80

    ; Leer num2
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 1
    int 0x80

    ; Leer y descartar el '\n' después del segundo dígito
    mov eax, 3
    mov ebx, 0
    mov ecx, discard2
    mov edx, 1
    int 0x80

    ; Convertir ASCII a entero para num1
    mov al, [num1]
    sub al, '0'
    mov bl, al            ; BL = num1

    ; Convertir ASCII a entero para num2
    mov al, [num2]
    sub al, '0'
    add bl, al            ; BL = num1 + num2

    ; Convertir resultado a ASCII
    mov al, bl
    cmp al, 10
    jl single_digit
    ; Si el resultado es >= 10, manejar dos dígitos
    mov ah, 0
    mov bl, 10
    div bl                ; AL = dígito de las unidades, AH = dígito de las decenas
    add al, '0'
    mov [result], al
    add ah, '0'
    mov [result+1], ah
    mov byte [result+2], 0
    jmp print_result

single_digit:
    add al, '0'
    mov [result], al
    mov byte [result+1], 0

print_result:
    ; Mostrar mensaje de resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, len_result_msg
    int 0x80

    ; Mostrar resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    ; Determinar la longitud del resultado
    mov edx, 2
    cmp byte [result+1], 0
    je show_single_digit
    mov edx, 2            ; Dos dígitos
    jmp display

show_single_digit:
    mov edx, 1            ; Un solo dígito

display:
    int 0x80

    ; Mostrar salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Salir del programa
    mov eax, 1            ; syscall: sys_exit
    xor ebx, ebx          ; estado de salida 0
    int 0x80
