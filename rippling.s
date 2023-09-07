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
@ r4 = potencia
@ r5 = k
@ r6 = temporal storage for output file
@ r7 = read/write
@ r8 = x/y
@ r9 = y/x
@ r10 = y'/x'
@ r11 = término serie Taylor
@ r12 = valor temporal mul/div

.data
    input_file: 		.asciz "test.txt"
    output_file: 		.asciz "image.txt"
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
    
    mov r5, #100        	@ k inicial
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
    cmp r8, #640
    blt inc_xcounter
    add r9, #1
    mov r8, #0
    b read
    
inc_xcounter:
    add r8, #1
    b read
   
sin_function:
    mov r10, r8   		@ Se copia el valor de r8 en r10, donde se irá acumulando el denominador del polinomio de Taylor.
    mov r12, #6       		@ Se carga el valor 6 en r12, una aproximación de 2*pi.
    mul r10, r12       		@ Se multiplica x por 6 y se almacena en r8.
    mov r12, #550      		@ Se carga el valor 75 en r12, siendo este Lxy.
    sdiv r10, r12      		@ Se realiza una división entera de 6x entre 75 y se almacena en r8.
    mov r12, #0x13b0  		@ Se carga 7! en r12, que acompaña al termino con x de menor grado.
    mul r10, r12      		@ Se multiplica x por 7! y se actualiza r10.
    mov r4, r10        		@ Se copia el valor de x en r4 para calcular la potencia.
    mov r3, #7     		@ Se carga el valor 7 en r3. como indice
    b power           		@ Salto a la etiqueta power para calcular potencias.

power:
    sub r3, #1         		@ Decrementa r3 en 1 para calcular la siguiente potencia.
    mul r4, r8         		@ Multiplica r4 por r8 y actualiza r4, con el acumulado de la potencia.
    cmp r3, #5         		@ Compara r3 con 5, para añadir al denominador el grado 3 del polinomio de Taylor.
    beq pow3           		@ Si r3 es igual a 5, salta a pow3.
    cmp r3, #3         		@ Compara r3 con 3, para añadir al denominador el grado 5 del polinomio de Taylor
    beq pow5           		@ Si r3 es igual a 3, salta a pow5.
    cmp r3, #1         		@ Compara r3 con 1, para añadir al denominador el grado 7 del polinomio de Taylor
    ble pow7           		@ Si r3 es menor o igual a 1, salta a pow7.
    b power

pow3:
    mov r11, r4        		@ Se copia el valor de r4 en r11 un registro temporal.
    mov r12, #0x348    		@ Se carga 840 al registro 12 para el término de grado 3.
    mul r11, r12       		@ Se multiplica r11 por r12 y se actualiza r11, con la potencia por el coeficiente.
    sub r10, r11       		@ Se resta r11 de r10.
    b power            		@ Salto de vuelta a la etiqueta power.

pow5:
    mov r11, r4        		@ Se copia el valor de r4 en r11 un registro temporal.
    mov r12, #0x2a     		@ Se carga 42 al registro 12 para el término de grado 5.
    mul r11, r12       		@ Se multiplica r11 por r12 y se actualiza r11, con la potencia por el coeficiente.
    add r10, r11       		@ Se suma r11 a r10.
    b power            		@ Salto de vuelta a la etiqueta power.

pow7:
    sub r10, r4        		@ Se resta la potencia de grado 7 de r10.
    mul r10, r5        		@ Se multiplica r10 por r5, o sea Axy.
    mov r12, #0x13b0   		@ Se carga 7! para la división
    sdiv r10, r12      		@ Se realiza una división entera de del numerador por 7!.
    add r10, r9        		@ Se suma r9 a r10, la coordenada y para cáclulo de x'.
    
    mov r4, r2         		@ Recuperar el registro del archivo de escritura
    mov r12, r5  		@ move k value to temp
    
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

