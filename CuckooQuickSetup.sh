#!/bin/sh

#ASSUMING AN UBUNTU 20.10 WHICH IS A FRESH INSTALL
#Most of the Tools are listed as per Origial Cuckoo Documentation
#Execute with sudo access: sudo ./CuckooQuickSetup.sh

#======================================================
#For Win 7 VM ISO->goes in readme as well
#======================================================
#wget https://cuckoo.sh/win7ultimate.iso

apt-get install git
apt-get install curl
apt-get install software-properties-common
#======================================================
Python
#======================================================
add-apt-repository universe

#apt-get install python 		#deprecated
apt install python2		#python-is-python2

curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python2 get-pip.py
pip --version

#optional
#apt install python3-pip
#pip3 --version

#======================================================
Other Libraries
#======================================================

#apt-get install python-pip 	      #E: Package 'python-pip' has no installation candidate
apt-get install python-dev 	        #Good/Working
apt-get install libffi-dev 	        #Good/Working
apt-get install libssl-dev		      #Good/Working
apt-get install python-virtualenv 	#E: Package 'python-virtualenv' has no installation candidate
#pip install virtualenv			        #optional for Cuckoo
apt-get install python-setuptools	  #Good/Working
apt-get install libjpeg-dev 	      #Good/Working
apt-get install zlib1g-dev 	        #Good/Working


#pydeep Optional-to check
#======================================================
Add User
#======================================================
adduser cuckoo
usermod -a -G vboxusers cuckoo
usermod -a -G libvirtd cuckoo

#======================================================
#mongodb
#https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-20-04
#======================================================

curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

apt-key list

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update

sudo apt install mongodb-org

#======================================================
#PostgreSQL
#======================================================
sudo apt-get install postgresql libpq-dev

#======================================================
#Virtualbox
#======================================================
apt-get install virtualbox
apt-get install virtualbox-ext-pack     #Relevance??to be checked


#VBoxManage goes here......
#Assuming win7.iso is available for installation


#VBoxManage snapshot "Win7x64" take "Win7x64_snap" --pause
#VBoxManage controlvm "Win7x64" poweroff
#VBoxManage snapshot "Win7x64" restorecurrent


#Configuring the Guest VMs
#Open VirtualBox and create your base VMs - I’m just going to create Windows 7 32-bit & 64-bit VMs called Win10x64 and Win7x64 respectively. They can be small VMs. So give them
#1 CPU
#512MB RAM
#10GB HDD 
#1 NIC attached to vboxnet0
#During installation, set the username to cuckoo for all VMs. Wait for the installation to finish.
#Set a static IP in each VM
#Win10x64 - 192.168.56.10
#Win7x64 - 192.168.56.15
#You will also want to
#Disable the Windows Firewall
#Disable UAC (Never Notify)
#Disable Windows Updates (don't even bother with W10)
#Download the latest Python 2.7.x for Windows to your Ubuntu server. Host the files a convenient place and fire up a simple web server cd ~/Downloads cp ~/cuckoo/agents/agent.py ~/Downloads python -m SimpleHTTPServer
#Download the x64 MSI installer and the Cuckoo agent 192.168.51:8000/python-2.7.14.amd64.msi 192.168.51:8000/agent.py
#Install Python manually in each VM.
#Start the Cuckoo agent by opening a Command Prompt as Administrator.
#Whilst the VMs are running, follow these steps to snapshot them (repeat for each VM):

#In the GUI, they should appear as Saved

#======================================================
#TCPDump
#======================================================
#Description Required
apt-get install tcpdump apparmor-utils      
aa-disable /usr/sbin/tcpdump

apt-get install tcpdump

groupadd pcap
usermod -a -G pcap cuckoo
chgrp pcap /usr/sbin/tcpdump
setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

#verify
echo getcap /usr/sbin/tcpdump
#/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip
#======================================================
#Installing Volatility
#======================================================
git clone https://github.com/volatilityfoundation/volatility.git
cd Volatility
python setup.py install
cd ..

#======================================================
#M2Crypto
#======================================================
apt-get install swig

#pip install m2crypto==0.24.0      #Version Error
-H pip install m2crypto==0.31.0    #Good/Working



#======================================================
#guacd optional
#======================================================
pip install -U pip setuptools #details&relevance??
pip install -U cuckoo


cuckoo -d


























