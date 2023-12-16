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
<script type="text/javascript" src="js/public_ipv6.js"></script>
<script type="text/javascript" src="js/pandoraBox.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	var miscObj = new ccpObject();
	var dev_info = miscObj.get_router_info();

	var hw_version 	= dev_info.hw_ver;
	var version 	= dev_info.fw_ver;
	var model		= dev_info.model;
	var login_Info 	= dev_info.login_info;
	var cli_mac 	= dev_info.cli_mac;
	document.title = get_words('TEXT000');

	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: ""
	};
	param.arg = "ccp_act=get&num_inst=2";
	param.arg +="&oid_1=IGD_LANDevice_i_ULA_&inst_1=1110";
	param.arg +="&oid_2=IGD_WANDevice_i_IPv6Status_&inst_2=1110";
	mainObj.get_config_obj(param);

	var enable_ula = mainObj.config_val("igdULASetup_ULAEnable_");
	var defulaprefix = mainObj.config_val("igdULASetup_DefaultULAPrefix_");
	var lan_ula_addr = filter_ipv6_addr(mainObj.config_val("igdIPv6Status_IPv6LanULAAddress_"));
	var currect_ulaprefix = mainObj.config_val("igdIPv6Status_IPv6ULACurrPrefix_");
	var ulaprefix =mainObj.config_val("igdULASetup_ULAPrefix_");
	var def_ulaprefix =  mainObj.config_val("igdIPv6Status_IPv6ULADefPrefix_");
	var submit_button_flag = 0;

    function onPageLoad()
	{
    	set_checked(enable_ula, $('#ulaEnable')[0]);
		set_checked(defulaprefix, $('#usedefault')[0]);
		default_ula();
		disable_ula();
		$('#ula_prefix').val(ulaprefix);
		if(enable_ula == 1)
		{
			$('#currect_ula_prefix').html(currect_ulaprefix.toUpperCase()+" /64");
	        $('#current_ula_lan').html(lan_ula_addr.toUpperCase()+" /64");
	    }else
	    {
	      	$('#currect_ula_prefix').html("");
	        $('#current_ula_lan').html("");
	    }
		if(defulaprefix == 1)
			$('#ula_prefix').val(def_ulaprefix);
    }

	function disable_ula()
	{
		if($('#ulaEnable')[0].checked){
			$('#usedefault').attr('disabled','');
			if($('#usedefault')[0].checked)
				$('#ula_prefix').attr('disabled',true);
			else
				$('#ula_prefix').attr('disabled','');
		}else{
			$('#usedefault').attr('disabled',true);
			$('#ula_prefix').attr('disabled',true);
		}
	}

	function default_ula()
	{
		if($('#usedefault')[0].checked){
			$('#ula_prefix').val(def_ulaprefix);
			$('#ula_prefix').attr('disabled',true);
		}else{
			$('#ula_prefix').val(ulaprefix);
			$('#ula_prefix').attr('disabled','');
		}
	}

	function send_request()
	{
		var ula_prefix = $('#ula_prefix').val();
		var ipv6_static_msg = replace_msg(all_ipv6_addr_msg,"ULA Prefix");
		var temp_ula_prefix = new ipv6_addr_obj(ula_prefix.split(":"), ipv6_static_msg, false, false);
		var colon_count = ula_prefix.split(":");
 
		if($('#ula_prefix').val() == "" && $('#ulaEnable')[0].checked){
			if(!confirm(get_words('MSG048')+"\n("+def_ulaprefix+"/64)"))
				return false;
			else
				$('#ula_prefix').val(def_ulaprefix);

		}else if($('#ulaEnable')[0].checked){
			if(check_ipv6_symbol(ula_prefix,"::") == 2){ // find two '::' symbol
				return false;
			}else if(check_ipv6_symbol(ula_prefix,"::") == 1){    // find one '::' symbol
				if(ula_prefix.substr(0,1) != "f" && ula_prefix.substr(0,1) != "F"){
					alert(get_words('MSG047'));
					return false;
				}
				if(ula_prefix.substr(1,1) != "d" && ula_prefix.substr(1,1) != "D" && 
				   ula_prefix.substr(1,1) != "c" && ula_prefix.substr(1,1) != "C"){
						alert(get_words('MSG047'));
					return false;
				}
				if(ula_prefix.substr(2,1) == ":" || ula_prefix.substr(3,1) == ":"){ 
					alert(get_words('MSG047'));
					return false;
				}
				if(colon_count.length > 6){
						alert(get_words('MSG047'));
					return false;
				}
				temp_ula_prefix = new ipv6_addr_obj(ula_prefix.split("::"), ipv6_static_msg, false, false);
				if(temp_ula_prefix.addr[temp_ula_prefix.addr.length-1].length != 0){
						alert(get_words('MSG047'));
					return false;
				}
				else
					temp_ula_prefix.addr[temp_ula_prefix.addr.length-1] = "1111";
				if (!check_ipv6_address(temp_ula_prefix,"::"))
					return false;
			}else{  //not find '::' symbol
				alert(get_words('MSG047'));
				return false;
			}
		}

		if (submit_button_flag == 0)
		{
			submit_button_flag = 1;
			submitula();
			return true;
        }
        return false;
    }

	function submitula()
	{
		var submitObj = new ccpObject();
		var param1 = {
			url: "get_set.ccp",
			arg: 'ccp_act=set&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=ipv6_ula.asp'
		};
		param1.arg += "&igdULASetup_ULAEnable_1.1.1.0="+get_checked_value($('#ulaEnable')[0]);
		param1.arg += "&igdULASetup_DefaultULAPrefix_1.1.1.0="+get_checked_value($('#usedefault')[0]);
		param1.arg += "&igdULASetup_ULAPrefix_1.1.1.0="+$('#ula_prefix').val();				
		submitObj.get_config_obj(param1);
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
		<script>ajax_load_page('menu_left_setup.asp', 'menu_left', 'left_b6');</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
			<h1><script>show_words('IPV6_ULA_TEXT14')</script></h1>
			<script>show_words('IPV6_ULA_TEXT11')</script><br>
			<br>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'ipv6_link_local.asp');">
				<script>$('#button').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
			</div>
			<div class=box>
				<h2 style=" text-transform:none">
				<script>show_words('IPV6_ULA_TEXT01')</script></h2>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td width="185" align=right class="duple">
						<script>show_words('IPV6_ULA_TEXT02')</script>
					:</td>
					<td width="333" colSpan=3>&nbsp;&nbsp;
						<input name="ulaEnable" type=checkbox id="ulaEnable" value="1" onClick="disable_ula();">
						<input type="hidden" id="ula_enable" name="ula_enable" value="">
					</td>
				</tr>
				<tr>
					<td width="185" align=right class="duple">
						<script>show_words('IPV6_ULA_TEXT03')</script>
					:</td>
					<td width="333" colSpan=3>&nbsp;&nbsp;
						<input name="usedefault" id="usedefault" type="checkbox" value="1" onClick="default_ula();">
						<input type="hidden" id="use_default" name="use_default" value="">
					</td>
				</tr>
				<tr>
					<td width="185" align=right class="duple">
						<script>show_words('IPV6_ULA_TEXT04')</script>
					:</td>
					<td width="333" colSpan=3>&nbsp;&nbsp;
						<input type=text id="ula_prefix" name="ula_prefix" size="25" maxlength="40" value="">
					<b>/64</b>
					</td>
				</tr>
				</table>
			</div>
			<div class=box >
				<h2 style=" text-transform:none"><script>show_words('IPV6_ULA_TEXT05')</script></h2>
				<table cellSpacing=1 cellPadding=1 width=525 border=0>
				<tr>
					<td width="206" align=right class="duple"><script>show_words('IPV6_ULA_TEXT06')</script> :</td>
					<td width="331">&nbsp;&nbsp;<b><span id="currect_ula_prefix" name="currect_ula_prefix"></span></b></td>
				</tr>
				<tr>
					<td width="206" align=right class="duple"><script>show_words('IPV6_ULA_TEXT07')</script> :</td>
					<td width="331">&nbsp;&nbsp;<b><span id="current_ula_lan" name="current_ula_lan"></span></b></td>
				</tr>
				</table>
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
			<p><script>show_words('IPV6_ULA_TEXT13')</script></p>
			<p><script>show_words('LW34')</script></p>
			<p class="more"><a href="support_internet.asp#ipv6_ULA">
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