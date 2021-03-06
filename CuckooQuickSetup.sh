#!/bin/sh

#ASSUMING AN UBUNTU 20.10 WHICH IS A FRESH INSTALL
#Cuckoo v2.0.7
#Most of the Tools are listed as per Origial Cuckoo Documentation
#Execute with NORMAL access:  ./CuckooQuickSetup.sh

#TODO:-Recheck if Sudo or Normal execution required for all installations

#======================================================
#       For Win 7 VM ISO->goes in readme as well
#======================================================
#wget https://cuckoo.sh/win7ultimate.iso
#======================================================
#       Basic Tools
#======================================================
sudo apt-get install git -y
sudo apt-get install curl -y
sudo apt-get install software-properties-common -y
#======================================================
#       Python
#======================================================
sudo add-apt-repository universe

#apt-get install python 		#deprecated
sudo apt install python2 -y		#python-is-python2
#sudo apt install python3 -y	#Python 3

curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
sudo python2 get-pip.py
python --version
pip --version

#Optional
#sudo apt install python3-pip -y
#pip3 --version

#======================================================
#       Other Python Libraries
#======================================================
#sudo apt-get install python-pip 	            #E: Package 'python-pip' has no installation candidate
sudo apt-get install python-dev -y 	            #Good/Working
sudo apt-get install libffi-dev -y 	            #Good/Working
sudo apt-get install libssl-dev -y		        #Good/Working
sudo apt-get install python-virtualenv -y 	    #E: Package 'python-virtualenv' has no installation candidate
#pip install virtualenv			                #optional for Cuckoo
sudo apt-get install python-setuptools -y       #Good/Working
sudo apt-get install libjpeg-dev -y             #Good/Working
sudo apt-get install zlib1g-dev -y              #Good/Working

#pydeep Optional-to check

#======================================================
#       Add User - Cuckoo #relevence to check??
#======================================================
sudo adduser cuckoo                         #Explaination Required
#sudo usermod -a -G vboxusers cuckoo         #If you’re using VirtualBox, make sure the new user belongs to the “vboxusers” group (or the group you used to run VirtualBox):

#======================================================
#       MongoDB
#       https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-20-04
#======================================================
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
apt-key list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt update
sudo apt install mongodb-org -y
#======================================================
#       PostgreSQL
#======================================================
sudo apt-get install postgresql libpq-dev -y
#======================================================
#       Virtualbox
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
#       TCPDump
#======================================================
#tcpdump is a data-network packet analyzer computer program that runs under a command line 
#interface. It allows the user to display TCP/IP and other packets being transmitted or 
#received over a network to which the computer is attached.
#Note: You must be able to run tcpdump as non-root user (user that is later used to run Cuckoo) otherwise Cuckoo will complain later.
sudo apt-get install tcpdump apparmor-utils -y     
sudo aa-disable /usr/sbin/tcpdump

groupadd pcap                                             #Explaination Required
usermod -a -G pcap cuckoo                                 #Explaination Required
chgrp pcap /usr/sbin/tcpdump                              #Explaination Required
setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump    #Explaination Required

#verifying the Setting
echo getcap /usr/sbin/tcpdump  
#/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip
#======================================================
#       Volatility
#======================================================
#perform forensic analysis on memory dumps of the given sample. It can automatically provide additional 
#visibility into deep modifications in the operating system as well as detect the presence of rootkit technology 
#that escaped the monitoring domain of Cuckoo’s analyzer.

git clone https://github.com/volatilityfoundation/volatility.git
cd Volatility
sudo python setup.py install
cd ..
#======================================================
#       M2Crypto
#======================================================
#M2Crypto is a complete Python wrapper of OpenSSL that features RSA, DA, DH, EC, HMACs, and more. 
#We will be installing M2Crypto for adding cryptographic support and security to your Python applications.
#Currently, M2Crypto library is only supported when SWIG has been installed

sudo apt-get install swig -y

#sudo pip install m2crypto==0.24.0      #Version Error
sudo -H pip install m2crypto==0.31.0    #Good/Working
#======================================================
#         Distorm3
#======================================================
#diStorm3 is a decomposer, which means it takes an instruction and returns a binary 
#structure which describes it rather than static text, which is great for advanced binary code analysis
sudo pip install distorm3
#======================================================
#         Guacd optional     
#======================================================
#guacd is an optional service that provides the translation layer for RDP, VNC, and SSH 
#for the remote control functionality in the Cuckoo web interface.
#DEPENDENCY:Virtual Box Extension Pack

#sudo apt install libguac-client-rdp0 libguac-client-vnc0 libguac-client-ssh0 guacd  #ERROR:UNABLE TO LOCATE PACKAGE
#======================================================
#         SetupTools & Cuckoo
#======================================================
sudo pip install -U pip setuptools #details&relevance??
sudo pip install -U cuckoo

cuckoo -d

sudo mkdir /opt/cuckoo                  #
sudo chown cuckoo:cuckoo /opt/cuckoo    #
cuckoo --cwd /opt/cuckoo                #
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

#The Below Components are Additional To which has been mentioned in the Cuckoo Documentation
#=======================================
#   Simple Web Server -Not Good /To Be Changed
#=======================================
python2 -m SimpleHTTPServer 80
#python3 -m http.server 80

#=======================================
#Installing YARA
#=======================================
#================================================================================================================
#Installing YARA--verification pending
#================================================================================================================
#YARA is a tool that helps malware researchers identify and classify malware samples. With YARA we can create descriptions of malware families based on textual or binary patterns.
#Now with this tool, we will be able to identify the type of malware when our sample is analyzed.
#Download the latest version of YARA from the link: https://github.com/VirusTotal/yara/releases


#sudo tar -zxvf yara-3.8.1.tar.gz 

#Navigate inside the YARA folder and type below commands:
#sudo ./bootstrap.sh
#sudo ./configure --with-crypto --enable-magic –enable-cuckoo
#sudo make
#sudo make install
#sudo -H pip install yara-python

#================================================================================================================
#Installing FTP Server--Manual Config Required
#================================================================================================================
#Now we will be installing an anonymous FTP server called vsftpd. This is the simplest way to share files between the Virtual machines and your host machine.
#First, we have to create a publicly accessible folder. Follow the commands below:

#$ sudo mkdir -p /home/<replace_your_username>/vmshared/pub
#$ sudo chown -R cuckoo:cuckoo /home/<replace_your_username>
#$ sudo chmod -R ug=rwX,o=rX /home/<replace_your_username>/vmshared/
#$ sudo chmod -R ugo=rwX /home/<replace_your_username>/vmshared/pub
#Then install vsftpd:

#$ sudo apt-get install vsftpd
#Now after installing, edit the vsftpd.conf file:

#$ sudo nano /etc/vsftpd.conf
#Change listen to YES
#Change listen_ipv6 to NO
#Change anonymous_enable to YES

#Now, uncomment the following lines:

#write_enable=YES
#anon_upload_enable=YES
#anon_mkdir_write_enable=YES

#And add the following lines at the bottom:
#listen_address=192.168.100.1
#listen_port=2121
#anon_root=/home/cuckoo/vmshared
#anon_umask=000
#chown_upload_mode=0666
#pasv_enable=Yes
#pasv_min_port=10090
#pasv_max_port=10100

#Restart the service:
#$ sudo service vsftpd restart

#Now the VMs can read /home/samy/vmshared and can write to /home/samy/vmshard/pub
#We can now access the FTP server from the Windows VM by typing in ftp://192.168.56.1:2121 into any explorer window.









