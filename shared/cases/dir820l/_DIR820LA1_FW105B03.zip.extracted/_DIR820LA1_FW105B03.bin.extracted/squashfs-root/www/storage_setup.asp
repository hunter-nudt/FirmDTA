<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css" />
<link rel="stylesheet" type="text/css" href="js/jquery.treeview.css" />
<link rel="stylesheet" type="text/css" href="js/jquery-ui.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="js/jquery.treeview.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
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
	var sendSubmit  = false;
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b4');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
		<div id=maincontent>
			<div id=box_header> <!-- remember to add all the <script></script> back to the string -->
				<h1><script>show_words('storage')</script></h1>
				<p><script>show_words('sh_port_tx_01')</script></p>
				<p><script>show_words('sh_port_tx_02')</script></p>
			</div>

			<div class=box>
				<h2><script>show_words('sh_port_tx_03')</script></h2>
				<P><script>show_words('sh_port_tx_04')</script></P>
				<P class=centered><input value='&trade;' name="wizard_storage" id="wizard_storage" type="button" class=button_submit onclick=window.location.href="wizard_storage.asp">
				<script>$("#wizard_storage").val(get_words('sh_port_tx_00a')+$("#wizard_storage").val() +" "+ get_words('sh_port_tx_00b') +" "+get_words('wwa_setupwiz'));</script>
				</p>
			</div>

			<div class=box>
				<h2><script>show_words('sh_port_tx_05')</script></h2>
				<P><script>show_words('sh_port_tx_06')</script></P>
				<P class=centered><input value='&trade;' name="storage" id="storage" type="button" class=button_submit onclick=window.location.href="storage.asp">
				<script>$("#storage").val(get_words('sh_port_tx_00a')+$("#storage").val() +" "+ get_words('sh_port_tx_00b') +" "+get_words('ES_manual_btn'));</script>
				</p>
			</div>
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
			<p><script>show_words('sto_help')</script></p>
			<p><script>
				var str = get_words('LW34');
				var tmp_str = str.substring(str.search("<strong>")+8,str.search("</strong>"));
				document.write(str.replace(tmp_str,$("#storage").val()));
			</script></p>
			<p class="more"><a href="support_internet.asp#storage"><script>show_words('_more')</script>&hellip;</a></p>
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
