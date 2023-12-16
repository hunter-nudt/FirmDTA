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
	
	var mainObj = new ccpObject();
	var	param = {
		url: "get_set.ccp",
		arg: 'ccp_act=get&num_inst=1'+
				'&oid_1=IGD_WLANConfiguration_i_WPS_&inst_1=1110'
	};
	mainObj.get_config_obj(param);

	var wps_enable = (mainObj.config_val("wpsCfg_Enable_")? mainObj.config_val("wpsCfg_Enable_"): "0");

	function onPageLoad(){
		if(wps_enable == "1"){
			$('#wps_enable').show();
			$('#wps_disable').hide();
		}else{
			$('#wps_enable').hide();
			$('#wps_disable').show();
		}
	}
	function send_request(){
		if(dev_info.login_info != "w"){
			window.location.href ="user_page.asp";
			return false;
		}else{
			if(!get_by_name("config_method_radio")[0].checked && !get_by_name("config_method_radio")[1].checked){
				alert("Please choose configuration mode!!");
			return false;
			}
			var path = get_checked_value(get_by_name("config_method_radio"));
			
			if(from == 'adv')
				path += "?from=adv";

			window.location.href = path;		
		}
	}

	function cancelOnClick()
	{
		if(from == 'adv')
			window.location.href = "adv_wps_setting.asp";
		else
			window.location.href = "wizard_wireless.asp";
	}
</script>
</head>

<center>
<body>
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
		<br>
		<table width="650" border="0">
		<tr>
			<td>
			<div id="wps_enable" class="box" style="display:none">
				<h2 align="left"><script>show_words('wps_KR35')</script></h2>
				<p class="box_msg"><script>show_words('wps_KR37')</script></p>
				<P><b><script>show_words('KR50')</script></b>
					<INPUT type="radio" id="config_method_radio" name="config_method_radio" value="do_wps.asp" checked >
					<LABEL for=config_method_radio_auto><b></b></LABEL>
					<script>show_words('wps_KR51')</script>
				</P>
				<P><b><script>show_words('bwn_RM_2')</script></b>
					<INPUT type="radio" id="config_method_radio" name="config_method_radio" value="wizard_add_wlan_device.asp">
					<LABEL for=config_method_radio_2><b></b></LABEL>
					<script>show_words('wps_KR42')</script>
				</P>
				<p align="center">
					<input type="button" class="button_submit" id="next_b" name="next_b" value="" onClick="send_request()">
					<input type="button" class="button_submit" id="cancel_b" name="cancel_b" value="" onClick=window.location.href="wizard_wireless.asp">
					<script>$('#next_b').val(get_words('_next'));</script>
					<script>$('#cancel_b').val(get_words('_cancel'));</script>
				</p>
			</div>
			<p></p>
			<div id="wps_disable" class="box" style="display:none">
				<h1 align="left"><script>show_words('LW13')</script></h1>
				<p>&nbsp;</p>
				<p><script>show_words('_wz_disWPS')</script></p>
				<p>&nbsp;</p>
				<p align="center">
					<input type="button" class="button_submit" name="btn_next" id="btn_next" value="" onClick="window.location.href='adv_wps_setting.asp'">
					<script>$("#btn_next").val(get_words('_yes'));</script>
					<input type="button" class="button_submit" name="btn_cancel" id="btn_cancel" value="" onClick="window.location.href='wizard_wireless.asp'">
					<script>$("#btn_cancel").val(get_words('_no'));</script>
				</p>
			</div>
			</td>
		</tr>
		</table>
		<br>
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
	onPageLoad();
</script>
</html>