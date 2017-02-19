import numpy as np
import cv2
import argparse
import sys
from detect_color import white_over_red

def answer(mode, image):
    is_good = 1
    print(mode, image)
    # Cascades
    if mode == 'face':
        object_cascade = cv2.CascadeClassifier('cascade/haarcascade_frontalface_default.xml')
    elif mode == 'walk':
        object_cascade = cv2.CascadeClassifier('cascade/crosswalk_greenlight.xml')
    else:
        print('wrong mode selected')
        exit(0)

    cv_img = cv2.imread(image)
    objects = object_cascade.detectMultiScale(cv_img, 1.3, 5)

    if mode == 'walk' and objects is not None:
        obj_len = []
        for (x,y,w,h) in objects:
            obj_len.append(w*h)
        sign = [objects[obj_len.index(max(obj_len))]]

        for (x,y,w,h) in sign:
            cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
            box = cv_img[y:y+h, x:x+w]
            cv2.imshow('cv_img',cv_img)
            if not white_over_red(box):
                print("Yes, you may.")
    #            return 1
            else:
                print("No, you may not.")
    #            return 0

    if mode == 'face' and objects is not None:
	    for (x,y,w,h) in objects:
	        cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
	        box = cv_img[y:y+h, x:x+w]
	        cv2.imshow('cv_img',cv_img)
	    print("Number of faces: %d" %(len(objects)))
	#        return len(objects)

    cv2.imshow('cv_img',cv_img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def main():
    #construct the argument parse and parse the arguments
#    ap = argparse.ArgumentParser()
#    ap.add_argument("-m", "--mode", help = "detection mode")
#    ap.add_argument("-i", "--image", help = "path to the image")
#    args = vars(ap.parse_args())
    mode = sys.argv[1]
    image = sys.argv[2]
    answer(mode, image)

if __name__ == "__main__":
    main()