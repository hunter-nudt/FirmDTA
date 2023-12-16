<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><% getWlanExist("stat"); %> Network Camera</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {color: #339900}
.style2 {color: #0048c0}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	background: url("images/bg.gif");
}
.style6 {
	color: #6699ff;
	background-color: FAFAF4;
}
.style7 {font-size: 12px}
.style8 {
	background-color: E5E5e5;
}
-->
</style>
<script language="JavaScript" type="text/javascript" src="language.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("network_2",item_name[_NETWORK]);
	setContent("network_3",item_name[_NETWORK]);
	setContent("network_4",item_name[_NETWORK]);
	setContent("ip_setting",item_name[_IP_SETTING]);
	setContent("dhcp",item_name[_DHCP]);
	setContent("static_ip",item_name[_STATIC_IP]);
	setContent("ip",item_name[_IP]);
	setContent("subnet_mask",item_name[_SUBNET_MASK]);
	setContent("default_gw",item_name[_DEFAULT_GW]);
	setContent("pri_dns",item_name[_PRI_DNS]);
	setContent("sec_dns",item_name[_SEC_DNS]);
	setContent("pppoe",item_name[_PPPOE]);
	setContent("user_name",item_name[_PPPOE_USER]);
	setContent("pwd",item_name[_PPPOE_PWD]);
	setContent("ddns_set",item_name[_DDNS_SETTING]);
	setContent("enable",item_name[_ENABLE]);
	setContent("provider",item_name[_PROVIDER]);
	setContent("host_name",item_name[_HOST_NAME]);
	setContent("user_name_1",item_name[_DDNS_USER]);
	setContent("pwd_1",item_name[_DDNS_PWD]);
	setContent("upnp",item_name[_UPNP]);
	setContent("enable_1",item_name[_ENABLE]);
	setContent("upnp_forward",item_name[_UPNP_FORWARD]);
	setContent("enable_2",item_name[_ENABLE]);
	setContent("ports_num",item_name[_PORTS_NUM]);
	setContent("http_port",item_name[_HTTP_PORT]);
	setContent("default_80",item_name[_DEF_80]);
	setContent("https",item_name[_HTTPS]);
	setContent("enable_3",item_name[_ENABLE]);
	setContent("https_port",item_name[_HTTPS_PORT]);
	setContent("default_443",item_name[_DEF_443]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}	

function send(){
	var o = document.form1;
	if(o.iptype[1].checked){
		if(ipCheck(o.ip1,o.ip2,o.ip3,o.ip4,true)==false)	return;
		if(ipCheck(o.netmask1,o.netmask2,o.netmask3,o.netmask4,true)==false)	return;
		if(ipCheck(o.gateway1,o.gateway2,o.gateway3,o.gateway4)==false)	return;
		if(ipCheck(o.dns1_1,o.dns1_2,o.dns1_3,o.dns1_4)==false)	return;
		if(ipCheck(o.dns2_1,o.dns2_2,o.dns2_3,o.dns2_4)==false)	return;		
	}else if(o.iptype[2].checked){
		if(isFilled(o.pppoeuser) == false) return;
		if(isFilled(o.pppoepass) == false) return;			
	}else if(o.iptype[2].checked){
		if(isFilled(o.pppoeuser) == false || asciiCheck(o.pppoeuser)==false) return;
		if(isFilled(o.pppoepass) == false || asciiCheck(o.pppoepass)==false) return;			
	}

	if(o.ddns_enable.checked)
	{
		if(isFilled(o.ddns_hostname) == false || asciiCheck(o.ddns_hostname) == false) return;
		if(isFilled(o.ddns_user) == false || asciiCheck(o.ddns_user) == false) return;
		if(isFilled(o.ddns_pass) == false || asciiCheck(o.ddns_pass) == false) return;	
	}
	
	if(rangeCheck(o.httpport,1,65535)==false)	return;
	if(rangeCheck(o.httpsport,1,65535)==false)	return;
	if(confirm(popup_msg[popup_msg_29]))
		document.form1.reboot.value = "1";
	document.form1.submit();
}
function disform(){
	var o = document.form1;
	var flag;
	if(o.iptype[1].checked)
	{		flag0 = false;flag1 = true; flag2 = true;}
	else if(o.iptype[0].checked)
	{		flag0 = true;flag1 = false; flag2 = true;}
	else if(o.iptype[2].checked)
	{		flag0 = true;flag1 = true; flag2 = false;}
			
			o.ip1.disabled = flag0;
			o.ip2.disabled = flag0;
			o.ip3.disabled = flag0;
			o.ip4.disabled = flag0;
			o.netmask1.disabled = flag0;
			o.netmask2.disabled = flag0;
			o.netmask3.disabled = flag0;
			o.netmask4.disabled = flag0;
			o.gateway1.disabled = flag0;
			o.gateway2.disabled = flag0;
			o.gateway3.disabled = flag0;
			o.gateway4.disabled = flag0;
			o.dns1_1.disabled = flag0;
			o.dns1_2.disabled = flag0;
			o.dns1_3.disabled = flag0;
			o.dns1_4.disabled = flag0;
			o.dns2_1.disabled = flag0;
			o.dns2_2.disabled = flag0;
			o.dns2_3.disabled = flag0;
			o.dns2_4.disabled = flag0;
			o.pppoeuser.disabled = flag2;
			o.pppoepass.disabled = flag2;			
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="network_2" name="network_2"></span>&nbsp;&raquo;&nbsp;<span id="network_3" name="network_3"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<form action="network.cgi" method="post" name="form1">
  			<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
					<tr>
						<td colspan="2" valign="top" class="greybluebg"><span id="network_4" name="network_4"></span></td>
					</tr>
      		<tr>
        		<td width="150" valign="top" class="bgblue"><span id="ip_setting" name="ip_setting"> </span>:</td>
      			<td class="bggrey" width="400">
      				<table width="100%"  border="0" cellpadding="2" cellspacing="1" class="box_tn">
	      				<tr>
	        				<td colspan="2">
	        					<input name="iptype" type="radio" value="1"  <% getIpType("1"); %> onClick="disform();">
	          				<span id="dhcp" name="dhcp"></span>
	          			</td>
	        				<td>&nbsp;</td>
	      				</tr>
	      				<tr>
	        				<td colspan="2">
	        					<input name="iptype" type="radio" value="0"  <% getIpType("0"); %>  onclick="disform();"> 
	          				<span id="static_ip" name="static_ip"></span>
	          			</td>
	        				<td>&nbsp;</td>
	      				</tr>
	      				<tr>
	        				<td width="28">&nbsp;</td>
	        				<td width="106"><span id="ip" name="ip"></span>: </td>
	        				<td>
	        					<input name="ip1" type="text" class="box_ip" id="ip1" value="<% getStaticIp("1"); %>" size="3" maxlength="3">
										.
										<input name="ip2" type="text" class="box_ip" id="ip2" value="<% getStaticIp("2"); %>" size="3" maxlength="3">
										.
										<input name="ip3" type="text" class="box_ip" id="ip3" value="<% getStaticIp("3"); %>" size="3" maxlength="3">
										.
										<input name="ip4" type="text" class="box_ip" id="ip4" value="<% getStaticIp("4"); %>" size="3" maxlength="3">
									</td>
						    </tr>
	      				<tr>
	        				<td>&nbsp;</td>
	        				<td><span id="subnet_mask" name="subnet_mask"></span>: </td>
	        				<td>
	         					<input name="netmask1" type="text" class="box_ip" id="netmask1" value="<% getNetmask("1"); %>" size="3" maxlength="3"> 
	         					.
	          				<input name="netmask2" type="text" class="box_ip" id="netmask2" value="<% getNetmask("2"); %>" size="3" maxlength="3">
	          				.
										<input name="netmask3" type="text" class="box_ip" id="netmask3" value="<% getNetmask("3"); %>" size="3" maxlength="3">
	          				.
										<input name="netmask4" type="text" class="box_ip" id="netmask4" value="<% getNetmask("4"); %>" size="3" maxlength="3">
									</td>
								</tr>
	      				<tr>
	        				<td>&nbsp;</td>
	        				<td><span id="default_gw" name="default_gw"></span>: </td>
	        				<td>
	        					<input name="gateway1" type="text" class="box_ip" id="gateway1" value="<% getGateway("1"); %>" size="3" maxlength="3">
	          				.
	          				<input name="gateway2" type="text" class="box_ip" id="gateway2" value="<% getGateway("2"); %>" size="3" maxlength="3">
	          				.
	          				<input name="gateway3" type="text" class="box_ip" id="gateway3" value="<% getGateway("3"); %>" size="3" maxlength="3">
	          				.
	          				<input name="gateway4" type="text" class="box_ip" id="gateway4" value="<% getGateway("4"); %>" size="3" maxlength="3">
	          			</td>
	          		</tr>
	      				<tr>
	        				<td>&nbsp;</td>
	        				<td><span id="pri_dns" name="pri_dns"></span>: </td>
	        				<td>
	        					<input name="dns1_1" type="text" class="box_ip" id="dns1_1" value="<% getDns1("1"); %>" size="3" maxlength="3">
	          				.
	          				<input name="dns1_2" type="text" class="box_ip" id="dns1_2" value="<% getDns1("2"); %>" size="3" maxlength="3">
	          				.
										<input name="dns1_3" type="text" class="box_ip" id="dns1_3" value="<% getDns1("3"); %>" size="3" maxlength="3">
	          				.
										<input name="dns1_4" type="text" class="box_ip" id="dns1_4" value="<% getDns1("4"); %>" size="3" maxlength="3">
									</td>
	      				</tr>
	      				<tr>
	        				<td>&nbsp;</td>
	        				<td><span id="sec_dns" name="sec_dns"></span>: </td>
	        				<td>
	        					<input name="dns2_1" type="text" class="box_ip" id="dns2_1" value="<% getDns2("1"); %>" size="3" maxlength="3">
	          				.
	          				<input name="dns2_2" type="text" class="box_ip" id="dns2_2" value="<% getDns2("2"); %>" size="3" maxlength="3">
	          				.
										<input name="dns2_3" type="text" class="box_ip" id="dns2_3" value="<% getDns2("3"); %>" size="3" maxlength="3">
	          				.
										<input name="dns2_4" type="text" class="box_ip" id="dns2_4" value="<% getDns2("4"); %>" size="3" maxlength="3">
									</td>
	      				</tr>
	      				<tr>
	        				<td colspan="2">
	        					<input name="iptype" type="radio" value="2" <% getIpType("2"); %> onClick="disform();">
	          				<span id="pppoe" name="pppoe"></span>
	          			</td>
	        				<td>&nbsp;</td>
	      				</tr>
	      				<tr>
	        				<td>&nbsp;</td>
	        				<td><span id="user_name" name="user_name"></span>: </td>
	        				<td><input name="pppoeuser" type="text" class="box_text" id="pppoeuser" value="<% getPppoeUser(); %>" size="20" maxlength="32"></td>
	      				</tr>
	      				<tr>
	      				  <td>&nbsp;</td>
	      				  <td><span id="pwd" name="pwd"></span>: </td>
	      				  <td><input name="pppoepass" type="password" class="box_text" id="pppoepass" value="<% getPppoePass(); %>" size="20" maxlength="32"></td>
	      				</tr>
      				</table>
      			</td>
      		</tr>
      		<tr>
        		<td valign="top" class="bgblue"><span id="ddns_set" name="ddns_set"> </span>:</td>
      			<td class="bggrey">
        			<table width="100%"  border="0" cellpadding="2" cellspacing="1" class="box_tn">
	      				<tr>
	        				<td width="137">
	        					<input name="ddns_enable" type="checkbox" id="ddns_enable" value="1" <% getDdnsEnable("1"); %>>
	        					<span id="enable" name="enable"></span>
	        				</td>
	        				<td>&nbsp;</td>
	      				</tr>
	      				<tr>
	        				<td><span id="provider" name="provider"></span>: </td>
	        				<td><select name="ddns_provider" id="ddns_provider"><% getDdnsProvider(); %></select></td>
	      				</tr>
	      				<tr>
	        				<td><span id="host_name" name="host_name"></span>: </td>
	        				<td><input name="ddns_hostname" type="text" class="box_text" id="ddns_hostname" value="<% getDdnsHostname(); %>" size="20" maxlength="32"></td>
	      				</tr>
	      				<tr>
	        				<td><span id="user_name_1" name="user_name_1"></span>: </td>
	        				<td><input name="ddns_user" type="text" class="box_text" id="ddns_user" value="<% getDdnsUser(); %>" size="20" maxlength="32"></td>
	      				</tr>
	      				<tr>
	        				<td><span id="pwd_1" name="pwd_1"></span>: </td>
	        				<td><input name="ddns_pass" type="password" class="box_text" id="ddns_pass" value="<% getDdnsPass(); %>" size="20" maxlength="32"></td>
	      				</tr>
      				</table>
      			</td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="upnp" name="upnp"> </span>:</td>
        		<td class="bggrey">
        			<table width="100%"  border="0" cellpadding="2" cellspacing="1" class="box_tn">
	      				<tr>
	        				<td width="137">
	        					<input name="upnpenable" type="checkbox" id="upnpenable" value="1" <% getUpnpEnable("1"); %>>
	          				<span id="enable_1" name="enable_1"></span>
	          			</td>
	      				</tr>
	  					</table>
	  				</td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="upnp_forward" name="upnp_forward"> </span>:</td>
        		<td class="bggrey">
        			<table width="100%"  border="0" cellpadding="2" cellspacing="1" class="box_tn">
	      				<tr>
	        				<td width="137">
	        					<input name="upnpforwardenable" type="checkbox" id="upnpforwardenable" value="1" <% getUpnpFowardEnable("1"); %>>
	          				<span id="enable_2" name="enable_2"></span>
	          			</td>
	      				</tr>
	  					</table>
	  				</td>
      		</tr>
      		<tr>
        		<td valign="top" class="bgblue"><span id="ports_num" name="ports_num"> </span>:</td>
      			<td class="bggrey">
        			<table width="100%"  border="0" cellpadding="2" cellspacing="1" class="box_tn">
	      				<tr>
	        				<td width="137"><span id="http_port" name="http_port"></span>: </td>
	        				<td>
	        					<input name="httpport" type="text" id="httpport" value="<% getWebPort(); %>" size="5" maxlength="5"> 
	         					<span id="default_80" name="default_80"></span>
	         				</td>
	      				</tr>
							</table>
						</td>
      		</tr>
      		<tr> 
		      <td valign="top" class="bgblue"><span id="https" name="https"></span>: </td>
		      <td class="bggrey"><table width="100%"  border="0" cellpadding="2" cellspacing="1" class="box_tn">
		        <tr>
		          <td width="137"><span class="style7">
		            <input name="httpsenable" type="checkbox" id="httpsenable" value="1" <% getHttpsEnable("1"); %>>
		            <span id="enable_3" name="enable_3"></span></span></td>
		          <td>&nbsp;</td>
		        </tr>
		        <tr>
		          <td width="137"><span class="style7"><span id="https_port" name="https_port"></span></span><span class="t12"> </span></td>
		          <td><input name="httpsport" type="text" id="httpsport" value="<% getHttpsPort(); %>" size="5" maxlength="5">
		          <span id="default_443" name="default_443"></span></td>
		        </tr>
		      </table></td>
		    </tr>
    		</table>
    		<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
        			<input type="button" id="Button" name="Button" value="" class="ButtonSmall" onClick="send();">
        			<input type="button" id="Button1" name="Button1" value="" class="ButtonSmall" onClick="reloadScreen('network.asp');">
        			<input type="hidden" name="reboot" value="0" class="ButtonSmall" />
        		</td>
      		</tr>
    		</table>
  		<br>
    	</form>
  	</td>
	</tr>
</table>
<script language="javascript" >disform();</script>
</body>
</html>
