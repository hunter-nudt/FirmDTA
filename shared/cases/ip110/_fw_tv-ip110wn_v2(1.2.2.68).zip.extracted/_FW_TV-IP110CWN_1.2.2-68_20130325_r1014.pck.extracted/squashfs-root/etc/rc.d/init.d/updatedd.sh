service=$2
name=$3
host=$4
check_period=120

get_interface() {
	ip_policy=`/sbin/cfg -a r net.conf WAN "Policy"`
	DEV=`/sbin/cfg -a r net.conf NETWORK "Wan Dev"`

	if [ "$ip_policy" = "pppoe" ]; then
		DEV=ppp0
	fi

}

update() {
	echo "do updatedd to " $service
	/usr/sbin/updatedd $service $name $host 1>/dev/null
}
start() {

	#update once first
	update

	#check the interface
	get_interface

	last_ip=`/sbin/iff_get -i $DEV`

	#periodically check the local ip, do update again if local ip changes
	while [ 1 ]
	do
		ip=`/sbin/iff_get -i $DEV`
		if [ $ip != $last_ip ]; then
			update
			last_ip=$ip
		fi
		sleep $check_period
	done
}

stop() {
        /bin/kill `pidof updatedd.sh` > /dev/null 2>&1
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
