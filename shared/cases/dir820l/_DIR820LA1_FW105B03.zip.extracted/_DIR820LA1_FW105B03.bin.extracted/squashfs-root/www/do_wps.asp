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

	var wband		= dev_info.wireless_band;

	var from = getUrlEntry('from');
	var submit_button_flag = 0;

	function check_pin()
	{
		var accum = 0;
		accum += 3 * Math.floor((PIN / 10000000) % 10);
		accum += 1 * Math.floor((PIN / 1000000) % 10);
		accum += 3 * Math.floor((PIN / 100000) % 10);
		accum += 1 * Math.floor((PIN / 10000) % 10);
		accum += 3 * Math.floor((PIN / 1000) % 10);
		accum += 1 * Math.floor((PIN / 100) % 10);
		accum += 3 * Math.floor((PIN / 10) % 10);
		accum += 1 * Math.floor((PIN / 1) % 10);

		return (0 == (accum % 10));
	}

	function chk_format()
	{
		//20120119 silvia add chk pin format - 0130 modify 8 num
		PIN = $('#wps_sta_enrollee_pin').val();
		var pins1 = PIN.split(' ');
		var pins2 = PIN.split('-');
		var pins3 = PIN.split('');

		if  ((pins3[4] == '-') || (pins3[4] == ' '))
		{
			if (pins1.length==2)
				PIN = pins1[0] +pins1[1];
			else if (pins2.length==2)
				PIN = pins2[0] +pins2[1];
			if(!_isNumeric(PIN) || pins3.length != 9)
			{
				alert(get_words('KR22_ww'));
				return false;
			}
		}else if ((pins3.length == 8)&&(_isNumeric(PIN))){
			return;
		}else{
			alert(get_words('pin_f'));
			return false;
		}
	}

	function send_request()
	{
		if(!get_by_name("wps_pin_radio")[0].checked && !get_by_name("wps_pin_radio")[1].checked){
			alert(get_words('TEXT012'));
			return false;
		}
		if(get_by_name("wps_pin_radio")[0].checked)
		{
			//20120214 silvia add allow pin 4 chars, no chk pin
			var pinnum = $('#wps_sta_enrollee_pin').val();
			if (pinnum.length == 4)
			{
				if (!_isNumeric(pinnum))
				{
					alert(get_words('pin_f'));
					return false;
				}
				PIN = pinnum;
			}else{
				if (chk_format() == false)
					return false;
				if (!check_pin() || pinnum =='')
				{
					alert(get_words('KR22_ww'));
					return false;
				}
			}

			//$('#wpspinCfg_ClientPINNumber_1.1.1.1.0').val(PIN);
			//$('#wpspinCfg_ClientPINNumber_1.1.3.1.0').val(PIN);
			get_by_id('wpspinCfg_ClientPINNumber_1.1.1.0').value = PIN;
			if (wband == "5G" || wband == "dual")
				get_by_id('wpspinCfg_ClientPINNumber_1.5.1.0').value = PIN;
			
			if(from == 'adv')
				document.form2.nextPage.value += "?from=adv";
			$('#form2').submit();
			//submit_reque();
		}
		else if(get_by_name("wps_pin_radio")[1].checked){
			var wpsObj = new ccpObject();
			var paramForm = {
				url: "get_set.ccp",
				arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WPSPBC&nextPage=wps_back.asp'
			};
			wpsObj.get_config_obj(paramForm);
		}
	}

	function cancelOnClick()
	{
		var path = "wps_wifi_setup.asp";
		if(from == 'adv')
			path += "?from=adv";

		window.location.href = path;
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
				<div class=box>
					<h2 align="left"><script>show_words('wps_LW13')</script></h2>
					<div align="left">
						<p><script>show_words('wps_p3_1')</script> </p>
						<P>-<script>show_words('wps_p3_2')</script> </P>
						<P>-<script>show_words('wps_p3_3')</script> </P>

					<form id="form2" name="form2" method=POST action="get_set.ccp">
						<input type="hidden" name="ccp_act" value="set">
						<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WPSPIN">
						<input type="hidden" name="nextPage" value="do_wps_save.asp">
						<input type="hidden" name="wpspinCfg_ClientPINNumber_1.1.1.0" id="wpspinCfg_ClientPINNumber_1.1.1.0" value="">
						<input type="hidden" name="wpspinCfg_ClientPINNumber_1.5.1.0" id="wpspinCfg_ClientPINNumber_1.5.1.0" value="">
					</form>
					<form id="form1" name="form1" method="post" action="">
						<input type="hidden" id="html_response_page" name="html_response_page" value="do_wps_save.asp">
						<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="do_wps.asp">
						<input type="hidden" id="reboot_type" name="reboot_type" value="none">
						<table align="center" class="formarea">
						<tr>
							<td width="50%" align="right"><input id="wps_pin_radio" name="wps_pin_radio" value="0" type="radio" checked="checked"></td>
							<td width="50%">
								<b>PIN :&nbsp;</b>
								<input id="wps_sta_enrollee_pin" name="wps_sta_enrollee_pin" maxlength="9" type="text">
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<p><script>show_words('wps_p3_4')</script></p>
								<p></p>
							</td>
						</tr>
						<tr>
							<td align="right"><INPUT type="radio" id="wps_pin_radio" name="wps_pin_radio" value="1"></td>
							<td><b>PBC&nbsp;</b></td>
						</tr>
						<tr>
							<td colspan="2">
								<p><script>show_words('wps_p3_5')</script></p>
								<p></p>
							</td>
						</tr>
						<tr align="center">
							<td colspan="3">
								<input name="btn_prev" id="btn_prev" type="button" class=button_submit value="" onClick="cancelOnClick()"> 
								<input name="btn_connect" id="btn_connect" type="button" class=button_submit value="" onClick="send_request()">
								<script>$('#btn_prev').val(get_words('_prev'));</script>
								<script>$('#btn_connect').val(get_words('_connect'));</script>
							</td>
						</tr>
						</table>
					</form>
 
				</div>
			</div>
			<p>&nbsp;</p>
			</td>
		</table>

		</tr>

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