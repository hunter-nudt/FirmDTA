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
	
	setContent("event_config_1",item_name[_EVENT_CONFIGURATION]);
	setContent("gen_setting",item_name[_GEN_SETTING]);
	setContent("general_1",item_name[_GENERAL]);
	setContent("subfolder",item_name[_FILENAME_PREFIX]);
	setContent("subfolder_desc",item_name[_SR_FILENAME_PREFIX]);
	setContent("record_per_event",item_name[_RECORDING_INTERVL]);
	setContent("record_per_event_desc",item_name[_TIME_PER_EVENT]);
	setContent("secs",item_name[_SECS]);
	setContent("gpio_per_event",item_name[_GPIO_TRIGGER_OUT_INTERVAL]);
	setContent("gpio_per_event_desc",item_name[_GPIO_TRIGGER_OUT_PER_EVENT]);
	setContent("secs_1",item_name[_SECS]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}	

function send(){
	var o = document.form1;
	if( (o.prefix.value!="") &&(alphanumCheck(o.prefix)==false) )	return;
	
	if(rangeCheck(o.duration,1,60)==false)	return;
	//if(rangeCheck(o.gpioduration,1,60)==false)	return;

	document.form1.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_config_1" name="event_config_1"></span>&nbsp;&raquo;&nbsp;<span id="gen_setting" name="gen_setting"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="general.cgi" method="post" name="form1">
		  	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
 					<tr>
      	  	<td colspan="2" class="greybluebg"><span id="general_1" name="general_1"> </span></td>
      		</tr>  
      	  <tr>
      	    <td class="bgblue"><span id="subfolder" name="subfolder"></span>:</td>
      	    <td class="bggrey">
      	    	<input name="prefix" type="text" id="prefix" value="<% getEventPrefix(); %>" size="10" maxlength="10"><br>
      	    	<span id="subfolder_desc" name="subfolder_desc"></span>
      	   	</td>
      	  </tr>
      	  <tr style="display:none">
      	    <td class="bgblue"><span id="record_per_event" name="record_per_event"></span>:</td>
      	    <td class="bggrey">
      	    	<input name="duration" type="text" id="duration" value="<% getEventDuration(); %>" size="2" maxlength="2"><span id="secs" name="secs"></span><br>
      	    	<span id="record_per_event_desc" name="record_per_event_desc"></span>
      	    </td>
      	  </tr>
      	  <tr style="display:none">
      	    <td class="bgblue"><span id="gpio_per_event" name="gpio_per_event"></span>:</td>
      	    <td class="bggrey">
      	    	<input name="gpioduration" type="text" id="gpioduration" value="<% getEventGpioDuration(); %>" size="2" maxlength="2"><span id="secs_1" name="secs_1"></span><br>
      	    	<span id="gpio_per_event_desc" name="gpio_per_event_desc"></span>
      	    </td>
      	  </tr>
      	</table>
     		<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
      	  	<td class="bggrey2">
      	      <input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
      	      <input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('general.asp');">
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
