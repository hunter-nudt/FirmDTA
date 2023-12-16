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
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("video_audio_1",item_name[_VIDEO_N_AUDIO]);
	setContent("video_1",item_name[_VIDEO]);
	setContent("mpeg4",item_name[_MPEG4]);
	setContent("video_resol",item_name[_V_RESOLUTION]);
	setContent("video_qual",item_name[_V_QUALITY]);
	setContent("frame_rate",item_name[_FRAME_RATE]);
	setContent("fps",item_name[_FPS]);
	setContent("mjpeg",item_name[_MJPEG]);
	setContent("video_resol_1",item_name[_V_RESOLUTION]);
	setContent("video_qual_1",item_name[_V_QUALITY]);
	setContent("frame_rate_1",item_name[_FRAME_RATE]);
	setContent("fps_1",item_name[_FPS]);
	setContent("mjpegviewer",item_name[_MJPEGVIEWER]);
	setContent("h264",item_name[_H264]);
	setContent("video_resol_2",item_name[_V_RESOLUTION]);
	setContent("video_qual_2",item_name[_V_QUALITY]);
	setContent("frame_rate_2",item_name[_FRAME_RATE]);
	setContent("fps_2",item_name[_FPS]);
	setContent("setting",item_name[_SETTING]);
	setContent("_3gpp",item_name[_3GPP]);
	setContent("disable",item_name[_DISABLE]);
	setContent("without_audio",item_name[_WITHOUT_AUDIO]);
	setContent("with_audio",item_name[_WITH_AUDIO]);
	
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function setFramerateOption(fmObj,length){
	var i;
	var opt;
	var optionLength = fmObj.length;
	var preIdx = fmObj.selectedIndex;
	if(preIdx>length-1)
		preIdx = length-1;
	for(i=optionLength-1;i>=0;i--)
	{	
		fmObj.options[i] = null
	}
	
	for(i=1;i<=length;i++)
	{
		opt = new Option(i,i);
		fmObj.options.add(opt);
		if(preIdx == i-1)
				fmObj.options.selectedIndex = i-1;
	}
}	

function send(){
	var obj = document.form1;
	obj.languse.value=lang_use;
	obj.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="video_audio_1" name="video_audio_1"></span>&nbsp;&raquo;&nbsp;<span id="video_1" name="video_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<form action="video.cgi" method="post" name="form1">
  			<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr style="display:none">
        		<td colspan="2" class="greybluebg"><span id="h264" name="h264"> </span></td>
      		</tr>
          <tr style="display:none">
            <td width="150" valign="top" class="bgblue"><span id="video_resol_2" name="video_resol_2"></span>:</td>
            <td class="bggrey"><select name="resolution2" id="resolution2"><% getresolution2(); %></select></td>
          </tr>
          <tr style="display:none">
            <td class="bgblue"><span id="video_qual_2" name="video_qual_2"></span>:</td>
            <td class="bggrey"><select name="quality2" id="quality2"><% getquality2(); %></select></td>
          </tr>
          <tr style="display:none">
            <td class="bgblue"><span id="frame_rate_2" name="frame_rate_2"></span>:</td>
            <td class="bggrey"><select name="framerate2" id="framerate2"><% getframerate2("30"); %></select><span class="style7" id="fps_2" name="fps_2"></span></td>
          </tr>
          <tr style="display:none">
        		<td colspan="2" class="greybluebg"><span id="mpeg4" name="mpeg4"> </span></td>
      		</tr>
          <tr style="display:none">
            <td class="bgblue"><span id="video_resol" name="video_resol"></span>:</td>
            <td class="bggrey"><select name="resolution0" id="resolution0"><% getresolution0(); %></select></td>
          </tr>
          <tr style="display:none">
            <td class="bgblue"><span id="video_qual" name="video_qual"></span>:</td>
            <td class="bggrey"><select name="quality0" id="quality0"><% getquality0(); %></select></td>
          </tr>
          <tr style="display:none">
            <td class="bgblue"><span id="frame_rate" name="frame_rate"></span>:</td>
            <td class="bggrey"><select name="framerate0" id="framerate0"><% getframerate0("30"); %></select><span class="style7" id="fps" name="fps"></span></td>
          </tr>
          <tr>
        		<td colspan="2" class="greybluebg"><span id="mjpeg" name="mjpeg"> </span></td>
      		</tr>
          <tr>
            <td class="bgblue"><span id="video_resol_1" name="video_resol_1"></span>:</td>
            <td class="bggrey"><select name="resolution1" id="resolution1">
                <% getresolution1(); %>
              </select></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="video_qual_1" name="video_qual_1"></span>:</td>
            <td class="bggrey"><select name="quality1" id="select2"><% getquality1(); %></select></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="frame_rate_1" name="frame_rate_1"></span>:</td>
            <td class="bggrey"><select name="framerate1" id="framerate1"><% getframerate1("25"); %></select><span class="style7" id="fps_1" name="fps_1"></span></td>
          </tr>
          <tr style="display:none">
            <td class="bgblue"><span id="mjpegviewer" name="mjpegviewer"></span>:</td>
            <td class="bggrey"><select name="view1" id="view1"><% getviewer1(); %></select></td>
          </tr>
          <tr style="display:none">
        		<td colspan="2" class="greybluebg"><span id="_3gpp" name="_3gpp"> </span></td>
      		</tr>
          <tr style="display:none">
          	<td valign="top" class="bgblue"><span id="setting" name="setting"></span>:</td>
            <td class="bggrey">
            	<span class="style7"> <input name="3gppenable" type="radio" id="3gppenable" value="0" <% get3gppEnable("0"); %>>
              <span id="disable" name="disable"></span></span><br>
           		<span class="style7"> <input name="3gppenable" type="radio" id="3gppenable" value="2" <% get3gppEnable("2"); %>>
              <span id="without_audio" name="without_audio"></span></span><br>
          		<span class="style7"> <input name="3gppenable" type="radio" id="3gppenable" value="1" <% get3gppEnable("1"); %>>
              <span id="with_audio" name="with_audio"></span></span>
            </td>
          </tr>
        </table>
				<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
       			<td class="bggrey2">
         			<input type="hidden" id="languse" name="languse" value="en">
           		<input class="ButtonSmall" type="button" id="Button"name="Button" value="" onClick="send();">
           		<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('video.asp'+'?'+lang_use);">
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
