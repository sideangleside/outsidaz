#!/bin/bash

#########################################################################
# set_purple_status.sh							#
# Author: Richard Jerrido						#
# Version: 1.0								#
# License: GPL								#
# Function: This script changes your Pidgin away 			#
# 	    status to match your currently playing			#
# 	    song in Rhythmbox.						#
# Dependencies: pidof, purple-remote (included with pidgin)		#
#	    rhythmbox (included with most distributions of GNOME)	#
# Usage: Script is designed as an infinite loop that polls rhythmbox    #
#	 status every 15 seconds. Start from the shell or 		#
#	 the GNOME Sessions menu for auto-start at login		#
#########################################################################

setstatus () 
{ 
	export Song=`banshee-1 --query-title | cut -f 2 -d ":"`
	if [[ "$Song" == "Not playing" ]]; then
		purple-remote "setstatus?status=away&message= " &>/dev/null
	else
		export Album=`banshee-1 --query-album | cut -f 2 -d ":"`
		export Artist=`banshee-1 --query-artist | cut -f 2 -d ":"`
		export Message=${Song}" by "${Artist}" from "${Album} 
		#purple-remote "setstatus?status=away&message=$Song by $Artist from $Album"
		Message=`echo $Message | sed 's/\&/and/g'`
		#sed -i "s/\&/and/g" ${Message}
		#echo $Message
		purple-remote "setstatus?status=away&message=${Message}" &>/dev/null
	fi
}

while [ 1 ]
do
	test `pidof banshee-1` -gt 0 &> /dev/null && setstatus || purple-remote "setstatus?status=away&message= " &>/dev/null 
	sleep 15
done
