#!/bin/bash
#
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
DDIR="text"
FILE="ipchecks"

#
### Get some information from the user.
########################################
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
if [ ! -d "$HOME/$CASE/$DDIR/ipfiles/googlesb" ]; then
        mkdir -p $HOME/$CASE/$DDIR/ipfiles/googlesb
fi
if [ ! -d "$HOME/$CASE/evidence/ipchecks" ]; then
        mkdir $HOME/$CASE/evidence/ipchecks
fi


cd $HOME/$CASE/$DDIR
echo "We are going to grab information from the googlesb database for each our IPs."
wc -l ipfiles/ipv4connections.external.txt
echo " "
echo "I am going to wait a little bit between each request, so I do not "
echo "request to many too quickly, and anger the googlesb folks. "
echo " ";
while read i; do
        # googlesb
        echo " Checking the McAfee Siteadvisor database..... $i"
        wget http://www.google.com/safebrowsing/diagnostic?site=$i&IP&IP=on -O ipfiles/googlesb/$i.googlesb.html
        sleep 5;
        echo " "
done < ipfiles/ipv4connections.external.txt


#
# EOF