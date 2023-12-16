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
	
	var pageNameArray = new Array('p0'	, 'p1', 'p2'  , 'p3'	  , 'p4a'  , 'p4b'   , 'p4c'  , 'p4d' , 'p4e' 	 , 'p5');
	var pageDescArray = new Array('main', 'pw', 'time', 'wantype' , 'dhcpc', 'static', 'pppoe', 'pptp', 'l2tp',  'save');
	var wz_curr_page=0;
	var wz_prev_page=0;
	var wz_next_page=1;
	
	var mainObj = new ccpObject();
	var	param = {
		url: "get_set.ccp",
		arg: "ccp_act=get&num_inst=12"+
			"&oid_1=IGD_&inst_1=1000"+
			"&oid_2=IGD_Time_&inst_2=1100"+
			"&oid_3=IGD_LANDevice_i_LANHostConfigManagement_&inst_3=1110"+
			"&oid_4=IGD_WANDevice_i_&inst_4=1100"+
			"&oid_5=IGD_WANDevice_i_StaticIP_&inst_5=1110"+
			"&oid_6=IGD_WANDevice_i_DHCP_&inst_6=1110"+
			"&oid_7=IGD_WANDevice_i_PPPoE_i_&inst_7=1110"+
			"&oid_8=IGD_WANDevice_i_PPTP_&inst_8=1110"+
			"&oid_9=IGD_WANDevice_i_PPTP_ConnectionCfg_&inst_9=1111"+
			"&oid_10=IGD_WANDevice_i_L2TP_&inst_10=1110"+
			"&oid_11=IGD_WANDevice_i_L2TP_ConnectionCfg_&inst_11=1111"+
			"&oid_12=IGD_AdministratorSettings_LoginInfo_i_&inst_12=1110"
	};
	mainObj.get_config_obj(param);
	
	var already_clone = mainObj.config_val("wanDev_MACAddressOverride_");
	var hw_mac = mainObj.config_val("wanDev_MACAddressClone_");	
	var hw_mac_org = hw_mac;
	var cli_mac 	= dev_info.cli_mac;
	var wan_mac		= dev_info.wan_mac;

	var adminpwd = mainObj.config_val("loginInfo_Password_");
	var gTimezoneIdx = mainObj.config_val("sysTime_LocalTimeZoneIndex_");
	var lanCfg = {
		'lanIp':		mainObj.config_val('lanHostCfg_IPAddress_'),
		'lanSubnet':	mainObj.config_val('lanHostCfg_SubnetMask_'),
		'lanDhcp':		mainObj.config_val('lanHostCfg_DHCPServerEnable_'),
		'lanMinAddr':	mainObj.config_val('lanHostCfg_MinAddress_'),
		'lanMaxAddr':	mainObj.config_val('lanHostCfg_MaxAddress_')
	};

	var wanCfg = {
		'wanMode':			mainObj.config_val('wanDev_CurrentConnObjType_'),
		'wanMac':			mainObj.config_val('wanDev_MACAddressClone_')?mainObj.config_val('wanDev_MACAddressClone_'):wan_mac,
		'wanMacCloned':		mainObj.config_val('wanDev_MACAddressOverride_'),

		'wanStaticIp':		mainObj.config_val('staticIPCfg_ExternalIPAddress_'),
		'wanStaticSubnet':	mainObj.config_val('staticIPCfg_SubnetMask_'),
		'wanStaticGw':		mainObj.config_val('staticIPCfg_DefaultGateway_'),
		'wanStaticDns':		mainObj.config_val('staticIPCfg_DNSServers_'),
		
		'wanPppoeType':		mainObj.config_val('pppoeCfg_IPAddressType_'),
		'wanPppoeAddr':		mainObj.config_val('pppoeCfg_ExternalIPAddress_'),
		'wanPppoeName':		mainObj.config_val('pppoeCfg_Username_')? mainObj.config_val('pppoeCfg_Username_'):"",
		'wanPppoePass':		mainObj.config_val('pppoeCfg_Password_'),
		'wanPppoeServ':		mainObj.config_val('pppoeCfg_ServiceName_')? mainObj.config_val('pppoeCfg_ServiceName_'):"",
		
		'wanDhcpHost':		mainObj.config_val('dhcpCfg_HostName_')? mainObj.config_val('dhcpCfg_HostName_'):"",
		
		'wanPPTPType':		mainObj.config_val('pptpCfg_IPAddressType_'),
		'wanPPTPAddr':		mainObj.config_val('pptpCfg_ExternalIPAddress_'),
		'wanPPTPMask':		mainObj.config_val('pptpCfg_SubnetMask_'),
		'wanPPTPGw':		mainObj.config_val('pptpCfg_DefaultGateway_'),
		'wanPPTPServ':		mainObj.config_val('pptpConn_ServerIP_'),
		'wanPPTPName':		mainObj.config_val('pptpConn_Username_'),
		'wanPPTPPass':		mainObj.config_val('pptpConn_Password'),
		
		'wanL2TPType':		mainObj.config_val('l2tpCfg_IPAddressType_'),
		'wanL2TPAddr':		mainObj.config_val('l2tpCfg_ExternalIPAddress_'),
		'wanL2TPMask':		mainObj.config_val('l2tpCfg_SubnetMask_'),
		'wanL2TPGw':		mainObj.config_val('l2tpCfg_DefaultGateway_'),
		'wanL2TPServ':		mainObj.config_val('l2tpConn_ServerIP_'),
		'wanL2TPName':		mainObj.config_val('l2tpConn_Username_'),
		'wanL2TPPass':		mainObj.config_val('l2tpConn_Password')
	};

	function onPageLoad()
	{
		get_by_id('pwd1').value = adminpwd;
		get_by_id('pwd2').value = adminpwd;
		
	}
	function clone_mac_action(obj){
		get_by_id(obj).value = cli_mac;
		already_clone = 1;
	}

	var submit_button_flag = 0;
	function send_request(){
		var login_who=dev_info.login_info;
		
		if(login_who!= "w")
		{
			//window.location.href ="index.asp";
			window.location.href ="user_page.asp";
			return false;
		}
		else
		{	
			var submitObj = new ccpObject();
			var paramStr = "";
			paramStr += "&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY";
			paramStr += "&nextPage=sel_wan.asp";
			paramStr += "&loginInfo_Username_1.1.1.0=admin&loginInfo_Password_1.1.1.0=" + urlencode(get_by_id("pwd1").value);
			paramStr += "&sysTime_LocalTimeZone_1.1.0.0=" + get_by_id("tzone").value;
			paramStr += "&sysTime_LocalTimeZoneName_1.1.0.0=" + get_by_id("tzone").options[get_by_id("tzone").selectedIndex].text
			paramStr += "&sysTime_LocalTimeZoneIndex_1.1.0.0=" + get_by_id("tzone").selectedIndex;
			
			switch(get_checked_value(get_by_name('wan_type')))
			{
				case "dhcpc":
					paramStr += constructParamDHCPC();
					break;
				case "static":
					paramStr += constructParamStaticIP();
					break;
				case "pppoe":
					paramStr += constructParamPPPoE();
					break;
				case "pptp":
					paramStr += constructParamPPTP();
					break;
				case "l2tp":
					paramStr += constructParamL2TP();
					break;
			}
			
			var paramSubmit = {
				url: "get_set.ccp",
				arg: 'ccp_act=set'
			};	
			paramSubmit.arg += paramStr;
			if(submit_button_flag == 0){
				submitObj.get_config_obj(paramSubmit);
				submit_button_flag = 1;
				return true;
			}else{
				return false;
			}
		}
	}
	
	function wizard_cancel(){
		if (is_form_modified("formAll")){
			if(!confirm(get_words('_wizquit'))) {
				return false;
			}
		}
		window.location.href="wizard_internet.asp";
	}

	function select_wan_type(){
		set_checked(get_by_id("select_isp").value, get_by_name("wan_type"));
	}
	
	function displayPage(page)
	{
		for(var i=0; i < pageNameArray.length; i++)
		{
			if(pageNameArray[i] == page)
			{
				get_by_id(pageNameArray[i]).style.display = "";
				if((i >= 6) && (i <=8))
				{
					show_static_ip(mapPage2WanType(page));
				}
			}
			else
				get_by_id(pageNameArray[i]).style.display = "none";
		}
		
		//var indexPage = pageNameArray.indexOf(page);
		/*
		var indexPage = pageNameArray.indexOf(searchElement[, 0]);
		if((indexPage >= 6) && (indexPage <=8))
		{
			show_static_ip(mapPage2WanType(page));
		}
		*/
	}
	
	function mapPage2WanType(pageId)
	{
		switch(pageId)
		{
			case "p4a":
				return "dhcpc";
			case "p4b":
				return "static";
			case "p4c":
				return "pppoe";
			case "p4d":
				return "pptp";
			case "p4e":
				return "l2tp";
		}
	}
	
	function mapWanType2Page(wan)
	{
		switch(wan)
		{
			case "dhcpc":
				return "p4a";
			case "pppoe":
				return "p4c";
			case "pptp":
				return "p4d";
			case "l2tp":
				return "p4e";
			case "static":
				return "p4b";
		}
	}
	
	function findIndexOfArrayByValue(array, value)
	{
		for (var i=0; i<array.length; i++)
		{
			if(array[i] == value)
				return i;
		}
		return -1;
	}
	
	function next_page()
	{
		if(	(wz_curr_page != 0) &&
			(wz_curr_page != 3))
		{
			if(eval("verify_wz_page_"+pageNameArray[wz_curr_page])() == false)
				return;
		}
			
		wz_prev_page = wz_curr_page;
		
		switch(wz_curr_page)
		{
			case 3:
				//wz_curr_page = pageNameArray.indexOf(mapWanType2Page(get_checked_value(get_by_name('wan_type'))));
				wz_curr_page = findIndexOfArrayByValue(pageNameArray, mapWanType2Page(get_checked_value(get_by_name('wan_type'))));
				break;
			case 0:
			case 1:
			case 2:		
				wz_curr_page ++;
				break;
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
				wz_curr_page = (pageNameArray.length - 1);
				break;
		}
		
		if(wz_curr_page == 4)
			get_by_id("wan_mac").value =wanCfg.wanMac;
		
		if((wz_curr_page == 10)	|| (wz_curr_page == 4)	)
		{
			already_clone = wanCfg.wanMacCloned;
			hw_mac = wanCfg.wanMac;
		}
			
		displayPage(pageNameArray[wz_curr_page]);
	}
	
	function prev_page(page)
	{
		wz_curr_page = wz_prev_page;		
		if( (wz_curr_page >= 4) &&
			(wz_curr_page <= 10))
			wz_prev_page = 3;
		else 
			wz_prev_page --;
		displayPage(pageNameArray[wz_curr_page]);
	}
	
	function show_static_ip(objname){	
		var ppp_type = get_by_name(objname + "_type");	
		if(ppp_type == null)
			return;

		get_by_id(objname+"_ip").disabled = ppp_type[0].checked;
		
		var mask_obj = get_by_id(objname + "_mask");
		var gw_obj = get_by_id(objname + "_gw");
		
		if(mask_obj)
			mask_obj.disabled = ppp_type[0].checked;
		if(gw_obj)
			gw_obj.disabled = ppp_type[0].checked;
	}	
	
	// verify password
	function verify_wz_page_p1()
	{
		var pwd = $('#pwd1').val();
		if (get_by_id("pwd1").value != get_by_id("pwd2").value){
			//alert(LangMap.msg['MATCH_WIZARD_PWD_ERROR']);
			alert(get_words('_pwsame'));
			return false;
		}
		
		if((get_by_id("pwd1").value!="") && (is_ascii(get_by_id("pwd1").value)==false))
		{
			alert(get_words('S493'));
			return false;
		}
		
		if (pwd.length <= '5'){
			if(pwd.length == 0)
				alert(get_words('mydlink_tx04'));
			else
				alert(get_words('limit_pass_msg'));
			return false;
		}
		
		return true;
	}
	
	function verify_wz_page_p2()
	{
		return true;
	}
	
	function verify_wz_page_p3()
	{
		return true;
	}
	
	function verify_wz_page_p4a()
	{
		var c_host = get_by_id("host").value
		if(c_host=="") {
			alert (get_words('GW_DHCP_CLIENT_CLIENT_NAME_INVALID'));
			return false;
		}
		/*
		 * Validate MAC and activate cloning if necessary
		 */		
		 
		var mac = get_by_id("wan_mac").value; 
		if (!check_mac(mac)){
			//alert(LangMap.msg['MAC_ADDRESS_ERROR']);
			alert (get_words('KR3'));
			return false;
		} 
		 	
		var mac = trim_string(get_by_id("wan_mac").value);
		if(!is_mac_valid(mac, true)) {
			//alert ("Invalid MAC address:" + mac + ".");
			alert (get_words('KR3'));
			return false;
		}
		
		if(Find_word(c_host,"'") || Find_word(c_host,'"') || Find_word(c_host,"/") || _isNumeric(c_host)){
			//alert("Host name invalid. the legal characters can not enter ',/,''");
			alert(get_words('GW_DHCP_CLIENT_CLIENT_NAME_INVALID'));
			return false
		}
		
		if(mac.toLowerCase() != hw_mac_org.toLowerCase())
			already_clone = "1";
			
		return true;
	}
	
	function verify_wz_page_p4b()
	{
	    var ip = get_by_id("ip").value;
    	var mask = get_by_id("mask").value;
    	var gateway = get_by_id("gateway").value;
    	var dns1 = get_by_id("dns1").value;
        var dns2 = get_by_id("dns2").value;       
        
		var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));
		var dns1_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_pdns'));
		var dns2_addr_msg = replace_msg(all_ip_addr_msg,get_words('wwa_sdns'));
        
        var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
		var temp_dns1_obj = new addr_obj(dns1.split("."), dns1_addr_msg, false, false);
		var temp_dns2_obj = new addr_obj(dns2.split("."), dns2_addr_msg, true, false);
                
        if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
        	return false;
        }	     
                
		if (!check_address(temp_dns1_obj)){
			return false;
		}
    	
    	if (dns2 != "" && dns2 != "0.0.0.0"){
    		if (!check_address(temp_dns2_obj)){
    			return false;
    		}
    	}
		return true;
	}
	
	function verify_wz_page_p4c()
	{
		var pppoe_type = get_by_name("pppoe_type");
		var ip = get_by_id("pppoe_ip").value;
		
		if (pppoe_type[1].checked){
			var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
			var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
			
			if (!check_address(temp_ip_obj)){
        		return false;
	    	}
		}
		if(get_by_id("pppoe_user_name").value == ""){
    		alert(get_words('GW_WAN_PPPOE_USERNAME_INVALID'));
    		return false;
	     }
	     
	      if (get_by_id("pppoe_pwd1").value == "" || get_by_id("pppoe_pwd2").value == ""){
		 	//alert("A PPPoE password MUST be specified");	
		 	alert(get_words('GW_WAN_PPPOE_PASSWORD_INVALID'));
			return false;
		}
		
		if (!check_pwd("pppoe_pwd1", "pppoe_pwd2")){
			return false;
        }

		return true;
	}
	
	function verify_wz_page_p4d()
	{
		var pptp_type = get_by_name("pptp_type");
    	var ip = get_by_id("pptp_ip").value;
    	var mask = get_by_id("pptp_mask").value;  
    	var gateway = get_by_id("pptp_gw").value;
		var server_ip = get_by_id("pptp_server_ip").value;
		
		var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));
		
		var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
                
		if (pptp_type[1].checked){    	      
        	if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
        		return false;
        	}
        }
    	
    	if(server_ip == ""){
    		//alert(LangMap.msg['ZERO_SERVER_IP']);
    		alert(get_words('YM108'));
    		return false;
       	}
		
		/*
		**    Date:		2013-05-23
		**    Author:	Pascal Pai
		**    Reason:   Check PPTP or L2TP Server IP Address is IP pattern or not
		**/
		if(ip_pattern(server_ip))
		{
			var server_ip_addr_msg = replace_msg(all_ip_addr_msg,LangMap.msg['SERVER_IP_DESC']);
			var temp_server_ip_obj = new addr_obj(server_ip.split("."), server_ip_addr_msg, false, false);
			
			if (!check_address(temp_server_ip_obj)){
				return false;
			}
		}
		
       	if(get_by_id("pptpuserid").value == ""){
       		alert(get_words('GW_WAN_PPTP_USERNAME_INVALID'));
    		return false;
	     }
       	if (get_by_id("pptppwd").value == "" || get_by_id("pptppwd2").value == ""){
		 	//alert("A PPTP password MUST be specified");	//GW_WAN_PPTP_PASSWORD_INVALID
		 	alert(get_words('GW_WAN_PPTP_PASSWORD_INVALID'));
			return false;
		}
       	if (!check_pwd("pptppwd", "pptppwd2")){
       		return false;
       	}

		return true;
	}
	
	function verify_wz_page_p4e()
	{
		var l2tp_type = get_by_name("l2tp_type");
    	var ip = get_by_id("l2tp_ip").value;
    	var mask = get_by_id("l2tp_mask").value;  
    	var gateway = get_by_id("l2tp_gw").value;    	
		var server_ip = get_by_id("l2tp_server_ip").value;
    	
    	var ip_addr_msg = replace_msg(all_ip_addr_msg,get_words('_ipaddr'));
		var gateway_msg = replace_msg(all_ip_addr_msg,get_words('wwa_gw'));
    	
    	var temp_ip_obj = new addr_obj(ip.split("."), ip_addr_msg, false, false);
		var temp_mask_obj = new addr_obj(mask.split("."), subnet_mask_msg, false, false);
		var temp_gateway_obj = new addr_obj(gateway.split("."), gateway_msg, false, false);
    	
    	if (l2tp_type[1].checked){        
	        if (!check_lan_setting(temp_ip_obj, temp_mask_obj, temp_gateway_obj, get_words('WAN'))){
	    		return false;
	    	}
       	}
       	
    	if(server_ip == ""){
    		//alert(LangMap.msg['ZERO_SERVER_IP']);
    		alert(get_words('bwn_alert_17'));
    		return false;
       	}
		
		/*
		**    Date:		2013-05-23
		**    Author:	Pascal Pai
		**    Reason:   Check PPTP or L2TP Server IP Address is IP pattern or not
		**/
		if(ip_pattern(server_ip))
		{
			var server_ip_addr_msg = replace_msg(all_ip_addr_msg,LangMap.msg['SERVER_IP_DESC']);
			var temp_server_ip_obj = new addr_obj(server_ip.split("."), server_ip_addr_msg, false, false);
			
			if (!check_address(temp_server_ip_obj)){
				return false;
			}
		}
		
        if(get_by_id("l2tpuserid").value == ""){
    		//alert(LangMap.msg['PPP_USERNAME_EMPTY']);
    		alert(get_words('GW_WAN_L2TP_USERNAME_INVALID'));
    		return false;
	    }
	     
	    if (get_by_id("l2tppwd").value == "" || get_by_id("l2tppwd2").value == ""){
		 	//alert("A L2TP password MUST be specified");	//
		 	alert(get_words('GW_WAN_L2TP_PASSWORD_INVALID'));
			return false;
		}
       	
       	if (!check_pwd("l2tppwd", "l2tppwd2")){
       		return false;
       	}
		
		return true;
	}
	
	function constructParamDHCPC()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=1";
		paramStr += "&wanDev_MACAddressClone_1.1.0.0=" + get_by_id("wan_mac").value;
		paramStr += "&wanDev_MACAddressOverride_1.1.0.0=" + already_clone;
		paramStr += "&dhcpCfg_HostName_1.1.1.0=" + get_by_id("host").value;
		//paramStr += "&dhcpCfg_UnicastUsed_1.1.1.0=0";
		paramStr += "&dhcpCfg_MaxMTUSize_1.1.1.0=1500";
		return paramStr;
	}

	function constructParamPPPoE()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=2";
		paramStr += "&pppoeCfg_IPAddressType_1.1.1.0=" + get_checked_value(get_by_name("pppoe_type"));
		paramStr += "&pppoeCfg_ExternalIPAddress_1.1.1.0=" + get_by_id("pppoe_ip").value;
		paramStr += "&pppoeCfg_ServiceName_1.1.1.0=" + urlencode(get_by_id("pppoe_service").value);
		paramStr += "&pppoeCfg_Username_1.1.1.0=" + urlencode(get_by_id("pppoe_user_name").value);
		paramStr += "&pppoeCfg_Password_1.1.1.0=" + urlencode(get_by_id("pppoe_pwd1").value);
		paramStr += "&pppoeCfg_NetSniperSupport_1.1.1.0=0";
		paramStr += "&pppoeCfg_SpecialDialMode_1.1.1.0=0";
		return paramStr;
	}
	
	function constructParamStaticIP()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=0";
		paramStr += "&staticIPCfg_ExternalIPAddress_1.1.1.0=" + get_by_id("ip").value;
		paramStr += "&staticIPCfg_SubnetMask_1.1.1.0=" + get_by_id("mask").value;
		paramStr += "&staticIPCfg_DefaultGateway_1.1.1.0=" + get_by_id("gateway").value;
		paramStr += "&staticIPCfg_DNSServers_1.1.1.0=" + get_by_id("dns1").value +","+ get_by_id("dns2").value;
		paramStr += "&staticIPCfg_MaxMTUSize_1.1.1.0=1500";
		paramStr += "&dhcpCfg_AdvancedDNSEnable_1.1.1.0=0";
		return paramStr;
	}
	
	function constructParamPPTP()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=3";
		paramStr += "&pptpCfg_IPAddressType_1.1.1.0=" + get_checked_value(get_by_name("pptp_type"));
		paramStr += "&pptpCfg_ExternalIPAddress_1.1.1.0=" + get_by_id("pptp_ip").value;
		paramStr += "&pptpCfg_SubnetMask_1.1.1.0=" + get_by_id("pptp_mask").value;
		paramStr += "&pptpCfg_DefaultGateway_1.1.1.0=" + get_by_id("pptp_gw").value;
		paramStr += "&pptpConn_ServerIP_1.1.1.1=" + get_by_id("pptp_server_ip").value;
		paramStr += "&pptpConn_Username_1.1.1.1=" + urlencode(get_by_id("pptpuserid").value);
		paramStr += "&pptpConn_Password_1.1.1.1=" + urlencode(get_by_id("pptppwd").value);
		return paramStr;
	}
	
	function constructParamL2TP()
	{
		var paramStr = "";
		paramStr += "&wanDev_CurrentConnObjType_1.1.0.0=4";
		paramStr += "&l2tpCfg_IPAddressType_1.1.1.0=" + get_checked_value(get_by_name("l2tp_type"));
		paramStr += "&l2tpCfg_ExternalIPAddress_1.1.1.0=" + get_by_id("l2tp_ip").value;
		paramStr += "&l2tpCfg_SubnetMask_1.1.1.0=" + get_by_id("l2tp_mask").value;
		paramStr += "&l2tpCfg_DefaultGateway_1.1.1.0=" + get_by_id("l2tp_gw").value;
		paramStr += "&l2tpConn_ServerIP_1.1.1.1=" + get_by_id("l2tp_server_ip").value;
		paramStr += "&l2tpConn_Username_1.1.1.1=" + urlencode(get_by_id("l2tpuserid").value);
		paramStr += "&l2tpConn_Password_1.1.1.1=" + urlencode(get_by_id("l2tppwd").value);
		return paramStr;		
	}
	
	$(document).ready( function () {
		get_by_id("tzone").selectedIndex = gTimezoneIdx;
		/*
		var d = new Date();
		var tz = -d.getTimezoneOffset()/60
		for (var i=0; i<$('#tzone').get(0).options.length; i++)
		{
			if (i<$('#tzone').get(0).options.length-1) {		
				if (parseInt($('#tzone option').eq(i).val()) == tz*16) {
					get_by_id("tzone").selectedIndex = i;
					break;
				}
			} else {
					get_by_id("tzone").selectedIndex = i;
			}
		}
		*/
		switch(wanCfg.wanMode)
		{
			case "0":
				set_checked("static", get_by_name("wan_type"));
			break;
			
			case "1":
				set_checked("dhcpc", get_by_name("wan_type"));
			break;
			
			case "2":
				set_checked("pppoe", get_by_name("wan_type"));
			break;
			
			case "3":
				set_checked("pptp", get_by_name("wan_type"));
			break;
			
			case "4":
				set_checked("l2tp", get_by_name("wan_type"));
			break;
		}
		
		get_by_id("wan_mac").value = wanCfg.wanMac;
		get_by_id("host").value = wanCfg.wanDhcpHost; 
		
		set_checked(wanCfg.wanPppoeType, get_by_name("pppoe_type"));
		get_by_id("pppoe_ip").value = wanCfg.wanPppoeAddr;
		get_by_id("pppoe_user_name").value = wanCfg.wanPppoeName;
		get_by_id("pppoe_service").value = unescape(wanCfg.wanPppoeServ);
		
		set_checked(wanCfg.wanPPTPType, get_by_name("pptp_type"));
		get_by_id("pptp_ip").value = wanCfg.wanPPTPAddr;
		get_by_id("pptp_mask").value = wanCfg.wanPPTPMask;
		get_by_id("pptp_gw").value = wanCfg.wanPPTPGw;
		get_by_id("pptp_server_ip").value = wanCfg.wanPPTPServ;
		get_by_id("pptpuserid").value = wanCfg.wanPPTPName;
		//get_by_id("pptppwd").value = wanCfg.wanPPTPPass;		

		set_checked(wanCfg.wanL2TPType, get_by_name("l2tp_type"));
		get_by_id("l2tp_ip").value = wanCfg.wanL2TPAddr;
		get_by_id("l2tp_mask").value = wanCfg.wanL2TPMask;
		get_by_id("l2tp_gw").value = wanCfg.wanL2TPGw;
		get_by_id("l2tp_server_ip").value = wanCfg.wanL2TPServ;
		get_by_id("l2tpuserid").value = wanCfg.wanL2TPName;
		
		get_by_id("ip").value = wanCfg.wanStaticIp;
		get_by_id("mask").value = wanCfg.wanStaticSubnet;
		get_by_id("gateway").value = wanCfg.wanStaticGw;
		get_by_id("dns1").value = wanCfg.wanStaticDns.split(",")[0];
		
		if(wanCfg.wanStaticDns.split(",")[1])
			get_by_id("dns2").value = wanCfg.wanStaticDns.split(",")[1];
		else
			get_by_id("dns2").value = "0.0.0.0";
	});

	function check_serv_name(){
		var s_name = $('#pppoe_service').val();
		if(check_service_name(s_name))
			next_page();
		else{
			alert(get_words('_srvname') + " " + get_words('mydlink_pop_04'));
			return false;
		}
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

	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<br><br>
		<table width="650" border="0">
	<tr>
		<td>
		<form id="formAll" name="formAll">
	<!-------------------------------->
	<!--     start of page main     -->
	<!-------------------------------->
		<div class=box id="p0" style="display:none"> 
			<h2 align="left"><script>show_words('wwa_title_wel')</script></h2>
			<p class="box_msg"><script>show_words('wwa_intro_wel')</script></p>

			<table class=formarea>
			<tr>
				<td width="334" height="81">
					<UL>
					<LI><script>show_words('wwa_title_s1')</script>
					<LI><script>show_words('wwa_title_s2')</script>
					<LI><script>show_words('wwa_title_s3')</script>
					<LI><script>show_words('wwa_title_s4')</script>
					</LI>
					</UL>
				</td>
			</tr>
			</table>
			<table align="center" class="formarea">
			<tr>
				<td>
                    <fieldset id="wz_buttons">
					<input type="button" class="button_submit" id="wz_prev_b_p0" name="wz_prev_b_p0" value="" disabled>
					<input type="button" class="button_submit" id="next_b2_p0" name="next_b2_p0" value="" onClick="next_page();">
					<input type="button" class="button_submit" id="cancel_b2_p0" name="cancel_b2_p0" value="" onClick="wizard_cancel();">
					<input type="button" class="button_submit" id="wz_save_b_p0" name="wz_save_b_p0" value="" disabled>
					<script>$('#wz_prev_b_p0').val(get_words('_prev'));</script>
					<script>$('#next_b2_p0').val(get_words('_next'));</script>
					<script>$('#cancel_b2_p0').val(get_words('_cancel'));</script>
					<script>$('#wz_save_b_p0').val(get_words('_connect'));</script>
					  </fieldset>
				</td>
			</tr>
			</table>

		</div>
	<!-------------------------------->
	<!--     End of page main       -->
	<!-------------------------------->

	<!-------------------------------->
	<!--     Start of page 1       -->
	<!-------------------------------->
		<div class=box id="p1">
			<h2 align="left"><script>show_words('wwa_title_s1')</script></h2>
			<p class="box_msg"><script>show_words('wwa_intro_s1a')</script></p>

			<table class=formarea>
			<tr>
				<td align=right class="duple"><script>show_words('_password')</script>:</td>
				<td>&nbsp;
						<input type="password" id=pwd1 name=pwd1 size=20 maxlength=32 value=''>
				</td>
			</tr>
			<tr>
				<td align=right class="duple"><script>show_words('_verifypw')</script> :</td>
				<td>&nbsp;
						<input type="password" id=pwd2 name=pwd2 size=20 maxlength=32 value=''>
				</td>
			</tr>
			</table><br>
			<table align="center" class="formarea">
			<tr>
				<td>
					<input type="button" class="button_submit" id="wz_prev_b_p1" name="wz_prev_b_p1" value="" onclick="prev_page();"> 
					<input type="button" class="button_submit" id="next_b_p1" name="next_b_p1" value="" onClick="next_page();"> 
					<input type="button" class="button_submit" id="cancel_b_p1" name="cancel_b_p1" value="" onclick="wizard_cancel();"> 
					<input type="button" class="button_submit" id="wz_save_b_p1" name="wz_save_b_p1" value="" disabled> 
					<script>$('#wz_prev_b_p1').val(get_words('_prev'));</script>
					<script>$('#next_b_p1').val(get_words('_next'));</script>
					<script>$('#cancel_b_p1').val(get_words('_cancel'));</script>
					<script>$('#wz_save_b_p1').val(get_words('_connect'));</script>
				</td>
			</tr>
			</table>
		</div>
	<!-------------------------------->
	<!--       End of page 1        -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 2       -->
	<!-------------------------------->
		<div class=box id="p2"> 
			<h2 align="left"><script>show_words('wwa_title_s2')</script></h2>
			<p class="box_msg"><script>show_words('wwa_intro_s2')</script></p>
			<P align="center">
			<select size=1 id="tzone" name="tzone">
					<option value="-192"><font face="Arial"><script>show_words('up_tz_76')</script></font></option>
					<option value="-176"><font face="Arial"><script>show_words('up_tz_77')</script></font></option>
					<option value="-160"><font face="Arial"><script>show_words('up_tz_02')</script></font></option>
					<option value="-144"><font face="Arial"><script>show_words('up_tz_03')</script></font></option>
					<option value="-128"><font face="Arial"><script>show_words('up_tz_04')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_05')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_78')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_06')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_07')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_08')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_79')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_10')</script></font></option>
					<option value="-80"><font face="Arial"><script>show_words('up_tz_80')</script></font></option>
					<option value="-80"><font face="Arial"><script>show_words('up_tz_12')</script></font></option>
					<option value="-72"><font face="Arial"><script>show_words('up_tz_81')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_82')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_14')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_16')</script></font></option>
					<option value="-56"><font face="Arial"><script>show_words('up_tz_17')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_18')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_83')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_20')</script></font></option>
					<option value="-32"><font face="Arial"><script>show_words('up_tz_21')</script></font></option>
					<option value="-16"><font face="Arial"><script>show_words('up_tz_22')</script></font></option>
					<option value="-16"><font face="Arial"><script>show_words('up_tz_23')</script></font></option>
					<option value="0"><font face="Arial"><script>show_words('up_tz_24')</script></font></option>
					<option value="0"><font face="Arial"><script>show_words('up_tz_25')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_26')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_27')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_28')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_84')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_30')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_31')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_32')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_33')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_34')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_85')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_36')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_37')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_38')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_40')</script></font></option>
					<option value="56"><font face="Arial"><script>show_words('up_tz_41')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_42')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_43')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_39')</script></font></option>
					<option value="72"><font face="Arial"><script>show_words('up_tz_44')</script></font></option>
					<option value="80"><font face="Arial"><script>show_words('up_tz_46')</script></font></option>
					<option value="88"><font face="Arial"><script>show_words('up_tz_86')</script></font></option>
					<option value="88"><font face="Arial"><script>show_words('up_tz_88')</script></font></option>
					<option value="92"><font face="Arial"><script>show_words('up_tz_48')</script></font></option>
					<option value="96"><font face="Arial"><script>show_words('up_tz_50')</script></font></option>
					<option value="96"><font face="Arial"><script>show_words('up_tz_45')</script></font></option>
					<option value="104"><font face="Arial"><script>show_words('up_tz_52')</script></font></option>
					<option value="112"><font face="Arial"><script>show_words('up_tz_87')</script></font></option>
					<option value="112"><font face="Arial"><script>show_words('up_tz_53')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_54')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_55')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_57')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_58')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_59')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_89')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_90')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_60')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_61')</script></font></option>
					<option value="152"><font face="Arial"><script>show_words('up_tz_63')</script></font></option>
					<option value="152"><font face="Arial"><script>show_words('up_tz_64')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_65')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_66')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_67')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_68')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_62')</script></font></option>
					<option value="176"><font face="Arial"><script>show_words('up_tz_70')</script></font></option>
					<option value="176"><font face="Arial"><script>show_words('up_tz_69')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_75')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_71')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_72')</script></font></option>
					<option value="208"><font face="Arial"><script>show_words('up_tz_91')</script></font></option>
					<option value="208"><font face="Arial"><script>show_words('up_tz_92')</script></font></option>
			</select>
			</p><br>

			<table align="center" class="formarea">
			<tr>
				<td>
					<input type="button" class="button_submit" id="wz_prev_b_p2" name="wz_prev_b_p2" value="" onclick="prev_page();"> 
					<input type="button" class="button_submit" id="next_b_p2" name="next_b_p2" value="" onClick="next_page();"> 
					<input type="button" class="button_submit" id="cancel_b_p2" name="cancel_b_p2" value="" onclick="wizard_cancel();"> 
					<input type="button" class="button_submit" id="wz_save_b_p2" name="wz_save_b_p2" value="" disabled>
					<script>$('#wz_prev_b_p2').val(get_words('_prev'));</script>
					<script>$('#next_b_p2').val(get_words('_next'));</script>
					<script>$('#cancel_b_p2').val(get_words('_cancel'));</script>
					<script>$('#wz_save_b_p2').val(get_words('_connect'));</script>
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
			<h2><script>show_words('wwa_title_s3')</script></h2>
			<div>
				<P align="left" class=box_msg><script>show_words('wwa_intro_s3a')</script></P>
				<table class=formarea >
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="dhcpc" checked>
					<STRONG><script>show_words('_dhcpconn')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_dhcp')</script></div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="pppoe">
					<STRONG><script>show_words('wwa_wanmode_pppoe')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_pppoe')</script></div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="pptp">
					<STRONG><script>show_words('wwa_wanmode_pptp')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_pptp')</script> </div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="l2tp">
					<STRONG><script>show_words('wwa_wanmode_l2tp')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_l2tp')</script> </div></td>
				</tr>
				<tr>
					<td class=form_label>&nbsp;</td>
					<td><input name="wan_type" type="radio" value="static">
					<STRONG><script>show_words('wwa_wanmode_sipa')</script></STRONG>
					<div class=itemhelp><script>show_words('wwa_msg_sipa')</script></div></td>
				</tr>
				</table><br>

				<table align="center" class="formarea">
				<tr>
					<td>
						<input type="button" class="button_submit" id="wz_prev_b_p3" name="wz_prev_b_p3" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p3" name="next_b_p3" value="" onClick="next_page();"> 
						<input type="button" class="button_submit" id="cancel_b_p3" name="cancel_b_p3" value="" onclick="wizard_cancel();"> 
						<input type="button" class="button_submit" id="wz_save_b_p3" name="wz_save_b_p3" value="" disabled>
						<script>$('#wz_prev_b_p3').val(get_words('_prev'));</script>
						<script>$('#next_b_p3').val(get_words('_next'));</script>
						<script>$('#cancel_b_p3').val(get_words('_cancel'));</script>
						<script>$('#wz_save_b_p3').val(get_words('_connect'));</script> 
					</td>
				</tr>
				</table>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 3        -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 4a      -->
	<!-------------------------------->
		<div class=box id="p4a"> 
			<h2 align="left"><script>show_words('_dhcpconn')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_msg_set_dhcp')</script></p>
				<div>
					<table align="center" class=formarea>
					<tr>
						<td width="137" align=right class="duple"><script>show_words('_macaddr')</script>&nbsp;:</td>
						<td width="473">
							<input type="text" id="wan_mac" name="wan_mac" maxlength="17" size="20" value=''>
							<script>show_words('_optional')</script>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td> 
							<input name="clone" type="button" class="button_submit" id="clone_1" value="" onClick='clone_mac_action("wan_mac");'>
							<script>$('#clone_1').val(get_words('_clone'));</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_hostname')</script>&nbsp;:</td>
						<td>
							<input type=text id=host name=host size="25" maxlength="39" value='dlinkrouter'>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="itemhelp"><script>show_words('wwa_note_hostname')</script></td>
					</tr>
					<tr>
						<td class=form_label>&nbsp;</td>
						<td>
							<input type="button" class="button_submit" id="wz_prev_b_p4a" name="wz_prev_b_p4a" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p4a" name="next_b_p4a" value="" onClick="next_page();"> 
							<input type="button" class="button_submit" id="cancel_b_p4a" name="cancel_b_p4a" value="" onclick="wizard_cancel();"> 
							<input type="button" class="button_submit" id="wz_save_b_p4a" name="wz_save_b_p4a" value="" disabled> 
							<script>$('#wz_prev_b_p4a').val(get_words('_prev'));</script>
							<script>$('#next_b_p4a').val(get_words('_next'));</script>
							<script>$('#cancel_b_p4a').val(get_words('_cancel'));</script>
							<script>$('#wz_save_b_p4a').val(get_words('_connect'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 4a       -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 4b      -->
	<!-------------------------------->
		<div class=box id="p4b"> 
			<h2 align="left"><script>show_words('wwa_set_sipa_title')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_set_sipa_msg')</script></p>
				<div>
					<table width="536" align="center" class=formarea>
					<tr>
						<td width="235" align=right class="duple"><script>show_words('_ipaddr')</script>&nbsp;:</td>
						<td width="468">
							<input type=text id=ip name=ip size="20" maxlength="15" value=''>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_subnet')</script>&nbsp;:</td>
						<td><input type=text id=mask name=mask size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"> <script>show_words('wwa_gw')</script>&nbsp;:</td>
						<td><input type=text id=gateway name=gateway size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('wwa_pdns')</script>&nbsp;:</td>
						<td><input type=text id=dns1 name=dns1 size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('wwa_sdns')</script>&nbsp;:</td>
						<td><input type=text id=dns2 name=dns2 size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="button" class="button_submit" id="wz_prev_b_p4b" name="wz_prev_b_p4b" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p4b" name="next_b_p4b" value="" onClick="next_page();"> 
							<input type="button" class="button_submit" id="cancel_b_p4b" name="cancel_b_p4b" value="" onclick="wizard_cancel();"> 
							<input type="button" class="button_submit" id="wz_save_b_p4b" name="wz_save_b_p4b" value="" disabled> 
							<script>$('#wz_prev_b_p4b').val(get_words('_prev'));</script>
							<script>$('#next_b_p4b').val(get_words('_next'));</script>
							<script>$('#cancel_b_p4b').val(get_words('_cancel'));</script>
							<script>$('#wz_save_b_p4b').val(get_words('_connect'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 4b       -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 4c      -->
	<!-------------------------------->
		<div class=box id="p4c"> 
			<h2 align="left"><script>show_words('wwa_title_set_pppoe')</script></h2>
			<p class="box_msg"><script>show_words('wwa_msg_set_pppoe')</script></p>
			<div>
				<table class=formarea >
				<tr>
					<td width="167" align=right class="duple"><script>show_words('bwn_AM')</script>&nbsp;:</td>
					<td width="443">
						<input name="pppoe_type" type="radio" value="0" onClick="show_static_ip('pppoe')" checked>
						<script>show_words('Dynamic_PPPoE')</script>&nbsp;&nbsp; 
						<input name="pppoe_type" type="radio" value="1" onClick="show_static_ip('pppoe')">
						<script>show_words('static_PPPoE')</script>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_ipaddr')</script>&nbsp;:</td>
					<td><input name="pppoe_ip" type="text" id="pppoe_ip" size="20" maxlength="15" value=''></td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_username')</script>&nbsp;:</td>
					<td><input type=text id=pppoe_user_name name=pppoe_user_name size="20" maxlength="63" value=''></td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_password')</script>&nbsp;:</td>
					<td>
						<input type=password id=pppoe_pwd1 name=pppoe_pwd1 size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_verifypw')</script>&nbsp;:</td>
					<td>
						<input type=password id=pppoe_pwd2 name=pppoe_pwd2 size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_srvname')</script>&nbsp;:</td><td>
						<input type=text id=pppoe_service name=pppoe_service size="20" maxlength="39" value=''>
						<script>show_words('_optional')</script>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="itemhelp"> <script>show_words('wwa_note_svcn')</script></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input type="button" class="button_submit" id="wz_prev_b_p4c" name="wz_prev_b_p4c" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p4c" name="next_b_p4c" value="" onClick="check_serv_name();"> 
						<input type="button" class="button_submit" id="cancel_b_p4c" name="cancel_b_p4c" value="" onclick="wizard_cancel();">
						<input type="button" class="button_submit" id="wz_save_b_p4c" name="wz_save_b_p4c" value="" disabled> 
						<script>$('#wz_prev_b_p4c').val(get_words('_prev'));</script>
						<script>$('#next_b_p4c').val(get_words('_next'));</script>
						<script>$('#cancel_b_p4c').val(get_words('_cancel'));</script>
						<script>$('#wz_save_b_p4c').val(get_words('_connect'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 4c       -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 4d      -->
	<!-------------------------------->
		<div class=box id="p4d"> 
			<h2 align="left"><script>show_words('wwa_title_set_pptp')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_msg_set_pptp')</script></p>
				<div>
					<table width="525" align="center" class=formarea >
					<tr>
						<td width="220" align=right class="duple"><script>show_words('bwn_AM')</script>&nbsp;:</td>
						<td width="304">
							<input name="pptp_type" type="radio" value="0" onClick="show_static_ip('pptp')" checked>
							<script>show_words('carriertype_ct_0')</script>&nbsp; 
							<input name="pptp_type" type="radio" value="1" onClick="show_static_ip('pptp')">
							<script>show_words('_sdi_staticip')</script>
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_PPTPip')</script>&nbsp;:</td>
						<td><input type=text id=pptp_ip name=pptp_ip size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_PPTPsubnet')</script>&nbsp;:</td>
						<td><input type=text id=pptp_mask name=pptp_mask size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_PPTPgw')</script>&nbsp;:</td>
						<td><input type=text id=pptp_gw name=pptp_gw size="20" maxlength="15" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('wwa_pptp_svraddr')</script>&nbsp;:</td>
						<td><input type=text id=pptp_server_ip name=pptp_server_ip size="20" maxlength="64" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_username')</script>&nbsp;:</td>
						<td><input type=text id=pptpuserid name=pptpuserid size="20" maxlength="63" value=''></td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_password')</script>&nbsp;:</td>
						<td>
							<input type=password id=pptppwd name=pptppwd size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					<tr>
						<td align=right class="duple"><script>show_words('_verifypw')</script>&nbsp;:</td>
						<td>
							<input type=password id=pptppwd2 name=pptppwd2 size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="button" class="button_submit" id="wz_prev_b_p4d" name="wz_prev_b_p4d" value="" onclick="prev_page();"> 
							<input type="button" class="button_submit" id="next_b_p4d" name="next_b_p4d" value="" onClick="next_page();"> 
							<input type="button" class="button_submit" id="cancel_b_p4d" name="cancel_b_p4d" value="" onclick="wizard_cancel();">
							<input type="button" class="button_submit" id="wz_save_b_p4d" name="wz_save_b_p4d" value="" disabled> 
							<script>$('#wz_prev_b_p4d').val(get_words('_prev'));</script>
							<script>$('#next_b_p4d').val(get_words('_next'));</script>
							<script>$('#cancel_b_p4d').val(get_words('_cancel'));</script>
							<script>$('#wz_save_b_p4d').val(get_words('_connect'));</script>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 4d       -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 4e      -->
	<!-------------------------------->
		<div class=box id="p4e"> 
			<h2 align="left"><script>show_words('wwa_set_l2tp_title')</script></h2>
			<div align="left"> 
				<p class="box_msg"><script>show_words('wwa_set_l2tp_msg')</script></p>
			<div>
				<table width="536" align="center" class=formarea>
				<tr>
					<td width="235" align=right class="duple">
						<script>show_words('bwn_AM')</script>
						&nbsp;:</td>
					<td width="468">
						<input name="l2tp_type" type="radio" value="0" onClick="show_static_ip('l2tp')" checked>
						<script>show_words('carriertype_ct_0')</script>
						&nbsp;&nbsp; 
						<input name="l2tp_type" type="radio" value="1" onClick="show_static_ip('l2tp')">
						<script>show_words('_sdi_staticip')</script>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_L2TPip')</script>&nbsp;:</td>
					<td>
						<input type=text id=l2tp_ip name=l2tp_ip size="20" maxlength="15" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_L2TPsubnet')</script>&nbsp;:</td>
					<td>
						<input type=text id=l2tp_mask name=l2tp_mask size="20" maxlength="15" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_L2TPgw')</script>&nbsp;:</td>
					<td>
						<input type=text id=l2tp_gw name=l2tp_gw size="20" maxlength="15" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('wwa_l2tp_svra')</script>&nbsp;:</td>
					<td>
						<input type=text id=l2tp_server_ip name=l2tp_server_ip size="20" maxlength="64" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_username')</script>&nbsp;:</td>
					<td>
						<input type=text id=l2tpuserid name=l2tpuserid size="20" maxlength="63" value=''>
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_password')</script>&nbsp;:</td>
					<td>
						<input type=password id=l2tppwd name=l2tppwd size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
					</td>
				</tr>
				<tr>
					<td align=right class="duple"><script>show_words('_verifypw')</script>&nbsp;:</td>
					<td>
						<input type=password id=l2tppwd2 name=l2tppwd2 size="20" maxlength="64" value="WDB8WvbXdHtZyM8Ms2RENgHlacJghQyGWDB8WvbXdHtZyM8Ms2RENgHlacJghQyG">
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input type="button" class="button_submit" id="wz_prev_b_p4e" name="wz_prev_b_p4e" value="" onclick="prev_page();"> 
						<input type="button" class="button_submit" id="next_b_p4e" name="next_b_p4e" value="" onClick="next_page();"> 
						<input type="button" class="button_submit" id="cancel_b_p4e" name="cancel_b_p4e" value="" onclick="wizard_cancel();">
						<input type="button" class="button_submit" id="wz_save_b_p4e" name="wz_save_b_p4e" value="" disabled> 
						<script>$('#wz_prev_b_p4e').val(get_words('_prev'));</script>
						<script>$('#next_b_p4e').val(get_words('_next'));</script>
						<script>$('#cancel_b_p4e').val(get_words('_cancel'));</script>
						<script>$('#wz_save_b_p4e').val(get_words('_connect'));</script>
					</td>
				</tr>
				</table>
			</div>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 4e       -->
	<!-------------------------------->

	<!-------------------------------->
	<!--      Start of page 5       -->
	<!-------------------------------->
		<div class=box id="p5"> 
			<h2 align="left"><script>show_words('_setupdone')</script></h2>
			<div align="left">
				<div> 
					<P align="left" class=box_msg><script>show_words('wwa_intro_s5')</script></P>
						<table align="center" class=formarea >
						<tr>
							<td></td>
							<td>    
								<input type="button" class="button_submit" id="prev_b_p5" name="prev_b_p5" value="" onclick="prev_page();"> 
								<input type="button" class="button_submit" id="next_b_p5" name="next_b_p5" value="" disabled> 
								<input type="button" class="button_submit" id="cancel_b_p5" name="cancel_b_p5" value="" onclick="wizard_cancel();"> 
								<input type="button" class="button_submit" id="wz_save_b_p5" name="wz_save_b_p5" value="" onClick="return send_request()">

								<script>$('#prev_b_p5').val(get_words('_prev'));</script>
								<script>$('#next_b_p5').val(get_words('_next'));</script>
								<script>$('#cancel_b_p5').val(get_words('_cancel'));</script>
								<script>$('#wz_save_b_p5').val(get_words('_connect'));</script>
							</td>
						</tr>
						</table>
						<div align="center"></div>
				</div>
			</div>
		</div>
	<!-------------------------------->
	<!--       End of page 5        -->
	<!-------------------------------->
		<br><br></form>
		</td>
	</tr>
		</table>
		</td>
	</tr>
  </table>
  
<tr>

	<!--footer-->
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