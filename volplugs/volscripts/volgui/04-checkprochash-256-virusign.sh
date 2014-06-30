#!/bin/bash
#
#
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
#
# This script will create hashes from executables
#
### Get some data from the user
###################################
echo "What is the name of the case? :"
read CASE;
if [ ! -d "$HOME/$CASE" ]; then
        echo "It does not look as if the case has been setup just yet.";
        echo "Please run the correct script first. ";
        echo " ";
        sleep 1;
        exit;
fi


echo "What should I make hashes of? :"
echo " "
echo "Choices: "
echo "  1) procexedump "
echo "  2) procmemdump "
read INSPECT


#
### Check for our hash file. If it exists, then check with VT.
################################################################
if [ $INSPECT == "1" ]; then
        if [ ! -f "$HOME/$CASE/procexedump/procexedump.sha256.stripped.txt" ]; then
                echo "It does not look as if the MD5 hash list is in this directory."
                echo "Please dump the executables, and hash them before running this script."
                echo " "
                cd $HOME;
                exit;
        fi
	cd $HOME/$CASE/procexedump
	mkdir -p virusign
	while read -r line; do
	        wget http://www.virusign.com/details.php?hash=$line -O virusign/$line.sha256.thash.html
	        sleep 1
	done < procexedump.sha256.stripped.txt
elif [ $INSPECT == "2" ]; then
        if [ ! -f "$HOME/$CASE/procmemdump/procmemdump.md5.stripped.txt" ]; then
                echo "It does not look as if the MD5 hash list is in this directory."
                echo "Please dump the executables, and hash them before running this script."
                echo " "
                cd $HOME;
                exit;
        fi
	cd $HOME/$CASE/procmemdump
	mkdir p virusign
        while read -r line; do
                wget http://www.virusign.com/details.php?hash=$line -O virusign/$line.sha256.thash.html
                sleep 1
        done < procmemdump.sha256.stripped.txt
else
        echo "This is unexpected input."
        echo "Please check your data, and re-run this script. "
        echo " "
        echo "Exiting.........."
        sleep 1;
        exit;
fi



#
# EOF

