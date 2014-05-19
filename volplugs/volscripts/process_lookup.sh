#!/bin/bash
#
#
#
HOME="/home/sansforensics/"
VTSE="/home/sansforensics/vcg/tools/dsvtsearch.py"
# Get the case name from the user
echo "What is the case name? :"
read CASE
# What is the memory file name
echo "What is the memory file name? :"
read FILE

# 
# Checking for these things needs to be written yet.
mkdir -p $HOME/$CASE/evidence
mkdir -p $HOME/$CASE/text

# Add to the log file
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "Today is $(date)" >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "The file being analyzed is: $FILE" >> $HOME/$CASE/evidence/$CASE.log
md5sum $HOME/$CASE/$FILE >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "------------------------------------------------------------" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log
echo "" >> $HOME/$CASE/evidence/$CASE.log

# What is the profile
echo "What is the profile? :"
read PRFL

# Get the process number from the user
echo "What process do you want to look at? :"
read NMBR

#
# Print some stuff to the screen. 
echo " I will know pull some information from the memory sample "
echo " "
# Run the scans on the input files
malware=( apihooks malfind callbacks ldrmodules ssdt )
for i in "${malware[@]}"
do
	echo $i
	vol.py -f $HOME/$CASE/$FILE --profile=$PRFL $i -p $NMBR >> $HOME/$CASE/text/$i.$NMBR.txt
	md5sum text/$m.$NMBR.txt >> $HOME/$CASE/evidence/$CASE.log
done

#
# Print some stuff to the screen.
echo " I am done pulling text based information. "
echo " You can start going through those for pertinent data. "
echo " "
echo " In the meantime I will pull the DLLs for this process. "
echo " and do a similar comparison wiht the process dumper routine "
echo " "


# dump the DLLs for that process
mkdir -p $HOME/$CASE/dlldumps
echo "Dumping the processes DLLs for the selected process"
vol.py -f $HOME/$CASE/$FILE --profile=$PRFL dlldump -p $NMBR -D $HOME/$CASE/dlldumps


#
# First md5sum the DLLs pulled from memroy
cd $HOME/$CASE/dlldumps/
for i in *.dll; do
        md5sum $i >> $HOME/$CASE/dlldumps/dlldump.md5dum.txt;
        done
#
# Now strip the first 32 characters form the first file.
while read -r line; do
        id=$(cut -c-32 <<< "$line");
        echo $id >> $HOME/$CASE/dlldumps/dlldump.md5.stripped.txt;
        done < $HOME/$CASE/dlldumps/dlldump.md5dum.txt
#
# Now sort the file and make sur eonly uniq values remain.
uniq $HOME/$CASE/dlldumps/dlldump.md5.stripped.txt >> $HOME/$CASE/dlldumps/dlldump.uniq.txt
#
# Now compare against Virus Total
#
echo "#"
echo "# I have pulled the DLLs out, ran an MD5sum against each"
echo "# we will now search for these hashed in Virus Total, but first"
echo "# I need you Virus Total API key...? :"
read $APIK
cd $HOME
$VTSE -k $APIK -f $HOME/$CASE/dlldumps/dlldump.md5.stripped.txt
cp $HOME/$CASE/dlldumps/virustotal-search-*.csv $HOME/$CASE/evidence/volatility_dlldumps.csv

# EOF
#
