var	ERR_NO_ERROR											=0
var ERR_FS_FILE_OPEN_FAILED									=10

var	ERR_PPPOE_FIXED_IP										=1000
var	ERR_PPPOE_TIMING_SET									=1001
var	ERR_PPPOE_STRING_TOO_LONG								=1002
var	ERR_PPPOE_USERNAME_TOO_LONG								=1003
var	ERR_PPPOE_PWD_TOO_LONG									=1004
var	ERR_PPPOE_AUTO_OFF_WAITE_TIME							=1005
var	ERR_PPPOE_LCP_MRU										=1006
var	ERR_PPPOE_ECHO_REQ_INTERVAL								=1007

var	ERR_DHCP_SERVER_ADDR_POOL_ERROR							=2000
var	ERR_DHCP_SERVER_GATEWAY_ERROR							=2001
var	ERR_DHCP_SERVER_DNS_ERROR								=2002
var	ERR_DHCP_SERVER_BAK_DNS_ERROR							=2003
var	ERR_DHCP_SERVER_LEASE									=2004
var	ERR_DHCP_SERVER_START_IP_ADDR							=2005
var	ERR_DHCP_SERVER_END_IP_ADDR								=2006
var	ERR_DHCP_SERVER_START_BIGGER_END						=2007
var	ERR_DHCP_SERVER_ADD_RANGE								=2008

var	ERR_FIX_MAP_MAC_ADDR_ERROR								=3000
var	ERR_FIX_MAP_IP_ADDR_ERROR								=3001
var	ERR_FIX_MAP_REC_EXIST									=3002
var	ERR_FIX_MAP_PAGE_NUM_ERROR								=3003
var	ERR_FIX_MAP_RECORD_ALREADY_FULL							=3004
var	ERR_FIX_MAP_RECORD_MAC_ALREADY_EXIST					=3005
var	ERR_FIX_MAP_RECORD_IP_ALREADY_EXIST						=3006
var ERR_FIX_MAP_IP_EQUAL_LANIP								=3007
var ERR_FIX_MAP_CONFLICT_WHITH_FIX_ARP                      =3008

var	ERR_STATIC_ROUTR_ENABLE									=4000
var	ERR_STATIC_ROUTR_DESTINATION_IP							=4001
var	ERR_STATIC_ROUTR_SUBNETMASK_IP							=4002
var ERR_STATIC_ROUTR_SUBNETMASK_DISMATCH_IP					=4003
var	ERR_STATIC_ROUTR_GATEWAY_IP								=4004
var	ERR_STATIC_ROUTR_NOEMPTY								=4005
var	ERR_STATIC_ROUTR_DUPLICATION							=4006
var	ERR_STATIC_ROUTR_DEFAULT_GATEWAY						=4007
var	ERR_STATIC_ROUTR_NOT_SAME_NETWORK						=4008
var	ERR_STATIC_ROUTR_CONFLICT_LAN_WAN						=4009
var	ERR_STATIC_DEST_CONFLICT_LAN							=4010
var	ERR_STATIC_DEST_CONFLICT_WAN							=4011
var	ERR_STATIC_ROUTR_ALREADY_FULL							=4012
var	ERR_STATIC_ROUTR_SAVE									=4013
var	ERR_STATIC_ROUTR_OTHER									=4014
var	ERR_WAN_DOWN_BANDWIDTH									=4015
var	ERR_WAN_UP_BANDWIDTH									=4016

var	ERR_NETWORK_MTU											=5000
var	ERR_LAN_IP_ERROR										=5001
var	ERR_LAN_MASK_ERROR										=5002
var	ERR_WAN_IP_ERROR										=5003
var	ERR_WAN_MASK_ERROR										=5004
var	ERR_WAN_DNS_ERROR										=5005
var	ERR_WAN_BACKDNS_ERROR									=5006
var	ERR_WAN_GATE_ERROR										=5007
var	ERR_WAN_LAN_CONFLICT									=5008
var	ERR_WAN_TYPE											=5009
var	ERR_LAN_IP_SET											=5010
var	ERR_LAN_MASK_SET										=5011
var	ERR_WAN_IP_SERVER										=5012
var	ERR_WAN_IP_SET											=5013
var	ERR_WAN_MASK_SET										=5014
var	ERR_WAN_DNS_SET											=5015
var	ERR_WAN_GATE_SET										=5016
var	ERR_WAN_MAC_ADDR										=5017
var	ERR_WAN_MAC_DUPLICATE									=5018
var	ERR_WAN_MAC_EQ_LAN_MAC									=5019
var	ERR_SNTP_MONTH											=5020
var	ERR_SNTP_DAY											=5021
var	ERR_SNTP_YEAR											=5022
var	ERR_SNTP_HOUR											=5023
var	ERR_SNTP_MINUTE											=5024
var	ERR_SNTP_SECOND											=5025
var	ERR_SNTP_TIME_SET										=5026
var	ERR_SNTP_TIMEZONE										=5027
var	ERR_SNTP_GET_GMT_FAILED									=5028
var ERR_SAME_WAN_IP										    =5029
var ERR_SNTP_SERVER_A                                       =5030
var ERR_SNTP_SERVER_B                                       =5031 
var ERR_SERVER_IP_ERROR	                                    =5032

var	ERR_MORNITOR_PORT_ACTIVE_PORT							=6000
var	ERR_MORNITOR_PORT_PASSIVE_PORT							=6001
var	ERR_MORNITOR_PORT_EQUAL_PORT							=6002
var	ERR_MORNITOR_NONE_PORT									=6003

var	ERR_TFTP_OVER_FILE_LEN									=7000
var	ERR_TFTP_IP_ERROR										=7001

var	ERR_FIREWALL_START_TIME_FORMAT_ERROR					=8000
var	ERR_FIREWALL_END_TIME_FORMAT_ERROR						=8001
var	ERR_FIREWALL_TIME_START_BIGGER_END						=8002
var	ERR_FIREWALL_LAN_IP_FORMAT_ERROR						=8003
var	ERR_FIREWALL_LAN_PORT_FORMAT_ERROR						=8004
var	ERR_FIREWALL_WAN_IP_FORMAT_ERROR						=8005
var	ERR_FIREWALL_WAN_PORT_FORMAT_ERROR						=8006
var	ERR_FIREWALL_PROTOCOL_TYPE_ERROR						=8007
var	ERR_FIREWALL_RECORD_ALREADY_EXIST						=8008
var	ERR_FIREWALL_IP_RECORD_ALREADY_FULL						=8009

var	ERR_FIREWALL_DOMAIN_NAME_LEN_OVER						=9000
var	ERR_FIREWALL_DOMAIN_NAME_ERROR							=9001
var	ERR_FIREWALL_DOMAIN_IS_SUBSET							=9002
var	ERR_FIREWALL_DOMAIN_RECORD_ALREADY_FULL					=9003

