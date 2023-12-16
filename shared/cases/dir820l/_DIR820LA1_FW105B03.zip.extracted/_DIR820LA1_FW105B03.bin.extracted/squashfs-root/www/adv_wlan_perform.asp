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
	var wband		= dev_info.wireless_band;
	var wband_cnt	=(wband == "dual")?1:0;
	var ch5_DFS_lst	= dev_info.ch5_DFS_lst;

	var mainObj = new ccpObject();
	var param = {
		url: 	"get_set.ccp",
		arg: 	"ccp_act=get&num_inst=1&"+
				"oid_1=IGD_WLANConfiguration_i_&inst_1=1000&"+
				"oid_2=IGD_WLANConfiguration_i_&inst_2=1200&"+
				"oid_3=IGD_WLANConfiguration_i_&inst_3=1500&"+
				"oid_4=IGD_WLANConfiguration_i_&inst_4=1600"
	};
	mainObj.get_config_obj(param);

	var array_wlanEnable 		= mainObj.config_str_multi("wlanCfg_Enable_");
	var array_power 			= mainObj.config_str_multi("wlanCfg_TransmitPower_");
	var array_partitionEnable	= mainObj.config_str_multi("wlanCfg_WlanPartitionEnable_");
	var array_wmmEnable			= mainObj.config_str_multi("wlanCfg_WMMEnable_");
	var array_shortGiEnable		= mainObj.config_str_multi("wlanCfg_ShortGIEnable_");
	var array_chanwidth			= mainObj.config_str_multi("wlanCfg_ChannelWidth_");
	var array_coexi				= mainObj.config_str_multi("wlanCfg_BSSCoexistenceEnable_");
	var dfs_enable				= mainObj.config_str_multi("wlanCfg_DFSEnable_");

	var submit_button_flag = 0;
	function onPageLoad()
	{
		//20120111 silvia add Coexistence	0419 Modify
		set_checked(array_coexi[0], get_by_name('coexi'));
		if (array_chanwidth[0] == 0)
		{
			$('#coexi0').attr('disabled',true);
			$('#coexi1').attr('disabled',true);
			set_checked(0, get_by_name('coexi'));
		}

		if (wband == "5G" || wband == "dual")
			$('.5G_use').show();

		var j=0;
		for (var i=0;i<=wband_cnt;i++){
			if(array_power)
				$("#wlan"+i+"_txpower")[0].selectedIndex = array_power[j];
			if(array_partitionEnable)
				set_checked(array_partitionEnable[j], $("#wlan"+i+"_partition_sel")[0]);
			if(array_wmmEnable)
				set_checked(array_wmmEnable[j], $("#wlan"+i+"_wmm_enable_sel")[0]);
			//if(array_shortGiEnable)
				//set_checked(array_shortGiEnable[j], $("#wlan"+i+"_short_gi_sel")[0]);
			j+=2;
			$('#wlan'+i+'_wmm_enable_sel').attr('disabled',true);
		}
		var wlan0_enable = "";
		var wlan1_enable = "";
		if(array_wlanEnable){
			wlan0_enable = array_wlanEnable[0];
			if (wband == "5G" || wband == "dual")
				wlan1_enable = array_wlanEnable[2];
		}else{
			wlan0_enable = "0";
			wlan1_enable = "0";
		}
		setValueDFSChannelEnable();
		if(wlan0_enable =="0" && wlan1_enable =="0")
			DisableEnableForm(form1,true);

		var login_who= login_Info;
		if(login_who!= "w")
			DisableEnableForm(form1,true);
	}

	function send_request(){
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		//DFS pop-up msg
		if($('#wlan1_dfs_enable_sel').attr('checked'))
			alert(get_words('DFS_TEXT002'));
		
		if(submit_button_flag == 0){
			submit_button_flag = 1;
			var setObj = new ccpObject();
			var str="ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_wlan_perform.asp";

			if (wband == "5G") {
				var i = 3;
			} else {
				var i = 1;
			}

			for (var j =0; j<= wband_cnt; j++) // 0 1 --> 2
			{
				var n = 0;
				while (n < 2)
				{
					if (i == 3)	// get 5g info
						i= i+2;

					str+="&wlanCfg_TransmitPower_1."+i+".0.0=" + $("#wlan"+j+"_txpower")[0].selectedIndex +
						"&wlanCfg_WlanPartitionEnable_1."+i+".0.0=" + get_checked_value($("#wlan"+j+"_partition_sel")[0])+
						"&wlanCfg_WMMEnable_1."+i+".0.0=" + get_checked_value($("#wlan"+j+"_wmm_enable_sel")[0]);
					n++;
					i++;
				}
			}

			str+="&wlanCfg_BSSCoexistenceEnable_1.1.1.0="+get_checked_value(get_by_name('coexi'));
			str+="&wlanCfg_DFSEnable_1.5.0.0="+($('#wlan1_dfs_enable_sel').attr('checked')?1:0);
			str+="&wlanCfg_DFSEnable_1.6.0.0="+($('#wlan1_dfs_enable_sel').attr('checked')?1:0);
			param.url="get_set.ccp";
			param.arg=str;
			setObj.get_config_obj(param);
			return true;
		}else{
			return false;
		}
		return false;
	}

