#!/bin/sh

#ASSUMING AN UBUNTU 20.10 WHICH IS A FRESH INSTALL
#Cuckoo 2.0.7
#Most of the Tools are listed as per Origial Cuckoo Documentation
#Execute with NORMAL access:  ./CuckooQuickSetup.sh

#Recheck if Sudo or Normal execution required for all installations

#======================================================
#For Win 7 VM ISO->goes in readme as well
#======================================================
#wget https://cuckoo.sh/win7ultimate.iso

sudo apt-get install git -y
sudo apt-get install curl -y
sudo apt-get install software-properties-common -y
#======================================================
Python
#======================================================
sudo add-apt-repository universe

#apt-get install python 		#deprecated
sudo apt install python2 -y		#python-is-python2
sudo apt install python3 -y		#python-is-python2

curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python2 get-pip.py
pip --version

#optional
sudo apt install python3-pip -y
pip3 --version

#======================================================
Other Libraries
#======================================================

#sudo apt-get install python-pip 	          #E: Package 'python-pip' has no installation candidate
sudo apt-get install python-dev -y 	        #Good/Working
sudo apt-get install libffi-dev -y 	        #Good/Working
sudo apt-get install libssl-dev -y		      #Good/Working
sudo apt-get install python-virtualenv -y 	#E: Package 'python-virtualenv' has no installation candidate
#pip install virtualenv			                #optional for Cuckoo
sudo apt-get install python-setuptools -y   #Good/Working
sudo apt-get install libjpeg-dev -y         #Good/Working
sudo apt-get install zlib1g-dev -y          #Good/Working


#pydeep Optional-to check

#======================================================
Add User  #relevence to check??
#======================================================
sudo adduser cuckoo                         #Explaination Required
sudo usermod -a -G vboxusers cuckoo         #Explaination Required
sudo usermod -a -G libvirtd cuckoo          #Explaination Required

#======================================================
#mongodb
#https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-20-04
#======================================================

curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

apt-key list

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update

sudo apt install mongodb-org -y

#======================================================
#PostgreSQL
#======================================================
sudo apt-get install postgresql libpq-dev -y

#======================================================
#Virtualbox
#======================================================
sudo apt-get install virtualbox -y
sudo apt-get install virtualbox-ext-pack -y   #Relevance??to be checked


#VBoxManage goes here......
#Assuming win7.iso is available for installation
#========
#MACHINENAME="cuckoo1"
#Create VM
#VBoxManage createvm --name $MACHINENAME --ostype "Windows 7 (64-bit)" --register --basefolder `pwd`
#Set memory and network
#VBoxManage modifyvm $MACHINENAME --ioapic on
#VBoxManage modifyvm $MACHINENAME --memory 4096 --vram 128
#VBoxManage modifyvm $MACHINENAME --nic1 nat
#Create Disk and connect Debian Iso
#VBoxManage createhd --filename `pwd`/$MACHINENAME/$MACHINENAME_DISK.vdi --size 80000 --format VDI
#VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
#VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/$MACHINENAME/$MACHINENAME_DISK.vdi
#VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
#VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/win7ultimate.iso
#VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
#=====





#======================================================
#TCPDump
#======================================================
#Description Required
sudo apt-get install tcpdump apparmor-utils -y     
sudo aa-disable /usr/sbin/tcpdump

groupadd pcap                                             #Explaination Required
usermod -a -G pcap cuckoo                                 #Explaination Required
chgrp pcap /usr/sbin/tcpdump                              #Explaination Required
setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump    #Explaination Required

#verify                                                   tobe echoed in blue color
echo getcap /usr/sbin/tcpdump
#/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip
#======================================================
#Installing Volatility
#======================================================
#Description Required
git clone https://github.com/volatilityfoundation/volatility.git
cd Volatility
python setup.py install
cd ..

#======================================================
#M2Crypto
#======================================================
#Description Required
sudo apt-get install swig

#sudo pip install m2crypto==0.24.0      #Version Error
sudo -H pip install m2crypto==0.31.0    #Good/Working

#======================================================
#         Distorm3
#======================================================
#Description Required
sudo pip install distorm3



#======================================================
#         Guacd optional     --To Find Out
#======================================================


#======================================================
#         SetupTools & Cuckoo
#======================================================
sudo pip install -U pip setuptools #details&relevance??
sudo pip install -U cuckoo

cuckoo -d






sudo mkdir /opt/cuckoo
sudo chown cuckoo:cuckoo /opt/cuckoo
cuckoo --cwd /opt/cuckoo

#======================================================
#         Configuring Host Network Adapater & Firewall
#======================================================
#ifconfig
#ens33  192.168.217.134
#lo     127.0.0.1


#vboxmanage hostonlyif create vboxnet0
#vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
#sudo iptables -A FORWARD -o ens33 -l vboxnet0 -s 192.168.56.0/24 -m conntrack --ctstate NEW -j ACCEPT
#sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#sudo iptables -A POSTROUTING -t nat -j MASQUERADE
#sudo echo 1 > /proc/sys/net/ipv4/ip_forward


# sudo iptables -t nat -A POSTROUTING -o eth0 -s 192.168.56.0/24 -j MASQUERADE

# Default drop.
# sudo iptables -P FORWARD DROP

# Existing connections.
# sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# Accept connections from vboxnet to the whole internet.
# sudo iptables -A FORWARD -s 192.168.56.0/24 -j ACCEPT

# Internal traffic.
# sudo iptables -A FORWARD -s 192.168.56.0/24 -d 192.168.56.0/24 -j ACCEPT

# Log stuff that reaches this point (could be noisy).
# sudo iptables -A FORWARD -j LOG

#=======================================
#   Simple Web Server
#=======================================
python2 -m SimpleHTTPServer 80
#python3 -m http.server 80










