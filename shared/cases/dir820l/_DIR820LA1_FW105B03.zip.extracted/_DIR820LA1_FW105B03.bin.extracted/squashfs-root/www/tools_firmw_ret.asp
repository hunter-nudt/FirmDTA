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
	var auth 		= miscObj.config_val("graph_auth");

	var arr_page = [
		'err_checksum',
		'err_hwid',
		'err_file',
		'success'
	];

	function toggle_page(id) {
		if (arr_page == null || (arr_page instanceof Array) == false)
			return;
		for (var i=0; i<arr_page.length; i++) {
			if (id == i)
				$('#'+arr_page[i]).show();
			else
				$('#'+arr_page[i]).hide();
		}
	}

	$(document).ready( function () {
		var msg = getUrlEntry('msg');
		if (msg == 'cfgupgrade') {
			$('#cfg_failed').show();
		} else if (msg == 'fwupgrade') {
			$('#fw_failed').show();
		}
	});
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
<table id="topnav_container" border="1" cellpadding="2" cellspacing="0" width="838" height="50%" align="center" bgcolor="#FFFFFF" bordercolordark="#FFFFFF">
<tr>
	<td valign="top" align="center" id="maincontent_container">
	<div id="maincontent">
	
	<div id="err_checksum" style="width:600; display:none">
		Checksum error!
		<input type="button" id='btn_err_checksum' onclick="location.replace('tools_firmw.asp')">
		<script>$('#btn_err_checksum').val(get_words('_back'))</script>
	</div>
	
	<div id="err_hwid" style="width:600; display:none">
		Bad hardware ID!
		<input type="button" id='btn_err_hwid' onclick="location.replace('tools_firmw.asp')">
		<script>$('#btn_err_hwid').val(get_words('_back'))</script>
	</div>
	
	<div id="err_file" style="width:600; display:none">
		Bad file!
		<input type="button" id='btn_err_file' onclick="location.replace('tools_firmw.asp')">
		<script>$('#btn_err_file').val(get_words('_back'))</script>
	</div>
	
	<div id="success" style="width:600; display:none">
		Upgrading firmware! Please wait for several seconds. (count down)
	</div>
	
	<div id="fw_failed" style="width:600; display:none">
		<div id="maincontent">
		<div id="box_header">
			<h1 align="left"> 
				<script>show_words('ub_Upload_Failed')</script>
			</h1>
			<p> 
				<script>show_words('ub_intro_1')</script>
			</p>
			<p> 
				<script>show_words('ub_intro_3')</script>
			</p>
			<p> 
				<script>show_words('ub_intro_2')</script>
			</p>
			<br>
			<input type="button" id='btn_err_fw_failed' onclick="location.replace('tools_firmw.asp')">
			<script>$('#btn_err_fw_failed').val(get_words('_back'))</script>
		</div>
		</div>
	</div>
	
	<div id="cfg_failed" style="width:600; display:none">
		<div id="maincontent">
		<div id="box_header">
			<h1 align="left"> 
				<script>show_words('_rs_invalid')</script>
			</h1>
			<p> 
				<script>show_words('rs_intro_1')</script>
			</p>
			<p> 
				<script>show_words('rs_intro_2')</script>
			</p>
			<br>
			<input type="button" id='btn_err_cfg_failed' onclick="location.replace('tools_system.asp')">
			<script>$('#btn_err_cfg_failed').val(get_words('_back'))</script>
		</div>
		</div>
	</div>
	</div>

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
</html>