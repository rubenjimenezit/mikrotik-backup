#!/usr/bin/python3

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

import argparse, datetime, time, os, sys
from scp import SCPClient

try:
    import paramiko
    
except ImportError:
    sys.tracebacklimit=0
    with open("error.log","ab") as e:
        e.write(time.strftime("%Y.%m.%d") + " " + time.strftime("%H:%M:%S") + " \"Paramiko\" module missing! Please visit http://www.paramiko.org/installing.html for more details." + "\r\n")
    e.close()
    raise ImportError("\rPlease install \"paramiko\" module! Visit http://www.paramiko.org/installing.html for more details.\r\n")


#### FUNCTIONS

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
    try:
        client.connect(host,port=port, username=username, password=password,look_for_keys=False)

        # get mikrotik system identity name
        stdin, stdout, stderr = client.exec_command("{ :local id [/system identity get name]; :put $id}")
        for line in stdout:
            # set identity as the result of the command stripping '\n' (LF = Line Feed) and '\r' (CR = Carriage Return) 
            identity = (line.strip('\n')).strip('\r')
        return identity
    except paramiko.ssh_exception.AuthenticationException:
        print("Authentication error")
        raise
    except paramiko.ssh_exception.SSHException:
        print("Connection error")
        raise
    except paramiko.ssh_exception.NoValidConnectionsError:
        print("Connection error")
        raise
    except:
        print("Error downloading file %s to local directory" % remoteFilePath)
        raise


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
        client.connect(host,port=port, username=username, password=password,look_for_keys=False)

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
        raise
    except paramiko.ssh_exception.SSHException:
        print("Connection error")
        raise
    except paramiko.ssh_exception.NoValidConnectionsError:
        print("Connection error")
        raise
    except:
        print("Error while exporting or creating configuration backup in Mikrotik device")
        raise


def directory_create (path):
    """create a new directory

    :param path: path of the directory to be created
    """
    try:
        if not os.path.exists(path):
            os.mkdir(path)
            print ("Directory %s created" % path)
        else:
            print ("Directory %s already exists" % path)
    except OSError:
        print ("Error al crear directorio %s" % path)
        raise


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
    ssh.connect(host,port=port, username=username, password=password,look_for_keys=False)
    with SCPClient(ssh.get_transport()) as scp:
        try:
            scp.get(remoteFilePath,localFilePath)
            print("File downloaded: %s" % localFilePath)
        except:
            print("Error downloading file %s to local directory" % remoteFilePath)
            raise


def file_exists (host, port, username, password, file):
    """check if a file or directory exists in a Mikrotik device

    :param host: mikrotik IP or hostname
    :param port: mikrotik ssh connectin port
    :param username: mikrotik username
    :param password: mikrotik password
    :param remoteFilePath: file path to be downloaded
    :param localFilePath: destination local directory to save the downloaded file
    """
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh.connect(host,port=port, username=username, password=password,look_for_keys=False)

        # execute in mikrotik: export mikrotik configuration to a file named <identity>-<date>-<time>.rsc
        stdin, stdout, stderr = ssh.exec_command(":if ([:len [/file find name=" + file + "]] > 0) do={ :put \"FOUND IT\" }")
        
        file_found = ""
        for line in stdout:
            # set identity as the result of the command stripping '\n' (LF = Line Feed) and '\r' (CR = Carriage Return) 
            file_found = (line.strip('\n')).strip('\r')

        # wait for command to finish
        exit_status = stdout.channel.recv_exit_status()
        if exit_status != 0:
            print("Could not look for file in Mikrotik device")
        
        ssh.close()

        if (file_found == "FOUND IT"):
            return True
        else:
            return False
        
    except:
        raise



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
print ("-------------------------")
print ("ip:", ip)
print ("port:", port)
print ("username:", username)
print ("password:", password)
print ("")

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
if file_exists(ip, port, username, password,"flash"):
    remoteFilePath = "flash/" + backup_filename + ".backup"
else:
    remoteFilePath = backup_filename + ".backup"
localFilePath = path + "/" + backup_filename + ".backup"
file_get(ip, port, username, password, remoteFilePath, localFilePath)

print ("-------------------------")