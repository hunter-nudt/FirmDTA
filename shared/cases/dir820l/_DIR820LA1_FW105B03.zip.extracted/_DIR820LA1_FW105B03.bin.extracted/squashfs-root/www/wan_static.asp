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
	var gigabit 	= dev_info.gigabit;

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=7";
	param.arg +="&oid_1=IGD_&inst_1=1000";
	param.arg +="&oid_2=IGD_WANDevice_i_&inst_2=1100";
	param.arg +="&oid_3=IGD_WANDevice_i_StaticIP_&inst_3=1110";
	param.arg +="&oid_4=IGD_LANDevice_i_LANHostConfigManagement_&inst_4=1110";
	param.arg +="&oid_5=IGD_WANDevice_i_TrafficControl_&inst_5=1110";
	param.arg +="&oid_6=IGD_Firewall_&inst_6=1100";
	param.arg +="&oid_7=IGD_WANDevice_i_PPPoEv6_i_&inst_7=1110";	
	mainObj.get_config_obj(param);
	
	var ipv6_wan_proto = mainObj.config_val("wanDev_CurrentConnObjType6");
	var ipv6_pppoe_share = mainObj.config_val("ipv6PPPoEConn_SessionType_"); 
	var hw_nat_enable = mainObj.config_val("wanDev_HardwareNatEnable_");
	var spi_enable = mainObj.config_val("firewallSetting_SPIEnable_");
	var trafficshap_enable = mainObj.config_val('wanTrafficShp_EnableTrafficShaping_');
	var adv_dns_en = mainObj.config_val('staticIPCfg_AdvancedDNSEnable_');
	var staticIPDNS = mainObj.config_val("staticIPCfg_DNSServers_").split(",");
