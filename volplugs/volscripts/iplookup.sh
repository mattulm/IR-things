#!/bin/bash
#
#

FILE="ipv4address.txt"
DIR="text"
HOME="/home/sansforensics"

# Get the file name from the user.
echo "What is the folder name of the investigation?"
read CASE

mkdir -p $HOME/$CASE/$DIR
cd $HOME/$CASE/$DIR/
cat netscan.txt | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | grep -E -v '(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^0.)|(^169\.254\.)' | sort | uniq >> ipv4address.txt

mkdir -p iplookup/virustotal 
mkdir -p iplookup/mdl
mkdir -p iplookup/malc0de
mkdir -p iplookup/exposure


while read i; do
	echo $i;
	wget https://www.virustotal.com/en/ip-address/$i/information/ -O iplookup/virustotal/$i.vt.html
	sleep 5;
	wget http://malc0de.com/database/index.php?search=$i -O iplookup/malc0de/$i.malc0de.html
	sleep 5;
	wget http://exposure.iseclab.org/detection/ip?ip=$i -O iplookup/exposure/$i.exposure.html
	sleep 10;
done < ipv4address.txt

# I need to do some clean up on teh files.
# We can remove the results with no findings.


# these lists are special right now, casue they want to do their own thing.
cd iplookup/mdl
while read i; do
       echo $i;
	wget http://www.malwaredomainlist.com/mdl.php?search=$i&colsearch=IP&quantity=10 
	sleep 10;
done < $HOME/$CASE/$DIR/ipv4address.txt
# Let's go and clean things up now.....



