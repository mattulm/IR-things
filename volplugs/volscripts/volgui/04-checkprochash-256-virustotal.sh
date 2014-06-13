#!/bin/bash
#
# Set up some global variables
VOL="vol.py"
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
VTSE="/home/sansforensics/volgui/tools/dsvtsearch.py"
#
# Get some data from the user
echo "What is the name of the case? :"
read CASE;
if [ ! -d "$HOME/$CASE" ]; then
        echo "It does not look as if the case has been setup just yet.";
        echo "Please run the correct script first. ";
        echo " ";
        sleep 1;
        exit;
fi
# Get the Virus Total API Key from the User.
echo "What is your API Key for VT? :"
read APIK
# Get the hashes that you would like to check.
echo "What set of hashes would you like me to check against Virus Total? :"
echo "Choices: (1/2)"
echo "  1) procexedump "
echo "  2) procmemdump "
echo " "
read INSPECT;


#
### Check for our hash file. If it exists, then check with VT.
################################################################
if [ $INSPECT == "1" ]; then
	cd $HOME/$CASE/procexedump
	if [ ! -f "procexedump.sha256.stripped.txt" ]; then
		echo "It does not look as if the master hash list is in this directory."
		echo "Please dump the executables, and hash them before running this script."
		echo " "
		cd $HOME;
		exit;
	fi
	python $VTSE -k $APIK -f procexedump.sha256.stripped.txt
elif [ $INSPECT == "2" ]; then
        cd $HOME/$CASE/procmemdump
        if [ ! -f "procmemdump.sha256.stripped.txt" ]; then
                echo "It does not look as if the master hash list is in this directory."
                echo "Please dump the executables, and hash them before running this script."
                echo " "
		cd $HOME;
                exit;
        fi
	python $VTSE -k $APIK -f $HOME/$CASE/procmemdump/procmemdump.sha256.stripped.txt
else
	echo "This is unexpected input."
	echo "Please check your data, and re-run this script. "
	echo " "
	echo "Exiting.........."
	sleep 1;
	cd $HOME;
	exit;
fi

#
# EOF
