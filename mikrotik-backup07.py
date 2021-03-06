#! python3

"""
Author: Rubén Jiménez
Date: 27/06/2020
Description: this application execute the following tasks:
- connects to a mikrotik routeros device
- export the mikrotik configuration and generate .rsc file
- backup the mikrotik configuration and generate  .backup file
- create a local directory
- download .rsc and .backup files from mikrotik device to the generated directory

Usage:
    mikrotik-backup -i <ip or hostname> -p <ssh port> -u <username> -pw <password> 
"""


#### IMPORT

import paramiko, argparse, datetime, os
from scp import SCPClient



#### FUNCTIONS

def directory_create (path):
    """create a new directory

    :param path: path of the directory to be created
    """
    try:
        if not os.path.exists(path):
            os.mkdir(path)
            print ("Directorio %s creado" % path)
        else:
            print ("Directorio %s ya existe" % path)
    except OSError:
        print ("Error al crear directorio %s" % path)


def file_get (host, port, username, password, remoteFilePath, localFilePath):
    """download a file from a Mikrotik device

    :param host: mikrotik IP or hostname
    :param port: mikrotik ssh connectin port
    :param username: mikrotik username
    :param password: mikrotik password
    :param remoteFilePath: file path to be downloaded
    :param localFilePath: destination local directory to save the downloaded file
    """
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host,port=port, username=username, password=password)
    with SCPClient(ssh.get_transport()) as scp:
        try:
            scp.get(remoteFilePath,localFilePath)
            print("Archivo descargado: %s" % localFilePath)
        except:
            print("Error al descargar el archivo %s a directorio local" % remoteFilePath)


def identity_get (host, port, username, password):
    """returns identity name from a mikrotik routeros device of None if it is not possible to connect

    :param host: mikrotik IP or hostname
    :param port: mikrotik ssh connectin port
    :param username: mikrotik username
    :param password: mikrotik password

    :returns: identity name of the mikrotik routeros device
    """
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    #try:
    client.connect(host,port=port, username=username, password=password)

    # get mikrotik system identity name
    stdin, stdout, stderr = client.exec_command("{ :local id [/system identity get name]; :put $id}")
    for line in stdout:
        # set identity as the result of the command stripping '\n' (LF = Line Feed) and '\r' (CR = Carriage Return) 
        identity = (line.strip('\n')).strip('\r')
    return identity
    #except paramiko.ssh_exception.AuthenticationException:
    #    print("Authentication error")
    #    return None
    #except paramiko.ssh_exception.SSHException:
    #    print("Connection error")
    #    return None
    #except paramiko.ssh_exception.NoValidConnectionsError:
    #    print("Connection error")
    #    return None
    #except:
    #    print("Error obtaining identity from mikrotik device")
    #    return None


def backup_create (host, port, username, password, backup_filename):
    """create export file (<backup_filename>.rsc) and backup file (<backup_filename>.backup) in a mikrotik routeros device

    :param host: mikrotik IP or hostname
    :param port: mikrotik ssh connectin port
    :param username: mikrotik username
    :param password: mikrotik password
    :param backup_filename: filename for the backup files
    """
    # ssh connection to device 
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        client.connect(host,port=port, username=username, password=password)

        # execute in mikrotik: export mikrotik configuration to a file named <identity>-<date>-<time>.rsc
        stdin, stdout, stderr = client.exec_command("/export file=" + backup_filename)
        
        # controlar que haya finalizado el export
        exit_status = stdout.channel.recv_exit_status()
        if exit_status == 0:
            print ("Succesfully exported configuration in Mikrotik device")
        else:
            print("Error exporting configuration in Mikrotik device: ", exit_status)
        
        # execute in mikrotik: save backup configuration to a file named <identity>-<date>-<time>.backup
        stdin, stdout, stderr = client.exec_command("/system backup save")

        # waiting for command to finish
        exit_status = stdout.channel.recv_exit_status()
        if exit_status == 0:
            print ("Succesfully configuration backup in Mikrotik device")
        else:
            print("Error creating configuration backup in Mikrotik device: ", exit_status)
        
            client.close()

    except paramiko.ssh_exception.AuthenticationException:
        print("Authentication error")
    except paramiko.ssh_exception.SSHException:
        print("Connection error")
    except paramiko.ssh_exception.NoValidConnectionsError:
        print("Connection error")
    except:
        print("Error while exporting or creating configuration backup in Mikrotik device")


#### ARGUMENTS

# Initiate the parser
parser = argparse.ArgumentParser()

# Add long and short argument
parser.add_argument("--ip", "-i", help="device ip or hostname")
parser.add_argument("--port", "-p", help="device port")
parser.add_argument("--username", "-u", help="device user")
parser.add_argument("--password", "-pw", help="device password")

# Read arguments from the command line
args = parser.parse_args()

#### VARIABLES

if args.ip:
    ip = args.ip
else:
    print ("No host defined")
    exit()

if args.port:
    port = args.port
else:
    print ("No port defined")
    exit()

if args.username:
    username = args.username
else:
    print ("No username defined")
    exit()

if args.password:
    password = args.password
else:
    print ("No password defined")
    exit()



#### MAIN PROGRAM

# print connection details
print ("------------------")
print ("ip:", ip)
print ("port:", port)
print ("username:", username)
print ("password:", password)
print ("------------------")

# get identity name from Mikrotik device
identity = identity_get (ip, port, username, password)
if (identity == None):
    exit()

# generate base filename = <identity>-<date>-<time>
backup_filename = identity+ "-" + (datetime.datetime.now()).strftime("%Y%m%d-%H%M")

# create configuration backup files in Mikrotik device 
backup_create(ip, port, username, password, backup_filename)

# create local directory path = ./<identity>
path = "./" + identity
directory_create (path)

# download .rsc file to local directory
remoteFilePath = backup_filename + ".rsc"
localFilePath = path + "/" + backup_filename + ".rsc"
file_get(ip, port, username, password, remoteFilePath, localFilePath)

# download .backup file to local directory
remoteFilePath = backup_filename + ".backup"
localFilePath = path + "/" + backup_filename + ".backup"
file_get(ip, port, username, password, remoteFilePath, localFilePath)