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
<script language="JavaScript" type="text/javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("basic_1",item_name[_BASIC]);
	setContent("system_1",item_name[_SYSTEM]);
	setContent("basic_2",item_name[_BASIC]);
	setContent("cam_name",item_name[_CAM_NAME]);
	setContent("location_1",item_name[_LOCATION]);
	setContent("led",item_name[_INDI_LED]);
	setContent("led_ctl",item_name[_INDI_LED_CTL]);
	setContent("normal",item_name[_NORMAL]);
	setContent("off",item_name[_OFF]);
	setContent("langu_def",item_name[_LANGUAGE_DEF]);
	setContent("ir",item_name[_IR_LED]);
	setContent("ir_ctl",item_name[_IR_LED_CTL]);
	setContent("start_time",item_name[_START_TIME]);
	setContent("end_time",item_name[_END_TIME]);
	


	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function checkIR(irObj){
	var o = document.form1;
	var sIdx = irObj.selectedIndex;
	if(sIdx == 1)
	{
		document.getElementById("start_time_setting").style.display = "";
		document.getElementById("end_time_setting").style.display = "";
		o.start_hr.disabled = false;
		o.start_min.disabled = false;
		o.end_hr.disabled = false;
		o.end_min.disabled = false;
		o.start_hr.value = addZero(o.start_hr.value);
		o.start_min.value = addZero(o.start_min.value);
		o.end_hr.value = addZero(o.end_hr.value);
		o.end_min.value = addZero(o.end_min.value);
	}
	else
	{
		document.getElementById("start_time_setting").style.display = "none";
		document.getElementById("end_time_setting").style.display = "none";
		o.start_hr.disabled = true;
		o.start_min.disabled = true;
		o.end_hr.disabled = true;
		o.end_min.disabled = true;
	}
	goSetHeight();
}

function init(){
	var o = document.form1;
	checkIR(o.irled);
}

function checkTime(starthr,startmin,endhr,endmin){
	if( (isPosInt(starthr.value) && range(starthr.value,0,23) ) == false)
	{
		warnAndSelect(starthr,popup_msg[popup_msg_33]);
		return false;
	}
	if( (isPosInt(startmin.value) && range(startmin.value,0,59) ) == false)
	{
		warnAndSelect(startmin,popup_msg[popup_msg_34]);
		return false;
	}
	if( (isPosInt(endhr.value) && range(endhr.value,0,23) ) == false)
	{
		warnAndSelect(endhr,popup_msg[popup_msg_33]);
		return false;
	}
	if( (isPosInt(endmin.value) && range(endmin.value,0,59) ) == false)
	{
		warnAndSelect(endmin,popup_msg[popup_msg_34]);
		return false;
	}
	if( parstIntTrimLeadZero(starthr.value) > parstIntTrimLeadZero(endhr.value))
	{
		warnAndSelect(starthr,popup_msg[popup_msg_35]);
		return false;
	}
	else if((parstIntTrimLeadZero(starthr.value) == parstIntTrimLeadZero(endhr.value)) && (parstIntTrimLeadZero(startmin.value) > parstIntTrimLeadZero(endmin.value)))
	{
		warnAndSelect(startmin,popup_msg[popup_msg_35]);
		return false;
	}
	else if((parstIntTrimLeadZero(starthr.value) == parstIntTrimLeadZero(endhr.value)) && (parstIntTrimLeadZero(startmin.value) == parstIntTrimLeadZero(endmin.value)))
	{
		warnAndSelect(startmin,popup_msg[popup_msg_35]);
		return false;
	}
	return true;
	
}

