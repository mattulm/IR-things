#!/bin/bash
#

# This script will create hashes from executables
# or other files dumped by volatility

# 
# Get some data from the user
echo "What is the name of the case? :"
read CASE

echo "What should I make hashes of? :"
echo " "
echo "Choices: "
echo "  1) procexedump "
echo "  2) procmemdump "
read TDIR
TEXT="exe"


if [ "$TDIR" == "1" ]; then
	TRGT="/home/sansforensics/Desktop/cases/$CASE/procexedump"
	DDIR="procexedump"
elif [ "$TDIR" == "2" ]; then
	TRGT="/home/sansforensics/Desktop/cases/$CASE/procmemdump"
	DDIR="procmemdump"
else
	echo "That is not the correct input......"
	sleep 5;
	echo "Exiting ....."
fi

#
# Now move into the directory we are going to create hashes for.
cd $TRGT
# now create some hashes
for i in *.exe; do
        md5sum $i >> $DDIR.md5sum.txt;
	sha1sum $i >> $DDIR.sha1sum.txt;        
	sha256sum $i >> $DDIR.sha256.txt;
done
#
# Create a single file list for uploads later
# if it is required.
for i in *.exe; do
        echo $i >> $DDIR.filelist.txt
done



echo "Now stripping the original files to only grab the hashes"
# MD5 hashes now
while read -r line; do
        id=$(cut -c-32 <<< "$line");
        echo $id >> $DDIR.md5.stripped.txt
done < $DDIR.md5sum.txt;
# SHA1 now
while read -r line; do
        id=$(cut -c-40 <<< "$line");
        echo $id >> $DDIR.sha1.stripped.txt
done < $DDIR.sha1sum.txt;
# SHA256 now
while read -r line; do
        id=$(cut -c-64 <<< "$line");
        echo $id >> $DDIR.sha256.stripped.txt
done < $DDIR.sha256.txt;

echo "I know will merge all of those together"
cat $DDIR.md5.stripped.txt >> $DDIR.temp.txt
cat $DDIR.sha1.stripped.txt >> $DDIR.temp.txt
cat $DDIR.sha256.stripped.txt >> $DDIR.temp.txt

echo " I will know sort the file and check to make sure everythin is unique"
sort $DDIR.temp.txt >> $DDIR.sorted.txt
uniq $DDIR.sorted.txt >> $DDIR.hashes.txt

echo " I am now done and will exit "
