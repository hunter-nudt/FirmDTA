<html>
<head>
<link rel="STYLESHEET" type="text/css" href="css_router.css">
<script language="JavaScript" src="lingual_<% CmoGetCfg("lingual","none"); %>.js"></script>
<script language="JavaScript" src="public.js"></script>
<script language="JavaScript" src="public_msg.js"></script>
<script language="JavaScript">
    var submit_button_flag = 0;
    var rule_max_num = 24;

    function onPageLoad()
    {
        var wlan_disabled = get_by_id("wlan0_enable").value == "0";
        get_by_id("wish_engine").disabled = wlan_disabled;

        set_checked(get_by_id("wish_engine_enabled").value, get_by_id("wish_engine"));
        set_checked(get_by_id("wish_http_enabled").value, get_by_id("wish_http"));
        set_checked(get_by_id("wish_media_enabled").value, get_by_id("wish_media"));
	/* Feature disabled in this model: set_checked(get_by_id("wish_auto_enabled").value, get_by_id("wish_auto")); */

        for (var i = 0; i < rule_max_num; i++) {
            var temp_qos;

            if (i > 9)
                temp_qos = get_by_id("wish_rule_" + i);
            else
                temp_qos = get_by_id("wish_rule_0" + i);

            if (temp_qos.value == "") {
                temp_qos.value = "0//1/0/0/6/0.0.0.0/255.255.255.255/0/65535/0.0.0.0/255.255.255.255/0/65535";
            }
        }

        wish_enable_click(get_by_id("wish_engine").checked);
        set_qos_rule();

        if ("<% CmoGetStatus("get_current_user"); %>" == "user"){
            DisableEnableForm(document.form1,true);
        }

        set_form_default_values("form1");
    }

    function wish_enable_click(obj_chk)
    {
        var is_disabled = !obj_chk;
        
        if (get_by_id("wlan0_enable").value == "0") {
            is_disabled = true;
        }
        
        get_by_id("wish_http").disabled = is_disabled;
        get_by_id("wish_media").disabled = is_disabled;
	/* Feature disabled in this model: get_by_id("wish_auto").disabled = is_disabled; */

        for (var i=0;i<rule_max_num;i++) {
            get_by_id("wish_rule_enabled"+i).disabled = is_disabled;
            get_by_id("name"+i).disabled = is_disabled;
            get_by_id("priority"+i).disabled = is_disabled;
            get_by_id("protocol"+i).disabled = is_disabled;
            get_by_id("protocol_select"+i).disabled = is_disabled;
            get_by_id("local_start_ip"+i).disabled = is_disabled;
            get_by_id("local_end_ip"+i).disabled = is_disabled;
            get_by_id("local_start_port"+i).disabled = is_disabled;
            get_by_id("local_end_port"+i).disabled = is_disabled;
            get_by_id("remote_start_ip"+i).disabled = is_disabled;
            get_by_id("remote_end_ip"+i).disabled = is_disabled;
            get_by_id("remote_start_port"+i).disabled = is_disabled;
            get_by_id("remote_end_port"+i).disabled = is_disabled;
        }
    }

    function set_qos_rule()
    {
        for (var i = 0; i < rule_max_num; i++) {
            var temp_qos;

            if (i > 9)
                temp_qos = (get_by_id("wish_rule_" + i).value).split("/");
            else
                temp_qos = (get_by_id("wish_rule_0" + i).value).split("/");

            if (temp_qos.length > 1) {
                if (temp_qos[0] == "1") {
                    get_by_id("wish_rule_enabled" + i).checked = true;
                }

                get_by_id("name" + i).value = temp_qos[1];
                set_selectIndex(temp_qos[2], get_by_id("priority" + i));
                set_protocol(i, temp_qos[5], get_by_id("protocol_select" + i));
                get_by_id("local_start_ip" + i).value = temp_qos[6];
                get_by_id("local_end_ip" + i).value = temp_qos[7];
                get_by_id("local_start_port" + i).value = temp_qos[8];
                get_by_id("local_end_port" + i).value = temp_qos[9];
                get_by_id("remote_start_ip" + i).value = temp_qos[10];
                get_by_id("remote_end_ip" + i).value = temp_qos[11];
                get_by_id("remote_start_port" + i).value = temp_qos[12];
                get_by_id("remote_end_port" + i).value = temp_qos[13];

                if (get_by_id("wish_engine").checked) {
                     detect_protocol_change_port(get_by_id("protocol_select"+i).selectedIndex, i);
                }
            }
        }
    }

    function set_protocol(i, which_value, obj)
    {
        set_selectIndex(which_value,obj);
        get_by_id("protocol" + i).disabled = true;

        if (which_value != obj.options[obj.selectedIndex].value) {
            get_by_id("protocol" + i).disabled = false;
            get_by_id("protocol_select" + i).selectedIndex = 5;
        }

        get_by_id("protocol" + i).value = which_value;
    }

    function protocol_change(i)
    {
        var obj_name = get_by_id("protocol_select"+i);
        if (obj_name.selectedIndex < 5) { //Any, TCP, UDP, Both, ICMP, Other
            get_by_id("protocol"+i).disabled = true;
            get_by_id("protocol"+i).value = obj_name.options[obj_name.selectedIndex].value;
        }
        else if (get_by_id("protocol_select" + i).selectedIndex == 5) { // Other
            get_by_id("protocol"+i).disabled = false;
            get_by_id("protocol"+i).value = "";
        }
    }

    function detect_protocol_change_port(proto, i)
    {
        if ((proto == 0) || (proto == 4) || (proto == 5)) {
            get_by_id("local_start_port"+i).disabled = true;
            get_by_id("local_end_port"+i).disabled = true;
            get_by_id("remote_start_port"+i).disabled = true;
            get_by_id("remote_end_port"+i).disabled = true;
        }
        else {
            get_by_id("local_start_port"+i).disabled = false;
            get_by_id("local_end_port"+i).disabled = false;
            get_by_id("remote_start_port"+i).disabled = false;
            get_by_id("remote_end_port"+i).disabled = false;
        }
    }

    function send_request()
    {
        if (!is_form_modified("form1") && !confirm(_ask_nochange)) {
            return false;
        }

        get_by_id("wish_engine_enabled").value = get_checked_value(get_by_id("wish_engine"));
        get_by_id("wish_http_enabled").value = get_checked_value(get_by_id("wish_http"));
        get_by_id("wish_media_enabled").value = get_checked_value(get_by_id("wish_media"));
	/* Feature disabled in this model: get_by_id("wish_auto_enabled").value = get_checked_value(get_by_id("wish_auto")); */

        //check rule
        var count = 0;
        for (var i = 0; i < rule_max_num; i++) {
            var local_start_ip = get_by_id("local_start_ip" + i).value;
            var local_end_ip = get_by_id("local_end_ip" + i).value;
            var remote_start_ip = get_by_id("remote_start_ip" + i).value;
            var remote_end_ip = get_by_id("remote_end_ip" + i).value;
            var local_start_port = parseInt(get_by_id("local_start_port" + i).value);
            var local_end_port = parseInt(get_by_id("local_end_port" + i).value);
            var remote_start_port = parseInt(get_by_id("remote_start_port" + i).value);
            var remote_end_port = parseInt(get_by_id("remote_end_port" + i).value);
            var ip_addr_msg = replace_msg(all_ip_addr_msg,"IP address");
            var remote_ip_addr_msg = replace_msg(all_ip_addr_msg,"Remote IP address");
            var temp_local_start_ip_obj = new addr_obj(local_start_ip.split("."), ip_addr_msg, false, false);
            var temp_local_end_ip_obj = new addr_obj(local_end_ip.split("."), ip_addr_msg, false, false);
            var temp_remote_start_ip_obj = new addr_obj(remote_start_ip.split("."), remote_ip_addr_msg, false, false);
            var temp_remote_end_ip_obj = new addr_obj(remote_end_ip.split("."), remote_ip_addr_msg, false, false);
            var temp_qos;
            var check_name = "";

            if (i > 9)
                get_by_id("wish_rule_" + i).value = "";
            else
                get_by_id("wish_rule_0" + i).value = "";

            //check protocol
            if (get_by_id("protocol_select" + i).selectedIndex == 5) {
                temp_obj = get_by_id("protocol" + i);
                var protocol_msg = replace_msg(check_num_msg, "protocol", 0, 255);
                obj = new varible_obj(temp_obj.value, protocol_msg, 0, 255, false);
                if (!check_varible(obj)) {
                    return false;
                }
            }

            if (get_by_id("name" + i).value != "") {
                // check name
                check_name = get_by_id("name" + i).value;
                if (Find_word(check_name,"'") || Find_word(check_name,'"') || Find_word(check_name,"/")) {
                    alert("Rules name "+ i +" invalid. the legal characters can not enter ',/,''");
                    get_by_id("name"+i).focus();
                    get_by_id("name"+i).select();
                    return false;
                }


                //check Priority
                temp_obj =  get_by_id("priority" + i);
                var priority_msg = replace_msg(check_num_msg, "Priority", 0, 7);
                obj = new varible_obj(temp_obj.value, priority_msg, 0, 7, false);
                if (!check_varible(obj)) {
                    return false;
                }

                //check ip
                if (local_start_ip != "0.0.0.0" && !check_address(temp_local_start_ip_obj)) {
                    return false;
                }
                if (local_end_ip != "255.255.255.255" && !check_address(temp_local_end_ip_obj)) {
                    return false;
                }
                if (remote_start_ip != "0.0.0.0" && !check_address(temp_remote_start_ip_obj)) {
                    return false;
                }
                if (remote_end_ip != "255.255.255.255" && !check_address(temp_remote_end_ip_obj)) {
                    return false;
                }

                //check port
                if ((get_by_id("protocol_select"+i).selectedIndex ==1) || (get_by_id("protocol_select"+i).selectedIndex ==2) || (get_by_id("protocol_select"+i).selectedIndex ==3)) {
                    if (local_start_port < 0 || local_start_port > 65535) {
						alert(YM51 +" '"+ check_name + "' " +YM68);
                        get_by_id("local_start_port"+i).focus();
                        get_by_id("local_start_port"+i).select();
                        return false;
					}
                    else if (local_end_port < 0 || local_end_port > 65535) {
						alert(YM51 +" '"+ check_name + "' " +YM69);
                        get_by_id("local_end_port"+i).focus();
                        get_by_id("local_end_port"+i).select();
                        return false;
					}
                    else if(local_start_port > local_end_port){
						alert(check_name + "' Host 1 port start, "+ local_start_port + ", must be less than host 1 port end, " + local_end_port);
                        get_by_id("local_start_port"+i).focus();
                        get_by_id("local_start_port"+i).select();
                        return false;
                    }

                    if (remote_start_port < 0 || remote_start_port > 65535) {
						alert(YM51 +" '"+ check_name + "' " +YM70);
                        get_by_id("remote_start_port"+i).focus();
                        get_by_id("remote_start_port"+i).select();
                        return false;
                    }
                    else if (remote_end_port < 0 || remote_end_port > 65535) {
						alert(YM51 +" '"+ check_name + "' " +YM71);
                        get_by_id("remote_end_port"+i).focus();
                        get_by_id("remote_end_port"+i).select();
                        return false;
                    }
                    else if (remote_start_port > remote_end_port) {
						alert(check_name + "' Host 2 port start, " + remote_start_port + ", must be less than host 2 port end, " + remote_end_port);
                        get_by_id("remote_start_port"+i).focus();
                        get_by_id("remote_start_port"+i).select();
                        return false;
                    }
                }
            }
            else {
                if (get_by_id("wish_rule_enabled" + i).checked == true) {
					alert(YM49+" "+i+".");
                    return false;
                }
            }

            if (count > 9)
                temp_qos = get_by_id("wish_rule_" + count);
            else
                temp_qos = get_by_id("wish_rule_0" + count);

            //enable/name/priority/uplink/downlink/protocol/local_start_ip/local_end_ip/local_start_port/local_end_port/remote_start_ip/remote_end_ip/remote_start_port/remote_end_port
            temp_qos.value = get_checked_value(get_by_id("wish_rule_enabled" + i)) + "/" + get_by_id("name" + i).value + "/" + get_by_id("priority" + i).value  + "/"
                            + "0/0/"
                            + get_by_id("protocol" + i).value + "/"
                            + get_by_id("local_start_ip" + i).value + "/" + get_by_id("local_end_ip" + i).value + "/" + get_by_id("local_start_port" + i).value + "/"
                            + get_by_id("local_end_port" + i).value+ "/" + get_by_id("remote_start_ip" + i).value + "/"
                            + get_by_id("remote_end_ip" + i).value + "/" + get_by_id("remote_start_port" + i).value + "/" + get_by_id("remote_end_port" + i).value;
            count++;
        }

        //check same as rule
        for (var i = 0; i < rule_max_num; i++) {
            var local_start_ip = get_by_id("local_start_ip" + i).value;
            var local_end_ip = get_by_id("local_end_ip" + i).value;
            var remote_start_ip = get_by_id("remote_start_ip" + i).value;
            var remote_end_ip = get_by_id("remote_end_ip" + i).value;
            var local_start_port = parseInt(get_by_id("local_start_port" + i).value);
            var local_end_port = parseInt(get_by_id("local_end_port" + i).value);
            var remote_start_port = parseInt(get_by_id("remote_start_port" + i).value);
            var remote_end_port = parseInt(get_by_id("remote_end_port" + i).value);
            var rule_protocol = get_by_id("protocol_select"+i).selectedIndex;
            var rule_Priority = get_by_id("priority"+i).selectedIndex;

            for (var j = 0; j < rule_max_num; j++) {
                if (j != i) {
                    var local_start_ip_chk = get_by_id("local_start_ip" + j).value;
                    var local_end_ip_chk = get_by_id("local_end_ip" + j).value;
                    var remote_start_ip_chk = get_by_id("remote_start_ip" + j).value;
                    var remote_end_ip_chk = get_by_id("remote_end_ip" + j).value;
                    var local_start_port_chk = parseInt(get_by_id("local_start_port" + j).value);
                    var local_end_port_chk = parseInt(get_by_id("local_end_port" + j).value);
                    var remote_start_port_chk = parseInt(get_by_id("remote_start_port" + j).value);
                    var remote_end_port_chk = parseInt(get_by_id("remote_end_port" + j).value);
                    var rule_protocol_chk = get_by_id("protocol_select"+j).selectedIndex;
                    var rule_Priority_chk = get_by_id("priority"+j).selectedIndex;

                    //check enable
                    if (get_by_id("wish_rule_enabled" + i).checked != true) {
                        continue;
                    }

                    //check enable
                    if (get_by_id("wish_rule_enabled" + j).checked != true) {
                        continue;
                    }

                    //check protocol
                    if (rule_protocol_chk != rule_protocol) {
                        continue;
                    }

                    //check ip
                    if (local_start_ip_chk != local_start_ip) {
                        continue;
                    }
                    if (local_end_ip_chk != local_end_ip) {
                        continue;
                    }
                    if (remote_start_ip_chk != remote_start_ip) {
                        continue;
                    }
                    if (remote_end_ip_chk != remote_end_ip) {
                        continue;
                    }
                    if (rule_Priority_chk != rule_Priority) {
                    	  continue;
                    }

                    //check port
                    //if ((rule_protocol == 1) || (rule_protocol == 2) || (rule_protocol == 3)) {
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
                        alert("Rules"+i+" is seting same as Rules"+j+".");
                        return false;
                    //}
                }
            }
        }

        if (submit_button_flag == 0) {
            submit_button_flag = 1;
            return true;
        }

        return false;
    }
