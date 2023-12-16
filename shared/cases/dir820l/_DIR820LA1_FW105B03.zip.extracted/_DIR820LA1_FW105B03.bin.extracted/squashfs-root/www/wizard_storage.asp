<html>
<head>
<title></title>
<style type="text/css">
/*
 * Styles used only on this page.
 * WAN mode radio buttons
 */
#wan_modes p {
	margin-bottom: 1px;
}
#wan_modes input {
	float: left;
	margin-right: 1em;
}
#wan_modes label.duple {
	float: none;
	width: auto;
	text-align: left;
}
#wan_modes .itemhelp {
	margin: 0 0 1em 2em;
}

#color_set{	background-color:#ffffff; width:98%}

/*
 * Wizard buttons at bottom wizard "page".
 */
#wz_buttons {
	margin-top: 1em;
	border: none;
}
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
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();
	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;
	var auth 		= miscObj.config_val("graph_auth");
	document.title = get_words('TEXT000');
	
	var pageNameArray = new Array('p0',  'p1a',   'p1',   'p2',      'p3',   'p4',		'p4a',    'p5');
	var pageDescArray = new Array('usb', 'error', 'user', 'folder' , 'ddns', 'check',	'p3_err', 'save');
	var wz_curr_page=0;
	var wz_prev_page=0;
	var wz_next_page=1;
	var count=30;
	var progressBarMaxWidth = 500;
	var null_count=0;
	var fqdn='';
	var device;
	var sendSubmit  = false;
	var save_ddns = false;
	
	//for folder browse test: get rid of it
	var waObj = new ccpObject();
	var folder_param = {
		url: 'web_access.ccp',
		arg: 'ccp_act=get&file_type=3&get_path=/'
	};
	waObj.get_config_obj(folder_param);

	var cur_path = '/';
	var dev_qty = waObj.config_val("usb_quantity");
	var folder_path_list = waObj.config_str_multi("dir_path");
	var file_path_list = waObj.config_str_multi("file_path");
	var folder_list = waObj.config_str_multi("dir");
	var file_list = waObj.config_str_multi("file");
	var folders;
	
	var mainObj = new ccpObject();
	var	param = {
		url: "get_set.ccp",
		arg: "ccp_act=get&num_inst=5"+
			"&oid_1=IGD_&inst_1=1000"+
			"&oid_2=IGD_Storage_&inst_2=1100"+
			"&oid_3=IGD_Storage_User_i_&inst_3=1100"+
			"&oid_4=IGD_WANDevice_i_DynamicDNS_&inst_4=1110"+
			"&oid_5=IGD_WANDevice_i_WANStatus_&inst_5=1110"
	};
	mainObj.get_config_obj(param);
	
	var user_inst = mainObj.config_inst_multi("IGD_Storage_User_i_");
	var ary_user_name = mainObj.config_str_multi("igdStorageUser_Username_");
	var access_port = mainObj.config_val('igdStorage_Http_Remote_Access_Port_');
	var wanIp = mainObj.config_val('igdWanStatus_IPAddress_');
	var ddns_serv = mainObj.config_val('ddnsCfg_DDNSServer_');
	
	function onPageLoad()
	{
		//$('#ddns_server').val(ddns_serv);
		 $('#folder_path').val("/");
	}
	
	var submit_button_flag = 0;
	
	function send_request(){
		var submitObj = new ccpObject();
		var submitData = "";
		var paramSet = 
		{
			url: "get_set.ccp",
			arg: "ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=storage_setup.asp"	//CCP_SUB_WEBACCESS
		};
		
		submitData += "&igdStorage_Enable_1.1.0.0=1";
		// do not enable remote access cuz following shareport spec
		submitData += "&igdStorage_Http_Remote_Access_Enable_1.1.0.0=0";
		
		if(user_inst == null)
		{
			submitData += "&igdStorageUser_Username_1.1.1.0="+ $("#user").val();
			submitData += "&igdStorageUser_Password_1.1.1.0="+ $("#pwd1").val();
			submitData += '&igdStorageUserRule_Device_1.1.1.1='+ $("#folder_path").val();
			submitData += '&igdStorageUserRule_AccessPath_1.1.1.1='+ encodeURIComponent($('#folder_path').val());
			submitData += '&igdStorageUserRule_Permission_1.1.1.1=1';
		}
		else 
		{			
			for(var i=0;i<user_inst.length;i++)
			{
				if(ary_user_name[i] == "")
				{
					null_count = i+1;
					break;
				}
			}	

			if(null_count >= 9)
			{
				alert(get_words('MSG055'));
				return;
			}
			else
			{
					submitData += "&igdStorageUser_Username_1.1."+(null_count)+".0="+ $("#user").val();
					submitData += "&igdStorageUser_Password_1.1."+(null_count)+".0="+ $("#pwd1").val();
					submitData += '&igdStorageUserRule_Device_1.1.'+(null_count)+'.1='+ $("#folder_path").val();
					submitData += '&igdStorageUserRule_AccessPath_1.1.'+(null_count)+'.1=' + encodeURIComponent($('#folder_path').val());
					submitData += '&igdStorageUserRule_Permission_1.1.'+(null_count)+'.1=1';
			}
		}
		
		if(save_ddns)
		{
			submitData += "&ddnsCfg_DDNSEnable_1.1.1.0=1";
			submitData += "&ddnsCfg_HostName_1.1.1.0="+$('#ddns_hostname').val();
			submitData += "&ddnsCfg_Username_1.1.1.0="+$('#ddns_username').val();
			submitData += "&ddnsCfg_Password_1.1.1.0="+$('#ddns_password1').val();
		}
		paramSet.arg += submitData;
		submitObj.get_config_obj(paramSet);
		
	}
	
	function wizard_cancel(){
		if (is_form_modified("formAll")){
			if(!confirm(get_words('_wizquit'))) {
				return false;
			}
		}
		window.location.href="storage_setup.asp"; 
	}

	function displayPage(page)
	{
		for(var i=0; i < pageNameArray.length; i++)
		{
			if(pageNameArray[i] == page)
			{
				get_by_id(pageNameArray[i]).style.display = "";
			}
			else
				get_by_id(pageNameArray[i]).style.display = "none";
		}
	}
	
	function next_page(isNeedSkip)
	{
		try {
				if(eval("verify_wz_page_"+pageNameArray[wz_curr_page])() == false) 
					return;
		} catch (e) {
			// the verify function is not exist
		}
			
		wz_prev_page = wz_curr_page;
		if(isNeedSkip=="skip")
			wz_curr_page +=2;
		else
			wz_curr_page ++;
		displayPage(pageNameArray[wz_curr_page]);
	}
	
	function prev_page()
	{
		//wz_curr_page = wz_prev_page;		
		if(wz_prev_page ==1 || wz_curr_page ==2) 
			wz_curr_page = 0;
		else if(wz_prev_page ==5 ||wz_prev_page==6)
			wz_curr_page = 4;
		else 
			wz_curr_page --;
		wz_prev_page = wz_curr_page;
		displayPage(pageNameArray[wz_curr_page]);
	}
	
	function get_disk_info()
	{
		var diskObj = new ccpObject();
		var param1 = {
			url: "web_access.ccp",
			arg: "ccp_act=get_disk_info&file_type=3&get_path=/"
		};
		diskObj.get_config_obj(param1);
		var disk_info = diskObj.config_str_multi("disk_info");
		if(disk_info != null)
				wz_curr_page=1; //success
		else
				wz_curr_page=0; //go to error page
	}
	
	//detect USB storage
	function verify_wz_page_p0()
	{
		get_disk_info();
		$("#next_p0").attr('disabled',false);
		return true;
	}
	
	//retry detecting USB storage
	function verify_wz_page_p1a()
	{
		get_disk_info();
		$("#next_p1a").attr('disabled',false);
		return true;
	}
	
	function verify_wz_page_p1()
	{
		if($("#user").val() == "")
		{
			alert(get_words('sh_port_msg_01'));
			return false;
		}
		
		if(($("#user").val() == "admin") || ($("#user").val() == "guest"))
		{
			alert(get_words('sto_03'));
			return false;
		}

		if (!check_name($("#user").val()))
		{
			alert(get_words('GW_SMTP_USERNAME_INVALID'));
			return false;
		}
		
		for (var i=0;i<9;i++)
		{
			if ($("#user").val() == ary_user_name[i])
			{
				alert(get_words('sto_03'));
				return false;
			}
		}
		
		if($("#pwd1").val() == "" || $("#pwd2").val() == "")
		{
			alert(get_words('sh_port_msg_02'));
			return false;
		}
			
		if(($("#pwd1").val()!="") && (is_ascii($("#pwd1").val())==false))
		{
			alert(get_words('S493'));
			return false;
		}
		
		//if ($("#pwd1").val() != $("#pwd2").val()){ //check_pwd
		if(!check_pwd("pwd1","pwd2")){
			//alert(get_words('sh_port_msg_04'));
			return false;
		}
		
		$("#acc_name").html($("#user").val());
		$("#passwd").html($("#pwd1").val());
		
		return true;
	}
	
	function verify_wz_page_p2()
	{
		if($("#folder_path").val()=="")
		{
			alert(get_words('sh_port_msg_05'));
			return false;
		}
		device = $('#folder_path').val().split('/');
		return true;
	}
	
	function verify_wz_page_p3()
	{
		save_ddns=false;
/*		if ($('#ddns_server').val() == "") 
		{
			alert(get_words('srv_name_empty'));
			return false;
		}
*/		if($("#ddns_hostname").val() =="" && $("#ddns_username").val() =="" && $("#ddns_password1").val() =="")
		{
			// $("#remote_link").hide();
			wz_curr_page+=2;
		}
		else
		{
			// $("#remote_link").show();
			if($("#ddns_hostname").val() =="")
			{
				alert(get_words('sh_port_msg_06'));
				return false;
			}
			if($("#ddns_username").val() =="")
			{
				alert(get_words('sh_port_msg_07'));
				return false;
			}
			if($("#ddns_password1").val() =="")
			{
				alert(get_words('sh_port_msg_08'));
				return false;
			}

			var paramForm = {
				url: "ddns_check.ccp",
				arg: 'ccp_act=doCheck'
			};
			paramForm.arg += "&ddnsHostName="+$('#ddns_hostname').val();
			paramForm.arg += "&ddnsUsername="+$('#ddns_username').val();
			paramForm.arg += "&ddnsPassword="+$('#ddns_password1').val();
			ajax_submit(paramForm);
		
			count = 30;
			setTimeout('get_conn_st()',1000);
			$('#progressbar').width(0);
			draw_progress_bar();
		
		}
		$("#local_access").html('<a href="http://dlinkrouter:'+access_port+ '" target="_blank">http://dlinkrouter:'+access_port+'</a>'
								+get_words('sh_port_tx_16')
								+'<a href="http://dlinkrouter.local:'+access_port+ '" target="_blank">http://dlinkrouter.local:'+access_port+'</a>');
		//$("#local_access").html('http://dlinkrouter:'+access_port+ " " +get_words('sh_port_tx_16')+ " " +'http://dlinkrouter:'+access_port);
		//$("#remote_access").html('http://'+$('#ddns_hostname').val()+':'+access_port);
		return true;
	}
	
	function verify_wz_page_p4()
	{
		save_ddns = true;
		fqdn = $('#ddns_hostname').val();
		// $("#remote_access").html('<a href="http://'+fqdn+':'+access_port+ '" target="_blank">http://'+fqdn+':'+access_port+'</a>');			
		return true;
	}
	
	function browser_folder()
	{
		var str = '<ul id="browser" class="filetree">'+
				'		<li><span class="folder" id="__" >'+ get_words('webf_hd') +'</span>'+
				'		<ul id="_" url="req_subfolder(\'/\', \'_\', \'1\')" clr="req_ctx(\'/\', \'_\')"></ul>'+
				'		</li>'+
				'	</ul>	';

		$('#browser_folder').dialog({'modal': true, width: 500, height: 400});
		$('#browser_folder').dialog("open");
		$('#browser_ctx').html(str);
		prepare_treeview('browser');
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
		
		req_ctx(path, ulId);
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
	
	function req_ctx(path, ulId)
	{
		path = path.replace(/%27/ig, "'");
		var ary = '';
		var sto_num = '';
		var sto_value = '';
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
			//set_selectIndex(dcount, get_by_id("dev_link"));
		}
		else
		{
			d_len = path_ary[0].length;
			if(d_len != 0)
				dcount = path_ary[0];
			else
				dcount = 0;
			
			//set_selectIndex(dcount, get_by_id("dev_link"));
			
			//for(var i=1;i<path_ary.length;i++)
			//{
			//	if(i == 1)
			full_path = "/"+path;
			//	else
			//		full_path += "/"+path_ary[i];
				
			//}
		}

		$('#folder_path').val(full_path);
		
		cur_path = path;
	}
	
	function sto_name_trim(str, init)
	{
		var len = parseInt(str.length);
		var init_addr = parseInt(init);
		str = str.substring(init_addr, len);
		return str.toUpperCase();
	}
	
	function transUid(uid)
	{
		return uid.replace(/[@\$\.\ \/]/g, function(c) { return ('\\'+c); });
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
	
	function get_conn_st()	//20120417 silvia add
	{
		var conn_st = query_wan_connection();
		if(conn_st == "true")
			get_wan_st();
		else{
		
			if (count <= 0){
				//alert("No Internet!");
				setTimeout('next_page()', 2000);
				return;
			}else{
				count--;
				setTimeout('get_conn_st()',1000);
			}
		}
	}

	//20120419 silvia add, new chk wan reserve act
	function get_wan_st()
	{
		if(count==0){
			//alert("No Internet!");
			setTimeout('next_page()', 2000);
			return;
		}
		
		var time=new Date().getTime();
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	"mdl_check.ccp",
			data: 	"act=getwanst"+"&"+time+"="+time,
			success: function(data) {
				if (data.indexOf('false') != -1)
				{
					count--;
					setTimeout('get_wan_st()', 1000);
				}
				else{
					chk_ddnslink();
				}
			}
		};
		try {
				$.ajax(ajax_param);
		} catch (e) {
		}
	}

	function query_wan_connection()
	{
		var pingObj = new ccpObject();
		var paramQuery = {
			url: "ping.ccp",
			arg: "ccp_act=queryWanConnect"
		};
		
		pingObj.get_config_obj(paramQuery);
		var ret = pingObj.config_val("WANisReady");
		return ret;
	}
	
	function chk_ddnslink()
	{		
		if(count==0){
			//alert("No Internet!");
			setTimeout('next_page()', 2000);
			return;
		}
		
		var ddnsObj = new ccpObject();
		var paramForm = {
			url: "ddns_check.ccp",
			arg: 'ccp_act=getResult'
		};
		ddnsObj.get_config_obj(paramForm);
		
		var ret = ddnsObj.config_val("DdnsCheckResult");
		
		if(ret == "" || ret == null)
		{
			count--;
			setTimeout('chk_ddnslink()', 1500);
		}
			
		if(ret == "OK")
			setTimeout('next_page(\"skip\")', 2000);
		else if(ret == "FAIL")			
			setTimeout('next_page()', 2000);
			
/*		if (ddns_status == "1")
			fqdn = $('#ddns_hostname').val();
		else
			fqdn = wanIp;
*/		
	}

	function draw_progress_bar()
	{
		var curWidth = $('#progressbar').width();
		var fieldWidth = curWidth + (progressBarMaxWidth-curWidth)/10;
	
		if (progressBarMaxWidth-curWidth <= 5) {
			$('#progressbar').width(progressBarMaxWidth);
			return;
		}

		if ($('#progressbar').width() < progressBarMaxWidth) {
			$('#progressbar').width(fieldWidth);
			setTimeout('draw_progress_bar()', 1000);
		}
	}
	
