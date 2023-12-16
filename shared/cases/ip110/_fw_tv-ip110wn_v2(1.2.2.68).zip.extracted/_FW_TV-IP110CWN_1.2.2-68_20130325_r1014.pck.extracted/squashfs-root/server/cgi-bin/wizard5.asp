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
<script language="javascript" type="text/javascript">

function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));
}

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){

	setContent("location",item_name[_LOCATION]);
	setContent("confirm_set",item_name[_CONFIRM_SETTING]);
	setContent("apply",item_name[_APPLY]);
	setContent("prev",item_name[_prev_1]);
	setContent("cancel",item_name[_CANCEL]);
	setContent("confirm_set_1",item_name[_CONFIRM_SETTING]);
	setContent("cam_name",item_name[_CAM_NAME]);
	setContent("location_1",item_name[_LOCATION]);
	setContent("ip_mode",item_name[_IP_MODE]);
	setContent("ip_addr",item_name[_IP_ADDR]);
	setContent("subnet_mask",item_name[_SUBNET_MASK]);
	setContent("default_gw",item_name[_DEFAULT_GW]);
	setContent("pri_dns",item_name[_PRI_DNS]);
	setContent("sec_dns",item_name[_SEC_DNS]);
	setContent("smtp_server",item_name[_SMTP_SERVER]);
	setContent("smtp_port",item_name[_SMTP_PORT]);
	setContent("encrypt_mode",item_name[_SSL]);
	setContent("starttls",item_name[_STARTTLS]);
	setContent("sender_email",item_name[_SENDER_EMAIL]);
	setContent("auth_mode",item_name[_AUTH_MODE]);
	setContent("sender_user",item_name[_SENDER_USER]);
	setContent("receiver1",item_name[_RECEIVER_1]);
	setContent("receiver2",item_name[_RECEIVER_2]);
	setContent("essid",item_name[_ESSID]);
	setContent("connection",item_name[_CONNECTION]);
	setContent("channel",item_name[_CHANNEL]);
	setContent("auth",item_name[_AUTH]);
	setContent("encry",item_name[_ENCRYPTION]);
	setContent("msg_line1",sw_msg[sw_msg_27]);
	setContent("msg_line2",sw_msg[sw_msg_28]);
	setContent("msg_line3",sw_msg[sw_msg_29]);
	setContent("msg_line4",sw_msg[sw_msg_30]);
	setContent("msg_line5",sw_msg[sw_msg_31]);
	setContent("msg_line6",sw_msg[sw_msg_32]);
	document.getElementById("Button").value=item_name[_PREV];
	document.getElementById("Button1").value=item_name[_APPLY];
	document.getElementById("Button2").value=item_name[_CANCEL];
}
function send(){
	var o = document.form1;	
	o.languageidx.value = "<%getCgiLanguage();%>";
	o.submit();
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
				              	<p><font color="#FFFFFF" size="3"><b><span id="confirm_set" name="confirm_set"></span></b></font></p>
				                <p><font color="#FFFFFF"><span id="msg_line1" name="msg_line1"></span><br>
												<span id="msg_line2" name="msg_line2"></span><b><span id="apply" name="apply"></span></b><span id="msg_line3" name="msg_line3"></span><b><span id="prev" name="prev"></span></b><span id="msg_line4" name="msg_line4"></span><b><span id="cancel" name="cancel"></span></b><span id="msg_line5" name="msg_line5"></span></font></p>
				                <p><font color="#FFFFFF"><span id="msg_line6" name="msg_line6"></span></font></p>
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
								<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="confirm_set_1" name="confirm_set_1"></span></font></b></td>
							</tr>
				      <tr>
				      	<td width="100%" height="80" align="center" valign="top">
						  		<form action="smartwizard.cgi?go=6" method="post" name="form1">
				            <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
				              <tr>
				                <td class="bgblue"><span id="cam_name" name="cam_name"></span>:</td>
				                <td class="bggrey"><% getWizardSpecialStrip("CameraNameS"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="location_1" name="location_1"></span>: </td>
				                <td class="bggrey"><% getWizardSpecialStrip("LocationS"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="ip_mode" name="ip_mode"></span>: </td>
				                <td class="bggrey"><% getWizardArr("Policy"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="ip_addr" name="ip_addr"></span>: </td>
				                <td class="bggrey"><% getWizard("IP Addr"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="subnet_mask" name="subnet_mask"></span>: </td>
				                <td class="bggrey"><% getWizard("Netmask"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="default_gw" name="default_gw"></span>: </td>
				                <td class="bggrey"><% getWizard("Gateway"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="pri_dns" name="pri_dns"></span>: </td>
				                <td class="bggrey"><% getWizard("Primary"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="sec_dns" name="sec_dns"></span>: </td>
				                <td class="bggrey"><% getWizard("Secondary"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="smtp_server" name="smtp_server"></span>:</td>
				                <td class="bggrey"><% getWizard("host"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="smtp_port" name="smtp_port"></span>:</td>
				                <td class="bggrey"><% getWizard("port"); %></td>
				              </tr>
				              <tr>
               					<td class="bgblue"><span id="encrypt_mode" name="encrypt_mode"></span>:</td>
                				<td class="bggrey"><% getWizardArr("encrypt"); %></td>
              				</tr>
              				<tr>
                				<td class="bgblue"><span id="starttls" name="starttls"></span>:</td>
                				<td class="bggrey"><% getWizardArr("starttls"); %></span></td>
              				</tr>
				              <tr>
				                <td class="bgblue"><span id="sender_email" name="sender_email"></span>: </td>
				                <td class="bggrey"><% getWizard("sender"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="auth_mode" name="auth_mode"></span>: </td>
				                <td class="bggrey"><% getWizardArr("auth"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="sender_user" name="sender_user"></span>: </td>
				                <td class="bggrey"><% getWizard("name"); %></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="receiver1" name="receiver1"></span>: </td>
				                <td class="bggrey"><% getWizard("receiver1"); %></td>
				              </tr> 
				                <td class="bgblue"><span id="receiver2" name="receiver2"></span>: </td>
				                <td class="bggrey"><% getWizard("receiver2"); %></td>
				              </tr>
				            	<div style="display:<% getWlanExist("wizard"); %>">
				              <tr style="display:<% getWlanExist("wizard"); %>">
				                <td class="bgblue"><span id="essid" name="essid"></span>:</td>
				                <td class="bggrey"><% getWizardSpecial("Essid"); %></td>
				              </tr>
				              <tr style="display:<% getWlanExist("wizard"); %>">
				                <td class="bgblue"><span id="connection" name="connection"></span>: </td>
				                <td class="bggrey"><% getWizardArr("Mode"); %></td>
				              </tr>
				              <tr style="display:<% getWlanExist("wizard"); %>">
				                <td class="bgblue"><span id="channel" name="channel"></span>: </td>
				                <td class="bggrey"><% getWizard("Channel"); %></td>
				              </tr>
				              <tr style="display:<% getWlanExist("wizard"); %>">
				                <td class="bgblue"><span id="auth" name="auth"></span>: </td>
				                <td class="bggrey"><% getWizardArr("AuthMode"); %></td>
				              </tr>
				              <tr style="display:<% getWlanExist("wizard"); %>">
				                <td class="bgblue"><span id="encry" name="encry"></span> : </td>
				                <td class="bggrey"><% getWizardArr("SecMethod"); %></td>
				              </tr>
				              </div>
				            </table>
				            <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
						      		<tr>
						        		<td class="bggrey2">
													<input class="ButtonSmall" type="button" id="Button" name="Button" value="< Prev" onClick="document.location = 'smartwizard.cgi?back=4&language=<%getCgiLanguage();%>';">
            							<input name="languageidx" type="hidden" value="">
            							<input class="ButtonSmall" type="button" id="Button1" name="Button1" value="Apply" onClick="send();">
		    									<input class="ButtonSmall" type="button" id="Button2" name="Button2" value="Cancel" onClick="if(confirm(popup_msg[popup_msg_8]+'?')){document.location='smartwizard.cgi?cancel=1&language=<%getCgiLanguage();%>';}">
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
</body>
</html>