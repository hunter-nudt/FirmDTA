<html>
<head>
<title></title>
<script>
	var funcWinOpen = window.open;
</script>
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

	var mainObj = new ccpObject();
	var param = {
			url: "get_set.ccp",
			arg: "ccp_act=get&num_inst=2"+
			"&oid_1=IGD_&inst_1=1000"+
			"&oid_2=IGD_MyDLink_&inst_2=1100"
	};

	mainObj.get_config_obj(param);

	var submit_button_flag = 0;
	var isReg = (mainObj.config_val("igd_Register_st_")? mainObj.config_val("igd_Register_st_"):"");
	var mdl_acc = mainObj.config_val("igdMyDLink_EmailAccount_");

	function onPageLoad()
	{
		$('#mdl_st').html( (isReg == 1 ? get_words('mydlink_reg'):get_words('mydlink_nonreg')));
		$('#mdl_acc').html( (isReg == 1 ? mdl_acc:get_words('wwl_NONE')));
		isReg == 1 ? $('#myaccount').show() : $('#myaccount').hide();
		$('#register_MDL').attr('disabled',(isReg == 1 ? true:''));

		var login_who= login_Info;
		if(login_who!= "w")
			DisableEnableForm(form1,true);
	}

	function wopen()
	{
		var time=new Date().getTime();
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	"mdl_check.ccp",
			data: 	"act=getpass"+"&"+time+"="+time,
			success: function(data) {
			if (data.indexOf('0') != -1)
			{
				alert(get_words('mydlink_tx04'));
				location.replace('tools_admin.asp');
				//alert(get_words('mydlink_pop_07'));
			}
			else
				location.replace('wizard_mydlink.asp');
			}
		};

		try {
			//setTimeout(function() {
				$.ajax(ajax_param);
			//}, 0);
		} catch (e) {
		}	
	}
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b7');</script>
		</td>
		<!-- end of left menu -->

		<form id='form1'>
		<td valign="top" id="maincontent_container">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
		<div id="maincontent">
			<div id="box_header">
				<h1><script>show_words('mydlink_S01')</script> </h1>
				<p><script>show_words('mydlink_S02')</script></p>
			</div>
			<div class="box">
				<h2><script>show_words('mydlink_S03')</script></h2>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td class="duple">
					<script>show_words('mydlink_srv')</script> :</td>
					<td width="340">&nbsp;
						<span id='mdl_st'><span>
					</td>
				</tr>				
				<tr id="myaccount" style="display:none">
					<td class="duple">
					<script>show_words('mydlink_acc')</script> :</td>
					<td width="340">&nbsp;
						<span id='mdl_acc'><span>
					</td>
				</tr>
				</table>
			</div>
			<div class="box">
				<h2><script>show_words('mydlink_S04')</script></h2>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td class="duple">
					<td width="340">&nbsp;
						<input type="button" name="register_MDL" id="register_MDL" value=""onclick=wopen();></td>
						<script>$('#register_MDL').val(get_words('mydlink_S04'));</script>
					</td>
				</tr>
				</table>
			</div>
		</div>
		</td>
	</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong><b><strong>
			<script>show_words('_hints')</script>
			</strong></b>&hellip;</strong>
			<p class="more"><a href="support_internet.asp#MyDLink">
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
</script>
</html>