//	var devMode = (config_val("igd_DeviceMode_")? config_val("igd_DeviceMode_"):"0");
	var devLanIP = "";
	
	var lanCfg = {
		'lanIp':			mainObj.config_val('lanHostCfg_IPAddress_'),
		'lanSubnetMask':	mainObj.config_val('lanHostCfg_SubnetMask_')
	};	

	var wanCfg = {
		'wanMode':			mainObj.config_val('wanDev_CurrentConnObjType_'),
		'wanMac':			mainObj.config_val('wanDev_MACAddressClone_'),
		'wanMacCloned':		mainObj.config_val('wanDev_MACAddressOverride_')
	};

	var staticCfg = {
		'exipaddr':			mainObj.config_val('staticIPCfg_ExternalIPAddress_'),
		'submask':			mainObj.config_val('staticIPCfg_SubnetMask_'),
		'gateway':			mainObj.config_val('staticIPCfg_DefaultGateway_'),
		'mtu':				mainObj.config_val('staticIPCfg_MaxMTUSize_')
	};

    var submit_button_flag = 0;
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
            get_by_id("wan_specify_dns").value ="0";
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
		if (gigabit == '1')
			$('.giga_use').show();

		//20130207 pascal add DIR-820L hide advanced dns service
		//model == "DIR-820L" ? $('#advDNS_service').hide() : $('#advDNS_service').show();
		
		paintWANlist();

		get_by_id("asp_temp_52").value = wanCfg.wanMode; 

		get_by_id("wan_static_ipaddr").value = staticCfg.exipaddr;
		get_by_id("wan_static_netmask").value = staticCfg.submask;
		get_by_id("wan_static_gateway").value = staticCfg.gateway;
		//set_checked(adv_dns_en, get_by_id('opendns_enable_sel'));

		//if (adv_dns_en == '1') 
		//	opendns_enable_selector(true);

		if (gigabit == 1)
			set_checked(hw_nat_enable, get_by_id('HW_NAT_Enable'));

		get_by_id("wan_primary_dns").value = (staticIPDNS[0]==""?"0.0.0.0":staticIPDNS[0]);
		if(staticIPDNS[1])
			get_by_id("wan_secondary_dns").value = staticIPDNS[1];
		else
			get_by_id("wan_secondary_dns").value = "0.0.0.0";

		get_by_id("wan_mtu").value = staticCfg.mtu;
		$("#wan_mac").val(wanCfg.wanMac == ""?wan_mac:wanCfg.wanMac);
		get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = wanCfg.wanMacCloned;

		set_form_default_values("form1");
		var login_who= login_Info;
		if(login_who!= "w"){
			DisableEnableForm(form1,true);	
		}	
	}

	function clone_mac_action(){
		get_by_id("wan_mac").value = cli_mac;
		get_by_id("wanDev_MACAddressOverride_1.1.0.0").value = "1";
	}

	function send_static_request()
	{
		if (ipv6_wan_proto == "3" && ipv6_pppoe_share == "0"){
			alert(LangMap.which_lang['IPV6_TEXT161a']);
			return false;
		}
		
    	get_by_id("asp_temp_52").value = get_by_id("wan_proto").value;
    	var is_modify = is_form_modified("form1");
    	if (!is_modify && !confirm(get_words('_ask_nochange'))) {
			return false;
		}

		if (gigabit == 1)
		{		
			//add by Vic for check hw nat enable
			if(!check_hw_nat_enable())
				return false;
		}
			
    	var ip = get_by_id("wan_static_ipaddr").value;
    	var mask = get_by_id("wan_static_netmask").value;
    	var gateway = get_by_id("wan_static_gateway").value;
    	var dns1 = get_by_id("wan_primary_dns").value;
        var dns2 = get_by_id("wan_secondary_dns").value;
        var mtu = get_by_id("wan_mtu").value;
        //var lanip = get_by_id("lan_ipaddr").value;
    	//var lanmask = get_by_id("lan_netmask").value;
		var lanip = "";
		var lanmask = "";
		
		if(lanCfg.lanIp)
			lanip = lanCfg.lanIp;
		else
			lanip = "0.0.0.0";
		
		if(lanCfg.lanSubnetMask)
			lanmask = lanCfg.lanSubnetMask;
		else
			lanmask = "255.255.255.255";
       
		var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));
		var dns1_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_pdns'));
		var dns2_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_sdns'));
        var mtu_msg = replace_msg(check_num_msg, get_words('bwn_MTU'), 1300, 1500);
        
        var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_lanip_obj = new addr_obj(lanip.split("."), ip_addr_msg, false, false);
		var temp_lanmask_obj = new addr_obj(lanmask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
        var temp_dns1_obj = new addr_obj(dns1.split("."), dns1_addr_msg, false, false);
		var temp_dns2_obj = new addr_obj(dns2.split("."), dns2_addr_msg, true, false);
		var temp_mtu = new varible_obj(mtu, mtu_msg, 1300, 1500, false);	

		if(ip == gateway){
			alert(get_words("ip_gateway_check"));
			return false;
		}
				
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
    	
    	if (!check_varible(temp_mtu)){
    		return false;
    	}
    	
    	//check lan and wan is same subnet    	
    	if (temp_lanip_obj && temp_lanmask_obj){
        	var ipaddr = temp_ip_obj.addr;
			var maskaddr = temp_mask_obj.addr;
        	var lanipaddr = temp_lanip_obj.addr;
			var lanmaskaddr = temp_lanmask_obj.addr;
			var count = 0;			
			for(var i = 0; i < ipaddr.length; i++){
				//alert(ipaddr[i]+maskaddr[i]+lanipaddr[i]+lanmaskaddr[i]);
				if ((ipaddr[i] & lanmaskaddr[i]) == (lanipaddr[i] & lanmaskaddr[i]))
					count++;			
			}
			if(count == ipaddr.length){
        		//alert("WAN and LAN IP Address cann't be set to the same subnet.");
        		alert(get_words('GW_WAN_LAN_SUBNET_CONFLICT_INVALID'));
        		return false;
        	}	
        }	     
		
    	/*
		 * Validate MAC and activate cloning if necessary
		 */	
		var clonemac = get_by_id("wan_mac").value; 
		if (!check_mac_00(clonemac)){
			//alert(LangMap.msg['MAC_ADDRESS_ERROR']);
			alert(get_words('KR3'));
			return false;
		} 
			 		
		var mac = trim_string(get_by_id("wan_mac").value);
		if(!is_mac_valid(mac, true)) {
			//alert ("Invalid MAC address:" + mac + ".");
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
			
		if((get_by_id("wan_primary_dns").value =="" || get_by_id("wan_primary_dns").value =="0.0.0.0")&& ( get_by_id("wan_secondary_dns").value =="" || get_by_id("wan_secondary_dns").value =="0.0.0.0")){
			get_by_id("wan_specify_dns").value = 0;
		}else{
			get_by_id("wan_specify_dns").value = 1;
		}
		
		if(submit_button_flag == 0){
			submit_button_flag = 1;
			copyDataToDataModelFormat();
			send_submit("form2");
			return true;
		}else{
			return false;
		}
    }

	function copyDataToDataModelFormat()
	{
		get_by_id("staticIPCfg_ExternalIPAddress_1.1.1.0").value = get_by_id("wan_static_ipaddr").value;
		get_by_id("staticIPCfg_SubnetMask_1.1.1.0").value = get_by_id("wan_static_netmask").value;
		get_by_id("staticIPCfg_DefaultGateway_1.1.1.0").value = get_by_id("wan_static_gateway").value;
		get_by_id("staticIPCfg_DNSServers_1.1.1.0").value = get_by_id("wan_primary_dns").value;
		if(get_by_id("wan_secondary_dns").value != "")
			get_by_id("staticIPCfg_DNSServers_1.1.1.0").value += ","+get_by_id("wan_secondary_dns").value;

		get_by_id("staticIPCfg_MaxMTUSize_1.1.1.0").value = get_by_id("wan_mtu").value;
		
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
		
		//get_by_id("staticIPCfg_AdvancedDNSEnable_1.1.1.0").value = get_checked_value(get_by_id("opendns_enable_sel"));

		if (gigabit == 1)
		{
			hw_nat_enable = get_checked_value(get_by_id('HW_NAT_Enable'));
			if(hw_nat_enable)
			{
				spi_enable = "0";
				trafficshap_enable = "0";
			}
		}

		get_by_id("wanDev_HardwareNatEnable_1.1.0.0").value = hw_nat_enable;
		get_by_id("firewallSetting_SPIEnable_1.1.0.0").value = spi_enable;
		get_by_id("wanTrafficShp_EnableTrafficShaping_1.1.1.0").value = trafficshap_enable;
	}
	
	function reload_page()
	{
		if (is_form_modified("form1") && confirm (get_words('up_fm_dc_1'))) {
			onPageLoad();
		}
	}
	
	function paintWANlist()
	{
		var contain = ""
		contain +=  '<select name="wan_proto" id="wan_proto" onChange="change_wan()">'+
					'<option value="0" selected>'+get_words('_sdi_staticip')+'</option>'+
					'<option value="1">'+get_words('bwn_Mode_DHCP')+'</option>'+
					'<option value="2">'+get_words('bwn_Mode_PPPoE')+'</option>'+
					'<option value="3">'+get_words('bwn_Mode_PPTP')+'</option>'+
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
				<input type="hidden" name="nextPage" value="sel_wan.asp">
				<input type="hidden" name="igd_DeviceMode_1.0.0.0" id="igd_DeviceMode_1.0.0.0" value="">
				<input type="hidden" name="wanDev_CurrentConnObjType_1.1.0.0" id="wanDev_CurrentConnObjType_1.1.0.0" value="0">
				<input type="hidden" name="wanDev_MACAddressClone_1.1.0.0" id="wanDev_MACAddressClone_1.1.0.0" value="">
				<input type="hidden" name="wanDev_MACAddressOverride_1.1.0.0" id="wanDev_MACAddressOverride_1.1.0.0" value="">
				<input type="hidden" name="staticIPCfg_Name_1.1.1.0" id="staticIPCfg_Name_1.1.1.0" value="">
				<input type="hidden" name="staticIPCfg_AdvancedDNSEnable_1.1.1.0" id="staticIPCfg_AdvancedDNSEnable_1.1.1.0" value="0">
				<input type="hidden" name="staticIPCfg_ExternalIPAddress_1.1.1.0" id="staticIPCfg_ExternalIPAddress_1.1.1.0" value="">
				<input type="hidden" name="staticIPCfg_SubnetMask_1.1.1.0" id="staticIPCfg_SubnetMask_1.1.1.0" value="1">
				<input type="hidden" name="staticIPCfg_DefaultGateway_1.1.1.0" id="staticIPCfg_DefaultGateway_1.1.1.0" value="">
				<input type="hidden" name="staticIPCfg_DNSEnabled_1.1.1.0" id="staticIPCfg_DNSEnabled_1.1.1.0" value="">
				<input type="hidden" name="staticIPCfg_DNSServers_1.1.1.0" id="staticIPCfg_DNSServers_1.1.1.0" value="">
				<input type="hidden" name="staticIPCfg_MaxMTUSize_1.1.1.0" id="staticIPCfg_MaxMTUSize_1.1.1.0" value="">
				<input type="hidden" id="wanDev_HardwareNatEnable_1.1.0.0" name="wanDev_HardwareNatEnable_1.1.0.0" value="">
				<input type="hidden" id="firewallSetting_SPIEnable_1.1.0.0" name="firewallSetting_SPIEnable_1.1.0.0" value="">
				<input type="hidden" id="wanTrafficShp_EnableTrafficShaping_1.1.1.0" name="wanTrafficShp_EnableTrafficShaping_1.1.1.0" value="">
			</form>
			
            <form id="form1" name="form1" method="post" action="">
            <input type="hidden" id="html_response_page" name="html_response_page" value="reboot.asp">
            <input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
            <input type="hidden" id="html_response_return_page" name="html_response_return_page" value="wan_static.asp">
            <input type="hidden" id="reboot_type" name="reboot_type" value="shutdown">

            <input type="hidden" id="mac_clone_addr" name="mac_clone_addr" value=''>
            <input type="hidden" id="wan_specify_dns" name="wan_specify_dns" value=''>
            <input type="hidden" id="asp_temp_51" name="asp_temp_51" value=''>
            <input type="hidden" id="asp_temp_52" name="asp_temp_52" value=''>
            <input type="hidden" id="lan_ipaddr" name="lan_ipaddr" value=''>
            <input type="hidden" id="lan_netmask" name="lan_netmask" value=''>

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
					<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_static_request()">
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
				<input type="hidden" id="opendns_enable" name="opendns_enable" value="" >
				<input type="hidden" id="dns_relay" name="dns_relay" value="">
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

				<div class = giga_use style="display:none">
				<div class=box>
					<h2><script>show_words('HW_NAT_desc');</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="185" align=right class="duple"><script>show_words('HW_NAT_enable');</script>:</td>
						<td width="331">&nbsp;
							<input type="checkbox" id="HW_NAT_Enable" name="HW_NAT_Enable" value="1">
						</td>
					</tr>
					</table>
				</div>
				</div>
				<div class=box id=show_static>
					<h2><script>show_words('bwn_SIAICT')</script></h2>
					<p class="box_msg"><script>show_words('bwn_msg_SWM')</script></p>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="185" class="duple"><script>show_words('_ipaddr')</script>: </td>
						<td width="331">&nbsp;
							<input type=text id="wan_static_ipaddr" name="wan_static_ipaddr" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td width=150 class="duple"><script>show_words('_subnet')</script>: </td>
						<td>&nbsp;
							<input type=text id="wan_static_netmask" name="wan_static_netmask" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td width=150 class="duple"><script>show_words('_defgw')</script>: </td>
						<td>&nbsp;
							<input type=text id="wan_static_gateway" name="wan_static_gateway" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td width=150 class="duple"><script>show_words('_dns1')</script>: </td>
						<td>&nbsp;
							<input type=text id="wan_primary_dns" name="wan_primary_dns" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td width=150 class="duple"><script>show_words('_dns2')</script>: </td>
						<td>&nbsp;
							<input type=text id="wan_secondary_dns" name="wan_secondary_dns" size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td width=150 class="duple"><script>show_words('bwn_MTU')</script>: </td>
						<td>&nbsp;
							<input type=text id="wan_mtu" name="wan_mtu" size="10" maxlength="5" value=''>
							<script>show_words('bwn_bytes')</script>
							<script>show_words('_308')</script>
						1500</td>
					</tr>
					<tr>
					</tr>
					<tr>
						<td width=150 valign=top class="duple"><script>show_words('_macaddr')</script>:</td>
						<td>&nbsp;
							<input type="text" id="wan_mac" name="wan_mac" size="20" maxlength="17" value=""><br>&nbsp;
							<input name="clone" id="clone" type="button" class=button_submit value="" onClick="clone_mac_action()">
							<script>$('#clone').val(get_words('_clone'));</script></td>
						</td>
					</tr>
					</table>
				</div>
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