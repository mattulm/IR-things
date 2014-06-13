#!/bin/bash
#
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
DDIR="text"
FILE="ipchecks"

echo "What is the case name? :"
read CASE
if [ ! -d "$HOME/$CASE" ]; then
        echo "It does not look as if the case has been setup just yet.";
        echo "Please run the correct script first. ";
        echo " ";
        sleep 1;
        exit;
fi

#
# Check for some directories
if [ ! -d "$HOME/$CASE/text/ipfiles/vt" ]; then
        mkdir -p $HOME/$CASE/$DDIR/ipfiles/vt
fi
if [ ! -d "$HOME/$CASE/evidence/ipchecks" ]; then
        mkdir $HOME/$CASE/evidence/ipchecks
fi


cd $HOME/$CASE/text
echo "We are going to grab information from Virus Total on our IPs."
wc -l ipfiles/ipv4connections.external.txt
echo " "
echo "I am going to wait a little bit between each request, so I do not "
echo "request to many too quickly, and anger VT/Google. "
while read i; do
        echo "Checking Virus Total for..... $i"	
	wget https://www.virustotal.com/en/ip-address/$i/information/ -O ipfiles/vt/$i.vt.html
	sleep 5;
	echo " "
done < ipfiles/ipv4connections.external.txt 


#
# Check some of the virus total files
echo " checking the Virus Total files "
echo " "
echo " This the first round of checks "
echo " This will check if there is any record of the IP in Virus Total. "
echo " If VirusTotal has never resolved any domain name from the submitted IP address "
echo " That file will be deleted. "
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " This is the first round of checks " >> $HOME/$CASE/evidence/$FILE.log
echo " This will check if there is any record of the IP in Virus Total. " >> $HOME/$CASE/evidence/$FILE.log
echo " If VirusTotal has never resolved any domain name from the submitted IP address " >> $HOME/$CASE/evidence/$FILE.log
echo " That file will be deleted. " >> $HOME/$CASE/evidence/$FILE.log
echo " The IP and filename will be logged. " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
for i in $HOME/$CASE/$DDIR/ipfiles/vt/*.vt.html; do
        if grep -q "VirusTotal has never resolved any domain name" $i; then
                echo "$i - VirusTotal has never resolved any domain name "; >> $HOME/$CASE/evidence/$FILE.log
                echo " "; >> $HOME/$CASE/evidence/$FILE.log
                echo " I will remove the following file - $i "
                echo " VirusTotal has never resolved any domain name for this IP "
                rm -f $i
		echo " "
	else
		echo "Virus Total has some information about this IP. "
		echo "For now you will need to investigate this manually. "
        fi
done
echo " "


#
# EOF
