var languageNum = new Array("en","tc","sc","de","fr","es","it","jp");
var item_name = new Array(
"影像壓縮",
"MPEG4",
"MJPEG",
"手動錄影",
"快照",
"目錄瀏覽",
"談話",
"聽現場音",
"夜晚模式",
"安裝設定精靈",
"攝影機設定",
"攝影機名稱",
"置放地點",
"請輸入管理者密碼",
"確認密碼",
"下一步 >",
"取消",
"網路位址(IP)設定",
"動態網路位址(DHCP)",
"固定網路位址",
"網路位址(IP)",
"子網路遮罩",
"預設閘道",
"主要網域伺服器(DNS)",
"次要網域伺服器(DNS)",
"寬頻撥接",
"撥接帳號",
"撥接密碼",
"< 上一步",
"電子郵件(E-Mail)",
"外送郵件伺服器位址(SMTP Server)",
"送件人郵件位址",
"認證模式",
"外送郵件帳號",
"密碼",
"收件者 #1 電子郵件位址",
"收件者 #2 電子郵件位址",
"無線網路",
"無線網路基地台名稱(SSID)",
"站台搜尋",
"連線模式",
"架構式",
"點對點",
"無線網路頻道",
"認證模式",
"編碼模式",
"無",
"WEP",
"TKIP",
"AES",
"編碼格式",
"標準編碼",
"十六進位",
"編碼長度",
"64 位元",
"128 位元",
"WEP 金鑰 1",
"WEP 金鑰 2",
"WEP 金鑰 3",
"WEP 金鑰 4",
"預先共用金鑰",
"確定設定",
"網路位址(IP)模式",
"IPv4 網路位址",
"主要網域伺服器(DNS)",
"次要網域伺服器(DNS)",
"無線網路基地台名稱(SSID)",
"連線模式",
"確定",
"基本設定",
"系統設定",
"日期與時間",
"使用者設定",
"網路設定",
"網路位址過濾",
"無線網路",
"影音設定",
"攝影機設定",
"影像設定",
"音效設定",
"事件伺服器",
"檔案上傳(FTP)",
"電子郵件",
"網路儲存",
"位移偵測",
"事件調整",
"一般設定",
"時程資訊",
"位移偵測觸發",
"時程觸發",
"應用工具",
"USB 設定",
"相關資訊",
"本機相關資訊",
"系統記錄",
"LED 設定",
"LED 控制",
"一般設定",
"關閉",
"時區",
" 與此台電腦時間同步 ",
"與網路時序伺服器時間同步",
"網路時序伺服器位址(NTP Server)",
"更新間隔",
"小時",
"手動設定",
"日期",
"時間",
"管理者帳號",
"修改",
"一般使用者帳號",
"使用者清單",
"新增/修改",
"刪除",
"訪客帳號",
"動態網路名稱伺服器設定",
"開啟",
"動態網路名稱伺服器服務提供者",
"輸入自訂動態網路名稱",
"通用隨插即用協定",
"網路埠號 (Port)",
"HTTP 埠號 (HTTP Port)",
"(預設: 80) ",
"RTSP 埠號 (RTSP Port)",
"(預設: 554)",
"開始網路位址區段(IP)",
"結束網路位址區段(IP)",
"新增",
"拒絕使用網路位址清單(IP)",
"無線網路設定",
"影音設定",
"影像設定",
"亮度",
"對比",
"飽和度",
"(0~100)",
"預設參數",
"鏡射模式",
"垂直鏡射",
"水平鏡射",
"燈光頻率",
"50Hz",
"60Hz",
"室外",
"重疊設定",
"包含日期時間",
"開啟不透明",
"影像解析度",
"影像品質",
"影像順暢度",
"自動設定",
"至 ",
"fps(每秒單張影像數量)",
"3GPP (3G影像支援)",
"關閉",
"3GPP 不包含音效",
"3GPP 包含音效",
"攝影機麥克風",
"攝影機喇叭",
"音量",
"事件伺服器",
"事件伺服器",
"檔案伺服器位址(FTP)",
"伺服器埠號(Port)",
"檔案目錄",
"被動登入模式",
"測試",
"網路儲存設定",
"網路分享伺服器位址(SAMBA)",
"分享",
"目錄",
"訪客模式",
"檔案設定條件",
"依檔案容量儲存",
"(MB)",
"依錄影長度儲存 ",
"(分鐘)",
"當儲存空間已滿即",
"停止錄影",
"循環錄影 - 刪除舊有資料",
"位移偵測",
"位移偵測設定",
"事件調整",
"一般設定",
"擷取畫面/錄影存檔目錄",
"每次事件網路儲存錄影時間",
"秒",
"設定時程資訊",
"位移偵測觸發",
"(*請先設定相關伺服器應用參數)",
"設定動作",
"發送電子郵件",
"檔案上傳(FTP)",
"錄影至網路儲存設備",
"儲存影像至USB裝置",
"時程觸發",
"電子郵件時程",
"間隔",
"檔案上傳時程(FTP)",
"網路儲存時程(Net Storage)",
"系統應用工具",
"回復出廠值設定",
"回復出廠值設定將會取消目前所有設定",
"網路攝影機重啟",
"網路攝影機將會重新啟動 ",
"重新啟動",
"資料設定",
"備份",
"備份本機設定檔",
"回存",
"更新本機韌體",
"目前本機韌體版本",
"選擇韌體檔案",
"更新",
"USB 設定",
"USB 裝置取消連線",
"手動並安全的取消 USB裝置的連線",
"取消連線",
"USB 裝置相關資訊",
"USB 裝置總容量",
"USB 裝置剩餘空間",
"相關資訊",
"本機相關資訊",
"韌體版本",
"MPEG4 影像解析度",
"MJPEG 影像解析度",
"3GPP 開啟",
"麥克風狀態",
"喇叭狀態",
"通用隨插即用協定開啟",
"系統記錄",
"系統記錄表",
"重新整理",
"事件",
"錄影中...",
"手動觸發完成",
"手動",
"儲存完成",
"儲存失敗!",
"談話中...",
"聽現場音中...",
"搜尋中..",
"永遠",
"camera 1",
"meeting room 1",
"網卡編號",
"傳輸模式",
"認證模式",
"信號強度",
"上一步",
"日期和時間",
"SMTP",
"時程資訊名稱",
"日期",
"周日",
"周一",
"周二",
"周三",
"周四",
"周五",
"周六",
"時間清單",
"週一至週日通用",
"指定時間週一至週日刪除",
"開始時間",
"結束時間",
"儲存",
"回復",
"網卡編號",
"使用者名稱",
"密碼",
"服務提供者登入帳號",
"服務提供者登入密碼",
"錯誤",
"測試 伺服器",
"GPIO觸發輸出持續時間",
"觸發輸出",
"水平旋轉掃描",
"暫停",
"自動巡弋",
"位置名稱",
"水平旋轉/垂直傾斜",
"水平旋轉及垂直傾斜",
"水平旋轉/垂直傾斜校正",
"校正",
"水平旋轉速度",
"垂直傾斜速度",
"水平旋轉步數",
"垂直傾斜步數",
"水平旋轉掃描速度",
"自動巡弋停留時間",
"GPIO觸發",
"移到設定位置",
"水平旋轉及垂直傾斜設定",
"度數",
"單一快照",
"事件前",
"事件後",
"Bonjour",
"友善名稱",
"郵件附加檔設定",
"檔案上傳設定",
"群播",
"群組IP",
"埠號",
"(預設: 1234)",
"TTL",
"(1~255)",
"RS-485",
"RS-485 傳輸設定",
"一般協定設定",
"協定",
"自訂協定設定",
"鮑率",
"原點",
"上",
"下",
"左",
"右",
"名稱",
"命令",
"外部命令 1",
"外部命令 2",
"外部命令 3",
"外部命令 4",
"外部命令 5",
"進階",
"HTTPS",
"HTTPS 埠號",
"色度",
"銳利度",
"(-50~50)",
"重疊/遮罩",
"日期時間",
"文字重疊",
"隱私遮罩",
"包含文字標題",
"拒絕",
"接受",
"接受的IP串列",
"SMTP 埠號",
"外送郵件伺服器需要安全連線 (SSL)",
"QoS",
"即時影像DSCP",
"即時語音DSCP",
"群播/單一傳播",
"即時傳訊",
"即時傳訊",
"Jabber 伺服器位址",
"Jabber ID",
"Jabber 密碼",
"收件者",
"訊息",
"手動指定Jabber伺服器位址/連接埠號",
"Jabber 埠號",
"使用安全連線",
"使用安全認證",
"遮罩區域 1",
"遮罩區域 2",
"位置",
"X",
"Y",
"寬度",
"高度",
"遮罩區域顏色",
"開啟觸發輸入1",
"開啟觸發輸入2",
"(*針對X,Y,寬度及高度，請使用8的倍數)",
"AES",
"BLC",
"WPS",
"WPS設定",
"防護設定",
"PIN 模式",
"PIN 碼",
"登錄者 ID(SSID)",
"PBC 模式",
"裝置狀態",
"認證",
"ENC",
"回復到未設定前",
"連接",
"取消 ",
"自動光圈",
"H.264",
"語系",
"預設語言",
"IPv6 網路位址",
"IPv6 預設閘道",
"非IE瀏覽器",
"H.264 影像解析度",
"IPv4 子網路遮罩",
"IPv4 預設閘道",
"RTSP",
"RTSP 串流",
"群播設定",
"網路攝影機",
"無線",
"網路位址",
"IPv4",
"IPv6",
"產生",
"類別",
"動作",
"H.264 埠號 (H.264 Port)",
"MPEG4 埠號 (MPEG4 Port)",
"即時語音埠號 (Audio Port)",
"(預設: 1236)",
"(預設: 1238)",
"編碼格式",
"檔案格式",
"MP4",
"AVI",
"SSL",
"廣域網路位址",
"(預設: 443)",
"自動調整日光節約時間",
"SD卡設定",
"錄影至SD卡",
"SD卡設定",
"SD卡取消連線",
"手動並安全的取消 SD卡的連線",
"SD卡相關資訊",
"SD卡總容量",
"SD卡剩餘空間",
"每次事件儲存錄影時間",
"錄影至SD卡",
"裝置忙碌中",
"IR LED 設定",
"IR LED 控制",
"廣域網路位址更改通知",
"STARTTLS",
"放大",
"縮小",
"水平旋轉",
"垂直傾斜",
"像素",
"紅外截止設定",
"紅外截止控制",
"電源LED控制",
"網絡LED控制",
"YouTube",
"YouTube 設定",
"YouTube 錄影和上傳",
"公開",
"私人",
"觸發輸出中...",
"白光LED",
"白光LED啟動中...",
"白光LED持續時間",
"PIR觸發",
"當上載失敗",
"重試",
"關鍵字",
"標題",
"描述",
"類別",
"開發金鑰",
"來源",
"每天",
"WDRC",
"(0~11)",
"我的 Android",
"Android上的Google(Gmail)帳號",
"攝影機上的Google(Gmail)帳號",
"帳號設定",
"Google Talk 設定",
"攝影機上的Google Talk帳號",
"Gmail 設定",
"攝影機上的Google Mail帳號",
"Picasa 設定",
"Android上的Picasa帳號",
"YouTube 設定",
"Android上的YouTube設定",
"Picasa",
"錄影至USB裝置",
"(上傳至 YouTube)",
"上傳影像至Picasa",
"(*必須安裝USB裝置)",
"上傳錄影檔案至YouTube",
"循環 - 刪除舊有相簿",
"停止",
"視頻服務器",
"變焦速度",
"聚焦速度",
"對焦變遠",
"對焦變近",
"光圈開大",
"光圈關小",
"+雲台控制",
"-雲台控制",
"自動對焦",
"手動對焦",
"巡弋",
"巡弋設定",
"前往",
"預設位置",
"巡弋路徑",
"停留時間",
"消除",
"啟動預設",
"裝置識別碼",
"(Pelco-D:0~254 Pelco-P:1~32)",
"伺服器名稱",
"基本設定",
"音源輸入",
"音源輸出",
"巡弋位置",
"新增為巡弋位置",
"檔案上傳設定",
"固定鏡頭",
"光圈可調鏡頭",
"TV 模式",
"NTSC",
"PAL",
"檔案名稱",
"下載",
"檔案管理員",
"檔案管理員",
"2倍",
"4倍",
"8倍",
"自動增益",
"黑準位",
"(0~5)",
"Setting",
"Direct Video Stream Authentication",
"User Accounts",
"IPv4 Address Range",
"Start",
"End",
"Filename Prefix",
"Recording Interval",
"GPIO Trigger Out Interval",
"Snapshot/Recording Filename Prefix",
"GPIO Trigger Out Per Event",
"Factory reset will restore the device's factory default settings.",
"Reboot the device.",
"Backup the device configurations. Click the button bellow and save the device configurations to your local harddrive.",
"Restore your device's configuration from a backup file.",
"Rebooting",
"SIP",
"SIP Setting",
"Registrar",
"Proxy",
"SIP Port",
"RTP Video Port",
"RTP Audio Port",
"STUN",
"Server",
"Multimedia",
"Enable Video Codec",
"Enable Audio Codec",
"夜間模式",
"黑白",
"彩色",
"自動刪除",
"網路斷線觸發",
"High",
"Medium",
"Low",
"ON",
"快門速度",
"快",
"AE控制",
"慢",
"HTTP",
"主機",
"查詢",
"HTTP Notify For Motion Trigger",
"HTTP Notify",
"HTTP Notify For GPIO Trigger"
);
						  
