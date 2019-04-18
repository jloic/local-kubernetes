#!/usr/bin/python3
from flask import Flask, request
from flask_restful import Resource, Api
from flask_restful_swagger import swagger
import pprint
import datetime
import json
from db import init_db

app = Flask(__name__)
api = swagger.docs(Api(app), apiVersion='1')

try:
    connection = init_db()
except:
    connection = None

@app.route('/v1/healthz')
@app.route('/')
def index():
    return json.dumps({"code" : 1})

class Users(Resource):
    def get(self):
        c = connection.cursor()
        c.execute('select * from user')

        users = []
        for i in c:
            u = dict(zip([j[0] for j in c.description], i))
            users.append(u)

        data = {'code' : 0,
            'msg' : 'Ok',
            'users' : users,
            'date' : str(datetime.datetime.now())}
        return data

    def post(self):
        q = '''INSERT INTO user (first_name, last_name, email) values (%s, %s, %s);'''
        c = connection.cursor()
        d = request.json
        c.execute(q, [d['first_name'], d['last_name'], d['email']])
        return self.get()

api.add_resource(Users, '/v1/users')
#api.add_resource(User, '/v1/user/<string:user_id>')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
