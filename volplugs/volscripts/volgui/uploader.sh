#!/bin/bash
#
# Set up some global variables
VOL="vol.py"
HOME="/home/sansforensics"
VTSS="/home/sansforensics/volgui/tools/dsvtsubmit.py"
#
# Need to read in the config file here
# For now we will statically

#
# Get info from the user
# Get the case name from the user
echo "What is the case name? :"
read CASE
#
# What is the memory file name
echo "What is the memory file name? :"
read FILE


cd $HOME/$CASE/procexedump/

for i in *.exe; do
	echo $i >> filelist.txt
done

#
# Get more info from user
echo "What is your API Key for VT? :"
read APIK
python $VTSS -k $APIK -f $HOME/$CASE/procexedump/filelist.txt
