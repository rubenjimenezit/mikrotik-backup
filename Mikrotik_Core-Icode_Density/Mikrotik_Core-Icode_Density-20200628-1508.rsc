# jun/28/2020 15:08:47 by RouterOS 6.45.5
# software id = EAW9-ET15
#
# model = 1100
# serial number = 2C69016BD0CA
/caps-man channel
add band=2ghz-g/n control-channel-width=20mhz extension-channel=disabled \
    frequency=2412,2462,2437 name="2.4 GHz Channels" reselect-interval=4h \
    tx-power=17
add band=5ghz-a/n control-channel-width=20mhz extension-channel=disabled \
    frequency=5180,5200,5220,5240 name="5GHz Channels" save-selected=no \
    skip-dfs-channels=yes
/caps-man datapath
add local-forwarding=yes name=Vlan11_Staff vlan-id=11 vlan-mode=use-tag
add local-forwarding=no name=NoVlan_BridgeLAN
add local-forwarding=yes name=Vlan12_Guests vlan-id=12 vlan-mode=use-tag
/caps-man configuration
add channel="5GHz Channels" country=no_country_set datapath=Vlan12_Guests \
    distance=indoors mode=ap name=cfgGuests_5GHz ssid=Invitados
/interface bridge
add dhcp-snooping=yes fast-forward=no igmp-snooping=yes name=bridgeLAN
/interface ethernet
set [ find default-name=ether1 ] name="ether1-WAN Movistar" speed=100Mbps
set [ find default-name=ether2 ] speed=100Mbps
set [ find default-name=ether3 ] speed=100Mbps
set [ find default-name=ether4 ] name=ether4-srv-09-hiperv speed=100Mbps
set [ find default-name=ether5 ] name=ether5-Laboratorio speed=100Mbps
set [ find default-name=ether6 ] name="ether6-Mesas Administracion" speed=\
    100Mbps
