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
	var wan_mac		= dev_info.wan_mac;
	var v4v6 		= dev_info.v4v6_support;

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=5";
	param.arg +="&oid_1=IGD_WANDevice_i_&inst_1=1100";
	param.arg +="&oid_2=IGD_WANDevice_i_PPTP_&inst_2=1110";
	param.arg +="&oid_3=IGD_WANDevice_i_PPTP_ConnectionCfg_&inst_3=1111";
	param.arg +="&oid_4=IGD_&inst_4=1000";
	param.arg +="&oid_5=IGD_WANDevice_i_PPPoEv6_i_&inst_5=1110";
	mainObj.get_config_obj(param);	
	
	var ipv6_wan_proto = mainObj.config_val("wanDev_CurrentConnObjType6_");
	var ipv6_pppoe_share = mainObj.config_val("ipv6PPPoEConn_SessionType_"); 
	var ipDNSServ = mainObj.config_val("pptpCfg_DNSServers_").split(",");
	var adv_dns_en = mainObj.config_val('pptpCfg_AdvancedDNSEnable_');
	var isReg = (mainObj.config_val("igd_Register_st_")? mainObj.config_val("igd_Register_st_"):"");
	var connect_mode ='';
    var submit_button_flag = 0;

	var wanCfg = {
		'wanMode':			mainObj.config_val('wanDev_CurrentConnObjType_'),
		'wanMac':			mainObj.config_val('wanDev_MACAddressClone_'),
		'wanMacCloned':		mainObj.config_val('wanDev_MACAddressOverride_')
	};

	var pptpCfg = {
		'ipType':			mainObj.config_val('pptpCfg_IPAddressType_'),
		'exipaddr':			mainObj.config_val('pptpCfg_ExternalIPAddress_'),
		'submask':			mainObj.config_val('pptpCfg_SubnetMask_'),
		'gateway':			mainObj.config_val('pptpCfg_DefaultGateway_'),
		'trigger':			mainObj.config_val('pptpConn_ConnectionTrigger_'),
		'username':			mainObj.config_val('pptpConn_Username_'),
		'serip':			mainObj.config_val('pptpConn_ServerIP_'),
		'ideldis_t':		mainObj.config_val('pptpConn_IdleDisconnectTime_'),
		'mtu':				mainObj.config_val('pptpConn_MaxMTUSize_')
	};
