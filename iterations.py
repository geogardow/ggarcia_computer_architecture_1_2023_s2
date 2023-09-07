import subprocess
from preprocess import *
from PIL import Image
import os

def run(command):
    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, text=True)
        #print("Command output:")
        #print(output)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")

def replace(new_content, line_number, file_path = "rippling.s"):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()

        if 1 <= line_number <= len(lines):
            lines[line_number - 1] = new_content + '\n'

            with open(file_path, 'w') as file:
                file.writelines(lines)
                #print(f"Line {line_number} replaced with: {new_content}")
        else:
            print(f"Line number {line_number} is out of range for the file.")

    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

def create(filename):

    image_size = (640, 640)
    img = Image.new('L', image_size)
    os.chmod(filename+".txt", 0o600)

    with open(filename+".txt", 'r') as file:
        for line in file:
            x, y, intensity = map(int, line.strip().split(';'))
            if x == 999 or y == 999:
                continue
            else:
                img.putpixel((x, y), intensity)

    img.save(filename+".png")
    img.show()

    