/*	function do_copy_serv()
	{
		if ($('#ddns_type_sel').val() != 'def_selection')
			$('#ddns_server').val($('#ddns_type_sel').val());
	}
*/	
	$(document).ready(function() {
		$('#next_p0').click(function() {
			$("#next_p0").attr('disabled',true);
		});
		
		$('#next_p1a').click(function() {
			$("#next_p1a").attr('disabled',true);
		});
		/*
		$('#prev_p5').click(function() {
			count = 15;
			setTimeout('get_conn_st()',1000);
			$('#progressbar').width(0);
			draw_progress_bar();
		});
		*/
		
	});
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
		<table width="650" border="0">
		<tr>
			<td>
		<form id="formAll" name="formAll">
<!-------------------------------->
<!--     start of page 0        -->
<!-------------------------------->
      	<div class=box id="p0" style="display:none"> 
            <h2 align="left"></h2>
            <p class="box_msg"><script>show_words('sh_port_tx_07')</script></p>
			<div align="center">
				<img src="image/shareport_usb.png" width="400" height="120">
			</div>
			<div> 
				<table align="center" class="formarea">
				<tr>
					<td>
					<input type="button" class="button_submit" id="next_p0" name="next_p0" value="" onClick="setTimeout('next_page()',2000);">
					<input type="button" class="button_submit" id="cancel_p0" name="cancel_p0" value="" onClick="wizard_cancel();">
					<script>$("#next_p0").val(get_words('_next'));</script>
					<script>$("#cancel_p0").val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			</div>
        </div>
