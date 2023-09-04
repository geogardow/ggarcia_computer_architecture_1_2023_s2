from PIL import Image

original_picture_name = 'test.jpg'
preprocessed_picture_name = 'test_preprocessed.jpg'
txt_picture_name = 'test.txt'
desired_width = 640
desired_height = 480

def img_to_txt(original_picture_name, preprocessed_picture_name, txt_picture_name, desired_width, desired_height):

    # Open the image file
    image = Image.open(original_picture_name)

    # Convert the image to grayscale
    grayscale_image = image.convert("L")

    # Resize image if necessary
    resized_image = grayscale_image.resize((desired_width, desired_height))

    # Save the preprocessed image
    resized_image.save(preprocessed_picture_name)

    # Get pixel data as a sequence
    pixel_data = list(resized_image.getdata())

    # Convert intensity values to decimal representation
    decimal_values = [intensity for intensity in pixel_data]

    with open(txt_picture_name, 'w') as f:
        for value in decimal_values:
            f.write(f"{value}\n") 
    return decimal_values


img_to_txt(original_picture_name, preprocessed_picture_name, txt_picture_name, desired_width, desired_height)