var	ERR_FIREWALL_TIME_NOT_FULL								=10000
var	ERR_FIREWALL_TIME_FORMAT_ERROR							=10001
var	ERR_FIREWALL_WZD_TIME_ALREADY_EXIST						=10002
var	ERR_FIREWALL_WZD_TIME_IS_SUBSET							=10003
var	ERR_FIREWALL_WZD_IP_FORMAT_ERROR						=10004
var	ERR_FIREWALL_WZD_ADDR_ALREADY_EXIST						=10005
var	ERR_FIREWALL_WZD_PORT_FORMAT_ERROR						=10006
var	ERR_FIREWALL_WZD_PORT_IS_SUBSET							=10007

var	ERR_MAC_FILTER_PAGE_NUM_ERROR							=11000
var	ERR_MAC_FILTER_RECORD_ALREADY_EXIST						=11001
var	ERR_MAC_FILTER_RECORD_ALREADY_FULL						=11002
var	ERR_MAC_FILTER_FORMAT_ERROR								=11003

var	ERR_REMOTE_MANAGE_IP_FORMAT_ERROR						=12000
var	ERR_REMOTE_MANAGE_PORT_FORMAT_ERROR						=12001
var	ERR_REMOTE_MANAGE_PORT_OUT_OF_RANGE						=12002
var	ERR_REMOTE_MANAGE_PORT_OCCUPIED_PORT					=12003
var	ERR_REMOTE_MANAGE_PORT_CONFLICT_PORT					=12004

var	ERR_DMZ_HOST_IP_ADDR									=13000
var ERR_DMZ_IP_IS_DEV_IP									=13001
var	ERR_VS_PAGE_NUM_ERROR									=14000
var	ERR_VS_PORT_OUT_RANGE									=14001
var	ERR_VS_PORT_FORMAT_ERROR								=14002
var	ERR_VS_IP_ADDRESS										=14003
var	ERR_VS_RECORD_ALREADY_EXIST								=14004
var	ERR_VS_PROTOCOL_TYPE_ERROR								=14005
var	ERR_VS_RECORD_ALREADY_FULL								=14006
var	ERR_VS_PORT_OCCUPIED									=14007

var	ERR_SPECIAL_APP_PUBLIC_PORT								=15000
var	ERR_SPECIAL_APP_DUPLICATE_PUBLIC_PORT					=15001
var	ERR_SPECIAL_APP_DUPLICATE_TAG_PORT						=15002
var	ERR_SPECIAL_APP_RECORD_ALREADY_FULL						=15003

var	ERR_DDNS_USER_NAME_EMPTY								=16000
var	ERR_DDNS_PWD_EMPTY										=16001
var	ERR_DDNS_USER_HAS_SPACE									=16002
var	ERR_DDNS_PWD_HAS_SPACE									=16003
var	ERR_DDNS_LIST_FULL										=16004
var	ERR_DDNS_LIST_INDEX_OUT_RANGE							=16005
var	ERR_DDNS_ENTRY_BE_DELETE								=16006

var	ERR_USER_NAME_LENGTH									=17000
var	ERR_USER_PWD_LENGTH										=17001
var	ERR_USER_NAME_ERROR										=17002
var	ERR_USER_PWD_ERROR										=17003
var	ERR_USER_PWD_INVALID_CHAR								=17004

var	ERR_SYS_TFTP_FAIL										=18000
var	ERR_SYS_TFTP_FILE_LENGTH								=18001
var	ERR_SYS_TFTP_SERVNOTFOUND								=18002
var	ERR_SYS_ERR_SOCKET										=18003
var	ERR_SYS_FAIL											=18004
var	ERR_SYS_FILE_VER										=18005
var ERR_SYS_DAYLIGHTSAVING_WRONG 							=18006

var	ERR_SESSION_LIMIT_TBL_FULL								=19000
var	ERR_SESSION_LIMIT_RECORD_ALREADY_FULL					=19001
var	ERR_SESSION_LIMIT_RECORD_ALREADY_EXIST					=19002

var	ERR_ARP_REC_IP_EXIST									=20000
var	ERR_ARP_FIXMAP_FULL										=20001
var	ERR_ARP_REC_IP_EXIST_ADD_SUCC							=20002
var	ERR_ARP_REC_IP_EXIST_ADD_FAIL							=20003
var	ERR_ARP_IP_EXIST_AND_FIXMAP_FULL						=20004
var	ERR_ARP_FIXMAP_FULL_IGNORE_OTHER_ENTRYS					=20005
var ERR_ARP_FIXMAP_MAC_ERR									=20006
var ERR_ARP_IP_SAME_AS_LANIP                                =20007
var ERR_ARP_IS_CONFILCT_WITH_STATIC_IP                      =20010

var	ERR_SYS_LOG_SYS_STATUS									=21000
var	ERR_SYS_LOG_SRV_ID										=21001
var	ERR_SYS_LOG_SRV_STATUS									=21002
var	ERR_SYS_LOG_SRV_ADDRESS									=21003
var	ERR_SYS_LOG_SRV_ADDR_EXIST								=21004
var	ERR_SYS_LOG_SRV_PORT									=21005
var	ERR_SYS_LOG_SETTING_EMERGENCY							=21006
var	ERR_SYS_LOG_SETTING_ALERT								=21007
var	ERR_SYS_LOG_SETTING_CRITICAL							=21008
var	ERR_SYS_LOG_SETTING_ERROR								=21009
var	ERR_SYS_LOG_SETTING_WARNING								=21010
var	ERR_SYS_LOG_SETTING_NOTICE								=21011
var	ERR_SYS_LOG_SETTING_INFORMATIONAL						=21012
var	ERR_SYS_LOG_SETTING_DEBUG								=21013
var	ERR_SYS_LOG_SETTING_EMPTY								=21014

var	ERR_FIREWALL_SYSLOG_SERVER_INVALID_ID					=22000
var	ERR_FIREWALL_SYSLOG_SERVER_NOT_DEFINED					=22001
var	ERR_FIREWALL_SCREEN_UNKNOWN_DEFENCE						=22002
var	ERR_FIREWALL_SCREEN_SCAN_THRESHOLD						=22003
var	ERR_FIREWALL_SCREEN_DOS_THRESHOLD						=22004

var	ERR_TDDP_UPLOAD_FILE_TOO_LONG							=23000
var	ERR_TDDP_UPLOAD_FILE_FORMAT_ERR							=23001
//added by ZQQ,08.05.19 the upload file is too big
var ERR_TDDP_UPLOAD_FILE_NAME_ERR                           =23002
var ERR_TDDP_UPLOAD_PRODUCT_INFO_ERR                        =23003

var	ERR_COMMON_ERROR										=25000
var	ERR_TDDP_DOWNLOAD_FILE_TOO_LONG							=25001
var ERR_VS_RECORD_CONFLICT_REMOTE_WEB_PORT                  =25002
var ERR_VS_RECORD_CONFLICT_FTP_PORT							=25004

