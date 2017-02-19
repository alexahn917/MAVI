import base64
import sys

def show_img(string_img):
    imgdata = base64.b64decode(string_img)
    filename = 'images/crosswalk.jpg'
    with open(filename, 'wb') as f:
        f.write(imgdata)
        f.close()
    print 'Success'

def main():
    with open('images/in.txt', 'r') as myfile:
        data = myfile.read().replace('\n', '')
        show_img(data)

if __name__ == '__main__':
    main()
