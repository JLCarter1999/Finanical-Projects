import psycopg2
import paramiko
import os
from dotenv import load_dotenv
from sshtunnel import SSHTunnelForwarder

load_dotenv()

# Retrieve Info from .env 
target = os.getenv('target_device')
target_port = int(os.getenv('target_port'))
target_user = os.getenv('target_user')
target_password = os.getenv('target_password') 

db_host = os.getenv('DB_HOST')
db_port = int(os.getenv('DB_PORT'))
db_name = os.getenv('DB_NAME')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')


def get_db_via_ssh(ssh_target, ssh_port, ssh_user, ssh_password, db_host, db_port, db_name, db_user, db_password):
    server = SSHTunnelForwarder(
        (ssh_target, ssh_port), 
        ssh_username=ssh_user, 
        ssh_password=ssh_password,
        remote_bind_address=(db_host, db_port), 
        local_bind_address=("127.0.0.1", 0) # 0 = a free local port 
    )
    server.start()

    conn = psycopg2.connect(
        host=db_host,
        port=server.local_bind_port, 
        database=db_name,
        user=db_user,
        password=db_password
    )

    return conn, server 

conn, tunnel = get_db_via_ssh(target, target_port, target_user, target_password, db_host, db_port, db_name, db_user, db_password)

if conn:
    print("Connection Established")
else: 
    print("Connection Failed")