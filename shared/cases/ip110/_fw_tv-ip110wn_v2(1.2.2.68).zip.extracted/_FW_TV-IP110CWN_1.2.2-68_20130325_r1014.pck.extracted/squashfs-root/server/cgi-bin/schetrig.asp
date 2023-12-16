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
	setContent("sch_trig_1",item_name[_SCHEDULE_TRIG]);
	setContent("email_sch",item_name[_EMAIL_SCHEDULE]);
	setContent("enable",item_name[_ENABLE]);
	setContent("sch_profile_1",item_name[_SCHEDULE_PROF]);
	setContent("interval",item_name[_INTERVAL]);
	setContent("secs",item_name[_SECS]);
	setContent("ftp_sch",item_name[_FTP_SCHEDULE]);
	setContent("enable_1",item_name[_ENABLE]);
	setContent("sch_profile_2",item_name[_SCHEDULE_PROF]);
	setContent("interval_1",item_name[_INTERVAL]);
	setContent("secs_1",item_name[_SEC_FRAME]);
	setContent("secs_2",item_name[_FRAME_SEC]);
	setContent("netstorage_sch",item_name[_STORAGE_SCHEDULE]);
	setContent("enable_2",item_name[_ENABLE]);
	setContent("sch_profile_3",item_name[_SCHEDULE_PROF]);
	setContent("interval_2",item_name[_INTERVAL]);
	setContent("secs_3",item_name[_SECS]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function send(){
	var o = document.form1;	
	if(rangeCheck(o.mail_interval,3,86400)==false)	return;
	if(rangeCheck(o.ftp_interval,3,86400)==false)	return;
	if(rangeCheck(o.samba_interval,3,86400)==false)	return;

	document.form1.submit();
}
function disHalf(){
	var o = document.form1;	
	o.ftp_frame.disabled = o.ftp_half[0].checked;
	o.ftp_interval.disabled = o.ftp_half[1].checked;		
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_config_1" name="event_config_1"></span>&nbsp;&raquo;&nbsp;<span id="sch_trig_1" name="sch_trig_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="schetrig.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="email_sch" name="email_sch"> </span></td>
      		</tr>
          <tr>
	          <td class="bgblue"><span id="enable" name="enable"></span></td>
            <td class="bggrey"><input name="mail_enable" type="checkbox" id="mail_enable" value="1" <% getScheEmailEnable("1"); %>></td>
          </tr>
          <tr>
          	<td class="bgblue"><span id="sch_profile_1" name="sch_profile_1"></span>:</td>
            <td class="bggrey"><select name="mail_profile" id="mail_profile"><% getScheEmailSche(); %></select></td>
          </tr>
          <tr>
          	<td class="bgblue"><span id="interval" name="interval"></span>:</td>
            <td class="bggrey">
            	<input name="mail_interval" type="text" id="mail_interval" value="<% getScheEmailInterval("1"); %>" size="5" maxlength="5">
              <span id="secs" name="secs"></span>
            </td>
          </tr>
          <tr>
        		<td colspan="2" class="greybluebg"><span id="ftp_sch" name="ftp_sch"> </span></td>
      		</tr>  
          <tr>
          	<td class="bgblue"><span id="enable_1" name="enable_1"></span></td>
            <td class="bggrey"><input name="ftp_enable" type="checkbox" id="ftp_enable" value="1"  <% getScheFtpEnable("1"); %>></td>
          </tr>
          <tr>
          	<td class="bgblue"><span id="sch_profile_2" name="sch_profile_2"></span>:</td>
            <td class="bggrey"><select name="ftp_profile" id="ftp_profile"><% getScheFtpSche(); %></select></td>
          </tr>
          <tr>
	        <td class="bgblue"><span id="interval_1" name="interval_1"></span>: </td>
	        <td class="bggrey">
	        	<input name="ftp_half" type="radio" id="ftp_half" value="0"  <% getScheFtpHalf("0"); %> onClick="disHalf();">
	        	<input name="ftp_interval" type="text" id="ftp_interval" value="<% getScheFtpIntervalShow(); %>" size="5" maxlength="5">                  
	          <span id="secs_1" name="secs_1"></span></td>
	      </tr>
	      <tr>
	      	<td class="bgblue">&nbsp;</td>
	      	<td td class="bggrey">
	                  <input name="ftp_half" type="radio" id="ftp_half" value="1"  <% getScheFtpHalf("1"); %> onClick="disHalf();">
	                  <select name="ftp_frame" id="ftp_frame">
					  <% getScheFtpFrame(); %>				  
					  </select>
					  <span id="secs_2" name="secs_2"></span></td>
	      </tr>
          <tr style="display:none">
        		<td colspan="2" class="greybluebg"><span id="netstorage_sch" name="netstorage_sch"> </span></td>
      		</tr> 
          <tr style="display:none">
          	<td class="bgblue"><span id="enable_2" name="enable_2"></span></td>
            <td class="bggrey"><input name="samba_enable" type="checkbox" id="samba_enable" value="1"  <% getScheSambaEnable("1"); %>></td>
          </tr>
          <tr style="display:none">
          	<td class="bgblue"><span id="sch_profile_3" name="sch_profile_3"></span>:</td>
            <td class="bggrey"><select name="samba_profile" id="samba_profile"><% getScheSambaSche("1"); %></select></td>
          </tr>
          <tr style="display:none">
          	<td class="bgblue"><span id="interval_2" name="interval_2"></span>:</td>
            <td class="bggrey">
            	<input name="samba_interval" type="text" id="samba_interval" value="<% getScheSambaInterval(); %>" size="5" maxlength="5">
              <span id="secs_3" name="secs_3"></span>
            </td>
          </tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="document.location.reload('schetrig.asp');">
          	</td>
        	</tr>
      	</table>
      </form>
      <br>
    </td>
  </tr>
</table>
<script language="javascript">disHalf();</script>
</body>
</html>