var	ERR_DST_HOUR											=26000
var	ERR_DST_DAY												=26001
var	ERR_DST_MONTH											=26002
var	ERR_DST_BEGIN_END										=26003

var	ERR_WLAN_CONFIG_BASE									=26100
var	ERR_WLAN_CONFIG_SECURITY								=26101
var	ERR_WLAN_CONFIG_KEY										=26102
var	ERR_WLAN_MAC_FILTER_PAGE_NUM_ERROR						=26103
var	ERR_WLAN_MAC_FILTER_RECORD_ALREADY_EXIST				=26104
var	ERR_WLAN_MAC_FILTER_RECORD_ALREADY_FULL					=26105
/*wifi*/
var ERR_IP_NOT_IN_THE_SAME_SUBNET                           =26106
var ERR_WLAN_SSID_LEN                                       =26107
var ERR_WLAN_REGION                                         =26108
var ERR_WLAN_CHANNEL_WIDTH                                  =26109
var ERR_WLAN_STATIC_RATE                                    =26110
var ERR_WLAN_MODE                                           =26111      
var ERR_WLAN_OPER_MODE										=26112
var ERR_WLAN_BROADCAST                                      =26113
var ERR_WLAN_MAC_ADDR_INVALID                               =26114  
var ERR_WLAN_RADIUS_IP_INVALID                              =26115
var ERR_WLAN_MODE_UNSUPPORT_CFG								=26116

//qos

var ERR_QOS_TOTAL_EGRESS_100M								= 27000	/* ZJin 090903: make the err msg more detailedly */
var ERR_QOS_TOTAL_INGRESS_100M								= 27001
var ERR_QOS_TOTAL_EGRESS_1000M								= 27002
var ERR_QOS_TOTAL_INGRESS_1000M								= 27003
var ERR_QOS_NOBUF											= 27004
var ERR_QOS_NOENT											= 27005/* rule not exsited*/
var ERR_QOS_EXIST											= 27006/* rule existed*/
var ERR_QOS_USEDBW											= 27007/* total limit is less than assigned band*/
var ERR_QOS_NOBW											= 27008/* total limit is less than assigned band*/
var ERR_QOS_BADRULE											= 27009/* rule is conflict*/
var ERR_QOS_TYPE											= 27010/* err type*/
var ERR_QOS_MAX												= 27011/*the max error code */
var ERR_QOS_INGRESS_BANDWIDTH								= 27012/*download bandwidth is greater than total limit*/
var ERR_QOS_EGRESS_BANDWIDTH								= 27013/*upload bandwidth is greater than total limit*/

/*parental control*/
var ERR_PARENT_CTRL_FULL									=28000
var ERR_PARENT_CTRL_URLDESC									=28001
var ERR_PARENT_CTRL_SAME_MAC_WITH_PARENT					=28002

/*yandex dns*/
var ERR_MAC_CONFLICT										=28003
var ERR_YANDEX_DNS_TABLE_FULL								=28004
var ERR_YANDEX_DNS_NAT_TABLE_FULL							=28005
var ERR_NAT_MODE_CONFLICT									=28006

/*access control*/
var ERR_ACC_CTRL_HOST_FULL									=29000
var ERR_ACC_CTRL_TARGET_FULL								=29001
var ERR_ACC_CTRL_SCHEDULE_FULL								=29002
var ERR_ACC_CTRL_RULE_FULL									=29003
var ERR_ACC_CTRL_SAME_NAME									=29004
var ERR_ACC_CTRL_REFERED									=29005
var ERR_ACC_CTRL_RULE_CONFLICT								=29006
var ERR_ACC_PARTIAL_DEL										=29007
var ERR_ACC_DEL_NONE										=29008
var ERR_FILTER_MAC											=29009
var ERR_ACC_CTRL_HOST_IPSTART								=29010
var ERR_ACC_CTRL_HOST_IPEND									=29011
var ERR_ACC_CTRL_TARGET_IPSTART								=29012
var ERR_ACC_CTRL_TARGET_IPEND								=29013
var ERR_ACC_CTRL_HOST_IPSTART_NOT_IN_THE_SAME_SUBNET		=29014
var ERR_ACC_CTRL_HOST_IPEND_NOT_IN_THE_SAME_SUBNET			=29015

//USB Settings
var ERR_NAS_ACCOUNT_DUPLICATE								=33000				/* same account */
var	ERR_NAS_TOO_MANY_USER									=33001						/* user number limit */
var	ERR_FTP_SHAREFOLDER_DUPLICATE							=33002				/* */
var	ERR_FTP_TOO_MANY_SHAREFOLDER							=33003				/* folder is too many */
var ERR_FTP_INVALID_PORT									=33004				/* ftp server port conflict */
var ERR_NAS_ACCOUNT_CONFLICT_GUESTNETWORK					=33005
var ERR_INVALID_FLODER_PATH									=33006				/* ftp share folder invalid */

//VPN stuff
var ERR_VPN_SAME_NAME										=34000
var ERR_VPN_IKE_TABLE_FULL									=34001
var ERR_VPN_IKE_CONFLICT									=34002
var ERR_VPN_IKE_REFERED										=34003
var ERR_VPN_INDEX_NO_EXISTED								=34004
var ERR_VPN_DEL_PARTIAL										=34005
var ERR_VPN_DEL_NONE										=34006
var ERR_VPN_LOCAL_ID										=34007
var ERR_VPN_PEER_ID											=34008
var ERR_VPN_LOCAL_NET_IP									=34009
var ERR_VPN_LOCAL_NET_MSK									=34010
var ERR_VPN_PEER_NET_IP										=34011
var ERR_VPN_PEER_NET_MSK									=34012
var ERR_VPN_PEER_GW											=34013
var ERR_VPN_IPSEC_TABLE_FULL								=34014
var ERR_VPN_IPSEC_CONFLICT									=34015
var ERR_VPN_OTHER_ERROR										=34016
var ERR_VPN_SPI												=34017
var ERR_VPN_SAD_INVALID										=34018
var ERR_VPN_AUTH_KEY_INVALID								=34019
var ERR_VPN_ENCRYPT_KEY_INVALID								=34020
var ERR_VPN_STATIC_ROUTE_CONFLICT                           =34021


var ERR_USB_MODEM_LIST_FULL 								= 50000
var ERR_USB_MODEM_LIST_UPLOAD_TOO_MANY_ENTRIES				= 50001
var ERR_USB_MODEM_LIST_UPLOAD_PARSE_FAILED					= 50002
var ERR_USB_MODEM_ENTRY_ALREADY_EXIST						= 50003                           
						
//IPv6
var ERR_IPV6_STATICIP_ERROR_GATEWAY							=51000
var ERR_IPV6_STATICIP_ERROR_IP_DAD							= 51001
						
