@ r0 = read/write
@ r1 = read/write
@ r2 = read/write
@ r7 = read/write
@ r3 = n max
@ r4 = potencia acumulada
@ r8 = x/y
@ r9 = y/x
@ r10 = y'/x'
@ r11 = potencia temporal
@ r12 = valor temporal mul/div
@ r5 = k

.global _start

.text
_start:

sin_function:
    mov r5, #5        @ Se carga el valor 5 en r5, que representa Axy.
    mov r8, #15       
    mov r9, #50       
    mov r12, #6       @ Se carga el valor 6 en r12, una aproximación de 2*pi.
    mul r8, r12       @ Se multiplica x por 6 y se almacena en r8.
    mov r12, #75      @ Se carga el valor 75 en r12, siendo este Lxy.
    sdiv r8, r12      @ Se realiza una división entera de 6x entre 75 y se almacena en r8.
    mov r10, r8       @ Se copia el valor de r8 en r10, donde se irá acumulando el denominador del polinomio de Taylor.
    mov r12, #0x13b0  @ Se carga 7! en r12, que acompaña al termino con x de menor grado.
    mul r10, r12      @ Se multiplica x por 7! y se actualiza r10.
    mov r4, r8        @ Se copia el valor de x en r4 para calcular la potencia.
    mov r3, #7        @ Se carga el valor 7 en r3. como indice
    b power           @ Salto a la etiqueta power para calcular potencias.

power:
    sub r3, #1         @ Decrementa r3 en 1 para calcular la siguiente potencia.
    mul r4, r8         @ Multiplica r4 por r8 y actualiza r4, con el acumulado de la potencia.
    cmp r3, #5         @ Compara r3 con 5, para añadir al denominador el grado 3 del polinomio de Taylor.
    beq pow3           @ Si r3 es igual a 5, salta a pow3.
    cmp r3, #3         @ Compara r3 con 3, para añadir al denominador el grado 5 del polinomio de Taylor
    beq pow5           @ Si r3 es igual a 3, salta a pow5.
    cmp r3, #1         @ Compara r3 con 1, para añadir al denominador el grado 7 del polinomio de Taylor
    ble pow7           @ Si r3 es menor o igual a 1, salta a pow7.
    b power

pow3:
    mov r11, r4        @ Se copia el valor de r4 en r11 un registro temporal.
    mov r12, #0x348    @ Se carga 840 al registro 12 para el término de grado 3.
    mul r11, r12       @ Se multiplica r11 por r12 y se actualiza r11, con la potencia por el coeficiente.
    sub r10, r11       @ Se resta r11 de r10.
    b power            @ Salto de vuelta a la etiqueta power.

pow5:
    mov r11, r4        @ Se copia el valor de r4 en r11 un registro temporal.
    mov r12, #0x2a     @ Se carga 42 al registro 12 para el término de grado 5.
    mul r11, r12       @ Se multiplica r11 por r12 y se actualiza r11, con la potencia por el coeficiente.
    add r10, r11       @ Se suma r11 a r10.
    b power            @ Salto de vuelta a la etiqueta power.

pow7:
    sub r10, r4        @ Se resta la potencia de grado 7 de r10.
    mul r10, r5        @ Se multiplica r10 por r5, o sea Axy.
    mov r12, #0x13b0   @ Se carga 7! para la división
    sdiv r10, r12      @ Se realiza una división entera de del numerador por 7!.
    add r10, r9        @ Se suma r9 a r10, la coordenada y para cáclulo de x'.
    b end              @ Salto a la etiqueta de salida.

end:
    mov r7, #1          @ Se carga el valor 1 en r7.
    mov r0, #0          @ Se carga el valor 0 en r0.
    svc 0               @ Llamada al sistema (syscall) para finalizar el programa.

