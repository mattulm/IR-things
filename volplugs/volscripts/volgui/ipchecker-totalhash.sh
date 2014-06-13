#!/bin/bash
#
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
DDIR="text"
FILE="ipchecks"

#
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
if [ ! -d "$HOME/$CASE/$DDIR/ipfiles/totalhash" ]; then
        mkdir -p $HOME/$CASE/$DDIR/ipfiles/totalhash
fi
if [ ! -d "$HOME/$CASE/evidence/ipchecks" ]; then
	mkdir $HOME/$CASE/evidence/ipchecks
fi

cd $HOME/$CASE/$DDIR
echo "We are going to grab information from the Totalhash db for each our IPs."
echo "I am going to wait a little bit between each request, so I do not "
echo "request too many too quickly, and anger the Team Cymru folks. "
while read i; do
	# Team Cymru
        echo "..... Checking the Totalhash database from Team Cymru ..... $i"
	wget http://totalhash.com/search/ip:$i -O ipfiles/totalhash/$i.md5.thash.html
        sleep 5;
	echo " "
done < ipfiles/ipv4connections.external.txt 


# Clean up the ISEC Exposure files.
echo " Checking the ISEC Exposure database files "
echo " These are also pretty easy "
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " Checking the ISEC Exposure database files " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
for i in ipfiles/totalhash/*.md5.thash.html; do
        if grep -q "0 of 0 results" $i; then
                echo "$i was not found in the Totalhash database. "
                echo "$i was not found in the Totalhash database. " >> $HOME/$CASE/evidence/$FILE.log
                echo "I am going to delete $i from the drive. "
		rm -f $i
		echo " "
        else
                mv $i $HOME/$CASE/evidence/ipchecks/;
                echo "$i - positive match in the Totalhash database. "
                echo "$i - positive match in the ISEC Exposure database. " >> $HOME/$CASE/evidence/$FILE.log
		echo " "
        fi
done
echo " "


#
# EOF
