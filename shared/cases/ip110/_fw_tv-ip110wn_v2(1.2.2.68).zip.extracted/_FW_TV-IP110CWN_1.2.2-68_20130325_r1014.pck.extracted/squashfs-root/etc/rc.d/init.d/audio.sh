#!/bin/sh
# 
# audio: audio related stuffs
#

RETVAL=0
#spvol=`/sbin/cfg -a r -p /server video.ini audio volume`
#speaker=`/sbin/cfg -a r -p /server video.ini audio speaker`
#
umask 077

case "$1" in
  start)
	echo $"Starting audio adjusting ---->"
#	# adjust microphone volume to max
#	/sbin/mixer2 -g 65
#	/sbin/mixer2 -0 82
#	/sbin/mixer2 -S 0x0E=0x825F
#	# adjust speaker volume
#	if [ $speaker = 1 ] ; then
#		/sbin/mixer2 -a $spvol
#	fi
	RETVAL=$?
	echo 
	exit $RETVAL
	;;
  stop)
	# donthing
esac
