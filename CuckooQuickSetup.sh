#!/bin/sh

#For Win 7 VM ISO
#wget https://cuckoo.sh/win7ultimate.iso


sudo add-apt-repository universe

#sudo apt-get install python 		#deprecated
sudo apt install python2		#python-is-python2

curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
sudo python2 get-pip.py
pip --version

#optional
#sudo apt install python3-pip
#pip3 --version



#sudo apt-get install python-pip 	#E: Package 'python-pip' has no installation candidate
sudo apt-get install python-dev 	#Good/Working
sudo apt-get install libffi-dev 	#Good/Working
sudo apt-get install libssl-dev		#Good/Working
sudo apt-get install python-virtualenv 	#E: Package 'python-virtualenv' has no installation candidate
#pip install virtualenv			#optional for Cuckoo
sudo apt-get install python-setuptools	#Good/Working
sudo apt-get install libjpeg-dev 	#Good/Working
sudo apt-get install zlib1g-dev 	#Good/Working
sudo apt-get install swig		#Good/Working

#pydeep Optional-to check

sudo adduser cuckoo
sudo usermod -a -G vboxusers cuckoo
sudo usermod -a -G libvirtd cuckoo


#mongodb
#https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-20-04
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

apt-key list

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update
sudo apt install mongodb-org



#postgresql
sudo apt-get install postgresql libpq-dev

#Virtualbox
echo deb http://download.virtualbox.org/virtualbox/debian xenial contrib | sudo tee -a /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-5.2

#TCPDump
sudo apt-get install tcpdump apparmor-utils
sudo aa-disable /usr/sbin/tcpdump

sudo apt-get install tcpdump

sudo groupadd pcap
sudo usermod -a -G pcap cuckoo
sudo chgrp pcap /usr/sbin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

#verify
getcap /usr/sbin/tcpdump
#/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip

#Installing Volatility


#M2Crypto
sudo apt-get install swig

#version 24 notvailable
sudo pip install m2crypto==0.24.0



#guacd optional

sudo pip install -U pip setuptools
sudo pip install -U cuckoo


cuckoo -d


























