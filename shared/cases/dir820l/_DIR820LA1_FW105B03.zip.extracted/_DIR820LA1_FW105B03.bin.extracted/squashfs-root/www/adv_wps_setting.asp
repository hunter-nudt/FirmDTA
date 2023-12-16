<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="uk.js"></script>
<script type="text/javascript" src="js/xml.js"></script>
<script type="text/javascript" src="js/object.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript" src="js/public_msg.js"></script>
<script type="text/javascript" src="js/pandoraBox.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	document.title = get_words('TEXT000');
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var wband		= dev_info.wireless_band;
	var wps_v		= dev_info.wps_verify;
	var wband_cnt =(wband == "dual")?1:0;

	var mainObj = new ccpObject();
	var param = {
			url: "get_set.ccp",
			arg: ""
	};
	param.arg = "ccp_act=get&num_inst=19";
	param.arg += "&oid_1=IGD_WLANConfiguration_i_WPS_&inst_1=1110";
	param.arg += "&oid_2=IGD_WLANConfiguration_i_&inst_2=1100";
	param.arg += "&oid_3=IGD_WLANConfiguration_i_WEP_&inst_3=1110";
	param.arg += "&oid_4=IGD_WLANConfiguration_i_WPA_&inst_4=1110";
	param.arg += "&oid_5=IGD_WLANConfiguration_i_WPA_PSK_&inst_5=1111";
	param.arg += "&oid_6=IGD_WLANConfiguration_i_WEP_WEPKey_i_&inst_6=1110";
	param.arg += "&oid_7=IGD_WLANConfiguration_i_WPA_&inst_7=1210";
	param.arg += "&oid_8=IGD_WLANConfiguration_i_WPA_&inst_8=1510";
	param.arg += "&oid_9=IGD_WLANConfiguration_i_WPA_&inst_9=1610";
	param.arg += "&oid_10=IGD_WLANConfiguration_i_WPS_&inst_10=1150";
	param.arg += "&oid_11=IGD_WLANConfiguration_i_&inst_11=1200";
	param.arg += "&oid_12=IGD_WLANConfiguration_i_&inst_12=1500";
	param.arg += "&oid_13=IGD_WLANConfiguration_i_&inst_13=1600";
	param.arg += "&oid_14=IGD_WLANConfiguration_i_WEP_&inst_14=1210";
	param.arg += "&oid_15=IGD_WLANConfiguration_i_WEP_&inst_15=1510";
	param.arg += "&oid_16=IGD_WLANConfiguration_i_WEP_&inst_16=1610";
	param.arg += "&oid_17=IGD_LANDevice_i_MACFilter_&inst_17=1110";
	param.arg += "&oid_18=IGD_WLANConfiguration_i_WLANStatus_&inst_18=1110";
	param.arg += "&oid_19=IGD_WLANConfiguration_i_WLANStatus_&inst_19=1510";

	mainObj.get_config_obj(param);

	var submit_button_flag = 0;
	var radius_button_flag = 0;
	var radius_button_flag_1 = 0;

	var current_pin = (mainObj.config_val("wpsCfg_SelfPINNumber_")? mainObj.config_val("wpsCfg_SelfPINNumber_"):"");
	var wlan_enable = (mainObj.config_str_multi("wlanCfg_Enable_")? mainObj.config_str_multi("wlanCfg_Enable_"): "0");
	var wlan_secMode = (mainObj.config_str_multi("wlanCfg_SecurityMode_")? mainObj.config_str_multi("wlanCfg_SecurityMode_"): "0");
	var wlan_wepKeyIdx = (mainObj.config_str_multi("wepInfo_KeyIndex_")? mainObj.config_str_multi("wepInfo_KeyIndex_"): "1");
	var wlan_wepAuth= (mainObj.config_str_multi("wepInfo_AuthenticationMode_")? mainObj.config_str_multi("wepInfo_AuthenticationMode_"): "0");
	var wlan_wpaAuth= (mainObj.config_str_multi("wpaInfo_AuthenticationMode_")? mainObj.config_str_multi("wpaInfo_AuthenticationMode_"): "0");
	var wlan_ssidBst= (mainObj.config_str_multi("wlanCfg_BeaconAdvertisementEnabled_")? mainObj.config_str_multi("wlanCfg_BeaconAdvertisementEnabled_"): "0");

	var wps_enable = (mainObj.config_val("wpsCfg_Enable_")? mainObj.config_val("wpsCfg_Enable_"): "0");
	var wps_state = (mainObj.config_val("wpsCfg_Status_")? mainObj.config_val("wpsCfg_Status_"): "0");	//only use status [0] for chk wps status

	var wps_locked = (mainObj.config_str_multi("wpsCfg_SetupLock_")? mainObj.config_str_multi("wpsCfg_SetupLock_"): "0");
	var encrMode = (mainObj.config_str_multi("wpaInfo_EncryptionMode_")? mainObj.config_str_multi("wpaInfo_EncryptionMode_"): "0");
	var wpaMode = (mainObj.config_str_multi("wpaInfo_WPAMode_")?mainObj.config_str_multi("wpaInfo_WPAMode_"):"0");

	var mac_action = mainObj.config_val("macFilter_Action_");

	var wlan_enable_curr = (mainObj.config_str_multi("igdWlanStatus_WlanEnable_")? mainObj.config_str_multi("igdWlanStatus_WlanEnable_"): "0");

	function onPageLoad(){
		set_checked(wps_enable, $("#wpsEnable")[0]);
		set_checked(wps_state, get_by_name("config"));

		if (wband == "5G" || wband == "dual")
		{
			if ((wps_locked[0] == 1) || (wps_locked[1] == 1))
				set_checked(1, $("#wpsLock")[0]);
			else
				set_checked(0, $("#wpsLock")[0]);
		} else if (wband == "2.4G")
		{
			if (wps_locked[0] == 1)
				set_checked(1, $("#wpsLock")[0]);
			else
				set_checked(0, $("#wpsLock")[0]);
		}

		/*
		**	  Date:		2013-03-11
		**	  Author:	Silvia Chang
		**	  Reason:	Add switch for WPS certification, request from Kevin Chen
		**/
		if(wps_v == 0)
			$('#set_unconfigured').hide();
		else
			$('#set_unconfigured').show();

		show_buttons();
		isenable();
		
		if (wband == "5G" || wband == "dual")
		{
			if(wlan_enable[0] == "0" && wlan_enable[2] == "0")
				DisableEnableForm(form1,true);
			else if(wlan_enable_curr[0] == '0' && wlan_enable_curr[1] == '0')
				DisableEnableForm(form1,true);
		}else if (wband == "2.4G"){
			if(wlan_enable[0] == "0")
				DisableEnableForm(form1,true);
			else if(wlan_enable_curr[0] == '0')
				DisableEnableForm(form1,true);
		}

		var login_who= login_Info;
		if(login_who!= "w"){
			DisableEnableForm(form1,true);	
		}
	}

	function send_request()
	{
		//20120111 silvia add check wps enabled/disabled  20121207 pascal modify to check guestzone 
/*		if (wband == "5G" || wband == "dual")
		{
			if (get_checked_value(get_by_id("wpsEnable")))
			{
				if (((wlan_secMode[1] == 1) || //WEP
					(wlan_secMode[1] == 3) || //WPA_E
					((wlan_secMode[1] == 2 && wpaMode[1] == 2) || //WPA_P and WPA
					(wlan_secMode[1] == 2 && encrMode[1] == 0))) ||//WPA_P and TKIP
					
					((wlan_secMode[3] == 1) || //WEP
					(wlan_secMode[3] == 3) || //WPA_E
					((wlan_secMode[3] == 2 && wpaMode[3] == 2) || //WPA_P and WPA
					(wlan_secMode[3] == 2 && encrMode[3] == 0))))//WPA_P and TKIP
				{
					alert(get_words('_gz_wps_deny'));
					return false;
				}
			}
		}else{
			if (get_checked_value(get_by_id("wpsEnable")))
			{
				if ((wlan_secMode[1] == 1) || //WEP
					(wlan_secMode[1] == 3) || //WPA_E
					((wlan_secMode[1] == 2 && wpaMode[1] == 2) || //WPA_P and WPA
					(wlan_secMode[1] == 2 && encrMode[1] == 0)))//WPA_P and TKIP
				{
					alert(get_words('_gz_wps_deny'));
					return false;
				}
			}
		}
*/
		//if (!is_form_modified("form1") && !confirm(_ask_nochange)) {
		var wpsEnable_value = get_checked_value($("#wpsEnable")[0]);
		var Lock_value = get_checked_value($("#wpsLock")[0]);
		if (!is_wps_modified()) {
			if (!confirm(get_words('_ask_nochange'))) {
				return false;
			}
		}

		if(!(ischeck_wps("auto"))){
				return false;
		}

		var arrry_idx = 0;
		for (var i = 0; i <= wband_cnt; i++)
		{
			if (wlan_enable[arrry_idx] != 0)
			{
				//if(security[1] == "eap" ||security1[1] == "eap" || vap1_security[1] == "eap"  || vap1_security1[1] == "eap" ){				//EAP
				if(((wlan_secMode[arrry_idx] == "2") || (wlan_secMode[arrry_idx] == "3")) && (wlan_wpaAuth[arrry_idx] == "1")){
					alert(get_words('TEXT026'));
					return false;
				}

				//if(security[1] == "share" ||security1[1] == "share" || vap1_security[1] == "share"  || vap1_security1[1] == "share" ){				//EAP
				if((wlan_secMode[arrry_idx] == "1") && (wlan_wepAuth[arrry_idx] == "1")){
					alert(get_words('_wps_albert_1'));
					return false;
				}

				if((wlan_wepKeyIdx[arrry_idx] != "1") && (wlan_secMode[arrry_idx] == "1")){
					alert(get_words('TEXT024'));//Can't choose WEP key 2, 3, 4 when WPS is enable
					return false;
				}
			}
			if (wband == "5G" || wband == "dual")
				arrry_idx +=2;
		}

		<!--save Wi-Fi value-->	
		get_by_id("wps_lock").value = get_checked_value(get_by_id("wpsLock"));
		
		if(submit_button_flag == 0){
			submit_button_flag = 1;

		var setObj = new ccpObject();
		var param = {
			url: 	"get_set.ccp",
			arg: 	"ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_wps_setting.asp"
		};
		
			param.arg += "&wpsCfg_Enable_1.1.1.0="+wpsEnable_value;
			param.arg += "&wpsCfg_SelfPINNumber_1.1.1.0="+$('#wps_pin').val();
			param.arg += "&wpsCfg_SetupLock_1.1.1.0="+get_checked_value(get_by_id("wpsLock"));

			if (wband == "5G" || wband == "dual")
			{
				param.arg += "&wpsCfg_Enable_1.5.1.0="+wpsEnable_value;
				param.arg += "&wpsCfg_SelfPINNumber_1.5.1.0="+$('#wps_pin').val();
				param.arg += "&wpsCfg_SetupLock_1.5.1.0="+get_checked_value(get_by_id("wpsLock"));
			}
			setObj.get_config_obj(param);
			return true;
		}else{
			return false;
		}
		
	}

	function is_wps_modified(){ //check wps change or not, false:not change, true:change
		var wpsEnable_value = get_checked_value($("#wpsEnable")[0]);

		if((wpsEnable_value == wps_enable) && 
		   ($("#show_wps_pin").html() == current_pin))
			return false;
		else
			return true;
	}

	function isenable()
	{	//20120503 silvia add modify act of sec
		//wlan_secMode --> WEP PSK EAP	encrMode--> TKIP AES
		if (wband == "5G" || wband == "dual")
		{
			if ((wlan_secMode[0] != 0 && wlan_enable[0] !=0) || (wlan_secMode[2] != 0 && wlan_enable[2] !=0))
			{
				if (((wlan_secMode[0] == 1 || wlan_secMode[0] == 3) && wlan_enable[0] == 1)
				|| ((wlan_secMode[2] == 1 || wlan_secMode[2] == 3) && wlan_enable[2] == 1))
					get_by_id("wpsEnable").disabled = true;
				else if ((wlan_secMode[0] == 2  && wlan_enable[0] == 1 && (encrMode[0] == 0 || wpaMode[0] == 2))
				|| (wlan_secMode[2] == 2 && wlan_enable[2] == 1 && (encrMode[2] == 0 || wpaMode[2] == 2)))
					get_by_id("wpsEnable").disabled = true;
				else
					get_by_id("wpsEnable").disabled = false;
			}else{
				get_by_id("wpsEnable").disabled = false;
			}
			if ((wlan_ssidBst[0] == 0) || (wlan_ssidBst[2] == 0))
			get_by_id("wpsEnable").disabled = true;
		}else{
			if (wlan_secMode[0] != 0 && wlan_enable[0] != 0)
			{
				if (wlan_secMode[0] == 1 || wlan_secMode[0] == 3)
					get_by_id("wpsEnable").disabled = true;
				else if (wlan_secMode[0] == 2 && (encrMode[0] == 0 || wpaMode[0] == 2))
					get_by_id("wpsEnable").disabled = true;
				else
					get_by_id("wpsEnable").disabled = false;
			}else{
				get_by_id("wpsEnable").disabled = false;
			}
		}
		if (wlan_ssidBst[0] == 0)
			get_by_id("wpsEnable").disabled = true;

		//20140120 Silvester add mac filter spec
		if(mac_action != 0)
			get_by_id("wpsEnable").disabled = true;
	}
	
	// for WPS function		
	function show_buttons(){
		var enable = $("#wpsEnable")[0];
		var isenable = enable.checked;
		if(!isenable){
			$("#show_wps_pin").html(current_pin);
		}else if(current_pin == "00000000" && get_by_id("wpsEnable").checked)
			$("#show_wps_pin").html(current_pin);

		$("#wps_pin").val(current_pin);
		$("#reset_pin").attr('disabled',!isenable);
		$("#generate_pin").attr('disabled',!isenable);
		$("#wps_wizard").attr('disabled',!isenable);
		$("#wpsLock").attr('disabled',!isenable);

		if(wps_state != "1")
			$("#reset_to_unconfigured").attr('disabled', true);

		if($("#wpsLock").is(":checked"))
			lock();
	}
