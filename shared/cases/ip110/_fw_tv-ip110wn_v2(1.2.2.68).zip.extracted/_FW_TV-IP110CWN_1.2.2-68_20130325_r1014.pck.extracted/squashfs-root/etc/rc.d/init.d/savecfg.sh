#!/bin/sh

cd /var; tar cf config.tar config
rm -f /var/config.tar.gz
gzip config.tar
echo $"Starting save config by bkcfg:---->"
/sbin/bkcfg -s /var/config.tar.gz
