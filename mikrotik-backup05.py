# mikrotik-backup
# Autor: Rubén Jiménez
# Fecha: 2020/06/27
# Descripción: esta aplicación conecta a un dispositivo mikrotik, genera los archivos de backup .rsc y .backup, crea un directorio local con el nombre del identity del dispositivo mikrotik, y descarga los archivos de backup generados a dicho directorio

# import libraries
import paramiko, argparse, datetime, os
from paramiko import SSHClient
from scp import SCPClient

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
print("------------------")
if args.ip:
    print("ip: %s" % args.ip)
    
if args.port:
    print("port: %s" % args.port)

if args.user:
    print("user: %s" % args.user)

if args.password:
    print("password: %s" % args.password)

print("------------------")



#### VARIABLES

host = args.ip
port = args.port
username = args.user
password = args.password


#### MAIN PROGRAM

# conectar con mikrotik por ssh
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
try:
    client.connect(host,port=port, username=username, password=password)

    # obtener el system identity del mikrotik y guardarlo en variable "identity"
    stdin, stdout, stderr = client.exec_command("{ :local id [/system identity get name]; :put $id}")
    for line in stdout:
        identity = (line.strip('\n')).strip('\r')
    
    nombre_archivo_backup = identity + "-" + (datetime.datetime.now()).strftime("%Y%m%d-%H%M")

    # ejecutar en mikrotik: export de la configuración en formato texto con nombre = identity-fecha-hora.rsc
    stdin, stdout, stderr = client.exec_command("/export file=" + nombre_archivo_backup)
    
    # controlar que haya finalizado el export
    exit_status = stdout.channel.recv_exit_status()
    if exit_status == 0:
        print ("Export realizado en Mikrotik")
    else:
        print("Error al realizar export en Mikrotik: ", exit_status)
    
    # ejecutar en mikrotik: backup de sistema en formato binario con nombre  = identity-fecha-hora.backup
    stdin, stdout, stderr = client.exec_command("/system backup save")

     # controlar que haya finalizado el backup
    exit_status = stdout.channel.recv_exit_status()
    if exit_status == 0:
        print ("Backup realizado en Mikrotik")
    else:
        print("Error al realizar export en Mikrotik: ", exit_status)
    
        client.close()

except paramiko.ssh_exception.AuthenticationException:
    print("Error de autenticacion")
except paramiko.ssh_exception.SSHException:
    print("Error al conectar")
except paramiko.ssh_exception.NoValidConnectionsError:
    print("Error al conectar")
except:
    print("Error al realizar backup")


# crear directorio para los archivos de backup
path = "./" + identity
try:
    if not os.path.exists(path):
        os.mkdir(path)
        print ("Directorio %s creado" % path)
    else:
        print ("Directorio %s ya existe" % path)
except OSError:
    print ("Error al crear directorio %s" % path)


# descargar archivos de backup a directorio local
ssh = SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(host,port=port, username=username, password=password)

# descargar al directorio creado anteriormente el archivo .rsc 
remoteFilePath = nombre_archivo_backup + ".rsc"
localFilePath = path + "/" + nombre_archivo_backup + ".rsc"

with SCPClient(ssh.get_transport()) as scp:
    try:
        scp.get(remoteFilePath,localFilePath)
        print("Archivo descargado: %s" % localFilePath)
    except:
        print("Error al descargar el archivo %s a directorio local" % remoteFilePath)

# descargar al directorio creado anteriormente el archivo .backup
remoteFilePath = nombre_archivo_backup + ".backup"
localFilePath = path + "/" + nombre_archivo_backup + ".backup"

with SCPClient(ssh.get_transport()) as scp:
    try:
        scp.get(remoteFilePath,localFilePath)
        print("Archivo descargado: %s" % localFilePath)
    except:
        print("Error al descargar el archivo %s a directorio local" % remoteFilePath)
   