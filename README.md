# MAVI
Mobile Application for the Visually Impaired.

## Inspiration
The inspiration for MAVI is to address physical and social barriers visually impaired people face on their daily lives. While assisting options (ie. guide dogs) exist, many of said options are either not too inaccessible or too specific. Moreover, there are many problems left unsolved for the visually impaired. We wanted to build something that would tackle mundane, untouched problems through leveraging popular methods and frameworks. On top of this, we want to integrate the platform that we build into something owned by a majority of the people in the world, a mobile device. Thus born, MAVI, a Mobile Assistant for the Visually Impaired.

## What it does
Through the lens of a mobile device, MAVI analyzes a user's surroundings through computer vision and auditorially informs the user of information inaccessible to them. MAVI is able to handle a number of request from its user and respond accordingly. MAVI's biggest features including "Can I Cross" and "What Do I See". The former detects the surrounding for pedestrian signals to inform the user if they can cross the streets. The latter is an array of machine learning detections that helps the user recognize who/what is around them.

## How we built it
Using OpenCV, we created a novel object classifier detecting crosswalk lights using supervised neural network learning and the dataset which we labeled ourselves. We were able to generate ~1000 labeled instances by superimposing target objects on top of irrelevant backgrounds photos to overcome hand-labeling. Our training was done through cross-validation to overcome overfitting issues and was optimized by choosing best parameters in terms of precision rates over 30 stages of iterations.

The mobile application is written in Swift and deployed onto ios devices. When a user takes a picture through their device, the image is translated to a bit64 file and sent to our backend server. The backend server is written with Flask and deployed on Heroku with OpenCV support which will run the scripts necessary to detect and process the image.

## Challenges we ran into
We faced countless challenges in trying to send image data to a public server. We deployed 3 different servers using Django framework, PHP, and finally Flask to finally get it working optimally for our purposes. Many frameworks that we used, including Swift 3, Flask, Alamofire has very little and undetailed documentation, which made building extra challenging.

## Accomplishments that we're proud of
On top of creating our own object classifier for pedestrian signals, honestly, we are super proud to present this as a product in its entirety. It was a huge challenge to tie all the heavy loaded features that we wanted to fit in this one app. We are very happy with the state of the app and how well its functionalities represent our original vision.

## What we learned
We learned how to utilize different applications of OpenCV to create novel object classifiers. We also learned how to create a restful api with Flask. On top of which, we learned how to handle with uploading an image through http requests. We learned how to set our own parameters to effectively train a machine to recognize pedestrian signals.

## What's next for MAVI: a Mobile Assistant for the Visually Impaired
MAVI is a very powerful and potentially very impactful application. The first step for the team is to refine the front end to seamlessly integrate all the features: Crosswalk, Crowdedness, Emotion Recognition, Text, and Numbers. After refining the object classifier, we hope to soon deploy it for the general public to use.

## Built With
`swift`, `python`, `objective-c`, `php`, `google-cloud-vision`, `opencv`, `machine-learning`, `ios`, `amazon-web-services`, `microsoft-cognitive-services`, `computer-vision`, `speech-recognition`
