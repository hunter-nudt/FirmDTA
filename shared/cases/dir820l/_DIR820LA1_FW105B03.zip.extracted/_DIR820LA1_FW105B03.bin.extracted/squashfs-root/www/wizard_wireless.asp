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

	var mainObj = new ccpObject();
	mainObj.set_param_url('get_set.ccp');
	mainObj.set_ccp_act('get');
	mainObj.add_param_arg('IGD_WLANConfiguration_i_WPS_',1110);
	if (wband == "2.4G" || wband == "dual")
		mainObj.add_param_arg('IGD_WLANConfiguration_i_',1100);
	if (wband == "5G" || wband == "dual")
		mainObj.add_param_arg('IGD_WLANConfiguration_i_',1500);

	mainObj.get_config_obj();

	var wlanEnable = mainObj.config_str_multi("wlanCfg_Enable_");
	var wpsEnable = mainObj.config_val("wpsCfg_Enable_");

$(function(){
	if (login_Info != "w" ) 
	{
		$('#wps_wizard').attr('disabled',true);
		$('#wireless_wizard').attr('disabled',true);
		$('#wizard').attr('disabled',true);
	}
	else
	{
		if( wpsEnable == "0")
			$('#wps_wizard').attr('disabled',true);
		else
		{
			if ((wband == "5G" || wband == "2.4G") && wlanEnable[0]==0)
				$('#wps_wizard').attr('disabled',true);

			if (wband == "dual" && wlanEnable[0]==0 && wlanEnable[1]==0)
				$('#wps_wizard').attr('disabled',true);
		}
	}
});
</script>
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
}
.style2 {font-size: 11px}
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b2');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('LW38')</script></h1>
				<p><script>show_words('LW39')</script></p>
				<p><script>show_words('LW39c')</script></p>
			</div>
			<div class=box>
				<h2><script>show_words('wwl_wl_wiz')</script></h2>
				<script>show_words('LW41')</script><br><br>
				<center>
					<input type="button" class="button_submit" id="wireless_wizard" name="wireless_wizard" value="" onClick=window.location.href="wizard_wlan.asp">
					<script>$('#wireless_wizard').val(get_words('wwl_wl_wiz'));</script>
				</center><br><br>
				<strong>
				<script>show_words('_note')</script>:</strong>
				<script>show_words('bwz_note_WlsWz')</script>
			</div>

			<div class=box>
			<h2><script>show_words('wps_LW13')</script></h2>
				<script>show_words('LW40')</script><br><br>
				<center>
					<input type="button" class="button_submit" id="wps_wizard" name="wps_wizard" value="" onClick=window.location.href="wps_wifi_setup.asp">
					<script>$('#wps_wizard').val(get_words('LW13'));</script>
				</center>
			</div>
			<div class=box>
				<h2><script>show_words('LW42')</script></h2>
				<script>show_words('LW43')</script>
				<script>show_words('LW44')</script>
				<br><br>
				<center>
					<input type="button" class="button_submit" id="wizard" name="wizard" value="" onClick=window.location.href="wireless.asp">
					<script>$('#wizard').val(get_words('LW42'));</script>
				</center>
			<br>
			</div>
		</div></td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('LW46')</script></p>
			<p><script>show_words('LW47')</script></p>
			<p class="more"><a href="support_internet.asp#Wireless">
				<script>show_words('_more')</script>&hellip;</a></p>
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
</html>