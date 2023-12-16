#!/bin/sh

http_port=`/sbin/cfg -a r net.conf WAN "Http Port"`
https_port=`/sbin/cfg -a r net.conf HTTPS "Https Port"`
https_enable=`/sbin/cfg -a r net.conf HTTPS "Enable"`
if [ -z $https_port ]; then
	https_port=443
fi
cfg -a w -p /etc/stunnel stunnel.conf https accept $https_port
cfg -a w -p /etc/stunnel stunnel.conf https connect $http_port

start() {
	if [ $https_enable = 1 ]; then
	echo "Starting https..."
		/usr/sbin/stunnel /etc/stunnel/stunnel.conf
	fi
}

stop() {
	kill `pidof stunnel`
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
