<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=800px">
<title>Rebooting</title>
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
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("sys_tool",item_name[_SYS_TOOLS]);
	setContent("tools_1",item_name[_TOOLS]);
	//setContent("sys_reboot",item_name[_SYS_REBOOT]);
	setContent("error",item_name[_ERROR]);
	setContent("msg_line1",popup_msg[popup_msg_53]);
	setContent("msg_line2",popup_msg[popup_msg_54]);

}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="sys_tool" name="sys_tool"></span>&nbsp;&raquo;&nbsp;<span id="tools_1" name="tools_1"></span></font></b></td>
	</tr>
	<tr>
	  <td width="100%" height="80" align="center" valign="top">
  		<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      	<tr>
        	<td colspan="2" class="greybluebg"><span id="msg_line1" name="msg_line1"> </span></td>
      	</tr>
        <tr>
        	<td height="30" class="bggrey"><span id="error" name="error"></span>: <span id="msg_line2" name="msg_line2"></span></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
