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

	var mainObj = new ccpObject();
	var param = {
	url: 	"get_set.ccp",
	arg: 	"ccp_act=get&num_inst=8&"+
			"oid_1=IGD_WANDevice_i_PortTriggerRule_i_&inst_1=1100&"+
			"oid_2=IGD_ScheduleRule_i_&inst_2=1000&" +
			"oid_3=IGD_&inst_3=1000&"+
			"oid_4=IGD_WANDevice_i_PortFwd_i_&inst_4=1100&"+
			"oid_5=IGD_WANDevice_i_VirServRule_i_&inst_5=1100&"+
			"oid_6=IGD_AdministratorSettings_&inst_6=1100&"+
			"oid_7=IGD_Storage_&inst_7=1100&"+
			"oid_8=IGD_WANDevice_i_&inst_8=1100"
	};
	mainObj.get_config_obj(param);
	var dev_mode = mainObj.config_val("igd_DeviceMode_");
	var wan_proto = mainObj.config_val("wanDev_CurrentConnObjType_");

	var array_enable 		= mainObj.config_str_multi("ptRule_Enable_");
	var array_name 			= mainObj.config_str_multi("ptRule_ApplicationName_");
	var array_tgport 		= mainObj.config_str_multi("ptRule_TriggerPorts_");
	var array_fwport 		= mainObj.config_str_multi("ptRule_FirewallPorts_");
	var array_tgprotocol 	= mainObj.config_str_multi("ptRule_TriggerProtocol_");
	var array_fwprotocol 	= mainObj.config_str_multi("ptRule_FirewallProtocol_");
	var array_Schdule 		= mainObj.config_str_multi("ptRule_ScheduleIndex_");

	var array_vs_enable		= mainObj.config_str_multi("vsRule_Enable_");
	var array_vs_proto	 	= mainObj.config_str_multi("vsRule_Protocol_");
	var array_vs_ports 		= mainObj.config_str_multi("vsRule_PublicPort_");
	var array_pf_enable		= mainObj.config_str_multi("pfRule_Enable_");
	var array_pf_ports_udp	= mainObj.config_str_multi("pfRule_UDPOpenPorts_");
	var array_pf_ports_tcp	= mainObj.config_str_multi("pfRule_TCPOpenPorts_");

	var array_sch_inst 		= mainObj.config_inst_multi("IGD_ScheduleRule_i_");
	var array_schedule_name	= mainObj.config_str_multi("schRule_RuleName_");

	var wa_http_en 			= mainObj.config_val("igdStorage_Http_Remote_Access_Enable_");
	var wa_https_en 		= mainObj.config_val("igdStorage_Https_Remote_Access_Enable_");
	var wa_http_port 		= mainObj.config_val("igdStorage_Http_Remote_Access_Port_");
	var wa_https_port		= mainObj.config_val("igdStorage_Https_Remote_Access_Port_");

	var schedule_cnt = 0;
	var submit_button_flag = 0;
	var rule_max_num = 24;
	var resert_rule = rule_max_num;

	if(array_schedule_name != null)
		schedule_cnt = array_schedule_name.length;

	function onPageLoad()
	{
		var login_who= login_Info;
		if(login_who!= "w" || dev_mode == "1" || wan_proto == "10"){
			DisableEnableForm(form1,true);
		}
		setTimeout("paint_table()", 2);
	}

	function do_submit()
	{
		var submitObj = new ccpObject();
		var param = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_appl.asp'
		};
		
		for (var i=1; i<=rule_max_num; i++) {
			if ($('#enable'+(i-1))[0].checked == false && $('#name'+(i-1)).val() == '') {
				param.arg += '&ptRule_Enable_1.1.'+i+'.0=0';
				param.arg += '&ptRule_ApplicationName_1.1.'+i+'.0=';
				param.arg += '&ptRule_TriggerPorts_1.1.'+i+'.0=0';
				param.arg += '&ptRule_FirewallPorts_1.1.'+i+'.0=0';
				param.arg += '&ptRule_TriggerProtocol_1.1.'+i+'.0=0';
				param.arg += '&ptRule_FirewallProtocol_1.1.'+i+'.0=0';
				param.arg += '&ptRule_ScheduleIndex_1.1.'+i+'.0=255';
			} else {
				param.arg += '&ptRule_Enable_1.1.'+i+'.0=' + (get_by_id('enable'+(i-1)).checked? '1' : '0');
				param.arg += '&ptRule_ApplicationName_1.1.'+i+'.0=' + get_by_id('name'+(i-1)).value;
				param.arg += '&ptRule_TriggerPorts_1.1.'+i+'.0=' + get_by_id('trigger_port'+(i-1)).value;
				param.arg += '&ptRule_FirewallPorts_1.1.'+i+'.0=' + get_by_id('public_port'+(i-1)).value;
				param.arg += '&ptRule_TriggerProtocol_1.1.'+i+'.0=' + get_by_id('trigger'+(i-1)).value;
				param.arg += '&ptRule_FirewallProtocol_1.1.'+i+'.0=' + get_by_id('public'+(i-1)).value;
				param.arg += '&ptRule_ScheduleIndex_1.1.'+i+'.0=' + get_by_id('schedule'+(i-1)).value;
			}
		}
		submitObj.get_config_obj(param);
	}

	function send_request()
	{
		var tcp_timeline = null;
		var udp_timeline = null;

		if (!is_form_modified("form3") && !confirm(get_words('_ask_nochange')))
			return false;

		// add virtual server ports into timeline
		try {
			for (var i=0; i<array_vs_enable.length; i++)
			{
				if (array_vs_enable[i] == '0')
					continue;
				var vs_ports = array_vs_ports[i].split(',');
				for (var j=0; j<vs_ports.length; j++)
				{
					var range = vs_ports[j].split('-');
					if (array_vs_proto[i] == '0') {
						tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
					} else if (array_vs_proto[i] == '1') {
						udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
					} else {
						tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
						udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
					}
				}
			}
		} catch (e) {
			alert('error occur in adding port trigger ports into timeline');
		}
		
		// add port forward ports into timeline
		try {
			for (var i=0; i<array_pf_enable.length; i++)
			{
				if (array_pf_enable[i] == '0')
					continue;
				var pf_tcp_ports = array_pf_ports_tcp[i].split(',');
				for (var j=0; j<pf_tcp_ports.length; j++) {
					var range = pf_tcp_ports[j].split('-');
					tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
				}
				var pf_udp_ports = array_pf_ports_udp[i].split(',');
				for (var j=0; j<pf_udp_ports.length; j++) {
					var range = pf_udp_ports[j].split('-');
					udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
				}
			}
		} catch (e) {
			alert('error occur in adding port forward ports into timeline');
		}

		var remote_port=mainObj.config_val("adminCfg_RemoteAdminHttpPort_");
		var remote_port_enable=mainObj.config_val("adminCfg_RemoteManagementEnable_");
		var remote_https_en=mainObj.config_val("adminCfg_RemoteAdminHttpsEnable_");
		var remote_https_port=mainObj.config_val("adminCfg_RemoteAdminHttpsPort_");

		//add Remote management port to time line
		try
		{
			if(remote_port_enable == '1')
			{
				var tcp_ports = remote_port;
				tcp_timeline = add_into_timeline(tcp_timeline, tcp_ports, null);
			}
			if(remote_https_en == '1')
			{
				var tcp_ports = remote_https_port;
				tcp_timeline = add_into_timeline(tcp_timeline, tcp_ports, null);
			}
		}
		catch (e)
		{
			alert('error occur in adding port trigger ports into timeline');
		}

		//add web access ports into timeline
		if(wa_http_en == 1)
			tcp_timeline = add_into_timeline(tcp_timeline, wa_http_port, null);
		
		if(wa_https_en == 1)
			tcp_timeline = add_into_timeline(tcp_timeline, wa_https_port, null);
		
		var count = 0;
		for (var i = 0; i < rule_max_num; i++)
		{
			var name = get_by_id("name" + i);
			var proto_type = get_by_id("public" + i).selectedIndex;
			var trigger_port = (get_by_id("trigger_port" + i).value).split("-");
			var public_port = (get_by_id("public_port" + i).value).split(",");			
			var is_enable = 0;
			var temp_appl;

			if (name.value != "")
			{
				var chk_trigger_port="";
				if (get_by_id("trigger_port" + i).value == ""){
		     		alert(get_words('TRIGGER_PORT_ERROR', LangMap.msg));
		     		return false;
		     	}else if (get_by_id("public_port" + i).value == ""){
		     		alert(get_words('PUBLIC_PORT_ERROR', LangMap.msg));
		     		return false;
		     	}
				
				if(is_number(get_by_id("trigger_port" + i).value))
					get_by_id("trigger_port" + i).value = parseInt(get_by_id("trigger_port" + i).value,10);
				if(is_number(get_by_id("public_port" + i).value))
					get_by_id("public_port" + i).value = parseInt(get_by_id("public_port" + i).value,10);
					
		     	if (!check_port(trigger_port[0])){
	 				alert(get_words('TRIGGER_PORT_ERROR', LangMap.msg));
	 				return false;
	 			}
				chk_trigger_port += parseInt(trigger_port[0],10);
		     	if (trigger_port.length > 1)
				{
		     		if (!check_port(trigger_port[1])){
		 				alert(get_words('PUBLIC_PORT_ERROR', LangMap.msg));
		 				return false;
		 			}	
					chk_trigger_port += "-" + parseInt(trigger_port[1],10);
		     	}
				get_by_id("trigger_port" + i).value=chk_trigger_port;
				
				var tmp_public = get_by_id("public_port" + i).value.split("-");
				if (tmp_public.length ==2 && tmp_public[0] == ""){
	 				alert(get_words('PUBLIC_PORT_ERROR', LangMap.msg));
	 				return false;
	 			}
				
		     	if(get_by_id("enable" + i).checked == true)
				{
					var chk_public_port="";
					for (var j = 0; j < public_port.length; j++)
					{
						var port = public_port[j].split("-");
						for(var k=0; k<port.length; k++)
						{
							if(port[k]=="")
							{
								alert(get_words('ac_alert_invalid_port'));									
								return false;
							}
						}
						
						var temp_port1 = "";
						var temp_port2 = "";
						temp_port1 = port[0];
						
						if (port.length > 1)
							temp_port2 = port[1];					
						
						if (temp_port1 != ""){
							if (!check_port(temp_port1)){
								alert(get_words('PUBLIC_PORT_ERROR', LangMap.msg));
								return false;
							}
							chk_public_port += parseInt(temp_port1,10);
						}					
						if (temp_port2 != ""){
							if (!check_port(temp_port2)){
								alert(get_words('PUBLIC_PORT_ERROR', LangMap.msg));
								return false;
							}
							chk_public_port += "-" + parseInt(temp_port2,10);
						}
						if(public_port.length>1 && j<public_port.length-1)
							chk_public_port += ",";
					}
					
					get_by_id("public_port" + i).value=chk_public_port;

					//check application firewall port and remote management port conflict problem
					var remote_port = "";
					var remote_port_enable = "";
					if($("#enable" + i)[0].checked == true)
					{
						if (proto_type == 0) {
							var tcp_ports = ($('#public_port'+i).val()).split(',');
							for (var j=0; j<tcp_ports.length; j++) {
								var range = tcp_ports[j].split('-');
								tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
							}
						} else if (proto_type == 1) {
							var udp_ports = ($('#public_port'+i).val()).split(',');
							for (var j=0; j<udp_ports.length; j++) {
								var range = udp_ports[j].split('-');
								udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
							}
						} else {
							var tcp_ports = ($('#public_port'+i).val()).split(',');
							for (var j=0; j<tcp_ports.length; j++) {
								var range = tcp_ports[j].split('-');
								tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
							}
							var udp_ports = ($('#public_port'+i).val()).split(',');
							for (var j=0; j<udp_ports.length; j++) {
								var range = udp_ports[j].split('-');
								udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
							}
						}
					}
				}

				for(jj=i+1;jj<rule_max_num;jj++)
				{
					if($("#name" + jj).val()==$("#name" + i).val()){
						alert(get_words('ag_inuse'));
						return false;
						break;
					}
					if($("#trigger" + jj).val() == $("#trigger" + i).val()){
						if($("#trigger_port" + jj).val()==$("#trigger_port" + i).val()){
							alert(get_words('TEXT057'));
							return false;
						}
					}
					if($("#public" + jj).val() == $("#public" + i).val()){
						if($("#public_port" + jj).val() == $("#public_port" + i).val()){
							alert(get_words('TEXT057'));	
							return false;
						}
					}
				}

				if (check_timeline(tcp_timeline) == false) {
					alert(addstr(get_words('ag_conflict5'), get_words('_firewall'), $('#public_port' + i).val()));
					return false;
				}
			
				if (check_timeline(udp_timeline) == false) {
					alert(addstr(get_words('ag_conflict5'), get_words('_trigger'), $('#public_port' + i).value));
					return false;
				}

		        count++;
			}  else {
				if ($('#enable'+i)[0].checked == true) {
					alert(get_words('GW_FIREWALL_RULE_NAME_INVALID'));
					return false;
				}
			}
		}

		if(submit_button_flag == 0){
			submit_button_flag = 1;
			//get_by_id("form2").submit();
			do_submit();
		}
		
		return false;
	}

	function add_option(id, def_val)
	{
		var obj = null;
		var arr = null;
		var nam = null;
		var str = '';
	
		if (id == 'Schedule') {
			obj = schedule_cnt;
			arr = array_sch_inst;
			nam = array_schedule_name;
		} else if (id == 'Inbound') {
			obj = inbound_cnt;
			arr = array_ib_inst;
			nam = array_ib_name;
		}
	
		if (obj == null)
			return;

		for (var i = 0; i < obj; i++)
		{
			var str_sel = '';

			if (id == 'Schedule') {
				var inst = inst_array_to_string(arr[i]);

				if (def_val == inst.charAt(1))
					str_sel = 'selected';

				str += ("<option value=" + inst.charAt(1) + " " + str_sel + ">" + nam[i] + "</option>");
			} else if (id == 'Inbound') {
				var inst = inst_array_to_string(arr[i]);
				if (def_val == inst.charAt(2))
					str_sel = 'selected';

				str += ("<option value=" + inst.charAt(2) + " " + str_sel + ">" + nam[i] + "</option>");
			}
		}
		return str;
	}

	function do_select(id, type, value)
	{
		var i=0;
		var obj = document.getElementById(id);
		
		if (obj == null)
			return;

		if (type == 'idx')
		{
			if (obj.options[value] != null)
				obj.options[value].selected = true;
		}
		else if (type == 'val')
		{
			for (i=0; i<obj.options.length; i++)
			{
				if (obj.options[i].value == value)
					obj.options[i].selected = true;
			}
		}
	}

	function paint_table()
	{
		var table_str = '<form id="form3"><h2>'+rule_max_num+'&ndash;&ndash; '+get_words('APP_RULES')+'</h2>';
			table_str +='<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1><tbody>';
			table_str +='<tr>';
			table_str +='<td align=middle width=20>&nbsp;</td>';
			table_str +='<td width="75">&nbsp;</td>';
			table_str +='<td align=middle><div align="left">&nbsp;</div></td>';
			table_str +='<td align=middle><div align="left"><strong>'+get_words('sps_port')+'</strong></div></td>';
			table_str +='<td align=middle><div align="left"><strong>'+get_words('av_traftype')+'</strong></div></td>';
			table_str +='<td align=middle><div align="left"><strong>'+get_words('_sched')+'</strong></div></td>';
			table_str +='</tr>';
			
		var Application_list = set_application_option(Application_list, default_appl);
		var disabledStr = "";
		if(login_Info!= "w" || dev_mode == "1")
			disabledStr = "disabled";

		for(var i=0 ; i< rule_max_num ; i++)
		{
			var obj_enable = "";
			var obj_name = "";
			var obj_tgport = "";
			var obj_fwport = "";
			var obj_tgprotocol = "";
			var obj_fwprototol = "";
			var obj_Schdule = "";

			if(array_enable!=null)
				obj_enable = array_enable[i];
			if(array_name!=null)
			{
				obj_name = array_name[i].replace("+"," ");
				obj_name = obj_name.replace("+"," ");
			}
			if(array_tgport!=null)
				obj_tgport = array_tgport[i];
			if(array_fwport!=null)
				obj_fwport = array_fwport[i];
			if(array_tgprotocol!=null)
				obj_tgprotocol = array_tgprotocol[i];
			if(array_fwprotocol!=null)
				obj_fwprototol = array_fwprotocol[i];
			if(array_Schdule!=null)
				obj_Schdule = array_Schdule[i];
				
			table_str +=("<tr>");
			if(obj_enable == '1')
				table_str+=("<td align=center rowspan=2><input "+disabledStr+" type=checkbox id=enable" + i + " name=enable" + i + " value=1 checked></td>");
			else
				table_str+=("<td align=center rowspan=2><input "+disabledStr+" type=checkbox id=enable" + i + " name=enable" + i + " value=1></td>");
			table_str+=('<td rowspan=2 align=center valign=middle>'+get_words('_name')+'<br><input '+disabledStr+' type=text class=flatL id=name' + i + ' name=name' + i + ' size=15 maxlength=31 value="'+obj_name+'"></td>');
			table_str+=('<td rowspan=2 align=center valign=middle>'+get_words('_app')+'<br>');
			table_str+=("<input "+disabledStr+" id=copy_app" + i + " name=copy_app" + i + " type=button value=<< class=btnForCopy onClick='copy_special_appl(" + i + ")'>");
			table_str+=("<select "+disabledStr+" class=wordstyle style='width:108' id=application" + i +" name=application" + i +" modified=\"ignore\">");
			table_str+=('<option>'+get_words('gw_SelVS')+'</option>');
			table_str+=(Application_list);
			table_str+=("</select></td>");
			
			table_str+=('<td align=center valign=bottom>'+get_words('_trigger')+'<br><input '+disabledStr+' type=text class=flatL id=trigger_port' + i +' name=trigger_port' + i +' maxLength=31 size=5 value="'+obj_tgport+'"></td>');
			table_str+=("<td align=center valign=middle>");
			table_str+=("<select "+disabledStr+" class=wordstyle id=trigger" + i + " name=trigger" + i +" >");
			table_str+=('<option value=\"0\" '+ (obj_tgprotocol == '0'? 'selected' : '') + '>'+get_words('_TCP')+'</option>');
			table_str+=('<option value=\"1\" '+ (obj_tgprotocol == '1'? 'selected' : '') + '>'+get_words('_UDP')+'</option>');
			table_str+=('<option value=\"2\" '+ (obj_tgprotocol == '2'? 'selected' : '') + '>'+get_words('at_Any')+'</option>');
			table_str+=("</select></td>");
			table_str+=("<td rowspan=2 align=center valign=middle>");
			table_str+=("<select "+disabledStr+" width=30 id=schedule" + i + " name=schedule" + i + " style='width:70'>");
			table_str+=('<option value=\"255\" '+ ((obj_Schdule==255) ? 'selected' : '' )+'>'+get_words('_always')+'</option>');
			table_str+=('<option value=\"254\" '+ ((obj_Schdule==254) ? 'selected' : '' )+'>'+get_words('_never')+'</option>');
			table_str+=(add_option('Schedule', obj_Schdule));
			
			table_str+=("</select>");
			table_str+=("</td>");
			table_str+=("</tr>");
			
			table_str+=("<tr>");
			table_str+=('<td align=center valign=bottom>'+get_words('_firewall')+'<br><input '+disabledStr+' type=text class=flatL id=public_port' + i + ' name=public_port'+ i +' maxLength=31 size=5 value="'+obj_fwport+'"></td>');
			table_str+=("<td align=center valign=middle>");
			table_str+=("<select "+disabledStr+" class=wordstyle id=public" + i + " name=public" + i +" >");
			table_str+=('<option value=\"0\" '+ (obj_fwprototol == '0'? 'selected' : '') + '>'+get_words('_TCP')+'</option>');
			table_str+=('<option value=\"1\" '+ (obj_fwprototol == '1'? 'selected' : '') + '>'+get_words('_UDP')+'</option>');
			table_str+=('<option value=\"2\" '+ (obj_fwprototol == '2'? 'selected' : '') + '>'+get_words('at_Any')+'</option>');
			table_str+=("</select></td>");
			table_str+=("</tr>");
		}
		
		table_str += '</tbody></table></form>';
		$("#contant_table").html(table_str);
		if(login_Info!= "w" || dev_mode == "1" || wan_proto == "10")
			DisableEnableForm(form3,true);

		set_form_default_values("form3");
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b3');</script>
		</td>
		<!-- end of left menu -->

	<form id="form1" name="form1" method="post" action="get_set.ccp">
		<input type="hidden" name="ccp_act" value="set">
		<input type="hidden" name="ccpSubEvent" value="CCP_SUB_WEBPAGE_APPLY">
		<input type="hidden" name="nextPage" value="adv_appl.asp">	
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('_specappsr')</script></h1>
				<script>show_words('as_intro_SA')</script><br><br>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type=button class=button_submit value="" onclick="page_cancel('form3', 'adv_appl.asp');">
				<script>$("#button2").val(get_words('_dontsavesettings'));</script>
				<script>$("#button").val(get_words('_savesettings'));</script>
			</div>

		<div class=box id="contant_table"></div>
		</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>
	</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text>
			<b><script>show_words('_hints')</script>&hellip;</b>
			<p><script>show_words('hhpt_intro')</script></p>
			<p><script>show_words('hhpt_app')</script></p>
			<p><script>show_words('hhpt_sch')</script></p>
			<p><a href="support_adv.asp#Special_Applications"><script>show_words('_more')</script>&hellip;</a></p>
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