<!-------------------------------->
<!--     End of page 0          -->
<!-------------------------------->

<!-------------------------------->
<!--     Start of page 1a       -->
<!-------------------------------->
		<div class=box id="p1a" style="display:none"> 
			<h2 align="left">
				<script>show_words('_error')</script>
			</h2>
			<!--
			<form id="form1" name="form1" method="post" action="">		
			-->
			<table align="center" class="formarea">
				<tr>
					<td><p><strong><script>show_words('sh_port_tx_08')</script></strong></p></td>
				</tr>
			</table>
			<br>
			<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="next_p1a" name="next_p1a" value="" onClick="setTimeout('next_page()',2000);"> 
						<input type="button" class="button_submit" id="cancel_p1a" name="cancel_p1a" value="" onclick="wizard_cancel();"> 
						<script>$("#next_p1a").val(get_words('TEXT073'));</script>
						<script>$("#cancel_p1a").val(get_words('_cancel'));</script>
					</td>
				</tr>
			</table>
			<!--</form>-->
		</div>
<!-------------------------------->
<!--       End of page 1a       -->
<!-------------------------------->
<!-------------------------------->
<!--     Start of page 1        -->
<!-------------------------------->
		<div class=box id="p1" style="display:none"> 
			<h2 align="left">
				<!--<script>show_words('wwa_title_s1')</script>-->
			</h2>
			<p class="box_msg"><script>show_words('sh_port_tx_09')</script></p>
			<!--
			<form id="form1" name="form1" method="post" action="">		
			-->
				<table class=formarea>
				<tr>
					<td align=right class="duple"><script>show_words('te_Acct')</script>:</td>
					<td>&nbsp;<input type="text" id=user name=user size=20 maxlength=15 value=''></td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_password')</script>:</td>
					<td>&nbsp;<input type="password" id=pwd1 name=pwd1 size=20 maxlength=15 value=''></td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_verifypw')</script>:</td>
					<td>&nbsp;<input type="password" id=pwd2 name=pwd2 size=20 maxlength=15 value=''></td>
				</tr>
				</table>
				<br>
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="prev_p1" name="prev_p1" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_p1" name="next_p1" value="" onClick="next_page();"> 
						<input type="button" class="button_submit" id="cancel_p1" name="cancel_p1" value="" onclick="wizard_cancel();"> 
						<script>$("#prev_p1").val(get_words('_prev'));</script>
						<script>$("#next_p1").val(get_words('_next'));</script>
						<script>$("#cancel_p1").val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			<!--</form>-->
		</div>
