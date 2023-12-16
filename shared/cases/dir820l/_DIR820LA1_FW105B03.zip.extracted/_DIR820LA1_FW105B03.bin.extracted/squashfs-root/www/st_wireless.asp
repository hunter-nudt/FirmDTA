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
	var wband		= dev_info.wireless_band;

	var wir = 0;
	var gz = 0;
	var cli_list = {
		'mac': 		'',
		'ip': 		'',
		'mode':		'',
		'rate':		'',
		'rssi':		'',
		'enable':	''
	};
	var cli_list_gz = {
		'mac': 		'',
		'ip': 		'',
		'mode':		'',
		'rate':		'',
		'rssi':		'',
		'enable':	''
	};

	if (wband == "5G" || wband == "dual")
	{
		var wir_5 = 0;
		var gz_5 = 0;
		var cli_list_5 = {	//silvia add 5g
			'mac': 		'',
			'ip': 		'',
			'mode':		'',
			'rate':		'',
			'rssi':		'',
			'enable':	''
		};
		var cli_list_gz_5 = {
			'mac': 		'',
			'ip': 		'',
			'mode':		'',
			'rate':		'',
			'rssi':		'',
			'enable':	''
		};
	}

	function onPageLoad()
	{
		if (wband == "5G" || wband == "dual")
			$('.5G_use').show();
	}

	function paintList() {
		if ((cli_list.mac == '' || cli_list.mac == null) &&
			(cli_list_gz.mac == '' || cli_list_gz.mac == null))
			return ;

		var tb = $('#station_table > tbody:last');
		var content = '';

		if (cli_list.mac != '' && cli_list.mac != null && cli_list.enable == 1)
		{
			for (var i=0; i<cli_list.mac.length; i++) {
				content += '<tr>';

				if (cli_list.mac[i] != null && cli_list.mac[i] != '')	// mac
					content += '<td>'+cli_list.mac[i]+'</td>';
				else
					content += '<td>&nbsp;</td>';

				if (cli_list.ip[i] != null && cli_list.ip[i] != '')	// ip
					content += '<td>'+cli_list.ip[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list.mode[i] != null && cli_list.mode[i] != '')	// mode
					content += '<td>'+cli_list.mode[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list.rate[i] != null && cli_list.rate[i] != '')	// rate
					content += '<td>'+cli_list.rate[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list.rssi[i] != null && cli_list.rssi[i] != '')	// rssi
					content += '<td>'+cli_list.rssi[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				content += '</tr>';
				wir = cli_list.mac.length;
			}
		}
		
		//guest zone client
		if (cli_list_gz.mac != '' && cli_list_gz.mac != null && cli_list_gz.enable == 1)
		{
			for (var i=0; i<cli_list_gz.mac.length; i++) {
				content += '<tr>';

				if (cli_list_gz.mac[i] != null && cli_list_gz.mac[i] != '')	// mac
					content += '<td>'+cli_list_gz.mac[i]+'</td>';
				else
					content += '<td>&nbsp;</td>';

				if (cli_list_gz.ip[i] != null && cli_list_gz.ip[i] != '')	// ip
					content += '<td>'+cli_list_gz.ip[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_gz.mode[i] != null && cli_list_gz.mode[i] != '')	// mode
					content += '<td>'+cli_list_gz.mode[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_gz.rate[i] != null && cli_list_gz.rate[i] != '')	// rate
					content += '<td>'+cli_list_gz.rate[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';
			
				if (cli_list_gz.rssi[i] != null && cli_list_gz.rssi[i] != '')	// rssi
					content += '<td>'+cli_list_gz.rssi[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				content += '</tr>';
				gz = cli_list_gz.mac.length;
			}
		}
		tb.append(content);
	}

	function paintList_5() {	//silvia add 5g
		if ((cli_list_5.mac == '' || cli_list_5.mac == null) &&
			(cli_list_gz_5.mac == '' || cli_list_gz_5.mac == null))
			return ;

		var tb = $('#station_table_1 > tbody:last');
		var content = '';

		if (cli_list_5.mac != '' && cli_list_5.mac != null && cli_list_5.enable == 1)
		{
			for (var i=0; i<cli_list_5.mac.length; i++) {
				content += '<tr>';

				if (cli_list_5.mac[i] != null && cli_list_5.mac[i] != '')	// mac
					content += '<td>'+cli_list_5.mac[i]+'</td>';
				else
					content += '<td>&nbsp;</td>';

				if (cli_list_5.ip[i] != null && cli_list_5.ip[i] != '')	// ip
					content += '<td>'+cli_list_5.ip[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_5.mode[i] != null && cli_list_5.mode[i] != '')	// mode
					content += '<td>'+cli_list_5.mode[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_5.rate[i] != null && cli_list_5.rate[i] != '')	// rate
					content += '<td>'+cli_list_5.rate[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_5.rssi[i] != null && cli_list_5.rssi[i] != '')	// rssi
					content += '<td>'+cli_list_5.rssi[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				content += '</tr>';
			}
			wir_5 = cli_list_5.mac.length;
		}
		
		//guest zone client
		if (cli_list_gz_5.mac != '' && cli_list_gz_5.mac != null && cli_list_gz_5.enable == 1)
		{
			for (var i=0; i<cli_list_gz_5.mac.length; i++) {
				content += '<tr>';

				if (cli_list_gz_5.mac[i] != null && cli_list_gz_5.mac[i] != '')	// mac
					content += '<td>'+cli_list_gz_5.mac[i]+'</td>';
				else
					content += '<td>&nbsp;</td>';

				if (cli_list_gz_5.ip[i] != null && cli_list_gz_5.ip[i] != '')	// ip
					content += '<td>'+cli_list_gz_5.ip[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_gz_5.mode[i] != null && cli_list_gz_5.mode[i] != '')	// mode
					content += '<td>'+cli_list_gz_5.mode[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				if (cli_list_gz_5.rate[i] != null && cli_list_gz_5.rate[i] != '')	// rate
					content += '<td>'+cli_list_gz_5.rate[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';
			
				if (cli_list_gz_5.rssi[i] != null && cli_list_gz_5.rssi[i] != '')	// rssi
					content += '<td>'+cli_list_gz_5.rssi[i]+'</td>';
				else
					content += '<td>'+ get_words('UNKNOWN') +'</td>';

				content += '</tr>';
				gz_5=cli_list_gz_5.mac.length;
			}
		}
		tb.append(content);
	}

	function loadWifiClientList()
	{
		/** Get 2.4G wlan client list **/
		var cliObj2 = new ccpObject();
		var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=2'+
				'&oid_1=IGD_WLANConfiguration_i_WLANStatus_Client_i_&inst_1=1110'+
				'&oid_2=IGD_WLANConfiguration_i_&inst_2=1100'
		};
		cliObj2.get_config_obj(param);

		cli_list.mac  	= cliObj2.config_str_multi('igdWlanHostStatus_MACAddress_');
		cli_list.ip   	= cliObj2.config_str_multi('igdWlanHostStatus_IPAddress_');
		cli_list.mode 	= cliObj2.config_str_multi('igdWlanHostStatus_Mode_');
		cli_list.rate 	= cliObj2.config_str_multi('igdWlanHostStatus_Rate_');
		cli_list.rssi 	= cliObj2.config_str_multi('igdWlanHostStatus_Signal_');
		cli_list.enable 	= cliObj2.config_val('wlanCfg_Enable_');

		/** Get 2.4G wlan guest client list **/
		var cliObj2_gz = new ccpObject();
		var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=2'+
				'&oid_1=IGD_WLANConfiguration_i_WLANStatus_Client_i_&inst_1=1210'+
				'&oid_2=IGD_WLANConfiguration_i_&inst_2=1200'
		};
		cliObj2_gz.get_config_obj(param);

		cli_list_gz.mac  	= cliObj2_gz.config_str_multi('igdWlanHostStatus_MACAddress_');
		cli_list_gz.ip   	= cliObj2_gz.config_str_multi('igdWlanHostStatus_IPAddress_');
		cli_list_gz.mode 	= cliObj2_gz.config_str_multi('igdWlanHostStatus_Mode_');
		cli_list_gz.rate 	= cliObj2_gz.config_str_multi('igdWlanHostStatus_Rate_');
		cli_list_gz.rssi 	= cliObj2_gz.config_str_multi('igdWlanHostStatus_Signal_');
		cli_list_gz.enable 	= cliObj2_gz.config_val('wlanCfg_Enable_');

		paintList();
		//20120110 silvia add, calculate the number of connected devices
		$('#show_resert').html(wir+gz);

		if (wband == "5G" || wband == "dual")
		{
			/** Get 5G wlan client list **/
			var cliObj5 = new ccpObject();
			var param = {
			'url': 	'get_set.ccp',
			'arg': 	'ccp_act=get&num_inst=2'+
					'&oid_1=IGD_WLANConfiguration_i_WLANStatus_Client_i_&inst_1=1510'+
					'&oid_2=IGD_WLANConfiguration_i_&inst_2=1500'
			};
			cliObj5.get_config_obj(param);

			cli_list_5.mac  	= cliObj5.config_str_multi('igdWlanHostStatus_MACAddress_');
			cli_list_5.ip   	= cliObj5.config_str_multi('igdWlanHostStatus_IPAddress_');
			cli_list_5.mode 	= cliObj5.config_str_multi('igdWlanHostStatus_Mode_');
			cli_list_5.rate 	= cliObj5.config_str_multi('igdWlanHostStatus_Rate_');
			cli_list_5.rssi 	= cliObj5.config_str_multi('igdWlanHostStatus_Signal_');
			cli_list_5.enable 	= cliObj5.config_val('wlanCfg_Enable_');

			/** Get 5G wlan guest client list **/
			var cliObj5_gz = new ccpObject();
			var param = {
			'url': 	'get_set.ccp',
			'arg': 	'ccp_act=get&num_inst=2'+
					'&oid_1=IGD_WLANConfiguration_i_WLANStatus_Client_i_&inst_1=1610'+
					'&oid_2=IGD_WLANConfiguration_i_&inst_2=1600'
			};
			cliObj5_gz.get_config_obj(param);

			cli_list_gz_5.mac  	= cliObj5_gz.config_str_multi('igdWlanHostStatus_MACAddress_');
			cli_list_gz_5.ip   	= cliObj5_gz.config_str_multi('igdWlanHostStatus_IPAddress_');
			cli_list_gz_5.mode 	= cliObj5_gz.config_str_multi('igdWlanHostStatus_Mode_');
			cli_list_gz_5.rate 	= cliObj5_gz.config_str_multi('igdWlanHostStatus_Rate_');
			cli_list_gz_5.rssi 	= cliObj5_gz.config_str_multi('igdWlanHostStatus_Signal_');
			cli_list_gz_5.enable 	= cliObj5_gz.config_val('wlanCfg_Enable_');

			//20120110 silvia add, calculate the number of connected devices
			paintList_5();
			$('#show_resert_1').html(wir_5+gz_5);
		}
	}

	$(document).ready( function () {
		loadWifiClientList();
	});
</script>
</head>

<body onload="onPageLoad();">
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
		<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b6');});</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post">
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
				<div id="box_header"> 
					<h1><script>show_words('_wireless')</script></h1>
					<p><script>show_words('sw_intro')</script></p>
				</div>
				<div class="box"> 
					<h2><script>show_words('sw_title_list')</script>&nbsp;-
					<script>show_words('GW_WLAN_RADIO_0_NAME')</script>:&nbsp;
					<span id="show_resert"></span></h2>
					<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1  id="station_table">
					<tbody>
					<tr id="box_header">
						<TD><b><script>show_words('sd_macaddr')</script></b></TD>
						<TD><b><script>show_words('_ipaddr')</script></b></TD>
						<TD><b><script>show_words('_mode')</script></b></TD>
						<TD><b><script>show_words('_rate')</script></b></TD>
						<TD><b><script>show_words('_rssi')</script></b></TD>
					</tr>
					</tbody>
					</table>
				</div>

				<div class="5G_use" style="display:none">
					<div class="box"> 
						<h2><script>show_words('sw_title_list')</script>&nbsp;-
						<script>show_words('GW_WLAN_RADIO_1_NAME')</script>:&nbsp;
						<span id="show_resert_1"></span></h2>
						<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1 id="station_table_1">
						<tr id="box_header">
							<TD><b><script>show_words('sd_macaddr')</script></b></TD>
							<TD><b><script>show_words('_ipaddr')</script></b></TD>
							<TD><b><script>show_words('_mode')</script></b></TD>
							<TD><b><script>show_words('_rate')</script></b></TD>
							<TD><b><script>show_words('_rssi')</script></b></TD>
						</tr>
						</table>
					</div>
				</div>
		</form>
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
			<p><script>show_words('hhsw_intro')</script></p>
			<p><a href="support_status.asp#Wireless"><script>show_words('_more')</script>&hellip;</a></p>
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
</html>