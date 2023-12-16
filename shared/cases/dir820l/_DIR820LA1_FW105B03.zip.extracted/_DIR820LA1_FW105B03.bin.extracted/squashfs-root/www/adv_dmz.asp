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
	//20120111 ignore TCP,UDP endingpoint
	document.title = get_words('TEXT000');
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var gigabit 	= dev_info.gigabit;

	var mainObj = new ccpObject();
	var param = {
		url: 	"get_set.ccp",
		arg: 	"ccp_act=get&num_inst=4&"+
				"oid_1=IGD_Firewall_&inst_1=1100&"+
				"oid_2=IGD_&inst_2=1000&"+
				"oid_3=IGD_WANDevice_i_&inst_3=1100&"+
				"oid_4=IGD_WANDevice_i_TrafficControl_&inst_4=1110"
	};
	mainObj.get_config_obj(param);

	var wan_proto = mainObj.config_val("wanDev_CurrentConnObjType_");
	var firewall_obj = {
		spi_enable: 	mainObj.config_val("firewallSetting_SPIEnable_"),
		anti_enable: 	mainObj.config_val("firewallSetting_AntiSpoofCheckEnable_"),
		algpptp: 		mainObj.config_val("firewallSetting_ALGPPTPEnable_"),
		algl2tp: 		mainObj.config_val("firewallSetting_ALGL2TPEnable_"),
		algipse: 		mainObj.config_val("firewallSetting_ALGIPSECEnable_"),
		algrtsp: 		mainObj.config_val("firewallSetting_ALGRTSPEnable_"),
		algsip: 		mainObj.config_val("firewallSetting_ALGSIPEnable_")
	};
	
	var wan_obj = {
		enable: 		mainObj.config_val("wanDev_DMZEnable_"),
		ipaddr: 		mainObj.config_val("wanDev_DMZIPAddress_"),
		hw_nat_enable:	mainObj.config_val("wanDev_HardwareNatEnable_")
	};

	var trafficshap_enable = mainObj.config_val('wanTrafficShp_EnableTrafficShaping_');
	var dev_mode = mainObj.config_val("igd_DeviceMode_");
	var submit_button_flag = 0;

	function onPageLoad()
	{
		$("#spi_enable").val(firewall_obj.spi_enable);
		set_checked($("#spi_enable").val(), $("#spiEnable")[0]);
		$("#anti_spoof_check").val(firewall_obj.anti_enable);
		set_checked($("#anti_spoof_check").val(), $("#anti_spoof_check_sel")[0]);
		$("#dmz_enable").val(wan_obj.enable);
		set_checked($("#dmz_enable").val(), $("#dmz_host")[0]);
		$("#dmz_ipaddr").val(wan_obj.ipaddr);

		if(firewall_obj.algpptp)
			set_checked(firewall_obj.algpptp, $("#pptp")[0]);
		if(firewall_obj.algl2tp)
			set_checked(firewall_obj.algl2tp, $("#l2tp")[0]);
		if(firewall_obj.algipse)
			set_checked(firewall_obj.algipse, $("#ipsec")[0]);
		if(firewall_obj.algrtsp)
			set_checked(firewall_obj.algrtsp, $("#rtsp")[0]);
		if(firewall_obj.algsip)
			set_checked(firewall_obj.algsip, $("#sip")[0]);

		var login_who= login_Info;
		if(login_who!= "w" || dev_mode == "1" || wan_proto == "10")
			DisableEnableForm(form1,true);	
		else
			disable_obj();

		set_form_default_values("form1");
	}

	function clone_mac()
	{
		if ($("#dhcp")[0].selectedIndex > 0){
			$("#dmz_ipaddr").val($("#dhcp")[0].options[$("#dhcp")[0].selectedIndex].value);
		}else{
			alert(LangMap.msg['SELECT_COMPUTER_ERROR']);
		}
	}

	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		if (gigabit == 1)
		{
			if((get_checked_value($("#spiEnable")[0]) == "1") && (wan_obj.hw_nat_enable == "1"))
			{
				if(!confirm(get_words("alert_hw_nat_3")))
					return false;
			}
		}

		$("#spi_enable").val( get_checked_value($("#spiEnable")[0]));
		$("#pptp_pass_through").val(get_checked_value($("#pptp")[0]));
		$("#l2tp_pass_through").val(get_checked_value($("#l2tp")[0]));
		$("#ipsec_pass_through").val(get_checked_value($("#ipsec")[0]));
		$("#alg_rtsp").val(get_checked_value($("#rtsp")[0]));
		$("#alg_sip").val(get_checked_value($("#sip")[0]));
		var dmz_ip = $("#dmz_ipaddr").val();
		var lan_ip = dev_info.lanIP;

		var ip_addr_msg = replace_msg(all_ip_addr_msg, get_words('help256'));
		var ip_obj = new addr_obj(dmz_ip.split("."), ip_addr_msg, false, false);
		var temp_lan_ip_obj = new addr_obj(lan_ip.split("."), ip_addr_msg, false, false);
		
		if (get_by_id("dmz_host").checked){
			if(!check_LAN_ip(temp_lan_ip_obj.addr, ip_obj.addr)){
				return false;
			}
			if (!check_address(ip_obj)){				
				return false;
	   		}
	   	}

		$("#dmz_enable").val(get_checked_value($("#dmz_host")[0]));
		$("#anti_spoof_check").val(get_checked_value($("#anti_spoof_check_sel")[0]));
		if(submit_button_flag == 0){
			submit_button_flag = 1;
			copy_data_to_cgi_struct();

			get_by_id("form2").submit();
		}
	}
	
	function disable_obj()
	{
		var is_disable = true;
		if ($("#dmz_host")[0].checked)
			is_disable = false;

		$("#dmz_ipaddr").attr("disabled",is_disable);
		$("#button22").attr("disabled",is_disable);
		$("#dhcp").attr("disabled",is_disable);
	}

	function copy_data_to_cgi_struct()
	{
		if (gigabit == 1)
		{
			if((get_checked_value(get_by_id("spiEnable")) == "1"))
				wan_obj.hw_nat_enable = "0";
		}

		get_by_id("wanDev_HardwareNatEnable_1.1.0.0").value = wan_obj.hw_nat_enable;
		get_by_id("firewallSetting_SPIEnable_").value = get_checked_value(get_by_id("spiEnable"));
		//get_by_id("firewallSetting_UDPEndpointFiltering_").value = 1 ;//get_radio_value(get_by_name("udp_nat_type"));
		//get_by_id("firewallSetting_TCPEndpointFiltering_").value = 2 ;//get_radio_value(get_by_name("tcp_nat_type"));
		get_by_id("firewallSetting_AntiSpoofCheckEnable_").value = get_checked_value(get_by_id("anti_spoof_check_sel"));
		get_by_id("wanDev_DMZEnable_").value = get_checked_value(get_by_id("dmz_host"));
		get_by_id("wanDev_DMZIPAddress_").value = get_by_id("dmz_ipaddr").value;
		get_by_id("firewallSetting_ALGPPTPEnable_").value = get_by_id("pptp_pass_through").value;
		get_by_id("firewallSetting_ALGL2TPEnable_").value = get_by_id("l2tp_pass_through").value;
		get_by_id("firewallSetting_ALGIPSECEnable_").value = get_by_id("ipsec_pass_through").value;
		get_by_id("firewallSetting_ALGRTSPEnable_").value = get_by_id("alg_rtsp").value;
		get_by_id("firewallSetting_ALGSIPEnable_").value = get_by_id("alg_sip").value;
	}

	function get_landevice()
	{
		var lanObj = new ccpObject();
		var param = {
			url: 	"get_set.ccp",
			arg: 	"ccp_act=get&num_inst=1"+
					"&oid_1=IGD_LANDevice_i_ConnectedAddress_i_&inst_1=1100"
		};
		lanObj.get_config_obj(param);
		return lanObj;
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b9');</script>
		</td>
		<!-- end of left menu -->

	<form id="form1" name="form1" method="post" action="">
		<input type="hidden" id="html_response_page"  name="html_response_page" value="back.asp">
		<input type="hidden" id="html_response_message"  name="html_response_message" value="">
		<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
		<input type="hidden" id="html_response_return_page"  name="html_response_return_page" value="adv_dmz.asp">
		<input type="hidden" id="reboot_type" name="reboot_type" value="filter">
		<input type="hidden" id="dhcp_list" name="dhcp_list" value="">
		<input type="hidden" id="dmz_schedule" name="dmz_schedule" value="">
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
					<h1><script>show_words('_firewalls')</script></h1>
					<p><script>show_words('af_intro_x')</script></p>
					<input name="button" id="button" type="button" class=button_submit value="" onClick="send_request()">
					<input name="button2" id="button2" type=button class=button_submit value="" onclick="page_cancel('form1', 'adv_dmz.asp');">
					<script>$("#button2").val(get_words('_dontsavesettings'));</script>
					<script>$("#button").val(get_words('_savesettings'));</script>
				</div>
				<div class=box>
					<h2><script>show_words('af_ES')</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width=155 align=right class="duple"><script>show_words('af_ES')</script>:</td>
						<td width="360">&nbsp;
							<input type="checkbox" id="spiEnable" name="spiEnable" value="1">
							<input type="hidden" id="spi_enable" name="spi_enable" value="">
						</td>
					</tr>
					</table>
				</div>
				
<!-- 20120111 ignore by silvia
				<div style="display:none" class=box>
					<h2><script>show_words('_neft')</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td align=right width=155>&nbsp;</td>
						<td width="360">&nbsp;
							<input type="radio" id="udp_nat_type" name="udp_nat_type" value="0">
							&nbsp;<script>show_words('af_EFT_0')</script>
						</td>
					</tr>
					<tr>
						<td width=155 align=right class="duple"><script>show_words('af_UEFT')</script>:</td>
						<td width="360">&nbsp;
							<input type="radio" id="udp_nat_type" name="udp_nat_type" value="1">
							&nbsp;<script>show_words('af_EFT_1')</script>
						</td>
					</tr>
					<tr>
						<td align=right width=155>&nbsp;</td>
						<td width="360">&nbsp;
							<input type="radio" id="udp_nat_type" name="udp_nat_type" value="2">
							&nbsp;<script>show_words('af_EFT_2')</script>
						</td>
					</tr>
					<tr>
						<td align=right colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td align=right width=155>&nbsp;</td>
						<td width="360">&nbsp;
							<input type="radio" id="tcp_nat_type" name="tcp_nat_type" value="0">
							&nbsp;<script>show_words('af_EFT_0')</script>
						</td>
					</tr>
					<tr>
						<td width=155 align=right class="duple"><script>show_words('af_TEFT')</script>:</td>
						<td width="360">&nbsp;
							<input type="radio" id="tcp_nat_type" name="tcp_nat_type" value="1">
							&nbsp;<script>show_words('af_EFT_1')</script>
						</td>
					</tr>
					<tr>
						<td align=right width=155>&nbsp;</td>
						<td width="360">&nbsp;
							<input type="radio" id="tcp_nat_type" name="tcp_nat_type" value="2">
							&nbsp;<script>show_words('af_EFT_2')</script>
						</td>
					</tr>
					</table>
				</div>
-->
				<div class=box>
					<h2><script>show_words('KR105')</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width=155 align=right class="duple"><script>show_words('KR106')</script>:</td>
						<td width="360">&nbsp;
							<input type="checkbox" id="anti_spoof_check_sel" name="anti_spoof_check_sel" value="1">
							<input type="hidden" id="anti_spoof_check" name="anti_spoof_check" value="">
						</td>
					</tr>
					</table>
				</div>
				
				<div class=box>
					<h2><script>show_words('_dmzh')</script></h2>
					<script>show_words('help165')</script></P>
					<p><script>show_words('af_intro_2')</script></p>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td align=right width=155>
							<input type="hidden" id="dmz_enable" name="dmz_enable" value="">
							<script>show_words('af_ED')</script>:
						</td>
						<td colSpan=3>&nbsp;<input type=checkbox id="dmz_host" name="dmz_host" value="1" onClick="disable_obj();"></td>
					</tr>
					<tr>
						<td width="155" align=right><script>show_words('af_DI')</script> :</td>
						<td width="96" valign="bottom"><input type=text id="dmz_ipaddr" name="dmz_ipaddr" size=16 maxlength=15 value=""></td>
						<td width="258" valign="bottom"><input id="button22" name="button22" type=button value="<<" style="width: 24; height: 24" onClick="clone_mac()">
							<select id="dhcp" name="dhcp" size=1>
								<option value="-1"><script>show_words('bd_CName')</script></option>
								<script>
									var lanObj = get_landevice();
									lanObj.get_host_list("ip");
								</script>
							</select>
						</td>
						<td width="3">&nbsp;</td>
					</tr>
					</table>
				</div>

				<div class=box>
					<h2><script>show_words('af_algconfig')</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td align=right width=155> <input type="hidden" id="pptp_pass_through" name="pptp_pass_through" value="">
						<script>show_words('_PPTP')</script> :</td>
						<td colSpan=3>&nbsp; <input type=checkbox id="pptp" name="pptp" value="1"></td>
					</tr>
					<tr style="display: none">
						<td align=right width=155> <input type="hidden" id="l2tp_pass_through" name="l2tp_pass_through" value="">
						<script>show_words('_L2TP')</script> :</td>
						<td colSpan=3>&nbsp; <input type=checkbox id="l2tp" name="l2tp" value="1"></td>
					</tr>
					<tr style="display: ">
						<td align=right width=155> <input type="hidden" id="ipsec_pass_through" name="ipsec_pass_through" value="">
						<script>show_words('as_IPSec')</script> :</td>
						<td colSpan=3>&nbsp; <input type=checkbox id="ipsec" name="ipsec" value="1"></td>
					</tr>
					<tr>
						<td align=right width=155> <input type="hidden" id="alg_rtsp" name="alg_rtsp" value="">
						<script>show_words('as_RTSP')</script> :</td>
						<td colSpan=3>&nbsp; <input type=checkbox id="rtsp" name="rtsp" value="1"></td>
					</tr>
					<tr>
						<td align=right width=155> <input type="hidden" id="alg_sip" name="alg_sip" value="">
						<script>show_words('as_SIP')</script> :</td>
						<td colSpan=3>&nbsp; <input type=checkbox id="sip" name="sip" value="1"></td>
					</tr>
					</table>
				</div>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>
	</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong>
		<script>show_words('_hints')</script>&hellip;</strong>
		<p><script>show_words('hhaf_dmz')</script></p>
		<p><a href="support_adv.asp#Firewall"><script>show_words('_more')</script>&hellip;</a></p>
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
	<form id="form2" name="form2" method="post" action="get_set.ccp">
		<input type="hidden" name="ccp_act" value="set">
		<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
		<input type="hidden" name="nextPage" value="adv_dmz.asp">	
		<input type="hidden" id="firewallSetting_SPIEnable_"  name="firewallSetting_SPIEnable_1.1.0.0" value="">
		<input type="hidden" id="firewallSetting_AntiSpoofCheckEnable_"  name="firewallSetting_AntiSpoofCheckEnable_1.1.0.0" value="">
		<input type="hidden" id="firewallSetting_ALGPPTPEnable_"  name="firewallSetting_ALGPPTPEnable_1.1.0.0" value="">	
		<input type="hidden" id="firewallSetting_ALGL2TPEnable_"  name="firewallSetting_ALGL2TPEnable_1.1.0.0" value="">	
		<input type="hidden" id="firewallSetting_ALGIPSECEnable_"  name="firewallSetting_ALGIPSECEnable_1.1.0.0" value="">
		<input type="hidden" id="firewallSetting_ALGRTSPEnable_"  name="firewallSetting_ALGRTSPEnable_1.1.0.0" value="">	
		<input type="hidden" id="firewallSetting_ALGSIPEnable_"  name="firewallSetting_ALGSIPEnable_1.1.0.0" value="">
<!--
		<input type="hidden" id="firewallSetting_UDPEndpointFiltering_"  name="firewallSetting_UDPEndpointFiltering_1.1.0.0" value="">	
		<input type="hidden" id="firewallSetting_TCPEndpointFiltering_"  name="firewallSetting_TCPEndpointFiltering_1.1.0.0" value="">	
-->
		<input type="hidden" id="wanDev_DMZEnable_"  name="wanDev_DMZEnable_1.1.0.0" value="">	
		<input type="hidden" id="wanDev_DMZIPAddress_"  name="wanDev_DMZIPAddress_1.1.0.0" value="">
		<input type="hidden" id="wanDev_HardwareNatEnable_1.1.0.0" name="wanDev_HardwareNatEnable_1.1.0.0" value="">
	</form>
</center>
</body>
<script>
	onPageLoad();
</script>
</html>