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
	
	/* get time information */
	var infoObj = new ccpObject();
	var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=1'+
				'&oid_1=IGD_Time_&inst_1=1100'
	};
	infoObj.get_config_obj(param);

	
	var objTime = {
		'enable':			infoObj.config_val('sysTime_NTPEnable_'),
		'ntpServ1':			infoObj.config_val('sysTime_NTPServer1_'),
		'ntpServ2':			infoObj.config_val('sysTime_NTPServer2_'),
		'ntpServ3':			infoObj.config_val('sysTime_NTPServer3_'),
		'curLocTime':		infoObj.config_val('sysTime_CurrentLocalTime_'),
		'curLocTimeStr':	infoObj.config_val('sysTime_CurrentLocalTimeStr_'),
		'locTimeZone':		infoObj.config_val('sysTime_LocalTimeZone_'),
		'dlSavUsed':		infoObj.config_val('sysTime_DaylightSavingsUsed_'),
		'locTimeZoneIdx':	infoObj.config_val('sysTime_LocalTimeZoneIndex_'),
		'dlSavMStart':		infoObj.config_val('sysTime_DaylightSavingMStart_'),
		'dlSavWStart':		infoObj.config_val('sysTime_DaylightSavingWStart_'),
		'dlSavDStart':		infoObj.config_val('sysTime_DaylightSavingDStart_'),
		'dlSavTStart':		infoObj.config_val('sysTime_DaylightSavingTStart_'),
		'dlSavMEnd':		infoObj.config_val('sysTime_DaylightSavingMEnd_'),
		'dlSavWEnd':		infoObj.config_val('sysTime_DaylightSavingWEnd_'),
		'dlSavDEnd':		infoObj.config_val('sysTime_DaylightSavingDEnd_'),
		'dlSavTEnd':		infoObj.config_val('sysTime_DaylightSavingTEnd_')
	};
	
	
	$(document).ready( function () {
		if(dev_info.login_info != "w"){
			DisableEnableForm(form1,true);	
			DisableEnableForm(form2,true);	
		}else{
			disable_daylight();
			show_time();
		}
		
		(objTime.enable == '1') ? $('#ntp_enable').attr('checked', 'checked'): $('#ntp_enable').attr('checked', '');
		$('#ntp_server').val(objTime.ntpServ1);
		$('#time_zone').attr('selectedIndex', objTime.locTimeZoneIdx);
		(objTime.dlSavUsed == '1') ? $('#daylight_enable').attr('checked', 'checked'): $('#daylight_enable').attr('checked', '');
		$('#m_start').val(objTime.dlSavMStart);
		$('#s_start').val(objTime.dlSavWStart);
		$('#w_start').val(objTime.dlSavDStart);
		$('#t_start').val(objTime.dlSavTStart);
		$('#m_end').val(objTime.dlSavMEnd);
		$('#s_end').val(objTime.dlSavWEnd);
		$('#w_end').val(objTime.dlSavDEnd);
		$('#t_end').val(objTime.dlSavTEnd);
		
		//var dat = objTime.curLocTimeStr.split(',');	
		var datetime= new Date();
		var curLocalTime = datetime.getFullYear() +"/"+ (datetime.getMonth()+1) + "/" + datetime.getDate() + "/" +
				datetime.getHours() + "/" + datetime.getMinutes() + "/" + datetime.getSeconds();
		var dat = curLocalTime.split('/');
		if (dat != null) {
			var i=0;
			set_selectIndex(dat[i++], get_by_id('year'));
			set_selectIndex(dat[i++], get_by_id('mon'));
			selectDate();
			set_selectIndex(dat[i++], get_by_id('day'));
			var hr = dat[i++];
			if (hr > 12) {
				set_selectIndex(1, get_by_id('ampm'));
				set_selectIndex((parseInt(hr)-12), get_by_id('hour'));
			} else {
				set_selectIndex(0, get_by_id('ampm'));
				set_selectIndex(hr, get_by_id('hour'));
			}
			set_selectIndex(dat[i++], get_by_id('min'));
			set_selectIndex(dat[i++], get_by_id('sec'));
		}
		var year = get_by_id("year").value;
		var mon = get_by_id("mon").value;
		var day = get_by_id("day").value;
		if(get_by_id("ampm").selectedIndex == 0)
			var hour = get_by_id("hour").value;
		else
			var hour = parseInt(get_by_id("hour").value) + 12;
		
		var minu = get_by_id("min").value;
		var sec = get_by_id("sec").value;
		
		show_time();
		get_time();
		STime();
		set_time();
		disable_daylight();
		set_form_default_values("form1");
		
		/* query time again, due to avoid the late setup time caused by time server  */
		setTimeout(query_current_time, 3000);
	});
	
	function query_current_time()
	{
		var ctObj = new ccpObject();
		var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=1'+
				'&oid_1=IGD_Time_&inst_1=1100'
		};
		ctObj.get_config_obj(param);
		
		objTime.curLocTime = ctObj.config_val('sysTime_CurrentLocalTime_');
		get_time();
	}
	
	var submit_button_flag = 0;
	
	function selectDate(){
		var year = get_by_id("year").value;
		//if (isFourDigitYear(year)){
			var mon = get_by_id("mon").selectedIndex;
			mon = parseInt(mon);
			year = parseInt(year);
			var days = getDaysInMonth(mon+1, year);
			for (var i = 0; i < days; i++){
				get_by_id("day").options[i] = new Option(i+1, i+1);
				get_by_id("day").length=days;
			}
		//}
	}

	function show_time(){
		var time_type = get_by_id("ntp_enable");
		
		//get_by_id("manual_sync").disabled = time_type.checked;
		get_by_id("ntp_server").disabled = !time_type.checked;
		get_by_id("ntp_server_list").disabled = !time_type.checked;
		get_by_id("year").disabled = time_type.checked;
		get_by_id("mon").disabled = time_type.checked;
		get_by_id("day").disabled = time_type.checked;
		get_by_id("hour").disabled = time_type.checked;
		get_by_id("min").disabled = time_type.checked;
		get_by_id("sec").disabled = time_type.checked;
		get_by_id("ampm").disabled = time_type.checked;
		get_by_id("clone").disabled = time_type.checked;
	}

	function disable_daylight(){
		var daylight_enable = get_by_id("daylight_enable");
		
		//get_by_id("offset").disabled = !daylight_enable.checked;
		get_by_id("m_start").disabled = !daylight_enable.checked;
		get_by_id("w_start").disabled = !daylight_enable.checked;
		get_by_id("s_start").disabled = !daylight_enable.checked;
		get_by_id("t_start").disabled = !daylight_enable.checked;
		get_by_id("m_end").disabled = !daylight_enable.checked;
		get_by_id("w_end").disabled = !daylight_enable.checked;
		get_by_id("s_end").disabled = !daylight_enable.checked;
		get_by_id("t_end").disabled = !daylight_enable.checked;
	}	
	function set_month_list(){
		for(var i = 0; i < month.length; i++){
			document.write("<option value=" + (i+1) + " >" + month[i] + "</option>");
		}
	}

	function set_week_list(){
		for(var i = 0; i < Week.length; i++){
			document.write("<option value=" + (i+1) + " >" + Week[i] + "</option>");
		}
	}

	function set_seq_list(){
		for(var i = 0; i < sequence.length; i++){
			document.write("<option value=" + (i+1) + " >" + sequence[i] + "</option>");
		}
	}
	
	function do_submit(dat)
	{
		var submitObj = new ccpObject();
		var param = {
			'url':	'get_set.ccp',
			'arg':	'ccp_act=set'
		};
		
		param.arg += '&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=tools_time.asp'+
					'&sysTime_NTPEnable_1.1.0.0='+($('#ntp_enable').attr('checked')? '1': '0')+
					'&sysTime_NTPServer1_1.1.0.0='+$('#ntp_server').val()+
					'&sysTime_CurrentLocalTimeStr_1.1.0.0='+dat+
					'&sysTime_LocalTimeZone_1.1.0.0='+$('#time_zone').val()+
					'&sysTime_DaylightSavingsUsed_1.1.0.0='+($('#daylight_enable').attr('checked')? '1': '0')+
					'&sysTime_LocalTimeZoneIndex_1.1.0.0='+$('#time_zone').attr('selectedIndex')+
					'&sysTime_DaylightSavingMStart_1.1.0.0='+$('#m_start').val()+
					'&sysTime_DaylightSavingWStart_1.1.0.0='+$('#s_start').val()+
					'&sysTime_DaylightSavingDStart_1.1.0.0='+$('#w_start').val()+
					'&sysTime_DaylightSavingTStart_1.1.0.0='+$('#t_start').val()+
					'&sysTime_DaylightSavingMEnd_1.1.0.0='+$('#m_end').val()+
					'&sysTime_DaylightSavingWEnd_1.1.0.0='+$('#s_end').val()+
					'&sysTime_DaylightSavingDEnd_1.1.0.0='+$('#w_end').val()+
					'&sysTime_DaylightSavingTEnd_1.1.0.0='+$('#t_end').val();
		submitObj.get_config_obj(param);
	}
	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange')))
			return false;

		var time_type = get_by_id("ntp_enable");
		var dat = '';
		var year = get_by_id("year").value;
		var mon = get_by_id("mon").value;
		var day = get_by_id("day").value;
		if(get_by_id("ampm").selectedIndex == 0)
			var hour = get_by_id("hour").value;
		else
			var hour = parseInt(get_by_id("hour").value) + 12;
		
		var minu = get_by_id("min").value;
		var sec = get_by_id("sec").value;
		
		dat = year +","+ mon +","+ day +","+ hour +","+ minu +","+ sec;

		if(time_type.checked && get_by_id("ntp_server").value == ""){
			alert(get_words('YM185'));
			return false;
		}

		if(submit_button_flag == 0){
			submit_button_flag = 1;
			do_submit(dat);
			return true;
		}else{
			return false;
		}
	}
	
	function set_time(){
		var date = new Date();
		var year = date.getFullYear();
		var mon = date.getMonth();
	
		mon = parseInt(mon);
		year = parseInt(year);
		var days = getDaysInMonth(mon+1, year);
		for(var i = 0 ; i < days; i++){
			get_by_id("day").options[i] = new Option(i+1, i+1);
			get_by_id("day").length = days;
		}
		set_selectIndex(date.getFullYear(), get_by_id("year"));
		get_by_id("mon").selectedIndex = date.getMonth();
		get_by_id("day").selectedIndex = date.getDate() - 1;

		if(parseInt(date.getHours()) > 11){
			get_by_id("hour").value = parseInt(date.getHours()) - 12;
			set_selectIndex(1, get_by_id("ampm"));
		}else{
			get_by_id("hour").value = date.getHours();
			set_selectIndex(0, get_by_id("ampm"));
		}
		
		//get_by_id("hour").selectedIndex = date.getHours(); 
		get_by_id("min").selectedIndex = date.getMinutes(); 
		get_by_id("sec").selectedIndex = date.getSeconds();
	}

	var nNow, gTime;
	function get_time()
	{
		if (gTime)
			return;

		gTime = objTime.curLocTime;
		var time = gTime.split(",");
		gTime = month_device[time[1]-1] + " " + time[2] + ", " + time[0] + " " + time[3] + ":" + time[4] + ":" + time[5];		
		nNow = new Date(gTime);
	}
	
	function print_year()
	{
		var str = '';
		var date = new Date();
		var year = date.getFullYear();
		/**
			20130116 Silvia add
			Linux system will not be able to extend up to 2040 for our Web GUI
			Set Max year to 2037 for now, waitting for patch becomes available
			
			var max_year = 2037;
			var min_year = ((year+10) > max_year)?(max_year-10):(year-5);
			max_year = ((year+10) > max_year)?max_year:(year+10);
			
			if (year != null && year != 0) {
				for (var i=min_year; i<=max_year; i++) {
					str += '<option value='+i+'>'+i+'</option>';
				}
			}
			
		**/
	
		var max_year = 2037;
		var min_year = 2007;
		
		if (year != null && year != 0) {
			for (var i=min_year; i<=max_year; i++) {
				str += '<option value='+i+'>'+i+'</option>';
			}
		}
		
		return document.write(str);
	}

	function STime(){
		nNow.setTime(nNow.getTime() + 1000);
		//new Date(yr_num, mo_num, day_num, hr_num, min_num, sec_num)
		//var date = new Date();
		var fulldate = ' '+change_week(nNow.getDay()) +' '+change_mon(nNow.getMonth()) +', '+nNow.getDate() +', '+nNow.getFullYear()
					+ ' ' +len_checked(nNow.getHours())+ ':' +len_checked(nNow.getMinutes())+ ':' +len_checked(nNow.getSeconds());
		$("#show_systime").html(fulldate);
		//get_by_id("show_systime").innerHTML = nNow.toLocaleString();
		setTimeout('STime()', 1000);
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
		<script>ajax_load_page('menu_top.asp', 'menu_top', 'top_b3');</script>
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
		<script>ajax_load_page('menu_left_tools.asp', 'menu_left', 'left_b2');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('_time')</script></h1>
				<p><script>show_words('tt_intro_Time')</script></p>
				<input name="button" id="button" type="button" class=button_submit value="" onClick="return send_request()">
				<input name="button2" id="button2" type=button class=button_submit value="" onclick="page_cancel('form1', 'tools_time.asp');">
				<script>$('#button').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
			</div>

			<div class=box>
				<h2><script>show_words('tt_TimeConf')</script></h2>
				<table width="525" class=formarea>
				<tr>  
					<td class="duple"><script>show_words('tt_CurTime')</script>&nbsp;:<br></td>
					<td>&nbsp;&nbsp;<span id="show_systime"></span></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('tt_TimeZ')</script> : </td>
					<td><span class="form_label">&nbsp;
						<select id="time_zone" name="time_zone" size=1 style="width:300px;">
					<option value="-192"><font face="Arial"><script>show_words('up_tz_76')</script></font></option>
					<option value="-176"><font face="Arial"><script>show_words('up_tz_77')</script></font></option>
					<option value="-160"><font face="Arial"><script>show_words('up_tz_02')</script></font></option>
					<option value="-144"><font face="Arial"><script>show_words('up_tz_03')</script></font></option>
					<option value="-128"><font face="Arial"><script>show_words('up_tz_04')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_05')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_78')</script></font></option>
					<option value="-112"><font face="Arial"><script>show_words('up_tz_06')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_07')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_08')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_79')</script></font></option>
					<option value="-96"><font face="Arial"><script>show_words('up_tz_10')</script></font></option>
					<option value="-80"><font face="Arial"><script>show_words('up_tz_80')</script></font></option>
					<option value="-80"><font face="Arial"><script>show_words('up_tz_12')</script></font></option>
					<option value="-72"><font face="Arial"><script>show_words('up_tz_81')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_82')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_14')</script></font></option>
					<option value="-64"><font face="Arial"><script>show_words('up_tz_16')</script></font></option>
					<option value="-56"><font face="Arial"><script>show_words('up_tz_17')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_18')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_83')</script></font></option>
					<option value="-48"><font face="Arial"><script>show_words('up_tz_20')</script></font></option>
					<option value="-32"><font face="Arial"><script>show_words('up_tz_21')</script></font></option>
					<option value="-16"><font face="Arial"><script>show_words('up_tz_22')</script></font></option>
					<option value="-16"><font face="Arial"><script>show_words('up_tz_23')</script></font></option>
					<option value="0"><font face="Arial"><script>show_words('up_tz_24')</script></font></option>
					<option value="0"><font face="Arial"><script>show_words('up_tz_25')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_26')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_27')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_28')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_84')</script></font></option>
					<option value="16"><font face="Arial"><script>show_words('up_tz_30')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_31')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_32')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_33')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_34')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_85')</script></font></option>
					<option value="32"><font face="Arial"><script>show_words('up_tz_36')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_37')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_38')</script></font></option>
					<option value="48"><font face="Arial"><script>show_words('up_tz_40')</script></font></option>
					<option value="56"><font face="Arial"><script>show_words('up_tz_41')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_42')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_43')</script></font></option>
					<option value="64"><font face="Arial"><script>show_words('up_tz_39')</script></font></option>
					<option value="72"><font face="Arial"><script>show_words('up_tz_44')</script></font></option>
					<option value="80"><font face="Arial"><script>show_words('up_tz_46')</script></font></option>
					<option value="88"><font face="Arial"><script>show_words('up_tz_86')</script></font></option>
					<option value="88"><font face="Arial"><script>show_words('up_tz_88')</script></font></option>
					<option value="92"><font face="Arial"><script>show_words('up_tz_48')</script></font></option>
					<option value="96"><font face="Arial"><script>show_words('up_tz_50')</script></font></option>
					<option value="96"><font face="Arial"><script>show_words('up_tz_45')</script></font></option>
					<option value="104"><font face="Arial"><script>show_words('up_tz_52')</script></font></option>
					<option value="112"><font face="Arial"><script>show_words('up_tz_87')</script></font></option>
					<option value="112"><font face="Arial"><script>show_words('up_tz_53')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_54')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_55')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_57')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_58')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_59')</script></font></option>
					<option value="128"><font face="Arial"><script>show_words('up_tz_89')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_90')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_60')</script></font></option>
					<option value="144"><font face="Arial"><script>show_words('up_tz_61')</script></font></option>
					<option value="152"><font face="Arial"><script>show_words('up_tz_63')</script></font></option>
					<option value="152"><font face="Arial"><script>show_words('up_tz_64')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_65')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_66')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_67')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_68')</script></font></option>
					<option value="160"><font face="Arial"><script>show_words('up_tz_62')</script></font></option>
					<option value="176"><font face="Arial"><script>show_words('up_tz_70')</script></font></option>
					<option value="176"><font face="Arial"><script>show_words('up_tz_69')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_75')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_71')</script></font></option>
					<option value="192"><font face="Arial"><script>show_words('up_tz_72')</script></font></option>
					<option value="208"><font face="Arial"><script>show_words('up_tz_91')</script></font></option>
					<option value="208"><font face="Arial"><script>show_words('up_tz_92')</script></font></option>
						</select>
					</span></td>
				</tr>
				<tbody>
				<tr>
					<td class="duple">
					<script>show_words('tt_dsen2')</script>&nbsp;:</td>
					<td width="340">&nbsp;
						<input name="daylight_enable" type=checkbox id="daylight_enable" value="1" onClick="disable_daylight();">
						<input type="hidden" id="time_daylight_saving_enable" name="time_daylight_saving_enable" value="">							
					</td>
				</tr>

				<tr>
					<td class="duple"><script>show_words('tt_dsdates')</script> :</td>
					<td valign="middle" width="340">
					<table>
						<tbody>
						<tr>
							<td>&nbsp;</td>
							<td><script>show_words('tt_Month')</script></td>
							<td><script>show_words('ZM21')</script></td>
							<td><script>show_words('ZM22')</script></td>
							<td><script>show_words('_time')</script></td>
						</tr>
						<tr>
							<td><script>show_words('tt_dststart')</script></td>
							<td>
								<select id="m_start" name="m_start">
									<script>set_month_list();</script>
								</select>
							</td>
							<td>
								<select id="s_start" name="s_start">
									<script>set_seq_list();</script>
								</select>
							</td>
							<td>
								<select id="w_start" name="w_start">
									<script>set_week_list();</script>
								</select>
							</td>
							<td>
								<select id="t_start" name="t_start">
									<option value="0"><script>show_words('tt_time_1')</script></option>
									<option value="1"><script>show_words('tt_time_2')</script></option>
									<option value="2"><script>show_words('tt_time_3')</script></option>
									<option value="3"><script>show_words('tt_time_4')</script></option>
									<option value="4"><script>show_words('tt_time_5')</script></option>
									<option value="5"><script>show_words('tt_time_6')</script></option>
									<option value="6"><script>show_words('tt_time_7')</script></option>
									<option value="7"><script>show_words('tt_time_8')</script></option>
									<option value="8"><script>show_words('tt_time_9')</script></option>
									<option value="9"><script>show_words('tt_time_10')</script></option>
									<option value="10"><script>show_words('tt_time_11')</script></option>
									<option value="11"><script>show_words('tt_time_12')</script></option>
									<option value="12"><script>show_words('tt_time_13')</script></option>
									<option value="13"><script>show_words('tt_time_14')</script></option>
									<option value="14"><script>show_words('tt_time_15')</script></option>
									<option value="15"><script>show_words('tt_time_16')</script></option>
									<option value="16"><script>show_words('tt_time_17')</script></option>
									<option value="17"><script>show_words('tt_time_18')</script></option>
									<option value="18"><script>show_words('tt_time_19')</script></option>
									<option value="19"><script>show_words('tt_time_20')</script></option>
									<option value="20"><script>show_words('tt_time_21')</script></option>
									<option value="21"><script>show_words('tt_time_22')</script></option>
									<option value="22"><script>show_words('tt_time_23')</script></option>
									<option value="23"><script>show_words('tt_time_24')</script></option>
								</select>
							</td>
						</tr>
						<tr>
							<td><script>show_words('tt_dstend')</script></td>
							<td>
								<select id="m_end" name="m_end">
									<script>set_month_list();</script>
								</select>
							</td>
							<td>
								<select id="s_end" name="s_end">
									<script>set_seq_list();</script>
								</select>
							</td>
							<td>
								<select id="w_end" name="w_end">
									<script>set_week_list();</script>
								</select>
							</td>
							<td>
								<select id="t_end" name="t_end">
									<option value="0"><script>show_words('tt_time_1')</script></option>
									<option value="1"><script>show_words('tt_time_2')</script></option>
									<option value="2"><script>show_words('tt_time_3')</script></option>
									<option value="3"><script>show_words('tt_time_4')</script></option>
									<option value="4"><script>show_words('tt_time_5')</script></option>
									<option value="5"><script>show_words('tt_time_6')</script></option>
									<option value="6"><script>show_words('tt_time_7')</script></option>
									<option value="7"><script>show_words('tt_time_8')</script></option>
									<option value="8"><script>show_words('tt_time_9')</script></option>
									<option value="9"><script>show_words('tt_time_10')</script></option>
									<option value="10"><script>show_words('tt_time_11')</script></option>
									<option value="11"><script>show_words('tt_time_12')</script></option>
									<option value="12"><script>show_words('tt_time_13')</script></option>
									<option value="13"><script>show_words('tt_time_14')</script></option>
									<option value="14"><script>show_words('tt_time_15')</script></option>
									<option value="15"><script>show_words('tt_time_16')</script></option>
									<option value="16"><script>show_words('tt_time_17')</script></option>
									<option value="17"><script>show_words('tt_time_18')</script></option>
									<option value="18"><script>show_words('tt_time_19')</script></option>
									<option value="19"><script>show_words('tt_time_20')</script></option>
									<option value="20"><script>show_words('tt_time_21')</script></option>
									<option value="21"><script>show_words('tt_time_22')</script></option>
									<option value="22"><script>show_words('tt_time_23')</script></option>
									<option value="23"><script>show_words('tt_time_24')</script></option>
								</select>
							</td>
						</tr>
						</tbody>
					</table>
					</td>
				</tr>
				</tbody>
				</table>
			</div>

			<div class=box> 
				<h2><script>show_words('tt_auto')</script></h2>
				<table width="525">
				<tbody>
					<tr>
						<td class="duple">
							<script>show_words('tt_EnNTP')</script> :</td>
						<td width="340">&nbsp;
							<input id="ntp_enable" name="ntp_enable" type=checkbox value="1" onClick="show_time()">
							<input type="hidden" id="ntp_client_enable" name="ntp_client_enable" value="">
						</td>
					</tr>
					<tr>
						<td class="duple">
							<script>show_words('tt_NTPSrvU')</script>&nbsp;:</td>
						<td width="340">&nbsp;&nbsp;
							<input type="text" id="ntp_server" name="ntp_server">
							&lt;&lt;
							<select id="ntp_server_list" name="ntp_server_list" onChange="key_word(this, 'ntp_server');">
								<option value=''><script>show_words('tt_SelNTPSrv')</script></option>
								<option value="ntp1.dlink.com">ntp1.dlink.com</option>
								<option value="ntp.dlink.com.tw">ntp.dlink.com.tw</option>
							</select>
						</td>
					</tr>
				</tbody>
				</table>
			</div>

			<div class=box>
				<h2><script>show_words('tt_StDT')</script></h2>
				<table width="525" cellpadding="1" cellspacing="1" class=formarea>
				<tbody>
					<tr>
						<td colspan=2>
							<table width="100%" border=0 cellpadding=2 cellspacing=0>
							<tbody>
								<tr>
									<td class="duple">&nbsp;</td>
									<td colspan="7">&nbsp;</td>
								</tr>
								<tr>
									<td class="duple"><script>show_words('tt_DaT')</script> : </td>
									<td>&nbsp;<script>show_words('tt_Year')</script></td>
									<td>
										<font face="Arial, Helvetica, sans-serif" size=2>
										<select id="year" name="year" size=1 style="WIDTH: 56px" onchange="selectDate();">
											<script>print_year();</script>
										</select>
										</font>
									</td>
									<td><script>show_words('tt_Month')</script></td>
									<td>
										<font face="Arial, Helvetica, sans-serif" size=2>
										<select id="mon" name="mon" size=1 style="WIDTH: 50px" onchange="selectDate();">
											<script>set_month_list();</script>
										</select>
										</font>
									</td>
									<td><script>show_words('tt_Day')</script></td>
									<td><font face="Arial, Helvetica, sans-serif" size=2>
										<select size=1 id="day" name="day" style="WIDTH: 50px"></select>
									</font></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td class="duple"></td>
									<td>&nbsp;<script>show_words('tt_Hour')</script></td>
									<td><font face="Arial, Helvetica, sans-serif" size=2>
									<select size=1 id="hour" name="hour" style="WIDTH: 50px">
										<option value=0>12</option>
										<option value=1>01</option>
										<option value=2>02</option>
										<option value=3>03</option>
										<option value=4>04</option>
										<option value=5>05</option>
										<option value=6>06</option>
										<option value=7>07</option>
										<option value=8>08</option>
										<option value=9>09</option>
										<option value=10>10</option>
										<option value=11>11</option>
									</select>
									</font></td>
									<td><script>show_words('tt_Minute')</script></td>
									<td><font face="Arial, Helvetica, sans-serif" size=2>
									<select size=1 id="min" name="min" style="WIDTH: 50px">
										<option value=0>00</option>
										<option value=1>01</option>
										<option value=2>02</option>
										<option value=3>03</option>
										<option value=4>04</option>
										<option value=5>05</option>
										<option value=6>06</option>
										<option value=7>07</option>
										<option value=8>08</option>
										<option value=9>09</option>
										<option value=10>10</option>
										<option value=11>11</option>
										<option value=12>12</option>
										<option value=13>13</option>
										<option value=14>14</option>
										<option value=15>15</option>
										<option value=16>16</option>
										<option value=17>17</option>
										<option value=18>18</option>
										<option value=19>19</option>
										<option value=20>20</option>
										<option value=21>21</option>
										<option value=22>22</option>
										<option value=23>23</option>
										<option value=24>24</option>
										<option value=25>25</option>
										<option value=26>26</option>
										<option value=27>27</option>
										<option value=28>28</option>
										<option value=29>29</option>
										<option value=30>30</option>
										<option value=31>31</option>
										<option value=32>32</option>
										<option value=33>33</option>
										<option value=34>34</option>
										<option value=35>35</option>
										<option value=36>36</option>
										<option value=37>37</option>
										<option value=38>38</option>
										<option value=39>39</option>
										<option value=40>40</option>
										<option value=41>41</option>
										<option value=42>42</option>
										<option value=43>43</option>
										<option value=44>44</option>
										<option value=45>45</option>
										<option value=46>46</option>
										<option value=47>47</option>
										<option value=48>48</option>
										<option value=49>49</option>
										<option value=50>50</option>
										<option value=51>51</option>
										<option value=52>52</option>
										<option value=53>53</option>
										<option value=54>54</option>
										<option value=55>55</option>
										<option value=56>56</option>
										<option value=57>57</option>
										<option value=58>58</option>
										<option value=59>59</option>
									</select>
									</font></td>
									<td><script>show_words('tt_Second')</script></td>
									<td><font face="Arial, Helvetica, sans-serif" size=2>
									<select size=1 id="sec" name="sec" style="WIDTH: 50px">
										<option value=0>00</option>
										<option value=1>01</option>
										<option value=2>02</option>
										<option value=3>03</option>
										<option value=4>04</option>
										<option value=5>05</option>
										<option value=6>06</option>
										<option value=7>07</option>
										<option value=8>08</option>
										<option value=9>09</option>
										<option value=10>10</option>
										<option value=11>11</option>
										<option value=12>12</option>
										<option value=13>13</option>
										<option value=14>14</option>
										<option value=15>15</option>
										<option value=16>16</option>
										<option value=17>17</option>
										<option value=18>18</option>
										<option value=19>19</option>
										<option value=20>20</option>
										<option value=21>21</option>
										<option value=22>22</option>
										<option value=23>23</option>
										<option value=24>24</option>
										<option value=25>25</option>
										<option value=26>26</option>
										<option value=27>27</option>
										<option value=28>28</option>
										<option value=29>29</option>
										<option value=30>30</option>
										<option value=31>31</option>
										<option value=32>32</option>
										<option value=33>33</option>
										<option value=34>34</option>
										<option value=35>35</option>
										<option value=36>36</option>
										<option value=37>37</option>
										<option value=38>38</option>
										<option value=39>39</option>
										<option value=40>40</option>
										<option value=41>41</option>
										<option value=42>42</option>
										<option value=43>43</option>
										<option value=44>44</option>
										<option value=45>45</option>
										<option value=46>46</option>
										<option value=47>47</option>
										<option value=48>48</option>
										<option value=49>49</option>
										<option value=50>50</option>
										<option value=51>51</option>
										<option value=52>52</option>
										<option value=53>53</option>
										<option value=54>54</option>
										<option value=55>55</option>
										<option value=56>56</option>
										<option value=57>57</option>
										<option value=58>58</option>
										<option value=59>59</option>
									</select>
									</font></td>
									<td>
									<select id="ampm" name="ampm">
										<option value="0"><script>show_words('_AM')</script></option>
										<option value="1"><script>show_words('_PM')</script></option>
									</select>
									</td>
								</tr>
								<tr>
									<td class="duple"></td>
									<td colspan="7"> 
										<input name="clone" id="clone" type="button" value="" onClick="set_time()"></td>
										<script>$('#clone').val(get_words('tt_CopyTime'));</script>
								</tr>
							</tbody>
							</table>
						</td>
					</tr>
				</tbody>
				</table>
			</div>
		</div></td></form>

		<form id="form2" name="form2" method="post" action="">
			<input type="hidden" name="html_response_return_page" value="tools_time.asp">
		</form>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text><strong> 
			<script>show_words('_hints')</script>&hellip;</strong>
			<p><script>show_words('hhtt_intro')</script></p>
			<p><a href="support_tools.asp#Time"><script>show_words('_more')</script>&hellip;</a></p>
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