<html lang=en-US xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
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

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;
	var auth 		= miscObj.config_val("graph_auth");

	function do_count_down(){
		$('#show_sec').html(count);

		if (count == 0) {
			$('#bt_continue').attr('disabled',false);
	        return;
	    }

		if (count > 0) {
	        count--;
	        setTimeout('do_count_down()',1000);
	    }
	}

	function do_redirect()
	{
		if(targetPage == "")
			window.location.href = "index.asp";
		else
			window.location.href = targetPage;
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

	<!-- main content -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br><br>
		<table width="650" border="0">
		<tr>
			<td>
			<form id="form1" name="form1" method="post">
				<input type="hidden" id="html_response_page" name="html_response_page" value="index.asp">
				<input type="hidden" id="html_response_message" name="html_response_message" value=''>
				<input type="hidden" id="html_response_return_page" name="html_response_return_page" value=''>
				<input type="hidden" name="reboot_type" value="none">

			<div id=box_header>
                  <h1><script>show_words('sc_intro_sv')</script></h1>
				  
                  <p class="centered"><script>show_words('rb_wait')</script></p>
				  <p class="centered"><script>show_words('sc_intro_sv')</script></p>
						<span id="for_lan_page"></span><br>
					<p class="centered"><input name="bt_continue" id="bt_continue" type="button" value="" onClick="do_redirect()" disabled></p>
						<script>$('#bt_continue').val(get_words('_continue'));</script>
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
	var count = 15;
	
	var targetPage = getUrlEntry('page');
	var temp_count = getUrlEntry('count');

	if(temp_count != null && temp_count != "")
		count = parseInt(temp_count);

	if (targetPage == null)
		window.location.href =  "login.asp";

	if(targetPage == "lan.asp")
		$('#for_lan_page').html('<p>'+get_words('rb_change')+'</p>');

	//20121224 Silvia add send event on countdown page
	if(targetPage == "wireless.asp")
	{
		var eventObj = new ccpObject();
		var param={
			url: "get_set.ccp",
			arg: ""
		};

		param.arg += "ccp_act=doEvent&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY";
		eventObj.get_config_obj(param);
	}

	do_count_down();
</script>
</html>