var str_err = new Array();
str_err[ERR_NO_ERROR]							=	"Error occurred, please try again.";
str_err[ERR_PPPOE_FIXED_IP]						=	"IP address specifies incorrectly. Please input another one.";
str_err[ERR_PPPOE_TIMING_SET]					=	"The setting of time-based Connecting is incorrect.";
str_err[ERR_PPPOE_STRING_TOO_LONG]				=	"The PPPOE string is too long.";
str_err[ERR_PPPOE_USERNAME_TOO_LONG]			=	"The Username is out of length 119. Please input another one.";
str_err[ERR_PPPOE_PWD_TOO_LONG]					=	"The password is out of length 119. Please input another one.";
str_err[ERR_PPPOE_AUTO_OFF_WAITE_TIME]			=	"The Max Idle time is out of range (10-99). Please input another number.";
str_err[ERR_PPPOE_LCP_MRU]						=	"MTU is out of range (576 - 1500). Please input another number.";
str_err[ERR_PPPOE_ECHO_REQ_INTERVAL]			=	"Interval seconds is out of range, please input another one  between 0~120!";
str_err[ERR_DHCP_SERVER_ADDR_POOL_ERROR]		=	"IP address pool is incorrect. Please try again.";
str_err[ERR_DHCP_SERVER_GATEWAY_ERROR]			=	"Bad Gateway, please input another one.";
str_err[ERR_DHCP_SERVER_DNS_ERROR]				=	"Bad Primary DNS Server IP address, please input another one.";
str_err[ERR_DHCP_SERVER_BAK_DNS_ERROR]			=	"Bad Secondary DNS Server IP address, please input another one.";
str_err[ERR_DHCP_SERVER_LEASE]					=	"Address lease time is out of range (1 ~ 2880). Please input another time.";
str_err[ERR_DHCP_SERVER_START_IP_ADDR]			=	"Bad IP address pool (the Starting or Ending IP address), please input another one.";
str_err[ERR_DHCP_SERVER_END_IP_ADDR]			=	"Bad IP address pool (the Starting or Ending IP address), please input another one.";
str_err[ERR_DHCP_SERVER_START_BIGGER_END]		=	"The Starting IP address is bigger than the Ending IP address.";
str_err[ERR_DHCP_SERVER_ADD_RANGE]				=	"The IP address pool is out of range 256. Please input another one.";
str_err[ERR_FIX_MAP_MAC_ADDR_ERROR]				=	"Bad MAC address, please input another one.";
str_err[ERR_FIX_MAP_IP_ADDR_ERROR]				=	"Bad IP address, please input another one.";
str_err[ERR_FIX_MAP_REC_EXIST]					=	"The entry already exists. Please input another entry.";
str_err[ERR_FIX_MAP_PAGE_NUM_ERROR]				=	"The page of Static IP address is incorrect. Please try again.";
str_err[ERR_FIX_MAP_RECORD_ALREADY_FULL]		=	"The DHCP reserved addresses table is already full.";
str_err[ERR_FIX_MAP_RECORD_MAC_ALREADY_EXIST]	=	"Another entry with the same MAC already exists.";
str_err[ERR_FIX_MAP_RECORD_IP_ALREADY_EXIST]	=	"Another entry with the same IP already exists.";
str_err[ERR_FIX_MAP_IP_EQUAL_LANIP]				=	"IP address should differ from LAN IP.";
str_err[ERR_FIX_MAP_CONFLICT_WHITH_FIX_ARP]     =   "The entry conflictes with the existing IP & MAC Binding entries.";
str_err[ERR_STATIC_ROUTR_ENABLE]				=	"The value is incorrect.";
str_err[ERR_STATIC_ROUTR_DESTINATION_IP]		=	"Bad destination IP address, please input another one.";
str_err[ERR_STATIC_ROUTR_SUBNETMASK_IP]			=	"Bad Subnet Mask, please input a correct Subnet Mask, <br> for example 255.255.255.0.";
str_err[ERR_STATIC_ROUTR_SUBNETMASK_DISMATCH_IP]=	"Subnet Mask doesn't match the Destination Network address, please enter again.";
str_err[ERR_STATIC_ROUTR_GATEWAY_IP]			=	"Bad Gateway, please input another IP address.";
str_err[ERR_STATIC_ROUTR_NOEMPTY]				=	"The static routing table is not empty.";
str_err[ERR_STATIC_ROUTR_DUPLICATION]			=	"The static routing entry already exists. Please input another one.";
str_err[ERR_STATIC_ROUTR_DEFAULT_GATEWAY]		=	"The input address is default Gateway. Please set it under the network's menu.";
str_err[ERR_STATIC_ROUTR_NOT_SAME_NETWORK]		=	"Gateway must be in the same subnet with WAN or LAN IP address.";
str_err[ERR_STATIC_ROUTR_CONFLICT_LAN_WAN]		=	"WAN or LAN IP parameters are conflict with static routing, please input another one.";
str_err[ERR_STATIC_DEST_CONFLICT_LAN]			=	"Destination Network address cannot be in the same subnet with LAN IP address, please enter again.";
str_err[ERR_STATIC_DEST_CONFLICT_WAN]			=	"Destination Network address cannot be inside the subnet of WAN IP address, please enter again.";
str_err[ERR_STATIC_ROUTR_ALREADY_FULL] 			=	"The static routing table is already full.";
str_err[ERR_STATIC_ROUTR_SAVE]					=	"Save failed!";
str_err[ERR_STATIC_ROUTR_OTHER]					=	"Other error happend.";
str_err[ERR_WAN_DOWN_BANDWIDTH]					=	"The download bandwith is out of range. Please input another one(0-10000).";
str_err[ERR_WAN_UP_BANDWIDTH]					=	"The upload bandwith is out of range. Please input another one(0-100000).";
//qos
str_err[ERR_QOS_NOBW]							=	"System can't satisfy the requested bandwith. Please input again.";
str_err[ERR_QOS_TOTAL_EGRESS_100M]				=	"The Egress Bandwidth is out of range. Please input another one(1-100000). Recommend that you set the bandwidth allocated by your ISP.";
str_err[ERR_QOS_TOTAL_INGRESS_100M]				=	"The Ingress Bandwidth is out of range. Please input another one(1-100000). Recommend that you set the bandwidth allocated by your ISP.";
str_err[ERR_QOS_TOTAL_EGRESS_1000M]				=	"The Egress Bandwidth is out of range. Please input another one(1-1000000). Recommend that you set the bandwidth allocated by your ISP.";
str_err[ERR_QOS_TOTAL_INGRESS_1000M]			=	"The Ingress Bandwidth is out of range. Please input another one(1-1000000). Recommend that you set the bandwidth allocated by your ISP.";
str_err[ERR_QOS_BADRULE]						=   "The rule you add conflicts with the existed rule, please input again.";

