import numpy as np
import cv2
import argparse
import sys
from detect_color import white_over_red

def answer(mode, image):
    return_answer = -1
    is_good = 1

    # Cascades
    if mode == 'face':
        object_cascade = cv2.CascadeClassifier('cascade/haarcascade_frontalface_default.xml')
    elif mode == 'walk':
        object_cascade = cv2.CascadeClassifier('cascade/crosswalk_greenlight.xml')
    else:
        print('wrong mode selected')
        exit(0)

    # read images
    cv_img = cv2.imread(image)

    # make detection
    objects = object_cascade.detectMultiScale(cv_img, 1.3, 5)

    # no detection
    if len(objects) is 0:
        submit_answer(-1)

    if mode == 'walk':
        obj_len = []
        scores = []
        # get score for "Lighting, Signage, Display Device, Electronic Signage, Flat Panel Display"
        for (x,y,w,h) in objects:
            obj_len.append(w*h)
#        for img in objects:
#            JSON_obj = google_function(img)
#            scores.append(get_obj_score(JSON_obj))
        sign = [objects[obj_len.index(max(obj_len))]]

        for (x,y,w,h) in sign:
            cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
            box = cv_img[y:y+h, x:x+w]
            cv2.imshow('cv_img',cv_img)
            cv2.waitKey(0)
            if white_over_red(box) is True:
                #print("Yes, you may.")
                submit_answer(1)
            else:
                #print("No, you may not.")
                submit_answer(-1)

    if mode == 'face':
        for (x,y,w,h) in objects:
            cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
            box = cv_img[y:y+h, x:x+w]
            cv2.imshow('cv_img',cv_img)
#        print("Number of faces: %d" %(len(objects)))
        submit_answer(len(objects))

    cv2.imshow('cv_img',cv_img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def google_label_detection(img):
    return obj

def get_obj_score(JSON_obj):
    scores = 0
    lable_set = {"Lighting", "Signage", "Display Device", "Electronic Signage", "Flat Panel Display"}
    for entry in JSON_obj.labelAnnotations:
        if entry[description] in lable_set:
            scores += entry[score]
    return scores

def submit_answer(ans):
    with open("return_answer.txt", "w") as f:
        f.write(str(ans))
        f.close()
        exit(0)

def main():
    #construct the argument parse and parse the arguments
    mode = sys.argv[1]
    image = sys.argv[2]
    answer(mode, image)

if __name__ == "__main__":
    main()