var _COMPRESSION = 0;
var _MPEG4 = 1;
var _MJPEG = 2;
var _MANUAL_RECORD = 3;
var _SNAPSHOT = 4;
var _BROWSE = 5;
var _TALK = 6;
var _LISTEN = 7;
var _NIGHTMODE = 8;
var _SMART_WIZARD = 9;
var _CAM_SETTING = 10;
var _CAM_NAME = 11;
var _LOCATION = 12;
var _ADMIN_PWD = 13;
var _CONFIRM_PWD = 14;
var _NAXT = 15;
var _CANCEL = 16;
var _IP_SETTING = 17;
var _DHCP = 18;
var _STATIC_IP = 19;
var _IP = 20;
var _SUBNET_MASK = 21;
var _DEFAULT_GW = 22;
var _PRI_DNS = 23;
var _SEC_DNS = 24;
var _PPPOE = 25;
var _PPPOE_USER = 26;
var _PPPOE_PWD = 27;
var _PREV = 28;
var _EMAIL_SETTING = 29;
var _SMTP_SERVER = 30;
var _SENDER_EMAIL = 31;
var _AUTH_MODE = 32;
var _SENDER_USER = 33;
var _SENDER_PWD = 34;
var _RECEIVER_1 = 35;
var _RECEIVER_2 = 36;
var _WIRELESS_NET = 37;
var _NETWORK_ID = 38;
var _SITE_SURVEY = 39;
var _WIRELESS_MODE = 40;
var _INFRASTRUC = 41;
var _AD_HOC = 42;
var _CHANNEL = 43;
var _AUTH = 44;
var _ENCRYPTION = 45;
var _NONE = 46;
var _WEP = 47;
var _TKIP = 48;
var _AES = 49;
var _FORMAT = 50;
var _ASCII = 51;
var _HEX = 52;
var _KEY_LENGTH = 53;
var _BITS_64 = 54;
var _BITS_128 = 55;
var _WEP_K1 = 56;
var _WEP_K2 = 57;
var _WEP_K3 = 58;
var _WEP_K4 = 59;
var _PRE_SHAR_KEY = 60;
var _CONFIRM_SETTING = 61;
var _IP_MODE = 62;
var _IP_ADDR = 63;
var _PRI_DNS_ADDR = 64;
var _SEC_DNS_ADDR = 65;
var _ESSID = 66;
var _CONNECTION = 67;
var _APPLY = 68;
var _BASIC = 69;
var _SYSTEM = 70;
var _DATE_TIME = 71;
var _USER = 72;
var _NETWORK = 73;
var _IP_FILTER = 74;
var _WIRELESS = 75;
var _VIDEO_AUDIO = 76;
var _CAMERA = 77;
var _VIDEO = 78;
var _AUDIO = 79;
var _EVENT_SERVER = 80;
var _FTP = 81;
var _EMAIL = 82;
var _NETSTORAGE = 83;
var _MOTION_DET = 84;
var _EVENT_CONFIG = 85;
var _GENERAL = 86;
var _SCHEDULE_PROF = 87;
var _MOTION_TRIG = 88;
var _SCHEDULE_TRIG = 89;
var _TOOLS = 90;
var _USB = 91;
var _INFORMATION = 92;
var _DEV_INFO = 93;
var _SYS_LOG = 94;
var _INDI_LED = 95;
var _INDI_LED_CTL = 96;
var _NORMAL = 97;
var _OFF = 98;
var _TIMEZONE = 99;
var _SYNC_PC = 100;
var _SYNC_NTP = 101;
var _NTP_SERVER = 102;
var _UPDATE_INTVL = 103;
var _HOURS = 104;
var _MANUAL = 105;
var _DATE = 106;
var _TIME = 107;
var _ADMIN = 108;
var _MODIFY = 109;
var _GEN_USER = 110;
var _USERLIST = 111;
var _ADD_MOD = 112;
var _DELETE = 113;
var _GUEST = 114;
var _DDNS_SETTING = 115;
var _ENABLE = 116;
var _PROVIDER = 117;
var _HOST_NAME = 118;
var _UPNP = 119;
var _PORTS_NUM = 120;
var _HTTP_PORT = 121;
var _DEF_80 = 122;
var _RTSP_PORT = 123;
var _DEF_554 = 124;
var _START_IP = 125;
var _END_IP = 126;
var _ADD = 127;
var _DENY_IP_LIST = 128;
var _WIRE_SETTING = 129;
var _VIDEO_N_AUDIO = 130;
var _IMAGE_SETTING = 131;
var _BRIGHTNESS = 132;
var _CONTRAST = 133;
var _SATURATION = 134;
var _RANGE = 135;
var _DEFAULT = 136;
var _MIRROR = 137;
var _VERTICAL = 138;
var _HORIZONTAL = 139;
var _LIGHT_FREQ = 140;
var _50HZ = 141;
var _60HZ = 142;
var _OUTDOOR = 143;
var _OLAY_SETTING = 144;
var _INCLUDE_DATE_TIME = 145
var _ENABLE_OPQ = 146;
var _V_RESOLUTION = 147;
var _V_QUALITY = 148;
var _FRAME_RATE = 149;
var _AUTO = 150;
var _LIMITE_TO = 151;
var _FPS = 152;
var _3GPP = 153;
var _DISABLE = 154;
var _WITHOUT_AUDIO = 155;
var _WITH_AUDIO = 156;
var _CAM_MIC_IN = 157;
var _CAM_SPK_OUT = 158;
var _VOLUME = 159;
var _EVENT_SERVER = 160;
var _EVENT_SERVER_SET = 161;
var _HOST_ADDR = 162;
var _PORT_NUM = 163;
var _DIRECT_PATH = 164;
var _PASS_MODE = 165;
var _TEST = 166;
var _NET_STORAGE = 167;
var _SAMBA_SERVER = 168;
var _SHARE = 169;
var _PATH = 170;
var _ANONYMOUS = 171;
var _SPLIT_BY = 172;
var _FILE_SIZE = 173;
var _MB = 174;
var _RECORD_TIME = 175;
var _MINUTE = 176;
var _DISK_FULL = 177;
var _STOP_RECORDING = 178;
var _RECYCLE = 179;
var _MOTION_DETECTION = 180;
var _DETECT_CONFIG = 181;
var _EVENT_CONFIGURATION = 182;
var _GEN_SETTING = 183;
var _SUBFOLDER = 184;
var _TIME_PER_EVENT = 185;
var _SECS = 186;
var _ARRANGE_SCH = 187;
var _MOTION_DET_TRIG = 188;
var _PLEASE_SET = 189;
var _ACTION = 190;
var _SEND_EMAIL = 191;
var _FTP_UPLOAD = 192;
var _RECORD_TO_NET = 193;
var _IMG_TO_USB = 194;
var _SCH_TRIG = 195;
var _EMAIL_SCHEDULE = 196;
var _INTERVAL = 197;
var _FTP_SCHEDULE = 198;
var _STORAGE_SCHEDULE = 199;
var _SYS_TOOLS = 200;
var _FACT_RESET = 201;
var _RESTOR_SET = 202;
var _SYS_REBOOT = 203;
var _SYS_REBOOTED = 204;
var _REBOOT = 205;
var _CONFIGURATION = 206;
var _BACKUP = 207;
var _GET_BACKUP_FILE = 208;
var _RESTORE = 209;
var _UPDATE_FW = 210;
var _CURRENT_FW_VER = 211;
var _SELECT_FW = 212;
var _UPDATE = 213;
var _USB_SETTING = 214;
var _USB_DISMOUNT = 215;
var _DISMOUNT_USB = 216;
var _DISMOUNT = 217;
var _USB_INFO = 218;
var _TOTAL_SPACE = 219;
var _FREE_SPACE = 220;
var _SYS_INFO = 221;
var _DEV_INFORMATION = 222;
var _FW_VER = 223;
var _MP4_RESOL = 224;
var _MJP_RESOL = 225;
var _ENABLE_3GPP = 226;
var _MIC_IN = 227;
var _SPK_OUT = 228;
var _UPNP_ENABLE = 229;
var _LOGS = 230;
var _LOGS_TABLE = 231;
var _REFRESH = 232;
var _EVENT = 233;
var _STOP_RECORD = 234;
var _ALARM_SENT = 235;
var _MANUAL_ALARM = 236;
var _SAVE_OK = 237;
var _SAVE_FAIL = 238;
var _TALKING = 239;
var _LISTENING = 240;
var _SEARCH = 241;
var _ALWAYS = 242;
var _CAM_1 = 243;
var _MEET_ROOM = 244;
var _MAC = 245;
var _MODE = 246;
var _PRIVACY = 247;
var _SIGNAL = 248;
var _prev_1 = 249;
var _DATE_N_TIME = 250;
var _SMTP = 251;
var _PROFILE_NAME = 252;
var _WEEKDAYS = 253;
var _SUN = 254;
var _MON = 255;
var _TUE = 256;
var _WED = 257;
var _THU = 258;
var _FRI = 259;
var _SAT = 260;
var _TIME_LIST = 261;
var _COPY_THIS = 262;
var _DELETE_THIS = 263;
var _START_TIME = 264;
var _END_TIME = 265;
var _SAVE = 266;
var _reset = 267;
var _MAC_ADDR = 268;
var _USER_NAME = 269;
var _PASSWORD = 270;
var _DDNS_USER = 271;
var _DDNS_PWD = 272;
var _ERROR = 273;
var _TEST_SERVER = 274;
var _GPIO_PER_EVENT = 275;
var _TRIGGER_OUT = 276;
var _PAN_SCAN = 277;
var _STOP = 278;
var _AUTO_PATROL = 279;
var _POSI_NAME = 280;
var _PAN_TILT = 281;
var _PAN_N_TILT = 282;
var _PT_CALIBRATION = 283;
var _CALIBRATION = 284;
var _PAN_SPEED = 285;
var _TILT_SPEED = 286;
var _PAN_STEP = 287;
var _TILT_STEP = 288;
var _PAN_SCAN_SPEED = 289;
var _AUTO_STAY_TIME = 290;
var _GPIO_TRIGGER = 291;
var _GO_TO_POSITION = 292;
var _PT_SETTING = 293;
var _DEGREES = 294;
var _ONE_SNAP = 295;
var _PRE_EVENT = 296;
var _POST_EVENT = 297;
var _BONJOUR = 298;
var _BONJOUR_NAME = 299;
var _MAIL_WITH = 300;
var _FTP_WITH = 301;
var _MULTICAST = 302;
var _GR_IP = 303;
var _PORT = 304;
var _DEFAULT_1234 = 305;
var _TTL = 306;
var _TTL_RANG = 307;
var _RS485 = 308;
var _RS485_SET = 309;
var _POPULAR_SET = 310;
var _PROTOCOL = 311;
var _CUSTOM_SET = 312;
var _BIT_RATE = 313;
var _HOME = 314;
var _UP = 315;
var _DOWN = 316;
var _LEFT = 317;
var _RIGHT = 318;
var _NAME = 319;
var _COMMAND = 320;
var _EX_COMMAND_1 = 321;
var _EX_COMMAND_2 = 322;
var _EX_COMMAND_3 = 323;
var _EX_COMMAND_4 = 324;
var _EX_COMMAND_5 = 325;
var _ADVANCE = 326;
var _HTTPS = 327;
var _HTTPS_PORT = 328;
var _HUE = 329;
var _SHARPNESS = 330;
var _RANGE_1 = 331;
var _OVER_MASK = 332;
var _DATE_OVER = 333;
var _TEXT_OVER = 334;
var _PRIVACY_MASK = 335;
var _INCLD_TEXT = 336;
var _DENY = 337;
var _ACCEPT = 338;
var _ACCEPT_IP_LIST = 339;
var _SMTP_PORT= 340;
var _SMTP_SECURITY= 341;
var _QOS= 342;
var _VIDEO_DSCP = 343;
var _AUDIO_DSCP = 344;
var _MULTICASTSW = 345;
var _JABBER = 346;
var _INSTANT_MESSAGE= 347;
var _JABBER_SERVER = 348;
var _JABBER_ID = 349;
var _JABBER_PWD = 350;
var _JABBER_RECEIVER = 351;
var _JABBER_MESSAGE = 352;
var _JABBER_MANUAL = 353;
var _JABBER_PORT= 354;
var _JABBER_TLS= 355;
var _JABBER_SASL= 356;
var _MASK_AREA1 = 357;
var _MASK_AREA2 = 358;
var _POSITION = 359;
var _X = 360;
var _Y = 361;
var _WIDTH = 362;
var _HEIGHT = 363;
var _MASK_COLOR = 364;
var _TRIGGER_IN_1 = 365;
var _TRIGGER_IN_2 = 366;
var _SET_OCTUPLE = 367;
var _CAMERA_AES = 368;
var _CAMERA_BLC = 369;
var _WPS = 370;
var _WPS_SETTING = 371;
var _PROTECTEDSETUP = 372;
var _PIN_MODE = 373;
var _PIN_CODE = 374;
var _REGISTAR_ID = 375;
var _PBC_MODE = 376;
var _DEVICESTATUS = 377;
var _AUTHENTICATE = 378;
var _ENC = 379;
var _RETOUNCONFIGURED = 380;
var _CONNECT = 381 ;
var _WPSCANCEL = 382;
var _AUTO_IRIS = 383;
var _H264 = 384;
var _LANGUAGE =385;
var _LANGUAGE_DEF = 386;
var _IP6_ADDR = 387;
var _V6_GW = 388;
var _MJPEGVIEWER = 389;
var _264_RESOL = 390;
var _IP4_NMASK = 391;
var _IP4_GW = 392;
var _RTSP= 393;
var _RTSPSTREAM= 394;
var _MULTICASTSET= 395;
var _NETCAMERA= 396;
var _WIRELESSTAG= 397;
var _IP_ADDRESS = 398;
var _IP_V4 = 399;
var _IP_V6 = 400;
var _GENERATE = 401;
var _TYPE = 402;
var _FILTER_ACTION = 403;
var _H264_PORT = 404;
var _MPEG4_PORT = 405;
var _AUDIO_PORT = 406;
var _DEFAULT_1236 = 407;
var _DEFAULT_1238 = 408;
var _ENCODE_FORMAT = 409;
var _FILE_FORMAT = 410;
var _MP4 = 411;
var _AVI = 412;
var _SSL = 413;
var _WANIP = 414;
var _DEF_443 = 415;
var _DAYLIGHT_SAVE = 416;
var _SD_CARD = 417;
var _VIDEO_TO_SD = 418;
var _SD_SETTING = 419;
var _SD_DISMOUNT = 420;
var _DISMOUNT_SD = 421;
var _SD_INFO = 422;
var _SD_TOTAL_SPACE = 423;
var _SD_FREE_SPACE = 424;
var _STORAGE_TIME_PER_EVENT = 425;
var _RECORD_TO_SD = 426;
var _DEVICE_BUSY = 427;
var _IR_LED = 428;
var _IR_LED_CTL = 429;
var _WANIP_NOTIFY = 430;
var _STARTTLS = 431;
var _ZOOM_IN = 432;
var _ZOOM_OUT = 433;
var _PIXEL_PAN = 434;
var _PIXEL_TILT = 435;
var _PIXEL = 436;
var _IR_CUT = 437;
var _IR_CUT_CTL = 438;
var _POWER_LED_CTL = 439;
var _NETWORK_LED_CTL = 440;
var _UTUBE = 441;
var _UTUBE_SET = 442;
var _UTUBE_RECORD = 443;
var _PUBLIC = 444;
var _PRIVATE = 445;
var _TRIGGER_OUTING = 446;
var _WHITE_LED = 447;
var _WHITE_LED_ON = 448;
var _WHITELED_PER_EVENT = 449;
var _PIR_TRIGGER = 450;
var _UPLOAD_FAIL = 451;
var _RETRY = 452;
var _KEYWORD = 453;
var _TITLE = 454;
var _DESCRIPTION = 455;
var _CATEGORY = 456;
var _DEV_KEY = 457;
var _SOURCE = 458;
var _EVERY_DAY = 459;
var _WDRC = 460;
var _RANGE_11 = 461;
var _ANDROID_WIZARD = 462;
var _ANDROID_USER = 463;
var _ANDROID_CAM_USER = 464;
var _ACCOUNT_SETTING = 465;
var _GOOGLETALK_SETTING = 466;
var _GOOGLETALK_USER = 467;
var _GMAIL_SETTING = 468;
var _GOOGLEMAIL_USER = 469;
var _PICASA_SETTING = 470;
var _PICASA_USER = 471;
var _YOUTUBE_SETTING = 472;
var _YOUTUBE_USER = 473;
var _PICASA = 474;
var _RECORD_TO_USB = 475;
var _UPLOAD_TO_YOUTUBE = 476;
var _IMAGE_TO_PICASA = 477;
var _YOUTUBE_TIP = 478;
var _UPLOAD_FILE_TO_YOUTUBE = 479;
var _RECYCLE_1 = 480;
var _STOP_1 = 481;
var _VIDEO_SERVER = 482;
var _ZOOM_SPEED = 483;
var _FOCUS_SPEED = 484;
var _FOCUS_FAR = 485;
var _FOCUS_NEAR = 486;
var _IRIS_OPEN = 487;
var _IRIS_CLOSE = 488;
var _PTZ_CONTROL_ADD = 489;
var _PTZ_CONTROL = 490;
var _AUTO_FOCUS = 491;
var _FOCUS_MANUAL = 492;
var _PATROL = 493;
var _PATROL_SETTING = 494;
var _GO = 495;
var _PRESET_POSITION = 496;
var _PATROL_PATH = 497;
var _STAY_TIME = 498;
var _REMOVE = 499;
var _STARTUP_PRESET= 500;
var _ADDRESS= 501;
var _RS485_RANGE= 502;
var _SERVER_NAME= 503;
var _BASIC_SETTING= 504;
var _LINE_IN= 505;
var _LINE_OUT= 506;
var _PATROL_POSITION= 507;
var _ADD_TO_PATROL= 508;
var _PICASA_WITH = 509;
var _MANUAL_LENS = 510;
var _DC_IRIS_LENS = 511;
var _TV_MODE = 512;
var _NTSC = 513;
var _PAL = 514;
var _FILE_NAME = 515;
var _DOWNLOAD = 516
var _FILE_MANAGER = 517;
var _FILE_BROWSE = 518;
var _2X = 519;
var _4X = 520;
var _8X = 521;
var _IMAGE_GAIN = 522;
var _BLACK_LEVEL = 523;
var _RANGE_0_5 = 524;
var _SETTING = 525;
var _HIDDENPAGEAUTH = 526;
var _USER_ACCOUNT = 527;
var _IPV4_ADDR_RANGE = 528;
var _START = 529;
var _END = 530;
var _FILENAME_PREFIX = 531;
var _RECORDING_INTERVL = 532;
var _GPIO_TRIGGER_OUT_INTERVAL = 533;
var _SR_FILENAME_PREFIX = 534;
var _GPIO_TRIGGER_OUT_PER_EVENT = 535;
var _RESTOR_SET_TN = 536;
var _SYS_REBOOTED_TN = 537;
var _BACKUP_TN = 538;
var _RESTORE_TN = 539;
var _REBOOTING = 540;
var _SIP = 541;
var _SIP_SET = 542;
var _REGISTRAR = 543;
var _PROXY = 544;
var _SIP_PORT = 545;
var _RTP_VIDEO_PORT = 546;
var _RTP_AUDIO_PORT = 547;
var _STUN = 548;
var _ENABLE_SERVER = 549;
var _MULTIMEDIA = 550;
var _ENABLE_VIDEO_CODEC = 551;
var _ENABLE_AUDIO_CODEC = 552;
var _NIGHT_IMAGE = 553;
var _MONO = 554;
var _COLOR = 555;
var _AUTO_DELETE = 556;
var _LAN_FAIL_TRIG = 557;
var _HIGH = 558;
var _MEDIUM = 559;
var _LOW = 560;
var _ON = 561;
var _SHUTTER_SPEED = 562;
var _FAST = 563;
var _AE_CONTROL = 564;
var _SLOW = 565;
var _HTTP = 566;
var _HOST = 567;
var _QUERY = 568;
var _HTTP_MOTION_TRIG = 569;
var _HTTP_NOTIFY = 570;
var _HTTP_GPIO_TRIG = 571;