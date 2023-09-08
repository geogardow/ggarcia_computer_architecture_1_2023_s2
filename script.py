from preprocess import *
from iterations import *
from animation import *

iterations = 40

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
