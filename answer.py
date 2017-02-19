import numpy as np
import cv2
import sys
from detect_color import white_over_red
from emotion import emotion_detection

def main():
    mode = sys.argv[1]
    image = sys.argv[2]
    return ans(mode, image)

def ans(mode, image):
    return_answer = -1
    is_good = 1

    # cascades
    object_cascade = cv2.CascadeClassifier('cascade/haarcascade_frontalface_default.xml')
    red_object_cascade = cv2.CascadeClassifier('cascade/crosswalk_redlight.xml')
    white_object_cascade = cv2.CascadeClassifier('cascade/crosswalk_greenlight.xml')        

    # read images
    cv_img = cv2.imread(image)

    # make face detection
    if mode == 'face':
        faces = object_cascade.detectMultiScale(cv_img, 1.3, 5)
        # no face detection
        if len(faces) is 0:
            print("No detection")
            return(-1)
        for (x,y,w,h) in faces:
            cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
            box = cv_img[y:y+h, x:x+w]
            cv2.imshow('cv_img',cv_img)
            cv2.imwrite("test1.jpg", box)
#            emotion = emotion_detection(open("test1.jpg", "rb"))[0]
#            emotions.update({emotion: emotions.get(emotion, 0) + 1})

#        cv2.waitKey(0)
        # print emotions
        print("There are in total %d many faces with:" %(len(faces)))
        emotions = emotion_detection(open(image, "rb"))
        emotion_counts = {}
        for emotion in emotions:
            emotion_counts.update({emotion:emotion_counts.get(emotion,0)+1})
        for emot, counts in emotion_counts.iteritems():
            print("%d %s faces" %(counts,emot))
        return(len(faces))

    # mode == 'walk'
    else: 
        reds = red_object_cascade.detectMultiScale(cv_img, 1.3, 5)
        whites = white_object_cascade.detectMultiScale(cv_img, 1.3, 5)
        # no detection
        if len(reds) + len(whites) is 0:
            print("No detection")
            return(-1)

        # get score for "Lighting, Signage, Display Device, Electronic Signage, Flat Panel Display"
#        for img in objects:
#            JSON_obj = google_function(img)
#            scores.append(get_obj_score(JSON_obj))

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

def google_label_detection(img):
    return obj

def get_obj_score(JSON_obj):
    scores = 0
    lable_set = {"Lighting", "Signage", "Display Device", "Electronic Signage", "Flat Panel Display"}
    for entry in JSON_obj.labelAnnotations:
        if entry[description] in lable_set:
            scores += entry[score]
    return scores

if __name__ == '__main__':
    main()