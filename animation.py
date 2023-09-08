import matplotlib.pyplot as plt
from matplotlib.animation import FFMpegWriter

# Create a figure and axis
fig, ax = plt.subplots()

# Create an empty list to store the images
images = []

# Load each image and append it to the images list
for i in range(1,41,1):
    img = plt.imread('images/image'+str(i)+'.png')
    img_plot = ax.imshow(img)
    images.append([img_plot])

# Create an animation
ani = plt.ArtistAnimation(fig, images, interval=100, blit=True)

# Define the writer for saving the animation as an MP4 file
writer = FFMpegWriter(fps=10, metadata=dict(artist='Geo García D'), bitrate=1800)

# Save the animation as an MP4 file
ani.save('animation.mp4', writer=writer)

# Show the animation (optional)
plt.show()
