import cv2
import os

"""
Tecnológico de Costa Rica
Área Académica Ingeniería en Computadores
Arquitectura de Computadores I
II Semestre 2023

Geovanny García Downing
2020092224
"""

def animate():
    """
    Este código permite recorrer las imágenes realizadas y generar un video a partir de ellas
    """
    # Ruta al directorio que contiene tus archivos de imagen
    image_directory = 'images'

    # Obtener una lista de archivos de imagen en el directorio
    image_files = [os.path.join(image_directory, filename) for filename in os.listdir(image_directory) if filename.endswith('.png')]

    # Ordenar los archivos de imagen en función de su parte numérica
    image_files.sort(key=lambda x: int(os.path.splitext(os.path.basename(x))[0][-2:]))

    # Establecer el nombre del archivo de video de salida
    output_video = 'animacion.mp4'

    # Definir la velocidad de cuadros (frames por segundo)
    frame_rate = 4  

    # Definir las dimensiones del video en función del tamaño de la primera imagen
    first_image = cv2.imread(image_files[0])
    height, width, layers = first_image.shape

    # Inicializar el escritor de video
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # Puedes cambiar el códec según sea necesario
    video_writer = cv2.VideoWriter(output_video, fourcc, frame_rate, (width, height))

    # Recorrer las imágenes y agregarlas al video con la demora especificada
    for image_file in image_files:
        frame = cv2.imread(image_file)
        video_writer.write(frame)

    # Liberar el escritor de video
    video_writer.release()


    print(f"Video '{output_video}' created successfully.")
