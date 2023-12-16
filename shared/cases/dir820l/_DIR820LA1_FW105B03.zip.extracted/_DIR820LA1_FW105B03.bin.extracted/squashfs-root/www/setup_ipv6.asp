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
		url: 	"get_set.ccp",
		arg: 	"ccp_act=get&num_inst=1&"+
				"oid_1=IGD_&inst_1=1000"
	};
	mainObj.get_config_obj(param);
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

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('IPV6_TEXT112')</script></h1>
				<p><script>show_words('IPV6_TEXT113')</script></p>
			</div>

			<div class=box>
				<h2><script>show_words('IPV6_TEXT110')</script></h2>
				<P><script>show_words('LW27_v6')</script></P>
				<P class=centered><input name="wizard" id="wizard" type="button" class=button_submit value="" onclick=window.location.href="wizard_ipv6.asp">
				<script>get_by_id("wizard").value = get_words('IPV6_TEXT110');</script>
				<p><strong><script>show_words('_note')</script>            :</strong>
					<script>show_words('bwz_note_ConWz')</script>
				</p>
			</div>

			<div class=box>
				<h2><script>show_words('IPV6_ULA_TEXT09')</script></h2>
				<P><script>show_words('IPV6_ULA_TEXT10')</script></P>
				<P class=centered>
				<input name="button3" id="button3" type="button" class=button_submit value="" onclick=window.location.href="ipv6_ula.asp">
					<script>get_by_id("button3").value = get_words('IPV6_ULA_TEXT12');</script>
				</p>
			</div>

			<div class=box>
				<h2><script>show_words('IPV6_TEXT111')</script></h2>
				<P><script>show_words('LW29_v6')</script></P>
				<P class=centered>
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick=window.location.href="sel_ipv6.asp">
					<script>get_by_id("button2").value = get_words('IPV6_TEXT111');</script>
				</p>
			</div>
		</div></td>
		</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

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
	if (login_Info != "w") {
		$('#wizard').attr('disabled',true);
		$('#button2').attr('disabled',true);
		$('#button3').attr('disabled',true);
	}
</script>
</html>