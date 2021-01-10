VBoxManage createvm --name win7x64Cuckoo --ostype "windows_64" --register --basefolder `pwd` 

VBoxManage modifyvm win7x64Cuckoo --ioapic on                     
VBoxManage modifyvm win7x64Cuckoo --memory 4096 --vram 128       
VBoxManage modifyvm win7x64Cuckoo --nic1 nat 


VBoxManage createhd --filename `pwd`/win7x64Cuckoo/win7x64Cuckoo_DISK.vdi --size 80000 --format VDI                     
VBoxManage storagectl win7x64Cuckoo --name "SATA Controller" --add sata --controller IntelAhci       
VBoxManage storageattach win7x64Cuckoo --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/win7x64Cuckoo/win7x64Cuckoo_DISK.vdi                
VBoxManage storagectl win7x64Cuckoo --name "IDE Controller" --add ide --controller PIIX4       
VBoxManage storageattach win7x64Cuckoo --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/debian.iso       
VBoxManage modifyvm win7x64Cuckoo --boot1 dvd --boot2 disk --boot3 none --boot4 none 


VBoxManage modifyvm [MACHINE NAME] --vrde on                  
VBoxManage modifyvm [MACHINE NAME] --vrdemulticon on --vrdeport 10001

VBoxHeadless --startvm [MACHINE NAME] 

====================================
#!/bin/bash
MACHINENAME=$1
#commandline parameter $1


# Download debian.iso
if [ ! -f ./debian.iso ]; then
    wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.9.0-amd64-netinst.iso -O debian.iso
fi

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

#Enable RDP
VBoxManage modifyvm $MACHINENAME --vrde on
VBoxManage modifyvm $MACHINENAME --vrdemulticon on --vrdeport 10001

#Start the VM
VBoxHeadless --startvm $MACHINENAME



#=======================================
#   Preparing Guest VM's --Tobe made as a new shell script
#=======================================
#Download the latest Python 2.7.x for Windows to your Ubuntu server. Host the files a convenient place and fire up a SIMPLE WEB SERVER 
#cd ~/Downloads cp ~/cuckoo/agents/agent.py ~/Downloads python -m SimpleHTTPServer
#Download the x64 MSI installer and the Cuckoo agent 192.168.51:8000/python-2.7.14.amd64.msi 192.168.51:8000/agent.py

#Install Python manually in each VM.

#Start the Cuckoo agent by opening a Command Prompt as Administrator.

#check ping www.google.com
#Install Guest addition //Find an alternate solution
#Install Google Chrome
#python 2.7 install
#pypi.org/project/pillow/#files  =>pillow-5.1.0 win32 py27

#Disable the Windows Firewall
#Disable UAC (Never Notify)
#Disable Windows Updates (don't even bother with W10)

#Inside VM Guest Network Settings
#cuckoo
#ipconfig
#192.168.56.101
#255.255.255.0
#192.168.56.1
#8.8.8.8
#8.8.4.4
#validate settings upon exit



#restart
#share folder access to copy agents //Better method to select




#take clone
#take snapshot

#VBoxManage snapshot "Win7x64" take "Win7x64_snap" --pause
#VBoxManage controlvm "Win7x64" poweroff
#VBoxManage snapshot "Win7x64" restorecurrent