<!-------------------------------->
<!--       End of page 1        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 2       -->
<!-------------------------------->
		<div class=box id="p2" style="display:none"> 
			<h2 align="left">
				<!--<script>show_words('wwa_title_s2')</script>-->
			</h2>
			<p class="box_msg"><script>show_words('sh_port_tx_10')</script></p>
			<!--
			<form id="form2" name="form2" method="post" action="">		
			-->
				<table class=formarea align="center">
				<tr>
					<td>&nbsp;<input type="text" id=folder_path name=folder_path size=60 maxlength=15 value='' readonly></td>
					<!--<td><input type="file" id="file" name="file" /><br>-->
					&nbsp;<td><input type="button" id="select" name="select" value="" onclick="browser_folder();"></td>
					<script>$("#select").val(get_words('sh_port_tx_21'));</script>
				</tr>
				</table>
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="prev_p2" name="prev_p2" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_p2" name="next_p2" value="" onClick="next_page();"> 
						<input type="button" class="button_submit" id="cancel_p2" name="cancel_p2" value="" onclick="wizard_cancel();"> 
						<script>$("#prev_p2").val(get_words('_prev'));</script>
						<script>$("#next_p2").val(get_words('_next'));</script>
						<script>$("#cancel_p2").val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
			<!--</form>-->
		</div>
		<div style="display:none" id="browser_folder" title="" align="center">
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
<!-------------------------------->
<!--       End of page 2        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 3       -->
<!-------------------------------->
		<div class=box id="p3" style="display:none"> 
			<h2>
				<!--<script>show_words('wwa_title_s3')</script>-->
			</h2>
			<div> 
				<p class="box_msg"><script>show_words('sh_port_ddns_01')</script><a href="http://www.DLinkDDNS.com" target="_blank">www.DLinkDDNS.com</a></p>
			</div>
			<div> 
				<!--
				<form id="form3" name="form3" method="post" action="">
				-->
