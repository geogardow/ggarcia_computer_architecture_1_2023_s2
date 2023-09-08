@ Tecnológico de Costa Rica
@ Área Académica Ingeniería en Computadores
@ Arquitectura de Computadores I
@ II Semestre 2023
@
@ Geovanny García Downing
@ 2020092224
@
@ RESGISTERS:
@
@ r0 = read/write
@ r1 = read/write
@ r2 = read/write
@ r3 = n max
@ r4 = constantes
@ r5 = k
@ r6 = temporal storage for output file
@ r7 = read/write
@ r8 = x/y
@ r9 = y/x
@ r10 = y'/x'
@ r11 = término serie Taylor
@ r12 = valor temporal mul/div

.data
    input_file: 		.asciz "raw39.txt"
    output_file: 		.asciz "image40.txt"
    buffer:     		.space 3     
    error_msg:   		.asciz  "Error opening file\n"
    selector:   		.asciz  ";"
    error_len = 		. - error_msg
    x:  			.space 1
    y:  			.space 1
    k:  			.word 12

.global _start

.text

_start:

main:
    ldr r0, =input_file		
    mov r1, #0              
    ldr r2,=0666       		@ Permiso de lectura
    mov r7, #5   		@ sys call para abrir el archivo  
    swi 0 	
    cmp r0, #0          	@ Busca error al abrir archivo
    blt error           	@ Si hay error se mueve al branch que lo manipula
    mov r4, r0          	@ Guarda el archivo de entrada
    
    mov r7, #8          	@ Crea la ruta del archivo
    ldr r0, =output_file  	@ Carga la dirección del archivo de salida
    ldr r2,=0666	       	@ Permiso de lectura
    swi 0               	@ System call para crear ruta
    mov r6, r0          	@ Guarda el archivo de salida
    mov r8, #0          	@ Counter x
    mov r9, #0          	@ Counter y
    push {r4}
    
    mov r5, #80
    b read
    
read:
    pop {r4}
    mov r0, r4
    ldr r1, =buffer  
    mov r2, #4              	@ Buffer para 4 caracteres
    mov r7, #3    		@ sys call para lectura de archivos   		
    swi 0
    cmp r0, #0          	@ Verifica si se llegó al final del código
    beq protocol_1
    cmp r0, #0             	@ Verifica si hay error al leer archivo
    blt error
    b processing
    
processing:
    push {r4}
    bl switch
    bl sin_function		@ Calculamos x'
    bl separator
    bl switch
    bl sin_function		@ Calculamos y'
    bl separator
    bl write
    b check_counters
    
switch:
    mov r0, r8
    mov r8, r9
    mov r9, r0
    bx lr
    
separator:
    mov r0, r6
    ldr r1, =selector    	@ Buffer de escritura
    mov r2, #1          	@ Buffer para 1 caracter
    mov r7, #4          
    swi 0               	@ sys call para escribir en archivo   
    bx lr      	  

check_counters:
    ldr r4, =639
    cmp r8, r4
    blt inc_xcounter
    add r9, #1
    mov r8, #0
    b read
    
inc_xcounter:
    add r8, #1
    b read
   
sin_function:
    mov r10, r8   		@ Se copia el valor de r8 en r10, donde se irá acumulando el denominador del polinomio de Taylor.
    mov r12, #6280      	@ Se carga el valor 6 en r12, una aproximación de 2*pi por un escalado de 1000.
    mul r10, r12       		@ Se multiplica x por 6 y se almacena en r8.
    mov r12, #75     		@ Se carga el valor 75 en r12, siendo este Lxy.
    sdiv r10, r12      		@ Se realiza una división entera de 6x entre 75 y se almacena en r8.
    mov r11, #0			@ Contador de signo
    mov r12, #0
    b mapping           	@ Salto a la etiqueta power para calcular seno..
    
mapping:			@ Verifica signo mediante la resta de pi
    ldr r4, =3140
    cmp r10, r4
    ble remapping
    sub r10, r4
    add r11, #1
    b mapping

remapping:			@ Mapea los valores a valores de 0 a pi/2
    ldr r4, =1570
    cmp r10, r4
    ble sin_value
    sub r10, r4
    add r12, #1
    b remapping
    
sin_value:			@ 12 rangos a trabajar del valor de seno
    cmp r10, #0
    beq set_cycle
    
    mov r4, #132
    cmp r10, r4
    ble set_cycle
    
    mov r4, #262
    cmp r10, r4
    ble set_cycle
    
    ldr r4, =392
    cmp r10, r4
    ble range3
    
    ldr r4, =524
    cmp r10, r4
    ble range4
    
    ldr r4, =654
    cmp r10, r4
    ble range5
    
    ldr r4, =786
    cmp r10, r4
    ble range6
    
    ldr r4, =916
    cmp r10, r4
    ble range7
    
    ldr r4, =1046
    cmp r10, r4
    ble range8
    
    ldr r4, =1178
    cmp r10, r4
    ble range9
    
    ldr r4, =1308
    cmp r10, r4
    ble range10
    
    ldr r4, =1440
    cmp r10, r4
    ble range11
    
    ldr r4, =1570
    cmp r10, r4
    ble range12
    
