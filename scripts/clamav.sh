#!/bin/bash
#
# Author : Jonathan Sanfilippo
# Date: Jun 2023
# Version 1.0.0: clamav weekly script
#


# Set Scan
weekday="Tue"
dirscan="/home/$user/"

#variable
data=$(date +'%d')
last=$(cat $HOME/scripts/av/last)
target="$weekday"
current=$(date +'%a')
log="$HOME/scripts/av/log"

clamav(){

if [ "$target" = "$current" ]; then 
    if ! [ "$data" -eq "$last" ]; then 
         echo "scan!"
         nice -n19 clamscan -ri --remove=yes  $dirscan > "$log";
         echo "$data" > $HOME/scripts/av/last
         MALWARE=$(tail "$log" | grep 'Infected' | cut -d " " -f3);
         if [ "$MALWARE" -eq "0" ];then
             notify-send  "ClamAV"  "System Protect"   -u normal
         else
             notify-send  "ClamAV"  "$MALWARE Malware Removed"   -u critical
         fi    
    else
        echo "already scan!"
    fi
else    
    echo "no scan for today!"
fi

}

clamav

