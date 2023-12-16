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
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();
	document.title = get_words('TEXT000');
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
		<script>ajax_load_page('menu_left_sup.asp', 'menu_left', 'left_b4');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="maincontent">
				<div id="box_header">
				<h1><script>show_words('help770')</script></h1>
				<table border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td>
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
					</ul></td>
				</tr>
				</table>
				</div>

				<div class="box">
				<h2><A name=Admin><script>show_words('_admin')</script></A></h2>				  	 
					<P><script>show_words('ta_intro_Adm')</script></P>
					<DL>
						<DT><script>show_words('_password_admin')</script>
							<DD><script>show_words('help824')</script>
                  		<DT><script>show_words('ta_GWN')</script>
							<DD><script>show_words('help827')</script>
						<DT><script>show_words('ta_ERM')</script>
							<DD><script>show_words('help828')</script>
						<DT><script>show_words('ta_RAP')</script>
							<DD><script>show_words('help829')</script>
						<DT><script>show_words('help830')</script>
							<DD><script>show_words('help831')</script></DD>
					</DL>
				</div>

				<div class="box">
				<h2><A name=Time><script>show_words('_time')</script></A></h2>
					<P><script>show_words('help840')</script></P>
					<DL>
						<DT><script>show_words('tt_TimeConf')</script>
							<DD>
							<DL>
								<DT><script>show_words('tt_CurTime')</script>
									<DD><script>show_words('help841a')</script>
								<DT><script>show_words('tt_TimeZ')</script>
									<DD><script>show_words('help841')</script>
								<DT><script>show_words('tt_dsen2')</script>
									<DD><script>show_words('help843')</script>
								<DT><script>show_words('tt_dsoffs')</script>
									<DD><script>show_words('help844')</script>
								<DT><script>show_words('help845')</script>
									<DD><script>show_words('help846')</script></DD>
							</DL>
						<DT><script>show_words('tt_auto')</script>
							<DD>
								<DL>
									<DT><script>show_words('tt_EnNTP')</script>
										<DD><script>show_words('help848')</script>
										<P><script>show_words('YM163')</script></P>
									<DT><script>show_words('tt_NTPSrvU')</script>
										<DD><script>show_words('help850')</script></DD>
								</DL>
								<DT><script>show_words('tt_StDT')</script>
									<DD><script>show_words('help851')</script></DD>
					</DL>
					<P><B><script>show_words('_note')</script>: </B>
					<script>show_words('help852')</script></P>
				</div>

				<div class="box">
				<h2><A name=SysLog><script>show_words('help704')</script></A></h2>
				<P><script>show_words('help856')</script></P>
					<DL>
						<DT><script>show_words('help857')</script>
							<DD><script>show_words('help858')</script>
						<DT><script>show_words('tsl_SLSIPA')</script>
							<DD><script>show_words('help859')</script></DD>
					</DL>
				</div>

				<div class="box">
				<h2><A name=EMail><script>show_words('te_EmSt')</script></A></h2>
				<P><script>show_words('te_intro_Em')</script></P>
					<DL>
						<DT><script>show_words('_enable')</script>
						<DD>
							<DL>
							<DT><script>show_words('te_EnEmN')</script>
								<DD><script>show_words('help860')</script></DD>
							</DL>
						<DT><script>show_words('te_EmSt')</script>
						<DD>
							<DL>
								<DT><script>show_words('te_FromEm')</script>
									<DD><script>show_words('help861')</script>
								<DT><script>show_words('te_ToEm')</script>
									<DD><script>show_words('help862')</script>
								<DT><script>show_words('te_SMTPSv')</script>
									<DD><script>show_words('help863')</script>
								<DT><script>show_words('te_EnAuth')</script>
									<DD><script>show_words('help864')</script>
								<DT><script>show_words('te_Acct')</script>
									<DD><script>show_words('help865')</script>
								<DT><script>show_words('_password')</script>
									<DD><script>show_words('help866')</script>
								<DT><script>show_words('_verifypw')</script>
									<DD><script>show_words('help867')</script></DD>
							</DL>
								<DT><script>show_words('help868')</script>
						<DD>
							<DL>
								<DT><script>show_words('te_OnFull')</script>
									<DD><script>show_words('help869')</script>
								<DT><script>show_words('te_OnSch')</script>
									<DD><script>show_words('help870')</script>
								<DT><script>show_words('_sched')</script>
									<DD><script>show_words('help872')</script>
									<P>
										<B><script>show_words('_note')</script>: </B>
										<script>show_words('help873')</script>
									</P>
									</DD>
							</DL>
						</DD>
					</DL>
				</div>

				<div class="box">
				<h2><A name=System><script>show_words('_system')</script></A></h2>
				<P><script>show_words('help874')</script></P>
					<DL>
						<DT><script>show_words('help_ts_ss')</script>
							<DD><script>show_words('help833')</script>
						<DT><script>show_words('help_ts_ls')</script>
							<DD><script>show_words('help834')</script>
						<DT><script>show_words('help_ts_rfd')</script>
							<DD><script>show_words('help876')</script>
						<DT><script>show_words('ts_rd')</script>
							<DD><script>show_words('help875')</script></DD>
					</DL>
				</div>

				<div class="box">
				<h2><A name=Firmware><script>show_words('_firmware')</script></A></h2>
				<P><script>show_words('tf_intro_FWU')</script></P>
				<P><script>show_words('help878')</script></P>
					<OL>
					<LI><script>show_words('help879')</script>
					<LI><script>show_words('help880')</script>
					<LI><script>show_words('help881')</script>
					<LI><script>show_words('help882')</script>
					</LI>
					</OL>
					<DL>
						<DT><script>show_words('help882')</script>
							<DD>
								<P><script>show_words('help883')</script></P>
								<DT><script>show_words('tf_FWUg')</script>
							<DD>
							<P>
								<B><script>show_words('_note')</script>: </B>
								<script>show_words('help886')</script>
							</P>
							<P>
								<B><script>show_words('_note')</script>: </B>
								<script>show_words('help887')</script>
							</P>
							<DL>
								<DT><script>show_words('tf_Upload')</script>
								<DD><script>show_words('help888')</script></DD>
					</DL>
				</div>

				<div class="box">
				<h2><A name=Dynamic_DNS><script>show_words('_dyndns')</script></A></h2>
				<P><script>show_words('help891')</script></P>
					<DL>
						<DT><script>show_words('td_EnDDNS')</script>
							<DD><script>show_words('help892')</script>
						<DT><script>show_words('td_SvAd')</script>
							<DD><script>show_words('help893')</script>
						<DT><script>show_words('_hostname')</script>
							<DD><script>show_words('help894')</script>
						<DT><script>show_words('td_UNK')</script>
							<DD><script>show_words('help895')</script>
						<DT><script>show_words('td_PWK')</script>
							<DD><script>show_words('help896')</script>
						<DT><script>show_words('td_Timeout')</script>
							<DD><script>show_words('help898')</script></DD>
						<DT><script>show_words('_status')</script>
							<DD><script>show_words('help901')</script></DD>
					</DL>
					<P><B>
						<script>show_words('help119')</script>
						<script>show_words('help899')</script>
						</B></P>
					<P>
						<B><script>show_words('help119')</script></B>
						<script>show_words('help900')</script>
					</P>
				</div>

				<div class="box">
				<h2><A name=System_Check><script>show_words('_syscheck')</script></A></h2>
					<dl>
						<dt><script>show_words('tsc_pingt')</script></dt>
							<dd><p><script>show_words('htsc_intro')</script></p>
							<dl>
								<dt><script>show_words('tsc_pingt_h')</script></dt>
									<dd><script>show_words('htsc_pingt_h')</script></dd>
								<dt><script>show_words('_ping')</script></dt>
									<dd><script>show_words('htsc_pingt_p')</script></dd>
							</dl>
							<div class="help_example">
								<dl>
									<dt><script>show_words('help367')</script></dt>
										<dd>
										<dl>
											<dt><script>show_words('tsc_pingt_h')</script></dt>
												<dd>www.whitehouse.gov</dd>
											<dt><script>show_words('tsc_pingr')</script></dt>
												<dd>
													<pre xml:space="preserve"><script>show_words('_success')</script></pre>
												</dd>
										</dl>
										</dd>
								</dl>
							</div>
					</dd>
					</dl>
				</div>

				<div class="box">
				<h2><A name=Schedules><script>show_words('_scheds')</script></A></h2>
				<P><script>show_words('help190')</script></P>
					<DL>
						<DT><script>show_words('KR95')</script>
							<DD><script>show_words('help192')</script>
							<DL>
								<DT><script>show_words('_name')</script>
									<DD><script>show_words('help193')</script>
								<DT><script>show_words('tsc_Days')</script>
									<DD><script>show_words('help194')</script>
								<DT><script>show_words('tsc_24hrs')</script>
									<DD><script>show_words('help195')</script>
								<DT><script>show_words('tsc_StrTime')</script>
									<DD><script>show_words('help196')</script>
								<DT><script>show_words('tsc_EndTime')</script>
									<DD><script>show_words('help197')</script>
								<DT><script>show_words('_save')</script>
									<DD><script>show_words('KR96')</script></DD>
							</DL>
							<DT><script>show_words('tsc_SchRuLs')</script>
								<DD><script>show_words('help199')</script></DD>
					</DL>
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