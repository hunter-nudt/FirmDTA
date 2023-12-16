<html> 
<head>
<script>
	//Jerry, redirect to doc root
	{
		var loc = window.location.pathname;
		var arr = loc.split('/');
		try {
			if (arr.length > 2) //more than one directory
			{
				location.replace('/wizard_router.asp');
			}
		} catch (e) {
		}
	}
</script>
<title></title>
<script>
	var funcWinOpen = window.open;
</script>
<style type="text/css">
/*
 * Styles used only on this page.
 * WAN mode radio buttons
 */
#wan_modes p {
	margin-bottom: 1px;
}
#wan_modes input {
	float: left;
	margin-right: 1em;
}
#wan_modes label.duple {
	float: none;
	width: auto;
	text-align: left;
}
#wan_modes .itemhelp {
	margin: 0 0 1em 2em;
}

/*
 * Wizard buttons at bottom wizard "page".
 */
#wz_buttons {
	margin-top: 1em;
	border: none;
}

#wz_progress {
  background-color:#bca;
  border:2px solid green;
}

body{ font-size:12px}
.langmenu{
position: absolute;
display: none;
background: white;
border: 1px solid #f06b24;
border-width: 3px 0px 3px 0px;
padding: 10px;
font: normal 12px Verdana;
z-index: 100;

}

.langmenu .column{
float: left;
width: 120px; /*width of each menu column*/
margin-right: 5px;
}

.langmenu .column ul{
margin: 0;
padding: 0;
list-style-type: none;
}

.langmenu .column ul li{
padding-bottom: 8px;
}

.langmenu .column ul li a{
text-decoration: none;
}

</style>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" type="text/css" href="css/css_router.css">
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css">
<link rel="stylesheet" type="text/css" href="js/jquery-ui.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script>
	//20120619 silvia fix chrome first time cannot auto detect lang
	var time=new Date().getTime();
	var i= "<script language=\"JavaScript\" "+ 
	" src=\"\/uk_w.js?uk_time=" + time + "\" type=\"text/JavaScript\"><\/script>"
	document.write(i)
