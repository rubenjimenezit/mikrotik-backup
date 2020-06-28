#Telnet RouterOs & Run Command v0.1
import telnetlib,time
#config_user_password_port_etc.
HOST='192.168.137.163'
PORT='23'
user= 'admin'
password= ''
command_1='ip address print'
command_3='quit'

tn=telnetlib.Telnet(HOST,PORT)
tn = telnetlib.Telnet(HOST)
#input user
tn.read_until(b"Login: ")
tn.write(user.encode('UTF-8') + b"\n")
#input password
tn.read_until(b"Password: ")
tn.write(password.encode('UTF-8') + b"\n")

tn.read_until(b'>')
tn.write(command_1.encode('UTF-8')+b"\r\n")
time.sleep(3)
tn.read_until(b'>')
tn.write(command_3.encode('UTF-8')+b"\r\n")

print(tn.read_all())
tn.close()