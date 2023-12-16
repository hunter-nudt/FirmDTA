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


	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=3";
	param.arg +="&oid_1=IGD_WANDevice_i_&inst_1=1100";
	param.arg +="&oid_2=IGD_WANDevice_i_IPv6Status_&inst_2=1110";
	param.arg +="&oid_3=IGD_LANDevice_i_ULA_&inst_3=1110";
	mainObj.get_config_obj(param);

	var lan_ipv6_linklocal_addr = filter_ipv6_addr(mainObj.config_val("igdIPv6Status_IPv6LanLinkLocalAddress_"));
	var enable_ula = mainObj.config_val("igdULASetup_ULAEnable_");
	var lan_ipv6_ula_addr = filter_ipv6_addr(mainObj.config_val("igdIPv6Status_IPv6LanULAAddress_"));
	var ipv6_type = mainObj.config_val("wanDev_CurrentConnObjType6");

    var submit_button_flag = 0;
    function onPageLoad() {
        $('#lan_link_local_ip').html(lan_ipv6_linklocal_addr.toUpperCase()+"/64");
        if(enable_ula !=0)
        	$('#lan_ula_ip').html(lan_ipv6_ula_addr.toUpperCase());
		else
			tr_ula_lan_ip.style.display="none";
    }

    function send_request()
    {
        if (submit_button_flag == 0) {
            submit_button_flag = 1;
			sendsubmit();
            return true;
        }
        return false;
    }
	
	function sendsubmit()
	{
		var submitObj = new ccpObject();
		var param1 = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=sel_ipv6.asp'
		};
		param1.arg += "&wanDev_CurrentConnObjType6_1.1.0.0=7";
		
		submitObj.get_config_obj(param1);
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
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'ipv6_link_local.asp');">
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
						<option value="2"><script>show_words('IPV6_TEXT107')</script></option>
						<option value="3"><script>show_words('IPV6_TEXT34')</script></option>
						<option value="4"><script>show_words('IPV6_TEXT35')</script></option>
						<option value="5"><script>show_words('IPV6_TEXT36')</script></option>
						<option value="6"><script>show_words('IPV6_TEXT139')</script></option>
						<option value="7" selected><script>show_words('IPV6_TEXT37')</script></option>
					</select></td>
				</tr>
				</table>
			</div>
			<div class=box id=lan_ipv6_settings>
				<h2 style=" text-transform:none"><script>show_words('IPV6_TEXT44')</script></h2>
				<p class="style2"><script>show_words('IPv6_Local_Info')</script></p>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td width="225" ><b><script>show_words('IPV6_TEXT47')</script> :</b></td>
					<td width="310">&nbsp;<b><span id="lan_link_local_ip"></span></b></td>
				</tr>
				<tr id="tr_ula_lan_ip">
					<td width="225" ><b><script>show_words('IPV6_ULA_TEXT08')</script> :</b></td>
					<td width="310">&nbsp;<b><span id="lan_ula_ip"></span></b></td>
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