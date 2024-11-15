; Programa en ensamblador NASM para restar dos dígitos ingresados por teclado

section .bss
    num1 resb 2          ; Reserva 2 bytes para el primer dígito y el salto de línea
    num2 resb 2          ; Reserva 2 bytes para el segundo dígito y el salto de línea
    result resb 4        ; Reserva 4 bytes para el resultado (signo, dos dígitos y terminador)

section .data
    prompt1 db "Ingrese el primer dígito: ", 0
    len_prompt1 equ $ - prompt1
    prompt2 db "Ingrese el segundo dígito: ", 0
    len_prompt2 equ $ - prompt2
    result_msg db "La resta es: ", 0
    len_result_msg equ $ - result_msg
    newline db 0xA, 0    ; Salto de línea
    negative_msg db "-", 0

section .text
    global _start

_start:
    ; Mostrar prompt1
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, prompt1      ; mensaje a escribir
    mov edx, len_prompt1  ; longitud del mensaje
    int 0x80

    ; Leer num1 (2 bytes: dígito + salto de línea)
    mov eax, 3            ; syscall: sys_read
    mov ebx, 0            ; file descriptor: stdin
    mov ecx, num1         ; buffer para almacenar el dígito
    mov edx, 2            ; número de bytes a leer
    int 0x80

    ; Mostrar prompt2
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len_prompt2
    int 0x80

    ; Leer num2 (2 bytes: dígito + salto de línea)
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; Convertir ASCII a entero para num1 (usar solo el primer byte)
    mov al, [num1]
    sub al, '0'
    mov bl, al            ; BL = num1

    ; Convertir ASCII a entero para num2 (usar solo el primer byte)
    mov al, [num2]
    sub al, '0'
    mov cl, al            ; CL = num2

    ; Realizar la resta: num1 - num2
    mov al, bl
    sub al, cl
    jo negative_result    ; Si hay desbordamiento, el resultado es negativo
    jge positive_result

negative_result:
    ; Manejar resultado negativo
    neg al                ; Obtener valor absoluto
    add al, '0'
    mov [result], byte '-' ; Agregar signo negativo
    mov [result+1], al
    mov byte [result+2], 0
    jmp print_result

positive_result:
    ; Convertir resultado a ASCII
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
    mov edx, 2            ; Mostrar hasta 2 bytes (incluyendo signo si es negativo)
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
