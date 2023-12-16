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
	var cli_mac 	= dev_info.cli_mac;
	
	document.title = get_words('TEXT000');
	
	/* get time information */
	var infoObj = new ccpObject();
	var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=3'+
				'&oid_1=IGD_Email_&inst_1=1100'+
				'&oid_2=IGD_ScheduleRule_i_&inst_2=1000'+
				'&oid_3=IGD_MyDLink_&inst_3=1100'
	};
	infoObj.get_config_obj(param);

	//IGD_Email_
	var objEmail = {
		'enable':		infoObj.config_val('emailCfg_Enable_'),
		'emailFrom':	infoObj.config_val('emailCfg_EmailFrom_'),
		'emailTo':		infoObj.config_val('emailCfg_EmailTo_'),
		'subject':		infoObj.config_val('emailCfg_Subject_'),
		'smtpAddr':		infoObj.config_val('emailCfg_SMTPServerAddress_'),
		'smtpPort':		infoObj.config_val('emailCfg_SMTPServerPort_'),
		'authEnable':	infoObj.config_val('emailCfg_AuthenticationEnable_'),
		'username':		infoObj.config_val('emailCfg_AccountName_'),
		'password':		infoObj.config_val('emailCfg_AccountPassword_'),
		'logOnFullEn':	infoObj.config_val('emailCfg_LogOnFullEnable_'),
		'logOnSchEn':	infoObj.config_val('emailCfg_LogOnScheduleEnable_'),
		'logSchIdx':	infoObj.config_val('emailCfg_LogScheduleIndex_'),
		'logDetail':	infoObj.config_val('emailCfg_LogDetail_')
	};
		
	//IGD_ScheduleRule_i_
	var array_sch_inst 		= infoObj.config_inst_multi("IGD_ScheduleRule_i_");
	var array_schedule_name	= infoObj.config_str_multi("schRule_RuleName_");
	var schedule_cnt = 0;
	if(array_schedule_name != null) {
		schedule_cnt = array_schedule_name.length;
	}
	var objSch = {
		cnt:		schedule_cnt,
		inst: 		array_sch_inst,
		name:		array_schedule_name,
		allweek: 	infoObj.config_str_multi("schRule_AllWeekSelected_"),
		days: 		infoObj.config_str_multi("schRule_SelectedDays_"),
		allday: 	infoObj.config_str_multi("schRule_AllDayChecked_"),
		timeformat: infoObj.config_str_multi("schRule_TimeFormat_"),
		start_h: 	infoObj.config_str_multi("schRule_StartHour_"),
		start_mi: 	infoObj.config_str_multi("schRule_StartMinute_"),
		start_me: 	infoObj.config_str_multi("schRule_StartMeridiem_"),
		end_h: 		infoObj.config_str_multi("schRule_EndHour_"),
		end_mi: 	infoObj.config_str_multi("schRule_EndMinute_"),
		end_me: 	infoObj.config_str_multi("schRule_EndMeridiem_")
	};

	function add_option(cnt, arrInst, arrName)
	{
		if (cnt == null)
			return;

		for (var i = 0; i < cnt; i++){		
			var inst = inst_array_to_string(arrInst[i]);
			document.write("<option value=" + inst.charAt(1) + ">" + arrName[i] + "</option>");
		}	
	}

	function schDetail(idx, obj)
	{
		var s = '';
		var s_day = "", count = 0;
		var s_time = '';
		var e_time = '';
		var days = obj.days[idx];
		
		for(var i=0; i < 8; i++){
			if(obj.days[idx].charAt(i) == "1"){
				s_day = s_day + " " + Week[i];
				count++;
			}
		}
		
		if(count == 7 || obj.allweek[idx] == 1){
			s_day = get_words('tsc_AllWk');
		}
		
		/*	//currently, we stored 24-hr format
		if (obj.start_me[idx] == 1)
			s_time = parseInt(obj.start_h[idx]) + 12;
		else
		*/
		s_time = obj.start_h[idx];
		s_time = s_time + ':' + (parseInt(obj.start_mi[idx])<10? '0'+obj.start_mi[idx] : obj.start_mi[idx] );
		
		/* //currently, we stored 24-hr format
		if (obj.end_me[idx] == 1)
			e_time = parseInt(obj.end_h[idx]) + 12;
		else
		*/
			e_time = obj.end_h[idx];
		e_time = e_time + ':' + (parseInt(obj.end_mi[idx])<10? '0'+obj.end_mi[idx] : obj.end_mi[idx] );
		
		var temp_time_array = s_time + "~" + e_time;
		if(obj.allday[idx] == 1 || s_time == e_time ){
			temp_time_array = get_words('tsc_AllDay');
		}
		
		s = s_day + " " + temp_time_array;
		return s;		
	}
	
	function onSchClick()
	{
		var schedule = get_by_id("email_schedule");
		//alert(schedule.selectedIndex);
		if(schedule.value == "-1"){
			if (confirm(get_words('aa_sched_conf_1')+"\n"+
				get_words('aa_sched_conf_2')+"\n"+get_words('up_ae_wic_3'))){
				window.location.href = "tools_schedules.asp";
			}
		}else if(schedule.selectedIndex == -1){
			get_by_id("email_detail").value = "";
		}else if(schedule.selectedIndex < 2){
			get_by_id("email_detail").value = schedule[schedule.selectedIndex].text;
		}else if(schedule.selectedIndex > 1){
			var idx = parseInt(schedule.selectedIndex) - 2;
			get_by_id("email_detail").value = schDetail(idx, objSch);
		}
	}
		
	function onPageLoad(){
		//alert(objEmail.enable);
		if (objEmail != null) {
			$('#email_enable').attr('checked', parseInt(objEmail.enable));
			$('#email_auth').attr('checked', parseInt(objEmail.authEnable));
			$('#email_sch_enable').attr('checked', parseInt(objEmail.logOnFullEn));
			$('#by_email_sch').attr('checked', parseInt(objEmail.logOnSchEn));
			
			set_selectIndex(objEmail.logSchIdx, get_by_id("email_schedule"));
			
			$('#log_email_sender').val(objEmail.emailFrom);
			$('#log_email_recipien').val(objEmail.emailTo);
			$('#log_email_server').val(objEmail.smtpAddr);
			$('#log_email_port').val(objEmail.smtpPort);
			$('#log_email_username').val(objEmail.username);
			$('#log_email_password').val(objEmail.password);
			$('#email_pw2').val(objEmail.password);
			$('#email_schedule').val(objEmail.logSchIdx);
		}
		onSchClick();

		if(dev_info.login_info != "w"){
			DisableEnableForm(document.form1,true);	
		}else{
			disable_schedule()
			disable_notifcation();
		}
		
	}

	function check_mail(){
		if (get_by_id("log_email_sender").value == ""){
			//alert(LangMap.msg['SMTP_SERVER_ERROR']);
			alert(get_words('_blankfromemailaddr'));
			return false;
		}else if(get_by_id("log_email_recipien").value == ""){
			//alert(LangMap.msg['EMAIL_ADDRESS_ERROR']);
			alert(get_words('_blanktomemailaddr'));
			return false;
		}else if (get_by_id("log_email_server").value == ""){
			//alert(LangMap.msg['EMAIL_ADDRESS_ERROR']);
			alert(get_words('_blanksmtpmailaddr'));
			return false;
		}else if (get_by_id('email_auth').checked && get_by_id("log_email_password").value != get_by_id("email_pw2").value){
			//alert(LangMap.msg['MATCH_WIZARD_PWD_ERROR']);
			alert(get_words('YM102'));
			return false;
		}
		return true;
	}
	
	function disable_emai_auth(){
		if(get_by_id("email_enable").checked){
	  	get_by_id("log_email_username").disabled = !get_by_id("email_auth").checked;
	  	get_by_id("log_email_password").disabled = !get_by_id("email_auth").checked;
	  	get_by_id("email_pw2").disabled = !get_by_id("email_auth").checked;
		}		
	}		
	
	function disable_notifcation(){
	  	get_by_id("log_email_sender").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("log_email_recipien").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("log_email_server").disabled = !get_by_id("email_enable").checked;
		get_by_id("log_email_port").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("email_auth").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("log_email_username").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("log_email_password").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("email_pw2").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("email_sch_enable").disabled = !get_by_id("email_enable").checked;
	  	get_by_id("by_email_sch").disabled = !get_by_id("email_enable").checked;
	  	if(!get_by_id("email_enable").checked){
	  		get_by_id("email_schedule").disabled = !get_by_id("email_enable").checked;
	  		//get_by_id("email_detail").disabled = !get_by_id("email_enable").checked;
	  	}	
	  	else{
	  		get_by_id("email_schedule").disabled = !get_by_id("by_email_sch").checked;
	  		//get_by_id("email_detail").disabled = !get_by_id("by_email_sch").checked;
	  	}		  	
		disable_emai_auth();
	}	

	function disable_schedule(){
	  	get_by_id("email_schedule").disabled = !get_by_id("by_email_sch").checked;
	  	//get_by_id("email_detail").disabled = !get_by_id("by_email_sch").checked;
	}		

	function check_date()
	{
		if (is_form_modified("form1") && !confirm(get_words('up_jt_1')+"\n"+get_words('up_jt_2')+"\n"+get_words('up_jt_3'))){
			return;
		}
		location.href="tools_schedules.asp";
	}

	function do_submit()
	{
		var setObj = new ccpObject();
		var param = {
			'url':	'get_set.ccp',
			'arg':	'ccp_act=set'
		};

		param.arg += '&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=tools_email.asp'+
					'&emailCfg_Enable_1.1.0.0='+($('#email_enable').attr('checked')? '1': '0')+
					'&emailCfg_EmailFrom_1.1.0.0='+$('#log_email_sender').val()+
					'&emailCfg_EmailTo_1.1.0.0='+$('#log_email_recipien').val()+
					'&emailCfg_SMTPServerAddress_1.1.0.0='+$('#log_email_server').val()+
					'&emailCfg_SMTPServerPort_1.1.0.0='+$('#log_email_port').val()+
					'&emailCfg_AuthenticationEnable_1.1.0.0='+($('#email_auth').attr('checked')? '1': '0')+
					'&emailCfg_AccountName_1.1.0.0='+$('#log_email_username').val()+
					'&emailCfg_AccountPassword_1.1.0.0='+$('#log_email_password').val()+
					'&emailCfg_LogOnFullEnable_1.1.0.0='+($('#email_sch_enable').attr('checked')? '1': '0')+
					'&emailCfg_LogOnScheduleEnable_1.1.0.0='+($('#by_email_sch').attr('checked')? '1': '0')+
					'&emailCfg_LogScheduleIndex_1.1.0.0='+$('#email_schedule').val()
		setObj.get_config_obj(param);
	}

	function send_request()
	{
		if (!is_form_modified("form1") && !confirm(get_words('_ask_nochange'))) {
			return false;
		}

		if(get_by_id("email_enable").checked){
			if(!check_mail()){
				return false;
			}
		}

		if (!check_integer(get_by_id("log_email_port").value, 0, 65535)) {
			alert(get_words('te_SMTPSv_Port_alert'));
			return false;
		}		

		do_submit();
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
		<script>ajax_load_page('menu_left_tools.asp', 'menu_left', 'left_b4');</script>
		</td>
		<!-- end of left menu -->

		<form id="form1" name="form1" method="post" action="">
			
		<td valign="top" id="maincontent_container">
		<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id=box_header>
				<h1><script>show_words('_email')</script></h1>
				<script>show_words('te_intro_Em')</script>
				<br><br>
				<input name="button3" id="button3" type="button" class=button_submit value="" onClick="send_request()">
				<input name="button2" id="button2" type="button" class=button_submit value="" onclick="page_cancel('form1', 'tools_email.asp');">
				<script>$('#button3').val(get_words('_savesettings'));</script>
				<script>$('#button2').val(get_words('_dontsavesettings'));</script>
			</div>

			<div class="box">
				<h2><script>show_words('_enable')</script></h2>
				<table cellSpacing=1 cellPadding=2 width=525 border=0>
				<tr>
					<td class="duple"><script>show_words('te_EnEmN')</script>:</td>
					<td width="340">&nbsp;<input type="Checkbox" id="email_enable" name="email_enable" value="1" onClick="disable_notifcation();"></td>
				</tr>
				</table>
			</div>

			<div class="box">
				<h2><script>show_words('te_EmSt')</script></h2>
				<table cellSpacing=1 cellPadding=2 width=525 border=0>
				<tr>
					<td class="duple"><script>show_words('te_FromEm')</script>:</td>
					<td width="340">&nbsp;
						<input type=text id="log_email_sender" name="log_email_sender" size=30 maxlength=99 value="">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('te_ToEm')</script>:</td>
					<td width="340">&nbsp;
						<input type=text id="log_email_recipien" name="log_email_recipien" size=30 maxlength=99 value="">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('te_SMTPSv')</script>:</td>
					<td width="340">&nbsp;
						<input type=text id="log_email_server" name="log_email_server" size=30 maxlength=99 value="">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('te_SMTPPort')</script>:</td>
					<td width="340">&nbsp;
						<input type=text id="log_email_port" name="log_email_port" size=5 maxlength=99 value="">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('te_EnAuth')</script>:</td>
					<td width="340">&nbsp;<input type="Checkbox" id="email_auth" name="email_auth" value="1" onClick="disable_emai_auth();"></td>
						<input type="hidden" id="log_email_auth" name="log_email_auth" value="">
				</tr>
				<tr>
					<td class="duple"><script>show_words('te_Acct')</script>:</td>
					<td width="340">&nbsp;
						<input type=text id="log_email_username" name="log_email_username" size=30 maxlength=99 value="">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('_password')</script>:</td>
					<td width="340">&nbsp;
						<input type=password id="log_email_password" name="log_email_password" size=30 maxlength=99 value="">
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('_verifypw')</script>:</td>
					<td width="340">&nbsp;
						<input type=password id="email_pw2" name="email_pw2" size=30 maxlength=99 value="">
					</td>
				</tr>
				</table>
			</div>

			<div class="box">
				<h2><script>show_words('te__title_EmLog')</script></h2>
				<table cellSpacing=1 cellPadding=2 width=525 border=0>
				<tr>
					<td class="duple"><script>show_words('te_OnFull')</script> :</td>
					<td width="340">&nbsp;<input type="Checkbox" id="email_sch_enable" name="email_sch_enable" value="1"></td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('te_OnSch')</script>:</td>
					<td width="340">&nbsp;<input type="Checkbox" id="by_email_sch" name="by_email_sch" value="25" onClick="disable_schedule();"></td>
				</tr>
				<tr>
					<td class="duple"><a href="javascript:check_date();"><script>show_words('_sched')</script></a> :</td>
					<td width="340">&nbsp;
					<select id="email_schedule" name="email_schedule" onchange="onSchClick();">
						<option value="255" selected><script>show_words('_always')</script></option>
						<option value="254"><script>show_words('_never')</script></option>
						<script>document.write(add_option(schedule_cnt, array_sch_inst, array_schedule_name));</script>
					</select>
					</td>
				</tr>
				<tr>
					<td class="duple"><script>show_words('_aa_details')</script>:</td>
					<td width="340">&nbsp;&nbsp;<input type="text" id="email_detail" name="email_detail" disabled></td>
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
			<p><script>show_words('hhte_intro')</script></p>
			<p><a href="support_tools.asp#EMail"><script>show_words('_more')</script>&hellip;</a></p>
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