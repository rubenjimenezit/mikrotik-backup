# jun/28/2020 14:55:07 by RouterOS 6.47
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/user group
set full policy="local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,pas\
    sword,web,sniff,sensitive,api,romon,dude,tikapp"
/ip address
add address=192.168.137.2/24 interface=ether1 network=192.168.137.0
/ip dns
set servers=8.8.8.8
/ip route
add distance=1 gateway=192.168.137.1
/system clock
set time-zone-name=Europe/Madrid
/system identity
set name=test-mkt
/system ntp client
set enabled=yes primary-ntp=216.239.35.4
