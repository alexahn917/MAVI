# import the necessary packages
import numpy as np
import argparse
import cv2

# return 1 if cv2 image has more red then green(white)
def white_over_red(image):
#    image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    red_lower = [0, 0, 150]
    red_upper = [150, 255, 255]

    wh_lower = [170, 170, 170]
    wh_upper = [255, 255, 255]

    # create NumPy arrays from the boundaries
    r_lower = np.array(red_lower, dtype = "uint8")
    r_upper = np.array(red_upper, dtype = "uint8")

    w_lower = np.array(wh_lower, dtype = "uint8")
    w_upper = np.array(wh_upper, dtype = "uint8")

    # find red
    r_mask = cv2.inRange(image, r_lower, r_upper)
    r_output = cv2.bitwise_and(image, image, mask = r_mask)

    # find white
    w_mask = cv2.inRange(image, w_lower, w_upper)
    w_output = cv2.bitwise_and(image, image, mask = w_mask)

    # show the images
    print("Total pixels: ", np.sum(image))
    reds = int(np.sum(r_output))
    whites = int(np.sum(w_output))
    diff = reds - whites
    print("Red pixels:", reds)
    print("White pixels:", whites)
    print("Red - White:", diff)

    is_good = True if reds > (whites * 10) else False
    if is_good:
        cv2.imshow("images", np.hstack([image, w_output]))
    else:
        cv2.imshow("images", np.hstack([image, r_output]))        
#    cv2.waitKey(0)

    return is_good