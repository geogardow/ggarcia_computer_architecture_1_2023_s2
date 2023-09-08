from PIL import Image

"""
Tecnológico de Costa Rica
Área Académica Ingeniería en Computadores
Arquitectura de Computadores I
II Semestre 2023

Geovanny García Downing
2020092224
"""

original_picture_name = 'test.jpg'
preprocessed_picture_name = 'test_preprocessed.jpg'
txt_picture_name = 'test.txt'
desired_width = 640
desired_height = 640

def img_to_txt(original_picture_name = 'test.jpg', txt_picture_name = 'test.txt', desired_width = 640, desired_height = 640):
    """
    Este código permite convertir de una imagen a un crudo txt con sus valores de intensidad a escala grises
    """
    # Abre el archivo de imagen
    image = Image.open(original_picture_name)

    # Convierte a escala de grises
    grayscale_image = image.convert("L")

    # Resize de la imagen
    resized_image = grayscale_image.resize((desired_width, desired_height))

    # Guarda imagen preprocesada
    #resized_image.save(preprocessed_picture_name)

    # Obtiene los pixeles en una lista
    decimal_values = []
    for y in range(desired_height):
        for x in range(desired_width):
            # Get y append de la intensidad del pixel buscado
            intensity = resized_image.getpixel((x, y))
            decimal_values.append(intensity)

    with open(txt_picture_name, 'w') as f:
        for value in decimal_values:
            f.write(f"{str(value).zfill(3)}\n") 
    return decimal_values