function setValueDFSChannelEnable()
{
	//set value
	$('#wlan1_dfs_enable_sel').attr('checked',(dfs_enable[2]=='1'));
	
	//set visibility
	if(ch5_DFS_lst!='')
		$('#tr_dfs_enable').show();
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b11');</script>
		</td>
		<!-- end of left menu -->

	<form id="form1" name="form1" method="post" >
		<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
		<input type="hidden" id="html_response_message" name="html_response_message" value="">
		<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
		<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_wlan_perform.asp">
		<input type="hidden" id="wlan0_auto_txrate" name="wlan0_auto_txrate" value="">
		<input type="hidden" id="wlan0_wmm_enable" name="wlan0_wmm_enable" value="">
		<input type="hidden" id="wlan0_11d_enable" name="wlan0_11d_enable" value="">
		<input type="hidden" id="wlan0_partition" name="wlan0_partition" value="">
		<input type="hidden" id="wlan0_short_gi" name="wlan0_short_gi" value="">
		
		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
		<div id=maincontent>
			<div id=box_header>
				<h1><script>show_words('_advwls')</script></h1>
				<p><script>show_words('aw_intro')</script></p>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'adv_wlan_perform.asp');">
				<script>$("#button").val(get_words('_savesettings'));</script>
				<script>$("#button2").val(get_words('_dontsavesettings'));</script>
			</div>
			<div class=box>
				<h2><script>show_words('aw_title_2')</script></h2>
				<table width=525>
				<tr>
					<td align=right class="duple"><script>show_words('wwl_band')</script> :</td>
					<td>&nbsp;<b><script>show_words('KR16')</script></b></td>
				</tr>
				<tr>
					<td width="183" align=right class="duple"><script>show_words('aw_TP')</script> :</td>
					<td width="330">
					<select id="wlan0_txpower" name="wlan0_txpower" size="1" >
						<option value="19"><script>show_words('aw_TP_0')</script></option>
						<option value="15"><script>show_words('aw_TP_1')</script></option>
						<option value="3"><script>show_words('aw_TP_2')</script></option>
					</select>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('KR4_ww')</script> :</td>
					<td><INPUT type="checkbox" id="wlan0_partition_sel" name="wlan0_partition_sel" value="1"></td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('aw_WE')</script> :</td>
					<td><INPUT name="wlan0_wmm_enable_sel" type="checkbox" id="wlan0_wmm_enable_sel" value="1"></td>
				</tr>
<!--				<tr>
					<td align=right class="duple"><script>show_words('aw_sgi')</script> :</td>
					<td><INPUT type="checkbox" id="wlan0_short_gi_sel" name="wlan0_short_gi_sel" value="1"></td>
				</tr>
-->				<tr>
					<td class="duple">
						<script>show_words('coexi')</script>:</td>
					<td width="340">
						<input type="radio" id="coexi1" name="coexi" value="1">
						<script>show_words('_enable')</script>
						<input type="radio" id="coexi0" name="coexi" value="0">
						<script>show_words('_disable')</script>
					</td>
				</tr>
				</table>
            </div>

			<div class="5G_use" style="display:none">
				<div class=box>
					<h2><script>show_words('aw_title_2')</script></h2>
					<TABLE width=525>
					<tr> 
						<td align=right class="duple"><script>show_words('wwl_band')</script> :</td>
						<td>&nbsp;<b><script>show_words('KR17')</script></b></td>
					</tr>
					<tr> 
						<td width="183" align=right class="duple"><script>show_words('aw_TP')</script> :</td>
						<td width="330"> <select id="wlan1_txpower" name="wlan1_txpower" size="1" >
							<option value="19"><script>show_words('aw_TP_0')</script></option>
							<option value="15"><script>show_words('aw_TP_1')</script></option>
							<option value="3"><script>show_words('aw_TP_2')</script></option>
						</select> </td>
					</tr>
						<td align=right class="duple"><script>show_words('KR4_ww')</script> :</td>
						<td> <INPUT type="checkbox" id="wlan1_partition_sel" name="wlan1_partition_sel" value="1"> </td>
					</tr>
					<tr> 
						<td align=right class="duple"><script>show_words('aw_WE')</script> :</td>
						<td> <INPUT name="wlan1_wmm_enable_sel" type="checkbox" id="wlan1_wmm_enable_sel" value="1"> </td>
					</tr>
					<tr id="tr_dfs_enable" style="display:none;"> 
						<td align="right" class="duple"><script>show_words('DFS_TEXT001')</script> :</td>
						<td> <input name="wlan1_dfs_enable_sel" type="checkbox" id="wlan1_dfs_enable_sel" /> </td>
					</tr>
	<!--				<tr> 
						<td align=right class="duple"><script>show_words('aw_sgi')</script> :</td>
						<td> <INPUT type="checkbox" id="wlan1_short_gi_sel" name="wlan1_short_gi_sel" value="1"> </td>
					</tr>
	-->				</table>
				</div>
			</div>
		</td>
	</form>

			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('hhaw_1')</script></p>
            <p><script>show_words('hhaw_wmm')</script></p>
			<p><a href="support_adv.asp#Advanced_Wireless"><script>show_words('_more')</script>&hellip;</a></p>
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