str_err[ERR_NETWORK_MTU]						=	"Incorrect MTU, please input another number(576 ~ 1500).";
str_err[ERR_LAN_IP_ERROR]						=	"Bad LAN IP address, please input another one.";
str_err[ERR_LAN_MASK_ERROR]						=	"Bad Subnet Mask for LAN IP, please input another one.";
str_err[ERR_WAN_IP_ERROR]						=	"Bad WAN IP address, please input another one.";
str_err[ERR_WAN_MASK_ERROR]						=	"Bad Subnet Mask for WAN IP, please input another one. <br> for example: 255.255.255.0.";
str_err[ERR_WAN_DNS_ERROR]						=	"Bad DNS Server IP address, please input another IP address. <br> for example: 202.96.134.188.";
str_err[ERR_WAN_BACKDNS_ERROR]					=	"Bad Secondary DNS Server IP address, please input another IP address. <br> for example: 202.96.134.188.";
str_err[ERR_WAN_GATE_ERROR]						=	"Bad Gateway for WAN IP, please input another one.";
str_err[ERR_WAN_LAN_CONFLICT]					=	"WAN IP address and LAN IP address cannot be in a same subnet. Please input another IP address.";
str_err[ERR_WAN_TYPE]							=	"Incorrect Internet connection type, please select a proper Internet connection type.";
str_err[ERR_LAN_IP_SET]							=	"Set LAN IP failed.";
str_err[ERR_LAN_MASK_SET]						=	"Set LAN mask failed.";
str_err[ERR_WAN_IP_SERVER]						=	"The server IP address is wrong.";
str_err[ERR_WAN_IP_SET]							=	"Set WAN IP failed.";
str_err[ERR_WAN_MASK_SET]						=	"Set WAN mask failed.";
str_err[ERR_WAN_DNS_SET]						=	"Set DNS failed.";
str_err[ERR_WAN_GATE_SET]						=	"Set WAN gateway failed.";
str_err[ERR_WAN_MAC_ADDR]						=	"Bad MAC address, please input correct MAC address.";
str_err[ERR_WAN_MAC_DUPLICATE]					=	"Two or more WAN interfaces have the same MAC.";
str_err[ERR_WAN_MAC_EQ_LAN_MAC]				 	=	"The WAN MAC address is the same with the LAN MAC address.";
str_err[ERR_SNTP_MONTH]							=	"Wrong format of month, please input another one(1-12)!";
str_err[ERR_SNTP_DAY]							=	"Wrong format of day, please input another one(1-31)!";
str_err[ERR_SNTP_YEAR]							=	"Wrong format of year, please input another one(1970-2037)!";
str_err[ERR_SNTP_HOUR]							=	"Wrong format of hour, please input another one(0-23)!";
str_err[ERR_SNTP_MINUTE]						=	"Wrong format of minute, please input another one(0-59)!";
str_err[ERR_SNTP_SECOND]						=	"Wrong format of second, please input another one(0-59)!";
str_err[ERR_SNTP_TIME_SET]						=	"Set time unsuccessfully. Please try again.";
str_err[ERR_SNTP_TIMEZONE]						=	"Incorrect time zone, please choose a correct time zone.";
str_err[ERR_SNTP_GET_GMT_FAILED]				=	"Get GMT unsuccessfully, make sure that you have already connected to Internet.";
str_err[ERR_SNTP_SERVER_A]						=	"The first ntp server address is invalid. Please input another one.";
str_err[ERR_SNTP_SERVER_B]						=	"The second ntp server address is invalid. Please input another one.";
str_err[ERR_SERVER_IP_ERROR]                    =   "Bad server IP address, please input another one.";
str_err[ERR_MORNITOR_PORT_ACTIVE_PORT]			=	"The active mirror port is blank. Please input another one.";
str_err[ERR_MORNITOR_PORT_PASSIVE_PORT]			=	"The passive mirrored port is blank. Please input another one.";
str_err[ERR_MORNITOR_PORT_EQUAL_PORT]			=	"The active mirror port cannot equal the passive mirror port. Please select another one.";
str_err[ERR_MORNITOR_NONE_PORT]					=	"The mirror port index is out of the range. Please input another one.";
str_err[ERR_TFTP_OVER_FILE_LEN]					=	"The length of the file name is incorrect. Please input the file with length less than 20.";
str_err[ERR_TFTP_IP_ERROR]						=	"TFTF Server's IP address is incorrect input.";
str_err[ERR_FIREWALL_START_TIME_FORMAT_ERROR]	=	"Bad starting time, please input another number in 24-hour time format hhmm. ";
str_err[ERR_FIREWALL_END_TIME_FORMAT_ERROR]		=	"Bad ending time, please input another number in 24-hour time format hhmm.";
str_err[ERR_FIREWALL_TIME_START_BIGGER_END]		=	"Starting time cannot be later than Ending time. Please input another time.";
str_err[ERR_FIREWALL_LAN_IP_FORMAT_ERROR]		=	"Bad LAN IP address, please input another one.";
str_err[ERR_FIREWALL_LAN_PORT_FORMAT_ERROR]		=	"LAN port is out of range (1~65535). Please input another number such as 8080.";
str_err[ERR_FIREWALL_WAN_IP_FORMAT_ERROR]		=	"Bad WAN IP address, please input another one such as 61.145.238.5.";
str_err[ERR_FIREWALL_WAN_PORT_FORMAT_ERROR]		=	"WAN port is out of range (1~65535). Please input another number such as 8080.";
str_err[ERR_FIREWALL_PROTOCOL_TYPE_ERROR]		=	"Incorrect protocol, please select a correct one.";
str_err[ERR_FIREWALL_RECORD_ALREADY_EXIST]		=	"This IP filtering entry already exists.";
str_err[ERR_FIREWALL_IP_RECORD_ALREADY_FULL]	=	"IP filtering entry list is already at maximum: 8.";
str_err[ERR_FIREWALL_DOMAIN_NAME_LEN_OVER]		=	"Domain name is out of length 30. Please input another one.";
str_err[ERR_FIREWALL_DOMAIN_NAME_ERROR]			=	"Illegal Domain name, please input another one.";
str_err[ERR_FIREWALL_DOMAIN_IS_SUBSET]			=	"Domain names contain each other (an entry contains another entry), please check and input!";
str_err[ERR_FIREWALL_DOMAIN_RECORD_ALREADY_FULL]=	"Domain filtering entry list is already at maximum: 8.";
str_err[ERR_FIREWALL_TIME_NOT_FULL]				=	"If you desire to set time, you must input both Starting time and Ending time.";
str_err[ERR_FIREWALL_TIME_FORMAT_ERROR]			=	"Wrong time format, please input another number in 24-hour time format hhmm.";
str_err[ERR_FIREWALL_WZD_TIME_ALREADY_EXIST]	=	"The entry's time range is conflicted with another entry.";
str_err[ERR_FIREWALL_WZD_TIME_IS_SUBSET]		=	"The entry's time range is contained by another entry.";
str_err[ERR_FIREWALL_WZD_IP_FORMAT_ERROR]		=	"Invalid address, please input another IP address or a range of IP addresses or Domain name. <br>If you input a range of IP addresses, make sure that starting IP address and ending IP address are in the same subnet and are available.";
str_err[ERR_FIREWALL_WZD_ADDR_ALREADY_EXIST]	=	"IP address or Domain name is conflicted.";
str_err[ERR_FIREWALL_WZD_PORT_FORMAT_ERROR]		=	"Incorrect port number,<br>please input another port number (1-65535) or a range of port numbers or two commas ',' to separate several ports.<br>If you input port, make sure that the number is available such as 8080 or 2300-9600.<br>";
str_err[ERR_FIREWALL_WZD_PORT_IS_SUBSET]		=	"The entry's port is contained or equaled by another entry's port.";
str_err[ERR_MAC_FILTER_PAGE_NUM_ERROR]			=	"The page number of MAC address filtering is error. Please try again!";
str_err[ERR_MAC_FILTER_RECORD_ALREADY_EXIST]	=	"The entry already exists. Please input another one.";
str_err[ERR_MAC_FILTER_RECORD_ALREADY_FULL]		=	"MAC address filtering list is already at maximum: 16.";
str_err[ERR_REMOTE_MANAGE_IP_FORMAT_ERROR]		=	"Bad IP address, please input another one.";
str_err[ERR_REMOTE_MANAGE_PORT_FORMAT_ERROR]	=	"Incorrect port, please input another one.";
str_err[ERR_REMOTE_MANAGE_PORT_OUT_OF_RANGE]	=	"Port is out of range (1-65535), please input another one.";
str_err[ERR_REMOTE_MANAGE_PORT_OCCUPIED_PORT]	=	"The remote management port number for the browser is not supported (21, 25, 110, 119, 139, 145, 445 etc.), please reenter.";
str_err[ERR_REMOTE_MANAGE_PORT_CONFLICT_PORT]	=	"The port of the remote web management is conflicting with of the virtual server.";
str_err[ERR_DMZ_HOST_IP_ADDR]					=	"Invalid DMZ Host, please input another one.";
str_err[ERR_DMZ_IP_IS_DEV_IP]					=	"The DMZ host IP address cannot be used for the device IP address. Please reenter.";
str_err[ERR_VS_PAGE_NUM_ERROR]					=	"The page number of Virtual Server is error. Please try again!";
str_err[ERR_VS_PORT_OUT_RANGE]					=	"Port is out of range (1-65535). Please input another one.";
str_err[ERR_VS_PORT_FORMAT_ERROR]				=	"Port format is incorrect. You can input a port or a port range such as 1024-2048. ";
str_err[ERR_VS_IP_ADDRESS]						=	"IP address is incorrect. Please input another one.";
str_err[ERR_VS_RECORD_ALREADY_EXIST]			=	"The entry already exists or its port is contained by another one.";
str_err[ERR_VS_PROTOCOL_TYPE_ERROR]				=	"Bad protocol type, please re-select it.";
str_err[ERR_VS_RECORD_ALREADY_FULL]				=	"Virtual Server entries at maximum: 16.";
str_err[ERR_VS_PORT_OCCUPIED]					=	"Error: The port of the remote web management is conflicting with of the virtual server.";
str_err[ERR_SPECIAL_APP_PUBLIC_PORT]			=	"Wrong incoming port format, please input another one.";
str_err[ERR_SPECIAL_APP_DUPLICATE_PUBLIC_PORT]	=	"This entry's Incoming port conflict with another entry's Incoming port behind it.<br>The entries' incoming port can not contain or equal each other, or not will result in error.";
str_err[ERR_SPECIAL_APP_DUPLICATE_TAG_PORT]		=	"This entry's Trigger condition (Trigger port and Trigger Protocol) conflict with another entry's Trigger condition behind it, please input another entry.<br>Two entries trigger protocol cannot set same when they have same trigger port.";
str_err[ERR_SPECIAL_APP_RECORD_ALREADY_FULL]	=	"Port Triggering list is already at maximum: 16.";
str_err[ERR_DDNS_USER_NAME_EMPTY]				=	"User name is NULL. Please input another one.";
str_err[ERR_DDNS_PWD_EMPTY]						=	"Password is NULL. Please input another one.";
str_err[ERR_DDNS_USER_HAS_SPACE]				=	"User name contains space. Please input another one.";
str_err[ERR_DDNS_PWD_HAS_SPACE]					=	"Password is NULL. Please input another one.";
str_err[ERR_DDNS_LIST_FULL]						=	"DDNS table is already full.";
str_err[ERR_DDNS_LIST_INDEX_OUT_RANGE]			=	"The index is out of range.";
str_err[ERR_DDNS_ENTRY_BE_DELETE]				=	"This entry has been deleted.";
str_err[ERR_USER_NAME_LENGTH]					=	"The user name is out of length 15. Please input another one.";
str_err[ERR_USER_PWD_LENGTH]					=	"The password is out of length 15. Please input another one.";
str_err[ERR_USER_NAME_ERROR]					=	"Old user Name is incorrect. Please input another one.";
str_err[ERR_USER_PWD_ERROR]						=	"Old password is incorrect. Please input another one.";
str_err[ERR_USER_PWD_INVALID_CHAR]				=	"User Name or Password contains illegal character. Please input another one.";
str_err[ERR_SYS_TFTP_FAIL]						=	"Error occurred, please try again.";
str_err[ERR_SYS_TFTP_FILE_LENGTH]				=	"Upgrade unsuccessfully because the length of the upgraded file is incorrect. Please check the file name.";
str_err[ERR_SYS_TFTP_SERVNOTFOUND]				=	"Upgrade unsuccessfully, make sure that you have launched the TFTP server.";
str_err[ERR_SYS_ERR_SOCKET]						=	"Upgrade unsuccessfully, make sure that you have launched the TFTP server and the upgraded file was in correct directory.";
str_err[ERR_SYS_FAIL]							=	"File transmit failed, please check the inputted file name.";
str_err[ERR_SYS_FILE_VER]						=	"Upgrade unsuccessfully because the version of the upgraded file was incorrect. Please check the file name.";
str_err[ERR_SYS_DAYLIGHTSAVING_WRONG]			=	"Invalid daylight saving time. Please check whether start time and end time are valid.";
/* zqq,07.10.29*/
str_err[ERR_SESSION_LIMIT_TBL_FULL]				=	"The session limit table is already full.";
str_err[ERR_SESSION_LIMIT_RECORD_ALREADY_FULL]	=	"The sessions to an IP address is full.";
str_err[ERR_SESSION_LIMIT_RECORD_ALREADY_EXIST]	=	"The session limit entry already exists.";
str_err[ERR_ARP_REC_IP_EXIST]					=	"The entry already exists, please input another one!";
str_err[ERR_ARP_FIXMAP_FULL]					=	"The IP & MAC Binding table is full.";
str_err[ERR_ARP_REC_IP_EXIST_ADD_SUCC]			=	"Ignore the entries conflict with the existing entries, only added the valid entrys.";
str_err[ERR_ARP_REC_IP_EXIST_ADD_FAIL]			=	"All the entries to be added is conflicted with the existing entries";
str_err[ERR_ARP_IP_EXIST_AND_FIXMAP_FULL]		=	"The IP & MAC Binding table is full.";
str_err[ERR_ARP_FIXMAP_FULL_IGNORE_OTHER_ENTRYS]=	"The IP & MAC Binding table is full. Ignore the spare entries.";
str_err[ERR_ARP_IP_SAME_AS_LANIP]               =   "It is forbidden to bind the LAN IP with other MAC addresses.";
str_err[ERR_ARP_IS_CONFILCT_WITH_STATIC_IP]     =   "The entry conflictes with the existing reserved addresses.";
str_err[ERR_SYS_LOG_SYS_STATUS]					=	"Syslog system status is invalid.";
str_err[ERR_SYS_LOG_SRV_ID]						=	"Syslog server ID is invalid.";
str_err[ERR_SYS_LOG_SRV_STATUS]					=	"Syslog server status is invalid.";
str_err[ERR_SYS_LOG_SRV_ADDRESS]				=	"Syslog server address is invalid.";
str_err[ERR_SYS_LOG_SRV_ADDR_EXIST]				=	"Syslog server address exists.";
str_err[ERR_SYS_LOG_SRV_PORT]					=	"Syslog server port is invalid.";
str_err[ERR_SYS_LOG_SETTING_EMERGENCY]			=	"Syslog setting emergency is invalid.";
str_err[ERR_SYS_LOG_SETTING_ALERT]				=	"Syslog setting alert is invalid.";
str_err[ERR_SYS_LOG_SETTING_CRITICAL]			=	"Syslog setting critical is invalid.";
str_err[ERR_SYS_LOG_SETTING_ERROR]				=	"Syslog setting is invalid.";
str_err[ERR_SYS_LOG_SETTING_WARNING]			=	"Syslog setting warning is invalid.";
str_err[ERR_SYS_LOG_SETTING_NOTICE]				=	"Syslog setting notice is invalid.";
str_err[ERR_SYS_LOG_SETTING_INFORMATIONAL]		=	"Syslog setting informational is invalid.";
str_err[ERR_SYS_LOG_SETTING_DEBUG]				=	"Syslog setting debug is invalid.";
str_err[ERR_SYS_LOG_SETTING_EMPTY]				=	"Syslog settings are empty.";
str_err[ERR_FIREWALL_SYSLOG_SERVER_INVALID_ID]	=	"Firewall syslog server is invalid.";
str_err[ERR_FIREWALL_SYSLOG_SERVER_NOT_DEFINED]	=	"Firewall syslog server is not defined.";
str_err[ERR_FIREWALL_SCREEN_UNKNOWN_DEFENCE]	=	"Firewall screen defence is unknow.";
str_err[ERR_FIREWALL_SCREEN_SCAN_THRESHOLD]		=	"Firewall screen threshold is invalid.";
str_err[ERR_FIREWALL_SCREEN_DOS_THRESHOLD]		=	"Firewall screen DoS threshold is invalid.";

