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
	var wband		= dev_info.wireless_band;

	var mainObj = new ccpObject();
	var	param = {
		url: "get_set.ccp",
		arg: 'ccp_act=get&num_inst=4'+
				'&oid_1=IGD_WLANConfiguration_i_&inst_1=1100'+
				'&oid_2=IGD_WLANConfiguration_i_&inst_2=1200'+
				'&oid_3=IGD_WLANConfiguration_i_&inst_3=1500'+
				'&oid_4=IGD_WLANConfiguration_i_&inst_4=1600'
	};
	
	mainObj.get_config_obj(param);
	
	var pre_page = "";
	var key_str0 = "";
	var key_str1 = "";
	var ssid = mainObj.config_str_multi("wlanCfg_SSID_");
	var ssid_enable = mainObj.config_val("wlanCfg_SecSsidEnable_");

	var submit_button_flag = 0;
	var auto_length = 5;
	var wband_cnt =(wband == "dual")?1:0;

	function onPageLoad()
	{
		$('#same_wlan_pwd').attr('checked',parseInt(mainObj.config_val("wlanCfg_SamePwdEnable_")));
		$('#show_ssid0').val(ssid?ssid[0]:"dlink");
		if (wband == "5G" || wband == "dual")
		{
			$('#show_ssid_1').attr('checked',parseInt(ssid_enable));
			if(ssid)
			{
				if(ssid_enable == 1)
					$('#show_ssid1').val(ssid[4]);
				else
					$('#show_ssid1').val(ssid[0]);
			}else{
				if(ssid_enable == 1)
					$('#show_ssid1').val("dlink_media");
				else
					$('#show_ssid1').val("dlink");
			}
			$('.5G_use').show();
			show_5g_ssid();	
		}else
			$('.2_4G_use').show();

		set_form_default_values("form1");
		display_page("p1");
	}
	
	function mis_length(){
		var mis_length = 8;
		if(parseInt($('#asp_temp_35').val()) < 2){
			mis_length = 13;
		}
		return mis_length;
	}

	function max_length(){
		var max_length = 63;
		if(parseInt($('#asp_temp_35').val()) < 2){
			max_length = 26;
		}
		return max_length;
	}
	
	function check_key(key0,key1){
		var temp_key0 = key0;
		var temp_key1 = key1;
		var mis = mis_length();
		var max = max_length();
		$('#asp_temp_36').val("hex");
		$('#asp_temp_50').val("1");
		var chk_key = '';

		for (var i=0;i<=wband_cnt;i++)
		{
			var key = (i == 0)?(key0):(key1);
			var temp_key = (i == 0)?(temp_key0):(temp_key1);
			chk_key = key.split('');
			
			/* 20120424 Removed by Jerry, Dlink ask to correct it
			//20120228 silvia add chk hex type
			for (i=0;i<chk_key.length;i++)
			{
				if(!check_hex(chk_key[i]))
				{
					alert(get_words("wifi_pass_chk"));
					return false;
				}
			}
			*/
			if(parseInt($('#asp_temp_35').val()) == 1){
				if(key.length != mis && key.length != max && key.length != 5 && key.length != 10){
					alert(get_words("IPV6_TEXT2"));
					return false;
				}else{
					if(key.length == 5){
						mis = key.length;
						max = 10;
						$('#asp_temp_50').val(0);
					}else if(key.length == 10){
						mis = 5;
						max = key.length;
						$('#asp_temp_50').val(0);
					}
					if(key.length == max){
						for (var j = 0; j < key.length; j++){
							if (!check_hex(key.substring(j, j+1))){
								alert(get_words("IPV6_TEXT2"));  
								return false;
							}
						}
					}else{
						$('#asp_temp_36').val("ascii");
						temp_key = a_to_hex($('#key'+i).val());
					}
				}
			}else if(parseInt($('#asp_temp_35').val()) > 1){
				if (key.length < mis){
					alert(get_words("IPV6_TEXT2"));  
					return false;
				}else if (key.length > max){
					if(!isHex(key)){
						alert(get_words("IPV6_TEXT2"));
						return false;
					}
				}
				temp_key = $('#key'+i).val();
			}
		}

		$('#passpharse_0').val(temp_key0);
		$('#passpharse_1').val(temp_key1);
		$('#asp_temp_37').val($('#passpharse_0').val());
		$('#asp_temp_38').val($('#passpharse_1').val());
	}
	
	function get_auto_wepkey(length){
		var pass_word=""
		var seed = parseInt(Math.random() * 100,10);
		for (i=0; i<length ;i++ ){
			seed = (214013 * seed) & 0xffffffff;
		    if(seed & 0x80000000)
		        seed = (seed & 0x7fffffff) + 0x80000000 + 0x269ec3;
		    else
		        seed = (seed & 0x7fffffff) + 0x269ec3;
		    temp = ((seed >> 16) & 0xff);
		    if(temp < 0x10){
		        pass_word += "0" + temp.toString(16).toLowerCase();
			}else{
		        pass_word += temp.toString(16).toLowerCase();
		    }
		}
		return pass_word;
	}

	function wizard_cancel(){
		if (!is_form_modified("mainform")) {
			if(!confirm(get_words("_wizquit"))) {
				return false;
			}
		}
		window.location.href="wizard_wireless.asp";
	}
	
	function display_page(page)
	{
		if(page == "p1")
		{
			$('#p1').show();
			$('#p2').hide();
			$('#p3').hide();
		}
		else if(page == "p2")
		{
			pre_page = "p1";
			$('#p1').hide();
			$('#p2').show();
			$('#p3').hide();

			$('#show_psk').show();
			//$('#show_wep').hide();
			//get_by_id("key0").size = "64";
			//get_by_id("key1").size = "64";
		}
		else if(page == "p3")
		{
			$('#p1').hide();
			$('#p2').hide();
			$('#p3').show();

			$('#wpa_ssid0').html($('#show_ssid0').val());
			$('#wpa_psk_key0').html(key_str0);
//			$('#show_wep_3').hide();
			$('#show_wpa0').show();
			
			if (wband == "5G" || wband == "dual")
			{
				$('#wpa_ssid1').html($('#show_ssid1').val());
				$('#wpa_psk_key1').html(key_str1);
				$('#show_wpa1').show();
			}
		}
	}
	
	function next_page_from_p1()
	{
		if(!check_ssid_0("show_ssid0"))
			return;
		var ssid_en = $('#show_ssid_1').attr("checked")?1 : 0;
		if(ssid_en==1)
		{
			if(!check_ssid_0("show_ssid1"))
			return;
		}

		if(!check_ascii($('#show_ssid0').val()) || !check_ascii($('#show_ssid1').val())){
			alert(get_words("ssid_ascii_range"));
			return false;
		}

		pre_page = "p1";
		$('#p1').hide();
		//$('#asp_temp_35').val(1);			//wep
		$('#asp_temp_36').val("hex");
		if(get_by_name("auto_next_page")[0].checked == true)
		{
			key_str0 = get_auto_wepkey(auto_length);
			key_str1 = get_auto_wepkey(auto_length);
			display_page("p3");
		}
		else if(get_by_name("auto_next_page")[1].checked == true)
		{
			display_page("p2");
		}
		get_by_id("asp_temp_35").value = 2;
	}
	
	function next_page_from_p2()
	{
		var wwl_ssp_en = $("#same_wlan_pwd").attr("checked")?1 : 0;
		if(wwl_ssp_en == 0)
		{
			var key0 = $('#key0').val();
			var key1 = $('#key1').val();
		}
		else
		{
			var key2 = $('#key2').val();
			
			$('#key0').val(key2);
			$('#key1').val(key2);
			$('#passpharse_0').val(key2);
			$('#passpharse_1').val(key2);
			
			var key0 = $('#key0').val();
			var key1 = $('#key1').val();
		}
		if(check_key(key0,key1) == false)
			return;
		
		key_str0 = $('#passpharse_0').val();
		key_str1 = $('#passpharse_1').val();
		pre_page = "p2";
		
		display_page("p3");

		//get_by_id("show_wep_3").style.display = "none";
		$('#show_wpa0').show();
		$('#show_wpa1').show();
	}
	
	function submit_wizard()
	{
		var wwl_ssp_en = $("#same_wlan_pwd").attr("checked")?1 : 0;
		var wwl_sse_en = $("#show_ssid_1").attr("checked")?1 : 0;
		var submitObj = new ccpObject();
		var paramWizard = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=wizard_wireless.asp'
		};

		var i = 0;
		while( i <= wband_cnt )
		{
			var inst = (i == 0)?('1.1.'):('1.5.');
			var key_str = (i == 0)?(key_str0):(key_str1);
			paramWizard.arg += "&wlanCfg_Enable_"+ inst +"0.0=1";
			paramWizard.arg += "&wlanCfg_SSID_"+ inst +"0.0="+urlencode($('#show_ssid'+i).val());
			paramWizard.arg += "&wlanCfg_SecurityMode_"+ inst +"0.0=2";
			paramWizard.arg += "&wpaInfo_WPAMode_"+ inst +"1.0=0";
			paramWizard.arg += "&wpaInfo_AuthenticationMode_"+ inst +"1.0=0";
			paramWizard.arg += "&wpaInfo_EncryptionMode_"+ inst +"1.0=2";
			paramWizard.arg += "&wpaPSK_KeyPassphrase_"+ inst +"1.1="+urlencode(key_str);
			paramWizard.arg += "&wpsCfg_Status_"+ inst +"1.0=1";
			//paramWizard.arg += "&wpsCfg_SetupLock_"+ inst +"1.0=1";
			paramWizard.arg += "&wlanCfg_SamePwdEnable_"+ inst +"0.0="+wwl_ssp_en;
			paramWizard.arg += "&wlanCfg_SecSsidEnable_"+ inst +"0.0="+wwl_sse_en;
			i++;
		}
		submitObj.get_config_obj(paramWizard);
	}

	function use_same_pwd()
	{
		var wwl_ssp_en = $("#same_wlan_pwd").attr("checked")?1 : 0;
		if(wwl_ssp_en == 1)
		{
			$('#wl_wsp24').hide();
			$('#wl_wsp5').hide();
			$('#wl_ssp').show();
		}
		else
		{
			$('#wl_wsp24').show();
			$('#wl_wsp5').show();
			$('#wl_ssp').hide();
		}
	}

	function show_5g_ssid()
	{
		var ssid_en = $('#show_ssid_1').attr("checked")?1 : 0;
		var ssid1 = $('#show_ssid0').val();
		if(ssid_en == 1)
		{
			$('#ssid1').show();
			$('#show_ssid1').val(ssid[2]);
		}
		else
		{
			$('#ssid1').hide();
			$('#show_ssid1').val(ssid1);
		}
	}

	function change_5g_ssid(){
		var ssid_en = $('#show_ssid_1').attr("checked")?1 : 0;
		var ssid1 = $('#show_ssid0').val();
		if(ssid_en == 0)
			$('#show_ssid1').val(ssid1);
		else
			return;
	}
