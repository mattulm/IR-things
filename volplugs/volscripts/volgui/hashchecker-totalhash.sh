#!/bin/bash
#
#

#
### Get some information from the user.
#########################################
echo "What is the case name? :"
read CASE

echo "What hashes am I going to check? :"
echo " "
echo "Choices: "
echo "  1) procexedump "
echo "  2) procmemdump "
echo " "
echo " .?"
read ANS1

# assign DDIR variable

# Create some directories

#
# Now let's submit to Total Hash. New site for possible use
echo " "
echo "Now going to compare on Total Hash"
while read -r line; do
        wget http://totalhash.com/search/hash:$line -O $HOME/$CASE/$DDIR/$THSH/$line.thash.html
        sleep 1
        done < $HOME/$CASE/$DDIR/$DDIR.hashes.txt
# Now remvoe our downloaded files, and return any non-return web pages.
cd $THSH

# Here is the string to delete files from: "of 0 results"

# If there are any files left, move to our evidence directory
if [ "$(ls -A )" ]; then
        cp $HOME/$CASE/procexedump/$THSH/*.thash.html $HOME/$CASE/evidence/
fi

