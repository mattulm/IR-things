#/bin/bash
#
# Basic Case creation with Volatility
# Basic Text File Creation with Volatility
#
# By: Matthew Ulm
# Date: May 17'th 2014
#
# First version finished"
# Date:
#
### Set some variables
##########################
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
VOL="vol.py"

#
### Get some information from the user.
#######################################
#
# Get the case name.
echo "I need to get some information first... "
echo " ";
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
# What is the memory file name
echo "What is the memory file name? :"
read FILE
if [ ! -f "$HOME/$CASE/$FILE" ]; then
        echo "It does not look as if the file you gave me is in the right place.";
        echo "Please make sure the file is in this location.";
	echo "$HOME/$CASE";
        mkdir -p $HOME/$CASE
        echo " ";
        sleep 1;
	exit;
fi


#
### Print some text to the screen.
###################################
echo " "
echo " Let me set up some directories... "
#
# Check for some directories
setupdir=( text evidence procexedump procmemdump malfind dlldump regkeys )
for i in "${setupdir[@]}"; do
	if [ ! -d "$HOME/$CASE/$i" ]; then
		mkdir -p $HOME/$CASE/$i
		echo "I have created the $i directory. "
	else
		echo "Are you sure you have not run some of the other scripts on this"
		echo "memory file before? I see the $i directory already present "
		echo "in this case file. "
		echo " "
	fi
done
echo "I have finished setting up the directories for the investigation. ";
echo " "


#
### Start the log file
#######################
if [ ! -f "$HOME/$CASE/evidence/$CASE.log" ]; then
	echo " I am going to start a log file now. "
	echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
	echo "Today is $(date)" >> $HOME/$CASE/evidence/$CASE.log
	echo "What is the investigator name? :"
	read NAME
	echo "Investigator is $NAME" >> $HOME/$CASE/evidence/$CASE.log
	echo "Investigator host is $(hostname)" >> $HOME/$CASE/evidence/$CASE.log
	echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
	echo " "
else
	echo "It appears as if the case file has already been created for this "
	echo " "
	echo "Has the investigator changed? (y/n): "
	read CHANGED;
	if [ $CHANGED == "y" ]; then
		echo "What is the name of the new investigator? :";
	        read NAME
	        echo "Investigator is $NAME" >> $HOME/$CASE/evidence/$CASE.log
	        echo "Investigator host is $(hostname)" >> $HOME/$CASE/evidence/$CASE.log
	        echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
	        echo " "
	elif [ $CHANGED == "n" ]; then
		echo "OK, I am going to move on now to other portions of the file";
	else
		echo "That is unexpected input.";
		echo "Exiting......."
		sleep 1;
		exit;
	fi
 
fi


#
### Hash the memory file
#########################
echo " I ma going to take an MD5 hash of the memory now. "
echo " This can take some time depending on the size of the memory. "
echo " It is important for the integrity of the case however. "
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "The file being analyzed is: $HOME/$CASE/$FILE" >> $HOME/$CASE/evidence/$CASE.log
md5sum $HOME/$CASE/$FILE >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log
echo " "


#
### Let's figure out what image we are working with.
### Ask the user if they know what profile to use.
### Find out for them if they do not know.
###########################################################
echo "One last bit of information is needed......"
echo "Do you know what profile to use on this memory sample? (y/n):"
read RESP
case $RESP in
	y|Y )	echo" OK, then......"
        	echo "What profile would you like to use? :"
        	read PRFL;
        	echo " ";;
	n|N )	echo " "
		echo " Let's run our imageinfo module and take a look at what we might have now. "
		vol.py -f $HOME/$CASE/$FILE imageinfo
		# Ask the user what they want to use
		echo "What profile do you want to use for these scans? :"
		read PRFL
		echo " ";;
	* ) 	echo " ";
		echo "That is unexpected input";
		echo "Stopping"
		exit;;
esac
echo " "


#
### Start with some basic text files and scans of the memory
### Grab network first so we can start working on that seperatly.
###################################################################
cd $HOME/$CASE
echo "At this time, this script can only perform the netscan operation on Windows 7"
echo "I will add other profiles at a later time as is needed. "
if [ $PRFL = "Win7SP1x86" ]; then
        echo " I will know grab the network information.  "
	        if [ ! -f "$HOME/$CASE/text/netscan.txt" ]; then
    	        	vol.py -f $FILE --profile=$PRFL netscan > text/netscan.txt
                	echo "I have just run the netscan module."
                	md5sum text/netscan.txt >> evidence/$CASE.log
                	echo " ";
        	else
                	echo "It looks as if the netscan module has already been run."
                	echo "I am skipping this step for now. "
                	sleep 1;
                	echo " ";
        	fi
elif [ $PRFL = "Win7SP0x86" ]; then
	echo " I will know grab the network information.  "
                if [ ! -f "$HOME/$CASE/text/netscan.txt" ]; then
                        vol.py -f $FILE --profile=$PRFL netscan > text/netscan.txt
                        echo "I have just run the netscan module."
                        md5sum text/netscan.txt >> evidence/$CASE.log
                        echo "I am done with the netscan file. ";
			echo " "
                else
                        echo "It looks as if the netscan module has already been run."
                        echo "I am skipping this step for now. "
                        sleep 1;
                        echo " ";
                fi
else
        echo "This script can not scan network connections yet for the selected profile"
        echo "Please use the appropriate memory profile script to parse the network date"
fi
echo " "


#
### Let's do our process scans to get started on our analysis
##############################################################
echo "Let's make some text files......."
cd $HOME/$CASE
process=( pslist psscan pstree psxview )
for i in "${process[@]}"; do
	if [ ! -f "text/$i.txt" ]; then
		$VOL -f $FILE --profile=$PRFL $i > text/$i.txt
		echo "I have just run the $i module."
                echo "I have just run the $i module." >> $HOME/$CASE/evidence/$CASE.log
		md5sum text/$i.txt >> evidence/$CASE.log
		echo " ";
	else 
		echo "It looks as if the $i modules was already run."
		echo "I am skipping this step for now. "
		sleep 1;
		echo " ";
	fi
done
echo " Done with the process modules"
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo " " >> $HOME/$CASE/evidence/$CASE.log


#
# EOF
