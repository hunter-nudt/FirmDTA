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

	function onPageLoad(){
		$("#html_response_page").val($("#html_response_return_page").val());
	}

	function do_count_down()
	{
		$('#button').attr('disabled',true);
		$("#show_sec").html(count);

		if (count == 0) {
	        get_by_id("button").disabled = false;
	        return;
	    }
	}

	function back(){
			window.location.href ="login.asp";
	}
</script>
<style type="text/css">
<!--
.style1 {color: #FF6600}
-->
</style>
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
		</td>
	</tr>
	</table>
	<form id="form1" name="form1" method="post">
		<input type="hidden" id="html_response_page" name="html_response_page" value="index.asp">
		<input type="hidden" id="html_response_message" name="html_response_message" value="">
		<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="">
		<input type="hidden" name="reboot_type" value="none">
	<!-- main content -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br>
		<table width="650" border="0">
		<tr>
			<td bgcolor="#FFFFFF"><p>&nbsp;</p>
			<table width="650" border="0" align="center">
            <tr>
				<td height="15"><div id=box_header>
					<H1 align="left"><span class="style1">&nbsp;</span></H1>
					<div align="left">
						<p align="center"><script>show_words('li_alert_3');</script></p>
						<p align="center">
						<input name="Button" id="button" type=button class=button_submit onClick="back()">
						<script>$('#button').val(get_words('_login_a'));</script>
					</div>
				</td>
			</tr>
			</table>

			</td>
		</tr>
		</table>
		<p>&nbsp;</p>
		</td>
	</tr>
	</table>
	</form>
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