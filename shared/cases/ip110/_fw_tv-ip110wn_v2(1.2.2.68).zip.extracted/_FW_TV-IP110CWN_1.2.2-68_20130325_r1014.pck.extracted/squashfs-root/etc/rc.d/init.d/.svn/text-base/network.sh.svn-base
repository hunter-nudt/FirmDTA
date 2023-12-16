#!/bin/sh

. /etc/init.d/defaults

DEV=`/sbin/cfg -a r net.conf NETWORK "Wan Dev"`
ip_policy=`/sbin/cfg -a r net.conf WAN Policy`
ip_addr=`/sbin/cfg -a r net.conf WAN "IP Addr"`
netmask_wan=`/sbin/cfg -a r net.conf WAN Netmask`
default_router=`/sbin/cfg -a r net.conf WAN Gateway`
macaddress=`/sbin/cfg -a r net.conf NETWORK "mac addr"`
region=`/sbin/cfg -a r net.conf WLAN Region`

#
# Setup Hostname
#
write_hosts() {
        # check WLAN supported
        /sbin/racfg exist
        if [ $? = 1 ]; then
		upnp="WL_UPNP"
        else
		upnp="UPNP"
        fi
	hostname=`/sbin/cfg -a r info.conf $upnp ModelName`
	cnt=1
	mac=""
	while [ "$cnt" -lt 7 ]
	do
        	mac=$mac`echo $macaddress | cut -d: -f$cnt`
		cnt=$(($cnt+1))
	done
	echo "Setting Hostname: ${hostname}-$mac"
        /bin/hostname "${hostname}-$mac"
        /bin/echo "127.0.0.1            localhost               localhost" > /var/hosts
        /bin/echo "$host_ip             `/bin/hostname`         `/bin/hostname`" >> /var/hosts
}

#
# network interface Setup
#
network_setup() {
	if [ $ip_policy = "static" ]; then
		echo "Setting fixed IP Address ...."
		/sbin/ifconfig $DEV ${ip_addr} netmask ${netmask_wan}
		/sbin/route add default gw ${default_router}
	elif [ $ip_policy = "dhcpc" ]; then
		if [ -f /usr/share/udhcpc/default.script ]; then
			echo "Starting DHCP Client ...."
			/etc/rc.d/init.d/udhcpc.sh start
		fi
	elif [ $ip_policy = "pppoe" ]; then
		echo "Starting PPPoE ...."
		if [ -r /etc/rc.d/init.d/pppoe.sh ]; then
			echo "Starting PPPoE Connection ...."
			/etc/rc.d/init.d/pppoe.sh start
			if [ $? = 0 ]; then
				# now use ppp0 as active one
				DEV=ppp0
				/etc/rc.d/init.d/pppoemail.sh
			else
				/sbin/ifconfig $DEV $default_ip netmask $default_mask 
			fi
		fi
	fi

	# Broadcast route for discover
	/sbin/route add -host 255.255.255.255 $DEV
	write_hosts

	#
	# Start DNS Relay Daemon
	#
	if [ $ip_policy = "static" ]; then 
		echo "Starting DNS Proxy ...."
		/etc/rc.d/init.d/dnrd.sh start
	fi
}

#
# network initial
#
initial() {
	/sbin/ifconfig lo 127.0.0.1 netmask 255.0.0.0
	/sbin/brctl addbr $DEV
	echo "MAC="$macaddress
	/sbin/racfg exist
	if [ $? = 1 ]; then
		/sbin/cfg -a w -p /var info.conf INFO Wireless 1
		/sbin/ifconfig wlan0 0.0.0.0
		/sbin/ifconfig wlan0 hw ether $macaddress
		/sbin/racfg region $region
		/sbin/racfg wmode 9
		/sbin/racfg wlanup 3
	fi
	/sbin/ifconfig eth0 0.0.0.0
	/sbin/ifconfig eth0 hw ether $macaddress
	/sbin/brctl addif $DEV eth0
	/sbin/brctl setfd $DEV 1
	/sbin/brctl setmaxage $DEV 1
}

#
# Add wireless
#
add_wlan() {
	/sbin/brctl addif $DEV wlan0
	/sbin/brctl delif $DEV eth0
}

#
# Remove wireless
#
remove_wlan() {
	/sbin/brctl addif $DEV eth0
	/sbin/brctl delif $DEV wlan0
}

case "$1" in
	init)
		initial
		;;
	netsetup)
		network_setup
		;;
	wlanon)
		add_wlan
		;;
	wlanoff)
		remove_wlan
		;;
	*)
		echo $"Usage $0 {init|netsetup|wlanon|wlanoff}"
		exit 1
esac
exit $?

