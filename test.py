import numpy as np
import cv2
import sys
from detect_color import white_over_red

mode = sys.argv[1]
image = sys.argv[2]
#print(ans(mode, image))

return_answer = -1
is_good = 1

# Cascades
if mode == 'face':
    object_cascade = cv2.CascadeClassifier('cascade/haarcascade_frontalface_default.xml')
elif mode == 'walk':
    object_cascade = cv2.CascadeClassifier('cascade/crosswalk_greenlight.xml')
else:
    print(-1)
    sys.exit(1)

# read images
cv_img = cv2.imread(image)

# make detection
objects = object_cascade.detectMultiScale(cv_img, 1.3, 5)

# no detection
if len(objects) is 0:
    print(-1)
    sys.exit(1)

if mode == 'walk':
    obj_len = []
    scores = []
for (x,y,w,h) in objects:
    obj_len.append(w*h)

sign = [objects[obj_len.index(max(obj_len))]]

for (x,y,w,h) in sign:
    cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
    box = cv_img[y:y+h, x:x+w]
    cv2.imshow('cv_img',cv_img)
    cv2.waitKey(0)
    if white_over_red(box) is True:
        print(1)
        sys.exit(1)
    else:
        print(-1)
        sys.exit(1)

if mode == 'face':
    for (x,y,w,h) in objects:
    cv2.rectangle(cv_img,(x,y),(x+w,y+h),(255,0,0),2)
    box = cv_img[y:y+h, x:x+w]
    cv2.imshow('cv_img',cv_img)
    #print("Number of faces: %d" %(len(objects)))
    print(len(objects))
    sys.exit(1)

#cv2.imshow('cv_img',cv_img)
#cv2.waitKey(0)
#cv2.destroyAllWindows()
#return(-1)