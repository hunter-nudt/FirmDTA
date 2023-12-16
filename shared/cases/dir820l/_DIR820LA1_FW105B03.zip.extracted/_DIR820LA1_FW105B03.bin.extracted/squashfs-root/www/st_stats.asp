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
	var wband_inst	=(wband == "2.4G")?4:6;

	/*
	**    Date:		2013-03-14
	**    Author:	Silvia Chang
	**    Reason:   Request from Leo, DLink model on Zoo2.0 still no support mulit-wan now,
	**				this will cause the system to print out "BUG ON!!"
	**/

	//query traffic statistics
	var statObj = new ccpObject();
	var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get'+
				'&oid_1=IGD_LANDevice_i_LANStatistic_&inst_1=1110'+
				'&oid_2=IGD_WANDevice_i_WANStatistic_&inst_2=1110'+
				'&oid_3=IGD_WLANConfiguration_i_WLANStatistic_&inst_3=1110'+
				'&oid_4=IGD_WLANConfiguration_i_WLANStatistic_&inst_4=1210'
	};

	if (wband == "5G" || wband == "dual")
	{
		param.arg += '&oid_5=IGD_WLANConfiguration_i_WLANStatistic_&inst_5=1510'+
					 '&oid_6=IGD_WLANConfiguration_i_WLANStatistic_&inst_6=1610'
	}
	
	param.arg += '&num_inst=' + wband_inst;
	
	statObj.get_config_obj(param);

	var stLan = {
		'sent':			statObj.config_val('igdLanStatistic_PacketsSent_'),
		'received':		statObj.config_val('igdLanStatistic_PacketsReceived_'),
		'tx':			statObj.config_val('igdLanStatistic_PacketsDropTx_'),
		'rx':			statObj.config_val('igdLanStatistic_PacketsDropRx_'),
		'collision':	statObj.config_val('igdLanStatistic_Collisions_'),
		'error':		statObj.config_val('igdLanStatistic_Errors_')
	};
	
	var stWan = {
		'sent':			statObj.config_str_multi('igdWanStatistic_PacketsSent_'),
		'received':		statObj.config_str_multi('igdWanStatistic_PacketsReceived_'),
		'tx':			statObj.config_str_multi('igdWanStatistic_PacketsDropTx_'),
		'rx':			statObj.config_str_multi('igdWanStatistic_PacketsDropRx_'),
		'collision':	statObj.config_str_multi('igdWanStatistic_Collisions_'),
		'error':		statObj.config_str_multi('igdWanStatistic_Errors_')
	};

	var stWlan = {
		'sent':			statObj.config_str_multi('igdWlanStatistic_PacketsSent_'),
		'received':		statObj.config_str_multi('igdWlanStatistic_PacketsReceived_'),
		'tx':			statObj.config_str_multi('igdWlanStatistic_PacketsDropTx_'),
		'rx':			statObj.config_str_multi('igdWlanStatistic_PacketsDropRx_'),
		'error':		statObj.config_str_multi('igdWlanStatistic_Errors_')
	};

	function onPageLoad()
	{
		if (wband == "5G" || wband == "dual")
			$('.5G_use').show();
		if (wband == "2.4G")
			$('.2G_use').show();
	}

	function reset_packets()
	{
		var resetObj = new ccpObject();
		var param = {
			'url': 	'statistic.ccp',
			'arg': 	'ccp_act=reset'
		};
		resetObj.get_config_obj(param);
	}

	var stats_string1, wlan_string;
	function show_stats(status)
	{
		var sent = 0, received = 0, tx = 0, rx = 0, collision = 0, error = 0;

		if(status == "lan"){
			sent = stLan.sent;
			received = stLan.received;
			tx = stLan.tx;
			rx = stLan.rx;
			collision = stLan.collision;
			error = stLan.error;
		}else if(status == "wan"){

			for (var jj = 0; jj<stWan.sent.length; jj++)
			{
				sent = parseInt(sent,10) + parseInt(stWan.sent[jj],10);
				received = parseInt(received,10) + parseInt(stWan.received[jj],10);
				tx = parseInt(tx,10) +parseInt(stWan.tx[jj],10);
				rx = parseInt(rx,10) + parseInt(stWan.rx[jj],10);
				collision = parseInt(collision,10)+ parseInt(stWan.collision[jj],10);
				error=  parseInt(error,10) + parseInt(stWan.error[jj],10);
			}

		}else if(status == "wlan1"){
			sent = parseInt(stWlan.sent[0])+parseInt(stWlan.sent[1]);
			received = parseInt(stWlan.received[0])+parseInt(stWlan.received[1]);
			tx = parseInt(stWlan.tx[0])+parseInt(stWlan.tx[1]);
			rx = parseInt(stWlan.rx[0])+parseInt(stWlan.rx[1]);
			error = parseInt(stWlan.error[0])+parseInt(stWlan.error[1]);
		}else if(status == "wlan2"){
			sent = parseInt(stWlan.sent[2])+parseInt(stWlan.sent[3]);
			received = parseInt(stWlan.received[2])+parseInt(stWlan.received[3]);
			tx = parseInt(stWlan.tx[2])+parseInt(stWlan.tx[3]);
			rx = parseInt(stWlan.rx[2])+parseInt(stWlan.rx[3]);
			error = parseInt(stWlan.error[2])+parseInt(stWlan.error[3]);
		}

		////////////////////////////////////
		stats_string1 = "<tr>";
		stats_string1 += '<td class=duple>'+get_words('ss_Sent')+' :</td>';
		stats_string1 += "<td width=340>&nbsp;" + sent + "</td>";
		stats_string1 += '<td class=duple>'+get_words('ss_Received')+' :</td>';
		stats_string1 += "<td width=340>&nbsp;" + received + "</td>";
		stats_string1 += "</tr>";
		stats_string1 += "<tr>";
		stats_string1 += '<td class=duple>'+get_words('ss_TXPD')+' :</td>';
		stats_string1 += "<td width=340>&nbsp;" + tx + "</td>";
		stats_string1 += '<td class=duple>'+get_words('ss_RXPD')+' :</td>';
		stats_string1 += "<td width=340>&nbsp;" + rx + "</td>"
		stats_string1 += "</tr>";
		
		stats_string2 = "<tr>";
		stats_string2 += '<td class=duple>'+get_words('ss_Collisions')+' :</td>';
		stats_string2 += "<td width=340>&nbsp;" + collision + "</td>";
		stats_string2 += '<td class=duple>'+get_words('ss_Errors')+' :</td>';
		stats_string2 += "<td width=340>&nbsp;" + error + "</td>";
		stats_string2 += "</tr>";

		wlan_string = "<tr>";
		wlan_string += "<td class=duple>&nbsp;</td>";
		wlan_string += "<td width=340>&nbsp;</td>";
		wlan_string += '<td class=duple>'+get_words('ss_Errors')+' :</td>';
		wlan_string += "<td width=340>&nbsp;" + error + "</td>";
		wlan_string += "</tr>";
	}
	
	$(document).ready( function () {
		if(dev_info.login_info != "w"){
			$('#refresh').attr('disabled',true);
			$('#reset').attr('disabled',true);
		}
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
		<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b3');});</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_stats.asp">

		<td valign="top" id="maincontent_container">
			<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
				<div id="box_header"> 

					<h1><script>show_words('_tstats')</script></h1>
					<script>show_words('ss_intro')</script>
					<br><br>
					<input name="refresh" type="button" id="refresh" value="" onClick=window.location.href="st_stats.asp">
					<input name="reset" type="button" id="reset" value="" onclick="reset_packets()">
					<script>$("#refresh").val(get_words('ss_reload'));</script>
					<script>$("#reset").val(get_words('ss_clear_stats'));</script>
				</div>
				<div class="box"> 
					<h2><script>show_words('ss_LANStats')</script></h2>
						<table borderColor=#ffffff cellSpacing=1 cellPadding=1 width=525>
							<script>
							show_stats("lan");
							document.write(stats_string1 + stats_string2);
							</script>
						</table>
				</div>
				<div class="box"> 
					<h2><script>show_words('ss_WANStats')</script></h2>
						<table borderColor=#ffffff cellSpacing=1 cellPadding=1 width=525>
							<script>
							show_stats("wan");
							document.write(stats_string1 + stats_string2);
							</script>
						</table>
				</div>
				<div class="box">
					<div class="5G_use" style="display:none">
						<h2><script>show_words('ss_Wstats_2')</script></h2>
					</div>
					<div class="2G_use" style="display:none">
						<h2><script>show_words('ss_WStats')</script></h2>
					</div>
					<table borderColor=#ffffff cellSpacing=1 cellPadding=1 width=525>
						<script>
						show_stats("wlan1");
						document.write(stats_string1 + wlan_string);
						</script>
					</table>
				</div>

				<div class="5G_use" style="display:none">
					<div class="box"> 
					<h2><script>show_words('ss_Wstats_5g')</script></h2>
					<table borderColor=#ffffff cellSpacing=1 cellPadding=1 width=525>
						<script>
						if (wband == "5G" || wband == "dual")
						{
							show_stats("wlan2");
							document.write(stats_string1 + wlan_string);
						}
						</script>
					</table>
					</div>
				</div>
		</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

		<form id="form2" name="form2" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="st_stats.asp">
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_stats.asp">
		</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text>
			<strong>
				<script>show_words('_hints')</script>&hellip;
			</strong>
			<p><script>show_words('hhss_intro')</script></p>
			<p><a href="support_status.asp#Statistics"><script>show_words('_more')</script>&hellip;</a></p>
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