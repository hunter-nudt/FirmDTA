<html
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
	setContent("email_setting",item_name[_EMAIL_SETTING]);
	setContent("smtp_server",item_name[_SMTP_SERVER]);
	setContent("smtp_port",item_name[_SMTP_PORT]);
	setContent("smtp_secu",item_name[_SMTP_SECURITY]);
	setContent("smtp_tls",item_name[_STARTTLS]);
	setContent("sender_email",item_name[_SENDER_EMAIL]);
	setContent("auth_mode",item_name[_AUTH_MODE]);
	setContent("sender_user",item_name[_SENDER_USER]);
	setContent("sender_pwd",item_name[_SENDER_PWD]);
	setContent("receiver1",item_name[_RECEIVER_1]);
	setContent("receiver2",item_name[_RECEIVER_2]);
	setContent("email_setting_1",item_name[_EMAIL_SETTING]);
	setContent("smtp_server_1",item_name[_SMTP_SERVER]);
	setContent("smtp_port_1",item_name[_PORT_NUM]);
	setContent("sender_email_1",item_name[_SENDER_EMAIL]);
	setContent("auth_mode_1",item_name[_AUTH_MODE]);
	setContent("none",item_name[_NONE]);
	setContent("smtp",item_name[_SMTP]);
	setContent("sender_user_1",item_name[_SENDER_USER]);
	setContent("sender_pwd_1",item_name[_SENDER_PWD]);
	setContent("receiver1_1",item_name[_RECEIVER_1]);
	setContent("receiver2_1",item_name[_RECEIVER_2]);
	setContent("msg_line1",sw_msg[sw_msg_11]);
	setContent("msg_line8",sw_msg[sw_msg_38]);
	setContent("msg_line2",sw_msg[sw_msg_12]);
	setContent("msg_line3",sw_msg[sw_msg_13]);
	setContent("msg_line4",sw_msg[sw_msg_14]);
	setContent("msg_line5",sw_msg[sw_msg_15]);
	setContent("msg_line6",sw_msg[sw_msg_16]);
	setContent("msg_line7",sw_msg[sw_msg_17]);
	document.getElementById("Button").value=item_name[_PREV];
	document.getElementById("Button1").value=item_name[_NAXT];
	document.getElementById("Button2").value=item_name[_CANCEL];
}	

function send(){
	var o = document.form1;	
	if(ipv4Check(o.hostname)==false)
		if(ipCheckv6(o.hostname)==false)
			if(hostCheck(o.hostname)==false)	return;
	if(ipv4Check(o.sender)==false)
		if(ipCheckv6(o.sender)==false)
			if(emailCheck(o.sender)==false)	return;
	if(rangeCheck(o.port,1,65535)==false)	return;
	if(o.auth[1].checked){
		if(isFilled(o.username) == false || asciiCheck(o.username)==false) return;
	}
	if(ipv4Check(o.receiver1)==false)
		if(ipCheckv6(o.receiver1)==false)
			if(emailCheck(o.receiver1)==false)	return;
	if(ipv4Check(o.receiver2)==false)
		if(ipCheckv6(o.receiver2)==false)
			if(emailCheck(o.receiver2)==false)	return;
	o.languageidx.value = "<%getCgiLanguage();%>";
	o.submit();
}

function disauth(){
	var o =  document.form1;
	o.username.disabled = o.auth[0].checked
	o.password.disabled = o.auth[0].checked	
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
				              	<p><font color="#FFFFFF" size="3"><b><span id="email_setting" name="email_setting"></span></b></font></p>
				                <p><font color="#FFFFFF"><b><span id="smtp_server" name="smtp_server"></span></b><span id="msg_line1" name="msg_line1"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="smtp_port" name="smtp_port"></span></b><span id="msg_line8" name="msg_line8"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="sender_email" name="sender_email"></span></b><span id="msg_line2" name="msg_line2"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="auth_mode" name="auth_mode"></span></b><span id="msg_line3" name="msg_line3"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="sender_user" name="sender_user"></span></b><span id="msg_line4" name="msg_line4"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="sender_pwd" name="sender_pwd"></span></b><span id="msg_line5" name="msg_line5"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="receiver1" name="receiver1"></span></b><span id="msg_line6" name="msg_line6"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="receiver2" name="receiver2"></span></b><span id="msg_line7" name="msg_line7"></span></font></p>
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
								<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="email_setting_1" name="email_setting_1"></span></font></b></td>
							</tr>
				      <tr>
				      	<td width="100%" height="80" align="center" valign="top">
						  		<form action="smartwizard.cgi?go=4" method="post" name="form1">
				            <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
				              <tr>
				                <td class="bgblue"><span id="smtp_server_1" name="smtp_server_1"></span>: </td>
				                <td class="bggrey"><input name="hostname" type="text" class="box_longtext" id="hostname" value="<% getWizard("host"); %>" size="32" maxlength="32"></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="smtp_port_1" name="smtp_port_1"></span>: </td>
				                <td class="bggrey"><input name="port" type="text" class="box_longtext" id="port" value="<% getWizard("port"); %>" size="5" maxlength="5"></td>
				              </tr>
				              <tr>
                				<td class="bgblue"><span id="smtp_secu" name="smtp_secu"></span></td>
                				<td class="bggrey"><input name="encrypt" type="checkbox" id="encrypt" value="1" <% getWizardRadio("encrypt,1"); %>></td>
              				</tr>
              				<tr>
                				<td class="bgblue"><span id="smtp_tls" name="smtp_tls"></span></td>
                				<td class="bggrey"><input name="starttls" type="checkbox" id="starttls" value="1" <% getWizardRadio("starttls,1"); %>></td>
              				</tr>
				              <tr>
				                <td class="bgblue"><span id="sender_email_1" name="sender_email_1"></span>: </td>
				                <td class="bggrey"><input name="sender" type="text" class="box_longtext" id="sender" value="<% getWizard("sender"); %>" size="32" maxlength="32"></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="auth_mode_1" name="auth_mode_1"></span>: </td>
				                <td class="bggrey">
				                	<input name="auth" type="radio" value="0" <% getWizardRadio("auth,0"); %> onClick="disauth();">
				                  <span class="style7" id="none" name="none"></span>
				                  <input name="auth" type="radio" value="1" <% getWizardRadio("auth,1"); %> onClick="disauth();">
				                  <span class="style7" id="smtp" name="smtp"></span>
				                </td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="sender_user_1" name="sender_user_1"></span>: </td>
				                <td class="bggrey"><input name="username" type="text" class="box_longtext" id="username" value="<% getWizard("name"); %>" size="32" maxlength="32"></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="sender_pwd_1" name="sender_pwd_1"></span>: </td>
				                <td class="bggrey"><input name="password" type="password" class="box_longtext" id="password" value="<% getWizard("pass"); %>" size="32" maxlength="32"></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="receiver1_1" name="receiver1_1"></span>: </td>
				                <td class="bggrey"><input name="receiver1" type="text" class="box_longtext" id="receiver1" value="<% getWizard("receiver1"); %>" size="32" maxlength="64"></td>
				              </tr>
				              <tr>
				                <td class="bgblue"><span id="receiver2_1" name="receiver2_1"></span>: </td>
				                <td class="bggrey"><input name="receiver2" type="text" class="box_longtext" id="receiver2" value="<% getWizard("receiver2"); %>" size="32" maxlength="64"></td>
				              </tr>
				            </table>
				            <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
						      		<tr>
						        		<td class="bggrey2">
						        			<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="document.location = 'smartwizard.cgi?back=2&language=<%getCgiLanguage();%>';">
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
<script language="javascript">disauth();</script>
</body>
</html>