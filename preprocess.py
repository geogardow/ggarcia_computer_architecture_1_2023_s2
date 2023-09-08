from PIL import Image

original_picture_name = 'test.jpg'
preprocessed_picture_name = 'test_preprocessed.jpg'
txt_picture_name = 'test.txt'
desired_width = 640
desired_height = 640

def img_to_txt(original_picture_name = 'test.jpg', txt_picture_name = 'test.txt', desired_width = 640, desired_height = 640):

    # Open the image file
    image = Image.open(original_picture_name)

    # Convert the image to grayscale
    grayscale_image = image.convert("L")

    # Resize image if necessary
    resized_image = grayscale_image.resize((desired_width, desired_height))

    # Save the preprocessed image
    #resized_image.save(preprocessed_picture_name)

    # Get pixel data as a sequence

    decimal_values = []
    for y in range(desired_height):
        for x in range(desired_width):
            # Get the intensity value at the current pixel
            intensity = resized_image.getpixel((x, y))
            
            # Append the intensity value to the list
            decimal_values.append(intensity)

    with open(txt_picture_name, 'w') as f:
        for value in decimal_values:
            f.write(f"{str(value).zfill(3)}\n") 
    return decimal_values