</script>

<title><% CmoGetStatus("title"); %></title>
<meta http-equiv=Content-Type content="text/html; charset=UTF8">
<style type="text/css">
<!--
.style1 {font-size: 11px}
-->
</style>
</head>
<body onload="onPageLoad();" topmargin="1" leftmargin="0" rightmargin="0" bgcolor="#757575">
    <table id="header_container" border="0" cellpadding="5" cellspacing="0" width="838" align="center">
      <tr>
        <td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"><% CmoGetCfg("model_number","none"); %></a></td>
		<td align="right" nowrap><script>show_words('TA3')</script>: <% CmoGetStatus("hw_version"); %> &nbsp;</td>
		<td align="right" nowrap><script>show_words('sd_FW')</script>: <% CmoGetStatus("version"); %></td>
                <td>&nbsp;</td>
      </tr>
  </table>
		<div id="header_banner"></div>
    <table border="0" cellpadding="2" cellspacing="1" width="838" align="center" bgcolor="#FFFFFF">
        <tr id="topnav_container">
            <td><img src="short_modnum.gif" width="125" height="25"></td>
			<td id="topnavoff"><a href="index.asp" onclick="return jump_if();"><script>show_words('_setup')</script></a></td>
			<td id="topnavon"><a href="adv_virtual.asp" onclick="return jump_if();"><script>show_words('_advanced')</script></a></td>
			<td id="topnavoff"><a href="tools_admin.asp" onclick="return jump_if();"><script>show_words('_tools')</script></a></td>
			<td id="topnavoff"><a href="st_device.asp" onclick="return jump_if();"><script>show_words('_status')</script></a></td>
			<td id="topnavoff"><a href="support_men.asp" onclick="return jump_if();"><script>show_words('_support')</script></a></td>
        </tr>
    </table>
    <table id="topnav_container" border="1" cellpadding="2" cellspacing="0" width="838" height="100%" align="center" bgcolor="#FFFFFF" bordercolordark="#FFFFFF">
        <tr>
            <td id="sidenav_container" valign="top" width="125" align="right">
                <table cellSpacing=0 cellPadding=0 border=0>
            <tr>
              <td id=sidenav_container>
                <div id=sidenav>
                  <UL>
				    <LI><div><a href="adv_virtual.asp" onClick="return jump_if();"><script>show_words('_virtserv')</script></a></div></LI>
                    <LI><div><a href="adv_portforward.asp" onclick="return jump_if();"><script>show_words('_pf')</script></a></div></LI>
                    <LI><div><a href="adv_appl.asp" onclick="return jump_if();"><script>show_words('_specappsr')</script></a></div></LI>
                    <LI><div><a href="adv_qos.asp" onclick="return jump_if();"><script>show_words('YM48')</script></a></div></LI>
                    <LI><div><a href="adv_filters_mac.asp" onclick="return jump_if();"><script>show_words('_netfilt')</script></a></div></LI>
                    <LI><div><a href="adv_access_control.asp" onclick="return jump_if();"><script>show_words('_acccon')</script></a></div></LI>
					<LI><div><a href="adv_filters_url.asp" onclick="return jump_if();"><script>show_words('_websfilter')</script></a></div></LI>
					<LI><div><a href="Inbound_Filter.asp" onclick="return jump_if();"><script>show_words('_inboundfilter')</script></a></div></LI>
					<LI><div><a href="adv_dmz.asp" onclick="return jump_if();"><script>show_words('_firewalls')</script></a></div></LI>
                    <LI><div><a href="adv_routing.asp" onclick="return jump_if();"><script>show_words('_routing')</script></a></div></LI>
					<LI><div><a href="adv_wlan_perform.asp" onclick="return jump_if();"><script>show_words('_adwwls')</script></a></div></LI>
                    <LI><div id=sidenavoff>WISH</div></LI>
					<LI><div><a href="adv_wps_setting.asp" onclick="return jump_if();"><script>show_words('LY2')</script></a></div></LI>
                    <LI><div><a href="adv_network.asp" onclick="return jump_if();"><script>show_words('_advnetwork')</script></a></div></LI>
                    <LI><div><a href="guest_zone.asp" onclick="return jump_if();"><script>show_words('_guestzone')</script></a></div></LI>
                    <LI><div><a href="adv_ipv6_sel_wan.asp" onclick="return jump_if();">IPv6 </a></div></LI>
                  </UL>
                </div>
              </td>
            </tr>
        </table></td>

            <form id="form1" name="form1" method="post" action="">
            <input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
            <input type="hidden" id="html_response_message" name="html_response_message" value="">
            <script>get_by_id("html_response_message").value = get_words('sc_intro_sv');</script>
            <input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_wish.asp">
            <input type="hidden" id="reboot_type" name="reboot_type" value="wireless">

            <input type="hidden" id="wlan0_enable" name="wlan0_enable" value="<% CmoGetCfg("wlan0_enable","none"); %>">            

            <input type="hidden" id="wish_rule_00" name="wish_rule_00" value="<% CmoGetCfg("wish_rule_00","none"); %>">
            <input type="hidden" id="wish_rule_01" name="wish_rule_01" value="<% CmoGetCfg("wish_rule_01","none"); %>">
            <input type="hidden" id="wish_rule_02" name="wish_rule_02" value="<% CmoGetCfg("wish_rule_02","none"); %>">
            <input type="hidden" id="wish_rule_03" name="wish_rule_03" value="<% CmoGetCfg("wish_rule_03","none"); %>">
            <input type="hidden" id="wish_rule_04" name="wish_rule_04" value="<% CmoGetCfg("wish_rule_04","none"); %>">
            <input type="hidden" id="wish_rule_05" name="wish_rule_05" value="<% CmoGetCfg("wish_rule_05","none"); %>">
            <input type="hidden" id="wish_rule_06" name="wish_rule_06" value="<% CmoGetCfg("wish_rule_06","none"); %>">
            <input type="hidden" id="wish_rule_07" name="wish_rule_07" value="<% CmoGetCfg("wish_rule_07","none"); %>">
            <input type="hidden" id="wish_rule_08" name="wish_rule_08" value="<% CmoGetCfg("wish_rule_08","none"); %>">
            <input type="hidden" id="wish_rule_09" name="wish_rule_09" value="<% CmoGetCfg("wish_rule_09","none"); %>">
            <input type="hidden" id="wish_rule_10" name="wish_rule_10" value="<% CmoGetCfg("wish_rule_10","none"); %>">
            <input type="hidden" id="wish_rule_11" name="wish_rule_11" value="<% CmoGetCfg("wish_rule_11","none"); %>">
            <input type="hidden" id="wish_rule_12" name="wish_rule_12" value="<% CmoGetCfg("wish_rule_12","none"); %>">
            <input type="hidden" id="wish_rule_13" name="wish_rule_13" value="<% CmoGetCfg("wish_rule_13","none"); %>">
            <input type="hidden" id="wish_rule_14" name="wish_rule_14" value="<% CmoGetCfg("wish_rule_14","none"); %>">
            <input type="hidden" id="wish_rule_15" name="wish_rule_15" value="<% CmoGetCfg("wish_rule_15","none"); %>">
            <input type="hidden" id="wish_rule_16" name="wish_rule_16" value="<% CmoGetCfg("wish_rule_16","none"); %>">
            <input type="hidden" id="wish_rule_17" name="wish_rule_17" value="<% CmoGetCfg("wish_rule_17","none"); %>">
            <input type="hidden" id="wish_rule_18" name="wish_rule_18" value="<% CmoGetCfg("wish_rule_18","none"); %>">
            <input type="hidden" id="wish_rule_19" name="wish_rule_19" value="<% CmoGetCfg("wish_rule_19","none"); %>">
            <input type="hidden" id="wish_rule_20" name="wish_rule_20" value="<% CmoGetCfg("wish_rule_20","none"); %>">
            <input type="hidden" id="wish_rule_21" name="wish_rule_21" value="<% CmoGetCfg("wish_rule_21","none"); %>">
            <input type="hidden" id="wish_rule_22" name="wish_rule_22" value="<% CmoGetCfg("wish_rule_22","none"); %>">
            <input type="hidden" id="wish_rule_23" name="wish_rule_23" value="<% CmoGetCfg("wish_rule_23","none"); %>">

            <td valign="top" id="maincontent_container">
                <div id="maincontent">
                  <div id=box_header>
                    <h1><script>show_words('YM63')</script></h1>
                     <script>show_words('YM72')</script>
                    <br><br>
                    <input name="button" id="button" type="submit" class=button_submit value="" onClick="return send_request()">
					<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'adv_wish.asp');">
					<script>get_by_id("button").value = _savesettings;</script>
					<script>get_by_id("button2").value = _dontsavesettings;</script>
                  </div>
                  <div class=box>
                    <h2><script>show_words('YM63')</script></h2>
                    <table width=525>
                                        <tr>
												<td width="185" align=right class="duple"><script>show_words('YM73')</script>
                  :</td>
                                                <td width="333">&nbsp;
                                                <input type="checkbox" id="wish_engine" name="wish_engine" value="1" onClick="wish_enable_click(this.checked)">
                                                <input type="hidden" id="wish_engine_enabled" name="wish_engine_enabled" value="<% CmoGetCfg("wish_engine_enabled","none"); %>">
                                                </td>
                                        </tr>
                    </table>
                  </div>
                  <div class=box>
                    <h2><script>show_words('YM74')</script>
            </h2>
                    <table width=525>
                                        <tr>
												<td width="185" align=right class="duple"><script>show_words('gw_vs_1')</script>
                  :</td>
                        <td width="333">&nbsp;
                                                <input type="checkbox" id="wish_http" name="wish_http" value="1">
                                                    <input type="hidden" id="wish_http_enabled" name="wish_http_enabled" value="<% CmoGetCfg("wish_http_enabled","none"); %>">
                                            </td>
                                            </tr>
                                            <tr>
											  <td align=right class="duple"><script>show_words('YM75')</script>
                  :</td>
                        <td>&nbsp;
                                                <input type="checkbox" id="wish_media" name="wish_media" value="1">
                                                    <input type="hidden" id="wish_media_enabled" name="wish_media_enabled" value="<% CmoGetCfg("wish_media_enabled","none"); %>">
                                            </td>
                                            </tr>
