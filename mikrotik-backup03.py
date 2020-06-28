# import libraries
import paramiko
import argparse


#### parse arguments

# Initiate the parser
parser = argparse.ArgumentParser()

# Add long and short argument
parser.add_argument("--ip", "-i", help="device ip or hostname")
parser.add_argument("--port", "-p", help="device port")
parser.add_argument("--user", "-u", help="device user")
parser.add_argument("--password", "-pw", help="device password")

# Read arguments from the command line
args = parser.parse_args()

# Check for arguments and print them
if args.ip:
    print("ip: %s" % args.ip)
    
if args.port:
    print("port: %s" % args.port)

if args.user:
    print("user: %s" % args.user)

if args.password:
    print("password: %s" % args.password)



#### variables

host = args.ip
port = args.port
username = args.user
password = args.password

#### functions

# send_command executes the command (str) in the device and prints the output in the console
def send_command_print(command):
    print (command)
    stdin, stdout, stderr = client.exec_command(command)
    for line in stdout:
        print(line.strip('\n'))
    print()


#### main program

client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
try:
    client.connect(host,port=port, username=username, password=password)
    send_command_print ('/system backup save')
    #send_command_print ('/export')
    #send_command_print ('/ip address print')
    #send_command_print ('/interface ethernet print')
    client.close()
except paramiko.ssh_exception.AuthenticationException:
    print("Error de autenticacion")
except paramiko.ssh_exception.SSHException:
    print("Error al conectar")
except paramiko.ssh_exception.NoValidConnectionsError:
    print("Error al conectar")
