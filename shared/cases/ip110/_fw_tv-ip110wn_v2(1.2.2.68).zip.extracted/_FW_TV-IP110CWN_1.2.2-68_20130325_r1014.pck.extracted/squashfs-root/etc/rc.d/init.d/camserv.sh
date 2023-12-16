#!/bin/sh

start() {
	/sbin/syslogd -C -m 0
	cd /server; ./camsvr&
	sleep 1
	# init sensor default values
	/etc/init.d/sensorctl.sh
}

stop() {
	/sbin/cammsger 0 stop 0 1 0 0
#	/bin/kill `pidof camsvr`
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
