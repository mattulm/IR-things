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
read TDIR
EXTN="exe"
echo " ";
if [ "$TDIR" == "1" ]; then
	TRGT="$HOME/$CASE/procexedump"
	DDIR="procexedump"
       	if [ ! -d "$HOME/$CASE/procexedump" ]; then
       	        echo "The Procexedump folder does not exist. "
		echo "Please run the dumper script first. "
       	fi
elif [ "$TDIR" == "2" ]; then
	TRGT="$HOME/$CASE/procmemdump"
	DDIR="procmemdump"
        if [ ! -d "$HOME/$CASE/procmemdump" ]; then
                echo "The Procmemdump folder does not exist. "
                echo "Please run the dumper script first. "
		echo " ";
		exit;
        fi
else
	echo "That is not the correct input......"
	sleep 1;
	echo "Exiting ....."
	exit;
fi
cd $TRGT


#
### Now move into the directory we are going to create hashes for.
#######################################################################
# Check for the files first.
hasheslist=( md5sum sha1sum sha256 )
for i in "${hasheslist[@]}"; do
	if [ -f "$DDIR.$i.txt" ]; then
		echo "The $i hashes already exists in this directory."
		echo "It looks like this script has already been run."
		echo " "
		sleep 1;
	fi
done
# If we are all good create some hashes
for i in *.$EXTN; do
        md5sum $i >> $DDIR.md5sum.txt;
	sha1sum $i >> $DDIR.sha1sum.txt;        
	sha256sum $i >> $DDIR.sha256.txt;
done


#
### Create a single file list for uploads later if it is required.
#######################################################################
if [ ! -f $DDIR.filelist.txt ]; then
	for i in *.exe; do
        	echo $i >> filelist.txt
	done
	cat filelist.txt | sort | uniq >> $DDIR.filelist.txt;
else
	echo "It seems as if the filelist has already been created. ";
fi


#
echo " ";
echo "Now stripping the original files to only grab the hashes"
# MD5 hashes now
if [ ! -f "$DDIR.md5.stripped.txt" ]; then
	while read -r line; do
        	id=$(cut -c-32 <<< "$line");
        	echo $id > $DDIR.md5.stripped.txt
	done < $DDIR.md5sum.txt;
else
	echo "It seems the $DDIR.md5sum.txt has already been stripped. "
	echo " "
fi
# SHA1 now
if [ ! -f "$DDIR.sha1.stripped.txt" ]; then
	while read -r line; do
        	id=$(cut -c-40 <<< "$line");
        	echo $id > $DDIR.sha1.stripped.txt
	done < $DDIR.sha1sum.txt;
else
	echo "It seems the $DDIR.sha1sum.txt has already been stripped. "
	echo " "
fi
# SHA256 now
if [ ! -f "$DDIR.sha256.stripped.txt" ]; then
	while read -r line; do
        	id=$(cut -c-64 <<< "$line");
        	echo $id > $DDIR.sha256.stripped.txt
	done < $DDIR.sha256.txt;
else
	echo "It seems the $DDIR.sha256.txt has already been stripped. ";
fi


#
### Organize and sort the result files.
##########################################
# Create an array
sorttype=( temp sorted hashes ) 
for i in "${sorttype[@]}"; do
        if [ -f "$DDIR.$i.txt" ]; then
                echo "The $DDIR.$i.txt file already exists in this directory."
                echo "It looks like this script has already been run at least once."
                echo "I can continue to run but I will overwrite any existing files "
		echo "that exist in this directory."
		echo "Should I continue? (y/n)" 
		read RESP;
		case $RESP in
        		y|Y )  	echo "OK, then......"
				echo " ";;
			n|N )	echo "I will now stop and exit. "
				exit;;
        		* )     echo " ";
                		echo "That is unexpected input";
                		echo "Stopping!"
                		exit;;
		esac
        fi
done
for i in "${sorttype[@]}"; do
	rm -f $DDIR.$i.txt
done
echo "I know will merge all of the stripped files together"
cat $DDIR.md5.stripped.txt > $DDIR.temp.txt
cat $DDIR.sha1.stripped.txt > $DDIR.temp.txt
cat $DDIR.sha256.stripped.txt > $DDIR.temp.txt
echo " "
echo " I will know sort the file and check to make sure everythin is unique"
sort $DDIR.temp.txt > $DDIR.sorted.txt
uniq $DDIR.sorted.txt > $DDIR.hashes.txt

echo " I am now done and will exit "

#
# EOF