<!--				<table align="center" class="formarea">
				<tr>
					<td>
						<select id="ddns_type_sel" name="ddns_type_sel" tabindex=2>
							<option value='def_selection'>Select Dynamic DNS Server</option>
							<option value="dlinkddns.com(Free)">dlinkddns.com(Free)</option>
							<option value="dyndns.com(Custom)">dyndns.com(Custom)</option>
							<option value="dyndns.com(Free)">dyndns.com(Free)</option>
						</select>
					</td>
					<td><input type="button" id="copy_serv" value=">>" onclick="do_copy_serv()" style="width:32"></td>
					<td><input type="text" id="ddns_server" name="ddns_server"></td>
				</tr>
				</table>  -->
				<table class="formarea">
				<tr>
					<td  align=right class="duple"><script>show_words('_hostname')</script>:</td>
					<td>&nbsp;<input type="text" id=ddns_hostname name=ddns_hostname size=20 maxlength=64 value=''></td>
				</tr>
				<tr>
					<td  align=right class="duple"><script>show_words('sh_port_tx_19')</script>:</td>
					<td>&nbsp;<input type="text" id=ddns_username name=ddns_username size=20 maxlength=64 value=''></td>
				</tr>
				<tr>
					<td  align=right class="duple"><script>show_words('sh_port_tx_20')</script>:</td>
					<td>&nbsp;<input type="password" id=ddns_password1 name=ddns_password1 size=20 maxlength=64 value=''></td>
				</tr>
				</table>
				<br>
				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="prev_p3" name="prev_p3" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_p3" name="next_p3" value="" onClick="next_page();"> 
						<input type="button" class="button_submit" id="cancel_p3" name="cancel_p3" value="" onclick="wizard_cancel();"> 
						<script>$("#prev_p3").val(get_words('_prev'));</script>
						<script>$("#next_p3").val(get_words('_next'));</script>
						<script>$("#cancel_p3").val(get_words('_cancel'));</script>
					</td>
				</tr>
				</table>
				<!--</form>-->
			</div>
		</div>
