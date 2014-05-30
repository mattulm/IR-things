#!/bin/bash
#
#
# This script is going to do some low level network investigation.
# It is not intended to do a hard core dive into the memory at this tim.
#
# M. Ulm
# May 17'th 2014
#

FILE="ipv4address.txt"
DIR="text"
HOME="/home/sansforensics"

# Get the case name from the user.
echo "What is the case name? :"
read CASE

# Print some stuff to a log.
echo "" >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo "Today is $(date)" >> $HOME/$CASE/evidence/$FILE.log
echo "" >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FIL.log
echo "" >> $HOME/$CASE/evidence/$FILE.log
# Print some stuff to the screen.
echo " I will now parse the netscan.txt file "
echo " ..... "

# parse the output of the netscan file and only grab ip addresses.
# I need to write in a check for the file still.
mkdir -p $HOME/$CASE/$DIR
cd $HOME/$CASE/$DIR/
cat netscan.txt | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | grep -E -v '(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^0.)|(^169\.254\.)' | sort | uniq >> ipv4address.txt

echo " "
wc -l ipv4address.txt
echo " this is the number of unique addresses "
echo " "
wc -l ipv4address.txt >> $HOME/$CASE/evidence/$FILE.log
echo " this is the number of unique addresses " >> $HOME/$CASE/evidence/$FILE.log
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " " >> $HOME/$CASE/evidence/$FILE.log


#
# Check for some directories
if [ ! -d "$HOME/$CASE/$DIR/iplookup/virustotal" ]; then
        mkdir -p $HOME/$CASE/$DIR/iplookup/virustotal
fi
if [ ! -d "$HOME/$CASE/$DIR/iplookup/mdl" ]; then
        mkdir -p $HOME/$CASE/$DIR/text/iplookup/mdl
fi
if [ ! -d "$HOME/$CASE/$DIR/iplookup/malc0de" ]; then
        mkdir -p $HOME/$CASE/$DIR/iplookup/malc0de
fi
if [ ! -d "$HOME/$CASE/$DIR/iplookup/exposure" ]; then
        mkdir -p $HOME/$CASE/$DIR/iplookup/exposure
fi

#
# fetch a few thigns from the internet.
echo " I will know grab some things from the internet "
echo " As you see the ip address on the screen, that is what I am "
echo " currently looking up. "
# try hashing the ip addresses, and then using the didier stevens tool for VT check.
while read i; do
	echo $i;
	# Virus Total
	echo " Checking Virus Total....."
	wget https://www.virustotal.com/en/ip-address/$i/information/ -O $HOME/$CASE/$DIR/iplookup/virustotal/$i.vt.html
	sleep 7;
	# malc0de
	echo " Checking the malc0de database....."
	wget http://malc0de.com/database/index.php?search=$i -O $HOME/$CASE/$DIR/iplookup/malc0de/$i.malc0de.html
	sleep 7;
	# ISEC exposure
	echo " Checking the ISEC exposure database....."
	wget http://exposure.iseclab.org/detection/ip?ip=$i -O $HOME/$CASE/$DIR/iplookup/exposure/$i.exposure.html
	sleep 7;
done < ipv4address.txt


#
# Print some stuff to a log.
echo "" >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " Completed First round of Internet checks of netsacn output. " >> $HOME/$CASE/evidence/$FILE.log
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " Sites check include: " >> $HOME/$CASE/evidence/$FILE.log
echo "	1. Virus Total " >> $HOME/$CASE/evidence/$FILE.log
echo "	2. malc0de " >> $HOME/$CASE/evidence/$FILE.log
echo " 	3. ISEC Labs Exposure " >> $HOME/$CASE/evidence/$FILE.log
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
#
# Print some stuff to the screen.
echo " Done with the internet for now..... "
echo " Let me try and clean a few things up."
echo " ..... "
echo " "

#
# Check for some directories
if [ ! -d "$HOME/$CASE/evidence/iplookup" ]; then
        mkdir -p $HOME/$CASE/evidence/iplookup
fi
#
# I need to do some clean up on the files.
# We can remove the results with no findings.

#
# Clean the malcode files up.
echo " Checking the malc0de database files as they are the easiest "
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " Checking the malc0de database files " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
for i in $HOME/$CASE/$DIR/iplookup/malc0de/*.malc0de.html; do
	if grep -q "yielded no results" $i; then
		echo "$i was not found in the malcode databse. "; >> $HOME/$CASE/evidence/$FILE.log
		# rm -f $i
	else 
		mv $i $HOME/$CASE/evidence/iplookup/;
		echo "$i - positive match in the malcode database. "; >> $HOME/$CASE/evidence/$FILE.log
	fi
done
echo " "
echo " "

# No results!
# Clean up the ISEC Exposure files.
echo " Checking the ISEC Exposure database files "
echo " These are also pretty easy "
echo " " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
echo " Checking the ISEC Exposure database files " >> $HOME/$CASE/evidence/$FILE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$FILE.log
for i in $HOME/$CASE/$DIR/iplookup/malc0de/*.exposure.html; do
        if grep -q ">No results!" $i; then
                echo "$i was not found in the ISEC Exposure databse. "
                echo "$i was not found in the ISEC Exposure databse. " >> $HOME/$CASE/evidence/$FILE.log
                # rm -f $i
        else
                mv $i $HOME/$CASE/evidence/iplookup/;
		echo "$i - positive match in the ISEC Exposure database. "
                echo "$i - positive match in the ISEC Exposure database. " >> $HOME/$CASE/evidence/$FILE.log
        fi
done
echo " "
echo " "


#
# TAR up the un-needed files. Move back to home afterwards.
echo "Archive the malcode files."
cd $HOME/$CASE/text/iplookup/
tar zcf malc0de.tgz malc0de/
rm -rf malc0de/
cd $HOME

#
# Clean up the ISEC exposure files
cd $HOME/$CASE/text/iplookup/
tar zcf exposure.tgz exposure/
rm -rf exposure/
cd $HOME

#
# Check some of the virus total files
echo " checking the Virus Total files "
echo " "
sleep 2;
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
for i in $HOME/$CASE/$DIR/iplookup/malc0de/*.exposure.html; do
        if grep -q "VirusTotal has never resolved any domain name" $i; then
                echo "$i - VirusTotal has never resolved any domain name "; >> $HOME/$CASE/evidence/$FILE.log
		echo " I will remove the following file - $i "
		echo " VirusTotal has never resolved any domain name for this IP "
                rm -f $i
        fi
done
echo " "
echo " "




#
# Print some text to the screen.
echo " "
echo " OK a few mroe things from the internet."
echo " ..... "

#
# these lists are special right now, casue they want to do their own thing.
cd $HOME/$CASE/text;
cd iplookup/mdl;
while read i; do
       echo $i;
	wget http://www.malwaredomainlist.com/mdl.php?search=$i&colsearch=IP&quantity=10 
	sleep 7;
	mv mdl.* $HOME/$CASE/$DIR/text/iplookup/mdl/$i.mdl.html
done < $HOME/$CASE/$DIR/ipv4address.txt
# Let's go and clean things up now.....


