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
	var v4v6 		= dev_info.v4v6_support;

	var mainObj = new ccpObject();
	var param = {
		url: 	"get_set.ccp",
		arg: 	"ccp_act=get&num_inst=3&"+
				"oid_1=IGD_AdvNetwork_&inst_1=1100&"+
				"oid_2=IGD_WANDevice_i_InboundFilter_i_&inst_2=1100&"+
				"oid_3=IGD_WANDevice_i_&inst_3=1100&"+
				"oid_4=IGD_&inst_4=1000"
	};
	mainObj.get_config_obj(param);
	var dev_mode = mainObj.config_val("igd_DeviceMode_");
	var array_ib_inst = mainObj.config_inst_multi("IGD_WANDevice_i_InboundFilter_i_");
	var array_filter_name = mainObj.config_str_multi("ibFilter_Name_");
	var array_filter_act = mainObj.config_str_multi("ibFilter_Action_");

	var network_obj = {
		upnp: 		mainObj.config_val("advNetwork_UpnpEnable_"),
		multi: 		mainObj.config_val("advNetwork_MulticastEnable_"),
		multiv6:	mainObj.config_val("advNetwork_MulticastIPv6Enable_")
	};

	var wan_obj = {
		ping: 		mainObj.config_val("wanDev_WanPingEnable_"),
		speed: 		mainObj.config_val("wanDev_WanPortSpeed_"),
		pinginbound:	mainObj.config_val("wanDev_WanPingInboundFilter_"),
		pingdetail:		mainObj.config_val("wanDev_WanPingDetail_")
	};

	var ib_filter_cnt = 0;
	var submit_button_flag = 0;
	var rule_max_num = 10;
	var inbound_used = 2;
	var DataArray = new Array();

	if(array_filter_name != null)
		ib_filter_cnt = array_filter_name.length;

	function onPageLoad()
	{
		if (v4v6 == '1')
		{
			$('.v6_use').show();
			if(network_obj.multiv6)
				set_checked(network_obj.multiv6, get_by_id("multi_enable_v6"));
		}
		if(network_obj.upnp)
			set_checked(network_obj.upnp,$("#upnpEnable")[0]);
		if(wan_obj.ping)
			set_checked(wan_obj.ping, $("#wan_ping")[0]);
		if(wan_obj.speed)
			$("#wan_port_speed").val(wan_obj.speed);
		if(network_obj.multi)
			set_checked(network_obj.multi, $("#multi_enable")[0]);

		$("#wan_port_ping_response_inbound_filter").val(wan_obj.pinginbound);
		var show_selected = $("#wan_port_ping_response_inbound_filter").val();
		$("#filtext").val(wan_obj.pingdetail);
		wan_ping_ingress_filter_name_selector(show_selected);

		set_selectIndex(show_selected, $("#inbound_filter")[0]);
		disable_wan();
		set_form_default_values("form1");

		var login_who= login_Info;
			if(login_who!= "w" || dev_mode == "1"){
			DisableEnableForm(form1,true);
		}
	}

	//name/action/used(vs/port/wan/remote)
	function Data(name, action, used, onList)
	{
		this.Name = name;
		this.Show_W = "";
		this.Used = used;
		this.OnList = onList;
		var sActionW = "Allow All"
		if(action =="deny"){
			sActionW = "Deny";
		}
		this.sAction = sActionW;
	}

	function set_Inbound(){
		var index = 0;
		for (var i = 0; i < rule_max_num; i++){
			var temp_st;
			var temp_A;
			var temp_B;
			var k=i;
			if(parseInt(i,10)<10){
				k="0"+i;
			}
			temp_st = ($("#inbound_filter_name_" + k)[0].value).split("/");
			if (temp_st.length > 1)
			{
				if(temp_st[0] != "")
				{
					DataArray[DataArray.length++] = new Data(temp_st[0], temp_st[1], temp_st[2], index);
					temp_A = $("#inbound_filter_ip_"+ k +"_A")[0].value.split(",");
					for(j=0;j<temp_A.length;j++)
					{
						var temp_A_e = temp_A[j].split("/");
						var temp_A_ip = temp_A_e[1].split("-");
						if(temp_A_e[0] == "1")
						{
							var T_IP_R = temp_A_e[1];
							if(temp_A_e[1] == "0.0.0.0-255.255.255.255"){
								T_IP_R = "*";
							}else if(temp_A_ip[0] == temp_A_ip[1]){
								T_IP_R = temp_A_ip[0];
							}
							if(DataArray[index].Show_W !=""){
								DataArray[index].Show_W = DataArray[index].Show_W + ",";
							}
							DataArray[index].Show_W = DataArray[index].Show_W + T_IP_R;
						}
					}
					temp_B = $("#inbound_filter_ip_"+ k +"_B")[0].value.split(",");
					for(j=0;j<temp_B.length;j++)
					{
						var temp_B_e = temp_B[j].split("/");
						var temp_B_ip = temp_B_e[1].split("-");
						if(temp_B_e[0] == "1")
						{
							var T_IP_R = temp_B_e[1];
							if(temp_B_e[1] == "0.0.0.0-255.255.255.255"){
								T_IP_R = "*";
							}else if(temp_B_ip[0] == temp_B_ip[1]){
								T_IP_R = temp_B_ip[0];
							}
							if(DataArray[index].Show_W !=""){
								DataArray[index].Show_W = DataArray[index].Show_W + ",";
							}
							DataArray[index].Show_W = DataArray[index].Show_W + T_IP_R;
						}
					}
					load_inbound_used(k, temp_st, inbound_used);
					index++;
				}
			}
		}
	}

	function show_option_value()
	{
		for(var i=0;i<ib_filter_cnt;i++){
			document.write("<option value=\""+ (i+1) +"\">"+ array_filter_name[i] +"</option>");
		}
	}

	function send_request(){
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		$("#upnp_enable").val(get_checked_value(get_by_id("upnpEnable")));
		$("#wan_port_ping_response_enable").val(get_checked_value(get_by_id("wan_ping")));
		$("#multicast_stream_enable").val(get_checked_value(get_by_id("multi_enable")));
		if (v4v6 == '1')
			$("#multicast_stream_enable_v6").val(get_checked_value(get_by_id("multi_enable_v6")));
		//save_inbound_used(get_by_id("wan_port_ping_response_inbound_filter").value, inbound_used);
		if(submit_button_flag == 0){
			submit_button_flag = 1;
			copy_data_to_cgi_struct();
			get_by_id('form2').submit();
			return false;
		}else{
			return false;
		}
	}

	function wan_ping_ingress_filter_name_selector(obj_value)
	{
		if (obj_value < 1)
			return;
		if(obj_value !="255" && obj_value !="254")
		{
			get_by_id("wan_port_ping_response_inbound_filter").value = obj_value;
			if (array_ib_inst != null) {
				var count=0;
				var aStr = new String(array_ib_inst[obj_value-1]);
				
				var ibObj = new ccpObject();
				param.arg = 'ccp_act=get&num_inst=1';
				param.arg += '&oid_1=IGD_WANDevice_i_InboundFilter_i_IPRange_i_&inst_1='+aStr.replace(/,/g, '');
			}
			ibObj.get_config_obj(param);
		
			var arr_enable  = ibObj.config_str_multi('ipRange_Enable_');
			var arr_range_s = ibObj.config_str_multi('ipRange_RemoteIPStart_');
			var arr_range_e = ibObj.config_str_multi('ipRange_RemoteIPEnd_');

			var str = '';
			if (arr_enable != null) {
				str += ((array_filter_act[obj_value-1] == 0)? get_words('_allow'): get_words('_deny'));
				for (var i=0; i<arr_enable.length; i++) {
					if (arr_enable[i] == '0')
						continue;
					str += ', '+arr_range_s[i]+'-'+arr_range_e[i];
				}
			}
	/*
			if (str.length != 0) {
				str = str.substring(1, str.length);
			}
	*/
			get_by_id("filtext").value = str;
		}else{
			$("#wan_port_ping_response_inbound_filter").val(obj_value);
			if(obj_value == "255")
				$("#filtext").val(get_words('_allowall'));
			else if(obj_value == "254")
				$("#filtext").val(get_words('_denyall'));
		}
	}

	function copy_data_to_cgi_struct()
	{
		$("#advNetwork_UpnpEnable_").val($("#upnp_enable").val());
		$("#wanDev_WanPingEnable_").val($("#wan_port_ping_response_enable").val());
		$("#wanDev_WanPingInboundFilter_").val($("#inbound_filter").val());
		//get_by_id("advNetwork_WanPingFilterName_").value = get_by_id("").value;
		$("#wanDev_WanPingDetail_").val($("#filtext").val());
		$("#wanDev_WanPortSpeed_").val($("#wan_port_speed").val());
		$("#advNetwork_MulticastEnable_").val($("#multicast_stream_enable").val());
		if (v4v6 == '1')
			$("#advNetwork_MulticastIPv6Enable_").val($("#multicast_stream_enable_v6").val());
	}

	function disable_wan()
	{
		if($('#wan_ping').attr('checked')==true)
		{
			$('#inbound_filter').attr('disabled', false);
			$('#filtext').attr('disabled', false);
		}
		else
		{
			$('#inbound_filter').attr('disabled', true);
			$('#filtext').attr('disabled', true);
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b13');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_network.asp">
            <td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="maincontent">
				<div id=box_header>
					<h1><script>show_words('_advnetwork')</script></h1>
                    <p><script>show_words('anet_intro')</script></p>
					<input name="apply" id="apply" type="button" class=button_submit value="" onClick="return send_request()">
					<input name="cancel" id="cancel" type="button" class=button_submit value="" onclick="page_cancel('form1', 'adv_network.asp');">
					<script>$("#apply").val(get_words('_savesettings'));</script>
					<script>$("#cancel").val(get_words('_dontsavesettings'));</script>
				</div>

				<div class=box>
					<h2><script>show_words('ta_upnp')</script></h2>
					<P class="box_msg"><script>show_words('anet_msg_upnp')</script></P>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="185" align=right class="duple">
							<script>show_words('ta_EUPNP')</script>
						:</td>
						<td width="333" colSpan=3>&nbsp;
							<input name="upnpEnable" type=checkbox id="upnpEnable" value="1">
							<input type="hidden" id="upnp_enable" name="upnp_enable" value="">
						</td>
					</tr>
					</table>
				</div>
				
				<div class=box> 
					<h2><script>show_words('anet_wan_ping')</script></h2>
					<P class="box_msg"><script>show_words('anet_msg_wan_ping')</script></P>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="185" align=right class="duple"> 
							<script>show_words('bwn_RPing')</script>
						:</td>
						<td width="333" colSpan=3>&nbsp;
							<input name="wan_ping" type="checkbox" id="wan_ping" value="1" onclick="disable_wan();">
							<input type="hidden" id="wan_port_ping_response_enable" name="wan_port_ping_response_enable" value="">
						</td>
					</tr>
					<tr>
						<td width="185" align=right class="duple">
							<script>show_words('bwn_IF')</script>
						:</td>
						<td width="333" colSpan=3>&nbsp;
							<input type="hidden" id="wan_port_ping_response_inbound_filter" name="wan_port_ping_response_inbound_filter" value="">
							<select id="inbound_filter" name="inbound_filter" onchange="wan_ping_ingress_filter_name_selector(this.value);">
								<option value="255"><script>show_words('_allowall')</script></option>
								<option value="254"><script>show_words('_denyall')</script></option>
								<script>show_option_value();</script>
							</select>
						</td>
					</tr>
					<tr>
						<td width="185" align=right class="duple">
						<script>show_words('_aa_details')</script>
						:</td>
						<td width="333" colSpan=3>&nbsp;
						<input type="text" id="filtext" name="filtext" size="48" maxlength="48" readonly="readonly">
						</td>
					</tr>
					</table>
				</div>

				<div class=box>
					<h2><script>show_words('anet_wan_phyrate')</script></h2>
					<table width="525" border=0 cellpadding=0>
					<tr>
						<td width="185" align=right class="duple">
						<script>show_words('anet_wan_phyrate')</script>
						:</td>
						<td width="333" colSpan=3>&nbsp;
							<select name="wan_port_speed" id="wan_port_speed">
								<option value="0"><script>show_words('anet_wp_0')</script></option>
								<option value="1"><script>show_words('anet_wp_1')</script></option>
								<option value="3"><script>show_words('anet_wp_auto2')</script></option>
							</select>
						</td>
					</tr>
					</table>
				</div>

				<div class=box>
					<h2><script>show_words('anet_multicast')</script></h2>
                    <table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="250" align=right class="duple">
						<script>show_words('anet_multicast_enable')</script>
						:</td>
						<td width="275" colSpan=2>&nbsp;
						<input name="multi_enable" type=checkbox id="multi_enable" value="1">
						<input type="hidden" id="multicast_stream_enable" name="multicast_stream_enable" value="">
						</td>
					</tr>
					</table>
				</div>
				
				<div class="v6_use" style="display:none">
					<div class=box> 
					<h2><script>show_words('anet_multicast_v6')</script></h2>
					<table cellSpacing=1 cellPadding=1 width=525 border=0>
					<tr>
						<td width="250" align=right class="duple" >
							<script>show_words('anet_multicast_enable_v6')</script>
						:</td>
						<td width="275" colSpan=2>&nbsp;
							<input name="multi_enable_v6" type=checkbox id="multi_enable_v6" value="1">
							<input type="hidden" id="multicast_stream_enable_v6" name="multicast_stream_enable_v6" value="">
						</td>
					</tr>
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
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
            </strong></b>&hellip;</strong></br>
			<p><script>show_words('hhan_upnp')</script></p>
			<p><script>show_words('hhan_ping')</script></p>
			<p><script>show_words('hhan_wans')</script></p>
			<p><script>show_words('hhan_mc')</script></p>
			<p><a href="support_adv.asp#Network"><script>show_words('_more')</script>&hellip;</a></p>
		</div>
		</td>
		<!-- end of user tips -->
	</tr>
	</table>
	<!-- end of main content -->

	<form id="form2" action="get_set.ccp">
		<input type="hidden" name="ccp_act" value="set">
		<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
		<input type="hidden" name="nextPage" value="adv_network.asp">	
		<input type="hidden" id="advNetwork_UpnpEnable_" name="advNetwork_UpnpEnable_1.1.0.0" value="">
		<input type="hidden" id="wanDev_WanPingEnable_" name="wanDev_WanPingEnable_1.1.0.0" value="">
		<input type="hidden" id="wanDev_WanPingInboundFilter_" name="wanDev_WanPingInboundFilter_1.1.0.0" value="">
		<input type="hidden" id="wanDev_WanPingFilterName_" name="wanDev_WanPingFilterName_1.1.0.0" value="">
		<input type="hidden" id="wanDev_WanPingDetail_" name="wanDev_WanPingDetail_1.1.0.0" value="">
		<input type="hidden" id="wanDev_WanPortSpeed_" name="wanDev_WanPortSpeed_1.1.0.0" value="">
		<input type="hidden" id="advNetwork_MulticastEnable_" name="advNetwork_MulticastEnable_1.1.0.0" value="">	
		<input type="hidden" id="advNetwork_MulticastIPv6Enable_" name="advNetwork_MulticastIPv6Enable_1.1.0.0" value="">	
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
</script>
</html>