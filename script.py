from preprocess import *
from iterations import *

iterations = 40

print("Procesing image 1 \n")
img_to_txt('test.jpg','test.txt')
replace('    input_file: 		.asciz "test.txt"',26)
replace('    output_file: 		.asciz "image1.txt"',27)
replace('    mov r5, #5',61)
run('arm-none-eabi-as rippling.s -g -o rippling.o')
run('arm-none-eabi-ld rippling.o -o rippling')
run('qemu-arm ./rippling')
create('image1')

#"""
for i in range(2,iterations+1,1):
    print("Procesing image "+str(i)+"\n")
    img_to_txt('image'+str(i-1)+'.png','raw'+str(i-1)+'.txt')
    replace('    input_file: 		.asciz "raw'+str(i-1)+'.txt"',26)
    replace('    output_file: 		.asciz "image'+str(i)+'.txt"',27)
    replace('    mov r5, #'+str(2*i),61)
    run('arm-none-eabi-as rippling.s -g -o rippling.o')
    run('arm-none-eabi-ld rippling.o -o rippling')
    run('qemu-arm ./rippling')
    create('image'+str(i))
    relocate('image'+str(i-1)+'.png', 'images')
    relocate('raw'+str(i-1)+'.txt', 'raws')
    relocate('image'+str(i)+'.txt', 'outputs')
#"""

relocate('image'+str(iterations)+'.png', 'images')
relocate('raw'+str(iterations)+'.txt', 'raws')
relocate('image'+str(iterations)+'.txt', 'outputs')
