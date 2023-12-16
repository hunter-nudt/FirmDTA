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

	function onPageLoad()
	{
		if (v4v6 == '1')
			$('.v6_use').show();
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
		<script>ajax_load_page('menu_left_sup.asp', 'menu_left', 'left_b5');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
					<h1> <script>show_words('help771')</script></h1>
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
				<div class="box">
					<h2><A name=Device_Info><script>show_words('_devinfo')</script></A></h2>
					<P>
						<script>show_words('help772')</script>
						<script>show_words('sd_FWV')</script></P>
					<P class=box_alert>
						<script>show_words('help773')</script></P>
					<P>
						<script>show_words('help774')</script></P>
					<DL>
						<DT><script>show_words('help775')</script>
						<DD>
							<script>show_words('help776')</script>
						<DT><script>show_words('help777')</script>
						<DD>
							<script>show_words('help778')</script>
						<DT><script>show_words('_sdi_staticip')</script>
						<DD>
							<script>show_words('KR94')</script></DD>
					</DL>
					<DL>
						<DT><script>show_words('sd_WLAN')</script>
						<DD>
							<script>show_words('LT291')</script>
						<DT><script>show_words('_LANComputers')</script>
						<DD>
							<script>show_words('help781')</script>
						<DT><script>show_words('_bln_title_IGMPMemberships')</script>
						<DD>
							<script>show_words('_bln_title_IGMPMemberships_h')</script></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Logs><script>show_words('_logs')</script></A></h2>
					<P>
						<script>show_words('help795')</script></P>
					<DL>
						<DT><script>show_words('sl_WtV')</script>
						<DD>
							<script>show_words('help796')</script>
							<UL>
								<LI>
									<script>show_words('help797')</script>
								<LI>
									<script>show_words('_system')</script>
								<LI>
									<script>show_words('sl_RStat')</script></LI>
							</UL>
						<DT><script>show_words('sl_VLevs')</script>
						<DD>
							<script>show_words('help798')</script>
							<UL>
								<LI>
									<script>show_words('sl_Critical')</script>
								<LI>
									<script>show_words('sl_Warning')</script>
								<LI>
									<script>show_words('sl_Infrml')</script></LI>
							</UL>
						<DT><script>show_words('sl_ApplySt')</script>
						<DD>
							<script>show_words('help799')</script>
						<DT><script>show_words('sl_reload')</script>
						<DD>
							<script>show_words('help800')</script>
						<DT><script>show_words('_clear')</script>
						<DD>
							<script>show_words('help801')</script>
						<DT><script>show_words('sl_emailLog')</script>
						<DD>
							<script>show_words('help802')</script>
						<DT><script>show_words('sl_saveLog')</script>
						<DD>
							<script>show_words('help803')</script></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Statistics><script>show_words('_stats')</script></A></h2>
					<P>
						<script>show_words('help804')</script></P>
					<DL>
						<DT><script>show_words('ss_Sent')</script>
						<DD>
							<script>show_words('help806')</script>
						<DT><script>show_words('ss_Received')</script>
						<DD>
							<script>show_words('help807')</script>
						<DT><script>show_words('ss_TXPD')</script>
						<DD>
							<script>show_words('help808')</script>
						<DT><script>show_words('ss_RXPD')</script>
						<DD>
							<script>show_words('help809')</script>
						<DT><script>show_words('ss_Collisions')</script>
						<DD>
							<script>show_words('help810')</script>
						<DT><script>show_words('ss_Errors')</script>
						<DD>
							<script>show_words('help811')</script></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Internet_Sessions><script>show_words('YM157')</script></A></h2>
					<P>
						<script>show_words('help813')</script></P>
					<DL>
						<DT><script>show_words('sa_Local')</script>
						<DD>
							<script>show_words('help814')</script>
						<DT><script>show_words('sa_NAT')</script>
						<DD>
							<script>show_words('help817')</script>
						<DT><script>show_words('sa_Internet')</script>
						<DD>
							<script>show_words('help816')</script>
						<DT><script>show_words('_protocol')</script>
						<DD>
							<script>show_words('help815')</script>
						<DT><script>show_words('sa_State')</script>
						<DD>
							<script>show_words('help819')</script>
							<UL>
								<LI>NO:
									<script>show_words('help819_1')</script>
								<LI>SS:
									<script>show_words('help819_2')</script>
								<LI>EST:
									<script>show_words('help819_3')</script>
								<LI>FW:
									<script>show_words('help819_4')</script>
								<LI>CW:
									<script>show_words('help819_5')</script>
								<LI>TW:
									<script>show_words('help819_6')</script>
								<LI>LA:
									<script>show_words('help819_7')</script>
								<LI>CL:
									<script>show_words('help819_8')</script></LI>
							</UL>
						<DT><script>show_words('sa_Dir')</script>
						<DD>
							<script>show_words('help820')</script>
							<DL>
								<DT><script>show_words('_Out')</script>
								<DD>
									<script>show_words('help821a')</script>
								<DT><script>show_words('_In')</script>
								<DD>
									<script>show_words('help822a')</script></DD>
							</DL>
						<DT><script>show_words('sa_TimeOut')</script>
						<DD>
							<script>show_words('help823')</script>
							<script>show_words('help823_1')</script>
							<DL>
								<DT>300&nbsp;<script>show_words('_seconds')</script>
								<DD><script>show_words('help823_11')</script></DD>
								<DT>240&nbsp;<script>show_words('_seconds')</script>
								<DD><script>show_words('help823_13')</script></DD>
								<DT>7800&nbsp;<script>show_words('_seconds')</script>
								<DD><script>show_words('help823_17')</script></DD>
							</DL>
						</DD>
					</DL>
				</div>

				<div class="box">
					<h2><A id=routing name=routing>
						<script>show_words('_routing')</script></a></h2>
					<DL>
						<DT><script>show_words('YM16')</script>
						<DD>
						<P><script>show_words('help105')</script></P>
						<DT><script>show_words('_netmask')</script>
						<DD>
						<P><script>show_words('help107')</script></P>
						</DD>
						<DT><script>show_words('_gateway')</script>
						<DD>
						<P><script>show_words('help109')</script></P>
						<DT><script>show_words('_metric')</script>
						<DD>
						<P><script>show_words('help113')</script></P>
						<DT><script>show_words('_interface')</script>
						<DD>
						<P><script>show_words('help111')</script></P>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Wireless><script>show_words('_wireless')</script></A></h2>
					<P><script>show_words('help782')</script></P>
					<DL>
						<DT><script>show_words('_macaddr')</script>
						<DD>
							<script>show_words('help783')</script>
						<DT><script>show_words('_ipaddr')</script>
						<DD>
							<script>show_words('help784')</script>
						<DT><script>show_words('_mode')</script>
						<DD>
							<script>show_words('help785')</script>
						<DT><script>show_words('_rate')</script>
						<DD>
							<script>show_words('help786')</script>
						<DT><script>show_words('help787')</script>
						<DD><script>show_words('help788')</script></DD>
					</DL>
				</div>

				<div class="v6_use" style="display:none">
					<div class="box">
						<h2><A name=IPv6>IPv6</A></h2>
						<p><script>show_words('STATUS_IPV6_DESC_0')</script></p>
						<DT>
						<script>show_words('STATUS_IPV6_DESC_1')</script>
						<DD> 
						<DL>
							<DT><script>show_words('IPV6_TEXT29a')</script>
							<DD><script>show_words('STATUS_IPV6_DESC_3')</script>
							<DD> 
							<DT><script>show_words('IPV6_TEXT47')</script>
							<DD><script>show_words('STATUS_IPV6_DESC_5')</script></DD>
						</DL>
					
						<DT><script>show_words('TEXT072')</script>
						<DD> 
						<DL>
							<DT><script>show_words('_name')</script>
							<DD><script>show_words('STATUS_IPV6_DESC_2')</script>
							<DD>
							<DT><script>show_words('aa_AT_1')</script>
							<DD><script>show_words('STATUS_IPV6_DESC_4')</script>
							<DD>
								<DT><script>show_words('IPV6_TEXT0')</script>
								<DD><script>show_words('STATUS_IPV6_DESC_6')</script></DD>
							</DD>
						</DL>
					</div>
				</div>

				<div class="v6_use" style="display:none">
					<div class="box">
						<h2><A id=stv6_routing name=stv6_routing>
						<script>show_words('v6_routing')</script></a></h2>
						<DL>
						<DT><script>show_words('v6_routing')</script>
						<DD>
						<P><script>show_words('v6_routing')</script></P>
						<DT><script>show_words('v6_routing')</script>
						<DD>
						<P><script>show_words('v6_routing')</script> </P>
						</DD></DL>
					</div>
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