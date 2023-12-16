#!/bin/sh

#
# Start daemons: UPNP, ipfind
#
start() {

	echo "HWmon update"
	/sbin/cammsger 10 update 0 0 0 0 0

	#
	# Start NTP Client, Time Server. run in background
	#
	/etc/rc.d/init.d/ntpc.sh 10 > /dev/null 2>&1 &

	#
	# Start upnp igd
	#
	/etc/rc.d/init.d/upnp_igdd.sh startdelay &

	#
	# Start Stunnel for SSMTP 
	#
	/etc/rc.d/init.d/smtps.sh codestart

	/usr/bin/logger -t ipcam "Camera service start"
	echo "Setting Iptables Ruleset"
	/etc/init.d/iptables_rule.sh 1>/dev/null 2>/dev/null
	echo "Setting Ip6tables Ruleset"
	/etc/init.d/ip6tables_rule.sh 1>/dev/null 2>/dev/null
   
	sleep 1
	echo "Starting UPNP ...."
	if [ `/sbin/cfg -a r net.conf UPNP Enable` != 0 ]
	then
		/usr/bin/logger -t ipcam "UPnP enable"
		/sbin/upnp 1>/dev/null 2>/dev/null&
	fi
	echo "Starting wanipd.sh ...."
	/etc/init.d/wanipd.sh&
	#
	# Start DDNS, the script will check enable/disable itself
	#
	/etc/rc.d/init.d/ddns.sh startdelay &
	#
	# Start WPS daemon
	#
	/sbin/racfg exist
	if [ $? = 1 ]; then
		/sbin/racfg wscgenpin
		/sbin/wscd -mode 2 -c /var/wscd.conf -w wlan0 -fi /var/wscd-wlan0.fifo -daemon
		/sbin/iwcontrol wlan0
	fi

	echo "Starting IPFind..."
	/sbin/ipfind&
}

stop() {
	/bin/kill `pidof upnp`
	/bin/kill `pidof ipfind`
	/bin/kill `pidof telnetd`
	/bin/kill `cat /var/run/iwcontrol.pid`
	/bin/kill `cat /var/run/wscd-wlan0.pid`
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
