@ r0 = 
@ r1 = 
@ r2 = 
@ r3 = n max
@ r4 = potencia acumulada
@ r8 = x
@ r9 = y
@ r10 = numerador
@ r11 = potencia temporal
@ r12 = valor temporal mul/div
@ r5 = k


.global _start

.text
_start:
    add sp, #8
    mov r4, #0
    
loop:
    pop {r0}
    cmp r0, #0
    beq main
    bl atoi
    add r4, r0
    b loop
    
main:
    mov r5, r4
    mov r8, #15
    mov r9, #50
    mov r12, #6
    mul r8, r12
    mov r12, #75
    sdiv r8, r12
    mov r10, r8
    mov r12, #0x13b0
    mul r10, r12
    mov r4, r8
    mov r3, #7
    b power  
    
power:
    sub r3, #1
    mul r4, r8
    cmp r3, #5
    beq pow3
    cmp r3, #3
    beq pow5
    cmp r3, #1
    ble pow7
    
pow3:
    mov r11, r4
    mov r12, #0x348
    mul r11, r12
    sub r10, r11
    b power
    
pow5:
    mov r11, r4
    mov r12, #0x2a
    mul r11, r12
    add r10, r11
    b power
    
pow7:
    sub r10, r4
    mul r10, r5
    mov r12, #0x13b0
    sdiv r10, r12
    b print
    
print:
    mov r0, #1
    mov r1, r10					
    mov r2, #3					@ buffer's len
    mov r7, #4					@ sys call to write 
    swi 0
    b end
    
end:
    mov r7, #1        
    mov r0, #0        
    svc 0             
