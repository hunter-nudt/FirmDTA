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
<script type="text/javascript" src="js/public_ipv6.js"></script>
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
		arg: 	"ccp_act=get&num_inst=2"+
				"&oid_1=IGD_Layer3Forwarding_ForwardingV6_i_&inst_1=1100"+
				"&oid_2=IGD_Status_Routing6Table_i_&inst_2=1100"
	};
	mainObj.get_config_obj(param);

/**
**    Date:		2013-06-28
**    Author:	Silvia Chang
**    Reason:	Fixed pre-test bug no.44 (redmine 554) duplicate ipv6 static routing rule shown in ipv6 routing page
**    Note:		Ignored to display static routing6 rule, it will make duplicate rule.
**				Norman: If the rule not work, should not appear on routing6 page.
**				P.S Except interface of Lan/Wan, may have some rules need to show, confirm later.
**/

/*
	var array_enable 		 	= mainObj.config_str_multi("fwdV6Rule_Enable_");
	var array_destipv6ip	 	= mainObj.config_str_multi("fwdV6Rule_DestIPv6Address_");
	var array_destipv6prefix 	= mainObj.config_str_multi("fwdV6Rule_DestIPv6AddressPrefixLength_");
	var array_sourceinterface	= mainObj.config_str_multi("fwdV6Rule_SourceInterface_");
	var array_gatewayip	 	 	= mainObj.config_str_multi("fwdV6Rule_GatewayIPAddress_");
	var array_metric		 	= mainObj.config_str_multi("fwdV6Rule_ForwardingMetric_");
*/
	//var rule_max_num = 10;
	var array_dynamic_ip6 = mainObj.config_val("igdR6tList_Destination_").split(",");
	var array_dynamic_gw6 = mainObj.config_val("igdR6tList_Gateway_").split(",");
	var array_dynamic_metric = mainObj.config_val("igdR6tList_Metric_").split(",");
	var array_dynamic_iface = mainObj.config_val("igdR6tList_Interface_").split(",");
	//  1/name/ip/netmask/gateway/WAN/metric

	var re_dynamic_ip6 = new Array();
	var re_dynamic_gw6 = new Array();
	var re_dynamic_metric = new Array();
	var re_dynamic_iface = new Array();

	function DataShow(){

		var content = "";
			content += '<table cellSpacing=1 cellPadding=2 width=525 bgcolor="#FFFFFF">'
			content += '<tr><TD><b>'+get_words('_destip')+'</b></TD>'
			content += '<TD><b>'+get_words('_gateway')+'</b></TD>'
			content += '<TD><b>'+get_words('_metric')+'</b></TD>'
			content += '<TD><b>'+get_words('_interface')+'</b></TD></tr>'
/*
		//Static
		for (var i=0; i<array_enable.length;i++)
		{
			if(array_enable[i]==1)
			{
				var iface = "";
				if (array_sourceinterface[i] === "2") {
					iface = "WAN";
				} else if(array_sourceinterface[i] === "1"){
					iface = "LAN";
				} else if(array_sourceinterface[i] === "0"){
					iface = "lo";
					array_gatewayip[i]="";
				} else if(array_sourceinterface[i] === "3"){
					continue;
					iface = "ath1";
					array_gatewayip[i]="::";
					array_metric[i]="256";
				} else {
					iface = "Error";
				}
				content += "<tr bgcolor=\"#F0F0F0\">";
				content += "<td class=\"break_word\">"+ filter_ipv6_addr(array_destipv6ip[i]) +"/"+ array_destipv6prefix[i] +"</td>";
				content += "<td class=\"break_word\">"+ filter_ipv6_addr(array_gatewayip[i]) +"</td>";
				content += "<td>"+ array_metric[i] +"</td>";
				content += "<td>"+ iface +"</td>";
				content += "</tr>\n";
			}
		}
*/
		//dynamic
		for (var i=0; i<re_dynamic_iface.length;i++)
		{
			var iface = "";
			if (re_dynamic_iface[i] === "2") {
				iface = "WAN";
			} else if(re_dynamic_iface[i] === "1"){
				iface = "LAN";
			} else if(re_dynamic_iface[i] === "0"){
				continue;
			} else if(re_dynamic_iface[i] === "3"){
				iface = "ath1";
			} else {
				iface = "Error";
				continue;
			}

			content += "<tr bgcolor=\"#F0F0F0\">";
			content += "<td class=\"break_word\">"+ filter_ipv6_addr(re_dynamic_ip6[i]) +"</td>";
			content += "<td class=\"break_word\">"+ filter_ipv6_addr(re_dynamic_gw6[i]) +"</td>";
			content += "<td>"+ re_dynamic_metric[i] +"</td>";
			content += "<td>"+ iface +"</td>";
			content += "</tr>\n";
		}
		content += "</table>";
		
		$('#v6Route_List').html(content);
	}
	
	function onPageLoad()
	{
		//20130128 pascal add for same routing (WIFI/LAN), only show once
		for (var i=0; i<array_dynamic_iface.length;i++)
		{
			var isRepeat = false;
			if(array_dynamic_iface[i] === "2") //LAN
			{
				for (var j=i+1; j<array_dynamic_iface.length;j++)
				{
					if((array_dynamic_ip6[j] == array_dynamic_ip6[i]) && (array_dynamic_gw6[j] == array_dynamic_gw6[i]) &&
						(array_dynamic_metric[j] == array_dynamic_metric[i]) && (array_dynamic_iface[j] == array_dynamic_iface[i]))
						isRepeat = true;
				}
			}

/*
			for (var k=0; k<array_enable.length; k++)
			{
				if(array_enable[k]==1)
				{
					if(((filter_ipv6_addr(array_destipv6ip[k]) +"/"+ array_destipv6prefix[k]) == array_dynamic_ip6[i]) && 
					(filter_ipv6_addr(array_gatewayip[k]) == array_dynamic_gw6[i]) && 
					(array_metric[k] == array_dynamic_metric[i]) && (array_sourceinterface[k] == array_dynamic_iface[i]))
					isRepeat = true;
				}
			}
*/
			if(!isRepeat)
			{
				re_dynamic_ip6[re_dynamic_ip6.length++] = array_dynamic_ip6[i];
				re_dynamic_gw6[re_dynamic_gw6.length++] = array_dynamic_gw6[i];
				re_dynamic_metric[re_dynamic_metric.length++] = array_dynamic_metric[i];
				re_dynamic_iface[re_dynamic_iface.length++] = array_dynamic_iface[i];
			}
		}
		DataShow();
	}
	
</script>
</head>
<body>
<center>
	<input type="hidden" id="dhcp_list" name="dhcp_list" value=''>
	<input type="hidden" id="ipv6_wan_proto" name="ipv6_wan_proto" value=''>
	<input type="hidden" id="ipv6_pppoe_dynamic" name="ipv6_pppoe_dynamic" value=''>
	<input type="hidden" id="ipv6_6to4_tunnel_address" name="ipv6_6to4_tunnel_address" maxLength=80 size=80 value=''>
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
			<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b8');});</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('v6_routing');</script></h1>
				<b><p><script>show_words('v6_routing_table');</script></p></b>
				<p><script>show_words('v6_routing_info');</script></p>
			</div>
			<div class="box">
			<h2><script>show_words('v6_routing_table');</script><span id="show_resert"></span></h2> 
			<span id="v6Route_List"></span>
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
			<p><a href="support_status.asp#stv6_routing"><script>show_words('_more')</script>&hellip;</a></p>
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