str_err[ERR_TDDP_UPLOAD_FILE_TOO_LONG]			=	"The uploaded file is too large! ";
str_err[ERR_TDDP_UPLOAD_FILE_FORMAT_ERR]		=	"Incorrect file format!";
str_err[ERR_TDDP_UPLOAD_FILE_NAME_ERR]          =   "The uploaded file name is too long!";
str_err[ERR_TDDP_UPLOAD_PRODUCT_INFO_ERR]		=	"The configuration file restored unsuccessfully as the hardware or software versions do not match!";
str_err[ERR_COMMON_ERROR]						=	"Error occurred, please try again.";
str_err[ERR_DST_HOUR]							=	"Incorrect DST time , please choose correct time .";
str_err[ERR_DST_DAY]							=	"Incorrect DST time , please choose correct time .";
str_err[ERR_DST_MONTH]							=	"Incorrect DST time , please choose correct time .";
str_err[ERR_DST_BEGIN_END]						=	"The DST begin time  must not equal to  the DST end time .";
str_err[ERR_TDDP_DOWNLOAD_FILE_TOO_LONG]		=	"The downloaded file is too long! ";
str_err[ERR_VS_RECORD_CONFLICT_REMOTE_WEB_PORT] =   "The port of the virtual server is conflicting with that of the remote web management.";
str_err[ERR_VS_RECORD_CONFLICT_FTP_PORT]		=	"The port of the virtual server is conflicting with that of the FTP server."
str_err[ERR_WLAN_CONFIG_BASE]					=	"Invalid wireless setting(s)!";
str_err[ERR_WLAN_CONFIG_SECURITY]				=	"Invalid wireless security setting(s)!";
str_err[ERR_WLAN_CONFIG_KEY]					=	"Invalid wireless WEP key(s)!";
str_err[ERR_WLAN_MAC_FILTER_PAGE_NUM_ERROR]		=	"Invalid MAC page, please try again!";
/* changed by wangbiao 10Jun14 */
/* changed "ACL" to "Access Control List (ACL)" to be friendly to user*/
str_err[ERR_WLAN_MAC_FILTER_RECORD_ALREADY_EXIST]=	"Wireless Access Control List (ACL) entry already exists, please input another one!";
str_err[ERR_WLAN_MAC_FILTER_RECORD_ALREADY_FULL]=	"Already reach the max number of wireless Access Control List (ACL) entries: 32";
/* end changed*/
// add by lsz 071103
str_err[ERR_IP_NOT_IN_THE_SAME_SUBNET]          =	"The IP address is not in the same subnet with LAN IP address.";
str_err[ERR_WLAN_SSID_LEN]                      =   "The length of SSID is incorrect. Please input another one.";
str_err[ERR_WLAN_REGION]                        =   "The region is incorrect.";
str_err[ERR_WLAN_CHANNEL_WIDTH]                 =   "The channel width is incorrect.";
str_err[ERR_WLAN_STATIC_RATE]                   =   "The static rate is incorrect.";
str_err[ERR_WLAN_MODE]                          =   "The mode setting is incorrect.";
str_err[ERR_WLAN_OPER_MODE]						=	"The operation mode's setting is incorrect.";
str_err[ERR_WLAN_BROADCAST]                     =   "The SSID broadcast setting is incorrect.";
str_err[ERR_WLAN_MAC_ADDR_INVALID]              =   "The MAC address is incorrect. Please input another one.";
str_err[ERR_WLAN_RADIUS_IP_INVALID]				=	"The radius server IP is invalid. Please input another one.";
str_err[ERR_WLAN_MODE_UNSUPPORT_CFG]			=	"";
//parental control
str_err[ERR_PARENT_CTRL_FULL]					=	"The parental control list is full. ";
str_err[ERR_PARENT_CTRL_URLDESC]				=	"This website list name has been used. ";
str_err[ERR_PARENT_CTRL_SAME_MAC_WITH_PARENT]	=	"MAC address of children's PC should differ from that of parental PC.";

