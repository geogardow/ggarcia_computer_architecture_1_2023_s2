import cv2
import os

def animate():
    # Path to the directory containing your image files
    image_directory = 'images'

    # Get a list of image files in the directory
    image_files = [os.path.join(image_directory, filename) for filename in os.listdir(image_directory) if filename.endswith('.png')]

    # Sort the image files based on their numerical part
    image_files.sort(key=lambda x: int(os.path.splitext(os.path.basename(x))[0][-2:]))

    # Set the output video file name
    output_video = 'animation.mp4'

    # Define the frame rate (frames per second)
    frame_rate = 4  

    # Define the video dimensions based on the first image's size
    first_image = cv2.imread(image_files[0])
    height, width, layers = first_image.shape

    # Initialize the video writer
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # You can change the codec as needed
    video_writer = cv2.VideoWriter(output_video, fourcc, frame_rate, (width, height))

    # Loop through the images and add them to the video with the specified delay
    for image_file in image_files:
        frame = cv2.imread(image_file)
        video_writer.write(frame)

    #Release the video writer
    video_writer.release()

    print(f"Video '{output_video}' created successfully.")
