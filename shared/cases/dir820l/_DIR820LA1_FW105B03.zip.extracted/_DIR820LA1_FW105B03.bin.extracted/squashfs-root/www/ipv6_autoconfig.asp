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
<script type="text/javascript" src="js/public_ipv6.js"></script>
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

    var submit_button_flag = 0;
	
	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=4";
	param.arg +="&oid_1=IGD_WANDevice_i_&inst_1=1100";
	param.arg +="&oid_2=IGD_WANDevice_i_AutoConfiguration_&inst_2=1110";	
	param.arg +="&oid_3=IGD_LANDevice_i_IPv6ConfigManagement_&inst_3=1110";
	param.arg +="&oid_4=IGD_WANDevice_i_IPv6Status_&inst_4=11100";
	mainObj.get_config_obj(param);
	
	//IPv6 connection type
	var ipv6_type = mainObj.config_val("wanDev_CurrentConnObjType6_");

	//IPv6 DNS settings
	var auto_dns_enable = mainObj.config_val("ipv6AutoConfConn_AutomaticDNSServer_");;

	//LAN IPv6 address settings
	var lan_ipv6_linklocal_addr = filter_ipv6_addr(filter_ipv6_addr(mainObj.config_val("igdIPv6Status_IPv6LanLinkLocalAddress_")));
	var dhcppd_enable = mainObj.config_val("lanIPv6Cfg_DHCPPDEnable_");

	var ipv6_obj = {
		'auto_dhcppd_enable':		mainObj.config_val("lanIPv6Cfg_AutoDHCPPDEnable_"),
		'auto_conf_type':			mainObj.config_val("lanIPv6Cfg_AutoConfigurationType_"),
		'auto_addr_assig_enable':	mainObj.config_val("lanIPv6Cfg_AutoV6AddressAssignEnable_"),
		'auto_conf_Addr':			filter_ipv6_addr(mainObj.config_val("lanIPv6Cfg_AutoConfigurationLanAddress_")),
		'start_range':				filter_ipv6_addr(mainObj.config_val("lanIPv6Cfg_DHCPv6AddressRangeStart_")),
		'end_range':				filter_ipv6_addr(mainObj.config_val("lanIPv6Cfg_DHCPv6AddressRangeEnd_")),
		'adv_lifetime':				mainObj.config_val("lanIPv6Cfg_AdvertisementLifetime_"),
		'addr_lifetime':			mainObj.config_val("lanIPv6Cfg_IPv6AddressLifeTime_"),
		'stat_pAddr':				filter_ipv6_addr(mainObj.config_val("igdIPv6Status_PrimaryDNSAddress_")),
		'stat_sAddr':				filter_ipv6_addr(mainObj.config_val("igdIPv6Status_SecondaryDNSAddress_")),
		'lanAddr':					filter_ipv6_addr(mainObj.config_val("igdIPv6Status_IPv6LanAddress_")),
		'liftime':					mainObj.config_val("igdIPv6Status_IPv6LifeTime_"),
		'primaryAddr':				filter_ipv6_addr(mainObj.config_val("ipv6AutoConfConn_PrimaryDNSAddress_")),
		'secondAddr':				filter_ipv6_addr(mainObj.config_val("ipv6AutoConfConn_SecondaryDNSAddress_"))
	};

    function onPageLoad()
    {
		//IPv6 DNS settings
		set_checked(auto_dns_enable, get_by_name("ipv6_dns_stateless_enable"));
		$('#ipv6_stateless_primary_dns').val(ipv6_obj.primaryAddr);
		$('#ipv6_stateless_secondary_dns').val(ipv6_obj.secondAddr);

		//LAN IPv6 address settings
		$('#ipv6_stateless_lan_ip').val(ipv6_obj.auto_conf_Addr);
		$('#lan_link_local_ip').html(lan_ipv6_linklocal_addr.toUpperCase()+"/64");
		set_checked(dhcppd_enable, $('#ipv6_dhcp_pd_chk')[0]);
		disable_ipv6_dhcp_pd_chk();

		//Address autoconfiguration settings
		set_checked(ipv6_obj.auto_addr_assig_enable, $('#ipv6_autoconfig_sel')[0]);
		set_checked(ipv6_obj.auto_dhcppd_enable, $('#ipv6_dhcp_pd_lan')[0]);
        $('#ipv6_autoconfig_type')[0].selectedIndex = ipv6_obj.auto_conf_type;
		$('#ipv6_dhcp_adver_lifetime').val(ipv6_obj.adv_lifetime);
		$('#ipv6_dhcpd_lifetime').val(ipv6_obj.addr_lifetime);
 
	    disable_ipv6_stateless_auto_dns();
        set_ipv6_autoconfiguration_type();
        set_ipv6_stateful_range();
		disable_ipv6_dhcp_pd_chk();
		disable_autoconfig();
		set_form_default_values("form1");
    }

	function disable_autoconfig()	//20120207 fix with 835
	{
		var selchk = $('#ipv6_autoconfig_sel')[0].checked;
		var pdchk = $('#ipv6_dhcp_pd_chk')[0].checked;
		$('#ipv6_autoconfig').val(get_checked_value($('#ipv6_autoconfig_sel')[0]));
		disabled_field('ipv6_addr_range_start_suffix',!selchk);
		disabled_field('ipv6_addr_range_end_suffix',!selchk);
		disabled_field('ipv6_autoconfig_type',!selchk);
		disabled_field('ipv6_dhcp_pd_lan',true);
		disabled_field('ipv6_dhcp_adver_lifetime',true);
		disabled_field('ipv6_dhcpd_lifetime',true);

		if (selchk == true)
		{
			if (pdchk == false)
			{
				disabled_field('ipv6_dhcpd_lifetime',false);
				disabled_field('ipv6_dhcp_adver_lifetime',false);
			}else
				disabled_field('ipv6_dhcp_pd_lan',false);
		}
	}

    function disable_ipv6_stateless_auto_dns()
	{
        var fixIP = get_by_name("ipv6_dns_stateless_enable");
        $('#ipv6_stateless_primary_dns').attr('disabled',fixIP[0].checked);
        $('#ipv6_stateless_secondary_dns').attr('disabled',fixIP[0].checked);

		if(fixIP[0].checked)
		{
			$('#ipv6_stateless_primary_dns').val(ipv6_obj.stat_pAddr);
			$('#ipv6_stateless_secondary_dns').val(ipv6_obj.stat_sAddr);
		}
		else
		{
			$('#ipv6_stateless_primary_dns').val(ipv6_obj.primaryAddr);
			$('#ipv6_stateless_secondary_dns').val(ipv6_obj.secondAddr);
		}
 	}

	function disabled_field(fe_name, act)
	{
		$('#'+fe_name).attr('disabled',act);
	}

	function disable_ipv6_dhcp_pd_chk(){	//20120207 fix with 835
		var pdchk = $('#ipv6_dhcp_pd_chk')[0].checked;
		var selchk = $('#ipv6_autoconfig_sel')[0].checked;
		disabled_field('ipv6_stateless_lan_ip',pdchk);
		disabled_field('ipv6_dhcpd_lifetime',pdchk);
		disabled_field('ipv6_dhcp_pd_lan',true);
		disabled_field('ipv6_dhcp_adver_lifetime',true);

		if (pdchk == true)
		{
			if (selchk == true)
				disabled_field('ipv6_dhcp_pd_lan',false);
		}else{
			if (selchk == true)
				disabled_field('ipv6_dhcp_adver_lifetime',false);
		}

		if($('#ipv6_dhcp_pd_chk')[0].checked)
		{
			$('#ipv6_stateless_lan_ip').val(ipv6_obj.lanAddr);
			set_ipv6_autoconf_range();
			$('#ipv6_dhcp_adver_lifetime').val(ipv6_obj.liftime);
			$('#ipv6_dhcpd_lifetime').val(ipv6_obj.liftime);
		}
		else
		{
			$('#ipv6_dhcp_adver_lifetime').val(ipv6_obj.adv_lifetime);
			$('#ipv6_dhcpd_lifetime').val(ipv6_obj.addr_lifetime);
		}
	 }

	function set_ipv6_autoconf_range(){
		var ipv6_lan_ip = $('#ipv6_stateless_lan_ip').val();
		var prefix_length = 64;
		var correct_ipv6="";
		if (ipv6_lan_ip != "") {
			correct_ipv6 = get_stateful_ipv6(ipv6_lan_ip);
			$('#ipv6_addr_range_start_prefix').val(get_stateful_prefix(correct_ipv6,prefix_length));
			$('#ipv6_addr_range_end_prefix').val(get_stateful_prefix(correct_ipv6,prefix_length));
		}
	}

	function set_ipv6_stateful_range()
	{
		var prefix_length = 64;
		var ipv6_lan_ip = $('#ipv6_stateless_lan_ip').val();
		var correct_ipv6="";
		if(ipv6_lan_ip != ""){
			correct_ipv6 = get_stateful_ipv6(ipv6_lan_ip);
			$('#ipv6_addr_range_start_prefix').val(get_stateful_prefix(correct_ipv6,prefix_length));
			$('#ipv6_addr_range_end_prefix').val(get_stateful_prefix(correct_ipv6,prefix_length));
		}
		$('#ipv6_addr_range_start_suffix').val(get_stateful_suffix(ipv6_obj.start_range));
		$('#ipv6_addr_range_end_suffix').val(get_stateful_suffix(ipv6_obj.end_range));
	}

	function set_ipv6_autoconfiguration_type()
	{
		var mode = $('#ipv6_autoconfig_type')[0].selectedIndex;
		switch(mode){
		case 0:
		case 1: //Stateless
			$('#show_ipv6_addr_range_start').hide();
			$('#show_ipv6_addr_range_end').hide();
			$('#show_ipv6_addr_lifetime').hide();
			$('#show_router_advert_lifetime').show();
			break;
		case 2: //Stateful DHCPv6
			set_ipv6_autoconf_range();
			$('#ipv6_addr_range_start_prefix').attr('disabled',true);
			$('#ipv6_addr_range_end_prefix').attr('disabled',true);
			$('#show_ipv6_addr_range_start').show();
			$('#show_ipv6_addr_range_end').show();
			$('#show_ipv6_addr_lifetime').show();
			$('#show_router_advert_lifetime').hide();
			break;
		default:
			$('#show_ipv6_addr_range_start').hide();
			$('#show_ipv6_addr_range_end').hide();
			$('#show_ipv6_addr_lifetime').hide();
			$('#show_router_advert_lifetime').show();
			//$('#show_channel_width').show();
		break;
		}
		disable_ipv6_dhcp_pd_chk();
	}

	function send_request()
	{
	   var primary_dns = $('#ipv6_stateless_primary_dns').val();
		var v6_primary_dns_msg = replace_msg(all_ipv6_addr_msg,get_words('_dns1_v6'));
		var secondary_dns = $('#ipv6_stateless_secondary_dns').val();
		var v6_secondary_dns_msg = replace_msg(all_ipv6_addr_msg,get_words('_dns1_v6'));
		var ipv6_lan = $('#ipv6_stateless_lan_ip').val();
		var ipv6_lan_msg = replace_msg(all_ipv6_addr_msg,get_words('IPV6_TEXT46'));
		var temp_ipv6_lan = new ipv6_addr_obj(ipv6_lan.split(":"), ipv6_lan_msg, false, false);
		var check_mode = $('#ipv6_autoconfig_type')[0].selectedIndex;
		var enable_autoconfig = $('#ipv6_autoconfig').val();
		var addr_lifetime_msg = replace_msg(check_num_msg, get_words('IPV6_TEXT68'), 1, 999999);
		var addr_lifetime_obj = new varible_obj($('#ipv6_dhcpd_lifetime').val(), addr_lifetime_msg, 1, 999999, false);
		var adver_lifetime_msg = replace_msg(check_num_msg, get_words('IPV6_TEXT69'), 1, 999999);
		var adver_lifetime_obj = new varible_obj($('#ipv6_dhcp_adver_lifetime').val(), adver_lifetime_msg , 1, 999999, false);
		var ipv6_addr_s_suffix = $('#ipv6_addr_range_start_suffix').val();
		var ipv6_addr_e_suffix = $('#ipv6_addr_range_end_suffix').val();

		if ($('#ipv6_wan_proto').val() == $('#ipv6_w_proto').val()) 
		{
			if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
				return false;
		}

		$('#ipv6_autoconfig').val(get_checked_value($('#ipv6_autoconfig_sel')[0]));
		$('#ipv6_dhcp_pd_enable').val(get_checked_value($('#ipv6_dhcp_pd_chk')[0]));
		$('#ipv6_stateless_dns_enable').val(get_checked_value(get_by_name("ipv6_dns_stateless_enable")));
		$('#ipv6_wan_specify_dns').val($('#ipv6_stateless_dns_enable').val());
		$('#ipv6_wan_proto').val($('#ipv6_w_proto').val());

		//check DNS Address
		if(!get_by_name("ipv6_dns_stateless_enable")[0].checked)
		{
			if((primary_dns == "") && (secondary_dns == ""))
			{
				alert(addstr(get_words('up_ai_se_2'),get_words('_dns1_v6')));
				return false;
			}
			if (primary_dns!= "") // don't check primary_dns if empty for v3.01, but need add it back since ver3.02 by graceyang 20080908
			{
				if(check_ipv6_symbol(primary_dns,"::")==2){ // find two '::' symbol
					return false;
				}else if(check_ipv6_symbol(primary_dns,"::")==1){    // find one '::' symbol
					temp_ipv6_primary_dns = new ipv6_addr_obj(primary_dns.split("::"), v6_primary_dns_msg, false, false);
					if (!check_ipv6_address(temp_ipv6_primary_dns ,"::"))
					{
						return false;
					}
				}else{	//not find '::' symbol
					temp_ipv6_primary_dns  = new ipv6_addr_obj(primary_dns.split(":"), v6_primary_dns_msg, false, false);
					if (!check_ipv6_address(temp_ipv6_primary_dns,":"))
					{
						return false;
					}
				}
			}

			if (secondary_dns != "")
			{
				if(secondary_dns != "0:0:0:0:0:0:0:0")
				{	
					if(check_ipv6_symbol(secondary_dns,"::")==2){ // find two '::' symbol
						return false;
					}else if(check_ipv6_symbol(secondary_dns,"::")==1){   // find one '::' symbol
						temp_ipv6_secondary_dns = new ipv6_addr_obj(secondary_dns.split("::"), v6_secondary_dns_msg, false, false);
						if (!check_ipv6_address(temp_ipv6_secondary_dns ,"::"))
						{
							return false;
						}
					}else{	//not find '::' symbol
						temp_ipv6_secondary_dns  = new ipv6_addr_obj(secondary_dns.split(":"), v6_secondary_dns_msg, false, false);
						if (!check_ipv6_address(temp_ipv6_secondary_dns,":"))
							return false;
					}
				}
			}
		}
		//check LAN IP Address
		if(!$('#ipv6_dhcp_pd_chk')[0].checked)
		{
			if(check_ipv6_symbol(ipv6_lan,"::")==2){ // find two '::' symbol
				return false;
			}else if(check_ipv6_symbol(ipv6_lan,"::")==1){    // find one '::' symbol
				temp_ipv6_lan = new ipv6_addr_obj(ipv6_lan.split("::"), ipv6_lan_msg, false, false);
				if (!check_ipv6_address(temp_ipv6_lan ,"::"))
					return false;
			}else{  //not find '::' symbol
			
				temp_ipv6_lan  = new ipv6_addr_obj(ipv6_lan.split(":"), ipv6_lan_msg, false, false);
				if (!check_ipv6_address(temp_ipv6_lan,":"))
					return false;
			}
		}
	   if(check_mode == 2 && enable_autoconfig == 1){
			//check the suffix of Address Range(Start)
			if(!check_ipv6_address_suffix(ipv6_addr_s_suffix,get_words('IPv6_addrSr')))
				return false;

			//check the suffix of Address Range(End)
			if(!check_ipv6_address_suffix(ipv6_addr_e_suffix,get_words('IPv6_addrEr')))
				return false;

			//compare the suffix of start and the suffix of end
			if(!compare_suffix(ipv6_addr_s_suffix,ipv6_addr_e_suffix))
				return false;

			//check the IPv6 Address Lifetime
			if(!$('#ipv6_dhcp_pd_chk')[0].checked)
			{
				if (!check_varible(addr_lifetime_obj))
					return false;
			}
			//set autoconfiguration range value
			$('#ipv6_dhcpd_start').val($('#ipv6_addr_range_start_prefix').val() + "::" + $('#ipv6_addr_range_start_suffix').val());
			$('#ipv6_dhcpd_end').val($('#ipv6_addr_range_end_prefix').val() + "::" + $('#ipv6_addr_range_end_suffix').val());
		}
		else if(enable_autoconfig == 1)
		{
			//check the Router Advertisement Lifetime
			if(!$('#ipv6_dhcp_pd_chk')[0].checked)
			{
				if (!check_varible(adver_lifetime_obj))
					return false;
			}
			//set Advertisement Lifetime
			$('#ipv6_ra_adv_valid_lifetime_l_one').val($('#ipv6_dhcp_adver_lifetime').val() * 60) ;
		}

		if (submit_button_flag == 0) 
		{
			submit_button_flag = 1;
			submit_aconfig();
			return true;
		}

		return false;
	}

	function submit_aconfig()
	{
		var submitObj = new ccpObject();
		var paramAdetect = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=sel_ipv6.asp'
		};

		paramAdetect.arg += "&wanDev_CurrentConnObjType6_1.1.0.0=2";

		paramAdetect.arg += "&ipv6AutoConfConn_AutomaticDNSServer_1.1.1.0="+get_radio_value(get_by_name("ipv6_dns_stateless_enable"));
		paramAdetect.arg += "&ipv6AutoConfConn_PrimaryDNSAddress_1.1.1.0="+$('#ipv6_stateless_primary_dns').val();
		paramAdetect.arg += "&ipv6AutoConfConn_SecondaryDNSAddress_1.1.1.0="+$('#ipv6_stateless_secondary_dns').val();
		paramAdetect.arg += "&lanIPv6Cfg_DHCPPDEnable_1.1.1.0="+get_checked_value($('#ipv6_dhcp_pd_chk')[0]);
		paramAdetect.arg += "&lanIPv6Cfg_AutoDHCPPDEnable_1.1.1.0="+get_checked_value($('#ipv6_dhcp_pd_lan')[0]);
		paramAdetect.arg += "&lanIPv6Cfg_AutoConfigurationLanAddress_1.1.1.0="+$('#ipv6_stateless_lan_ip').val();
		paramAdetect.arg += "&lanIPv6Cfg_AutoDetectLanAddress_1.1.1.0="+$('#ipv6_dhcp_lan_ip').val();
		paramAdetect.arg += "&lanIPv6Cfg_AutoV6AddressAssignEnable_1.1.1.0="+get_checked_value($('#ipv6_autoconfig_sel')[0]);
		paramAdetect.arg += "&lanIPv6Cfg_AutoConfigurationType_1.1.1.0="+$('#ipv6_autoconfig_type')[0].selectedIndex;
		paramAdetect.arg += "&lanIPv6Cfg_AdvertisementLifetime_1.1.1.0="+$('#ipv6_dhcp_adver_lifetime').val();
		paramAdetect.arg += "&lanIPv6Cfg_DHCPv6AddressRangeStart_1.1.1.0="+$('#ipv6_addr_range_start_prefix').val() + "::" + $('#ipv6_addr_range_start_suffix').val();
		paramAdetect.arg += "&lanIPv6Cfg_DHCPv6AddressRangeEnd_1.1.1.0="+$('#ipv6_addr_range_end_prefix').val() + "::" + $('#ipv6_addr_range_end_suffix').val();
		paramAdetect.arg += "&lanIPv6Cfg_IPv6AddressLifeTime_1.1.1.0="+$('#ipv6_dhcpd_lifetime').val();
		submitObj.get_config_obj(paramAdetect);
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b6');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_ipv6_stateless.asp">
			<input type="hidden" id="ipv6_autoconfig" name="ipv6_autoconfig">
			<input type="hidden" id="ipv6_dhcp_pd_enable" name="ipv6_dhcp_pd_enable">
			<input type="hidden" id="ipv6_stateless_dns_enable" name="ipv6_stateless_dns_enable">
			<input type="hidden" id="ipv6_dhcpd_start" name="ipv6_dhcpd_start">
			<input type="hidden" id="ipv6_dhcpd_end" name="ipv6_dhcpd_end">
			<input type="hidden" id="ipv6_wan_proto" name="ipv6_wan_proto">
			<input type="hidden" id="ipv6_ra_adv_valid_lifetime_l_one" name="ipv6_ra_adv_valid_lifetime_l_one">
			<input type="hidden" maxLength=80 size=80 name="link_local_ip_l" id="link_local_ip_l">
			<input type="hidden" id="page_type" name="page_type" value="IPv6">
			<input type="hidden" id="ipv6_wan_specify_dns" name="ipv6_wan_specify_dns" value="1">

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('ipv6')</script></h1>
				<script>show_words('IPV6_TEXT28')</script><br>
				<br>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'ipv6_autoconfig.asp');">
				<script>$('#button').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
			</div>
			<div class=box>
				<h2 style=" text-transform:none">
				<script>show_words('IPV6_TEXT29')</script></h2>
				<p class="box_msg"><script>show_words('IPV6_TEXT30')</script></p>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td align=right width="187" class="duple"><script>show_words('IPV6_TEXT31')</script> :</td>
					<td width="331">&nbsp; <select name="ipv6_w_proto" id="ipv6_w_proto" onChange='change_ipv6_type()'>
						<option value="0"><script>show_words('IPV6_TEXT138')</script></option>
						<option value="1"><script>show_words('IPV6_TEXT32')</script></option>
						<option value="2" selected><script>show_words('IPV6_TEXT107')</script></option>
						<option value="3"><script>show_words('IPV6_TEXT34')</script></option>
						<option value="4"><script>show_words('IPV6_TEXT35')</script></option>
						<option value="5"><script>show_words('IPV6_TEXT36')</script></option>
						<option value="6"><script>show_words('IPV6_TEXT139')</script></option>
						<option value="7"><script>show_words('IPV6_TEXT37')</script></option>
					</select></td>
				</tr>
				</table>
			</div>
			<div class=box id=wan_ipv6_settings>
				<h2 style=" text-transform:none"><script>show_words('IPV6_TEXT63')</script></h2>
				<p class="box_msg"><script>show_words('IPV6_TEXT64')</script> </p>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td width="187" align=right><input type="radio" name="ipv6_dns_stateless_enable" value="0" onClick="disable_ipv6_stateless_auto_dns()" checked></td>
					<td width="331">&nbsp;<script>show_words('IPV6_TEXT65')</script></td>
				</tr>
				<tr>
					<td width="187" align=right><input type="radio" name="ipv6_dns_stateless_enable" value="1" onClick="disable_ipv6_stateless_auto_dns()"></td>
					<td width="331">&nbsp;<script>show_words('IPV6_TEXT66')</script></td>
				</tr>
				<tr>
					<td width="187" align=right class="duple"><script>show_words('_dns1_v6')</script> :</td>
					<td width="331">&nbsp;<input type=text id="ipv6_stateless_primary_dns" name="ipv6_stateless_primary_dns" size="30" maxlength="39"></td>
				</tr>
				<tr>
					<td width="187" align=right class="duple"><script>show_words('_dns2_v6')</script> :</td>
					<td width="331">&nbsp;<input type=text id="ipv6_stateless_secondary_dns" name="ipv6_stateless_secondary_dns" size="30" maxlength="39"></td>
				</tr>
				</table>
			</div>
			<div class=box id=lan_ipv6_settings>
				<h2 style=" text-transform:none"><script>show_words('IPV6_TEXT44')</script></h2>
				<p align="justify" class="style1"><script>show_words('IPV6_TEXT45')</script> </p>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td width="187" align=right class="duple"><script>show_words('IPV6_TEXT147')</script> :</td>
					<td width="331">&nbsp;<input type=checkbox id="ipv6_dhcp_pd_chk" name="ipv6_dhcp_pd_chk"   value="1" onClick="disable_ipv6_dhcp_pd_chk();"></td>
				</tr>
				<tr>
					<td width="187" align=right class="duple"><script>show_words('IPV6_TEXT46')</script> :</td>
					<td width="331">&nbsp;
						<input type=text id="ipv6_stateless_lan_ip" name="ipv6_stateless_lan_ip" size="30" maxlength="63" onChange="set_ipv6_autoconf_range()">
						<b>/64</b>
					</td>
				</tr>
				<tr>
					<td width="187" align=right class="duple"><script>show_words('IPV6_TEXT47')</script> :</td>
					<td width="331">&nbsp;
						<b><span id="lan_link_local_ip"></span></b>
					</td>
				</tr>
				</table>
			</div>
			<div class="box" id=ipv6_autoconfiguration_settings>
				<h2><script>show_words('IPV6_TEXT48')</script></h2>
				<p align="justify" class="style1"><script>show_words('IPV6_TEXT49')</script><script>show_words('IPV6_TEXT164')</script></p>
				<table width="525" border=0 cellPadding=1 cellSpacing=1 class=formarea summary="">
				<tr>
					<td width="187" class="duple"><script>show_words('IPV6_TEXT105')</script> :</td>
					<td width="331">&nbsp;<input name="ipv6_autoconfig_sel" type=checkbox id="ipv6_autoconfig_sel" value="1" onClick="disable_autoconfig();"></td>
				</tr>
				<tr>
					<td width="187" class="duple"><script>show_words('IPV6_TEXT108')</script> :</td>
					<td width="331">&nbsp;<input name="ipv6_dhcp_pd_lan" type=checkbox id="ipv6_dhcp_pd_lan" value="1"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('IPV6_TEXT51')</script> :</td>
					<td width="331">&nbsp;
						<select id="ipv6_autoconfig_type" name="ipv6_autoconfig_type" onChange="set_ipv6_autoconfiguration_type()">
							<option value="rdnss"><script>show_words('IPV6_TEXT157')</script></option>
							<option value="stateless"><script>show_words('IPV6_TEXT106')</script></option>
							<option value="stateful"><script>show_words('IPV6_TEXT53')</script></option>
						</select>
					</td>
				</tr>
				<tr id="show_ipv6_addr_range_start" style="display:none">
					<td class="duple"><script>show_words('IPV6_TEXT54')</script> :</td>
					<td width="331">&nbsp;&nbsp;<input type=text id="ipv6_addr_range_start_prefix" name="ipv6_addr_range_start_prefix" size="20" maxlength="19">
						::<input type=text id="ipv6_addr_range_start_suffix" name="ipv6_addr_range_start_suffix" size="5" maxlength="4">
					</td>
				</tr>
				<tr id="show_ipv6_addr_range_end" style="display:none">
					<td class="duple"><script>show_words('IPV6_TEXT55')</script> :</td>
					<td width="331">&nbsp;&nbsp;<input type=text id="ipv6_addr_range_end_prefix" name="ipv6_addr_range_end_prefix" size="20" maxlength="19">
						::<input type=text id="ipv6_addr_range_end_suffix" name="ipv6_addr_range_end_suffix" size="5" maxlength="4">
					</td>
				</tr>
				<tr id="show_ipv6_addr_lifetime" style="display:none">
					<td class="duple"><script>show_words('IPV6_TEXT56')</script> :</td>
					<td width="331">&nbsp;&nbsp;<input type=text id="ipv6_dhcpd_lifetime" name="ipv6_dhcpd_lifetime" size="20" maxlength="15" value=''>
						<script>show_words('_minutes')</script></td>
				</tr>
				<tr id="show_router_advert_lifetime">
					<td class="duple"><script>show_words('IPV6_TEXT57')</script> :</td>
					<td width="331">&nbsp;&nbsp;<input type=text id="ipv6_dhcp_adver_lifetime" name="ipv6_dhcp_adver_lifetime" size="20" maxlength="15" value="">
						<script>show_words('_minutes')</script></td>
				</tr>
				</table>
			</div>
		</td>
		</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('IPV6_TEXT58')</script></p>
			<p><script>show_words('IPV6_TEXT59')</script></p>
			<p class="more"><a href="support_internet.asp#ipv6"><script>show_words('_more')</script>&hellip;</a></p>
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