//yandex dns
str_err[ERR_MAC_CONFLICT]						=	"The MAC has already in another rule";
str_err[ERR_YANDEX_DNS_TABLE_FULL]				=	"The Internet Blocking list is full";
str_err[ERR_YANDEX_DNS_NAT_TABLE_FULL]			=	"The Yandex.Dns list is full";
	
//rule filter
str_err[ERR_ACC_CTRL_HOST_FULL]					=	"The host list is full. ";
str_err[ERR_ACC_CTRL_TARGET_FULL]				=	"The target list is full. ";
str_err[ERR_ACC_CTRL_SCHEDULE_FULL]				=	"The schedule table is full. ";
str_err[ERR_ACC_CTRL_RULE_FULL]					=	"The access control policy management table is full. ";
str_err[ERR_ACC_CTRL_SAME_NAME]					=	"This list name has been used. ";
str_err[ERR_ACC_CTRL_REFERED]					=	"This item is being used and can't be deleted. ";
str_err[ERR_ACC_CTRL_RULE_CONFLICT]				=	"This rule has been set.";
str_err[ERR_ACC_PARTIAL_DEL]					=	"Some entries can not be deleted for they are being used, while all the other free entries have been deleted. ";
str_err[ERR_ACC_DEL_NONE]						=	"All the items are being used, can't be deleted.";
str_err[ERR_FILTER_MAC]							=	"Wrong MAC address. ";
str_err[ERR_ACC_CTRL_HOST_IPSTART]				=	"Wrong Start IP Address.";
str_err[ERR_ACC_CTRL_HOST_IPEND]				=	"Wrong End IP Address.";
str_err[ERR_ACC_CTRL_TARGET_IPSTART]			=	"Wrong Start IP Address.";
str_err[ERR_ACC_CTRL_TARGET_IPEND]				=	"Wrong End IP Address.";
str_err[ERR_ACC_CTRL_HOST_IPSTART_NOT_IN_THE_SAME_SUBNET] = "Start IP address must be in the same subnet with LAN IP address.";
str_err[ERR_ACC_CTRL_HOST_IPEND_NOT_IN_THE_SAME_SUBNET] = "End IP address must be in the same subnet with LAN IP address.";

