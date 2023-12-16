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
	var v4v6 	= dev_info.v4v6_support;
	var dlna_sup	= dev_info.media_server;

	function onPageLoad()
	{
		if (v4v6 == '1')
			$('.v6_use').show();
		if (dlna_sup == '1')
			$('.dlna_use').show();
	}
</script>
</head>

<body onload="onPageLoad();">
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b5');</script>
		<!-- end of top menu -->
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="topnav_container" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<!-- left menu -->
		<td id="sidenav_container" width="125" valign="top">
		<div id="menu_left"></div>
		<script>ajax_load_page('menu_left_sup.asp', 'menu_left', 'left_b1');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="maincontent">
				<div id="box_header">
					<h1><script>show_words('help767s')</script></h1>
						<ul>
							<li><a href="#Setup"><script>show_words('_setup')</script></a></li>
							<li><a href="#Advanced"><script>show_words('_advanced')</script></a></li>
							<li><a href="#Tools"><script>show_words('_tools')</script></a></li>
							<li><a href="#Status"><script>show_words('_status')</script></a></li>
						</ul>
				</div>
				<div class="box">
					<h2><font size=4><b><a name=Setup><script>show_words('help201a')</script></a></b></font></h2>
					<ul>
						<li><a href=support_internet.asp#Internet><script>show_words('_internetc')</script></a></li>
						<li><a href=support_internet.asp#WAN><script>show_words('_WAN')</script></a></li>
						<li><a href=support_internet.asp#Wireless><script>show_words('_wireless')</script></a></li>
						<li><a href=support_internet.asp#Network><script>show_words('bln_title_NetSt')</script></a></li>
						<li><a href=support_internet.asp#storage><script>show_words('storage')</script></a></li>
						<li class="dlna_use" style="display:none"><a href=support_internet.asp#media><script>show_words('dlna_t')</script></a></li>
						<li class="v6_use" style="display:none"><a href=support_internet.asp#ipv6><script>show_words('ipv6')</script></a></li>
						<li><a href=support_internet.asp#mydlink><script>show_words('mydlink_help_03')</script></a></li>
					</ul>
				</div>
				<div class="box">
					<h2><font size=4><b><a name=Advanced><script>show_words('help1')</script></a></b></font></h2>
					<ul>
						<li><a href=support_adv.asp#Virtual_Server><script>show_words('_virtserv')</script></a></li>
						<li><a href=support_adv.asp#Gaming><script>show_words('_pf')</script></a></li>
						<li><a href=support_adv.asp#Special_Applications><script>show_words('_specappsr')</script></a></li>
						<li><a href=support_adv.asp#Traffic_Shaping><script>show_words('YM48')</script></a></li>
						<li><a href=support_adv.asp#MAC_Address_Filter><script>show_words('_netfilt')</script></a></li>
						<li><a href=support_adv.asp#Access_Control><script>show_words('_acccon')</script></a></li>
						<li><a href=support_adv.asp#Web_Filter><script>show_words('_websfilter')</script></a></li>
						<li><a href=support_adv.asp#Inbound_Filter><script>show_words('_inboundfilter')</script></a></li>
						<li><a href=support_adv.asp#Firewall><script>show_words('_firewalls')</script></a></li>
						<li><a href=support_adv.asp#Routing><script>show_words('_routing')</script></a></li>
						<li><a href=support_adv.asp#Advanced_Wireless><script>show_words('_adwwls')</script></a></li>
						<li><a href=support_adv.asp#Protected_Setup><script>show_words('LW65')</script></a></li>
						<li><a href=support_adv.asp#Network><script>show_words('_advnetwork')</script></a></li>
						<li><a href=support_adv.asp#GuestZone><script>show_words('_guestzone')</script></script></a></li>
                        <li class="v6_use" style="display:none"><a href=support_adv.asp#IPv6_Firewall><script>show_words('if_iflist')</script></a></li>
                        <li class="v6_use" style="display:none"><a href=support_adv.asp#IPv6_Routing><script>show_words('v6_routing')</script></script></a></li>
					</ul>
				</div>
				<div class="box">
					<h2><font size=4><b><a name=Tools><script>show_words('help770')</script></a></b></font></h2>
					<ul>
						<li><a href=support_tools.asp#Admin><script>show_words('_admin')</script></a></li>
						<li><a href=support_tools.asp#Time><script>show_words('_time')</script></a></li>
						<li><a href=support_tools.asp#SysLog><script>show_words('help704')</script></a></li>
						<li><a href=support_tools.asp#EMail><script>show_words('te_EmSt')</script></a></li>
						<li><a href=support_tools.asp#System><script>show_words('_system')</script></a></li>
						<li><a href=support_tools.asp#Firmware><script>show_words('_firmware')</script></a></li>
						<li><a href=support_tools.asp#Dynamic_DNS><script>show_words('_dyndns')</script></a></li>
						<li><a href=support_tools.asp#System_Check><script>show_words('_syscheck')</script></a></li>
						<li><a href=support_tools.asp#Schedules><script>show_words('_scheds')</script></a></li>
					</ul>
				</div>
				<div class="box">
					<h2><font size=4><b><a name=Status><script>show_words('help771')</script></a></b></font></h2>
					<ul>
                        <li><a href=support_status.asp#Device_Info><script>show_words('_devinfo')</script></a></li>
                        <li><a href=support_status.asp#Logs><script>show_words('_logs')</script></a></li>
                        <li><a href=support_status.asp#Statistics><script>show_words('_stats')</script></a></li>
                        <li><a href=support_status.asp#Internet_Sessions><script>show_words('YM157')</script></a></li>
						<li><a href=support_status.asp#routing><script>show_words('_routing')</script></a></li>
						<li><a href=support_status.asp#Wireless><script>show_words('_wireless')</script></a></li>
                        <li class="v6_use" style="display:none"><a href=support_status.asp#IPv6><script>show_words('ipv6')</script></a></li>
						<li class="v6_use" style="display:none"><a href=support_status.asp#stv6_routing><script>show_words('v6_routing')</script></a></li>
					</ul>
				</div>
            </div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>
	</tr>
	</table>

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
</html>