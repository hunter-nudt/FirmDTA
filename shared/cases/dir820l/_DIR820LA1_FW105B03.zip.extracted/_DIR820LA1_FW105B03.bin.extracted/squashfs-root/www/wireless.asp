<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="js/jquery-ext.js"></script>
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
	var cli_mac 	= dev_info.cli_mac;
	var wband		= dev_info.wireless_band;
	var wband_cnt 	=(wband == "dual")?1:0;
	var ac_mode		= dev_info.ac_mode;
	var domain		= dev_info.domain;
	var ch2_lst		= dev_info.ch2_lst;
	var ch5_lst		= dev_info.ch5_lst;
	var ch5_DFS_lst		= dev_info.ch5_DFS_lst;

	/**
	**    Date:		2013-08-13
	**    Author:	Silvia Chang
	**    Reason:	DFS Manually switch for CE logo test
	**    Note:		0 --> disable DFS channel option, can not be selected
					1 --> enable  DFC channel option, can be selected
	**	 2013-10-30 if DFS_cert enable set select_sort_channel
	**/
	var DFS_Cert	= 0;

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};

	param.arg ="oid_1=IGD_&inst_1=1000";
	param.arg +="&oid_2=IGD_ScheduleRule_i_&inst_2=1000";
	param.arg +="&oid_3=IGD_LANDevice_i_MACFilter_&inst_3=1110";

	//j --> 2.4G or 5G, i --> second inst k, counts --> oid number
	if (wband == "5G") {
		var i = 3;
	} else {
		var i = 1;
	}

	for (var j =0, k =3; j<= wband_cnt; j++)	//, counts =0
	{
		var n = 0;
		while (n < 2)
		{
			if (i == 3)	// get 5g info
				i= i+2;
	
			param.arg +="&oid_"+(k+1)+"=IGD_WLANConfiguration_i_&inst_"+(k+1)+"=1"+i+"00";
			param.arg +="&oid_"+(k+2)+"=IGD_WLANConfiguration_i_WEP_&inst_"+(k+2)+"=1"+i+"10";
			param.arg +="&oid_"+(k+3)+"=IGD_WLANConfiguration_i_WEP_WEPKey_i_&inst_"+(k+3)+"=1"+i+"10";
			param.arg +="&oid_"+(k+4)+"=IGD_WLANConfiguration_i_WPS_&inst_"+(k+4)+"=1"+i+"10";
			param.arg +="&oid_"+(k+5)+"=IGD_WLANConfiguration_i_WPA_EAP_i_&inst_"+(k+5)+"=1"+i+"10";
			param.arg +="&oid_"+(k+6)+"=IGD_WLANConfiguration_i_WPA_&inst_"+(k+6)+"=1"+i+"10";
			param.arg +="&oid_"+(k+7)+"=IGD_WLANConfiguration_i_WPA_PSK_&inst_"+(k+7)+"=1"+i+"11";
			k+=7;
			n++;
			i++;
		}
	}

	param.arg += "&ccp_act=get&num_inst="+k;
	mainObj.get_config_obj(param);

	var array_sch_inst 	= mainObj.config_inst_multi("IGD_ScheduleRule_i_");
	var schCfg = {
		'name':				mainObj.config_str_multi("schRule_RuleName_"),
		'allweek':			mainObj.config_str_multi("schRule_AllWeekSelected_"),
		'allday':			mainObj.config_str_multi("schRule_AllDayChecked_"),
		'weekday':			mainObj.config_str_multi("schRule_SelectedDays_"),
		'start_h':			mainObj.config_str_multi("schRule_StartHour_"),
		'start_m':			mainObj.config_str_multi("schRule_StartMinute_"),
		'end_h':			mainObj.config_str_multi("schRule_EndHour_"),
		'end_m':			mainObj.config_str_multi("schRule_EndMinute_")
	};

	var lanCfg = {
		'enable':			mainObj.config_str_multi("wlanCfg_Enable_"),	//gz_enable
		'schedule':			mainObj.config_str_multi("wlanCfg_ScheduleIndex_"),	//gz_schedule
		'rate':				mainObj.config_str_multi("wlanCfg_TransmitRate_"),
		'ssid':				mainObj.config_str_multi("wlanCfg_SSID_"),
		'autochan':			mainObj.config_str_multi("wlanCfg_AutoChannel_"),
		'channel':			mainObj.config_str_multi("wlanCfg_Channel_"),
		'coexi':			mainObj.config_str_multi("wlanCfg_BSSCoexistenceEnable_"),
		'beaconEnab':		mainObj.config_str_multi("wlanCfg_BeaconAdvertisementEnabled_"),
		'chanwidth':		mainObj.config_str_multi("wlanCfg_ChannelWidth_"),
		'standard':			mainObj.config_str_multi("wlanCfg_Standard_"),
		'standard5G':		mainObj.config_str_multi("wlanCfg_Standard5G_"),
		'sMode':			mainObj.config_str_multi("wlanCfg_SecurityMode_"),	//wep_type_value
		'wdsenable':		mainObj.config_str_multi("wlanCfg_WDSEnable_"),
		'WMM':				mainObj.config_str_multi("wlanCfg_WMMEnable_"),
		'dfs':				mainObj.config_str_multi("wlanCfg_DFSEnable_")
	}

	var EapCfg ={
		'ip':			mainObj.config_str_multi("wpaEap_RadiusServerIP_"),
		'port':			mainObj.config_str_multi("wpaEap_RadiusServerPort_"),
		'psk':			mainObj.config_str_multi("wpaEap_RadiusServerPSK_"),
		'macauth':		mainObj.config_str_multi("wpaEap_MACAuthentication_")
	}

	var wpsCfg = {
		'enable':			mainObj.config_str_multi("wpsCfg_Enable_"),
		'status':			mainObj.config_str_multi("wpsCfg_Status_")
	}

	var wepCfg = {
		'infokey':		mainObj.config_str_multi("wepInfo_KeyIndex_"),
		'infoAuthMode':	mainObj.config_str_multi("wepInfo_AuthenticationMode_"),
		'infoKeyL':		mainObj.config_str_multi("wepInfo_KeyLength_"),
		'key64':		mainObj.config_str_multi("wepKey_KeyHEX64_"),
		'key128':		mainObj.config_str_multi("wepKey_KeyHEX128_")
	}

	var wpaCfg = {
		'infoAuthMode':	mainObj.config_str_multi("wpaInfo_AuthenticationMode_"),
		'infoKeyup':	mainObj.config_str_multi("wpaInfo_KeyUpdateInterval_"),
		'infoTimeout':	mainObj.config_str_multi("wpaInfo_AuthenticationTimeout_"),
		'infoMode':		mainObj.config_str_multi("wpaInfo_WPAMode_"),
		'encrMode':		mainObj.config_str_multi("wpaInfo_EncryptionMode_"),	//c_type
		'pskKey':		mainObj.config_str_multi("wpaPSK_KeyPassphrase_")
	}

	var wpsEnableSt = (wpsCfg.enable[0]? wpsCfg.enable[0]:"0");
	var wifi_txRate = (lanCfg.rate[0]? lanCfg.rate[0]:"0");
	var mac_action = mainObj.config_val("macFilter_Action_");

	var s_mode0,s_mode1;
	var submit_c	= "";
	var is_wps = 1;
	var schedule_cnt = 0;
	var submit_button_flag = 0;
	var radius_button_flag = 0;
	var radius_button_flag_1 = 0;

	if(schCfg.name != null)
		schedule_cnt = schCfg.name.length;

	function onPageLoad()
	{
		if (wband == "2.4G") {
			$('.2G_use').show();
			onPageLoad_2G();
		} else if (wband == "5G") {
			$('.5G_use').show();
			onPageLoad_5G();
		} else {
			$('.2G_use').show();
			$('.5G_use').show();
			onPageLoad_2G();
			onPageLoad_5G();
		}

		var radiusIP = EapCfg.ip;
		var radiusPort = EapCfg.port;
		var radiusPSK = EapCfg.psk;
		var radiusMACAuth = EapCfg.macauth;

		var z =0;
		var n =0;

		for (i=0;i<=wband_cnt;i++){
			$('#wlan'+i+'_eap_reauth_period').val(wpaCfg.infoTimeout[n]?wpaCfg.infoTimeout[n]:"120");
			if(radiusIP && (radiusIP[z]!=null))
				$('#wlan'+i+'_eap_radius_server_0').val(radiusIP[z]+"/");
			else
				$('#wlan'+i+'_eap_radius_server_0').val("0.0.0.0/");
				
			if(radiusPort && (radiusPort[z]!=null))
				get_by_id("wlan"+i+"_eap_radius_server_0").value += radiusPort[z]+"/";
			else
				get_by_id("wlan"+i+"_eap_radius_server_0").value += "1812/";
			
			if(radiusPSK && (radiusPSK[z]!=null))
				get_by_id("wlan"+i+"_eap_radius_server_0").value += radiusPSK[z];

			var temp_r0 = $('#wlan'+i+'_eap_radius_server_0').val();
			var Dr0 = temp_r0.split("/");
			if(Dr0.length > 1){
				$('#radius'+i+'_ip1').val(Dr0[0]);
				$('#radius'+i+'_port1').val(Dr0[1]);
				$('#radius'+i+'_pass1').val(Dr0[2]);
			}

			if(radiusIP && (radiusIP[z+1]!=null))
				$('#wlan'+i+'_eap_radius_server_1').val(radiusIP[z+1]+"/");
			else
				$('#wlan'+i+'_eap_radius_server_1').val("0.0.0.0/");
				
			if(radiusPort && (radiusPort[z+1]!=null))
				get_by_id("wlan"+i+"_eap_radius_server_1").value += radiusPort[z+1]+"/";
			else
				get_by_id("wlan"+i+"_eap_radius_server_1").value += "1812/";
			
			if(radiusPSK && (radiusPSK[z+1]!=null))
				get_by_id("wlan"+i+"_eap_radius_server_1").value += radiusPSK[z+1];

			var temp_r1 = $('#wlan'+i+'_eap_radius_server_1').val();
			var Dr1 = temp_r1.split("/");
			if(Dr1.length > 1){
				$('#radius'+i+'_ip2').val(Dr1[0]);
				$('#radius'+i+'_port2').val(Dr1[1]);
				$('#radius'+i+'_pass2').val(Dr1[2]);
			}
			if(radiusMACAuth[z] == "1")
				$('#radius'+i+'_auth_mac1').attr("checked",true);
			else
				$('#radius'+i+'_auth_mac1').attr("checked",false);

			if(radiusMACAuth[z+1] == "1")
				$('#radius'+i+'_auth_mac2').attr("checked",true);
			else
				$('#radius'+i+'_auth_mac2').attr("checked",false);

			set_selectIndex(wepCfg.infokey[n], $('#wep'+i+'_def_key')[0]);
			var wep_auth_mode = (wepCfg.infoAuthMode[n]?wepCfg.infoAuthMode[n]:"0");	//0->open, 1->psk
			var wep_key_len = (wepCfg.infoKeyL[n]?wepCfg.infoKeyL[n]:"0");	//0->64, 1->128
			var wpa_auth_mode = (wpaCfg.infoAuthMode[n]?wpaCfg.infoAuthMode[n]:"0");
			var s_mode = ((i == 0)?s_mode0:s_mode1);

			if(s_mode == "0")
				$('#wlan'+i+'_security').val("disable");
			else if(s_mode == "1")
			{
				$('#wlan'+i+'_security').val("wep_");
				if(wep_auth_mode == "0")
					get_by_id("wlan"+i+"_security").value += "open_";
				else if(wep_auth_mode == "1")
					get_by_id("wlan"+i+"_security").value += "share_";
				else
					get_by_id("wlan"+i+"_security").value += "both_";
				if(wep_key_len == "0")
					get_by_id("wlan"+i+"_security").value += "64";
				else if(wep_key_len == "1")
					get_by_id("wlan"+i+"_security").value += "128";
			}
			else if(s_mode == "2")	//wpa1
			{
				$('#wlan'+i+'_security').val("wpa_");
				if(wpa_auth_mode == "0")
					get_by_id("wlan"+i+"_security").value += "psk";
				else
					get_by_id("wlan"+i+"_security").value += "eap";
			}
			else if(s_mode == "3")	//wpa2
			{
				$('#wlan'+i+'_security').val("wpa2_");
				if(wpa_auth_mode == "0")
					get_by_id("wlan"+i+"_security").value += "psk";
				else
					get_by_id("wlan"+i+"_security").value += "eap";
			}
			else if(s_mode == "4")	//wpa2auto
			{
				$('#wlan'+i+'_security').val("wpa2auto_");
				if(wpa_auth_mode == "0")
					get_by_id("wlan"+i+"_security").value += "psk";
				else
					get_by_id("wlan"+i+"_security").value += "eap";
			}

			var wlan0_security= $('#wlan0_security').val();
			var security0 = wlan0_security.split("_");
			var wlan1_security= $('#wlan1_security').val();
			var security1 = wlan1_security.split("_");
			var security = ((i == 0)?security0:security1);
			var wlan_security = ((i == 0)?wlan0_security:wlan1_security);
			if(wlan_security == "disable"){				//Disabled
				set_selectIndex(0, $('#wep'+i+'_type')[0]);
			}else if(security[0] == "wep"){					//WEP
				$('#show'+i+'_wep').show();
				set_selectIndex(1, $('#wep'+i+'_type')[0]);
				set_selectIndex(security[1], $('#auth'+i+'_type')[0]);
				if(security[2] == "64"){
					set_selectIndex(5, $('#wep'+i+'_key_len')[0]);
				}else{
					set_selectIndex(13, $('#wep'+i+'_key_len')[0]);
				}
			}else{
				if(security[1] == "psk"){					//PSK
					$('#show'+i+'_wpa_psk').show();
					set_selectIndex(2, $('#wep'+i+'_type')[0]);
				}else if(security[1] == "eap"){				//EAP
					$('#show'+i+'_wpa_eap').show();
					set_selectIndex(3, $('#wep'+i+'_type')[0]);
				}
				//set wpa_mode
				if(security[0] == "wpa2auto"){
					$('#show'+i+'_wpa').show();	
					set_selectIndex(2, $('#wpa'+i+'_mode')[0]);
				}else{
					$('#wpa'+i+'_mode').val(security[0]);
				}
			}

			$('#wpa'+i+'_mode')[0].selectedIndex = wpaCfg.infoMode[n];
			var k = ((i == 0)?0:8);
			for(var j=1; j<=4; j++)
			{
				if(wepCfg.key64)
					$('#wlan'+i+'_wep64_key_'+j).val(wepCfg.key64[k]);
				else
					$('#wlan'+i+'_wep64_key_'+j).val("0000000000");

				if(wepCfg.key128)
					$('#wlan'+i+'_wep128_key_'+j).val(wepCfg.key128[k]);
				else
					$('#wlan'+i+'_wep128_key_'+j).val("00000000000000000000000000");
				k+=1;
			}
			$('#wlan'+i+'_psk_pass_phrase').val(wpaCfg.pskKey[n]?wpaCfg.pskKey[n]:"00000000");
			$('#wlan'+i+'_gkey_rekey_time').val(wpaCfg.infoKeyup[n]?wpaCfg.infoKeyup[n]:"3600");
			$('#c_type_'+i)[0].selectedIndex = wpaCfg.encrMode[n];
			z +=4;
			n +=2;
		}

		if (wband == "2.4G") {
			change_wep_key_fun();
		} else if (wband == "5G") {
			change_wep_key_fun_1();
		} else {
			change_wep_key_fun();
			change_wep_key_fun_1();
		}

		change_mode();
		var login_who= login_Info;
		if(login_who!= "w"){
			DisableEnableForm(form1,true);	
		}else{
		
			if (wband == "2.4G") {
				disable_wireless_0();
				disable_channel_0();
			} else if (wband == "5G") {
				disable_wireless_1();
				disable_channel_1();
			} else {
				disable_wireless_0();
				disable_channel_0();
				disable_wireless_1();
				disable_channel_1();
			}
		}
		
		setValue5GDFSChannelList();

        set_form_default_values("form1");
	}


	function onPageLoad_5G()
	{
		//20121221 pascal add for ac mode
		if(ac_mode==1)
		{
			$('#11a_protection').append('<option value="3">'+get_words('bwl_ht204080')+'</option>');
			$('#dot11_mode_1').append('<option value="11n">'+get_words('bwl_Mode_n')+'</option>');
			$('#dot11_mode_1').append('<option value="11ac">'+get_words('bwl_Mode_ac')+'</option>');
			$('#dot11_mode_1').append('<option value="11na">'+get_words('bwl_Mode_5')+'</option>'); 
			$('#dot11_mode_1').append('<option value="11acn">'+get_words('bwl_Mode_acn')+'</option>');    
			$('#dot11_mode_1').append('<option value="11acna">'+get_words('bwl_Mode_acna')+'</option>');    
			
		}
		else
		{
			$('#dot11_mode_1').append('<option value="11n">'+get_words('bwl_Mode_n')+'</option>');
			$('#dot11_mode_1').append('<option value="11a">'+get_words('bwl_Mode_a')+'</option>');    
			$('#dot11_mode_1').append('<option value="11na">'+get_words('bwl_Mode_5')+'</option>'); 
		}
		
		s_mode1 = (lanCfg.sMode[2]?lanCfg.sMode[2]:"0");	//0->disable, 1->wep, 2->wpa1, 3->wpa2, 4->auto
		set_checked(lanCfg.enable[2], $('#w_enable_1')[0]);
		$('#show_ssid_1').val(lanCfg.ssid[2]);
		set_checked(lanCfg.autochan[2], $('#auto_channel_1')[0]);
		set_checked(lanCfg.beaconEnab[2], get_by_name("wlan1_ssid_broadcast"));
		$('#sel_wlan1_channel').attr("disabled",true);
		
		if(ac_mode==1)
			var dot11_mode_t5 = "11naac";	
		else
			var dot11_mode_t5 = "11na";
			
		switch(lanCfg.standard5G[2]){
		case '0':
			dot11_mode_t5 = "11n";
			break;
		case '1':
			dot11_mode_t5 = "11a";
			break;
		case '2':
			dot11_mode_t5 = "11na";
			break;
		case '3':
			dot11_mode_t5 = "11ac";
			break;
		case '4':
			dot11_mode_t5 = "11acna";
			break;
		case '5':
			dot11_mode_t5 = "11acn";
		}

		set_selectIndex(dot11_mode_t5, $('#dot11_mode_1')[0]);
		set_selectIndex(lanCfg.schedule[2],$('#wlan1_schedule_select')[0]);
		
		/* 
		 * 20121224 moa add when choose not ac mode, hide 80MHz
		 */
		if (ac_mode==1)
		{
			var check80_func = 
			function()
			{
				var dot11_mode_1_selected = $('#dot11_mode_1 option:selected').val();
				if (dot11_mode_1_selected =='11na' || dot11_mode_1_selected =='11n' )
				{
					$('#11a_protection option[value=3]').remove();
				}
				else
				{
					if($('#11a_protection option[value=3]').length==0)
					{
						$('#11a_protection').append('<option value="3">'+get_words('bwl_ht204080')+'</option>');
					}
				}
			};
			check80_func();//on page loading, check 1 time to add 80MHz or not
			$('#dot11_mode_1').change(check80_func);
		}
		show_chan_width_1();
		$('#11a_protection').val(lanCfg.chanwidth[2]);
	}

	function onPageLoad_2G()
	{
		s_mode0 = (lanCfg.sMode[0]?lanCfg.sMode[0]:"0");	//0->disable, 1->wep, 2->wpa1, 3->wpa2, 4->auto
		//set_checked(wpsCfg.enable[0], $('#wpsEnable')[0]);
		set_checked(lanCfg.enable[0], $('#w_enable')[0]);
		$('#show_ssid_0').val(lanCfg.ssid[0]);
		set_checked(lanCfg.autochan[0], $('#auto_channel')[0]);
		set_checked(lanCfg.beaconEnab[0], get_by_name("wlan0_ssid_broadcast"));
		$('#sel_wlan0_channel').attr("disabled",true);

		var dot11_mode_t = "11bgn";	
		switch(lanCfg.standard[0]){
		case '1':
			dot11_mode_t = "11g";
			$('#wlan0_11g_txrate').val(wifi_txRate);
			break;
		case '2':
			dot11_mode_t = "11n";
			$('#wlan0_11n_txrate').val(wifi_txRate);
			break;
		case '3':
			dot11_mode_t = "11bg";
			$('#wlan0_11bg_txrate').val(wifi_txRate);
			break;
		case '4':
			dot11_mode_t = "11gn";
			$('#wlan0_11gn_txrate').val(wifi_txRate);
			break;
		case '5':
			dot11_mode_t = "11bgn";
			$('#wlan0_11bgn_txrate').val(wifi_txRate);
			break;
		}

		set_selectIndex(dot11_mode_t, $('#dot11_mode')[0]);
		set_selectIndex(lanCfg.schedule[0],$('#wlan0_schedule_select')[0]);
		show_chan_width_0();
		$('#11n_protection')[0].selectedIndex = lanCfg.chanwidth[0];
	}

	function change_wep_key_fun(){
		var length = parseInt($('#wep0_key_len').val()) * 2;
		var key_length = $('#wep0_key_len')[0].selectedIndex;
		var key_type = $('#wlan0_wep_display').val();

		var key1 = $("#wlan0_wep" + key_num_array[key_length] + "_key_1").val();
		var key2 = $("#wlan0_wep" + key_num_array[key_length] + "_key_2").val();
		var key3 = $("#wlan0_wep" + key_num_array[key_length] + "_key_3").val();
		var key4 = $("#wlan0_wep" + key_num_array[key_length] + "_key_4").val();
		
		$('#show_resert1').html("<input type=\"password\" id=\"key1\" name=\"key1\" maxlength=" + length + " size=\"31\" value=" + key1 + " >");
		$('#show_resert2').html("<input type=\"password\" id=\"key2\" name=\"key2\" maxlength=" + length + " size=\"31\" value=" + key2 + " >");
		$('#show_resert3').html("<input type=\"password\" id=\"key3\" name=\"key3\" maxlength=" + length + " size=\"31\" value=" + key3 + " >");
		$('#show_resert4').html("<input type=\"password\" id=\"key4\" name=\"key4\" maxlength=" + length + " size=\"31\" value=" + key4 + " >");
	}

    function check_8021x()
	{
		var ip1 = $('#radius0_ip1').val();
		var ip2 = $('#radius0_ip2').val();
		var radius1_msg = replace_msg(all_ip_addr_msg,get_words('RADIUS_SERVER1_IP_DESC', LangMap.msg));
		var radius2_msg = replace_msg(all_ip_addr_msg,get_words('RADIUS_SERVER2_IP_DESC', LangMap.msg));
		var temp_ip1 = new addr_obj(ip1.split("."), radius1_msg, false, false);
		var temp_ip2 = new addr_obj(ip2.split("."), radius2_msg, true, false);
		var temp_radius1 = new raidus_obj(temp_ip1, $('#radius0_port1').val(), $('#radius0_pass1').val());
		var temp_radius2 = new raidus_obj(temp_ip2, $('#radius0_port2').val(), $('#radius0_pass2').val());

		if (!check_radius(temp_radius1)){
			return false;
		}else if (ip2 != "" && ip2 != "0.0.0.0"){
			if (!check_radius(temp_radius2)){
				return false;
			}
		}	
		return true;
	}

    function check_psk_0(){
		var psk_value = $('#wlan0_psk_pass_phrase').val();
		if (psk_value.length < 8){
			alert(get_words('YM116'));
				return false;
		}else if (psk_value.length > 63){
			if(!isHex(psk_value)){
				alert(get_words('GW_WLAN_WPA_PSK_HEX_STRING_INVALID'));
				return false;
			}
        }
        return true;
    }

	function check_psk_br(){
		var psk_value = $('#br_passphrase').val();
		if (psk_value.length < 8){
			alert(get_words('YM116'));
				return false;
		}else if (psk_value.length > 63){
			if(!isHex(psk_value)){
				alert(get_words('GW_WLAN_WPA_PSK_HEX_STRING_INVALID'));
				return false;
			}
        }
        return true;
    }
   
	function show_wpa_wep()
	{
		var wep_type = $('#wep0_type').val();

		$('#show0_wep').hide();
		$('#show0_wpa').hide();
	    $('#show0_wpa_psk').hide();
	    $('#show0_wpa_eap').hide();
			
		if (wep_type == 1){			//WEP
			$('#show0_wep').show();
		}else if(wep_type == 2){	//WPA-Personal
			if (check_wps_psk_eap()){
				$('#show0_wpa').show();
				$('#show0_wpa_psk').show();
			}
		}else if(wep_type == 3){	//WPA-Enterprise
			if(check_wps_psk_eap()){
				$('#show0_wpa').show();	
				$('#show0_wpa_eap').show();
			}
		}
    }

   function show_chan_width_0()
   {
		/*
		**    Date:		2013-02-21
		**    Author:	Silvia Chang
		**    Reason:   when set wireless mode need to change channel width for AC and N.
		**    Note:		0019473: Manual Wireless Setup: TSD Suggest auto configuring HT20/40 instead of HT20 when user set wireless mode to 802.11n only.
		**				onChange for ie, onClick for other browsers and do not use selectedIndex
		**/

		var mode = $('#dot11_mode').val();
		if (mode =='11g' || mode =='11bg')
		{
			$('#show_channel_width').hide();
			$('#11n_protection').val("20");
		} else if (mode =='11n') {
			$('#show_channel_width').show();
			$('#11n_protection').val("auto");
		} else
			$('#show_channel_width').show();

		change_mode();
   }

	function disable_channel_0(){
		if($('#w_enable')[0].checked)
			$('#sel_wlan0_channel').attr('disabled', $('#auto_channel')[0].checked);
	}

	function disable_wireless_0()
	{
		var is_display = "";
		$('#auto_channel').attr('disabled', !$('#w_enable')[0].checked);
		$('#show_ssid_0').attr('disabled', !$('#w_enable')[0].checked);
		$('#dot11_mode').attr('disabled', !$('#w_enable')[0].checked);
		$('#sel_wlan0_channel').attr('disabled', !$('#w_enable')[0].checked);
		$('#11n_protection').attr('disabled', !$('#w_enable')[0].checked);
		get_by_name("wlan0_ssid_broadcast")[0].disabled = !$('#w_enable')[0].checked;
		get_by_name("wlan0_ssid_broadcast")[1].disabled = !$('#w_enable')[0].checked;
		$('#add_new_schedule').attr('disabled', !$('#w_enable')[0].checked);
		$('#wlan0_schedule_select').attr('disabled', !$('#w_enable')[0].checked);
		$('#wlan0_11bgn_txrate').attr('disabled', !$('#w_enable')[0].checked);
		$('#wlan0_11g_txrate').attr('disabled', !$('#w_enable')[0].checked);
		$('#wlan0_11n_txrate').attr('disabled', !$('#w_enable')[0].checked);
		$('#wlan0_11bg_txrate').attr('disabled', !$('#w_enable')[0].checked);
		$('#wlan0_11gn_txrate').attr('disabled', !$('#w_enable')[0].checked);
		disable_channel_0();
		if(!$('#w_enable')[0].checked){
			$('#wpsEnable').attr('checked', false);
			show_buttons();
			$('#show_security').hide();
			$('#show0_wep').hide();
			$('#show0_wpa').hide();
			$('#show0_wpa_psk').hide();
			$('#show0_wpa_eap').hide();
		}else{
			$('#show_security').show();
			show_wpa_wep();
		}
	}

	function show_radius()
	{
		$('#radius2').hide();
		$('#none_radius2').hide();
		$('#show_radius2').hide();
		if(radius_button_flag){
			$('#radius2').show();
			radius_button_flag = 0;
		}else{
			$('#none_radius2').show();
			$('#show_radius2').show();
			radius_button_flag = 1;
		}
	}

	function send_key_value(key_length)
	{
		var key_type = $('#wlan0_wep_display').val();
		for(var i = 1; i < 5; i++){
			$("#wlan0_wep" + key_length + "_key_" + i).val($("#key" + i).val());
		}
/*		$("#wlan0_wep" + key_length + "_key_1").val($("#key1").val());
		$('#asp_temp_37').val($("#wlan0_wep"+ key_length +"_key_1").val());
		$('#asp_temp_38').val($("#wlan0_wep"+ key_length +"_key_2").val());
		$('#asp_temp_39').val($("#wlan0_wep"+ key_length +"_key_3").val());
		$('#asp_temp_40').val($("#wlan0_wep"+ key_length +"_key_4").val());
*/	}

	function send_cipher_value(){
		if($('#c_type_0')[0].selectedIndex == 0)
			$('#wlan0_psk_cipher_type').val("tkip");
		else if($('#c_type_0')[0].selectedIndex == 1)
			$('#wlan0_psk_cipher_type').val("aes");
		else
			$('#wlan0_psk_cipher_type').val("both");
	}

	function get_schedule_array_index_by_value(val)
	{
		for(var i=0; i < schedule_cnt; i++)
		{
			var inst = array_sch_inst[i];
			if(inst[1] == val)
				return i;
		}
		
		return -1;
	}

    /*
     * Reason: Check host and guest schedule time.
     * Modified: Yufa Huang
     * Date: 2010.10.05
     */
    function check_schedule(i)
    {
		//20120228 silvia modify add chk 5g sch
		var guest_sched_name = (i==0)?lanCfg.schedule[1]:lanCfg.schedule[3];
		var host_sched_name = (i==0)?$("#wlan0_schedule_select").val():$("#wlan1_schedule_select").val();
		var gz_enable = (i==0)?lanCfg.enable[1]:lanCfg.enable[3];
		var lan_enable = (i==0)?$("#wlan0_enable").val():$("#wlan1_enable").val();

        var host_sched;
        var host_start_time = 0;
        var host_start_hour =0;
        var host_start_min = 0;
        var host_end_time = 0;
        var host_end_hour = 0;
        var host_end_min = 0;
        var host_weekdays = 0;
        var guest_sched;
        var guest_start_time = 0;
        var guest_start_hour =0;
        var guest_start_min = 0;
        var guest_end_time = 0;
        var guest_end_hour =0;
        var guest_end_min = 0;
        var guest_weekdays = 0;
        var tmp_sched;

		if ((gz_enable == "0") || (lan_enable == "0"))
            return 0;

		if ((host_sched_name == "255") ||(guest_sched_name == "254")) {
			return 0;
		}

		var host_idx = get_schedule_array_index_by_value(host_sched_name);
		var guest_idx = get_schedule_array_index_by_value(guest_sched_name);

		//config host schedule
		if(host_sched_name == "254")
			host_weekdays = 0;//0000000;
		else if((host_sched_name == "255") || (schCfg.allweek[host_idx] == "1"))
			host_weekdays = 127;//1111111;
		else
			host_weekdays = parseInt(schCfg.weekday[host_idx],2);

		if(host_sched_name == "254"){
			host_start_hour = 0;
			host_start_min = 0;
			host_end_hour = 0;
			host_end_min = 0;
		}else if((host_sched_name == "255") || (schCfg.allday[host_idx] == "1")){
			host_start_hour = 0;
			host_start_min = 0;
			host_end_hour = 23;
			host_end_min = 59;
		}else{
			host_start_hour = parseInt(schCfg.start_h[host_idx]);
			host_start_min = parseInt(schCfg.start_m[host_idx]);
			host_end_hour = parseInt(schCfg.end_h[host_idx]);
			host_end_min = parseInt(schCfg.end_m[host_idx]);
		}

		//config guest schedule
		if(guest_sched_name == "254")
			guest_weekdays = 0;//0000000;
		else if((guest_sched_name == "255") || (schCfg.allweek[guest_idx] == "1"))
			guest_weekdays = 127;//1111111;
		else
			guest_weekdays = parseInt(schCfg.weekday[guest_idx],2);

		if(guest_sched_name == "254"){
			guest_start_hour = 0;
			guest_start_min = 0;
			guest_end_hour = 0;
			guest_end_min = 0;
		}else if((guest_sched_name == "255") || (schCfg.allday[guest_idx] == "1")){
			guest_start_hour = 0;
			guest_start_min = 0;
			guest_end_hour = 23;
			guest_end_min = 59;
		}else{
			guest_start_hour = parseInt(schCfg.start_h[guest_idx]);
			guest_start_min = parseInt(schCfg.start_m[guest_idx]);
			guest_end_hour = parseInt(schCfg.end_h[guest_idx]);
			guest_end_min = parseInt(schCfg.end_m[guest_idx]);
		}

		if(host_start_hour > guest_start_hour)
			return -1;
		else if((host_start_hour == guest_start_hour) && (host_start_min > guest_start_min))
			return -1;

		if(host_end_hour < guest_end_hour)
			return -1;
		else if((host_end_hour == guest_end_hour) && (host_end_min < guest_end_min))
			return -1;

        /* check schdule days */
        for (var i=0; i < 7; i++) {
            if (((host_weekdays & 1) == 0) && ((guest_weekdays & 1) == 1)) {
                return -1;
            }
            host_weekdays  = host_weekdays >> 1;
            guest_weekdays = guest_weekdays >> 1;
        }
        return 0;
    }

	function send_request()
	{
		//is_wps = wpsCfg.enable[0];

		for (var i = 0;i<=wband_cnt;i++)
		{
			var keys = ((i==0)?$("#key1").val():$("#key5").val());
			if ($('#wep'+i+'_key_len')[0].selectedIndex == 0)
				$('#wlan'+i+'_wep64_key_1').val(keys);
			else
				$('#wlan'+i+'_wep128_key_1').val(keys);
		}

		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange'))) {
			return false;
		}

		var wlan_ssid = $('#show_ssid_0').val();
		var wep_type_value_0 = $('#wep0_type').val();
		var key_length =$('#wep0_key_len')[0].selectedIndex;
		var rekey_msg = replace_msg(check_num_msg, get_words('bws_GKUI'), 30, 65535);
		var temp_rekey = new varible_obj($('#wlan0_gkey_rekey_time').val(), rekey_msg, 30, 65535, false);
		var dot11_mode_value = $('#dot11_mode').val();
		var c_type_value = $('#c_type_0').val();
		var ssid_vs= get_checked_value(get_by_name("wlan0_ssid_broadcast"));
		var wlan_enable_0 = get_checked_value($('#w_enable')[0]);

		//save wireless network setting
		$('#wlan0_enable').val(get_checked_value($('#w_enable')[0]));
		$('#wlan0_auto_channel_enable').val(get_checked_value($('#auto_channel')));
		$('#wlan0_channel').val($('#sel_wlan0_channel').val());
		$('#wlan0_dot11_mode').val($('#dot11_mode').val());
		$('#wlan0_11n_protection').val($('#11n_protection').val());
		$('#wlan0_wep_default_key').val($('#wep0_def_key').val());
		var wpa_mode0 = $('#wpa0_mode').val();

		/***	2.4G site		***/
		if ((wband == "2.4G" || wband == "dual") && wlan_enable_0 ==1)
		{

			if(!(check_ssid_0("show_ssid_0")))
					return false;
			if(!check_ascii(wlan_ssid)){
				alert(get_words("ssid_ascii_range"));
				return false;
			}
			if(wlan_ssid.substring(0,1).indexOf(" ") == 0 || wlan_ssid.substring(wlan_ssid.length-1,wlan_ssid.length).indexOf(" ") == 0)
			{
				alert(get_words('_wifi_ssid'));
				return false;
			}
			/*	$("#show_ssid_0").val().substring(0,1).indexOf(" ")
				$("#show_ssid_0").val().substring($("#show_ssid_0").val().length-1,$("#show_ssid_0").val().length).indexOf(" ")
			*/
			if(!(ischeck_wps("auto")))
					return false;

			if(wep_type_value_0 == 1){		//WEP
				if (dot11_mode_value == "11n"){
					alert(get_words('MSG044'));
					return false;
				}else{
					if(!check_key_0())
						return false;
				}
				is_wps = 0;
			}else if(wep_type_value_0 == 2){	//PSK
				if ((dot11_mode_value == "11n") && (c_type_value == "tkip")){
					alert(get_words('MSG045'));
					return false;
				}else{
					if (!check_varible(temp_rekey))
						return false;
					if(!check_psk_0())
						return false;
				}
				if (c_type_value == "tkip" || $('#wpa0_mode')[0].selectedIndex == 2)
					is_wps = 0;
			}else if(wep_type_value_0 == 3){	//EAP
				if ((dot11_mode_value == "11n") && (c_type_value == "tkip")){
					alert(get_words('MSG045'));
					return false;
				}
				if (!check_varible(temp_rekey))
					return false;
				if(!check_8021x())
					return false;
				is_wps = 0;
			}
		}

		/***	 Set WPS turn on/off 	***/
		if ((wband == "2.4G" || wband == "dual") && wlan_enable_0 == 1)
		{
			if (wep_type_value_0 == 0)
				alert(get_words('msg_non_sec'));
			if (wpsCfg.enable[0] == 1)
			{
				if (ssid_vs == 0)
				{
					if (confirm(get_words("msg_wps_sec_03")) == false)
						return false;
					else
						is_wps = 0;
				}
				else if (is_wps == 0 && wep_type_value_0 != 3)
				{
					if (wep_type_value_0 == 1)
					{
						if (confirm(get_words("msg_wps_sec_01")) == false)
							return false;
					}

					if (c_type_value == "tkip" &&  wep_type_value_0 == 2)
					{
						if (confirm(get_words("msg_wps_sec_02")) == false)
							return false;
					}

					if ($('#wpa0_mode')[0].selectedIndex == 2)
					{
						if (confirm(get_words("msg_wps_sec_04")) == false)
							return false;
					}
				}
				else if( wep_type_value_0 == 3)
				{
					if (confirm(get_words("msg_wps_sec_05")) == false)
							return false;
				}
			}
		}

		/***	5G site		***/
		var wlan_ssid_1 = $('#show_ssid_1').val();
		var wep_type_value_1 = $('#wep1_type').val();
		var key_length_1 =$('#wep1_key_len')[0].selectedIndex;
		var temp_rekey_1 = new varible_obj($('#wlan1_gkey_rekey_time').val(), rekey_msg, 30, 65535, false);
		var dot11_mode_value_1 = $('#dot11_mode_1').val();
		var c_type_value_1 = $('#c_type_1').val();
		var ssid_vs1= get_checked_value(get_by_name("wlan1_ssid_broadcast"));
		var wlan_enable_1 = get_checked_value($('#w_enable_1')[0]);

		//save wireless network setting
		$('#wlan1_enable').val(get_checked_value($('#w_enable_1')[0]));
		$('#wlan1_auto_channel_enable').val(get_checked_value($('#auto_channel_1')));
		$('#wlan1_channel').val($('#sel_wlan1_channel').val());
		$('#wlan1_dot11_mode').val($('#dot11_mode_1').val());
		$('#wlan1_11n_protection').val($('#11a_protection').val());
		$('#wlan1_wep_default_key').val($('#wep1_def_key').val());
		var wpa_mode1 = $('#wpa1_mode').val();

		if ((wband == "5G" || wband == "dual") && wlan_enable_1 ==1)
		{
			if(!(check_ssid_0("show_ssid_1")))
					return false;
			if(!check_ascii(wlan_ssid_1)){
				alert(get_words("ssid_ascii_range"));
				return false;
			}
			if(wlan_ssid_1.substring(0,1).indexOf(" ") == 0 || wlan_ssid_1.substring(wlan_ssid_1.length-1,wlan_ssid_1.length).indexOf(" ") == 0)
			{
				alert(get_words('_wifi_ssid'));
				return false;
			}
			if(wep_type_value_1 == 1){
				if (dot11_mode_value_1 == "11n"){
					alert(get_words('MSG044'));
					return false;
				}else{
					if(!check_key_1())
						return false;
				}
				is_wps = 0;
			}else if(wep_type_value_1 == 2){
				if ((dot11_mode_value_1 == "11n") && (c_type_value_1 == "tkip")){
					alert(get_words('MSG045'));
					return false;
				}else{
					if (!check_varible(temp_rekey_1))
						return false;
					if(!check_psk_1())
						return false;
				}
				if (c_type_value_1 == "tkip" || $('#wpa1_mode')[0].selectedIndex == 2)
					is_wps = 0;
			}else if(wep_type_value_1 == 3){
				if ((dot11_mode_value_1 == "11n") && (c_type_value_1 == "tkip")){
					alert(get_words('MSG045'));
					return false;
				}
				if (!check_varible(temp_rekey_1)){
					return false;
				}
				if(!check_8021x_1())
					return false;
				is_wps = 0;
			}
		}



		if ((wband == "5G" || wband == "dual") && wlan_enable_1 == 1)
		{
			if (wep_type_value_1 == 0)
				alert(get_words('msg_non_sec'));
	
			//20120426 silvia modify to follow WPS2.0 waring msg
			if (wpsCfg.enable[2] == 1)
			{
				if (ssid_vs1 == 0)
				{
					if (confirm(get_words("msg_wps_sec_03")) == false)
						return false;
					else
						is_wps = 0;
				}
				else if (is_wps == 0 && wep_type_value_1 != 3)
				{
					if (wep_type_value_1 == 1)
					{
						if (confirm(get_words("msg_wps_sec_01")) == false)
							return false;
					}

					if (c_type_value_1 == "tkip" && wep_type_value_1 == 2)
					{
						if (confirm(get_words("msg_wps_sec_02")) == false)
							return false;
					}

					if ($('#wpa1_mode')[0].selectedIndex == 2)
					{
						if (confirm(get_words("msg_wps_sec_04")) == false)
							return false;
					}
				}
				else if (wep_type_value_1 == 3)
				{
					if (confirm(get_words("msg_wps_sec_05")) == false)
							return false;
				}
			}
		}

		for (i=0;i<=wband_cnt;i++)
		{
			var Wlan_Enable = (i==0)?wlan_enable_0:wlan_enable_1;
			if (Wlan_Enable == 1)
			{
				var wep_type_value = ((i==0)?wep_type_value_0:wep_type_value_1);
				var wpa_mode = ((i==0)?wpa_mode0:wpa_mode1);
				//save security
				if(wep_type_value == 1){			//WEP
					//save wep key
					if (i==0){
						$('#wlan0_security').val($("#wep_"+ $('#auth0_type').val() +"_"+ key_num_array[key_length]));
						//$("#wlan0_wep" + key_length + "_key_1").val($("#key1").val());
						send_key_value(key_num_array[key_length]);
					}else{
						$('#wlan1_security').val($("#wep_"+ $('#auth1_type').val() +"_"+ key_num_array[key_length_1]));
						//$("#wlan1_wep" + key_length_1 + "_key_1").val($("#key5").val());
						send_key_value_1(key_num_array[key_length_1]);
					}
					Format_WEP(i);
				}else if(wep_type_value == 2){		//PSK
					if(wpa_mode == "auto"){
						$('#wlan'+i+'_security').val("wpa2auto_psk");
					}else{
						$('#wlan'+i+'_security').val(wpa_mode + "_psk");
					}
					if (i == 0){
						send_cipher_value();
						//save psk value
						$('#asp_temp_37').val($('#wlan0_psk_pass_phrase').val());
						Format_WPA(i);
					}else{
						send_cipher_value_1();
						$('#asp_temp_53').val($('#wlan1_psk_pass_phrase').val());
						Format_WPA(i);
					}
				}else if(wep_type_value == 3){		//EAP
					if(wpa_mode == "auto"){
						$('#wlan'+i+'_security').val("wpa2auto_eap");
					}else{
						$('#wlan'+i+'_security').val(wpa_mode + "_eap");
					}

					//save radius server
					var r_ip_0 = $('#radius'+i+'_ip1').val();
					var r_port_0 = $('#radius'+i+'_port1').val();
					var r_pass_0 = $('#radius'+i+'_pass1').val();
					var dat0 =r_ip_0 +"/"+ r_port_0 +"/"+ r_pass_0;
					$('#wlan'+i+'_eap_radius_server_0').val(dat0);

					if (i == 0){
						send_cipher_value();
						if(radius_button_flag){
							var r_ip_1 = $('#radius0_ip2').val();
							var r_port_1 = $('#radius0_port2').val();
							var r_pass_1 = $('#radius0_pass2').val();
							var dat1 =r_ip_1 +"/"+ r_port_1 +"/"+ r_pass_1;
							$('#wlan0_eap_radius_server_1').val(dat1);
						}
						Format_WPA(i);
					}else{
						send_cipher_value_1();
						if(radius_button_flag_1){
							var r_ip_1 = $('#radius1_ip2').val();
							var r_port_1 = $('#radius1_port2').val();
							var r_pass_1 = $('#radius1_pass2').val();
							var dat1 =r_ip_1 +"/"+ r_port_1 +"/"+ r_pass_1;
							$('#wlan1_eap_radius_server_1').val(dat1);
						}
						Format_WPA(i);
					}

					if(($('#radius'+i+'_auth_mac1')[0].checked == false) && ($('#radius'+i+'_auth_mac2')[0].checked == false))
						$('#wlan'+i+'_eap_mac_auth').val(0);
					else if(($('#radius'+i+'_auth_mac1')[0].checked == true) && ($('#radius'+i+'_auth_mac2')[0].checked == false))
						$('#wlan'+i+'_eap_mac_auth').val(1);
					else if(($('#radius'+i+'_auth_mac1')[0].checked == false) && ($('#radius'+i+'_auth_mac2')[0].checked == true))
						$('#wlan'+i+'_eap_mac_auth').val(2);
					else
						$('#wlan'+i+'_eap_mac_auth').val(3);
				}else{								//DISABLED
					$('#wlan'+i+'_security').val("disable");
				}

				if (check_schedule(i) == -1) {
					alert(get_words('MSG049'));
					return false;
				}
			}
		}

		//save Wi-Fi value
		if($('#wps_enable').val() != get_checked_value($('#wpsEnable')[0])){
			$('#wps_enable').val(get_checked_value($('#wpsEnable')[0]));
			$('#reboot_type').val("wlanapp");
		}
		//save wps_configured_mode
		//when just chainge wps pin value don't modify the configured mode.

		if (wband == "dual")
		{
			if((lanCfg.enable[0] == "1" && $('#wlan0_enable').val() == "0" && lanCfg.enable[1] == "1") ||
				(lanCfg.enable[2] == "1" && $('#wlan1_enable').val() == "0" && lanCfg.enable[3] == "1"))
			{
				if(!confirm(get_words('MSG050')))
					return false;
			}
		} else if (wband == "5G")
		{
			if(lanCfg.enable[2] == "1" && $('#wlan1_enable').val() == "0" && lanCfg.enable[3] == "1")
			{
				if(!confirm(get_words('MSG050')))
					return false;
			}
		}else if (wband == "2.4G")
		{
			if(lanCfg.enable[0] == "1" && $('#wlan0_enable').val() == "0" && lanCfg.enable[1] == "1")
			{
				if(!confirm(get_words('MSG050')))
					return false;
			}
		}

		if(mac_action != 0){
			is_wps=0;
		}

		if(submit_button_flag == 0){
			submit_button_flag = 1;

			if (wband == "2.4G" || wband == "dual")
				$('#wlan0_ssid').val($('#show_ssid_0').val());
			if (wband == "5G" || wband == "dual")
				$('#wlan1_ssid').val($('#show_ssid_1').val());
			Format_basic();

			if(Format_BdgSetting() == false)
				return;

			submit_All();
			return true;
		}else{
			return false;
		}
	}

	function set_channel()
	{
		if (ch2_lst == "UNKNOWN")
			alert(get_words('HWerr'));

		var current_channel =lanCfg.channel[0];
		var ch = ch2_lst.split(", ");
		var obj = $('#sel_wlan0_channel')[0];
		var count = 0;
		for (var i = 0; i < ch.length; i++)
		{
			var ooption = document.createElement("option");
			var g = parseInt(ch[i], 10)*5+2407+'';
			ooption.text = (ch[i]=='0'?get_words("KR50"):''.concat(g.substr(0,1), '.', g.substr(1,3), ' GHz - CH ', ch[i]));
			ooption.value = ch[i];
			obj.options[count++] = ooption;
			if (ch[i] == current_channel)
				ooption.selected = true;
		}
	}

	//2011.11.29 5G Silvia,brian modify
	//2013.07.02 Silvia modify, move channel to misc.c
	function set_channel_1()
	{
		if (ch5_lst == "UNKNOWN")
		{
			alert(get_words('HWerr'));//keep web show currect.
			ch5_lst = "36,40,44,48";
		}

		var current_channel =lanCfg.channel[2];
		var ch = ch5_lst.split(",");
		var obj = $('#sel_wlan1_channel')[0];
		var count = 0;
		for (var i = 0; i < ch.length; i++){
			var ooption = document.createElement("option");
			var g = parseInt(ch[i], 10)*5+5000+'';
			ooption.text = (ch[i]=='0'?get_words("KR50"):''.concat(g.substr(0,1), '.', g.substr(1,3), ' GHz - CH ', ch[i]));
			ooption.value = ch[i];
			obj.options[count++] = ooption;
			if (ch[i] == current_channel)
				ooption.selected = true;
		}
	}

	function show_wpa_wep_1()
	{	
		var wep_type = $('#wep1_type').val();
		 $('#show1_wep').hide();
		 $('#show1_wpa').hide();
		 $('#show1_wpa_psk').hide();
		 $('#show1_wpa_eap').hide();
		if (wep_type == 1){
			 $('#show1_wep').show();
		}else if(wep_type == 2){
			check_wps_psk_eap_1();
			 $('#show1_wpa').show();
			 $('#show1_wpa_psk').show();
		}else if(wep_type == 3){
			if(check_wps_psk_eap_1()){
				 $('#show1_wpa').show();
				 $('#show1_wpa_eap').show();
			}
		}
	}

	function check_wps_psk_eap_1()
	{
		if($('#wps_enable').val() =="1"){
			if(($('#wep1_type').val() == "1") && ($('#wep1_def_key').val() != "1")){
				alert(get_words('TEXT024'));
				return false;
			}
		}
		return true;
	}

	function change_wep_key_fun_1()
	{
		var length_1 = parseInt($('#wep1_key_len').val()) * 2;
		var key_length_1 = $('#wep1_key_len')[0].selectedIndex;
		var key_type_1 = $('#wlan1_wep_display').val();
		var key5 = $('#wlan1_wep' + key_num_array[key_length_1] + '_key_1').val();
		var key6 = $('#wlan1_wep' + key_num_array[key_length_1] + '_key_2').val();
		var key7 = $('#wlan1_wep' + key_num_array[key_length_1] + '_key_3').val();
		var key8 = $('#wlan1_wep' + key_num_array[key_length_1] + '_key_4').val();
		$('#show_resert5').html("<input type=\"password\" id=\"key5\" name=\"key5\" maxlength=" + length_1 + " size=\"31\" value=" + key5 + " >");
		$('#show_resert6').html("<input type=\"hidden\" id=\"key6\" name=\"key6\" maxlength=" + length_1 + " size=\"31\" value=" + key6 + " >");
		$('#show_resert7').html("<input type=\"hidden\" id=\"key7\" name=\"key7\" maxlength=" + length_1 + " size=\"31\" value=" + key7 + " >");
		$('#show_resert8').html("<input type=\"hidden\" id=\"key8\" name=\"key8\" maxlength=" + length_1 + " size=\"31\" value=" + key8 + " >");
	}

	function disable_wireless_1()
	{
		var is_display = "";
		$('#auto_channel_1').attr('disabled',!$('#w_enable_1')[0].checked);
		$('#show_ssid_1').attr('disabled',!$('#w_enable_1')[0].checked);
		$('#dot11_mode_1').attr('disabled',!$('#w_enable_1')[0].checked);
		$('#sel_wlan1_channel').attr('disabled',!$('#w_enable_1')[0].checked);
		$('#11a_protection').attr('disabled',!$('#w_enable_1')[0].checked);
		get_by_name("wlan1_ssid_broadcast")[0].disabled = !$('#w_enable_1')[0].checked;
		get_by_name("wlan1_ssid_broadcast")[1].disabled = !$('#w_enable_1')[0].checked;
		$('#add_new_schedule2').attr('disabled',!$('#w_enable_1')[0].checked);
		$('#wlan1_schedule_select').attr('disabled',!$('#w_enable_1')[0].checked);
		disable_channel_1();
		if(!$('#w_enable_1')[0].checked){
			$('#show_security_1').hide();
			$('#show1_wep').hide();
			$('#show1_wpa').hide();
			$('#show1_wpa_psk').hide();
			$('#show1_wpa_eap').hide();
		}else{
			$('#show_security_1').show();
			show_wpa_wep_1();
		}
	}

	/**
	**    Date:		2013-07-04 / 2013-10-23
	**    Author:	Silvia Chang
	**    Reason:	modfiy for ch 165, channel width only can set 20. /
	**				Domain TW ch 56, only "20 only", ch 60 and 64, only "24/40"
	**/

	function disable_chwidth_1()
	{
		var chan = parseInt($('#sel_wlan1_channel').val(), 10);
		$('#11a_protection').attr('disabled',true);
	
		if (chan == 165)
			$('#11a_protection').val("0");
		else
		{
			if (domain == "TW")
			{
				switch (chan) {
				case 56:
					$('#11a_protection').val("0");
					break;
				case 60:
				case 64:
					$('#11a_protection').val("1");
					break;
				default:
					$('#11a_protection').attr('disabled',false);
					break;
				}
			} else {
				$('#11a_protection').attr('disabled',false);
			}
		}
	}

	function disable_channel_1()
	{
		var auto_ch = $('#auto_channel_1')[0].checked;
		var chan = parseInt($('#sel_wlan1_channel').val(), 10);

		if($('#w_enable_1')[0].checked)
		{
			$('#sel_wlan1_channel').attr('disabled',auto_ch);

			if (auto_ch == 1)
				$('#11a_protection').attr('disabled',false);

			if (auto_ch == 0)
			{
				if (chan == 165)
				{
					$('#11a_protection').val("0");
					$('#11a_protection').attr('disabled',!auto_ch);
				}
				if (domain == "TW")
				{
					switch (chan) {
					case 56:
						$('#11a_protection').val("0");
						$('#11a_protection').attr('disabled',!auto_ch);
						break;
					case 60:
					case 64:
						$('#11a_protection').val("1");
						$('#11a_protection').attr('disabled',!auto_ch);
						break;
					default:
						break;
					}
				}
			}
		}
	}

	function show_chan_width_1()
	{
		$('#show_channel_width_1').show();
		var mode = $('#dot11_mode_1').val();
		if (mode =='11n')
			$('#11a_protection').val("1");	//Auto
		else if (mode =='11ac' || mode =='11acn' || mode =='11acna')
			$('#11a_protection').val("3");	//204080Auto
		else if (mode =='11a')
		{
			$('#show_channel_width_1').hide();
			$('#11a_protection').val("0");	//20MHz
		}
		disable_channel_1();
	}

	function send_key_value_1(key_length_1)
	{
		//$("#wlan1_wep" + key_length_1 + "_key_1").val($("#key5").val());
		var key_type_1 = $('#wlan1_wep_display').val();

		for(var i = 1; i < 5; i++){
			$("#wlan1_wep" + key_length_1 + "_key_" + i).val($("#key" + (i+4)).val());
		}
	}

	function send_cipher_value_1()
	{
		if($('#c_type_1')[0].selectedIndex == 0)
			$('#wlan1_psk_cipher_type').val("tkip");
		else if($('#c_type_1')[0].selectedIndex == 1)
			$('#wlan1_psk_cipher_type').val("aes");
		else
			$('#wlan1_psk_cipher_type').val("both");
	}

	function check_8021x_1()
	{
    	var ip1 = $('#radius1_ip1').val();
    	var ip2 = $('#radius1_ip2').val();
		var radius1_msg = replace_msg(all_ip_addr_msg,get_words('RADIUS_SERVER1_IP_DESC', LangMap.msg));
		var radius2_msg = replace_msg(all_ip_addr_msg,get_words('RADIUS_SERVER2_IP_DESC', LangMap.msg));
		var temp_ip1 = new addr_obj(ip1.split("."), radius1_msg, false, false);
		var temp_ip2 = new addr_obj(ip2.split("."), radius2_msg, true, false);
        var temp_radius1 = new raidus_obj(temp_ip1, $('#radius1_port1').val(), $('#radius1_pass1').val());
        var temp_radius2 = new raidus_obj(temp_ip2, $('#radius1_port2').val(), $('#radius1_pass2').val());
		if (!check_radius(temp_radius1)){
			return false;
		}else if (ip2 != "" && ip2 != "0.0.0.0"){
			if (!check_radius(temp_radius2)){
				return false;
			}
		}
		return true;
	}

	function check_psk_1(){
		var psk_value = $('#wlan1_psk_pass_phrase').val();
		if (psk_value.length < 8){
			alert(get_words('YM116'));
				return false;
		}else if (psk_value.length > 63){
			if(!isHex(psk_value)){
				alert(get_words('GW_WLAN_WPA_PSK_HEX_STRING_INVALID'));
				return false;
			}
        }
        return true;
    }

	function show_radius_1()
	{
		$('#radius2_1').hide();
		$('#none_radius2_1').hide();
		$('#show_radius2_1').hide();
		if(radius_button_flag_1){
			$('#radius2_1').show();
			radius_button_flag_1 = 0;
		}else{
			$('#none_radius2_1').show();
			$('#show_radius2_1').show();
			radius_button_flag_1 = 1;
		}
	}

    function get_wlan1_schedule(obj){
		$('#wlan1_schedule').val($("#wlan1_schedule_select option:selected").val());
	}
	// End of Silvia add

	var txrate_11b = new Array(11, 5.5, 2, 1);
	var txrate_11g = new Array(54, 48, 36, 24, 18, 12, 9, 6);
	var txrate_11n = new Array('MCS 15 - 130 [270]', 'MCS 14 - 117 [243]', 'MCS 13 - 104 [216]', 'MCS 12 - 78 [162]', 'MCS 11 - 52 [108]', 'MCS 10 - 39 [81]', 'MCS 9 - 26 [54]', 'MCS 8 - 13 [27]', 'MCS 7 - 65 [135]', 'MCS 6 - 58.5 [121.5]', 'MCS 5 - 52 [108]', 'MCS 4 - 39 [81]', 'MCS 3 - 26 [54]', 'MCS 2 - 19.5 [40.5]', 'MCS 1 - 13 [27]', 'MCS 0 - 6.5 [13.5]');

	var txrate_11b_value = new Array(34,35,36,37);
	var txrate_11g_value = new Array(26,27,28,29,30,31,32,33);
	var txrate_11n_value = new Array(10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25);

	/*
	**    Date:		2013-07-23
	**    Author:	Silvia Chang
	**    Reason:   Remove transmission rate (MCS), request from DLink
	**/

	function set_11g_txrate(obj){
		for(var i = 0; i < txrate_11g.length; i++){
			var ooption = document.createElement("option");
			
			obj.options[i+1] = null;
			ooption.text = txrate_11g[i];
			ooption.value = txrate_11g_value[i];
			obj.options[i+1] = ooption;	
		}
	}

	function set_11n_txrate(obj){
		for(var i = 0; i < txrate_11n.length; i++){
			var ooption = document.createElement("option");
			
			obj.options[i+1] = null;
			ooption.text = txrate_11n[i];
			ooption.value = txrate_11n_value[i];
			obj.options[i+1] = ooption;	
		}
	}

	function set_11bg_txrate(obj){
		var count = 0;
		var legth = txrate_11b.length + txrate_11g.length;
		for(var i = 0; i < legth; i++){
			var ooption = document.createElement("option");
			obj.options[i+1] = null;
			if(i >= txrate_11g.length){
				ooption.text = txrate_11b[count];
				ooption.value = txrate_11b_value[count];
				count++;
			}else{
				ooption.text = txrate_11g[i];
				ooption.value = txrate_11g_value[i];
			}
			obj.options[i+1] = ooption;	
		}
	}

	function set_11gn_txrate(obj){
		var count = 0;
		var legth = txrate_11g.length;
		for(var i = 0; i < legth; i++){
			var ooption = document.createElement("option");
			obj.options[i+1] = null;
			ooption.text = txrate_11g[count];
			ooption.value = txrate_11g_value[count];
			count++;
			obj.options[i+1] = ooption;	
		}
	}

	function set_11bgn_txrate(obj){
		var count_b = 0, count_g = 0;
		var legth = txrate_11b.length + txrate_11g.length;
		for(var i = 0; i < legth; i++){
			var ooption = document.createElement("option");
			obj.options[i+1] = null;
			if(i >= txrate_11g.length){
				ooption.text = txrate_11b[count_b];
				ooption.value = txrate_11b_value[count_b];
				count_b++;
			}
			else
			{
				ooption.text = txrate_11g[count_g];
				ooption.value = txrate_11g_value[count_g];
				count_g++;
			}
			obj.options[i+1] = ooption;	
		}
	}

	function change_mode(){
		var mode = $('#dot11_mode').val();

		$('#show_11g_txrate').hide();
		$('#show_11n_txrate').hide();
		$('#show_11bg_txrate').hide();
		$('#show_11gn_txrate').hide();
		$('#show_11bgn_txrate').hide();
		$('#show_channel_width').hide();
		switch(mode){
		case '11g':
			$('#show_11g_txrate').show();
			break;
		case '11n':
			//$('#show_11n_txrate').show();
			$('#show_channel_width').show();
			break;
		case '11bg':
			$('#show_11bg_txrate').show();
			break;
		case '11gn':
			$('#show_11gn_txrate').show();
			$('#show_channel_width').show();	//20120503 silvia add channel_n
			break;
		case '11bgn':
			$('#show_11bgn_txrate').show();
			$('#show_channel_width').show();
			break;
		}
	}

