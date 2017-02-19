from flask import Flask, request, redirect, jsonify
import base64
from answer import ans


app = Flask(__name__)

@app.route("/process-image", methods=["POST"])
def hello_world():
    lang = request.get_json(force=True, silent = True)
    img_data = lang['img']
    img_data = base64.b64decode(img_data)
    filename = 'images/input.jpg'
    with open(filename, 'wb') as f:
        f.write(img_data)

    ans("walk", filename)




    return jsonify({"name": "yes"})


# @app.route("/process-image")
# def hello_world():
#     return jsonify({"mmessage": "working"})
#


if __name__ == "__main__":
    app.run(host='0.0.0.0', port="8000")
