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

	var rtList = null;
	
	var rtObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: 'ccp_act=get&num_inst=2'+
			'&oid_1=IGD_Status_RoutingTable_i_&inst_1=1100'+
			'&oid_2=IGD_Layer3Forwarding_Forwarding_i_&inst_2=1100'
	};
	rtObj.get_config_obj(param);
	
	rtList = {
		'addr':			new String(rtObj.config_val('igdRtList_Destination_')).split(','),
		'mask':			new String(rtObj.config_val('igdRtList_Netmask_')).split(','),
		'gw':			new String(rtObj.config_val('igdRtList_Gateway_')).split(','),
		'iface':		new String(rtObj.config_val('igdRtList_Interface_')).split(','),
		'metric':		new String(rtObj.config_val('igdRtList_Metric_')).split(','),
		'type':			new String(rtObj.config_val('igdRtList_Type_')).split(','),
		'creator':		new String(rtObj.config_val('igdRtList_Creator_')).split(',')
	}

	var adv_route = {
		'enable':	rtObj.config_str_multi("fwdRule_Enable_"),
		'name':		rtObj.config_str_multi("fwdRule_Name_"),
		'addr':		rtObj.config_str_multi("fwdRule_DestIPAddress_"),
		'mask':		rtObj.config_str_multi("fwdRule_DestSubnetMask_"),
		'gw':		rtObj.config_str_multi("fwdRule_GatewayIPAddress_"),
		'metric':	rtObj.config_str_multi("fwdRule_ForwardingMetric_"),
		'iface':	rtObj.config_str_multi("fwdRule_SourceInterface_")
	};

	function compare_creator(idx)
	{
		i = idx;
		for (var j =0;j<adv_route.addr.length;j++)
		{
			if (adv_route.enable[j] == 0)
			{
				if((rtList.addr[i] == adv_route.addr[j]) && (rtList.mask[i] == adv_route.mask[j]) &&
					(rtList.gw[i] == adv_route.gw[j]) && (mapIface(rtList.iface[i]) == 'WAN') &&
					(rtList.metric[i] == adv_route.metric[j]))
						return 'Admin';
			}
		}
		return get_words('_system');
	}

	function mapIface(idx)
	{
		switch (idx) {
		case '1':
			return get_words('_LAN');
		case '2':
			return get_words('_loopback');
		default:
			return get_words('WAN');
		}
	}

/*	
	function creator_up(idx)
	{
		switch (idx) {
		case '0':
			return 'System';
		case '1':
			return 'Admin';
		}
	}

	function wantype_up(idx)
	{
		switch (idx) {
		case '0':
			return 'INTERNET';
		case '1':
			return 'DHCP Option';
		case '2':
			return 'STATIC';
		case '3':
			return 'INTRANET';
		case '4':
			return 'LOCAL';
		}
	}
*/

	//20120203 silvia add to change addr and mask string
/*
	function compare_addr(addr)
	{
		if (addr == "0.0.0.0")
			return "default";
		else if (addr == "239.255.255.250")
			return "239.0.0.0";
		else
			return addr;
	}
*/
	function routingTable_list()
	{
		if (rtList.addr == null || rtList.addr=='')
			return;
		/*
		var str = 	'<tr>'+
						'<td align="center" bgcolor="#DDDDDD"><b>' + get_words('_NetworkAddr') + '</b></td>'+
						'<td align="center" bgcolor="#DDDDDD"><b>' + get_words('_NetworkMask') + '</b></td>'+
						'<td align="center" bgcolor="#DDDDDD"><b>' + get_words('_GWAddr') + '</b></td>'+
						'<td align="center" bgcolor="#DDDDDD"><b>' + get_words('_Interface') + '</b></td>'+
						'<td align="center" bgcolor="#DDDDDD"><b>' + get_words('_Metric') + '</b></td>'+
						'<td align="center" bgcolor="#DDDDDD"><b>' + get_words('_Type') + '</b></td>'+
					'</tr>';
		*/
		var str = 	'<tr>'+
						'<TD><b>'+get_words('_DestIP')+'</b></TD>'+	
						'<TD><b>'+get_words('_netmask')+'</b></TD>'+
						'<TD><b>'+get_words('_gateway')+'</b></TD>'+
						'<TD><b>'+get_words('_metric')+'</b></TD>'+	
						'<TD><b>'+get_words('_interface')+'</b></TD>'+
						'<TD><b>'+get_words('_type')+'</b></TD>'+
						'<TD><b>'+get_words('_creator')+'</b></TD>'+
					'</tr>';
		for (var i = 0; i < rtList.addr.length ; i++){
			str += ("<tr bgcolor=\"#F0F0F0\">");
			str += ("<td><font face=\"Arial\" size=\"2\">"+ ((rtList.addr[i] == "239.255.255.250") ? "239.0.0.0":rtList.addr[i] )+"</font></td>");
			//str += ("<td><font face=\"Arial\" size=\"2\">"+ compare_addr(rtList.addr[i])+"</font></td>");
			str += ("<td><font face=\"Arial\" size=\"2\">"+ ((rtList.addr[i] == "239.255.255.250") ? "255.0.0.0":rtList.mask[i] )+"</font></td>");
			str += ("<td><font face=\"Arial\" size=\"2\">"+ rtList.gw[i] +"</font></td>");
			str += ("<td><font face=\"Arial\" size=\"2\">"+ rtList.metric[i] +"</font></td>");
			str += ("<td><font face=\"Arial\" size=\"2\">"+ mapIface(rtList.iface[i]) +"</font></td>");
			str += ("<td><font face=\"Arial\" size=\"2\" class=\"break_word\">"+ (rtList.type[i]==0? get_words('_dynamic'):get_words('_static')) +"</font></td>");	//wantype_up(rtList.type[i]) +"</font></td>");
			str += ("<td><font face=\"Arial\" size=\"2\">"+ compare_creator(i)+"</font></td>");	//creator_up(rtList.creator[i]) +"</font></td>");
			str += ("</tr>");		
		}
		$('#list_container').html(str);
	}
	$(document).ready( function () {
		routingTable_list();
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

		<!-- top menu -->
		<div id="menu_top"></div>
		<script>$(document).ready(function($){ajax_load_page('menu_top.asp', 'menu_top', 'top_b4');});</script>
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
			<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b5');});</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('_routing')</script></h1>
				<b><script>show_words('sr_RTable')</script></b><br><br>
				<script>show_words('sr_intro')</script>
			</div>
			<div class="box">
				<h2><script>show_words('sr_RTable')</script></h2>
				<table cellSpacing=1 cellPadding=2 width=525 bgcolor="#FFFFFF" id="list_container">
				</table>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id="help_text"><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><a href="support_status.asp#routing"><script>show_words('_more')</script>&hellip;</a></p>
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
	get_lang();
</script>
</html>