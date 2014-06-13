#!/bin/bash
#
# Set up some global variables
VOL="vol.py"
RDIR="/home/sansforensics"
HOME="/home/sansforensics/Desktop/cases"
VTSE="/home/sansforensics/volgui/tools/dsvtsearch.py"
#
# Get some data frmo the user
echo "What is the name of the case"
read CASE

echo "What is your API Key for VT? :"
read APIK


python $VTSE -k $APIK -f $HOME/$CASE/procexedump/procexedump.hashes.txt
cp $HOME/$CASE/procexedump/virustotal-search-*.csv $HOME/$CASE/evidence/volatility_proexedump.csv
