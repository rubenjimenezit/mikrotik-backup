# import libraries
import paramiko
import argparse
import pysftp

#### ARGUMENTS

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

print("------------")
if args.ip:
    print("ip: %s" % args.ip)
    
if args.port:
    print("port: %s" % args.port)

if args.user:
    print("user: %s" % args.user)

if args.password:
    print("password: %s" % args.password)



#### VARIABLES

host = args.ip
port = args.port
username = args.user
password = args.password



#### FUNCTIONS

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
    send_command_print("/system backup save")
    client.exec_command("{ :local fecha [ /system clock get date ]; :local anyo [ :pick $fecha 7 11 ]; :local mes  [ :pick $fecha 0 3 ]; :local dia [ :pick $fecha 4 6]; :local nuevomes; :if ( $mes = \"jan\" ) do={ :set nuevomes ( \"01\" )}; :if ( $mes = \"feb\" ) do={ :set nuevomes ( \"02\" )}; :if ( $mes = \"mar\" ) do={ :set nuevomes ( \"03\" )}; :if ( $mes = \"apr\" ) do={ :set nuevomes ( \"04\" )}; :if ( $mes = \"may\" ) do={ :set nuevomes ( \"05\" )}; :if ( $mes = \"jun\" ) do={ :set nuevomes ( \"06\" )}; :if ( $mes = \"jul\" ) do={ :set nuevomes ( \"07\" )}; :if ( $mes = \"ago\" ) do={ :set nuevomes ( \"08\" )}; :if ( $mes = \"sep\" ) do={ :set nuevomes ( \"09\" )}; :if ( $mes = \"oct\" ) do={ :set nuevomes ( \"10\" )}; :if ( $mes = \"nov\" ) do={ :set nuevomes ( \"11\" )}; :if ( $mes = \"dec\" ) do={ :set nuevomes ( \"12\" )}; :local hora [/system clock get time]; :local nuevahora; :for i from=0 to=([:len $hora] - 4) do={ :local char [:pick $hora $i]; :if ($char = \":\") do={ :set $char \"\"; }; :set nuevahora ($nuevahora . $char); }; :local id [/system identity get name]; :local nuevafecha; :set nuevafecha ($id . \"-\" . $anyo . $nuevomes . $dia . \"-\" . $nuevahora ); /export file=$nuevafecha; };")
    client.close()
except paramiko.ssh_exception.AuthenticationException:
    print("Error de autenticacion")
except paramiko.ssh_exception.SSHException:
    print("Error al conectar")
except paramiko.ssh_exception.NoValidConnectionsError:
    print("Error al conectar")
except:
    print("Error al realizar backup:", sys.exc_info()[0])

print("------------")