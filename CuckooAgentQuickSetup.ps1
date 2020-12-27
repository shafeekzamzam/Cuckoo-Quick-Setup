#agent install in win7x64Cuckoo

Invoke-WebRequest -Uri "https://www.python.org/ftp/python/2.7.14/python-2.7.14.amd64.msi" -OutFile "c:/temp/python-2.7.14.amd64.msi"
Invoke-WebRequest -Uri "https://redirector.gvt1.com/edgedl/release2/chrome/VM7AZGvxTD3eRDzvxYLSvg_86.0.4240.75/86.0.4240.75_chrome_installer.exe" -OutFile "c:/temp/86.0.4240.75_chrome_installer.exe"
Invoke-WebRequest -Uri "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/1901020099/AcroRdrDC1901020099_en_US.exe" -OutFile "c:/temp/AcroRdrDC1901020099_en_US.exe"

#install vscode also


c:/temp/python-3.7.0.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
c:/temp/86.0.4240.75_chrome_installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
c:/temp/AcroRdrDC1901020099_en_US.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
