#!/usr/bin/env python

from netmiko import ConnectHandler

mkt = {
    'device_type': 'mikrotik_routeros',
    'host': '192.168.137.2',
    'username': 'admin',
    'password': '',
}


net_connect = ConnectHandler(**mkt)
net_connect.find_prompt()
output = net_connect.send_command('/export')
print(output)