</script>
<script type="text/javascript" src="js/xml.js"></script>
<script type="text/javascript" src="js/object.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript" src="js/public_msg.js"></script>
<script type="text/javascript" src="js/pandoraBox.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	var salt = "345cd2ef";
	var progressBarMaxWidth = 500;

	var miscObj = new ccpObject();
	var dev_info	= miscObj.get_router_info();
	var model		= dev_info.model;
	var cli_mac 	= dev_info.cli_mac;
	var wan_mac		= dev_info.wan_mac;
	var wband		= dev_info.wireless_band;
	var EN_SPEC_WFA_MYDLINK_1_00	= dev_info.EN_SPEC_WFA_MYDLINK_1_00;

	var wband_cnt 	=(wband == "dual")?1:0;
	var count = 1;
	//var fichk=0;
	var close=0;
	var imgclose=0;
	var pingIntv=1000*60*3;
	var count_myd =0;
	var show_mydlink_start_str='mydlink_pop_05';

	if (dev_info.es_conf == '1') {
		location.replace('login.asp');
	}

	document.title = get_words('TEXT000');
	var lan_ip = "192.168.0.1";
	var langArray = new Array('English','Español','Deutsch','Français','Italiano','Русский','Português',
							'日本語','繁體中文','简体中文','한국어','Česky','Dansk','Ελληνικά','Suomi',
							'Hrvatski','Magyar','Nederlands','Norsk','Polski','Português do Brasil',
							'Română','Slovenščina','Svenska')

	var pageNameArray = new Array('p0', 'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p6a', 'p6b', 'p7a', 
								  'p7b', 'p7c', 'p7d', 'p7e', 'p8', 'p9', 'p10', 'p11', 'p12',
								  'p13','p13', 'p13a','p13b','p14', 'p15', 'Unknown');
	var nextPageArray = new Array('p3', 'p2', 'p9', 'p4', 'p5', 'p6', 'p7a', 'p8', 'p8', 'p8', 
								  'p8', 'p8', 'p8', 'p8', 'p1', 'p10', 'p12', 'p12', 'p13',
								  'p13a','p13b', 'p15','p15','p14', 'p15','Unknown');
	var historyArray = new Array(20);//p10 3 12
	var historyIdx   = 0;
	var wz_curr_page = 0;
	var wz_next_page = 1;
	var wz_probe_wan = -1;
	var probe_count  = 0;
	var is_support = 0;
	var action = 0;	//0=>signup, 1=>signin, 2=>adddev
	var curr_lang = '';
	var currLindex  = '';
	//var mdl_srv = 'http://www.dlink.com';	//provision file
	var conn_type = '';	//wan connect type
	var limit_time= '';

	var mainObj = new ccpObject();
	var	param = {
		url: "easy_setup.ccp",
		arg: "oid_1=IGD_&inst_1=1000"+
			"&oid_2=IGD_Time_&inst_2=1100"+
			"&oid_3=IGD_LANDevice_i_LANHostConfigManagement_&inst_3=1110"+
			"&oid_4=IGD_AdministratorSettings_&inst_4=1000"+
			"&oid_5=IGD_WANDevice_i_&inst_5=1100"+
			"&oid_6=IGD_WANDevice_i_StaticIP_&inst_6=1110"+
			"&oid_7=IGD_WANDevice_i_DHCP_&inst_7=1110"+
			"&oid_8=IGD_WANDevice_i_PPPoE_i_&inst_8=1110"+
			"&oid_9=IGD_WANDevice_i_PPTP_&inst_9=1110"+
			"&oid_10=IGD_WANDevice_i_PPTP_ConnectionCfg_&inst_10=1111"+
			"&oid_11=IGD_WANDevice_i_L2TP_&inst_11=1110"+
			"&oid_12=IGD_WANDevice_i_L2TP_ConnectionCfg_&inst_12=1111"
	};

	if (wband == "5G") {
		var i = 3;
	} else {
		var i = 1;
	}

	for (var j =0, k =12; j<= wband_cnt; j++)	//, counts =0
	{
		var n = 0;
		while (n < 2)
		{
			if (i == 3)	// get 5g info
				i= i+2;
	
			param.arg +="&oid_"+(k+1)+"=IGD_WLANConfiguration_i_&inst_"+(k+1)+"=1"+i+"00";
			param.arg +="&oid_"+(k+2)+"=IGD_WLANConfiguration_i_WPA_PSK_&inst_"+(k+2)+"=1"+i+"11";
			k+=2;
			n++;
			i++;
		}
	}

	param.arg += "&ccp_act=get&es_step=0&num_inst="+k;
	mainObj.get_config_obj(param);

	var wlanPASS = mainObj.config_str_multi('wpaPSK_KeyPassphrase_');
	var wlanSSID = mainObj.config_str_multi('wlanCfg_SSID_');
	var already_clone = mainObj.config_val("wanDev_MACAddressOverride_");
	var hw_mac = mainObj.config_val('wanDev_MACAddressClone_')?mainObj.config_val('wanDev_MACAddressClone_'):wan_mac;
	var hw_mac_org = hw_mac;

	var br_lang = mainObj.config_val('igd_CurrentLanguage_')? mainObj.config_val('igd_CurrentLanguage_'):"0";
	var gTimezoneIdx = mainObj.config_val("sysTime_LocalTimeZoneIndex_");
	var gauth_en = mainObj.config_val("adminCfg_GraphAuthenticationEnable_");

	var lanCfg = {
		'lanIp':		mainObj.config_val('lanHostCfg_IPAddress_'),
		'lanSubnet':	mainObj.config_val('lanHostCfg_SubnetMask_'),
		'lanDhcp':		mainObj.config_val('lanHostCfg_DHCPServerEnable_'),
		'lanMinAddr':	mainObj.config_val('lanHostCfg_MinAddress_'),
		'lanMaxAddr':	mainObj.config_val('lanHostCfg_MaxAddress_'),
		'lanHostName':	mainObj.config_val('lanHostCfg_HostName_')
	};

	var wanCfg = {
		'wanMode':			mainObj.config_val('wanDev_CurrentConnObjType_'),
		'wanMac':			mainObj.config_val('wanDev_MACAddressClone_')?mainObj.config_val('wanDev_MACAddressClone_'):wan_mac,
		'wanMacCloned':		mainObj.config_val('wanDev_MACAddressOverride_'),

		'wanStaticIp':		mainObj.config_val('staticIPCfg_ExternalIPAddress_'),
		'wanStaticSubnet':	mainObj.config_val('staticIPCfg_SubnetMask_'),
		'wanStaticGw':		mainObj.config_val('staticIPCfg_DefaultGateway_'),
		'wanStaticDns':		mainObj.config_val('staticIPCfg_DNSServers_').split(','),

		'wanPppoeType':		mainObj.config_val('pppoeCfg_IPAddressType_'),
		'wanPppoeAddr':		mainObj.config_val('pppoeCfg_ExternalIPAddress_'),
		'wanPppoeName':		mainObj.config_val('pppoeCfg_Username_')? mainObj.config_val('pppoeCfg_Username_'):"",
		'wanPppoePass':		mainObj.config_val('pppoeCfg_Password_'),
		'wanPppoeServ':		mainObj.config_val('pppoeCfg_ServiceName_')? mainObj.config_val('pppoeCfg_ServiceName_'):"",
		'wanPppoeDNS':		mainObj.config_val('pppoeCfg_DNSServers_').split(','),

		'wanPPTPType':		mainObj.config_val('pptpCfg_IPAddressType_'),
		'wanPPTPAddr':		mainObj.config_val('pptpCfg_ExternalIPAddress_'),
		'wanPPTPMask':		mainObj.config_val('pptpCfg_SubnetMask_'),
		'wanPPTPGw':		mainObj.config_val('pptpCfg_DefaultGateway_'),
		'wanPPTPServ':		mainObj.config_val('pptpConn_ServerIP_'),
		'wanPPTPName':		mainObj.config_val('pptpConn_Username_'),
		'wanPPTPPass':		mainObj.config_val('pptpConn_Password'),
		'wanPPTPDNS':		mainObj.config_val('pptpCfg_DNSServers_').split(','),

		'wanL2TPType':		mainObj.config_val('l2tpCfg_IPAddressType_'),
		'wanL2TPAddr':		mainObj.config_val('l2tpCfg_ExternalIPAddress_'),
		'wanL2TPMask':		mainObj.config_val('l2tpCfg_SubnetMask_'),
		'wanL2TPGw':		mainObj.config_val('l2tpCfg_DefaultGateway_'),
		'wanL2TPServ':		mainObj.config_val('l2tpConn_ServerIP_'),
		'wanL2TPName':		mainObj.config_val('l2tpConn_Username_'),
		'wanL2TPPass':		mainObj.config_val('l2tpConn_Password'),
		'wanL2TPDNS':		mainObj.config_val('l2tpCfg_DNSServers_').split(',')
	};

	function clone_mac_action(obj){
		$('obj').val(cli_mac);
		already_clone = 1;
	}

	function chk_browser_lang()
	{
		check_browser();
		if (is_support == 2)	// ie only
			curr_lang = window.navigator.userLanguage;
		else	// other browser
			curr_lang = window.navigator.language;

		currLindex = lang_compare(curr_lang);
		lang_change(currLindex);
		return currLindex;
	}

	function onPageLoad()
	{
		$('#append_net').dialog({'modal': true});
		$('#append_net').dialog({ width: 500});
		$('#append_net').dialog({ height: 180});
		$('#append_net').dialog({'resizable': false});
		close_net();
		paintsecList();

		chk_browser_lang();
		$('#wan_mac').val(wanCfg.wanMac);
		$('#p6a_wan_mac').val(wanCfg.wanMac);
		set_checked(gauth_en, get_by_name("graphical_enable"));
		$('#p8_key').val(wlanPASS[0]);
		
		if (wband == "5G" || wband == "dual"){
			$('.5G_use').show();
			$('#p8_key_5').val(wlanPASS[2]);
		}else
			$('.2_4G_use').show();
	}

	function paintsecList()	//20121017 modified to use paint
	{
		<!-- 20120112 silvia add 5g -->
		var content = '';
		var wband_cnt =(wband == "5G" || wband == "dual")?2:1;
		content+= '<table align="center" cellpadding="5" class=formarea style="display:">';
		content+= '<div align="center" width="440">';
		for (var i =0;i<wband_cnt;i++)
		{
			content += '<tr>'+
					'<td width="300" height="30">'+
					'<p class="box_msg" align="left">'+
					get_words('wwz_wwl_intro_s0')+' &nbsp;';

			if (i==0)
				content += '('+ get_words('GW_WLAN_RADIO_0_NAME')+ ')';
			else if (i==1)
				content += '('+ get_words('GW_WLAN_RADIO_1_NAME')+ ')';

			content += '</p></td></tr>';
			content += '<tr align="left">'+
					'<td colspan="2" class=form_label>'+
					'<b>'+get_words('wwz_wwl_intro_s2_1_1')+'&nbsp;:&nbsp;</b><br>';
			if (i==0)
				content += '<input type="text" id="p8_ssid" name="p8_ssid" size="40" maxlength="32" value="">';
			else if (i==1)
				content += '<input type="text" id="p8_ssid_5" name="p8_ssid_5" size="40" maxlength="32" value="">';

			content += get_words('wwz_wwl_intro_s2_1_2')+'</td></tr><br>';

			content += '<tr align="left">'+
					'<td colspan="2" class=form_label>'+
					'<b>'+get_words('wwz_wwl_intro_s2_2_1')+'&nbsp;:&nbsp;</b><br>';
			if (i==0){
				content += '<input type="text" id="p8_key" name="p8_key" size="40" maxlength="63" value="">'+
					'<input type="hidden" id="p8_autokey" name="p8_key" size="40" maxlength="63" value="">';
			}else if (i==1){
				content += '<input type="text" id="p8_key_5" name="p8_key_5" size="40" maxlength="63" value="">'+
					'<input type="hidden" id="p8_autokey_5" name="p8_key_5" size="40" maxlength="63" value="">';
			}
			content += get_words('wwz_wwl_intro_s2_2_2')+'</td></tr>';
		}
		content += '</div></table><br><br>';
		$('#WifiSecurity').html(content);
	}

	function bookmark()
	{
		var title = 'D-Link Router Web Management';
		var web_url;
		var temp_cURL = document.URL.split("/");
		var hURL = temp_cURL[0];

		//20120119 silvia modify use dev_name
		if (hURL == "https:")
			web_url="https://dlinkrouter/.";
		else
			web_url="http://dlinkrouter/.";

		if(window.sidebar){				// Mozilla Firefox Bookmark
			window.sidebar.addPanel(title, web_url, "");
		} else if(document.all){		// IE Favorite
			window.external.AddFavorite(web_url, title);
		}
	}

	function OpenWindow(){
		funcWinOpen('goto_mydlink.asp',"",'location=1, resizable=1, scrollbars=1, top=0, left=0, height='+((screen.availHeight)-10)+',width='+((screen.availWidth)-10));
	}

	function check_browser()	//chk support bookmark and lang
	{
		var chkMSIE = (navigator.userAgent.match(/msie/gi) == 'MSIE') ? true : false ;
		var isMSIE = (-[1,]) ? false : true;

		if(window.sidebar && window.sidebar.addPanel){ //Firefox
			is_support = 1;
		}else if (chkMSIE && window.external) {  //IE favorite
			is_support = 2;
		}
		return is_support;
	}

	function termsOfUse_page(){
		var prelink;
		if(br_lang == "9")
			prelink = "tw";
		else if(br_lang=="10")
			prelink = "cn";
		else
			prelink = "eu";
		var lang = termsOfUse_link(br_lang);
		
		var langlink = "http://"+prelink+".mydlink.com/termsOfUse?lang="+lang+"#";
		$('a#language_link').attr('href', langlink);
	}
	var submit_button_flag = 0;
	
	function submit_all()
	{
		var submitObj = new ccpObject();
		var paramStr = "";
		paramStr += "&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY"; //CCP_SUB_WIZARD change to CCP_SUB_SETUP_WIZARD
		paramStr += "&nextPage=sel_wan.asp";
		//2014-02-20 Silvia, Support WFA 1.00 need to set igdStorageAdmin_Password for samba
		if (EN_SPEC_WFA_MYDLINK_1_00)
			paramStr += "&igdStorageAdmin_Password_1.1.1.0=" + urlencode($('#pwd1').val());
		paramStr += "&loginInfo_Username_1.1.1.0=admin&loginInfo_Password_1.1.1.0=" + urlencode($('#pwd1').val());
		paramStr += "&adminCfg_GraphAuthenticationEnable_1.1.0.0=" + get_checked_value(get_by_id("graphical_enable"));
		paramStr += "&sysTime_LocalTimeZone_1.1.0.0=" + $('#tzone').val();
		paramStr += "&sysTime_LocalTimeZoneName_1.1.0.0=" + $('#tzone')[0].options[$('#tzone')[0].selectedIndex].text;
		paramStr += "&sysTime_LocalTimeZoneIndex_1.1.0.0=" + $('#tzone')[0].selectedIndex;

		paramStr += "&sysTime_NTPEnable_1.1.0.0=1";
		paramStr += "&sysTime_NTPServer1_1.1.0.0=ntp1.dlink.com";
		
		switch(get_checked_value(get_by_name('wan_type')))
		{
			case "dhcpc":
				paramStr += constructParamDHCPC();
				break;
			case "static":
				paramStr += constructParamStaticIP();
				break;
			case "pppoe":
				paramStr += constructParamPPPoE();
				break;
			case "pptp":
				paramStr += constructParamPPTP();
				break;
			case "l2tp":
				paramStr += constructParamL2TP();
				break;
		}

		//paramStr += constructParamWifi(); //move to mydlink

		var paramSubmit = {
			url: "easy_setup.ccp",
			arg: 'ccp_act=set&es_step=0'
		};
		paramSubmit.arg += paramStr;
		submitObj.get_config_obj(paramSubmit);
	}
	
	//20120510 pascal add 
	function submit_wifi(gotopage)
	{
		var submitObj = new ccpObject();
		submitObj.set_param_url('easy_setup.ccp');
		submitObj.set_ccp_act('set');
		submitObj.add_param_event('CCP_SUB_WEBPAGE_APPLY');
		submitObj = constructParamWifi(submitObj);
		submitObj.add_param_arg('igd_AlreadyConfiguration_','1.0.0.0',1);
		submitObj.ajax_submit(false);
		
		if(gotopage==0)
			location.replace('login.asp');
		else
			get_conn_st_mydlink();
			
		//setTimeout('OpenWindow()', 1000);
		//setTimeout('location.replace(\'login.asp\')', 1000 * 12);
	}

	function send_request(val)
	{
		switch (val)
		{
		case 0:
			submit_all();
			//check_browser();
			if (is_support != 0 && (confirm(get_words('ES_bookmark')))){
				bookmark();
			}
			next_page();
			return true;
			break;
		case 1:
			if(verify_wz_page_p13a() == false)
				return false;
			$('#next_b_p13a').attr('disabled',true);
		default :
			if (val == 3)
				$('#next_b_p14').attr('disabled',true);
			submit_regist(val);
			break;
		}
	}

	function submit_regist(val)
	{
		var paramStr={
			'url': 	'easy_setup.ccp',
			'arg': 	'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY'
		};
		//20120203 silvia add if user do the registration then change defcfg
		
		/*
		**    Date:		2013-04-22
		**    Author:	Silvia Chang
		**    Reason:   The request from Vic's team, when send "https enable" will cause wan disconnect.
		**				Because there are no spec defined it, so ignore it.
		**/
		//paramStr.arg += '&adminCfg_HttpsServerEnable_1.1.0.0=1';

		if (val == 1)
		{
			paramStr.arg += '&igdMyDLink_EmailAccount_1.1.0.0='+$('#email_addra').val();
			paramStr.arg += '&igdMyDLink_AccountPassword_1.1.0.0='+urlencode($('#pass').val());
		}

		if (val == 2)
		{
			paramStr.arg += '&igdMyDLink_EmailAccount_1.1.0.0='+$('#email_addr').val();
			paramStr.arg += '&igdMyDLink_AccountPassword_1.1.0.0='+urlencode($('#passwd').val());
			paramStr.arg += '&igdMyDLink_LastName_1.1.0.0='+urlencode($('#lname').val());
			paramStr.arg += '&igdMyDLink_FirstName_1.1.0.0='+urlencode($('#fname').val());
		}
		if (val != 3)
			mydlink_save(paramStr);
		
		paramStr.url = 'mdl_check.ccp';
		if ((val == 1) || (val == 3))	//signin	登入
		{
			paramStr.arg = 'act=signin';
			action = 1;
		}
		else if (val == 2)		//signup	註冊
		{
			paramStr.arg = 'act=signup';
			action = 0;
		}
		mydlink_reg(paramStr);
	}

	function is_wifi_change(){
		if (wband == "5G" || wband == "dual")
		{
			if ( wlanSSID[0] != $('#p8_ssid').val() || wlanSSID[2] != $('#p8_ssid_5').val() || 
			wlanPASS[0] != $('#p8_key').val() || wlanPASS[2] != $('#p8_key_5').val())
			{
				return true;
			}else{
				return false;
			}
		}else{
			if ( wlanCfg.wlanSSID != $('#p8_ssid').val() || wlanPASS != $('#p8_key').val())
				return true;
			else
				return false;
		}
	}
	
	function mydlink_reg(param)
	{
		var time=new Date().getTime();

		if (param == null || param.url == null)
			return;

		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	param.url,
			data: 	param.arg+"&"+time+"="+time,
			success: function(data) {
				switch(action)
				{
					case 0:	//signup
					{
						
						if (data.indexOf('success') != -1)
						{
							send_request(3); //next_page();
							//show_mydlink_start_str='_wz_mydlink_email_1';
							break;
						}
						$('#next_b_p14').attr('disabled','');
						$('#next_b_p13a').attr('disabled','');
						$('#next_b_p13b').attr('disabled','');
					}
					if(get_words(data)==null)
						alert(data);
					else
						alert(get_words(data));
					break;
					
					case 1:	//signin
						
						if (data.indexOf('success') != -1)
						{
							var paramStr={
								'url': 	'mdl_check.ccp',
								'arg': 	'act=adddev'
							};
							action = 2;
							mydlink_reg(paramStr);
							break;
						}
						if(get_words(data)==null)
							alert(data);
						else
							alert(get_words(data));
						$('#next_b_p14').attr('disabled','');
						$('#next_b_p13a').attr('disabled','');
						$('#next_b_p13b').attr('disabled','');
					break;
					
					case 2:	//adddev
						$('#next_b_p14').attr('disabled',true);
						$('#next_b_p13a').attr('disabled',true);
						$('#next_b_p13b').attr('disabled',true);
						if (data.indexOf(':'+ model) != -1)
						{
							next_page();
							var easyObj = new ccpObject();
							//adddev already set to configured, so can not use easy_setup.ccp
							easyObj.set_param_url('easy_setup.ccp');
							easyObj.set_ccp_act('set');
							if (conn_type == 2)
								easyObj.add_param_arg('pppoeCfg_ConnectionTrigger_','1.1.1.0',0);
							if (conn_type == 3)
								easyObj.add_param_arg('pptpConn_ConnectionTrigger_','1.1.1.1',0);
							if (conn_type == 4)
								easyObj.add_param_arg('l2tpConn_ConnectionTrigger_','1.1.1.1',0);
							easyObj.add_param_arg('igdMyDLink_PushEventEnable_','1.1.0.0',1);
							
							if(!is_wifi_change())
								easyObj.add_param_arg('igd_AlreadyConfiguration_','1.0.0.0',1);
							easyObj.add_param_event('CCP_SUB_WEBPAGE_APPLY');		//Jerry, add sub event
							easyObj.ajax_submit(false);
							if(is_wifi_change())
								submit_wifi(1);
							else
								get_conn_st_mydlink();
							//OpenWindow();
							//submit_wifi();
							//setTimeout('location.replace(\'login.asp\')', 1000 * 15);
							break;
						}

						if (data.indexOf(']') == -1)
							alert(get_words(data));
						else
						{
							data = data.split(']');
							alert(data[1]);
						}
						$('#next_b_p14').attr('disabled',false);
						$('#next_b_p13a').attr('disabled',false);
						$('#next_b_p13b').attr('disabled',false);
					break;
				}
			},
			error: function(xhr, ajaxOptions, thrownError){
				if (xhr.status == 200) {
					try {
						setTimeout(function() {
							document.write(xhr.responseText);
						}, 0);
					} catch (e) {
					}
				} else {
				}
			}
		};
		
		try {
			//setTimeout(function() {
				$.ajax(ajax_param);
			//}, 0);
		} catch (e) {
		}	
	}
	
	function mydlink_save(param)
	{
		var time=new Date().getTime();

		if (param == null || param.url == null)
			return;

		var ajax_param = {
			type: 	"POST",
			async:	false,
			url: 	param.url,
			data: 	param.arg+"&"+time+"="+time,
			success: function(data) {
			},
			error: function(xhr, ajaxOptions, thrownError){
			}
		};
		
		try {
			//setTimeout(function() {
				$.ajax(ajax_param);
			//}, 0);
		} catch (e) {
		}
	}

	//20120228 silvia add get url
	function get_ip()
	{
		var web_url;
		var temp_cURL = document.URL.split('/');

		if (temp_cURL[0] == "https:")
			web_url="https://"+temp_cURL[1]+temp_cURL[2]+'/login.asp';
		else
			web_url="http://"+temp_cURL[1]+temp_cURL[2]+'/login.asp';
		return web_url;
	}

	function wizard_cancel(wz){
		close_lang(1);

		if (wz != 0 && wz != 3)
		{
			if (is_form_modified("formAll")){
				if(!confirm(get_words('_wizquit')))
					return false;
			}
		}
		
		/* 
		** Date:	2013-04-10
		** Author:	Pascal Pai
		** Reason:	Setup Wizard spec v1.04
		**/
		if(wz==3)
		{
			if(!confirm(get_words('_wz_skip_mydlink'))) {
				return false;
			}
		}

		//for submit wifi
		if(wz==3 && is_wifi_change())
			submit_wifi(0);

		var wzcancelObj = new ccpObject();
		var paramSubmit = {
			url: "easy_setup.ccp",
			arg: 'ccp_act=wzcancel&es_step=0'
		};
		if(submit_button_flag == 0){
			wzcancelObj.get_config_obj(paramSubmit);
			submit_button_flag = 1;

			var result = wzcancelObj.config_val("result");
			if(result == 'OK')
			{
				location.replace(get_ip());
			}
			return true;
		}else{
			return false;
		}
	}

	function select_wan_type(){
		set_checked($('#select_isp').val(), get_by_name("wan_type"));
	}

	function get_pageNameIdx(name) 
	{
		for (var i=0; i < pageNameArray.length; i++)
		{
			if (pageNameArray[i] == 'Unknown')
				break;

			if (pageNameArray[i] == name)
				return i;
		}

		alert('unknown page name');
		return -1;
	}

	function displayPage(page)
	{
		for(var i=0; i < pageNameArray.length; i++)
		{
			if (pageNameArray[i] == 'Unknown')
				break;

			if(pageNameArray[i] == page)
			{
				if (pageNameArray[i] == 'p7a'){
					next_page();
					break;
				}else{
					get_by_id(pageNameArray[i]).style.display = "";
					if(page == 'p7c' || page == 'p7d' || page == 'p7e')
						show_static_ip(mapPage2WanType(page));
				}
				if (pageNameArray[i] == 'p13')
				{

					if (get_checked_value(get_by_name('mdl_reg')) == 'no')
					{
						next_page(findIndexOfArrayByValue(pageNameArray, 'p13b'));
					} else if (get_checked_value(get_by_name('mdl_reg')) == 'yes')
					{
						next_page(findIndexOfArrayByValue(pageNameArray, 'p13a'));
					}
					break;
				}

				if (pageNameArray[i] == 'p12')
				{
					var connObj = new ccpObject();
					var param = {
						url: "easy_setup.ccp",
						arg: "ccp_act=get&num_inst=1"+
							'&oid_1=IGD_WANDevice_i_&inst_1=1100'
					};
					connObj.get_config_obj(param);
					conn_type = connObj.config_val("wanDev_CurrentConnObjType_");

					//20120430 ignored by silvia
					/*
					if ((conn_type == 2) || (conn_type == 3) ||(conn_type == 4))
						setTimeout('pop()',500);
					*/
				}
			}
			else
				get_by_id(pageNameArray[i]).style.display = "none";
		}
	}

	function mapEnum2WanType(idx)
	{
		//StaticIP	DHCP	PPPoE	PPTP	L2TP	BigPond	RSPPPoE	RSPPTP	RSL2TP	DHCPPLUS																			
		switch(idx)
		{
			//case '0':
			//	return "static";
			case '1':
				return "dhcpc_auto";
			case '2':
				return "pppoe_auto";
		}
	}

	function mapPage2WanType(pageId)
	{
		switch(pageId)
		{
			case "p7a":
				return "dhcpc";
			case "p7b":
				return "static";
			case "p7c":
				return "pppoe";
			case "p7d":
				return "pptp";
			case "p7e":
				return "l2tp";
		}
	}

	function mapWanType2Page(wan)
	{
		switch(wan)
		{
			case "dhcpc_auto":
				return "p8";
			case "pppoe_auto":
				return "p6b";
			case "dhcpc":
				return "p7a";
			case "pppoe":
				return "p7c";
			case "pptp":
				return "p7d";
			case "l2tp":
				return "p7e";
			case "static":
				return "p7b";
		}
	}

	function findIndexOfArrayByValue(array, value)
	{
		for (var i=0; i<array.length; i++)
		{
			if(array[i] == value)
				return i;
		}
		return -1;
	}

	function get_auto_wepkey(length)
	{
		var pass_word=""
		var seed = parseInt(Math.random() * 100,10);
		for (i=0; i<length ;i++ ){
			seed = (214013 * seed) & 0xffffffff;
		    if(seed & 0x80000000)
		        seed = (seed & 0x7fffffff) + 0x80000000 + 0x269ec3;
		    else
		        seed = (seed & 0x7fffffff) + 0x269ec3;
		    temp = ((seed >> 16) & 0xff);
		    if(temp < 0x10){
		        pass_word += "0" + temp.toString(16).toLowerCase();
			}else{
		        pass_word += temp.toString(16).toLowerCase();
		    }
		}
		return pass_word;
	}
	
	function check_key(key)
	{
		var min = 8;
		var max = 63;

		if (key.length < min){
			alert(get_words("IPV6_TEXT2"));
			return false;
		}else if (key.length > max){
			alert(get_words("IPV6_TEXT2"));
			return false;
		}
		return true;
	}

	function do_probe()
	{
		var time=new Date().getTime();

		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	'easy_setup.ccp',
			data: 	'ccp_act=do_probe&es_step=0'+"&"+time+"="+time
		};

		$.ajax(ajax_param);
	}

	function get_probe_state_hldr(data)
	{
		wz_probe_wan = get_node_value(data, 'probe_status');

		if (wz_probe_wan == '10' || probe_count++ >= 9) {		//probe finished: 10
			$('#next_b_p4').attr('disabled', false);
			$('#progressbar').width(progressBarMaxWidth);
			if(pageNameArray[wz_curr_page] == 'p4') {
				next_page();
			}
			return;
		}

		if (wz_probe_wan != '' && wz_probe_wan != '0') {
			$('#next_b_p4').attr('disabled', false);
			$('#progressbar').width(progressBarMaxWidth);
			if(pageNameArray[wz_curr_page] == 'p4') {
				next_page();
			}
			return;
		}

		setTimeout('get_probe_state()', 1000);
	}

	function get_probe_state()
	{
		var time=new Date().getTime();

		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	'easy_setup.ccp',
			data: 	'ccp_act=get_probe_state&es_step=0'+"&"+time+"="+time,
			success: function(data) {
				get_probe_state_hldr(data);
			},
			error: function(xhr, ajaxOptions, thrownError){
				if (xhr.status == 200) {
					try {
						setTimeout(function() {
							document.write(xhr.responseText);
						}, 0);
					} catch (e) {
					}
				}
			}
		};

		$.ajax(ajax_param);
	}
	
	function try_again() 
	{
		preload_wz_page_p3();
	}
	
	function next_page(page_idx)
	{
		close_lang(1);
		historyArray[historyIdx++] = wz_curr_page;
		
		if (wz_curr_page != 0)
		{
			try {
				if (pageNameArray[wz_curr_page] != 'p13b')
				{
					if(eval("verify_wz_page_"+pageNameArray[wz_curr_page])() == false) {
						historyIdx--;
						return;
					}
				}
			} catch (e) {
				// the verify function is not exist
			}
		}
		
		if (page_idx != null)
			wz_curr_page = page_idx;
		else
			wz_curr_page = findIndexOfArrayByValue(pageNameArray, nextPageArray[wz_curr_page]);
			
		if(pageNameArray[wz_curr_page].indexOf('p7a') == 0) {
			$('#wan_mac').val(wanCfg.wanMac);
			already_clone = wanCfg.wanMacCloned;
		}

		if(pageNameArray[wz_curr_page].indexOf('p7g') == 0) {
			$('#dhcpplus_wan_mac').val(wanCfg.wanMac);
			already_clone = wanCfg.wanMacCloned;
			hw_mac = wanCfg.wanMac;
		}

		// preload (pre-check) for the next page
		try {
			if (eval("preload_wz_page_"+pageNameArray[wz_curr_page])() == false) 
				return;
		} catch (e) {
			// the preload function is not exist
		}

		displayPage(pageNameArray[wz_curr_page]);
	}

	function prev_page()
	{
		close_lang(1);
		if (historyArray[historyIdx-1] ==9)
			historyIdx--;
		wz_curr_page = historyArray[--historyIdx];
		
		// preload (pre-check) for the next page
		try {
			if (eval("preload_wz_page_"+pageNameArray[wz_curr_page])() == false) 
				return;
		} catch (e) {
			// the preload function is not exist
		}

		displayPage(pageNameArray[wz_curr_page]);
	}

	function show_static_ip(objname){
		var ppp_type = get_by_name(objname + "_type");	
		if(ppp_type == null)
			return;

		// since pppoe disabled some field, skip null object error.
		try {
			get_by_id(objname+"_ip").disabled = ppp_type[0].checked;
			
			var mask_obj = get_by_id(objname + "_mask");
			var gw_obj = get_by_id(objname + "_gw");
			
			if(mask_obj)
				mask_obj.disabled = ppp_type[0].checked;
			if(gw_obj)
				gw_obj.disabled = ppp_type[0].checked;
		} catch (e) {

		}
	}

	function draw_progress_bar()
	{
		var curWidth = $('#progressbar').width();
		var fieldWidth = curWidth + (progressBarMaxWidth-curWidth)/5;
	
		if (progressBarMaxWidth-curWidth <= 5) {
			$('#progressbar').width(progressBarMaxWidth);
			return;
		}

		if ($('#progressbar').width() < progressBarMaxWidth) {
			$('#progressbar').width(fieldWidth);
			setTimeout('draw_progress_bar()', 600);
		}
	}

	function preload_wz_page_p3()
	{
		var preloadObj = new ccpObject();
		var paramHost={
			'url': 	'easy_setup.ccp',
			'arg': 	'ccp_act=get&es_step=0&num_inst=1&oid_1=IGD_WANDevice_i_WANStatus_&inst_1=1110'
		};
		preloadObj.get_config_obj(paramHost);

		var cableSt = preloadObj.config_val('igdWanStatus_CableStatus_');
		if (cableSt == 'Connected') {	//skip try again page	//usar
			next_page();
			historyIdx--;
			return false;
		}
		return true;
	}

	function preload_wz_page_p4()
	{
		probe_count = 0;
		$('#next_b_p4').attr('disabled', true);
		do_probe();
		setTimeout('get_probe_state()',1500);
		$('#progressbar').width(0);
		draw_progress_bar();
		return true;
	}
	
	// guide me page
	function preload_wz_page_p5()
	{
		//wz_probe_wan = 0;	//usar

		switch(wz_probe_wan) {
			case '1':		//dhcp
				$('input:radio[name=wan_type]').filter('[value=dhcpc]').attr('checked', true);
				next_page(findIndexOfArrayByValue(pageNameArray, mapWanType2Page(mapEnum2WanType(wz_probe_wan))));
				historyIdx--;
				break;
			case '2':		//pppoe
				$('input:radio[name=wan_type]').filter('[value=pppoe]').attr('checked', true);
				next_page(findIndexOfArrayByValue(pageNameArray, mapWanType2Page(mapEnum2WanType(wz_probe_wan))));
				historyIdx--;
				break;
			default:	//unknown type
				return true;
		}
		
		return false;
	}

	// manual wan type
	function preload_wz_page_p7a()
	{
		if (mapWanType2Page(get_checked_value(get_by_name('wan_type'))) != 'p7a') {
			next_page(findIndexOfArrayByValue(pageNameArray, mapWanType2Page(get_checked_value(get_by_name('wan_type')))));
			historyIdx--;
			return false;
		}

		return true;
	}

	function preload_wz_page_p9()
	{
		$('#p9_ssid').html(sp_words($('#p8_ssid').val()));
		$('#p9_secMode').html(get_words('KR48'));
		$('#p9_cipher').html(get_words('bws_CT_3'));
		$('#p9_key').html(sp_words($('#p8_key').val()));
		
		if (wband == "5G" || wband == "dual")
		{
			$('#p9_ssid_5').html(sp_words($('#p8_ssid_5').val()));
			$('#p9_secMode_5').html(get_words('KR48'));
			$('#p9_cipher_5').html(get_words('bws_CT_3'));
			$('#p9_key_5').html(sp_words($('#p8_key_5').val()));
		}
	}

	function preload_wz_page_p10()
	{
		count = 34;
		$('#p10_title').html(get_words('save_settings'));
		$('#save_and_wait').show();
		$('#chk_wan_bar').hide(); //chk_wan
		$('#wan_progressbar').width(0);
		setTimeout('get_conn_st()',8000);
		return true;
	}

	function preload_wz_page_p11()
	{
		return true;
	}
	
	function preload_wz_page_p12()
	{
		return true;
	}
	
	function preload_wz_page_p13a()
	{
		return true;
	}
	function preload_wz_page_p13b()
	{
		return true;
	}
	function preload_wz_page_p14()
	{
		return true;
	}

	function preload_wz_page_p15()
	{
		$('#p15_ssid').html(sp_words($('#p8_ssid').val()));
		$('#p15_secMode').html(get_words('KR48'));
		$('#p15_cipher').html(get_words('bws_CT_3'));
		$('#p15_key').html(sp_words($('#p8_key').val()));

		if (wband == "5G" || wband == "dual")
		{
			$('#p15_ssid_5').html(sp_words($('#p8_ssid_5').val()));
			$('#p15_secMode_5').html(get_words('KR48'));
			$('#p15_cipher_5').html(get_words('bws_CT_3'));
			$('#p15_key_5').html(sp_words($('#p8_key_5').val()));
		}
	}

	function verify_wz_page_p1()
	{
		var pwd = $('#pwd1').val();
		if ((pwd == '') || ($('#pwd2').val() == ''))
		{
			alert(get_words('mydlink_tx04'));
			return false;
		}

		if (pwd != $('#pwd2').val()){
			alert(get_words('_pwsame'));
			return false;
		}

		if((pwd != "") && (is_ascii(pwd) == false))
		{
			alert(get_words('S493'));
			return false;
		}
		if (pwd.length <= '5'){
			alert(get_words('limit_pass_msg'));
			return false;
		}

		return true;
	}
	
	function verify_wz_page_p6a()
	{
		/*
		 * Validate MAC and activate cloning if necessary
		 */

		var mac = $('#p6a_wan_mac').val(); 
		if (!check_mac(mac)){
			alert (get_words('KR3')+":" + mac + ".");
			return false;
		} 

		mac = trim_string($('#p6a_wan_mac').val());
		if(!is_mac_valid(mac, true)) {
			alert(get_words('KR3')+":" + mac + ".");
			return false;
		}

		if(mac.toLowerCase() != hw_mac_org.toLowerCase())
			already_clone = "1";

		$('input:radio[name=wan_type]').filter('[value=dhcpc]').attr('checked', true);
		$('#wan_mac').val($('#p6a_wan_mac').val());

		return true;
	}
	
	function verify_wz_page_p6b()
	{
		if($('#p6b_pppoe_user_name').val() == ""){
    		alert(get_words('PPP_USERNAME_EMPTY'));
    		return false;
	    }
		if($('#p6b_pppoe_pwd1').val() == ""){
    		alert(get_words('GW_WAN_PPPOE_PASSWORD_INVALID'));
    		return false;
	    }

		$('input:radio[name=wan_type]').filter('[value=pppoe]').attr('checked', true);
		$('#pppoe_user_name').val($('#p6b_pppoe_user_name').val());
		$('#pppoe_pwd1').val($('#p6b_pppoe_pwd1').val());

		return true;
	}

	function verify_wz_page_p7a()
	{
		/*
		 * Validate MAC and activate cloning if necessary
		 */

		var mac = $('#wan_mac').val();
		if (!check_mac(mac)){
			alert (get_words('KR3')+":" + mac + ".");
			return false;
		}

		mac = trim_string($('#wan_mac').val());
		if(!is_mac_valid(mac, true)) {
			alert (get_words('KR3')+":" + mac + ".");
			return false;
		}

		if(mac.toLowerCase() != hw_mac_org.toLowerCase())
			already_clone = "1";

		return true;
	}

	function verify_wz_page_p7b()
	{
	    var ip = $('#ip').val();
    	var mask = $('#mask').val();
    	var gateway = $('#gateway').val();
    	var dns1 = $('#static_dns1').val();
        var dns2 = $('#static_dns2').val();

		var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));
		var dns1_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_pdns'));
		var dns2_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_sdns'));

        var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
		var temp_dns1_obj = new addr_obj(dns1.split("."), dns1_addr_msg, false, false);
		var temp_dns2_obj = new addr_obj(dns2.split("."), dns2_addr_msg, true, false);

        if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
        	return false;
        }

		if (!check_address(temp_dns1_obj)){
			return false;
		}

    	if (dns2 != "" && dns2 != "0.0.0.0"){
    		if (!check_address(temp_dns2_obj)){
    			return false;
    		}
    	}
		return true;
	}

	function verify_wz_page_p7c()
	{
		var pppoe_type = get_by_name("pppoe_type");
		if($('#pppoe_user_name').val() == ""){
    		alert(get_words('PPP_USERNAME_EMPTY'));
    		return false;
	    }
		if($('#pppoe_pwd1').val() == ""){
    		alert(get_words('GW_WAN_PPPOE_PASSWORD_INVALID'));
    		return false;
	    }
		return true;
	}

	function verify_wz_page_p7d()
	{
		var pptp_type = get_by_name("pptp_type");
    	var ip = $('#pptp_ip').val();
    	var mask = $('#pptp_mask').val();  
    	var gateway = $('#pptp_gw').val();
		var server_ip = $('#pptp_server_ip').val();

		var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));

    	var dns1 = $('#pptp_dns1').val();
        var dns2 = $('#pptp_dns2').val();
		var dns1_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_pdns'));
		var dns2_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_sdns'));
		var temp_dns1_obj = new addr_obj(dns1.split("."), dns1_addr_msg, true, false);
		var temp_dns2_obj = new addr_obj(dns2.split("."), dns2_addr_msg, true, false);

		var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);

		if (pptp_type[1].checked){
        	if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
        		return false;
        	}
        }

    	if(server_ip == ""){
    		alert(get_words('YM108'));
    		return false;
       	}
		
		/*
		**    Date:		2013-05-23
		**    Author:	Pascal Pai
		**    Reason:   Check PPTP or L2TP Server IP Address is IP pattern or not
		**/
		if(ip_pattern(server_ip))
		{
			var server_ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('SERVER_IP_DESC'));
			var temp_server_ip_obj = new addr_obj(server_ip.split("."), server_ip_addr_msg, false, false);
			
			if (!check_address(temp_server_ip_obj)){
				return false;
			}
		}
		
       	if($('#pptpuserid').val() == ""){
       		alert(get_words('PPP_USERNAME_EMPTY'));
    		return false;
	     }
       	if ($('#pptppwd').val() == "" || $('#pptppwd2').val() == ""){
		 	alert(get_words('GW_WAN_PPTP_PASSWORD_INVALID'));
			return false;
		}
       	if (!check_pwd("pptppwd", "pptppwd2")){
       		return false;
       	}

		if (!check_address(temp_dns1_obj)){
			return false;
		}

    	if (dns2 != "" && dns2 != "0.0.0.0"){
    		if (!check_address(temp_dns2_obj)){
    			return false;
    		}
    	}
		return true;
	}
	
	function verify_wz_page_p7e()
	{
		var l2tp_type = get_by_name("l2tp_type");
    	var ip = $('#l2tp_ip').val();
    	var mask = $('#l2tp_mask').val();
    	var gateway = $('#l2tp_gw').val();
		var server_ip = $('#l2tp_server_ip').val();

    	var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));

    	var dns1 = $('#l2tp_dns1').val();
        var dns2 = $('#l2tp_dns2').val();
		var dns1_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_pdns'));
		var dns2_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_sdns'));
		var temp_dns1_obj = new addr_obj(dns1.split("."), dns1_addr_msg, true, false);
		var temp_dns2_obj = new addr_obj(dns2.split("."), dns2_addr_msg, true, false);

    	var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);

    	if (l2tp_type[1].checked){
	        if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
	    		return false;
	    	}
       	}

    	if(server_ip == ""){
    		alert(get_words('bwn_alert_17'));
    		return false;
       	}
		
		/*
		**    Date:		2013-05-23
		**    Author:	Pascal Pai
		**    Reason:   Check PPTP or L2TP Server IP Address is IP pattern or not
		**/
		if(ip_pattern(server_ip))
		{
			var server_ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('SERVER_IP_DESC'));
			var temp_server_ip_obj = new addr_obj(server_ip.split("."), server_ip_addr_msg, false, false);
			
			if (!check_address(temp_server_ip_obj)){
				return false;
			}
		}
		
        if($('#l2tpuserid').val() == ""){
    		alert(get_words('GW_WAN_L2TP_USERNAME_INVALID'));
    		return false;
	    }

	    if ($('#l2tppwd').val() == "" || $('#l2tppwd2').val() == ""){
		 	alert(get_words('GW_WAN_L2TP_PASSWORD_INVALID'));
			return false;
		}

       	if (!check_pwd("l2tppwd", "l2tppwd2")){
       		return false;
       	}

		if (!check_address(temp_dns1_obj)){
			return false;
		}

    	if (dns2 != "" && dns2 != "0.0.0.0"){
    		if (!check_address(temp_dns2_obj)){
    			return false;
    		}
    	}

		return true;
	}

	function verify_wz_page_p8()
	{
		if (wband == "5G" || wband == "dual"){
			if(!check_ssid("p8_ssid") || !check_ssid("p8_ssid_5"))
				return false;
			if(!check_ascii($('#p8_ssid').val()) || !check_ascii($('#p8_ssid_5').val())){
				alert(get_words("ssid_ascii_range"));
				return false;
			}
			if ((check_key($('#p8_key').val()) == false) || (check_key($('#p8_key_5').val()) == false))
				return false;
		}else{
			if(!check_ssid("p8_ssid"))
					return false;
			if(!check_ascii($('#p8_ssid').val())){
				alert(get_words("ssid_ascii_range"));
				return false;
			}
			if (check_key($('#p8_key').val()) == false)
				return false;
		}
		//usar
		//if ($('input[name=assign_key_act]:checked').val() == '1') {	//manual 

		return true;
	}

	function verify_wz_page_p13b()
	{
		var showword = ' '+get_words('mydlink_pop_03');
		var mailaddr = $('#email_addr').val();

		if (mailaddr == ''){
			alert(get_words('mydlink_tx09')+showword);
			return false;
		}

		if (!mail_addr_test(mailaddr))
		{
			alert(get_words('mydlink_tx09')+' "'+ mailaddr+'" '+get_words('mydlink_pop_04'));
			return false;
		}

		if ($('#passwd').val() == ''){
			alert(get_words('_password')+showword);
			return false;
		}

		if (is_ascii($('#passwd').val()) == false)
		{
			alert(get_words('S493'));
			return false;
		}

		if ($('#passwd').val() != $('#pass_chk').val()){
			alert(get_words('_pwsame'));
			return false;
		}

		if ($('#passwd').val().length <= '5'){
			alert(get_words('limit_pass_msg'));
			return false;
		}

		if ($('#lname').val() == ''){
			alert(get_words('Lname')+showword);
			return false;
		}

		if ($('#fname').val() == ''){
			alert(get_words('Fname')+showword);
			return false;
		}

		if (get_checked_value($('#mdl_caption')[0]) == 0)
		{
			alert(get_words('mydlink_pop_02'));
			return false;
		}
		$('#next_b_p13b').attr('disabled','true');
		submit_regist(2);
		return true;
	}

	function verify_wz_page_p13a()
	{
		var showword = ' '+get_words('mydlink_pop_03');
		var mailaddr = $('#email_addra').val();
		if (mailaddr == ''){
			alert(get_words('mydlink_tx09')+showword);
			return false;
		}
		if (!mail_addr_test(mailaddr))
		{
			alert(get_words('mydlink_tx09')+' "'+ mailaddr+'" '+get_words('mydlink_pop_04'));
			return false;
		}

		if ($('#pass').val() == ''){
			alert(get_words('_password')+showword);
			return false;
		}
		return true;
	}
	
	//20120530 pascal add
	function get_conn_st_mydlink()
	{
		var conn_st = query_wan_connection();
		if(conn_st == "true")
			get_wan_st_mydlink();
		else
			setTimeout('get_conn_st_mydlink()',500);
	}
	
	//20120530 pascal add
	function get_wan_st_mydlink()
	{
		var time=new Date().getTime();

		var ajax_param = {
			type: 	"POST",
			async:	false,
			url: 	"mdl_check.ccp",
			data: 	"act=getwanst"+"&"+time+"="+time,
			success: function(data) {
				if (data.indexOf('false') != -1)
				{
					count_myd++;
					if ((count_myd % 2) ==0)
						do_fakeping();
					setTimeout('get_wan_st_mydlink()', 1000);
				}
				else{
					alert(get_words(show_mydlink_start_str));
					location.assign('http://www.mydlink.com');
				}
			}
		};
		try {
				$.ajax(ajax_param);
		} catch (e) {
		}
	}

	function get_conn_st()	//20120417 silvia add
	{
		/*var paramHost={
			'url': 	'easy_setup.ccp',
			'arg': 	'ccp_act=get&es_step=0&num_inst=1&oid_1=IGD_WANDevice_i_WANStatus_&inst_1=11000'
		};
		get_config_obj(paramHost);

		var conn_st = config_val("igdWanStatus_NetworkStatus_");
		*/
		if (count == 34)	//def count
		{
			$('#p10_title').html(get_words('ES_title_s6'));
			$('#save_and_wait').hide();
			$('#chk_wan_bar').show(); //chk_wan
			limit_time = new Date().getTime() + 1000 * 60;
		}

		if (get_secs_to_countdown() >= limit_time)
		{
			$("#append_net").dialog("open");
			return;
		}

		var conn_st = query_wan_connection();
		if(conn_st == "true")
		{
			get_wan_st();
			//check_file();
		}else{
			if ((count % 5) ==0)
				do_fakeping();
				
			if (count <= 0){
				$("#append_net").dialog("open");
				return;
			}else{
				count--;
				setTimeout('get_conn_st()',1000);
			}
		}
	}

	//20120419 silvia add, new chk wan reserve act
	function get_wan_st()
	{
		if ((count==0) || (get_secs_to_countdown() >= limit_time))
		{
			$("#append_net").dialog("open");
			return;
		}
		var time=new Date().getTime();

		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	"mdl_check.ccp",
			data: 	"act=getwanst"+"&"+time+"="+time,
			success: function(data) {
				if (data.indexOf('false') != -1)
				{
					count--;
					if ((count % 2) ==0)
						do_fakeping();
					setTimeout('get_wan_st()', 1000);
				}
				else{
					setTimeout('do_sp_ping()', pingIntv);
					setTimeout('next_page()', 2000);
				}
			}
		};
		try {
				$.ajax(ajax_param);
		} catch (e) {
		}
	}

	/*
	function mdl_chk_wan()
	{
		setTimeout('queryPingRet()',3000);
		count=30;
	}*/

	function query_wan_connection()
	{
		var pingObj = new ccpObject();
		var paramQuery = {
			url: "ping.ccp",
			arg: "ccp_act=queryWanConnect"
		};
		
		pingObj.get_config_obj(paramQuery);
		var ret = pingObj.config_val("WANisReady");
		return ret;
	}
	
	/*
	function queryPingRet()
	{
		if (count <= 0)
			return;
			
		var val = query_wan_connection();
		//alert(val);
		
		if(val != "true")
		{
			do_fakeping();
			setTimeout('queryPingRet()',2000);
			count-=1;	
			//return;
		}
		else
		{
			var paramQuery = {
				url: "ping.ccp",
				arg: "ccp_act=queryPingV4Ret"
			};

			get_config_obj(paramQuery);
			var ret = config_val("ping_result");

			switch(ret)
			{
				case "success":
					count = -1;
					setTimeout('do_sp_ping()', pingIntv);
					next_page();
					return;
				break;
				case "fail":
					if (count > 4)
					{
						do_fakeping();
						do_ping();
					}
					setTimeout('queryPingRet()',2000);
					count-=2;
				break;
				case "waiting":
					if (count > 0)
						setTimeout('queryPingRet()',3000);
					count-=3;
				break;
				default:
					setTimeout('queryPingRet()',1000);
					count-=1;
				break;
			}
		}

		if (count <= 0){
			$("#append_net").dialog("open");
			return;
		}
	}
	
	function check_file()
	{
		if((count==0) && (fichk==-2)){
			$("#append_net").dialog("open");
			return;
		}

		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	"mdl_check.ccp",
			data: 	"act=chkprov",
			success: function(data) {
				if (data.indexOf('false') != -1)
				{
					fichk=-2;
					count--;
					do_fakeping();
					setTimeout('check_file()', 1000);
				}
				else{
					fichk=-1;
					mdl_srv = data;
					do_ping();
					setTimeout('mdl_chk_wan()', 1500);
				}
			}
		};
		try {
				$.ajax(ajax_param);
		} catch (e) {
		}
	}
*/
	function wz_back(idx)
	{
		switch(idx)
		{
			case 1:
				close_net();
				historyIdx = 0;
				submit_button_flag = 0;
				next_page(findIndexOfArrayByValue(pageNameArray,'p0'));
				$('#chk_wan').hide();
				count = 1;
				//fichk = 0;
				break;
			case 0:
				close_net();
				wizard_cancel(3);
				break;
		}
		
		return false;
	}

	function constructParamWifi(obj)
	{
		var wband_i =(wband == "2.4G")?1:5;

		obj.add_param_arg('wlanCfg_Enable_','1.1.0.0',1);
		obj.add_param_arg('wlanCfg_SSID_','1.1.0.0',$('#p8_ssid').val());
		obj.add_param_arg('wpaPSK_KeyPassphrase_','1.1.1.1',$('#p8_key').val());

		if (wband == "5G" || wband == "dual"){
			obj.add_param_arg('wlanCfg_Enable_','1.5.0.0',1);
			obj.add_param_arg('wlanCfg_SSID_','1.5.0.0',$('#p8_ssid_5').val());
			obj.add_param_arg('wpaPSK_KeyPassphrase_','1.5.1.1',$('#p8_key_5').val());
		}

		for (var i =1;i<=wband_i;)
		{
			obj.add_param_arg('wlanCfg_SecurityMode_','1.'+i+'.0.0',2);
			obj.add_param_arg('wpaInfo_WPAMode_','1.'+i+'.1.0',0);
			obj.add_param_arg('wpaInfo_AuthenticationMode_','1.'+i+'.1.0',0);
			obj.add_param_arg('wpaInfo_EncryptionMode_','1.'+i+'.1.0',2);

			// since security will be modified, WPS should always be set configured.
			obj.add_param_arg('wpsCfg_Status_','1.'+i+'.1.0',1);
			i+=4;
		}

		obj.add_param_arg('wpsCfg_Status_','1.1.1.0',1);
		return obj;
	}

	function constructParamDHCPC()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=1";
		paramStr += "&wanDev_MACAddressClone_1.1.0.0=" + $('#wan_mac').val();
		paramStr += "&wanDev_MACAddressOverride_1.1.0.0=" + already_clone;
		//paramStr += "&dhcpCfg_UnicastUsed_1.1.1.0=0";
		paramStr += "&dhcpCfg_MaxMTUSize_1.1.1.0=1500";
		return paramStr;
	}

	function constructParamPPPoE()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=2";
		paramStr += "&pppoeCfg_IPAddressType_1.1.1.1.0=" + get_checked_value(get_by_name("pppoe_type"));
		paramStr += "&pppoeCfg_Username_1.1.1.0=" + urlencode($('#pppoe_user_name').val());
		paramStr += "&pppoeCfg_Password_1.1.1.0=" + urlencode($('#pppoe_pwd1').val());
		paramStr += "&pppoeCfg_NetSniperSupport_1.1.1.0=0";
		paramStr += "&pppoeCfg_SpecialDialMode_1.1.1.0=0";
		paramStr += "&pppoeCfg_PPPoEPlusDialEnable_1.1.1.0=" + get_checked_value($('#pppoe_plus_support')[0]);
		return paramStr;
	}

	function constructParamStaticIP()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=0";
		paramStr += "&staticIPCfg_ExternalIPAddress_1.1.1.0=" + $('#ip').val();
		paramStr += "&staticIPCfg_SubnetMask_1.1.1.0=" + $('#mask').val();
		paramStr += "&staticIPCfg_DefaultGateway_1.1.1.0=" + $('#gateway').val();	
		paramStr += "&staticIPCfg_DNSServers_1.1.1.0=" + $('#static_dns1').val() +","+ $('#static_dns2').val();
		paramStr += "&staticIPCfg_MaxMTUSize_1.1.1.0=1500";
		return paramStr;
	}

	function constructParamPPTP()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=3";
		paramStr += "&pptpCfg_IPAddressType_1.1.1.0=" + get_checked_value(get_by_name("pptp_type"));
		paramStr += "&pptpCfg_ExternalIPAddress_1.1.1.0=" + $('#pptp_ip').val();
		paramStr += "&pptpCfg_SubnetMask_1.1.1.0=" + $('#pptp_mask').val();
		paramStr += "&pptpCfg_DefaultGateway_1.1.1.0=" + $('#pptp_gw').val();
		paramStr += "&pptpCfg_DNSServers_1.1.1.0=" + $('#pptp_dns1').val() + ',' + $('#pptp_dns2').val();
		paramStr += "&pptpConn_ServerIP_1.1.1.1=" + $('#pptp_server_ip').val();
		paramStr += "&pptpConn_Username_1.1.1.1=" + urlencode($('#pptpuserid').val());
		paramStr += "&pptpConn_Password_1.1.1.1=" + urlencode($('#pptppwd').val());
		return paramStr;
	}

	function constructParamL2TP()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=4";
		paramStr += "&l2tpCfg_IPAddressType_1.1.1.0=" + get_checked_value(get_by_name("l2tp_type"));
		paramStr += "&l2tpCfg_ExternalIPAddress_1.1.1.0=" + $('#l2tp_ip').val();
		paramStr += "&l2tpCfg_SubnetMask_1.1.1.0=" + $('#l2tp_mask').val();
		paramStr += "&l2tpCfg_DefaultGateway_1.1.1.0=" + $('#l2tp_gw').val();
		paramStr += "&l2tpCfg_DNSServers_1.1.1.0=" + $('#l2tp_dns1').val() + ',' + $('#l2tp_dns2').val();
		paramStr += "&l2tpConn_ServerIP_1.1.1.1=" + $('#l2tp_server_ip').val();
		paramStr += "&l2tpConn_Username_1.1.1.1=" + urlencode($('#l2tpuserid').val());
		paramStr += "&l2tpConn_Password_1.1.1.1=" + urlencode($('#l2tppwd').val());
		return paramStr;
	}

	$(document).ready( function () {
		switch(wanCfg.wanMode)
		{
			case "0":
				set_checked("static", get_by_name("wan_type"));
			break;

			case "1":
				set_checked("dhcpc", get_by_name("wan_type"));
			break;

			case "2":
				set_checked("pppoe", get_by_name("wan_type"));
			break;

			case "3":
				set_checked("pptp", get_by_name("wan_type"));
			break;

			case "4":
				set_checked("l2tp", get_by_name("wan_type"));
			break;

			case "9":
				set_checked("dhcpplus", get_by_name("wan_type"));
			break;
		}

		$('#wan_mac').val(wanCfg.wanMac);

		set_checked(wanCfg.wanPppoeType, get_by_name("pppoe_type"));
		$('#pppoe_user_name').val(wanCfg.wanPppoeName);
		
		set_checked(wanCfg.wanPPTPType, get_by_name("pptp_type"));
		$('#pptp_ip').val(wanCfg.wanPPTPAddr);
		$('#pptp_mask').val(wanCfg.wanPPTPMask);
		$('#pptp_gw').val(wanCfg.wanPPTPGw);
		$('#pptp_server_ip').val(wanCfg.wanPPTPServ);
		$('#pptpuserid').val(wanCfg.wanPPTPName);	
		$('#pptp_dns1').val(wanCfg.wanPPTPDNS[0]);
		if (wanCfg.wanPPTPDNS[1])
			$('#pptp_dns2').val(wanCfg.wanPPTPDNS[1]);
		else
			$('#pptp_dns2').val('0.0.0.0');
			
		set_checked(wanCfg.wanL2TPType, get_by_name("l2tp_type"));
		$('#l2tp_ip').val(wanCfg.wanL2TPAddr);
		$('#l2tp_mask').val(wanCfg.wanL2TPMask);
		$('#l2tp_gw').val(wanCfg.wanL2TPGw);
		$('#l2tp_server_ip').val(wanCfg.wanL2TPServ);
		$('#l2tpuserid').val(wanCfg.wanL2TPName);
		$('#l2tp_dns1').val(wanCfg.wanL2TPDNS[0]);
		if (wanCfg.wanL2TPDNS[1])
			$('#l2tp_dns2').val(wanCfg.wanL2TPDNS[1]);
		else
			$('#l2tp_dns2').val('0.0.0.0');

		$('#ip').val(wanCfg.wanStaticIp);
		$('#mask').val(wanCfg.wanStaticSubnet);
		$('#gateway').val(wanCfg.wanStaticGw);

		$('#static_dns1').val(wanCfg.wanStaticDns[0]);
		
		if (wanCfg.wanStaticDns[1])
			$('#static_dns2').val( wanCfg.wanStaticDns[1]);
		else
			$('#static_dns2').val("0.0.0.0");

		$('#p8_ssid').val(wlanSSID[0]);
		$('#p8_ssid_5').val(wlanSSID[2]);
	});

	function lang_set()
	{
		var str = '';
		var location_idx = '';
		var temp_cURL = document.URL.split('#');
		str += ("<div id=lang_menu class=langmenu style=position:absolute;>");			
		for(var i = 0,len = langArray.length; i<len; i+=j)
		{
			str += ("<div class=column>");
			str += ("<ul>");
			for (var j =0; j<8; j++)
			{
				location_idx = i+j+1;
				if ((i+j)<len){
					if ((i+j) == 20){
						i++;
						location_idx = i+j+1;
					}
					str += ("<li><a href='"+ temp_cURL[0] +"#"+ location_idx+"'onclick=lang_change('#"+location_idx+"')>"+langArray[(i+j)]+"</a></li>");
				}
			}
			str += ("<ul>");
			str += ("</div>");
		}
		str += ("</div>");
		$('#lang_menu_list').html(str);
	}

	function show_txtlang(br)
	{
		var num_index=parseInt(br);
		$('#tlang').val(langArray[num_index-1]);
	}
	
	function show_lang()
	{
		close=1;
		imgclose=1;
		//$('#tlang').attr('disabled', true);
		$('#lang_menu').show();
		$('#lang_menu').focus();
	}

	/**	Date:	2013-08-27
	 **	Author:	Silvia Chang
	 **	Reason:	fixed can not chang lang from UI drop-down menu and always display same lang
	 **/
	function lang_change(Nlang)
	{
		//select from UI drop-down menu
		var indexL =Nlang.split('#');
		if (indexL.length>1)
		{
			Nlang = indexL[1];
			$('#curr_language').val(Nlang);
			if (indexL[1] != br_lang)
			{
				ajax_submit(Nlang);
				return;
			}
		}

		//check current URL, is broswer lang or default lang
		if (document.URL.split('#').length == 1 || br_lang == 0)
		{
			ajax_submit(Nlang);
			return;
		}
	}

	function ajax_submit(Nlang)
	{
		var time=new Date().getTime();
		var temp_cURL = document.URL.split('#');
		var ajax_param = {
			type: 	"POST",
			async:	false,
			url: 	'curr_lang.ccp',
			data: 	'ccp_act=set&curr_language='+Nlang+
					'&igd_CurrentLanguage_1.0.0.0='+Nlang+"&"+time+"="+time,
			success: function(data) {
				window.location.href = temp_cURL[0] +'#'+Nlang;
/*				var isSafari = navigator.userAgent.search("Safari") > -1;
				if (isSafari)
					location.replace('/wizard_router.asp');
				else
					window.location.reload(true);
*/
				window.location.reload(true);
			}
		};
		$.ajax(ajax_param);
	}

	function close_net()
	{
		$( "#append_net" ).dialog("close");
	}
	function prev_page_mld(idx)
	{
		displayPage('idx');
		get_by_id('p12').style.display = "";
		wz_curr_page = 18;
		historyIdx--;
	}

	function mail_addr_test(str)
	{
		/*
		var rlt = 0;	
		var tmp = str.split("@");
		try{
	        if(tmp.length == 2 && /^([+]?)*([a-zA-Z0-9]*[_|\-|\.|\+|\%|\*|\?|\!|\\]?)*[a-zA-Z0-9]*([+]?)+$/.test(tmp[0]) && /^([a-zA-Z0-9]*[_|\-|\.|\+|\%|\*|\?|\!|\\]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,6}$/.test(tmp[1])){
	            rlt = 1
	        }
		}catch(e){}
		return rlt;
		*/
		var patten = new RegExp(/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]+$/);
		return patten.test(str);
	}

	$(document).ready(function() {
		$('#lang_select').click(function() {
			if(imgclose==0)
				show_lang();
			else if(imgclose==1)
				close_lang(1);
		});
		
		$('#tlang').click(function() {
			if(imgclose==0)
				show_lang();
			else if(imgclose==1)
				close_lang(1);
		});

		$('#lang_menu').click(function(event) {
			close_lang(1);
		});
	});
	
	function close_lang(clo){
		//clo 1:close  2:outside of lang_menu 3:inside of lang_menu
		if (clo==1){
			$('#lang_menu').hide();
			//$('#tlang').attr('disabled', false);
			imgclose=0;
		}
		else if(clo==2){
			close=-1;
		}
		else if(clo=3){
			close=1;
		}
	}
	$(document).click(function() { if(close==-1) close_lang(1);});

	//20120302 silvia add for chk wan status of mydlink register
