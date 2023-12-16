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
<script language="javascript" type="text/javascript" src="warn.js"></script>
<script language="javascript" type="text/javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("basic_1",item_name[_BASIC]);
	setContent("date_time_1",item_name[_DATE_TIME]);
	setContent("date_n_time",item_name[_DATE_N_TIME]);
	setContent("timezone_1",item_name[_TIMEZONE]);
	setContent("setting",item_name[_SETTING]);
	setContent("daylight",item_name[_DAYLIGHT_SAVE]);
	setContent("sync_pc",item_name[_SYNC_PC]);
	setContent("sync_ntp",item_name[_SYNC_NTP]);
	setContent("ntp_server",item_name[_NTP_SERVER]);
	setContent("update_intvl",item_name[_UPDATE_INTVL]);
	setContent("hours",item_name[_HOURS]);
	setContent("manual",item_name[_MANUAL]);
	setContent("date",item_name[_DATE]);
	setContent("time",item_name[_TIME]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}	

var yr,mm,dy,hr,minu,sec;

function time_init(){

var DATENOW = document.form1.date.value;
var TIMENOW = document.form1.time.value;

var a=DATENOW.split("-");
var b=TIMENOW.split(":");

dy=parstIntTrimZero(a[2]);
mm=parstIntTrimZero(a[1]);
yr=parstIntTrimZero(a[0]);
sec=parstIntTrimZero(b[2]);
minu=parstIntTrimZero(b[1]);
hr=parstIntTrimZero(b[0]);

}
function Init(){
//	time_init();
  //  IntID=window.setInterval("show_pctime()",1000);
}
function send(){
	var obj = document.form1;
	if(obj.synctype[0].checked)
	{
		if(dateCheck(obj.date)==false || timeCheck(obj.time)==false) return;
		curDate=new Date();
		obj.pcdate.value= curDate.getFullYear()+"/"+ addZero((curDate.getMonth()+ 1 ))+"/"+addZero(curDate.getDate())
		obj.pctime.value= addZero(curDate.getHours())+":"+ addZero(curDate.getMinutes()) +":"+ addZero(curDate.getSeconds())
	}else if(obj.synctype[1].checked){
		if(isFilled(obj.ntpserver) == false || asciiCheck(obj.ntpserver)==false) return;
	}else if(obj.synctype[2].checked){
		if(dateCheck(obj.date)==false || timeCheck(obj.time)==false) return;
	}
	if(ipv4Check(obj.ntpserver)==false)
		if(ipCheckv6(obj.ntpserver)==false)
			if(hostCheck(obj.ntpserver)==false)	return;
	obj.submit();
}

function goSetHeight() {
	if (parent == window) return;
	else{
		parent.setIframeHeight('ifrm');
		parent.setDateTime("<% getDate(); %>"+" <% getTime(); %>");
	}
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="basic_1" name="basic_1"></span>&nbsp;&raquo;&nbsp;</span><span id="date_time_1" name="date_time_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<form action="datetime.cgi" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
        	<tr>
        		<td colspan="3" class="greybluebg"><span id="date_n_time" name="date_n _time"> </span></td>
      		</tr>
					<tr>
        		<td nowrap bgcolor="#FFFFFF" class="bgblue" width="150"><span id="timezone_1" name="timezone_1"></span>: </td>
        		<td colspan="2" bgcolor="#FFFFFF" class="bggrey"><select name="timezone" id="timezone"><% getTimeZone() %></select></td>
      		</tr>
      		<tr>
        		<td valign="top" bgcolor="#FFFFFF" class="bgblue" width="150"><span id="setting" name="setting"></span>: </td>
        		<td colspan="2" bgcolor="#FFFFFF" class="bggrey">
        			<input name="daylightsave" id="daylightsave" type="checkbox" value="1" <% getDayLightSave("1"); %>>
        			<span id="daylight" name="daylight"></span></span>
							<br>    
          		<input name="synctype" type="radio" value="2" <% getSyncType("2"); %>>
          		<span id="sync_pc" name="sync_pc"></span> 
          		<input name="pcdate" type="hidden" value="">
          		<input name="pctime" type="hidden" value="">
        			<br>
           		<input name="synctype" type="radio" value="1"  <% getSyncType("1"); %>>
           		<span id="sync_ntp" name="sync_ntp"></span>
           		<br>
           		<table width="100%" border="0" cellspacing="1" cellpadding="3">
								<tr class="box_tn">
		        			<td width="25">&nbsp;</td>
		        			<td width="35%"><span id="ntp_server" name="ntp_server"> </span>:</td>
		        			<td width="55%"><input name="ntpserver" type="text" id="ntpserver" value="<% getNtpIp() %>" size="32" maxlength="32"></td>
		      			</tr>
	      				<tr class="box_tn">
		        			<td>&nbsp;</td>
		        			<td><span id="update_intvl" name="update_intvl"> </span>:</td>
		        			<td><select name="ntp_interval" id="ntp_interval"><% getNtpInterval(); %></select><span id="hours" name="hours"></span></td>
	      				</tr>
	      			</table>
            	<input name="synctype" type="radio" value="0"  <% getSyncType("0"); %>>
							<span id="manual" name="manual"></span>
        			<br>
							<table width="100%" border="0" cellspacing="1" cellpadding="3">
	  						<tr class="box_tn">
		        			<td width="25">&nbsp;</td>
		        			<td width="35%"><span id="date" name="date"></span>:</td>
		        			<td width="55%"><input name="date" type="text" id="date" value="<% getDate(); %>" size="10" maxlength="10">(YYYY/MM/DD) </td>
		      			</tr>
		      			<tr class="box_tn">
		        			<td>&nbsp;</td>
		        			<td><span id="time" name="time"></span>:</td>
		        			<td><input name="time" type="text" id="time" value="<% getTime(); %>" size="10" maxlength="8">(hh:mm:ss)</td>
		      			</tr>
	    				</table>
  					</td>
					</tr>
				</table>
				<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
					<tr>
        		<td class="bggrey2">
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send();">
            	<input class="ButtonSmall" name="Button1" type="button" id="Button1" value="" onClick="document.location.reload('datetime.asp');">
            </td>
          </tr>
        </table>
        <br>
			</form>
		</td>
	</tr>
</table>
<script language="javascript">Init();</script>
</body>
</html>


    		