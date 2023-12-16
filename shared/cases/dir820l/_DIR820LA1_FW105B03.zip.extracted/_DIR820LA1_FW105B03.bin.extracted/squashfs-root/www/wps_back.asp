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

	var from = getUrlEntry('from');

	function do_count_down(){
		$('#show_sec').html(count);

		if (count == 0)
	        return false;

		if (count > 0) {
	        count--;
	        setTimeout('do_count_down()',1000);
	    }
	}

	function back(){
		if(dev_info.login_info!= "w")
			window.location.href ="index.asp";
		else
			window.location.href = $('#html_response_page').val();
	}
	
	function query_wps_state()
	{
		var queryObj = new ccpObject();
		var tmpObj = new ccpObject();
		var paramQueryWPSPIN={
			url: "get_set.ccp",
			arg: "ccp_act=queryWPSPBC"
		}

		queryObj.get_config_obj(paramQueryWPSPIN);
		
		var WPSPBCRet = queryObj.config_val("WPSPBCRet");
		
		if((WPSPBCRet == "success") && (count <=116))
		{
			paramQueryWPSPIN.arg = "ccp_act=doEvent&ccpSubEvent=CCP_SUB_WPSSUCCESS";
			tmpObj.get_config_obj(paramQueryWPSPIN);
			var path = "wps_back_ok.asp";

			if(from == 'adv')
				path += "?from=adv";
			window.location.href = path;
			return;
		}
		else
		{
			paramQueryWPSPIN.arg = "ccp_act=doEvent&ccpSubEvent=CCP_SUB_WPSFAILURE";
			tmpObj.get_config_obj(paramQueryWPSPIN);
		}
		
		if(count == 0)
		{
			paramQueryWPSPIN.arg = "ccp_act=doEvent&ccpSubEvent=CCP_SUB_WPSTIMEOUT";
			tmpObj.get_config_obj(paramQueryWPSPIN);
			var path = "wps_back_fail.asp";

			if(from == 'adv')
				path += "?from=adv";
			window.location.href = path;
			return;
		}
		setTimeout('query_wps_state()',1000);
	}

</script>
</head>

<body>
<center>
	<table class="MainTable" cellpadding="0" cellspacing="0" >
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
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br><br>
		<table width="650" border="0">
		<tr>
			<td>
				<div id=box_header >
					<h1 align="left"><!--Virtual Push Button--><script>show_words('LW13')</script></h1>&nbsp;
					<p align="center">
						<script>show_words('wps_messgae1_2')</script>
						<font color="#FF0000"><span id="show_sec"></span></font>&nbsp;
						<script>show_words('_seconds')</script> &hellip;
					</p>
				</div>
			</form>
			</td>
		</tr>
		</table>
		<p>&nbsp;</p>
		</td>
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
	var count = 120;
	do_count_down();
	query_wps_state();
</script>
</html>