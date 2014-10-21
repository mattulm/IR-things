#!/bin/bash
HEADER="Accept: text/html"
UA20="Mozilla/5.0 Gecko/20010527 Firefox/22.3"
UA21="Mozilla/5.0 Gecko/20100114 Firefox/21.1"
UA22="Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13; ) Gecko/20101203"
# Get the IP address from the user
echo "What is the name of the IP file? : "
read FILENAME
mkdir $FILENAME.dir;
# malc0de Database
while read r; do
        wget --header="$HEADER" --user-agent="$UA21" "http://malc0de.com/database/index.php?search=$r" -O "$FILENAME.dir/$r.mcdb.html"
        wget --header="$HEADER" --user-agent="$UA22" "https://www.virustotal.com/en/ip-address/$r/information/" -O "$FILENAME.dir/$r.vt.html"
        wget --header="$HEADER" --user-agent="$UA21" "http://vxvault.siri-urz.net/ViriList.php?IP=$r" -O "$FILENAME.dir/$r.vxv.html"
        wget --header="$HEADER" --user-agent="$UA22" "http://www.projecthoneypot.org/ip_$r" -O "$FILENAME.dir/$r.phn.html"
        wget --header="$HEADER" --user-agent="$UA20" "https://zeustracker.abuse.ch/monitor.php?ipaddress=$r" -O "$FILENAME.dir/$r.zt.html" --no-check-certificate
        wget --header="$HEADER" --user-agent="$UA22" "https://spyeyetracker.abuse.ch/monitor.php?ipaddress=$r" -O "$FILENAME.dir/$r.set.html" --no-check-certificate
        wget --header="$HEADER" --user-agent="$UA23" "https://palevotracker.abuse.ch/?ipaddress=$r" -O "$FILENAME.dir/$r.pt.html" --no-check-certificate

done < $FILENAME
cd $FILENAME.dir;
#########
# This section will go through the files downlaoded, and pull out any that have
# no data within them.
#############################
for i in *.mcdb.html; do
        if grep -q "yielded no results" $i; then
                rm -rf $i
        fi
done
#
for i in *.vt.html; do
        if grep -q "<strong>unknown ip" $i; then
                rm -rf $i
        fi
done
#
for i in *.vt.html; do
        if grep -q "<strong>Unknown IP!</strong> VirusTotal has never resolved any domain name" $i; then
                rm -rf $i
        fi
done
#
for i in *.phn.html; do
        if grep -q "<p>We don" $i; then
                rm -rf $i
        fi
done
#
for i in *.zt.html; do
        if grep -qi "strong> was not found in the ZeuS Tracker database.</p>" $i; then
                rm -rf $i
        fi
done
#
for i in *.pt.html; do
        if grep -q "<p>No hits in database</p>" $i; then
                rm -rf $i
        fi
done
#
find -name "*.set.html" -size -3641c -delete
        # this removes any files that have no results.
find -name "*.vxv.html" -size -1506c -delete
        # this remvoes fils with no results.
########
# Let's look for some information within the files
#########################################################
# Virus Total
for i in *.vt.html; do
        if grep -q "URL scanner or malicious URL dataset</strong>" $i; then
                echo "$i : Virus Total : URL Scanner : URLs on this IP were detected by at least one URL scanner or malicious URL dataset. " >> results.txt
        fi
done
#
for i in *.vt.html; do
        if grep -q "antivirus solutions and communicate with the IP address provided</strong>" $i; then
                echo "$i : Virus Total : Malware : This IP has identified malware communicating with it. " >> results.txt
        fi
done
# Project Honey Net
for i in *.phn.html; do
        if grep -q "<li>This IP has not seen any suspicious activity within the last 3 months." $i; then
                echo "$i : Project Honey Net : Activity : No malicious activity in the last 3 months " >> results.txt
        fi
done
#
for i in *.phn.html; do
        if grep -q ">mail server</a></b>" $i; then
                echo "$i : Project Honey Net : Activity : This IP has behavior consistent with a mail server " >> results.txt
        fi
done
#
for i in *.phn.html; do
        if grep -q ">dictionary attacker</a></b>" $i; then
                echo "$i : Project Honey Net : Activity : This IP has behavior consistent with a Dictionary Attacker " >> results.txt
        fi
done
#
for i in *.phn.html; do
        if grep -q ">spam harvester</a></b>" $i; then
                echo "$i : Project Honey Net : Activity : This IP has behavior consistent with a Spam Harvester " >> results.txt
        fi
done
#
for i in *.phn.html; do
        if grep -q ">comment spammer</a></b>" $i; then
                echo "$i : Project Honey Net : Activity : This IP has behavior consistent with that of a Comment Spammer " >> results.txt
        fi
done
# Malc0de Database
for i in *.mcdb.html; do
        if grep -q "class1" $i ; then
                echo "$i : Malcode Database : Malware : The Malcode database has an entry for this IP " >> results.txt
        fi
done
# Spy Eye Tracker
for i in *.set.html; do
        if grep -iq "strong> was not found in the SpyEye Tracker database" $i; then
                echo "$1 : Spy Eye TRacker : Malware : No data in the database. " >> results.txt
                rm -rf
        fi
done
# Organize our file now.
cat results.txt | sort >> report.txt
# Clean up
find -name "*.html" -size -1c -delete
rm -rf *.vt.html
rm -rf *.phn.html
rm -rf *.mcdb.html
#
echo " "; echo " "; echo " ";

#
# EOF