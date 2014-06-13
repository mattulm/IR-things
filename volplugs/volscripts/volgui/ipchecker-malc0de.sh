#!/bin/bash
#
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
DDIR="text"
FILE="ipchecks"

#
### Get some data from the user.
##################################
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
################################
if [ ! -d "$HOME/$CASE/text/ipfiles/malc0de" ]; then
        mkdir -p $HOME/$CASE/$DDIR/ipfiles/malc0de
fi
if [ ! -d "$HOME/$CASE/evidence/ipchecks" ]; then
        mkdir $HOME/$CASE/evidence/ipchecks
fi


cd $HOME/$CASE/$DDIR
echo "We are going to grab information from the malc0de website for each of our IPs."
wc -l ipfiles/ipv4connections.external.txt
echo " "
echo "I am going to wait a little bit between each request, so I do not "
echo "request to many too quickly, and anger the malc0de folks. "
while read i; do
	# malc0de
        echo " Checking the malc0de database for ..... $i"
	sleep 1;
        wget http://malc0de.com/database/index.php?search=$i -O ipfiles/malc0de/$i.malc0de.html
        sleep 4;
	echo " "
done < ipfiles/ipv4connections.external.txt 



#
# Clean the malcode files up.
echo " Checking the malc0de database files as they are the easiest "
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " Checking the malc0de database files " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
for i in ipfiles/malc0de/*.malc0de.html; do
        if grep -q "yielded no results" $i; then
                echo "$i was not found in the malcode databse. " >> $HOME/$CASE/evidence/$FILE.log
		echo "$i was not found in the malcode databse. "
		echo "I am going to delete the $i file from the drive."
                rm -f $i
		echo " "
        else
                mv $i $HOME/$CASE/evidence/iplookup/;
                echo "$i - positive match in the malcode database. " >> $HOME/$CASE/evidence/$FILE.log
                echo "$i - positive match in the malcode database. "
		echo " "
        fi
done
echo " "
echo " "

#
# EOF