function send(){
	var obj = document.form1;
	if(isAscii(obj.camname.value) == false && obj.camname.value.length>16)
	{
		warnAndSelect(obj.camname,popup_msg[popup_msg_68]);
		return;
	}
	if(isAscii(obj.camlocation.value) == false && obj.camlocation.value.length>16)
	{
		warnAndSelect(obj.camlocation,popup_msg[popup_msg_69]);
		return;
	}
	if(obj.irled.selectedIndex==1){
		if(checkTime(obj.start_hr,obj.start_min,obj.end_hr,obj.end_min) == false ) 
			return;
		obj.start_hr.value = addZero(obj.start_hr.value);
		obj.start_min.value = addZero(obj.start_min.value);
		obj.end_hr.value = addZero(obj.end_hr.value);
		obj.end_min.value = addZero(obj.end_min.value);
	}

	obj.languse.value=lang_use;
	obj.submit();
}

function goSetHeight() {
	if (parent == window) return;
	else{
		parent.setIframeHeight('ifrm');
		parent.setLocation("<% getLocation(); %>");
	}
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="basic_1" name="basic_1"></span>&nbsp;&raquo;&nbsp;</span><span id="system_1" name="system_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<form action="system.cgi" method="post" name="form1">
  			<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
       		<tr>
        		<td colspan="2" class="greybluebg"><span id="basic_2" name="basic_2"> </span></td>
      		</tr>
        	<tr>
        	  <td width="150" class="bgblue"><span id="cam_name" name="cam_name"></span>: </td>
        	  <td class="bggrey"><input name="camname" type="text" id="camname" value="<% getCamNameS(); %>" size="32" maxlength="32"></td>
        	</tr>
        	<tr>
        	  <td class="bgblue"><span id="location_1" name="location_1"></span>: </td>
        	  <td class="bggrey"><input name="camlocation" type="text" id="camlocation" value="<% getLocationS(); %>" size="32" maxlength="32"></td>
        	</tr>
        	<tr style="display:none">
     			  <td class="bgblue"><span id="langu_def" name="langu_def"></span>: </td> 
        	  <td class="bggrey"><select name="langu" id="langu" ><% getLanguage(); %></select></td>
        	</tr>
					<tr>
       		 <td colspan="2" class="greybluebg"><span id="led" name="led"> </span></td>
      		</tr>
          <tr>
	          <td class="bgblue"><span id="led_ctl" name="led_ctl"></span>: </td>
            <td class="bggrey">
            	<input name="led" type="radio" value="2" <% getLed("2"); %>><span id="normal" name="normal"></span>
              <input name="led" type="radio" value="0" <% getLed("0"); %>><span id="off" name="off"></span>
            </td>
          </tr>
			<tr style="display:none">
       	 		<td colspan="2" class="greybluebg"><span id="ir" name="ir"> </span></td>
      		</tr>
          <tr style="display:none">
          	<td class="bgblue"><span id="ir_ctl" name="ir_ctl"></span>: </td>
            <td class="bggrey"><select name="irled" id="irled" onChange="checkIR(this);"><% getIRLed(); %></select></td>
          </tr>
          <tr id="start_time_setting" name="start_time_setting" style="display:none;">
          	<td class="bgblue"><span id="start_time" name="start_time"></span>: </td>
            <td class="bggrey">
            	<input name="start_hr" type="text" id="start_hr" value="<% getIRStartHr(); %>" size="2" maxlength="2">:
              <input name="start_min" type="text" id="start_min" value="<% getIRStartMin(); %>" size="2" maxlength="2">
            </td>
          </tr>
          <tr id="end_time_setting" name="end_time_setting" style="display:none;">
          	<td class="bgblue"><span id="end_time" name="emd_time"></span>: </td>
            <td class="bggrey">
            	<input name="end_hr" type="text" id="end_hr" value="<% getIREndHr(); %>" size="2" maxlength="2">:
              <input name="end_min" type="text" id="end_min" value="<% getIREndMin(); %>" size="2" maxlength="2">
            </td>
          </tr>
      	</table>
				<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
					<tr>
        		<td class="bggrey2">
            	<input type="hidden" id="languse" name="languse" value="en">
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('system.asp'+'?'+lang_use);">
          	</td>
        	</tr>
      	</table>
      <br>
      </form>
		</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">init();</script>
</body>
</html>
