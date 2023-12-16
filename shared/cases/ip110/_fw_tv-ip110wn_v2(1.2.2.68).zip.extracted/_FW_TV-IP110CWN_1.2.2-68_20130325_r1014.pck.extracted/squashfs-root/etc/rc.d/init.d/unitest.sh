#!/bin/sh

test_mode()
{
	echo "testing mode..."
	/sbin/cammsger 10 test 0 1 0 0 0
}

normal_mode()
{
	echo "normal mode..."
	/sbin/cammsger 10 test 0 0 0 0 0
}

system_mode()
{
	echo "system mode"
}

region_test()
{
	echo "wireless region: $1"
	/sbin/cfg -a w net.conf WLAN Region $1
	/etc/init.d/savecfg.sh
}

case "$1" in

	test)
		test_mode
		;;
	normal)
		normal_mode
		;;
	region)
		region_test $2
		;;
	system)
		system_mode $2
		;;
	*)	
		echo "no such test case"
esac

