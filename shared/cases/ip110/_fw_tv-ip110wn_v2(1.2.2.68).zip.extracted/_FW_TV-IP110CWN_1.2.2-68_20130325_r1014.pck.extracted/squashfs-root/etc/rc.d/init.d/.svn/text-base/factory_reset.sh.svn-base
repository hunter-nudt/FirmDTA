#!/bin/sh

# get mac address & region
mac=`/sbin/cfg -a r net.conf NETWORK "mac addr"`
ret=$?
if [ ! $ret = 0 ]; then
	mac=00:12:34:56:78:90
fi

region=`/sbin/cfg -a r net.conf WLAN Region`
issoft=0

# process 'soft' factory reset
if [ ! -z $1 ]; then
	# soft keep IP addr, subnetmask, broadcast, route
	if [ $1 = "soft" ]; then
	echo "it's soft..."
	policy=`/sbin/cfg -a r net.conf WAN Policy`
	ipaddr=`/sbin/cfg -a r net.conf WAN "IP Addr"`
	netmask=`/sbin/cfg -a r net.conf WAN Netmask`
	gateway=`/sbin/cfg -a r net.conf WAN Gateway`
	issoft=1
	fi
fi

cd /var/config; /bin/tar zxf /etc/factory_default.tgz

# write back mac address to /etc/net.conf
cfg -a w net.conf NETWORK "mac addr" $mac
cfg -a w net.conf WLAN Region $region

if [ $issoft = 1 ]; then
	cfg -a w net.conf WAN Policy $policy
	cfg -a w net.conf WAN "IP Addr" $ipaddr
	cfg -a w net.conf WAN Netmask $netmask
	cfg -a w net.conf WAN Gateway $gateway
fi

# save config to flash
/etc/init.d/savecfg.sh
retval=$?
echo "remember to reboot your camera..."
exit $retval
