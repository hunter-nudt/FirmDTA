#!/bin/sh
# set mac address
/sbin/cfg -a w net.conf NETWORK "mac addr" $1

