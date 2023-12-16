var sw_msg = new Array(
"欢迎使用设定精灵. 现在将会协助您快速设定您的网络摄像机.",
": 请输入您的网络摄像机名称.例如,camera 1.",
": 请输入您的网络摄像机置放地点. 例如,会议室 1",
": 请输入您存取网络摄像机管理工具的管理者密码，并再一次输入密码作为确认.",
": 如果你使用动态网络地址，请使用动态网络地址(DHCP)选项. 当网络摄像机启动时,  DHCP伺服器将会自动分派动态网络地址.",
": 如果你使用固定网络地址，请使用固定网络地址选项. 你能使用IP Finder 应用程式搜寻到网络摄像机地址并相关参数设定.",
"- 网络地址(IP): 例如,  请输入默认设定 ",
"- 子网络遮罩: 例如,  请输入默认设定 ",
"- 默认闸道: 例如,  请输入默认设定 ",
"- 主要/次要网域服务器(DNS): 请输入你的网络服务商(ISP)所提供的网域服务器.",
": 如果你使用ADSL拨接请使用PPPoE选项. 输入网络服务商(ISP)所提供给你的ADSL帐号密码. 网络摄像机将会储存并在再次启动时自已连接网络, 你能够在下一页中设定，当网络摄像机每次拨接时，自动发Email通知你 .",
": 请输入外送邮件伺服器地址. 例如, mymail.com",
": 请输入送件人邮件地址. 例如, John@mymail.com",
": 如果外送邮件伺服器需要登入, 请选择SMTP并输入帐号密码.",
": 请输入登入至外送邮件伺服器的帐号.",
": 请输入登入至外送邮件伺服器的密码.",
": 请输入电子邮件收件者 #1.",
": 请输入电子邮件收件者 #2.",
": 连接摄像机至一个指定的无线基地台, 在摄像机设定无线基地台所使用的SSID. 连接摄像机至一个Ad-Hoc无线网络群组, 设定符合内容一致的无线频道和SSID.",
"点击 ",
" 显示可用的无线基地台网络, 使用者可以快速的连线到清单内的无线基地台网络.",
": 选择摄像机无线网络所使用的连线模式.",
": 从下拉清单中选择合适的无线网络频道.",
": 选择摄像机无线网络所使用的认证模式.",
"- Open: 预设使用的无线网络认证模式设定",
"- Shared-key: 使用WEP认证模式",
"- WPA-PSK/WPA2-PSK: 使用WPA-PSK/WPA2-PSK认证模式. 使用者在每次连线到无线网络时，必须手动设定连线密码",
"请确认所进行的设定内容.",
"当确认后, 请点选 ",
" 结束设定精灵，并重新启动网络摄像机.  否则请点选 ",
" 回到前述步骤变更相关设定; 或点选 ",
" 结束设定精灵并忽略先前输入的设定.",
"请记得如果更新相关网络设定，网络摄像机的网络IP地址有可能会更动. 如果发生网络摄像机画面无法出现影像时. 请使用产品包装内所提供的 IP  Finder 软件，以便重新搜寻网络摄像机网络IP地址. 之后连接网络摄像机便可回复摄像机影像",
"网络摄像机重新启动. 请稍候50秒.",
" 结束设定精灵. 否则请点选 ",
"Welcome to the Smart Wizard.",
"This wizard will help you quickly set up the Network Camera to run on your network.",
"Example:",
": Enter the mail server port number."
);
var ad_msg = new Array(
"欢迎使用Android设定精灵",
": 请输入Android行动装置所使用的Google(Gmail)帐户",
": 请输入网路摄像机所使用的Google(Gmail)帐户",
": 请输入网路摄像机所使用的Google(Talk)帐户",
": 请输入Android行动装置所使用的Picasa帐户",
": 请输入Android行动装置所使用的YouTube帐户",
"這些設定將應用於相對應的事件服務器設定."
)
var popup_msg = new Array(
"摄像机喇叭己被使用, 请再试一次",//0
"系统麦克风错误",
"摄像机喇叭已被关闭",
"网络错误",
"发生未知错误",
"网络摄像机麦克风己被使用",
"系统音效错误",
"网络摄像机麦克风己被关闭",
"放弃修改",
"密码为空白",
"密码错误，请重新输入",    //10
"不能为空白",
"必需介於",
"不合法的数字:",
"'0.0.0.0' 是一个保留地址",
"'255.255.255.255' 是一个保留地址",
"WEP 密码不能为空白",  //english
"WEP 密码必须是 ",
" 个字元长",
"必须输入ASCII码",
"WPA 密码长度必须介于 8-63 个ASCII码或者是 64 个16 进位码",//19
"必须输入16 进位码 [a-f],[A-F],[0-9]",
"只能包含 [a-f],[A-F],[0-9]",
"只能包含ASCII码",
"不同於",
"用户名称已经被使用",
"测试中",
"您确定要删除此用户吗?",
"是保留字, 请更换",
"是否重新启动, 以使用新的设定?",//29
"这组地址已被设定过",		
"确定要删除此项规则?",
"不能包含空白字元",
"小时 必须在 0-23 之间",
"分钟 必须在 0-59 之间",
"开始时间 必须在 结束时间 之前",
"请先选择一份时程资讯",
"请先选择时间间隔",
"时程资讯名称已存在",
"时程资讯名称长度必须介于 1-16",//39
"'always' 是预设时程资讯, 请勿修改",
"是否删除时程资讯",
"请输入时程资讯名称",
"不是正数",
"不能为空白",
"用户清单以满",  //english
"确定要删除?",
"未安装ActiveX控件",
"时间相同",
"请先选择档案",
"固件更新失败!",//50
"固件更新完成!",
"网络摄像机重新启动. 请稍候50秒!",
"重新启动失败!",
"固件更新处理中. 请稍候重新启动.",
"网络摄像机将回复出厂设定!!",
"设定回复失败!",
"设定回复完成!",
"测试失败!",
"储存空间已满!",
"影像分辨率或视频帧率被更动. 录影停止.",//60
"影像格式被更动. 录影停止.",
"文件写入失败!",
"无信息",
"只能包含 [a-z],[A-Z],[0-9]",
"请稍等!",
"格式无效!",
"电子邮件格式错误!",
"摄像机名称长度必须介于 1-16 个非ASCII码",
"置放地点长度必须介于 1-16 个非ASCII码",
"请先选择一个 预设位置",
"友善名称长度必须介于 1-16 个非ASCII码",
"无效的输入",
"允许IP列表不能为空白",
"拒绝IP列表不能为空白",
"於HTTPS 协议时不支持视频.",
"未安装ActiveX控件.",
"群播(视频) 逾时",
"网络端口号已经被使用",
"WPS-PIN 连接中, 请稍等",
"WPS-PBC 连接中, 请稍等",
"WPS 连接处理当中 , 请稍等",
"连接成功",
"连接失败",
"连接终止",
"设备闲置",
"WCN.NET 连接处理当中 , 请稍等",
"遮蔽区域(宽度*长度) 必须小於 38400",
"X+宽度 必须小於 639",
"Y+长度 必须小於 479",
"必须是8的倍数",
"无效的IPv6 网络地址",
"只能包含 [a-z],[A-Z],[0-9],+,-,_",
"必须是偶数",
"群播(音频) 逾时",
"值域冲突!",
"最大使用数量已满. 操作中止!",
"遮蔽区域(宽度*长度) 必须大於 64"
);
var sw_msg_0 = 0;
var sw_msg_1 = 1;
var sw_msg_2 = 2;
var sw_msg_3 = 3;
var sw_msg_4 = 4;
var sw_msg_5 = 5;
var sw_msg_6 = 6;
var sw_msg_7 = 7;
var sw_msg_8 = 8;
var sw_msg_9 = 9;
var sw_msg_10 = 10;
var sw_msg_11 = 11;
var sw_msg_12 = 12;
var sw_msg_13 = 13;
var sw_msg_14 = 14;
var sw_msg_15 = 15;
var sw_msg_16 = 16;
var sw_msg_17 = 17;
var sw_msg_18 = 18;
var sw_msg_19 = 19;
var sw_msg_20 = 20;
var sw_msg_21 = 21;
var sw_msg_22 = 22;
var sw_msg_23 = 23;
var sw_msg_24 = 24;
var sw_msg_25 = 25;
var sw_msg_26 = 26;
var sw_msg_27 = 27;
var sw_msg_28 = 28;
var sw_msg_29 = 29;
var sw_msg_30 = 30;
var sw_msg_31 = 31;
var sw_msg_32 = 32;
var sw_msg_33 = 33;
var sw_msg_34 = 34;
var sw_msg_35 = 35;
var sw_msg_36 = 36;
var sw_msg_37 = 37;
var sw_msg_38 = 38;

