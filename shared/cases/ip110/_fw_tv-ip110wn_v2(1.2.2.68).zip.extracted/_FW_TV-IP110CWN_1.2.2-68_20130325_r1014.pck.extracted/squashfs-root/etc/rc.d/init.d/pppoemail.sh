#/bin/sh
pppoe_path=/server/cgi-bin/lang
lang=`/sbin/cfg -a r sys.conf SYSTEM "Language"`
if [ -z "$lang" ]; then
	lang=en
fi

charset=`/sbin/cfg -a r -p /server server.ini OEM "charset"`
if [ -z $charset ]; then
	charset="utf-8"
fi

cp $pppoe_path/$lang/mail.txt /var/pppoe.txt
/sbin/pppoenotify -c $charset