/*
	function do_ping()
	{
		
		var paramPing = {
			url: "ping.ccp",
			arg: 'ccp_act=ping_v4&ping_addr='+mdl_srv
		};
		ping_wan(paramPing);
	}
*/
	function do_sp_ping()
	{
		var paramPing = {
			url: "ping.ccp",
			arg: 'ccp_act=ping_v4&iface=lan&ping_addr=www.dlink.com'
		};
		ping_wan(paramPing);
		setTimeout('do_sp_ping()', pingIntv);
	}

	function do_fakeping()
	{
		
		var paramPing = {
			url: "ping.ccp",
			arg: 'ccp_act=fakeping&fakeping=1'
		};
		ping_wan(paramPing);
	}

	function ping_wan(p)
	{
		var time=new Date().getTime();
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	p.url,
			data: 	p.arg+"&"+time+"="+time
		};

		$.ajax(ajax_param);
	}

/*	function pop()
	{
		alert(get_words('mydlink_pop_09'));
	}
*/

	function get_secs_to_countdown()
	{
		var curWidth = $('#wan_progressbar').width();
		var fieldWidth = curWidth + (progressBarMaxWidth-curWidth)/5;
	
		if (progressBarMaxWidth-curWidth <= 5) {
			$('#wan_progressbar').width(progressBarMaxWidth);
			return;
		}

		if ($('#wan_progressbar').width() < progressBarMaxWidth) {
			$('#wan_progressbar').width(fieldWidth);
		}

		var time_secs = new Date().getTime();
		return time_secs;
	}