<!-------------------------------->
<!--       End of page 3        -->
<!-------------------------------->

<!-------------------------------->
<!--     Start of page 4a       -->
<!-------------------------------->
		<div class=box id="p4a" style="display:none"> 
			<h2 align="left"><script>show_words('sh_port_ddns_02')</script></h2>
			<!--
			<form id="form1" name="form1" method="post" action="">		
			-->
			<table align="center" class="formarea">
				<tr>
					<td><p><script>show_words('sh_port_tx_24')</script></p></td>
				</tr>
			</table>
			<br>
			<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="prev_p4a" name="prev_p4a" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_p4a" name="next_p4a" value="" onClick="next_page();"> 
						<!--<input type="button" class="button_submit" id="cancel_p4a" name="cancel_p4a" value="" onclick="wizard_cancel();"> -->
						<script>$("#prev_p4a").val(get_words('_back'));</script>
						<script>$("#next_p4a").val(get_words('_cancel'));</script>
						<!--<script>$("#cancel_p4a").val(get_words('_cancel'));</script>-->
					</td>
				</tr>
			</table>
			<!--</form>-->
		</div>
<!-------------------------------->
<!--       End of page 4a       -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 4       -->
<!-------------------------------->
		<div class=box id="p4"  style="display:none"> 
			<h2 align="left"><script>show_words('sh_port_ddns_02')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('sh_port_ddns_03')</script></p>
				<!--
				<form id="form4a" name="form4a" method="post" action="">
				-->
				<div align="center">
				<div align="left" style="width:500;border:3px solid #000000" >
					<div id="progressbar" style="background-color: #FF6F00;">&nbsp;</div>
				</div>
				</div>
					<div>
						<table align="center" class=formarea>
							<td>
								<input type="button" class="button_submit" id="prev_p4" name="prev_p4" value="" onclick="prev_page();" disabled> 
								<input type="button" class="button_submit" id="next_p4" name="next_p4" value="" onClick="next_page();" disabled> 
								<input type="button" class="button_submit" id="cancel_p4" name="cancel_p4" value="" onclick="wizard_cancel();"> 
								<script>$("#prev_p4").val(get_words('_prev'));</script>
								<script>$("#next_p4").val(get_words('_next'));</script>
								<script>$("#cancel_p4").val(get_words('_cancel'));</script>
							</td>
						</table>
					</div>
				<!--</form>-->
			</div>
		</div>
