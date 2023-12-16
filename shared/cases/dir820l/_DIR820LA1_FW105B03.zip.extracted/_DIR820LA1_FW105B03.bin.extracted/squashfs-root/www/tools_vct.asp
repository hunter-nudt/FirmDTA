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
	var cli_mac 	= dev_info.cli_mac;
	var v4v6 		= dev_info.v4v6_support;

	var result = '';

	function onPageLoad()
	{
		if (v4v6 == '1')
			$('.v6_use').show();
	}

	function disablePinItem(opt)
	{
		$('#ping').attr('disabled',opt);
		$('#ping_ipaddr').attr('disabled',opt);
	}
	function disablePinItem6(opt)
	{
		$('#ping_v6').attr('disabled',opt);
		$('#ping6_ipaddr').attr('disabled',opt);
	}

	function check_ip(){
		if ($('#ping_ipaddr').val() == ""){
			alert(LangMap.which_lang['tsc_pingt_msg2']);
			return false;
		}
		
		disablePinItem(true);
		
		var paramPing = {
			url: "ping.ccp",
			arg: 'ccp_act=ping_v4&ping_addr='+$('#ping_ipaddr').val()
		};
		ajax_submit(paramPing);

		$('#ping_result').html(get_words('_testing_'));
		setTimeout("queryPingRet()",1*1000);
	}

	function check_ipv6_ip()
	{
		if ($('#ping6_ipaddr').val() == ""){
			alert(LangMap.which_lang['tsc_pingt_msg2']);
			return false;
		}

		disablePinItem6(true);
		
		var paramPing = {
			url: "ping.ccp",
			arg: 'ccp_act=ping_v6&ping_addr='+$('#ping6_ipaddr').val()
		};
		ajax_submit(paramPing);
		
		$('#ping_result').html(get_words('_testing_'));

		setTimeout("queryPingRet6()",1*1000);
	} 

	function queryPingRet()
	{
		var pingObj = new ccpObject();
		var paramQuery = {
			url: "ping.ccp",
			arg: "ccp_act=queryPingV4Ret"
		};

		pingObj.get_config_obj(paramQuery);
		var ret = pingObj.config_val("ping_result");
		switch(ret)
		{
			case "waiting":
				setTimeout("queryPingRet()",1*1000);
			return;

			case "success":
				disablePinItem(false);
				$('#ping_result').html(addstr(get_words('_ping_success'), $('#ping_ipaddr').val()));
			return;
			case "fail":
				disablePinItem(false);
				$('#ping_result').html(addstr(get_words('_ping_fail'), $('#ping_ipaddr').val()));
			return;
		}
	}
	function queryPingRet6()
	{
		var ping6Obj = new ccpObject();
		var paramQuery = {
			url: "ping.ccp",
			arg: "ccp_act=queryPingV6Ret"
		};
		
		ping6Obj.get_config_obj(paramQuery);
		
		var ret = ping6Obj.config_val("ping_result");
		switch(ret)
		{
			case "waiting":
				setTimeout("queryPingRet6()",1*1000);
			return;
			
			case "success":
				disablePinItem6(false);
				$('#ping_result').html(addstr(get_words('_ping_success'), $('#ping6_ipaddr').val()));
			return;
			case "fail":
				disablePinItem6(false);
				$('#ping_result').html(addstr(get_words('_ping_fail'), $('#ping6_ipaddr').val()));
			return;
		}
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b3');</script>
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
		<script>ajax_load_page('menu_left_tools.asp', 'menu_left', 'left_b8');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
			<h1><script>show_words('tsc_pingt')</script></h1>
			<p><script>show_words('tsc_pingt_mesg')</script></p>
		</div>

		<div class=box> 
			<h2><script>show_words('tsc_pingt')</script></h2>
			<!--P>Ping Test is used to send &quot;Ping&quot; packets to test if a computer is on the Internet.</P-->
			<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<form id="form5" name="form5" method="post" action="">
					<input type="hidden" id="html_response_page" name="html_response_page" value="tools_vct.asp">
					<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="tools_vct.asp">
					<tr>
						<td>
							<div align="right"><strong>
								<script>show_words('tsc_pingt_h')</script>
								&nbsp;:&nbsp;</strong></div></td>
						<td height="20" valign="top">&nbsp;
							<input type="text" id="ping_ipaddr" name="ping_ipaddr" size=30 maxlength=63 value="" >
							<script>document.write('<input name="ping" id="ping" type="button" value="'+get_words('_ping')+'" onClick="check_ip()">')</script></td>
					</tr>
				</form>
			</table>
		</div>
		<div class="v6_use" style="display:none">
			<div class="box">
			<h2><script>show_words('tsc_pingt_v6')</script></h2>
			<!--P>Ping Test is used to send &quot;Ping&quot; packets to test if a computer is on the Internet.</P-->
			<table cellSpacing=1 cellPadding=1 width=525 border=0>

			<form id="form6" name="form6" method="post" action="">
				<input type="hidden" id="html_response_page" name="html_response_page" value="tools_vct.asp">
				<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="tools_vct.asp">
				<tr>
					<td>
					<div align="right"><strong>
					<script>show_words('tsc_pingt_h_v6')</script>
					&nbsp;:&nbsp;</strong></div></td>
					<td height="20" valign="top">&nbsp;
					<input type="text" id="ping6_ipaddr" name="ping6_ipaddr" size=30 maxlength=63 value="" >
					<script>document.write('<input name="ping_v6" id="ping_v6" type="button" value="'+get_words('_ping')+'" onClick="check_ipv6_ip()">')</script>
				</tr>
			</form>
			</table>
			</div>
		</div>

        <div class=box> 
			<h2><script>show_words('tsc_pingr')</script></h2>
			<table cellSpacing=1 cellPadding=1 width=525 border=0>
			<tr>
				<td>
					<div align="center" width="100%"></div>
				</td>
				<td height="20" valign="top" align="center">&nbsp;<span id="ping_result"><script>show_words('tsc_pingt_msg1')</script></span></td>
			</tr>
			</table>
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
			<p><script>show_words('hhtsc_pingt_intro')</script></p>
			<p><script>show_words('htsc_pingt_h')</script></p>
			<p><a href="support_tools.asp#System_Check"><script>show_words('_more')</script>&hellip;</a></p>
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