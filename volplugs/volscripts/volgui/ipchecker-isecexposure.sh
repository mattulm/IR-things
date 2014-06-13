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
if [ ! -d "$HOME/$CASE/$DDIR/ipfiles/exposure" ]; then
        mkdir -p $HOME/$CASE/$DDIR/ipfiles/exposure
fi
if [ ! -d "$HOME/$CASE/evidence/ipchecks" ]; then
        mkdir $HOME/$CASE/evidence/ipchecks
fi


cd $HOME/$CASE/$DDIR
echo "We are going to grab information from the ISEC database for each our IPs."
wc -l ipfiles/ipv4connections.external.txt
echo " "
echo "I am going to wait a little bit between each request, so I do not "
echo "request to many too quickly, and anger the ISEC folks. "
while read i; do
	# ISEC exposure
        echo " Checking the ISEC exposure database..... $i"
	wget http://exposure.iseclab.org/detection/ip?ip=$i -O ipfiles/exposure/$i.exposure.html
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
for i in ipfiles/exposure/*.exposure.html; do
        if grep -q ">No results!" $i; then
                echo "$i was not found in the ISEC Exposure database. "
                echo "$i was not found in the ISEC Exposure database. " >> $HOME/$CASE/evidence/$FILE.log
                echo "I am going to delete $i from the drive. "
		rm -f $i
		echo " "
        else
                mv $i $HOME/$CASE/evidence/iplookup/;
                echo "$i - positive match in the ISEC Exposure database. "
		echo "This is actually quite rare!"
		echo " "
                echo "$i - positive match in the ISEC Exposure database. " >> $HOME/$CASE/evidence/$FILE.log
		echo " "

        fi
done
echo " "
echo " "

#
# EOF
