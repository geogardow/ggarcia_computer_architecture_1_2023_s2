from preprocess import *
from iterations import *
from animation import *
import os

"""
Tecnológico de Costa Rica
Área Académica Ingeniería en Computadores
Arquitectura de Computadores I
II Semestre 2023

Geovanny García Downing
2020092224
"""

iterations = 40

def recursive():
    """
    Este código corre todas las funciones realizadas en los otros módulos de Python
    Convierte una imagen a 640x640 escala grises y la inserta en un archivo crudo .txt
    Luego cambia la entrada del script arm para ese archivo .txt
    Luego modifica incrementalmente el valor de k de 5 en 5
    El archivo de entrada es el de la iteración anterior y se anima mediante la visualización de 40 valores diferentes de k
    Se corren los comandos de compilado en terminal
    Crea una imagen .png a partir del output generado por el scrip .s
    Se reubican los archivos para tener mejor orden
    Por último, se anima las imagenes de salida en un video .mp4
    """

    print("Procesing image 1 \n")
    img_to_txt('test.jpg','test.txt')
    replace('    input_file: 		.asciz "test.txt"',26)
    replace('    output_file: 		.asciz "image01.txt"',27)
    replace('    mov r5, #2',61)
    run('arm-none-eabi-as rippling.s -g -o rippling.o')
    run('arm-none-eabi-ld rippling.o -o rippling')
    run('qemu-arm ./rippling')
    create('image01')
    relocate('image01.txt', 'outputs')

    #"""
    for i in range(2,iterations+1,1):
        print("Procesing image "+str(i)+"\n")
        img_to_txt('image'+str(i-1).zfill(2)+'.png','raw'+str(i-1).zfill(2)+'.txt')
        replace('    input_file: 		.asciz "raw'+str(i-1).zfill(2)+'.txt"',26)
        replace('    output_file: 		.asciz "image'+str(i).zfill(2)+'.txt"',27)
        replace('    mov r5, #'+str(2*i),61)
        run('arm-none-eabi-as rippling.s -g -o rippling.o')
        run('arm-none-eabi-ld rippling.o -o rippling')
        run('qemu-arm ./rippling')
        create('image'+str(i).zfill(2))
        relocate('image'+str(i-1).zfill(2)+'.png', 'images')
        relocate('raw'+str(i-1).zfill(2)+'.txt', 'raws')
        relocate('image'+str(i).zfill(2)+'.txt', 'outputs')
    #"""

    relocate('image'+str(iterations)+'.png', 'images')
    relocate('raw'+str(iterations)+'.txt', 'raws')
    relocate('image'+str(iterations)+'.txt', 'outputs')
    animate()

def independent():
    """
    Este código corre todas las funciones realizadas en los otros módulos de Python
    Convierte una imagen a 640x640 escala grises y la inserta en un archivo crudo .txt
    Luego cambia la entrada del script arm para ese archivo .txt
    Luego modifica incrementalmente el valor de k de 5 en 5
    El archivo de entrada siempre es el mismo y se anima mediante la visualización de 40 valores diferentes de k
    Se corren los comandos de compilado en terminal
    Crea una imagen .png a partir del output generado por el scrip .s
    Se reubican los archivos para tener mejor orden
    Por último, se anima las imagenes de salida en un video .mp4
    """

    print("Procesing image 1 \n")
    img_to_txt('test.jpg','test.txt')
    replace('    input_file: 		.asciz "test.txt"',26)
    replace('    output_file: 		.asciz "image01.txt"',27)
    replace('    mov r5, #5',61)
    run('arm-none-eabi-as rippling.s -g -o rippling.o')
    run('arm-none-eabi-ld rippling.o -o rippling')
    run('qemu-arm ./rippling')
    create('image01')
    relocate('image01.txt', 'outputs')

    #"""
    for i in range(2,iterations+1,1):
        print("Procesing image "+str(i)+"\n")
        replace('    output_file: 		.asciz "image'+str(i).zfill(2)+'.txt"',27)
        replace('    mov r5, #'+str(5*i),61)
        run('arm-none-eabi-as rippling.s -g -o rippling.o')
        run('arm-none-eabi-ld rippling.o -o rippling')
        run('qemu-arm ./rippling')
        create('image'+str(i).zfill(2))
        relocate('image'+str(i-1).zfill(2)+'.png', 'images')
        relocate('image'+str(i).zfill(2)+'.txt', 'outputs')
    #"""

    relocate('image'+str(iterations)+'.png', 'images')
    relocate('image'+str(iterations)+'.txt', 'outputs')
    animate()

decision = input("Desea correr de forma recursiva (r) o independiente (i)? (r/i)/ ").lower()
if decision == "r":
    recursive()
elif decision == "i":
    independent()

os.chmod("rippling.s", 0o666)
os.chmod("rippling.o", 0o666)
os.chmod("rippling", 0o666)
