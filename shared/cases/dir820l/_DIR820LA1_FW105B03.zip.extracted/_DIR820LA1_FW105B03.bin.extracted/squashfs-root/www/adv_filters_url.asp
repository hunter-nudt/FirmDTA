<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
		arg: 	"ccp_act=get&num_inst=5"+
				"&oid_1=IGD_URLFilter_&inst_1=1100"+
				"&oid_2=IGD_URLFilter_URLAllowList_i_&inst_2=1100"+
				"&oid_3=IGD_URLFilter_URLDenyList_i_&inst_3=1100"+
				"&oid_4=IGD_&inst_4=1000"+
				"&oid_5=IGD_WANDevice_i_&inst_5=1100"
	};
	mainObj.get_config_obj(param);
	var dev_mode = mainObj.config_val("igd_DeviceMode_");
	var wan_proto = mainObj.config_val("wanDev_CurrentConnObjType_");

	var allowUrlCnt	= (mainObj.config_val("urlFilter_URLAllowNumberOfEntries_")? mainObj.config_val("urlFilter_URLAllowNumberOfEntries_"): "0");
	var denyUrlCnt	= (mainObj.config_val("urlFilter_URLDenyNumberOfEntries_")? mainObj.config_val("urlFilter_URLDenyNumberOfEntries_"): "0");

	var array_allow_enable = mainObj.config_str_multi("urlFilterAllowList_Enable_");
	var array_deny_enable = mainObj.config_str_multi("urlFilterDenyList_Enable_");

	var array_allow_list = mainObj.config_str_multi("urlFilterAllowList_ManagedURL_");
	var array_deny_list = mainObj.config_str_multi("urlFilterDenyList_ManagedURL_");

	var array_allow_name = mainObj.config_str_multi("urlFilterAllowList_Name_");
	var array_deny_name = mainObj.config_str_multi("urlFilterDenyList_Name_");
	var filter_action = mainObj.config_val("urlFilter_Action_")?mainObj.config_val("urlFilter_Action_"):0;

	var submit_button_flag = 0;
	var rule_max_num = 40;

	function onPageLoad()
	{
		$("#url_domain_filter_type")[0].selectedIndex = filter_action;
		
		fill_list_field();
		var login_who= login_Info;
		if(login_who!= "w" || dev_mode == "1" || wan_proto == "10")
			DisableEnableForm(form1,true);	
	}

	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		for (var i = 0; i < rule_max_num; i++)
		{
			var temp_url = get_by_id("url_" + i).value;
			temp_url = temp_url.toLowerCase();

			if (temp_url != "")
			{
				if(temp_url.indexOf("http://") != -1)
					temp_url = temp_url.substring("http://".length);
				if(temp_url.lastIndexOf("/")  != -1)
					temp_url = temp_url.substring(0, temp_url.lastIndexOf("/"));

				for (var j = i+1; j < rule_max_num; j++)
				{
					hid_temp_url = $("#url_" + j).val();
					hid_temp_url = hid_temp_url.toLowerCase();
					if (hid_temp_url != ""){
						if(hid_temp_url.indexOf("http://") != -1){
							hid_temp_url = hid_temp_url.substring("http://".length);
						}
						if(hid_temp_url.lastIndexOf("/")  != -1){
							hid_temp_url = hid_temp_url.substring(0, hid_temp_url.lastIndexOf("/"));
						}
					}
					if (temp_url == hid_temp_url){
						alert(addstr(get_words('awf_alert_5'), temp_url));
						return false;
					}
				}
			}
		}

		var count = 0;

		for (var i = 0; i < rule_max_num; i++)
		{
			var tmp_url = $("#url_" + i).val();
			var pos = tmp_url.indexOf("http://");
			var pos1 = tmp_url.indexOf("https://");
			var lpos = tmp_url.lastIndexOf("/"); 

			var strGet_url = "";
			if(pos != -1){
				if(lpos < 7)
					strGet_url = tmp_url.substring(pos+7);
				else    
					strGet_url = tmp_url.substring(pos+7,lpos); 
			}else{
				if(pos1 != -1){
					alert(get_words('GW_URL_INVALID'));
					return false;
				}else{
					if(lpos != -1)
						strGet_url = tmp_url.substring(0,lpos);
					else
						strGet_url = tmp_url; 
				}
			}
			count++;
		}

		if(submit_button_flag == 0){
			submit_button_flag = 1;
			copy_data_to_cgi_struct();
		}
	}

	function copy_data_to_cgi_struct()
	{
		var act = $("#url_domain_filter_type").val();
		$("#urlFilter_Action_").val($("#url_domain_filter_type")[0].selectedIndex);
		var total_cnt = 0;
		var cgiObj = new ccpObject();
		var ruleContent = "";
		ruleContent += "&urlFilter_Action_1.1.0.0=" + $("#url_domain_filter_type")[0].selectedIndex;

		for(var i=0; i<rule_max_num; i++)
		{
			var strVal = $("#url_"+i).val().toLowerCase();
			var chkVal = "0";
			var nameVal =  $("#name_"+i).val().toLowerCase();

			if(strVal == "")
				continue;

			total_cnt ++;
			chkVal = "1";
			if(act == 'list_allow')
			{
				ruleContent += ("&urlFilterAllowList_ManagedURL_1.1."+(total_cnt)+".0=")+strVal;
				ruleContent += ("&urlFilterAllowList_Enable_1.1."+(total_cnt)+".0=")+chkVal;
				ruleContent += ("&urlFilterAllowList_Name_1.1."+(total_cnt)+".0=")+nameVal;
			}
			else
			{
				ruleContent += ("&urlFilterDenyList_ManagedURL_1.1."+(total_cnt)+".0=")+strVal;
				ruleContent += ("&urlFilterDenyList_Enable_1.1."+(total_cnt)+".0=")+chkVal;
				ruleContent += ("&urlFilterDenyList_Name_1.1."+(total_cnt)+".0=")+nameVal;
			}
		}

		var delCnt = 0;
		if(act == 'list_allow')
		{
			delCnt = ((allowUrlCnt > total_cnt)? (allowUrlCnt - total_cnt):0);

			if(delCnt > 0)
			{
				var delContent = "";
				delContent += "&num_inst="+delCnt;
			

				for(var i= allowUrlCnt; (i > total_cnt) && (delCnt>0); i--, delCnt--)
				{
					delContent += "&oid_"+delCnt+"=IGD_URLFilter_URLAllowList_i_&inst_"+delCnt+"=1.1."+i+".0";
				}

				var delObj = new ccpObject();
				var paramDel = {
					url: "get_set.ccp",
					arg: "ccp_act=del" + delContent
				};

				delObj.get_config_obj(paramDel);
			}
		}
		else{
			delCnt = ((denyUrlCnt > total_cnt)? (denyUrlCnt - total_cnt):0);
		
			if(delCnt > 0)
			{
				var delContent = "";
				delContent += "&num_inst="+delCnt;

				for(var i=denyUrlCnt; (i > total_cnt) && (delCnt>0); i--, delCnt--)
				{
					delContent += "&oid_"+delCnt+"=IGD_URLFilter_URLDenyList_i_&inst_"+delCnt+"=1.1."+i+".0";
				}

				var delObj = new ccpObject();
				var paramDel = {
					url: "get_set.ccp",
					arg: "ccp_act=del" + delContent
				};

				delObj.get_config_obj(paramDel);
			}
		}

		var paramSubmit = {
			url: "get_set.ccp",
			arg: "ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_filters_url.asp" + ruleContent
		};

		cgiObj.get_config_obj(paramSubmit);
	}

	function check_date()
	{
		var is_change = false;
		var check_domain_type = "";
		if ($("#url_domain_filter_type").val() != check_domain_type){
			is_change = true;
		}else if(!is_change){
			for(i=0;i<rule_max_num;i++)
			{
				var kk = i;
				if(i<10){
					kk = "0"+i;
				}
				if($("#url_domain_filter_"+ kk).val() != $("#url_"+ i).val()){
					is_change = true;
					break;
				}
			}
		}
		if(is_change){
			if (!confirm(get_words('up_jt_1')+"\n"+get_words('up_jt_2')+"\n"+get_words('up_jt_3')))
				return false;
		}
		location.href="tools_schedules.asp";
	}

	function clear_list_URL()
	{
		for (var i = 0; i < rule_max_num; i++) {
			$("#url_"+ i).val("");
			$("#name_"+ i).val("");
			$("#chk_"+ i).attr("checked","");
		}
	}

	function fill_list_field()
	{
		clear_list_URL();
		if($("#url_domain_filter_type").val() == 'list_allow')
		{
			for(var i=0; i<allowUrlCnt; i++)
			{
				$("#url_"+ i).val(array_allow_list[i]);
				$("#chk_"+ i)[0].checked = parseInt(array_allow_enable[i]);
				$("#name_"+ i).val(array_allow_name[i]);
			}
		}
		else
		{
			for(var i=0; i<denyUrlCnt; i++)
			{
				$("#url_"+ i).val(array_deny_list[i]);
				$("#chk_"+ i)[0].checked = parseInt(array_deny_enable[i]);
				$("#name_"+ i).val(array_deny_name[i]);
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b7');</script>
		</td>
		<!-- end of left menu -->
        <form id="form1" name="form1" method="post" action="get_set.ccp">
			<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>get_by_id("html_response_message").value = get_words('sc_intro_sv');</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_filters_url.asp">
			<input type="hidden" id="reboot_type" name="reboot_type" value="filter">

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
						<h1><script>show_words('_websfilter')</script></h1>
						<p><script>show_words('dlink_awf_intro_WF')</script><p>
						<input name="apply" id="apply" type="button" class=button_submit value="" onClick="send_request()">
						<input name="cancel" id="cancel" type=button class=button_submit value="" onclick="page_cancel('form1', 'adv_filters_url.asp');">
						<script>$("#apply").val(get_words('_savesettings'));</script>
						<script>$("#cancel").val(get_words('_dontsavesettings'));</script>
					</div>
					<div class=box> 
						<h2>40 &ndash;<script>show_words('awf_title_WSFR')</script></h2>
						<table cellSpacing=1 cellPadding=2 width=500 border=0>
							<tr>
								<td><script>show_words('dlink_wf_intro')</script></td>
							</tr>
							<tr>
								<td>
									<select id="url_domain_filter_type" name="url_domain_filter_type">
									<option value="list_deny"><script>show_words('dlink_wf_op_0')</script></option>
									<option value="list_allow"><script>show_words('dlink_wf_op_1')</script></option>
									</select>
								</td>
							</tr>
							<tr>
								<td>
									<script>document.write('<input type="button" class=button_submit value="'+get_words('awf_clearlist')+'" onclick="clear_list_URL()">')</script>
								</td>
							</tr>
						</table><br/>
						<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=0>
							<tr align=center>
								<td width="100%" colspan="2"><b><script>show_words('aa_WebSite_Domain')</script></b></td>
							</tr>
							<tr align=center>
								<td colspan="2"></td>
							</tr>
							<script>
								for(var i=0 ; i<rule_max_num ; i++){
									document.write("<tr align=center>");
									document.write("<td><span style=\"display:none\"><input type=checkbox id=chk_"+ i +" value=1></span><input id=\"url_" + i + "\" name=\"url_" + i + "\" maxlength=40 size=41></td>");
									document.write('<input type=hidden id=name_'+ i +' value=\"\">');
									document.write("<td><span style=\"display:none\"><input type=checkbox id=chk_"+ ++i +" value=1></span><input id=\"url_" + i + "\" name=\"url_" + i + "\" maxlength=40 size=41></td>");
									document.write('<input type=hidden id=name_'+ i +' value=\"\">');
									document.write("</tr>");
								}
							</script>
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
		<div id=help_text><strong>
			<script>show_words('_hints')</script>&hellip;</strong>
			<p><script>show_words('dlink_hhwf_intro')</script></p>
			<p><script>show_words('hhwf_xref')</script></p>
			<p><a href="support_adv.asp#Web_Filter"><script>show_words('_more')</script>&hellip;</a></p>
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