</script>
</head>
<body topmargin="1" leftmargin="0" rightmargin="0" bgcolor="#757575">
<center>
	<table class="MainTable" cellpadding="0" cellspacing="0">
		<tr>
			<td bgcolor="#FFFFFF">
			<div align=center>
			<table id="header_container" border="0" cellpadding="5" cellspacing="0" width="838" align="center">
				<tr>
					<td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"><script>document.write(dev_info.model);</script></a></td>
					<td align="right" nowrap><script>show_words('TA3')</script>: <script>document.write(dev_info.hw_ver);</script> &nbsp;</td>
					<td align="right" nowrap><script>show_words('sd_FWV')</script>: <script>document.write(dev_info.fw_ver);</script></td>
					<td>&nbsp;</td>
				</tr>
			</table>
			</div>
			</td>
		</tr>
	</table>
	<!-- banner -->
	<div id="header_banner">
		<div id="header_lang" style="float:right;height:25px;vertical-align:text-bottom;">
			<strong><script>show_words('_Language');</script>&nbsp;:&nbsp;</strong>
			<input type="text" id="tlang" name="tlang" size="20" maxlength="15" value="" style=cursor:default onblur="close_lang(2);" readonly />
			<img src="image/lang_button1.png" width="18" height="20" id="lang_select" name="lang_select"  onmouseover="close_lang(3);" onmouseout="close_lang(2);" />
		</div>
	</div>
	<!-- end of banner -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
		<tr>
			<td  style=padding-left:437><form id='lang_menu_list' onmouseover="close_lang(3);" onmouseout="close_lang(2);"></form>
			</td>			
		</tr>
	</table>
