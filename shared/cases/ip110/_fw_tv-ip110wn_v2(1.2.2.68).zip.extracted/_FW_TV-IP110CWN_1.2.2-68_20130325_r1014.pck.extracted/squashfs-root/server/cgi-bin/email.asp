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
	
	setContent("event_server_set",item_name[_EVENT_SERVER_SET]);
	setContent("email_1",item_name[_EMAIL]);
	setContent("email_2",item_name[_EMAIL]);
	setContent("smtp_server",item_name[_SMTP_SERVER]);
	setContent("smtp_port",item_name[_SMTP_PORT]);
	setContent("smtp_secu",item_name[_SMTP_SECURITY]);
	setContent("smtp_tls",item_name[_STARTTLS]);
	setContent("sender_email",item_name[_SENDER_EMAIL]);
	setContent("auth_mode",item_name[_AUTH_MODE]);
	setContent("none",item_name[_NONE]);
	setContent("smtp",item_name[_SMTP]);
	setContent("sender_user",item_name[_SENDER_USER]);
	setContent("sender_pwd",item_name[_SENDER_PWD]);
	setContent("receiver_1",item_name[_RECEIVER_1]);
	setContent("receiver_2",item_name[_RECEIVER_2]);
	setContent("wanip_enable",item_name[_WANIP_NOTIFY]);
	
	document.getElementById("Test").value=item_name[_TEST];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
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
	o.action = "email.cgi";
	o.target = "_self";

	o.submit();
}
function test(){
	var o =  document.form1;
	if(isFilled(o.hostname) == false || asciiCheck(o.hostname)==false) return;
	if(emailCheck(o.sender)==false) return;
	if(o.auth[1].checked){
		if(isFilled(o.username) == false || asciiCheck(o.username)==false) return;
	}
	if(emailCheck(o.receiver1)==false) return;
	if(emailCheck(o.receiver2)==false) return;
	o.language.value = parent.languagevaule;
	o.targetserv.value = "email";
	o.action = "testserv.cgi";
//	o.target = "_blank";
    openTarget(o,'width=600,height=200,resizable=1,scrollbars=1');
	o.submit();

}

function disauth(){
	var o =  document.form1;
	o.username.disabled = o.auth[0].checked
	o.password.disabled = o.auth[0].checked	
}

function goSetHeight() {
  if (parent == window) return;
  else parent.setIframeHeight('ifrm');
}
function init(){
	disauth();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_server_set" name="event_server_set"></span>&nbsp;&raquo;&nbsp;<span id="email_1" name="email_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="email.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="email_2" name="email_2"> </span></td>
      		</tr>
          <tr>
            <td width="150" class="bgblue"><span id="smtp_server" name="smtp_server"></span>:</td>
            <td class="bggrey"> <input name="hostname" type="text" class="box_longtext" id="hostname" value="<% getMailHost(); %>" size="32" maxlength="64"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="sender_email" name="sender_email"></span>:</td>
            <td class="bggrey"><input name="sender" type="text" class="box_longtext" id="sender" value="<% getMailSender(); %>" size="32" maxlength="64"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="smtp_port" name="smtp_port"></span>:</td>
            <td class="bggrey"><input name="port" type="text" class="box_longtext" id="port" value="<% getMailPort(); %>" size="32" maxlength="5"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="smtp_secu" name="smtp_secu"></span>:</td>
            <td class="bggrey"><input name="encrypt" type="checkbox" id="encrypt" value="1" <% getMailEncrypt("1"); %>></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="smtp_tls" name="smtp_tls"></span>:</td>
            <td class="bggrey"><input name="starttls" type="checkbox" id="starttls" value="1" <% getMailStarttls("1"); %>></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="auth_mode" name="auth_mode"></span>:</td>
            <td class="bggrey"><input name="auth" type="radio" value="0" <% getMailAuth("0"); %> onClick="disauth();">
              <span class="style7" id="none" name="none"></span>
              <input name="auth" type="radio" value="1" <% getMailAuth("1"); %> onClick="disauth();">
              <span class="style7" id="smtp" name="smtp"></span></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="sender_user" name="sender_user"></span>:</td>
            <td class="bggrey"><input name="username" type="text" class="box_longtext" id="username" value="<% getMailUser(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="sender_pwd" name="sender_pwd"></span>:</td>
            <td class="bggrey"><input name="password" type="password" class="box_longtext" id="password" value="<% getMailPass(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="receiver_1" name="receiver_1"></span>:</td>
            <td class="bggrey"><input name="receiver1" type="text" class="box_longtext" id="receiver1" value="<% getMailRecv1(); %>" size="32" maxlength="64"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="receiver_2" name="receiver_2"></span>:</td>
            <td class="bggrey"><input name="receiver2" type="text" class="box_longtext" id="receiver2" value="<% getMailRecv2(); %>" size="32" maxlength="64"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="wanip_enable" name="wanip_enable"></span>:</td>
            <td class="bggrey"><input name="wanip" type="checkbox" id="wanip" value="1" <% getWanipEnable("1"); %>></td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">    
            	<input name="targetserv" type="hidden" value="">
            	<input name="language" id="language" type="hidden" value="">
            	<input class="ButtonSmall" name="Test" type="button" id="Test" value=""  onclick="test();">
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('email.asp');">
         		</td>
        	</tr>
      	</table>
      </form>
      <br>
    </td>
  </tr>
</table>
<script language="javascript">init();</script>
</body>
</html>