set [ find default-name=ether7 ] name="ether7-Sala Reuniones" speed=100Mbps
set [ find default-name=ether8 ] name=ether8-TV1 speed=100Mbps
set [ find default-name=ether9 ] name=ether9-TV2 speed=100Mbps
set [ find default-name=ether10 ] name=ether10-AP_Unifi speed=100Mbps
set [ find default-name=ether11 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full name=\
    ether11-AP_Cambium
set [ find default-name=ether12 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full name=\
    ether12-AP_Arista
set [ find default-name=ether13 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full
/interface pppoe-client
add add-default-route=yes default-route-distance=2 disabled=no interface=\
    "ether1-WAN Movistar" keepalive-timeout=60 name=pppoe-WAN password=\
    adslppp user="adslppp@telefonicanetpa "
/interface vlan
add interface=bridgeLAN name=vlan11-Invitados vlan-id=11
add interface=bridgeLAN name=vlan12-Bemywifi vlan-id=12
/caps-man rates
add basic=12Mbps name="12Mbps min - No B Rates" supported=\
    12Mbps,18Mbps,24Mbps,36Mbps,48Mbps,54Mbps
/caps-man security
add name=securityOpen
add authentication-types=wpa2-psk encryption=aes-ccm name=securityClientes \
    passphrase=clientes
add authentication-types=wpa2-psk encryption=aes-ccm name=securityStaff \
    passphrase=staff123
/caps-man configuration
add channel="2.4 GHz Channels" country=spain distance=indoors mode=ap name=\
    cfgGuests_2,4GHz rates="12Mbps min - No B Rates" security=securityOpen \
    ssid=Invitados
add channel="5GHz Channels" country=no_country_set datapath=Vlan11_Staff \
    mode=ap name=cfgStaff_5GHz rates="12Mbps min - No B Rates" security=\
    securityStaff ssid=Staff
add channel="2.4 GHz Channels" country=no_country_set datapath=Vlan11_Staff \
    distance=indoors mode=ap name=cfgStaff_2,4GHz rates=\
    "12Mbps min - No B Rates" security=securityStaff ssid=Staff
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot
add disabled=no idle-timeout=none interface=vlan11-Invitados name=\
    serverBemywifi
/ip hotspot profile
add dns-name=icode.bemywifi hotspot-address=10.12.0.1 html-directory=\
    hotspot_redir login-by=cookie,http-pap name=hsprofBemywifi use-radius=yes
/ip hotspot user profile
set [ find default=yes ] shared-users=100
/ip ipsec profile
set [ find default=yes ] enc-algorithm=aes-256,aes-128,3des nat-traversal=no
add dh-group=modp1536 name=Prof_Tu-Icode-Arica
add dh-group=modp2048,modp1536 enc-algorithm=aes-256 hash-algorithm=sha256 \
    name=Prof_Tu-Icode-HMA
add dh-group=modp1536 enc-algorithm=aes-192,3des,des name=Prof_Tu-Icode-RyA
add dh-group=modp2048,modp1536 enc-algorithm=aes-256,aes-128 name=profile_4
add dh-group=modp1024 enc-algorithm=aes-256,aes-192,aes-128 name=\
    Prof_Tu-Icode-MdS nat-traversal=no
add dh-group=modp2048 enc-algorithm=aes-256,aes-192,aes-128,3des name=\
    Prof_Tu-Icode-Acens
add dh-group=modp2048 enc-algorithm=aes-128 name=Prof_Tu-Sanse-Atocha
add dh-group=modp1024 enc-algorithm=aes-256,aes-192,aes-128,3des lifebytes=\
    102400 name=Prof_Tu-Icode-Codere
add dh-group=modp1536 dpd-interval=disable-dpd enc-algorithm=aes-128 \
    hash-algorithm=sha256 name=Prof_Ph1_Tu-Icode-Ruben
add name=default-backup
/ip ipsec peer
add address=200.111.169.218/32 comment=Tu-Icode-MdS name=Tu-Icode-MdS \
    profile=Prof_Tu-Icode-MdS
add address=200.54.51.18/32 comment=Tu-Icode-Arica name=Tu-Icode-Arica \
    profile=Prof_Tu-Icode-Arica
add address=194.224.59.233/32 comment=Tu-Icode-HMA name=Tu-Icode-HMA profile=\
    Prof_Tu-Icode-HMA
add address=186.72.2.2/32 comment=Tu-Icode-Codere name=Tu-Icode-Codere \
    profile=Prof_Tu-Icode-Codere
add address=89.140.86.2/32 comment=Tu-Sanse-Atocha disabled=yes name=\
    Tu-Icode-Atocha profile=Prof_Tu-Sanse-Atocha
add address=88.26.202.191/32 comment=Tu-Icode-RyABCN418 disabled=yes name=\
    Tu-Icode-RyABCN418 profile=Prof_Tu-Icode-RyA
add address=88.6.153.189/32 comment=Tu-Icode-Ruben disabled=yes name=\
    Peer_Tu-Icode-Ruben profile=Prof_Ph1_Tu-Icode-Ruben
add address=81.46.222.174/32 comment=Tu-Icode-Molle-Acens name=Tu-Icode-Acens \
    profile=Prof_Tu-Icode-Acens
add address=77.226.208.28/32 comment=Tu-Icode-ISP name=Tu-Icode-ISP profile=\
    profile_4
/ip ipsec proposal
set [ find default=yes ] enc-algorithms=\
    aes-256-cbc,aes-192-cbc,aes-128-cbc,3des,des lifetime=0s pfs-group=none
add enc-algorithms=aes-128-cbc,3des lifetime=0s name=Prop_Tu-Icode-Arica \
    pfs-group=modp1536
add auth-algorithms=sha256 enc-algorithms=aes-256-cbc name=Prop_Tu-Icode-HMA \
    pfs-group=modp1536
add disabled=yes enc-algorithms=aes-256-cbc,aes-192-cbc,aes-128-cbc,3des,des \
    name=Prop_Tu-Icode-RyA pfs-group=modp1536
add enc-algorithms=aes-256-cbc name=Prop_Tu-Icode-ISP pfs-group=modp1536
add name=Prop_Tu-Icode-MdS pfs-group=none
add disabled=yes enc-algorithms=aes-192-cbc,3des name=Prop_Tu-Icode-RyA_Mad \
    pfs-group=modp1536
add enc-algorithms=aes-256-cbc,aes-192-cbc,aes-128-cbc,3des,des name=\
    Prop_Tu-Icode-Acens pfs-group=none
add enc-algorithms=aes-128-cbc,aes-128-ctr,aes-128-gcm lifetime=0s name=\
    Prop_Tu-Icode-Atocha pfs-group=none
add enc-algorithms=aes-128-cbc,aes-128-ctr,aes-128-gcm lifetime=0s name=\
    Prop_Tu-Icode-Codere
add auth-algorithms=sha256,sha1 disabled=yes enc-algorithms=aes-128-cbc,3des \
    name=Prop_Ph2_Tu-Icode-Ruben pfs-group=modp2048
/ip pool
add name=poolL2TP ranges=10.35.0.10-10.35.0.254
add name=poolLAN ranges=192.168.50.100-192.168.50.200
add name=poolInvitados ranges=10.11.0.10-10.11.254.254
add name=poolBemywifi ranges=10.12.0.10-10.12.254.254
/ip dhcp-server
add address-pool=poolLAN authoritative=after-2sec-delay disabled=no \
    interface=bridgeLAN lease-time=12h name=serverLAN
add address-pool=poolInvitados authoritative=after-2sec-delay disabled=no \
    interface=vlan11-Invitados lease-time=2h name=serverInvitados
add address-pool=poolBemywifi disabled=no interface=vlan12-Bemywifi name=\
    serverBemywifi
/ppp profile
add dns-server=8.8.8.8 local-address=10.35.0.1 name=L2TP_estatico rate-limit=\
    4M/4M
add dns-server=10.35.0.1,8.8.8.8 local-address=10.35.0.1 name=L2TP_dinamico \
    rate-limit=5M/10M remote-address=poolL2TP
add name=profile1
set *FFFFFFFE change-tcp-mss=default
/queue tree
add comment=GLOBAL limit-at=2500M max-limit=2500M name=Download parent=global \
    priority=1
/queue type
add kind=sfq name=BAJADA
add kind=sfq name=SUBIDA
/queue tree
add comment="IPSec, L2TP" limit-at=1500M max-limit=1500M name=\
    "1.Conectividad VPN" packet-mark="PRIO 1" parent=Download priority=1 \
    queue=BAJADA
add comment="SNMP, Ping" limit-at=3G max-limit=3G name="2.Monitorizaci\F3n" \
    packet-mark="PRIO 2" parent=Download priority=2 queue=BAJADA
add comment="Winbox, RDP" limit-at=1G max-limit=1G name=3.Accesos \
    packet-mark="PRIO 3" parent=Download priority=3 queue=BAJADA
add comment="HTTP, HTTPS" limit-at=1G max-limit=1G name="5.Navegaci\F3n" \
    packet-mark="PRIO 5" parent=Download priority=5 queue=BAJADA
add comment="DNS, DHCP, NTP" limit-at=300M max-limit=300M name=\
    "4.Sincronizaci\F3n" packet-mark="PRIO 4" parent=Download priority=4 \
    queue=BAJADA
add comment=Otros limit-at=1G max-limit=1G name=6.Otros packet-mark="PRIO 6" \
    parent=Download priority=6 queue=BAJADA
/snmp community
set [ find default=yes ] addresses=0.0.0.0/0
add addresses=0.0.0.0/0 name=icodesnmp write-access=yes
/system logging action
set 0 memory-lines=10000
/caps-man manager
set enabled=yes
/caps-man manager interface
set [ find default=yes ] forbid=yes
add disabled=no interface=bridgeLAN
/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=\
    cfgStaff_2,4GHz name-format=prefix-identity name-prefix="2,4GHz - "
add action=create-dynamic-enabled hw-supported-modes=an master-configuration=\
    cfgStaff_5GHz name-format=prefix-identity name-prefix="5 GHz - "
/interface bridge port
add bridge=bridgeLAN hw=no interface=ether2
add bridge=bridgeLAN hw=no interface=ether3
add bridge=bridgeLAN hw=no interface=ether4-srv-09-hiperv
add bridge=bridgeLAN hw=no interface=ether5-Laboratorio
add bridge=bridgeLAN hw=no interface="ether6-Mesas Administracion"
add bridge=bridgeLAN hw=no interface="ether7-Sala Reuniones"
add bridge=bridgeLAN hw=no interface=ether8-TV1
add bridge=bridgeLAN hw=no interface=ether9-TV2
add bridge=bridgeLAN hw=no interface=ether10-AP_Unifi
add bridge=bridgeLAN hw=no interface=ether11-AP_Cambium
add bridge=bridgeLAN hw=no interface=ether12-AP_Arista
add bridge=bridgeLAN hw=no interface=ether13
/ip neighbor discovery-settings
set discover-interface-list=all
/interface l2tp-server server
set allow-fast-path=yes enabled=yes ipsec-secret=%Wo2JGJp8Qtx!! \
    keepalive-timeout=300 use-ipsec=yes
/ip address
add address=192.168.50.1/24 interface=bridgeLAN network=192.168.50.0
add address=192.168.100.99/24 disabled=yes interface="ether1-WAN Movistar" \
    network=192.168.100.0
add address=10.11.0.1/16 interface=vlan11-Invitados network=10.11.0.0
add address=10.12.0.1/16 interface=vlan12-Bemywifi network=10.12.0.0
add address=192.168.1.1/24 disabled=yes interface=bridgeLAN network=\
    192.168.1.0
add address=192.168.1.213/24 interface=bridgeLAN network=192.168.1.0
/ip dhcp-server lease
add address=192.168.50.54 mac-address=00:15:5D:0A:63:08 server=serverLAN
add address=192.168.50.49 client-id=1:b4:6b:fc:3f:cc:3f mac-address=\
    B4:6B:FC:3F:CC:3F server=serverLAN
add address=192.168.50.81 client-id=1:0:15:5d:a:63:1f comment=\
    "PC-SW-01 Virtual" mac-address=00:15:5D:0A:63:1F server=serverLAN
add address=192.168.50.82 client-id=1:0:15:5d:a:63:20 comment=\
    "PC-SW-02 Virtual" mac-address=00:15:5D:0A:63:20 server=serverLAN
add address=192.168.50.115 client-id=1:1c:4d:70:c:6d:13 comment="PC Eloy" \
    mac-address=1C:4D:70:0C:6D:13 server=serverLAN
add address=192.168.50.83 client-id=1:0:15:5d:a:63:21 comment=\
    "win10-test para Totem" mac-address=00:15:5D:0A:63:21 server=serverLAN
/ip dhcp-server network
add address=10.11.0.0/16 dns-server=10.11.0.1,8.8.8.8 gateway=10.11.0.1
add address=10.12.0.0/16 dns-server=10.12.0.1 gateway=10.12.0.1
add address=192.168.50.0/24 dns-server=192.168.50.1,8.8.8.8 gateway=\
    192.168.50.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip firewall address-list
add address=10.35.0.1-10.35.0.254 list=WhiteList
add address=192.168.50.99 list=WhiteList
add address=0.0.0.0/8 list=BlackList
add address=100.64.0.0/10 list=BlackList
add address=127.0.0.0/8 list=BlackList
add address=169.254.0.0/16 list=BlackList
add address=192.0.0.0/24 list=BlackList
add address=192.0.2.0/24 list=BlackList
add address=192.88.99.0/24 list=BlackList
add address=198.18.0.0/15 list=BlackList
add address=198.51.100.0/24 list=BlackList
add address=203.0.113.0/24 list=BlackList
add address=224.0.0.0/4 list=BlackList
add address=240.0.0.0/4 list=BlackList
add address=194.224.59.233 list=L2TP_Allowed
add address=80.30.198.86 list=L2TP_Allowed
add address=217.197.18.15 list=L2TP_Allowed
add address=213.0.69.153 list=L2TP_Allowed
add address=200.54.51.18 list=L2TP_Allowed
add address=81.35.64.59 list=L2TP_Allowed
add address=83.61.148.150 list=L2TP_Allowed
add address=92.185.237.190 list=L2TP_Allowed
add address=213.97.78.33 list=L2TP_Allowed
add address=83.42.128.14 list=L2TP_Allowed
add address=79.157.42.38 list=L2TP_Allowed
add address=79.146.147.40 list=L2TP_Allowed
add address=2.139.225.136 list=L2TP_Allowed
add address=80.28.246.92 list=L2TP_Allowed
add address=88.12.4.35 list=L2TP_Allowed
add address=200.111.169.218 list=L2TP_Allowed
add address=80.24.20.102 list=L2TP_Allowed
add address=88.26.202.191 list=L2TP_Allowed
add address=79.154.203.2 list=L2TP_Allowed
add address=80.25.227.128 list=L2TP_Allowed
add address=79.157.42.147 list=L2TP_Allowed
add address=201.229.156.148 list=L2TP_Allowed
add address=200.88.117.170 list=L2TP_Allowed
add address=79.159.51.92 list=L2TP_Allowed
add address=83.48.100.125 list=L2TP_Allowed
add address=88.27.252.97 list=L2TP_Allowed
add address=190.5.234.50 list=L2TP_Allowed
add address=88.0.37.109 list=L2TP_Allowed
add address=37.10.159.249 list=L2TP_Allowed
add address=77.226.208.28 list=L2TP_Allowed
add address=10.1.222.0/23 comment=Codere-ElPanama list=Codere
add address=10.1.232.0/23 comment="Codere - Guayacanes" list=Codere
add address=10.1.210.0/23 comment="Codere - Continental" list=Codere
add address=10.1.224.0/23 comment=Codere-Soloy list=Codere
add address=10.1.214.0/23 comment="Codere - Riande" list=Codere
add address=10.1.218.0/23 comment="Codere - Casino Hipodromo" list=Codere
add address=10.1.226.0/23 comment="Codere - Nacional" list=Codere
add address=10.1.216.0/23 comment="Codere Mirage" list=Codere
add address=10.35.0.0/16 list=Icode
add address=192.168.50.0/24 list=Icode
add address=10.1.240.0/23 comment="Codere - Aloft" list=Codere
add address=10.1.220.0/23 comment="Codere - Hipodromo" list=Codere
add address=10.1.234.0/23 comment="Codere - Radisson" list=Codere
add address=10.1.213.0/24 comment="Codere - Sheraton" list=Codere
add address=10.1.82.240 list=Codere
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=input comment="Accept ICMP" protocol=icmp
add action=accept chain=input comment="Log From ACENS IP 81.46.222.174" \
    log-prefix=input_ACENS_ipsec_ src-address=81.46.222.174
add action=drop chain=input comment="Drop Everything from BlackList" \
    src-address-list=BlackList
add action=drop chain=input comment="Drop Winbox Brute Forcers" dst-port=\
    8100,8291-8299 protocol=tcp src-address-list=winbox_blacklist
add action=add-src-to-address-list address-list=winbox_blacklist \
    address-list-timeout=2h chain=input connection-state=new dst-port=\
    8100,8291-8299 protocol=tcp src-address-list=winbox_stage3
add action=add-src-to-address-list address-list=winbox_stage3 \
    address-list-timeout=1m chain=input connection-state=new dst-port=\
    8100,8291-8299 protocol=tcp src-address-list=winbox_stage2
add action=add-src-to-address-list address-list=winbox_stage2 \
    address-list-timeout=1m chain=input connection-state=new dst-port=\
    8100,8291-8299 protocol=tcp src-address-list=winbox_stage1
add action=add-src-to-address-list address-list=winbox_stage1 \
    address-list-timeout=1m chain=input connection-state=new dst-port=\
    8100,8291-8299 protocol=tcp
add action=accept chain=input comment=DNAT connection-nat-state=dstnat
add action=accept chain=input comment=\
    "Conexiones Establecidas / Relacionadas" connection-state=\
    established,related
add action=accept chain=input comment="Accept SNMP" dst-port=161 protocol=udp
add action=accept chain=input comment="RouterOS Neighbour" dst-port=5678 \
    protocol=udp
add action=accept chain=input comment="Accept Winbox" dst-port=8291-8299 \
    protocol=tcp
add action=accept chain=input comment="Accept SSH" dst-port=22 protocol=tcp
add action=accept chain=input comment="Accept L2TP/IPSEC" dst-port=\
    500,1701,4500 protocol=udp
add action=accept chain=input protocol=ipsec-esp
add action=accept chain=input protocol=ipsec-ah
add action=accept chain=input comment="Accept NTP" dst-port=123 protocol=udp
add action=drop chain=input comment="Drop everything else"
add action=accept chain=forward comment=\
    "Conexiones Relacionadas / Establecidas" connection-state=\
    established,related
add action=accept chain=forward comment="Forward Accept from L2TP" \
    src-address=10.35.0.0/16
add action=accept chain=forward comment="Forward Accept from LAN" \
    in-interface=bridgeLAN
add action=accept chain=forward comment="Forward Accept DNAT" \
    connection-nat-state=dstnat log-prefix=fw_dnat
add action=drop chain=forward comment="Drop everything else" \
    connection-state="" log=yes log-prefix="DROPPED - "
/ip firewall mangle
add action=mark-routing chain=prerouting disabled=yes dst-address=10.20.0.106 \
    new-routing-mark=intranet passthrough=yes src-address=192.168.50.0/24
add action=mark-packet chain=prerouting comment=\
    "MARCO PRIO 1 - Conectividad VPN ( IPSec, L2TP )" connection-mark=\
    "PRIO 1" connection-state="" new-packet-mark="PRIO 1" passthrough=no
add action=mark-connection chain=prerouting connection-state=new \
    new-connection-mark="PRIO 1" passthrough=yes protocol=gre
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    500,1701,4500 new-connection-mark="PRIO 1" passthrough=yes protocol=udp
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    1723 new-connection-mark="PRIO 1" passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting connection-state=new \
    new-connection-mark="PRIO 1" passthrough=yes protocol=ipsec-ah
add action=mark-connection chain=prerouting connection-state=new \
    new-connection-mark="PRIO 1" passthrough=yes protocol=ipsec-esp
add action=jump chain=prerouting jump-target="TERMINO DE PROCESAR" \
    packet-mark="PRIO 1"
add action=mark-packet chain=prerouting comment=\
    "MARCO PRIO 2  - Monitoring ( SNMP, Ping )" connection-mark="PRIO 2" \
    connection-state="" new-packet-mark="PRIO 2" passthrough=no
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    161,162 new-connection-mark="PRIO 2" passthrough=yes protocol=udp
add action=mark-connection chain=prerouting connection-state=new \
    new-connection-mark="PRIO 2" passthrough=yes protocol=icmp
add action=jump chain=prerouting jump-target="TERMINO DE PROCESAR" \
    packet-mark="PRIO 2"
add action=mark-packet chain=prerouting comment=\
    "MARCO PRIO 3 - Accesos ( Winbox, RDP, Special WebAccess)" \
    connection-mark="PRIO 3" connection-state="" new-packet-mark="PRIO 3" \
    passthrough=no
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    8291-8299,8888,8443,18443 new-connection-mark="PRIO 3" passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    3389,13389 new-connection-mark="PRIO 3" passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    3389,13389 new-connection-mark="PRIO 3" passthrough=yes protocol=udp
add action=jump chain=prerouting jump-target="TERMINO DE PROCESAR" \
    packet-mark="PRIO 3"
add action=mark-packet chain=prerouting comment=\
    "MARCO PRIO 4 - Sincronizaci\F3n ( DNS, NTP, DHCP )" connection-mark=\
    "PRIO 4" connection-state="" new-packet-mark="PRIO 4" passthrough=no
add action=mark-connection chain=prerouting connection-state=new \
    new-connection-mark="PRIO 4" passthrough=yes protocol=icmp
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    67,68 new-connection-mark="PRIO 4" passthrough=yes protocol=udp
add action=mark-connection chain=output connection-state=new dst-port=67,68 \
    new-connection-mark="PRIO 4" passthrough=yes protocol=udp
add action=mark-connection chain=prerouting connection-state=new dst-port=53 \
    new-connection-mark="PRIO 4" passthrough=yes protocol=udp
add action=mark-connection chain=output connection-state=new dst-port=53 \
    new-connection-mark="PRIO 4" passthrough=yes protocol=udp
add action=mark-connection chain=prerouting connection-state=new dst-port=123 \
    new-connection-mark="PRIO 4" passthrough=yes protocol=udp
add action=jump chain=prerouting jump-target="TERMINO DE PROCESAR" \
    packet-mark="PRIO 4"
add action=mark-packet chain=prerouting comment=\
    "MARCO PRIO 5 - Navegacion ( HTTP, HTTPS )" connection-mark="PRIO 5" \
    connection-state="" new-packet-mark="PRIO 5" passthrough=no
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    80,443,8080 new-connection-mark="PRIO 5" passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting connection-state=new dst-port=\
    80,443,8080 new-connection-mark="PRIO 5" passthrough=yes protocol=udp
add action=jump chain=prerouting jump-target="TERMINO DE PROCESAR" \
    packet-mark="PRIO 5"
add action=mark-packet chain=prerouting comment="MARCO PRIO 6 - Otros" \
    connection-mark="PRIO 6" connection-state="" new-packet-mark="PRIO 6" \
    passthrough=no
add action=mark-connection chain=prerouting connection-state=new \
    new-connection-mark="PRIO 6" passthrough=yes
add action=accept chain="TERMINO DE PROCESAR" comment="TERMINO DE PROCESAR"
add action=accept chain=prerouting
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=dst-nat chain=dstnat comment="PC-SW-01 virtual RDP" dst-port=35101 \
    in-interface=pppoe-WAN log-prefix=PC-SW-02 protocol=tcp to-addresses=\
    192.168.50.81 to-ports=3389
add action=dst-nat chain=dstnat comment="Soft Totem Chino - RDP" dst-port=\
    9001 in-interface=pppoe-WAN protocol=tcp to-addresses=192.168.50.83 \
    to-ports=3389
add action=dst-nat chain=dstnat comment="Soft Totem Chino - 3307/tcp" \
    dst-port=7788 in-interface=pppoe-WAN protocol=tcp to-addresses=\
    192.168.50.83 to-ports=7788
add action=dst-nat chain=dstnat comment="Soft Totem Chino - 7788/tcp" \
    dst-port=3307 in-interface=pppoe-WAN protocol=tcp to-addresses=\
    192.168.50.83 to-ports=3307
add action=dst-nat chain=dstnat comment="Soft Totem Chino" dst-port=9000 \
    in-interface=pppoe-WAN protocol=tcp to-addresses=192.168.50.83 to-ports=\
    9000
add action=dst-nat chain=dstnat comment="PC-SW-01 virtual SQL" dst-port=35201 \
    in-interface=pppoe-WAN log-prefix=PC-SW-02 protocol=tcp to-addresses=\
    192.168.50.81 to-ports=1433
add action=dst-nat chain=dstnat comment=Subversion dst-port=35301 \
    in-interface=pppoe-WAN log-prefix=PC-SW-02 protocol=tcp to-addresses=\
    192.168.50.117 to-ports=443
add action=dst-nat chain=dstnat comment="PC Eloy Plex" dst-port=32400 \
    in-interface=pppoe-WAN log-prefix="PC Eloy Plex" protocol=tcp \
    to-addresses=192.168.50.115 to-ports=32400
add action=dst-nat chain=dstnat comment="Zabbix web dnat" dst-port=8888 \
    in-interface=pppoe-WAN log-prefix=zabbix protocol=tcp to-addresses=\
    192.168.50.54 to-ports=80
add action=dst-nat chain=dstnat comment="Zabbix web dnat" dst-port=8888 \
    in-interface=bridgeLAN log-prefix=zabbix protocol=tcp to-addresses=\
    192.168.50.54 to-ports=80
add action=dst-nat chain=dstnat comment="Zabbix ssh dnat" dst-port=8822 \
    in-interface=pppoe-WAN log-prefix=zabbix protocol=tcp to-addresses=\
    192.168.50.54 to-ports=22
add action=dst-nat chain=dstnat comment="Zabbix ssh dnat" dst-port=8822 \
    in-interface=bridgeLAN log-prefix=zabbix protocol=tcp to-addresses=\
    192.168.50.54 to-ports=22
add action=dst-nat chain=dstnat comment="Microserver-Ashay FTP dnat" \
    dst-port=20,21 in-interface=pppoe-WAN log-prefix=microserverahsay \
    protocol=tcp to-addresses=192.168.50.253
add action=dst-nat chain=dstnat comment="Ashay dnat" dst-port=4443 \
    in-interface=pppoe-WAN log-prefix=microserverahsay protocol=tcp \
    to-addresses=192.168.50.253 to-ports=443
add action=dst-nat chain=dstnat comment="Ashay dnat" dst-port=4443 \
    in-interface=bridgeLAN log-prefix=microserverahsay protocol=tcp \
    to-addresses=192.168.50.253 to-ports=443
add action=dst-nat chain=dstnat comment="Wiki Icode dnat" dst-port=8204 \
    in-interface=pppoe-WAN log-prefix=wiki protocol=tcp to-addresses=\
    192.168.50.111 to-ports=80
add action=dst-nat chain=dstnat comment="Microserver ftp dnat passive ports" \
    dst-port=33000-33100 in-interface=pppoe-WAN log-prefix=microserverahsay \
    protocol=tcp to-addresses=192.168.50.253
add action=accept chain=srcnat comment="Static IPSec NATs - Novomatic Franco" \
    dst-address=192.168.50.0/24 log-prefix=asd src-address=192.168.1.0/24
add action=accept chain=srcnat comment="Static IPSec NATs - Novomatic Franco" \
    dst-address=192.168.1.0/24 log-prefix=asd src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPSec NATs - Chillan" \
    dst-address=172.28.13.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NATs - Arica Chile" \
    dst-address=172.19.0.0/24
add action=accept chain=srcnat comment="Static IPsec NATs - Arica Chile" \
    dst-address=172.19.1.0/24
add action=accept chain=srcnat comment="Static IPsec NATs - Arica Chile" \
    dst-address=172.19.2.64/27
add action=accept chain=srcnat comment="Static IPsec NATs - ISP" dst-address=\
    192.168.5.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NAT - HMA.corp" \
    dst-address=192.168.128.0/21 log-prefix=NAT_HMA src-address=\
    192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NAT - Codere" \
    dst-address-list=Codere src-address-list=Icode
add action=accept chain=srcnat comment="Static IPsec NAT - HMA.meru" \
    dst-address=172.16.0.0/21 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NAT - Atocha-Sanse" \
    dst-address=192.168.1.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NATs - Ruben" disabled=\
    yes dst-address=192.168.55.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NATs - RyA BCN418" \
    dst-address=192.168.0.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPsec NATs - RyA Madrid" \
    dst-address=192.168.3.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment=Tu-IcodeBNC-Ruben dst-address=\
    192.168.54.0/24 src-address=192.168.50.0/24
add action=accept chain=srcnat comment="Static IPSec NATs - Osorno" \
    dst-address=172.28.11.0/24 src-address=192.168.50.48/29
add action=accept chain=srcnat comment="Static IPSec NATs - Calama" \
    dst-address=172.28.12.0/24 src-address=192.168.50.48/29
add action=accept chain=srcnat comment="Static IPSec NATs - Acens" \
    dst-address=10.20.0.0/24 log-prefix=ACCENS src-address=192.168.50.0/24
add action=masquerade chain=srcnat comment="Masquerade NAT - Permite a los con\
    ectados por L2TP tener salida a internet a traves de Icode" \
    out-interface=pppoe-WAN src-address=192.168.50.0/24
add action=masquerade chain=srcnat comment="Masquerade NAT - Permite a los con\
    ectados por L2TP tener salida a internet a traves de Icode" \
    out-interface=all-ppp src-address=192.168.50.0/24
add action=masquerade chain=srcnat comment="Masquerade NAT - Permite a los con\
    ectados por L2TP tener salida a internet a traves de Icode" src-address=\
    192.168.50.0/24
add action=masquerade chain=srcnat comment="Masquerade NAT - Permite a los con\
    ectados por L2TP tener salida a internet a traves de Icode" src-address=\
    10.35.0.0/16
/ip firewall service-port
set ftp disabled=yes
set tftp disabled=yes
set irc disabled=yes
set h323 disabled=yes
set sip disabled=yes
set pptp disabled=yes
set udplite disabled=yes
set dccp disabled=yes
set sctp disabled=yes
/ip ipsec identity
add peer=Tu-Icode-Arica remote-id=ignore secret=icodel2tpserver!
add my-id=address:192.168.1.99 peer=Tu-Icode-HMA secret=icodel2tpserver!
add disabled=yes peer=Tu-Icode-RyABCN418 secret=ryal2tpserver!
add peer=Tu-Icode-ISP secret=1h0lf02akbze2eu6
add peer=Tu-Icode-MdS secret=O2FTPXDsXDMkSw
add my-id=address:192.168.1.99 peer=Tu-Icode-Acens secret=icodeacensipsec2
add disabled=yes peer=Tu-Icode-Atocha secret=\
    K9N1n3H4n5G0p01Wqs4d6TTr2QwsD0q882
add peer=Tu-Icode-Codere secret=M1kr0t1k@C0d3r32019Vpn
add comment=Tu-Icode-Ruben disabled=yes peer=Peer_Tu-Icode-Ruben secret=\
    icodel2tpserver!
/ip ipsec policy
set 0 comment="Policy to All  |  L2TP"
add comment=Tu-Icode-Arica.netMikrotik dst-address=172.19.1.0/24 level=unique \
    peer=Tu-Icode-Arica proposal=Prop_Tu-Icode-Arica sa-dst-address=\
    200.54.51.18 sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=\
    yes
add comment=Tu-Icode-Arica.netMeru dst-address=172.19.0.0/24 level=unique \
    peer=Tu-Icode-Arica proposal=Prop_Tu-Icode-Arica sa-dst-address=\
    200.54.51.18 sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=\
    yes
add comment=Tu-Icode-Arica.netMeru dst-address=172.19.2.64/27 level=unique \
    peer=Tu-Icode-Arica proposal=Prop_Tu-Icode-Arica sa-dst-address=\
    200.54.51.18 sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=\
    yes
add comment=Tu-Icode-HMA.corp dst-address=192.168.128.0/21 level=unique peer=\
    Tu-Icode-HMA proposal=Prop_Tu-Icode-HMA sa-dst-address=194.224.59.233 \
    sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-Ruben disabled=yes dst-address=192.168.55.0/24 level=\
    unique peer=Peer_Tu-Icode-Ruben proposal=Prop_Ph2_Tu-Icode-Ruben \
    src-address=192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-HMA.meru dst-address=172.16.0.0/21 level=unique peer=\
    Tu-Icode-HMA proposal=Prop_Tu-Icode-HMA sa-dst-address=194.224.59.233 \
    sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-RyA disabled=yes dst-address=192.168.0.0/24 level=unique \
    peer=Tu-Icode-RyABCN418 proposal=Prop_Tu-Icode-RyA src-address=\
    192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-RyA disabled=yes dst-address=192.168.0.0/24 level=unique \
    peer=Tu-Icode-RyABCN418 proposal=Prop_Tu-Icode-RyA src-address=\
    10.35.0.0/16 tunnel=yes
add comment=Tu-Icode-ISP dst-address=192.168.5.0/24 level=unique peer=\
    Tu-Icode-ISP proposal=Prop_Tu-Icode-ISP sa-dst-address=77.226.208.28 \
    sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-MdS-Osorno dst-address=172.28.11.0/24 level=unique peer=\
    Tu-Icode-MdS proposal=Prop_Tu-Icode-MdS sa-dst-address=200.111.169.218 \
    sa-src-address=0.0.0.0 src-address=10.35.0.0/16 tunnel=yes
add comment=Tu-Icode-MdS-Osorno dst-address=172.28.11.0/24 level=unique peer=\
    Tu-Icode-MdS proposal=Prop_Tu-Icode-MdS sa-dst-address=200.111.169.218 \
    sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-MdS-Calama dst-address=172.28.12.0/24 level=unique peer=\
    Tu-Icode-MdS proposal=Prop_Tu-Icode-MdS sa-dst-address=200.111.169.218 \
    sa-src-address=0.0.0.0 src-address=10.35.0.0/16 tunnel=yes
add comment=Tu-Icode-MdS-Calama dst-address=172.28.12.0/24 level=unique peer=\
    Tu-Icode-MdS proposal=Prop_Tu-Icode-MdS sa-dst-address=200.111.169.218 \
    sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Acens dst-address=10.20.0.0/24 level=unique peer=\
    Tu-Icode-Acens proposal=Prop_Tu-Icode-Acens sa-dst-address=81.46.222.174 \
    sa-src-address=0.0.0.0 src-address=192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-MdS-Chillan dst-address=172.28.13.0/24 level=unique \
    peer=Tu-Icode-MdS proposal=Prop_Tu-Icode-MdS sa-dst-address=\
    200.111.169.218 sa-src-address=0.0.0.0 src-address=10.35.0.0/16 tunnel=\
    yes
add comment=Tu-Icode-MdS-Chillan dst-address=172.28.13.0/24 level=unique \
    peer=Tu-Icode-MdS proposal=Prop_Tu-Icode-MdS sa-dst-address=\
    200.111.169.218 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 \
    tunnel=yes
add comment=Tu-Icode-Atocha disabled=yes dst-address=192.168.1.0/24 level=\
    unique peer=Tu-Icode-Atocha proposal=Prop_Tu-Icode-Atocha src-address=\
    192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-Atocha disabled=yes dst-address=10.10.0.0/24 level=\
    unique peer=Tu-Icode-Atocha proposal=Prop_Tu-Icode-Atocha src-address=\
    192.168.50.0/24 tunnel=yes
add comment=Tu-Icode-Codere_ElPanama dst-address=10.1.222.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_ElPanama dst-address=10.1.222.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Guayacanes dst-address=10.1.232.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Guayacanes dst-address=10.1.232.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Continental dst-address=10.1.210.0/23 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Continental dst-address=10.1.210.0/23 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Soloy dst-address=10.1.224.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Meru-Contorller dst-address=10.1.82.240/32 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Meru-Contorller dst-address=10.1.82.240/32 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Soloy dst-address=10.1.224.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Riande dst-address=10.1.214.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Riande dst-address=10.1.214.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_CasHipodromo dst-address=10.1.218.0/23 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_RiandeNuevo dst-address=10.1.230.0/23 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_CasHipodromo dst-address=10.1.218.0/23 level=\
    unique peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Nacional dst-address=10.1.226.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Nacional dst-address=10.1.226.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Mirage dst-address=10.1.216.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
add comment=Tu-Icode-Codere_Mirage dst-address=10.1.216.0/23 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Sheraton dst-address=10.1.213.0/24 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=10.35.0.0/24 tunnel=yes
add comment=Tu-Icode-Codere_Sheraton dst-address=10.1.213.0/24 level=unique \
    peer=Tu-Icode-Codere proposal=Prop_Tu-Icode-Codere sa-dst-address=\
    186.72.2.2 sa-src-address=0.0.0.0 src-address=192.168.50.48/29 tunnel=yes
/ip route
add disabled=yes distance=1 gateway=192.168.100.1
add distance=1 dst-address=10.0.2.0/24 gateway=10.35.0.187
add distance=1 dst-address=10.1.1.0/24 gateway=10.35.0.187
add distance=1 dst-address=10.1.82.240/32 gateway=bridgeLAN
add distance=1 dst-address=10.10.0.10/32 gateway=bridgeLAN
add comment=MADRIDRIO-OFICINAAYTO distance=1 dst-address=10.14.171.0/24 \
    gateway=10.35.1.12
add distance=1 dst-address=10.20.0.0/24 gateway=bridgeLAN
add distance=1 dst-address=10.70.10.0/24 gateway=10.35.100.2
add comment=BBAY-BANUS distance=1 dst-address=10.100.0.0/23 gateway=10.35.1.1
add comment=BBAY-LANZAROTE distance=1 dst-address=10.100.2.0/23 gateway=\
    10.35.1.4
add comment=BALAMO-MARISQUERIA distance=1 dst-address=10.100.6.0/23 gateway=\
    10.35.1.10
add comment=JUANECA-GUADALIX distance=1 dst-address=10.100.10.0/24 gateway=\
    10.35.10.4
add comment=BBAY-VILLASDORADAS distance=1 dst-address=10.100.12.0/23 gateway=\
    10.35.1.13
add comment=BBAY-VILLASDORADAS distance=1 dst-address=10.100.14.0/23 gateway=\
    10.35.1.14
add comment=BARCELO-BOBADILLA distance=1 dst-address=10.100.16.0/23 gateway=\
    10.35.1.15
add distance=1 dst-address=10.100.18.0/23 gateway=10.35.101.10
add comment=CARDAMOMO-ECHEGARAY distance=1 dst-address=10.100.20.0/24 \
    gateway=10.35.10.3
add comment=GRUPOHD-ALISIOS distance=1 dst-address=10.100.50.0/23 gateway=\
    10.35.1.8
add comment=BBAY-CLUB distance=1 dst-address=10.100.64.0/22 gateway=10.35.1.3
add comment=BBAY-BEACHCLUB distance=1 dst-address=10.100.68.0/22 gateway=\
    10.35.1.5
add comment=BBAY-AQUARIUS distance=1 dst-address=10.100.74.0/23 gateway=\
    10.35.1.11
add comment=BBAY-VISTANOVA distance=1 dst-address=10.100.76.0/23 gateway=\
    10.35.1.6
add comment=BBAY-LAGOMONTE distance=1 dst-address=10.100.78.0/23 gateway=\
    10.35.1.7
add comment=BBAY-BELSANA distance=1 dst-address=10.100.80.0/23 gateway=\
    10.35.1.2
add distance=1 dst-address=10.120.11.0/24 gateway=10.35.100.9
add distance=1 dst-address=10.120.12.0/24 gateway=10.35.100.4
add distance=1 dst-address=10.221.0.25/32 gateway=10.35.101.9
add distance=1 dst-address=10.221.0.51/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.0.52/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.0.53/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.0.62/32 gateway=10.35.101.10
add distance=1 dst-address=10.221.0.70/32 gateway=10.35.101.10
add distance=1 dst-address=10.221.0.71/32 gateway=10.35.101.10
add distance=1 dst-address=10.221.0.72/32 gateway=10.35.101.10
add distance=1 dst-address=10.221.0.100/32 gateway=10.35.101.16
add distance=1 dst-address=10.221.0.101/32 gateway=10.35.101.16
add distance=1 dst-address=10.221.0.102/32 gateway=10.35.101.16
add distance=1 dst-address=10.221.8.20/32 gateway=*F00BB0
add distance=1 dst-address=10.221.8.25/32 gateway=*F00BB0
add distance=1 dst-address=10.221.8.28/32 gateway=*F00BB0
add distance=1 dst-address=10.221.8.100/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.126/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.198/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.199/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.200/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.208/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.211/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.212/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.214/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.8.215/32 gateway=10.35.101.13
add distance=1 dst-address=10.221.64.17/32 gateway=10.35.101.10
add distance=1 dst-address=10.221.72.38/32 gateway=10.35.101.9
add distance=1 dst-address=172.16.0.0/24 gateway=bridgeLAN
add distance=1 dst-address=172.18.99.0/24 gateway=10.35.100.1
add distance=1 dst-address=172.18.99.0/24 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.8/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.9/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.10/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.60/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.61/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.66/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.69/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.72/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.73/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.74/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.75/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.76/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.77/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.78/32 gateway=10.35.100.8
add distance=1 dst-address=172.18.99.79/32 gateway=10.35.100.8
add distance=1 dst-address=172.19.0.0/24 gateway=bridgeLAN
add distance=1 dst-address=172.19.1.0/24 gateway=bridgeLAN
add disabled=yes distance=1 dst-address=192.168.1.0/24 gateway=bridgeLAN
add disabled=yes distance=1 dst-address=192.168.1.90/32 gateway=bridgeLAN
add disabled=yes distance=1 dst-address=192.168.1.94/32 gateway=bridgeLAN
add disabled=yes distance=1 dst-address=192.168.1.102/32 gateway=bridgeLAN
add disabled=yes distance=1 dst-address=192.168.1.104/32 gateway=bridgeLAN
add check-gateway=ping disabled=yes distance=1 dst-address=192.168.1.112/32 \
    gateway=10.35.100.4
add check-gateway=ping disabled=yes distance=1 dst-address=192.168.1.112/32 \
    gateway=10.35.100.9 pref-src=192.168.50.1
add distance=1 dst-address=192.168.3.0/24 gateway=10.35.10.6
add comment=CASTAVI-APT distance=1 dst-address=192.168.10.0/24 gateway=\
    10.35.1.9
add comment=Tu-Icode-Ruben disabled=yes distance=1 dst-address=\
    192.168.55.0/24 gateway=pppoe-WAN
add comment="MADRIDRIO - AntenasWifi E500" distance=1 dst-address=\
    192.168.80.0/24 gateway=10.35.1.12
add comment="HOTEL MIGUEL ANGEL" distance=1 dst-address=192.168.128.0/21 \
    gateway=bridgeLAN
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/ppp secret
add comment="L2TP Icode" name=icode password=ICDl2tpserver! profile=\
    L2TP_dinamico
add comment="BlueBay Banus" name=BBAY-BANUS password=239ga6ppbyf423wd \
    profile=L2TP_estatico remote-address=10.35.1.1 service=l2tp
add comment="BlueBay Belsana" name=BBAY-BELSANA password=bcxydt06o59c5r8k \
    profile=L2TP_estatico remote-address=10.35.1.2 service=l2tp
add comment="BlueBay Bellevue Club" name=BBAY-CLUB password=7od6jnh10jhe28zs \
    profile=L2TP_estatico remote-address=10.35.1.3 service=l2tp
add comment="BlueBay Lanzarote" name=BBAY-LANZAROTE password=pnv85kb94pt1a5wy \
    profile=L2TP_estatico remote-address=10.35.1.4 service=l2tp
add comment="BlueBay VistaNova" name=BBAY-VISTANOVA password=glb1drz4aq0i6hs0 \
    profile=L2TP_estatico remote-address=10.35.1.6 service=l2tp
add comment="Centro Comercial Alisios" name=GRUPOHD-ALISIOS password=\
    9wsprjr9zxiuvuje profile=L2TP_estatico remote-address=10.35.1.8 service=\
    l2tp
add comment="Apartamentos Castavi" name=CASTAVI-APT password=l1vjgh5hosgkfbzp \
    profile=L2TP_estatico remote-address=10.35.1.9 service=l2tp
add comment="Fisa Central" name=FISA-CENTRAL password=f1z8mk70564g9vbv \
    profile=L2TP_estatico remote-address=10.35.10.1 service=l2tp
add comment="BlueBay Lagomonte" name=BBAY-LAGOMONTE password=kj9fa63pbyf3f3wh \
    profile=L2TP_estatico remote-address=10.35.1.7 service=l2tp
add comment="Marisqueria Balamo" name=BALAMO-MARISQUERIA password=0mcdwhlgax2 \
    profile=L2TP_estatico remote-address=10.35.1.10 service=l2tp
add comment="Orenes - Salon Archena" name=ORE-ARCHENA password=5f5sg7ihs3g \
    profile=L2TP_estatico remote-address=10.35.101.1 service=l2tp
add comment="Bluebay Beachclub" name=BBAY-BEACHCLUB password=\
    G2HmWgeZHorvV1F0wA91 profile=L2TP_estatico remote-address=10.35.1.5 \
    service=l2tp
add comment="Icode Guadalix" disabled=yes name=ICDMAD password=icodemadrid \
    profile=L2TP_estatico remote-address=10.35.255.1 service=l2tp
add comment="Casino Maria del Sol Chillan" name=MDS-CHILLAN password=\
    MDSCHILLAN! profile=L2TP_estatico remote-address=10.35.100.2 service=l2tp
add comment="Tablao Cardamomo" name=CARDAMOMO-ECHEGARAY password=\
    Cardaicdm4n4g3! profile=L2TP_estatico remote-address=10.35.10.3 service=\
    l2tp
add comment="Fisa GranVia662" name=FISA-GRANVIA62 password=134asd8vn4 \
    profile=L2TP_estatico remote-address=10.35.10.2 service=l2tp
add comment="Salon Novomatic Francos Rodriguez" name=NOVOFRANCOS password=\
    NOVOFRANCOS profile=L2TP_estatico remote-address=10.35.100.4 service=l2tp
add comment="Salon BBT Chorrera" name=BBT-CHORRERA password="5r\$09z1rPR" \
    profile=L2TP_estatico remote-address=10.35.100.1 service=l2tp
add comment="Orenes - Salon Ruzafa" name=ORE-RUZAFA password=5f5sg7ihs3g \
    profile=L2TP_estatico remote-address=10.35.101.2 service=l2tp
add comment="Salon WinCity Granada" name=WIN-GRANADA password=235g56653wrd \
    profile=L2TP_estatico remote-address=10.35.100.6 service=l2tp
add comment="Salon WinCity Fuenlabrada" name=WIN-FUENLA password=t7uh34werg \
    profile=L2TP_estatico remote-address=10.35.100.5 service=l2tp
add comment="Orenes - Salon Torres Cotillas" name=ORE-TORRES password=\
    23licjdxfc34we profile=L2TP_estatico remote-address=10.35.101.3 service=\
    l2tp
add comment="Salon BBT Colon" name=BBT-COLON password=g67sf34rb34t! profile=\
    L2TP_estatico remote-address=10.35.100.2 service=l2tp
add comment="Orenes - Salon Granada" name=ORE-GRANADA password=GRANADA \
    profile=L2TP_estatico remote-address=10.35.101.4 service=l2tp
add comment="Orenes - Salon Archena" name=ORE-UBRIQUE password=5f5sg7ihs3g \
    profile=L2TP_estatico remote-address=10.35.101.5 service=l2tp
add comment="Salon Novomatic Francos Rodriguez" name=NOVOMATIC-VELILLA \
    password=NOVO-VELILLA profile=L2TP_estatico remote-address=10.35.100.7 \
    service=l2tp
add name=JUANECA-GUADALIX password=juaneca profile=L2TP_estatico \
    remote-address=10.35.10.4 service=l2tp
add comment="BlueBay Banus" name=BBAY-AQUARIUS password=239ga6ppbyf423wd \
    profile=L2TP_estatico remote-address=10.35.1.11 service=l2tp
add name=ORE-CAS-BADAJOZ password=ORE-CAS-BADAJOZ profile=L2TP_estatico \
    remote-address=10.35.101.6 service=l2tp
add name=ORE-KINEPOLIS password=ORE-KINEPOLIS profile=L2TP_estatico \
    remote-address=10.35.101.7 service=l2tp
add comment="Bluebay Beachclub" name=BBAY-VILLASDORADAS password=\
    A365!WgeZHorvV1F0wA91 profile=L2TP_estatico remote-address=10.35.1.13 \
    service=l2tp
add comment="Bluebay Beachclub" name=BBAY-DOMINICAN password=\
    O9893HorvV1F0wA90! profile=L2TP_estatico remote-address=10.35.1.14 \
    service=l2tp
add name=ORE-CAS-LANZAROTE password=ORE-CAS-LANZAROTE profile=L2TP_estatico \
    remote-address=10.35.101.8 service=l2tp
add name=ORE-CAS-BADAJOZv2 password=ORE-CAS-BADAJOZv2 profile=L2TP_estatico \
    remote-address=10.35.101.9 service=l2tp
add name=ORE-CAS-MURCIA password=ORE-CAS-MURCIA profile=L2TP_estatico \
    remote-address=10.35.101.10 service=l2tp
add name=ORE-RINCONADA password=ORE-RINCONADA profile=L2TP_estatico \
    remote-address=10.35.101.11 service=l2tp
add comment="Salon BBT Chorrera" name=BBT-MARBELLA password=BBT-MARBELLA \
    profile=L2TP_estatico remote-address=10.35.100.8 service=l2tp
add name=ORE-LOMASCABOROIG password=ORE-LOMASCABOROIG profile=L2TP_estatico \
    remote-address=10.35.101.12 service=l2tp
add comment="Madrid Rio" name=MADRIDRIO-OFICINAAYTO password=239ga6ppbyf423+! \
    profile=L2TP_estatico remote-address=10.35.1.12 service=l2tp
add comment="Salon Novomatic Francos Rodriguez" name=NOVOHUMANES password=\
    NOVOHUMANES profile=L2TP_estatico remote-address=10.35.100.9 service=l2tp
add name=ORE-PARLA password=ORE-PARLA profile=L2TP_estatico remote-address=\
    10.35.101.13 service=l2tp
add comment="Bluebay Beachclub" name=BARCELO-BOBADILLA password=\
    uiok+93HorvV1F0wAee! profile=L2TP_estatico remote-address=10.35.1.15 \
    service=l2tp
add name=ORE-ZURBARAN password=ORE-ZURBARAN profile=L2TP_estatico \
    remote-address=10.35.101.14 service=l2tp
add comment="L2TP Icode" name=chernandez password=PlCastilla+1 profile=\
    L2TP_dinamico
add name=ORE-ODISEO password=ORE-ODISEO profile=L2TP_estatico remote-address=\
    10.35.101.10 service=l2tp
add name=ORE-TORREJON password=ORE-TORREJON profile=L2TP_estatico \
    remote-address=10.35.101.15 service=l2tp
add name=ORE-PALACIOS password=ORE-PALACIOS profile=L2TP_estatico \
    remote-address=10.35.101.16 service=l2tp
add comment="L2TP Icode" name=optimus4s password=ICDl2tpserver! profile=\
    L2TP_dinamico
add name=BALAMO2 password=BALAMO2 profile=L2TP_estatico remote-address=\
    10.35.11.10 service=l2tp
add name=RYAMAD password=RYAMAD profile=L2TP_estatico remote-address=\
    10.35.10.6 service=l2tp
add name=RYABCN password=RYABCN profile=L2TP_estatico remote-address=\
    10.35.10.5 service=l2tp
/radius
add address=18.197.251.195 secret=icodelab! service=hotspot
/snmp
set enabled=yes trap-community=icodesnmp trap-target=192.168.50.53 \
    trap-version=2
/system clock
set time-zone-name=Europe/Madrid
/system identity
set name=Mikrotik_Core-Icode_Density
/system logging
set 0 disabled=yes
set 1 disabled=yes
add disabled=yes topics=ipsec,debug,!packet
add disabled=yes topics=ipsec,info
add topics=firewall,info
add disabled=yes topics=l2tp,error,!packet
add disabled=yes topics=l2tp,!packet
add disabled=yes topics=l2tp
add disabled=yes topics=ipsec
/system scheduler
add interval=2m name=dynDNS on-event="/system script run dynDNS" policy=\
    reboot,read,write,policy,test start-time=startup
/system script
add dont-require-permissions=no name=dynDNS owner=admin policy=\
    read,write,test source=":local DDNSuser \"icodecons\"\r\
    \n:local DDNSpass \"D3nsit&05!\"\r\
    \n:local DDNShost \"icodeoficina.dyndns.org\"\r\
    \n\r\
    \n:local CURRip [/tool fetch url=\"http://myip.dnsomatic.com/index.html\" \
    mode=http dst-path=CURRip; :delay 1; /file get CURRip contents; /file remo\
    ve CURRip]\r\
    \nif ([:resolve \$DDNShost] != \$CURRip) do={\r\
    \n    /tool fetch url=\"http://members.dyndns.org/nic/update\?hostname=\$D\
    DNShost&myip=\$CURRip\" mode=http user=\$DDNSuser password=\$DDNSpass dst-\
    path=DDNShost keep-result=no;\r\
    \n    /log info message=(\"DDNS: Updating \$DDNShost to:\$CURRip\")\r\
    \n    }"
/tool graphing interface
add
/tool graphing queue
add
/tool graphing resource
add
/tool netwatch
add host=10.100.18.1 interval=2s
add host=10.100.18.102 interval=2s
add host=10.100.18.101 interval=2s
add host=10.100.18.103 interval=2s
add host=10.35.101.10 interval=2s
add host=10.100.18.2 interval=2s