<table class="MainTable" cellpadding="0" cellspacing="0">
<tr>
	<td bgcolor="#FFFFFF">
	<p>&nbsp;</p>
	<table width="650" border="0" align="center">
	<tr>
		<td>
		<form id="formAll" name="formAll">
		<input type="hidden" id="curr_language" name="curr_language">
<!-------------------------------->
<!--     start of page main (welcome)    -->
<!-------------------------------->
		<div class=box id="p0" style="display:none">
		<h2 align="left"><script>show_words('wwa_title_wel')</script></h2>
		<p class="box_msg"><script>show_words('wwa_intro_wel')</script></p>
		<table class=formarea>
		<tr>
			<td width="334" height="81">
			<UL>
				<LI><script>show_words('ES_wwa_title_s1')</script></LI>
				<LI><script>show_words('ES_step_wifi_security')</script></LI>
				<LI><script>show_words('ES_title_s3')</script></LI>
				<LI><script>show_words('ES_title_s4')</script></LI>
				<LI><script>show_words('ES_title_s5_0')</script></LI>
				<LI><script>show_words('ES_title_s6')</script></LI>
			</UL>
			</TD>
		</tr>
		</table>
		<table align="center" class="formarea">
		<tr>
			<td>
			<fieldset id="wz_buttons">
				<input type="button" class="button_submit" id="cancel_b2_p0" name="cancel_b2_p0" value="" onClick="wizard_cancel();">
				<input type="button" class="button_submit" id="next_b2_p0" name="next_b2_p0" value="" onClick="next_page();">				
				<script>$('#next_b2_p0').val(get_words('_next'));</script>
				<script>$('#cancel_b2_p0').val(get_words('_cancel'));</script>
			</fieldset>
			</td>
		</tr>
		</table>
		</div>
