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
	var auth 		= miscObj.config_val("graph_auth");
	var wband		= dev_info.wireless_band;
	var wband_cnt 	=(wband == "dual")?1:0;
	var wband_inst	=(wband == "dual")?4:2;
	var from = getUrlEntry('from');

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};

	//j --> 2.4G or 5G, i --> second inst k, counts --> oid number
	if (wband == "5G") {
		var i = 3;
	} else {
		var i = 1;
	}

	for (var j =0, k =2; j<= wband_cnt; j++)	//, counts =0
	{
		var n = 0;
		while (n < 2)
		{
			if (i == 3)	// get 5g info
				i= i+2;
	
			param.arg +="&oid_"+(k+1)+"=IGD_WLANConfiguration_i_&inst_"+(k+1)+"=1"+i+"00";
			param.arg +="&oid_"+(k+2)+"=IGD_WLANConfiguration_i_WEP_&inst_"+(k+2)+"=1"+i+"10";
			param.arg +="&oid_"+(k+3)+"=IGD_WLANConfiguration_i_WEP_WEPKey_i_&inst_"+(k+3)+"=1"+i+"10";
			param.arg +="&oid_"+(k+4)+"=IGD_WLANConfiguration_i_WPS_&inst_"+(k+4)+"=1"+i+"10";
			param.arg +="&oid_"+(k+5)+"=IGD_WLANConfiguration_i_WPA_EAP_i_&inst_"+(k+5)+"=1"+i+"10";
			param.arg +="&oid_"+(k+6)+"=IGD_WLANConfiguration_i_WPA_&inst_"+(k+6)+"=1"+i+"10";
			param.arg +="&oid_"+(k+7)+"=IGD_WLANConfiguration_i_WPA_PSK_&inst_"+(k+7)+"=1"+i+"10";
			k+=7;
			n++;
			i++;
		}
	}

	param.arg += "&ccp_act=get&num_inst="+k;
	mainObj.get_config_obj(param);	

	var wlan_enable = (mainObj.config_str_multi("wlanCfg_Enable_")? mainObj.config_str_multi("wlanCfg_Enable_"): "0");
	var wlan_ssid = (mainObj.config_str_multi("wlanCfg_SSID_")? mainObj.config_str_multi("wlanCfg_SSID_"): "");
	var wlan_secMode= (mainObj.config_str_multi("wlanCfg_SecurityMode_")? mainObj.config_str_multi("wlanCfg_SecurityMode_"): "0");
	var wlan_wepKeyIdx = (mainObj.config_str_multi("wepInfo_KeyIndex_")? mainObj.config_str_multi("wepInfo_KeyIndex_"): "1");
	var wlan_wepKeyType = (mainObj.config_str_multi("wepInfo_KeyTypeForGUI_")? mainObj.config_str_multi("wepInfo_KeyTypeForGUI_"): "1");

	var wlan_wepAuth= (mainObj.config_str_multi("wepInfo_AuthenticationMode_")? mainObj.config_str_multi("wepInfo_AuthenticationMode_"): "0");
	var wlan_wpaMode= (mainObj.config_str_multi("wpaInfo_WPAMode_")? mainObj.config_str_multi("wpaInfo_WPAMode_"): "0");
	var wlan_wpaAuth= (mainObj.config_str_multi("wpaInfo_AuthenticationMode_")? mainObj.config_str_multi("wpaInfo_AuthenticationMode_"): "0");
	var wlan_wpaKey = (mainObj.config_str_multi("wpaPSK_KeyPassphrase_")? mainObj.config_str_multi("wpaPSK_KeyPassphrase_"): "");
	
	var wlan_encType= (mainObj.config_str_multi("wpaInfo_EncryptionMode_")? mainObj.config_str_multi("wpaInfo_EncryptionMode_"): "0")
	
	var wlan_wepKeyLen= (mainObj.config_str_multi("wepInfo_KeyLength_")? mainObj.config_str_multi("wepInfo_KeyLength_"): "0");
	var wlan_wepKey64= mainObj.config_str_multi("wepKey_KeyHEX64_");
	var wlan_wepKey128=mainObj.config_str_multi("wepKey_KeyHEX128_");

	/**	Date:	2013-08-30
	 **	Author:	Silvia Chang
	 **	Reason:	TSD bug No.26118: Manual mode WPS
	 **	Note:	If WPS is disabled, even user key-in the page manually, do no display.
	 **/
	if (config_val("wpsCfg_Enable_") == 0)
	{
		var hasLogin = getCookie('hasLogin');  
		if (hasLogin == null || hasLogin == '0')
			location.replace("login.asp");
		else
			location.replace("wizard_wireless.asp");
	}
	var wlan_eapKey = mainObj.config_str_multi("wpaEap_RadiusServerPSK_");

	function onPageLoad()
	{
		var i = 0;
		var eap = 0;
		var wep = 0;
		
		if (wband == "5G" || wband == "dual")
			$('.5G_use').show();

		for (i;i<wband_inst;)
		{
			if(wlan_secMode[i] == "0"){					//Disabled
				$('#secu_mode_'+i).html(get_words('_none'));
				$('#wep_'+i).hide();
				$('#wpa_'+i).hide();
			}else if(wlan_secMode[i] == "1"){						//WEP
				$('#wep_'+i).show();
				$('#wpa_'+i).hide();
				var default_key = wlan_wepKeyIdx[i];
				var key = new Array();
				if(wlan_wepKeyLen[i] == '0')
				{
					key[1] = wlan_wepKey64[wep+0];
					key[2] = wlan_wepKey64[wep+1];
					key[3] = wlan_wepKey64[wep+2];
					key[4] = wlan_wepKey64[wep+3];
				}
				else
				{
					key[1] = wlan_wepKey128[wep+0];
					key[2] = wlan_wepKey128[wep+1];
					key[3] = wlan_wepKey128[wep+2];
					key[4] = wlan_wepKey128[wep+3];
				}

				var displayWepKey = key[default_key];
				if(wlan_wepKeyType[i] == "1")
					displayWepKey = hex_to_a(displayWepKey);

				$('#show_wep_key_'+i).html("WEP KEY " + default_key + " : <strong>" + displayWepKey + "</strong>");
				if(wlan_wepAuth[i] == "0"){
					$('#secu_mode_'+i).html(get_words('_WEP')+" - "+get_words('_open'));
				}else if(wlan_wepAuth[i] == "1"){
					$('#secu_mode_'+i).html(get_words('_WEP')+" - "+get_words('bws_Auth_2'));
				}
				else if(wlan_wepAuth[i] == "2"){
					$('#secu_mode_'+i).html(get_words('_WEP')+" - "+get_words('_both'));
				}
			}else {	//WPA
				//alert(wlan_wpaMode);
				//alert(wlan_secMode);
				$('#wpa_'+i).show();
				$('#wpa_key_'+i).show();
				$('#wep_'+i).hide();
				if(wlan_wpaMode[i] == "2" && wlan_secMode[i] == "2"){		
					$('#secu_mode_'+i).html(get_words('_WPApersonal'));
				}else if(wlan_wpaMode[i] == "2" && wlan_secMode[i] == "3"){
					$('#secu_mode_'+i).html(get_words('_WPAenterprise'));
					$('#wpa_key_'+i).hide();
				}else if(wlan_wpaMode[i] == "1" && wlan_secMode[i] == "2"){
					$('#secu_mode_'+i).html("WPA2 - "+get_words('LW24'));
				}else if(wlan_wpaMode[i] == "1" && wlan_secMode[i] == "3"){
					$('#secu_mode_'+i).html("WPA2 - "+get_words('LW23'));
					$('#wpa_key_'+i).hide();
				}else if(wlan_wpaMode[i] == "0" && wlan_secMode[i] == "2"){
					$('#secu_mode_'+i).html(get_words('KR48'));
				}else if(wlan_wpaMode[i] == "0" && wlan_secMode[i] == "3"){
					$('#secu_mode_'+i).html(get_words('bws_WPAM_2')+" - "+get_words('LW23'));
					$('#wpa_key_'+i).hide();
				}
				if  (wlan_secMode[i] == "2")
					$('#show_wpa_key_'+i).html(sp_words(wlan_wpaKey[i]));
				else{
					var show_eap = wlan_eapKey[eap];
					if (wlan_eapKey[eap+1])
						show_eap+=","+wlan_eapKey[eap+1];
					$('#show_wpa_key_'+i).html(show_eap);
				}
			}
			eap +=2;
			wep +=4;
			i+=2;
		}

		show_tr();
	}

	function onOKClick()
	{
		if(from == 'adv')
			window.location.href = "adv_wps_setting.asp";
		else
			window.location.href = "wizard_wireless.asp";
	}

	function show_tr()	//20120920 Silvia add, chk wifi devices
	{
		for (i=0; i<wband_inst;)
		{
			if (wlan_enable[i] == 0)
				$('#tr_0' + i ).hide();
			i+=2;
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
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br><br>
		<table width="84%" border="0">
		<tr>
			<td>
			<div class=box>
				<h2 align="left"><script>show_words('KR36')</script></h2>
			<table width="600" border="0" align="center">
			<!--2.4G-->
			<tr><td>
				<p class="box_msg"><script>show_words('wwl_intro_end')</script></p>
			</td></tr>
			<tr id="tr_00">
				<td colspan="2" align="left"><br>
				<div class="box">
					<table align="center" border="0" cellpadding="20" cellspacing="0" width="90%">
					<tr>
						<td>
							<script>show_words('GW_WLAN_RADIO_0_NAME')</script>
							<script>show_words('help699')</script>: 
							<strong><script>document.write(sp_words(wlan_ssid[0]))</script></strong><br><br>
							<script>show_words('bws_SM')</script>: 
							<strong><span id="secu_mode_0"></span></strong><br><br>

							<div id="wpa_0" style="display:none">
								<script>show_words('bws_CT')</script>
								: <strong><font style="text-transform:uppercase;">
									<script>
									if(wlan_encType[0] == "0")
										document.write("TKIP");
									else if(wlan_encType[0] == "1")
										document.write("AES");
									else
										document.write("TKIP/AES");
									</script>
								</font></strong><br><br>
							</div>
							<div  id="wpa_key_0" style="display:none">
								<script>show_words('LW25')</script>: 
								<strong><span id="show_wpa_key_0"></span></strong>
							</div>
							<div id="wep_0" style="display:none">
								<span id="show_wep_key_0"></span>
							</div>
						</td>
					</tr>
					</table>
				</div>
				</td>
			</tr>

			<!--2.4G guest zone	20111227 silvia add-->
		<!--
		**    Date:		2013-02-22
		**    Author:	Silvia Chang
		**    Note: 0019918: Setup-Wireless Settings, The Guest Zone information should not be displayed.
		-->
			<tr id="tr_01" style="display:none">
				<td colspan="2" align="left"><br>
				<div class="box">
				<table align="center" border="0" cellpadding="20" cellspacing="0" width="90%">
				<tr>
					<td>
						<script>show_words('_guestzone')</script>
						<script>show_words('help699')</script>: 
						<strong><script>document.write(sp_words(wlan_ssid[1]))</script></strong><br><br>
						<script>show_words('bws_SM')</script>: 
						<strong><span id="secu_mode_1"></span></strong><br><br>

						<div id="wpa_1" style="display:none">
							<script>show_words('bws_CT')</script>
							: <strong><font style="text-transform:uppercase;">
								<script>
								if(wlan_encType[1] == "0")
									document.write("TKIP");
								else if(wlan_encType[1] == "1")
									document.write("AES");
								else
									document.write("TKIP/AES");
								</script>
							</font></strong><br><br>
						</div>
						<div id="wpa_key_1" style="display:none">
							<script>show_words('LW25')</script>: 
							<strong><span id="show_wpa_key_1"></span></strong>
						</div>
						<div id="wep_1" style="display:none">
							<span id="show_wep_key_1"></span>
						</div>
					</td>
				</tr>
				</table>
				</div>
				</td>
			</tr>

			<!--5G-->
		<tr id="tr_02" class="5G_use" style="display:none">
				<td colspan="2" align="left"><br>
				<div class="box">
				<table align="center" border="0" cellpadding="20" cellspacing="0" width="90%">
				<tr>
					<td>
						<script>show_words('GW_WLAN_RADIO_1_NAME')</script>
						<script>show_words('help699')</script>: 
						<strong><script>
							if (wband == "5G" || wband == "dual")
								document.write(sp_words(wlan_ssid[2]))
						</script></strong><br><br>
						<script>show_words('bws_SM')</script>: 
						<strong><span id="secu_mode_2"></span></strong><br><br>

						<div id="wpa_2" style="display:none">
							<script>show_words('bws_CT')</script>
							: <strong><font style="text-transform:uppercase;">
								<script>
								if (wband == "5G" || wband == "dual"){
									if(wlan_encType[2] == "0")
										document.write("TKIP");
									else if(wlan_encType[2] == "1")
										document.write("AES");
									else
										document.write("TKIP/AES");
								}
								</script>
							</font></strong><br><br>
						</div>
						<div  id="wpa_key_2" style="display:none">
							<script>show_words('LW25')</script>: 
							<strong><span id="show_wpa_key_2"></span></strong>
						</div>
						<div id="wep_2" style="display:none">
							<span id="show_wep_key_2"></span>
						</div>
					</td>
				</tr>
				</table>
				</div>
				</td>
			</tr>

			<!--5G guest zone-->
			<tr id="tr_03" style="display:none">
				<td colspan="2" align="left"><br>
				<div class="box">
				<table align="center" border="0" cellpadding="20" cellspacing="0" width="90%">
				<tr>
					<td>
						<script>show_words('_guestzone')</script>
						<script>show_words('help699')</script>: 
						<strong><script>
							if (wband == "5G" || wband == "dual")
								document.write(sp_words(wlan_ssid[3]))
						</script></strong><br><br>
						<script>show_words('bws_SM')</script>: 
						<strong><span id="secu_mode_3"></span></strong><br><br>

						<div id="wpa_3" style="display:none">
							<script>show_words('bws_CT')</script>
							: <strong><font style="text-transform:uppercase;">
								<script>
								if (wband == "5G" || wband == "dual"){
									if(wlan_encType[3] == "0")
										document.write("TKIP");
									else if(wlan_encType[3] == "1")
										document.write("AES");
									else
										document.write("TKIP/AES");
								}
								</script>
							</font></strong><br><br>
						</div>
						<div  id="wpa_key_3" style="display:none">
							<script>show_words('LW25')</script>: 
							<strong><span id="show_wpa_key_3"></span></strong>
						</div>
						<div id="wep_3" style="display:none">
							<span id="show_wep_key_3"></span>
						</div>
					</td>
				</tr>
				</table>
				</div>
				</td>
			</tr>
			<!--end of silvia add-->

			<tr align="center">
				<td> 
					<br>
					<input name="OK_b" id="OK_b" type="button" class=button_submit value="" onClick="onOKClick();">
					<script>$('#OK_b').val(get_words('_ok'));</script>&nbsp;
				</td>
			</tr>
			</table>
			</div>
			<p>&nbsp;</p>

			</td>
		</tr>
		</table>
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
<script>
	onPageLoad();
</script>
</html>