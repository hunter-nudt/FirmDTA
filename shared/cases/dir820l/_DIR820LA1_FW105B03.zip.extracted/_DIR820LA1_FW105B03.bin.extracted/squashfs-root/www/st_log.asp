<html>
<head>
<script>
	var funcWinOpen = window.open;
</script>
<style>  
      #wrap{word-break:break-all;width:400px; overflow:auto; }  
</style>  
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
	
	var curr_page = 1;
	var last_page = 1;
	var logObj = new ccpObject();
	var param = {
		'url': 	'get_set.ccp',
		'arg': 	'ccp_act=get&num_inst=2'+
				'&oid_1=IGD_SystemLogInfo_&inst_1=1100'+
				'&oid_2=IGD_Email_&inst_2=1100'
	};
	logObj.get_config_obj(param);
	
	//IGD_Email_
	var objEmail = {
		'enable':		logObj.config_val('emailCfg_Enable_'),
		'emailFrom':	logObj.config_val('emailCfg_EmailFrom_'),
		'emailTo':		logObj.config_val('emailCfg_EmailTo_'),
		'subject':		logObj.config_val('emailCfg_Subject_'),
		'smtpAddr':		logObj.config_val('emailCfg_SMTPServerAddress_'),
		'authEnable':	logObj.config_val('emailCfg_AuthenticationEnable_'),
		'username':		logObj.config_val('emailCfg_AccountName_'),
		'password':		logObj.config_val('emailCfg_AccountPassword_'),
		'logOnFullEn':	logObj.config_val('emailCfg_LogOnFullEnable_'),
		'logOnSchEn':	logObj.config_val('emailCfg_LogOnScheduleEnable_'),
		'logSchIdx':	logObj.config_val('emailCfg_LogScheduleIndex_'),
		'logDetail':	logObj.config_val('emailCfg_LogDetail_')
	};
	
	var sysLogInfo = {
		'sysAct':		logObj.config_val('sysLog_OptionSystemActivity_'),
		'debugInfo':	logObj.config_val('sysLog_OptionDebugInfo_'),
		'attack':		logObj.config_val('sysLog_OptionAttack_'),
		'droppedPack':	logObj.config_val('sysLog_OptionDroppedPacket_'),
		'notice':		logObj.config_val('sysLog_OptionNotice_')
	};
	
	var doRefreshObj = new ccpObject();
	param.url = "log.ccp";
	param.arg = "ccp_act=doLogReflash";
	doRefreshObj.get_config_obj(param);
	
	var query_page = 1;
	
	var doQueryObj = new ccpObject();
	param.url = "log.ccp"
	param.arg = "ccp_act=doLogQuery&queryPage="+query_page;
	doQueryObj.get_config_obj(param);
	
	var zero_page = 0;
	var current_page = 0;
	var totle_page = 0;

	function send_action(act, page)
	{
		var actObj = new ccpObject();
		var paramQry = {
			url: "log.ccp",
			arg: "ccp_act="+act
		};
		
		if(page!=0)
			paramQry.arg += "&queryPage="+page;
			
		actObj.get_config_obj(paramQry);
		paint_page_info(actObj);
		paint_content(actObj);
		disable_log_button();
	}
	
	function onPageLoad(){
		set_checked(sysLogInfo.sysAct, get_by_id("type1"));
		set_checked(sysLogInfo.debugInfo, get_by_id("type2"));
		set_checked(sysLogInfo.attack, get_by_id("type3"));
		set_checked(sysLogInfo.droppedPack, get_by_id("type4"));
		set_checked(sysLogInfo.notice, get_by_id("type5"));
		set_form_default_values("form8");
		if(dev_info.login_info != "w"){
			DisableEnableForm(form8,true);	
			$('#Fp1').attr('disabled',true);
			$('#Lp1').attr('disabled',true);
			$('#Pp1').attr('disabled',true);
			$('#Np1').attr('disabled',true);
			$('#clear').attr('disabled',true);
			$('#email').attr('disabled',true);
			$('#refresh').attr('disabled',true);
			$('#backup').attr('disabled',true);
		}
	}

	function send_request()
	{
		if (!is_form_modified("form8") && !confirm(get_words('_ask_nochange'))) {
			return false;
		}
		var ccpObj = new ccpObject();
		var param = {
			'url':	'get_set.ccp',
			'arg':	'ccp_act=set'
		};
		
		param.arg += '&ccpSubEvent=CCP_SUB_WEBPAGE_APPLY&nextPage=st_log.asp'+
					'&sysLog_OptionSystemActivity_1.1.0.0='+($('#type1').attr('checked')? '1': '0')+
					'&sysLog_OptionDebugInfo_1.1.0.0='+($('#type2').attr('checked')? '1': '0')+
					'&sysLog_OptionAttack_1.1.0.0='+($('#type3').attr('checked')? '1': '0')+
					'&sysLog_OptionDroppedPacket_1.1.0.0='+($('#type4').attr('checked')? '1': '0')+
					'&sysLog_OptionNotice_1.1.0.0='+($('#type5').attr('checked')? '1': '0');
		ccpObj.get_config_obj(param);
	}
	
	
	function switch_page(which_page){	
		if (which_page >= 0 && which_page <= last_page){
			get_by_id("current_page").value = which_page;
			//send_submit("form1");
		}
	}

	function start_button(){
		get_by_id("Pp1").disabled = true;
		get_by_id("Np1").disabled = true;
		get_by_id("Fp1").disabled = true;
		get_by_id("Lp1").disabled = true;
		
		setTimeout('disable_button()',1000);
	}

	function disable_button(){
		get_by_id("Pp1").disabled = false;
		get_by_id("Np1").disabled = false;
		get_by_id("Fp1").disabled = false;
		get_by_id("Lp1").disabled = false;
		
		if (curr_page == "1"){
			get_by_id("Pp1").disabled = true;
		}
		
		if (curr_page == last_page){
			get_by_id("Np1").disabled = true;
		}
	}
	
	function disable_log_button(){
		get_by_id("Pp1").disabled = false;
		get_by_id("Np1").disabled = false;
		get_by_id("Fp1").disabled = false;
		get_by_id("Lp1").disabled = false;

		var cur_page = current_page;
		var tot_page = totle_page;
		
		if (cur_page == 1 || (cur_page==0 && tot_page==0)){
		    get_by_id("Pp1").disabled = true;
		}
		if ((cur_page == tot_page ) && cur_page!=0 && tot_page!=0 ){
		    get_by_id("Np1").disabled = true;
		}
		var login_who=dev_info.login_info;
    	if(login_who != "w")
			get_by_id("clear").disabled = "true";			
	}
	

	function to_first_page(){
		query_page = 1;
		send_action("doLogQuery", query_page);
		//send_submit("form2");
	}

	function to_last_page(){
		query_page = totle_page;
		send_action("doLogQuery", query_page);
		//send_submit("form3");
	}
	
	function to_next_page(){
		query_page += 1;
		send_action("doLogQuery", query_page);
		//send_submit("form4");
	}
	
	function to_pre_page(){
		query_page -= 1;
		send_action("doLogQuery", query_page);
		//send_submit("form5");
	}

	function clear_log(){
		//send_submit("form6");
		send_action("doLogClear", 0);
		location.href='st_log.asp';
	}

	function paint_page_info(actObj)
	{
		var logCnt = actObj.config_val("currLogCnt");
		if(logCnt == 0)
		{
			current_page = zero_page;
			totle_page = 0;			
		}
		else
		{
			if((logCnt%10) == 0)
				totle_page = Math.floor(logCnt/10)
			else
				totle_page = Math.floor(logCnt/10) + 1;
			current_page = query_page;
		}
		
		if(totle_page > 10)
			totle_page = 10;
		
		/* disable save button avoid save error*/
		/*if(totle_page == 0)
			get_by_id("backup").disabled = true;
		else			
			get_by_id("backup").disabled = false;
		*/
		
		$('#caption_page').html(current_page+'/'+totle_page);

		//get_by_id("log_total_page").innerHTML = totle_page;
		//get_by_id("log_current_page").innerHTML = current_page;
	}
	
	function paint_content(actObj)
	{
		var logCnt = actObj.config_val("currLogCnt");
		var loopMax = 0;
		
		if(logCnt == 0)
			return;
			
		if(logCnt>10)
			loopMax = 10;
		else
			loopMax = logCnt;
			
		var logTime = actObj.config_str_multi("logTime");
		var logType = actObj.config_str_multi("logType");
		var logMsg = actObj.config_str_multi("logMsg");
		
		var content = '';
		content = '<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1 style="table-layout:fixed">'+
					'<tr>'+
					'<td width="20%">'+get_words('_time')+'</td>'+
					'<td>'+get_words('KR110')+'</td>'+
					'</tr>';
		
		for(var i=0; i<logTime.length; i++)
		{
			content +='<tr bgcolor=#FFFFFF>';
			content +='<td>' + logTime[i] + '</td>';
			content +='<td style="word-wrap : break-word;">' + logType[i] +': '+ logMsg[i] +'</td>';
			content +='</tr>';
		}
		
		content += '</table>';
		get_by_id("logContent").innerHTML = content;
	}	
	
	function save_log_fun()
	{
		//show_save_window('log.ccp?ccp_act=doLogSave');
		var paramSave = {
			url: "log.ccp",
			arg: "ccp_act=doLogSave"
		};
		//ajax_submit(paramSave);
		send_submit("form7");
	}

	function email_now()
	{
		if(objEmail.enable == "0")
			alert(get_words('YM169'));
		else
		{
			var add = objEmail.emailTo;
			//alert("The log will be sent to email address " + add);
			alert(get_words('sl_alert_2') + " " + add);	//sl_alert_2
			
			var paramSendMail = {
				url: "get_set.ccp",
				arg: 'ccp_act=doEvent&ccpSubEvent=CCP_SUB_EMAILNOW'
			};
			ajax_submit(paramSendMail,false);
		}
	}
	
	function show_save_window(name){
		funcWinOpen(name,"Save","width=500,height=600,scrollbar=yes");
	}
