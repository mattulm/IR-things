#/bin/bash
#
# Basic Case creation with Volatility
# Basic Text File Creation with Volatility
#
# By: Matthew Ulm
# Date: May 17'th 2014
#

HOME="/home/sansforensics"
#
# Get the case name from the user
echo " I need to get some information first... "
echo "What is the case name? :"
read CASE
#
# What is the memory file name
echo "What is the memory file name? :"
read FILE

#
# Print soem text to the screen
echo " "
echo " Let me set up soem directories... "

#
# Check for some directories
if [ ! -d "$HOME/$CASE/text" ]; then
	mkdir -p $HOME/$CASE/text
fi
if [ ! -d "$HOME/$CASE/evidence" ]; then
	mkdir -p $HOME/$CASE/evidence
fi

#
# Start the log file
echo " "
echo " I am going to start a log file now. "
echo " " 
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "Today is $(date)" >> $HOME/$CASE/evidence/$CASE.log
echo "What is the investigator name? :"
read NAME
echo "Investigator is $NAME" >> $HOME/$CASE/evidence/$CASE.log
echo "host is $(hostname)" >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo " I ma going to take a hash of the memory now. "
echo " This can take some time depending on the size of the memory. "
echo " It is important for the integrity of the case however. "
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "The file being analyzed is: $HOME/$CASE/$FILE" >> $HOME/$CASE/evidence/$CASE.log
md5sum $HOME/$CASE/$FILE >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log

# Let's figure out what image we are working with
echo " "
echo " Let's take a look at what we might have now. "
vol.py -f $HOME/$CASE/$FILE imageinfo
# Ask the user what they want to use
echo " "
echo "What profile do you want to use for these scans? :"
read PRFL
echo " "

#
# Maybe grab network first so we can start working on that.
if [ $PRFL = "Win7SP1x86" ]; then
        echo " I will know grab the network information.  "
	vol.py -f $HOME/$CASE/$FILE --profile=$PRFL netscan >> $HOME/$CASE/text/netscan.txt
        echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/ipv4address.txt.log
	echo " The netscan file has been created. " >> $HOME/$CASE/evidence/$CASE.log
	echo " " >> $HOME/$CASE/evidence/$CASE.log
	md5sum $HOME/$CASE/text/netscan.txt >> $HOME/$CASE/evidence/$CASE.log
        echo " " >> $HOME/$CASE/evidence/$CASE.log
        echo " I am done with the netscan file. "
elif [ $PRFL = "Win7SP0x86" ]; then
	echo " I will know grab the network information.  "
        vol.py -f $HOME/$CASE/$FILE --profile=$PRFL netscan >> $HOME/$CASE/text/netscan.txt
        echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/ipv4address.txt.log
        echo " The netscan file has been created. " >> $HOME/$CASE/evidence/$CASE.log
        echo " " >> $HOME/$CASE/evidence/$CASE.log
        md5sum $HOME/$CASE/text/netscan.txt >> $HOME/$CASE/evidence/$CASE.log
        echo " " >> $HOME/$CASE/evidence/$CASE.log
	echo " I am done with the netscan file. "
else
        echo "This script can not scan network connections yet for the selected profile"
        echo "Please use the appropriate memory profile script to parse the network date"
fi

echo " "
echo " "
echo " "
echo "Let's make some text files......."
#
# Let's do some process stuff!
cd $HOME/$CASE
process=( pslist psscan pstree psxview )
for i in "${process[@]}"
do
	vol.py -f $HOME/$CASE/$FILE --profile=$PRFL $i > text/$i.txt
	md5sum text/$i.txt >> $HOME/$CASE/evidence/$CASE.log
done

echo " Done with the process modules"
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "Today is $(date)" >> $HOME/$CASE/evidence/$CASE.log
echo "host is $(hostname)" >> $HOME/$CASE/evidence/$CASE.log
echo "The file being analyzed is: $FILE" >> $HOME/$CASE/evidence/$CASE.log
md5sum $HOME/$CASE/$FILE >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log

#
# EOF