/*	
	//20120709 pascal add when SSID is default then remove the button
	function remove_unconfigured()
	{
		var param = {
			'url': 	'get_set.ccp',
			'arg': 	'&oid_1=IGD_Status_LANStatus_&inst_1=11000' +
					'&oid_2=IGD_WLANConfiguration_i_&inst_2=11100'
		};
		param.arg +='&ccp_act=get&num_inst=2';
		get_config_obj(param);
		
		var lan_mac = config_val('igdLanStatus_MACAddress_').split(":");
		var def_SSID = config_str_multi("wlanCfg_SSID_")[0];
		var chk_SSID = 'dlink-' +lan_mac[4] +lan_mac[5];
		
		if(def_SSID == chk_SSID)
			$('#set_unconfigured').hide();
		else
			$('#set_unconfigured').show();
	}
*/
	function lock(){
		var wpsLock = get_by_id("wpsLock").checked;
		$('#generate_pin').attr('disabled',wpsLock);
		$('#reset_pin').attr('disabled',wpsLock);
	}

	function set_pinvalue(obj_value){
		var setpinObj = new ccpObject();
		var param = {
			url: 	"get_set.ccp",
			arg: 	"ccp_act=set&ccpSubEvent=CCP_SUB_WPSPINRESET&ccpSubEvent2=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_wps_setting.asp"
		};
		/*
			param.arg += "&wpsCfg_SelfPINNumber_1.1.1.0=''";
			if (wband == "5G" || wband == "dual")
				param.arg += "&wpsCfg_SelfPINNumber_1.5.1.0=''";	
		*/	
		setpinObj.get_config_obj(param);
	}

	function compute_pin_checksum(val)
	{
		var accum = 0; 
		var code = parseInt(val)*10;

		accum += 3 * (parseInt(code / 10000000) % 10); 
		accum += 1 * (parseInt(code / 1000000) % 10); 
		accum += 3 * (parseInt(code / 100000) % 10); 
		accum += 1 * (parseInt(code / 10000) % 10);
		accum += 3 * (parseInt(code / 1000) % 10);
		accum += 1 * (parseInt(code / 100) % 10);
		accum += 3 * (parseInt(code / 10) % 10); 
		accum += 1 * (parseInt(code / 1) % 10); 
		var digit = (parseInt(accum) % 10);
		return ((10 - digit) % 10);
	}

	function genPinClicked()
	{
		var num_str="1";
		var rand_no;
		var num;

		while (num_str.length != 7) {
			rand_no = Math.random()*1000000000; 
			num = parseInt(rand_no, 10);
			num = num%10000000;
			num_str = num.toString();
		} 
		num = num*10 + compute_pin_checksum(num);
		num = parseInt(num, 10);  		 
		$("#wps_pin").val(num);
		$("#show_wps_pin").html(num);
	}

	function Unconfigured_button(){	//20120102 silvia modify
		if(!confirm(get_words('wps_reboot_need')))
			return;
			
		var unconfBtnObj = new ccpObject();
		var paramRestore = {
			url: 	"get_set.ccp",
			arg: 	"ccpSubEvent=CCP_SUB_WIRELESS_RESETOOB&nextPage=adv_wps_setting.asp"
		};

		//j --> 2.4G or 5G, i --> second inst k, counts --> oid number
		if (wband == "5G") {
			var i = 3;
		} else {
			var i = 1;
		}

		for (var j =0, k =0; j<= wband_cnt; j++)	//, counts =0
		{
			var n = 0;
			while (n < 2)
			{
				if (i == 3)	// get 5g info
					i= i+2;

				paramRestore.arg +="&oid_" + (k+1) + "=IGD_WLANConfiguration_i_&inst_" + (k+1) + "=1" + i + "00";
				paramRestore.arg +="&oid_" + (k+2) + "=IGD_WLANConfiguration_i_WEP_&inst_" + (k+2) + "=1" + i + "10";
				paramRestore.arg +="&oid_" + (k+3) + "=IGD_WLANConfiguration_i_WPA_&inst_" + (k+3) + "=1" + i + "10";
				paramRestore.arg +="&oid_" + (k+4) + "=IGD_WLANConfiguration_i_WPA_PSK_&inst_" + (k+4) + "=1" + i + "11";
				paramRestore.arg +="&oid_" + (k+5) + "=IGD_WLANConfiguration_i_WPA_EAP_i_&inst_" + (k+5) + "=1" + i + "10";
				paramRestore.arg +="&oid_" + (k+6) + "=IGD_WLANConfiguration_i_WPS_&inst_" + (k+6) + "=1" + i + "10";	
				paramRestore.arg +="&oid_" + (k+7) + "=IGD_WLANConfiguration_i_WEP_WEPKey_i_&inst_" + (k+7) + "=1" + i + "10";

				k+=7;
				n++;
				i++;
			}
		}

		paramRestore.arg +="&ccp_act=restoreObj&num_inst=" + k;
		unconfBtnObj.get_config_obj(paramRestore);

		//20120312 silvia add when click unconfig PinLock use value original
		var unconfBtn2Obj = new ccpObject();
		var paramForm = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WPSPINRESET&ccpSubEvent2=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_wps_setting.asp'
		};

		if (wband == "5G" || wband == "dual")
		{
			if ((wps_locked[0] == 1) || (wps_locked[1] == 1))
			{
				paramForm.arg += "&wpsCfg_SetupLock_1.1.1.0=1";
				paramForm.arg += "&wpsCfg_SetupLock_1.5.1.0=1";
			}
		}else {
			if (wps_locked[0] == 1)
				paramForm.arg += "&wpsCfg_SetupLock_1.1.1.0=1";
		}
		unconfBtn2Obj.get_config_obj(paramForm);
	}

	function ischeck_wps(obj){
		var is_true = false;
		if($("#wpsEnable")[0].checked){
			if(wlan_enable[0] == "0" && wlan_enable[2] == "0"){
				alert(get_words('TEXT028'));
				is_true = true;
			}
		}
		if(is_true){
			if(obj == "wps")
				$("#wpsEnable")[0].checked = false;
			return false;
		}
		return true;
	}

	function toWPSWizard()
	{
		if(wps_enable == '0')
		{
			window.location.href='wps_wifi_setup.asp';	
			//return;
		}
		window.location.href='wps_wifi_setup.asp?from=adv';	
	}

