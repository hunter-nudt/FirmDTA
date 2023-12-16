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
	var cli_mac 	= dev_info.cli_mac;
	var wband		= dev_info.wireless_band;
	var wband_cnt 	=(wband == "dual")?1:0;
	var submit_c	= "";

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};

	param.arg ="oid_1=IGD_&inst_1=1000";
	param.arg +="&oid_2=IGD_ScheduleRule_i_&inst_2=1000";

	//j --> 2.4G or 5G, i --> second inst k, counts --> oid number
	if (wband == "5G") {
		var i = 3;
	} else {
		var i = 1;
	}

	for (var j =0, k =2; j<= wband_cnt; j++)	//, counts =0
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
			param.arg +="&oid_"+(k+7)+"=IGD_WLANConfiguration_i_WPA_PSK_&inst_"+(k+7)+"=1"+i+"10";

			k+=7;
			n++;
			i++;
		}
	}

	param.arg += "&ccp_act=get&num_inst="+k;
	mainObj.get_config_obj(param);
	
	var schedule_cnt = 0;
    var submit_button_flag = 0;
    var radius_button_flag = 0;
	var radius_button_flag_1 = 0;
	var wlan0_enable = 1;
	var wlan1_enable = 1;

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
		'beaconEnab':		mainObj.config_str_multi("wlanCfg_BeaconAdvertisementEnabled_"),
		'chanwidth':		mainObj.config_str_multi("wlanCfg_ChannelWidth_"),
		'standard':			mainObj.config_str_multi("wlanCfg_Standard_"),
		'standard5G':		mainObj.config_str_multi("wlanCfg_Standard5G_"),
		'sMode':			mainObj.config_str_multi("wlanCfg_SecurityMode_"),
		'wdsenable':		mainObj.config_str_multi("wlanCfg_WDSEnable_"),
		'macaddr':			mainObj.config_str_multi("wlanRmMac_MACAddress_"),
		'enableRouting':	mainObj.config_str_multi("wlanCfg_RouteBetweenZone_")
	}

	var EapCfg ={
		'ip':			mainObj.config_str_multi("wpaEap_RadiusServerIP_"),
		'port':			mainObj.config_str_multi("wpaEap_RadiusServerPort_"),
		'psk':			mainObj.config_str_multi("wpaEap_RadiusServerPSK_"),
		'macauth':		mainObj.config_str_multi("wpaEap_MACAuthentication_")
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
		'encrMode':		mainObj.config_str_multi("wpaInfo_EncryptionMode_"),
		'pskKey':		mainObj.config_str_multi("wpaPSK_KeyPassphrase_")
	}

	if(schCfg.name != null)
		schedule_cnt = schCfg.name.length;

    function onPageLoad()
    {
		if (wband == "5G" || wband == "dual")
			$('.5G_use').show();

		set_checked(lanCfg.enable[1], $("#guest_zone_enable0")[0]);
		$("#show0_ssid").val(lanCfg.ssid[1]);
		set_checked(lanCfg.enableRouting[1], $("#guest_select_0")[0]);	//asp_temp_65
		set_selectIndex(lanCfg.schedule[1], $("#wlan0_vap1_schedule_select")[0]);

		if (wband == "5G" || wband == "dual")
		{
			set_checked(lanCfg.enable[3], $("#guest_zone_enable1")[0]);
			$("#show1_ssid").val(lanCfg.ssid[3]);
			set_checked(lanCfg.enableRouting[3], $("#guest_select_1")[0]);	//asp_temp_66
			set_selectIndex(lanCfg.schedule[3], $("#wlan1_vap1_schedule_select")[0]);
			var s_mode1 = (lanCfg.sMode[3]?lanCfg.sMode[3]:"0");	//0->disable, 1->wep, 2->wpa1, 3->wpa2, 4->auto
		}

		var radiusIP = EapCfg.ip;
		var radiusPort = EapCfg.port;
		var radiusPSK = EapCfg.psk;
		var radiusMACAuth = EapCfg.macauth;
		var s_mode0 = (lanCfg.sMode[1]?lanCfg.sMode[1]:"0");	//0->disable, 1->wep, 2->wpa1, 3->wpa2, 4->auto
		var z =2;
		var n =1;

		for (i=0;i<=wband_cnt;i++){
			$('#wlan'+i+'_vap1_eap_reauth_period').val(wpaCfg.infoTimeout[n]?wpaCfg.infoTimeout[n]:"120");
			if(radiusIP && (radiusIP[z]!=null))
				$("#wlan"+i+"_vap1_eap_radius_server_0").val(radiusIP[z]+"/");
			else
				$("#wlan"+i+"_vap1_eap_radius_server_0").val("0.0.0.0/");
				
			if(radiusPort && (radiusPort[z]!=null))
				$("#wlan"+i+"_vap1_eap_radius_server_0")[0].value += radiusPort[z]+"/";
			else
				$("#wlan"+i+"_vap1_eap_radius_server_0")[0].value += "1812/";

			if(radiusPSK && (radiusPSK[z]!=null))
				$("#wlan"+i+"_vap1_eap_radius_server_0")[0].value += radiusPSK[z];

			if(radiusIP && (radiusIP[z+1]!=null))
				$("#wlan"+i+"_vap1_eap_radius_server_1").val(radiusIP[z+1]+"/");
			else
				$("#wlan"+i+"_vap1_eap_radius_server_1").val("0.0.0.0/");

			if(radiusPort && (radiusPort[z+1]!=null))
				$("#wlan"+i+"_vap1_eap_radius_server_1")[0].value += radiusPort[z+1]+"/";
			else
				$("#wlan"+i+"_vap1_eap_radius_server_1")[0].value += "1812/";

			if(radiusPSK && (radiusPSK[z+1]!=null))
				$("#wlan"+i+"_vap1_eap_radius_server_1")[0].value += radiusPSK[z+1];

			var temp_r0 = $("#wlan"+i+"_vap1_eap_radius_server_0").val();
			var Dr0 = temp_r0.split("/");
			if(Dr0.length > 1){
				$("#radius"+i+"_ip1").val(Dr0[0]);
				$("#radius"+i+"_port1").val(Dr0[1]);
				$("#radius"+i+"_pass1").val(Dr0[2]);
			}

			var temp_r1 = $("#wlan"+i+"_vap1_eap_radius_server_1").val();
			var Dr1 = temp_r1.split("/");
			if(Dr1.length > 1){
				$("#radius"+i+"_ip2").val(Dr1[0]);
				$("#radius"+i+"_port2").val(Dr1[1]);
				$("#radius"+i+"_pass2").val(Dr1[2]);
			}

			if(radiusMACAuth && radiusMACAuth[z] == "1")
				$("#radius"+i+"_auth_mac1")[0].checked = true;
			else
				$("#radius"+i+"_auth_mac1")[0].checked = false;

			if(radiusMACAuth && radiusMACAuth[z+1] == "1")
				$("#radius"+i+"_auth_mac2")[0].checked = true;
			else
				$("#radius"+i+"_auth_mac2")[0].checked = false;

			set_selectIndex(wepCfg.infokey[n], $("#wep"+i+"_def_key")[0]);
			var wep_auth_mode = (wepCfg.infoAuthMode[n]?wepCfg.infoAuthMode[n]:"0");	//0->open, 1->psk
			var wep_key_len = (wepCfg.infoKeyL[n]?wepCfg.infoKeyL[n]:"0");	//0->64, 1->128
			var wpa_auth_mode = (wpaCfg.infoAuthMode[n]?wpaCfg.infoAuthMode[n]:"0");
			var s_mode = ((i == 0)?s_mode0:s_mode1);	//0->disable, 1->wep, 2->wpa1, 3->wpa2, 4->auto

			if(s_mode == "0")
				$("#wlan"+i+"_vap1_security").val("disable");
			else if(s_mode == "1")	//wep
			{
				$("#wlan"+i+"_vap1_security").val("wep_");
				if(wep_auth_mode == "0")
					$("#wlan"+i+"_vap1_security")[0].value += "open_";
				else if(wep_auth_mode == "1")
					$("#wlan"+i+"_vap1_security")[0].value += "share_";
				else
					$("#wlan"+i+"_vap1_security")[0].value += "both_";

				if(wep_key_len == "0")
					$("#wlan"+i+"_vap1_security")[0].value += "64";
				else if(wep_key_len == "1")
					$("#wlan"+i+"_vap1_security")[0].value += "128";
			}
			else if(s_mode == "2")	//wpa1
			{
				$("#wlan"+i+"_vap1_security").val("wpa_");
				if(wpa_auth_mode == "0")
					$("#wlan"+i+"_vap1_security")[0].value += "psk";
				else
					$("#wlan"+i+"_vap1_security")[0].value += "eap";
			}
			else if(s_mode == "3")	//wpa2
			{
				$("#wlan"+i+"_vap1_security").val("wpa2_");
				if(wpa_auth_mode == "0")
					$("#wlan"+i+"_vap1_security")[0].value += "psk";
				else
					$("#wlan"+i+"_vap1_security")[0].value += "eap";
			}
			else if(s_mode == "4")	//wpa2auto
			{
				$("#wlan"+i+"_vap1_security").val("wpa2auto_");
				if(wpa_auth_mode == "0")
					$("#wlan"+i+"_vap1_security")[0].value += "psk";
				else
					$("#wlan"+i+"_vap1_security")[0].value += "eap";
			}

			var wlan0_security= $('#wlan0_vap1_security').val();
			var security0 = wlan0_security.split("_");
			var wlan1_security= $('#wlan1_vap1_security').val();
			var security1 = wlan1_security.split("_");
			var security = ((i == 0)?security0:security1);
			var wlan_security = ((i == 0)?wlan0_security:wlan1_security);

			if(wlan_security == "disable"){
				set_selectIndex(0, $("#wep"+i+"_type")[0]);
			}else if(security[0] == "wep"){
				$("#show"+i+"_wep").show();
				set_selectIndex(1, $("#wep"+i+"_type")[0]);
				set_selectIndex(security[1], $("#auth"+i+"_type")[0]);
				if(security[2] == "64"){
					set_selectIndex(5, $("#wep"+i+"_key_len")[0]);
				}else{
					set_selectIndex(13, $("#wep"+i+"_key_len")[0]);
				}
			}else{
				if(security[1] == "psk"){					//PSK
					$("#show"+i+"_wpa_psk").show();
					set_selectIndex(2, $("#wep"+i+"_type")[0]);
				}else if(security[1] == "eap"){				//EAP
					$("#show"+i+"_wpa_eap").show();
					set_selectIndex(3, $("#wep"+i+"_type")[0]);
				}
				//set wpa_mode
				if(security[0] == "wpa2auto"){
					$("#show"+i+"_wpa").show();
					set_selectIndex(2, $("#wpa"+i+"_mode")[0]);
				}else{
					$("#wpa"+i+"_mode").val(security[0]);
				}
			}

			$("#wpa"+i+"_mode")[0].selectedIndex = wpaCfg.infoMode[n];
			var k = ((i == 0)?4:12);
			for(var j=1; j<=4; j++)
			{
				if(wepCfg.key64)
					$("#wlan"+i+"_vap1_wep64_key_"+j).val(wepCfg.key64[k]);
				else
					$("#wlan"+i+"_vap1_wep64_key_"+j).val("0000000000");

				if(wepCfg.key128)
					$("#wlan"+i+"_vap1_wep128_key_"+j).val(wepCfg.key128[k]);
				else
					$("#wlan"+i+"_vap1_wep128_key_"+j).val("00000000000000000000000000");
				k+=1;
			}
			$('#wlan'+i+'_vap1_psk_pass_phrase').val(wpaCfg.pskKey[n]?wpaCfg.pskKey[n]:"00000000");
			$('#wlan'+i+'_vap1_gkey_rekey_time').val(wpaCfg.infoKeyup[n]?wpaCfg.infoKeyup[n]:"3600");
			$('#c_type_'+i)[0].selectedIndex = wpaCfg.encrMode[n];
			z +=4;
			n +=2;
		}

		var login_who= login_Info;
		if(login_who!= "w"){
			DisableEnableForm(form1,true);	
		}else{
			change_wep_key_fun();
			disable_wireless_0();

			if (wband == "5G" || wband == "dual")
			{
				disable_wireless_1();
				change_wep_key_fun_1();
			}
		}
		set_form_default_values("form1");
    }
	
	function change_wep_key_fun(){
		var length = parseInt($("#wep0_key_len").val()) * 2;
		var key_length_0 = $("#wep0_key_len")[0].selectedIndex;
		var key_type = $("#wlan0_vap1_wep_display").val();

		var key1 = $("#wlan0_vap1_wep" + key_num_array[key_length_0] + "_key_1").val();
		var key2 = $("#wlan0_vap1_wep" + key_num_array[key_length_0] + "_key_2").val();
		var key3 = $("#wlan0_vap1_wep" + key_num_array[key_length_0] + "_key_3").val();
		var key4 = $("#wlan0_vap1_wep" + key_num_array[key_length_0] + "_key_4").val();

		$("#show_resert1").html("<input type=\"password\" id=\"key1\" name=\"key1\" maxlength=" + length + " size=\"31\" value=" + key1 + " >");
		$("#show_resert2").html("<input type=\"password\" id=\"key2\" name=\"key2\" maxlength=" + length + " size=\"31\" value=" + key2 + " >");
		$("#show_resert3").html("<input type=\"password\" id=\"key3\" name=\"key3\" maxlength=" + length + " size=\"31\" value=" + key3 + " >");
		$("#show_resert4").html("<input type=\"password\" id=\"key4\" name=\"key4\" maxlength=" + length + " size=\"31\" value=" + key4 + " >");
	}

	function change_wep_key_fun_1(){
		var length_1 = parseInt($("#wep1_key_len").val()) * 2;
		var key_length_1 = $("#wep1_key_len")[0].selectedIndex;
		var key_type_1 = $("#wlan1_vap1_wep_display").val();
		var key5 = $('#wlan1_vap1_wep' + key_num_array[key_length_1] + '_key_1').val();
		var key6 = $('#wlan1_vap1_wep' + key_num_array[key_length_1] + '_key_2').val();
		var key7 = $('#wlan1_vap1_wep' + key_num_array[key_length_1] + '_key_3').val();
		var key8 = $('#wlan1_vap1_wep' + key_num_array[key_length_1] + '_key_4').val();
		$('#show_resert5').html("<input type=\"password\" id=\"key5\" name=\"key5\" maxlength=" + length_1 + " size=\"31\" value=" + key5 + " >");
		$('#show_resert6').html("<input type=\"hidden\" id=\"key6\" name=\"key6\" maxlength=" + length_1 + " size=\"31\" value=" + key6 + " >");
		$('#show_resert7').html("<input type=\"hidden\" id=\"key7\" name=\"key7\" maxlength=" + length_1 + " size=\"31\" value=" + key7 + " >");
		$('#show_resert8').html("<input type=\"hidden\" id=\"key8\" name=\"key8\" maxlength=" + length_1 + " size=\"31\" value=" + key8 + " >");
	}

    function check_8021x()
    {
        var ip1 = $("#radius0_ip1").val();
        var ip2 = $("#radius0_ip2").val();

        var radius1_msg = replace_msg(all_ip_addr_msg,get_words('RADIUS_SERVER1_IP_DESC', LangMap.msg));
        var radius2_msg = replace_msg(all_ip_addr_msg,get_words('RADIUS_SERVER2_IP_DESC', LangMap.msg));

        var temp_ip1 = new addr_obj(ip1.split("."), radius1_msg, false, false);
        var temp_ip2 = new addr_obj(ip2.split("."), radius2_msg, true, false);
        var temp_radius1 = new raidus_obj(temp_ip1, $("#radius0_port1").val(), $("#radius0_pass1").val());
        var temp_radius2 = new raidus_obj(temp_ip2, $("#radius0_port2").val(), $("#radius0_pass2").val());

        if (!check_radius(temp_radius1))
            return false;
        else if (ip2 != "" && ip2 != "0.0.0.0")
		{
            if (!check_radius(temp_radius2))
                return false;
        }
        return true;
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

    function check_psk()
    {
        var psk_value = $("#wlan0_vap1_psk_pass_phrase").val();
        if (psk_value.length < 8) {
            alert(get_words('YM116'));
            return false;
        }
        else if (psk_value.length > 63) {
            if (!isHex(psk_value)) {
                alert(get_words('GW_WLAN_WPA_PSK_HEX_STRING_INVALID'));
                return false;
            }
        }
        return true;
    }

    function show_wpa_wep()
    {
        var wep_type = $("#wep0_type").val();
        $("#show0_wep").hide();
        $("#show0_wpa").hide();
        $("#show0_wpa_psk").hide();
        $("#show0_wpa_eap").hide();

        if (wep_type == 1) {         //WEP
            $("#show0_wep").show();
        }
        else if (wep_type == 2) {    //WPA-Personal
            $("#show0_wpa").show();
            $("#show0_wpa_psk").show();
        }
        else if (wep_type == 3) {    //WPA-Enterprise
			$("#show0_wpa").show();
			$("#show0_wpa_eap").show();
        }
    }

    function disable_wireless_0()
    {
        var is_disable = false;

        if (($("#wlan0_enable").val() == "0") || (!$("#guest_zone_enable0")[0].checked))
            is_disable = true;

        if ($("#wlan0_enable").val() == "0")
            $("#guest_zone_enable0").attr('disabled', true);

        $("#wlan0_vap1_schedule_select").attr('disabled', is_disable);
        $("#add_new_schedule").attr('disabled', is_disable);
        $("#show0_ssid").attr('disabled', is_disable);
        $("#guest_select_0").attr('disabled', is_disable);

        if (is_disable) {
		    $("#show_wlan0_wep").hide();
            $("#show0_wep").hide();
            $("#show0_wpa").hide();
            $("#show0_wpa_psk").hide();
            $("#show0_wpa_eap").hide();
        }
        else {
        	$("#show_wlan0_wep").show();
        	show_wpa_wep();
        }
    }

    function show_radius()
    {
        $("#radius2").hide();
        $("#none_radius2").hide();
        $("#show0_radius2").hide();

        if (radius_button_flag) {
            $("#radius2").show();
            radius_button_flag = 0;
        }
        else {
            $("#none_radius2").show();
            $("#show0_radius2").show();
            radius_button_flag = 1;
        }
    }

    function send_key_value(key_length_0)
    {
        //var key_type = $("#wlan0_vap1_wep_display").val();

        for (var i = 1; i < 5; i++) {
            $("#wlan0_vap1_wep" + key_length_0 + "_key_" + i).val($("#key" + i).val());
        }
    }

    function send_cipher_value()
    {
        if ($("#c_type_0")[0].selectedIndex == 0)
			$("#wlan0_vap1_psk_cipher_type").val("tkip");
        else if ($("#c_type_0")[0].selectedIndex == 1)
            $("#wlan0_vap1_psk_cipher_type").val("aes");
        else
            $("#wlan0_vap1_psk_cipher_type").val("both");
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

    function check_schedule(i)
    {
		//20120228 silvia modify add chk 5g sch
		var host_sched_name = (i==0)?lanCfg.schedule[0]:lanCfg.schedule[2];
		var guest_sched_name = (i==0)?$("#wlan0_vap1_schedule_select").val():$("#wlan1_vap1_schedule_select").val();
		var lan_enable = (i==0)?lanCfg.enable[0]:lanCfg.enable[2];
		var gz_enable = (i==0)?$("#guest_zone_enable0")[0]:$("#guest_zone_enable1")[0];

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
		
		if ((lan_enable == "0") || (gz_enable == "0")) {
			return 0;
		}

		if ((host_sched_name == "255") ||(guest_sched_name == "254")) {
			return 0;
		}

		var host_idx = get_schedule_array_index_by_value(host_sched_name);
		var guest_idx = get_schedule_array_index_by_value(guest_sched_name);

		if(host_sched_name == "255")
			host_weekdays = 127;//1111111;
		else if(host_sched_name == "254")
			host_weekdays = 0;//0000000;
		else if(schCfg.allweek[host_idx] == "1")
			host_weekdays = 127;//1111111;
		else
			host_weekdays = parseInt(schCfg.weekday[host_idx],2);

		if(host_sched_name == "255")
		{
			host_start_hour = 0;
			host_start_min = 0;
			host_end_hour = 23;
			host_end_min = 59;
		}
		else if(host_sched_name == "254")
		{
			host_start_hour = 0;
			host_start_min = 0;
			host_end_hour = 0;
			host_end_min = 0;
		}
		else if(schCfg.allday[host_idx] == "1")
		{
			host_start_hour = 0;
			host_start_min = 0;
			host_end_hour = 23;
			host_end_min = 59;
		}
		else
		{
			host_start_hour = parseInt(schCfg.start_h[host_idx]);
			host_start_min = parseInt(schCfg.start_m[host_idx]);
			host_end_hour = parseInt(schCfg.end_h[host_idx]);
			host_end_min = parseInt(schCfg.end_m[host_idx]);
		}

		//config guest schedule
		if(guest_sched_name == "255")
			guest_weekdays = 127;//1111111;
		else if(guest_sched_name == "254")
			guest_weekdays = 0;//0000000;
		else if(schCfg.allweek[guest_idx] == "1")
			guest_weekdays = 127;//1111111;
		else
			guest_weekdays = parseInt(schCfg.weekday[guest_idx],2);

		if(guest_sched_name == "255")
		{
			guest_start_hour = 0;
			guest_start_min = 0;
			guest_end_hour = 23;
			guest_end_min = 59;
		}
		else if(guest_sched_name == "254")
		{
			guest_start_hour = 0;
			guest_start_min = 0;
			guest_end_hour = 0;
			guest_end_min = 0;
		}
		else if(schCfg.allday[guest_idx] == "1")
		{
			guest_start_hour = 0;
			guest_start_min = 0;
			guest_end_hour = 23;
			guest_end_min = 59;
		}
		else
		{
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
		if (wband == "5G" || wband == "dual")
		{
			if((lanCfg.enable[0] == 0 && lanCfg.enable[2] == 0)
				&& ( get_checked_value($('#guest_zone_enable0')[0]) == 1 || get_checked_value($('#guest_zone_enable1')[0]) == 1))
			{
				alert(get_words('KR16')+', '+get_words('KR17')+ ' '+ get_words('wifi_enable_chk'));
				 return false;
			}
			if((lanCfg.enable[0] == 0) && (get_checked_value($('#guest_zone_enable0')[0]) == 1))
			{
				alert(get_words('KR16')+' '+get_words('wifi_enable_chk'));
				 return false;
			}
			if((lanCfg.enable[2] == 0) && (get_checked_value($('#guest_zone_enable1')[0]) == 1))
			{
				alert(get_words('KR17')+' '+get_words('wifi_enable_chk'));
				 return false;
			}
		}else if (wband == "2.4G")
		{
			if((lanCfg.enable[0] == 0) && (get_checked_value($('#guest_zone_enable0')[0]) == 1))
			{
				alert(get_words('wifi_enable_chk'));
				 return false;
			}
		}

		for (var i = 0;i<=wband_cnt;i++)
		{
			var keys = ((i==0)?$("#key1").val():$("#key5").val());
			if ($('#wep'+i+'_key_len')[0].selectedIndex == 0)
				$('#wlan'+i+'_vap1_wep64_key_1').val(keys);
			else
				$('#wlan'+i+'_vap1_wep128_key_1').val(keys);
		}

        if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
            return false;

        var wlan0_dot11_mode = lanCfg.standard[1];
        var wep_type_value_0 = $("#wep0_type").val();
        var key_length_0 =$("#wep0_key_len")[0].selectedIndex;
        var c_type_value_0 = $("#c_type_0").val();
        var rekey_msg = replace_msg(check_num_msg, get_words('bws_GKUI'), 30, 65535);
        var temp_rekey_0 = new varible_obj($("#wlan0_vap1_gkey_rekey_time").val(), rekey_msg, 30, 65535, false);

		if(!(check_ssid_0("show0_ssid")))
				return false;
		if(!check_ascii($('#show0_ssid').val())){
			alert(get_words("ssid_ascii_range"));
			return false;
		}
		if(!(ischeck_wps("auto")))
				return false;
		
		/***	5G site		***/
		if (wband == "5G" || wband == "dual")
		{
			var wlan1_dot11_mode = lanCfg.standard5G[3];
			var wep_type_value_1 = $("#wep1_type").val();
			var key_length_1 =$("#wep1_key_len")[0].selectedIndex;
			var c_type_value_1 = $("#c_type_1").val();
			var temp_rekey_1 = new varible_obj($("#wlan1_vap1_gkey_rekey_time").val(), rekey_msg, 30, 65535, false);

			if(!(check_ssid_0("show1_ssid")))
					return false;
			if(!check_ascii($('#show1_ssid').val())){
				alert(get_words("ssid_ascii_range"));
				return false;
			}
		}
		if((get_checked_value($('#guest_zone_enable0')[0]) == 1) || (get_checked_value($('#guest_zone_enable1')[0]) == 1))
    	{
			var index;
			if((get_checked_value($('#guest_zone_enable0')[0]) == 1) && (get_checked_value($('#guest_zone_enable1')[0]) == 1))
				index=0;
			else
				get_checked_value($('#guest_zone_enable1')[0]) == 1?(index=1):(index=0);
			for (var i=index;i<=wband_cnt;i++)
			{
				var wep_type_value = ((i==0)?wep_type_value_0:wep_type_value_1);
				var wlan_dot11_mode = ((i==0)?wlan0_dot11_mode:wlan1_dot11_mode);
				var c_type_value = ((i==0)?c_type_value_0:c_type_value_1);
				var temp_rekey = ((i==0)?temp_rekey_0:temp_rekey_1);
				var select_dot = ((i==0)?"2":"0");

				if (wep_type_value == 1) {        //WEP
					if (wlan_dot11_mode == select_dot) {
						alert(get_words('MSG044'));
						return false;
					}
					if (i==0){
						if (!check_vap1_key())
							return false;
					}else{
						if (!check_vap1_key_1())
							return false;
					}
				}
				else if(wep_type_value == 2) {  //PSK
					if ((wlan_dot11_mode == select_dot) && (c_type_value == "tkip")) {
						alert(get_words('MSG045'));
						return false;
					}
					if (!check_varible(temp_rekey))
						return false;
					if (i==0){
						if (!check_psk())
							return false;
					}else{
						if (!check_psk_1())
							return false;
					}
				}
				else if (wep_type_value == 3) {  //EAP
					if ((wlan_dot11_mode == select_dot) && (c_type_value == "tkip")) {
						alert(get_words('MSG045'));
						return false;
					}
					if (!check_varible(temp_rekey))
						return false;
					if (i==0){
						if (!check_8021x())
							return false;
					}else{
						if (!check_8021x_1())
							return false;
					}
				}
				//save wireless network setting
				$("#wlan"+i+"_vap1_enable").val(get_checked_value($("#guest_zone_enable"+i)[0]));
				if (i==0)
					$("#asp_temp_65").val(get_checked_value($("#guest_select_0")[0]));
				else
					$("#asp_temp_66").val(get_checked_value($("#guest_select_1")[0]));
				if (get_checked_value($("#guest_select_"+i)[0]) == "0")
					$("#wlan"+i+"_vap_guest_zone").val(1);
				else
					$("#wlan"+i+"_vap_guest_zone").val(0);
				$("#wlan"+i+"_vap1_wep_default_key").val($("#wep"+i+"_def_key").val());
					
				var wpa_mode = $("#wpa"+i+"_mode").val();

				//save security
				if (wep_type_value == 1) {//WEP
				
					if (i==0){	//save wep key
						$("#wlan0_vap1_security").val("wep_"+ $("#auth0_type").val() + "_" + key_num_array[key_length_0]);
						send_key_value(key_num_array[key_length_0]);
					}else{
						$("#wlan1_vap1_security").val("wep_"+ $("#auth1_type").val() + "_" + key_num_array[key_length_1]);
						send_key_value_1(key_num_array[key_length_1]);
					}
					Format_WEP(i);
				}
				else if (wep_type_value == 2) {//PSK
					if (wpa_mode == "auto")
						$("#wlan"+i+"_vap1_security").val("wpa2auto_psk");
					else
						$("#wlan"+i+"_vap1_security").val(wpa_mode + "_psk");
					if (i == 0)
						send_cipher_value();
					else
						send_cipher_value_1();
					Format_WPA(i);
				}
				else if (wep_type_value == 3) {      //EAP
					if (wpa_mode == "auto")
						$("#wlan"+i+"_vap1_security").val("wpa2auto_eap");
					else
						$("#wlan"+i+"_vap1_security").val(wpa_mode + "_eap");

					//save radius server
					var r_ip_0 = $('#radius'+i+'_ip1').val();
					var r_port_0 = $('#radius'+i+'_port1').val();
					var r_pass_0 = $('#radius'+i+'_pass1').val();
					var dat0 =r_ip_0 +"/"+ r_port_0 +"/"+ r_pass_0;
					$('#wlan'+i+'_vap1_eap_radius_server_0').val(dat0);

					if (i == 0){
						send_cipher_value();
						if(radius_button_flag){
							var r_ip_1 = $('#radius0_ip2').val();
							var r_port_1 = $('#radius0_port2').val();
							var r_pass_1 = $('#radius0_pass2').val();
							var dat1 =r_ip_1 +"/"+ r_port_1 +"/"+ r_pass_1;
							$('#wlan0_vap1_eap_radius_server_1').val(dat1);
						}
						Format_WPA(i);
					}else{
						send_cipher_value_1();
						if(radius_button_flag_1){
							var r_ip_1 = $('#radius1_ip2').val();
							var r_port_1 = $('#radius1_port2').val();
							var r_pass_1 = $('#radius1_pass2').val();
							var dat1 =r_ip_1 +"/"+ r_port_1 +"/"+ r_pass_1;
							$('#wlan1_vap1_eap_radius_server_1').val(dat1);
						}
						Format_WPA(i);
					}
					if(($('#radius'+i+'_auth_mac1')[0].checked == false) && ($('#radius'+i+'_auth_mac2')[0].checked == false))
						$('#wlan'+i+'_vap1_eap_mac_auth').val(0);
					else if(($('#radius'+i+'_auth_mac1')[0].checked == true) && ($('#radius'+i+'_auth_mac2')[0].checked == false))
						$('#wlan'+i+'_vap1_eap_mac_auth').val(1);
					else if(($('#radius'+i+'_auth_mac1')[0].checked == false) && ($('#radius'+i+'_auth_mac2')[0].checked == true))
						$('#wlan'+i+'_vap1_eap_mac_auth').val(2);
					else
						$('#wlan'+i+'_vap1_eap_mac_auth').val(3);
				}else{								//DISABLED
					$("#wlan0_vap1_security").val("disable");
				}

				if (check_schedule(i) == -1) {
					alert(get_words('MSG049'));
					return false;
				}
			}
			// 20121221 moa fixed no warning on none-security mode
			if (($('#wep0_type').val() == 0) && (get_checked_value($('#guest_zone_enable0')[0]) == 1) || 
				($('#wep1_type').val() == 0) && (get_checked_value($('#guest_zone_enable1')[0]) == 1))
			{
				alert(get_words('msg_non_sec'));
			}
		}
        if (submit_button_flag == 0) {
            submit_button_flag = 1;
            $("#wlan0_vap1_ssid").val($("#show0_ssid").val());
			if (wband == "5G" || wband == "dual")
				$("#wlan1_vap1_ssid").val($("#show1_ssid").val());
			submit_All();
            return true;
        }
        return false;
    }

	//2011.11.29 5G Silvia
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
			 $('#show1_wpa').show();
			 $('#show1_wpa_psk').show();
		}else if(wep_type == 3){
			 $('#show1_wpa').show();
			 $('#show1_wpa_eap').show();
		}
	}

	function disable_wireless_1()
	{
		var is_disable = false;

		var aa = $("#wlan1_enable").val();
		var cc = $("#guest_zone_enable1")[0].checked;
        if (($("#wlan1_enable").val() == "0") || (!$("#guest_zone_enable1")[0].checked))
            is_disable = true;

        if ($("#wlan1_enable").val() == "0")
            $("#guest_zone_enable1").attr('disabled', true);
		
        $("#wlan1_vap1_schedule_select").attr('disabled', is_disable);
        $("#add_new_schedule2").attr('disabled', is_disable);
        $("#show1_ssid").attr('disabled', is_disable);
        $("#guest_select_1").attr('disabled', is_disable);

        if (is_disable) {
		    $("#show_wlan1_wep").hide();
            $("#show1_wep").hide();
            $("#show1_wpa").hide();
            $("#show1_wpa_psk").hide();
            $("#show1_wpa_eap").hide();
        }
        else {
        	$("#show_wlan1_wep").show();
        	show_wpa_wep_1();
		}
	}

	function send_key_value_1(key_length_1)
	{
		//var key_type = $("#wlan1_vap1_wep_display").val();
		for(var i = 1; i < 5; i++){
			$("#wlan1_vap1_wep" + key_length_1 + "_key_" + i).val($("#key" + (i+4)).val());
		}
	}

	function send_cipher_value_1()
	{
		if($('#c_type_1')[0].selectedIndex == 0)
			$('#wlan1_vap1_psk_cipher_type').val("tkip");
		else if($('#c_type_1')[0].selectedIndex == 1)
			$('#wlan1_vap1_psk_cipher_type').val("aes");
		else
			$('#wlan1_vap1_psk_cipher_type').val("both");
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
		var psk_value = $('#wlan1_vap1_psk_pass_phrase').val();
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
		$('#show1_radius2').hide();
		if(radius_button_flag_1){
			$('#radius2_1').show();
			radius_button_flag_1 = 0;
		}else{
			$('#none_radius2_1').show();
			$('#show1_radius2').show();
			radius_button_flag_1 = 1;
		}
	}

	/*
	**	Date:	2013-06-07
	**	Author:	Silvia Chang
	**	Reason:	Fixed [10]wep-share should not pop WPS disable message for wireless guest zone
	**			No need check WPS in guset zone
	**/
	function ischeck_wps(obj)
	{
		if ($("#auth0_type").val() == "share" && obj == "auto")
			set_selectIndex("open", $("#auth0_type")[0]);
		return true;
	}

    function do_add_new_schedule()
    {
        window.location.href = "tools_schedules.asp";
    }

    function get_wlan0_vap1_schedule(obj)
    {
        var tmp_schedule = obj.options[obj.selectedIndex].value;
        var schedule_val;
        var tmp_schedule_index = obj.selectedIndex;

        $("#wlan0_vap1_schedule").val(tmp_schedule);
    }

    function get_wlan1_vap1_schedule(obj)
    {
        var tmp_schedule = obj.options[obj.selectedIndex].value;
        var schedule_val;
        var tmp_schedule_index = obj.selectedIndex;

        $("#wlan1_vap1_schedule").val(tmp_schedule);
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
		var ins = 2;
		var submitObj = new ccpObject();
		var paramForm = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=guest_zone.asp'
		};

		for(var i=0; i<=wband_cnt;)
		{
			paramForm.arg += "&wlanCfg_Enable_1."+ins+".0.0="+get_checked_value($('#guest_zone_enable'+i)[0]);
			paramForm.arg += "&wlanCfg_ScheduleIndex_1."+ins+".0.0="+$('#wlan'+i+'_vap1_schedule_select').val();
			paramForm.arg += "&wlanCfg_SSID_1."+ins+".0.0="+urlencode($('#show'+i+'_ssid').val());
			paramForm.arg += "&wlanCfg_SecurityMode_1."+ins+".0.0="+$('#wep'+i+'_type')[0].selectedIndex;
			paramForm.arg += "&wlanCfg_RouteBetweenZone_1."+(ins-1)+".0.0="+get_checked_value($('#guest_select_'+i)[0]);
			paramForm.arg += "&wlanCfg_RouteBetweenZone_1."+ins+".0.0="+get_checked_value($('#guest_select_'+i)[0]);
			i++;
			ins+=4;
		}
		paramForm.arg += submit_c;
		submitObj.get_config_obj(paramForm);
	}

	function Format_WEP(j)
	{
		var ins = ((j==0)?2:6);
		var WEP="";
		if($('#auth'+j+'_type').val() == "both")
			WEP += "&wepInfo_AuthenticationMode_1."+ins+".1.0=2"
		else
			WEP += "&wepInfo_AuthenticationMode_1."+ins+".1.0=1"

		WEP += "&wepInfo_KeyType_1."+ins+".1.0=0";	//always be HEX in this model
		WEP += "&wepInfo_KeyLength_1."+ins+".1.0="+$('#wep'+j+'_key_len')[0].selectedIndex;
		WEP += "&wepInfo_KeyIndex_1."+ins+".1.0="+$('#wep'+j+'_def_key').val();
			
		for(var i=1; i<=4; i++)
		{
			WEP += "&wepKey_KeyHEX64_1."+ins+".1."+i+"="+ $('#wlan'+j+'_vap1_wep64_key_'+i).val();
			WEP += "&wepKey_KeyHEX128_1."+ins+".1."+i+"="+ $('#wlan'+j+'_vap1_wep128_key_'+i).val();
		}
		submit_c += WEP;
	}

	function Format_WPA(j)
	{
		var flag = ((j==0)?radius_button_flag:radius_button_flag_1);
		var ins = ((j==0)?2:6);
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

		WPA += "&wpaInfo_KeyUpdateInterval_1."+ins+".1.0="+ $('#wlan'+j+'_vap1_gkey_rekey_time').val();
		WPA += "&wpaInfo_AuthenticationTimeout_1."+ins+".1.0="+$('#wlan'+j+'_vap1_eap_reauth_period').val();
		WPA += "&wpaPSK_KeyPassphrase_1."+ins+".1.1="+ urlencode($('#wlan'+j+'_vap1_psk_pass_phrase').val());
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
			<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b14');</script>
		</td>
		<!-- end of left menu -->

		<input type="hidden" id="wlan0_enable" name="wlan0_enable" value=''>
		<input type="hidden" id="wlan1_enable" name="wlan1_enable" value=''>
		<input type="hidden" id="wlan0_schedule" name="wlan0_schedule" value=''>

	<form id="form1" name="form1" method="post" action="">
		<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
		<input type="hidden" id="html_response_message" name="html_response_message" value="">
		<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
		<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="guest_zone.asp">
		<input type="hidden" id="reboot_type" name="reboot_type" value="wireless">
		<input type="hidden" id="wlan0_vap1_ssid" name="wlan0_vap1_ssid" value=''>
		<input type="hidden" id="wlan1_vap1_ssid" name="wlan1_vap1_ssid" value=''>
		<input type="hidden" id="wlan0_vap1_wep_display" name="wlan0_vap1_wep_display" value='");'>
		<input type="hidden" id="wlan1_vap1_wep_display" name="wlan1_vap1_wep_display" value=''>
		<input type="hidden" id="wlan0_vap1_schedule" name="wlan0_vap1_schedule" value=''>
		<input type="hidden" id="wlan1_vap1_schedule" name="wlan1_vap1_schedule" value=''>

		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
		<div id="maincontent">
			<div id="box_header">
				<h1><script>show_words('_guestzone')</script></h1>
				<script>show_words('guestzone_Intro_1')</script><br><br>
				<input name="button" id="button" type="button" class="button_submit" onclick="send_request()">
				<input name="button2" id="button2" type="button" class="button_submit" onclick="page_cancel('form1', 'guest_zone.asp');">
				<script>$("#button").val(get_words('_savesettings'));</script>
				<script>$("#button2").val(get_words('_dontsavesettings'));</script>
			</div>

			<div class="box">
				<h2><script>show_words('guestzone_title_1')</script></h2>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple"><script>show_words('guestzone_enable')</script> :</td>
					<td>&nbsp;&nbsp;<input name="guest_zone_enable0" id="guest_zone_enable0" type="checkbox" value="1" onClick="disable_wireless_0();">
						<input type="hidden" id="wlan0_vap1_enable" name="wlan0_vap1_enable" value=''>
						<select id="wlan0_vap1_schedule_select" name="wlan0_vap1_schedule_select" onChange="get_wlan0_vap1_schedule(this);">
							<option value="255" selected><script>show_words('_always')</script></option>
							<option value="254"><script>show_words('_never')</script></option>
							<script>document.write(add_option('Schedule'));</script>
						</select>
						<input name="add_new_schedule" type="button" class="button_submit" id="add_new_schedule" onclick="do_add_new_schedule(true)" value="">
						<script>$("#add_new_schedule").val(get_words('dlink_1_add_new'));</script>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('wwl_band')</script> :</td>
					<td>&nbsp;&nbsp;<strong><script>show_words('GW_WLAN_RADIO_0_NAME')</script></strong></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bwl_NN')</script> :</td>
					<td width="340">&nbsp;&nbsp;<input name="show0_ssid" type="text" id="show0_ssid" size="20" maxlength="32" value="">
					<script>show_words('bwl_AS')</script> </td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('S473')</script> :</td>
					<td>&nbsp;&nbsp;<input name="guest_select_0" id="guest_select_0" type="checkbox"  value="1">
					<input type="hidden" id="wlan0_vap_guest_zone" name="wlan0_vap_guest_zone" value=''>
					<input type="hidden" id="asp_temp_65" name="asp_temp_65" value=''></td>
				</tr>
				</table>

				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr id="show_wlan0_wep">
					<td class="duple"><script>show_words('bws_SM')</script> :</td>
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

			<input type="hidden" id="wlan0_vap1_security" name="wlan0_vap1_security" value=''>
			<div class="box" id="show0_wep" style="display:none">
				<h2><script>show_words('_WEP')</script></h2>
				<p><script>show_words('bws_msg_WEP_1')</script></p>
				<p><script>show_words('bws_msg_WEP_2')</script></p>
				<p><script>show_words('bws_msg_WEP_3')</script></p>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
					<input type="hidden" id="wlan0_vap1_wep64_key_1" name="wlan0_vap1_wep64_key_1" >
					<input type="hidden" id="wlan0_vap1_wep128_key_1" name="wlan0_vap1_wep128_key_1" >
					<input type="hidden" id="wlan0_vap1_wep64_key_2" name="wlan0_vap1_wep64_key_2" value=''>
					<input type="hidden" id="wlan0_vap1_wep128_key_2" name="wlan0_vap1_wep128_key_2" value=''>
					<input type="hidden" id="wlan0_vap1_wep64_key_3" name="wlan0_vap1_wep64_key_3" value=''>
					<input type="hidden" id="wlan0_vap1_wep128_key_3" name="wlan0_vap1_wep128_key_3" value=''>
					<input type="hidden" id="wlan0_vap1_wep64_key_4" name="wlan0_vap1_wep64_key_4" value=''>
					<input type="hidden" id="wlan0_vap1_wep128_key_4" name="wlan0_vap1_wep128_key_4" value=''>
					<tr>
						<td class="duple"><script>show_words('bws_WKL')</script> :</td>
						<td width="340">&nbsp;
							<select id="wep0_key_len" name="wep0_key_len" size=1 onChange="change_wep_key_fun();">
								<option value="5"><script>show_words('bws_WKL_0')</script></option>
								<option value="13"><script>show_words('bws_WKL_1')</script></option>
							</select>
							<script>show_words('bws_length')</script>
						</td>
					</tr>
					<tr style="display:none">
						<td class="duple"><script>show_words('bws_DFWK')</script> :</td>
						<td width="340">&nbsp;
							<select id="wep0_def_key" name="wep0_def_key" onChange="ischeck_wps('wep');">
								<option value="1"><script>show_words('wepkey1')</script></option>
								<option value="2"><script>show_words('wepkey2')</script></option>
								<option value="3"><script>show_words('wepkey3')</script></option>
								<option value="4"><script>show_words('wepkey4')</script></option>
							</select>
							<input type="hidden" id="wlan0_vap1_wep_default_key" name="wlan0_vap1_wep_default_key" value=''>
						</td>
					</tr>
					<tr>
						<td class="duple"><script>show_words('auth')</script> :</td>
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
			<div class="box" id="show0_wpa" style="display:none">
				<h2><script>show_words('_WPA')</script></h2>
				<p><script>show_words('bws_msg_WPA')</script></p>
				<p><script>show_words('bws_msg_WPA_2')</script></p>
				<input type="hidden" id="wlan0_vap1_psk_cipher_type" name="wlan0_vap1_psk_cipher_type" value=''>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple"> <script>show_words('bws_WPAM')</script> :</td>
					<td width="340">&nbsp;
						<select id="wpa0_mode" name="wpa0_mode">
							<option value="auto"><script>show_words('bws_WPAM_2')</script></option>
							<option value="wpa2"><script>show_words('bws_WPAM_3')</script></option>
							<option value="wpa"><script>show_words('bws_WPAM_1')</script></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_CT')</script> :</td>
					<td width="340">&nbsp;
						<select id="c_type_0" name="c_type_0">
							<option value="tkip"><script>show_words('bws_CT_1')</script></option>
							<option value="aes"><script>show_words('bws_CT_2')</script></option>
							<option value="both"><script>show_words('bws_CT_3')</script></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_GKUI')</script> :</td>
					<td width="340">&nbsp;
						<input type="text" id="wlan0_vap1_gkey_rekey_time" name="wlan0_vap1_gkey_rekey_time" size="8" maxlength="5" value=''>
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
					<td class="duple"><script>show_words('_psk')</script> :</td>
					<td width="340">&nbsp;<input type="password" id="wlan0_vap1_psk_pass_phrase" name="wlan0_vap1_psk_pass_phrase" size="40" maxlength="64" onfocus="select();"</td>
				</tr>
				</table>
			</div>

			<div class="box" id="show0_wpa_eap" style="display:none">
				<h2><script>show_words('bws_EAPx')</script></h2>
				<p class="box_msg"><script>show_words('bws_msg_EAP')</script>  </p>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<input type="hidden" id="wlan0_vap1_eap_radius_server_0" name="wlan0_vap1_eap_radius_server_0">
					<input type="hidden" id="wlan0_vap1_eap_mac_auth" name="wlan0_vap1_eap_mac_auth" value=''>
					<td class="duple"><script>show_words('bwsAT_')</script> :</td>
					<td width="340">&nbsp;<input id="wlan0_vap1_eap_reauth_period" name="wlan0_vap1_eap_reauth_period" size=10 value='120'>
					<script>show_words('_minutes')</script></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RIPA')</script> :</td>
					<td width="340">&nbsp;<input id="radius0_ip1" name="radius0_ip1" maxlength=15 size=15></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RSP')</script> :</td>
					<td width="340">&nbsp;<input type="text" id="radius0_port1" name="radius0_port1" size="8" maxlength="5" value="1812"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RSSs')</script> :</td>
					<td width="340">&nbsp;<input type="password" id="radius0_pass1" name="radius0_pass1" size="32" maxlength="64" onfocus="select();"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_RMAA')</script> :</td>
					<td width="340">&nbsp;<input type="checkbox" id="radius0_auth_mac1" name="radius0_auth_mac1" value="1"></td>
				</tr>
				<tr id="radius2">
					<td colspan="2">
						<input type="button" id="advanced" name="advanced" value="" onClick="show_radius();">
						<script>$("#advanced").val(get_words('_advanced')+">>");</script> </td>
				</tr>
				<tr id="none_radius2" style="display:none">
					<td colspan="2">
						<input type="button" id="advanced_0" name="advanced_0" value="" onClick="show_radius();">
						<script>$("#advanced_0").val("<<"+get_words('_advanced'));</script></td>
				</tr>
				</table>

				<table id="show0_radius2" cellpadding="1" cellspacing="1" border="0" width="525" style="display:none">
				<tr>
					<input type="hidden" id="wlan0_vap1_eap_radius_server_1" name="wlan0_vap1_eap_radius_server_1" value=''>
					<td class="box_msg" colspan="2"><script>show_words('bws_ORAD')</script> :</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RIPA')</script> :</td>
					<td width="340">&nbsp;<input id="radius0_ip2" name="radius0_ip2" maxlength=15 size=15></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RSP')</script> :</td>
					<td width="340">&nbsp;<input type="text" id="radius0_port2" name="radius0_port2" size="8" maxlength="5" value="1812"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RSSS')</script> :</td>
					<td width="340">&nbsp;<input type="password" id="radius0_pass2" name="radius0_pass2" size="32" maxlength="64" onfocus="select();"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('bws_2RMAA')</script> :</td>
					<td width="340">&nbsp;<input type="checkbox" id="radius0_auth_mac2" name="radius0_auth_mac2" value="1"></td>
				</tr>
				</table>
			</div>
		
		<!-- 2011.12.06 5G Silvia -->
			<div class="5G_use" style="display:none">
				<div class="box">
				<h2><script>show_words('guestzone_title_1')</script></h2>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr> 
					<td class="duple"><script>show_words('guestzone_enable')</script> :</td>
					<td>&nbsp; <input name="guest_zone_enable1" id="guest_zone_enable1" type="checkbox" value="1" onClick="	disable_wireless_1();">
						<input type="hidden" id="wlan1_vap1_enable" name="wlan1_vap1_enable" value="">
						<select id="wlan1_vap1_schedule_select" name="wlan1_vap1_schedule_select" onChange="get_wlan1_vap1_schedule(this	);">
							<option value="255" selected><script>show_words('_always')</script></option>
							<option value="254"><script>show_words('_never')</script></option>
							<script>document.write(add_option('Schedule'));</script>
						</select> 
						<input name="add_new_schedule2" type="button" class="button_submit" id="add_new_schedule2" onclick="	do_add_new_schedule(true)" value="">
						<script>$('#add_new_schedule2').val(get_words('dlink_1_add_new'));</script>
					</td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('wwl_band')</script> :</td>
					<td><strong>&nbsp;&nbsp;<script>show_words('GW_WLAN_RADIO_1_NAME')</script></strong></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bwl_NN')</script> :</td>
					<td width="340">&nbsp;&nbsp;<input name="show1_ssid" type="text" id="show1_ssid" size="20" maxlength="32" 	value="">
						<script>show_words('bwl_AS')</script> </td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('S473')</script> :</td>
					<td>&nbsp;&nbsp;<input name="guest_select_1" id="guest_select_1" type="checkbox" value="1">
					<input type="hidden" id="wlan1_vap_guest_zone" name="wlan1_vap_guest_zone" value="0">
					<input type="hidden" id="asp_temp_66" name="asp_temp_66" value=""></td>
				</tr>
				</table>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr id="show_wlan1_wep"> 
					<td class="duple"><script>show_words('bws_SM')</script> :</td>
					<td width="340">&nbsp;
						<select id="wep1_type" name="wep1_type" onChange="show_wpa_wep_1()">
							<option value="0" selected><script>show_words('_none')</script></option>
							<option value="1"><script>show_words('_WEP')</script></option>
							<option value="2"><script>show_words('_WPApersonal')</script></option>
							<option value="3"><script>show_words('_WPAenterprise')</script></option>
						</select> </td>
				</tr>
				</table>
				</div>
				<input type="hidden" id="wlan1_vap1_security" name="wlan1_vap1_security" value="disable">
				<input type="hidden" id="asp_temp_61" name="asp_temp_61" value="">
				<input type="hidden" id="asp_temp_62" name="asp_temp_62" value="">
				<input type="hidden" id="asp_temp_63" name="asp_temp_63" value="">
				<input type="hidden" id="asp_temp_64" name="asp_temp_64" value="">
				<div class="box" id="show1_wep" style="display:none"> 
				<h2><script>show_words('_WEP')</script></h2>
				<p><script>show_words('bws_msg_WEP_1')</script></p>
				<p><script>show_words('bws_msg_WEP_2')</script></p>
				<p><script>show_words('bws_msg_WEP_3')</script></p>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
					<input type="hidden" id="wlan1_vap1_wep64_key_1" name="wlan1_vap1_wep64_key_1" value="">
					<input type="hidden" id="wlan1_vap1_wep128_key_1" name="wlan1_vap1_wep128_key_1" value="">
					<input type="hidden" id="wlan1_vap1_wep64_key_2" name="wlan1_vap1_wep64_key_2" value="">
					<input type="hidden" id="wlan1_vap1_wep128_key_2" name="wlan1_vap1_wep128_key_2" value="">
					<input type="hidden" id="wlan1_vap1_wep64_key_3" name="wlan1_vap1_wep64_key_3" value="">
					<input type="hidden" id="wlan1_vap1_wep128_key_3" name="wlan1_vap1_wep128_key_3" value="">
					<input type="hidden" id="wlan1_vap1_wep64_key_4" name="wlan1_vap1_wep64_key_4" value="">
					<input type="hidden" id="wlan1_vap1_wep128_key_4" name="wlan1_vap1_wep128_key_4" value="">
				<tr> 
					<td class="duple"><script>show_words('bws_WKL')</script> :</td>
					<td width="340">&nbsp; 
						<select id="wep1_key_len" name="wep1_key_len" size=1 onChange="change_wep_key_fun_1();">
							<option value="5"><script>show_words('bws_WKL_0')</script></option>
							<option value="13"><script>show_words('bws_WKL_1')</script>)</option>
						</select> <script>show_words('bws_length')</script>
				</tr>
				<tr id=show_wlan1_wep style="display:none"> 
					<td class="duple"><script>show_words('bws_DFWK')</script> :</td>
					<td width="340">&nbsp; <select id="wep1_def_key" name="wep1_def_key" onChange="ischeck_wps('wep');">
						<option value="1"><script>show_words('wepkey1')</script></option>
						</select> <input type="hidden" id="wlan1_vap1_wep_default_key" name="wlan1_vap1_wep_default_key" value="1"> 
					</td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('auth')</script> :</td>
					<td width="340">&nbsp; 
						<select name="auth1_type" id="auth1_type" onChange="ischeck_wps('auto');">
							<option value="both"><script>show_words('_both')</script></option>
							<option value="share"><script>show_words('bws_Auth_2')</script></option>
						</select> </td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('_wepkey1')</script> :</td>
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
				<input type="hidden" id="wlan1_vap1_psk_cipher_type" name="wlan1_vap1_psk_cipher_type" value="both">
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr> 
					<td class="duple"><script>show_words('bws_WPAM')</script> :</td>
					<td width="340">&nbsp;
						<select id="wpa1_mode" name="wpa1_mode">
							<option value="auto"><script>show_words('bws_WPAM_2')</script></option>
							<option value="wpa2"><script>show_words('bws_WPAM_3')</script></option>
							<option value="wpa"><script>show_words('bws_WPAM_1')</script></option>
						</select> </td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_CT')</script> :</td>
					<td width="340">&nbsp; <select id="c_type_1" name="c_type_1">
						<option value="tkip"><script>show_words('bws_CT_1')</script></option>
						<option value="aes"><script>show_words('bws_CT_2')</script></option>
						<option value="both"><script>show_words('bws_CT_3')</script></option>
					</select> </td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_GKUI')</script> :</td>
					<td width="340">&nbsp; <input type="text" id="wlan1_vap1_gkey_rekey_time" name="wlan1_vap1_gkey_rekey_time" size="8"	 maxlength="5" value="3600">
						<script>show_words('bws_secs')</script> </td>
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
						<input type="password" id="wlan1_vap1_psk_pass_phrase" name="wlan1_vap1_psk_pass_phrase" size="40" maxlength="64	" value=""></td>
				</tr>
				</table>
				</div>
				<div class="box" id="show1_wpa_eap" style="display:none"> 
				<h2><script>show_words('bws_EAPx')</script></h2>
				<p class="box_msg"><script>show_words('bws_msg_EAP')</script> </p>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr> 
					<input type="hidden" id="wlan1_vap1_eap_radius_server_0" name="wlan1_vap1_eap_radius_server_0" value="0.0.0.0/1812/"	>
					<input type="hidden" id="wlan1_vap1_eap_mac_auth" name="wlan1_vap1_eap_mac_auth" value="">
					<td class="duple"><script>show_words('bwsAT_')</script> :</td>
					<td width="340">&nbsp;
						<input id="wlan1_vap1_eap_reauth_period" name="wlan1_vap1_eap_reauth_period" size=10 value="120">
						<script>show_words('_minutes')</script></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_RIPA')</script> :</td>
					<td width="340">&nbsp;
						<input id="radius1_ip1" name="radius1_ip1" maxlength=15 size=15></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_RSP')</script> :</td>
					<td width="340">&nbsp;
						<input type="text" id="radius1_port1" name="radius1_port1" size="8" maxlength="5" value="1812"></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_RSSs')</script> :</td>
					<td width="340">&nbsp;
						<input type="password" id="radius1_pass1" name="radius1_pass1" size="32" maxlength="64"></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_RMAA')</script> :</td>
					<td width="340">&nbsp;
						<input type="checkbox" id="radius1_auth_mac1" name="radius1_auth_mac1" value="1"></td>
				</tr>
				<tr id="radius2_1"> 
					<td colspan="2">
						<input type="button" id="advanced_1" name="advanced_1" value="" onClick="show_radius_1();">
						<script>$('#advanced_1').val(get_words('_advanced')+">>");</script></td>
				</tr>
				<tr id="none_radius2_1" style="display:none"> 
					<td colspan="2">
						<input type="button" id="advanced_2" name="advanced_2" value="" onClick="show_radius_1();">
						<script>$('#advanced_2').val("<<"+get_words('_advanced'));</script></td>
				</tr>
				</table>
				<table id="show1_radius2" cellpadding="1" cellspacing="1" border="0" width="525" style="display:none">
				<tr> 
					<input type="hidden" id="wlan1_vap1_eap_radius_server_1" name="wlan1_vap1_eap_radius_server_1" value="0.0.0.0/1812/"	>
					<td class="box_msg" colspan="2"><script>show_words('bws_ORAD')</script> :</td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_2RIPA')</script> :</td>
					<td width="340">&nbsp;
						<input id="radius1_ip2" name="radius1_ip2" maxlength=15 size=15></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_2RSP')</script> :</td>
					<td width="340">&nbsp;
						<input type="text" id="radius1_port2" name="radius1_port2" size="8" maxlength="5" value="1812"></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_2RSSS')</script> :</td>
					<td width="340">&nbsp;
						<input type="password" id="radius1_pass2" name="radius1_pass2" size="32" maxlength="64"></td>
				</tr>
				<tr> 
					<td class="duple"><script>show_words('bws_2RMAA')</script> :</td>
					<td width="340">&nbsp;
						<input type="checkbox" id="radius1_auth_mac2" name="radius1_auth_mac2" value="1"></td>
				</tr>
				</table>
				</div>
			</div>
		</div>
	</form>

			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong>
			<script>show_words('_hints')</script>&hellip;</strong>
			<p><script>show_words('guestzone_Intro_1')</script></p>
			<p><a href="support_adv.asp#GuestZone"><script>show_words('_more')</script>&hellip;</a></p>
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