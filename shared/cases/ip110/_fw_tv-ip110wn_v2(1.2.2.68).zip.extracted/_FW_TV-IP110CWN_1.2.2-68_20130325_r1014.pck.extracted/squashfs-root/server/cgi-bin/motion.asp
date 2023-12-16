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
<script language="javascript">
var protocol = location.protocol;
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}

function BrowserCheck()
{
		if( window.opera)
		{
			if( document.getElementById)
			{
				return false;
			}
		}
		if (navigator.appName.toUpperCase() == 'MICROSOFT INTERNET EXPLORER' && navigator.appVersion.indexOf("MSIE") > 0)
		{
			if (parseFloat(navigator.appVersion.substr(navigator.appVersion.indexOf("MSIE")+4)) >= 6.0)
			{
				return true;
			}
		}
			return false;
}

function init(){
	if(protocol == "https:"){
		setContent("viewermsg",popup_msg[popup_msg_75]);
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
}

function start(){

	setContent("motion_detect_1",item_name[_MOTION_DETECTION]);
	setContent("detect_config",item_name[_DETECT_CONFIG]);
	
	if(protocol == "https:")
		return;
		
	if(BrowserCheck()){
		if(document.getElementById("ucx")==null){
			setContent("viewermsg",popup_msg[popup_msg_76]);
			document.getElementById("viewerTR").style.display = "none";
			document.getElementById("msgTR").style.display = "";
        	return;
        }
				
		//document.ucx.RemoteHost = "<% getip(); %>";
		//document.ucx.RemotePort = "<% getport(); %>";
		document.ucx.RemoteHost = document.location.hostname;
		document.ucx.RemotePort = parseInt((document.location.port == "") ? 80: document.location.port);

		document.ucx.AccountCode = "<% getserial(); %>";

		SetOSD();
		document.ucx.MotionDetect();
		document.ucx.PlayVideo(1);//always use MJPEG streaming
		
	}else{
		setContent("viewermsg",popup_msg[popup_msg_76]);
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
	
}

function SetOSD() {
	var osd_enable = "<% getOsdEnable("1"); %>";
	if (osd_enable == "checked")
		document.ucx.TimeStampEnable(1);
	else 
		document.ucx.TimeStampEnable(0);
	document.ucx.TimestampStroke(1);
}

function goSetHeight() {
  if (parent == window) return;
  else parent.setIframeHeightMotion('ifrm');
}
</script>
</head>
<body onLoad="setTimeout('start();goSetHeight();', 100);">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="motion_detect_1" name="motion_detect_1"></span>&nbsp;&raquo;&nbsp;<span id="detect_config" name="detect_config"></span></font></b></td>
	</tr>
  	<tr>
  		<td align="center" valign="top">
	      	<table width="98%" border="0" cellpadding="3" cellSpacing="1" class="box_tn">
	      		<tr id="msgTR" name="msgTR" style=" display:none">
	          		<td width="100%" height="80" align="center" class="bggrey"><b><span id="viewermsg" name="viewermsg"></span></b></td>
	        	</tr>
	      		<tr id="viewerTR" name="viewerTR">
	      			<td class="bggrey">
		            	<p align="left">
				      			<object classid="CLSID:<% getactivexclsid(); %>" codebase="./<% getactivexname(); %>#version=<% getactivexver(); %>" width="840" height="480" align="middle" id="ucx" title="ActiveX Streaming Client">
		              	<b>ActiveX is not installed. This function is only avaiable in Windows Internet Explorer.</b>
		            		</object>
				      		</p>
		    		</td>
        		</tr>
      		</table>
   		</td>
  	</tr>
</table>
</body>
<script language="javascript">init();</script> </html>
