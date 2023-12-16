
#!  /bin./bash

port=`/sbin/cfg -a r net.conf WAN "Http Port"`
rtsp_port=`/sbin/cfg -a r net.conf WAN "RTSP Port"`
model=`/sbin/cfg -a r sys.conf SYSTEM "CameraName"`

wan_service="IP"
wan_service=`/sbin/cfg -a r info.conf UPNP "WanConnection"`
retval=$?
if [ $retval != 0 ]; then
	wan_service="IP"
fi

echo "wan_s:[$wan_service]"
# commands
GetSpecificPortMap=0
AddPortMap=1
GetExternalIP=2
DelPortMap=3
GetDefaultService=4

upnp_portmap()
{
	# query the port is available
	/sbin/upnp_igd $1 $GetSpecificPortMap $2 TCP
	retval=$?
	# TP-Link will return 402 for GetSpecificPortMapping
	if [ $retval = 202 -o $retval = 146 ]; then # ret is 714(406) - (256*2) = 202:)
		# the port is empty, set port map now!
		/sbin/upnp_igd $1 $AddPortMap $2 TCP $3 $2
		retval=$?
		if [ $retval = 0 ] ; then
		/usr/bin/logger -t ipcam "UPnP port mapping setting finish"
		else
		/usr/bin/logger -t ipcam "UPnP port mapping setting fail"
		fi
		return $retval
	elif [ $retval = 0 ]; then
		# specific port is open
		/usr/bin/logger -t ipcam "UPnP specific port:$2 already open"
	else
		/usr/bin/logger -t ipcam "UPnP port mapping setting fail"
	fi
	return $retval
}

upnp_portdel()
{
	# query the port is available
	/sbin/upnp_igd $1 $GetSpecificPortMap $2 TCP
	retval=$?
	# TP-Link will return 402 for GetSpecificPortMapping
	if [ $retval = 202 -o $retval = 146 ]; then # ret is 714(406) - (256*2) = 202:)
		# specific port is open
		/usr/bin/logger -t ipcam "UPnP specific port:$2 is not open"
		return $retval
	elif [ $retval = 0 ]; then
		/sbin/upnp_igd $1 $DelPortMap $2 TCP
		retval=$?
	fi

	if [ $retval = 0 ]; then
		/usr/bin/logger -t ipcam "UPnP specific port:$2 delete successfully"
	fi

	return $retval
}

if [ -z "$model" ]; then
	/sbin/racfg exist
	retval=$?
	if [ retval = 1 ]; then
		model=`/sbin/cfg -a r info.conf WL_UPNP "ModelName"`
	else
		model=`/sbin/cfg -a r info.conf UPNP "ModelName"`
	fi
fi

upnp_igd()
{
  for chkport in $1; do
	/usr/bin/logger -t ipcam "UPnP port($chkport) mapping setting start"
	upnp_portmap $wan_service $chkport "$model"
	retval=$?
  done 
  return $retval
}

#
# Start UPNP
#
start() {
	echo "Starting UPNP Port Forwarding...."
	if [ `/sbin/cfg -a r net.conf UPNP PortForward` = 0 ]
	then
		echo disabled
		upnp_portdel $wan_service $port
		exit 0
	fi
	echo enabled
	upnp_igd "$port"
	retval1=$?
	if [ $retval1 -ne 0 ]; then
		exit $retval1
	fi
	exit 0
}

stop() {
	echo nothing...
}

restart() {
	stop
	start
}

delete() {
	/usr/bin/logger -t ipcam "UPnP delete portmapping"
	upnp_portdel $wan_service $port
	retval=$?
	exit $retval
}

specific() {
	# speficy port
	if [ -z $1 ]; then
		/sbin/upnp_igd $wan_service $GetSpecificPortMap $port TCP
	else
		/sbin/upnp_igd $wan_service $GetSpecificPortMap $1 TCP
	fi

	retval=$?
	exit $retval
}

# get external IP address
getextip() {
	# specify service type
	if [ -n "$1" ]; then
		wan_service=$1
	fi
	/sbin/upnp_igd $wan_service $GetExternalIP
	retval=$?
	# write service in conf file
	if [ $retval = 0 ]; then
		/sbin/cfg -a w info.conf UPNP WanConnection $wan_service
	fi
	exit $retval
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
	delete)
		delete 
		;;
	specific)
		specific $2
		;;
	getextip)
		getextip $2
		;;
	*)
		echo $"Usage $0 {start|stop|restart|delete|specific|getextip}"
		exit 1
esac

exit $?
