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
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();
	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var sendSubmit  = false;

	document.title = get_words('TEXT000');
	
	var mainObj = new ccpObject();
	var param = {
			url: "get_set.ccp",
			arg: "ccp_act=get&num_inst=1"+
				 "&oid_1=IGD_LANDevice_i_MediaServerDLNA_&inst_1=1110"
	};

	mainObj.get_config_obj(param);

	var obj_ser_enable = mainObj.config_val("igdDLNA_Enable_");
	var obj_ser_name = mainObj.config_val("igdDLNA_Name_");

	function onPageLoad()
	{
		set_checked(obj_ser_enable, get_by_id("dlna_enable"));
		$('#media_ser_name').val(obj_ser_name);
		disable_dlna();
	}

	function disable_dlna()
	{
		var ser_enable = $("#dlna_enable").attr("checked")?1 : 0;
		$('#media_ser_name').attr('disabled',(ser_enable == 0 ? true:''));
	}
	
	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		var dlna_st = ($('#dlna_enable').attr('checked')? 1: 0);
		var submitObj = new ccpObject();
		var param = {
			'url':	'get_set.ccp',
			'arg':	'ccp_act=set'
		};

		if (dlna_st == 1)
		{
			if (media_server_chk($('#media_ser_name').val()))
				param.arg += '&igdDLNA_Name_1.1.1.0='+urlencode($('#media_ser_name').val());
			else
			{
				alert(get_words('dlna_02')+' "'+ $('#media_ser_name').val() +'" '+get_words('mydlink_pop_04'));
				return false;
			}
		}

		param.arg += '&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=media_server.asp';
		param.arg += '&igdDLNA_Enable_1.1.1.0=' + dlna_st;

		submitObj.get_config_obj(param);
	}
</script>
</head>

<body >
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b1');</script>
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b5');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1">
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('dlna_t')</script></h1>
				<p><script>show_words('dlna_t1')</script></p>
				<p><script>show_words('dlna_t2')</script></p>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'media_server.asp');">
				<script>$('#button').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
			</div>
					
			<div class="box">
				<h2><script>show_words('dlna_t')</script></h2>
				<table cellpadding="1" cellspacing="1" border="0" width="525">
				<tr>
					<td class="duple">
						<script>show_words('dlna_01')</script> :
					</td>
					<td width="210">&nbsp;
						<input name="dlna_enable" id="dlna_enable" type=checkbox value="1" onClick="disable_dlna()">
					</td>
				</tr>

				<tr>
					<td class="duple">
					<script>show_words('dlna_02')</script> :
					</td>
					<td width="210">&nbsp;
						<input name="media_ser_name" type="text" id="media_ser_name" size="30" maxlength="128" value=''>
					</td>
				</tr>
				</table>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>
		</form>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p><a href="support_internet.asp#MiniDLNA">
			<script>show_words('_more')</script>&hellip;</a></p>
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
<script>
	onPageLoad();
	set_form_default_values("form1");
</script>
</html>