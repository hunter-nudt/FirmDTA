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
	var model	= dev_info.model;
	var v4v6 	= dev_info.v4v6_support;
	var dlna_sup	= dev_info.media_server;
	var wfa = +miscObj.config_val('EN_SPEC_WFA_MYDLINK_1_00');

	function onPageLoad()
	{
		if (v4v6 == '1')
			$('.v6_use').show();
		if (dlna_sup == '1')
			$('.dlna_use').show();

		if(wfa)
			$('.wfa-samba').hide();
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
		<script>ajax_load_page('menu_left_sup.asp', 'menu_left', 'left_b2');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="maincontent">
				<div id="box_header">
					<h1><script>show_words('help201a')</script></h1>
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
					<h2><A id=Internet name=Internet><script>show_words('_internetc')</script></a></h2>
					<DL>
						<DT><script>show_words('wwa_setupwiz')</script>
						<DD>
							<P><script>show_words('bi_wiz')</script></P>
						<DT><script>show_words('int_LWlsWz')</script>
						<DD>
							<P><script>show_words('bi_man')</script> </P></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A id=WAN name=WAN><script>show_words('_WAN')</script></A></h2>
					<P><script>show_words('help254')</script></P>
					<DL>
						<DT><script>show_words('bwn_ict')</script>
						<DD>
							<P><script>show_words('help254_ict')</script></P>
						<DL>
							<DT><script>show_words('bwn_SWM')</script>
							<DD>
								<script>show_words('help255')</script> <SPAN class=option><script>show_words('help256')</script></SPAN>, <SPAN class=option><script>show_words('help703')</script></SPAN>, <SPAN
								class=option><script>show_words('_gateway')</script></SPAN>, <SPAN class=option><script>show_words('_dns1')</script></SPAN>, <script>show_words('help257')</script> <SPAN class=option><script>show_words('_dns2')</script></SPAN>. <script>show_words('help258')</script>
							<DT><script>show_words('bwn_DWM')</script>
							<DD><script>show_words('help259')</script>
								<P>
									<SPAN class=option><script>show_words('_hostname')</script>: </SPAN><script>show_words('help261')</script></P>
								<P>
									<SPAN class=option><script>show_words('_use_unicasting')</script>: </SPAN><script>show_words('help261a')</script> </P>
							<DT><script>show_words('_PPPoE')</script>
							<DD>
								<script>show_words('help265')</script> <script>show_words('bw_sap')</script>
								<P>
									<SPAN class=option><script>show_words('carriertype_ct_0')</script>: </SPAN><script>show_words('help265_7')</script> </P>
								<P>
									<SPAN class=option><script>show_words('_sdi_staticip')</script>: </SPAN><script>show_words('help265_2')</script> <SPAN class=option><script>show_words('_ipaddr')</script></SPAN>. </P>
								<P>
									<SPAN class=option><script>show_words('_srvname')</script>: </SPAN><script>show_words('help267')</script> </P>
								<P>
									<SPAN class=option><script>show_words('help268')</script></SPAN><script>show_words('help269')</script></P>
								<UL>
									<LI><SPAN class=option><script>show_words('help270')</script>: </SPAN><script>show_words('help271')</script>
									<LI><SPAN class=option><script>show_words('help272')</script>: </SPAN><script>show_words('help273')</script>
									<LI><SPAN class=option><script>show_words('help274')</script>: </SPAN><script>show_words('help275')</script></LI>
								</UL>
								<P>
									<SPAN class=option><script>show_words('help276')</script>: </SPAN><script>show_words('help277')</script> </P>
							<DT><script>show_words('_PPTP')</script>
							<DD>
								<script>show_words('help278')</script> <script>show_words('bw_sap')</script>
								<P>
									<SPAN class=option><script>show_words('carriertype_ct_0')</script>: </SPAN><script>show_words('help265_7')</script> </P>
								<P>
									<SPAN class=option><script>show_words('_sdi_staticip')</script>: </SPAN><script>show_words('help265_5')</script><SPAN class=option><script>show_words('_PPTPip')</script></SPAN>, <SPAN class=option><script>show_words('help279')</script> </SPAN>, <script>show_words('help257')</script>
									<SPAN class=option><script>show_words('_PPTPgw')</script></SPAN>. </P>
								<P>
									<SPAN class=option><script>show_words('bwn_PPTPSIPA')</script>: </SPAN><script>show_words('help280')</script> </P>
								<P>
									<SPAN class=option><script>show_words('help268')</script></SPAN><script>show_words('help282')</script></P>
								<UL>
									<LI><SPAN class=option><script>show_words('help270')</script>: </SPAN><script>show_words('help271')</script>
									<LI><SPAN class=option><script>show_words('help272')</script>: </SPAN><script>show_words('help273')</script>
									<LI><SPAN class=option><script>show_words('help274')</script>: </SPAN><script>show_words('help275')</script></LI>
								</UL>
								<P>
									<SPAN class=option><script>show_words('help276')</script>: </SPAN><script>show_words('help283')</script> </P>
							<DT><script>show_words('_L2TP')</script>
							<DD>
								<script>show_words('help284')</script> <script>show_words('bw_sap')</script>
								<P>
									<SPAN class=option><script>show_words('bwn_PPTPSIPA')</script>: </SPAN><script>show_words('help265_7')</script> </P>
								<P>
									<SPAN class=option><script>show_words('_sdi_staticip')</script>: </SPAN><script>show_words('help265_5')</script><SPAN class=option><script>show_words('_L2TPip')</script></SPAN>, <SPAN class=option><script>show_words('help285')</script> </SPAN>, <script>show_words('help257')</script>
									<SPAN class=option><script>show_words('_L2TPgw')</script></SPAN>. </P>
								<P>
									<SPAN class=option><script>show_words('bwn_L2TPSIPA')</script>: </SPAN><script>show_words('help280')</script> </P>
								<P>
									<SPAN class=option><script>show_words('help268')</script></SPAN><script>show_words('help286')</script></P>
								<UL>
									<LI><SPAN class=option><script>show_words('help270')</script>: </SPAN><script>show_words('help271')</script>
									<LI><SPAN class=option><script>show_words('help272')</script>: </SPAN><script>show_words('help273')</script>
									<LI><SPAN class=option><script>show_words('help274')</script>: </SPAN><script>show_words('help275')</script></LI>
								</UL>
								<P>
									<SPAN class=option><script>show_words('help276')</script>: </SPAN><script>show_words('help287')</script> </P></DD>
						</DL>
						<DT>
						<DD>
							<P><script>show_words('help288')</script> </P>
							<P>
								<SPAN class=option><script>show_words('help289a')</script>:</SPAN>
								<script>show_words('help290a')</script> </P>
							<P><SPAN class=option><script>show_words('help293')</script>:</SPAN>
								<script>show_words('help294')</script> </P>
							<P><SPAN class=option><script>show_words('help605')</script>:</SPAN>
								<script>show_words('help302')</script> <script>show_words('help304')</script></P></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A id=Wireless name=Wireless><script>show_words('_wireless')</script></a></h2>
					<P><script>show_words('help349')</script> </P>
					<P><script>show_words('help350')</script> </P>
					<DL>
						<DT><script>show_words('bwl_EW')</script>
						<DD>
							<script>show_words('help351')</script>
						<DT><script>show_words('bwl_NN')</script>
						<DD>
							<script>show_words('help352')</script>
						<DT><script>show_words('ebwl_AChan')</script>
						<DD>
							<script>show_words('help354')</script>
						<DT><script>show_words('_wchannel')</script>
						<DD>
							<script>show_words('help355')</script>
						<DT><script>show_words('bwl_Mode')</script>
							<DD><script>show_words('help357')</script>
						<DT><script>show_words('bwl_CWM')</script>
							<DD><script>show_words('bwl_CWM_h1')</script> <script>show_words('bwl_CWM_h2')</script>
						<DT><script>show_words('bwl_VS')</script>
							<DD><script>show_words('help353')</script>
						<DT><script>show_words('bws_SM')</script>
							<DD><script>show_words('bws_SM_h1')</script>
						<DT><script>show_words('_WEP')</script>
						<DD>
							<P>
								<script>show_words('help366')</script> </P>
							<DIV class=help_example>
								<DL>
									<DT><script>show_words('help367')</script>
									<DD>
										<script>show_words('help368')</script>
									<DD>
										<script>show_words('help369')</script>
									<DD>
										<script>show_words('help370')</script>
									<DD>
										<script>show_words('help371')</script></DD>
								</DL>
							</div>
							<P>
								<script>show_words('help371_n')</script> </P>
						<DT><script>show_words('help372')</script>
						<DD>
							<P>
								<script>show_words('help373')</script> </P>
							<P>
								<SPAN class=option><script>show_words('help374')</script></SPAN>&nbsp;<script>show_words('help375')</script> </P>
							<P>
								<SPAN class=option><script>show_words('help378')</script></SPAN>&nbsp;<script>show_words('help379')</script> </P>
						<DT><script>show_words('_WPApersonal')</script>
						<DD>
							<P>
								<script>show_words('help380')</script> </P>
							<P>
								<SPAN class=option><script>show_words('_psk')</script>: </SPAN><script>show_words('help382')</script> </P>
							<DIV class=help_example>
								<DL>
									<DT><script>show_words('help367')</script>
									<DD>
										<CODE><script>show_words('help383')</script></CODE> </DD>
								</DL>
							</div>
						<DT><script>show_words('_WPAenterprise')</script>
						<DD>
							<P><script>show_words('help384')</script> </P>
							<P><SPAN class=option><script>show_words('help385')</script>: </SPAN><script>show_words('help386')</script> </P>
							<P><SPAN class=option><script>show_words('help387')</script></SPAN><script>show_words('help388')</script> </P>
							<P><SPAN class=option><script>show_words('help389')</script></SPAN><script>show_words('help390')</script> </P>
							<P><SPAN class=option><script>show_words('help391')</script></SPAN><script>show_words('help392')</script> </P>
							<P><SPAN class=option><script>show_words('help393')</script>: </SPAN><script>show_words('help394')</script> </P>
							<P><SPAN class=option><script>show_words('help395')</script></SPAN></P>
							<DL>
								<DT><script>show_words('help396')</script>
								<DD>
									<script>show_words('help397')</script> </DD>
							</DL></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A id=Network name=Network><script>show_words('bln_title')</script></A></h2>
					<DL><!-- No Bridge issue 2007.05.08 -->
						<DT><script>show_words('bln_title_Rtrset')</script>
						<DD><script>show_words('help305')</script> <script>show_words('help305rt')</script>
						<DL>
						<DT><script>show_words('help256')</script>
						<DD><script>show_words('help307')</script>
						<DT><script>show_words('help703')</script>
						<DD><script>show_words('help309')</script>
						<DT><script>show_words('DEVICE_NAME')</script>
						<DD><script>show_words('DEVICE_DESC')</script>
						<DT><script>show_words('_262')</script>
						<DD><script>show_words('_1044')</script> <script>show_words('_1044a')</script>
						<DT><script>show_words('bln_title_DNSRly')</script>
						<DD><script>show_words('help312dr2')</script></DD>
					</DL><!--  No Bridge issue 2007.05.18
                        <p>If WAN Port Mode is set to "Bridge Mode", the following choices are displayed in place of the above choices, because the device is functioning as a bridge in a network that contains another router.</p>

                        <dl>

                        <dt>Router IP Address</dt>
                                <dd>The IP address of the this device on the local area network.
                        Assign any unused IP address in the range of IP addresses available for the LAN.
                        For example, 192.168.0.101.</dd>

                        <dt>Subnet Mask</dt>
                                <dd>The subnet mask of the local area network.</dd>

                        <dt>Gateway</dt>
                                <dd>The IP address of the <span>rou</span><span>ter</span> on the local area network.
                                        For example, 192.168.0.1.</dd>
                        <dt>
                                Primary DNS Server, Secondary DNS Server</dt>
                        <dd>
Enter the IP addresses of the DNS Servers. Leave the field for the secondary server empty if not used.
</dd>
                        </dl>
                        -->
						<DT><script>show_words('bd_title_DHCPSSt')</script>
						<DD>
							<P><script>show_words('help314')</script> </P>
							<DL>
								<DT><script>show_words('bd_EDSv')</script>
								<DD>
									<P><script>show_words('help316')</script> </P>
									<P><script>show_words('help317')</script> </P>
									<P><script>show_words('help318')</script> </P>
								<DT><script>show_words('bd_DIPAR')</script>
								<DD>
									<script>show_words('help319')</script>
									<P><script>show_words('help320')</script> </P>
									<P><script>show_words('help321')</script> </P>
									<DIV class=help_example>
										<DL>
											<DT><script>show_words('help367')</script>
											<DD>
												<script>show_words('help322')</script>
											<DT><script>show_words('help367')</script>
											<DD>
												<script>show_words('help323')</script> </DD>
										</DL>
									</div>
								<DT><script>show_words('bd_DLT')</script>
								<DD>
									<script>show_words('help324')</script>
								<DT><script>show_words('help325')</script>
								<DD>
									<script>show_words('help326')</script>
								<DT><script>show_words('bd_NETBIOS')</script>
								<DD>
									<script>show_words('help400_b')</script> <script>show_words('help400_1')</script>
								<DT><script>show_words('bd_NETBIOS_WAN')</script>
								<DD>
									<script>show_words('help401_b')</script> <script>show_words('help401_1')</script>
								<DT><script>show_words('bd_NETBIOS_WINS_1')</script>
								<DD>
									<script>show_words('help402_b')</script> <script>show_words('help402_1')</script> <script>show_words('help402_2')</script>
								<DT><script>show_words('bd_NETBIOS_WINS_2')</script>
								<DD>
									<script>show_words('help403_b')</script>
									<script>show_words('help402_2')</script>
								<DT><script>show_words('bd_NETBIOS_SCOPE')</script>
								<DD>
									<script>show_words('help404_b')</script> <script>show_words('help402_2')</script>
								<DT><script>show_words('bd_NETBIOS_REG')</script>
								<DD>
									<script>show_words('help405_b')</script><BR><script>show_words('help405_1')</script><BR><script>show_words('help405_2')</script><BR><script>show_words('help405_3')</script><BR><script>show_words('help405_4')</script><BR><script>show_words('help402_2')</script><BR></DD>
							</DL>
						<DT><A id="Static_DHCP" name="Static_DHCP"><script>show_words('help330')</script></A>
						<DD>
							<P><script>show_words('help331')</script> </P>
							<DL>
								<DT><script>show_words('bd_CName')</script>
								<DD>
									<P><script>show_words('help345')</script>
									<script>show_words('help367')</script> 
									<CODE><script>show_words('help346')</script></CODE>. </P>
								<DT><script>show_words('_ipaddr')</script>
									<DD><script>show_words('_1066')</script>
								<DT><script>show_words('_macaddr')</script>
								<DD>
									<P><script>show_words('help333')</script> </P>
									<P><script>show_words('help334')</script> </P>
									<P><script>show_words('help335')</script> </P>
									<TABLE summary="">
										<TBODY>
											<TR>
												<TD width="20%"><script>show_words('help336')</script> <BR clear=none><script>show_words('help337')</script> </TD>
												<TD><script>show_words('help338')</script> </TD></TR>
											<TR>
												<TD width="20%"><script>show_words('help339')</script> <BR clear=none><script>show_words('help340')</script> </TD>
												<TD><script>show_words('help341')</script> </TD></TR>
											<TR>
												<TD width="20%"><script>show_words('help342')</script> </TD>
												<TD><script>show_words('help343')</script> </TD></TR></TBODY>
									</TABLE></DD>
							</DL>
						<DT><script>show_words('bd_title_list')</script>
						<DD>
							<script>show_words('help348')</script>
						<DT><script>show_words('bd_title_clients')</script>
						<DD>
							<P><script>show_words('help327')</script> </P>
						<DL>
						<DT><script>show_words('bd_Revoke')</script>
                        <DD><script>show_words('help329')</script>
                        <DT><script>show_words('bd_Reserve')</script>
                        <DD><script>show_words('help329_rsv')</script> </DD></DL></DD></DL>
				</div>

			<div class="dlna_use" style="display:none">
				<div class="box">
					<h2><A id=media name=media><script>show_words('dlna_t')</script></a></h2>
					<DL><P><DD><script>show_words('help_dlna1')</script></P></DL>
				</div>
			</div>

				<div class="box">
					<h2><A id=storage name=storage><script>show_words('storage')</script></a></h2>
					<DL><P><DD><script>document.write(addstr(get_words('help_stor1'), model))</script></P>
					</DL>
					<DL>
						<DT><script>show_words('sto_http_1')</script>
						<DD><P><script>document.write(addstr(get_words('help_stor2'), model))</script></P></DD>
					</DL>
					<DL class="wfa-samba">
						<DT><script>show_words('sto_http_3')</script>
						<DD><P><script>document.write(addstr(get_words('help_stor3'), model))</script> </P></DD>
					</DL>
					<DL class="wfa-samba">
						<DT><script>show_words('sto_http_5')</script>
						<DD><P><script>document.write(addstr(get_words('help_stor4'), model))</script> </P></DD>
					</DL>
					<DL class="wfa-samba">
						<DT><script>show_words('sto_http_6')</script>
						<DD><P><script>show_words('help_stor5')</script> </P></DD>
					</DL>
					<DL>
						<DT><script>show_words('help_stor6')</script>
					</DL>
					<DL>
						<DT><script>show_words('_username')</script>
						<DD><P><script>show_words('help_stor7')</script> </P></DD>
					</DL>
					<DL>
						<DT><script>show_words('_password')</script>/<script>show_words('_verifypw')</script>
						<DD><P><script>show_words('help_stor8')</script> </P></DD>
					</DL>
					<DL>
						<DT><script>show_words('sto_list')</script>
						<DD><P><script>show_words('help_stor9')</script> </P></DD>
					</DL>
				</div>

				<div class="v6_use" style="display:none">
					<div class="box">
					<h2><A id=ipv6 name=ipv6><script>show_words('ipv6')</script></a></h2>
					<DL>
						<DT><script>show_words('ipv6')</script>
						<DD><script>show_words('IPV6_TEXT76');</script> 
						<DT><script>show_words('IPV6_TEXT29');</script> 
						<DD><script>show_words('IPV6_TEXT77');</script> 
					<DL>
						<DT><script>show_words('IPV6_TEXT78');</script> 
						<DD><script>show_words('IPV6_TEXT79');</script></DD>
					</DL>
					<DL>
						<DT><script>show_words('IPV6_TEXT80');</script> 
						<DD><script>show_words('IPV6_TEXT81');</script></DD>
					</DL>
					<DL>
						<DT><script>show_words('IPV6_TEXT82');</script> 
						<DD><script>show_words('IPV6_TEXT83');</script></DD>
					</DL>
					<DL>
						<DT><script>show_words('IPV6_TEXT84');</script> 
						<DD><script>show_words('IPV6_TEXT85');</script> </DD>
					</DL>
					<DL>
						<DT><script>show_words('IPV6_TEXT34');</script> 
						<DD><script>show_words('IPV6_TEXT86');</script> 
					</DD>
					<DD> 
					<P><SPAN class=option><script>show_words('carriertype_ct_0');</script>: </SPAN>
						<script>show_words('IPV6_TEXT87');</script> </P>
					<DD> 
					<P><SPAN class=option><script>show_words('_sdi_staticip');</script>: </SPAN>
						<script>show_words('IPV6_TEXT88');</script></SPAN></P>
					<DD> 
					<P><SPAN class=option><script>show_words('_srvname');</script>: </SPAN>
						<script>show_words('help267');</script> </P>
					<DD> 
					<P><SPAN class=option><script>show_words('bwn_RM');</script>: </SPAN>
						<script>show_words('help269');</script> </P>
					<UL>
						<LI><SPAN class=option><script>show_words('bwn_RM_0');</script>: </SPAN>
							<script>show_words('help271');</script>
						<LI><SPAN class=option><script>show_words('bwn_RM_1');</script>: </SPAN>
							<script>show_words('help273');</script> 
						<LI><SPAN class=option><script>show_words('bwn_RM_2');</script>: </SPAN>
							<script>show_words('help275');</script> </LI>
					</UL>
					<P><SPAN class=option><script>show_words('bwn_MIT');</script>: </SPAN>
						<script>show_words('IPV6_TEXT89');</script> </P>
					<dt>&nbsp; </dt>
					</DL>
					<DL>
						<DT><script>show_words('IPV6_TEXT90');</script> 
						<DD><script>show_words('IPV6_TEXT91');</script> 
					</DL>	
					<DL> <DT><script>show_words('IPV6_TEXT92');</script> 
						<DD><script>show_words('IPV6_TEXT93');</script> </DD><br>
						<DD><script>show_words('help288');</script></DD><br>
						<DD><script>show_words('IPV6_TEXT94');</script></DD>
					</DL>
					<DT><script>show_words('IPV6_TEXT44');</script>
					<DD><script>show_words('IPV6_TEXT95');</script></DD>
					<DT><script>show_words('_LAN');</script> <script>show_words('IPV6_TEXT48');</script> 
					<DD><script>show_words('IPV6_TEXT96');</script></DD>
					<DD> 
					<DL>
						<DT><script>show_words('IPV6_TEXT50');</script> 
						<DD><script>show_words('IPV6_TEXT97');</script> </DD>
						<DD><script>show_words('IPV6_TEXT98');</script></DD>
						<DD><script>show_words('IPV6_TEXT99');</script> 
						<DD><script>show_words('IPV6_TEXT101');</script> </DD>
						<DD><script>show_words('IPV6_TEXT102');</script> </DD>
						<DT><script>show_words('IPV6_TEXT56');</script> 
						<DD><script>show_words('IPV6_TEXT103');</script> </DD>
					</dl>
					</DD>
					</div>
				</div>

				<div class="box">
				<h2><A id=mydlink name=mydlink><script>show_words('mydlink_S01')</script></a></h2>
				<DL>
					<DT><script>show_words('mydlink_S03')</script>
					<DD>
						<P><script>show_words('mydlink_help_01')</script></P>
						<DT><script>show_words('mydlink_S04')</script>
					</DD>
					<DD>
						<P><script>show_words('mydlink_help_02')</script> </P>
					</DD>
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