#!/bin/sh

. /etc/init.d/defaults

die() {
	echo $@
	exit 1
}

ip_policy=`/sbin/cfg -a r net.conf WAN Policy`
wan_ip=`/sbin/cfg -a r -p /var info.conf UPNP WanIP`
check=`/sbin/cfg -a r -p /server event.ini SchedEmail wanip`
ddns_check=`/sbin/cfg -a r net.conf DDNS Enable`
bootup=1

while [ 1 ]
do
	/sbin/ddns checkip > /dev/null 2>&1
	retval=$?

	check=`/sbin/cfg -a r -p /server event.ini SchedEmail wanip`
	ddns_check=`/sbin/cfg -a r net.conf DDNS Enable`
	echo "check:$check ddns_check:$ddns_check"

	if [ $retval = 0 ]; then
		if [ $bootup = 1 ]; then
			wan_ip=`/sbin/cfg -a r -p /var info.conf UPNP WanIP`
			bootup=0
			continue
		fi
		new_wan_ip=`/sbin/cfg -a r -p /var info.conf UPNP WanIP`
		if [ "$new_wan_ip" != "$wan_ip" ]; then
			echo "old wan ip:[$wan_ip], new:[$new_wan_ip]"
			wan_ip=$new_wan_ip
			if [ "$ddns_check" = "1" ]; then
				/etc/init.d/ddns.sh refresh
			fi
			if [ "$check" = "1" ]; then
				/etc/init.d/wanipmail.sh
			fi
		fi

	fi
	sleep 600
done
