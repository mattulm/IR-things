#!/bin/bash
#
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
DDIR="text"
FILE="ipchecks"

#
### Get some information from the user.
#########################################
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
### Check for some directories
###############################
if [ ! -d "$HOME/$CASE/$DDIR/ipfiles/mdl" ]; then
        mkdir -p $HOME/$CASE/$DDIR/ipfiles/mdl
fi
if [ ! -d "$HOME/$CASE/evidence/ipchecks" ]; then
        mkdir $HOME/$CASE/evidence/ipchecks
fi



echo "We are going to grab information from qthe Malware Domain List for each of our IPs."
wc -l ipfiles/ipv4connections.external.txt
echo "I am going to wait a little bit between each request, so I do not anger any one too much"
cd $HOME/$CASE/$DDIR/ipfiles/mdl;
while read i; do
	echo $i;
	wget http://www.malwaredomainlist.com/mdl.php?search=$i&colsearch=IP&quantity=10
	sleep 4;
	mv mdl.ph* $i.mdl.html
done < $HOME/$CASE/$DDIR/ipfiles/ipv4connections.external.txt
# Let's go and clean things up now.....



