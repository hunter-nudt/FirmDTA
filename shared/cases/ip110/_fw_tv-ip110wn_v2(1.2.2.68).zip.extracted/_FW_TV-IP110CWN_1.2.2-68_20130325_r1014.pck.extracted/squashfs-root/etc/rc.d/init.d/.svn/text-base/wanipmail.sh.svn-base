#/bin/sh
ip_policy=`/sbin/cfg -a r net.conf WAN Policy`
wan_ip=`/sbin/cfg -a r -p /var info.conf UPNP WanIP`
wan_port=`/sbin/cfg -a r net.conf WAN "Http Port"`
DEV=`/sbin/cfg -a r net.conf NETWORK "Wan Dev"`
lan_mac_addr=`/sbin/iff_get -h $DEV`
wan_path=/server/cgi-bin/lang
lang=`/sbin/cfg -a r sys.conf SYSTEM "Language"`
if [ -z "$lang" ]; then
	lang=en
fi

charset=`/sbin/cfg -a r -p /server server.ini OEM "charset"`
if [ -z $charset ]; then
	charset="utf-8"
fi

title=`/sbin/cfg -a r -p $wan_path/$lang mail.txt Wanip title`
line1=`/sbin/cfg -a r -p $wan_path/$lang mail.txt Wanip line1`
line2=`/sbin/cfg -a r -p $wan_path/$lang mail.txt Wanip line2`
line3=`/sbin/cfg -a r -p $wan_path/$lang mail.txt Wanip line3`

cp $wan_path/$lang/mail.txt /var/pppoe.txt
/sbin/pppoenotify -d -s "${title}" -n "${lan_mac_addr} ${line1}" -n "${line2} http://${wan_ip}:${wan_port} ${line3}" -c $charset
