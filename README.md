# Cuckoo-Quick-Setup
for Ubuntu 20.10 OS


Setting up Cuckoo in Ubuntu 20.10 Using Shell Script
List of Tools & Version 
| App/Task       | Version/Comments          | 
| ------------- |:-------------:| 
| Python     | 2.7.17 |
|  |      |  
|  |      |  
|  |      |  
|  |      |  
|  |      |  



Setting Guest-Win7x64 using Batch Script
List of Tools & Version (table)
| App/Task       | Version/Comments          | 
| ------------- |:-------------:| 
| Python     | 2.7.17 |
| Pip     |  2.2.2     |  
| Chrome |      |   
| Adobe Reader |  | 
| Office |  | 
| Disable Windows AutoUpdate |  | 
| Disable Firewall |  | 

Network Diagram

IP Layout

First Install the basic Cuckoo setup in Ubuntu using a Normal User Privilege Install of CuckooQuickSetup.sh and In Parallel download the Win7 ISO Image

Now, do the VM Installation and Configuration using AutoCreateVM.sh

Using Simple Web Server, Import the Agent inside the VM


sudo apt-get install git <br>
git clone https://github.com/shafeekzamzam/Cuckoo-Quick-Setup.git <br>
chmod +rwx CuckooQuickSetup.sh <br>
sudo ./CuckooQuickSetup.sh<br>
