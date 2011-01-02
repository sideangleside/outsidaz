#!/bin/bash
# raid_notify.sh - Script to identify failed drives in a Linux 
#     software RAID setup.
# http://www.outsidaz.org/blog/2009/11/05/identifying-failed-drives-via-udev-and-mdadm/
# Author: Rich Jerrido 
# License: GPLv2

#The Event that occurred
MDEVENT=$1

#The md device that is affected
MDDEVICE=$2

#The physical disk that is affected
PHYSDEVICE=$3

#Subject line of the email
SUBJECT="A ""${MDEVENT}"" Event has been detected on ""${HOSTNAME}"

#Logfile for the email
LOGFILE=/tmp/mdadm_logging

echo $SUBJECT > $LOGFILE
echo "******************" >> $LOGFILE
echo "Affected Array  - " $MDDEVICE >> $LOGFILE
echo "******************" >> $LOGFILE

#Check to see if the physical disk parameter ($3) has been passed. If it is not
#null then mdadm has passed it, and we can check the disk via udev.
if [ -n "$PHYSDEVICE" ];
	then
		echo "Affected Physical Drive  - " $PHYSDEVICE >> $LOGFILE
		echo "******************" >> $LOGFILE
		echo "Physical Drive Information is as follows " >> $LOGFILE
		echo "******************" >> $LOGFILE
		udevadm info --query=all --name=$PHYSDEVICE >> $LOGFILE
fi	
mail -s "$SUBJECT" root < $LOGFILE && /bin/rm $LOGFILE
