#!flask/bin/python
from flask import Flask, jsonify
from main import *
import SimpleHTR

app = Flask(__name__)

@app.route('/')
def index():
   return "Hello, World!"

@app.route('/getRandomWord', methods=['GET'])
def getRandomWord():
    return jsonify(returnWord())

@app.route('/getWordFromInput/<word>', methods=['GET'])
def getWordFromInput(word):
    return jsonify(getWord(word))

@app.route('/getWordFromImg/<address>', methods=['POST'])
def getWordFromImg(address):
   return jsonify(getWord(SimpleHTR.src.main.main(address)))

if __name__ == '__main__':
   app.run(debug=True)