#!/bin/bash
#
#
# This script is going to do some low level network investigation.
# It is not intended to do a hard core dive into the memory at this tim.
#
# M. Ulm
# May 17'th 2014
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"

# Get the case name from the user.
echo "What is the case name? :"
read CASE
if [ ! -d "$HOME/$CASE" ]; then
        echo "It does not look as if the case has been setup just yet.";
        echo "I will create the necessary case directory. ";
        mkdir -p $HOME/$CASE
        echo " ";
        sleep 1;
fi


#
### Check for some directories and some files.
#################################################
if [ ! -f "$HOME/$CASE/text/netscan.txt" ]; then
	echo "It looks like the netscan file has not been run. "
	echo "Please go back and run the textfiles script first. " 	
        echo " ";
	sleep 1;
	exit;
fi
cd $HOME/$CASE/text;
if [ ! -d "$HOME/$CASE/text/ipfiles" ]; then
        mkdir -p ipfiles
        echo " ";
fi



#
### Parse the netscan file for only IPv4 addresses.
######################################################
if [ ! -f "ipfiles/ipv4connections.txt" ]; then
	cat netscan.txt | grep -E -o '(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)' | sort | uniq >> ipfiles/ipv4connections.txt
	echo "This is the number of unique addresses from the netscan file."
	wc -l ipfiles/ipv4connections.txt
	echo " "
	echo "Number of unique addresses from the netscan file." >> $HOME/$CASE/evidence/$CASE.log
	wc -l ipfiles/ipv4connections.txt >> $HOME/$CASE/evidence/$CASE.log
	md5sum ipfiles/ipv4connections.txt >> $HOME/$CASE/evidence/$CASE.log
        echo " " >> $HOME/$CASE/evidence/$CASE.log
        echo "--------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
        echo " " >> $HOME/$CASE/evidence/$CASE.log
else
	echo "It seems as if the netscan file has already been parsed for IPv4 addresses. "
	echo "I will move on to other checks. "
	echo " "
fi
sleep 1;


#
### Sort the file for only external IPv4 addresses, and then remove duplicates.
################################################################################
if [ ! -f "ipfiles/ipv4connections.external.txt" ]; then
	cat ipfiles/ipv4connections.txt | grep -E -v '(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^0.)|(^169\.254\.)' | sort | uniq >> ipfiles/ipv4connections.external.txt
	echo "This is the number of unique external addresses from the netscan file. "
	wc -l ipfiles/ipv4connections.external.txt;
	echo "Number of unique external addresses from the netscan file. " >> $HOME/$CASE/evidence/$CASE.log
	wc -l ipfiles/ipv4connections.external.txt >> $HOME/$CASE/evidence/$CASE.log
	md5sum ipfiles/ipv4connections.external.txt >> $HOME/$CASE/evidence/$CASE.log
	echo " " >> $HOME/$CASE/evidence/$CASE.log
	echo "--------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
	echo " " >> $HOME/$CASE/evidence/$CASE.log
else
        echo "It seems as if the ipv4 file has already been parsed for external IPs. "
        echo "I will move on to other checks. "
        echo " "
fi


#
#
### Let's take a whois of each IP address.
############################################
echo "Would you like to run a whois now on the external IPs? (y/n):"
read WHOIS
if [ $WHOIS == "y" ]; then
	mkdir -p $HOME/$CASE/text/ipfiles/whois
	while read i; do
        	echo "Checking Whois for..... $i"
        	whois $i >> ipfiles/whois/$i.whois.txt
        	wget http://who.is/whois-ip/ip-address/$i -O ipfiles/whois/$i.whois.html
		echo " "
	done < ipfiles/ipv4connections.external.txt
elif [ $WHOIS == "n" ]; then
	echo "I will not run a whois on these IPs. "
	echo "I will now exit. "
	echo " "
else
	echo "That is un-expected input."
	echo "Exiting ........"
	sleep 1;
	exit;
fi
cd $HOME/$CASE;


#
# EOF
