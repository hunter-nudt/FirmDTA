#!/bin/sh

primary=`/sbin/cfg -a r net.conf "DNS PROXY" Primary`
secondary=`/sbin/cfg -a r net.conf "DNS PROXY" Secondary`

# use the /var/resolv.conf directly 
start() {
	RESOLV="/var/resolv.conf"
	DNS="$primary $secondary"
	#echo $DNS
	rm -f /var/resolv.conf
	echo -n > $RESOLV
 	for i in $DNS; do
 	       echo "nameserver $i" >> $RESOLV
	done
}


stop() {
	/usr/sbin/dnrd -k > /dev/null 2>&1
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
