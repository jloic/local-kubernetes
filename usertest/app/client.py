import requests
import pprint

t = requests.post('http://localhost:5000/v1/users', json = {'first_name' : 'loic', 'last_name' :'jeannin', 'email' : 'bla@bla'})
pprint.pprint(t.json())
