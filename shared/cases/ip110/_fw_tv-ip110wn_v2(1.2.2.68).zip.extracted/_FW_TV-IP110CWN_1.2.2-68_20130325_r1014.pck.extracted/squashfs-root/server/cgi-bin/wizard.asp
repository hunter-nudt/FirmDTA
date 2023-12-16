<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=800px">
<title><% getWlanExist("stat"); %> Network Camera</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/javascript" src="../lang/<% getCgiLanguage(); %>/itemname.js"></script>
<script language="JavaScript" type="text/javascript" src="../lang/<% getCgiLanguage(); %>/msg.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="date.js"></script>
<script language="javascript">

function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));
}

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}

function start(){
	
	setContent("location",item_name[_LOCATION]);
	setContent("cam_setting",item_name[_CAM_SETTING]);
	setContent("cam_name",item_name[_CAM_NAME]);
	setContent("location_1",item_name[_LOCATION]);
	setContent("admin_pwd",item_name[_ADMIN_PWD]);
	setContent("confirm_pwd",item_name[_CONFIRM_PWD]);
	setContent("cam_setting_1",item_name[_CAM_SETTING]);
	setContent("cam_name_1",item_name[_CAM_NAME]);
	setContent("location_2",item_name[_LOCATION]);
	setContent("admin_pwd_1",item_name[_ADMIN_PWD]);
	setContent("confirm_pwd_1",item_name[_CONFIRM_PWD]);
	setContent("msg_line1",sw_msg[sw_msg_35]);
	setContent("msg_line2",sw_msg[sw_msg_1]);
	setContent("msg_line3",sw_msg[sw_msg_2]);
	setContent("msg_line4",sw_msg[sw_msg_3]);
	setContent("msg_line5",sw_msg[sw_msg_36]);
	
	document.getElementById("Button").value=item_name[_NAXT];
	document.getElementById("Button2").value=item_name[_CANCEL];
	
}	
function hasWhiteSpace(s)
{
	re = new RegExp(/\s/g);
	return re.test(s);
}
function send(act){

	var obj = document.form1;
	if(isAscii(obj.camname.value) == false && obj.camname.value.length>16)
	{
		warnAndSelect(obj.camname,popup_msg[popup_msg_68]);
		return;
	}
	if(isAscii(obj.location.value) == false && obj.location.value.length>16)
	{
		warnAndSelect(obj.location,popup_msg[popup_msg_69]);
		return;
	}
	if(act == "addadm")
	{
		if(asciiCheck(obj.adminpass)== false) return false;
		if(asciiCheck(obj.adminpass2)== false) return false;
		if(hasWhiteSpace(obj.adminpass.value))
		{
			warnAndSelect(obj.adminpass, popup_msg[popup_msg_32]);
			return false;
		}
		if(obj.adminpass.value != obj.adminpass2.value)
		{
			warnAndSelect(obj.adminpass,popup_msg[popup_msg_10]);
			return false;
		}
		if(obj.adminpass.value == "")
		{
			if(confirm(popup_msg[popup_msg_9]+"?") == false)
					return false;			
		}
	}
	obj.languageidx.value = "<%getCgiLanguage();%>";
	obj.submit();
}
</script>	
</head>
<body onLoad="time_go();start();">
<table width="900" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="21"><img src="images/c1_tl.gif" width="21"></td>
		<td width="858" background="images/bg1_t.gif"><img src="images/top_1.gif" width="390"></td>
		<td width="21"><img src="images/c1_tr.gif" width="21"></td>
	</tr>
	<tr>
  	<td valign="top" background="images/bg1_l.gif"><img src="images/top_2.gif" width="21" height="69"></td>
    <td background="images/bg.gif">
    	<table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="13%" valign="top"><img src="images/logo.gif" width="390" height="69"></td>
					<td width="87%" align="right" valign="top">
						<table width="100%" border="0" cellpadding="4" cellspacing="0">
							<tr>
								<td align="right" valign="top"><img src="images/description_<% getmodelname(); %>.gif"></td>
							</tr>
							<tr>
								<td align="right" valign="top">
									<b><font color="#FFFFFF"><span id="location" name="location"></span>:
									<span class="t12"><% getLocation(); %>&nbsp;&nbsp;&nbsp; </span></font>
									<font color="#FFFFFF"><span class="style1">
									<span id="datebar"><% getDate(); %> <%getTime(); %></span>
									&nbsp; </span>&nbsp; </font></b>
								</td>
							</tr>
						</table>
					</td>
			  </tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="250" valign="top" align="center">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
				      <tr>
				        <td width="100%" height="80" align="center" bgcolor="#666666">
				          <table width="97%"  border="0" cellpadding="5" cellspacing="1">
				          	<tr>
				            	<td width="100%">
				            		<p><font color="#FFFFFF" size="3"><b><span id="msg_line1" name="msg_line1"></span></b></font><br>
				              	<font color="#FFFFFF"><span id="msg_line5" name="msg_line5"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="cam_setting" name="cam_setting"></span></b></font></p>
				                <p><font color="#FFFFFF"><b><span id="cam_name" name="cam_name"></span></b><span id="msg_line2" name="msg_line2"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="location_1" name="location_1"></span></b><span id="msg_line3" name="msg_line3"></span></font></p>
				                <p><font color="#FFFFFF"><b><span id="admin_pwd" name="admin_pwd"></span>/<span id="confirm_pwd" name="confirm_pwd"></span></b><span id="msg_line4" name="msg_line4"></span></p></font>
				              </td>
				            </tr>
				          </table>
				        </td>
							</tr>
						</table>
					</td>
					<td width="10"><img src="images/spacer.gif" width="10" height="15"></td>
					<td valign="top">
						<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
							<tr>
								<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="cam_setting_1" name="cam_setting_1"></span></font></b></td>
							</tr>
				      <tr>
				      	<td width="100%" height="80" align="center" valign="top">
						  		<form action="smartwizard.cgi?go=2" method="post" name="form1">
				          	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
				            	<tr>
				              	<td class="bgblue"><span id="cam_name_1" name="cam_name_1"></span>:</td>
				              	<td class="bggrey"><input name="camname" type="text" class="box_longtext" id="camname" value="<% getWizardSpecialStrip("CameraName"); %>" size="32" maxlength="32"></td>
				            	</tr>
				            	<tr>
				              	<td class="bgblue"><span id="location_2" name="location_2"></span>: </td>
				              	<td class="bggrey"><span class="t12"><input name="location" type="text" class="box_longtext" id="location" value="<% getWizardSpecialStrip("Location"); %>" size="32" maxlength="32"></span></td>
				            	</tr>
				            	<tr>
				              	<td class="bgblue"><span id="admin_pwd_1" name="admin_pwd_1"></span>:</td>
				              	<td class="bggrey"><input name="adminpass" type="password" class="box_longtext" id="adminpass" tabindex="1"  value="" size="32" maxlength="32"></td>
				            	</tr>
				            	<tr>
				              	<td class="bgblue"><span id="confirm_pwd_1" name="confirm_pwd_1"></span>: </td>
				              	<td class="bggrey"><input name="adminpass2" type="password" class="box_longtext" id="adminpass2" tabindex="2" value="" size="32" maxlength="32"></td>
				            	</tr>
				            </table>
				            <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
						      		<tr>
						      			<td class="bggrey2">
						      				<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send('addadm');">
        									<input name="languageidx" type="hidden" value="">
		    									<input class="ButtonSmall" type="button" id="Button2" name="Button2" value="" onClick="if(confirm(popup_msg[popup_msg_8]+'?')){document.location='smartwizard.cgi?cancel=1&language=<%getCgiLanguage();%>';}">
		    								</td>
		    							</tr>
		    						</table>
									<br>
						  		</form>
				        </td>
				      </tr>
				    </table>
					</td>
				</tr>
			</table>
		</td>
  	<td width="21" background="images/bg1_r.gif"></td>
  </tr>
  <tr>
    <td><img src="images/c1_bl.gif" width="21"></td>
    <td align="right" background="images/bg1_b.gif"><img src="images/copyright.gif" width="264"></td>
    <td><img src="images/c1_br.gif" width="21"></td>
	</tr>
</table>
</body>
</html>