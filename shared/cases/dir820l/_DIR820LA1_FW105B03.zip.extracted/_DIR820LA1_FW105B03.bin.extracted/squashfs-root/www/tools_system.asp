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
	
	var count = 120;
	var arr_page = [
		'err_checksum',
		'err_hwid',
		'err_file',
		'success'
	];
	
	var arr_fwupgrade_msg = [
		get_words('fw_checksum_err'),
		get_words('fw_bad_hwid'),
		get_words('fw_unknow_file_format'),
		get_words('fw_cfg_upgrade_success')
	];

	function toggle_page(id) {
		if (arr_page == null || (arr_page instanceof Array) == false)
			return;
		for (var i=0; i<arr_page.length; i++) {
			if (id == i) {
				//alert(arr_fwupgrade_msg[i]);
				return;
			} else if (parseInt(id/10) == 1 && (id%10) == i) {
				//alert(arr_lpupgrade_msg[i]);
				return;
			}
		}
	}

	function onPageLoad(){
		if(dev_info.login_info != "w"){
			DisableEnableForm(document.form1,true);	
			DisableEnableForm(document.form2,true);	
			DisableEnableForm(document.form6,true);	
			DisableEnableForm(document.form17,true);	
		}
		
		var ret = getUrlEntry('ret');
		toggle_page(ret);
	}

	function restoreConfirm(){
		if(dev_info.login_info != "w"){
			window.location.href ="back.asp";
		}else{
			//if(confirm(LangMap.msg['RESTORE_DEFAULT'])){	
			if(confirm(get_words('up_rb_4')+"\n"+get_words('up_rb_5'))){	
				send_submit("form3");
			}
		}
	}
	
	function restore_js(){
		if(confirm(LangMap.msg['RESET_JUMPSTAR'])){		
	    	//send_submit("form4");
	   	}
	}
	
	function loadConfirm(){
		if(dev_info.login_info != "w"){
			window.location.href ="back.asp";
		}else{
			var btn_restore = get_by_id("load");
			if (btn_restore.disabled) {
				//alert ("A restore is already in progress.");
				alert(get_words('ta_alert_4'));
				return false;
			}
			if (get_by_id("file").value == "") {
				//alert(LangMap.msg['LOAD_FILE_ERROR']);
				alert(get_words('ta_alert_5'));
				return false;
			}
			var file_name=get_by_id("file").value;
			var ext_file_name=file_name.substring(file_name.lastIndexOf('.')+1,file_name.length);
			if (ext_file_name!="bin"){
				alert(get_words('rs_intro_1'));
				return false;
			}
			btn_restore.disabled = true;
			//if(confirm(LangMap.msg['LOAD_SETTING'])){
			var inf = get_by_id("restore_info");
			if(confirm(get_words('YM38'))){
				inf.innerHTML = get_words('ta_alert_6')+"...";
				//inf.innerHTML = "Please wait, uploading configuration file...";
				try {
					send_submit("form1");
					return true;
				} catch (e) {
					alert(get_words('_error')+": " + e.message);
					//alert("Error: " + e.message);
					inf.innerHTML = "&nbsp;";
					btn_restore.disabled = false;
				}
				return false;
			}else{
				inf.innerHTML = "&nbsp;";
				btn_restore.disabled = false;
			}
		}    
	}
	function confirm_reboot(){
		if(dev_info.login_info != "w"){
			window.location.href ="back.asp";
		}else{
			//if(confirm(LangMap.msg['REBOOT_ROUTER'])){
			if(confirm(get_words('up_rb_1')+"\n"+get_words('up_rb_2'))){	
	    		send_submit("form6");
	   		}
		}
	}

	function save_conf(){
		send_submit("form17");
	}

</script>
<style type="text/css">
<!--
.style2 {font-size: 11px}
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
		<script>ajax_load_page('menu_left_tools.asp', 'menu_left', 'left_b5');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('tss_SysSt')</script></h1>
				<p><script>show_words('tss_intro')</script></p>
				<p><script>show_words('tss_intro2')</script></p>
			</div>

			<div class="box"> 
				<h2><script>show_words('tss_SysSt')</script></h2>
				<table width="525" border=0 cellpadding=2 cellspacing="2">
					<form id="form17" name="form17" method=POST action="cfg_op.ccp">
					<input type="hidden" name="ccp_act" value="save">
					<tr valign="top">
						<td width="183" height="48" align=right class="duple"><script>show_words('help_ts_ss')</script>:</td>
						<td width="328">&nbsp;
							<input name="save" id="save" type="button" value="" onClick="save_conf()">
							<script>$('#save').val(get_words('ta_SavConf'));</script>
						</td>
					</tr>
					</form>

					<form id="form1" name="form1" method=POST action="cfg_op.ccp" enctype=multipart/form-data>
					<input type="hidden" name="ccp_act" value="load">
					<tr>
						<td height="72" align=right valign="top" class="duple"><script>show_words('help_ts_ls')</script>:</td>
						<td valign="top">&nbsp;
							<input type=file id=file name=file size=20><br>&nbsp;
							<input name="load" id="load" type="button" value="" onclick="loadConfirm()">
							<script>$('#load').val(get_words('ta_ResConf'));</script><br>
							<span class="msg_inprogress" id="restore_info">&nbsp;</span>
						</td>
					</tr>
					</form>

					<form id="form2" name="form2" method="post" action="">
					<input type="hidden" id="html_response_page" name="html_response_page" value="reboot.asp">
					<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="tools_system.asp">
					<tr valign="top">
						<td height="66" align=right class="duple"><script>show_words('help_ts_rfd')</script>:</td>
						<td>&nbsp; 
							<input name="restore" id="restore" type="button" value="" onClick="restoreConfirm()">
							<script>$('#restore').val(get_words('tss_RestAll_b'));</script>
							<br>&nbsp;&nbsp;
							<script>show_words('tss_RestAll')</script>
						</td>
					</tr>
					</form>
		
					<form id="form3" name="form3" method="post" action="cfg_op.ccp">
						<input type="hidden" name="ccp_act" value="restore">
					</form>

					<form id="form6" name="form6" method="post" action="cfg_op.ccp">
					<input type="hidden" name="ccp_act" value="reboot">
					<tr valign="top">
						<td height="39" align=right class="duple"><script>show_words('ts_rd')</script>:</td>
						<td>&nbsp; 
							<input name="restart" id="restart" type="button" value="" onClick="confirm_reboot()"> 
							<script>$('#restart').val(get_words('ts_rd'));</script>
						</td>
					</tr>
					</form>
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
			<p><script>show_words('ZM18')</script></p>
			<p><script>show_words('ZM19')</script></p>
			<p><script>show_words('ZM20')</script></p>
			<p><a href="support_tools.asp#System"><script>show_words('_more')</script>&hellip;</a></p>
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
<script>
	onPageLoad();
</script>
</html>