#!/bin/sh

SAMBA_FILE=/tmp/samba/smb.conf

if [ ! -n "$2" ]; then
	echo "insufficient arguments!"
	echo "Usage: $0 <netbios_name> <workgroup>"
	exit 0
fi

NETBIOS_NAME="$1"
WORKGROUP="$2"

echo "[global]
use sendfile = yes
netbios name = $NETBIOS_NAME
server string = Samba Server
workgroup = $WORKGROUP
security = SHARE
guest account = root
log file = /var/log.samba
#socket options = TCP_NODELAY SO_KEEPALIVE SO_RCVBUF=48000 SO_SNDBUF=40000 IPTOS_LOWDELAY 
socket options = IPTOS_LOWDELAY IPTOS_THROUGHPUT TCP_NODELAY SO_KEEPALIVE TCP_FASTACK SO_RCVBUF=65536 SO_SNDBUF=65536 #realtek
encrypt passwords = yes
use spne go = no
client use spnego = no
disable spoolss = yes
smb passwd file = /etc/samba/smbpasswd
host msdfs = no
getwd cache = yes
strict allocate = No
os level = 20
log level = 0
max log size = 100
null passwords = yes
aio write size = 65536	#realtek
aio read size = 65536	#realtek
large readwrite = yes	#realtek
read raw = yes		#realtek
write raw = yes		#realtek
mangling method = hash
dos charset = CP950
unix charset = UTF8
display charset = UTF8
unix password sync = yes
case sensitive = no
bind interfaces only = yes" > $SAMBA_FILE

echo "interfaces = lo, br0" >> $SAMBA_FILE

echo "" >> $SAMBA_FILE


