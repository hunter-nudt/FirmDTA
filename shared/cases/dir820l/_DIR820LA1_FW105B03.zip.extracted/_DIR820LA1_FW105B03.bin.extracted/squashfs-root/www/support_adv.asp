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

	var v4v6 = dev_info.v4v6_support;

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
		<script>ajax_load_page('menu_left_sup.asp', 'menu_left', 'left_b3');</script>
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
						<a href=support_adv.asp#WISH  style="display:none" >WISH</a>
						<li><a href=support_adv.asp#Protected_Setup><script>show_words('LW65')</script></a></li>
						<li><a href=support_adv.asp#Network><script>show_words('_advnetwork')</script></a></li>
						<li><a href=support_adv.asp#GuestZone><script>show_words('_guestzone')</script></a></li>
						<li class="v6_use" style="display:none"><a href=support_adv.asp#IPv6_Firewall><script>show_words('if_iflist')</script></a></li>
						<li class="v6_use" style="display:none"><a href=support_adv.asp#IPv6_Routing><script>show_words('v6_routing')</script></script></a></li>
					</ul>
				</div>
				<div class="box">
				<h2><A name=Virtual_Server><script>show_words('_virtserv')</script></A></h2>
					<P><script>show_words('help2')</script> </P>
					<DIV class=help_example>
						<DL>
							<DT><script>show_words('help3')</script>
								<DD><script>show_words('help4')</script>
							<OL>
								<LI><script>show_words('help5')</script>
								<LI><script>show_words('help6')</script>
								<LI><script>show_words('help7')</script>
								<LI><script>show_words('help8')</script>
								<LI><script>show_words('help9')</script>
								<LI><script>show_words('help10')</script>
								<LI><script>show_words('help11')</script>
								<LI><script>show_words('help12')</script></LI>
							</OL>
							<script>show_words('help13')</script></DD>
						</DL>
					</DIV>
					<DL>
						<DT><script>show_words('help14_p')</script>
							<DD>
							  <DL>
								<DT><script>show_words('_name')</script>
								<DD>
									<script>show_words('help17')</script>
								<DT><script>show_words('_ipaddr')</script>
								<DD>
									<script>show_words('help18')</script><script>show_words('help18_a')</script>
								<DT><script>show_words('av_traftype')</script>
								<DD>
									<script>show_words('help19')</script><script>show_words('help19x1')</script><script>show_words('help19x2')</script>
								<DT><script>show_words('av_PriP')</script>
								<DD>
									<script>show_words('help20')</script>
								<DT><script>show_words('av_PubP')</script>
								<DD>
									<script>show_words('help21')</script>
								<DT><script>show_words('_inboundfilter')</script>
								<DD>
									<script>show_words('help22')</script>
								<DT><script>show_words('_sched')</script>
								<DD>
									<script>show_words('help23')</script></DD>
							  </DL>
						<DT>24&nbsp;--&nbsp;<script>show_words('av_title_VSL')</script>
							<DD>
								<script>show_words('help25_b')</script> </DD>
					</DL>
					<P><B><script>show_words('help26')</script></B> <script>show_words('help27')</script></P>
					<P><script>show_words('help28')</script></P>
					<P><script>show_words('help29')</script></P>
					<P><script>show_words('help30')</script></P>
				</div>
				<div class="box">
					<h2><A name=Gaming><script>show_words('_pf')</script></A></h2>
					<P><script>show_words('help57')</script></P>
					<P><script>show_words('help58')</script> <BR clear=none><script>show_words('help59')</script>
					<BR clear=none><script>show_words('help60')</script> </P>
					<DIV class=help_example>
						<DL>
							<DT><script>show_words('help3')</script>
								<DD><script>show_words('help63')</script> </DD>
						</DL>
					</DIV>
					<DL>
						<DT><script>show_words('help60f')</script>
						<DD>
							<DL>
								<DT><script>show_words('_name')</script>
								<DD>
									<script>show_words('help65')</script>
								<DT><script>show_words('_ipaddr')</script>
								<DD>
									<script>show_words('help66')</script>
								<DT><script>show_words('help67')</script>
								<DD>
									<script>show_words('help68')</script>
								<DT><script>show_words('help69')</script>
								<DD>
									<script>show_words('help70')</script>
								<DT><script>show_words('_inboundfilter')</script>
								<DD>
									<script>show_words('help71')</script>
								<DT><script>show_words('_sched')</script>
								<DD>
									<script>show_words('help72')</script></DD>
							</DL>
						<DIV class=help_example>
							<P><script>show_words('help74')</script></P>
						</DIV>
						<P><script>show_words('KR53')</script> </P>
						<DT>24&nbsp;--&nbsp;<script>show_words('ag_title_4')</script>
						<DD>
							<script>show_words('help75a')</script> </DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Special_Applications> <script>show_words('_specappsr')</script></A></h2>
					<P><script>show_words('help46')</script> </P>
					<DL>
						<DT><script>show_words('haar_p')</script>
						<DD>
							<DIV class=help_example>
								<DL>
								<DT><script>show_words('help3')</script>
								<DD><script>show_words('help47')</script>
								</DD></DL>
							</DIV>
							<DL>
								<dt><script>show_words('_name')</script></dt>
								<dd>
									<script>show_words('help48')</script></dd>
								<dt><script>show_words('_app')</script></dt>
								<dd>
									<script>show_words('help48a')</script></dd>
								<dt><script>show_words('as_TPRange_b')</script></dt>
								<dd>
									<script>show_words('help49')</script></dd>
								<dt><script>show_words('as_TPrt')</script></dt>
								<dd>
									<script>show_words('help50')</script></dd>
								<dt><script>show_words('as_IPR_b')</script></dt>
								<dd>
									<script>show_words('help51')</script></dd>
								<DT><script>show_words('as_FPrt')</script></dt>
								<dd>
									<script>show_words('help52')</script></dd>
								<dt><script>show_words('_sched')</script></dt>
								<DD>
									<script>show_words('help53')</script> </DD>
							</DL>
							<DIV class=help_example>
								<P><script>show_words('help55')</script></P>
							</DIV></DD>
					</DL>
					<DL>
						<DT>24&nbsp;--&nbsp;<script>show_words('_specappsr')</script>
						<DD><script>show_words('help56_a')</script>
							<script>show_words('help75a')</script></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Traffic_Shaping><script>show_words('YM48')</script></A></h2>
					<P><script>show_words('help76')</script> </P>
					<DL>
						<DT><script>show_words('at_title_SESet')</script>
						<DD><DL>
							<dt><script>show_words('at_ESE')</script></dt>
							<dd><script>show_words('help78')</script></dd>
							<dt><script>show_words('at_AUS')</script></dt>
							<dd><script>show_words('help81')</script></dd>
							<dt><script>show_words('at_MUS')</script></dt>
							<dd><script>show_words('help82')</script></dd>
							<dt><script>show_words('at_UpSp')</script></dt>
							<dd><script>show_words('help83')</script></dd>
							<!--DT><DT><script>show_words('_contype')</script>
							<DD><script>show_words('help84')</script>
							<DT><script>show_words('help85')</script>
							<DD><script>show_words('help86')</script> </DD-->
						</DL></DD>
						<dt><script>show_words('at_title_SERules')</script></dt>
						<dd>
							<script>show_words('help88')</script>
							<script>show_words('help88b')</script>
							<p><script>show_words('help88c')</script></p>
						</dd>
						<DT><DD><DL>
							<dt><script>show_words('_name')</script></dt>
							<dd><script>show_words('help90')</script></dd>
							<dt><script>show_words('_priority')</script></dt>
							<dd><script>show_words('help91')</script></dd>
							<dt><script>show_words('_protocol')</script></dt>
							<dd><script>show_words('help92')</script></dd>
							<dt><script>show_words('at_LoIPR')</script></dt>
							<dd><script>show_words('help93')</script></dd>
							<dt><script>show_words('at_LoPortR')</script></dt>
							<dd><script>show_words('help94')</script></dd>
							<dt><script>show_words('at_ReIPR')</script></dt>
							<dd><script>show_words('help95')</script></dd>
							<dt><script>show_words('at_RePortR')</script></dt>
							<dd><script>show_words('help96')</script></dd>
						<DT></DD></DL>

						<DT>10 -- <script>show_words('at_title_SERules')</script>
						<DD><script>show_words('help99_s')</script>
							<script>show_words('help75a')</script>
						</DD>
					</DL>
				</div>

				<div class="box">
					<h2><A name=MAC_Address_Filter><script>show_words('_macfilt')</script> (
						<script>show_words('_netfilt')</script>)</A></h2>
						<P><script>show_words('help149')</script></P>
					<DL>
						<DT>24&nbsp;--&nbsp;<script>show_words('am_MACFILT')</script>

						<DD>
						<DL>
							<DT><script>show_words('am_intro_2')</script></DT>
							<DD><script>show_words('help155_2')</script></DD>
							<DT><script>show_words('_macaddr')</script></DT>
							<DD><script>show_words('help161_2')</script>
								<script>show_words('hham_add')</script></DD>
							<DT><script>show_words('_clear')</script></DT>
							<DD><script>show_words('ham_del')</script></DD>
						</DL>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Access_Control><script>show_words('_acccon')</script></A></h2>
					<P><script>show_words('help117')</script></P>
					<DL>
						<DT><script>show_words('_enable')</script>
						<DD>
							<script>show_words('help118')</script>
							<P>
								<B><script>show_words('help119')</script></B>
								<script>show_words('help120')</script>
							</P>
						</DD>
						<DT><script>show_words('_aa_pol_wiz')</script></DT>
						<DD>
							<script>show_words('help121')</script>
							<DL>
								<DT><script>show_words('_aa_pol_add')</script></DT>
								<DD><script>show_words('_501_12')</script></DD>
							</DL>
						</DD>
						<DT><script>show_words('aa_Policy_Table')</script></DT>
						<DD><script>show_words('help140')</script></DD>
					</DL>
				</div>

				<div class="box">
					<h2><A name=Web_Filter><script>show_words('_websfilter')</script></A></h2>
					<script>show_words('help141')</script>
					<script>show_words('help141_a')</script>
					<DL>
						<DT><script>show_words('awsf_p')</script></DT>
						<DD>
							<DL>
								<DT><script>show_words('aa_WebSite_Domain')</script></DT>
								<DD>
									<script>show_words('dlink_help145')</script>
									<P>
										<B><script>show_words('help119')</script></B>
										<script>show_words('dlink_help146')</script>
									</P>
								</DD>
							</DL></DD>
					</DL>
					<DL>
						<DT>40&nbsp;--&nbsp;<script>show_words('awf_title_WSFR')</script>
						<DD><script>show_words('dlink_help148')</script></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Inbound_Filter><script>show_words('_inboundfilter')</script></A></h2>
					<p><script>show_words('help168a')</script></p>
					<p><script>show_words('help169')</script></p>
					<dl>
						<dt><script>show_words('help170')</script>
						<dd>
							<script>show_words('help171')</script>
							<dl>
								<dt><script>show_words('_name')</script>
								<dd>
									<script>show_words('help172')</script>
								<dt><script>show_words('ai_Action')</script>
								<dd>
									<script>show_words('help173')</script>
								<dt><script>show_words('at_ReIPR')</script>
								<dd>
									<script>show_words('help174')</script>
								<dt><script>show_words('KR56')</script>
								<dd>
									<script>show_words('help175')</script>
								<dt><script>show_words('_clear')</script>
								<dd>
									<script>show_words('KR57')</script>
								</dd>
							</dl>
						<dt><script>show_words('ai_title_IFRL')</script>
						<dd>
							<script>show_words('help176')</script>
						<p><script>show_words('help177')</script>	</p>
						<dl>
							<dt><script>show_words('_allowall')</script>
							<dd>
								<script>show_words('help178')</script>
							<dt><script>show_words('_denyall')</script>
							<dd>
								<script>show_words('help179')</script></dd>
						</dl>
						</dd>
					</dl>
				</div>

				<div class="box">
					<h2><A id=Firewall name=Firewall>
						<script>show_words('_firewalls')</script></A>
					</h2>
					<P>
						<script>show_words('haf_intro_1')</script>
						<script>show_words('haf_intro_2')</script>
					</P>
					<DT><script>show_words('_firewalls')</script></DT>
					<DL>
						<DT><script>show_words('af_ES')</script></DT>
						<DD>
							<script>show_words('help164')</script>
							<script>show_words('help164_1')</script>
							<P><script>show_words('help164_2')</script></P>
						<!-- 2013-12-19 ignore by silvia NO SUPPORT TRUE GIGABITS
							<P><script>show_words('help_auto_disable_hw_nat')</script></P>
						-->
						</DD>
					</DL>
