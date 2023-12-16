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

	var mainObj = new ccpObject();
	var param = {
		url: 	"get_set.ccp",
		arg: 	"ccp_act=get&num_inst=3&"+
				"oid_1=IGD_LANDevice_i_MACFilter_&inst_1=1110&"+
				"oid_2=IGD_LANDevice_i_MACFilter_ClientList_i_&inst_2=1110&"+
				"oid_3=IGD_WLANConfiguration_i_WPS_&inst_3=1110"
	};
	mainObj.get_config_obj(param);

	var array_rul_list = mainObj.config_str_multi("macList_MACAddress_");
	var mac_action = mainObj.config_val("macFilter_Action_");
	var wps_enable = (mainObj.config_val("wpsCfg_Enable_")? mainObj.config_val("wpsCfg_Enable_"): "0");

	var submit_button_flag = 0;
	var rule_max_num = 24;
	var resert_rule = rule_max_num;
	var DHCPL_DataArray = new Array();
	function onPageLoad()
	{
		if(mac_action)
			$("#mac_filter_type")[0].selectedIndex = mac_action;

		if(array_rul_list)
		{
			for(var i=0; i<rule_max_num; i++)
			{
				$("#mac" + i).val(array_rul_list[i]);
			}
		}

		var login_who= login_Info;
			if(login_who!= "w"){
			DisableEnableForm(form1,true);	
		}else{
			disable_mac_filter();
		}
	}

	function DHCP_Data(name, ip, mac, Exp_time, onList) 
	{
		this.Name = name;
		this.IP = ip;
		this.MAC = mac;
		this.EXP_T = Exp_time;
		this.OnList = onList;
	}

	function disable_mac_filter(){
		var mac_filter_type = $("#mac_filter_type")[0].selectedIndex;
		for (var i = 0; i < rule_max_num; i++){
			$("#mac" + i).attr('disabled', !(mac_filter_type != 0));
			$("#copy" + i).attr('disabled', !(mac_filter_type != 0));
			$("#dhcp_list" + i).attr('disabled', !(mac_filter_type != 0));
			$("#clear" + i).attr('disabled', !(mac_filter_type != 0));
		}
	}

	function copy_mac(index)
	{
		if ($("#dhcp_list" + index)[0].selectedIndex > 0){
			$("#mac" + index).val($("#dhcp_list" + index)[0].options[$("#dhcp_list" + index)[0].selectedIndex].value);
		}else{
			alert(get_words('aa_alert_10'));
		}
	}

	function clear_mac(index){
		$("#mac" + index).val("00:00:00:00:00:00");
	}
	
	function check_dhcp_ip(index)
	{
		var index = 0;
		var mac = $("#dhcp_list" + index)[0].options[$("#dhcp_list" + index)[0].selectedIndex].value;
		var temp_dhcp_list = ($("#dhcp_list"+ index).val()).split(',');

		for (var i = 0; i < temp_dhcp_list.length; i++)
		{
			var temp_data = temp_dhcp_list[i].split("/");
			if(temp_data.length > 1)
			{
				DHCPL_DataArray[DHCPL_DataArray.length++] = new DHCP_Data(temp_data[0], temp_data[1], temp_data[2], temp_data[3], index);
				//check selected mac equal to mac or not?
				index++;
				if(mac == temp_data[2])
				{
					var lan_ip = "";
					var lan_ip_addr_msg = replace_msg(all_ip_addr_msg,"IP address");
					var temp_lan_ip_obj = new addr_obj(lan_ip.split("."), lan_ip_addr_msg, false, false);
					var ip = temp_data[1];
					var ip_addr_msg = replace_msg(all_ip_addr_msg,"IP address");
					var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);

					if(!check_LAN_ip(temp_lan_ip_obj.addr, temp_ip_obj.addr, "IP address"))
						return false;

					return true;
				}
			}
		}
		return true;
	}
	
	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		var lan_mac = "";
		var i=0;
		var mac = 0;
		var flag = 0;
		for(var i=0; i < rule_max_num; i++)
		{
			var mac = $("#mac" + i).val();
			if ($("#mac" + i).val() != "")
			{
				if (mac != "00:00:00:00:00:00" && mac !="")
				{
					if (!check_mac(mac)){
						alert(get_words('LS47'));
						return false;
					}
                    if (mac.toLowerCase() == lan_mac.toLowerCase() ){
						alert(get_words('LS47'));
						return false;
					}
                    if(!check_dhcp_ip())
						return false;
					
					for (var j = i+1; j < rule_max_num; j++){
						if (mac != "00:00:00:00:00:00" && mac !="" && mac.toLowerCase() == $("#mac" + j)[0].value.toLowerCase()){//alert("The Access Control mac address is already in the list");
							alert(addstr(get_words('GW_MAC_FILTER_MAC_UNIQUENESS_INVALID'), mac));
							return false;
						}
					}
					flag = 1;
					continue;
				}
			}
			else
			{
				clear_mac(i);
			}
		}

		if(flag == 0)
		{
			var mac_filter_type = $("#mac_filter_type")[0].selectedIndex;
			if(mac_filter_type !="1")
			{
				for(k=0; k < rule_max_num; k++){
					$("#mac" + k).val("00:00:00:00:00:00");
				}
			}else{
				alert(get_words('GW_MAC_FILTER_ALL_LOCKED_OUT_INVALID'));
				return false;
			}
		}

		if($("#mac_filter_type").val() != 'disable' && wps_enable == '1'){
			if(!confirm(get_words('GW_MAC_FILTER_WPS_DISABLED')))
				return false;
			else{
				$('#wps_enable1').val('0');
				$('#wps_enable2').val('0');
			}
		}
		
		if(submit_button_flag == 0)
		{
			submit_button_flag = 1;
			copy_data_to_cgi_struct();
			//get_by_id("form1").submit();
			get_by_id("form2").submit();
		}
	}
	
	function copy_data_to_cgi_struct()
	{
		get_by_id("macFilter_Action_").value = get_by_id("mac_filter_type").selectedIndex;
		for(var i=0; i<rule_max_num; i++)
		{	
			var kk=i;
			if(i<10)
				kk="0"+i;
			get_by_id("macList_MACAddress_"+(i+1)).value = get_by_id("mac"+i).value;
			if($("#mac" + i).val()=="00:00:00:00:00:00")
				get_by_id("macList_Enable_"+(i+1)).value = 0;
			else
				get_by_id("macList_Enable_"+(i+1)).value = 1;
			
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b2');</script>
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b5');</script>
		</td>
		<!-- end of left menu -->

            <input type="hidden" id="dhcp_list" name="dhcp_list" value="">

            <form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>get_by_id("html_response_message").value = get_words('sc_intro_sv');</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_filters_mac.asp">
			<input type="hidden" id="reboot_type" name="reboot_type" value="all">
			<input type="hidden" id="dhcp_list" name="dhcp_list" value="">

		<td valign="top" id="maincontent_container">
		<div id="maincontent">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="box_header">
				<h1><script>show_words('_macfilt')</script></h1>
				<script>show_words('am_intro_1')</script>
				<br><br>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="send_request()">
				<input name="button2" type="button" id="button2" class=button_submit value="" onclick="page_cancel('form1', 'adv_filters_mac.asp');">
				<script>$("#button2").val(get_words('_dontsavesettings'));</script>
				<script>$("#button").val(get_words('_savesettings'));</script>
			</div>
			<div class=box>
				<h2><script>document.write(rule_max_num)</script> &ndash;&ndash; <script>show_words('am_MACFILT')</script></h2>
				<table cellSpacing=1 cellPadding=2 width=525 border=0>
					<tbody>
					<tr>
						<td><script>show_words('am_intro')</script></td>
					</tr>
					<tr>
						<td>
							<select id="mac_filter_type" name="mac_filter_type" onChange="disable_mac_filter();" style="max-width:500px;">
								<option value="disable"><script>show_words('am_FM_2')</script></option>
								<option value="list_allow"><script>show_words('am_FM_3')</script></option>
								<option value="list_deny"><script>show_words('am_FM_4')</script></option>
							</select>
						</td>
					</tr>
					</tbody>
				</table>
				<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
					<tbody>
					<tr>
						<td width="100" align=left><strong><script>show_words('_macaddr')</script></strong></td>
						<td>&nbsp;</td>
						<td width="250" align=left><strong><script>show_words('bd_DHCP')</script></strong></td>
						<td>&nbsp;</td>
					</tr>
					<script>
						var deviceObj = get_landevice();
						for(var i=0 ; i<rule_max_num ; i++){
							document.write("<tr>")
							document.write("<td><input type=text class=flatL id=mac" + i + " name=mac" + i + " size=20 maxlength=17><input type=hidden id=name" + i + " name=name" + i + " maxlength=31></td>")
							document.write("<td><input type=button id=copy" + i + " name=copy" + i + " value=<< class=btnForCopy onClick='copy_mac(" + i + ")'></td>");
							document.write("<td width=155> <select class=wordstyle width=140 id=dhcp_list" + i + " name=dhcp_list" + i + " modified=\"ignore\">")
							document.write("<option value=-1>")
							show_words('bd_CName')
							document.write("</option>")
							deviceObj.get_host_list( 'mac' );
							document.write("</select></td>")
							document.write("<td align=center>")
							document.write('<input type=button id=\"clear' + i + '\" name=\"clear' + i + '\" value="'+get_words('_clear')+'" onClick=\"clear_mac(' + i + ')\">')													
							document.write("</td>")
							document.write("</tr>")
						}
					</script> 
					</tbody>
				</table>
			</div>
				</div>
			</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><b><script>show_words('_hints')</script>&hellip;</b>
            <p><script>show_words('hham_intro')</script></p>
            <p><script>show_words('hham_add')</script></p>
            <p><script>show_words('hham_del')</script></p>
			<p><a href="support_adv.asp#MAC_Address_Filter"><script>show_words('_more')</script>&hellip;</a></p>
		</div>
		</td>
		<!-- end of user tips -->
	</tr>
	</table>
	<!-- end of main content -->

	<form id="form2" action="get_set.ccp">
		<input type="hidden" name="ccp_act" value="set">
		<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
		<input type="hidden" name="nextPage" value="adv_filters_mac.asp">	
		<input type="hidden" id="macFilter_Action_" name="macFilter_Action_1.1.1.0" value="">
		<input type="hidden" name="wpsCfg_Enable_1.1.1.0" id="wps_enable1">
		<input type="hidden" name="wpsCfg_Enable_1.5.1.0" id="wps_enable2">
		<script>
			for(var i=0; i<rule_max_num; i++)
			{
				document.write("<input type=\"hidden\" id=\"macList_MACAddress_"+(i+1)+"\" name=\"macList_MACAddress_1.1.1."+(i+1)+"\" value=\"\">");
				document.write("<input type=\"hidden\" id=\"macList_Enable_"+(i+1)+"\" name=\"macList_Enable_1.1.1."+(i+1)+"\" value=\"\">");
			}
		</script>
	</form>

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