</script>
</head>

<body>
<center>
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<!-- product info -->
		<table id="header_container">
		<tr>
			<td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"><script>document.write(dev_info.model);</script></a></td>
			<td width="60%">&nbsp;</td>
			<td align="right" nowrap><script>show_words('TA3')</script>: <script>document.write(dev_info.hw_ver);</script> &nbsp;</td>
			<td align="right" nowrap><script>show_words('sd_FWV')</script>: <script>document.write(dev_info.fw_ver);</script></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</table>
		<!-- end of product info -->

		<!-- banner -->
		<div id="header_banner"></div>
		<!-- end of banner -->

		<!-- top menu -->
		<div id="menu_top"></div>
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b2');</script>
		<!-- end of top menu -->
		</td>
	</tr>
	</table>
	
	<!-- main content -->
	<table class="topnav_container" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<!-- left menu -->
		<td id="sidenav_container" valign="top">
		<div id="menu_left"></div>
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b12');</script>
		</td>
		<!-- end of left menu -->		
		<form id="form1" name="form1" method="post">
			<input type="hidden" id="wps_default_pin" name="wps_default_pin" value="">
			<input type="hidden" id="wps_generate_pin" name="wps_generate_pin" value="">
			<input type="hidden" id="wlan0_enable" name="wlan0_enable" value="">
			<input type="hidden" id="wps_pin" name="wlan0_short_gi" value="">
			<input type="hidden" id="wps_configured_mode" name="wps_configured_mode" value="">
			<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="maincontent">
				<div id="box_header">
					<h1><script>show_words('LY2')</script> </h1>
					<p><script>show_words('LY3')</script></p>
					<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
					<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'adv_wps_setting.asp');">
					<script>$("#button").val(get_words('_savesettings'));</script>
					<script>$("#button2").val(get_words('_dontsavesettings'));</script>
				</div>

				<div class="box">
					<h2><script>show_words('LW4')</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td class="duple"><script>show_words('_enable')</script> :</td>
						<td width="340">&nbsp; <input name="wpsEnable" type=checkbox id="wpsEnable" value="1" onClick="show_buttons();">
							<input type="hidden" id="wps_enable" name="wps_enable" value=""> 
						</td>
					</tr>
					<tr>
						<td class="duple"><script>show_words('LW6_1')</script> :</td>
						<td>&nbsp; <input name="wpsLock" type="checkbox" id="wpsLock" value="1" onclick="lock();">
							<input type="hidden" id="wps_lock" name="wps_lock" value=""> 
					</tr>
					<tr id="set_unconfigured" style="display:none">
						<td class="duple">&nbsp;</td>
						<td>&nbsp;<input type="button" name="reset_to_unconfigured" id="reset_to_unconfigured" value="" onClick="Unconfigured_button();"></td>
						<script>$("#reset_to_unconfigured").val(get_words('resetUnconfiged'));</script>
					</tr>
					</table>
				</div>

				<div class="box">
					<h2><script>show_words('LY5')</script></h2>
					<table cellpadding="1" cellspacing="1" border="0" width="525">
					<tr>
						<td class="duple"><script>show_words('LW9')</script> :</td>
						<td>&nbsp;&nbsp;<span id="show_wps_pin">
						<script>document.write(current_pin);</script>
						</span></td>
					</tr>
					<tr>
						<td class="duple">&nbsp;</td>
						<td width="340">&nbsp;
						<input type="button" name="generate_pin" id="generate_pin" value="" onclick='genPinClicked();'>
						<input type="button" name="reset_pin" id="reset_pin" value="" onclick='set_pinvalue($("#wps_default_pin").val());'></td>
						<script>$("#generate_pin").val(get_words('LW11'));</script>
						<script>$("#reset_pin").val(get_words('LW10'));</script>
					</tr>
					</table>
				</div>

				<div class="box">
					<h2><script>show_words('LY10')</script></h2>
					<br>
					<table cellpadding="1" cellspacing="1" border="0" width="525">
					<tr>
						<td class="duple">&nbsp;</td>
						<td width="340">&nbsp;<input name="wps_wizard" id="wps_wizard" type="button" class="button_submit" value="" onClick="toWPSWizard();"></td>
						<script>$("#wps_wizard").val(get_words('LW13'));</script>
					</tr>
					</table>
				</div>
			</div>
		</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong>
			<script>show_words('_hints')</script></strong></b>&hellip;</strong>
			<p><script>show_words('LW14')</script></p>
			<p><script>show_words('LW15')</script></p>
			<p><script>
				var str = get_words('LW17');
				var tmp_str = str.substring(str.search("<strong>")+8,str.search("</strong>"));
				document.write(str.replace(tmp_str,$("#wps_wizard").val()));
			</script></p>
			<p><a href="support_adv.asp#Protected_Setup"><script>show_words('_more')</script>&hellip;</a></p>
		</div>
		</td>
		<!-- end of user tips -->
	</tr>
	</table>
	<!-- end of main content -->

	<!-- footer -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<table id="footer_container">
		<tr>
			<td width="100%" align="left">&nbsp;<img src="image/wireless_tail.gif"></td>
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
	set_form_default_values("form1");
</script>
</html>