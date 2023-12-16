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

var dnsMap = {
	'0': {Policy:get_words('_opendns_nonblocking'),Primary:'',Secondary:''},
	'1': {Policy:get_words('_opendns_adult'),Primary:'204.194.232.200',Secondary:'204.194.234.200'},
	'2': {Policy:get_words('_opendns_child'),Primary:'208.67.222.123',Secondary:'208.67.220.123'}
};
var mainObj = getMain();

function getMain(){
	var main = new ccpObject("get_set.ccp","get");
	main.add_param_arg("IGD_",1000);
	main.add_param_arg("IGD_OpenDNSClients_i_",1000);
	main.add_param_arg("IGD_LANDevice_i_ConnectedAddress_i_",1100);
	main.get_config_obj();
	return main.make_member();
}
function checkSettings(obj){
	if(!is_form_modified("form1") && !confirm(get_words('_ask_nochange'))){
		return false;
	}
	var total = obj.igd['1.0.0.0'].OpenDNSCNumberOfEntries;
	var aRule = obj.get_member_array('openDNSC', true);
	var mac = $('#mac_addr').val();
	for(var i=0;i<total;++i){
		if(mac==aRule[i].MAC){
			alert(addstr1(get_words('GW_MAC_FILTER_MAC_UNIQUENESS_INVALID'),$('#mac_addr').val()));
			return false;
		}
		if(mac!='' && !check_mac(mac)){
			alert(get_words('MAC_ADDRESS_ERROR',LangMap.msg));
			return false;
		}
	}
	return true;
}
function saveTableSettings(set){
	$('.rule_enabled').each(function(idx,e){
		var inst = $(e).data('inst');
		set.add_param_arg('openDNSC_Enabled_',inst,$(e).attr('checked')?1:0);
	});
	return set;
}
function saveNewSettings(set){
	if($('#mac_addr').val()!=''){
		var queryInst = new ccpObject('get_set.ccp','queryInst');
		queryInst.add_param_arg('IGD_OpenDNSClients_i_','1.1.0.0')
		queryInst.ajax_submit(function(){
			var result = queryInst.config_val('result');
			if(result=='success'){
				var inst = queryInst.config_val('newInst');
				console.log(inst);
				set.add_param_arg('openDNSC_Enabled_',inst,$('#opendns_enable').attr('checked')?1:0);
				set.add_param_arg('openDNSC_MAC_',inst,$('#mac_addr').val());
				set.add_param_arg('openDNSC_Policy_',inst,$('#policy').val());
				set.get_config_obj();
			}
			else{
				alert(get_words('_ruleisfull'));
			}
		})
		return null;
	}
	else{
		return set;
	}
}
function saveSettings(){
	var set = new ccpObject('get_set.ccp','set');
	set.set_param_next_page('adv_opendns.asp');
	set.add_param_event('CCP_SUB_WEBPAGE_APPLY');
	
	set = saveTableSettings(set);
	set = saveNewSettings(set);
	if(set){
		set.get_config_obj();
	}
	//alreay submit in saveNewSettings();
}
function setHeader(){
	$('#header_link').html('&nbsp;&nbsp;'+get_words('TA2')+': '+'<a href="http://www.dlink.com/us/en/support">'+model+'</a>');
	$('#header_hwv').html(get_words('TA3')+': '+hw_version+' &nbsp;');
	$('#header_fwv').html(get_words('sd_FWV')+': '+version);
}
function setMenu(){
	$('#menu_top').ready(function(){
		ajax_load_page('menu_top.asp', 'menu_top', 'top_b2');
	});
	$('#menu_left').ready(function(){
		ajax_load_page('menu_left_adv.asp', 'menu_left', 'left_b17');
	});
}
function setMacList(obj){
	var aHost = obj.get_member_array('igdLanHostStatus', true);
	for(var i=0;i<aHost.length;++i){
		if(+aHost[i].HostAddressType==0 || +aHost[i].HostAddressType==1){
			$('#mac_list').append('<option value="'+aHost[i].HostMACAddress+'">'+sp_words(aHost[i].HostName)+'</option>');
		}
	}
}
function setPolicyTable(obj){
	var aPolicy = obj.get_member_array('openDNSC', true);
	for(var i=0;i<aPolicy.length;++i){
		console.log(aPolicy[i]);
		$('#policy_table').append(drawTable(aPolicy[i],i));
	}
}
function drawTable(obj,idx){
	return '<tr>'+
		'<td><input type="checkbox" id="rule_enabled'+idx+'" class="rule_enabled" data-inst="'+obj.key+'" '+(1==+obj.Enabled?'checked':'')+' /></td>'+
		'<td>'+dnsMap[obj.Policy].Policy+'</td>'+
		'<td>'+obj.MAC+'</td>'+
		'<td>'+dnsMap[obj.Policy].Primary+'</td>'+
		'<td>'+dnsMap[obj.Policy].Secondary+'</td>'+
		'<td><a id="rule_del'+idx+'" href="#" class="rule_del" data-inst="'+obj.key+'"><img src="image/delete.jpg" border="0" title="'+get_words('_delete')+'" /></a></td>'+
	'</tr>';
}
function setEvtMacList(){
	$('#mac_list').unbind('change').bind('change', function(e){
		e.preventDefault();
		$('#mac_addr').val($(this).val());
	});
}
function setEvtBtnDel(obj){
	$('.rule_del').unbind('click').bind('click', function(e){
		e.preventDefault();
		var inst = $(this).data('inst');
		var del = new ccpObject('get_set.ccp','del');
		del.set_param_next_page('adv_opendns.asp');
		del.add_param_event('CCP_SUB_WEBPAGE_APPLY');
		del.add_param_arg('IGD_OpenDNSClients_i_',inst);
		del.get_config_obj();
	});
}
function setEvtBtnSave(obj){
	$('#btn_save').unbind('click').bind('click', function(e){
		e.preventDefault();	
		if(checkSettings(obj)){
			saveSettings(obj);
		}
	});
}
function setEvtBtnCancel(){
	$('#btn_cancel').unbind('click').bind('click', function(e){
		e.preventDefault();
		console.log('page_cancel');
		page_cancel('form1', 'adv_opendns.asp');
	});
}
function setEvtBtnTest(obj){
	$('#btn_test').unbind('click').bind('click', function(e){
		e.preventDefault();
		if($('#rt_address').val()!=''){
			sendQuery();
		}
	});
}
function sendQuery(){
	var aSeq = [
		{selector:'#rt_nonblocking',type:'non-Blocking'},
		{selector:'#rt_adult',type:'Adult'},
		{selector:'#rt_child',type:'Child'}
	];
	$('#rt_nonblocking,#rt_adult,#rt_child').text('');
	aSeq.forEach(function(seq){
		var query4 = new ccpObject('dns.ccp','opendns_v4');
		var type = seq.type;
		query4.set_param_option('query_domain',$('#rt_address').val());
		query4.set_param_option('type',type);
		query4.ajax_submit(function(){
			var obj = query4.make_member();
			// v4 not response, do v6
			if(obj[0][type]=='-'){
				var query6 = new ccpObject('dns.ccp','opendns_v6');
				query6.set_param_option('query_domain',$('#rt_address').val());
				query6.set_param_option('type',type);
				query6.ajax_submit(function(){
					var obj = query6.make_member();
					$(seq.selector).text(addstr1(get_words('_opendns_query_time'),obj[0][type]));
				});
			}
			$(seq.selector).text(addstr1(get_words('_opendns_query_time'),obj[0][type]));
		});
	})
}
$(function(){
	setHeader();
	setMenu();
	
	setMacList(mainObj);
	setPolicyTable(mainObj);

	setEvtMacList();
	setEvtBtnDel(mainObj);
	
	setEvtBtnSave(mainObj);
	setEvtBtnCancel(mainObj);
	setEvtBtnTest(mainObj);
	set_form_default_values('form1');
})
if (!Array.prototype.forEach) {
    Array.prototype.forEach = function forEach(fun /*, thisp*/) {
        var object = toObject(this),
            self = splitString && _toString.call(this) === "[object String]" ?
                this.split("") :
                object,
            thisp = arguments[1],
            i = -1,
            length = self.length >>> 0;

        // If no callback function or if callback is not a callable function
        if (!isFunction(fun)) {
            throw new TypeError(); // TODO message
        }

        while (++i < length) {
            if (i in self) {
                // Invoke the callback function with call, passing arguments:
                // context, property value, property key, thisArg object
                // context
                fun.call(thisp, self[i], i, object);
            }
        }
    };
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
			<td id="header_link" width="100%"></td>
			<td width="60%">&nbsp;</td>
			<td id="header_hwv" align="right" nowrap></td>
			<td id="header_fwv" align="right" nowrap></td>
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
		<!-- end of top menu -->
		</td>
	</tr>
	</table>

	<!-- main content -->
	<table class="topnav_container" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<!-- left menu -->
		<td id="sidenav_container" valign="top"><div id="menu_left"></div></td>
		<!-- end of left menu -->
		<td valign="top" id="maincontent_container">
		<div id="maincontent">
			<!-- ######################### -->
			<!--          main part        -->
			<!-- ######################### -->
			<div id="box_header">
				<h1><script>show_words('_adv_opendns');</script></h1>
				<p></p>
				<input type="button" id="btn_save" class="button_submit" />
				<input type="button" id="btn_cancel" class="button_submit" />
				<script>$("#btn_save").val(get_words('_savesettings'));</script>
				<script>$("#btn_cancel").val(get_words('_dontsavesettings'));</script>
			</div>
			<form id="form1" name="form1" method="post" action="">
				<div class="box">
					<h2><script>show_words('_adv_opendns');</script></h2>
					<table cellSpacing="1" cellPadding="1" width="525" border="0">
					<tr>
						<td width="155" align="right" class="duple"><script>show_words('_enable')</script>:</td>
						<td width="360">&nbsp;
							<input type="checkbox" id="opendns_enable" value="1">
						</td>
					</tr>
					<tr>
						<td width="155" align="right" class="duple"><script>show_words('aa_AT_1');</script>:</td>
						<td width="360">&nbsp;
							<input type="text" id="mac_addr" value="" maxlength="17" />&lt;&lt;
							<select id="mac_list">
								<option value=""><script>show_words('bd_CName');</script></option>
							<select>
						</td>
					</tr>
					<tr>
						<td width="155" align="right" class="duple"><script>show_words('aa_ACR_c2');</script>:</td>
						<td width="360">&nbsp;
							<select id="policy">
								<option value="0"><script>show_words('_opendns_policy_nb');</script></option>
								<option value="1"><script>show_words('_opendns_adult');</script></option>
								<option value="2"><script>show_words('_opendns_child');</script></option>
							<select>
						</td>
					</tr>
					</table>
				</div>
				<div class="box">
					<h2><script>show_words('aa_Policy_Table');</script></h2>
					<p></p>
					<table id="policy_table" bordercolor="#ffffff" cellspacing="1" cellpadding="2" width="525" bgcolor="#dfdfdf" border="1">
					<tr>
						<td><strong><script>show_words('_enable');</script></strong></td>
						<td><strong><script>show_words('aa_ACR_c2');</script></strong></td>
						<td><strong><script>show_words('aa_AT_1');</script></strong></td>
						<td><strong><script>show_words('_dns1');</script></strong></td>
						<td><strong><script>show_words('_dns2');</script></strong></td>
						<td></td>
					</tr>
					</table>
				</div>
			</form>
				<div class="box">
					<h2><script>show_words('_response_time');</script></h2>
					<p></p>
					<table cellSpacing="1" cellPadding="1" width="525" border="0">
					<tr>
						<td width="185"><strong><script>show_words('tsc_pingt_h');</script> :</strong></td>
						<td colSpan="3">&nbsp; <input type="text" id="rt_address" /><input type="button" id="btn_test" value="Test" />
						<script>$('#btn_test').val(get_words('_test'));</script>
						</td>
					</tr>
					<tr>
						<td width="185"><strong><script>show_words('_opendns_nonblocking');</script> :</strong></td>
						<td colSpan="3">&nbsp; <span id="rt_nonblocking"></span></td>
					</tr>
					<tr>
						<td width="185"><strong><script>show_words('_opendns_adult');</script> :</strong></td>
						<td colSpan="3">&nbsp; <span id="rt_adult"></span></td>
					</tr>
					<tr>
						<td width="185"><strong><script>show_words('_opendns_child');</script> :</strong></td>
						<td colSpan="3">&nbsp; <span id="rt_child"></span></td>
					</tr>
					</table>
				</div>
			</div>
			<!-- ######################### -->
			<!--      end of main part     -->
			<!-- ######################### -->
		</td>

		<!-- user tips -->
		<td valign="top" width="150" id="sidehelp_container" align="left">
		<div id="help_text">
			<strong><script>show_words('_hints')</script>&hellip;</strong>
			<p></p>
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