// for WPS function
	function show_buttons()
	{
		var enable = $('#wpsEnable')[0];
		var show_wps_word = "Enabled / ";
		if(ischeck_wps("wps")){
			if(!enable.checked){
				$('#wps_pin').val("00000000");
				show_wps_word = "Disabled / ";
			}else if($('#wps_pin').val() == "00000000" && $('#wpsEnable')[0].checked){
				$('#wps_pin').val($('#wps_default_pin').val());
				$('#show_wps_pin').html($('#wps_pin').val());
			}
			$('#reset_pin').attr('disabled', !enable.checked);
			$('#generate_pin').attr('disabled', !enable.checked);
			$('#reset_to_unconfigured').attr('disabled', !enable.checked);
			
			if($('#wps_configured_mode').val() == "1"){
				show_wps_word += "Not Configured";
				$('#reset_to_unconfigured').attr("disabled",true);
			}else{
				show_wps_word += "Configured";
			}
			$('#wps_word').html(show_wps_word);
		}
	}

	function set_pinvalue(obj_value){
		$('#wps_pin').val(obj_value);
		$('#show_wps_pin').html(obj_value);
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
 		$('#wps_pin').val(num);
 		$('#show_wps_pin').html(num);
	}

	function Unconfigured_button(){
		get_by_id("form1").action = "restore_default_wireless.cgi";
		get_by_id("form1").submit();
	}

	function check_wps_psk_eap(){
		var wlan0_security= $('#wlan0_security').val();
		var security = wlan0_security.split("_");

		if($('#wpsEnable')[0].checked){
			if(($('#wep0_type').val() == "1") && ($('#wep0_def_key').val() != "1")){
				$('#show0_wep').hide();
				$('#show0_wpa').hide();
		    	$('#show0_wpa_psk').hide();
		    	$('#show0_wpa_eap').hide();

				if(wlan0_security == "disable"){				//Disabled
					set_selectIndex(0, $('#wep0_type')[0]);
				}else if(security[0] == "wep"){					//WEP
					set_selectIndex(1, $('#wep0_type')[0]);
					$('#show0_wep').show();
				}else{
					if(security[1] == "psk"){					//PSK
						set_selectIndex(2, $('#wep0_type')[0]);
						$('#show0_wpa').show();
						$('#show0_wpa_psk').show();
					}else if(security[1] == "eap"){				//EAP
						set_selectIndex(3, $('#wep0_type')[0]);
						$('#show0_wpa').show();
						$('#show0_wpa_eap').show();
					}
				}
				set_selectIndex($('#wlan0_wep_default_key').val(), $('#wep0_def_key')[0]);
				alert(get_words('TEXT024'));
				return false;
			}
			if($('#wep0_type').val() == "3"){
				$('#show0_wep').hide();
				$('#show0_wpa').hide();
		    	$('#show0_wpa_psk').hide();
		    	$('#show0_wpa_eap').hide();

				if(wlan0_security == "disable"){				//Disabled
					set_selectIndex(0, $('#wep0_type')[0]);
				}else if(security[0] == "wep"){					//WEP
					set_selectIndex(1, $('#wep0_type')[0]);
					$('#show0_wep').show();
				}else{
					if(security[1] == "psk"){					//PSK
						set_selectIndex(2, $('#wep0_type')[0]);
						$('#show0_wpa').show();
						$('#show0_wpa_psk').show();
					}else if(security[1] == "eap"){				//EAP
						set_selectIndex(3, $('#wep0_type')[0]);
						$('#show0_wpa').show();
						$('#show0_wpa_eap').show();
					}
				}
				alert(get_words('TEXT026'));
				return false;
			}
		}
		return true;
	}

	function ischeck_wps(obj){
		var is_true = false;
		if($('#wpsEnable')[0].checked){
			if(!$('#w_enable')[0].checked){
				alert(get_words('TEXT028'));
				is_true = true;
			}else if(!check_wps_psk_eap()){
				is_true = true;
			}else if($('#auth0_type').val() == "share"){
				alert(get_words('TEXT027'));
				is_true = true;
				if(obj == "auto"){
					set_selectIndex("open", $('#auth0_type')[0]);
				}
			}
		}
		if(is_true){
			if(obj == "wps")
				$('#wpsEnable').attr("checked",false);
			return false;
		}
		return true;
	}

	 function do_add_new_schedule(){
			window.location.href = "tools_schedules.asp";
	}

	function get_wlan0_schedule(obj){
		$('#wlan0_schedule').val($("#wlan0_schedule_select option:selected").val());
	}

	function add_option(id)
	{
		var obj = null;
		var arr = null;
		var nam = null;
		
		if (id == 'Schedule') {
			obj = schedule_cnt;
			arr = array_sch_inst;
			nam = schCfg.name;
		} else if (id == 'Inbound') {
			obj = inbound_cnt;
			arr = array_ib_inst;
			nam = array_ib_name;
		}
		
		if (obj == null)
			return;

		for (var i = 0; i < obj; i++){
				var inst = inst_array_to_string(arr[i]);
				document.write("<option value=" + inst.charAt(1) + ">" + nam[i] + "</option>");
		}	
	}

	function submit_All()
	{
		var submitObj = new ccpObject();
		var paramForm = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&nextPage=wireless.asp'	//20121224 Silvia move send event to countdown page
		};

		if (wband == "2.4G" || wband == "dual")
			paramForm.arg += "&wlanCfg_WMMEnable_1.1.0.0="+lanCfg.WMM[0];
		if (wband == "5G" || wband == "dual")
			paramForm.arg += "&wlanCfg_WMMEnable_1.5.0.0="+lanCfg.WMM[1];

		paramForm.arg += submit_c;
		submitObj.get_config_obj(paramForm);
	}

	function Format_basic()
	{
		var basic="";
		if (wband == "2.4G" || wband == "dual")
		{
			basic += "&wlanCfg_Enable_1.1.0.0="+get_checked_value($('#w_enable')[0]);
			if($('#wlan0_enable').val() == "0")
				basic += "&wlanCfg_Enable_1.2.0.0=0";

			if (get_checked_value($('#w_enable')[0]) == 1)
			{
				basic += "&wlanCfg_ScheduleIndex_1.1.0.0="+$('#wlan0_schedule_select').val();
				basic += "&wlanCfg_SSID_1.1.0.0="+urlencode($('#wlan0_ssid').val());

				if (wband == "5G" || wband == "dual")
				{
					basic += "&wpsCfg_Enable_1.5.1.0="+is_wps;
					basic += "&wpsCfg_Enable_1.6.1.0="+is_wps;
				}

				for (i=1;i<=2;i++){
					basic += "&wlanCfg_AutoChannel_1."+i+".0.0="+(($('#auto_channel')[0].checked)?"1":"0");
					basic += "&wlanCfg_Channel_1."+i+".0.0="+$('#sel_wlan0_channel').val();
					basic += "&wpsCfg_Enable_1."+i+".1.0="+is_wps;

					switch($('#dot11_mode').val())
					{
						case "11g":
							basic += "&wlanCfg_Standard_1."+i+".0.0=1";
							basic += "&wlanCfg_TransmitRate_1."+i+".0.0="+$('#wlan0_11g_txrate').val();
							break;
						case "11n":
							basic += "&wlanCfg_Standard_1."+i+".0.0=2";
							basic += "&wlanCfg_TransmitRate_1."+i+".0.0="+$('#wlan0_11n_txrate').val();
							break;
						case "11bg":
							basic += "&wlanCfg_Standard_1."+i+".0.0=3";
							basic += "&wlanCfg_TransmitRate_1."+i+".0.0="+$('#wlan0_11bg_txrate').val();
							break;
						case "11gn":
							basic += "&wlanCfg_Standard_1."+i+".0.0=4";
							basic += "&wlanCfg_TransmitRate_1."+i+".0.0="+$('#wlan0_11gn_txrate').val();
							break;
						case "11bgn":
							basic += "&wlanCfg_Standard_1."+i+".0.0=5";
							basic += "&wlanCfg_TransmitRate_1."+i+".0.0="+$('#wlan0_11bgn_txrate').val();
							break;
					}
					basic += "&wlanCfg_ChannelWidth_1."+i+".0.0="+$('#11n_protection')[0].selectedIndex;
				}

				var ssid_vs = get_checked_value(get_by_name("wlan0_ssid_broadcast"));
				basic += "&wlanCfg_BeaconAdvertisementEnabled_1.1.0.0="+ssid_vs;

				//20120111 silvia add Coexistence	0419 ignored
		/*
				if ($('#11n_protection')[0].selectedIndex == 0)
					basic += "&wlanCfg_BSSCoexistenceEnable_1.1.0.0=0";
				else
					basic += "&wlanCfg_BSSCoexistenceEnable_1.1.0.0=1";
		*/

				basic += "&wlanCfg_SecurityMode_1.1.0.0="+$('#wep0_type')[0].selectedIndex;
				basic += "&wlanCfg_WDSEnable_1.1.0.0="+get_checked_value($('#enable_wds')[0]);

				// 20120312 silvia modify
				//wpsCfg.status[0] = '0';
				if((($('#wlan0_ssid').val() != lanCfg.ssid[0]) ||
				   (($('#wep0_type')[0].selectedIndex != lanCfg.sMode[0]) && ($('#wep0_type')[0].selectedIndex != 0))||
				   ($('#c_type_0')[0].selectedIndex != wpaCfg.encrMode[0]) ||
				   ($('#wlan0_psk_pass_phrase').val() != wpaCfg.pskKey[0]))
				   && wpsCfg.status[0] == "0" )
				   {
						basic += "&wpsCfg_Status_1.1.1.0=1";
						basic += "&wpsCfg_Status_1.5.1.0=1";
					}
				
		/*	
				if((($('#wlan0_ssid').val() != lanCfg.ssid[0]) && wpsCfg.status[0] == "0") ||
					($('#wep0_type')[0].selectedIndex == 2) && wpsCfg.status[0] == "0")
				{
					basic += "&wpsCfg_Status_1.1.1.0=1";
					//basic += "&wpsCfg_SetupLock_1.1.1.0=1";
				}
		*/
			}
		}

		// 2011.11.30 for 5G
		if (wband == "5G" || wband == "dual")
		{
			basic += "&wlanCfg_Enable_1.5.0.0="+get_checked_value($('#w_enable_1')[0]);
			if($('#wlan1_enable').val() == "0")
				basic += "&wlanCfg_Enable_1.6.0.0=0";

			if (get_checked_value($('#w_enable_1')[0]) == 1)
			{
				basic += "&wlanCfg_ScheduleIndex_1.5.0.0="+$('#wlan1_schedule_select').val();
				basic += "&wlanCfg_SSID_1.5.0.0="+urlencode($('#wlan1_ssid').val());

				if (wband == "2.4G" || wband == "dual")
				{
					basic += "&wpsCfg_Enable_1.1.1.0="+is_wps;
					basic += "&wpsCfg_Enable_1.2.1.0="+is_wps;
				}

				for (i=5;i<=6;i++){
					basic += "&wlanCfg_AutoChannel_1."+i+".0.0="+(($('#auto_channel_1')[0].checked)?"1":"0");
					basic += "&wlanCfg_Channel_1."+i+".0.0="+$('#sel_wlan1_channel').val();
					basic += "&wpsCfg_Enable_1."+i+".1.0="+is_wps;

					switch($('#dot11_mode_1').val())
					{
						case "11n":
							basic += "&wlanCfg_Standard5G_1."+i+".0.0=0";
							break;
						case "11a":
							basic += "&wlanCfg_Standard5G_1."+i+".0.0=1";
							break;
						case "11na":
							basic += "&wlanCfg_Standard5G_1."+i+".0.0=2";
							break;
						case "11ac":
							basic += "&wlanCfg_Standard5G_1."+i+".0.0=3";
							break;
						case "11acna":
							basic += "&wlanCfg_Standard5G_1."+i+".0.0=4";
							break;
						case "11acn":
							basic += "&wlanCfg_Standard5G_1."+i+".0.0=5";
							break;
					}
					basic += "&wlanCfg_ChannelWidth_1."+i+".0.0="+$('#11a_protection').val();
					basic += "&wlanCfg_BeaconAdvertisementEnabled_1."+i+".0.0="+get_checked_value(get_by_name("wlan1_ssid_broadcast"));
				}

				basic += "&wlanCfg_SecurityMode_1.5.0.0="+$('#wep1_type')[0].selectedIndex;
				basic += "&wlanCfg_WDSEnable_1.5.0.0="+get_checked_value($('#enable_wds_a')[0]);

				var ssid_vs1 = get_checked_value(get_by_name("wlan1_ssid_broadcast"));
				basic += "&wlanCfg_BeaconAdvertisementEnabled_1.5.0.0="+ssid_vs1;

				// 20120312 silvia modify
				if((($('#wlan1_ssid').val() != lanCfg.ssid[2]) ||
				   (($('#wep1_type')[0].selectedIndex != lanCfg.sMode[2]) && ($('#wep1_type')[0].selectedIndex != 0))||
				   ($('#c_type_1')[0].selectedIndex != wpaCfg.encrMode[2]) ||
				   ($('#wlan1_psk_pass_phrase').val() != wpaCfg.pskKey[2]))
				   && wpsCfg.status[0] == "0" )
				   {
						basic += "&wpsCfg_Status_1.1.1.0=1";
						basic += "&wpsCfg_Status_1.5.1.0=1";
					}
			}
		}
/*
		if((($('#wlan1_ssid').val() != lanCfg.ssid[2]) && wpsCfg.status[2] == "0") ||
			($('#wep1_type')[0].selectedIndex == 2) && wpsCfg.status[2] == "0")
		{
			basic += "&wpsCfg_Status_1.3.1.0=1";
			//basic += "&wpsCfg_SetupLock_1.3.1.0=1";
		}
*/
		submit_c += basic;
	}
	
	function Format_WEP(j)
	{
		var ins = ((j==0)?1:5);
		var WEP="";
		if($('#auth'+j+'_type').val() == "both")
			WEP += "&wepInfo_AuthenticationMode_1."+ins+".1.0=2"
		else
			WEP += "&wepInfo_AuthenticationMode_1."+ins+".1.0=1"

		WEP += "&wepInfo_KeyType_1."+ins+".1.0=0";	//always be HEX in this model
		WEP += "&wepInfo_KeyLength_1."+ins+".1.0="+$('#wep'+j+'_key_len')[0].selectedIndex;
		WEP += "&wepInfo_KeyIndex_1."+ins+".1.0="+$('#wep'+j+'_def_key').val();

		if($('#wlan'+j+'_wep_display').val() == "ascii")
			WEP += "&wepInfo_KeyTypeForGUI_1."+ins+".1.0=1";
		else
			WEP += "&wepInfo_KeyTypeForGUI_1."+ins+".1.0=0";
			
		for(var i=1; i<=4; i++)
		{
			WEP += "&wepKey_KeyHEX64_1."+ins+".1."+i+"="+ $('#wlan'+j+'_wep64_key_'+i).val();
			WEP += "&wepKey_KeyHEX128_1."+ins+".1."+i+"="+ $('#wlan'+j+'_wep128_key_'+i).val();
		}
		submit_c += WEP;
	}

	function Format_WPA(j)
	{
		var flag = ((j==0)?radius_button_flag:radius_button_flag_1);
		var ins = ((j==0)?1:5);
		var WPA="";
		var sec_type = $('#wep'+j+'_type')[0].selectedIndex;

		WPA += "&wpaInfo_WPAMode_1."+ins+".1.0="+$('#wpa'+j+'_mode')[0].selectedIndex;

		if(sec_type == "2")
			WPA += "&wpaInfo_AuthenticationMode_1."+ins+".1.0=0";
		else if(sec_type == "3")
			WPA += "&wpaInfo_AuthenticationMode_1."+ins+".1.0=1";
		
		if($('#c_type_'+j).val() == "tkip")
			WPA += "&wpaInfo_EncryptionMode_1."+ins+".1.0=0";
		else if($('#c_type_'+j).val() == "aes")
			WPA += "&wpaInfo_EncryptionMode_1."+ins+".1.0=1";
		else
			WPA += "&wpaInfo_EncryptionMode_1."+ins+".1.0=2";

		WPA += "&wpaInfo_KeyUpdateInterval_1."+ins+".1.0="+ $('#wlan'+j+'_gkey_rekey_time').val();
		WPA += "&wpaInfo_AuthenticationTimeout_1."+ins+".1.0="+$('#wlan'+j+'_eap_reauth_period').val();
		WPA += "&wpaPSK_KeyPassphrase_1."+ins+".1.1="+ urlencode($('#wlan'+j+'_psk_pass_phrase').val());
		//WPA += "&wpaInfo_KeyUpdateInterval_1.1.3.1.0=1131";

		var ser = ((flag==0)?1:2);
		for(var i=1; i<=ser; i++)
		{
			WPA += "&wpaEap_RadiusServerIP_1."+ins+".1."+i+"="+ $('#radius'+j+'_ip'+i).val();
			WPA += "&wpaEap_RadiusServerPort_1."+ins+".1."+i+"="+ $('#radius'+j+'_port'+i).val();
			WPA += "&wpaEap_RadiusServerPSK_1."+ins+".1."+i+"="+ urlencode($('#radius'+j+'_pass'+i).val());
			WPA += "&wpaEap_MACAuthentication_1."+ins+".1."+i+"="+ get_checked_value($('#radius'+j+'_auth_mac'+i)[0]);
		}
		submit_c += WPA;
	}

	function Format_BdgSetting()
	{
		if($('#enable_wds')[0].checked == true)
		{
			if($('#br_sec').val() == 3 || $('#br_sec').val() == 4)
			{
				if(!check_psk_br())
					return false;
			}
			for(var i=0; i<8; i++)
			{
				var mac = $('#rm_mac_'+(i+1)).val();
				if (mac == "")
					continue;

				if(!check_mac(mac))
				{
					alert(get_words('KR3'));
					return false;
				}
			}
		}
		return true;
	}

	function changeWlanMode()
	{
		$('#auto_channel').attr("disabled",false);
		$('#show_br_setting').hide();
		
		if($('#enable_wds')[0].checked == true)
		{
			$('#auto_channel')[0].checked = parseInt(mainObj.config_val("wlanCfg_AutoChannel_"));
			$('#auto_channel').attr("checked",false);
			$('#auto_channel').attr("disabled",true);
			$('#show_br_setting').show();
		}
		else
		{
			$('#auto_channel')[0].checked = parseInt(mainObj.config_val("wlanCfg_AutoChannel_"));
			$('#show_br_setting').hide();
		}

		disable_channel_0();
		onBrSecChange();
	}
	
	function displayBrSecField(sec_mode)
	{
		$('#br_wep_key_type').attr('disabled', (sec_mode == 'WEP')? false:true);
		$('#br_wep_key').attr('disabled', (sec_mode == 'WEP')? false:true);
		$('#br_passphrase').attr('disabled', (sec_mode == 'WPA')? false:true);
	}

	function onBrSecChange()
	{
		var brSec = $('#br_sec').val/90;
		switch(brSec)
		{
			case "0":
				displayBrSecField('none');
			break;
			case "1":
			case "2":
				displayBrSecField('WEP');
			break;
			case "3":
			case "4":
				displayBrSecField('WPA');
			break;
		}
	}

