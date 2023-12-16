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
<script type="text/javascript" src="js/public_ipv6.js"></script>
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

	var hasBgGetDevStatus = false;
	var Show_ = get_words('_none');
	var wan_addr4;
	var use_linklocal_addr;
	var v6Status = {
		'connType':	0,
		'IPAddressType':	0,
		'netState':	'Disconnected',
		'connupTime': '0',
		'wanAddr':	'',
		'wanIANA':	'',
		'wanStaticIP':	'',
		'gw':		'',
		'priDNS':	'',
		'secDNS':	'',
		'wanLL':	'',
		'lanLL':	'',
		'lanAddr':	'',
		'dhcpPdEn':	0,
		'dhcpPdAddr':	'',
		'dhcpPdLen':	0,
		'WanPrefixLen': 0,
		'WanStaticPrefixLen': 0,
		'LanPrefixLen': 0
	};

	var lanHost = {
		'name':			'',
		'ip':			'',
		'prefix':		''
	};

	function reqStatus()
	{
		var mainObj = new ccpObject();
		var param = {
			url: "get_set.ccp",
			arg: ""
		};
		//20121113 Silvia note: webpage LAN/WAN 1100, only L7 use 1200, 1300,1400
		param.arg = "ccp_act=get&num_inst=6";
		param.arg +="&oid_1=IGD_WANDevice_i_IPv6Status_&inst_1=1110";	
		param.arg +="&oid_2=IGD_LANDevice_i_ConnectedAddressV6_i_&inst_2=1100";
		param.arg +="&oid_3=IGD_LANDevice_i_IPv6ConfigManagement_&inst_3=1110";
		param.arg +="&oid_4=IGD_WANDevice_i_WANStatus_&inst_4=1110";
		param.arg +="&oid_5=IGD_WANDevice_i_StaticIPv6_&inst_5=1110";
		param.arg +="&oid_6=IGD_WANDevice_i_PPPoEv6_i_&inst_6=1110"; //added by Derek 20120504
		mainObj.get_config_obj(param);

		/*     
		**    Date:		2013-02-21
		**    Author:	Silvia Chang
		**    Note:		Fixed Status information issue (NaN)
		**/

		if (typeof mainObj.gConfig == String && mainObj.gConfig == "error")
		{
			return mainObj;
		}

		wan_addr4 = mainObj.config_val("igdWanStatus_IPAddress_");
		use_linklocal_addr = filter_ipv6_addr(mainObj.config_val("ipv6StaticConn_UseLinkLocalAddress_"));
		v6Status.connType = mainObj.config_val('igdIPv6Status_CurrentConnObjType_');
		v6Status.IPAddressType =mainObj.config_val('ipv6PPPoEConn_IPAddressType_');//added by Derek 20120504
		v6Status.netState = mainObj.config_val('igdIPv6Status_NetworkStatus_');
		v6Status.connupTime = mainObj.config_val('igdIPv6Status_WanUpTime_');
		v6Status.wanAddr = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPAddress_'));
		v6Status.wanIANA = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPAddressIANA_'));
		v6Status.wanAddrSec = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPAddressSec_'));
		v6Status.gw = mainObj.config_val('igdIPv6Status_DefaultGateway_');
		v6Status.priDNS = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_PrimaryDNSAddress_'));
		v6Status.secDNS = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_SecondaryDNSAddress_'));
		v6Status.wanLL = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPv6WanLinkLocalAddress_'));
		v6Status.lanLL = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPv6LanLinkLocalAddress_'));
		v6Status.lanAddr = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPv6LanAddress_'));
		v6Status.lanAddr2 = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPv6LanAddress2_'));
		v6Status.dhcpPdEn = mainObj.config_val("lanIPv6Cfg_DHCPPDEnable_");
		v6Status.dhcpPdAddr = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPv6AddressAssignedByDHCPPD_'));
		v6Status.dhcpPdLen = mainObj.config_val('igdIPv6Status_IPv6AddressLenAssignedByDHCPPD_');
		v6Status.tunnelAddr = filter_ipv6_addr(mainObj.config_val('igdIPv6Status_IPv6TunnelAddress_'));
		v6Status.WanPrefixLen = mainObj.config_val('igdIPv6Status_IPv6WanPrefixLen_');
		v6Status.WanPrefixLen2 = mainObj.config_val('igdIPv6Status_IPv6WanPrefixLen2_');
		v6Status.WanIANAPrefixLen = mainObj.config_val('igdIPv6Status_IANAPrefix_');
		v6Status.LanPrefixLen = mainObj.config_val('igdIPv6Status_IPv6LanPrefixLen_');
		v6Status.LanPrefixLen2 = mainObj.config_val('igdIPv6Status_IPv6LanPrefixLen2_');
		v6Status.wanStaticIP=mainObj.config_val('igdIPv6Status_StaticIPAddress_');//added by Derek 20120504
		v6Status.WanStaticPrefixLen = mainObj.config_val('igdIPv6Status_IPv6WanStaticPrefixLen_');
		lanHost.name = mainObj.config_str_multi("igdLanHostV6Status_HostName_");
		lanHost.ip = mainObj.config_str_multi("igdLanHostV6Status_HostIPv6Address_");
		lanHost.prefix = mainObj.config_str_multi("igdLanHostV6Status_HostIPv6Prefix_");
		return mainObj;
	}

	function onPageLoad()
	{
		var mainObj = reqStatus();
		if (typeof mainObj.gConfig == String && mainObj.gConfig == "error")
		{
			setTimeout("onPageLoad()",3000);
			return;
		}

		var connection_type = '';
		var showNone = true;
		ipv6_link_local();
		tr_tunnel_ipv6_addr.style.display="none";
		switch(v6Status.connType)
		{
			case "0":   //autodetection
				connection_type = get_words('IPV6_TEXT138');
				show_dhcppd(1);
				get_v6_gw(0);
				if (v6Status.netState == "Disconnected")
					tr_ipv6_show_button.style.display="none";
				tr_ipv6_conn_time.style.display="none";
				tr_wan_ipv6_addriana.style.display="";
				break;
			case "1":    //static
				connection_type = get_words('IPV6_TEXT32');
				show_dhcppd(0);
				get_v6_gw(0);
				tr_ipv6_conn_time.style.display="none";
				tr_ipv6_show_button.style.display="none";
				tr_dhcp_pd.style.display="none";
				tr_ipv6_addr_by_dhcppd.style.display="none";
				tr_wan_ipv6_addriana.style.display="";
				break;
			case "2":   //autoconfiguration
				connection_type = get_words('IPV6_TEXT171');
				if (v6Status.netState != "Disconnected")
					tr_ipv6_show_button.style.display="";
				tr_wan_ipv6_addriana.style.display="";
				show_dhcppd(1);
				get_v6_gw(0);
				break;
			case "3":  //pppoe
				connection_type = "PPPoE";
				if (v6Status.netState != "Disconnected")
					tr_ipv6_show_button.style.display="";
				tr_wan_ipv6_addriana.style.display="";
				show_dhcppd(1);
				get_v6_gw(0);
				break;
			case "4": //6in4
				connection_type = get_words('IPV6_TEXT35');
				show_dhcppd(1);
				get_v6_gw(0);
				tr_ipv6_show_button.style.display="none";
				tr_ipv6_conn_time.style.display="none";
				tr_tunnel_ipv6_addr.style.display="none";
				tr_wan_ipv6_addriana.style.display="";
				//$('#tunnel_ipv6_addr')[0].html() += "/128";
				break;
			case "5":  //6to4
				connection_type = get_words('IPV6_TEXT36');
				showNone = change_6to4_format(mainObj);
				show_dhcppd(0);	
				get_v6_gw(1);
				tr_ipv6_show_button.style.display="none";
				tr_ipv6_conn_time.style.display="none";
				tr_dhcp_pd.style.display="none";
				tr_ipv6_addr_by_dhcppd.style.display="none";
				tr_wan_ipv6_addriana.style.display="";
				break;
			case "6":   //6rd
				connection_type = get_words('IPV6_TEXT139');
				show_dhcppd(0);	
				get_v6_gw(1);
				tr_ipv6_show_button.style.display="none";
				tr_ipv6_conn_time.style.display="none";
				tr_tunnel_ipv6_addr.style.display="";
				tr_dhcp_pd.style.display="none";
				tr_ipv6_addr_by_dhcppd.style.display="none";
				tr_wan_ipv6_addriana.style.display="none";
				//$('#tunnel_ipv6_addr')[0].html() += "/64";
				break;
			case "7":  //link local
				connection_type = get_words('IPV6_TEXT37');
				tr_ipv6_show_button.style.display="none";
				tr_ipv6_conn_time.style.display="none";
				tr_network_ipv6_status.style.display="none";
				tr_lan_ipv6_addr.style.display="none";
				tr_primary_ipv6_dns.style.display="none";
				tr_secondary_ipv6_dns.style.display="none";
				tr_wan_ipv6_gw.style.display="none";
				tr_dhcp_pd.style.display="none";
				tr_ipv6_addr_by_dhcppd.style.display="none";
				tr_wan_ipv6_addriana.style.display="";
				show_dhcppd(0);	
				break;
			case "8":  //dslite
				connection_type = get_words('IPV6_TEXT140');
				tr_wan_ipv6_addriana.style.display="";
				lan_ip = "None";
				break;
			case "9":   //6rdAutoConfig
				connection_type = get_words('IPV6_TEXT172');
				if (v6Status.netState != "Disconnected")
					tr_ipv6_show_button.style.display="";
				show_dhcppd(1);
				get_v6_gw(0);
				tr_tunnel_ipv6_addr.style.display="";
				tr_wan_ipv6_addriana.style.display="";
				break;
			default:
				break;
		}
		
		$('#connection_ipv6_type').html(connection_type);
		$('#network_ipv6_status').html(v6Status.netState == "Disconnected" ? get_words('DISCONNECTED'):get_words('CONNECTED'));
		get_wan_time(v6Status.connupTime);
		
		if(v6Status.connType=="1" && use_linklocal_addr == "1"){
			if(v6Status.wanLL){
				$('#wan_ipv6_addr').html('&nbsp;&nbsp;'+v6Status.wanLL+"/"+v6Status.WanStaticPrefixLen);
				showNone = false;
			}
		}
		else if(v6Status.wanAddr){
			$('#wan_ipv6_addr').html('&nbsp;&nbsp;'+v6Status.wanAddr+"/"+v6Status.WanPrefixLen);
			showNone = false;
		}

		if(v6Status.wanAddrSec){
			$('#wan_ipv6_addrSec').html('&nbsp;&nbsp;'+v6Status.wanAddrSec+"/"+v6Status.WanPrefixLen2);
			showNone = false;
		}

		if(v6Status.connType!="5"){
			if(v6Status.wanIANA){
				$('#wan_ipv6_addriana').html('&nbsp;&nbsp;'+(v6Status.wanIANA+"/"+v6Status.WanIANAPrefixLen));
				showNone = false;
			}
		}
		else if(v6Status.wanIANA){
			var ip6to4 = get_6to4_ip();
			$('#wan_ipv6_addriana').html('&nbsp;&nbsp;'+ip6to4);
			showNone = false;
		}

		if(v6Status.IPAddressType == "1" && v6Status.connType == "3"){
			if(v6Status.wanStaticIP){
				$('#wan_ipv6_StaticIP').html('&nbsp;&nbsp;'+filter_ipv6_addr(v6Status.wanStaticIP)+"/"+v6Status.WanStaticPrefixLen);
				showNone = false;
			}
		}

		if(showNone){
			$('#wan_ipv6_addr').html('&nbsp;&nbsp;'+Show_);
		}

		$('#primary_ipv6_dns').html((v6Status.priDNS == "")? Show_ :v6Status.priDNS);
		$('#secondary_ipv6_dns').html((v6Status.secDNS == "")? Show_ :v6Status.secDNS);
		$('#lan_ipv6_addr').html((v6Status.lanAddr == "")? Show_ :(v6Status.lanAddr+"/"+v6Status.LanPrefixLen));
		//20120822 pascal add for 6rd two ipv6 address
		if(v6Status.lanAddr2 != "")
		{
			$("#count_ip").attr('rowspan',2);
			$("#tr_lan_ipv6_addr2").show();
			$('#lan_ipv6_addr2').html((v6Status.lanAddr2 == "")? Show_ :(v6Status.lanAddr2+"/"+v6Status.LanPrefixLen2));
		}
		else
		{
			$("#count_ip").attr('rowspan',1);
			$("#tr_lan_ipv6_addr2").hide();
			$('#lan_ipv6_addr2').html(Show_);
		}	
		$('#lan_link_local_ip').html((v6Status.lanLL == "")? Show_ :(v6Status.lanLL+"/64"));

		/*if(v6Status.netState == "Disconnected")
		{
			$('#wan_ipv6_addr').html("");
			$('#wan_ipv6_addriana').html("");
			$('#tunnel_ipv6_addr').html("");
			$('#wan_ipv6_gw').html("");
			$('#primary_ipv6_dns').html("");
			$('#secondary_ipv6_dns').html("");
			$('#lan_ipv6_addr').html("");
			$('#ipv6_addr_by_dhcppd').html("");
		}*/
		//$('#wan_ipv6_addr').html("1111:2222:3333:4444:5555:6666:7777:8888/128");
		//$('#wan_ipv6_addriana').html("2222:2222:2222:2222:2222:2222:2222:2222/128");
		
		print_hostv6();
		if((v6Status.connType=="2")||(v6Status.connType=="9"))
		{
			if(v6Status.gw=="")
			{
				if((v6Status.wanAddr=="")&&(v6Status.wanIANA==""))
				{
					$('#network_ipv6_status').html(get_words('DISCONNECTED'));
					$('#primary_ipv6_dns').html(Show_);
					$('#secondary_ipv6_dns').html(Show_);
					get_by_id("ipv6_conn_time").innerHTML = get_words('_NA');
				}
			}
		}
		set_control_button();
		setTimeout("onPageLoad()",3000);
	}
	String.prototype.lpad = function(padString, length) {
	var str = this;
	while (str.length < length)
	str = padString + str;
	return str;
	}

	var wTimesec, wan_time;
	var temp, days = 0, hours = 0, mins = 0, secs = 0;
	function caculate_time(){
	
		var wTime = Math.floor(wTimesec);
		var days = Math.floor(wTime / 86400);
			wTime %= 86400;
			var hours = Math.floor(wTime / 3600);
			wTime %= 3600;
			var mins = Math.floor(wTime / 60);
			wTime %= 60;

			wan_time = days + " " + 
				((days <= 1) 
					? "Day"
					: "Days")
				+ ", ";
			wan_time += hours + ":" + padout(mins) + ":" + padout(wTime);
		
	}
	function padout(number) {
		return (number < 10) ? '0' + number : number;
	}	
	function get_wan_time(_t){
		wTimesec = parseInt(_t);
		if(wTimesec == 0){
			//wan_time = "N/A";
			wan_time = get_words('_na');
		}else{
			wTimesec = wTimesec/100;
			caculate_time();
			chk_typeAutoConf();
		}
		//get_by_id("network_ipv6_status").innerHTML = "+get_wan_time+"+wTimesec;
	}
	
	function WTime(){
		get_by_id("ipv6_conn_time").innerHTML = wan_time;
		if(wTimesec != 0){
			wTimesec++;
			caculate_time();
			chk_typeAutoConf();
			//get_by_id("network_ipv6_status").innerHTML = "+WTime()+"+wTimesec;
		}
		setTimeout('WTime()', 1000);
	}
	
	
	function h2d(h) {return parseInt(h,16);}

	function h2d2(a,b) {return parseInt(a,16)*16+parseInt(b,16);}

	function ipv6_link_local()
	{
		var u32_pf;
		var ary_ip6rd_pf = [0,0];
		var ary_ip4 = wan_addr4.split(".");
		var u32_ip4 = (ary_ip4[0]*Math.pow(2,24)) + (ary_ip4[1]*Math.pow(2,16)) + (ary_ip4[2]*Math.pow(2,8)) + parseInt(ary_ip4[3]);
		u32_pf = parseInt(u32_ip4);
		str_tmp = u32_pf.toString(16).lpad("0",8);
		ary_ip6rd_pf[0] = str_tmp.substr(0,4);
		ary_ip6rd_pf[1] = str_tmp.substr(4,4);

		//add by Vic
		if((v6Status.connType=="6")||(v6Status.connType=="9") )
		{
			if(v6Status.netState == "Connected")
				$('#tunnel_ipv6_addr').html("fe80::"+ary_ip6rd_pf[0]+":"+ary_ip6rd_pf[1]+"/64");
			else
				$('#tunnel_ipv6_addr').html(Show_);
		}
	}

	//20120906 pascal add 6to4 IANA adress
	function change_6to4_format(mainObj)
	{
		var address = mainObj.config_val('igdIPv6Status_IPAddressIANA_');
		var str="::";
		if(address != ""){
			var tmpv6ip =address.split(":");
			for(i=4;i<8;i++)
			{
				tmphex = "";
				tmphex = tmpv6ip[i].split("");
				if(tmphex.length == 1)
					str +=h2d(tmphex[0]);
				else
					str +=h2d2(tmphex[0], tmphex[1]);
				if(i<7)
					str +=".";
			}
			str +="/";
			str +=v6Status.WanIANAPrefixLen;
			$('#wan_ipv6_addriana').html('&nbsp;&nbsp;'+str);
			return false;
		}
		return true;
	}

	function get_6to4_ip(){
		var ipAddr = v6Status.wanIANA,
			ipAry = ipAddr.split(':'),
			tmpAddr = [];

			for(var i = 2; i < 6; i++){
				tmpAddr.push(parseInt(ipAry[i], 16));
			}

		return '::' + tmpAddr.join('.');
	}
	
	function get_v6_gw(is_v4_gw)
	{

		if(is_v4_gw == 0)
		{
			$('#wan_ipv6_gw').html((v6Status.gw == "")? Show_ :filter_ipv6_addr(v6Status.gw));
		}
		else
		{
			var i, tmphex, decvalue;
			//v6Status.gw = '';
			if(v6Status.gw != ""){
				$('#wan_ipv6_gw').html("::");
				var tmpv6gw = v6Status.gw.split(":");
				for(i=4;i<8;i++)
				{
					//alert(tmpv6gw[i]);
					tmphex = "";
					tmphex = tmpv6gw[i].split("");
					if(tmphex.length == 1)
						$('#wan_ipv6_gw')[0].innerHTML +=h2d(tmphex[0]);
					else
						$('#wan_ipv6_gw')[0].innerHTML +=h2d2(tmphex[0], tmphex[1]);
					if(i<7)
						$('#wan_ipv6_gw')[0].innerHTML +=".";
				}
			}
			else{
				$('#wan_ipv6_gw').html(Show_);
			}
		}
	}

	function show_dhcppd(dhcppd_support)
	{	
		if(dhcppd_support){
			if(v6Status.dhcpPdEn == 1)
			{
				$('#dhcp_pd').html(get_words('_enabled'));
				$('#ipv6_addr_by_dhcppd').html((v6Status.dhcpPdAddr == "")? Show_ :(v6Status.dhcpPdAddr+"/"+v6Status.dhcpPdLen));
			}	
			else
			{
				$('#dhcp_pd').html(get_words('_disabled'));
				$('#ipv6_addr_by_dhcppd').html(Show_);
			}
		}
		else
		{
			$('#dhcp_pd').html(get_words('_disabled'));
			$('#ipv6_addr_by_dhcppd').html(Show_);
		}
	}

	function set_control_button()
	{
		var wan_type = v6Status.connType;
		var commonAction1 = "do_connect()";
		var commonAction2 = "do_disconnect()";

		var button1_name = get_words('_connect');		//_connect;
		var button2_name = get_words('LS315');	//sd_Disconnect;
		var button1_action = commonAction1;
		var button2_action = commonAction2;
		//wan_type = '2';
		switch(wan_type)
		{
			case "0":	//is_autodetect
				break;

			case "1":	//is_static
			case "4":	//is_6in4
			case "5":	//is_6to4
			case "6":	//is_6rd
			case "7":	//is_linklocal
			case "8":	//is_dslite
				return;

			case "2":	//is_autoconf
			case "9":	//is_autoconf_6rd
				button1_name =  get_words('LS312');		//sd_Renew;
				button2_name = get_words('LS313');	//sd_Release;
				break;
				
			case "3":	//is_pppoe
				break;
		}

		$('#ctrl_buttons').html("<input type=\"button\" value=\""+button1_name+"\" name=\"connect\" id=\"connect\" onClick=\""+button1_action+"\">&nbsp;<input type=\"button\" value=\""+button2_name+"\" name=\"disconnect\" id=\"disconnect\" onClick=\""+button2_action+"\"></td>");
		if(v6Status.netState=="Disconnected")
			$('#disconnect').attr('disabled',true);
		else
			$('#connect').attr('disabled',true);

		//20120215 silvia add if wantype is autoconf renew always enable.
		if ((wan_type == '2')||(wan_type=='9'))
		{
			$('#connect').attr('disabled','');
			//if ((v6Status.wanIANA != "") || ((v6Status.dhcpPdEn == 1) && (v6Status.dhcpPdAddr != "")))
			if (((v6Status.wanIANA == "") && (v6Status.dhcpPdEn == 0))||
			((v6Status.WanIANAPrefixLen == "64") && (v6Status.dhcpPdEn == 0))||
			((v6Status.wanIANA == "") && (v6Status.dhcpPdEn == 1) && (v6Status.dhcpPdAddr == ""))||
			((v6Status.WanIANAPrefixLen == "64") && (v6Status.dhcpPdEn == 1) && (v6Status.dhcpPdAddr == "")))
				$('#disconnect').attr('disabled',true);
			else
				$('#disconnect').attr('disabled','');
		}

	/*	if(wan_type == '3')
		{
			if(v6Status.netState=="Disconnected")
			{
				if((v6Status.wanIANA != "0:0:0:0:0:0:0:0")||(v6Status.dhcpPdAddr != "0:0:0:0:0:0:0:0"))
				{
					$('#connect').attr('disabled',true);
					$('#disconnect').attr('disabled','');
				}
			}			
		}*/
		if (login_Info != "w") {
			$('#connect').attr('disabled',true);
			$('#disconnect').attr('disabled',true);
		}
	}

	function do_connect()
	{
		$('#network_ipv6_status').html(get_words('ddns_connecting'));
		$('#connect').attr('disabled',true);
		var conObj = new ccpObject();
		var paramConnect = {
			url: "get_set.ccp",
			arg: "ccp_act=doEvent&ccpSubEvent=CCP_SUB_DOWANCONNECT_V6"
		};
		conObj.get_config_obj(paramConnect);
	}

	function do_disconnect()
	{
		$('#network_ipv6_status').html(get_words('ddns_disconnecting'));
		$('#disconnect').attr('disabled',true);
		var disObj = new ccpObject();
		var paramDisconnect = {
			url: "get_set.ccp",
			arg: "ccp_act=doEvent&ccpSubEvent=CCP_SUB_DOWANDISCONNECT_V6"
		};
		disObj.get_config_obj(paramDisconnect);
	}

	function print_hostv6()
	{
		var str = 	'<tr><td>'+get_words('IPV6_TEXT0')+'</td>'+
					'<td>'+get_words('YM187')+'</td></tr>';

		if (lanHost != null && lanHost.name != null) {
			for(var i=0; i<lanHost.name.length; i++)
			{
				var lanHostip = filter_ipv6_addr(lanHost.ip[i]);
				str += "<tr><td>" + lanHostip+ "</td><td>" + sp_words(lanHost.name[i]) + "</td></tr>";
			}
		}
		$('#host6_table').html(str);
	}

	function replace_null_to_none(item){
		if(item=="(null)")
			item="none";
		return item;
	}

	//20120822 add by Silvia
	function chk_typeAutoConf()
	{
		if(v6Status.connType == "2")
		{
			if ((((v6Status.wanIANA) != '') || ((v6Status.wanAddr) != '')) && (v6Status.gw) != '')
				$('#network_ipv6_status').html(get_words('CONNECTED'));
			else{
				$('#network_ipv6_status').html(get_words('DISCONNECTED'));
				wan_time = get_words('_na');
			}
		}
		if(v6Status.connType == "9")
		{
			if ((((v6Status.wanIANA) != '') || ((v6Status.wanAddr) != '')) && (v6Status.gw) != '')
				$('#network_ipv6_status').html(get_words('CONNECTED'));
			else{
				$('#network_ipv6_status').html(get_words('DISCONNECTED'));
				wan_time = get_words('_na');
			}
		}
	}
