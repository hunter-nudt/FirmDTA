<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
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
<script type="text/javascript" src="md5.js"></script>
<script type="text/javascript" src="jquery.cookie.pack.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	var salt = "345cd2ef";
	document.title = get_words('TEXT000');
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;
	var auth 		= miscObj.config_val("graph_auth");

	if (miscObj.config_val("es_configured") != '' && miscObj.config_val("es_configured") == 0)
		location.replace("wizard_router.asp");

	var submit_button_flag = true;
	function encode_base64(psstr) {
		return encode(psstr,psstr.length); 
	}

	function encode (psstrs, iLen) {
		var map1="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/{}|[]\:;'<>?,.~!@#$%^&*()_-+=\"";
		var oDataLen = (iLen*4+2)/3;
		var oLen = ((iLen+2)/3)*4;
		var out='';
		var ip = 0;
		var op = 0;
		while (ip < iLen) {
			var xx = psstrs.charCodeAt(ip++);
			var yy = ip < iLen ? psstrs.charCodeAt(ip++) : 0;
			var zz = ip < iLen ? psstrs.charCodeAt(ip++) : 0;
			var aa = xx >>> 2;
			var bb = ((xx &   3) << 4) | (yy >>> 4);
			var cc = ((yy & 0xf) << 2) | (zz >>> 6);
			var dd = zz & 0x3F;
			out += map1.charAt(aa);
			op++;
			out += map1.charAt(bb);
			op++;
			out += op < oDataLen ? map1.charAt(cc) : '='; 
			op++;
			out += op < oDataLen ? map1.charAt(dd) : '='; 
			op++; 
		}
		return out; 
	}

	function check()
	{
		if ($('#username').val() == '') {
			alert('null user name');
			return;
		}
		
		if(submit_button_flag){
			var username = urlencode($("#username").val());
			var password = urlencode($("#password").val());	
			submit_button_flag = false;
			
			//Challenge
			var param = {
				url:	'dws/api/Login',
				arg:	''
				//arg:	'id='+get_by_id("username").value+'&password='+get_by_id("password").value
			};
			var data = json_ajax(param);
			if (data == null || data['uid'] == null) {
				submit_button_flag = true;
				return;
			}
			
			$.cookie('uid', data['uid']);
			var arg1 = username+data['challenge'];
			var arg2 = password;
			
			// submit username and password
			var digs = hex_hmac_md5(arg2, arg1);
			param.arg = 'id='+username+'&password='+digs;
			var data = json_ajax(param);
			if (data == null) {
				submit_button_flag = true;
				return;
			}
			$.cookie('id', data['id']);
			$.cookie('key', data['key']);
			
			// redirect page
			location.replace('file_access.asp');
			
			//send_submit("form1");
		}
		return true;
	}

	function chk_KeyValue(e){
//var salt = "345cd2ef";
		if(browserName == "Netscape") { 
			var pKey=e.which; 
		} 
		if(browserName=="Microsoft Internet Explorer") { 
			var pKey=event.keyCode; 
		} 
		if(pKey==13){
			if(check()){
				send_submit("form1");
			}
		}
	}

	
	var browserName = navigator.appName;
	document.onkeyup=chk_KeyValue;

	$(document).ready( function () {
		//AuthShow(); 	//remove it, why it occurs an error at line: 103 (sometimes) ???
		
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
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
	<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br><br>
		<table width="650" border="0">
		<tr>
			<td height="10">
			<div id=box_header>
				<H1 align="left"><script>show_words('li_Login')</script></H1>
				<script>show_words('li_intro')</script><p>
				<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr height="24">
					<td width="30%"></td>
					<td colspan="2"><b><script>show_words('_username')</script> :&nbsp;</b>
						<input type="text" id="username" name="username">
					</td>
				</tr>
				<tr height="24">
					<td width="30%"></td>
					<td colspan="2">
						<b><script>show_words('_password')</script> :&nbsp;&nbsp;</b>
						<input type="password" id="password" name="password" value="" onfocus="select();"/>
					</td>
				</tr>
				</table>
				<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td width="25%"></td>
					<td width="90"></td>
					<td><br>
						<input class="button_submit_padleft" type="button" name="login" id="login" value="" style="width:120 " onclick="check()">
						<script>get_by_id("login").value = get_words('li_Log_In');</script>
					</td>
				</tr>
				</table>
			</div>
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
</html>