from pymysql import Connection
import os

def init_db():
    DB_HOST = os.environ.get('MYSQL_HOST', '127.0.0.1')
    DB_USER = os.environ.get('MYSQL_USER', 'root')
    DB_PASS = os.environ.get('MYSQL_PASS', 'password')
    DB_NAME = os.environ.get('MYSQL_DB', 'test_loic')

    connection = Connection(host = DB_HOST, user = DB_USER, password = DB_PASS, db = DB_NAME, autocommit = True)
    c = connection.cursor()
    c.execute('''
            CREATE TABLE IF NOT EXISTS user (
                id int  AUTO_INCREMENT,
                first_name varchar(128),
                last_name varchar(128),
                email varchar(128),
		PRIMARY KEY(id)
            );
    ''')
    return connection

