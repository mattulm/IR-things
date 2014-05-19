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
APIK="4f2a278c757ca832566afd2b07b599584a0d391e36d862884bc8458512794e55"
CASE="cohans"

python $VTSE -k $APIK -f $HOME/$CASE/procexedump/procexedump.md5.stripped.txt
cp $HOME/$CASE/procexedump/virustotal-search-*.csv $HOME/$CASE/evidence/volatility_proexedump.csv
