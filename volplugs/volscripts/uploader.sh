#!/bin/bash
#
# Set up some global variables
VOL="vol.py"
HOME="/home/sansforensics"
VTSE="/home/sansforensics/tools/dsvtsearch.py"
VTSS="/home/sansforensics/tools/dsvtsubmit.py"
GTEC="gtechfiles"
THSH="totalhash"
#
# Need to read in the config file here
# For now we will statically
FILE="PhysicalMemory_CAF6AADD110CEB8293D2112B4C8C58BE"
PRFL="Win7SP1x86"
APIK="4f2a278c757ca832fskdjfhssdfjkh;jkhsfs91e36d862884bc8458512794e55"
CASE="cohans"

cd $HOME/$CASE/procexedump/

for i in *.exe; do
	echo $i >> filelist.txt
done

python $VTSS -k $APIK -f $HOME/$CASE/procexedump/filelist.txt
