"""
File: pillow_img_test.py
Author: SkyLeach
Email: skyleach@gmail.com
Github: https://github.com/skyleach/poweruser_tools
Description: simple python pillow test.
"""
from sys import argv
from PIL import Image


def showimg(filename):
    """Show an image using pillow.
    """
    with Image.open(filename) as pimg:
        pimg.show()


if __name__ == "__main__":
    showimg(argv[-1])
