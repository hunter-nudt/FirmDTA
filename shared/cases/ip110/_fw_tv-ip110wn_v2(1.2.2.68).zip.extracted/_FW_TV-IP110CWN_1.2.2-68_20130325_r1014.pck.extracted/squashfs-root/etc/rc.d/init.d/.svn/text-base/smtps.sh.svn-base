#!/bin/sh

tlscheck() {

	tls=`/sbin/cfg -p /server -a r server.ini email "starttls"`
	ttls=`/sbin/cfg -p /var -a r info.conf email "starttls"`
	echo "tls="$tls
	echo "ttls="$ttls

	#starttls
	if [ "$tls" = "1" ]; then
		cfg -a w -p /etc/stunnel stunnel-smtps.conf smtps protocol "smtp"
	else #legency ssl
		cfg -a d -p /etc/stunnel stunnel-smtps.conf smtps protocol
	fi

	#starttls
	if [ "$ttls" = "1" ]; then
		cfg -a w -p /etc/stunnel stunnel-smtps.conf "smtps-test" protocol "smtp"
	else #legency ssl
		cfg -a d -p /etc/stunnel stunnel-smtps.conf "smtps-test" protocol
	fi

}

codestart() {
	encrypt=`/sbin/cfg -p /server -a r server.ini email "encrypt"`
	smtps_port=`/sbin/cfg -p /server -a r server.ini email "port"`
	smtps_host=`/sbin/cfg -p /server -a r server.ini email "host"`
	cfg -a w -p /etc/stunnel stunnel-smtps.conf smtps connect $smtps_host:$smtps_port

	tlscheck
	if [ $encrypt = 1 ]; then
	echo -n "Starting smtps stunnel:"
	/usr/sbin/stunnel-smtps /etc/stunnel/stunnel-smtps.conf
	fi
}

start() {
	tlscheck
	echo -n "Starting smtps stunnel:"
	/usr/sbin/stunnel-smtps /etc/stunnel/stunnel-smtps.conf
}

stop() {
	kill `pidof stunnel-smtps`
}

restart() {
	stop
	start
}

case "$1" in
	codestart)
		codestart
		;;
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
