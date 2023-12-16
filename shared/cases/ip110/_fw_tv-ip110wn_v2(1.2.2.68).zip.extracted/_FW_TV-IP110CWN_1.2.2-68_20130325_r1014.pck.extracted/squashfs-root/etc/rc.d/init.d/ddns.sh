#!/bin/sh

provider=`/sbin/cfg -a r net.conf DDNS Provider`
interval_hr=`/sbin/cfg -a r net.conf DDNS Interval_Hr`
interval_min=`/sbin/cfg -a r net.conf DDNS Interval_Min`
user=`/sbin/cfg -a r net.conf DDNS UserName`
pass=`/sbin/cfg -a r net.conf DDNS Password`
host=`/sbin/cfg -a r net.conf DDNS HostName`

start() {
	echo -n "Starting ddns:"
	if [ `/sbin/cfg -a r net.conf DDNS Enable` = 0 ]
	then
		echo disabled
		exit 0
	fi
	/usr/bin/logger -t ipcam "Dynamic DNS register start"
	if [ $provider = "www.EuroDynDNS.org" ]; then
		/etc/rc.d/init.d/updatedd.sh restart eurodyndns $user:$pass $host&
	elif [ $provider = "www.no-ip.com" ]; then
		/etc/rc.d/init.d/updatedd.sh restart noip $user:$pass $host&
	elif [ $provider = "www.ovh.com" ]; then
		/etc/rc.d/init.d/updatedd.sh restart ovh $user:$pass $host&
	elif [ $provider = "www.regfish.com" ]; then
		/etc/rc.d/init.d/updatedd.sh restart regfish $user:$pass $host&
	else
		/sbin/ddns&
	fi
}

startdelay() {
	#sleep preventing startup crash
	sleep 40
	start
}

stop() {
	/usr/bin/logger -t ipcam "Dynamic DNS register stop"
        /bin/killall -QUIT ez-ipupdate > /dev/null 2>&1
	/usr/bin/killall -QUIT ddns > /dev/null 2>&1
}

restart() {
	stop
	start
}

refresh() {
	echo -n "DDNS refresh: "
	if [ `/sbin/cfg -a r net.conf DDNS Enable` = 0 ]
	then
		echo disabled
		exit 0
	fi
	# Fire SIGTERM to notify ddns daemon to refresh ip
	/usr/bin/killall -TERM ddns > /dev/null 2>&1
}

case "$1" in
	start)
		start
		;;
	startdelay)
		startdelay
		;;
	stop)
		stop
		;;
	restart)
		restart
		;;
	refresh)
		refresh
		;;
	*)
		echo $"Usage $0 {start|startdelay|stop|restart|refresh}"
		exit 1
esac

exit $?
