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
<script language="javascript" type="text/javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}

function send(){
	var o = document.form1;
	if(o.text_enable.checked)
		if(isFilled(o.incldtext) == false || asciiCheck(o.incldtext)==false) return;
	o.submit();
}

function start(){

	setContent("mask_over_1",item_name[_OVER_MASK]);
	setContent("text_over_1",item_name[_TEXT_OVER]);
	setContent("overlay",item_name[_OLAY_SETTING]);
	setContent("include_d_t",item_name[_INCLUDE_DATE_TIME]);
	setContent("incld_text",item_name[_INCLD_TEXT]);
	setContent("enable_opq",item_name[_ENABLE_OPQ]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
	
}
function init(){
	var obj = document.form1;
	if(obj.text_enable.checked){
		obj.incldtext.disabled=false;
	}else{
		obj.incldtext.disabled=true;
	}
}
</script>
</head>
<body onLoad="setTimeout('start();goSetHeight();', 100);">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="mask_over_1" name="mask_over_1"></span>&nbsp;&raquo;&nbsp;<span id="text_over_1" name="text_over_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
			<form action="textoverlay.cgi" method="post" name="form1">
		  	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="overlay" name="overlay"> </span></td>
      		</tr>
          <tr>
            <td width="450" class="bgblue"><span id="include_d_t" name="include_d_t"></span></td>
            <td class="bggrey"><input name="osd_enable" type="checkbox" id="osd_enable" value="1" <% getOsdEnable("1"); %>></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="incld_text" name="incld_text"></span>:</td>
            <td class="bggrey"><input name="text_enable" type="checkbox" id="text_enable" value="1" <% getTextOsdEnable("1"); %> onclick="init()"><input name="incldtext" type="text" id="incldtext" value="<% getTextOsd(); %>" size="32" maxlength="16"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="enable_opq" name="enable_opq"></span></td>
            <td class="bggrey"><input name="osd_opaque" type="checkbox" id="osd_opaque" value="1" <% getOsdOpaque("1"); %>></td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
       			<td class="bggrey2">     
		      		<input name="dummy" type="hidden" id="dummy" value="1">
		      		<input class="ButtonSmall" type="button" name="Button" id="Button" value="" onClick="send();">
		      		<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="reloadScreen('textoverlay.asp');">
		      	</td>
		      </tr>
		    </table>
	    </form>
		  <br>  
    </td>
  </tr>
</table>
<script language="javascript" type="text/javascript">init();</script>
</body>
</html>
