#!/bin/sh

RETVAL=0

umask 077

case "$1" in
  start)
	#
	# create directory
	#
	mkdir /var/tmp
	mkdir /var/log
	mkdir /var/run
	mkdir /var/lock
	mkdir /var/system
	mkdir /var/wps
	ln -s /var/config/RTL8192CD.dat /var/RTL8192CD.dat
	cp -f /etc/simplecfgservice.xml /var/wps/simplecfgservice.xml
	cp -f /etc/wscd.conf /var/wscd.conf
	cp -f /usr/sbin/reboot /var/.

	echo $"Starting bkcfg:---->"
	mkdir /var/config
#check passwd by LouisChen 20121212	
	/sbin/bkcfg -r /var/config.tar.gz
	if [ -e /var/config.tar.gz ]; then
		cd /var; tar zxvf /var/config.tar.gz 
			if [ -f /var/config/passwd ]; then
				echo "passwd file already exists."
			else
				cd /var/config/; cp -f /etc/passwd.a ./passwd
				echo "passwd updated."
				cd ../; tar cf config.tar config	
				rm -f /var/config.tar.gz
				gzip config.tar
				echo $"Starting save config by bkcfg:---->"
				/sbin/bkcfg -s /var/config.tar.gz
			fi	
	else
		/etc/init.d/factory_reset.sh
	fi 

	# set timezome
	/sbin/settz

	# cp info.conf to /var for ddns wan ip read/write
	cp /etc/info.conf /var

	echo
	exit $RETVAL
	;;
  stop)
	echo $"Shutting down tmpfs: ---->"
	# donothing 
	echo	
        exit $RETVAL
	;;
esac
