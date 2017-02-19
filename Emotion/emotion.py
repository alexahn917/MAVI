import httplib, urllib, base64
import sys
import re
import base64
from PIL import Image
import numpy as np

def emotion_detection(img_data):
	headers = {
		# Request headers                                                                                                                                                
		'Content-Type': 'application/octet-stream',
		'Ocp-Apim-Subscription-Key': '604dccf2aff542d180f47921c40646d3',
	}

	params = urllib.urlencode({
	})

	try:
		conn = httplib.HTTPSConnection('westus.api.cognitive.microsoft.com')
		conn.request("POST", "/emotion/v1.0/recognize?%s" % params, 
			img_data, headers)
		response = conn.getresponse()
		data = response.read()
		data = re.findall(r'"scores":.{1,500}', data)[0]
		data = data.replace('"scores":{', "")
		data = data.replace('}', "")
		category = re.findall(r'".{1,10}"', data)
		#allstate = re.finall(r'".{1,10}":.{1,15},', data)                                                                                                               
		num = ""
		score_list = []
		add = False
		for element in data:
			if element == ',' or element == ']':
				add = False
				score_list.append(float(num))
				num = ""
			if add:
				num = num + "" +  element
			if element == ':':
				add = True
		max_index = score_list.index(max(score_list))
		max_emotion = category[max_index]
		print(max_emotion.replace('"', ""))
		conn.close()
	except Exception as e:
		print("[Errno {0}] {1}".format(e.errno, e.strerror))

####################################

def main():
	img_data = open(sys.argv[1], 'rb')
	emotion_detection(img_data)

if __name__ == '__main__':
	main()
