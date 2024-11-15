; Programa en Ensamblador para mostrar nombre y número de identificación
; Ensamblador: NASM
; Sistema Operativo: Linux x86 (32-bit)

section .data
    nombre db "Daniel Santiago Acosta Galindo", 0xA  ; Cadena de caracteres con salto de línea
    len_nombre equ $ - nombre            ; Longitud de la cadena de nombre

    id db "ID: 1013103650", 0xA             ; Cadena de caracteres con salto de línea
    len_id equ $ - id                    ; Longitud de la cadena de ID

section .text
    global _start                         ; Punto de entrada

_start:
    ; Escribir el nombre en la salida estándar
    mov eax, 4                            ; syscall: sys_write
    mov ebx, 1                            ; file descriptor: stdout
    mov ecx, nombre                       ; puntero al mensaje
    mov edx, len_nombre                   ; longitud del mensaje
    int 0x80                              ; llamada al sistema

    ; Escribir el ID en la salida estándar
    mov eax, 4                            ; syscall: sys_write
    mov ebx, 1                            ; file descriptor: stdout
    mov ecx, id                           ; puntero al mensaje
    mov edx, len_id                       ; longitud del mensaje
    int 0x80                              ; llamada al sistema

    ; Salir del programa
    mov eax, 1                            ; syscall: sys_exit
    mov ebx, 0                            ; estado de salida
    int 0x80                              ; llamada al sistema
