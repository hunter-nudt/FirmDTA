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
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();
	document.title = get_words('TEXT000');

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;
	var gigabit 	= dev_info.gigabit;

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=4";
	param.arg +="&oid_1=IGD_WANDevice_i_TrafficControl_&inst_1=1110";
	param.arg +="&oid_2=IGD_WANDevice_i_TrafficControl_Rule_i_&inst_2=1110";
	param.arg +="&oid_3=IGD_WANDevice_i_&inst_3=1100";
	param.arg +="&oid_4=IGD_Firewall_&inst_4=1100";

	mainObj.get_config_obj(param);

	var hw_nat_enable = mainObj.config_val("wanDev_HardwareNatEnable_");
	var trafficshap_enable = mainObj.config_val('wanTrafficShp_EnableTrafficShaping_');
	var spi_enable = mainObj.config_val("firewallSetting_SPIEnable_");

	var qos_obj = {
		'enableTrafficShaping':	mainObj.config_val('wanTrafficShp_EnableTrafficShaping_'),
		'autoUplinkSpeed':		mainObj.config_val('wanTrafficShp_AutoUplinkSpeed_'),
		'measuredUplinkSpeed':	mainObj.config_val('wanTrafficShp_MeasuredUplinkSpeed_'),
		'manualUplinkSpeed':	mainObj.config_val('wanTrafficShp_ManualUplinkSpeed_'),
		'enableQoSEngine':		mainObj.config_val('wanTrafficShp_EnableQoSEngine_'),
		'autoClassification':	mainObj.config_val('wanTrafficShp_AutoClassification_'),
		'dynamicFragmentation':	mainObj.config_val('wanTrafficShp_DynamicFragmentation_')
	};

	var qos_rule_obj = {
		'enable':			mainObj.config_str_multi('trafficRule_Enable_'),
		'name':				mainObj.config_str_multi('trafficRule_Name_'),
		'priority':			mainObj.config_str_multi('trafficRule_Priority_'),
		'localIPStart':		mainObj.config_str_multi('trafficRule_LocalIPAddrStart_'),
		'localIPEnd':		mainObj.config_str_multi('trafficRule_LocalIPAddrEnd_'),
		'remoteIPStart':	mainObj.config_str_multi('trafficRule_RemoteIPAddrStart_'),
		'remoteIPEnd':		mainObj.config_str_multi('trafficRule_RemoteIPAddrEnd_'),
		'localPortStart':	mainObj.config_str_multi('trafficRule_LocalPortStart_'),
		'localPortEnd':		mainObj.config_str_multi('trafficRule_LocalPortEnd_'),
		'remotePortStart':	mainObj.config_str_multi('trafficRule_RemotePortStart_'),
		'remotePortEnd':	mainObj.config_str_multi('trafficRule_RemotePortEnd_'),
		'protocolIdx':		mainObj.config_str_multi('trafficRule_Protocol_'),
		'protocalNum':		mainObj.config_str_multi('trafficRule_ProtoNum_')
	};

	var submit_button_flag = 0;
	var rule_max_num = 10;

	function onPageLoad()
	{
		set_checked(qos_obj.enableTrafficShaping, $("#qos_traffic_shaping")[0]);
		set_checked(qos_obj.autoUplinkSpeed, $("#qos_auto_uplink")[0]);
		set_checked(qos_obj.enableQoSEngine, $("#qos_engine_enabled")[0]);
		set_checked(qos_obj.autoClassification, $("#qos_auto_classification")[0]);
		set_checked(qos_obj.dynamicFragmentation, $("#qos_dyn_frag")[0]);
		set_selectIndex(qos_obj.manualUplinkSpeed, $("#qos_max_trans_rate_select")[0]);
		qos_max_trans_rate_selector(qos_obj.manualUplinkSpeed);
		qos_traffic_shaping_click($("#qos_traffic_shaping")[0].checked);
		set_qos_rule();

		if (login_Info != "w")
            DisableEnableForm(form1, true);

		set_form_default_values("form1");
	}

	function set_qos_rule()
	{
		for (var i = 0; i < rule_max_num; i++)
		{          
			if(qos_rule_obj.enable[i] != null)
			{
				if (qos_rule_obj.enable[i] == "1") {
					$("#qos_rule_enabled" + i).attr("checked","checked");
				}
				$("#name" + i).val(qos_rule_obj.name[i]);
				$("#priority" + i).val(qos_rule_obj.priority[i]);
				set_protocol(i, qos_rule_obj.protocolIdx[i], $("#protocol_select" + i)[0]);
				$("#local_start_ip" + i).val(qos_rule_obj.localIPStart[i]);
				$("#local_end_ip" + i).val(qos_rule_obj.localIPEnd[i]);
				$("#local_start_port" + i).val(qos_rule_obj.localPortStart[i]);
				$("#local_end_port" + i).val(qos_rule_obj.localPortEnd[i]);
				$("#remote_start_ip" + i).val(qos_rule_obj.remoteIPStart[i]);
				$("#remote_end_ip" + i).val(qos_rule_obj.remoteIPEnd[i]);
				$("#remote_start_port" + i).val(qos_rule_obj.remotePortStart[i]);
				$("#remote_end_port" + i).val(qos_rule_obj.remotePortEnd[i]);

				if ($("#qos_engine_enabled")[0].checked) {
					detect_protocol_change_port($("#protocol_select"+i)[0].selectedIndex,i);
				}
			}
		}
	}

	function set_protocol(i, which_value, obj)
	{
		set_selectIndex(which_value, obj);
		$("#protocol" + i).attr("disabled",true);

		$("#protocol"+i).val(obj.options[which_value].value);
		obj.selectedIndex = which_value;

		if(which_value == "5"){
			$("#protocol" + i).attr("disabled",false);
			$("#protocol_select" + i)[0].selectedIndex = 5;
			$("#protocol"+i).val(qos_rule_obj.protocalNum[i]);
		}
	}

	function qos_max_trans_rate_selector(value)
	{
		$("#qos_uplink").val(value);		
		// Always go back to "Select"
		$("#qos_max_trans_rate_select").val(0);
	}

    function qos_traffic_shaping_click(obj_chk)
    {
        var is_disabled = !obj_chk;
		$("#qos_auto_uplink").attr("disabled",is_disabled);
		$("#qos_uplink").attr("disabled",is_disabled);
		$("#qos_max_trans_rate_select").attr("disabled",is_disabled);
		$("#qos_connection_type_select").attr("disabled",is_disabled);
		if (is_disabled == false) {
			qos_auto_uplink_click($("#qos_auto_uplink")[0].checked);
		}
		$("#qos_engine_enabled").attr("disabled",is_disabled);
		qos_enable_click($("#qos_engine_enabled")[0].checked);
		
		for (var i = 0; i < rule_max_num; i++)
		{
			if ($("#qos_engine_enabled")[0].checked && is_disabled == false)
				detect_protocol_change_port($("#protocol_select"+i)[0].selectedIndex,i);
		}
	}

	function qos_auto_uplink_click(obj_chk)
	{
		var is_disabled = (obj_chk)?"disabled":"";
		$("#qos_uplink").attr("disabled",is_disabled);
		$("#qos_max_trans_rate_select").attr("disabled",is_disabled);
	}

	function qos_enable_click(obj_chk)
	{
		var is_disabled = ((obj_chk && $("#qos_traffic_shaping")[0].checked))?"":"disabled";

		$("#qos_auto_classification").attr("disabled",is_disabled);
		$("#qos_dyn_frag").attr("disabled",is_disabled);

		for (var i=0;i<rule_max_num;i++)
		{
			$("#qos_rule_enabled"+i).attr("disabled",is_disabled);
			$("#name"+i).attr("disabled",is_disabled);
			$("#priority"+i).attr("disabled",is_disabled);
			$("#protocol"+i).attr("disabled",is_disabled);
			$("#protocol_select"+i).attr("disabled",is_disabled);
			$("#local_start_ip"+i).attr("disabled",is_disabled);
			$("#local_end_ip"+i).attr("disabled",is_disabled);
			$("#local_start_port"+i).attr("disabled",is_disabled);
			$("#local_end_port"+i).attr("disabled",is_disabled);
			$("#remote_start_ip"+i).attr("disabled",is_disabled);
			$("#remote_end_ip"+i).attr("disabled",is_disabled);
			$("#remote_start_port"+i).attr("disabled",is_disabled);
			$("#remote_end_port"+i).attr("disabled",is_disabled);
			if (is_disabled == false)
				detect_protocol_change_port($("#protocol_select"+i)[0].selectedIndex,i);
		}
	}

	function protocol_change(i)
	{
		var obj_name = $("#protocol_select"+i)[0];
		if (obj_name.selectedIndex < 5) { //Any, TCP, UDP, Both, ICMP, Other
			$("#protocol"+i).attr("disabled",true);
			$("#protocol"+i).val(obj_name.options[obj_name.selectedIndex].value);
		}
		else if ($("#protocol_select"+i)[0].selectedIndex == 5) { // Other
			$("#protocol"+i).attr("disabled",false);
			$("#protocol"+i).val("");
		}
	}

	function detect_protocol_change_port(proto,i)
	{
		if ((proto == 0)||(proto == 4)||(proto == 5)) {
			$("#local_start_port"+i).attr("disabled",true);
			$("#local_end_port"+i).attr("disabled",true);
			$("#remote_start_port"+i).attr("disabled",true);
			$("#remote_end_port"+i).attr("disabled",true);
		}
		else {
			$("#local_start_port"+i).attr("disabled",false);
			$("#local_end_port"+i).attr("disabled",false);
			$("#remote_start_port"+i).attr("disabled",false);
			$("#remote_end_port"+i).attr("disabled",false);
		}
	}

	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		if (gigabit == 1)
		{
			if((get_checked_value($("#qos_traffic_shaping")[0]) == "1") && (hw_nat_enable == "1"))
			{
				if(!confirm(get_words("alert_hw_nat_2")))
					return false;
			}
		}

		$("#traffic_shaping").val(get_checked_value($("#qos_traffic_shaping")[0]));
		$("#auto_uplink").val(get_checked_value($("#qos_auto_uplink")[0]));
		$("#qos_enable").val(get_checked_value($("#qos_engine_enabled")[0]));
		$("#auto_classification").val(get_checked_value($("#qos_auto_classification")[0]));
		$("#qos_dyn_fragmentation").val(get_checked_value($("#qos_dyn_frag")));
		$("#qos_connection_type").val($("#qos_connection_type_select").val());
		
        // check qos_uplink
		if ($("#qos_traffic_shaping")[0].checked) {
			var qos_uplink = parseInt($("#qos_uplink").val());
			//20120509 silvia modify max val and is not a int / 05-31 max to 100M
			if (!(check_integer($("#qos_uplink").val(), 8, 102400))) {
				alert(get_words('at_alert_1_2'));
				return false;
			}
		}

		//check rule
		var count = 0;
		for (var i = 0; i < rule_max_num; i++)
		{
			var local_start_ip = $("#local_start_ip" + i).val();
			var local_end_ip = $("#local_end_ip" + i).val();
			var remote_start_ip = $("#remote_start_ip" + i).val();
			var remote_end_ip = $("#remote_end_ip" + i).val();
			var local_start_port = parseInt($("#local_start_port" + i).val());
			var local_end_port = parseInt($("#local_end_port" + i).val());
			var remote_start_port = parseInt($("#remote_start_port" + i).val());
			var remote_end_port = parseInt($("#remote_end_port" + i).val());
			var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
			var remote_ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_remoteipaddr'));
			var temp_local_start_ip_obj = new addr_obj(local_start_ip.split("."), ip_addr_msg, false, false);
			var temp_local_end_ip_obj = new addr_obj(local_end_ip.split("."), ip_addr_msg, false, false);
			var temp_remote_start_ip_obj = new addr_obj(remote_start_ip.split("."), remote_ip_addr_msg, false, false);
			var temp_remote_end_ip_obj = new addr_obj(remote_end_ip.split("."), remote_ip_addr_msg, false, false);
			var temp_qos;
			var check_name = "";

			if (i > 9)
				$("#qos_rule_" + i).val("");
			else
				$("#qos_rule_0" + i).val("");

			//check protocol
			if ($("#protocol_select" + i)[0].selectedIndex == 5)
			{
				temp_obj = $("#protocol" + i)[0];
				var protocol_msg = replace_msg(check_num_msg, get_words('_vs_proto'), 0, 255);
				obj = new varible_obj(temp_obj.value, protocol_msg, 0, 255, false);
				if (!check_varible(obj))
					return false;
			}

			if ($("#name" + i).val() != "")
			{
				// check name
				check_name = $("#name" + i).val();
				if(Find_word(check_name,"'") || Find_word(check_name,'"') || Find_word(check_name,"/"))
				{
					alert(addstr(LangMap.which_lang['TEXT002'], i));
					$("#name"+i)[0].focus();
					$("#name"+i)[0].select();
					return false;
				}

				//check Priority
				temp_obj =  $("#priority" + i)[0];
				var priority_msg = replace_msg(check_num_msg, get_words('_priority'), 1, 255);
				pro_obj = new varible_obj(temp_obj.value, priority_msg, 1, 255, false);
				//check Priority is decimal or not? GraceYang-20090407
				var priority_value = $("#priority" + i).val();
				var str = new String(parseFloat(priority_value));

				if (!check_varible(pro_obj)) {
					return false;
				}

				//check ip
				if (local_start_ip != "0.0.0.0" && !check_address(temp_local_start_ip_obj))
					return false;

				if (local_end_ip != "255.255.255.255" && !check_address(temp_local_end_ip_obj))
					return false;

				if (remote_start_ip != "0.0.0.0" && !check_address(temp_remote_start_ip_obj))
					return false;

				if (remote_end_ip != "255.255.255.255" && !check_address(temp_remote_end_ip_obj))
					return false;

				//check port
				if (($("#protocol_select"+i)[0].selectedIndex ==1) || ($("#protocol_select"+i)[0].selectedIndex ==2) || ($("#protocol_select"+i)[0].selectedIndex ==3))
				{
					if (!is_number(local_start_port) || local_start_port < 0 || local_start_port > 65535) {
						alert(get_words('YM59'));
						$("#local_start_port"+i)[0].focus();
						$("#local_start_port"+i)[0].select();
						return false;
					}
					else if (!is_number(local_end_port) || local_end_port < 0 || local_end_port > 65535) {
						alert(get_words('YM60'));
						$("#local_end_port"+i)[0].focus();
						$("#local_end_port"+i)[0].select();
						return false;
					}
					else if (local_start_port > local_end_port){
						var alertStr = addstr1(get_words('GW_QOS_RULES_LOCAL_PORT'), $("#name" + i).val(), local_start_port, local_end_port);
						alert(alertStr);						
						$("#local_start_port"+i)[0].focus();
						$("#local_start_port"+i)[0].select();
						return false;
					}

					if (!is_number(remote_start_port) || remote_start_port < 0 || remote_start_port > 65535) {
						alert(get_words('YM61'));
						$("#remote_start_port"+i)[0].focus();
						$("#remote_start_port"+i)[0].select();
						return false;
					}
					else if (!is_number(remote_end_port) || remote_end_port < 0 || remote_end_port > 65535) {
						alert(get_words('YM62'));
						$("#remote_end_port"+i)[0].focus();
						$("#remote_end_port"+i)[0].select();
						return false;
					}
					else if (remote_start_port > remote_end_port) {
						var alertStr = addstr1(get_words('GW_QOS_RULES_REMOTE_PORT'), $("#name" + i).val(), remote_start_port, remote_end_port);
						alert(alertStr);                        
						$("#remote_start_port"+i)[0].focus();
						$("#remote_start_port"+i)[0].select();
						return false;
					}
				}
			} else {
				if ($("#qos_rule_enabled" + i)[0].checked == true) {
                    alert(addstr1(get_words('YM49'), i)); //   alert(get_words('YM49')+" "+i+".")
					return false;
				}
			}

			if (count > 9)
				temp_qos = $("#qos_rule_" + count)[0];
			else
				temp_qos = $("#qos_rule_0" + count)[0];
				
            //enable/name/priority/uplink/downlink/protocol/local_start_ip/local_end_ip/local_start_port/local_end_port/remote_start_ip/remote_end_ip/remote_start_port/remote_end_port
			temp_qos.value = get_checked_value($("#qos_rule_enabled" + i)[0]) + "/" + $("#name" + i).val() + "/" + $("#priority" + i).val()   + "/"
							+ "0/0/"
							+ $("#protocol" + i).val() + "/"
							+ $("#local_start_ip" + i).val() + "/" + $("#local_end_ip" + i).val() + "/" + $("#local_start_port" + i).val() + "/"
							+ $("#local_end_port" + i).val() + "/" + $("#remote_start_ip" + i).val() + "/"
							+ $("#remote_end_ip" + i).val() + "/" + $("#remote_start_port" + i).val() + "/" + $("#remote_end_port" + i).val();
            count++;
        }

		//check same as rule
		for (var i = 0; i < rule_max_num; i++)
		{
			var local_start_ip = $("#local_start_ip" + i).val();
			var local_end_ip = $("#local_end_ip" + i).val();
			var remote_start_ip = $("#remote_start_ip" + i).val();
			var remote_end_ip = $("#remote_end_ip" + i).val();
			var local_start_port = parseInt($("#local_start_port" + i).val());
			var local_end_port = parseInt($("#local_end_port" + i).val());
			var remote_start_port = parseInt($("#remote_start_port" + i).val());
			var remote_end_port = parseInt($("#remote_end_port" + i).val());
			var rule_protocol = $("#protocol_select"+i)[0].selectedIndex;
			var check_name = $("#name" + i).val();

			for (var j = 0; j < rule_max_num; j++)
			{
				if (j != i)
				{
					var local_start_ip_chk = $("#local_start_ip" + j).val();
					var local_end_ip_chk = $("#local_end_ip" + j).val();
					var remote_start_ip_chk = $("#remote_start_ip" + j).val();
					var remote_end_ip_chk = $("#remote_end_ip" + j).val();
					var local_start_port_chk = parseInt($("#local_start_port" + j).val());
					var local_end_port_chk = parseInt($("#local_end_port" + j).val());
					var remote_start_port_chk = parseInt($("#remote_start_port" + j).val());
					var remote_end_port_chk = parseInt($("#remote_end_port" + j).val());
					var rule_protocol_chk = $("#protocol_select"+j)[0].selectedIndex;
					var check_name_chk = $("#name" + j).val();

					if ((check_name == check_name_chk) && (check_name) && (check_name_chk)){
						alert(addstr1(get_words('GW_INET_ACL_NAME_DUPLICATE_INVALID'), $('#name' + j).val()));
						return false;
					}

                    //check enable
					if ($("#qos_rule_enabled" + i)[0].checked != true)
						continue;

                    //check enable
                    if (get_by_id("qos_rule_enabled" + j).checked != true) {
                        continue;
                    }

                    //check protocol
					if (rule_protocol_chk != rule_protocol)
						continue;

                    //check ip
					if (local_start_ip_chk != local_start_ip)
						continue;
					if (local_end_ip_chk != local_end_ip)
						continue;
					if (remote_start_ip_chk != remote_start_ip)
						continue;
					if (remote_end_ip_chk != remote_end_ip)
						continue;

					//check port
					if ((rule_protocol ==1) || (rule_protocol ==2) || (rule_protocol ==3)) {
						if (local_start_port_chk != local_start_port) {
							continue;
						}
                        else if (local_end_port_chk != local_end_port) {
                            continue;
                        }
						if (remote_start_port_chk != remote_start_port) {
							continue;
						}
                        else if (remote_end_port_chk != remote_end_port) {
							continue;
						}
						// same as rule
						alert(get_words('TEXT008a')+" "+i+" "+get_words('TEXT008b')+" "+j+".");//TEXT008
						return false;
					}
				}
			}
		}

		if (submit_button_flag == 0) {
			submit_button_flag = 1;
			sendAjax();
			return true;
		}
		return false;
	}

	function sendAjax()
	{
		if (gigabit == 1)
		{
			if((get_checked_value($("#qos_traffic_shaping")[0]) == "1"))
				hw_nat_enable = "0";
		}

		var qos_enabled = get_checked_value($("#qos_engine_enabled")[0]);

		var sendObj = new ccpObject();
		var str="ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=adv_qos.asp" +
			"&wanTrafficShp_EnableTrafficShaping_1.1.1.0="+get_checked_value($("#qos_traffic_shaping")[0])+
			"&wanTrafficShp_AutoUplinkSpeed_1.1.1.0="+($("#qos_auto_uplink").attr('checked')? '1':'0')+
			"&wanTrafficShp_ManualUplinkSpeed_1.1.1.0="+$("#qos_uplink").val()+
			"&wanTrafficShp_EnableQoSEngine_1.1.1.0="+qos_enabled+
			"&wanTrafficShp_AutoClassification_1.1.1.0="+qos_enabled+
			"&wanTrafficShp_DynamicFragmentation_1.1.1.0="+qos_enabled;

		if (gigabit == 1)
		{
			 str += "&wanDev_HardwareNatEnable_1.1.0.0="+hw_nat_enable;
		}

		for(var i=0; i<rule_max_num; i++)
		{
			var inst = '1.1.1.'+(i+1);
			var ruleEn = get_checked_value($("#qos_rule_enabled"+ i)[0]);
			var ruleNm = $("#name"+ i).val();
			if((ruleEn == "0") && (ruleNm == ""))
			{
				str += "&trafficRule_Enable_"+inst+"=0"+
					"&trafficRule_Name_"+inst+"="+
					"&trafficRule_Priority_"+inst+"=1"+
					"&trafficRule_LocalIPAddrStart_"+inst+"=0.0.0.0"+
					"&trafficRule_LocalIPAddrEnd_"+inst+"=255.255.255.255"+
					"&trafficRule_RemoteIPAddrStart_"+inst+"=0.0.0.0"+
					"&trafficRule_RemoteIPAddrEnd_"+inst+"=255.255.255.255"+
					"&trafficRule_LocalPortStart_"+inst+"=0"+
					"&trafficRule_LocalPortEnd_"+inst+"=65535"+
					"&trafficRule_RemotePortStart_"+inst+"=0"+
					"&trafficRule_RemotePortEnd_"+inst+"=65535"+
					"&trafficRule_Protocol_"+inst+"=1"+
					"&trafficRule_ProtoNum_"+inst+"=6";
			}
			else
			{
				str += "&trafficRule_Enable_"+inst+"="+get_checked_value($("#qos_rule_enabled"+ i)[0])+
					"&trafficRule_Name_"+inst+"="+$("#name"+ i).val()+
					"&trafficRule_Priority_"+inst+"="+$("#priority"+ i).val()+
					"&trafficRule_LocalIPAddrStart_"+inst+"="+$("#local_start_ip"+ i).val()+
					"&trafficRule_LocalIPAddrEnd_"+inst+"="+$("#local_end_ip"+ i).val()+
					"&trafficRule_RemoteIPAddrStart_"+inst+"="+$("#remote_start_ip"+ i).val()+
					"&trafficRule_RemoteIPAddrEnd_"+inst+"="+$("#remote_end_ip"+ i).val()+
					"&trafficRule_LocalPortStart_"+inst+"="+$("#local_start_port"+ i).val()+
					"&trafficRule_LocalPortEnd_"+inst+"="+$("#local_end_port"+ i).val()+
					"&trafficRule_RemotePortStart_"+inst+"="+$("#remote_start_port"+ i).val()+
					"&trafficRule_RemotePortEnd_"+inst+"="+$("#remote_end_port"+ i).val()+
					"&trafficRule_Protocol_"+inst+"="+$("#protocol_select"+ i)[0].selectedIndex +
					"&trafficRule_ProtoNum_"+inst+"="+$("#protocol"+ i).val();
			}
		}
		param.url="get_set.ccp";
		param.arg=str;
		sendObj.get_config_obj(param);
	}
	
	function query_wan_speed()
	{
		var queryObj = new ccpObject();
		var paramWanSp = {
			url: "qos.ccp",
			arg: "ccp_act=getWanSpeed"
		};
		
		queryObj.get_config_obj(paramWanSp);

		if(queryObj.config_val("WanSpeedTestState") == "3")	//probe finish
		{
			var sp_value = queryObj.config_val("WanSpeedTestResult");
			if(sp_value == "0")
				$("#wan_speed").html(get_words("at_NEst"));
			else				
				$("#wan_speed").html(ReplaceAll(get_words('RATE_ESTIMATOR_RATE_IS'), "%d",parseInt(sp_value)));
			
			return;
		}
		else if(queryObj.config_val("WanSpeedTestState") == "0")
		{
			$("#wan_speed").html(get_words("at_NEst"));
			return;
		}
		else
		{
			$("#wan_speed").html(get_words("at_NEst"));
			setTimeout("query_wan_speed()",3000);
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
		<script>ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b4');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="reboot.asp">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_qos.asp">
			<input type="hidden" id="reboot_type" name="reboot_type" value="qos">

			<input type="hidden" id="qos_rule_00" name="qos_rule_00" value=''>
			<input type="hidden" id="qos_rule_01" name="qos_rule_01" value=''>
			<input type="hidden" id="qos_rule_02" name="qos_rule_02" value=''>
			<input type="hidden" id="qos_rule_03" name="qos_rule_03" value=''>
			<input type="hidden" id="qos_rule_04" name="qos_rule_04" value=''>
			<input type="hidden" id="qos_rule_05" name="qos_rule_05" value=''>
			<input type="hidden" id="qos_rule_06" name="qos_rule_06" value=''>
			<input type="hidden" id="qos_rule_07" name="qos_rule_07" value=''>
			<input type="hidden" id="qos_rule_08" name="qos_rule_08" value=''>
			<input type="hidden" id="qos_rule_09" name="qos_rule_09" value=''>
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('YM48')</script></h1>
				<script>show_words('at_intro')</script><script>show_words('at_intro_2')</script><br><br>
				<input name="button" id="button" type="button" class="button_submit" value="" onClick="send_request()">
				<input name="button1" id="button1" type="button" class="button_submit" value="" onclick="page_cancel('form1', 'adv_qos.asp');">
				<script>$("#button").val(get_words('_savesettings'));</script>
				<script>$("#button1").val(get_words('_dontsavesettings'));</script>
			</div>
			<div class=box>
				<h2><script>show_words('at_title_SESet')</script></h2>
				<table width=525>
				<tr>
					<td width="185" align=right class="duple"><script>show_words('at_ESE')</script> :</td>
					<td width="333">&nbsp;
						<input type="checkbox" id="qos_traffic_shaping" name="qos_traffic_shaping" value="1" onClick="qos_traffic_shaping_click(this.checked);">
						<input type="hidden" id="traffic_shaping" name="traffic_shaping" value=''>
					</td>
				</tr>

				<tr>
					<td align=right class="duple"><script>show_words('at_AUS')</script> :</td>
					<td>&nbsp;
						<input type="checkbox" id="qos_auto_uplink" name="qos_auto_uplink" value="1" onClick="qos_auto_uplink_click(this.checked);">
						<input type="hidden" id="auto_uplink" name="auto_uplink" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('at_MUS')</script> :</td>
                    <td>&nbsp;
						<span id="wan_speed"></span>
						<!--<script>document.write(qos_obj.measuredUplinkSpeed);</script>-->
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('at_UpSp')</script> :</td>
					<td>&nbsp;
						<input type="text" id="qos_uplink" name="qos_uplink" maxlength="7" size="7"  value=''>&nbsp;
						<script>show_words('at_kbps')</script>
						<span>&nbsp;&lt;&lt;&nbsp;</span>
						<select id="qos_max_trans_rate_select" name="qos_max_trans_rate_select" onchange="qos_max_trans_rate_selector(this.value);">
							<option value="0"><script>show_words('at_STR')</script></option>
							<option value="128">128 <script>show_words('at_kbps')</script></option>
							<option value="256">256 <script>show_words('at_kbps')</script></option>
							<option value="384">384 <script>show_words('at_kbps')</script></option>
							<option value="512">512 <script>show_words('at_kbps')</script></option>
							<option value="1024">1 <script>show_words('at_mbps')</script></option>
							<option value="2048">2 <script>show_words('at_mbps')</script></option>
							<option value="3072">3 <script>show_words('at_mbps')</script></option>
							<option value="5120">5 <script>show_words('at_mbps')</script></option>
							<option value="10240">10 <script>show_words('at_mbps')</script></option>
						</select>
					</td>
				</tr>
				<tr style="display:none">
					<td align=right class="duple">Connection Type :</td>
					<td>&nbsp;
						<input type="hidden" id="qos_connection_type" name="qos_connection_type" value=''>
						<select id="qos_connection_type_select" name="qos_connection_type_select">
							<option value="2">Auto-detect</option>
							<option value="1">xDSL Or Other Frame Relay Network</option>
							<option value="0">Cable Or Other Broadband Network</option>
						</select>
					</td>
				</tr>
				<tr style="display:none">
					<td align=right class="duple">Detected Network type :</td>
				</tr>
				</table>
			</div>

			<div class=box id="qos_engine" style="display:none">
				<h2><script>show_words('at_title_SESet')</script></h2>
				<table width=525>
				<tr>
					<td width="185" align=right class="duple"><script>show_words('at_ESE')</script> :</td>
					<td width="333">&nbsp;
						<input type="checkbox" id="qos_engine_enabled" name="qos_engine_enabled" value="1" onClick="qos_enable_click(this.checked)">
						<input type="hidden" id="qos_enable" name="qos_enable" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('at_AC')</script> :</td>
					<td>&nbsp;
						<input type="checkbox" id="qos_auto_classification" name="qos_auto_classification" value="1">
						<input type="hidden" id="auto_classification" name="auto_classification" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('at_DF')</script> :</td>
					<td>&nbsp;
						<input type="checkbox" id="qos_dyn_frag" name="qos_dyn_frag" value="1">
						<input type="hidden" id="qos_dyn_fragmentation" name="qos_dyn_fragmentation" value=''>
					</td>
				</tr>
				</table>
			</div>

			<div class=box>
				<h2>10 -- <script>show_words('at_title_SERules')</script></h2>
				<table bordercolor=#ffffff cellspacing=1 cellpadding=2 width=525 bgcolor=#dfdfdf border=1>
					<script>
					for(var i=0; i <rule_max_num ; i++){
					document.write("<tr>");
					document.write("<td rowspan=3><input type=checkbox id=\"qos_rule_enabled"+ i + "\" name=\"qos_rule_enabled"+ i + "\" value=\"1\"></td>");
					document.write('<td>'+get_words('_name')+'<br><input id=name' + i + ' name=name' + i +' type=text size=16 maxlength=31></td>');
					document.write('<td> '+get_words('_priority')+'<br><input id=priority' + i + ' name=priority' + i +' type=text size=16 maxlength=31>(1..255)</td>');
					document.write('<td>'+get_words('_protocol')+'<br>');
					document.write("<input id=\"protocol"+ i + "\" name=\"protocol"+ i + "\" maxlength=3 size=2 type=text>");
					document.write("  <<  ");
					document.write("<select id=\"protocol_select"+ i + "\" name=\"protocol_select"+ i + "\" onChange=\"protocol_change(" + i + ");detect_protocol_change_port(this.selectedIndex,'" + i + "');\">");
					document.write('<option value=256>'+get_words('at_Any')+'</option>');
					document.write('<option value=6>'+get_words('_TCP')+'</option>');
					document.write('<option value=17>'+get_words('_UDP')+'</option>');
					document.write('<option value=257>'+get_words('_both')+'</option>');
					document.write('<option value=1>'+get_words('_ICMP')+'</option>');
					document.write('<option value=-1>'+get_words('_other')+'</option>');
					document.write("</select></td>");
					document.write("</tr>");
					document.write("<tr>");
					document.write('<td colspan=2 width=60%>'+get_words('at_LoIPR')+'<br>');
					document.write('<input id=local_start_ip'+ i + ' name=local_start_ip'+ i + ' type=text size=14 maxlength=15>'+get_words('_to')+'<input id=local_end_ip'+ i + ' name=local_end_ip'+ i + ' type=text size=14 maxlength=15>');
					document.write("</td>");
					document.write('<td>'+get_words('at_LoPortR')+'<br>');
					document.write('<input id=local_start_port'+ i + ' name=local_start_port'+ i + ' type=text size=4 maxlength=5>'+get_words('_to')+'<input id=local_end_port'+ i + ' name=local_end_port'+ i + ' type=text size=4 maxlength=5>');
					document.write("</td>");
					document.write("</tr>");
					document.write("<tr>");
					document.write('<td colspan=2 width=60%>'+get_words('at_ReIPR')+'<br>');
					document.write('<input id=remote_start_ip'+ i + ' name=remote_start_ip'+ i + ' type=text size=14 maxlength=15>'+get_words('_to')+'<input id=remote_end_ip'+ i + ' name=remote_end_ip'+ i + ' type=text size=14 maxlength=15>');
					document.write("</td>");
					document.write('<td>'+get_words('at_RePortR')+'<br>');
					document.write('<input id=remote_start_port'+ i + ' name=remote_start_port'+ i + ' type=text size=4 maxlength=5 >'+get_words('_to')+'<input id=remote_end_port'+ i + ' name=remote_end_port'+ i + ' type=text size=4 maxlength=5>');
					document.write("</td>");
					document.write("</tr>");
					}
					</script>
				</table>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>
		</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>
				var str = get_words('hhase_intro');
				var tmp_str = str.substring(str.search("<strong>")+8,str.search("</strong>"));
				document.write(str.replace(tmp_str,get_words('at_AUS')));
			</script></p>
			<p><a href="support_adv.asp#Traffic_Shaping"><script>show_words('_more')</script>&hellip;</a></p>
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
	query_wan_speed();
</script>
</html>
