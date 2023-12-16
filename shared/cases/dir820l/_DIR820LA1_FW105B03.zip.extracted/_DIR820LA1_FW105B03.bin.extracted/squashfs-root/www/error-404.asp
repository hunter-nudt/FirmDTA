<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<script>
	//Jerry, redirect to doc root
	{
		var loc = window.location.pathname;
		var arr = loc.split('/');
		try {
			if (arr.length > 2) //more than one directory
			{
				location.replace('/error-404.asp');
			}
		} catch (e) {
		}
	}
</script>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="uk.js"></script>
<script type="text/javascript" src="js/xml.js"></script>
<script type="text/javascript" src="js/object.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript" src="js/public_msg.js"></script>
<script type="text/javascript" src="js/pandoraBox.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();
	var lan_ip = dev_info.lanIP;
</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table id="___01" width="836" bgcolor="#FFFFFF" height="551" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height="14" colspan="3" bgcolor="#E6E6E6">&nbsp;</td>
	</tr>
	<tr>
		<td width="23" height="537" rowspan="2" bgcolor="#E6E6E6">&nbsp;</td>
		<td>
			<table id="___" width="786" height="539" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td rowspan="10" width="78">&nbsp;</td>
				<td height="35" colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td width="120"><strong>
					<font face="Arial, Helvetica, sans-serif">
					<font color="#66CCFF" size="6">
					<script>show_words('OOPS')</script>
					</font></font></strong>
				</td>
				<td height="45" colspan="6">&nbsp;</td>
			</tr>
			<tr>
				<td height="13" colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td height="35" colspan="7">
			<!--	<font color="#808080" size="6">	-->
					<font color="#999999" size="6" face="Arial, Helvetica, sans-serif">
						<script>show_words('err404_title')</script>
					</font>
				</td>
			</tr>
			<tr>
				<td height="38" colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5">
				<script>
					document.write('<img src="651.jpg" width="606" height="128" alt="" style="cursor:pointer" onclick="location.replace(\''+ 'http://'+lan_ip+'\');">');
				</script>
				</td>
				<td height="128" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td height="13" colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5">
				<p><font color="#999999" size="2" face="Verdana, Arial, Helvetica, sans-serif"><script>show_words('err404_sug')</script></font></p>
				<font color="#999999" size="2">
				<ol style="font-family:Verdana, Arial, Helvetica, sans-serif">

					<li><script>show_words('err404_sug1')</script></li>
					<li><script>show_words('err404_sug2')</script>
						<a id="link_w" href="" target=''>
							<script>$('a#link_w').attr('href', "http://"+lan_ip);
									show_words('err404_sug3')</script>
						</a>
						<script>show_words('err404_sug4')</script></li>
					<li><script>show_words('err404_sug5')</script></li>

				</ol></font></td>
				<td height="86" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td height="48" colspan="3">&nbsp;</td>
				<td colspan="3" rowspan="2">
					<script>document.write('<img src="652_16.jpg" width="229" height="75" alt="">');</script>
				</td>
			<td width="46" height="75" rowspan="2">&nbsp;</td>
			</tr>
			<tr> 
				<td height="2" colspan="2">&nbsp;</td>
				<td width="305" height="2"><font face="Arial, Helvetica, sans-serif" size="1"><a href="http://www.dlink.com"><script>show_words('_copyright');</script></a></font></td>
			</tr>
			</table>
		</td>
			<td width="27" height="537" rowspan="2" bgcolor="#E6E6E6">&nbsp;</td>
		</tr>
		<tr>
			<td width="782" height="32" bgcolor="#E6E6E6">&nbsp;</td>
		</tr>
	</table>
</body>
</html>