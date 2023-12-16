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
	setContent("http_1",item_name[_HTTP]);
	setContent("http_2",item_name[_HTTP_MOTION_TRIG]);
	setContent("host_addr",item_name[_HOST]);
	setContent("port_num",item_name[_PORT]);
	setContent("user_name",item_name[_USER_NAME]);
	setContent("pwd",item_name[_PASSWORD]);
	setContent("query",item_name[_QUERY]);
	
	document.getElementById("Test").value=item_name[_TEST];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}


function send(){
	var o = document.form1;
	if(asciiCheck(o.hostname)==false) return;
	if(rangeCheck(o.port,1,65535)==false)	return;
	if(asciiCheck(o.username)==false) return;
	if(asciiCheck(o.query)==false) return;

//	o.targetserv.value = "ftp";
	o.action = "http.cgi";
	o.target = "_self";

	document.form1.submit();
}
function test(tar){
	var o =  document.form1;
	if(rangeCheck(o.port,1,65535)==false)	return;
	if( tar == "http1" )
		if(isFilled(o.hostname) == false || asciiCheck(o.hostname)==false) return;

	o.targetserv.value = tar;
	o.language.value = parent.languagevaule;
	o.action = "testserv.cgi";
//	o.target = "_blank";
    openTarget(o,'width=600,height=200,resizable=1,scrollbars=1');
	o.submit();

}

</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_server_set" name="event_server_set"></span>&nbsp;&raquo;&nbsp;<span id="http_1" name="http_1"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="http.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="http_2" name="http_2"> </span></td>
      </tr>
      <tr>
        <td width="150" class="bgblue"><span id="host_addr" name="host_addr"></span>:</td>
        <td class="bggrey"><input name="hostname" type="text" class="box_longtext" id="hostname" value="<% getHttp1Host(); %>" size="32" maxlength="32"></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="port_num" name="port_num"></span>: </td>
        <td class="bggrey"><input name="port" type="text" id="port" value="<% getHttp1Port(); %>" size="5" maxlength="5"></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="user_name" name="user_name"></span>: </td>
        <td class="bggrey"><input name="username" type="text" class="box_longtext" id="username" value="<% getHttp1User(); %>" size="32" maxlength="32"></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="pwd" name="pwd"></span>: </td>
        <td class="bggrey"><input name="password" type="password" class="box_longtext" id="password" value="<% getHttp1Pass(); %>" size="32" maxlength="32"></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="query" name="query"></span>: </td>
        <td class="bggrey"><input name="query" type="text" class="box_longtext" id="query" value="<% getHttp1Query(); %>" size="32" maxlength="80"></td>
      </tr>
    </table>
    <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td class="bggrey2">
        	<input name="targetserv" type="hidden" value="">
        	<input name="language" id="language" type="hidden" value="">
        			<input name="Test" type="button" id="Test" value="" class="ButtonSmall" onClick="test('http1');">
					<input type="button" id="Button" name="Button" value="" class="ButtonSmall" onClick="send()">
    			<input type="button" name="Button1" id="Button1" value="" class="ButtonSmall" onClick="reloadScreen('http.asp');">
    		</td>
      </tr>
    </table>
	<br>
	</form>
  	</td>
</tr>
</table>
</body>
</html>
