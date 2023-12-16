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

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: "ccp_act="
	};

	param.arg = "ccp_act=get&num_inst=1";
	param.arg +="&oid_1=IGD_Layer3Forwarding_Forwarding_i_&inst_1=1100";
	mainObj.get_config_obj(param);

	var route_obj = {
		'enable':	mainObj.config_str_multi("fwdRule_Enable_"),
		'name':		mainObj.config_str_multi("fwdRule_Name_"),
		'ip':		mainObj.config_str_multi("fwdRule_DestIPAddress_"),
		'mask':		mainObj.config_str_multi("fwdRule_DestSubnetMask_"),
		'gw':		mainObj.config_str_multi("fwdRule_GatewayIPAddress_"),
		'metric':	mainObj.config_str_multi("fwdRule_ForwardingMetric_"),
		'iface':	mainObj.config_str_multi("fwdRule_SourceInterface_"),
		'idx':		mainObj.config_str_multi("fwdRule_InterfaceIndex_"),
		'pppidx':	mainObj.config_str_multi("fwdRule_PPPIndex_")
	};

	var current_rules = 0;
	if(route_obj.ip != null)
		current_rules = route_obj.ip.length;

	var submit_button_flag = 0;
	var rule_max_num = 32;
	var resert_rule = rule_max_num;
	var DataArray = new Array();

	function onPageLoad()
	{
		if (login_Info != "w") {
			DisableEnableForm(form1,true);
		}
		set_form_default_values("form1");
	}

	//0/name/192.168.31.0/255.255.255.0/192.168.31.1/192.168.31.1/20
	function Data(enable, name, ip_addr, net_mask, gateway, _interface, metric, iindex, pppindex, onList)
	{
		this.Enable = enable;
		this.Name = name;
		this.Ip_addr = ip_addr;
		this.Net_mask = net_mask;
		this.Gateway = gateway;
		this.Interface = _interface;
		this.Metric = metric;
		this.IIndex = iindex;
		this.PPPindex = pppindex;
		this.OnList = onList ;
	}

	function set_routes()
	{
		var index = 0;
		for (var i = 0; i < rule_max_num; i++) {			
			DataArray[DataArray.length++] = new Data(route_obj.enable[i], route_obj.name[i], route_obj.ip[i], route_obj.mask[i], route_obj.gw[i], route_obj.iface[i], route_obj.metric[i], route_obj.idx[i], route_obj.pppidx[i], i);
		}
	}

	function my_chk_addr(addrObj, maskObj)
	{
		var mask = new Array(255,255,255,0);
		if (addrObj == null || addrObj.addr.length != 4) {
			alert(addrObj.e_msg[INVALID_IP]);
			return false;
		}
		
		if((addrObj.addr[0] == "127") || ((addrObj.addr[0] >= 224) && (addrObj.addr[0] <= 239))){
			alert(addrObj.e_msg[MULTICASE_IP_ERROR]);
			return false;
		}
		
		// check the ip is "0.0.0.0"
		if (!addrObj.allow_zero && addrObj.addr[0] == '0' && addrObj.addr[1] == '0' && addrObj.addr[2] == '0' && addrObj.addr[3] == '0') {
			alert(addrObj.e_msg[ZERO_IP]);
			return false;
		}
		
		if (maskObj != null){
			mask = maskObj.addr;
		}
					
		var ip = addrObj.addr;
		var count_zero = 0;
		var count_bcast = 0;
		for (var i = 0; i < 4; i++){	// check the IP address is a network address or a broadcast address																							
			if (((~mask[i] + 256) & ip[i]) == 0){	// (~mask[i] + 256) = reverse mask[i]
				count_zero++;						
			}
			
			if ((mask[i] | ip[i]) == 255){
				count_bcast++;
			}							
		}
	
		if ((count_zero == 4 && !addrObj.is_network) || (count_bcast == 4)){
			alert(addrObj.e_msg[INVALID_IP]);
			return false;
		}
		return true;
	}

	//20130111 Silvia add, chk Dest ip is the same with subnet or not
	function check_subnet(ip_obj,mask_obj)
	{
		var tmp_ip = ip_obj.split(".");
		var tmp_mask = mask_obj.split(".");
		var tmp_subnet;
		var array_range = new Array(ip_obj.length);

		for (var i = 0; i < tmp_ip.length; i++)
		{
			array_range[i] = tmp_ip[i].toString(2) & tmp_mask[i].toString(2);
		}

		tmp_subnet = array_range[0]+"."+array_range[1]+"."+array_range[2]+"."+array_range[3];
		if (ip_obj != tmp_subnet)
		{
			alert(addstr(get_words('GW_ROUTES_DESTINATION_IP_ADDRESS_INVALID'),ip_obj));
			return false;
		}
		return true;
	}
	
	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange'))) {
			return false;
		}
		var count = 0;
		for (var i = 0; i < rule_max_num; i++)
		{
			var temp_mac;
			if ($("#Destination" + i).val() == "" )
					$("#Destination" + i).val("0.0.0.0");
			if ($("#Sub_Mask" + i).val() == "" )
					$("#Sub_Mask" + i).val("0.0.0.0");
			if ($("#Sub_gateway" + i).val() == "")
					$("#Sub_gateway" + i).val("0.0.0.0");

			var static_ip = $("#Destination" + i).val();
			var static_mask = $("#Sub_Mask" + i).val();
			var static_gateway = $("#Sub_gateway" + i).val();
			var metric = $("#metric"+ i).val();

			var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('help256'));
			var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));

			var static_ip_obj = new addr_obj(static_ip.split("."), ip_addr_msg, false, true);
			var static_mask_obj = new addr_obj(static_mask.split("."), subnet_mask_msg, false, false);
			var static_gateway_obj = new addr_obj(static_gateway.split("."), gateway_msg, false, true);
			var temp_metric = new varible_obj(metric, metric_msg, 1, 15, false);
			var check_name = $("#name"+i).val();

			if ($("#enable" + i)[0].checked)
			{
				if (!check_route_address(static_ip_obj))
					return false;
				if(!check_route_mask(static_mask_obj))
					return false;
				if (!check_address(static_gateway_obj))
					return false;	// when gateway is invalid
				if (!check_varible(temp_metric))
					return false;
				if (!check_subnet(static_ip,static_mask))
					return false;
			}

			if(get_checked_value($("#enable"+i)[0])=="1")
			{
				if(trim_string($("#name"+i).val()) == ""){
					alert(get_words('aa_alert_9'));
					return false;
				}else {
					if(Find_word(check_name,"'") || Find_word(check_name,'"') || Find_word(check_name,"/")){
						alert(get_words('TEXT003').replace("+ i +","'" + check_name + "'"));
						return false;
					}
				}
				for (jj=i+1; jj<rule_max_num; jj++)
				{
					if ($("#Destination" + jj).val() != "0.0.0.0") {
						if (($("#Destination" + jj).val() == static_ip) && ($("#interface" + jj).val() == $("#interface" + i).val())) {
							alert(get_words('_r_alert_new1')+", '"+ $("#name" + jj).val() + "'" + get_words('help264') +" '" + $("#name" + i).val() + "'." );
							return false;
						}
					}
					if($("#name" +i).val() == $("#name" +jj).val()){
						alert(addstr(get_words('av_alert_16'),get_by_id("name"+i).value));
						return false;
					}
				}
			}

			count++;
		}

		if (submit_button_flag == 0)
		{
			copyDataToDataModelFormat();
			send_submit("form2");
			
			submit_button_flag = 1;
			return true;
		}

		return false;
	}
	
	function copyDataToDataModelFormat()
	{
		for(var i=0; i<rule_max_num; i++)
		{	
			var inst = '1.1.'+(i+1)+'.0';
			if (get_by_id('enable'+i).checked == false && get_by_id('name'+i).value == '') {
				get_by_id("fwdRule_Enable_"+inst).value = '0';
				get_by_id("fwdRule_Name_"+inst).value = '';
				get_by_id("fwdRule_DestIPAddress_"+inst).value = '0.0.0.0';
				get_by_id("fwdRule_DestSubnetMask_"+inst).value = '0.0.0.0';
				get_by_id("fwdRule_SourceInterface_"+inst).value = '0';
				get_by_id("fwdRule_GatewayIPAddress_"+inst).value = '0.0.0.0';
				get_by_id("fwdRule_ForwardingMetric_"+inst).value = '1';
				get_by_id("fwdRule_InterfaceIndex_"+inst).value = '1';
				get_by_id("fwdRule_PPPIndex_"+inst).value = '1';
			} else {
				get_by_id("fwdRule_Enable_"+inst).value = get_checked_value(get_by_id("enable"+i));
				get_by_id("fwdRule_Name_"+inst).value = get_by_id("name"+i).value;
				get_by_id("fwdRule_DestIPAddress_"+inst).value = get_by_id("Destination"+i).value;
				get_by_id("fwdRule_DestSubnetMask_"+inst).value = get_by_id("Sub_Mask"+i).value;
				get_by_id("fwdRule_SourceInterface_"+inst).value = get_by_id("interface"+i).value;
				get_by_id("fwdRule_GatewayIPAddress_"+inst).value = get_by_id("Sub_gateway"+i).value;
				get_by_id("fwdRule_ForwardingMetric_"+inst).value = get_by_id("metric"+i).value;
				get_by_id("fwdRule_InterfaceIndex_"+inst).value = get_by_id("ifaceindex"+i).value;
				get_by_id("fwdRule_PPPIndex_"+inst).value = get_by_id("pppindex"+i).value;
			}
		}
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b10');</script>
		</td>
		<!-- end of left menu -->

	<input type="hidden" id="dhcp_list" name="dhcp_list" value=''>

    <form id="form2" name="form2" method="post" action="get_set.ccp">
		<input type="hidden" name="ccp_act" value="set">
		<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
		<input type="hidden" name="nextPage" value="adv_routing.asp">
		<script>
			var str = "";
			for(var i=1; i<=rule_max_num; i++)
			{
				var inst = '1.1.'+i+'.0';
				str += '<input type="hidden" name="fwdRule_Enable_'+inst+'" id="fwdRule_Enable_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_Name_'+inst+'" id="fwdRule_Name_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_DestIPAddress_'+inst+'" id="fwdRule_DestIPAddress_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_DestSubnetMask_'+inst+'" id="fwdRule_DestSubnetMask_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_SourceInterface_'+inst+'" id="fwdRule_SourceInterface_'+inst+'" value="1">';
				str += '<input type="hidden" name="fwdRule_GatewayIPAddress_'+inst+'" id="fwdRule_GatewayIPAddress_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_ForwardingMetric_'+inst+'" id="fwdRule_ForwardingMetric_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_InterfaceIndex_'+inst+'" id="fwdRule_InterfaceIndex_'+inst+'" value="">';
				str += '<input type="hidden" name="fwdRule_PPPIndex_'+inst+'" id="fwdRule_PPPIndex_'+inst+'" value="">';
			}
			document.write(str);
		</script>
	</form>

	<form id="form1" name="form1" method="post">		
		<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
		<input type="hidden" id="html_response_message" name="html_response_message" value="">
		<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
		<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_routing.asp">
		<input type="hidden" id="reboot_type" name="reboot_type" value="filter">

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('_routing')</script></h1>
				<p><script>show_words('av_intro_r')</script></p>
				<br>
				<input name="button" id="button" type="button" class="button_submit" value="" onClick="send_request()">
				<input name="button2" id="button2" type="button" class="button_submit" value="" onclick="page_cancel('form1', 'adv_routing.asp');">
				<script>$("#button2").val(get_words('_dontsavesettings'));</script>
				<script>$("#button").val(get_words('_savesettings'));</script>
			</div>
			<a name="show_list"></a>

			<div class=box>
				<h2>32 --<script>show_words('r_rlist')</script></h2>
				<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
				<tbody>
					<tr>
						<td align=center width=20>&nbsp;</td>
						<td align=center>&nbsp;</td>
						<td align=center>&nbsp;</td>
						<td align=center><script>show_words('_metric')</script></td>
						<td align=center><script>show_words('_interface')</script></td>
					</tr>
					<script>
						set_routes();
						for(var i=0 ; i<rule_max_num ; i++){
							var is_checked = "";
							var obj_Name = "";
							var obj_IP = "";
							var obj_Mask = "";
							var obj_gateway = "";
							var obj_interface = "1";
							var obj_metric = "";
							if(i < DataArray.length){
								obj_Name = DataArray[i].Name;
								obj_IP = DataArray[i].Ip_addr;
								obj_Mask = DataArray[i].Net_mask;
								obj_gateway = DataArray[i].Gateway;
								obj_interface = DataArray[i].Interface;
								obj_metric = DataArray[i].Metric;
								obj_iindex = DataArray[i].IIndex;
								obj_pppindex = DataArray[i].PPPindex;
							}
							document.write("<tr>")
							document.write("<td align=center rowspan=2><input type=\"checkbox\" id=\"enable" + i + "\" name=\"enable" + i + "\" value=\"1\"></td>")
							document.write('<td>'+get_words('_name')+'<br><input type=text class=flatL id=name' + i + ' name=name'+ i +' size=16 maxlength=15 value='+ obj_Name +'></td>')
							document.write('<td>'+get_words('_destip')+'<br><input type=text class=flatL id=Destination' + i + ' name=Destination' + i + ' size=16 maxlength=15 value='+ obj_IP +'></td>')
							document.write('<td align=center rowspan=2><input type=text class=flatL id=metric' + i + ' name=metric' + i + ' size=16 maxlength=15 value='+ obj_metric +'></td>')
							document.write("<td align=center rowspan=2>&nbsp;");
							document.write("<select style='width:90' id=\"interface" + i +"\" name=\"interface" + i +"\">");
							document.write("<option value=\"1\">WAN</option>");
							document.write("</select></td>");
							document.write("<td style='display:none' align=center rowspan=2>&nbsp;");
							document.write("<select style='width:90' id=\"ifaceindex" + i +"\" name=\"ifaceindex" + i +"\">");
							document.write("<option value=\"1\">1</option> <option value=\"2\">2</option>");
							document.write("</select></td>");
							document.write("<td style='display:none' align=center rowspan=2>&nbsp;");
							document.write("<select style='width:90' id=\"pppindex" + i +"\" name=\"pppindex" + i +"\">");
							document.write("<option value=\"1\">1</option> <option value=\"2\">2</option>");
							document.write("</select></td>");
							document.write("</tr>")

							document.write("<tr>")
							document.write('<td>'+get_words('_netmask')+'<br><input type=text class=flatL id=Sub_Mask' + i + ' name=Sub_Mask' + i + ' size=16 maxlength=15 value='+ obj_Mask +'></td>')
							document.write('<td>'+get_words('_gateway')+'<br><input type=text class=flatL id=Sub_gateway' + i + ' name=Sub_gateway' + i + ' size=16 maxlength=15 value='+ obj_gateway +'></td>')
							document.write("</tr>")

							if(i < DataArray.length){
								set_checked(DataArray[i].Enable, $("#enable"+i)[0]);
								set_selectIndex(DataArray[i].Interface, $("#interface"+i)[0]);
								set_selectIndex(DataArray[i].IIndex, $("#ifaceindex"+i)[0]);
								set_selectIndex(DataArray[i].PPPindex, $("#pppindex"+i)[0]);
							}
						}
					</script>
				</tbody>
				</table>
			</div>
		</div>
		</td>
	</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><b>
			<script>show_words('_hints')</script>&hellip;</b><br>
			<br><script>show_words('hhav_enable')</script></p>
			<p><script>show_words('hhav_r_name')</script></p>
			<p><script>show_words('hhav_r_dest_ip')</script></p>
			<p><script>show_words('hhav_r_netmask')</script></p>
			<p><script>show_words('hhav_r_gateway')</script></p>
			<p><a href="support_adv.asp#Routing" onclick="return jump_if();">
			<script>show_words('_more')</script>&hellip;</a></p>
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