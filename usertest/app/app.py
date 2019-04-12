#!/usr/bin/python3
from flask import Flask
import datetime
import json

app = Flask(__name__)

@app.route('/v1/healthz')
@app.route('/')
def hello_world():
    data = {'code' : 0,
            'msg' : 'Ok',
            'date' : str(datetime.datetime.now())}
    return json.dumps(data)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
