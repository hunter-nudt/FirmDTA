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
var protocol = location.protocol;
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}

function def(){
	obj = document.form1;
	obj.brightness.value = "<% getDefaultBrightness(); %>";
	obj.contrast.value = "<% getDefaultContrast(); %>";
	obj.saturation.value = "<% getDefaultSaturation(); %>";
	
}
function send(){
	obj = document.form1;
	if(rangeCheck(obj.brightness,0,100)==false)	return;
	if(rangeCheck(obj.contrast,0,100)==false)	return;
	if(rangeCheck(obj.saturation,0,100)==false)	return;
	obj.submit();
	obj.Button.disabled = true;
}

function init(){
	if(protocol == "https:"){
		setContent("viewermsg",popup_msg[popup_msg_75]);
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
}

function start(){
	setContent("video_audio_1",item_name[_VIDEO_N_AUDIO]);
	setContent("camera_1",item_name[_CAMERA]);
	setContent("img_setting",item_name[_IMAGE_SETTING]);
	setContent("brightness_1",item_name[_BRIGHTNESS]);
	setContent("range",item_name[_RANGE]);
	setContent("contrast_1",item_name[_CONTRAST]);
	setContent("range_2",item_name[_RANGE]);
	setContent("saturation_1",item_name[_SATURATION]);
	setContent("range_3",item_name[_RANGE]);
	setContent("mirror",item_name[_MIRROR]);
	setContent("vertical_1",item_name[_VERTICAL]);
    setContent("horizontal_1",item_name[_HORIZONTAL]);
    setContent("light_freq",item_name[_LIGHT_FREQ]);
    setContent("_50hz",item_name[_50HZ]);
    setContent("_60hz",item_name[_60HZ]);
    setContent("outdoor",item_name[_OUTDOOR]);
    setContent("ae_control",item_name[_AE_CONTROL]);
	setContent("fast_1",item_name[_FAST]);
	setContent("normal_1",item_name[_NORMAL]);
	setContent("slow_1",item_name[_SLOW]);
	setContent("overlay",item_name[_OLAY_SETTING]);
	setContent("include_d_t",item_name[_INCLUDE_DATE_TIME]);
	setContent("enable_opq",item_name[_ENABLE_OPQ]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
	document.getElementById("Button2").value=item_name[_DEFAULT];
	
}

function initView()
{
		var remote_host = document.location.hostname;
		var remote_port = parseInt((document.location.port == "") ? 80: document.location.port);
		document.write("<object \
			classid = 'clsid:CAFEEFAC-0015-0000-0012-ABCDEFFEDCBA' \
			codebase = 'http:\/\/java.sun.com\/update\/1.5.0\/jinstall-1_5_0_12-windows-i586.cab#Version=5,0,120,4' \
			WIDTH = '320' HEIGHT = '240' NAME = 'ucx' ID = 'ucx'> \
			<PARAM NAME = CODE VALUE = 'ultracam.class' > \
			<PARAM NAME = ARCHIVE VALUE = 'ultracam.jar' > \
			<PARAM NAME = NAME VALUE = 'ucx' > \
			<PARAM NAME = ID VALUE = 'ucx' > \
			<param name = 'type' value = 'application\/x-java-applet;jpi-version=1.5.0_12'> \
			<param name = 'scriptable' value = 'false'> \
			<PARAM NAME = 'accountcode' VALUE='<% getserial(); %>' > \
			<PARAM NAME = 'codebase' VALUE='http:\/\/"+remote_host+":"+remote_port+"\/admin' > \
			<PARAM NAME = 'mode' VALUE='0' > \
			<PARAM NAME = 'mayscript' VALUE='' /> \
			<comment> \
			<embed \
				type = 'application\/x-java-applet' \
				CODE = 'ultracam.class' \
				ARCHIVE = 'ultracam.jar' \
				NAME = 'ucx' \
				ID = 'ucx' \
				WIDTH = '320' \
				HEIGHT = '240' \
				accountcode ='<% getserial(); %>'  \
				codebase ='http:\/\/"+remote_host+":"+remote_port+"\/admin'  \
				mode ='1'  \
				mayscript ='' \
				scriptable = false \
				pluginspage = 'http:\/\/java.sun.com\/products\/plugin\/index.html#download'> \
			<noembed> \
			</noembed> \
			</embed> \
			</comment> \
			</object>");
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="video_audio_1" name="video_audio_1"></span>&nbsp;&raquo;&nbsp;<span id="camera_1" name="camera_1"></span></font></b></td>
	</tr>
	<tr>
    <td valign="top">
    	<form action="camera.cgi" method="post" name="form1">
    		<table width="97%" border="0" cellpadding="2" cellspacing="0" id="msgTR" name="msgTR" style=" display:none">
        	<tr>
          	<td width="100%" height="80" align="center"><b><font color="#FFFFFF"><span id="viewermsg" name="viewermsg"></span></font></b></td>
        	</tr>
	      </table>
    		<table width="100%" border="0" cellspacing="1" cellpadding="10">
        	<tr>
          	<td align="center">
          		<p align="center" id="viewerTR" name="viewerTR">
				<!--"CONVERTED_APPLET"-->
				<script language="JavaScript" type="text/javascript">initView();</script>
				<!--"END_CONVERTED_APPLET"-->
		          </p>
		        </td>
        	</tr>
	      </table>
				<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="img_setting" name="img_setting"> </span></td>
      		</tr>    
          <tr>
             <td width="150" class="bgblue"><span id="brightness_1" name="brightness_1"></span>:</td>
             <td class="bggrey"><input name="brightness" type="text" id="brightness" value="<% getBrightness(); %>" size="3" maxlength="3">
             <span id="range" name="range"></span></td>
           </tr>
           <tr>
             <td class="bgblue"><span id="contrast_1" name="contrast_1"></span>:</td>
             <td class="bggrey"><input name="contrast" type="text" id="contrast" value="<% getContrast(); %>" size="3" maxlength="3">                
               <span id="range_2" name="range_2"></span></td>
           </tr>
           <tr>
             <td class="bgblue"><span id="saturation_1" name="saturation_1"></span>:</td>
             <td class="bggrey"><input name="saturation" type="text" id="saturation" value="<% getSaturation(); %>" size="3" maxlength="3">                
               <span id="range_3" name="range_3"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <input type="button" id="Button2" name="Button2" value="" onClick="def();"></td>
           </tr>
           <tr>
             <td class="bgblue"><span id="mirror" name="mirror"></span>:</td>
             <td class="bggrey"><input name="vertical" type="checkbox" id="vertical" value="1" <% getFlip("1"); %>>
               <span class="style7"><span id="vertical_1" name="vertical_1"></span>
               <input name="horizontal" type="checkbox" id="horizontal" value="1" <% getMirror("1"); %>>
             <span id="horizontal_1" name="horizontal_1"></span></span></td>
           </tr>
           <tr>
             <td class="bgblue"><span id="light_freq" name="light_freq"></span>:</td>
             <td class="bggrey"><input name="flicker" type="radio" value="2" <% getFlicker("2"); %>>
               <span class="style7"><span id="_50hz" name="_50hz"></span>
               <input name="flicker" type="radio" value="1" <% getFlicker("1"); %>>
               <span id="_60hz" name="_60hz"></span></span>
               <input name="flicker" type="radio" value="0" <% getFlicker("0"); %>>
             	 <span class="style7"id="outdoor" name="outdoor"></span>
             </td>
           </tr>
           <tr style="display:none">
            <td class="bgblue"><span id="ae_control" name="ae_control"></span>:</td>
            <td class="bggrey">
            	<input name="aeindex" type="radio" id="aeindex" value="7" <% getAEIndex("7"); %>>
              <span id="fast_1" name="fast_1"></span>
              <input name="aeindex" type="radio" id="aeindex" value="8" <% getAEIndex("8"); %>>
              <span id="normal_1" name="normal_1"></span>
              <input name="aeindex" type="radio" id="aeindex" value="0" <% getAEIndex("0"); %>>
              <span id="slow_1" name="slow_1"></span>
            </td>
          </tr>
          <tr style="display:none">
          <td colspan="2" class="greybluebg"><span id="overlay" name="overlay"> </span></td>
        </tr>
        <tr style="display:none">
          <td class="bgblue"><span id="include_d_t" name="include_d_t"></span></td>
          <td class="bggrey"><input name="osd_enable" type="checkbox" id="osd_enable" value="1" <% getOsdEnable("1"); %>></td>
        </tr>
        <tr style="display:none">
          <td class="bgblue"><span id="enable_opq" name="enable_opq"></span></td>
          <td class="bggrey"><input name="osd_opaque" type="checkbox" id="osd_opaque" value="1" <% getOsdOpaque("1"); %>></td>
        </tr>
        </table>
				<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
		      		<input class="ButtonSmall" type="button" name="Button" id="Button" value="" onClick="send();">
		      		<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="reloadScreen('rdrvideo.asp');">
		      	</td>
		      </tr>
		    </table>
	    </form>
	    <br>
		</td>
  </tr>
</table>
<script language="javascript" >init();</script>
</body>
</html>