<!-------------------------------->
<!--     End of page main       -->
<!-------------------------------->

<!-------------------------------->
<!--     Start of page 3 (password)      -->
<!-------------------------------->
		<div class=box id="p1" style="display:none"> 
		<h2 align="left"><script>show_words('ES_title_s3')</script></h2>
		<p class="box_msg"><script>show_words('wwa_intro_s1')</script></p>
		<table class=formarea>
		<!--
		**	Date:	2013-05-14
		**	Author:	Silvia Chang
		**	Reason:	mydlink wizard v1.05R, Appendix IV: 32 for Admin passwd
		-->
		<tr>
			<td align=right class="duple"><script>show_words('_password')</script>:</td>
			<td>&nbsp;
				<input type="password" id=pwd1 name=pwd1 size=20 maxlength=32 value=''>
			</td>
		</tr>
		<tr>
			<td align=right class="duple"><script>show_words('_verifypw')</script> :</td>
			<td>&nbsp;
				<input type="password" id=pwd2 name=pwd2 size=20 maxlength=32 value=''>
			</td>
			</tr>
			<tr>
				<td align=right class="duple">
					<script>show_words('_graph_auth')</script> 
				:</td>
				<td>&nbsp;
					<input type=checkbox id=graphical_enable name=graphical_enable value="1">
			</td>
		</tr>
		</table>
		<br>
		<table align="center" class="formarea">
		<tr>
			<td>
				<input type="button" class="button_submit" id="cancel_b_p1" name="cancel_b_p1" value="" onclick="wizard_cancel();"> 
				<input type="button" class="button_submit" id="wz_prev_b_p1" name="wz_prev_b_p1" value="" onclick="prev_page();"> 
				<input type="button" class="button_submit" id="next_b_p1" name="next_b_p1" value="" onClick="next_page();"> 				
				<script>$('#wz_prev_b_p1').val(get_words('_prev'));</script>
				<script>$('#next_b_p1').val(get_words('_next'));</script>
				<script>$('#cancel_b_p1').val(get_words('_cancel'));</script>
			</td>
		</tr>
		</table>
		</div>
<!-------------------------------->
<!--       End of page 3        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 2 (timezone)      -->
<!-------------------------------->
		<div class=box id="p2" style="display:none"> 
			<h2 align="left"><script>show_words('ES_title_s4')</script></h2>
			<p class="box_msg"><script>show_words('wwa_intro_s2')</script></p>
			<P align="center">
				<select size=1 id="tzone" name="tzone">
					<option value="-192"><font face="Arial"><script>show_words('up_tz_76')</script></font></option>
					<option value="-176"><font face="Arial"><script>show_words('up_tz_77')</script></font></option>
					<option value="-160"><font face="Arial"><script>show_words('up_tz_02')</script></font></option>
					<option value="-144"><font face="Arial"><script>show_words('up_tz_03')</script></font></option>
					<option value="-128"><font face="Arial"><script>show_words('up_tz_04')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_05')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_78')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_06')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_07')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_08')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_79')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_10')</script></font></option>
					<option value="-80"><font face="Arial"><script>show_words('up_tz_80')</script></font></option>
					<option value="-80"><font face="Arial"><script>show_words('up_tz_12')</script></font></option>
					<option value="-72"><font face="Arial"><script>show_words('up_tz_81')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_82')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_14')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_16')</script></font></option>
					<option value="-56"><font face="Arial"><script>show_words('up_tz_17')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_18')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_83')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_20')</script></font></option>
					<option value="-32"><font face="Arial"><script>show_words('up_tz_21')</script></font></option>
					<option value="-16"><font face="Arial"><script>show_words('up_tz_22')</script></font></option>
					<option value="-16"><font face="Arial"><script>show_words('up_tz_23')</script></font></option>
					<option value="0"><font face="Arial"><script>show_words('up_tz_24')</script></font></option>
					<option value="0"><font face="Arial"><script>show_words('up_tz_25')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_26')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_27')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_28')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_84')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_30')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_31')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_32')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_33')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_34')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_85')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_36')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_37')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_38')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_40')</script></font></option>
					<option value="56"><font face="Arial"><script>show_words('up_tz_41')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_42')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_43')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_39')</script></font></option>
					<option value="72"><font face="Arial"><script>show_words('up_tz_44')</script></font></option>
					<option value="80"><font face="Arial"><script>show_words('up_tz_46')</script></font></option>
					<option value="88"><font face="Arial"><script>show_words('up_tz_86')</script></font></option>
					<option value="88"><font face="Arial"><script>show_words('up_tz_88')</script></font></option>
					<option value="92"><font face="Arial"><script>show_words('up_tz_48')</script></font></option>
					<option value="96"><font face="Arial"><script>show_words('up_tz_50')</script></font></option>
					<option value="96"><font face="Arial"><script>show_words('up_tz_45')</script></font></option>
					<option value="104"><font face="Arial"><script>show_words('up_tz_52')</script></font></option>
					<option value="112"><font face="Arial"><script>show_words('up_tz_87')</script></font></option>
					<option value="112"><font face="Arial"><script>show_words('up_tz_53')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_54')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_55')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_57')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_58')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_59')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_89')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_90')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_60')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_61')</script></font></option>
					<option value="152"><font face="Arial"><script>show_words('up_tz_63')</script></font></option>
					<option value="152"><font face="Arial"><script>show_words('up_tz_64')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_65')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_66')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_67')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_68')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_62')</script></font></option>
					<option value="176"><font face="Arial"><script>show_words('up_tz_70')</script></font></option>
					<option value="176"><font face="Arial"><script>show_words('up_tz_69')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_75')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_71')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_72')</script></font></option>
					<option value="208"><font face="Arial"><script>show_words('up_tz_91')</script></font></option>
					<option value="208"><font face="Arial"><script>show_words('up_tz_92')</script></font></option>
				</select>
			</p>
			<br>
			<table align="center" class="formarea">
			<tr>
				<td>
					<input type="button" class="button_submit" id="cancel_b_p2" name="cancel_b_p2" value="" onclick="wizard_cancel();">
					<input type="button" class="button_submit" id="wz_prev_b_p2" name="wz_prev_b_p2" value="" onclick="prev_page();"> 
					<input type="button" class="button_submit" id="next_b_p2" name="next_b_p2" value="" onClick="next_page();"> 									
					<script>$('#wz_prev_b_p2').val(get_words('_prev'));</script>
					<script>$('#next_b_p2').val(get_words('_next'));</script>
					<script>$('#cancel_b_p2').val(get_words('_cancel'));</script>
					
				</td>
			</tr>
			</table>
		</div>
<!-------------------------------->
<!--       End of page 2        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 3 (cable lost)      -->
<!-------------------------------->
		<div class=box id="p3" style="display:none"> 
			<h2><script>show_words('ES_wwa_title_s1')</script></h2>
			<p class="box_msg"><script>show_words('ES_cable_lost_desc')</script></p>
			<div align="center">
				<img src="image/netowrk-topology_1.03.png" width="603" height="246">
			</div>
			<div> 
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p3" name="cancel_b_p3" value="" onclick="wizard_cancel();">
						<input type="button" class="button_submit" id="wz_prev_b_p3" name="wz_prev_b_p3" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p3" name="next_b_p3" value="" onClick="try_again();"> 						
						<script>$('#wz_prev_b_p3').val(get_words('_prev'));</script>
						<script>$('#next_b_p3').val(get_words('_connect'));</script>
						<script>$('#cancel_b_p3').val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
<!-------------------------------->
<!--      End of page 3 (cable lost)      -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 4 (auto-detection)      -->
<!-------------------------------->
		<div class=box id="p4" style="display:none"> 
			<h2><script>show_words('ES_wwa_title_s1')</script></h2>
			<p class="box_msg"><script>show_words('ES_auto_detect_desc')</script></p>
			<p>
				<div align="center">
				<div align="left" style="width:500;border:3px solid #000000" >
					<div id="progressbar" style="background-color: #FF6F00;">&nbsp;</div>
				</div>
				</div>
			</p>
			<div> 
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p4" name="cancel_b_p4" value="" onclick="wizard_cancel();">
						<input type="button" class="button_submit" id="wz_prev_b_p4" name="wz_prev_b_p4" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p4" name="next_b_p4" value="" onClick="next_page();"> 
						<script>$('#wz_prev_b_p4').val(get_words('_prev'));</script>
						<script>$('#next_b_p4').val(get_words('_next'));</script>
						<script>$('#cancel_b_p4').val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
<!-------------------------------->
<!--      End of page 4 (auto-detection)      -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 5 (unable to detect the Internet connection type)      -->
<!-------------------------------->
		<div class=box id="p5" style="display:none"> 
			<h2><script>show_words('ES_wwa_title_s1')</script></h2>
			<p class="box_msg"><script>show_words('ES_auto_detect_failed_desc')</script></p>
			<br><br>
			<div> 
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p5" name="cancel_b_p5" value="" onclick="wizard_cancel();"> 
						<input type="button" class="button_submit" id="wz_prev_b_p5" name="wz_prev_b_p5" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p5" name="next_b_p5" value="" onClick="next_page();"> 
						<script>$('#wz_prev_b_p5').val(get_words('ES_btn_try_again'));</script>
						<script>$('#next_b_p5').val(get_words('ES_btn_guide_me'));</script>	
						<script>$('#cancel_b_p5').val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
