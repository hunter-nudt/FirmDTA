<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=800px">
<title><% getWlanExist("stat"); %> Network Camera</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/javascript" src="../lang/<% getCgiLanguage(); %>/itemname.js"></script>
<script language="JavaScript" type="text/javascript" src="../lang/<% getCgiLanguage(); %>/msg.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="date.js"></script>
<script language="javascript">
	
function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));
}

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
	
function start(){

	setContent("location",item_name[_LOCATION]);
	setContent("ip_setting",item_name[_IP_SETTING]);
	setContent("dhcp",item_name[_DHCP]);
	setContent("static_ip",item_name[_STATIC_IP]);
	setContent("ip_setting_1",item_name[_IP_SETTING]);
	setContent("dhcp_1",item_name[_DHCP]);
	setContent("static_ip_1",item_name[_STATIC_IP]);
	setContent("ip",item_name[_IP]);
	setContent("subnet_mask",item_name[_SUBNET_MASK]);
	setContent("default_gw",item_name[_DEFAULT_GW]);
	setContent("pri_dns",item_name[_PRI_DNS]);
	setContent("sec_dns",item_name[_SEC_DNS]);
	setContent("pppoe",item_name[_PPPOE]);
	setContent("pppoe_1",item_name[_PPPOE]);
	setContent("user_name",item_name[_PPPOE_USER]);
	setContent("password",item_name[_PPPOE_PWD]);
	setContent("msg_line1",sw_msg[sw_msg_4]);
	setContent("msg_line2",sw_msg[sw_msg_5]);
	setContent("msg_line3",sw_msg[sw_msg_6]);
	setContent("msg_line4",sw_msg[sw_msg_7]);
	setContent("msg_line5",sw_msg[sw_msg_8]);
	setContent("msg_line6",sw_msg[sw_msg_9]);
	setContent("msg_line7",sw_msg[sw_msg_10]);
	setContent("msg_line8",sw_msg[sw_msg_37]);
	document.getElementById("Button").value=item_name[_PREV];
	document.getElementById("Button1").value=item_name[_NAXT];
	document.getElementById("Button2").value=item_name[_CANCEL];
	
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
		if(isFilled(o.pppoeuser) == false || asciiCheck(o.pppoeuser)==false) return;
		if(isFilled(o.pppoepass) == false || asciiCheck(o.pppoepass)==false) return;	
	}
	o.languageidx.value = "<%getCgiLanguage();%>";
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
<body onLoad="time_go();start();">
<table width="900" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="21"><img src="images/c1_tl.gif" width="21"></td>
		<td width="858" background="images/bg1_t.gif"><img src="images/top_1.gif" width="390"></td>
		<td width="21"><img src="images/c1_tr.gif" width="21"></td>
	</tr>
	<tr>
  	<td valign="top" background="images/bg1_l.gif"><img src="images/top_2.gif" width="21" height="69"></td>
    <td background="images/bg.gif">
    	<table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
		    <tr>
					<td width="13%" valign="top"><img src="images/logo.gif" width="390" height="69"></td>
					<td width="87%" align="right" valign="top">
						<table width="100%" border="0" cellpadding="4" cellspacing="0">
							<tr>
								<td align="right" valign="top"><img src="images/description_<% getmodelname(); %>.gif"></td>
							</tr>
							<tr>
								<td align="right" valign="top"><b><font color="#FFFFFF"><span id="location" name="location"></span>: <span class="t12">
								<% getLocation(); %>&nbsp;&nbsp;&nbsp; </span></font><font color="#FFFFFF"><span class="style1">
								<span id="datebar"><% getDate(); %> <%getTime(); %></span>
								&nbsp; </span>&nbsp; </font></b></td>
							</tr>
						</table>
					</td>
		    </tr>
		  </table>
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="250" valign="top" align="center">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
				  	  	<td width="100%" height="80" align="center" bgcolor="#666666">
				        	<table width="97%"  border="0" cellpadding="5" cellspacing="1">
				          	<tr>
				            	<td width="100%">
				            		<p><b><font color="#FFFFFF" size="3"><span id="ip_setting" name="ip_setting"></span></font></b></p>
				                <p><font color="#FFFFFF"><b><span id="dhcp" name="dhcp"></span></b><span id="msg_line1" name="msg_line1"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="static_ip" name="static_ip"></span></b><span id="msg_line2" name="msg_line2"></span></font><br>
				                <font color="#FFFFFF"><span id="msg_line8" name="msg_line8"></span><br>
				                <span id="msg_line3" name="msg_line3"></span><span>192.168.10.30</span><br>
				                <span id="msg_line4" name="msg_line4"></span><span>255.255.255.0</span><br>
				                <span id="msg_line5" name="msg_line5"></span><span>192.168.10.1</span><br>
				                <span id="msg_line6" name="msg_line6"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="pppoe" name="pppoe"></span></b><span id="msg_line7" name="msg_line7"></span></font></p>
				              </td>
				            </tr>
				          </table>
				        </td>
				      </tr>
						</table>
					</td>
					<td width="10"><img src="images/spacer.gif" width="10" height="15"></td>
					<td valign="top">
						<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
							<tr>
								<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="ip_setting_1" name="ip_setting_1"></span></font></b></td>
							</tr>
				      <tr>
				      	<td width="100%" height="80" align="center" valign="top">
						  		<form action="smartwizard.cgi?go=3" method="post" name="form1">
				          	<table width="98%"  border="0" cellpadding="3" cellspacing="0" bgcolor="#333333" class="box_tn">
				              <tr>
				                <td colspan="3" class="bggrey"><input name="iptype" type="radio" value="1"  <% getWizardRadio("Policy,1"); %> onClick="disform();"><span id="dhcp_1" name="dhcp_1"></span></td>
				              </tr>
				              <tr>
				                <td colspan="3" class="bggrey"><input name="iptype" type="radio" value="0"  <% getWizardRadio("Policy,0"); %>  onclick="disform();"><span id="static_ip_1" name="static_ip_1"></span></td>
				              </tr>
				              <tr>
				                <td width="20" class="bggrey">&nbsp;</td>
				                <td width="93" class="bggrey"><span id="ip" name="ip"></span>:</td>
				                <td width="303" class="bggrey">
				                	<input name="ip1" type="text" class="box_ip" id="ip1" value="<% getWizardIp("IP Addr,1"); %>" size="3" maxlength="3">
				                  .
				                  <input name="ip2" type="text" class="box_ip" id="ip2" value="<% getWizardIp("IP Addr,2"); %>" size="3" maxlength="3">
				                  .
				                  <input name="ip3" type="text" class="box_ip" id="ip3" value="<% getWizardIp("IP Addr,3"); %>" size="3" maxlength="3">
				                  .
				                  <input name="ip4" type="text" class="box_ip" id="ip4" value="<% getWizardIp("IP Addr,4"); %>" size="3" maxlength="3">
				                </td>
				              </tr>
				              <tr>
				                <td class="bggrey">&nbsp;</td>
				                <td class="bggrey"><span id="subnet_mask" name="subnet_mask_1"></span>:</td>
				                <td class="bggrey">
				                	<input name="netmask1" type="text" class="box_ip" id="netmask1" value="<% getWizardIp("Netmask,1"); %>" size="3" maxlength="3">
				                  .
				                  <input name="netmask2" type="text" class="box_ip" id="netmask2" value="<% getWizardIp("Netmask,2"); %>" size="3" maxlength="3">
				                  .
				                  <input name="netmask3" type="text" class="box_ip" id="netmask3" value="<% getWizardIp("Netmask,3"); %>" size="3" maxlength="3">
				                  .
				                  <input name="netmask4" type="text" class="box_ip" id="netmask4" value="<% getWizardIp("Netmask,4"); %>" size="3" maxlength="3">
				                </td>
				              </tr>
				              <tr>
				                <td class="bggrey">&nbsp;</td>
				                <td class="bggrey"><span id="default_gw" name="default_gw"></span>:</td>
				                <td class="bggrey">
				                	<input name="gateway1" type="text" class="box_ip" id="gateway1" value="<% getWizardIp("Gateway,1"); %>" size="3" maxlength="3">
				                  .
				                  <input name="gateway2" type="text" class="box_ip" id="gateway2" value="<% getWizardIp("Gateway,2"); %>" size="3" maxlength="3">
				                  .
				                  <input name="gateway3" type="text" class="box_ip" id="gateway3" value="<% getWizardIp("Gateway,3"); %>" size="3" maxlength="3">
				                  .
				                  <input name="gateway4" type="text" class="box_ip" id="gateway4" value="<% getWizardIp("Gateway,4"); %>" size="3" maxlength="3">
				                </td>
				              </tr>
				              <tr>
				                <td class="bggrey">&nbsp;</td>
				                <td class="bggrey"><span id="pri_dns" name="pri_dns"></span>:</td>
				                <td class="bggrey">
				                	<input name="dns1_1" type="text" class="box_ip" id="dns1_1" value="<% getWizardIp("Primary,1"); %>" size="3" maxlength="3">
				                  .
				                  <input name="dns1_2" type="text" class="box_ip" id="dns1_2" value="<% getWizardIp("Primary,2"); %>" size="3" maxlength="3">
				                  .
				                  <input name="dns1_3" type="text" class="box_ip" id="dns1_3" value="<% getWizardIp("Primary,3"); %>" size="3" maxlength="3">
				                  .
				                  <input name="dns1_4" type="text" class="box_ip" id="dns1_4" value="<% getWizardIp("Primary,4"); %>" size="3" maxlength="3">
				                </td>
				              </tr>
				              <tr>
				                <td class="bggrey">&nbsp;</td>
				                <td class="bggrey"><span id="sec_dns" name="sec_dns"></span>:</td>
				                <td class="bggrey">
				                	<input name="dns2_1" type="text" class="box_ip" id="dns2_1" value="<% getWizardIp("Secondary,1"); %>" size="3" maxlength="3">
				                  .
				                  <input name="dns2_2" type="text" class="box_ip" id="dns2_2" value="<% getWizardIp("Secondary,2"); %>" size="3" maxlength="3">
				                  .
				                  <input name="dns2_3" type="text" class="box_ip" id="dns2_3" value="<% getWizardIp("Secondary,3"); %>" size="3" maxlength="3">
				                  .
				                  <input name="dns2_4" type="text" class="box_ip" id="dns2_4" value="<% getWizardIp("Secondary,4"); %>" size="3" maxlength="3">
				                </td>
				              </tr>
				              <tr>
				                <td colspan="3" class="bggrey"><input name="iptype" type="radio" value="2"  <% getWizardRadio("Policy,2"); %> onClick="disform();"><span id="pppoe_1" name="pppoe_1"></span></td>
				              </tr>
				              <tr>
				                <td class="bggrey">&nbsp;</td>
				                <td class="bggrey"><span id="user_name" name="user_name"></span>:</td>
				                <td class="bggrey"><input name="pppoeuser" type="text" class="box_text" id="pppoeuser" value="<% getWizard("UserName"); %>" size="20" maxlength="32"></td>
				              </tr>
				              <tr>
				                <td class="bggrey">&nbsp;</td>
				                <td class="bggrey"><span id="password" name="password"></span>:</td>
				                <td class="bggrey"><input name="pppoepass" type="password" class="box_text" id="pppoepass" value="<% getWizard("Password"); %>" size="20" maxlength="32"></td>
				              </tr>
				            </table>
				            <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
						      		<tr>
						        		<td class="bggrey2">
						        			<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="document.location = 'smartwizard.cgi?back=1&language=<%getCgiLanguage();%>';">
													<input name="languageidx" type="hidden" value="">
            							<input class="ButtonSmall" type="button" id="Button1" name="Button1" value="" onClick="send();">
		    									<input class="ButtonSmall" type="button" id="Button2" name="Button2" value="" onClick="if(confirm(popup_msg[popup_msg_8]+'?')){document.location='smartwizard.cgi?cancel=1&language=<%getCgiLanguage();%>';}">
						        		</td>
						      		</tr>
						    		</table>
									<br>
						  		</form>
				        </td>
				      </tr>
				    </table>
					</td>
				</tr>
			</table>
		</td>
  	<td width="21" background="images/bg1_r.gif"></td>
  </tr>
  <tr>
    <td><img src="images/c1_bl.gif" width="21"></td>
    <td align="right" background="images/bg1_b.gif"><img src="images/copyright.gif" width="264"></td>
    <td><img src="images/c1_br.gif" width="21"></td>
  </tr>
</table>
<script language="javascript" >disform();</script>
</body>
</html>