//nas
str_err[ERR_NAS_ACCOUNT_DUPLICATE]				=	"Duplicate user account.";
str_err[ERR_FTP_INVALID_PORT]					=	"Port number might have conflict with other programs in the router. Please choose another number.";
str_err[ERR_NAS_TOO_MANY_USER]					=	"Too many users.";
str_err[ERR_FTP_SHAREFOLDER_DUPLICATE]			=	"Duplicate share folder.";
str_err[ERR_FTP_TOO_MANY_SHAREFOLDER]			=	"Too many share folders.";
str_err[ERR_NAS_ACCOUNT_CONFLICT_GUESTNETWORK]	=	"User account conflicts with the Guset Network's account.";
str_err[ERR_INVALID_FLODER_PATH]				= 	"Invalid share folder path or share folder name! The folder name can not include any one character as follows:<br> + \ / : * ? \" < > | # & <br> , please check it and try again.";

// VPN stuff
str_err[ERR_VPN_SAME_NAME]						=	"Policy name conflicts with exist one.";
str_err[ERR_VPN_IKE_TABLE_FULL]					=	"IKE security policy list is full.";
str_err[ERR_VPN_IKE_CONFLICT]					=	"IKE security policy conflicts with exist one.";
str_err[ERR_VPN_IKE_REFERED]					=	"IKE security policy has been used by IPsec policy, can not be deleted.";
str_err[ERR_VPN_INDEX_NO_EXISTED]				=	"Request policy index is not exist.";
str_err[ERR_VPN_DEL_PARTIAL]					=	"Error when delete policy, the list is not be cleared.";
str_err[ERR_VPN_DEL_NONE]						=	"Error when delete policy, did not specified any policy.";
str_err[ERR_VPN_LOCAL_ID]						=	"Local ID is not correct.";
str_err[ERR_VPN_PEER_ID]						=	"Peer ID is not correct.";
str_err[ERR_VPN_LOCAL_NET_IP]					=	"Local subnet is not correct.";
str_err[ERR_VPN_LOCAL_NET_MSK]					=	"Local subnet mask length is not correct.";
str_err[ERR_VPN_PEER_NET_IP]					=	"Peer subnet is not correct.";
str_err[ERR_VPN_PEER_NET_MSK]					=	"Peer subnet mask length is not correct.";
str_err[ERR_VPN_PEER_GW]						=	"Peer gateway is not correct.";
str_err[ERR_VPN_IPSEC_TABLE_FULL]				=	"IPsec policy is full.";
str_err[ERR_VPN_IPSEC_CONFLICT]					=	"IPsec policy confilcts with exist one.";
str_err[ERR_VPN_OTHER_ERROR]					=	"Unknow error.";
str_err[ERR_VPN_SPI]							=	"Duplicate SPI valude��or  conflicts with exist policy.";
str_err[ERR_VPN_SAD_INVALID]					=	"Can not read security alliance information.";
str_err[ERR_VPN_AUTH_KEY_INVALID]				=	"Check key error.";
str_err[ERR_VPN_ENCRYPT_KEY_INVALID]			=	"Encryption key error.";
str_err[ERR_VPN_STATIC_ROUTE_CONFLICT]			=	"IPsec policy conflicts with static route.";

// Mobile
str_err[ERR_USB_MODEM_LIST_FULL]				=	"3G USB modem list is full.";
str_err[ERR_USB_MODEM_LIST_UPLOAD_TOO_MANY_ENTRIES]	=	"The uploaded file contains too many 3G USB modem entries.";
str_err[ERR_USB_MODEM_LIST_UPLOAD_PARSE_FAILED]	=	"Failed to parse the 3G usb modem configuration file, please check it.";
str_err[ERR_USB_MODEM_ENTRY_ALREADY_EXIST]		= 	"3G Usb modem entry already exists, please check uploaded file or delete all usb modem entries!";

//IPV6
str_err[ERR_IPV6_STATICIP_ERROR_GATEWAY]		= 	"The gateway or address is error."
str_err[ERR_IPV6_STATICIP_ERROR_IP_DAD]			= 	"Duplicate address detection(DAD) failed, IP address is conflicting."

