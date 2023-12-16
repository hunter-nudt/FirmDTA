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
<script type="text/JavaScript">
<!--
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("video_audio_1",item_name[_VIDEO_N_AUDIO]);
	setContent("audio_1",item_name[_AUDIO]);
	setContent("mic_in",item_name[_CAM_MIC_IN]);
	setContent("enable",item_name[_ENABLE]);
	setContent("spk_out",item_name[_CAM_SPK_OUT]);
	setContent("enable_1",item_name[_ENABLE]);
	setContent("volume_1",item_name[_VOLUME]);
	
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function send(){
	obj = document.form1;
	if(rangeCheck(obj.volume,0,100)==false)	return;
	obj.submit();
}
//-->
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="video_audio_1" name="video_audio_1"></span>&nbsp;&raquo;&nbsp;<span id="audio_1" name="audio_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="sound.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="mic_in" name="mic_in"> </span></td>
      		</tr>
          <tr>
          	<td width="150" class="bgblue"><span id="enable" name="enable"></span></td>
            <td class="bggrey"><input name="mic_enable" type="checkbox" id="mic_enable" value="1" <% getMicEnable("1"); %>></td>
          </tr>
		  <tr style="display:none">
        		<td colspan="2" class="greybluebg"><span id="spk_out" name="spk_out"> </span></td>
      		</tr>
          <tr style="display:none">
          	<td class="bgblue"><span id="enable_1" name="enable_1"></span></td>
            <td class="bggrey"><input name="speaker_enable" type="checkbox" id="speaker_enable" value="1" <% getSpeakerEnable("1"); %>></td>
          </tr>
          <tr style="display:none">
          	<td class="bgblue"><span id="volume_1" name="volume_1"></span>:</td>
            <td class="bggrey"><input name="volume" type="text" id="volume" value="<% getSpeakerVol(); %>" size="2" maxlength="2"></td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">  
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('audio.asp');">
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
