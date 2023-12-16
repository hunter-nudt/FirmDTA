var sw_msg = new Array(
"歡迎使用設定精靈. 現在將會協助您快速設定您的網路攝影機.",
": 請輸入您的網路攝影機名稱.例如,camera 1.",
": 請輸入您的網路攝影機置放地點. 例如,會議室 1",
": 請輸入您存取網路攝影機管理工具的管理者密碼，並再一次輸入密碼作為確認.",
": 如果你使用動態網路位址，請使用動態網路位址(DHCP)選項. 當網路攝影機啟動時,  DHCP伺服器將會自動分派動態網路位址.",
": 如果你使用固定網路位址，請使用固定網路位址選項. 你能使用IP Finder 應用程式搜尋到網路攝影機位址並相關參數設定.",
"- 網路位址(IP): 例如,  請輸入預設設定 ",
"- 子網路遮罩: 例如,  請輸入預設設定 ",
"- 預設閘道: 例如,  請輸入預設設定 ",
"- 主要/次要網域伺服器(DNS): 請輸入你的網路服務商(ISP)所提供的網域伺服器.",
": 如果你使用ADSL撥接請使用PPPoE選項. 輸入網路服務商(ISP)所提供給你的ADSL帳號密碼. 網路攝影機將會儲存並在再次啟動時自已連接網路, 你能夠在下一頁中設定，當網路攝影機每次撥接時，自動發Email通知你 .",
": 請輸入外送郵件伺服器位址. 例如, mymail.com",
": 請輸入送件人郵件位址. 例如, John@mymail.com",
": 如果外送郵件伺服器需要登入, 請選擇SMTP並輸入帳號密碼.",
": 請輸入登入至外送郵件伺服器的帳號.",
": 請輸入登入至外送郵件伺服器的密碼.",
": 請輸入電子郵件收件者 #1.",
": 請輸入電子郵件收件者 #2.",
": 連接攝影機至一個指定的無線基地台, 在攝影機設定無線基地台所使用的SSID. 連接攝影機至一個Ad-Hoc無線網路群組, 設定符合內容一致的無線頻道和SSID.",
"點擊 ",
" 顯示可用的無線基地台網路, 使用者可以快速的連線到清單內的無線基地台網路.",
": 選擇攝影機無線網路所使用的連線模式.",
": 從下拉清單中選擇合適的無線網路頻道.",
": 選擇攝影機無線網路所使用的認證模式.",
"- Open: 預設使用的無線網路認證模式設定",
"- Shared-key: 使用WEP認證模式",
"- WPA-PSK/WPA2-PSK: 使用WPA-PSK/WPA2-PSK認證模式. 使用者在每次連線到無線網路時，必須手動設定連線密碼",
"請確認所進行的設定內容.",
"當確認後, 請點選 ",
" 結束設定精靈，並重新啟動網路攝影機.  否則請點選 ",
" 回到前述步驟變更相關設定; 或點選 ",
" 結束設定精靈並忽略先前輸入的設定.",
"請記得如果更新相關網路設定，網路攝影機的網路IP位址有可能會更動. 如果發生網路攝影機畫面無法出現影像時. 請使用產品包裝內所提供的 IP  Finder 軟體，以便重新搜尋網路攝影機網路IP位址. 之後連接網路攝影機便可回復攝影機影像",
"網路攝影機重新啟動. 請稍候50秒.",
" 結束設定精靈.  否則請點選 ",
"Welcome to the Smart Wizard.",
"This wizard will help you quickly set up the Network Camera to run on your network.",
"Example:",
": Enter the mail server port number."
);
var ad_msg = new Array(
"歡迎使用Android設定精靈",
": 請輸入Android行動裝置所使用的Google(Gmail)帳號",
": 請輸入網路攝影機所使用的Google(Gmail)帳號",
": 請輸入網路攝影機所使用的Google(Talk)帳號",
": 請輸入Android行動裝置所使用的Picasa帳號",
": 請輸入Android行動裝置所使用的YouTube帳號",
"這些設定將應用於相對應的事件伺服器設定."
)
var popup_msg = new Array(
"攝影機喇叭己被使用, 請再試一次",//0
"系統麥克風錯誤",
"攝影機喇叭已被關閉",
"網路錯誤",
"發生未知錯誤",
"網路攝影機麥克風己被使用",
"系統音效錯誤",
"網路攝影機麥克風己被關閉",
"放棄修改",
"密碼為空白",
"密碼錯誤，請重新輸入",    //10
"不能為空白",
"必需介於",
"不合法的數字:",
"'0.0.0.0' 是一個保留的網路位址",
"'255.255.255.255' 是一個保留的網路位",
"WEP 金鑰不能為空白",  //english
"WEP 金鑰必須是 ",
" 個字元長",
"必須輸入ASCII碼",
"WPA 金鑰長度必須介於 8-63 個ASCII碼或者是 64 個16進位碼",//19
"必須輸入16進位碼 [a-f],[A-F],[0-9]",
"只能包含 [a-f],[A-F],[0-9]",
"只能包含ASCII碼",
"不同於",
"使用者名稱已經被使用",
"測試中",
"您確定要刪除此使用者嗎?",
"是保留字, 請更換",
"是否重新啟動, 以使用新的設定?",//29
"這組位址已被設定過",		
"確定要刪除此項規則?",
"不能包含空白字元",
"小時 必須在 0-23 之間",
"分鐘 必須在 0-59 之間",
"開始時間 必須在 結束時間 之前",
"請先選擇一份時程資訊",
"請先選擇時間間隔",
"時程資訊名稱已存在",
"時程資訊名稱長度必須介於 1-16",//39
"'always' 是預設時程資訊, 請勿修改",
"是否刪除時程資訊",
"請輸入時程資訊名稱",
"不是正數",
"不能為空白",
"使用者清單已滿",  //english
"確定要刪除?",
"未安裝ActiveX控制項",
"時間相同",
"請先選擇檔案",
"韌體更新失敗!",//50
"韌體更新完成!",
"網路攝影機重新啟動. 請稍候50秒!",
"重新啟動失敗!",
"韌體更新處理中. 請稍候重新啟動.",
"網路攝影機將回復出廠設定!!",
"設定回復失敗!",
"設定回復完成!",
"測試失敗!",
"儲存空間已滿!",
"影像解析度或影像順暢度被更動. 錄影停止.",//60
"影像格式被更動. 錄影停止.",
"檔案寫入失敗!",
"無資訊",
"只能包含 [a-z],[A-Z],[0-9]",
"請稍候!",
"格式無效!",
"電子郵件格式錯誤!",
"攝影機名稱長度必須介於 1-16 個非ASCII碼",
"置放地點長度必須介於 1-16 個非ASCII碼",
"請先選擇一個預設位置",
"友善名稱長度必須介於 1-16 個非ASCII碼",
"無效的輸入",
"允許IP列表不能為空白",
"拒絕IP列表不能為空白",
"於HTTPS協定時不支援影像.",
"未安裝ActiveX控制項.",
"群播(影像) 逾時",
"網路埠號已經被使用",
"WPS-PIN 連接中, 請稍候",
"WPS-PBC 連接中, 請稍候",
"WPS 連接處理當中 , 請稍候",
"連線成功",
"連線失敗",
"連線終止",
"設備閒置",
"WCN.NET 連接處理當中 , 請稍候",
"遮罩區域(寬度*長度)必須小於 38400",
"X+寬度 必須小於 639",
"Y+長度 必須小於 479",
"必須是8的倍數",
"無效的IPv6 網路位址",
"只能包含 [a-z],[A-Z],[0-9],+,-,_",
"必須是偶數",
"群播(音效) 逾時",
"範圍衝突!",
"最大使用數量已滿. 操作中止!",
"遮罩區域(寬度*長度)必須大於 64"
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