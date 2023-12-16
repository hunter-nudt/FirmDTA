#!/bin/sh

brightness=`/sbin/cfg -a r -p /server video.ini video brightness`
contrast=`/sbin/cfg -a r -p /server video.ini video contrast`
saturation=`/sbin/cfg -a r -p /server video.ini video saturation`
hue=`/sbin/cfg -a r -p /server video.ini video hue`
sharpness=`/sbin/cfg -a r -p /server video.ini video sharpness`
flip=`/sbin/cfg -a r -p /server video.ini video flip`
mirror=`/sbin/cfg -a r -p /server video.ini video mirror`
flicker=`/sbin/cfg -a r -p /server video.ini video frequency`


/sbin/psensor -brightness=$brightness
/sbin/psensor -contrast=$contrast
/sbin/psensor -saturation=$saturation
/sbin/psensor -hue=$hue
/sbin/psensor -sharpness=$sharpness
/sbin/psensor -vflip=$flip
/sbin/psensor -hmirror=$mirror
/sbin/psensor -flicker=$flicker

