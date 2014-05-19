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
# Set up some global variables
VOLT="vol.py"
HOME="/home/sansforensics"
VCGT="/home/sansforensics/vcg"
DSVT="/home/sansforensics/vcg/tools/dsvtsearch.py"
#
GTEC="gtechfiles"
THSH="totalhash"
#
# Get some stuff from the user.
# Get the case name from the user
echo "What is the case name? :"
read CASE
#
# What is the memory file name
echo "What is the memory file name? :"
read FILE
#
# Ask the user what they want to use
echo "What profile do you want to use for these scans? :"
read PRFL

#
# Start the log file
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "Today is $(date)" >> $HOME/$CASE/evidence/$CASE.log
echo "host is $(hostname)" >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "The file being analyzed is: $FILE" >> $HOME/$CASE/evidence/$CASE.log
md5sum $HOME/$CASE/$FILE >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo ""
echo ""


#
# Create directories if they do not exist
echo "#"
echo "Making some Directories"
if [ ! -d "$HOME/$CASE/procexedump/$GTEC" ]; then
        mkdir -p $HOME/$CASE/procexedump/$THSH
fi
if [ ! -d "$HOME/$CASE/evidence" ]; then
        mkdir -p $HOME/$CASE/evidence
fi

#
# Dump the processes
echo "# Dump the Executables form memory that we can"
$VOL -f $HOME/$CASE/$FILE --profile=$PRFL procexedump -u -D $HOME/$CASE/procexedump/

#
# First md5sum the executables pulled from memroy
cd $HOME/$CASE/procexedump/
for i in *.exe; do
        md5sum $i >> $HOME/$CASE/procexedump/procexedump.md5dum.txt;
        done
#
# Now strip the first 32 characters form the first file.
while read -r line; do
        id=$(cut -c-32 <<< "$line");
        echo $id >> $HOME/$CASE/procexedump/procexedump.md5.stripped.txt;
        done < $HOME/$CASE/procexedump/procexedump.md5dum.txt
#
# Now sort the file and make sur eonly uniq values remain.
uniq $HOME/$CASE/procexedump/procexedump.md5.stripped.txt >> $HOME/$CASE/procexedump/procexedump.uniq.txt
#
# Now compare against Virus Total
echo "#"
echo "# I have pulled the executables out, ran an MD5sum against each"
echo "# we will now search for these hashed in Virus Total"
python $VTSE -k $APIK -f $HOME/$CASE/procexedump/procexedump.md5.stripped.txt
cp $HOME/$CASE/procexedump/virustotal-search-*.csv $HOME/$CASE/evidence/volatility_proexedump.csv

#
# Now let's take our MD5 hashes and compare them on other sites as well.
# First we will use Open Malware. This iste is a little dated, but we still
# get a hit every once and awhile.
echo "#"
echo "Now going to compare on Open Malware"
while read -r line; do
        wget http://oc.gtisc.gatech.edu:8080/search.cgi?search=$line -O $HOME/$CASE/procexedump/$GTEC/$line.gtech.html
        # sleep for 1 second so not hammering too fast.
        sleep 1
        done < $HOME/$CASE/procexedump/procexedump.md5.stripped.txt
#
# Now go through our downloaded files, and remove any non-return web pages.
cd $GTEC
find -type f -size 885c -delete
# If any files are left, move them to evidence directory
if [ "$(ls -A )" ]; then
        cp $HOME/$CASE/procexedump/$GTEC/*.gtech.html $HOME/$CASE/evidence/
fi
cd ../

#
# Now let's submit to Total Hash. New site for possible use
echo "#"
echo "Now going to compare on Total Hash"
while read -r line; do
        wget http://totalhash.com/search/hash:$line -O $HOME/$CASE/procexedump/$THSH/$line.thash.html
        sleep 1
        done < $HOME/$CASE/procexedump/procexedump.md5.stripped.txt
# Now remvoe our downloaded files, and return any non-return web pages.
cd $THSH
find -type f -size -11334c -delete
find -type f -size -11493c -delete
# If there are any files left, move to our evidence directory
if [ "$(ls -A )" ]; then
        cp $HOME/$CASE/procexedump/$THSH/*.thash.html $HOME/$CASE/evidence/
fi
cd ../
