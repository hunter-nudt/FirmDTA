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
<script language="javascript" type="text/javascript">
function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));
}

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("location",item_name[_LOCATION]);
	setContent("rebooting",item_name[_REBOOTING]);
	setContent("reboot_msg",sw_msg[sw_msg_33]);
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
								<td align="right" valign="top"><b><font color="#FFFFFF"><span id="location" name="location"></span>: <span class="t12">
								<% getLocation(); %>&nbsp;&nbsp;&nbsp; </span></font><font color="#FFFFFF"><span class="style1">
								<span id="datebar"><% getDate(); %> <%getTime(); %></span>
								&nbsp; </span>&nbsp; </font></b></td>
							</tr>
						</table>
					</td>
			    </tr>
			  </table>
			  <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
				<tr>
					<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="rebooting" name="rebooting"></span></font></b></td>
				</tr>
				<tr>
					<td width="100%" align="center" valign="top">
						<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
						  <tr>
					          <td height="300" align="center" class="bggrey" style="font-size:20px"><span id="reboot_msg" name="reboot_msg"></span></td>  
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

