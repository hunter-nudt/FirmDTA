#!/bin/sh
/bin/kill `pidof sleep`
# stop camserv
/etc/init.d/camserv.sh stop
# stop daemon
/etc/init.d/daemon.sh stop
# stop ntp
/bin/kill `pidof ntpc`
# kill udhcpc
/bin/kill `cat /var/run/udhcpc.pid`
# kill wanipd.sh
/bin/kill `pidof wanipd.sh`
