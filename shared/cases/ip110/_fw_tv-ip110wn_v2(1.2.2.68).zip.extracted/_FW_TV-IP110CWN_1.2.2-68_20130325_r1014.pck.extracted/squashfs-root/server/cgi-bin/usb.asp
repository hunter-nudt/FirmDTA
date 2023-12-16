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
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("usb_1",item_name[_USB]);
	setContent("usb_setting",item_name[_USB_SETTING]);
	setContent("usb_dismount",item_name[_USB_DISMOUNT]);
	setContent("dismount_usb",item_name[_DISMOUNT_USB]);
	setContent("usb_info",item_name[_USB_INFO]);
	setContent("total_space",item_name[_TOTAL_SPACE]);
	setContent("free_space",item_name[_FREE_SPACE]);
	setContent("usb_setting_1",item_name[_USB_SETTING]);
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
	setContent("utube_upload",item_name[_UPLOAD_FILE_TO_YOUTUBE]);

	document.getElementById("unmount").value=item_name[_DISMOUNT];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function dis(){
	var usb_stat ="<% getUsbMountState("stat"); %>"; 
	var obj = document.form1;
	if(usb_stat == "2")
		obj.unmount.disabled  = true;
	else
		obj.unmount.disabled  = <% getUsbMountState(); %>;
	checkYoutube();
}
function umount(){
	var obj = document.form1;
	obj.do_unmount.value = "1"
	obj.languse.value=lang_use;
	obj.submit();
}
function checkYoutube(){
	var obj = document.form1;
	if(obj.utubeupload.checked){
		obj.split[1].checked = true;
		obj.split[0].disabled = true;
		obj.splitbysize.disabled = true;
		if(obj.splitbytime.value>10)
			obj.splitbytime.value = 10;
	}else{
		obj.split[0].disabled = false;
		obj.splitbysize.disabled = false;
	}
}
function send(){
	var o = document.form1;
	if(o.utubeupload.checked){
		if(rangeCheck(o.splitbytime,1,10)==false)	return;
	}else
	{	
		if(rangeCheck(o.splitbysize,12,640)==false)	return;
		if(rangeCheck(o.splitbytime,1,60)==false)	return;
	}
	if(rangeCheck(o.splitbysize,12,640)==false)	return;
	if(rangeCheck(o.splitbytime,1,60)==false)	return;
	o.languse.value=lang_use;
	o.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="usb_1" name="usb_1"></span>&nbsp;&raquo;&nbsp;<span id="usb_setting" name="usb_setting"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="usb.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="usb_dismount" name="usb_dismount"> </span></td>
      		</tr>
          <tr>
            <td class="bgblue"><span id="dismount_usb" name="dismount_usb"></span></td>
            <td class="bggrey">
            	<input name="unmount" type="button" id="unmount" value="" onClick="umount();">
            	<input name="do_unmount" type="hidden" value="0">
            </td>
          </tr>
					<tr>
        		<td colspan="2" class="greybluebg"><span id="usb_info" name="usb_info"> </span></td>
      		</tr>
          <tr>
            <td class="bgblue"><span id="total_space" name="total_space"></span>:</td>
            <td class="bggrey"> <% getUsbTotalSpace(); %> </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="free_space" name="free_space"></span>:</td>
            <td class="bggrey"> <% getUsbFreeSpace(); %> </td>
          </tr>
					<tr>
        		<td colspan="2" class="greybluebg"><span id="usb_setting_1" name="usb_setting_1"></span></td>
      		</tr>  
          <tr>
            <td class="bgblue"><span id="split_by" name="split_by"></span>:</td>
            <td class="bggrey">
            	<input name="split" type="radio" value="0" <% getUsbSplit("0"); %>>
              <span id="file_size" name="file_size"></span> 
              <input name="splitbysize" type="text" id="splitbysize" value="<% getUsbMaxSize(); %>" size="2" maxlength="3">
              <span id="mb" name="mb"></span><br>
          		<input name="split" type="radio" value="1" <% getUsbSplit("1"); %>>
              <span id="record_time" name="record_time"></span> 
              <input name="splitbytime" type="text" id="splitbytime" value="<% getUsbMaxTime(); %>" size="1" maxlength="2">
              <span id="minute" name="minute"></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="disk_full" name="disk_full"></span>:</td>
            <td class="bggrey">
            	<input name="recycle" type="radio" value="0" <% getUsbRecycle("0"); %>>
              <span class="style7" id="stop_record" name="stop_record"></span><br>
          		<input name="recycle" type="radio" value="1" <% getUsbRecycle("1"); %>>
              <span class="style7" id="recycle_1" name="recycle_1"></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="encode_format" name="encode_format"></span>:</td>
            <td class="bggrey">
            	<input name="encodeformat" type="radio" value="0" <% getUsbEncode("0"); %>>
              <span id="mpeg4" name="mpeg4"></span><br>
          		<input name="encodeformat" type="radio" value="7" <% getUsbEncode("7"); %>>
              <span id="h264" name="h264"></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="file_format" name="file_format"></span>:</td>
            <td class="bggrey">
            	<input name="fileformat" type="radio" value="0"  <% getUsbFile("0"); %>>
              <span id="mp4" name="mp4"></span><br>
          		<input name="fileformat" type="radio" value="1"  <% getUsbFile("1"); %>>
              <span id="avi" name="avi"></span>
            </td>
          </tr>
          <tr>
            <td class="bgblue"><span id="utube_upload" name="utube_upload"></span></td>
            <td class="bggrey"><input name="utubeupload" type="checkbox" id="utubeupload" value="1" <% getUtubeLink("1"); %> onClick="checkYoutube();"></td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
            	<input type="hidden" id="languse" name="languse" value="en">
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="location.reload('usb.asp'+'?'+lang_use);">
            </td>
          </tr>
        </table>
		  </form>
      <br>
    </td>
  </tr>
</table>
<script language="javascript">dis();</script>
</body>
</html>