<!--
-------------------------------------
Unsupported feature in this model
-------------------------------------
                                            <tr>
											  <td align=right class="duple"><script>show_words('YM76')</script> : </td>
                        <td>&nbsp;
                                                <input type="checkbox" id="wish_auto" name="wish_auto" value="1">
                                                    <input type="hidden" id="wish_auto_enabled" name="wish_auto_enabled" value="<% CmoGetCfg("wish_auto_enabled","none"); %>">
					  						  <script>show_words('ZM2')</script>
                                            </td>
                                            </tr>
-->
                    </table>
                  </div>
                  <div class=box>
                    <h2>24 -- <script>show_words('YM77')</script></h2>
                    <table bordercolor=#ffffff cellspacing=1 cellpadding=2 width=525 bgcolor=#dfdfdf border=1>
                        <script>
                                for(var i=0; i <rule_max_num ; i++){
                                        document.write("<tr>");
                                        document.write("<td rowspan=3><input type=checkbox id=wish_rule_enabled"+ i + " name=wish_rule_enabled"+ i + "\" value=\"1\"></td>");
                                        document.write("<td>Name<br><input id=name" + i + " name=name" + i +" type=text size=16 maxlength=15></td>");
                                        document.write("<td> Priority<br>");
                                        document.write("<select id=priority"+ i + " name=priority"+ i + ">");
                                        document.write("<option value=1>Background (BK)</option>");
                                        document.write("<option value=0>Best Effort (BE)</option>");
                                        document.write("<option value=4>Video (VI)</option>");
                                        document.write("<option value=6>Voice (VO)</option>");
                                        document.write("</select>");
                                        document.write("</td>");
                                        document.write("<td>Protocol<br>");
                                        document.write("<input id=protocol"+ i + " name=protocol"+ i + " maxlength=3 size=2 type=text>");
                                        document.write("  <<  ");
                                        document.write("<select id=\"protocol_select"+ i + "\" name=\"protocol_select"+ i + "\" onChange=\"protocol_change(" + i + ");detect_protocol_change_port(this.selectedIndex,'" + i + "');\">");
                                        document.write("<option value=256>Any</option>");
                                        document.write("<option value=6>TCP</option>");
                                        document.write("<option value=17>UDP</option>");
                                        document.write("<option value=257>Both</option>");
                                        document.write("<option value=1>ICMP</option>");
                                        document.write("<option value=-1>Other</option>");
                                        document.write("</select></td>");
                                        document.write("</tr>");
                                        document.write("<tr>");
                                        document.write("<td colspan=2 width=60%>Host 1 IP Range<br>");
                                        document.write("<input id=local_start_ip"+ i + " name=local_start_ip"+ i + " type=text size=14 maxlength=15>to<input id=local_end_ip"+ i + " name=local_end_ip"+ i + " type=text size=14 maxlength=15>");
                                        document.write("</td>");
                                        document.write("<td>Host 1 Port Range<br>");
                                        document.write("<input id=local_start_port"+ i + " name=local_start_port"+ i + " type=text size=4 maxlength=5>to<input id=local_end_port"+ i + " name=local_end_port"+ i + " type=text size=4 maxlength=5>");
                                        document.write("</td>");
                                        document.write("</tr>");
                                        document.write("<tr>");
                                        document.write("<td colspan=2 width=60%>Host 2 IP Range<br>");
                                        document.write("<input id=remote_start_ip"+ i + " name=remote_start_ip"+ i + " type=text size=14 maxlength=15>to<input id=remote_end_ip"+ i + " name=remote_end_ip"+ i + " type=text size=14 maxlength=15>");
                                        document.write("</td>");
                                        document.write("<td>Host 2 Port Range<br>");
                                        document.write("<input id=remote_start_port"+ i + " name=remote_start_port"+ i + " type=text size=4 maxlength=5 >to<input id=remote_end_port"+ i + " name=remote_end_port"+ i + " type=text size=4 maxlength=5>");
                                        document.write("</td>");
                                        document.write("</tr>");
                                }
                        </script>
                    </table>
                  </div>
                </div>
             </td></form>
            <td valign="top" width="150" id="sidehelp_container" align="left">
                <table borderColor=#ffffff cellSpacing=0 borderColorDark=#ffffff  cellPadding=2 bgColor=#ffffff borderColorLight=#ffffff border=0>
                  <tr>

          <td id=help_text><strong><b>
            <script>show_words('_hints')</script>
            </b>&hellip;</strong>
            <p><script>show_words('YM86')</script></p>
	                   <p><script>show_words('YM87')</script></p>
	                   <p class="more"><a href="support_adv.asp#WISH" onclick="return jump_if();"><script>show_words('_more')</script>&hellip;</a></p>
                       </TD>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table id="footer_container" border="0" cellpadding="0" cellspacing="0" width="838" align="center">
        <tr>
            <td width="125" align="center">&nbsp;&nbsp;<img src="wireless_tail.gif" width="114" height="35"></td>
            <td width="10">&nbsp;</td><td>&nbsp;</td>
        </tr>
    </table>
<br>
<div id="copyright"><% CmoGetStatus("copyright"); %></div>
<br>
</body>
</html>