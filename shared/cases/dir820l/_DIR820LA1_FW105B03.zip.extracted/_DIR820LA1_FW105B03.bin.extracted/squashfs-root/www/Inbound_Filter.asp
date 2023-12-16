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

	var ibstObj = new ccpObject();
	var ibStParam = {
		url: "used_check.ccp",
		arg: "ccp_act=getStOfIbfilter"
	}
	ibstObj.get_config_obj(ibStParam);
	
	var usedIbfilter = ibstObj.config_val("usedIbfilter");
	var max_ib_len = 10;
	var RULES_IN_IFLTER = 8;

	var mainObj = new ccpObject();
	var param = {
		url: 	"get_set.ccp",
		arg: 	"ccp_act=get&num_inst=2&"+
				"oid_1=IGD_WANDevice_i_InboundFilter_i_&inst_1=1100&"+
				"oid_2=IGD_&inst_2=1000"
	};
	mainObj.get_config_obj(param);
	var dev_mode = mainObj.config_val("igd_DeviceMode_");

	var array_rule_inst = mainObj.config_inst_multi("IGD_WANDevice_i_InboundFilter_i_");
	var array_name = mainObj.config_str_multi("ibFilter_Name_");
	var array_action = mainObj.config_str_multi("ibFilter_Action_");
	
	if (array_rule_inst != null)
	{
		var ruleObj = new ccpObject();
		var param = {
			url: 	"get_set.ccp",
			arg: 	"ccp_act=get&num_inst="+array_rule_inst.length+"&"
		};
		for (var i=1; i<=array_rule_inst.length; i++) {
			var p_inst = new String(array_rule_inst[i-1]);
			param.arg += "&oid_"+i+"=IGD_WANDevice_i_InboundFilter_i_IPRange_i_&inst_"+i+"=11"+p_inst.substr(4, 1)+"0";
		}

		ruleObj.get_config_obj(param);
		var array_ip_inst = ruleObj.config_inst_multi("IGD_WANDevice_i_InboundFilter_i_IPRange_i_");

		var array_enable = ruleObj.config_str_multi("ipRange_Enable_");
		var array_ip_start = ruleObj.config_str_multi("ipRange_RemoteIPStart_");
		var array_ip_end = ruleObj.config_str_multi("ipRange_RemoteIPEnd_");
	}

	var submit_button_flag = 0;
	var rule_max_num = 10;
	var DataArray = new Array();
	var DataArray_detail = new Array(10);

	function onPageLoad()
	{
		if (array_enable != null && array_rule_inst.length >= max_ib_len)
			$('#button1').attr('disabled',true);

		onReset();

		var login_who= login_Info;
		if(login_who!= "w" || dev_mode == "1")
			DisableEnableForm(form1,true);	
	}

	function edit_row(obj)
	{
		$('#button1').attr('disabled',false);
		$("#edit").val(obj);
		$("#ingress_filter_name").val(array_name[obj]);
		$("#action_select")[0].selectedIndex = array_action[obj];
		for(j=0;j<RULES_IN_IFLTER;j++){
			set_checked(array_enable[obj*RULES_IN_IFLTER+j], $("#entry_enable_"+j)[0]);
			$("#ip_start_"+j).val(array_ip_start[obj*RULES_IN_IFLTER+j]);
			$("#ip_end_"+j).val(array_ip_end[obj*RULES_IN_IFLTER+j]);
		}
		$("#button1").val(get_words('YM34'));
		$("#form_act").val("edit");
		$("#ibFilter_inst").val(inst_array_to_string(array_rule_inst[obj]));
	}

	function del_row(row)
	{
		var tmp = new String(inst_array_to_string(array_rule_inst[row]));
		var idx = parseInt(tmp.charAt(2));
		var used_str = new String(usedIbfilter);
		
		if(used_str.charAt(idx-1) == '1')
		{
			alert(array_name[row] +" "+ get_words('GW_SCHEDULES_IN_USE_INVALID_s2'));	//GW_SCHEDULES_IN_USE_INVALID_s2, GW_SCHEDULES_IN_USE_INVALID
			return;
		}

		if (confirm(get_words('YM35')+" "+ array_name[row] +"?"))
		{
			var inst = new String(array_rule_inst[row]);
			var delInst = '';
			var delObj = new ccpObject();
			var param = {
				url: "get_set.ccp",
				arg: "ccp_act=del&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=Inbound_Filter.asp&"
			};

			if (inst.indexOf('.') != -1 || inst.indexOf(',') != -1) 
				delInst = '1.1.'+new String(array_rule_inst[row]).substr(4, 1)+'.0';
			else
				delInst = '1.1.'+new String(array_rule_inst[row]).substr(2, 1)+'.0';

			param.arg += "oid_1=IGD_WANDevice_i_InboundFilter_i_&inst_1="+delInst;
			delObj.get_config_obj(param);
			location.replace('Inbound_Filter.asp');
		}
		else
			return;
	}

	function do_submit()
	{
		var inst = '';
		var queryObj = new ccpObject();
		var param = {
			url: "get_set.ccp",
			arg: ''
		};

		if ($('#form_act').val() == 'add') {
			param.arg = "ccp_act=queryInst&num_inst=1";
			param.arg +="&oid_1=IGD_WANDevice_i_InboundFilter_i_&inst_1=1100";
			queryObj.get_config_obj(param);
			inst = queryObj.config_val("newInst");
		} else if ($('#form_act').val() == 'edit')
			inst = 	$('#ibFilter_inst').val();

		var submitObj = new ccpObject();
		param.arg = 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=Inbound_Filter.asp';
		param.arg += make_req_entry('&ibFilter_Name_', 			urlencode($('#ingress_filter_name').val()), inst);
		param.arg += make_req_entry('&ibFilter_Action_', 		$('#action_select')[0].selectedIndex, inst);
		
		for (var i=0; i<8; i++)
		{
			var rangeInst = '';
			if (inst.indexOf('.') != -1) 
				rangeInst = new String(inst).substr(0, 6)+(i+1);
			else
				rangeInst = '1.1.'+new String(inst).substr(2, 1)+'.'+(i+1);
			param.arg += make_req_entry('&ipRange_Enable_', 		$('#entry_enable_'+i)[0].checked? '1': '0', rangeInst);
			param.arg += make_req_entry('&ipRange_RemoteIPStart_', 	$('#ip_start_'+i).val(), rangeInst);
			param.arg += make_req_entry('&ipRange_RemoteIPEnd_', 	$('#ip_end_'+i).val(), rangeInst);
		}
		submitObj.get_config_obj(param);	
		location.replace('Inbound_Filter.asp');	// we have to add this line, otherwise, ie won't refresh page.
	}

	function send_request()
	{
		$('#button1').attr('disabled', true);
		setTimeout("$('#button1').attr('disabled', false)", 500);
		
		if($("#ingress_filter_name")[0].value.length > 0)
		{
			if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
				return false;

			if($('#form_act').val() == 'edit'){
				var edit_idx = $("#edit").val();
				var tmp = new String(inst_array_to_string(array_rule_inst[edit_idx]));
				var idx = parseInt(tmp.charAt(2));

				var used_str = new String(usedIbfilter);
				if(used_str.charAt(idx-1) == '1')
				{
					if(array_name[edit_idx] != $("#ingress_filter_name").val())
					{
						alert(array_name[edit_idx] +" "+ get_words('GW_SCHEDULES_IN_USE_INVALID_s2'));
						return false;
					}
				}
				if(!confirm(get_words('YM38')+" : " + $("#ingress_filter_name").val()))
					return false;
			}
			if($("#ingress_filter_name").val() == "Allow All" || $("#ingress_filter_name").val() == "Deny All"){
				alert(get_words('TEXT014'));
				return false;
			}

			var is_checked = false;
			for(var i=0;i<RULES_IN_IFLTER;i++)
			{
				var start_ip = $("#ip_start_"+i).val();
				var end_ip = $("#ip_end_"+i).val();

				var start_ip_addr_msg = replace_msg(all_ip_addr_msg,"Start IP address");
				var end_ip_addr_msg = replace_msg(all_ip_addr_msg,"End IP address");
				var start_obj = new addr_obj(start_ip.split("."), start_ip_addr_msg, false, false);
				var end_obj = new addr_obj(end_ip.split("."), end_ip_addr_msg, false, false);

				if(array_name != null && array_name[i]==$("#ingress_filter_name").val() && edit_idx != i){
					alert(addstr(get_words('GW_QOS_RULES_NAME_ALREADY_USED'),$("#ingress_filter_name").val()));
					return false;
				}

				if (!is_ipv4_valid(start_ip)) {
					alert(get_words('KR2') +" : " + start_ip + ".");
					$("#ip_start_"+i)[0].select();
					$("#ip_start_"+i)[0].focus();
					return false;
				}

				if (!is_ipv4_valid(end_ip)) {
					alert(get_words('KR2') +" : " + end_ip + ".");
					$("#ip_end_"+i)[0].select();
					$("#ip_end_"+i)[0].focus();
					return false;
				}
			
				if (!check_ip_order(start_obj, end_obj)){
					alert(get_words('IP_RANGE_ERROR', LangMap.msg));
					//alert("Start IP address must be less than end IP address");
					return false;
				}

				if($("#entry_enable_"+i)[0].checked){
					for(j=i+1;j<8;j++){
						if($("#entry_enable_"+j)[0].checked && (start_ip == $("#ip_start_"+j).val() && end_ip == $("#ip_end_"+j).val())){
							alert(addstr(get_words('ai_alert_7'), start_ip, end_ip));
							return false;
						}
					}
					is_checked = true;
				}
			}
			if(!is_checked){
				alert(addstr(get_words('ai_alert_5'), $("#ingress_filter_name").val()));
				return false;
			}
		}else{
			alert(get_words('GW_FIREWALL_RULE_NAME_INVALID'));
			return false;
		}
		do_submit();
		return false;
	}

	function copy_data_to_cgi_struct()
	{
		get_by_id("ibFilter_Name_").value = get_by_id("ingress_filter_name").value;
		get_by_id("ibFilter_Action_").value = get_by_id("action_select").selectedIndex;
	
		for(var i=1; i<=8; i++)
		{
			get_by_id("ipRange_Enable_"+i).value = get_checked_value(get_by_id("entry_enable_"+(i-1)));
			get_by_id("ipRange_RemoteIPStart_"+i).value = get_by_id("ip_start_"+(i-1)).value;
			get_by_id("ipRange_RemoteIPEnd_"+i).value = get_by_id("ip_end_"+(i-1)).value;
		}
	}

	function onReset()
	{
		$("#ingress_filter_name").val("");
		$("#action_select")[0].selectedIndex = 0;

		for(j=0;j<RULES_IN_IFLTER;j++){
			set_checked(0, $("#entry_enable_"+j)[0]);
			$("#ip_start_"+j).val("0.0.0.0");
			$("#ip_end_"+j).val("255.255.255.255");
		}
		$("#form_act").val("add");
		$("#ibFilter_inst").val("");
		$("#button1").val(get_words('_add'));
		set_form_default_values("form1");	
	}

	function print_ip_range(idx)
	{
		var str = '';
		for (var i=0; i<RULES_IN_IFLTER; i++)
		{
			var id = idx*RULES_IN_IFLTER+i;

			if (array_enable[id] == 0)
				continue;
			if (str != '') 
				str += ',';
			if (array_ip_start[id] == '0.0.0.0' && array_ip_end[id] == '255.255.255.255')
				str += '*';
			else
				str += array_ip_start[id] + '-' + array_ip_end[id];
		}
		return str;
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b8');</script>
		</td>
		<!-- end of left menu -->
			<input type="hidden" name="ccp_act" value="set">
			<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
			<input type="hidden" name="nextPage" value="Inbound_Filter.asp">
			<input type="hidden" id="form_act" value="add">
            <input type="hidden" id="edit" name="edit" value="-1">
			<input type="hidden" id="ibFilter_inst" value="">
			<input type="hidden" id="ibFilter_Name" name="ibFilter_Name_1.1.1.0" value="">
			<input type="hidden" id="ibFilter_Action" name="ibFilter_Action_1.1.1.0" value="">

			<script>
				for(var i=2; i<=DataArray.length; i++) {
					document.write("<input type=\"hidden\" id=\"ibFilter_Name_1.1."+i+".0\" name=\"ibFilter_Name_1.1."+i+".0\" value=\"\">");
					document.write("<input type=\"hidden\" id=\"ibFilter_Action_1.1."+i+".0\" name=\"ibFilter_Action_1.1."+i+".0\" value=\"\">");
				}
				for(var i=1; i<=8; i++){
					document.write("<input type=\"hidden\" id=\"ipRange_Enable_"+i+"\" name=\"ipRange_Enable_1.1.1."+i+"\" value=\"\">");
					document.write("<input type=\"hidden\" id=\"ipRange_RemoteIPStart_"+i+"\" name=\"ipRange_RemoteIPStart_1.1.1."+i+"\" value=\"\">");
					document.write("<input type=\"hidden\" id=\"ipRange_RemoteIPEnd_"+i+"\" name=\"ipRange_RemoteIPEnd_1.1.1."+i+"\" value=\"\">");
				}
			</script>

		<td valign="top" id="maincontent_container">
		<div id="maincontent">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="box_header">
				<h1><script>show_words('_inboundfilter')</script></h1>
				<p><script>show_words('ai_intro_1')</script></p>
				<p>
					<script>show_words('ai_intro_2')</script>
					<script>show_words('ai_intro_3')</script>
				</p><br>
			</div>
			<form id="form1" name="form1" method="post" action="get_set.ccp">
			<div class=box>
				<h2><span id="inbound_filter_name_rule_title"><script>show_words('_add')</script></span> <script>show_words('ai_title_IFR')</script></h2>
				<table cellSpacing=1 cellPadding=2 width=500 border=0>
				<tr>
					<td align=right class="duple">
					<script>show_words('_name')</script>:</td>
					<td>
						<input type="text" id="ingress_filter_name" size="20" maxlength="15">
					</td>
				</tr>
				<tr>
					<td align=right class="duple">
					<script>show_words('ai_Action')</script>:</td>
					<td>
						<select id="action_select">
							<option value="allow"><script>show_words('_allow')</script></option>
							<option value="deny"><script>show_words('_deny')</script></option>
						</select>
					</td>
				</tr>
				<tr>
					<td align=right valign="top" class="duple">
					<script>show_words('at_ReIPR')</script>:</td>
					<td>
						<table cellSpacing=1 cellPadding=2 width=300 border=0>
						<tr>
							<td><b><script>show_words('_enable')</script></b></td>
							<td><b><script>show_words('KR5')</script></b></td>
							<td><b><script>show_words('KR6')</script></b></td>
						</tr>
						<script>
							for(i=0;i<8;i++){
								document.write("<tr>")
								document.write("<td align=\"middle\"><INPUT type=\"checkbox\" id=\"entry_enable_"+ i +"\" id=\"entry_enable_"+ i +"\" value=\"1\"></td>")
								document.write("<td><input id=\"ip_start_" + i + "\" name=\"ip_start_" + i + "\" size=\"15\" maxlength=\"15\" value=\"0.0.0.0\"></td>")
								document.write("<td><input id=\"ip_end_" + i + "\" name=\"ip_end_" + i + "\" size=\"15\" maxlength=\"15\" value=\"255.255.255.255\"></td>")
								document.write("</tr>")
							}
						</script>
						</table>
					</td>
				</tr>
				<tr>
					<td></td>
					<td> 
						<input name="button1" id="button1" type="button" class=button_submit value="" onClick="send_request()">
						<input name="button2" id="button2" type="button" class=button_submit value="" onClick="onReset()">
						<script>$("#button1").val(get_words('_add'));</script>
						<script>$("#button2").val(get_words('_clear'));</script>
					</td>
				</tr>
				</table>
			</div>
			</form>

		<div class=box>
			<h2><script>show_words('ai_title_IFRL')</script></h2>
            </h2>
			<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
			<tr align=center>
				<td align=middle width=20>
					<b><script>show_words('_name')</script></b>
				</td>
				<td align=middle width=20>
					<b><script>show_words('ai_Action')</script></b>
				</td>
				<td width="255">
					<b><script>show_words('at_ReIPR')</script></b>
				</td>
				<td align=middle width=20><b>&nbsp;</b></td>
				<td align=middle width=20><b>&nbsp;</b></td>
			</tr>
			<script>
				if(array_rule_inst!=null) {
					for(var i=0;i<array_rule_inst.length;i++){
						var act = array_action[i] == '0'? get_words('_allow'): get_words('_deny');
						document.write("<tr>")
						document.write("<td>"+ sp_words(array_name[i]) +"</td>")
						document.write("<td>"+ act +"</td>")
						document.write("<td>"+ print_ip_range(i) +"</td>")
						document.write("<td><a href=\"javascript:edit_row("+ i +")\"><img src=\"image/edit.jpg\" border=\"0\" title=\""+get_words('_edit')+"\"></a></td>")
						document.write("<td><a href=\"javascript:del_row(" + i +")\"><img src=\"image/delete.jpg\"  border=\"0\" title=\""+get_words('_delete')+"\"></a></td>")
						document.write("</tr>")
					}
				}
			</script>
			</table>
		</div>
		</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong>
			<script>show_words('_hints')</script>
			&hellip;</strong>
			<p><script>show_words('hhai_name')</script></p>
			<p><script>show_words('hhai_action')</script></p>
			<p><script>show_words('hhai_ipr')</script></p>
			<p><script>show_words('hhai_ip')</script></p>
			<p><script>show_words('hhai_save')</script></p>
			<p><script>show_words('hhai_edit')</script></p>
			<p><script>show_words('hhai_delete')</script></p>
			<p><a href="support_adv.asp#Inbound_Filter"><script>show_words('_more')</script>&hellip;</a></p>
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