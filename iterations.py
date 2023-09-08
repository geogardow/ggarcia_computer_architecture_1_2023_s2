import subprocess
from preprocess import *
from PIL import Image
import os
import shutil

"""
Tecnológico de Costa Rica
Área Académica Ingeniería en Computadores
Arquitectura de Computadores I
II Semestre 2023

Geovanny García Downing
2020092224
"""

def run(command):
    """
    Este código permite correr comandos en termial
    """
    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, text=True)
        #print("Command output:")
        #print(output)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")

def replace(new_content, line_number, file_path = "rippling.s"):
    """
    Este código permite cambiar las líneas de texto en un archivo
    Se utiliza para modificar los valores k e inputs del script .s
    """
    try:
        # Abre archivo y recorre lineas hasta encontrar la especifica e inserta la nueva linea
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
    """
    Este código crea una imagen a partir del output del compilado de arm
    """
    image_size = (640, 640)
    img = Image.new('L', image_size)
    os.chmod(filename+".txt", 0o600) #Permisos de lectura escritura

    with open(filename+".txt", 'r') as file:
        #Recorre las lineas
        for line in file:
            x, y, intensity = map(int, line.strip().split(';'))
            #No agrega valores fuera de rango
            if x == 999 or y == 999:
                continue
            else:
                img.putpixel((x, y), intensity)

    img.save(filename+".png")
    img.show()

def relocate(source_file, destination_path):
    """
    Este código reubica archivos para mejorar el orden
    """
    try:
        destination_path = destination_path + "/" + source_file
        # Verifica existencia del archivo
        if not os.path.isfile(source_file):
            return False
        
        # Si existe el archivo, sobreescribir
        if os.path.exists(destination_path):
            if os.path.isfile(destination_path):
                os.remove(destination_path)
            else:
                return False
        
        # Crea directorio si no existe
        destination_directory = os.path.dirname(destination_path)
        os.makedirs(destination_directory, exist_ok=True)
        
        # Mueve el archivo al destino
        shutil.move(source_file, destination_path)
        os.chmod(destination_path, 0o666)

        return True
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return False

    
