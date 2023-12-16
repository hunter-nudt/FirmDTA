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
	document.title = get_words('TEXT000');
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;

	function onPageLoad()
	{
		var msg = gup("msg");
		if(msg == "fwupgrade" || msg == 'reboot')
			$('.ip_info').hide();
		else
			$('.ip_info').show();
	}

	function gup( name ){  
		name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");  
		var regexS = "[\\?&]"+name+"=([^&#]*)";
		var regex = new RegExp( regexS );  
		var results = regex.exec( window.location.href );
		if( results == null )
			return "";
		else
			return results[1];
	}

	function do_count_down(){
		get_by_id("show_sec").innerHTML = count;

		if (count == 0) {
	        is_page_work();
	        return;
	    }

		if (count > 0) {
	        count--;
	        setTimeout('do_count_down()',1000);
	    }
	}

	function back(){
		var login_who=dev_info.login_info;
		var newIP = gup("newIP");
		var redirectPage = (login_who!= "w"?"index.asp":get_by_id("html_response_page").value);
		if(newIP!="")
			window.location.assign(location.protocol+"//"+newIP+"/"+redirectPage);
		else
			window.location.href = redirectPage;
	}
	function is_page_work(){
		var newIP = gup("newIP");
		var ajax_param = {
			url				:	(newIP!=''?'http://'+newIP:'')+'/jsonp',
			type			:	'OPTIONS',
			success			:	function(json){
				if(json=='OK')
					back();
			},
			error			:	function(json){
				if(json.status==501){
					back();
				}
				else{
					($('#dot').html().length>3?$('#dot').html(''):$('#dot').append('.'));
					setTimeout(function(){is_page_work();}, 1000);
				}
			}
		};
		
		try{
			$.ajax(ajax_param);
		} catch(e) {//not support CORS
			back();
		}
	}
</script>
<style type="text/css">
<!--
.style1 {color: #FF6600}
-->
</style>
</head>
<body>
<input type="hidden" id="html_response_page" name="html_response_page" value="login.asp">
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
			<div id=box_header>
				<h1><script>show_words('rb_Rebooting')</script>&hellip;</h1>
				<p class="centered"><script>show_words('rb_wait')</script><span id="dot"></span></p>
				<p class="ip_info"><script>show_words('rb_change')</script></p>
				<br>
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
<script>
	var count = 60;
	var temp_count = getUrlEntry('count');
	if(temp_count != "")
		count = parseInt(temp_count);

	onPageLoad();
	do_count_down();
</script>
</html>