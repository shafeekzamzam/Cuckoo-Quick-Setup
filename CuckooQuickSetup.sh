#!/bin/sh

#ASSUMING AN UBUNTU 20.10 WHICH IS A FRESH INSTALL
#Most of the Tools are listed as per Origial Cuckoo Documentation
#Execute with sudo access:  ./CuckooQuickSetup.sh

#======================================================
#For Win 7 VM ISO->goes in readme as well
#======================================================
#wget https://cuckoo.sh/win7ultimate.iso

sudo apt-get install git
sudo apt-get install curl
sudo apt-get install software-properties-common
#======================================================
Python
#======================================================
sudo add-apt-repository universe

#apt-get install python 		#deprecated
sudo apt install python2		#python-is-python2

curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python2 get-pip.py
pip --version

#optional
#apt install python3-pip
#pip3 --version

#======================================================
Other Libraries
#======================================================

#sudo apt-get install python-pip 	      #E: Package 'python-pip' has no installation candidate
sudo apt-get install python-dev 	        #Good/Working
sudo apt-get install libffi-dev 	        #Good/Working
sudo apt-get install libssl-dev		      #Good/Working
sudo apt-get install python-virtualenv 	#E: Package 'python-virtualenv' has no installation candidate
#pip install virtualenv			        #optional for Cuckoo
sudo apt-get install python-setuptools	  #Good/Working
sudo apt-get install libjpeg-dev 	      #Good/Working
sudo apt-get install zlib1g-dev 	        #Good/Working


#pydeep Optional-to check
#======================================================
Add User
#======================================================
sudo adduser cuckoo
sudo usermod -a -G vboxusers cuckoo
sudo usermod -a -G libvirtd cuckoo

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
sudo apt-get install virtualbox
sudo apt-get install virtualbox-ext-pack     #Relevance??to be checked


#VBoxManage goes here......
#Assuming win7.iso is available for installation
#========
#Create VM
VBoxManage createvm --name $MACHINENAME --ostype "Debian_64" --register --basefolder `pwd`
#Set memory and network
VBoxManage modifyvm $MACHINENAME --ioapic on
VBoxManage modifyvm $MACHINENAME --memory 1024 --vram 128
VBoxManage modifyvm $MACHINENAME --nic1 nat
#Create Disk and connect Debian Iso
VBoxManage createhd --filename `pwd`/$MACHINENAME/$MACHINENAME_DISK.vdi --size 80000 --format VDI
VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/$MACHINENAME/$MACHINENAME_DISK.vdi
VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/debian.iso
VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
#=====





#======================================================
#TCPDump
#======================================================
#Description Required
sudo apt-get install tcpdump apparmor-utils      
sudo aa-disable /usr/sbin/tcpdump

sudo apt-get install tcpdump

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
sudo apt-get install swig

#sudo pip install m2crypto==0.24.0      #Version Error
sudo -H pip install m2crypto==0.31.0    #Good/Working



#======================================================
#guacd optional
#======================================================
sudo pip install -U pip setuptools #details&relevance??
sudo pip install -U cuckoo


cuckoo -d



sudo pip install distorm3

sudo mkdir /opt/cuckoo
sudo chown cuckoo:cuckoo /opt/cuckoo
cuckoo --cwd /opt/cuckoo

vboxmanage hostonlyif create vboxnet0
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
sudo iptables -A FORWARD -o ens33 -l vboxnet0 -s 192.168.56.0/24 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A POSTROUTING -t nat -j MASQUERADE
sudo echo 1 > /proc/sys/net/ipv4/ip_forward


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

#==========================
#change vmsettings network adaptor to vboxnet0

#windows guest
#cuckoo
#ipconfig
#192.168.56.101
#255.255.255.0
#192.168.56.1
#8.8.8.8
#8.8.4.4
#validate settings upon exit

##check ping www.google.com
#install guest addition
#chrome
#python 2.7 install
#pypi.org/project/pillow/#files  =>pillow-5.1.0 win32 py27

#restart
#share folder access to copy agents

#firewall disable
#uac disbale

#take snapshot
#take clone
#VBoxManage snapshot "Win7x64" take "Win7x64_snap" --pause
#VBoxManage controlvm "Win7x64" poweroff
#VBoxManage snapshot "Win7x64" restorecurrent