function setValue5GDFSChannelList()
{
	//check DFSEnable
	if(lanCfg.dfs[2]=='1')
	{
		var select_sort_channel = function() {
			var current_channel =lanCfg.channel[2];
			$("#sel_wlan1_channel option[value='" +current_channel+ "']").attr("selected", true);
		}

		var arrDFS = ch5_DFS_lst.split(", ");
		for(var i in arrDFS)
		{
			var g = parseInt(arrDFS[i], 10)*5+5000+'';	//calculate frequency by channel
			g = ''.concat(g.substr(0,1), '.', g.substr(1,3), ' GHz - CH ', arrDFS[i]);
			if (DFS_Cert == 0)
				$('#sel_wlan1_channel').append($('<option>').val(arrDFS[i]).html(g).attr('disabled','disabled'));
			else if (DFS_Cert == 1)
				$('#sel_wlan1_channel').append($('<option>').val(arrDFS[i]).html(g));
		}
		$('#sel_wlan1_channel>option').sortElements(function(a, b){
			return parseInt($(a).val()) > parseInt($(b).val()) ? 1 : -1;
		});
		if (DFS_Cert == 1)
			select_sort_channel();
	}
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
			<td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"><script>document.write(model);</script></a></td>
			<td width="60%">&nbsp;</td>
			<td align="right" nowrap><script>show_words('TA3')</script>: <script>document.write(hw_version);</script> &nbsp;</td>
			<td align="right" nowrap><script>show_words('sd_FWV')</script>: <script>document.write(version);</script></td>
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b1');</script>
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b2');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="wireless.asp">
			<input type="hidden" id="reboot_type" name="reboot_type" value="wireless">
			<input type="hidden" id="wlan0_ssid" name="wlan0_ssid" value=''>
			<input type="hidden" id="wlan1_ssid" name="wlan1_ssid" value=''>
			<input type="hidden" id="wps_pin" name="wps_pin" value=''>
			<input type="hidden" id="wps_configured_mode" name="wps_configured_mode" value=''>
			<input type="hidden" id="wlan0_wep_display" name="wlan0_wep_display" value=''>
			<input type="hidden" id="wlan1_wep_display" name="wlan1_wep_display" value=''>
			<input type="hidden" id="wlan0_schedule" name="wlan0_schedule" value=''>
			<input type="hidden" id="wlan1_schedule" name="wlan1_schedule" value=''>
			<input type="hidden" id="apply" name="apply" value="0">

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('_wireless')</script></h1>
				<p><script>show_words('bwl_Intro_1')</script></p>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'wireless.asp');">
				<script>$('#button').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
			</div>

			<div class="box" style="display:none"> 
				<h2><script>show_words('LW65')</script></h2>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td class="duple"><script>show_words('_enable')</script>:</td>
					<td width="340">&nbsp;
						<input name="wpsEnable" type=checkbox id="wpsEnable" value="1" onClick="show_buttons();">
						<input type="hidden" id="wps_enable" name="wps_enable" value=''>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('LW9')</script>:</td>
					<td width="340">&nbsp;
						<span id="show_wps_pin"></span>
					</td>
				</tr>
				<tr>
					<td class="duple">&nbsp;</td>
					<td width="340">&nbsp; 
						<input type="button" name="generate_pin" id="generate_pin" value="" onclick="genPinClicked();">
						<input type="button" name="reset_pin" id="reset_pin" value="" onclick=set_pinvalue(get_by_id("wps_default_pin").value);> 
						<script>$('#generate_pin').val(get_words('LW11'));</script>
						<script>$('#reset_pin').val(get_words('LW10'));</script>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('LW2')</script> :</td>
					<td width="340">&nbsp;
						<span id="wps_word"></span>
					</td>
				</tr>
				<tr>
					<td class="duple">&nbsp;</td>
					<td width="340">&nbsp; 
						<input type="button" name="reset_to_unconfigured" id="reset_to_unconfigured" value="" onclick="Unconfigured_button();">
						<script>$('#reset_to_unconfigured').val(get_words('resetUnconfiged'));</script><br>
					</td>
				</tr>
				</table>
			</div>

		<div class="2G_use" style="display:none">
			<div class="box"> 
				<h2> <script>show_words('bwl_title_1')</script></h2>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr> 
				<td class="duple"><script>show_words('wwl_band')</script> :</td>
				<td><strong>&nbsp;&nbsp;<script>show_words('GW_WLAN_RADIO_0_NAME')</script></strong></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bwl_EW')</script>:</td>
					<td width="340">&nbsp;
						<input id="w_enable" name="w_enable" type="checkbox" value="1" onClick="disable_wireless_0();" checked>
						<input type="hidden" id="wlan0_enable" name="wlan0_enable" value=''>
						<select id="wlan0_schedule_select" name="wlan0_schedule_select" onChange="get_wlan0_schedule(this);">
						<option value="255" selected><script>show_words('_always')</script></option>
						<option value="254"><script>show_words('_never')</script></option>
						<script>document.write(add_option('Schedule'));</script>
						</select>
						<input name="add_new_schedule" type="button" class="button_submit" id="add_new_schedule" onclick="do_add_new_schedule(true)" value="">
						<script>$('#add_new_schedule').val(get_words('dlink_1_add_new'));</script>
					</td>
				</tr>
				<tr style="display:none">
					<td class="duple"><script>show_words('enable_WDS')</script>:</td>
					<td width="340">&nbsp;
						<input type="checkbox" id="enable_wds" name="enable_wds" value="1" onclick="changeWlanMode();">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bwl_NN')</script>:</td>
					<td width="340">&nbsp;&nbsp;&nbsp;<input name="show_ssid_0" type="text" id="show_ssid_0" size="20" maxlength="32" value="">
						<script>show_words('bwl_AS')</script>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bwl_Mode')</script>:</td>
					<td width="340">&nbsp;&nbsp; 
						<select id="dot11_mode" name="dot11_mode" onClick="show_chan_width_0();" onChange="show_chan_width_0();">
							<option value="11g"><script>show_words('bwl_Mode_2')</script></option>
							<option value="11n"><script>show_words('bwl_Mode_8')</script></option>
							<option value="11bg"><script>show_words('bwl_Mode_3')</script></option>
							<option value="11gn"><script>show_words('bwl_Mode_10')</script></option>
							<option value="11bgn"><script>show_words('bwl_Mode_11')</script></option>
						</select>
						<input type="hidden" id="wlan0_dot11_mode" name="wlan0_dot11_mode" value=''>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('ebwl_AChan')</script>:</td>
					<td width="340">&nbsp;
						<input type="checkbox" id="auto_channel" name="auto_channel" value="1" onClick="disable_channel_0();">
						<input type="hidden" id="wlan0_auto_channel_enable" name="wlan0_auto_channel_enable" value=''>
					</td>
				</tr>
				<tr>
				<td class="duple">
					<script>show_words('_wchannel')</script>:</td>
				<td width="340">&nbsp;&nbsp; 
					<select name="sel_wlan0_channel" id="sel_wlan0_channel">
						<script>set_channel();</script>
					</select>
					<input type="hidden" id="wlan0_channel" name="wlan0_channel" value=''>
				</td>
				</tr>
				<!-- 11g txrate -->
				<tr id="show_11g_txrate" style="display:none">
					<td class="duple"><script>show_words('bwl_TxR')</script> :</td>
					<td width="340">&nbsp;&nbsp; 
						<select id="wlan0_11g_txrate" name="wlan0_11g_txrate">
							<option value="0" selected><script>show_words('bwl_TxR_0')</script></option>
							<script>set_11g_txrate(get_by_id("wlan0_11g_txrate"));</script>
						</select>
					</td>
				</tr>
				<!-- 11n txrate -->
				<tr id="show_11n_txrate" style="display:none">
					<td class="duple"><script>show_words('bwl_TxR')</script> :</td>		
					<td width="340">&nbsp;&nbsp; 
						<select id="wlan0_11n_txrate" name="wlan0_11n_txrate">
							<option value="0" selected>
								<script>show_words('bwl_TxR_0')</script>
							</option>
						<script>set_11n_txrate(get_by_id("wlan0_11n_txrate"));</script>
						</select>
					</td>
				</tr>
				<!-- 11b/g txrate -->
				<tr id="show_11bg_txrate" style="display:none">
					<td class="duple"><script>show_words('bwl_TxR')</script> :</td>
					<td width="340">&nbsp;&nbsp; 
						<select id="wlan0_11bg_txrate" name="wlan0_11bg_txrate">
							<option value="0" selected><script>show_words('bwl_TxR_0')</script></option>
							<script>set_11bg_txrate(get_by_id("wlan0_11bg_txrate"));</script>
						</select>
					</td>
				</tr>
				<!-- 11g/n txrate -->
				<tr id="show_11gn_txrate" style="display:none">
					<td class="duple"><script>show_words('bwl_TxR')</script> :</td>
					<td width="340">&nbsp;&nbsp; 
						<select id="wlan0_11gn_txrate" name="wlan0_11gn_txrate">
							<option value="0" selected><script>show_words('bwl_TxR_0')</script></option>
							<script>set_11gn_txrate(get_by_id("wlan0_11gn_txrate"));</script>
						</select>
					</td>
				</tr>
				<!-- 11b/g/n txrate -->
				<tr id="show_11bgn_txrate" style="display:none">
					<td class="duple"><script>show_words('bwl_TxR')</script> :</td>
					<td width="340">&nbsp;&nbsp; 
						<select id="wlan0_11bgn_txrate" name="wlan0_11bgn_txrate">
							<option value="0" selected><script>show_words('bwl_TxR_0')</script></option>
							<script>set_11bgn_txrate(get_by_id("wlan0_11bgn_txrate"));</script>
						</select>
					</td>
				</tr>
				<tr id="show_channel_width">
					<td class="duple">
					<script>show_words('bwl_CWM')</script>:</td>
					<td width="340">&nbsp;&nbsp; 
						<select id="11n_protection" name="11n_protection">
							<option value="20"><script>show_words('bwl_ht20')</script></option>
							<option value="auto"><script>show_words('bwl_ht2040')</script></option>
						</select>
						<input type="hidden" id="wlan0_11n_protection" name="wlan0_11n_protection" value=''>
					</td>
				</tr>
				<tr>
					<td class="duple">
						<script>show_words('bwl_VS')</script>:</td>
					<td width="340">&nbsp;
						<input type="radio" id="wlan0_ssid_broadcast" name="wlan0_ssid_broadcast" value="1">
						<script>show_words('bwl_VS_0')</script>
						<input type="radio" id="wlan0_ssid_broadcast" name="wlan0_ssid_broadcast" value="0">
						<script>show_words('bwl_VS_1')</script>
					</td>
				</tr>
				</table>
			</div>
			<input type="hidden" id="wlan0_security" name="wlan0_security" value=''>
			<input type="hidden" id="asp_temp_37" name="asp_temp_37" value=''>
			<input type="hidden" id="asp_temp_38" name="asp_temp_38" value=''>
			<input type="hidden" id="asp_temp_39" name="asp_temp_39" value=''>
			<input type="hidden" id="asp_temp_40" name="asp_temp_40" value=''>

			<div class="box" id="show_security"> 
				<h2><script>show_words('bws_WSMode')</script></h2>
				<script>show_words('bws_intro_WlsSec')</script>
				<br><br>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple"><script>show_words('bws_SM')</script>:</td>
					<td width="340">&nbsp;
						<select id="wep0_type" name="wep0_type" onChange="show_wpa_wep()">
							<option value="0" selected><script>show_words('_none')</script></option>
							<option value="1"><script>show_words('_WEP')</script></option>
							<option value="2"><script>show_words('_WPApersonal')</script></option>
							<option value="3"><script>show_words('_WPAenterprise')</script></option>
						</select>
					</td>
				</tr>
				</table>
			</div>

			<div class="box" id="show0_wep" style="display:none"> 
				<h2><script>show_words('_WEP')</script></h2>
				<p><script>show_words('bws_msg_WEP_1')</script></p>
				<p><script>show_words('bws_msg_WEP_2')</script></p>
				<p><script>show_words('bws_msg_WEP_3')</script></p>

				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<input type="hidden" id="wlan0_wep64_key_1" name="wlan0_wep64_key_1" value=''>
				<input type="hidden" id="wlan0_wep128_key_1" name="wlan0_wep128_key_1" value=''>
				<input type="hidden" id="wlan0_wep64_key_2" name="wlan0_wep64_key_2" value=''>
				<input type="hidden" id="wlan0_wep128_key_2" name="wlan0_wep128_key_2" value=''>
				<input type="hidden" id="wlan0_wep64_key_3" name="wlan0_wep64_key_3" value=''>
				<input type="hidden" id="wlan0_wep128_key_3" name="wlan0_wep128_key_3" value=''>
				<input type="hidden" id="wlan0_wep64_key_4" name="wlan0_wep64_key_4" value=''>
				<input type="hidden" id="wlan0_wep128_key_4" name="wlan0_wep128_key_4" value=''>
				<tr> 
					<td class="duple"><script>show_words('bws_WKL')</script>:</td>
					<td width="340">&nbsp; 
						<select id="wep0_key_len" name="wep0_key_len" size=1 onChange="change_wep_key_fun();">
							<option value="5"><script>show_words('bws_WKL_0')</script></option>
							<option value="13"><script>show_words('bws_WKL_1')</script></option>
						</select>
						<script>show_words('bws_length')</script>
					</td>
				</tr>
				<tr style="display:none">
					<td class="duple">
						<script>show_words('bws_DFWK')</script>:</td>
					<td width="340">&nbsp;
						<select id="wep0_def_key" name="wep0_def_key" onChange="ischeck_wps('wep');">
							<option value="1" selected><script>show_words('wepkey1')</script></option>
							<option value="2"><script>show_words('wepkey2')</script></option>
							<option value="3"><script>show_words('wepkey3')</script></option>
							<option value="4"><script>show_words('wepkey4')</script></option>
						</select>
						<input type="hidden" id="wlan0_wep_default_key" name="wlan0_wep_default_key" value=''>
					</td>
				</tr>
				<tr>
					<td class="duple">
						<script>show_words('auth')</script>:</td>
					<td width="340">&nbsp;
						<select name="auth0_type" id="auth0_type" onChange="ischeck_wps('auto');">
							<option value="both"><script>show_words('_both')</script></option>
							<option value="share"><script>show_words('bws_Auth_2')</script></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('_wepkey1')</script> :</td>
					<td width="340">&nbsp;
						<span id="show_resert1"></span>
					</td>
				</tr>
				<tr style="display:none">
					<td class="duple"><script>show_words('_wepkey2')</script> :</td>
					<td width="340">&nbsp;
						<span id="show_resert2"></span>
					</td>
				</tr>
				<tr style="display:none">
					<td class="duple"><script>show_words('_wepkey3')</script> :</td>
					<td width="340">&nbsp;
						<span id="show_resert3"></span>
					</td>
				</tr>
				<tr style="display:none">
					<td class="duple"><script>show_words('_wepkey4')</script> :</td>
					<td width="340">&nbsp;
						<span id="show_resert4"></span>
					</td>
				</tr>
				</table>
			</div>

			<div class="box" id="show0_wpa"  style="display:none"> 
				<h2><script>show_words('_WPA')</script></h2>
				<p><script>show_words('bws_msg_WPA')</script></p>
				<p><script>show_words('bws_msg_WPA_2')</script></p>
				<input type="hidden" id="wlan0_psk_cipher_type" name="wlan0_psk_cipher_type" value=''>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple"><script>show_words('bws_WPAM')</script>:</td>
					<td width="340">&nbsp;
						<select id="wpa0_mode" name="wpa0_mode">
							<option value="auto"><script>show_words('bws_WPAM_2')</script></option>
							<option value="wpa2"><script>show_words('bws_WPAM_3')</script></option>
							<option value="wpa"><script>show_words('bws_WPAM_1')</script></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_CT')</script>:</td>
					<td width="340">&nbsp;
						<select id="c_type_0" name="c_type_0" onChange="check_wps_psk_eap()">
							<option value="tkip"><script>show_words('bws_CT_1')</script></option>
							<option value="aes"><script>show_words('bws_CT_2')</script></option>
							<option value="both"><script>show_words('bws_CT_3')</script></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_GKUI')</script>:</td>
					<td width="340">&nbsp;
						<input type="text" id="wlan0_gkey_rekey_time" name="wlan0_gkey_rekey_time" size="8" maxlength="5" value=''>
						<script>show_words('bws_secs')</script>
					</td>
				</tr>
				</table>
			</div>

			<div class="box" id="show0_wpa_psk" style="display:none"> 
				<h2><script>show_words('_psk')</script></h2>
				<p class="box_msg"> 
					<script>show_words('KR18')</script>
					<script>show_words('KR19')</script>
				</p>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple"><script>show_words('_psk')</script>:</td>
					<td width="340">&nbsp;<input type="password" id="wlan0_psk_pass_phrase" name="wlan0_psk_pass_phrase" size="40" maxlength="64" value=''></td>
				</tr>
				</table>
			</div>

			<div class="box" id="show0_wpa_eap" style="display:none"> 
				<h2><script>show_words('bws_EAPx')</script></h2>
				<p class="box_msg"><script>show_words('bws_msg_EAP')</script></p>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<input type="hidden" id="wlan0_eap_radius_server_0" name="wlan0_eap_radius_server_0" value=''>
					<input type="hidden" id="wlan0_eap_mac_auth" name="wlan0_eap_mac_auth" value=''>
					<td class="duple"><script>show_words('bwsAT_')</script>:</td>
					<td width="340">&nbsp;<input id="wlan0_eap_reauth_period" name="wlan0_eap_reauth_period" size=10 value=''>
						<script>show_words('_minutes')</script>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RIPA')</script>:</td>
					<td width="340">&nbsp;<input type="text" id="radius0_ip1" name="radius0_ip1" maxlength=15 size=15></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RSP')</script>:</td>
					<td width="340">&nbsp;<input type="text" id="radius0_port1" name="radius0_port1" size="8" maxlength="5" value="1812"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RSSs')</script>:</td>
					<td width="340">&nbsp;<input type="password" id="radius0_pass1" name="radius0_pass1" size="32" maxlength="64"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RMAA')</script>:</td>
					<td width="340">&nbsp;<input type="checkbox" id="radius0_auth_mac1" name="radius0_auth_mac1" value="1"></td>
				</tr>
				<tr id="radius2">
					<td colspan="2"><input type="button" id="advanced" name="advanced" value="" onClick="show_radius();">
						<script>$('#advanced').val(get_words('_advanced')+">>");</script>
					</td>
				</tr>
				<tr id="none_radius2" style="display:none">
					<td colspan="2"><input type="button" id="advanced1" name="advanced1" value="" onClick="show_radius();">
					<script>$('#advanced1').val("<<"+get_words('_advanced'));</script></td>
				</tr>
				</table>

				<table id="show_radius2" cellpadding="1" cellspacing="1" border="0" width="525" style="display:none">
				<tr>
					<input type="hidden" id="wlan0_eap_radius_server_1" name="wlan0_eap_radius_server_1" value=''>
					<td class="box_msg" colspan="2"><script>show_words('bws_ORAD')</script>:</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RIPA')</script>:</td>
					<td width="340">&nbsp;<input type="text" id="radius0_ip2" name="radius0_ip2" maxlength=15 size=15></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RSP')</script>:</td>
					<td width="340">&nbsp;<input type="text" id="radius0_port2" name="radius0_port2" size="8" maxlength="5" value="1812"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RSSS')</script>:</td>
					<td width="340">&nbsp;<input type="password" id="radius0_pass2" name="radius0_pass2" size="32" maxlength="64"></td>
				</tr>
				<tr style="display:">
					<td class="duple"><script>show_words('bws_2RMAA')</script>:</td>
					<td width="340">&nbsp;<input type="checkbox" id="radius0_auth_mac2" name="radius0_auth_mac2" value="1"></td>
				</tr>
				</table>
			</div>

			<div class="box" id="show_br_setting" style="display:none"> 
				<h2><script>show_words('BR_SET')</script></h2>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple">Remote AP MAC :</td>
					<td>1.<input type="text" id="rm_mac_1" name="rm_mac_1" size="20" maxlength="18"></td>
					<td>2.<input type="text" id="rm_mac_2" name="rm_mac_2" size="20" maxlength="18"></td>
				</tr>
				<tr>
					<td class="duple"></td>
					<td>3.<input type="text" id="rm_mac_3" name="rm_mac_3" size="20" maxlength="18"></td>
					<td>4.<input type="text" id="rm_mac_4" name="rm_mac_4" size="20" maxlength="18"></td>
				</tr>
				<tr>
					<td class="duple"></td>
					<td>5.<input type="text" id="rm_mac_5" name="rm_mac_5" size="20" maxlength="18"></td>
					<td>6.<input type="text" id="rm_mac_6" name="rm_mac_6" size="20" maxlength="18"></td>
				</tr>
				<tr>
					<td class="duple"></td>
					<td>7.<input type="text" id="rm_mac_7" name="rm_mac_7" size="20" maxlength="18"></td>
					<td>8.<input type="text" id="rm_mac_8" name="rm_mac_8" size="20" maxlength="18"></td>
				</tr>

				<tr>
					<td class="duple">Bridge Security :</td>
					<td colspan=2>
					<select id="br_sec" name="br_sec" onChange="onBrSecChange();">
						<option value=0>none</option>
						<option value=1>WEP 64bits</option>
						<option value=2>WEP 128bits</option>
						<option value=3>WPA-PSK (TKIP)</option>
						<option value=4>WPA2-PSK (AES)</option>
					</select>
					</td>
				</tr>
				<tr>
					<td class="duple" valign="middle">WEP Key :</td>
					<td colspan=2>
					<select id="br_wep_key_type" name="br_wep_key_type" onChange="onBrSecChange();">
						<option value=1>ASCII</option>
						<option value=0>HEX</option>
					</select><br>
					<input type="text" id="br_wep_key" name="br_wep_key" size="30" maxlength="128">
					</td>
				</tr>
				<tr>
					<td class="duple">Passphrase :<br>(8~63 char.)</td>
					<td colspan=2>
						<input type="text" id="br_passphrase" name="br_passphrase" size="30" maxlength="63">
					</td>
				</tr>

				</table>
			</div>
		</div>

			<!-- 2011.11.29 5G Silvia -->
		<div class="5G_use" style="display:none">
			<div class="box" id="show0_wpa_eap" style="display:none"> 
			<h2><script>show_words('bws_EAPx')</script></h2>
			<p class="box_msg">
				<script>show_words('bws_msg_EAP')</script>
				<script>show_words('bws_RMAA')</script>
			</p>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr>
				<td class="duple"> <script>show_words('bwsAT_')</script> :</td>
					<input type="hidden" id="wlan0_eap_radius_server_0" name="wlan0_eap_radius_server_0" value="0.0.0.0/1812/">
					<input type="hidden" id="wlan0_eap_mac_auth" name="wlan0_eap_mac_auth" value="3">
				<td width="340">&nbsp;
					<input id="wlan0_eap_reauth_period" name="wlan0_eap_reauth_period" size=10 value="60">
					<script>show_words('_minutes')</script></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RIPA')</script> :</td>
				<td width="340">&nbsp;
					<input id="radius0_ip1" name="radius0_ip1" maxlength=15 size=15></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RSP')</script> :</td>
				<td width="340">&nbsp;
					<input type="text" id="radius0_port1" name="radius0_port1" size="8" maxlength="5" value="1812"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RSSs')</script> :</td>
				<td width="340">&nbsp;
					<input type="password" id="radius0_pass1" name="radius0_pass1" size="32" maxlength="64"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RMAA')</script> :</td>
				<td width="340">&nbsp;
					<input type="checkbox" id="radius0_auth_mac1" name="radius0_auth_mac1" value="1"></td>
			</tr>
			<tr id="radius2"> 
				<td colspan="2"><input type="button" id="advanced" name="advanced" value="" onClick="show_radius();">
					<script>$('#advanced').val(get_words('_advanced')+">>");</script></td>
				</td>
			</tr>
			<tr id="none_radius2" style="display:none"> 
				<td colspan="2"><input type="button" id="advanced0" name="advanced0" value="" onClick="show_radius();">
					<script>$('#advanced0').val("<<"+get_words('_advanced'));</script></td>
			</tr>
			</table>

			<table id="show_radius2" cellpadding="1" cellspacing="1" border="0" width="525" style="display:none">
			<tr> 
				<input type="hidden" id="wlan0_eap_radius_server_1" name="wlan0_eap_radius_server_1" value="0.0.0.0/1812/">
				<td class="box_msg" colspan="2"><script>show_words('bws_ORAD')</script>:</td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RIPA')</script> :</td>
				<td width="340">&nbsp;
					<input id="radius0_ip2" name="radius0_ip2" maxlength=15 size=15></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RSP')</script> :</td>
				<td width="340">&nbsp;
					<input type="text" id="radius0_port2" name="radius0_port2" size="8" maxlength="5" value="1812"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RSSS')</script> :</td>
				<td width="340">&nbsp;
					<input type="password" id="radius0_pass2" name="radius0_pass2" size="32" maxlength="64"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RMAA')</script> :</td>
				<td width="340">&nbsp;
					<input type="checkbox" id="radius0_auth_mac2" name="radius0_auth_mac2" value="1"></td>
			</tr>
			</table> 
			</div>

			<div class="box">
			<h2><script>show_words('bwl_title_1')</script></h2>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr> 
				<td class="duple"><script>show_words('wwl_band')</script> :</td>
				<td><strong>&nbsp;&nbsp;<script>show_words('GW_WLAN_RADIO_1_NAME')</script></strong></td>
			</tr>
			<tr> 
				<td class="duple"><script>show_words('bwl_EW')</script> :</td>
				<td width="340">&nbsp; <input id="w_enable_1" name="w_enable_1" type="checkbox" value="1" onClick="disable_wireless_1();" checked> 
					<input type="hidden" id="wlan1_enable" name="wlan1_enable" value="1"> 
					<select id="wlan1_schedule_select" name="wlan1_schedule_select" onChange="get_wlan1_schedule(this);">
						<option value="255" selected><script>show_words('_always')</script></option>
						<option value="254"><script>show_words('_never')</script></option>
						<script>document.write(add_option('Schedule'));</script>
					</select> 
					<input name="add_new_schedule2" type="button" class="button_submit" id="add_new_schedule2" onclick="do_add_new_schedule(true)" value=""> 
					<script>$('#add_new_schedule2').val(get_words('dlink_1_add_new'));</script>
				</td>
			</tr>
			<tr style="display:none">
					<td class="duple"><script>show_words('enable_WDS')</script>:</td>
					<td width="340">&nbsp;
						<input type="checkbox" id="enable_wds_a" name="enable_wds_a" value="1" >
					</td>
			</tr>
			<tr> 
				<td class="duple"><script>show_words('bwl_NN')</script> :</td>
				<td width="340">&nbsp;&nbsp;&nbsp; <input name="show_ssid_1" type="text" id="show_ssid_1" size="20" maxlength="32" value="">
					<script>show_words('bwl_AS')</script> </td>
			</tr>
			<tr> 
				<td class="duple"><script>show_words('bwl_Mode')</script> :</td>
				<td width="340">&nbsp;&nbsp;
					<select id="dot11_mode_1" name="dot11_mode_1" onClick="show_chan_width_1();" onChange="show_chan_width_1();">
					</select> <input type="hidden" id="wlan1_dot11_mode" name="wlan1_dot11_mode" value="11na"> 
				</td>
			</tr>
			<tr> 
				<td class="duple"><script>show_words('ebwl_AChan')</script> :</td>
				<td width="340">&nbsp; <input type="checkbox" id="auto_channel_1" name="auto_channel_1" value="1" onClick="disable_channel_1();"> 
					<input type="hidden" id="wlan1_auto_channel_enable" name="wlan1_auto_channel_enable" value="1"> 
				</td>
			</tr>
			<tr> 
				<td class="duple"><script>show_words('_wchannel')</script> :</td>
				<td width="340">&nbsp;&nbsp;
					<select name="sel_wlan1_channel" id="sel_wlan1_channel" onClick="disable_chwidth_1();">
					<script>set_channel_1();</script>
					</select> <input type="hidden" id="wlan1_channel" name="wlan1_channel" value=""> 
				</td>
			</tr>

			<tr id="show_channel_width_1"> 
				<td class="duple"><script>show_words('bwl_CWM')</script> :</td>
				<td width="340">&nbsp;&nbsp;
					<select id="11a_protection" name="11a_protection">
					<option value="0"><script>show_words('bwl_ht20')</script></option>
					<option value="1"><script>show_words('bwl_ht2040')</script></option>
					</select> 
					<input type="hidden" id="wlan1_11n_protection" name="wlan1_11n_protection" value="20"> 
				</td>
			</tr>
			<tr> 
				<td class="duple"><script>show_words('bwl_VS')</script> :</td>
				<td width="340">&nbsp;
					<input type="radio" name="wlan1_ssid_broadcast" value="1">
					<script>show_words('bwl_VS_0')</script> 
					<input type="radio" name="wlan1_ssid_broadcast" value="0">
				<script>show_words('bwl_VS_1')</script> </td>
			</tr>
			</table>
			</div>

			<input type="hidden" id="wlan1_security" name="wlan1_security" value="wpa2auto_psk">
			<input type="hidden" id="asp_temp_53" name="asp_temp_53" value="">
			<input type="hidden" id="asp_temp_54" name="asp_temp_54" value="">
			<input type="hidden" id="asp_temp_55" name="asp_temp_55" value="">
			<input type="hidden" id="asp_temp_56" name="asp_temp_56" value="">

			<div class="box" id="show_security_1"> 
			<h2><script>show_words('bws_WSMode')</script></h2>
			<script>show_words('bws_intro_WlsSec')</script>
			<br><br>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr> 
				<td class="duple"><script>show_words('bws_SM')</script> :</td>
				<td width="340">&nbsp; <select id="wep1_type" name="wep1_type" onChange="show_wpa_wep_1()">
					<option value="0" selected><script>show_words('_none')</script></option>
					<option value="1"><script>show_words('_WEP')</script></option>
					<option value="2"><script>show_words('_WPApersonal')</script></option>
					<option value="3"><script>show_words('_WPAenterprise')</script></option>
				</select> </td>
			</tr>
			</table>
			</div>
			<div class="box" id="show1_wep" style="display:none"> 
			<h2><script>show_words('_WEP')</script></h2>
			<p><script>show_words('bws_msg_WEP_1')</script></p>
			<p><script>show_words('bws_msg_WEP_2')</script></p>
			<p><script>show_words('bws_msg_WEP_3')</script></p>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<input type="hidden" id="wlan1_wep64_key_1" name="wlan1_wep64_key_1" value="">
			<input type="hidden" id="wlan1_wep128_key_1" name="wlan1_wep128_key_1" value="">
			<input type="hidden" id="wlan1_wep64_key_2" name="wlan1_wep64_key_2" value="">
			<input type="hidden" id="wlan1_wep128_key_2" name="wlan1_wep128_key_2" value="">
			<input type="hidden" id="wlan1_wep64_key_3" name="wlan1_wep64_key_3" value="">
			<input type="hidden" id="wlan1_wep128_key_3" name="wlan1_wep128_key_3" value="">
			<input type="hidden" id="wlan1_wep64_key_4" name="wlan1_wep64_key_4" value="">
			<input type="hidden" id="wlan1_wep128_key_4" name="wlan1_wep128_key_4" value="">
			<tr>
				<td class="duple"> <script>show_words('bws_WKL')</script>:</td>
				<td width="340">&nbsp;
					<select id="wep1_key_len" name="wep1_key_len" size=1 onChange="change_wep_key_fun_1();">
					<option value="5"><script>show_words('bws_WKL_0')</script></option>
					<option value="13"><script>show_words('bws_WKL_1')</script></option>
					</select>
				<script>show_words('bws_length')</script> </td>
			</tr>
			<tr id=show_wlan1_wep style="display:none">
				<td class="duple"> <script>show_words('bws_DFWK')</script>:</td>
				<td width="340">&nbsp;
					<select id="wep1_def_key" name="wep1_def_key" onChange="ischeck_wps('wep');">
					<option value="1"><script>show_words('wepkey1')</script></option>
					</select> <input type="hidden" id="wlan1_wep_default_key" name="wlan1_wep_default_key" value=""> 
				</td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('auth')</script>:</td>
				<td width="340">&nbsp;
					<select name="auth1_type" id="auth1_type" onChange="ischeck_wps('auto');">
					<option value="both"><script>show_words('_both')</script></option>
					<option value="share"><script>show_words('bws_Auth_2')</script></option>
				</select> </td>
			</tr>
			<tr>
				<td class="duple"><script>show_words('_wepkey1')</script>:</td>
				<td width="340">&nbsp; <span id="show_resert5"></span> </td>
			</tr>
				<span id="show_resert6"></span>
				<span id="show_resert7"></span>
				<span id="show_resert8"></span>
			</table>
			</div>

			<div class="box" id="show1_wpa" style="display:none"> 
			<h2><script>show_words('_WPA')</script></h2>
			<p><script>show_words('bws_msg_WPA')</script></p>
			<p><script>show_words('bws_msg_WPA_2')</script></p>
			<input type="hidden" id="wlan1_psk_cipher_type" name="wlan1_psk_cipher_type" value="both">
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr>
				<td class="duple"> <script>show_words('bws_WPAM')</script>:</td>
				<td width="340">&nbsp; <select id="wpa1_mode" name="wpa1_mode">
					<option value="auto"><script>show_words('bws_WPAM_2')</script></option>
					<option value="wpa2"><script>show_words('bws_WPAM_3')</script></option>
					<option value="wpa"><script>show_words('bws_WPAM_1')</script></option>
				</select></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_CT')</script>:</td>
				<td width="340">&nbsp;
					<select id="c_type_1" name="c_type_1" onChange="check_wps_psk_eap_1()">
					<option value="tkip"><script>show_words('bws_CT_1')</script></option>
					<option value="aes"><script>show_words('bws_CT_2')</script></option>
					<option value="both"><script>show_words('bws_CT_3')</script></option>
				</select> </td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_GKUI')</script>:</td>
				<td width="340">&nbsp; <input type="text" id="wlan1_gkey_rekey_time" name="wlan1_gkey_rekey_time" size="8" maxlength="5" value="3600">
				<script>show_words('bws_secs')</script></td>
			</tr>
			</table>
			</div>
			<div class="box" id="show1_wpa_psk" style="display:none"> 
			<h2><script>show_words('_psk')</script></h2>
			<p class="box_msg"> 
				<script>show_words('KR18')</script>
				<script>show_words('KR19')</script>
			</p>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr> 
				<td class="duple"><script>show_words('_psk')</script> :</td>
				<td width="340">&nbsp;
				<input type="password" id="wlan1_psk_pass_phrase" name="wlan1_psk_pass_phrase" size="40" maxlength="64" value="3ff2354aa43844bcaf362d91bea167b51c66b629d534a2aac93a288d0032afee"></td>
			</tr>
			</table>
			</div>
			<div class="box" id="show1_wpa_eap" style="display:none"> 
			<h2><script>show_words('bws_EAPx')</script></h2>
			<p class="box_msg"><script>show_words('bws_msg_EAP')</script></p>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr>
				<td class="duple"> <script>show_words('bwsAT_')</script>:</td>
					<input type="hidden" id="wlan1_eap_radius_server_0" name="wlan1_eap_radius_server_0" value="0.0.0.0/1812/">
					<input type="hidden" id="wlan1_eap_mac_auth" name="wlan1_eap_mac_auth" value="3">
				<td width="340">&nbsp; <input id="wlan1_eap_reauth_period" name="wlan1_eap_reauth_period" size=10 value="60">
					<script>show_words('_minutes')</script></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RIPA')</script>:</td>
				<td width="340">&nbsp; <input id="radius1_ip1" name="radius1_ip1" maxlength=15 size=15></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RSP')</script>:</td>
				<td width="340">&nbsp; <input type="text" id="radius1_port1" name="radius1_port1" size="8" maxlength="5" value="1812"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RSSs')</script>:</td>
				<td width="340">&nbsp; <input type="password" id="radius1_pass1" name="radius1_pass1" size="32" maxlength="64"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_RMAA')</script>:</td>
				<td width="340">&nbsp; <input type="checkbox" id="radius1_auth_mac1" name="radius1_auth_mac1" value="1"></td>
			</tr>
			<tr id="radius2_1"> 
				<td colspan="2"><input type="button" id="advanced_1" name="advanced_1" value="" onClick="show_radius_1();">
				<script>$('#advanced_1').val(get_words('_advanced')+">>");</script></td>
			</tr>
			<tr id="none_radius2_1" style="display:none"> 
				<td colspan="2"><input type="button" id="advanced_2" name="advanced_2" value="" onClick="show_radius_1();">
				<script>$('#advanced_2').val("<<"+get_words('_advanced'));</script></td>
			</tr>
			</table>
			<table id="show_radius2_1" cellpadding="1" cellspacing="1" border="0" width="525" style="display:none">
			<tr> 
				<input type="hidden" id="wlan1_eap_radius_server_1" name="wlan1_eap_radius_server_1" value="0.0.0.0/1812/">
				<td class="box_msg" colspan="2"><script>show_words('bws_ORAD')</script>:</td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RIPA')</script>:</td>
				<td width="340">&nbsp; <input id="radius1_ip2" name="radius1_ip2" maxlength=15 size=15></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RSP')</script>:</td>
				<td width="340">&nbsp; <input type="text" id="radius1_port2" name="radius1_port2" size="8" maxlength="5" value="1812"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RSSS')</script>:</td>
				<td width="340">&nbsp; <input type="password" id="radius1_pass2" name="radius1_pass2" size="32" maxlength="64"></td>
			</tr>
			<tr>
				<td class="duple"> <script>show_words('bws_2RMAA')</script>:</td>
				<td width="340">&nbsp; <input type="checkbox" id="radius1_auth_mac2" name="radius1_auth_mac2" value="1"></td>
			</tr>
			</table>
			</div>
		</div>
<!-- End of Silvia add -->
		</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('YM123')</script></p>
			<p><script>show_words('YM124')</script></p>
			<p><script>show_words('YM125')</script></p>
			<p><script>show_words('YM126')</script></p>
			<p class="more"><a href="support_internet.asp#Wireless"><script>show_words('_more')</script>&hellip;</a></p>
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
</script>
</html>