</script>
</head>
<body>
<center>
	<input type="hidden" id="dhcp_list" name="dhcp_list" value=''>
	<input type="hidden" id="ipv6_wan_proto" name="ipv6_wan_proto" value=''>
	<input type="hidden" id="ipv6_pppoe_dynamic" name="ipv6_pppoe_dynamic" value=''>
	<input type="hidden" id="ipv6_6to4_tunnel_address" name="ipv6_6to4_tunnel_address" maxLength=80 size=80 value=''>
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
		<script>$(document).ready(function($){ajax_load_page('menu_top.asp', 'menu_top', 'top_b4');});</script>
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
			<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b7');});</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id="maincontent">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="box_header">
				<h1 style=" text-transform:none"><script>show_words('TEXT068')</script></h1><br>
				<script>show_words('TEXT069')</script>
				<br><br>
			</div>
			<div class="box">
				<h2 style=" text-transform:none"><script>show_words('TEXT070')</script></h2>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td align=right  nowrap><b><script>show_words('IPV6_TEXT29a')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="connection_ipv6_type" nowrap></span>
					</td>
				</tr>
				<tr id="tr_network_ipv6_status">
					<td align=right  nowrap><b><script>show_words('_networkstate')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="network_ipv6_status" nowrap></span>
					</td>
				</tr>
				<tr id="tr_ipv6_conn_time">
					<td align=right  nowrap><b><script>show_words('_conuptime')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="ipv6_conn_time" nowrap></span>
					</td>
				</tr>
				<tr id="tr_ipv6_show_button">
					<td >&nbsp;</td>
					<td width="300">&nbsp;
						<span id="show_button"></span><span id="ctrl_buttons"></span>
					</td>
				</tr>
				<tr id="tr_wan_ipv6_addriana">
					<td align=right  nowrap><b><script>show_words('TEXT071')</script> :</b></td>
					<td width="300">
						<div id="wan_ipv6_addriana" nowrap></div>
						<div id="wan_ipv6_StaticIP" nowrap></div>
						<div id="wan_ipv6_addr" nowrap></div>
						<div id="wan_ipv6_addrSec" nowrap></div>	
					</td>
				</tr>
				<tr id="tr_tunnel_ipv6_addr">
					<td align=right  nowrap><b><script>show_words('IPV6_TEXT145')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="tunnel_ipv6_addr" nowrap></span>
					</td>
				</tr>
				<tr id="tr_wan_ipv6_gw">
					<td align=right  nowrap><b><script>show_words('IPV6_TEXT75')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="wan_ipv6_gw" nowrap></span>
					</td>
				</tr>
				<tr id="tr_lan_ipv6_addr">
					<td align=right nowrap id="count_ip"><b><script>show_words('IPV6_TEXT46')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="lan_ipv6_addr" nowrap></span>
					</td>
				</tr>
				<tr id="tr_lan_ipv6_addr2" style="display:none">
					<td width="300">&nbsp;
						<span id="lan_ipv6_addr2" nowrap></span>
					</td>
				</tr>
				<tr id="tr_lan_link_local_ip">
					<td align=right  nowrap><b><script>show_words('IPV6_TEXT47')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="lan_link_local_ip" nowrap></span>
					</td>
				</tr>
				<tr id="tr_primary_ipv6_dns">
					<td align=right  nowrap><b><script>show_words('wwa_pdns')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="primary_ipv6_dns" nowrap></span>
					</td>
				</tr>
				<tr id="tr_secondary_ipv6_dns">
					<td align=right  nowrap><b><script>show_words('wwa_sdns')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="secondary_ipv6_dns" nowrap></span>
					</td>
				</tr>
				<tr id="tr_dhcp_pd">
					<td align=right  nowrap><b>DHCP-PD :</b></td>
					<td width="300">&nbsp;
						<span id="dhcp_pd" nowrap></span>
					</td>
				</tr>
				<tr id="tr_ipv6_addr_by_dhcppd">
					<td align=right ><b><script>show_words('IPV6_TEXT166')</script> :</b></td>
					<td width="300">&nbsp;
						<span id="ipv6_addr_by_dhcppd" nowrap></span>
					</td>
				</tr>
				</table>
			</div>

			<div class="box">
				<h2 style=" text-transform:none"><script>show_words('TEXT072')</script></h2>
				<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1 id='host6_table'>
				</table>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><script>show_words('IPV6_TEXT165')</script></p>
			<p><a href="support_status.asp#IPv6"><script>show_words('_more')</script>&hellip;</a></p>
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
	WTime();
	hasBgGetDevStatus = true;
</script>
</body>
</html>