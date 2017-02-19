import numpy as np
import cv2
import sys
import io
import os
from google.cloud import vision
from detect_color import white_over_red
from emotion import emotion_detection

def main():
    mode = sys.argv[1]
    image = sys.argv[2]
    return ans(mode, image)

def ans(mode, image):
    cv_img = cv2.imread(image)
    cv2.imwrite("temp.jpg", cv_img)
    with io.open("temp.jpg", 'rb') as image_file:
        temp_img = image_file.read()    

    # classify objects
    if mode == 'object':
        return(detect_objects(temp_img))

    # make face detection
    elif mode == 'face':
        return(detect_faces(image))

    # mode == 'walk'
    elif mode == 'walk':
        return(may_walk(cv_img))

    else:
        print("Invalid function.")
        return(-1)

def detect_objects(content):
    vision_client = vision.Client()
    image = vision_client.image(content=content)
    labels = image.detect_labels()
    print('Labels:')
    for label in labels:
        print("object label: '%s' with the score of %f" % (label.description, label.score))
        return labels

def detect_faces(image):
    emotions = emotion_detection(open(image, "rb"))
    # print emotions
    print("There are in total %d many faces with:" %(len(emotions)))
    emotion_counts = {}
    for emotion in emotions:
        emotion_counts.update({emotion:emotion_counts.get(emotion,0)+1})
    for emot, counts in emotion_counts.iteritems():
        print("%d %s faces" %(counts,emot))
    return(emotions)

def may_walk(cv_img):
    # crosswalk lights classifiers (cascades)
    red_object_cascade = cv2.CascadeClassifier('cascade/crosswalk_redlight.xml')
    white_object_cascade = cv2.CascadeClassifier('cascade/crosswalk_greenlight.xml')
    reds = red_object_cascade.detectMultiScale(cv_img, 1.3, 5)
    whites = white_object_cascade.detectMultiScale(cv_img, 1.3, 5)
    # no detection
    if len(reds) + len(whites) is 0:
        print("No detection")
        return(-1)
    for sign in [reds, whites]:
        for (x,y,w,h) in sign:
            cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
            box = cv_img[y:y+h, x:x+w]
            cv2.imshow('cv_img',cv_img)
            cv2.waitKey(0)
            if white_over_red(box) is False:
                print("Not good to go.")
                return(-1)
    print("Good to go.")
    return(1)

def get_obj_score(JSON_obj):
    scores = 0
    lable_set = {"Lighting", "Signage", "Display Device", "Electronic Signage", "Flat Panel Display"}
    for entry in JSON_obj.labelAnnotations:
        if entry[description] in lable_set:
            scores += entry[score]
    return scores

if __name__ == '__main__':
    main()