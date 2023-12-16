#!/bin/sh

#Reset iptables rulset
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z

#Setting iptables rulset
mode=`/sbin/cfg -a r -p /server httpd.ini main filter`
fname=""
target=""
tableTarget=""

set_rule(){
	value=0
	var=`cat "$fname"`
	for i in $var; do
		value=`expr $value + 1`
		if [ $value != 1 ] && [ $fname != "" ] && [ $target != "" ] && [ $tableTarget != "" ]; then
			echo $i
		/sbin/iptables -A INPUT -m iprange --src-range $i -j $target
		fi
	done 
	/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT
	/sbin/iptables -P INPUT $tableTarget
}

case "$mode" in
	0)
	    #do nothing
		echo "ipfilter: Disable mode"
	    ;;
	1)
		echo "ipfilter: Accept mode"
	    fname="/server/accepted.ini"
		target="ACCEPT"
		tableTarget="DROP"
		set_rule
	    ;;
	2)
		echo "ipfilter: Deny mode"
	    fname="/server/ipfilter.ini"
		target="DROP"
		tableTarget="ACCEPT"
		set_rule
	    ;;
	*)
		exit 1
esac

exit $?