</script>
</head>

<body>
<center>
	<table class="MainTable" cellpadding="0" cellspacing="0" >
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
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br><br>
		<table width="650" border="0">
		<tr>
			<td>
			<div class="box" id="p1"> 
				<h2 align="left"><script>show_words('wwz_wwl_title_s3')</script></h2>
				<div align="center"> 
					<p class="box_msg" align="left"><script>show_words('wwz_wwl_intro_s3_1')</script></p>
				</div>

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="wizard_wlan1.asp">
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="wizard_wlan.asp">
			<input type="hidden" id="reboot_type" name="reboot_type" value="none">
			<input type="hidden" id="asp_temp_35" name="asp_temp_35" value="">
			<input type="hidden" id="asp_temp_37" name="asp_temp_37" value="">
			<input type="hidden" id="asp_temp_38" name="asp_temp_38" value="">
			<input type="hidden" id="asp_temp_36" name="asp_temp_36" value="hex">
			<input type="hidden" id="asp_temp_50" name="asp_temp_50" value="1"><!--64, 128 bits-->

		<!-------------------------------->
		<!--    start of option page    -->
		<!-------------------------------->
			<table align="center" class=formarea style="display:">
			<tr align="left">
				<td width="20">&nbsp;</td>
				<td colspan="2" class=form_label>
					<div class="style1">
						<strong><script>show_words('wwz_wwl_wnn')</script>&nbsp
						<script>show_words('GW_WLAN_RADIO_0_NAME')</script>:</strong> 
						<input type="text" id="show_ssid0" name="show_ssid0" size="20" maxlength="32" value="" onchange="change_5g_ssid()">
					</div>
				</td>
			</tr>

			<!--20120109 silvia add 5g -->
			<tr class="5G_use" style="display:none" align="left">
				<td width="20"></td>
				<td colspan="2" class=form_label>
					<div class="style1">
						<INPUT type="checkbox" id="show_ssid_1" name="show_ssid_1" onClick="show_5g_ssid();">
						<script>show_words('manul_5g_ssid')</script>
					</div>
				</td>
			</tr>
			<tr class="5G_use" style="display:none" align="left" id="ssid1">
				<td width="20">&nbsp;</td>
				<td colspan="2" class=form_label>
					<div class="style1">
						<strong><script>show_words('wwz_wwl_wnn')</script>&nbsp
						<script>show_words('GW_WLAN_RADIO_1_NAME')</script>:</strong> 
						<input type="text" id="show_ssid1" name="show_ssid1" size="20" maxlength="32" value="">
					</div>
				</td>
			</tr>
		<!--20120109 end of silvia add -->
			<tr align="left">
				<td width="20"><INPUT type="radio" id="auto_next_page" name="auto_next_page" value="wizard_wlan2.asp" checked></td>
				<td colspan="2" class=form_label>
					<div class="style1">
						<script>show_words('wwz_auto_assign_key3')</script>
					</div>
				</td>
			</tr>
			<tr align="left">
				<td width="20">&nbsp;</td>
				<td colspan="2" class=form_label>
					<p><script>show_words('wwz_auto_assign_key2')</script></p>
				</td>
			</tr>
			<tr align="left">
				<td width="20"><INPUT type="radio" id="auto_next_page" name="auto_next_page" value="wizard_wlan1.asp"></td>
				<td colspan="2" class=form_label>
					<div class="style1">
						<script>show_words('wwz_manual_key')</script>
					</div>
				</td>
			</tr>
			<tr align="left">
				<td width="20">&nbsp;</td>
				<td colspan="2" class=form_label>
					<p><script>show_words('wwz_manual_key2')</script></p>
				</td>
			</tr>
			<tr>
				<td class="box_msg" colspan="3"><br>
					<script>show_words('wwl_s3_note_2')</script><br>
				</td>
			</tr>
			<tr align="center">
				<td colspan="3">
					<input type="button" class="button_submit" id="prev_b" name="prev_b" value="" onclick=window.location.href="wizard_wireless.asp"> 
					<input type="button" class="button_submit" id="next_b" name="next_b" value="" onClick="next_page_from_p1();">
					<input type="button" class="button_submit" id="cancel_b" name="cancel_b" value="" onclick="wizard_cancel();"> 
					<script>$('#prev_b').val(get_words("_prev"));</script>
					<script>$('#next_b').val(get_words("_next"));</script>
					<script>$('#cancel_b').val(get_words("_cancel"));</script>
				</td>
			</tr>
			</table>
		<!------------------------------>
		<!--    End of option page    -->
		<!------------------------------>
		</form>
			</div>
			<div class=box id="p2"> 
				<h2 align="left"><script>show_words('wwl_title_s4_2')</script></h2>				
		<!-------------------------------->
		<!--       start of page 2      -->
		<!-------------------------------->
			<table align="center" class="formarea" summary="wizard wep" style="display:">
			<tr>
				<td class="box_msg" colspan="2"><br>
					<script>show_words('wwl_s4_intro')</script>
				<br><br>
				</td>
			</tr>
			<tr id="show_psk" style="display:none">
				<td class="box_msg" colspan="2">
					<span class="itemhelp" id="wlan_passwd_wpa">
						<script>show_words('wwl_s4_intro_za1')</script>
					</span><br><br>
					<span class="itemhelp" id="wlan_passwd_wpa">
						<script>show_words('wwl_s4_intro_za2')</script>
					</span><br><br>
					<span class="itemhelp" id="wlan_passwd_wpa">
						<script>show_words('wwl_s4_intro_za3')</script>
					</span><br><br>
				</td>
			</tr>

			<tr>
				<td align="center" colspan=2>
					<input type="checkbox" id="same_wlan_pwd" onClick="use_same_pwd();"><script>show_words("wwl_SSP")</script>
				</td>
			</tr>
			<tr id="wl_wsp24">
				<td class="duple" width="450">
					<strong><script>show_words('GW_WLAN_RADIO_0_NAME')</script>
					<script>show_words('wwl_WSP')</script></strong> 
					&nbsp;:&nbsp;</td>
				<td width="220">
					<input id="key0" name="key0" type="text" size="20" maxlength="64">
					<input type="hidden" id="passpharse_0" name="passpharse_0" maxlength="64">
				</td>
			</tr>
			<!--silvia add 5g band-->
			<tr id="wl_wsp5" class="5G_use" style="display:none">
				<td class="duple" width="450">
					<strong><script>show_words('GW_WLAN_RADIO_1_NAME')</script>
					<script>show_words('wwl_WSP')</script></strong> 
					&nbsp;:&nbsp;</td>
				<td width="220">
					<input id="key1" name="key1" type="text" size="20" maxlength="64">
					<input type="hidden" id="passpharse_1" name="passpharse_1" maxlength="64">
				</td>
			</tr>
			<tr id="wl_ssp">
				<td class="duple" width="450">
					<strong><script>show_words('wwl_WSP')</script></strong>&nbsp;:&nbsp;
				</td>
				<td width="220">
					<input id="key2" name="key2" type="text" size="20" maxlength="64">
					<input type="hidden" id="passpharse_2" name="passpharse_2" maxlength="64">
				</td>
			</tr>
			<tr>
				<td class="box_msg" colspan="2"><br>
					<script>show_words('wwl_s4_note')</script><br><br>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<p align="center"> 
					<input type="button" class="button_submit" id="prev_b_2" name="prev_b_2" value="" onclick="display_page('p1')">
					<input type="button" class="button_submit" id="next_b_2" name="next_b_2" value="" onClick="next_page_from_p2()">
					<input type="button" class="button_submit" id="cancel_b_2" name="cancel_b_2" value="" onclick="wizard_cancel();">
					<script>$('#prev_b_2').val(get_words("_prev"));</script>
					<script>$('#next_b_2').val(get_words("_next"));</script>
					<script>$('#cancel_b_2').val(get_words("_cancel"));</script>
				</p>
				</td>
			</tr>
			</table>
			</div>
			<!-------------------------------->
			<!--       End of page 2        -->
			<!-------------------------------->			

			<!-------------------------------->
			<!--      Start of page 3       -->
			<!-------------------------------->	
			<div class=box id="p3"> 
				<h2 align="left"><script>show_words('_setupdone')</script></h2>
				<div align="left"> 
					<p class="box_msg"><script>show_words('wwl_intro_end')</script></p>
					<table width="650" border="0" align="center" class="formarea" style="display:">

					<!--2.4G-->
					<tr id="show_wpa0" style="display:none">
						<td colspan="3">
						<table align="center" border="1" cellpadding="4" cellspacing="2" width="90%" rules="none">
						<tr>
							<td class="duple">
								<script>show_words('GW_WLAN_RADIO_0_NAME')</script>
								<script>show_words('wwl_wnn')</script>
							</td>
							<td width="10">:</td>
							<td width="277" align="left"><span id="wpa_ssid0"></span></td>
						</tr>
						<tr>
							<td class="duple"><script>show_words('bws_SM')</script></td>
							<td>:</td>
							<td><script>show_words('KR48')</script></td>
						</tr>
						<tr>
							<td class="duple"><script>show_words('bws_CT')</script></td>
							<td>:</td>
							<td><script>show_words('bws_CT_3')</script></td>
						</tr>
						<tr >
							<td class="duple"><script>show_words('_psk')</script></td>
							<td>:</td>
							<td><span id="wpa_psk_key0"></span></td>
						</tr>
						</table></td>
					</tr>
					<tr id="show_wpa1_auto" style="display:none">
						<td colspan="3">&nbsp;</td>
					</tr>

					<!--5G-->
					<tr id="show_wpa1" class="5G_use" style="display:none">
						<td colspan="3">
						<table align="center" border="1" cellpadding="4" cellspacing="2" width="90%" rules="none">
						<tr>
							<td class="duple">
								<script>show_words('GW_WLAN_RADIO_1_NAME')</script>
								<script>show_words('wwl_wnn')</script>
							</td>
							<td width="10">:</td>
							<td width="277" align="left"><span id="wpa_ssid1"></span></td>
						</tr>
						<tr>
							<td class="duple"><script>show_words('bws_SM')</script></td>
							<td>:</td>
							<td><script>show_words('KR48')</script></td>
						</tr>
						<tr>
							<td class="duple"><script>show_words('bws_CT')</script></td>
							<td>:</td>
							<td><script>show_words('bws_CT_3')</script></td>
						</tr>
						<tr >
							<td class="duple"><script>show_words('_psk')</script></td>
							<td>:</td>
							<td><span id="wpa_psk_key1"></span></td>
						</tr>
						</table></td>
					</tr>

					<tr>
						<td colspan="3">
							<div align="center">
								<input type="button" class="button_submit" id="prev_b_3" name="prev_b_3" value="" onClick="display_page(pre_page);">
								<input type="button" class="button_submit" id="save_b_3" name="save_b_3" value="" onClick="submit_wizard();">
								<input type="button" class="button_submit" id="cancel_b_3" name="cancel_b_3" value="" onclick="wizard_cancel();">
								<script>$('#prev_b_3').val(get_words("_prev"));</script>
								<script>$('#save_b_3').val(get_words("_save"));</script>
								<script>$('#cancel_b_3').val(get_words("_cancel"));</script>
							</div>
						</td>
					</tr>
					</table>
				</div>
			</div>
		<!-------------------------------->
		<!--       End of page 3        -->
		<!-------------------------------->	
			</td>
		</tr>
		</table>
		<p>&nbsp;</p>
		</td>
	</tr>
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
	use_same_pwd();
</script>
</html>