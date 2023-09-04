@ s0 = x
@ r0 = n
@ r1 = 2n + 1
@ r2 = power counter
@ r3 = n max
@ r4 = Resultado factorial
@ s1 = Resultado potencia
@ s2 = Resultado temporal seno
@ s3 = Resultado acumulado seno

.arch armv7-a
.fpu vfpv3-d16

.global _start

.text
_start:

main:
    mov r3, #10
    mov r0, #2
    vmov.f32 s0, #2.0
    vmov.f32 s1, s0
    b sin_iteration

sin_iteration:
    add r1, r0, r0
    add r1, #1
    mov r4, r1
    b factorial

factorial:
    sub r1, #1
    mul r4, r1
    cmp r1, #1
    beq pre_power
    b factorial
    
pre_power:
    add r1, r0, r0
    add r1, #1
    mov r2, r1
    b power
    
power:
    sub r2, #1
    vmul.f32 s1, s1, s0
    cmp r2, #1
    beq end
    b power
 end:
    mov r7, #1        
    mov r0, #0        
    svc 0             
