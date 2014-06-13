#!/bin/bash
#
# This script will dump the executables from a memory image, and run a hash on these
# files. It will then compare those hashes to a series of online databases to determine
# if the executable is malicious or not.
#
# At this time three online engines are used by this script. They are:
# 1. VirusTotal.com
# 2. Open Malware from Georgia Tech
# 3. Total Hash.
#
#
### Set up some global variables
##################################
VOL="vol.py"
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"


#
### Message to the user.
###########################
echo " "
echo "Hello, and welcome to the process dumper script. This script will dump"
echo "all of the processes from a memory image in the menner a user chooses."
echo "It will only dump the full processes, and not sectrions, DLLs, or any "
echo "other protion of the process."
echo " "

#
### Gather some info from the user.
######################################
echo "What is the name of the case? :"
read CASE;
if [ ! -d "$HOME/$CASE" ]; then
	echo "It does not look as if the case has been setup just yet.";
	echo "Please run the correct script first. ";
	echo " ";
	sleep 1;
	exit;
fi
echo "What is the name fo the file? :"
read FILE
if [ ! -f "$HOME/$CASE/$FILE" ]; then
        echo "It does not look as if the file is in the correct location.";
        echo "Please check that your submitted information is correct. ";
        echo " ";
        sleep 1;
        exit;
fi
echo "Do you know what profile to use on this memory sample? (y/n):" 
read RESP;
case $RESP in
        y|Y )   echo" OK, then......"
                echo "What profile would you like to use? :"
                read PRFL;
                echo " ";;
        n|N )   echo " "
                echo " Let's run our imageinfo module and take a look at what we might have now. "
                vol.py -f $HOME/$CASE/$FILE imageinfo
                # Ask the user what they want to use
                echo "What profile do you want to use for these scans? :"
                read PRFL
                echo " ";;
        * )     echo " ";
                echo "That is unexpected input";
                echo "Stopping"
                exit;;
esac




#
### Look for some directories to make sure that they exist.
### Create thos directories if they do not exist.
###########################################################
procdump=(procexedump procmemdump);
echo "Checking for some directories, and making them if they do not exist."
for i in "${procdump[@]}"; do
	if [ ! -d "$HOME/$CASE/$i" ]; then
        	mkdir $HOME/$CASE/$i
	else
		echo "It seems as if the $i directory exists. "
		echo " "
	fi
done;


#
### Let's dump the processes the user wants to now.
### In the manner that they want to dump them.
########################################################
echo "What sort of Process Dump would you like to perform? :"
echo "Choices: (1/2)"
echo "  1) EXE dump"
echo "  2) MEM dump"
echo " "
read MTHD
if [ "$MTHD" == "1" ]; then
        mkdir -p $HOME/$CASE/procexedump
     	echo "# Dump the Executables form memory that we can"
	$VOL -f $HOME/$CASE/$FILE --profile=$PRFL procexedump -u -D $HOME/$CASE/procexedump
elif [ "$MTHD" == "2" ]; then
        mkdir -p $HOME/$CASE/procmemdump
        echo "# Dump the Executables form memory that we can"
        $VOL -f $HOME/$CASE/$FILE --profile=$PRFL procexedump -u -D $HOME/$CASE/procexedump/
else
        echo "That is not the correct input......"
        sleep 1;
        echo "Exiting ....."
	exit;
fi

echo "Script completed."
echo "Exiting........"


#
# EOF