/*
    function opendns_enable_selector(value)
    {
        if (value == true) {
            get_by_id("wan_specify_dns").value = "1";
            get_by_id("wan_primary_dns").value = "204.194.232.200";
            get_by_id("wan_secondary_dns").value = "204.194.234.200";
            get_by_id("wan_primary_dns").disabled = true;
            get_by_id("wan_secondary_dns").disabled = true;
        }
        else {
            get_by_id("wan_specify_dns").value = "0";
            get_by_id("wan_primary_dns").disabled = false;
            get_by_id("wan_secondary_dns").disabled = false;
            get_by_id("wan_primary_dns").value = "0.0.0.0";
            get_by_id("wan_secondary_dns").value =  "0.0.0.0";
        }
    }
*/
    function onPageLoad()
    {
		if (v4v6 == '1')
			$('.v6_use').show();
		else
			$('.v4_use').show();

		//20130207 pascal add DIR-820L hide advanced dns service
		//model == "DIR-820L" ? $('#advDNS_service').hide() : $('#advDNS_service').show();
		
		paintWANlist();

		get_by_id("wan_pptp_ipaddr").value = pptpCfg.exipaddr;
		get_by_id("wan_pptp_netmask").value= pptpCfg.submask;
		get_by_id("wan_pptp_gateway").value= pptpCfg.gateway;
		get_by_id("wan_primary_dns").value= (ipDNSServ[0]==""?"0.0.0.0":ipDNSServ[0]);
		
		if(ipDNSServ[1])
			get_by_id("wan_secondary_dns").value = ipDNSServ[1];
		else
			get_by_id("wan_secondary_dns").value = "0.0.0.0";
		
		get_by_id("wan_pptp_server_ip").value= pptpCfg.serip;
		get_by_id("wan_pptp_username").value= pptpCfg.username;
		get_by_id("wan_pptp_max_idle_time").value= pptpCfg.ideldis_t;
		get_by_id("wan_pptp_mtu").value= pptpCfg.mtu;
		
		set_checked(pptpCfg.ipType,get_by_name("wan_pptp_dynamic"));
		set_checked(pptpCfg.trigger,get_by_name("wan_pptp_connect_mode"));
		//set_checked(adv_dns_en, get_by_id('opendns_enable_sel'));
		//if (adv_dns_en == '1') {
		//	opendns_enable_selector(true);
		//}
		
		$("#wan_mac").val(wanCfg.wanMac == ""?wan_mac:wanCfg.wanMac);
		get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = wanCfg.wanMacCloned;

        check_connectmode();
        clickPPTP();

        if (login_Info != "w") {
           DisableEnableForm(form1,true);
        }

        set_form_default_values("form1");
    }

    function clone_mac_action()
    {
		get_by_id("wan_mac").value = cli_mac;
		get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = "1";
    }

    function check_connectmode()
    {
        var conn_mode = get_by_name("wan_pptp_connect_mode");
        get_by_id("wan_pptp_max_idle_time").disabled = !conn_mode[1].checked;
    }

    function clickPPTP()
    {
        var fixIP = get_by_name("wan_pptp_dynamic");
        var is_disabled = false;

        if (fixIP[0].checked)
            is_disabled = true

        get_by_id("wan_pptp_ipaddr").disabled = is_disabled;
        get_by_id("wan_pptp_netmask").disabled = is_disabled;
        get_by_id("wan_pptp_gateway").disabled = is_disabled;
    }

	function send_request(){
	
		if (ipv6_wan_proto == "3" && ipv6_pppoe_share == "0"){
			alert(LangMap.which_lang['IPV6_TEXT161a']);
			return false;
		}
		
		var user_name = get_by_id("wan_pptp_username").value;
		var wan_type = get_by_name("wan_pptp_dynamic");
		var ip = get_by_id("wan_pptp_ipaddr").value;		
		var mask = get_by_id("wan_pptp_netmask").value;
		var gateway = get_by_id("wan_pptp_gateway").value;	
		var dns = get_by_id("wan_primary_dns").value;	
		var dns2 = get_by_id("wan_secondary_dns").value;	
		var idle_time = get_by_id("wan_pptp_max_idle_time").value;	    	
        var mtu = get_by_id("wan_pptp_mtu").value;
        
        var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));
		var dns_server_msg = replace_msg(all_ip_addr_msg,get_words('lan_dns'));
		var dns2_server_msg = replace_msg(all_ip_addr_msg,get_words('lan_dns2'));
        var max_idle_msg = replace_msg(check_num_msg,get_words('usb3g_max_idle_time'), 0, 999); 
        var mtu_msg = replace_msg(check_num_msg,get_words('bwn_MTU'), 1300, 1400);       
        
		var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
		var temp_dns_obj = new addr_obj(dns.split("."), dns_server_msg, false, false);
		var temp_dns2_obj = new addr_obj(dns2.split("."), dns2_server_msg, false, false);
		var temp_idle = new varible_obj(idle_time, max_idle_msg, 0, 9999, false);
        var temp_mtu = new varible_obj(mtu, mtu_msg, 1300, 1400, false);

		if(user_name==""){
			alert(get_words('GW_WAN_PPTP_USERNAME_INVALID'));
    		return false;
	     }
		 
		connect_mode = get_checked_value(get_by_name("wan_pptp_connect_mode"));
		if ((connect_mode ==2) && (isReg == 1))
		{
			if (confirm(get_words("mydlink_pop_08")) == false)
				return;
		}

		if (wan_type[1].checked){
			if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
				return false;
			}
		}
		
		if (dns != "" && dns != "0.0.0.0"){
			if (!check_address(temp_dns_obj)){
				return false;
			}
		}
		if (dns2 != "" && dns2 != "0.0.0.0"){
			if (!check_address(temp_dns2_obj))
				return false;
		}
    	
		if((get_by_id("wan_pptp_server_ip").value == "") ||
			(get_by_id("wan_pptp_server_ip").value == "0.0.0.0") ||
			(get_by_id("wan_pptp_server_ip").value == "255.255.255.255")){
    		alert(LangMap.msg['INVALID_SERVER_IP']);
    		return false;
	     }
		
		/*
		**    Date:		2013-05-23
		**    Author:	Pascal Pai
		**    Reason:   Check PPTP or L2TP Server IP Address is IP pattern or not
		**/
		if(ip_pattern($('#wan_pptp_server_ip').val()))
		{
			var server_ip = $('#wan_pptp_server_ip').val();
			var server_ip_addr_msg = replace_msg(all_ip_addr_msg,LangMap.msg['SERVER_IP_DESC']);
			var temp_server_ip_obj = new addr_obj(server_ip.split("."), server_ip_addr_msg, false, false);
			
			if (!check_address(temp_server_ip_obj)){
				return false;
			}
		}
		
		if ($('#pptppwd1').val() == "" || $('#pptppwd2').val() == ""){
			alert(get_words('GW_WAN_PPTP_PASSWORD_INVALID'));//
			return false;
		}
		
		if (!check_pwd("pptppwd1", "pptppwd2")){
			return false;
		}
		
		if (wan_type[0].checked) //Set dynamic IP
			get_by_id("wan_specify_dns").value = 0;
		else{						//Set static IP			
			get_by_id("wan_specify_dns").value = (dns == "" || dns == "0.0.0.0") ? 0 : 1;
		}	
		
		if(connect_mode == "2")
		{
			if (!check_varible(temp_idle))
				return false;
		}
    	
    	if (!check_varible(temp_mtu)){
    		return false;
    	}

		/*
		 * Validate MAC and activate cloning if necessary
		 */			
		var clonemac = get_by_id("wan_mac").value; 
		if (!check_mac_00(clonemac)){
			alert(get_words('KR3'));
			return false;
		} 
		 
		var mac = trim_string(get_by_id("wan_mac").value);
		if(!is_mac_valid(mac, true)) {
			alert (get_words('KR3')+":" + mac + ".");
			return false;
		}else{
			get_by_id("wan_mac").value = mac;
		}
		
		if($("#wan_mac").val() == "00:00:00:00:00:00")
		{
			$("#wan_mac").val(wan_mac);
			get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = "0";
		}
		else
			$("#wan_mac").val(mac);
		
		copyDataToDataModelFormat();
		send_submit("form2");
	}
	
	function copyDataToDataModelFormat()
	{
		get_by_id("pptpCfg_IPAddressType_1.1.1.0").value = get_checked_value(get_by_name("wan_pptp_dynamic"));
		get_by_id("pptpCfg_ExternalIPAddress_1.1.1.0").value = get_by_id("wan_pptp_ipaddr").value;
		get_by_id("pptpCfg_SubnetMask_1.1.1.0").value = get_by_id("wan_pptp_netmask").value;
		get_by_id("pptpCfg_DefaultGateway_1.1.1.0").value = get_by_id("wan_pptp_gateway").value;
		get_by_id("pptpCfg_DNSServers_1.1.1.0").value = get_by_id("wan_primary_dns").value;
		if(get_by_id("wan_secondary_dns").value != "")
			get_by_id("pptpCfg_DNSServers_1.1.1.0").value += ","+get_by_id("wan_secondary_dns").value;

		get_by_id("pptpConn_ServerIP_1.1.1.1").value = get_by_id("wan_pptp_server_ip").value;
		get_by_id("pptpConn_Username_1.1.1.1").value = get_by_id("wan_pptp_username").value;
		//if(get_by_id("wan_pptp_username").value == "WDB8WvbXdHtZyM8Ms2RENgHlacJghQyG")
			//get_by_id("pptpConn_Password_1.1.1.1.1").value = config_val("pptpConn_Password_");
		//else
			get_by_id("pptpConn_Password_1.1.1.1").value = get_by_id("pptppwd1").value;
		get_by_id("pptpConn_ConnectionTrigger_1.1.1.1").value = connect_mode;
		get_by_id("pptpConn_IdleDisconnectTime_1.1.1.1").value = get_by_id("wan_pptp_max_idle_time").value;
		get_by_id("pptpConn_MaxMTUSize_1.1.1.1").value = get_by_id("wan_pptp_mtu").value;
		//get_by_id("pptpConn_MPPEEnable_1.1.1.1.1").value = get_checked_value(get_by_id("pptp_mppe"));
		
		//get_by_id("pptpCfg_AdvancedDNSEnable_1.1.1.0").value = get_checked_value(get_by_id("opendns_enable_sel"));

		/*
		 * 20121226 moa rewrite contitions if MAC override or not
		 */
		if(get_by_id("wan_mac").value == wan_mac)
		{
			get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = "0";
		}
		else
		{
			get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = "1";
		}
		get_by_id("wanDev_MACAddressClone_1.1.0.0").value = get_by_id("wan_mac").value;

	}

	function paintWANlist()
	{
		var contain = ""
		contain +=  '<select name="wan_proto" id="wan_proto" onChange="change_wan()">'+
					'<option value="0">'+get_words('_sdi_staticip')+'</option>'+
					'<option value="1">'+get_words('bwn_Mode_DHCP')+'</option>'+
					'<option value="2">'+get_words('bwn_Mode_PPPoE')+'</option>'+
					'<option value="3" selected>'+get_words('bwn_Mode_PPTP')+'</option>'+
					'<option value="4">'+get_words('bwn_Mode_L2TP')+'</option>';
		if (v4v6 == '1')
			contain +='<option value="10">'+get_words('IPV6_TEXT140')+'</option>';

		contain +='</select>';

		$('#WAN_list').html(contain);
	}
