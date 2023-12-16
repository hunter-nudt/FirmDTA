<html>
<head>
<style type="text/css">
m_color {
	color: #FF0000;
	font-size: 14px;
}
</style>
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
	document.title = get_words('TEXT000');
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	
	function SETOBJ()
	{
		var testObj = new ccpObject();
		var paramSubmit = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=test_page.asp'
		};
		paramSubmit.arg += $("#txt").val();
		testObj.get_config_obj_test(paramSubmit);
	}
	
	function GETOBJ()
	{
		var testObj = new ccpObject();
		var param = {
			url: 	"get_set.ccp",
			arg: 	"ccp_act=get&num_inst="
		};
		
		param.arg += $("#txt").val();
		testObj.get_config_obj_test(param);
		//var x = gConfig.documentElement;
		//alert(gConfig);
		$('#get_val').val(testObj.gConfig);
	}
	
	$(document).ready(function() {  
		var mainObj = new ccpObject();
		var param = {
			url: "get_set.ccp",
			arg: ""
		};
		param.arg = "ccp_act=get&num_inst=1";
		param.arg +="&oid_1=IGD_&inst_1=1000";
		mainObj.get_config_obj(param);
	});
</script>
</head>

<body>
<center>
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<!-- product info -->
		<table id="header_container">
		<tr>
			<td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"><script>document.write(model);</script></a></td>
			<td width="60%">&nbsp;</td>
			<td align="right" nowrap><script>show_words('TA3')</script>: <script>document.write(hw_version);</script> &nbsp;</td>
			<td align="right" nowrap><script>show_words('sd_FWV')</script>: <script>document.write(version);</script></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</table>
		<!-- end of product info -->

		<!-- banner -->
		<div id="header_banner"></div>
		<!-- end of banner -->
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="topnav_container" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<!-- left menu -->
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr height="28">
					<td width="5%"></td>
					<td width="20%" align="center"><b>OID, INST :&nbsp;</b></td>
                    <td width="75%"><textarea name="txt" id="txt" cols="80" rows="9"></textarea></td>
				</tr>
				<tr height="28">
					<td colspan=3 align="center">
						<input class="button_submit_padleft" type="button" name="set_b" id="set_b" value="" style="width:60 " onclick="SETOBJ()">
						<input class="button_submit_padleft" type="button" name="get_b" id="get_b" value="" style="width:60 " onclick="GETOBJ()">
						<script>$('#set_b').val("SET OBJ");</script>
						<script>$('#get_b').val("GET OBJ");</script>
					</td>
				</tr>
				<tr>
					<td colspan=3 align="left">
						EX: Get obj:<br>
						<m_color>3</m_color>&oid_<m_color>1</m_color>=IGD_WANDevice_i_VirServRule_i_&inst_<m_color>1</m_color>=1100&oid_<m_color>2</m_color>=IGD_ScheduleRule_i_&inst_<m_color>2</m_color>=1000&oid_<m_color>3</m_color>=IGD_&inst_<m_color>3</m_color>=1000<br><br>
						EX: Set obj:<br>
						&vsRule_InternalIPAddr_1.1.1.0=192.168.0.123<br>
						&vsRule_VirtualServerName_1.1.1.0=testtt<br>
						&vsRule_PublicPort_1.1.1.0=100
					</td>
				</tr>
				<tr>
					<td colspan=3 align="center">
						<textarea name="get_val" id="get_val" cols="100" rows="10"></textarea>
					</td>
				</tr>
             </table>
			</div>
		</div>
		</td>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>
        </form>
	</tr>
	</table>
	<!-- end of main content -->

	<!-- footer -->
	<table class="MainTable" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" valign="baseline" bgcolor="#FFFFFF">
		<table id="footer_container">
		<tr>
			<td width="100%" align="left">&nbsp;<img src="image/wireless_tail.gif"></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</table>
		</td>
	</tr>
	</table>
	<br>
	<div id="copyright"><script>show_words('_copyright');</script></div>
	<!-- end of footer -->
</center>
</body>
</html>
