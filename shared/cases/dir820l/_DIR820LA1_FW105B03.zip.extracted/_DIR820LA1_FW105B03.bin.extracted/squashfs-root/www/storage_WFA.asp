<html>
<head>
<title></title>
<style>
#color_set{	background-color:#ffffff; width:98%}
</style>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css" />
<link rel="stylesheet" type="text/css" href="js/jquery.treeview.css" />
<link rel="stylesheet" type="text/css" href="js/jquery-ui.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="js/jquery.treeview.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
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
	var sendSubmit  = false;
	
	//Tin Add
	
	//for folder browse
	var folderObj = new ccpObject();
	var folder_param = {
		url: 'web_access.ccp',
		arg: 'ccp_act=get&file_type=3&get_path=/'
	};
	folderObj.get_config_obj(folder_param);

	var cur_path = '/';
	var dev_qty = folderObj.config_val("usb_quantity");
	var folder_path_list = folderObj.config_str_multi("dir_path");
	var file_path_list = folderObj.config_str_multi("file_path");
	var folder_list = folderObj.config_str_multi("dir");
	var file_list = folderObj.config_str_multi("file");
	var folders;

	var diskObj = new ccpObject();
	var param1 = {
		url: "web_access.ccp",
		arg: ""
	};

	param1.arg = "ccp_act=get_disk_info&get&file_type=1&get_path=/";
	diskObj.get_config_obj(param1);

	var disk_info = diskObj.config_str_multi("disk_info");
	

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=24";
	param.arg +="&oid_1=IGD_&inst_1=1000";	
	param.arg +="&oid_2=IGD_Storage_&inst_2=1100";
	param.arg +="&oid_3=IGD_Storage_Admin_&inst_3=1110";
	param.arg +="&oid_4=IGD_Storage_Admin_Rule_i_&inst_4=1110";
	param.arg +="&oid_5=IGD_Storage_Guest_&inst_5=1110";
	param.arg +="&oid_6=IGD_Storage_Guest_Rule_i_&inst_6=1110";
	param.arg +="&oid_7=IGD_Storage_User_i_&inst_7=1100";

	for (var i=1;i<=9;i++)
		param.arg +="&oid_" + (i+7) +"=IGD_Storage_User_i_Rule_i_&inst_"+ (i+7)+"=11"+i+"0";

	param.arg +="&oid_17=IGD_Email_&inst_17=1100";
	param.arg +="&oid_18=IGD_WANDevice_i_DynamicDNS_&inst_18=1110";
	param.arg +="&oid_19=IGD_WANDevice_i_DynamicDNS_DynamicDNSStatus_&inst_19=1111";
	param.arg +="&oid_20=IGD_WANDevice_i_VirServRule_i_&inst_20=1100";
	param.arg +="&oid_21=IGD_WANDevice_i_PortFwd_i_&inst_21=1100";
	param.arg +="&oid_22=IGD_WANDevice_i_PortTriggerRule_i_&inst_22=1100";
	param.arg +="&oid_23=IGD_AdministratorSettings_&inst_23=1100";
	param.arg +="&oid_24=IGD_WANDevice_i_WANStatus_&inst_24=1110";

	mainObj.get_config_obj(param);

	var waCfg = {
		'enable': 		mainObj.config_val("igdStorage_Enable_"),
		'raHttpEn':		mainObj.config_val("igdStorage_Http_Remote_Access_Enable_"),
		'raHttpPort':	mainObj.config_val('igdStorage_Http_Remote_Access_Port_'),
		//'raHttpsEn':	mainObj.config_val("igdStorage_Https_Remote_Access_Enable_"),
		'raHttpsPort':	mainObj.config_val('igdStorage_Https_Remote_Access_Port_'),
		'linkHttp':		mainObj.config_val('igdStorage_Http_Storage_Link_')
	};

	var dynDns = {
		'enable':		mainObj.config_val("ddnsCfg_DDNSEnable_"),
		'hostName':		mainObj.config_val("ddnsCfg_HostName_"),
		'status':		mainObj.config_val("ddnsStatus_Status_")
	};

	var objEmail = 
	{
		'enable':		mainObj.config_val('emailCfg_Enable_'),
		'emailFrom':	mainObj.config_val('emailCfg_EmailFrom_'),
		'emailTo':		mainObj.config_val('emailCfg_EmailTo_'),
		'subject':		mainObj.config_val('emailCfg_Subject_'),
		'smtpAddr':		mainObj.config_val('emailCfg_SMTPServerAddress_'),
		'smtpPort':		mainObj.config_val('emailCfg_SMTPServerPort_'),
		'authEnable':	mainObj.config_val('emailCfg_AuthenticationEnable_'),
		'username':		mainObj.config_val('emailCfg_AccountName_'),
		'password':		mainObj.config_val('emailCfg_AccountPassword_'),
		'logOnFullEn':	mainObj.config_val('emailCfg_LogOnFullEnable_'),
		'logOnSchEn':	mainObj.config_val('emailCfg_LogOnScheduleEnable_'),
		'logSchIdx':	mainObj.config_val('emailCfg_LogScheduleIndex_'),
		'logDetail':	mainObj.config_val('emailCfg_LogDetail_')
	};

	var guest_enable = mainObj.config_val('igdStorage_GuestEnable_'); 
	
	var adm_rule_inst = mainObj.config_inst_multi("IGD_Storage_Admin_Rule_i_");	
	var guest_rule_inst = mainObj.config_inst_multi("IGD_Storage_Guest_Rule_i_");
	var user_inst = mainObj.config_inst_multi("IGD_Storage_User_i_");
	var user_rule_inst = mainObj.config_inst_multi("IGD_Storage_User_i_Rule_i_");

	var adm_name = mainObj.config_val("igdStorageAdmin_Username_");
	var adm_passwd = mainObj.config_val("igdStorageAdmin_Password_");

	var ary_user_name = mainObj.config_str_multi("igdStorageUser_Username_");
	var ary_user_passwd = mainObj.config_str_multi("igdStorageUser_Password_");

	var guest_name = mainObj.config_val("igdStorageGuest_Username_");
	var guest_passwd = mainObj.config_val("igdStorageGuest_Password_");

	var adm_rule_dev = mainObj.config_str_multi("igdStorageAdminRule_Device_");
	var adm_rule_path = mainObj.config_str_multi("igdStorageAdminRule_AccessPath_");
	var adm_rule_right = mainObj.config_str_multi("igdStorageAdminRule_Permission_");

	var guest_rule_dev = mainObj.config_str_multi("igdStorageGuestRule_Device_");
	var guest_rule_path = mainObj.config_str_multi("igdStorageGuestRule_AccessPath_");
	var guest_rule_right = mainObj.config_str_multi("igdStorageGuestRule_Permission_");

	var user_rule_dev = mainObj.config_str_multi("igdStorageUserRule_Device_");
	var user_rule_path = mainObj.config_str_multi("igdStorageUserRule_AccessPath_");
	var user_rule_right = mainObj.config_str_multi("igdStorageUserRule_Permission_");

	var http_stolink = mainObj.config_val("igdStorage_Http_Storage_Link");
	var https_stolink = mainObj.config_val("igdStorage_Https_Storage_Link");

	var rmgr_en = mainObj.config_val("adminCfg_RemoteManagementEnable_");
	var rmgr_port = mainObj.config_val('adminCfg_RemoteAdminHttpPort_');
	var rmgrs_en = mainObj.config_val("adminCfg_RemoteAdminHttpsEnable_");
	var rmgrs_port = mainObj.config_val("adminCfg_RemoteAdminHttpsPort_");

	var array_vs_inst = mainObj.config_inst_multi("IGD_WANDevice_i_VirServRule_i_");
	var array_vs_enable	= mainObj.config_str_multi("vsRule_Enable_");
	var array_vs_enable		= mainObj.config_str_multi("vsRule_Enable_");
	var array_vs_proto	 	= mainObj.config_str_multi("vsRule_Protocol_");
	var array_vs_ports 		= mainObj.config_str_multi("vsRule_PublicPort_");
	var array_pf_enable		= mainObj.config_str_multi("pfRule_Enable_");
	var array_pf_ports_udp	= mainObj.config_str_multi("pfRule_UDPOpenPorts_");
	var array_pf_ports_tcp	= mainObj.config_str_multi("pfRule_TCPOpenPorts_");

	var array_pf_name = mainObj.config_str_multi("pfRule_ApplicationName_");
	var array_pf_port = mainObj.config_str_multi("pfRule_TCPOpenPorts_");
	var array_pf_inst = mainObj.config_inst_multi("IGD_WANDevice_i_PortFwd_i_");

	var array_pt_enable		= mainObj.config_str_multi("ptRule_Enable_");
	var array_pt_name = mainObj.config_str_multi("ptRule_ApplicationName_");
	var array_pt_ports = mainObj.config_str_multi("ptRule_FirewallPorts_");
	var array_pt_proto = mainObj.config_str_multi("ptRule_FirewallProtocol_");
	var array_pt_inst = mainObj.config_inst_multi("IGD_WANDevice_i_PortTriggerRule_i_");

	var wanIp = mainObj.config_val('igdWanStatus_IPAddress_');

	var on_list = "";
	var DataArray = new Array();    
	var curr_user_cnt=0;
	var usrPasswd = new Array();
	var usrName = new Array();

	function calculate(size)
	{
		var tmp, total, count=0, unit;
		tmp = size/1024; //first run
		while(tmp > 1024)
		{
			tmp = tmp.toFixed(2);
			count++;
			tmp = tmp/1024;
		}
		
		switch(count)
		{
			case 0:
				tmp = tmp.toFixed(2);
				unit = "MB";
				break;
			case 1:
				tmp = tmp.toFixed(2);
				unit = "GB";
				break;
			case 2:
				tmp = tmp.toFixed(2);
				unit = "TB";
				break;

		}
		total = tmp+unit;
		return total;
	}
	
	function sto_name_trim(str, init)
	{
		var len = parseInt(str.length);
		var init_addr = parseInt(init);
		str = str.substring(init_addr, len);
		return str.toUpperCase();
	}

	function disable_storage()
	{
		var storage_enable = $("#wfa_enable").attr("checked")?1 : 0;
//		var http_enable = $("#http_remote_access").attr("checked")?1 : 0;
		var disable = 0;
		if (storage_enable != 1)
			disable = 1;

		//$('#http_remote_access').attr('disabled',disable);
		
		//Tin 20120514 modify to follow shareport web access v1.03 spec 
		/*
		if(disable == "0")
		{
			$('#http_remote_port').attr('disabled',false);
		}
		else
		{
			$('#http_remote_port').attr('disabled',true);
		}

		if(disable == "0")
		{
			$('#https_remote_port').attr('disabled',false);
		}
		else
		{
			$('#https_remote_port').attr('disabled',true);
		}
		*/
		show_shareport_link();
		$('#user_name').attr('disabled',disable);
		$('#pwd').attr('disabled',disable);
		$('#pwd1').attr('disabled',disable);
		$('#user_add').attr('disabled',disable);
		$('#user_name_list').attr('disabled',disable);
	}

	function ajax_submit()
	{
		if (sendSubmit)
			return;
		
		var time=new Date().getTime();
		sendSubmit = true;
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	paramSet.url,
			data: 	paramSet.arg+"&"+time+"="+time,
			success: function(data) {
				//gConfig = data;
				document.write(data);
			}
		};

		$.ajax(ajax_param);

	}
	
	function ajax_submit_no_redirect(p)
	{
		
		var time=new Date().getTime();
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	p.url,
			data: 	p.arg+"&"+time+"="+time
		};
		
		$.ajax(ajax_param);
	}
	
	function show_user()
	{
		$('#user_name_list').find('option').remove(); 
		var content = "";
			content += '<option value="0" selected>'+ get_words('_username') +'</option>';
		
		if(DataArray == null)
			return;
			
		for(var i=1;i<=DataArray.length;i++)
		{
			if((DataArray[i-1].Name != "") && (DataArray[i-1].Name != "admin") && (DataArray[i-1].Name != "guest") && (DataArray[i-1].Num != ""))
				content += '<option value=\"'+ i +'\">'+ DataArray[i-1].Name +'</option>';
		}
		$('#user_name_list').append(content);
		$('#user_name_list').val(0);
		load_user();
	}

	function load_user()
	{
		on_list = $("#user_name_list option:selected").index()
		if(on_list!=0)
		{
			$('#user_name').val($("select[name=user_name_list]").find("option:selected").text());
			$('#pwd').val('WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG');
			$('#pwd1').val('WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG');
			$('#user_del').attr("disabled", false);
		}
		else
		{
			$('#user_name').val('');
			$('#pwd').val('');
			$('#pwd1').val('');
			$('#user_del').attr("disabled", true);
		}
	}

	function add_user()
	{
		var usr_name = $('#user_name').val();
		var pwd = $('#pwd').val();
		var pwd1 = $('#pwd1').val();
		var wa_en = $("#wfa_enable").attr("checked")?1 : 0;
/*
		var wa_http_en = $("#http_remote_access").attr("checked")?1 : 0;
		var wa_http_port = $('#http_remote_port').val();
		var wa_https_port = $('#https_remote_port').val();
*/
		var submitData = "";

		var max_user_rule = 5;
		var max_user = 9;
		var null_count = 0;
		
		var lower_usr = $('#user_name').val().toLowerCase();
		if((lower_usr == "admin") || (lower_usr == "guest"))
		{
			alert(get_words('sto_03'));
			return;
		}

		if (usr_name == null || usr_name == '')
		{
			alert(get_words('GW_SMTP_USERNAME_INVALID'));
			return false;
		}

		if (!check_name(usr_name))
		{
			alert(get_words('GW_SMTP_USERNAME_INVALID'));
			return false;
		}
		else
		{
			for (var i =0;i<DataArray.length;i++)
			{
				if (usr_name == DataArray[i].Name && $('#user_name_list').val()==0)
				{
					alert(get_words('sto_03'));
					return false;
				}
			}
		}

		if(pwd != pwd1)
		{
			alert(get_words('YM174'));
			return false;
		}

/*
		if (wa_http_en == 1 && wa_http_port == "") //|| 
			//(wa_https_en == 1 && wa_https_port == ""))
		{
			alert(get_words('sto_01'));
			return;
		}
		
		wa_http_port = parseInt(wa_http_port);
		wa_https_port = parseInt(wa_https_port);
		if (wa_http_en == 1 && (wa_http_port <=0 || wa_http_port > 65535)) {
			alert(get_words("ac_alert_invalid_port"));
			return;
		}
		
		if (wa_http_en == 1 && (wa_https_port <=0 || wa_https_port > 65535)) {
			alert(get_words("ac_alert_invalid_port"));
			return;
		}

		//check port use
		var ret_val;
		if(wa_http_en == 1)
		{
			ret_val = check_port_use(get_words('sto_http_3'), wa_http_port);
			if(!ret_val)
				return;
		}

		if(wa_http_en == 1)
		{
			ret_val = check_port_use(get_words('sto_http_5'), wa_https_port);
			if(!ret_val)
				return;
		}
*/

		if((curr_user_cnt-2) ==9) //curr_user_cnt exclude admin and guest
		{
			alert(get_words('MSG055'));
			return;
		}
		else if($('#user_name_list').val()!=0)
		{
			var edit_user=$('#user_name_list').val();
			//check if username is changed
			if(usr_name!=$("select[name=user_name_list]").find("option:selected").text())
			{
				for(var k=0; k<usrName.length; k++)
				{
					if(usrName[k].split("/")[0]==$("select[name=user_name_list]").find("option:selected").text())
						usrName[k]= usr_name +"/"+ usrName[k].split("/")[1];
				}
			}
			//edit all the name in multiple rules
			for(var m=0; m<DataArray.length; m++)
			{
				if(DataArray[m].Name==$("select[name=user_name_list]").find("option:selected").text())
					DataArray[m].Name = usr_name;
			}
				
			//DataArray[edit_user-1].Name = usr_name;
			usrPasswd[usrPasswd.length] = usr_name+"/"+pwd;
		}
		else
		{	
			curr_user_cnt++;
			DataArray[DataArray.length++] = new Data(curr_user_cnt, 0, usr_name, "0", "None", 0);
			usrPasswd[usrPasswd.length] = usr_name+"/"+pwd;
		}
		show_user();
		DataShow();		
	}

	function user_delete()
	{
		var usr_name = $('#user_name').val();
		var pwd = $('#pwd').val();
		var pwd1 = $('#pwd1').val();
		var user_rule_count = 0;
		var submit_Data = "";

		var lower_usr = $('#user_name').val().toLowerCase();
		if((lower_usr == "admin") || (lower_usr == "guest"))
		{
			$('#user_del').attr("disabled", true);
			alert(get_words('sto_03'));
			return;
		}

		if (usr_name == null || usr_name == '')
		{
			$('#user_del').attr("disabled", true);
			alert(get_words('GW_SMTP_USERNAME_INVALID'));
			return false;
		}

		if(user_rule_inst != null && ary_user_name != null)
			user_rule_count = (user_rule_inst.length / ary_user_name.length);

		var usr_rule = chk_user_rule(usr_name);
		
		var reDataArray = new Array();	
		var reUsrPasswd = new Array();
		var reIdx=0, ArrayIdx=0;
		var reUsrIdx=0;
		for(var i=0; i < DataArray.length; i++)
		{
			if(DataArray[i].Name != usr_name)
			{
				if(DataArray[i].Num!="")
				{
					reDataArray[ArrayIdx] = new Data(reIdx+1, DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
					reIdx++;
				}
				else				
					reDataArray[ArrayIdx] = new Data("", DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
				ArrayIdx++;				
			}
		}
		curr_user_cnt--;
		for(var j=0; j<usrPasswd.length; j++)
		{
			var name = usrPasswd[j].split('/');
			if (name[0] != usr_name)
			{
				reUsrPasswd[reUsrIdx]=usrPasswd[j];
				reUsrIdx++;
			}
		}

		DataArray = reDataArray;
		usrPasswd = reUsrPasswd;
		show_user();
		DataShow();
	}


	function show_config()
	{
		$('#wfa_enable').attr('checked', parseInt(waCfg.enable));
		$('#http_remote_access').attr('checked', parseInt(waCfg.raHttpEn));
		//$('#https_remote_access').attr('checked', parseInt(waCfg.raHttpsEn));
		if(waCfg.raHttpPort != null || waCfg.raHttpPort != '')
		{
			$('#http_remote_port').val(waCfg.raHttpPort);
		}
		
		if(waCfg.raHttpsPort != null || waCfg.raHttpsPort != '')
		{
			$('#https_remote_port').val(waCfg.raHttpsPort);
		}
	}

	function Data(num, sub_num, name, dev, access_path, permission) 
	{
		this.Num = num;
		this.Sub_num = sub_num;
		this.Name = name;
		this.Device = dev;
		this.Access_path = access_path;
		this.Permission = permission;
	}	
	
	function set_list()
	{
		var index = 1;
		var user_rule = 0;
		var guest_rule = 0;	
		var user_rule_count = 0;
		var sub_idx = 1;
		var user = "";
		
		if(user_rule_inst != null && ary_user_name != null)
			user_rule_count = (user_rule_inst.length / ary_user_name.length);

		if(adm_rule_inst != null && adm_rule_inst.length > 0)
		{
			for(var i=0;i<adm_rule_inst.length;i++)
			{
				if(adm_rule_dev[i] != "" && adm_rule_path[i] != "" && adm_rule_right[i] != "")
				{
					DataArray[DataArray.length++] = new Data(index, 0, adm_name, adm_rule_dev[i], adm_rule_path[i], adm_rule_right[i]);
					index++;
				}
			}
		}
		
		if(guest_rule_inst != null && guest_rule_inst.length > 0)
		{
			for(var i=0;i<guest_rule_inst.length;i++)
			{
				if(guest_rule_dev[i] != "" && guest_rule_path[i] != "" && guest_rule_right[i] != "")
				{
					if(sub_idx == 1)
					{
						DataArray[DataArray.length++] = new Data(index, sub_idx, guest_name, guest_rule_dev[i], guest_rule_path[i], guest_rule_right[i]);
						index++;
					}
					else
					{
						DataArray[DataArray.length++] = new Data("", sub_idx, guest_name, guest_rule_dev[i], guest_rule_path[i], guest_rule_right[i]);
					}
					guest_rule++;
					sub_idx++
				}
				else if((guest_rule == 0) && (i == guest_rule_inst.length - 1))
				{
					DataArray[DataArray.length++] = new Data(index, 0, guest_name, "0", "None", 0);
					index++;
					break;
				}
			}
			sub_idx = 1;
		}

		if(user_rule_inst != null && user_rule_inst.length > 0)
		{
			for(var i=0;i<ary_user_name.length;i++)
			{				
			if(ary_user_name[i] !="")
			{
				var j = (i * user_rule_count);
				var k = (j + user_rule_count);
				for(j;j<k;j++)
				{
					if(user_rule_dev[j] != "" && user_rule_path[j] != "" && user_rule_right[j] != "")
					{
						if(user == "" || ary_user_name[i] != user)
						{
							DataArray[DataArray.length++] = new Data(index, sub_idx, ary_user_name[i], user_rule_dev[j], user_rule_path[j], user_rule_right[j]);
							index++;
						}
						else
						{
							DataArray[DataArray.length++] = new Data("", sub_idx, ary_user_name[i], user_rule_dev[j], user_rule_path[j], user_rule_right[j]);
						}
						user = ary_user_name[i];
						user_rule++;
						sub_idx++;
					}
					else if((user_rule == 0) && (j == k - 1))
					{
				
						DataArray[DataArray.length++] = new Data(index, 0, ary_user_name[i], "0", "None", 0);
						index++;
					}
				}
				user_rule = 0;
				sub_idx = 1;
				usrPasswd[usrPasswd.length] = ary_user_name[i]+"/"+ary_user_passwd[i];
				usrName[usrName.length] = ary_user_name[i]+"/i="+(i+1);
			}
			}
		}
		curr_user_cnt = index-1;
	}	

	function check_port_use(port_item, port)
	{
		var tcp_timeline = null;
		var udp_timeline = null;
		
		var dst_port = port;
		tcp_timeline = add_into_timeline(tcp_timeline, dst_port, null);
		
		// add virtual server ports into timeline

		for (var i=0; i<array_vs_enable.length; i++) 
		{
			if (array_vs_enable[i] == '0')
				continue;
				
			var vs_ports = array_vs_ports[i].split(',');
			for (var j=0; j<vs_ports.length; j++) 
			{
				var range = vs_ports[j].split('-');
				if (array_vs_proto[i] == '0') 
				{
					tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
					if (check_timeline(tcp_timeline) == false) 
					{
						alert(addstr(get_words('ag_conflict5'), port_item, dst_port));
						return false;
					}
				} 
				else if (array_vs_proto[i] == '1') 
				{
					udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
				} 
				else 
				{
					tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
					udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
				}
			}
		}
	
		// add port forward ports into timeline
		for (var i=0; i<array_pf_enable.length; i++) 
		{
			if (array_pf_enable[i] == '0')
				continue;
				
			var pf_tcp_ports = array_pf_ports_tcp[i].split(',');
			for (var j=0; j<pf_tcp_ports.length; j++) 
			{
				var range = pf_tcp_ports[j].split('-');
				tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
				if (check_timeline(tcp_timeline) == false) 
				{
					alert(addstr(get_words('ag_conflict5'), port_item, dst_port));
					return false;
				}
			}
			var pf_udp_ports = array_pf_ports_udp[i].split(',');
			for (var j=0; j<pf_udp_ports.length; j++) 
			{
				var range = pf_udp_ports[j].split('-');
				udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
			}
		}

		// add port trigger ports into timeline
		for (var i=0; i<array_pt_enable.length; i++) 
		{
			if (array_pt_enable[i] == '0')
				continue;
			
			var pt_ports = array_pt_ports[i].split(',');
			for (var j=0; j<pt_ports.length; j++) 
			{
				var range = pt_ports[j].split('-');
				if (array_pt_proto[i] == '0') 
				{
					tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
					if (check_timeline(tcp_timeline) == false) 
					{
						alert(addstr(get_words('ag_conflict5'), port_item, dst_port));
						return false;
					}
				} 
				else if (array_pt_proto[i] == '1') 
				{
					udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
				} 
				else 
				{
					tcp_timeline = add_into_timeline(tcp_timeline, range[0], range[1]);
					udp_timeline = add_into_timeline(udp_timeline, range[0], range[1]);
				}
			}
		}

		//tcp_timeline = add_into_timeline(tcp_timeline,80,null)
		if (check_timeline(tcp_timeline) == false) 
		{				
			alert(addstr(get_words('ag_conflict5'), port_item, dst_port));
			return false;
		}
		
		//add remote management port to timeline
		if(rmgr_en == 1)
		{
			tcp_timeline = add_into_timeline(tcp_timeline,rmgr_port,null)
			if (check_timeline(tcp_timeline) == false) 
			{				
				alert(addstr(get_words('ag_conflict5'), port_item, dst_port));
				return false;
			}
		}
		//add remote management https port to timeline
		if(rmgrs_en == 1)
		{
			tcp_timeline = add_into_timeline(tcp_timeline,rmgrs_port,null)
			if (check_timeline(tcp_timeline) == false) 
			{				
				alert(addstr(get_words('ag_conflict5'), port_item, dst_port));
				return false;
			}
		}

		return true;
	}

	var paramSet; //global variable for delay to send request
    function send_request()
	{    	
		var wa_en = $("#wfa_enable").attr("checked")?1 : 0;
		var gu_en = $('input[name="user_enable"]:checked').val();

		var wa_http_en = $("#http_remote_access").attr("checked")?1 : 0;
		var wa_http_port = $('#http_remote_port').val();
		var wa_https_port = $('#https_remote_port').val();
		

		if((wa_http_en == '1') && (dynDns.enable == 1 && dynDns.status == 1))
		{
			http_stolink = 'http://'+dynDns.hostName+':'+wa_http_port;
			https_stolink = 'https://'+dynDns.hostName+':'+wa_https_port;
		}
		else if(wa_http_en == '1')
		{
			http_stolink = 'http://'+wanIp+':'+wa_http_port;
			https_stolink = 'https://'+wanIp+':'+wa_https_port;
		}

		//20120509 silvia modify can fill int only, chk port confilct
		//if (wa_http_en == 1 && wa_https_en == 1 && wa_http_port == wa_https_port) {
		if (wa_en == 1 && wa_http_port == wa_https_port) {
			alert(get_words("TEXT057"));
			return;
		}

		if (wa_en == 1 && (!(check_integer(wa_http_port, 1, 65535)))) {
			alert(get_words("ac_alert_invalid_port"));
			return;
		}
		
		if (wa_en == 1 && (!check_integer(wa_https_port, 1, 65535))) {
			alert(get_words("ac_alert_invalid_port"));
			return;
		}

		//check port use
		var ret_val;
		if(wa_en == 1)
		{
			ret_val = check_port_use(get_words('sto_http_3'), wa_http_port);
			if(!ret_val)
				return;
		}

		if(wa_en == 1)
		{
			ret_val = check_port_use(get_words('sto_http_5'), wa_https_port);
			if(!ret_val)
				return;
		}


		DisableEnableForm(form1,true);
		var submitData = "";
		paramSet =""
		paramSet = {
			url: "get_set.ccp",
			arg: "ccp_act=setStorage&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=storage.asp"	//CCP_SUB_WEBACCESS
		};

		submitData += "&igdStorage_Enable_1.1.0.0="+wa_en;
		submitData += "&igdStorage_GuestEnable_1.1.0.0="+gu_en;
//		submitData += "&igdStorage_Http_Remote_Access_Enable_1.1.0.0="+wa_http_en;

		if (wa_en == 1) {
//			submitData += "&igdStorage_Http_Remote_Access_Port_1.1.0.0="+wa_http_port;
			submitData += "&igdStorage_Http_Storage_Link_1.1.0.0="+http_stolink;
//			submitData += "&igdStorage_Https_Remote_Access_Port_1.1.0.0="+wa_https_port;
			submitData += "&igdStorage_Https_Storage_Link_1.1.0.0="+https_stolink;
		}


		var submitUserData="";
		var paramUserSet = {
			url: "get_set.ccp",
			arg: "ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=storage.asp"
		};
		//send modified username first
		for(var k=0; k<usrName.length; k++)
		{
			var edit_idx = usrName[k].split("/")[1].substring(2,3);
			if(edit_idx != "")
				submitUserData += "&igdStorageUser_Username_1.1."+(edit_idx)+".0="+usrName[k].split("/")[0];
		}
		paramUserSet.arg += submitUserData;
		ajax_submit_no_redirect(paramUserSet);
		
		
		var admin_idx=1, guest_idx=1, user_idx=1, rule_user_idx=1;
			
		for(var i=0; i<DataArray.length; i++)
		{
			if(DataArray[i].Name == "admin") //admin rule
			{
				if(DataArray[i].Access_path !="None")
				{
					submitData += '&igdStorageAdminRule_Device_1.1.1.'+(admin_idx)+'='+DataArray[i].Device; 
					submitData += '&igdStorageAdminRule_AccessPath_1.1.1.'+(admin_idx)+'='+encodeURIComponent(DataArray[i].Access_path);
					submitData += '&igdStorageAdminRule_Permission_1.1.1.'+(admin_idx)+'='+DataArray[i].Permission; 
					admin_idx++;
				}
			}
			else if(DataArray[i].Name == "guest") //guest rule
			{
				if(DataArray[i].Access_path !="None")
				{
					submitData += '&igdStorageGuestRule_Device_1.1.1.'+(guest_idx)+'='+DataArray[i].Device;
					submitData += '&igdStorageGuestRule_AccessPath_1.1.1.'+(guest_idx)+'='+encodeURIComponent(DataArray[i].Access_path);
					submitData += '&igdStorageGuestRule_Permission_1.1.1.'+(guest_idx)+'='+DataArray[i].Permission;
					//clear the rest of rules
					for(var k=(guest_idx+1); k<=guest_rule_inst.length; k++)
					{
						submitData += '&igdStorageGuestRule_Device_1.1.1.'+k+'=0';
						submitData += '&igdStorageGuestRule_AccessPath_1.1.1.'+k+'=';
						submitData += '&igdStorageGuestRule_Permission_1.1.1.'+k+'=0';
					}
					guest_idx++;
				}
				else
				{
					for(var k=1; k<=guest_rule_inst.length; k++)
					{
						submitData += '&igdStorageGuestRule_Device_1.1.1.'+k+'=0';
						submitData += '&igdStorageGuestRule_AccessPath_1.1.1.'+k+'=';
						submitData += '&igdStorageGuestRule_Permission_1.1.1.'+k+'=0';
					}
				}
			}
			else //user
			{
				if(DataArray[i].Num!="")
				{
					rule_user_idx=1;
					for(var j=0; j<usrPasswd.length; j++) //save username and password
					{
						if(DataArray[i].Name == usrPasswd[j].split("/")[0])
						{
							//if(usrPasswd[j].split("/")[1]!="") //not save password into datamodel yet  && usrPasswd[j].split("/")[1]!=""
							{
							submitData += "&igdStorageUser_Username_1.1."+(user_idx)+".0="+DataArray[i].Name;
							submitData += "&igdStorageUser_Password_1.1."+(user_idx)+".0="+usrPasswd[j].split("/")[1];
							}
							//else
							
						}
						
					}
					user_idx++;
				}
				if(DataArray[i].Access_path !="None") //save user rules
				{					
					submitData += '&igdStorageUserRule_Device_1.1.'+(user_idx-1)+'.'+rule_user_idx+'='+DataArray[i].Device;
					submitData += '&igdStorageUserRule_AccessPath_1.1.'+(user_idx-1)+'.'+rule_user_idx+'='+encodeURIComponent(DataArray[i].Access_path);
					submitData += '&igdStorageUserRule_Permission_1.1.'+(user_idx-1)+'.'+rule_user_idx+'='+DataArray[i].Permission;
					//clear the rest of rules
					for(var k=(rule_user_idx+1); k<=5; k++)
					{
						submitData += '&igdStorageUserRule_Device_1.1.'+(user_idx-1)+'.'+k+'=0';
						submitData += '&igdStorageUserRule_AccessPath_1.1.'+(user_idx-1)+'.'+k+'=';
						submitData += '&igdStorageUserRule_Permission_1.1.'+(user_idx-1)+'.'+k+'=0';
					}
					rule_user_idx++;
				}
				else
				{
					//when Access_path == "None" means no rules for this user
					/**
					**	Date:	2013-05-20
					**	Author:	Silvia Chang
					**	Reason:	no spec define, request from D-Link Andy, add message when user not yet assign access path
					**/
					alert(addstr(get_words('sto_user_path'), DataArray[i].Name));
					DisableEnableForm(form1,false);
					return;

/*					for(var k=1; k<=5; k++)
					{
						submitData += '&igdStorageUserRule_Device_1.1.'+(user_idx-1)+'.'+k+'=0';
						submitData += '&igdStorageUserRule_AccessPath_1.1.'+(user_idx-1)+'.'+k+'=';
						submitData += '&igdStorageUserRule_Permission_1.1.'+(user_idx-1)+'.'+k+'=0';
					}
					rule_user_idx++;
*/
				}
			}
		}
		//clear the rest of users and rules		
		for(var k=user_idx; k<=(user_rule_inst.length / ary_user_name.length); k++)
			{
				submitData += '&igdStorageUser_Username_1.1.'+k+'.0=';
				submitData += '&igdStorageUser_Password_1.1.'+k+'.0=';
				
				for(var m=1; m<=5; m++)
				{
					submitData += '&igdStorageUserRule_Device_1.1.'+k+'.'+m+'=0';
					submitData += '&igdStorageUserRule_AccessPath_1.1.'+k+'.'+m+'=';
					submitData += '&igdStorageUserRule_Permission_1.1.'+k+'.'+m+'=0';
				}
			}

				
		paramSet.arg += submitData;
		setTimeout('ajax_submit()',500);
	}

	var idx_edit_rule=0;
	function edit_rule(name, sub_idx, dev, path, permission)
	{
		path = path.replace(/%27/ig, "'");
		idx_edit_rule = sub_idx;
		if (login_Info != "w") {
			return;
		}
		
		var permission_content;
		var permission_select_value = "<option value=\"0\" selected>"+get_words("_readonly")+"</option><option value=\"1\" >"+get_words("_readwrite")+"</option>";
		var content = '<option value=\"0\" selected></option>';
		var ary = "";
		var all_value = "";
		var org_path = "";
		var org_dev = "";
		var show_url = "";
		var path_ary = "";
		
		if(dev == "None")
			org_dev = "0";
		else
			org_dev = dev;

		if(path == "None")
			org_path = "";
		else
			org_path = path;
		
		all_value = name+";"+org_dev+";"+org_path+";"+permission;
		$('#all_field').val(all_value);
		
		$('#append_folder').dialog({'modal': true, width: 550, height: 400, close:function(){$('#dev_link').empty();$('#append_permission').empty();}});
		if(sub_idx==0)
			$('#append').attr('disabled', true);
		else
			$('#append').attr('disabled', false);
		//$('#append_folder').dialog({ width: 500, });

		if((waCfg.raHttpEn == '1') && (dynDns.enable == 1 && dynDns.status == 1))
		{
			show_url += 'http://'+dynDns.hostName+':'+waCfg.raHttpPort;
		}
		else if(waCfg.raHttpEn == '1') 
		{
			show_url += 'http://'+wanIp+':'+waCfg.raHttpPort;
		}
			
		if ((waCfg.raHttpsEn == '1') && (dynDns.enable == 1 && dynDns.status == 1)) 
		{
			show_url += 'https://'+dynDns.hostName+':'+waCfg.raHttpsPort;
		} 
		else if(waCfg.raHttpsEn == '1')
		{
			show_url = 'https://'+wanIp+':'+waCfg.raHttpsPort;
		}

		//Tin add:Reset all field
		set_selectIndex(0,get_by_id("dev_link"));	
		$('#append_username').val("");
		$('#folder_path').val("");

		if (disk_info == null) 
		{
			//alert(get_words('_usb_not_found'));
			$('#append_username').attr("disabled", "disabled");
			$('#append_username').val(name);
			$('#http_link').attr("disabled", "disabled");
			$('#http_link').val(waCfg.linkHttp);
			$('#folder_path').attr("disabled", "disabled");
			$('#folder_path').val(path);
			$('#append_permission').attr("disabled", "disabled");
			$('#append_permission').append(permission_select_value);
			$('#append').attr("disabled", "disabled");
			return;
		}
		
		for(var i=0;i<disk_info.length;i++)
		{
			ary = disk_info[i].split(";");
			content += '<option value=\"'+ ary[0] +'\">'+ ary[0] +'</option>';
		}

		path_ary = path.split("/");
		
		if(path_ary != "None")
			content += '<option value=\"'+ path_ary[1] +'\">'+ path_ary[1] +'</option>';
		
		$('#dev_link').append(content);
		
		if(permission == "0")
			permission_content = "Read Only";
		else
			permission_content = "Read/Write";
		
		$('#append_username').val(name);
		
		$('#append_username').attr("disabled", "disabled");
		$('#dev_link').attr("disabled", "disabled");
		$('#folder_path').attr("disabled", "disabled");

		if(path != "None")
		{
			$('#folder_path').val(path);
			path_ary = path.split("/");
			
			if(path_ary != "")
				set_selectIndex(path_ary[1],get_by_id("dev_link"));
			else
				set_selectIndex(0,get_by_id("dev_link"));
		}

		if(name == "guest")
			$('#append_permission').attr("disabled", "disabled");
		else
			$('#append_permission').attr("disabled", "");

		$('#append_permission').append(permission_select_value);
		$('#append_permission').val(permission);
		$("#append_permission option[value='" +permission+ "']").attr("selected", true);

		$('#storage_link').val(get_words("_StorageLink"));
//		$('#http_link').attr("disabled", "disabled");
		$('#http_link').val(waCfg.linkHttp);
		set_selectIndex(org_dev,get_by_id("dev_link"));
	}

	function close_append()
	{
		$("#append_folder" ).dialog("close");
		//$('#append_folder').dialog("disable");

		//set content as empty
		$('#dev_link').empty();
		$('#append_permission').empty();
		
		//Tin:fixed append window sometime becomes transparent issue.
		//location.reload();
	}

	function save_append()
	{
		var dev_content = $('#dev_link').val();
		var rule_empty = 0;
		var org_value = $('#all_field').val();
		var ary = org_value.split(";");
		
		var path_content = $('#folder_path').val();
		var permission = $('#append_permission').val();
		var username = $('#append_username').val();
		var user_rule_count = (user_rule_inst.length / ary_user_name.length);
		
		var array_rule = "";
		var rule_count = 1;
		//var chk_result = chk_rule(username);

		if(path_content == '\\' || (path_content.indexOf('\\') != -1))
		{
			//alert(get_words('MSG056'));
			alert(addstr(get_words('MSG056'), '\\'));
			return;
		}
		
		if($('#dev_link').val()==0)
			dev_content = (path_content == "/")? "/" : "";
			
		if(path_content != "")
		{
			for(var i=0; i < DataArray.length; i++)
			{
				if(DataArray[i].Name == $('#append_username').val() && DataArray[i].Sub_num == idx_edit_rule)
				{
					
					if(DataArray[i].Sub_num == 0)
						DataArray[i].Sub_num =DataArray[i].Sub_num+1;
						
					DataArray[i].Device = dev_content;
					DataArray[i].Access_path = path_content;
					DataArray[i].Permission = permission;
				}
			}
		}
		DataShow();
		$("#append_folder" ).dialog("close");
	}

	function append_rule()
	{
		//var folder = $('#append_folder').data('folder_path'); //get append_folder's path
		//array_rule

		var dev_content = $('#dev_link').val();
		var path_content = $('#folder_path').val();
		var permission = $('#append_permission').val();
		var username = $('#append_username').val();
		var user_rule_count = (user_rule_inst.length / ary_user_name.length);
		var array_rule = "";
		var not_empty = 0;
		var rule_count = 1;

		if(path_content == "")
		{
			alert(addstr(get_words('MSG056'), ' '));
			return;
		}

		if(path_content == '\\' || (path_content.indexOf('\\') != -1))
		{
			alert(addstr(get_words('MSG056'), '\\'));
			return;
		}
		
		if($('#dev_link').val()==0)
			dev_content = (path_content == "/")? "/" : "";
			
		var max_num=0;
			//max_num = (username == "admin")? adm_rule_inst.length : ((username == "guest")? guest_rule_inst.length : user_rule_count);

		var reDataArray = new Array();		
		var reIdx=0;
		var is_added =false;
		for(var i=0; i < DataArray.length; i++)
		{
			max_num = (DataArray[i].Name == "admin")? adm_rule_inst.length : ((DataArray[i].Name == "guest")? guest_rule_inst.length : user_rule_count);
			if(DataArray[i].Sub_num == max_num && username == DataArray[i].Name)
			{
				alert(get_words("MSG052"));
				return;
			}
			if(DataArray[i].Name != username)
			{
				if(is_added) //use is_added to check if new rule is among the array
				{
					reDataArray[reIdx] = new Data("", DataArray[i-1].Sub_num+1, DataArray[i-1].Name, dev_content, path_content, permission);
					reIdx++;
				}
				reDataArray[reIdx] = new Data(DataArray[i].Num, DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
				is_added=false;
			}
			else 
			{
				if(DataArray[i].Device != "0" && (path_content != DataArray[i].Access_path)) // not allow to append the rule for same path
					reDataArray[reIdx] = new Data(DataArray[i].Num, DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
				else
				{
					alert(get_words("MSG053"));
					return;
				}
				is_added=true;
			}				
			reIdx++;
		}
		if(is_added) // if append rule is at the end of array
			reDataArray[reIdx] = new Data("", DataArray[reIdx-1].Sub_num+1, DataArray[reIdx-1].Name, dev_content, path_content, permission);
		DataArray = reDataArray;
		DataShow();
		$("#append_folder" ).dialog("close");
		
	}

	function chk_rule(name)
	{
		var is_null = 0;
		var user_rule_count = (user_rule_inst.length / ary_user_name.length);

		if(name == "admin")
		{
			for(var i=0;i<adm_rule_inst.length;i++)
			{
				if(adm_rule_dev[i] == "" && adm_rule_path[i] == "" && adm_rule_right[i] == "0")
				{
					is_null++;
				}
			}
		}
		else if(name == "guest")
		{
			for(var i=0;i<guest_rule_inst.length;i++)
			{
				if(guest_rule_dev[i] == "" && guest_rule_path[i] == "" && guest_rule_right[i] == "0")
				{
					is_null++;
				}
			}
		}
		else
		{
			for(var i=0;i<ary_user_name.length;i++)
			{
				if(ary_user_name[i] == name)
				{
					var j = (i * user_rule_count);
					var k = (j + user_rule_count);
					for(j;j<k;j++)
					{
						if(user_rule_dev[j] == "" && user_rule_path[j] == "" && user_rule_right[j] == "0")
						{
							is_null++;
						}
					}
				}
			}
		}

		if((name == "admin" && is_null == 5) || (name == "guest" && is_null == 2) || (name != "" && is_null == 5))
			return is_null; //all rule is empty, return user number of array
		else
			return 999; //have one or more  rule
	}
	
	function chk_user_rule(name)
	{
		var is_null = 0;
		var i_count = 0;
		var user_rule_count = (user_rule_inst.length / ary_user_name.length);

		for(var i=0;i<ary_user_name.length;i++)
		{
			if(ary_user_name[i] == name)
			{
				i_count = i;
				var j = (i * user_rule_count);
				var k = (j + user_rule_count);
				for(j;j<k;j++)
				{
					if(user_rule_dev[j] == "0" && user_rule_path[j] == "" && user_rule_right[j] == "0")
					{
						is_null++;
					}
				}
			}
		}

		if(is_null >= 5)
			return i_count; //all rule is empty, return user number of array
		else
			return 999; //have one or more  rule
	}

	function remove_rule(name, sub_idx, dev, path, permission)
	{
		path = path.replace(/%27/ig, "'");
		if (login_Info != "w") {
			return;
		}
		var user_rule_count = (user_rule_inst.length / ary_user_name.length);
		var submit_Data = "";
		var usr_rule = 0;
		var dev_content;
		var path_content;
		var permission_content;
		var is_null = 0;
		
		if(dev == "None")
			dev_content = "0";
		else
			dev_content = dev;

		if(path == "None")
			path_content = "";
		else
			path_content = path;
		
		var reDataArray = new Array();	
		var user_rerule_cnt=0;
		var user_rerule_idx=0;
		var reIdx=0;
		var is_removed=false;
		for(var i=0; i < DataArray.length; i++)
		{
			if(DataArray[i].Name == name)
			{
				user_rerule_cnt++;
				if(DataArray[i].Num != "")
					user_rerule_idx= DataArray[i].Num;
			}
		}
		
		for(var i=0; i < DataArray.length; i++)
		{
			if(DataArray[i].Name == name)
			{
				if(user_rerule_cnt==1) //this user only has one rule
				{
					if(name == 'admin')
						reDataArray[reIdx] = new Data(reIdx+1, 0, DataArray[i].Name, "*", "/", 1);
					else if(name == 'guest')
						reDataArray[reIdx] = new Data(reIdx+1, DataArray[i].Sub_num-1,  DataArray[i].Name, "0", "None", 0);
					else
						reDataArray[reIdx] = new Data(reIdx+1, DataArray[i].Sub_num-1, DataArray[i].Name, "0", "None", 0);
					//is_removed=true;
				}
				else //this user has more than one rule
				{
					if(DataArray[i].Sub_num==sub_idx)
					{
						is_removed = true;
						continue;
					}
					else //check if it is already removed
					{
						if(is_removed)
						{
							if(DataArray[i].Sub_num == 2) //need to wirte Num instead of null value
								reDataArray[reIdx] = new Data(user_rerule_idx, DataArray[i].Sub_num-1, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
							else
							{
								reDataArray[reIdx] = new Data("", DataArray[i].Sub_num-1, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
							}
						}
						else
							reDataArray[reIdx] = new Data(DataArray[i].Num, DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
					}
					
				}
			}
			else
			{
				if(is_removed && DataArray[i].Num == "")
					reDataArray[reIdx] = new Data("", DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
				else
					reDataArray[reIdx] = new Data(DataArray[i].Num, DataArray[i].Sub_num, DataArray[i].Name, DataArray[i].Device, DataArray[i].Access_path, DataArray[i].Permission);
			}
		
			reIdx++;
		}
		DataArray = reDataArray;
		DataShow();
	}
	
	function loadSettings()
	{
		$('#append_folder').hide();
		$('#browser_folder').hide();
		$('#user_del').attr("disabled", true);
		show_config();
		show_user();
		show_user_permission();
		show_shareport_link();
	}
	
			
	function DataShow()
	{
		var str_permission = "";	
		var icon = "";
		var last_name = "";
		
		var contain = "";
			contain +='<div class="box" id="user_list_area">';
			contain +='<h2>'+get_words('sto_list')+'</h2>';
			contain +='<table width="525" border="0" cellpadding="3" cellspacing="0" style="word-break:break-all">';
			contain +='<tr align="right">';
			contain +='<td colspan="6"><img src="image/modify.png" width="20px"> : '+get_words("_modify")+'&nbsp;&nbsp;<img src="image/remove.png" width="20px"> :'+get_words("_delete")+'</td>';
			contain +='</tr>';
			contain +='<tr>';
			contain +='<td align="center" width="10%" bgcolor="#DDDDDD"><b>'+get_words('_item_no')+'</b></td>';
			contain +='<td align="left" width="16%" bgcolor="#DDDDDD"><b>'+get_words('_username')+'</b></td>';
			contain +='<td align="left" bgcolor="#DDDDDD"><b>'+get_words('sto_path')+'</b></td>';
			contain +='<td align="left" bgcolor="#DDDDDD"><b>'+get_words('sto_permi')+'</b></td>';
			contain +='<td align="center" bgcolor="#DDDDDD" width="5%"></td>';
			contain +='<td align="center" bgcolor="#DDDDDD" width="5%"></td>';
			contain +='</tr>';
			
		//var is_enable = "";
		for(i = 0; i < DataArray.length; i++)
		{	
			contain +='<tr>';
			if(DataArray[i].Name != "")
			{
				if(DataArray[i].Permission == "0")
				{
					str_permission = get_words("_readonly");
				}
				else
				{
					str_permission = get_words("_readwrite");
				}
				if(DataArray[i].Name == "admin")
				{
					// Tin modify at 20120510 : follow wfa v1.03 spec
					
					//if(DataArray[i].Access_path == "/")
						icon += "<td></td><td></td>";
					//else
					//	icon += "<td align=\"right\"><img src=\"modify.png\" id=\"modify\" width=\"20px\" onClick=\"edit_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Device+"\', \'"+DataArray[i].Access_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td><td align=\"right\"><img src=\"remove.png\" id=\"remove\" width=\"20px\" onClick=\"remove_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Device+"\', \'"+DataArray[i].Access_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td>";
				}
				else if(DataArray[i].Name == "guest")
				{
					if(DataArray[i].Access_path == "None")
						icon += "<td align=\"center\" width=\"5%\"><img src=\"image/modify.png\" id=\"modify\" width=\"20px\" onClick=\"edit_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Sub_num+"\', \'"+DataArray[i].Device+"\', \'"+DataArray[i].Access_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td><td width=\"5%\"></td>";
					else
					{
						var tmp_path = DataArray[i].Access_path.replace(/'/ig, "%27");
						icon += "<td align=\"center\" width=\"5%\"><img src=\"image/modify.png\" id=\"modify\" width=\"20px\" onClick=\"edit_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Sub_num+"\', \'"+DataArray[i].Device+"\', \'"+tmp_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td><td align=\"right\" width=\"5%\"><img src=\"image/remove.png\" id=\"remove\" width=\"20px\" onClick=\"remove_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Sub_num+"\', \'"+DataArray[i].Device+"\', \'"+tmp_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td>";
					}
				}
				else
				{
					if(DataArray[i].Access_path != "None")
					{
						var tmp_path = DataArray[i].Access_path.replace(/'/ig, "%27");
						icon += "<td align=\"center\" width=\"5%\"><img src=\"image/modify.png\" id=\"modify\" width=\"20px\" onClick=\"edit_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Sub_num+"\', \'"+DataArray[i].Device+"\', \'"+tmp_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td><td align=\"right\" width=\"5%\"><img src=\"image/remove.png\" id=\"remove\" width=\"20px\" onClick=\"remove_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Sub_num+"\', \'"+DataArray[i].Device+"\', \'"+tmp_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td>";
					}
					else
						icon += "<td align=\"center\" width=\"5%\"><img src=\"image/modify.png\" id=\"modify\" width=\"20px\" onClick=\"edit_rule(\'"+DataArray[i].Name+"\', \'"+DataArray[i].Sub_num+"\', \'"+DataArray[i].Device+"\', \'"+DataArray[i].Access_path+"\', \'"+DataArray[i].Permission+"\')\" style=\"cursor:hand\"></td><td align=\"right\" width=\"5%\">";
				}	
				
				//document.write("<tr align=\"left\">");
				contain += "<td align=\"center\">"+ DataArray[i].Num +"</td>";
				if(last_name != DataArray[i].Name)
					contain +="<td>"+ DataArray[i].Name +"</td>";
				else
					contain +="<td></td>";
				
				if(DataArray[i].Sub_num != 0)
					contain +="<td>("+DataArray[i].Sub_num+") "+ DataArray[i].Access_path +"</td>";
				else
					contain +="<td>"+ DataArray[i].Access_path +"</td>";
				
				contain +="<td>"+ str_permission  +"</td>";
				contain += icon;
				
				icon = "";
			}
			contain +='</tr>';
			last_name = DataArray[i].Name;
		}	
			contain +='</table></div>';
			$('#UsrLstTable').html(contain);
	}	

	function get_disk_info()
	{
		//execute web_access.ccp to get device info

		var ary = new Array(2);
		if(disk_info != null)
		{
			$('#dev_count').html(disk_info.length);
			for(var i=0;i<disk_info.length;i++)
			{
				ary = disk_info[i].split(";");
				var total_size = calculate(ary[1]);
				var avaliable_size = calculate(ary[2]);
				document.write("<tr align=\"center\">");
				document.write("<td>"+ary[0]+"</td>");
				document.write("<td>"+total_size+"</td>");
				document.write("<td>"+avaliable_size+"</td>");
				document.write("</tr>\n");

			}
		}
	}

	function req_subfolder(path, ulId, type) 
	{
		path = path.replace(/%27/ig, "'");
		var folderObj = new ccpObject();
		var param = {
			url: 'web_access.ccp',
			arg: 'ccp_act=get&file_type='+type+'&get_path='+encodeURIComponent(path)
		};
		folderObj.get_config_obj(param);
		folders = folderObj.config_str_multi("dir_path");
		update_tree(path, ulId, folderObj);
		
		//if (path == '/')
		//	return;

		req_ctx(path, ulId);
	}
	
	function req_ctx(path, ulId)
	{
		path = path.replace(/%27/ig, "'");
		var ary = '';
		var path_ary = '';
		var full_path = '';
		var dcount = 0; //device number
		var d_len = 0; //device char length
		var ctxObj = new ccpObject();
		var param = {
			url: 'web_access.ccp',
			arg: 'ccp_act=get&file_type=3&get_path='+encodeURIComponent(path)
		};
		ctxObj.get_config_obj(param);
		dev_qty = ctxObj.config_val("usb_quantity");
		folder_path_list = ctxObj.config_str_multi("dir_path");
		file_path_list = ctxObj.config_str_multi("file_path");
		folder_list = ctxObj.config_str_multi("dir");
		file_list = ctxObj.config_str_multi("file");
		//show_content(path, ulId);
		if(path == "/")
			full_path = path;
		else
			full_path = "/"+path;
		
		path_ary = path.split("/");
		if(path_ary.length == 2 && (path_ary[0] == "" && path_ary[1] == ""))
		{
			d_len = path_ary[0].length;
			dcount = path_ary[0];
			set_selectIndex(dcount, get_by_id("dev_link"));
		}
		else
		{
			d_len = path_ary[0].length;
			if(d_len != 0)
				dcount = path_ary[0];
			else
				dcount = 0;
			
			set_selectIndex(dcount, get_by_id("dev_link"));
			full_path = "/"+path;
		}

		$('#folder_path').val(full_path);
		
		cur_path = path;
	}

	function update_tree(path, ulId, folderObj)
	{
		var branches = '';
		var rPath = '';
		var folders = folderObj.config_str_multi("dir_path");
		
		if (path == '/')
			rPath = '';
		else
			rPath = path+'/';
		
		var se_rPath = rPath.replace(/'/ig, "%27");
		
		if (folders == null)
			return;

		for (var i=0; i<folders.length; i++) {
			var dispName = '';
			dispName = folders[i];
			if (path == '/')
				dispName = dispName;
			var se_dispName = folders[i].replace(/'/ig, "%27");
			branches += '<li><span class=folder>'+dispName+'</span>'+
				'<ul id="'+ulId+'/'+se_dispName+'"'+
//					' url="req_subfolder(\''+rPath+folders[i]+'\', \''+transUid(ulId, folders[i])+'\', \'1\')"'+
//					' clr="req_ctx(\''+rPath+folders[i]+'\', \''+transUid(ulId, folders[i])+'\')">'+
					' url="req_subfolder(\''+se_rPath+se_dispName+'\', \''+ulId+'/'+se_dispName+'\', \'1\')"'+
					' clr="req_ctx(\''+se_rPath+se_dispName+'\', \''+ulId+'/'+se_dispName+'\')">'+
				'</ul></li>';
		}
		/*
		$('#'+transUid(ulId)).html('');
		$(branches).appendTo('#'+transUid(ulId));
		*/
		
		//Buck replace jQuery, special character will casue jQuery error
		document.getElementById(ulId).innerHTML = branches;
		prepare_treeview(ulId);
	}

	function prepare_treeview(ulId) 
	{
		//Buck replace jQuery, special character will casue jQuery error
		$(document.getElementById(ulId)).treeview({
			collapsed: true,
			toggle: function() {
				var obj = $(this).find('ul');
				if ($(this).attr('class').substring(0,1) == 'c') {	//collapse
					eval(obj.attr('url'));
				} else {
					eval(obj.attr('clr'));
					obj.html('');
				}
			}
		});
	}

	function transUid(uid)
	{
		return uid.replace(/[@\$\.\ \/]/g, function(c) { return ('\\'+c); });
	}
	
	function browser_folder()
	{
		var str = "";
		if (disk_info != null)
		{
			str = '<ul id="browser" class="filetree">'+
					'		<li><span class="folder" id="__" >'+ get_words('webf_hd') +'</span>'+
					'		<ul id="_" url="req_subfolder(\'/\', \'_\', \'1\')" clr="req_ctx(\'/\', \'_\')"></ul>'+
					'		</li>'+
					'	</ul>	';
		}
		else
		{
			str = '<ul id="browser" class="filetree">'+
					'		<li><span class="folder" id="__" >&nbsp/</span>'+
					'		'+ get_words('webf_non_hd') +
					'		</li>'+
					'	</ul>	';
		}

		$('#browser_folder').dialog({'modal': true, width: 500, height: 400});
		$('#browser_folder').dialog("open");
		$('#browser_ctx').html(str);
		prepare_treeview('browser');
		/*
		try {
			var classes = $('#browser').find('div').attr('class').split(' ');
			if (classes != null) {
				for (var i=0; i<classes.length; i++) {
					if (classes[i] != 'collapsable-hitarea')
						continue;
					$('#browser').find('div').click();
					break;
				}
			}
		} catch (e) {
			
		}
		*/
	}

	function set_folder()
	{
		$('#browser_folder').dialog("close");
	}

	function close_browser()
	{
		$('#folder_path').val("");
		$('#browser_folder').dialog("close");
	}

/*
	function prepare_wa_link()
	{	
		//for folder browse
		var ShowMsg = "";
		$('#wa_link').html("");
		
		ShowMsg = '<table align=\"center\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" width=\"420\">';
		
		if (wanIp == null || wanIp == '0.0.0.0' || waCfg.enable == '0' || waCfg.raHttpEn == '0') {
			$('#wa_link').html('');
			return;
		}

		var emailBtnTag = '';
			if(objEmail.enable == 1)
		{
			emailBtnTag += '<input id=\"email_http\" name=\"email_http\" type=\"button\" onClick=\"email_now();\" class=button_submit value=\"'+get_words("_email_now")+'\">';
		}
			
		ShowMsg += '<tr><td>';
		if(dynDns.enable == 1 && dynDns.status == 1)
		{
			//set storage link url
			ShowMsg += '<table>';
			ShowMsg += '<tr><td><a href=http://'+dynDns.hostName+':'+waCfg.raHttpPort+'>http://'+dynDns.hostName+':'+waCfg.raHttpPort+"</a></td></tr>";
			ShowMsg += '<tr><td><a href=https://'+dynDns.hostName+':'+waCfg.raHttpsPort+'>https://'+dynDns.hostName+':'+waCfg.raHttpsPort+"</a></td></tr>";
			ShowMsg += '</table>';
		} 
			else
		{
			ShowMsg += '<table>';
			ShowMsg += '<tr><td><a href=http://'+wanIp+':'+waCfg.raHttpPort+'>http://'+wanIp+':'+waCfg.raHttpPort+"</a></td></tr>";
			ShowMsg += '<tr><td><a href=https://'+wanIp+':'+waCfg.raHttpsPort+'>https://'+wanIp+':'+waCfg.raHttpsPort+"</a></td></tr>";
			ShowMsg += '</table>';
		}
		ShowMsg += '</td>';
		ShowMsg += '<td>'+emailBtnTag+'</td>';
			ShowMsg += '</tr>';
			
		ShowMsg += '</table>';

		$('#wa_link').html(ShowMsg);
	}

	function email_now()
	{
		var add = objEmail.emailTo;
		alert(get_words('sl_alert_4') + " " + add);
			
		var emailObj = new ccpObject();
		var paramSendMail = {
			url: "get_set.ccp",
			arg: 'ccp_act=doEvent&ccpSubEvent=CCP_SUB_EMAIL_STOLINK'
		};
		emailObj.get_config_obj(paramSendMail);
	}
*/

	//Tin add end

	//To follow DLink spec.
	function show_user_permission(){
		var radio = $('input[name=user_enable]')[guest_enable];
		$(radio).attr('checked', true);
	}

	function show_shareport_link(){
		if(disk_info && $('#wfa_enable').attr('checked'))
			$('.sto_link').show();
		else
			$('.sto_link').hide();
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b1');</script>
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b4');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			<input type="hidden" id="html_response_page" name="html_response_page" value="">
			<input type="hidden" id="html_response_message" name="html_response_message" value="">
			<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
			<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="lan.asp">
			<input type="hidden" id="reboot_type" name="reboot_type" value="lan">
			<input type="hidden" id="del" name="del" value="-1">
			<input type="hidden" id="edit" name="edit" value="-1">
			<input type="hidden" id="max_row" name="max_row" value="-1">
			<input type="hidden" name="modified" id="modified" value="0">

		<td valign="top" id="maincontent_container">
		<div id="maincontent">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="box_header">
						<h1>
							<script>show_words('storage')</script>
						</h1>
						<script>show_words('sto_into')</script>
						<br>
						<br>
						<input name="button" id="button" type="button" class="button_submit" value="" onClick="send_request()">
						<input name="button2" id="button2" type="button" class="button_submit" value="" onclick="page_cancel('form1', 'storage.asp');">
						<script>$('#button').val(get_words('_savesettings'));</script>
						<script>$('#button2').val(get_words('_dontsavesettings'));</script>
					</div>

					<div class="box">
						<h2><script>show_words('samba_title_up')</script></h2>
						<table cellpadding="1" cellspacing="1" border="0" width="525">
							<tr>
								<td class="duple1">
									<script>show_words('samba_title_low')</script> :
								</td>
								<td width="340">&nbsp;
									<input name="user_enable" id="admin_enable" type="radio" value="0">
									<script>show_words('samba_admin')</script>
								</td>
							</tr>
							<tr>
								<td class="duple1"></td>
								<td width="340">&nbsp;
									<input name="user_enable" id="guest_enable" type="radio" value="1">
									<script>show_words('samba_user')</script>
								</td>
							</tr>
						</table>
					</div>




					<div class="box">
						<h2><script>show_words('sto_http_0')</script></h2>
						<table cellpadding="1" cellspacing="1" border="0" width="525">
							<tr>
								<td class="duple1">
									<script>show_words('sto_http_1')</script> :
								</td>
								<td width="340">&nbsp;
									<input name="wfa_enable" id="wfa_enable" type=checkbox value="" onClick="disable_storage()">
								</td>
							</tr>
							<tr class="sto_link">
								<td class="duple1">
									<script>show_words('sto_http_7')</script> :
								</td>
								<td width="340">&nbsp;
									<a href="http://shareport.local./">
										<script>show_words('sto_http_link')</script>
									</a>
								</td>
							</tr>
							<tr class="sto_link">
								<td class="duple1"></td>
								<td width="340">&nbsp;
									<a href="https://shareport.local./">
										<script>show_words('sto_https_link')</script>
									</a>
								</td>
							</tr>
							<tr style="display:none">
								<td class="duple1">
								<script>show_words('sto_http_3')</script> :
								</td>
								<td width="340">&nbsp;
									<input name="http_remote_port" type="text" id="http_remote_port" size="20" maxlength="15" value=''>
								</td>
							</tr>
							<tr style="display:none">
								<td class="duple1">
								<script>show_words('sto_http_5')</script> :
								</td>
								<td width="340">&nbsp;
									<input name="https_remote_port" type="text" id="https_remote_port" size="20" maxlength="15" value=''>
								</td>
							</tr>
							<tr style="display:none">
								<td class="duple1">
									<script>show_words('sto_http_6')</script> :
								</td>
								<td width="340">&nbsp;
									<input name="http_remote_access" type=checkbox id="http_remote_access" value="" onClick="disable_storage()">
								</td>
							</tr>
						</table>
					</div>

					<div class="box" id="add_users">
						<h2><script>show_words('sto_creat')</script> </h2>
						<table width="525" border=0 cellPadding=1 cellSpacing=1 class=formarea summary="">
							<tr>
								<td class="duple">
									<script>show_words('_username')</script> :
								</td>
								<td width="340">&nbsp;&nbsp;
									<input type=text id="user_name" name="user_name" size="20">&lt;&lt;
									<select id="user_name_list" name="user_name_list" onChange="load_user()">
										<option value="0" selected>
											<script>show_words('_username')</script>
										</option>
										<span id="user_list"></span>
									</select>
								</td>
							</tr>
							<tr>
								<td class="duple">
									<script>show_words('_password')</script> :
								</td>
								<td width="340">&nbsp;&nbsp;
									<input type=password id="pwd" name="pwd" size="20" maxlength="15">
								</td>
							</tr>
							<tr>
								<td class="duple">
									<script>show_words('_verifypw')</script> :
								</td>
								<td width="340">&nbsp;&nbsp;
									<input type=password id="pwd1" name="pwd1" size="20" maxlength="15">
									<input id="user_add" name="user_add" type="button" class=button_submit value="" onClick="add_user();">
									<input id="user_del" name="user_del" type="button" class=button_submit value="" onClick="user_delete();">
									<script>$('#user_add').val(get_words('_add_edit'));</script>
									<script>$('#user_del').val(get_words('_delete'));</script>
								</td>
							</tr>
						</table>
					</div>

					<span id="UsrLstTable"></span>
						<script>
							set_list();
							DataShow();
						</script>

					<div class=box id="dev_list">
						<h2><script>show_words('sto_no_dev')</script>: <span id="dev_count"></span></h2>
						<table width="525" border="0" align="center" cellpadding="3" cellspacing="1" >
						<tr>
                     		<td align="center" bgcolor="#DDDDDD"><b><script>show_words('sto_dev')</script></b></td>
                        	<td align="center" bgcolor="#DDDDDD"><b><script>show_words('_total_space')</script></b></td>
                        	<td align="center" bgcolor="#DDDDDD"><b><script>show_words('_free_space')</script></b></td>
                     	</tr>
						<script>
							get_disk_info();
						</script>
						</table>
					</div>

					<div class="box" style="display:none">
						<h2><script>show_words('sto_link_0')</script></h2>
						<table cellpadding="1" cellspacing="1" border="0" width="525">
							<tr>
								<td><script>show_words('sto_link_1')</script></td>
							</tr>
							<tr>
								<td>
									<!--script>show_words('sto_link_2')</script-->
									
										<span id="wa_link"></span>
										<span id="email_btn"></span>
								</td>
							</tr>
						</table>
					</div>

					<div style="height: 200px;width: 500px;" class="ui-dialog-content ui-widget-content" id="append_folder" title="">
					<table width="98%" border="0" align="center" bgcolor="#333333" cellspacing="0">
                        <tr>
                      		<td align="left" colspan="2"><b><font color="#FFFFFF"><span id="title"></span></font></b></td>
                      		<script>$('#title').html(get_words('_AppendNewFolder'))</script>
				  		</tr>
                        <tr>
                        	<td align="right" bgcolor="#FFFFFF"><span id="user"></span> :</td><td align="left" bgcolor="#FFFFFF"> &nbsp;&nbsp;<input type="text" id="append_username" name="append_username" /></td>
                        	<script>$('#user').html(get_words('_username'))</script>
                        </tr>
                        <tr style="display:none">
							<td align="right" bgcolor="#FFFFFF"><span id="Device"></span> :</td> <td align="left" bgcolor="#FFFFFF">&nbsp;&nbsp;<select size="1" id="dev_link" name="dev_link" onChange=""></td>
							<script>$('#Device').html(get_words('_DevLink'))</script>
                        </tr>
						<tr>
                        	<td align="right" bgcolor="#FFFFFF"><span id="Device_link"></span> :</td><td align="left" bgcolor="#FFFFFF"> &nbsp;&nbsp;<input style="width: 300px;" type="text" id="http_link" name="http_link" /></td>
                        	<script>$('#Device_link').html(get_words('_DevLink'))</script>
                        </tr>
                        <tr>
							<td align="right" bgcolor="#FFFFFF"><span id="folder"></span> : </td><td align="left" bgcolor="#FFFFFF">&nbsp;&nbsp;<input type="text" id="folder_path" name="folder_path" /><input type="button" id="browse" name="browse" value="" onClick="browser_folder()" /></td>
							<script>$('#browse').val(get_words('_browse'));</script>
							<script>$('#folder').html(get_words('_folder'))</script>
                        </tr>
                        <tr>
							<td align="right" bgcolor="#FFFFFF"><span id="Permission"></span> : </td><td align="left" bgcolor="#FFFFFF">&nbsp;&nbsp;<select size="1" id="append_permission" name="append_permission" /></td>
							<script>$('#Permission').html(get_words('sto_permi'))</script>
                        </tr>
                        <tr>
                        	<td align="center" bgcolor="#FFFFFF"></td>
							<td align="left" bgcolor="#FFFFFF" colspan="2">&nbsp;&nbsp;<input type="button" id="append" name="append" onClick="append_rule()" value="" /></td>
							<script>$('#append').val(get_words('_append'));</script>
                        </tr>
                        <p><input type="hidden" name="all_field" id="all_field" value="" /></p>
                        <tr>
                        	<td align="center" bgcolor="#FFFFFF"></td>
							<td align="left" bgcolor="#FFFFFF">
							&nbsp;&nbsp;&nbsp;<input type="button" id="append_ok" name="append_ok" onClick="save_append()" value="">
								<script>$('#append_ok').val(get_words('_ok'));</script>
							&nbsp;&nbsp;<input type="button" id="append_cancel" name="append_cancel" onClick="close_append()" value="">
								<script>$('#append_cancel').val(get_words('_cancel'));</script>
							</td>
                        </tr>
                        
                    </table>
					</div>
					<div style="display" id="browser_folder" title="" align="center">
						<div id="color_set" align="left">
							<!-- I can work normal-->	
							<div id="browser_ctx" ></div>
						</div>
						<table width="98%" border="0" align="center" bgcolor="#333333" cellspacing="0">
						<tr height="100%">
							<td width="18%" valign="top" bgcolor=#ffffff >
							</td>
						</tr>
						<tr>
                        <td align="left" bgcolor="#FFFFFF">
							&nbsp;&nbsp;&nbsp;<input type="button" id="ok" name="ok" onClick="set_folder()" value="">
								<script>$('#ok').val(get_words('_ok'));</script>
							&nbsp;&nbsp;<input type="button" id="cancel1" name="cancel1" onClick="close_browser()" value="">
								<script>$('#cancel1').val(get_words('_cancel'));</script>
							</td>
						</tr>
                    </table>
					</div>
					
				</div>
			</td>
		</form>
		
		<td valign="top" width="150" id="sidehelp_container" align="left">
			<table cellSpacing=0 cellPadding=2 bgColor=#ffffff border=0>
				<tr>
					<td id=help_text>
						<strong><script>show_words('_hints')</script>&hellip;</strong> 
						<p><script>show_words('sto_help')</script></p>
						<p class="more"><a href="support_internet.asp#storage" onclick="return jump_if();"><script>show_words('_more')</script>&hellip;</a></p>
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
	loadSettings();
	disable_storage();
//	prepare_wa_link();
	set_form_default_values("form1");

/*
	if (login_Info != "w") {
		DisableEnableForm(form1,true);	
		$('#email_now').attr('disabled',true);
	}
*/
</script>
</html>
