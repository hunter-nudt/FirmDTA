
short_interval=60
retval=0
# do 5 times when system start. Stop after success.
i=5

start() {
	while [ $i -gt 0 ]; do
		/etc/init.d/upnp_igd.sh start
		retval=$?
		echo upnpigd=$retval
		if [ $retval = 0 ]; then
			exit $retval
		fi
		sleep $short_interval
		i=$(($i-1))
		echo $i
	done

	exit $retval
}

startdelay() {
	# sleep a long time while bootup, cause it may get crash if it starts too early
	sleep 60
	start
}

case "$1" in
	start)
		start
		;;
	startdelay)
		startdelay
		;;
	*)
		echo $"Usage $0 {start|startdelay}"
		exit 1
esac

exit $?
