#!/bin/sh

#Reset ip6tables rulset
/sbin/ip6tables -P INPUT ACCEPT
/sbin/ip6tables -P OUTPUT ACCEPT
/sbin/ip6tables -P FORWARD ACCEPT
/sbin/ip6tables -F
/sbin/ip6tables -X
/sbin/ip6tables -Z

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
		/sbin/ip6tables -A INPUT -s $i -j $target
		fi
	done 
	/sbin/ip6tables -A INPUT -s ::1 -j ACCEPT
	/sbin/ip6tables -P INPUT $tableTarget
}

case "$mode" in
	0)
	    #do nothing
		echo "ip6filter: Disable mode"
	    ;;
	1)
		echo "ip6filter: Accept mode"
	    fname="/server/accepted6.ini"
		target="ACCEPT"
		tableTarget="DROP"
		set_rule
	    ;;
	2)
		echo "ip6filter: Deny mode"
	    fname="/server/ipfilter6.ini"
		target="DROP"
		tableTarget="ACCEPT"
		set_rule
	    ;;
	*)
		exit 1
esac

exit $?
