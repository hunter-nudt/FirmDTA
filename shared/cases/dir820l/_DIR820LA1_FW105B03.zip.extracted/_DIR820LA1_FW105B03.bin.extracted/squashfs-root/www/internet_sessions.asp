<html>
<head>
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
	document.title = get_words('TEXT000');
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;

	var DataArray = new Array();

	var queryObj = new ccpObject();
	var param = {
		url: "session.ccp",
		arg: "ccp_act=querySession"
	};
	queryObj.get_config_obj(param);
	var content_str = queryObj.config_val("session_content");

	//20120203 silvia add to chk addr range
	var addrrangeObj = new ccpObject();
	var paramHost={
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=1'+
				'&oid_1=IGD_LANDevice_i_LANHostConfigManagement_&inst_1=1110'
	};
	addrrangeObj.get_config_obj(paramHost);

	var startaddr = addrrangeObj.config_val('lanHostCfg_MinAddress_');
	var endaddr = addrrangeObj.config_val('lanHostCfg_MaxAddress_');
	
	function set_session_Data(src_proto, timeout, state, direction, local_ip, local_port, remote_ip, remote_port, public_port, priority, onList) 
	{
		this.Proto = src_proto;
		this.Timeout = timeout;
		this.State = state;
		this.Dir = direction;
		this.Local_IP = local_ip;
		this.Local_port = local_port;
		this.Remote_IP = remote_ip;
		this.Remote_Port = remote_port;
		this.Public_port = public_port;
		this.Priority = priority;
		this.OnList = onList ;
	}

	function copy_session_Data(localInfo, internetInfo, proto, direction, status, expire, nat) 
	{
		this.local = localInfo;
		this.internet = internetInfo;
		this.proto = proto;
		this.Dir = direction;
		this.status = status;
		this.expire = expire;
		this.nat = nat
	}

	function set_session_table(){
		var index = 0;
		var detail_index = 0;
		for (var i = 0; i < localIPPort.length; i++)
		{
			if ( localIPPort[i] <= endaddr && localIPPort[i] >= startaddr)
			{
				DataArray[DataArray.length++] = new copy_session_Data(localIPPort[i], IntrenetIPPort[i], sessionProto[i],
												sessionDirection[i], sessionStatus[i], sessionExpire[i], sessionNAT[i]);
				detail_index++;
			}
		}
	}

	function session_list(){
		if(content_str.length > 0)
			document.write(content_str);
	}
</script>
<meta http-equiv=Content-Type content="text/html; charset=UTF8">
<style type="text/css">
<!--
.style4 {
	font-size: 11px;
	font-weight: bold;
}
-->
</style>
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

		<!-- top menu -->
		<div id="menu_top"></div>
		<script>$(document).ready(function($){ajax_load_page('menu_top.asp', 'menu_top', 'top_b4');});</script>
		<!-- end of top menu -->
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="topnav_container" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<!-- left menu -->
		<td id="sidenav_container" valign="top">
		<div id="menu_left"></div>
		<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b4');});</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<form id="form1" name="form1" method="post">
			<input type="hidden" id="internet_session_table" name="internet_session_table" value="">
			<div id="maincontent">
				<div id="box_header"> 
					<h1><script>show_words('YM157')</script></h1>
					<p><script>show_words('sa_intro')</script></p>
				</div>
				<div class="box"> 
					<h2><script>show_words('YM157')</script></h2>
					<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
						<tr id="box_header">
							<TD><b><script>show_words('sa_Local')</script></b></TD>
							<TD><b><script>show_words('sa_NAT')</script></b></TD>
							<TD><b><script>show_words('sa_Internet')</script></b></TD>
							<TD><b><script>show_words('_protocol')</script></b></TD>
							<TD><b><script>show_words('sa_State')</script></b></TD>
							<TD><b><script>show_words('sa_Dir')</script></b></TD>
							<TD><b><script>show_words('sa_TimeOut')</script></b></TD>
						</tr>
						<script>session_list();</script>
					</table>
				</div>
            </div>
			</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text>
			<strong>
				<script>show_words('_hints')</script>&hellip;
			</strong> 
			<p>
				<script>show_words('hhsa_intro')</script></p>
			<p>
				<a href="support_status.asp#Internet_Sessions" onclick="return jump_if();">
					<script>show_words('_more')</script>&hellip;
				</a>
			</p>
		</div>
		</td>
		<!-- end of user tips -->
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