<!-------------------------------->
<!--       End of page 4        -->
<!-------------------------------->

<!-------------------------------->
<!--      Start of page 5       -->
<!-------------------------------->
		<div class=box id="p5"  style="display:none"> 
			<h2 align="left"><script>show_words('_setupdone')</script></h2>
			<div align="left">
				<div> 
					<P align="left" class=box_msg>
						<strong><script>show_words('sh_port_tx_00')</script></strong>&nbsp;<script>show_words('sh_port_tx_11')</script>
					</P>
					<table align="center" class=formarea >
						<tr>
							<td>
							<p><strong><script>show_words('sh_port_tx_12')</script>:</strong>&nbsp;<span id="local_access"></span></p>
							<!-- <div id="remote_link">
							<p><strong><script>show_words('sh_port_tx_13')</script>:</strong>&nbsp;<span id="remote_access"></span></p>
							</div> -->
							<p><strong><script>show_words('te_Acct')</script>:</strong>&nbsp;<span id="acc_name"></span></p>
							<p><strong><script>show_words('_password')</script>:</strong>&nbsp;<span id="passwd"></span></p>
							</td>
						</tr>
					</table>
					<table  align="center" class=formarea >
					<br>
						<tr>
							<td>    
								<input type="button" class="button_submit" id="prev_p5" name="prev_p5" value="" onclick="prev_page();"> 
								<input type="button" class="button_submit" id="save_p5" name="save_p5" value="" onClick="return send_request()">
								<input type="button" class="button_submit" id="cancel_p5" name="cancel_p5" value="" onclick="wizard_cancel();"> 
								<script>$("#prev_p5").val(get_words('_prev'));</script>
								<script>$("#save_p5").val(get_words('_save'));</script>
								<script>$("#cancel_p5").val(get_words('_cancel'));</script>
							</td>
							<br>
						</tr>
					</table>
					<table align="center" class="formarea" style="display:none;">
						<tr>
							<td>
								<strong><script>show_words('sh_port_tx_18')</script></strong>
							</td>
						</tr>
					</table>
						<div align="center"></div>
					<!--</form>-->
				</div>
			</div>
		</div>
<!-------------------------------->
<!--       End of page 5        -->
<!-------------------------------->
	  </form>
			</td>
		</tr>
		</table>
		<p>&nbsp;</p>

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
	set_form_default_values("formAll");
	displayPage("p0");
</script>
</html>