.section .data
file_name:  .asciz "test.txt"   @ Especifica el nombre de tu archivo de entrada
buffer:     .space 1            @ Búfer para almacenar un solo byte
file_desc:  .word 0             @ Descriptor de archivo

.section .bss
line_buffer: .space 8           @ Búfer para almacenar una línea de texto (ajusta el tamaño según sea necesario)

.section .text
.global _start

_start:
    @ Abrir el archivo para lectura
    ldr r0, =file_name
    mov r1, #0x00  @ Bandera O_RDONLY
    bl open_file

    @ Leer y procesar líneas desde el archivo
read_loop:
    ldr r0, =file_desc
    ldr r1, =line_buffer
    mov r2, #8  @ Longitud máxima de línea, ajústala según sea necesario
    bl read_line

    cmp r0, #0  @ Comprobar fin de archivo o error
    ble exit

    @ En este punto, r1 apunta al line_buffer que contiene la representación de texto del entero.
    @ Puedes convertir el texto a un entero y realizar más procesamiento aquí.

    @ Ejemplo: Convertir el texto a un entero
    bl atoint

    @ Haz algo con el entero en r0

    b read_loop

exit:
    @ Cerrar el archivo
    ldr r0, =file_desc
    bl close_file

    @ Salir del programa
    mov r7, #1   @ Llamada al sistema SYS_EXIT
    swi 0

open_file:
    @ r0: Nombre del archivo (puntero)
    @ r1: Modo de acceso al archivo
    ldr r7, =5    @ Número de llamada al sistema SYS_OPEN
    svc 0
    mov r1, r0    @ Guardar el descriptor de archivo en r1
    bx lr

read_line:
    @ r0: Descriptor de archivo
    @ r1: Búfer (puntero)
    @ r2: Tamaño del búfer
    ldr r7, =0x3   @ Número de llamada al sistema SYS_READ
    svc 0
    bx lr

close_file:
    @ r0: Descriptor de archivo
    ldr r7, =6   @ Número de llamada al sistema SYS_CLOSE
    svc 0
    bx lr

atoint:
    @ Convertir una cadena terminada en nulo en r1 a un entero (resultado en r0)
    mov r0, #0
    mov r2, #10   @ Base 10
loop:
    ldrb r3, [r1], #1
    cmp r3, #0
    beq done
    sub r3, r3, #48  @ Convertir de ASCII a entero
    mul r11, r0, r2
    add r0, r11, r3
    b loop
done:
    bx lr