<!-------------------------------->
<!--      End of page 5 (unable to detect the Internet connection type)      -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 6a (DHCP)     -->
<!-------------------------------->
		<div class=box id="p6a" style="display:none"> 
			<h2 align="left"><script>show_words('_dhcpconn')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_msg_set_dhcp')</script></p>
				<div>
					<table align="center" class=formarea>
					<tr>
						<td width="137" align=right class="duple">
							<script>show_words('_macaddr')</script>
							&nbsp;:
						</td>
						<td width="473">
							<input type="text" id="p6a_wan_mac" name="p6a_wan_mac" maxlength="17" size="20" value=''>
							<script>show_words('_optional')</script>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td> 
							<input name="clone" type="button" class="button_submit" id="clone_2" value="" onClick='clone_mac_action("p6a_wan_mac");'>
							<script>$('#clone_2').val(get_words('_clone'));</script>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class=form_label>&nbsp;
						</td>
						<td>
							<input type="button" class="button_submit" id="cancel_b_p6a" name="cancel_b_p6a" value="" onclick="wizard_cancel();"> 
							<input type="button" class="button_submit" id="wz_prev_b_p6a" name="wz_prev_b_p6a" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p6a" name="next_b_p6a" value="" onClick="next_page();"> 							
							<script>$('#wz_prev_b_p6a').val(get_words('_prev'));</script>
							<script>$('#next_b_p6a').val(get_words('_next'));</script>
							<script>$('#cancel_b_p6a').val(get_words('_cancel'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 6a       -->
<!-------------------------------->


<!-------------------------------->
<!--      Start of page 6b (pppoe)     -->
<!-------------------------------->
		<div class=box id="p6b" style="display:none"> 
			<h2 align="left"><script>show_words('wwa_title_set_pppoe')</script></h2>
			<p class="box_msg"><script>show_words('wwa_msg_set_pppoe')</script></p>
			<div>
				<table class=formarea >
				<tr>
					<td align=right class="duple">
						<script>show_words('_username')</script>
						&nbsp;:</td>
					<td>
						<input type=text id=p6b_pppoe_user_name name=p6b_pppoe_user_name size="20" maxlength="63" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple">
						<script>show_words('_password')</script>
						&nbsp;:</td>
					<td>
							<input type=text id=p6b_pppoe_pwd1 name=p6b_pppoe_pwd1 size="20" maxlength="64" value="">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>

				<tr>
					<td></td>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p6b" name="cancel_b_p6b" value="" onclick="wizard_cancel();">
						<input type="button" class="button_submit" id="wz_prev_b_p6b" name="wz_prev_b_p6b" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p6b" name="next_b_p6b" value="" onClick="next_page();"> 						
						<script>$('#wz_prev_b_p6b').val(get_words('_prev'));</script>
						<script>$('#next_b_p6b').val(get_words('_next'));</script>
						<script>$('#cancel_b_p6b').val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 6b       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 7 (Manual select Internet connection type)       -->
<!-------------------------------->
		<div class=box id="p6" style="display:none"> 
			<h2><script>show_words('ES_wwa_title_s1')</script></h2>
			<div> 
				<p class="box_msg"><script>show_words('wwa_intro_s3')</script></p>

			</div>
			
			<div>
				<table class=formarea >
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="dhcpc" checked>
					<STRONG><script>show_words('_dhcpconn')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_dhcp')</script></div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="pppoe">
					<STRONG><script>show_words('wwa_wanmode_pppoe')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_pppoe')</script></div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="pptp">
					<STRONG><script>show_words('wwa_wanmode_pptp')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_pptp')</script> </div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="l2tp">
					<STRONG><script>show_words('wwa_wanmode_l2tp')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_l2tp')</script> </div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="static">
					<STRONG><script>show_words('wwa_wanmode_sipa')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_sipa')</script></div></td>
				</tr>
				</table>
				
				<br>
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p6" name="cancel_b_p6" value="" onclick="wizard_cancel();"> 
						<input type="button" class="button_submit" id="wz_prev_b_p6" name="wz_prev_b_p6" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p6" name="next_b_p6" value="" onClick="next_page();"> 						
						<script>$('#wz_prev_b_p6').val(get_words('_prev'));</script>
						<script>$('#next_b_p6').val(get_words('_next'));</script>
						<script>$('#cancel_b_p6').val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
<!-------------------------------->
<!--      End of page 7 (Manual select Internet connection type)       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 7a (DHCP)     -->
<!-------------------------------->
		<div class=box id="p7a" style="display:none"> 
			<h2 align="left"><script>show_words('_dhcpconn')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_msg_set_dhcp')</script></p>
				<div>
					<table align="center" class=formarea>
					<tr>
						<td width="137" align=right class="duple">
							<script>show_words('_macaddr')</script>
							&nbsp;:
						</td>
						<td width="473">
							<input type="text" id="wan_mac" name="wan_mac" maxlength="17" size="20" value=''>
							<script>show_words('_optional')</script>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td> 
							<input name="clone" type="button" class="button_submit" id="clone_1" value="" onClick='clone_mac_action("wan_mac");'>
							<script>$('#clone_1').val(get_words('_clone'));</script>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="itemhelp"> 
							<script>show_words('wwa_note_hostname')</script>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="itemhelp">&nbsp;</td>
					</tr>
					<tr>
						<td class=form_label>&nbsp;
						</td>
						<td>
							<input type="button" class="button_submit" id="cancel_b_p7a" name="cancel_b_p7a" value="" onclick="wizard_cancel();"> 
							<input type="button" class="button_submit" id="wz_prev_b_p7a" name="wz_prev_b_p7a" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p7a" name="next_b_p7a" value="" onClick="next_page();"> 							
							<script>$('#wz_prev_b_p7a').val(get_words('_prev'));</script>
							<script>$('#next_b_p7a').val(get_words('_next'));</script>
							<script>$('#cancel_b_p7a').val(get_words('_cancel'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 7a       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 7b (Static ip)     -->
<!-------------------------------->
		<div class=box id="p7b" style="display:none"> 
			<h2 align="left"><script>show_words('wwa_set_sipa_title')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_set_sipa_msg')</script></p>
				<div>
					<table width="536" align="center" class=formarea>
					<tr>
						<td width="230" align=right class="duple3">
							<strong><script>show_words('_ipaddr')</script></strong>
							&nbsp;:</td>
						<td width="470">
							<input type=text id=ip name=ip size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple3">
							<script>show_words('_subnet')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=mask name=mask size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple3"> 
							<script>show_words('wwa_gw')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=gateway name=gateway size="20" maxlength="15" value=''>
						</td>
					</tr>
					</table>
				</div>
				<h2 align="left"><script>show_words('wwa_dnsset')</script></h2>
				<div>				
					<table width="536" align="center" class=formarea>
					<tr>
						<td width="230" align=right class="duple3">
							<strong><script>show_words('wwa_pdns')</script></strong>
							&nbsp;:</td>
						<td width="470">
							<input type=text id=static_dns1 name=static_dns1 size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple3">
							<script>show_words('wwa_sdns')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=static_dns2 name=static_dns2 size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="itemhelp">&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>  
							<input type="button" class="button_submit" id="cancel_b_p7b" name="cancel_b_p7b" value="" onclick="wizard_cancel();"> 
							<input type="button" class="button_submit" id="wz_prev_b_p7b" name="wz_prev_b_p7b" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p7b" name="next_b_p7b" value="" onClick="next_page();"> 							
							<script>$('#wz_prev_b_p7b').val(get_words('_prev'));</script>
							<script>$('#next_b_p7b').val(get_words('_next'));</script>
							<script>$('#cancel_b_p7b').val(get_words('_cancel'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 7b       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 7c (pppoe)     -->
<!-------------------------------->
		<div class=box id="p7c" style="display:none"> 
			<h2 align="left"><script>show_words('wwa_title_set_pppoe')</script></h2>
			<p class="box_msg"><script>show_words('wwa_msg_set_pppoe')</script></p>
			<div>
				<table class=formarea >
				<tr>
					<td align=right class="duple">
						<script>show_words('_username')</script>
						&nbsp;:</td>
					<td>
						<input type=text id=pppoe_user_name name=pppoe_user_name size="20" maxlength="63" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple">
						<script>show_words('_password')</script>
						&nbsp;:</td>
					<td>
						<input type=text id=pppoe_pwd1 name=pppoe_pwd1 size="20" maxlength="64" value="">
					</td>
				</tr>
				<tr style="display:none">
					<td align=right class="duple">
						<script>show_words('pppoe_plus_dail')</script>
						&nbsp;:</td>
					<td>
						<input type=checkbox id=pppoe_plus_support name=pppoe_plus_support value="1">
					</td>
				</tr>
				<tr>
					<td colspan="2" class="itemhelp">&nbsp;</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p7c" name="cancel_b_p7c" value="" onclick="wizard_cancel();">
						<input type="button" class="button_submit" id="wz_prev_b_p7c" name="wz_prev_b_p7c" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p7c" name="next_b_p7c" value="" onClick="next_page();"> 						
						<script>$('#wz_prev_b_p7c').val(get_words('_prev'));</script>
						<script>$('#next_b_p7c').val(get_words('_next'));</script>
						<script>$('#cancel_b_p7c').val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 7c       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 7d (pptp)     -->
<!-------------------------------->
		<div class=box id="p7d" style="display:none"> 
			<h2 align="left"><script>show_words('wwa_title_set_pptp')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_msg_set_pptp')</script></p>
				<div>
					<table width="525" align="center" class=formarea >
					<tr>
						<td width="220" align=right class="duple">
							<script>show_words('bwn_AM')</script>
							&nbsp;:</td>
						<td width="304">
							<input name="pptp_type" type="radio" value="0" onClick="show_static_ip('pptp')" checked>
							<script>show_words('carriertype_ct_0')</script>
							&nbsp; 
							<input name="pptp_type" type="radio" value="1" onClick="show_static_ip('pptp')">
							<script>show_words('_sdi_staticip')</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_PPTPip')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=pptp_ip name=pptp_ip size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_PPTPsubnet')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=pptp_mask name=pptp_mask size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_PPTPgw')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=pptp_gw name=pptp_gw size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('wwa_pptp_svraddr')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=pptp_server_ip name=pptp_server_ip size="20" maxlength="64" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_username')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=pptpuserid name=pptpuserid size="20" maxlength="63" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_password')</script>
							&nbsp;:</td>
						<td>
							<input type=password id=pptppwd name=pptppwd size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_verifypw')</script>
							&nbsp;:</td>
						<td>
							<input type=password id=pptppwd2 name=pptppwd2 size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					</table>
				</div>

				<h2 align="left"><script>show_words('wwa_dnsset')</script></h2>
				<div>				
					<table width="525" align="center" class=formarea>
					<tr>
						<td width="220" align=right class="duple">
							<script>show_words('wwa_pdns')</script>
							&nbsp;:</td>
						<td width="304">
							<input type=text id=pptp_dns1 name=pptp_dns1 size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('wwa_sdns')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=pptp_dns2 name=pptp_dns2 size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="itemhelp">&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="button" class="button_submit" id="cancel_b_p7d" name="cancel_b_p7d" value="" onclick="wizard_cancel();">
							<input type="button" class="button_submit" id="wz_prev_b_p7d" name="wz_prev_b_p7d" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p7d" name="next_b_p7d" value="" onClick="next_page();"> 							
							<script>$('#wz_prev_b_p7d').val(get_words('_prev'));</script>
							<script>$('#next_b_p7d').val(get_words('_next'));</script>
							<script>$('#cancel_b_p7d').val(get_words('_cancel'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 7d       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 7e (l2tp)     -->
<!-------------------------------->
		<div class=box id="p7e" style="display:none">
			<h2 align="left"><script>show_words('wwa_set_l2tp_title')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_set_l2tp_msg')</script></p>
				<div>
					<table width="536" align="center" class=formarea>
					<tr>
						<td width="240" align=right class="duple">
							<strong><script>show_words('bwn_AM')</script></strong>
							&nbsp;:</td>
						<td width="430">
							<input name="l2tp_type" type="radio" value="0" onClick="show_static_ip('l2tp')" checked>
							<script>show_words('carriertype_ct_0')</script>
							&nbsp;&nbsp; 
							<input name="l2tp_type" type="radio" value="1" onClick="show_static_ip('l2tp')">
							<script>show_words('_sdi_staticip')</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_L2TPip')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=l2tp_ip name=l2tp_ip size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_L2TPsubnet')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=l2tp_mask name=l2tp_mask size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_L2TPgw')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=l2tp_gw name=l2tp_gw size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('wwa_l2tp_svra')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=l2tp_server_ip name=l2tp_server_ip size="20" maxlength="64" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_username')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=l2tpuserid name=l2tpuserid size="20" maxlength="63" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_password')</script>
							&nbsp;:</td>
						<td>
							<input type=password id=l2tppwd name=l2tppwd size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_verifypw')</script>
							&nbsp;:</td>
						<td>
							<input type=password id=l2tppwd2 name=l2tppwd2 size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					</table>
				</div>

				<h2 align="left"><script>show_words('wwa_dnsset')</script></h2>
				<div>
					<table width="536" align="center" class=formarea>
					<tr>
						<td width="240"align=right class="duple">
							<strong><script>show_words('wwa_pdns')</script></strong>
							&nbsp;:</td>
						<td width="430">
							<input type=text id=l2tp_dns1 name=l2tp_dns1 size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('wwa_sdns')</script>
							&nbsp;:</td>
						<td>
							<input type=text id=l2tp_dns2 name=l2tp_dns2 size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="itemhelp">&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="button" class="button_submit" id="cancel_b_p7e" name="cancel_b_p7e" value="" onclick="wizard_cancel();">
							<input type="button" class="button_submit" id="wz_prev_b_p7e" name="wz_prev_b_p7e" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p7e" name="next_b_p7e" value="" onClick="next_page();"> 							
							<script>$('#wz_prev_b_p7e').val(get_words('_prev'));</script>
							<script>$('#next_b_p7e').val(get_words('_next'));</script>
							<script>$('#cancel_b_p7e').val(get_words('_cancel'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 7e       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 8 (Wireless & security)      -->
<!-------------------------------->
		<div class="box" id="p8" style="display:none"> 
			<h2 align="left"> <script>show_words('ES_step_wifi_security')</script></h2>
			<span id="WifiSecurity"></span>
			<table align="center" class=formarea >
			<tr>
				<td></td>
				<td>
					<input type="button" class="button_submit" id="cancel_b_p8" name="cancel_b_p8" value="" onclick="wizard_cancel();"> 
					<input type="button" class="button_submit" id="prev_b_p8" name="prev_b_p8" value="" onclick="prev_page();"> 
					<input type="button" class="button_submit" id="next_b_p8" name="next_b_p8" value="" onclick="next_page();"> 					
					<script>$('#prev_b_p8').val(get_words('_prev'));</script>
					<script>$('#next_b_p8').val(get_words('_next'));</script>
					<script>$('#cancel_b_p8').val(get_words('_cancel'));</script>
				</td>
			</tr>
			</table>
		</div>
<!-------------------------------->
<!--       End of page 8        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 9	    -->
<!-------------------------------->
		<div class=box id="p9" style="display:none">
			<h2 align="left"><script>show_words('ES_title_s5_0')</script></h2>
			<table align="center" class=formarea style="display:"width="94%"> 
				<tr><td>
					<P align="left" class=box_msg><script>show_words('wwl_intro_end')</script></P>
					<br>
					<table align="center" width="80%" height="80" cellspacing="14">
					<div align="left">
					<tr> 
						<td class="duple3">
							<div class="5G_use" style="display:none">
								<script>show_words('wwz_wwl_intro_s2_1_1')</script>&nbsp;
								<script>show_words('GW_WLAN_RADIO_0_NAME')</script>:
							</div>
							<div class="2_4G_use" style="display:none">
								<script>show_words('wwz_wwl_intro_s2_1_1')</script>&nbsp;:
							</div>
						</td>
						<td><span id="p9_ssid"></span></td>
					</tr>
					<tr> 
						<td class="duple3"><script>show_words('wwz_wwl_intro_s2_2_1')</script>&nbsp;:</td>
						<td><span id="p9_key"></span></td>
					</tr>

			<!-- 20120113 silvia add 5g -->
					<tr class="5G_use" style="display:none"> 
						<td class="duple3">
							<script>show_words('wwz_wwl_intro_s2_1_1')</script>&nbsp;
							<script>show_words('GW_WLAN_RADIO_1_NAME')</script>:
						</td>
						<td><span id="p9_ssid_5"></span></td>
					</tr>
					<tr class="5G_use" style="display:none"> 
						<td class="duple3"><script>show_words('wwz_wwl_intro_s2_2_1')</script>&nbsp;:</td>
						<td><span id="p9_key_5"></span></td>
					</tr>
					</div>
					</table>
					</br><br>

					<table align="center" class=formarea >
					<tr>
						<td></td>
						<td>    
							<input type="button" class="button_submit" id="cancel_b_p9" name="cancel_b_p9" value="" onclick="wizard_cancel();"> 
							<input type="button" class="button_submit" id="prev_b_p9" name="prev_b_p9" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p9" name="next_b_p9" value="" onClick="send_request(0)">							
							<script>$('#prev_b_p9').val(get_words('_prev'));</script>
							<script>$('#next_b_p9').val(get_words('_next'));</script>
							<script>$('#cancel_b_p9').val(get_words('_cancel'));</script>
						</td>
					</tr>
					</table>
					<div align="center"></div>
				</td></tr>
		</table>
	</div>
<!-------------------------------->
<!--       End of page 9        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 10      -->
<!-------------------------------->
	<div class=box id="p10" style="display:none">
	<h2 align="left"><span id="p10_title"></span></h2>
	<table border=0 align="center" cellPadding=0 cellSpacing=0 >
	<tr>
		<td ><p>&nbsp;</p>
		<table width="650" border="0" align="center">
		<tr>
			<td height="15">
			<div id='save_and_wait' style='display:'>
				<p class="centered"><script>show_words('save_wait')</script></p>
				<p></p>
				<p class="centered"><script>show_words('_please_wait')</script></p>
				<p></p>
			</div>
			<div align="left" id='chk_wan_bar' style='display:none'>
			<p class="box_msg"><script>show_words('_chk_wanconn_msg_00')</script></p>	
			<div align="center">			
				<div align="left" style="width:500;border:3px solid #000000" >
					<div id="wan_progressbar" style="background-color: #FF6F00;">&nbsp;</div>
				</div>
			</div>
			<p></p>
			<table align="center" class=formarea>
			<tr>
				<td></td>
				<td>
					<input type="button" class="button_submit" id="cancel_b_p10" name="cancel_b_p10" value="" onclick="wizard_cancel(3);"> 
					<input type="button" class="button_submit" id="next_b_p10" name="next_b_p10" value="" disabled>					
					<script>$('#next_b_p10').val(get_words('_next'));</script>
					<script>$('#cancel_b_p10').val(get_words('_skip'));</script>
				</td>
			</tr>
			</table>
			</div>
			<div id='chk_wan' style='display:none'>
				<p class="centered"><script>show_words('mydlink_tx05')</script></p>
				<p></p>
				<p class="centered">
				<div align="center" >
					<font color="#FF0000"><span id='count_sh'><span></font>&nbsp;<span id='count_sh2'><span>
				</div>
			</div>
			</td>
		</tr>
		</table>
		<p>&nbsp;</p>
		</td>
	</tr>
	</table>
	</div>
		<div style="width: 500px;" id="append_net" title=""  cellpadding=0>
		<table width="98%" height="70%" border="0" align="center" bgcolor="#FFFFFF" cellspacing="5" >
			<tr>
				<td align="center" bgcolor="#FFFFFF"><span id="show_msg2"></span></td>
				<script>$('#show_msg2').html(get_words('mydlink_tx03'))</script>
			</tr>
			<p><input type="hidden" name="all_field" id="all_field" value=""></p>
			<tr>
				<td align="center" bgcolor="#FFFFFF">
				&nbsp;&nbsp;<input type="button" id="append_retry" name="append_retry" onClick="wz_back(1)" value="">
					<script>$('#append_retry').val(get_words('_retry'));</script>
				&nbsp;&nbsp;<input type="button" id="append_cancel1" name="append_cancel1" onClick="wz_back(0)" value="">
					<script>$('#append_cancel1').val(get_words('_skip'));</script>
				</td>
			</tr>
			
		</table>
		</div>
<!-------------------------------->
<!--       End of page 10       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 11 (finished)      -->
<!-------------------------------->
		<div class=box id="p11" style="display:none">
			<h2 align="left"><script>show_words('ES_title_s6')</script></h2>
			<div align="left">
				<div>
					<p class="box_msg"><script>show_words('mydlink_tx01')</script></p>
					<p></p>
					<p class="box_msg"><script>show_words('mydlink_tx02')</script></p><br>
					
				</div>
			<div>

			<form name="form1" id="form1" method="post" action="https://api.mydlink.com/signup?lang=en" enctype="application/x-www-form-urlencoded">
				<input type="hidden" id="mac" name="mac">
				<input type="hidden" id="time" name="time">
				<input type="hidden" id="auth" name="auth">
			</form>

				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="b_yes" name="b_yes" value="" onclick="return send_request(2)"> 
						<input type="button" class="button_submit" id="b_no" name="b_no" value="" onClick="return send_request(1)"> 
						<script>$('#b_yes').val(get_words('_yes'));</script>
						<script>$('#b_no').val(get_words('_no'));</script>
					</td>
				</tr>
				</table>
			</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 11       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 12(mydlink)     -->
<!-------------------------------->
		<div class=box id="p12" style="display:none"> 
		<h2 align="left"><script>show_words('ES_title_s6')</script></h2>
		<p class="box_msg">
			<script>show_words('_wz_mydlink_into_1')</script>
			<script>show_words('_wz_mydlink_into_2')</script>
			<br><br>
			<script>show_words('_wz_mydlink_into_3')</script>
		</p>
			<table  align="center" class=formarea>
				<tr height="24">
					<td width="10%"></td>
					<td><script>show_words('mydlink_tx06')</script></td>
				</tr>
				<tr height="24">
					<td></td>
					<td>
						<input type="radio" id="mdl_reg" name="mdl_reg" value="yes">
						<script>show_words('mydlink_tx07')</script>
					</td>
				</tr>
				<tr height="24">
					<td></td>
					<td>
						<input type="radio" id="mdl_reg" name="mdl_reg" value="no" checked>
						<script>show_words('mydlink_tx08')</script>
					</td>
				</tr>
			</table><br>

			<table align="center" class=formarea>
			<tr>
				<td></td>
				<td>
					<input type="button" class="button_submit" id="cancel_b_p12" name="cancel_b_p12" value="" onclick="wizard_cancel(3);"> 
					<input type="button" class="button_submit" id="next_b_p12" name="next_b_p12" value="" onClick="next_page()">					
					<script>$('#next_b_p12').val(get_words('_next'));</script>
					<script>$('#cancel_b_p12').val(get_words('_skip'));</script>
				</td>
			</tr>
			</table>
		</div>
<!-------------------------------->
<!--       End of page 12       -->
<!-------------------------------->
		<div id="p13" style="display:none">
		</div>
<!-------------------------------->
<!--      Start of page 13a       -->
<!-------------------------------->
		<div class=box id="p13a" style="display:none"> 
		<h2 align="left"><script>show_words('ES_title_s6')</script></h2>
			<table class=formarea>
				<tr height="24"><br>
					<td width="15%"></td>
					<td width="40%"><div align="right"><script>show_words('mydlink_tx09')</script>:&nbsp;</div></td>
					<td width="45%">
						<input type="text" id="email_addra" name="email_addra" value="">
					</td>
				</tr>
				<tr height="24"><br>
					<td></td>
					<td><div align="right"><script>show_words('_password')</script>&nbsp;:&nbsp;</div></td>
					<td>
						<input type="password" id="pass" name="pass" value="" maxlength="32">
					</td>
				</tr>
			</table><br>

			<table align="center" class=formarea>
			<tr>
				<td></td>
				<td>
					<input type="button" class="button_submit" id="cancel_b_p13a" name="cancel_b_p13a" value="" onclick="wizard_cancel(3);"> 
					<input type="button" class="button_submit" id="wz_prev_b_p13a" name="wz_prev_b_p13a" value="" onclick="prev_page_mld(p13a);"> 
					<input type="button" class="button_submit" id="next_b_p13a" name="next_b_p13a" value="" onClick="send_request(1);">					
					<script>$('#wz_prev_b_p13a').val(get_words('_prev'));</script>
					<script>$('#next_b_p13a').val(get_words('_login'));</script>
					<script>$('#cancel_b_p13a').val(get_words('_skip'));</script>
				</td>
			</tr>
			</table>
		</div>
<!-------------------------------->
<!--       End of page 13a       -->
<!-------------------------------->
<!-------------------------------->
<!--      Start of page 13b       -->
<!-------------------------------->
		<div class=box id="p13b" style="display:none"> 
		<h2 align="left"><script>show_words('ES_title_s6')</script></h2>
		<center><p class="box_msg"><script>show_words('mydlink_tx10')</script></p></center>
			<table class=formarea>
				<tr height="24"><br>
					<td width="8%"></td>
					<td width="40%"><div align="right"><script>show_words('mydlink_tx09')</script>&nbsp;:&nbsp</div></td>
					<td width="52%">
						<input type="text" id="email_addr" name="email_addr" value="" maxlength="128">
					</td>
				</tr>
				<tr height="24">
					<td></td>
					<td><div align="right"><script>show_words('_password')</script>&nbsp;:&nbsp;</div></td>
					<td>
						<input type="password" id="passwd" name="passwd" value="" maxlength="32">
					</td>
				</tr>
				<tr height="24">
					<td></td>
					<td><div align="right"><script>show_words('chk_pass')</script>&nbsp;:&nbsp;</div></td>
					<td>
						<input type="password" id="pass_chk" name="pass_chk" value="" maxlength="32">
					</td>
				</tr>
				<tr height="24">
					<td></td>
					<td><div align="right"><script>show_words('Fname')</script>&nbsp;:&nbsp;</div></td>
					<td>
						<input type="text" id="fname" name="fname" value="">
					</td>
				</tr>
				<tr height="24">
					<td></td>
					<td><div align="right"><script>show_words('Lname')</script>&nbsp;:&nbsp;</div></td>
					<td>
						<input type="text" id="lname" name="lname" value="">
					</td>
				</tr>
				<tr height="24">
					<td></td>
					<td><div align="right">
						<input type="checkbox" id="mdl_caption" name="mdl_caption" value="1"></div></td>
					<td>
						<a id="language_link" href="" onclick="termsOfUse_page()"; target='_blank'>
						<script>show_words('mydlink_tx12')</script></a>
					</td>
				</tr>
			</table><br>

			<table align="center" class=formarea>
			<tr>
				<td></td>
				<td>
					<input type="button" class="button_submit" id="cancel_b_p13b" name="cancel_b_p13b" value="" onclick="wizard_cancel(3);"> 
					<input type="button" class="button_submit" id="wz_prev_b_p13b" name="wz_prev_b_p13b" value="" onclick="prev_page_mld(p13b);"> 
					<input type="button" class="button_submit" id="next_b_p13b" name="next_b_p13b" value="" onClick="verify_wz_page_p13b();">					
					<script>$('#wz_prev_b_p13b').val(get_words('_prev'));</script>
					<script>$('#next_b_p13b').val(get_words('_signup'));</script>
					<script>$('#cancel_b_p13b').val(get_words('_skip'));</script>
				</td>
			</tr>
			</table>

		</div>
<!-------------------------------->
<!--       End of page 13b       -->
<!-------------------------------->
<!-------------------------------->
<!--      Start of page 14 (mydlink_finsh)       -->
<!-------------------------------->
		<div class=box id="p14" style="display:none"> 
		<h2 align="left"><script>show_words('ES_title_s6')</script></h2>
		<p class="box_msg">
			<script>show_words('mydlink_tx13_1')</script>
			<script>show_words('mydlink_tx13_2')</script>
		</p>
		<br><br>
				<table align="center" class=formarea>
				<tr>
					<td></td>
					<td>
						<input type="button" class="button_submit" id="cancel_b_p14" name="cancel_b_p14" value="" onclick="wizard_cancel(3);"> 
						<input type="button" class="button_submit" id="next_b_p14" name="next_b_p14" value="" onClick="return send_request(3)">						
						<script>$('#next_b_p14').val(get_words('_login'));</script>
						<script>$('#cancel_b_p14').val(get_words('_skip'));</script>
					</td>
				</tr>
				</table>
		</div>
<!-------------------------------->
<!--       End of page 14       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 15 (save wifi)      -->
<!-------------------------------->
		<div class=box id="p15" style="display:none">
		<h2 align="left"><script>show_words('save_settings')</script></h2>
		<table border=0 align="center" cellPadding=0 cellSpacing=0 >
		<tr>
			<td ><p>&nbsp;</p>
			<table width="650" border="0" align="center">
			<tr>
				<td height="15">
				<div>
					<p class="centered"><script>show_words('save_wait')</script></p>
					<p></p>
					<p class="centered"><script>show_words('_please_wait')</script></p>
					<p></p>
				</div>
				</td>
			</tr>
			</table>
			<p>&nbsp;</p>
			</td>
		</tr>
		</table>
		</div>
<!-------------------------------->
<!--       End of page 15       -->
<!-------------------------------->
		</form>
		</td>
	</tr>
	
	</table>
	<p>&nbsp;</p>
	</td>
</tr>
</table>

	<!-- footer -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<table id="footer_container">
		<tr>
			<td width="100%" align="c">&nbsp;<img src="image/wireless_tail.gif"></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</table>
		</td>
	</tr>
	</table>
	<br>
	<div id="copyright"><script>show_words('_copyright');</script></div>
	<!-- end of footer -->
</center>
</body>
<script>
	onPageLoad();
	set_form_default_values("formAll");
	lang_set();
	displayPage("p0");
	show_txtlang(br_lang);

	//change site, avoid ie error
	//$('#tzone')[0].selectedIndex = gTimezoneIdx;
	var tz = TimezoneDetect()/60;

	for (var i=0; i<$('#tzone').get(0).options.length; i++)
	{
		if (i<$('#tzone').get(0).options.length-1) {
			if (parseInt($('#tzone option').eq(i).val()) == tz*16) {
				if(tz==8)//add for timezone=GMT+8 then set to Taipei
					get_by_id("tzone").selectedIndex = 59;
				else
					get_by_id("tzone").selectedIndex = i;
				break;
			}
		} else {
				get_by_id("tzone").selectedIndex = i;
		}
	}
</script>
</html>
