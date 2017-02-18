# import the necessary packages
import numpy as np
import argparse
import cv2
 
# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", help = "path to the image")
args = vars(ap.parse_args())
 

def detect_red():
	# load the image
	image = cv2.imread(args["image"])

	red_lower = [40, 60, 130]
	red_upper = [90, 130, 250]

	# create NumPy arrays from the boundaries
	lower = np.array(red_lower, dtype = "uint8")
	upper = np.array(red_upper, dtype = "uint8")

	# find the colors within the specified boundaries and apply the mask
	mask = cv2.inRange(image, lower, upper)
	output = cv2.bitwise_and(image, image, mask = mask)

	# show the images
	cv2.imshow("images", np.hstack([image, output]))
	cv2.waitKey(0)


def main():
	detect_red()

if __name__ == "__main__":
    main()