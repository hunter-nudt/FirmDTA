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
	setContent("netstorage_1",item_name[_NET_STORAGE]);
	setContent("netstorage_2",item_name[_NET_STORAGE]);
	setContent("samba_server",item_name[_SAMBA_SERVER]);
	setContent("share_1",item_name[_SHARE]);
	setContent("path_1",item_name[_PATH]);
	setContent("user_name",item_name[_USER_NAME]);
	setContent("anonymous_1",item_name[_ANONYMOUS]);
	setContent("pwd",item_name[_PASSWORD]);
	setContent("split_by",item_name[_SPLIT_BY]);
	setContent("file_size",item_name[_FILE_SIZE]);
	setContent("mb",item_name[_MB]);
	setContent("record_time",item_name[_RECORD_TIME]);
	setContent("minute",item_name[_MINUTE]);
	setContent("disk_full",item_name[_DISK_FULL]);
	setContent("stop_record",item_name[_STOP_RECORDING]);
	setContent("recycle_1",item_name[_RECYCLE]);
	setContent("encode_format",item_name[_ENCODE_FORMAT]);
	setContent("mpeg4",item_name[_MPEG4]);
	setContent("h264",item_name[_H264]);
	setContent("file_format",item_name[_FILE_FORMAT]);
	setContent("mp4",item_name[_MP4]);
	setContent("avi",item_name[_AVI]);
	
	document.getElementById("Test").value=item_name[_TEST];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function checkAnony(){
	var o = document.form1;
	o.username.disabled = o.anonymous.checked;
	o.password.disabled = o.anonymous.checked;
}

function isSpaceIn(value)
{
	if(value.indexOf(" ")>0)
		return true;
	return false;
}

function spaceCheck(obj){
	if(isSpaceIn(trimAllblank(obj.value)))
	{
		warnAndSelect(obj,popup_msg[popup_msg_32]);
	 	return false;
	}
	return true;
}
function send(){
	var o = document.form1;	
	if(isFilled(o.hostname) == false || asciiCheck(o.hostname)==false) return;
	if(o.anonymous.checked == false){
		if(isFilled(o.username) == false || asciiCheck(o.username)==false) return;
	}
	if(spaceCheck(o.share)==false || asciiCheck(o.share)==false) return;	
	if(spaceCheck(o.path)==false || asciiCheck(o.path)==false) return;
	if(rangeCheck(o.splitbysize,12,640)==false)	return;
	if(rangeCheck(o.splitbytime,1,60)==false)	return;
	o.action = "samba.cgi";
	o.target = "_self";
	o.submit();
}
function test(){
	var o =  document.form1;
	if(isFilled(o.hostname) == false || asciiCheck(o.hostname)==false) return;
	if(o.anonymous.checked == false){
		if(isFilled(o.username) == false || asciiCheck(o.username)==false) return;
	}
	if(spaceCheck(o.share)==false || asciiCheck(o.share)==false) return;	
	if(spaceCheck(o.path)==false || asciiCheck(o.path)==false) return;	
	o.targetserv.value = "samba";
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
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_server_set" name="event_server_set"></span>&nbsp;&raquo;&nbsp;<span id="netstorage_1" name="netstorage_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="samba.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="netstorage_2" name="netstorage_2"> </span></td>
      		</tr>
          <tr>
            <td class="bgblue"><span id="samba_server" name="samba_server"></span>:</td>
            <td class="bggrey"><input name="hostname" type="text" class="box_longtext" id="hostname" value="<% getSambaHost(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="share_1" name="share_1"></span>:</td>
            <td class="bggrey"><input name="share" type="text" class="box_longtext" id="share" value="<% getSambaShare(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="path_1" name="path_1"></span>:</td>
            <td class="bggrey"><input name="path" type="text" class="box_longtext" id="path" value="<% getSambaPath(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="user_name" name="user_name"></span>:</td>
            <td class="bggrey"><input name="username" type="text" class="box_longtext" id="username" value="<% getSambaUser(); %>" size="32" maxlength="32">
              <input name="anonymous" type="checkbox" value="1" <% getSambaAnonymous("1"); %> onClick="checkAnony();">
              <span class="style7"> <span id="anonymous_1" name="anonymous_1"></span></span></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="pwd" name="pwd"></span>:</td>
            <td class="bggrey"><input name="password" type="password" class="box_longtext" id="password" value="<% getSambaPass(); %>" size="32" maxlength="32"></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="split_by" name="split_by"></span>:</td>
            <td class="bggrey">
            	<input name="split" type="radio" value="0" <% getSambaSplit("0"); %>>
              <span id="file_size" name="file_size"></span> 
              <input name="splitbysize" type="text" id="splitbysize" value="<% getSambaMaxSize(); %>" size="3" maxlength="3">
              <span id="mb" name="mb"></span></span><br>
            	<input name="split" type="radio" value="1" <% getSambaSplit("1"); %>>
              <span id="record_time" name="record_time"></span> 
              <input name="splitbytime" type="text" id="splitbytime" value="<% getSambaMaxTime(); %>" size="3" maxlength="2">
              <span id="minute" name="minute"></span></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="disk_full" name="disk_full"></span>:</td>
            <td class="bggrey">
            	<input name="recycle" type="radio" value="0"  <% getSambaRecycle("0"); %>>
              <span id="stop_record" name="stop_record"></span><br>
              <input name="recycle" type="radio" value="1"  <% getSambaRecycle("1"); %>>
              <span id="recycle_1" name="recycle_1"></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="encode_format" name="encode_format"></span>:</td>
            <td class="bggrey">
            	<input name="encodeformat" type="radio" value="0"  <% getRecordEncode("0"); %>>
              <span id="mpeg4" name="mpeg4"></span><br>
              <input name="encodeformat" type="radio" value="7"  <% getRecordEncode("7"); %>>
              <span id="h264" name="h264"></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="file_format" name="file_format"></span>:</td>
            <td class="bggrey">
            	<input name="fileformat" type="radio" value="0"  <% getRecordFile("0"); %>>
              <span id="mp4" name="mp4"></span><br>
              <input name="fileformat" type="radio" value="1"  <% getRecordFile("1"); %>>
              <span id="avi" name="avi"></span>
            </td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
            	<input name="targetserv" type="hidden" value="">
            	<input name="language" type="hidden" value="">
            	<input class="ButtonSmall" name="Test" type="button" id="Test" value=""  onclick="test();">
            	<input class="ButtonSmall" type="button" name="Button" id="Button" value="" onClick="send()">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('netstorage.asp');">
          	</td>
        	</tr>
      	</table>
      </form>
      <br>
    </td>
  </tr>
</table>
<script language="javascript">checkAnony();</script>
</body>
</html>
