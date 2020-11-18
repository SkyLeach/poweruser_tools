'''
using Pillow to resize an image or images in order to post to social media.
'''
from PIL import Image
# from __future__ import print_function
# Create an Image object from a jpg file
# TODO: replace useless hardcoded line
img = Image.open("whale.jpg")
# TODO: make function
# Make the new image half the width and half the height of the original image
resized_img = img.resize(
    round(img.size[0]*.5), round(img.size[1]*.5)
)
print("I wonder how good this thing really is.")
# TODO: optionalize the pointless GUI calls, removed for now
# Display the original image
# img.show()
# Display the resized image
# resized_img.show()
# Save the resized image to disk
# TODO: replace hard-coded name and location.
resized_img.save("whale_resized.jpg")
# Scale a region
# TODO: add function
res_and_scaled_img = img.resize(
    round(img.size[0]*.5),
    round(img.size[1]*.5),
    box=(100, 100, 200, 225))
res_and_scaled_img.show()
if __name__ == '__main__':
    # parse the CLI
    # do stuff
    pass