<!--20120111 ignore by silvia               <DT>
                 <script>show_words('_neft')</script>

                <DD>
                  <P>
                    <script>show_words('YM133')</script>
                    </P>
                  <DL>
                    <DT>
                      <script>show_words('af_EFT_0')</script>
                    <DD>
                      <script>show_words('YM134')</script>
                    <DT>
                      <script>show_words('af_EFT_1')</script>
                    <DD>
                      <script>show_words('YM135')</script>
                    <DT>
                      <script>show_words('af_EFT_2')</script>
                    <DD>
                      <script>show_words('YM136')</script>
                    </DD>
                  </DL>
                  <P>
                    <script>show_words('YM137')</script>
                     </P>
                  <DL>
                    <DT>
                      <script>show_words('af_UEFT')</script>
                    <DD>
                      <script>show_words('YM138')</script>
                    <DT>
                      <script>show_words('af_TEFT')</script>
                    <DD>
                      <script>show_words('YM139')</script>
                    </DD>
                  </DL>
				<P>
                    <script>show_words('KR54')</script>
                    <script>show_words('KR55')</script>
                     </P>
 -->
					<DT><script>show_words('KR105')</script>
					<DD>
						<P>
							<script>show_words('KR108')</script></P>
					<DT><script>show_words('_dmzh')</script>
					<DD>
						<P>
							<script>show_words('help165')</script></P>
						<P>
							<script>show_words('haf_dmz_10')</script></P>
						<P>
							<script>show_words('haf_dmz_20')</script></P>
						<P>
							<script>show_words('haf_dmz_30')</script></P>
						<P>
							<script>show_words('haf_dmz_40')</script></P>
						<P>
							<script>show_words('haf_dmz_50')</script></P>
						<UL>
							<LI>
								<script>show_words('haf_dmz_60')</script>
							<LI>
								<script>show_words('haf_dmz_70')</script></LI>
						</UL>
						<DL>
							<DT><script>show_words('af_ED')</script>
								<DD>
								<P>
									<B><script>show_words('help26')</script></B>
									<script>show_words('help166')</script></P>
							<DT><script>show_words('af_DI')</script>
							<DD>
								<script>show_words('help167')</script></DD>
						</DL>
                  <!--DT><script>show_words('af_gss')</script>Non-UDP/TCP/ICMP LAN Sessions
			              <DD>
			              <P><script>show_words('LW48')</script>When a LAN application that uses a protocol other than UDP,
			              TCP, or ICMP initiates a session to the Internet, the router's NAT
			              can track such a session, even though it does not recognize the
			              protocol. This feature is useful because it enables certain
			              applications (most importantly a single VPN connection to a remote
			              host) without the need for an ALG. </P>
			              <P>Note that this feature does not apply to the DMZ host (if one
			              is enabled). The DMZ host always handles these kinds of sessions.
			              </P>
			              <DL>
			                <DT>Enable
			                <DD>Enabling this option (the default setting) enables single
			                VPN connections to a remote host. (But, for multiple VPN
			                connections, the appropriate VPN ALG must be used.) Disabling
			                this option, however, only disables VPN if the appropriate VPN
			                ALG is also disabled. </DD></DL-->

					<DT><script>show_words('af_algconfig')</script>
					<DD>
						<script>show_words('help32')</script>
						<DL>
							<DT><script>show_words('_PPTP')</script>
							<DD>
								<script>show_words('help33')</script>
								<script>show_words('help33b')</script>
							<DT><script>show_words('as_IPSec')</script>
							<DD>
								<script>show_words('help34')</script>
								<P><script>show_words('help35')</script></P>
								<P><script>show_words('help34b')</script></P>
							<DT><script>show_words('as_RTSP')</script>
							<DD><script>show_words('help36')</script>
			                <!--DT>Windows/MSN Messenger
			                <DD>Supports use on LAN computers of Microsoft Windows Messenger
			                (the Internet messaging client that ships with Microsoft
			                Windows) and MSN Messenger. The SIP ALG must also be enabled
			                when the Windows Messenger ALG is enabled.
			                <DT>FTP
			                <DD>Allows FTP clients and servers to transfer data across NAT.
			                Refer to the
                              <a href="adv_virtual.asp">Advanced&rarr;Virtual&nbsp;Server</a>
			                page if you want to host an FTP server.
			                <DT>H.323 (Netmeeting)
			                <DD>Allows H.323 (specifically Microsoft Netmeeting) clients to
			                communicate across NAT. Note that if you want your buddies to
			                call you, you should also set up a virtual server for
			                NetMeeting. Refer to the <A
			                href="adv_virtual.asp">Advanced&rarr;Virtual Server</A> page for information on how to set up a
			                virtual server. -->
							<DT><script>show_words('as_SIP')</script>
							<DD><script>show_words('help40')</script>
			                <!--DT>Wake-On-LAN
			                <DD>This feature enables forwarding of "magic packets" (that is,
			                specially formatted wake-up packets) from the WAN to a LAN
			                computer or other device that is "Wake on LAN" (WOL) capable.
			                The WOL device must be defined as such on the <A
			                href="adv_virtual.asp">Advanced&rarr;Virtual Server</A> page. The LAN IP address for the virtual
			                server is typically set to the broadcast address 192.168.0.255.
			                The computer on the LAN whose MAC address is contained in the
			                magic packet will be awakened.
			                <DT>MMS
			                <DD>Allows Windows Media Player, using MMS protocol, to receive
	                  streaming media from the internet. </DD></DL></DD></DL-->
				</div>
				<div class="box">
					<h2><A name=Routing><script>show_words('_routing')</script></A></h2>
					<DT><script>show_words('_enable')</script>
					<DD><script>show_words('help103')</script>
					<DT><script>show_words('help104')</script>
					<DD><script>show_words('help105')</script>
					<DT><script>show_words('_netmask')</script>
					<DD><script>show_words('help107')</script>
					<DT><script>show_words('_gateway')</script>
					<DD><script>show_words('help109')</script>
					<DT><script>show_words('_metric')</script>
					<DD><script>show_words('help113')</script>
					<DT><script>show_words('help110')</script>
					<DD><script>show_words('help111')</script>
				</div>
				<div class="box">
					<h2><A name=Advanced_Wireless><script>show_words('_adwwls')</script></A></h2>
					<DL>
						<DT><script>show_words('aw_TP')</script>
						<DD>
							<script>show_words('help187')</script>

                  <DT>
                    <script>show_words('KR4_ww')</script>

						<DD>
							<script>show_words('KR58_ww')</script>
						<DT><script>show_words('aw_WE')</script>
						<DD>
							<script>show_words('help188_wmm')</script>
						<DT><script>show_words('aw_sgi')</script>
						<DD>
							<script>show_words('aw_sgi_h1')</script>
							<script>show_words('_worksbest')</script>
					</DL>
				</div>

				<div class="box">
					<h2><A name=Protected_Setup><script>show_words('LW4')</script></A></h2>
					<DL>
						<DT><script>show_words('LW4')</script>
						<DD>
							<DL>
								<DT><script>show_words('_enable')</script>
								<DD>
									<script>show_words('LW55')</script>
								<DT><script>show_words('LW6_1')</script>
								<DD>
									<script>show_words('LY29')</script></DD>
							</DL>
						<DT><script>show_words('LW7')</script>
						<DD>
							<P>
								<script>show_words('LW57')</script></P>
							<DL>
								<DT><script>show_words('LW9')</script>
								<DD>
									<script>show_words('LW58')</script>
								<DT><script>show_words('LW10')</script>
								<DD>
									<script>show_words('LW59')</script>
								<DT><script>show_words('LW11')</script>
								<DD>
									<script>show_words('LW60')</script></DD>
							</DL>
						<DT><script>show_words('LW12')</script>
						<DD>
							<P><script>show_words('LW61')</script></P>
							<P><script>show_words('LW62')</script></P>
							<P><script>show_words('LW63')</script></P>
							<DL>
								<DT><script>show_words('LW13')</script>
								<DD>
									<script>show_words('LW64')</script></DD>
							</DL></DD>
					</DL>
				</div>
				<div class="box">
					<h2><A name=Network><script>show_words('_advnetwork')</script></A></h2>
					<DL>
						<DT><script>show_words('ta_upnp')</script>
						<DD>
							<script>show_words('help_upnp_1')</script>
							<DL>
								<DT><script>show_words('ta_EUPNP')</script>
								<DD>
									<script>show_words('help_upnp_2')</script></DD>
							</DL>
						<DT><script>show_words('anet_wan_ping')</script>
						<DD>
							<script>show_words('anet_wan_ping_1')</script>
							<DL>
								<DT><script>show_words('bwn_RPing')</script>
								<DD>
									<script>show_words('anet_wan_ping_2')</script></DD>
							</DL>
						<DT><script>show_words('anet_wan_phyrate')</script>
						<DD>
							<script>show_words('help296')</script>
						<DT><script>show_words('anet_multicast')</script>
						<DD>
							<script>show_words('bln_IGMP_title_h')</script>
							<DL>
								<DT><script>show_words('anet_multicast_enable')</script>
								<DD>
									<script>show_words('igmp_e_h')</script></DD>
							</DL></DD>
					</DL>
				</div>
				<div class="box">
					<h2><a name="GuestZone"><script>show_words('_guestzone')</script></a></h2>
					<dl>
						<dt><script>show_words('guestzone_title_1')</script></dt>
						<dd>
							<p><script>show_words('IPV6_TEXT5')</script></p>
							<dl>
								<dt><script>show_words('guestzone_enable')</script></dt>
								<dd>
									<script>show_words('IPV6_TEXT6')</script></dd>

								<dt><script>show_words('bwl_NN')</script></dt>
		                        <dd><script>show_words('IPV6_TEXT7')</script></dd>
		                        <dt><script>show_words('IPV6_TEXT3')</script></dt>
		                        <dd><script>show_words('IPV6_TEXT8')</script></dd>
		                        <dt><script>show_words('bws_WSMode')</script></dt>
		                        <dd><script>show_words('IPV6_TEXT9')</script></dd>
		                        <dt><script>show_words('_WEP')</script></dt>
		                        <dd><script>show_words('IPV6_TEXT10')</script></dd>
		                        <dl>
		                            <dt><script>show_words('auth')</script></dt>
		                            <dd><script>show_words('IPV6_TEXT11')</script></dd>
		                            <dt><script>show_words('_both')</script></dt>
		                            <dd><script>show_words('IPV6_TEXT12')</script></dd>
		                            <dt><script>show_words('bws_Auth_2')</script></dt>
		                            <dd><script>show_words('IPV6_TEXT13')</script></dd>
		                            <dt><script>show_words('IPV6_TEXT19')</script></dt>
		                            <dd><script>show_words('IPV6_TEXT14')</script></dd>
		                            <dt><script>show_words('IPV6_TEXT18')</script></dt>
		                            <dd><script>show_words('IPV6_TEXT15')</script></dd>
		                            <dt><script>show_words('IPV6_TEXT16')</script></dt>
		                            <dd><script>show_words('IPV6_TEXT17')</script></dd>
		                        </dl>
		                                <p><script>show_words('help371_n')</script></p>
		                        </dd>
		                        <dt><script>show_words('help372')</script></dt>
		                        <dd>
									<p><script>show_words('help373')</script></p>
		                            <p>
		                                <span class="option"><script>show_words('help374')</script> </span>
		                                <script>show_words('help375')</script>
		                            </p>
		                            <p>
		                                <span class="option"><script>show_words('help376')</script> </span>
		                                <script>show_words('help377')</script>
		                            </p>
		                            <p>
		                                <span class="option"><script>show_words('bws_GKUI')</script>: </span>
		                                <script>show_words('help379')</script>
		                             </p>
		                        </dd>
								<dt><script>show_words('_WPApersonal')</script></dt>
								<dd>
                            		<p><script>show_words('help380')</script> </p>
									<p>
										<span class="option"><script>show_words('_psk')</script>: </span>
										<script>show_words('help382')</script></p>
									<div class="help_example">
										<dl>
											<dt><script>show_words('help367')</script></dt>
											<dd>
												<code><script>show_words('help383')</script></code></dd>
										</dl>
									</div></dd>
								<dt><script>show_words('_WPAenterprise')</script></dt>
								<dd>
		                            <p><script>show_words('help384')</script> </p>
		                            <p>
		                                <span class="option"><script>show_words('help385')</script>: </span>
		                                <script>show_words('help386')</script>
		                            </p>
		                            <p>
		                                <span class="option"><script>show_words('help387')</script> </span>
		                                <script>show_words('help388')</script>
		                            </p>
		                            <p>
		                                <span class="option"><script>show_words('bws_RSP')</script>: </span>
		                                <script>show_words('help390')</script>
		                            </p>
		                            <p>
		                                 <span class="option"><script>show_words('bws_RSSs')</script>: </span>
		                                <script>show_words('help392')</script>
		                            </p>
		                            <p>
		                                <span class="option"><script>show_words('bws_RMAA')</script>: </span>
		                                <script>show_words('help394')</script>
		                            </p>
		                            <p><span class="option"><script>show_words('help395')</script> </span></p>
									<dl>
										<dt><script>show_words('help396')</script></dt>
										<dd>
	                                    <script>show_words('help397')</script>
	                                </dd>
									</dl>
								</dd>
							</dl>
						</dd>
					</dl>
				</div>
				<div class="box" style="display:none">
					<h2><A name=ipv6>Ipv6</A></h2>
					<DT>IPv6
					<DD>
						<script>show_words('IPV6_TEXT76')</script>
					<DT><script>show_words('IPV6_TEXT29a')</script>
					<DD>
						<script>show_words('IPV6_TEXT77')</script>
						<DL>
							<DT><script>show_words('IPV6_TEXT78')</script>
							<DD>
								<script>show_words('IPV6_TEXT79')</script> </DD>
						</DL>
						<DL>
							<DT><script>show_words('IPV6_TEXT80')</script>
							<DD>
								<script>show_words('IPV6_TEXT81')</script> </DD>
						</DL>
						<DL>
							<DT><script>show_words('IPV6_TEXT82')</script>
							<DD>
								<script>show_words('IPV6_TEXT83')</script> </DD>
						</DL>
						<DL>
							<DT><script>show_words('_PPPoE')</script>
							<DD>
								<script>show_words('IPV6_TEXT86')</script> </DD>
							<DD>
								<P><SPAN class=option><script>show_words('carriertype_ct_0')</script>: </SPAN><script>show_words('IPV6_TEXT87')</script> </P>
							<DD>
								<P><SPAN class=option><script>show_words('_sdi_staticip')</script>: </SPAN><script>show_words('IPV6_TEXT88')</script></SPAN> </P>
							<DD>
								<P><SPAN class=option><script>show_words('_srvname')</script>: </SPAN><script>show_words('help267')</script> </P>
							<DD>
								<P><SPAN class=option><script>show_words('bwn_RM')</script>: </SPAN><script>show_words('help269')</script>: </P>
								<UL>
									<LI><SPAN class=option><script>show_words('bwn_RM_0')</script>: </SPAN><script>show_words('help271')</script>
									<LI><SPAN class=option><script>show_words('bwn_RM_1')</script>: </SPAN><script>show_words('help273')</script>
									<LI><SPAN class=option><script>show_words('bwn_RM_2')</script>: </SPAN><script>show_words('help275')</script> </LI>
								</UL>
								<P><SPAN class=option><script>show_words('help276')</script>: </SPAN><script>show_words('IPV6_TEXT89')</script> </P>
							<dt>&nbsp; </dt>
						</DL>
						<DL>
							<DT><script>show_words('IPV6_TEXT90')</script>
							<DD><script>show_words('IPV6_TEXT91')</script>
						</DL>
						<DL>
							<DT><script>show_words('IPV6_TEXT92')</script>
							<DD><script>show_words('IPV6_TEXT93')</script></DD><br>
							<DD><script>show_words('help288')</script></DD><br>
							<DD><script>show_words('IPV6_TEXT94')</script></DD>
						</DL>
					<DT><script>show_words('IPV6_TEXT44')</script>
					<DD>
						<script>show_words('IPV6_TEXT95')</script></DD>
					<DT><script>show_words('_LAN')</script> <script>show_words('IPV6_TEXT48')</script>
					<DD><script>show_words('IPV6_TEXT96')</script></DD>
					<DD>
						<dl>
							<DT><script>show_words('IPV6_TEXT50')</script>
							<DD><script>show_words('IPV6_TEXT97')</script> </DD>
							<DD><script>show_words('IPV6_TEXT98')</script></DD>
							<DD><script>show_words('IPV6_TEXT99')</script></DD>
							<DT><script>show_words('IPV6_TEXT100')</script>
							<DD><script>show_words('IPV6_TEXT101')</script> </DD>
							<DD><script>show_words('IPV6_TEXT102')</script> </DD>
							<DT><script>show_words('IPV6_TEXT56')</script>
		                    <DD><script>show_words('IPV6_TEXT103')</script></DD>
						</dl>
					</DD>
				</div>

				<div class="v6_use" style="display:none">
					<div class="box">
						<h2><A id=IPv6_Firewall name=IPv6_Firewall><script>show_words('if_iflist')</script></a></h2>
						<DL>
							<DT><script>show_words('if_iflist')</script>
							<DD><P><script>show_words('help_171')</script></P>
						</DL>
					</div>
				</div>

				<div class="v6_use" style="display:none">
					<div class="box">
					<h2><A id=IPv6_Routing name=IPv6_Routing><script>show_words('v6_routing')</script></a></h2>
					<DL>
						<DD><P><script>show_words('IPV6_TEXT170')</script></P>
					</DL>
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