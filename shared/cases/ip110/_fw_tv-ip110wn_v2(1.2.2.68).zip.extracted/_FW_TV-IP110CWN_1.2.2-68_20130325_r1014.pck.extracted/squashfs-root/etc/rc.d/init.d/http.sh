#!/bin/sh

#http_port=`/sbin/cfg -a r net.conf WAN "Http Port"`

start() {
	echo "Starting boa web server..."
	cd /server; ./boa -c /server 1>/dev/null 2>/dev/null&
	/etc/init.d/https.sh start
}

stop() {
	kill `pidof boa`
	/etc/init.d/https.sh stop
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