</script>

<style type="text/css">
<!--
.style4 {
	font-size: 11px;
	font-weight: bold;
}
.style5 {font-size: 11px}
#wrap {word-break:break-all;width:450px;}
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
		<script>$(document).ready(function($){ajax_load_page('menu_left_st.asp', 'menu_left', 'left_b2');});</script>
		</td>
		<!-- end of left menu -->

		<td valign="top" id="maincontent_container">
			<div id=maincontent>
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
				<div id="box_header"> 
					<h1><script>show_words('_logs')</script></h1>
					<p><script>show_words('sl_intro')</script></p>
				</div>
					<form id="form8" name="form8" method="post" action="">
					<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
					<input type="hidden" id="html_response_message" name="html_response_message" value="">
					<script>$('#html_response_message').val(get_words('sc_intro_sv'));</script>
					<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp">
					<div class="box">
						<h2><script>show_words('sl_LogOps')</script></h2>
						<table cellpadding="1" cellspacing="1" border="0" width="525">
							<tr>
								<td class="duple"><script>show_words('sl_LogOps')</script> :</td>
								<td width="340">
									<input type="hidden" id="log_system_activity" name="log_system_activity" value="">
									<input type=checkbox id=type1 name=type1 value="1"><script>show_words('TEXT019')</script>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td width="340">
									<input type="hidden" id="log_debug_information" name="log_debug_information" value="">
									<input type=checkbox id=type2 name=type2 value="1"><script>show_words('TEXT020')</script>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td width="340">
									<input type="hidden" id="log_attacks" name="log_attacks" value="">
									<input type=checkbox id=type3 name=type3 value="1"><script>show_words('TEXT021')</script>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td width="340">
									<input type="hidden" id="log_dropped_packets" name="log_dropped_packets" value="">
									<input type=checkbox id=type4 name=type4 value="1"><script>show_words('TEXT022')</script>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td width="340">
									<input type="hidden" id="log_notice" name="log_notice" value="">
									<input type=checkbox id=type5 name=type5 value="1"><script>show_words('TEXT023')</script>
								</td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<input name="button3" id="button3" type="button" class=button_submit value="" onClick="send_request()">
									<script>$('#button3').val(get_words('sl_ApplySt'));</script>
								</td>
							</tr>
						</table>
					</div>
					</form>
					<div class="box">
					<h2><script>show_words('sl_LogDet')</script></h2>	
					<form id="form1" name="form1" method="post" action="">
						<input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
						<input type="hidden" id="html_response_message" name="html_response_message" value="The setting is saved.">
						<script>$("#html_response_message").val(get_words('sc_intro_sv'));</script>
						<input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp">

						<input type="hidden" name="total_log" id="total_log" value="">
						<input type=hidden id="current_page" name="current_page" value="">
						<input type=hidden id="total_page" name="total_page" value="">
						<table cellpadding="1" cellspacing="1" border="0" width="525">
						<tr>
							<td><div align="center">
								<input id="Fp1" name="Fp1" type="button" class=button_submit value="" onclick="to_first_page()">
								<input id="Lp1" name="Lp1" type="button" class=button_submit value="" onclick="to_last_page()">
								<input id="Pp1" name="Pp1" type="button" class=button_submit value="" onclick="to_pre_page()">
								<input id="Np1" name="Np1" type="button" class=button_submit value="" onclick="to_next_page()">
								<script>$("#Fp1").val(get_words('TEXT016'));</script>
								<script>$("#Lp1").val(get_words('TEXT017'));</script>
								<script>$("#Pp1").val(get_words('TEXT018'));</script>
								<script>$("#Np1").val(get_words('TEXT074'));</script>
							</div>
							</td>
						</tr>
						<tr>
							<td><div align="center">
								<input id="refresh" name="refresh" type="button" class=button_submit value="" onClick='window.location.href="st_log.asp"'>
								<input id="clear" name="clear" type="button" class=button_submit value="" onclick="clear_log()">
								<input id="email" name="email" type="button" class=button_submit value="" onclick="email_now()">
								<input id="backup" name="backup" type="button" class=button_submit value="" onclick="save_log_fun();">
								<script>$("#refresh").val(get_words('sl_reload'));</script>
								<script>$("#clear").val(get_words('_clear'));</script>
								<script>$("#email").val(get_words('sl_emailLog'));</script>
								<script>$("#backup").val(get_words('sl_saveLog'));</script>
							</div>
							</td>
						</tr>
						<tr> 
							<td>
								<br>
								<font face="Tahoma" size="2">
								<span id='caption_page'></span>
								</font>
							</td>
						</tr>
						</table>

						<span id="logContent"></span>
					</div>
				<p>&nbsp;</p>
            </div>

				<form id="form2" name="form2" method="post" action=""><input type="hidden" id="html_response_page" name="html_response_page" value="st_log.asp"><input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp"></form>
				<form id="form3" name="form3" method="post" action=""><input type="hidden" id="html_response_page" name="html_response_page" value="st_log.asp"><input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp"></form>
				<form id="form4" name="form4" method="post" action=""><input type="hidden" id="html_response_page" name="html_response_page" value="st_log.asp"><input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp"></form>
				<form id="form5" name="form5" method="post" action=""><input type="hidden" id="html_response_page" name="html_response_page" value="st_log.asp"><input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp"></form>
				<form id="form6" name="form6" method="post" action=""><input type="hidden" id="html_response_page" name="html_response_page" value="st_log.asp"><input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp"></form>
				<form id="form7" name="form7" method=POST action="log.ccp">
				<input type="hidden" name="ccp_act" value="doLogSave">
				</form>
				<form id="form9" name="form9" method="post" action=""><input type="hidden" id="html_response_page" name="html_response_page" value="st_log.asp"><input type="hidden" id="html_response_return_page" name="html_response_return_page" value="st_log.asp"></form>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</div>
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id=help_text>
			<strong>
				<script>show_words('_hints')</script>&hellip;
			</strong>
			<p><script>show_words('hhsl_intro')</script></p>
			<p><script>show_words('hhsl_lmail')</script></p>
			<p><a href="support_status.asp#Logs"><script>show_words('_more')</script>&hellip;</a></p>
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
<br>
<script>
	to_first_page();
	//start_button();
	onPageLoad();
</script>
</body>
</html>
