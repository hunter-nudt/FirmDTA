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
	var count = 10;
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	
	var redirectpage = "";
	var old_ip = getUrlEntry("old_ip");
	var old_mask = getUrlEntry("old_mask");
	var new_ip = getUrlEntry("new_ip");
	var new_mask = getUrlEntry("new_mask");
	var pc_ip = getUrlEntry("pc_ip");
	
	//alert(evt);
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
	
	function lan_action()
	{		
		if(old_ip == null)
			old_ip = "0.0.0.0";
		if(old_mask == null)
			old_mask = "0.0.0.0";
		if(new_ip == null)
			new_ip = "0.0.0.0";
		if(new_mask == null)
			new_mask = "0.0.0.0";
			
		var temp_old_ip_obj = new addr_obj(old_ip.split("."), "", true, false);
		var temp_old_mask_obj = new addr_obj(old_mask.split("."), "", true, false);
		var temp_new_ip_obj = new addr_obj(new_ip.split("."), "", true, false);
		var temp_new_mask_obj = new addr_obj(new_mask.split("."), "", true, false);
		var temp_pc_ip_obj = new addr_obj(pc_ip.split("."), "", true, false);

		//alert(temp_old_ip_obj.addr);
		var eventObj = new ccpObject();
		var param={
			url: "get_set.ccp",
			arg: ""
		};
		
		param.arg += "ccp_act=doEvent&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY";
		eventObj.get_config_obj(param);
		
		/*	2013-11-21
			in lan.asp it will redirect to reboot.asp while ip,mask,dns-relay,dhcp-server setting changed.
			so, NO NEED to redirect to login.asp here (whether from wan or from lan)
		*/
		redirect_target = "lan.asp";

		//count = parseInt(config_val("count_down"));	//<--Silvia: hay que revertirlo, cuando event esta bien. hard code
		
		//alert("Lan IP has been changed, please wait for "+ count +" seconds.");
		//redirectpage = "lan.htm";
	}
	
	function devModeChange()
	{
		var new_ip = getUrlEntry("new_ip");
		redirect_target = "http://" + new_ip;
	}
	
	function onPageLoad(){
		if( old_ip != null && new_ip != null && old_mask != null && new_mask != null )
			setTimeout('lan_action()', 1000);
		else if(evt == 'devModeChange')
			devModeChange();
	}
	function back()
	{
		window.location.href = redirect_target;
	}
	function do_count_down(){
		get_by_id("show_sec").innerHTML = count;
		
		if (count == 0) {	  
			//alert("count=0");
			if( old_ip != null && new_ip != null && old_mask != null && new_mask != null )
			{
				get_by_id("button").disabled = false;
				//back();
			}
			else if(evt == 'devModeChange'){
				get_by_id("newlink").style.display = "";
				get_by_id("button").disabled = false;
			}
				
	        return false;
	    }

		if (count > 0) {
	        count--;
	        setTimeout('do_count_down()',1000);
	    }
	
	}
	
	$(document).ready(function() 
	{
		onPageLoad();
		do_count_down();
	});
</script>
<style type="text/css">
<!--
.style1 {color: #FF6600}
-->
</style>
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

			<div id=box_header>
				<H1 align="left"><span class="style1">&nbsp;</span>
					<script>show_words('sc_intro_sv')</script>
				</H1>
				<div align="left">
					<p class="centered"><script>show_words('rb_wait')</script></p>
					<p align="center" class="centered"><script>document.write(LangMap.which_lang['sc_intro_sv']);</script></p>
					<p><script>document.write(LangMap.which_lang['rb_change']);</script></p>
					<p align="center"> 
						<span id="newlink" style="display:none"></span>
						<input name="button" id="button" type=button class=button_submit value="" onClick="back()" disabled>
						<script>get_by_id("button").value = LangMap.which_lang['_continue'];</script>
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
</html>