</script>
<style type="text/css">
<!--
.style1 {font-size: 11px}
-->
</style>
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b1');</script>
		</td>
		<!-- end of left menu -->

		<input type="hidden" id="old_wan_mac" name="old_wan_mac" value=''>
			  <form id="form2" name="form2" method="post" action="get_set.ccp">
				<input type="hidden" name="ccp_act" value="set">
				<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
				<input type="hidden" name="nextPage" value="wan_pptp.asp">
				<input type="hidden" name="wanDev_CurrentConnObjType_1.1.0.0" id="wanDev_CurrentConnObjType_1.1.0.0" value="3">
				<input type="hidden" name="wanDev_MACAddressClone_1.1.0.0" id="wanDev_MACAddressClone_1.1.0.0" value="">
				<input type="hidden" name="wanDev_MACAddressOverride_1.1.0.0" id="wanDev_MACAddressOverride_1.1.0.0" value="">
				<input type="hidden" name="pptpCfg_IPAddressType_1.1.1.0" id="pptpCfg_IPAddressType_1.1.1.0" value="">
				<input type="hidden" name="pptpCfg_ExternalIPAddress_1.1.1.0" id="pptpCfg_ExternalIPAddress_1.1.1.0" value="">
				<input type="hidden" name="pptpCfg_SubnetMask_1.1.1.0" id="pptpCfg_SubnetMask_1.1.1.0" value="">
				<input type="hidden" name="pptpCfg_DefaultGateway_1.1.1.0" id="pptpCfg_DefaultGateway_1.1.1.0" value="">
				<input type="hidden" name="pptpCfg_DNSEnabled_1.1.1.0" id="pptpCfg_DNSEnabled_1.1.1.0" value="1">
				<input type="hidden" name="pptpCfg_DNSServers_1.1.1.0" id="pptpCfg_DNSServers_1.1.1.0" value="">
				<input type="hidden" name="pptpCfg_AdvancedDNSEnable_1.1.1.0" id="pptpCfg_AdvancedDNSEnable_1.1.1.0" value="0">
				<input type="hidden" name="pptpConn_ServerIP_1.1.1.1" id="pptpConn_ServerIP_1.1.1.1" value="">
				<input type="hidden" name="pptpConn_Username_1.1.1.1" id="pptpConn_Username_1.1.1.1" value="">
				<input type="hidden" name="pptpConn_Password_1.1.1.1" id="pptpConn_Password_1.1.1.1" value="">
				<input type="hidden" name="pptpConn_ConnectionTrigger_1.1.1.1" id="pptpConn_ConnectionTrigger_1.1.1.1" value="">
				<input type="hidden" name="pptpConn_IdleDisconnectTime_1.1.1.1" id="pptpConn_IdleDisconnectTime_1.1.1.1" value="">
				<input type="hidden" name="pptpConn_MaxMTUSize_1.1.1.1" id="pptpConn_MaxMTUSize_1.1.1.1" value="">
				<!--<input type="hidden" name="pptpConn_MPPEEnable_1.1.1.1.1" id="pptpConn_MPPEEnable_1.1.1.1.1" value="">-->
			  </form>

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="reboot.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="wan_pptp.asp">
			<input type="hidden" id="mac_clone_addr" name="mac_clone_addr" value=''>
			<input type="hidden" id="wan_specify_dns" name="wan_specify_dns" value=''>
			<input type="hidden" id="wan_pptp_password"  name="wan_pptp_password" value="">
			<input type="hidden" id="asp_temp_51" name="asp_temp_51" value=''>
			<input type="hidden" id="asp_temp_52" name="asp_temp_52" value=''>
			<input type="hidden" id="reboot_type" name="reboot_type" value="shutdown">

		<td valign="top" id="maincontent_container">
		<div id="maincontent">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
				<div id="box_header">
					<h1><script>show_words('_WAN')</script></h1>
					<div class="v6_use" style="display:none">
						<p><script>show_words('bwn_intro_ICS_v6')</script></p></div>
					<div class="v4_use" style="display:none">
						<p><script>show_words('bwn_intro_ICS')</script></p></div>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'sel_wan.asp');">
				<script>$('#button').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
				</div>

				<div class=box>
					<h2><script>show_words('bwn_ict')</script></h2>
					<p class="box_msg"><script>show_words('bwn_msg_Modes')</script></p>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td align=right width="185" class="duple"><script>show_words('bwn_mici')</script> :</td>
						<td width="331">&nbsp;<span id='WAN_list'></span></td>
					</tr>
					</table>
				</div>

				<!--IFDEF OPENDNS-->
				<input type="hidden" id="opendns_enable" name="opendns_enable" value=''>
				<input type="hidden" id="dns_relay" name="dns_relay" value=''>
				<div class=box id="advDNS_service" style="display:none">
					<h2><script>show_words('_title_AdvDns');</script></h2>
					<p class="box_msg"><script>show_words('_desc_AdvDns');</script></p>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="185" align=right style="WIDTH: 190px;" class="duple"><script>show_words('_en_AdvDns');</script> :</td>
						<td width="331">&nbsp;<input type="checkbox" id="opendns_enable_sel" name="opendns_enable_sel" value="1" onclick="opendns_enable_selector(this.checked);"></td>
					</tr>
					</table>
				</div>
				<!--ENDIF OPENDNS-->

				<div class=box id=show_pptp>
					<h2><script>show_words('bwn_PPTPICT')</script></h2>
					<p class="box_msg"><script>show_words('_ispinfo')</script> </p>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="185" align=right class="duple">
							<script>show_words('bwn_AM')</script> :</td>
						<td width="331">&nbsp;
						<input type=radio value="0" name="wan_pptp_dynamic" onClick=clickPPTP() checked>
							<script>show_words('carriertype_ct_0')</script>
						<input type=radio value="1" name="wan_pptp_dynamic" onClick=clickPPTP()>
							<script>show_words('_sdi_staticip')</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_PPTPip')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_pptp_ipaddr" name="wan_pptp_ipaddr" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple">
							<script>show_words('_PPTPsubnet')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_pptp_netmask" name="wan_pptp_netmask" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_PPTPgw')</script> :</td>
						<td>&nbsp;
							<input name="wan_pptp_gateway" type=text id="wan_pptp_gateway" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('bwn_PPTPSIPA')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_pptp_server_ip" name="wan_pptp_server_ip" size="20" maxlength="64" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('bwn_UN')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_pptp_username" name="wan_pptp_username" size="20" maxlength="63" value=''>
						</td>
					</tr>
					<tr>
						<td  align=right class="duple">
							<script>show_words('_password')</script> :</td>
						<td>&nbsp;
							<input type=password id="pptppwd1" name="pptppwd1" size="20" maxlength="63" onfocus="select();" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_verifypw')</script> :</td>
						<td>&nbsp;
							<input type=password id=pptppwd2 name=pptppwd2 size="20" maxlength="63" onfocus="select();" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('bwn_RM')</script> :</td>
						<td>&nbsp;
						<input type=radio name="wan_pptp_connect_mode" value="0" onClick="check_connectmode()">
							<script>show_words('bwn_RM_0')</script>
						<input type=radio name="wan_pptp_connect_mode" value="2" onClick="check_connectmode()">
							<script>show_words('bwn_RM_1')</script>
						<input type=radio name="wan_pptp_connect_mode" value="1" onClick="check_connectmode()">
							<script>show_words('bwn_RM_2')</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('bwn_MIT')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_pptp_max_idle_time" name="wan_pptp_max_idle_time" maxlength="5" size="10" value=''>
						<script>show_words('bwn_min')</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_dns1')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_primary_dns" name="wan_primary_dns" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_dns2')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_secondary_dns" name="wan_secondary_dns" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('bwn_MTU')</script> :</td>
						<td>&nbsp;
							<input type=text id="wan_pptp_mtu" name="wan_pptp_mtu" size="10" maxlength="5" value=''>
							<script>show_words('bwn_bytes')</script>
							<script>show_words('_308')</script>
						1400</td>
					</tr>
					<tr>
						<td width=150 valign=top class="duple"><script>show_words('_macaddr')</script> :</td>
						<td>&nbsp;
							<input type="text" id="wan_mac" name="wan_mac" size="20" maxlength="17" value=""><br>&nbsp;
							<input name="clone" id="clone" type="button" class=button_submit value="" onClick="clone_mac_action()">
							<script>$('#clone').val(get_words('_clone'));</script></td>
						</td>
					</tr>
					</table>
				</div>
			</td>
			</div>
		</form>

			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
 		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('LW35')</script></p>
			<p><script>show_words('LW36')</script></p>
			<p class="more"><a href="support_internet.asp#WAN" onclick="return jump_if();"><script>show_words('_more')</script>&hellip;</a></p>
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