#!/bin/sh

start() {
	# change pppoe interface depend on current connect policy
	DEV=ppp0
	#log
	/usr/bin/logger -t ipcam "PPPoE start"
	/sbin/cfg -a w ddns.conf "" interface $DEV
	/usr/sbin/adsl-start
}

stop() {
	/usr/bin/logger -t ipcam "PPPoE stop"
	/usr/sbin/adsl-stop
}

restart() {
	stop
	start
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		restart
		;;
	*)
		echo $"Usage $0 {start|stop|restart}"
		exit 1
esac

exit $?