var ad_msg_0 = 0;
var ad_msg_1 = 1;
var ad_msg_2 = 2;
var ad_msg_3 = 3;
var ad_msg_4 = 4;
var ad_msg_5 = 5;
var ad_msg_6 = 6;
						  
var popup_msg_0 = 0;
var popup_msg_1 = 1;
var popup_msg_2 = 2;
var popup_msg_3 = 3;
var popup_msg_4 = 4;
var popup_msg_5 = 5;
var popup_msg_6 = 6;
var popup_msg_7 = 7;
var popup_msg_8 = 8;
var popup_msg_9 = 9;
var popup_msg_10 = 10;
var popup_msg_11 = 11;
var popup_msg_12 = 12;
var popup_msg_13 = 13;
var popup_msg_14 = 14;
var popup_msg_15 = 15;
var popup_msg_16 = 16;
var popup_msg_17 = 17;
var popup_msg_18 = 18;
var popup_msg_19 = 19;
var popup_msg_20 = 20;
var popup_msg_21 = 21;
var popup_msg_22 = 22;
var popup_msg_23 = 23;
var popup_msg_24 = 24;
var popup_msg_25 = 25;
var popup_msg_26 = 26;
var popup_msg_27 = 27;
var popup_msg_28 = 28;
var popup_msg_29 = 29;
var popup_msg_30 = 30;
var popup_msg_31 = 31;
var popup_msg_32 = 32;
var popup_msg_33 = 33;
var popup_msg_34 = 34;
var popup_msg_35 = 35;
var popup_msg_36 = 36;
var popup_msg_37 = 37;
var popup_msg_38 = 38;
var popup_msg_39 = 39;
var popup_msg_40 = 40;
var popup_msg_41 = 41;
var popup_msg_42 = 42;
var popup_msg_43 = 43;
var popup_msg_44 = 44;
var popup_msg_45 = 45;
var popup_msg_46 = 46;
var popup_msg_47 = 47;
var popup_msg_48 = 48;
var popup_msg_49 = 49;
var popup_msg_50 = 50;
var popup_msg_51 = 51;
var popup_msg_52 = 52;
var popup_msg_53 = 53;
var popup_msg_54 = 54;
var popup_msg_55 = 55;
var popup_msg_56 = 56;
var popup_msg_57 = 57;
var popup_msg_58 = 58;
var popup_msg_59 = 59;
var popup_msg_60 = 60;
var popup_msg_61 = 61;
var popup_msg_62 = 62;
var popup_msg_63 = 63;
var popup_msg_64 = 64;
var popup_msg_65 = 65;
var popup_msg_66 = 66;
var popup_msg_67 = 67;
var popup_msg_68 = 68;
var popup_msg_69 = 69;
var popup_msg_70 = 70;
var popup_msg_71 = 71;
var popup_msg_72 = 72;
var popup_msg_73 = 73;
var popup_msg_74 = 74;
var popup_msg_75 = 75;
var popup_msg_76 = 76;
var popup_msg_77 = 77;
var popup_msg_78 = 78;
var popup_msg_79 = 79;
var popup_msg_80 = 80;
var popup_msg_81 = 81;
var popup_msg_82 = 82;
var popup_msg_83 = 83;
var popup_msg_84 = 84;
var popup_msg_85 = 85;
var popup_msg_86 = 86;
var popup_msg_87 = 87;
var popup_msg_88 = 88;
var popup_msg_89 = 89;
var popup_msg_90 = 90;
var popup_msg_91 = 91;
var popup_msg_92 = 92;
var popup_msg_93 = 93;
var popup_msg_94 = 94;
var popup_msg_95 = 95;
var popup_msg_96 = 96;
var popup_msg_97 = 97;