range3:				@ Rangos para valores de seno
    ldr r10, =382
    b set_cycle
    
range4:
    ldr r10, =500
    b set_cycle
    
range5:
    ldr r10, =608
    b set_cycle
    
range6:
    ldr r10, =708
    b set_cycle
    
range7:
    ldr r10, =793
    b set_cycle
    
range8:
    ldr r10, =865
    b set_cycle
    
range9:
    ldr r10, =924
    b set_cycle
    
range10:
    ldr r10, =966
    b set_cycle
    
range11:
    ldr r10, =991
    b set_cycle
    
range12:
    ldr r10, =999
    b set_cycle
    
set_cycle:
    cmp r12, #1
    beq adjust_cycle
    b set_sign
    
adjust_cycle:
    ldr r4, =1000
    sub r10, r4, r10
    b set_sign  
    
set_sign:			@ Ajusta el valor de seno a rango 0-1
    and r11, r11, #1
    mul r10, r5
    ldr r12, =1000
    sdiv r10, r12
    cmp r11, #1    		@ Verifica si el signo debe ser positivo o negativo
    beq resta
    b suma
    
suma:
    add r10, r9, r10		@ Caso positivo
    b result

resta:				@ Caso negativo
    sub r10, r9, r10
    b result
    
result:
    mov r4, r2         		@ Recuperar el registro del archivo de escritura
    mov r12, r5  		@ Movemos la k a un valor temporal
    
    cmp r10, #640 		@ Valida que los números se encuentren dentro de las posibles coordenadas
    bge validate
    cmp r10, #0
    blt validate

    b itoa			@ Conversion from Integer to ASCII

    
validate:
    mov r10, #999
    b itoa
    
itoa:
    mov r11, r9
    mov r3, r10
    mov r9, #100            	@ Carga el valor 100 en el registro r9
    sdiv r5, r3, r9        	@ r4 = r10 // 100 => 342 // 100 = 3
    mov r0, r5              	@ Mueve el primer dígito a r0
    add r0, r0, #48         	@ Conversión a ASCII
    ldr r1, =x              	@ Carga la dirección
    str r0, [r1]            	@ Almacena el valor en la dirección

    mov r0, r6              	@ Obtiene fd
    ldr r1, =x              	@ Carga el registro para escribir
    mov r2, #1              	@ Longitud del búfer
    mov r7, #4              	@ Llamada al sistema para escribir
    svc #0                  	@ Ejecución

    mul r2, r5, r9          	@ r2 = r5 * 100 => 3 * 100 = 300
    sub r3, r3, r2        	@ r3 = r3 - r2 => 342 - 300 = 42
    mov r9, #10             	@ r9 = 10
    sdiv r0, r3, r9        	@ r0 = r3 // r9 => 42 // 10 = 4
    mul r5, r0, r9          	@ r5 = r0 * 10 => 4 * 10 = 40
    sub r5, r3, r5         	@ r5 = r3 - r2 => 42 - 40 = 2

    add r0, r0, #48         	@ Conversión a ASCII
    ldr r1, =x              	@ Carga la dirección
    str r0, [r1]            	@ Almacena el valor en la dirección

    mov r0, r6              	@ Obtiene fd
    ldr r1, =x              	@ Carga el registro para escribir
    mov r2, #1              	@ Longitud del búfer
    mov r7, #4              	@ Llamada al sistema para escribir
    svc #0                  	@ Ejecución

    mov r0, r5              	@ Mueve el último dígito a r0
    add r0, r0, #48         	@ Conversión a ASCII
    ldr r1, =x              	@ Carga la dirección
    str r0, [r1]            	@ Almacena el valor en la dirección

    mov r0, r6              	@ Obtiene fd
    ldr r1, =x              	@ Carga el registro para escribir
    mov r2, #1              	@ Longitud del búfer
    mov r7, #4              	@ Llamada al sistema para escribir
    svc #0                  	@ Ejecución

    mov r5, r12             	@ Mueve el valor de k a r5
    mov r9, r11
    bx lr                	@ Si no, continúa escribiendo el valor

    
write:
    mov r0, r6
    ldr r1, =buffer     	@ buffer to write
    mov r2, #4          	@ buffer's len
    mov r7, #4          	
    swi 0               	@ syscall to write  
    bx lr

end:
    mov r7, #1         		@ Se carga el valor 1 en r7.
    mov r0, #0          	@ Se carga el valor 0 en r0.
    svc 0               	@ Llamada al sistema (syscall) para finalizar el programa.
    
error:
    @ Print an error message to stderr
    mov r0, #2                  
    ldr r1, =error_msg     	@ Carga dirección del mensaje
    ldr r2, =error_len 		@ Carga logitud del mensaje
    mov r7, #4                  @ sys call para escribir 
    svc 0                    	

    @ Exit the program with an error status
    mov r7, #1                  @ sys call para cerrar 
    mov r0, #1                  @ Estado de error
    svc 0   
    
protocol_1:
    mov r7, #6          	@ sys call para cerrar 
    swi 0               	@ ejecutar

protocol_2:
    mov r7, #6          	@ sys call para cerrar 
    swi 0               	@ ejecutar
    b end

