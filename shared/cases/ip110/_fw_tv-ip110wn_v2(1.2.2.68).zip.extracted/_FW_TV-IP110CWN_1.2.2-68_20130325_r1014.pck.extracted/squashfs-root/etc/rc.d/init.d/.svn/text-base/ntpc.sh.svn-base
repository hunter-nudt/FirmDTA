#!/bin/sh

time_protocol=`/sbin/cfg -a r sys.conf DATETIME "Protocol"`
intervel=`/sbin/cfg -a r sys.conf DATETIME "Sync Schedule"`
retry=3
retrysleep=60

case "$time_protocol" in
  1)
	/bin/kill `pidof ntpclient`
	hostname=`/sbin/cfg -a r sys.conf DATETIME "NTP IP"`
	if [ $? = 0 ] ; then
		/bin/kill `pidof ntpclient` 
		# some delay to avoid wireless connection not finished
		if [ -n "$1" ]; then
			sleep $1 
		fi
		synctime=$(($intervel * 3600))
		while [ "$retry" -gt 0 ]; do
	  		/usr/sbin/ntpclient -s -i 15 -h "$hostname"
        if [ $? != 0 ]; then
   	  		/usr/sbin/ntpclient -s -i 15 -6 -h "$hostname"
		    fi
			# if query is OK, set the hwclock
			if [ $? = 0 ]; then
				#/usr/bin/logger -t ipcam "NTP date/time setting finish"
				/usr/sbin/ntpclient -s -i $synctime -l -h "$hostname"&
				exit 0
			else
				/usr/bin/logger -t ipcam "NTP date/time setting fail"
				retry=$(($retry -1))
				sleep $retrysleep
			fi
		done
  	/usr/sbin/ntpclient -s -i $synctime -l -h "$hostname"&
		
	fi
	
	;;

  *)
	echo "No protocol find"
	exit 1
esac

