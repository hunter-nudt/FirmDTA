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
	setContent("ftp_1",item_name[_FTP]);
	setContent("ftp_2",item_name[_FTP]);
	setContent("host_addr",item_name[_HOST_ADDR]);
	setContent("port_num",item_name[_PORT_NUM]);
	setContent("user_name",item_name[_USER_NAME]);
	setContent("pwd",item_name[_PASSWORD]);
	setContent("direct_path",item_name[_DIRECT_PATH]);
	setContent("pass_mode",item_name[_PASS_MODE]);
	setContent("enable",item_name[_ENABLE]);
	
	document.getElementById("Test").value=item_name[_TEST];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}


function send(){
	var o = document.form1;
	if(ipv4Check(o.hostname)==false)
		if(ipCheckv6(o.hostname)==false)
			if(hostCheck(o.hostname)==false)	return;
	if(rangeCheck(o.port,1,65535)==false)	return;
	if(asciiCheck(o.username)==false) return;
	if(asciiCheck(o.path)==false) return;
	o.action = "ftp.cgi";
	o.target = "_self";
	o.submit();
}

function test(){
	var o =  document.form1;
	if(isFilled(o.hostname) == false || asciiCheck(o.hostname)==false) return;
	o.targetserv.value = "ftp";
	o.language.value = parent.languagevaule;
	o.action = "testserv.cgi";
  openTarget(o,'width=600,height=200,resizable=1,scrollbars=1');
	o.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_server_set" name="event_server_set"></span>&nbsp;&raquo;&nbsp;<span id="ftp_1" name="ftp_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="ftp.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="ftp_2" name="ftp_2"> </span></td>
      		</tr>
          <tr>
            <td width="150" class="bgblue"><span id="host_addr" name="host_addr"></span>:</td>
            <td class="bggrey"><input name="hostname" type="text" class="box_longtext" id="hostname" value="<% getFtpHost(); %>" size="64" maxlength="64"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="port_num" name="port_num"></span>:</td>
            <td class="bggrey"><input name="port" type="text" id="port" value="<% getFtpPort(); %>" size="5" maxlength="5"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="user_name" name="user_name"></span>:</td>
            <td class="bggrey"><input name="username" type="text" class="box_longtext" id="username" value="<% getFtpUser(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="pwd" name="pwd"></span>:</td>
            <td class="bggrey"><input name="password" type="password" class="box_longtext" id="password" value="<% getFtpPass(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="direct_path" name="direct_path"></span>:</td>
            <td class="bggrey"><input name="path" type="text" class="box_longtext" id="path" value="<% getFtpPath(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="pass_mode" name="pass_mode"></span>:</td>
            <td class="bggrey"><input name="passive" type="checkbox" id="passive" value="1" <% getFtpPasv("1"); %>>
              <span class="style7" id="enable" name="enable"></span></td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
							<input name="targetserv" id="targetserv" type="hidden" value="">
							<input name="language" id="language" type="hidden" value="">
							<input class="ButtonSmall" name="Test" type="button" id="Test" value="" onClick="test();">
							<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('ftp.asp');">
          	</td>
        	</tr>
      	</table>
      </form>
      <br>
    </td>
  </tr>
</table>
</body>
</html>
