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
	
	/* get time information */
	var infoObj = new ccpObject();
	var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=1'+
				'&oid_1=IGD_SystemLogInfo_&inst_1=1100'
	};
	infoObj.get_config_obj(param);
	
	var objSysLog = {
		'enable':	infoObj.config_val('sysLog_SysLogServerEnable_'),
		'servAddr':	infoObj.config_val('sysLog_SysLogServerAddress_')
	};

	var DHCPList_word = "";
	var DHCPL_DataArray = new Array();
	
	function DHCP_Data(name, ip, mac, Exp_time, onList){
		this.Name = name;
		this.IP = ip;
		this.MAC = mac;
		this.EXP_T = Exp_time;
		this.OnList = onList ;
	}
	
	function set_lan_dhcp_list(){
		var index = 0;
		var temp_dhcp_list = get_by_id("dhcp_list").value.split(",");
		for (var i = 0; i < temp_dhcp_list.length; i++){	
			var temp_data = temp_dhcp_list[i].split("/");
			if(temp_data.length > 1){
				DHCPL_DataArray[DHCPL_DataArray.length++] = new DHCP_Data(temp_data[0], temp_data[1], temp_data[2], temp_data[3],index);
				DHCPList_word = DHCPList_word+ "<option value=\""+ index +"\">" + temp_data[0] + "</option>";
				index++;
			}
		}
	}
	
	function print_dhcp_sel(){
		var print_sel = get_by_id("sys_dhcp").selectedIndex;
		if(print_sel > 0){
			get_by_id("sys_server").value = get_by_id("sys_dhcp").options[get_by_id("sys_dhcp").selectedIndex].value;
		}
	}
	
	function onPageLoad(){
		//Syslog settings
		//var syslog_ser = get_by_id("syslog_server").value.split("/");
		set_checked(objSysLog.enable, get_by_id("sel_sys_enable"));
		get_by_id("sys_server").value = objSysLog.servAddr;

		if(dev_info.login_info != "w"){
			DisableEnableForm(document.form1,true);	
		}else{
			disable_log();
		}
	}

	function do_submit() 
	{
		var submitObj = new ccpObject();
		var param = {
			'url':	'get_set.ccp',
			'arg':	'ccp_act=set'
		};
		
		param.arg += '&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=tools_syslog.asp'+
					'&sysLog_SysLogServerEnable_1.1.0.0='+($('#sel_sys_enable').attr('checked')? '1': '0')+
					'&sysLog_SysLogServerAddress_1.1.0.0='+$('#sys_server').val();
		submitObj.get_config_obj(param);
	}
	
	function send_request(){
		//if (!is_form_modified("form1") && !confirm("Nothing has changed, save anyway?")) {
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange'))) {
			return false;
		}
		
		if(get_by_id("sel_sys_enable").checked){
                        var lan_ip = dev_info.lanIP;
			var ip_addr_msg = replace_msg(all_ip_addr_msg,"IP address");
			var temp_lan_ip_obj = new addr_obj(lan_ip.split("."), sys_ip_addr_msg, false, false);
			var sys_ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('tsl_SLSIPA'));
    		var temp_sys_ip_obj = new addr_obj(get_by_id("sys_server").value.split("."), sys_ip_addr_msg, false, false);
    		if(!check_address(temp_sys_ip_obj)){
	            return false;
        	}
        	//check dhcp ip range equal to lan-ip or not?
				if(!check_LAN_ip(temp_lan_ip_obj.addr, temp_sys_ip_obj.addr, "IP address")){
					return false;
				}
        }else{
        	get_by_id("sys_server").value = "0.0.0.0";
        }

		//save Syslog settings
		get_by_id("syslog_server").value = get_checked_value(get_by_id("sel_sys_enable")) +"/"+ get_by_id("sys_server").value;
		
		do_submit();
		//get_by_id("form1").submit();
	}
	
	function disable_log(){
		get_by_id("show_sysip").style.display = "none";
	  	if (get_by_id("sel_sys_enable").checked){
	    	get_by_id("show_sysip").style.display = "";
	  	}
	}

	function get_landevice()
	{
		var deviceObj = new ccpObject();
		var param = {
			url: 	"get_set.ccp",
			arg: 	"ccp_act=get&num_inst=1"+
					"&oid_1=IGD_LANDevice_i_ConnectedAddress_i_&inst_1=1100"
		};
		deviceObj.get_config_obj(param);
		return deviceObj;
	}
</script>	
<style type="text/css">
<!--
.style4 {
	font-size: 11px;
	font-weight: bold;
}
.style5 {font-size: 11px}
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
		<script>ajax_load_page('menu_left_tools.asp', 'menu_left', 'left_b3');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="tools_syslog.asp">
			<input type="hidden" id="syslog_server" name="syslog_server" value="">
			<input type="hidden" id="dhcp_list" name="dhcp_list" value="">
			
			<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
					<h1><script>show_words('_syslog')</script></h1>
					<script>show_words('tsl_intro')</script>
					<br><br>
					<input name="button" id="button" type="button" class=button_submit value="" onClick="send_request()">
					<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'tools_syslog.asp');">
					<script>$('#button').val(get_words('_savesettings'));</script>
					<script>$('#button2').val(get_words('_dontsavesettings'));</script> 
				</div>

				<div class="box">
					<h2><script>show_words('tsl_SLSt')</script></h2>
					<table cellSpacing=1 cellPadding=2 width=525 border=0>
					<tr>
						<td class="duple1"><script>show_words('tsl_EnLog')</script>:</td>
						<td width=57%><input type="Checkbox" id="sel_sys_enable" name="sel_sys_enable" value="1" onClick="disable_log();"></td>
					</tr>
					<tr id="show_sysip" style="display:none">
						<td class="duple1"><script>show_words('tsl_SLSIPA')</script>:</td>
						<td width=57%> 
						<input type=text id="sys_server" name="sys_server" size=16 maxlength=15>
						&lt;&lt;
						<select id="sys_dhcp" name="sys_dhcp" size=1 onChange="print_dhcp_sel()">
						<option value="-1"><script>show_words('bd_CName')</script></option>
							<script>
								var deviceObj = get_landevice();
								deviceObj.get_host_list( 'ip' );
							</script>
						</select>
						</td>
					</tr>
					</table>
				</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>
		</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('hhts_def')</script></p>
			<p><a href="support_tools.asp#SysLog"><script>show_words('_more')</script>&hellip;</a></p>
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
	set_form_default_values("form1");
</script>
</html>