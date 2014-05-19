#!/bin/bash
#
#
#

# Just some basic strings stuff
#
# Get some info frmo the user.
echo " What is the case name? "
read CASE
echo " "
echo " WHat is the memory file name? :"
read FILE
echo " "

#Create directories if they do not exist
echo "#"
echo "Making some Directories"
if [ ! -d "$HOME/$CASE/text/strings" ]; then

#
# Print some text to the screen.
echo " I ma going to take a hash of the memory now."
echo " This can take some time depending on the size of the memory."
echo " It is important for the integrity of the case however."
#
# Start the log file
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "Today is $(date)" >> $HOME/$CASE/evidence/$CASE.log
echo "The file being analyzed is: $FILE" >> $HOME/$CASE/evidence/$CASE.log
md5sum $HOME/$CASE/$FILE >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo ""
echo ""
fi


echo " I will know run strings agains the memory file. "
echo " This can take some time depending on the size of the memroy file. "
echo " "
strings $HOME/$CASE/$FILE >> $HOME/$CASE/text/strings/$FILE.strings.txt

#
# EOF

