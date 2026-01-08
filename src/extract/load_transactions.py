import psycopg2
import paramiko

target = '' ## Add in .env
target_user = '' # Add in .env
target_password = '' # Add in .env 

ssh = paramiko.SSHClient() 

def get_connection(target, user, password): 
    
    ssh.load_system_host_keys()

    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    ssh.connect(target, username=user, password=password, look_for_keys=False)

    ssh_stdin, ssh_stout, ssh_stderr = ssh.exec_command("docker ps")

    output = ssh_stout.readlines()

    ssh.close() 

    return output

test = get_connection(target, target_user, target_password)

if test:
    print(test)
else: 
    print("Connection Failed")
