var noAuthPage = new Array('login.asp', 'login_fail.asp', 'logout.asp', 'es_base.asp', 
		'es_display.asp', 'summary.asp', 'reject.asp', 'time_ctl.asp', 'error-404.asp', 
		'wizard_router.asp');
var noRedirectLogin = new Array('tools_firmw.asp', 'login.asp', 'reject.asp', 'time_ctl.asp', 
		'back.asp', 'error-404.asp', 'wps_back.asp', 'reboot.asp', 'wizard_router.asp');
var noTimeoutPage = new Array();
var drws_err = 
{
	'5001':	get_words('drws_err_5001'),
	'5002':	get_words('drws_err_5002'),
	'5003':	get_words('drws_err_5003'),
	'5004':	get_words('drws_err_5004'),
	'5005':	get_words('drws_err_5005'),
	'5006':	get_words('drws_err_5006'),	//'5006':	'Lack of required parameters',
	'5007':	get_words('drws_err_5007'),
	'5008':	get_words('drws_err_5008'),
	'5009':	get_words('drws_err_5009'),
	'5010':	get_words('drws_err_5010'),
	'5011':	get_words('drws_err_5011'),
	'5101':	get_words('drws_err_5101'),
	'5102':	get_words('drws_err_5102'),	
	'5103':	get_words('drws_err_5103'),	
	'5104':	get_words('drws_err_5104')
};

var gConfig;

function get_time_str(str)
{
	try {
		var n = parseInt(str);
		
		if (n < 10)
			return ('0'+str);
		else
			return str;
	} catch (e) {
		return '00';
	}
}

function show_schedule_detail(idx, sch_obj){
	var detail = '';
	var s_day = '';
	var str_day = new String(sch_obj.days);

	for(var j = 0; j < 8; j++){			
		if(str_day.substr(j, 1) == "1"){
			s_day += (Week[j] + ' ');
		}
	}

	if(sch_obj.allweek == '1' || s_day == ''){
		s_day = "All week";
	}

	var str_time = get_time_str(sch_obj.start_h)+':'+get_time_str(sch_obj.start_mi)+
				'~'+get_time_str(sch_obj.end_h)+':'+get_time_str(sch_obj.end_mi);
	if(sch_obj.allday == '1' || str_time== '00:00~24:00'){
		str_time = "All Day";
	}
	
	detail = s_day + ", " + str_time;
	return detail;
}

function getCookieValue(val) {
	if ((endOfCookie = document.cookie.indexOf(";", val)) == -1) {
		endOfCookie = document.cookie.length;
	}
	return unescape(document.cookie.substring(val,endOfCookie));
}

function getCookie(name) {
	if (document.cookie == null)
		return null
	
	var ckLen = document.cookie.length;
	var sName = name + "=";
	var cookieLen = sName.length;
	var x = 0;
	while (x <= ckLen) {
		var y = (x + cookieLen);
		if (document.cookie.substring(x, y) == sName)
			return getCookieValue(y);
		x = document.cookie.indexOf(" ", x) + 1;
		if (x == 0){
			break;
		}
	}
	return null;
}

function getDocName() {
	var file_name = document.location.pathname;
	var end = (file_name.indexOf("?") == -1) ? file_name.length : file_name.indexOf("?");
	return file_name.substring(file_name.lastIndexOf("/")+1, end);
}

function needAuth(page) {
	if (noAuthPage == null || page == null)
		return 1;

	for (var i=0; i<noAuthPage.length; i++) {
		if (page == noAuthPage[i])
			return 0;
	}
	
	return 1;
}

function get_config_obj(param)
{
	if (param == null || param.url == null)
		return;

	var hasLogin = getCookie('hasLogin');  
	if (hasLogin == null || hasLogin == '0') {
		if (needAuth(getDocName()) == 1) {
			document.cookie = 'hasLogin=0;';
			setTimeout(function() {
				location.replace('login.asp');
			}, 0);
		}
	}
		
	var ajax_param = {
		type: 	"POST",
		async:	false,
		url: 	param.url,
		data: 	param.arg,
		dataType: "xml",
		success: function(data) {
			gConfig = data;
		},
		error: function(xhr, ajaxOptions, thrownError){
			if (xhr.status == 200) {
				try {
					setTimeout(function() {
						document.write(xhr.responseText);
					}, 0);
				} catch (e) {
				}
			} else {
			}
		}
	};
	
	try {
		//setTimeout(function() {
			$.ajax(ajax_param);
		//}, 0);
	} catch (e) {
	}
}

/**
 *	config_val() : get config value of the input tag name
 *
 *	Parameter(s) :
 *		name : tag name
 *
 * Return : the node value of the input tag name.
 *
 **/
function config_val(name)
{
	return get_node_value(gConfig, name);
}

function config_attr(name)
{
	return get_node_attribute(gConfig, name);
}

function config_inst(name)
{
	var attr = config_attr(name);
	var inst = attr.split(",");

	return inst;
}

/**
 *	config_str() : Get config string of the input tag name.
 *				   It will be shown on page directly.
 *
 *	Parameter(s) :
 *		name : tag name
 *
 * Return : the node string of the input tag name.
 *
 **/
function config_str(name)
{
	return document.write(get_node_value(gConfig, name));
}


function config_str_multi(name)
{
	var obj = $(gConfig).find(name);
	var size = obj.size();
	
	if (size == 0)
		return null;
		
	var i=0;
	var r = new Array(size);
	
	for (i=0; i<size; i++) {
		r[i] = obj.eq(i).text();
	}
	return r;
}

function config_inst_multi(name)
{
	name += " ";
	var obj = $(gConfig).find(name);
	var size = obj.size()
	
	if (size == 0)
		return null;

	var i=0;
	var r = new Array(size);

	for (i=0; i<size; i++) {
		//r[i] = $(gConfig).find(name).eq(i).attr("inst");
		var tmp = obj.eq(i).attr("inst");
		r[i] = tmp.split(",");
		//alert("test("+name +") ="+ $(gConfig).find(name).eq(i).attr("inst"));
	}

	return r;
}

function inst_array_to_string(inst)
{
	var size = inst.length;
	var string = "";
	for(var i=0; i<size; i++)
	{
		string += inst[i];
	}
	//alert("string = "+ string);
	return string;
}

/*function config_val_by_inst(obj_name, param_name, inst)
{
	if ($(gConfig).find(name).size() == 0)
		return null;
	var size = $(gConfig).find(name).size()
	var i=0;

	for
}*/

/**
 *	make_req_entry
 *
 *	obj_name:	name of obj (ex: schRule_RuleName_)
 *	obj_value:	value of obj
 *	obj_inst:	instance of obj (ex: 11000 or 1.1.0.0.0)
 *
 *	return: entry name of the element
 */
function make_req_entry(obj_name, obj_value, obj_inst)
{
	var r = obj_name;
	var s = new String(obj_inst);

	// instance already contains 'dot'
	if (s.indexOf('.') != -1) {
		r += obj_inst+'='+obj_value;
		return r;
	}
	
	for (var i=0; i<obj_inst.length-1; i++) {
		r += (s.substr(i, 1) + '.');
	}
	
	r += s.substr(obj_inst.length-1, 1);
	r += '='+obj_value;
	
	return r;
}

/**
 *	get_router_info
 *
 *	return:	a object has the following elements.
 *
 *	parameters:
 *		hw_ver:	router's hardware version
 *		sw_ver:	router's firmware version
 *		model:	device model
 *		login_info:	current user's grant
 */
function get_router_info() 
{
	var param1 = {
		url: "misc.ccp",
		arg: "action=getmisc"
	};
	get_config_obj(param1);
	
	var info = {
		'hw_ver':		config_val("hw_version"),
		'fw_ver':		config_val("version"),
		'ver_date':		config_val("version_date"),
		'model':		config_val("model"),
		'login_info':	config_val("login_Info"),
		'cli_mac':		config_val("cli_mac"),
		'graph_auth':	config_val("graph_auth"),
		'lanIP':		config_val('lan_ip'),
		'lanMask':		config_val('lan_mask'),
		'es_conf': 		config_val('es_configured')
	};
	
	setTimeout('redirect_login()', (180*1000));

	if (typeof(page_title) != "undefined") {
		document.title = LangMap.which_lang[page_title];
	}
	
	return info;
}

/**
 *	check_addr_order
 *	
 *	return: true: 	start ip is behind end ip
 *			false: 	start ip is after end ip
 *
 *	parameters:
 *		ip_s:	a string of start ip
 *		ip_e:	a string of end ip
 */
function check_addr_order(ip_s, ip_e)
{
	var arr_ips = ip_s.split('.');
	var arr_ipe = ip_e.split('.');

	if (arr_ips == null || arr_ipe == null || 
		arr_ips.length != 4 || arr_ipe.length != 4) {
		return false;
	}
	
	for (var i=0; i<4; i++) {
		if (arr_ips[i] > arr_ipe[i])
			return false;
	}
	
	return true;
}

/**
 *	check_addr
 *	
 *	return: true: 	input ip is a LAN IP
 *			false: 	input ip is NOT a LAN IP
 *
 *	parameters:
 *		ip:		a string of ip we want to check
 *		lanip:	a string of lan ip
 *		mask:	subnet mask
 */
function check_addr(ip, lanip, mask)
{
	if (ip == null || lanip == null || mask == null)
		return false;

	var arr_ip 		= ip.split('.');
	var arr_lanip 	= lanip.split('.');
	var arr_mask	= mask.split('.');
	var err = 0;
	
	// input is not an IP
	if (arr_ip == null || arr_ip.length != 4) {
		alert(msg[INVALID_IP]);
		return false;
	}
	
	// check the ip is "0.0.0.0" or not
	if (ip[0] == "0" && ip[1] == "0" && ip[2] == "0" && ip[3] == "0"){
		alert(msg[INVALID_IP]);
		return false;
	}
	
	for (var i=0; i<4; i++) {
		if ((arr_ip[i] & arr_mask[i]) == 0) {
			if (arr_ip[i] != 0)
				continue;
		}
		
		if (arr_ip[i] == arr_lanip[i])
			continue;
		err++;
	}
	
	if (err > 0)
		return false;
	else
		return true;
}

/**
 *	getUrlEntry
 *	
 *	return: string: 	value of input key
 *			null: 		not found
 *
 *	parameters:
 *		key:		a string we want to find in url entry
 */
function getUrlEntry(key)
{
	var search=location.search.slice(1);
	//alert(search);
	var my_id=search.split("&");
	//alert(my_id);
	try {
		for(var i=0;i<my_id.length;i++)
		{
			var ar=my_id[i].split("=");
			if(ar[0]==key)
			{
				return ar[1];
			}
		}
	} catch (e) {
	}
	
	return null;
} 

function redirect_login()
{
	var file = window.location.pathname.replace(/^.*\/(\w{2})\.asp$/i, "$1").replace('/', '');
	
	for (var i=0; i<noRedirectLogin.length; i++) {
		if (file == noRedirectLogin[i])
			return;
	}

	document.cookie = 'hasLogin=0;';
	
	setTimeout(function() {
		location.replace('login.asp');
	}, 0);
}

function set_host_list( ref )
{
	var allHostName = config_val("igdLanHostStatus_HostName_").split("/");
	var allHostIp = config_val("igdLanHostStatus_HostIPv4Address_").split("/");
	var allHostMac = config_val("igdLanHostStatus_HostMACAddress_").split("/");
	var allHostType = config_val("igdLanHostStatus_HostAddressType_").split("/");
	
	if(allHostIp != null)
	{
		for (var i=0; i<allHostIp.length; i++)
		{
			if(ref == 'ip')
			{
				if(allHostIp[i] != '')
					document.write('<option value='+allHostIp[i]+'>'+allHostName[i]+'('+allHostIp[i]+')</option>');
			}
			else if(ref == 'mac')
			{
				if(allHostMac[i]!= '')
					document.write('<option value='+allHostMac[i]+'>'+allHostName[i]+'('+allHostMac[i]+')</option>');
			}
			else
				document.write('<option value='+allHostName[i]+'>'+allHostName[i]+'</option>');
		}
	}
}

function get_host_list( ref )
{
	var allHostName = config_val("igdLanHostStatus_HostName_").split("/");
	var allHostIp = config_val("igdLanHostStatus_HostIPv4Address_").split("/");
	var allHostMac = config_val("igdLanHostStatus_HostMACAddress_").split("/");
	var allHostType = config_val("igdLanHostStatus_HostAddressType_").split("/");
	
	if(allHostIp != null)
	{
		for (var i=0; i<allHostIp.length; i++)
		{
			if(allHostName[i] == '')
			continue;

			if(allHostName[i] == 'Unknowable')
				continue;

			if(ref == 'ip')
			{
				if(allHostIp[i] != '')
					document.write('<option value='+allHostIp[i]+'>'+allHostName[i]+'('+allHostIp[i]+')</option>');
			}
			else if(ref == 'mac')
			{
				if(allHostMac[i]!= '')
					document.write('<option value='+allHostMac[i]+'>'+allHostName[i]+'('+allHostMac[i]+')</option>');
			}
			else
				document.write('<option value='+allHostName[i]+'>'+allHostName[i]+'</option>');
			
	}
}
	
}
function set_host_list_1( ref )
{
	var allHostName = config_val("igdLanHostStatus_HostName_").split("/");
	var allHostIp = config_val("igdLanHostStatus_HostIPv4Address_").split("/");
	var allHostMac = config_val("igdLanHostStatus_HostMACAddress_").split("/");
	var allHostType = config_val("igdLanHostStatus_HostAddressType_").split("/");
	
	var list_str = "";
	
	if(allHostIp != null)
	{
		for (var i=0; i<allHostIp.length; i++)
		{
			if(allHostName[i] == '')
				continue;
			
			if(allHostName[i] == 'Unknowable')
				continue;
			
			if(ref == 'ip')
			{
				if(allHostIp[i] != '')
					list_str += '<option value='+allHostIp[i]+'>'+allHostName[i]+'('+allHostIp[i]+')</option>';
			}
			else if(ref == 'mac')
			{
				if(allHostMac[i]!= '')
					list_str += '<option value='+allHostMac[i]+'>'+allHostName[i]+'('+allHostMac[i]+')</option>';
			}
			else
				list_str += '<option value='+allHostName[i]+'>'+allHostName[i]+'</option>';
		}
	}
	
	return list_str;
}

function do_logout() {
	document.cookie = 'hasLogin=0;';
	
	var param1 = {
		url: "login.ccp",
		arg: "act=logout"
	};
	
	var ajax_param = {
		type: 	"POST",
		async:	false,
		url: 	"login.ccp",
		data: 	"act=logout",
		success: function(data) {
			document.write(data);
		},
		error: function(xhr, ajaxOptions, thrownError){
			if (xhr.status == 200) {
				try {

					document.write(xhr.responseText);
				} catch (e) {
				}
			} else {
			}
		}
	};

	try {
		//setTimeout(function() {
			$.ajax(ajax_param);
		//}, 0);
	} catch (e) {
	}
}

function urlencode(text){
	text = text.toString();
	var matches = text.match(/[\x90-\xFF]/g);
	if (matches)
	{
		for (var matchid = 0; matchid < matches.length; matchid++)
		{
			var char_code = matches[matchid].charCodeAt(0);
			text = text.replace(matches[matchid], '%u00' + (char_code & 0xFF).toString(16).toUpperCase());
		}
	}
	//return escape(text).replace(/\+/g, "%2B");
	return text.replace(/[<>\&\"\'\=\%]/g, function(c) { return '%' + (c.charCodeAt(0) & 0xFF).toString(16).toUpperCase() + ''; });
}

function disableDiv(divname, opt)
{
	var divObj=document.getElementById(divname);
	var elInput = divObj.getElementsByTagName("input");
	for(i=0;i<elInput.length;i++)
	{
		elInput[i].disabled=opt;
	}
}


/**
 * the following 2 functions are used to check if port range is overlapped
 *
 * add_into_timeline()
 * 
 * parameters:
 * 		timeline: 	an input variable for recording all port range.
 *		port_s:		start port of the range.
 *		port_e:		end port of the range. (if single port, this parameter should be empty or null)
 *
 * return:
 * 		timeline:	timeline for the following reference.
 */
function add_into_timeline(timeline, port_s, port_e)
{
	var cur_state = 0;
	
	// inital
	if (timeline == null || timeline == '') {
		if (port_e == null || port_e == '') {
			timeline = new Array(2);
			timeline[0] = port_s;
			timeline[1] = 0;			// single port
		} else {
			timeline = new Array(4);
			timeline[0] = port_s;
			timeline[1] = 1;			// up
			timeline[2] = port_e;
			timeline[3] = 2;			// down
		}
		return timeline;				// successfully added into timeline
	}
	
	// check if there exist something wrong in timeline
	var rec_port_s = 0;
	var length = timeline.length;
	for (var i=0; i<length; i+=2) {
		// add port_s first
		if (parseInt(timeline[i]) > parseInt(port_s) && rec_port_s == 0) {
			if (port_e == null || port_e == '')	{ 	//single port
				timeline.splice(i, 0, 0);			// add state first
				timeline.splice(i, 0, port_s);		// add port number
				return timeline;					// successfully added into timeline
			} else {
				var addPort_e = false;
				rec_port_s = 1;
				timeline.splice(i, 0, 1);			// add state first
				timeline.splice(i, 0, port_s);		// add port number
				for (var j=i; j<timeline.length; j+=2) {
					if (parseInt(timeline[j]) > parseInt(port_e)) {
						timeline.splice(j, 0, 2);			// add state first
						timeline.splice(j, 0, port_e);		// add port number
						addPort_e = true;
						return timeline;
					}
				}
				
				if (addPort_e == false) {
					var append_idx = timeline.length;
					timeline.splice(append_idx, 0, 2);
					timeline.splice(append_idx, 0, port_e);
					return timeline;
				}
				continue;
			}
		}
		
		if (rec_port_s == 0)
			continue;
		
		// add port_e
		if (parseInt(timeline[i]) > parseInt(port_e)) {
			timeline.splice(i, 0, 2);			// add state first
			timeline.splice(i, 0, port_e);	// add port number
			break;
		}
	}
	
	if (timeline.length == length) {			// append to last of timeline
		if (port_e == null || port_e == '') {	// single port
			timeline.splice(length, 0, 0);
			timeline.splice(length, 0, port_s);
		} else {
			timeline.splice(length, 0, 2);
			timeline.splice(length, 0, port_e);
			timeline.splice(length, 0, 1);
			timeline.splice(length, 0, port_s);
		}
	}
	
	return timeline;
}

/**
 * 	check_timeline()
 *
 *	parameter:
 *		timeline:	an input timeline for checking.
 *
 *	return:
 *		true:		no overlapped.
 *		false:		contains an overlapped.
 */
function check_timeline(timeline)
{
	var prev_port = -1;
	var prev_stat = 0;
	
	if (timeline == null || timeline == '')
		return true;

	for (var i=0; i<timeline.length; i+=2) {
		if (prev_port == parseInt(timeline[i]))
			return false;
		
		if (prev_stat == 1 && timeline[i+1] != 2)
			return false;
		
		prev_port = timeline[i];
		if (timeline[i+1] != 0)
			prev_stat = timeline[i+1];
	}
	
	return true;
}

function translateFormObjToAJAXArg(form_id)
{
	var df = document.forms[form_id];
	if (!df) {
		return;
	}
	
	var str = "";
	for (var i = 0, k = df.elements.length; i < k; i++) {
		var obj = df.elements[i];

		var name = obj.name;
		var value = obj.value;
		
		str +="&"+name+"="+value;
	}
	
	return str;
}

function check_hw_nat_enable()
{
	if(get_checked_value(get_by_id('HW_NAT_Enable')) == "1")
	{
		if((spi_enable == "1") || (trafficshap_enable == "1"))
			return confirm(get_words("alert_hw_nat_1"));
	}
	return true;
}

function escape(text)
{
	return text.replace(/[<>\&\"\']/g, function(c) { return '&#' + c.charCodeAt(0) + ';'; });
}

function json_ajax(param)
{
	var myData = null;
	var ajax_param = {
		type: 	"POST",
		async:	false,
		url: 	param.url,
		data: 	param.arg,
		dataType: "json",
		success: function(data) {
			if (data['status'] != 'fail') {
				myData = data;
				return;
			}
			
			alert('Error: '+drws_err[data['errno']]);
			
			if (data['errno'] == '5003' ||
				data['errno'] == '5101' ||
				data['errno'] == '5103' ||
				data['errno'] == '5104') {
				var cnt = parseInt($.cookie('fail'));
				$.cookie('fail', cnt + 1);
				location.replace('login.asp');
			}
		},
		error: function(xhr, ajaxOptions, thrownError){
			if (xhr.status == 200) {
				try {
					setTimeout(function() {
						document.write(xhr.responseText);
					}, 0);
				} catch (e) {
				}
			} else {
			}
		}
	};
	
	try {
		//setTimeout(function() {
			$.ajax(ajax_param);
			return myData;
		//}, 0);
	} catch (e) {
	}	
}

/*									*/
/******** use for web access ********/
/*									*/


/**
 *	create_http_request() : create a XMLHttpRequest object to communicate with the Web server
 *
 *	Parameter(s) :
 *		NULL
 *
 * Return :	a XMLHttpRequest object
 * 	
 **/
function create_http_request(){
	var http_request = false;
	
	if (window.XMLHttpRequest) { // Mozilla, Safari,...
		http_request = new XMLHttpRequest();
		
		/* For compatibility with some versions of some Mozilla browsers, 
		 * to ensure that browsers can work properly.
		 */
		if (http_request.overrideMimeType){
			http_request.overrideMimeType('text/xml');
		}
		
		return http_request;
	}

	if (window.ActiveXObject){ // IE
		try {
			http_request = new ActiveXObject("Msxml3.XMLHTTP");
		}catch(e){
			try{
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e){				
				return false;
			}
		}
		return http_request;
	}

	return false;
}

function get_lang_xml(){
	var my_lang = "en";
	var lang_xml;
	
	lang_xml = load_xml("xml/multi_lang.xml");	
	
	return get_node_value(lang_xml, "lang");
}

/**
 *	load_lang_obj() : create Lang_Obj, Msg_Obj for displaying words, warning messages, and model's information
 *
 *	Parameter(s) :
 *		NULL
 *
 * Variable(s) :
 *		lang_obj	 :	a XML object which contains words displaying on GUI
 *    msg_obj   : a XML object which contains warning messages
 *		html_obj	 : a XML object which contains html information
 * Return :	NULL
 * 	
 **/
function load_lang_obj(){	
	var which_lang = get_lang_xml();	
	
	lang_obj = new Lang_Obj(which_lang);
	msg_obj = new Msg_Obj(which_lang);
	html_obj = new Html_Obj();
	
	document.oncontextmenu = disable_right_btn;	// disable the mouse's right button
	document.onkeypress = key_handler;
}

function get_login_info(which_setting){
	var xml_request = new XMLRequest(get_settings_xml);
	var para = "request=" + arguments[0] + "&request=load_settings";

	for (var i = 1; i < arguments.length; i++){
		para += "&table_name=" + arguments[i];
	}
							
	xml_request.exec_cgi(para);
}

/**
 *	check_user_info() : to check if the user has login yet
 *
 *	Parameter(s) :
 *		redirect_page : a XML's element object which contains a redirect page
 *
 * Return :	True or False
 * 	
 **/
function check_user_info(redirect_page){
	var which_page;
	
	if (redirect_page != null){	
		which_page = redirect_page.firstChild.nodeValue;
		location.href = html_obj.get_value(which_page);				
		return 0;
	}
	
	return 1;
}

function encode_base64(str) {
	return encode(str, str.length); 
}

function encode (psstrs, iLen) {
	var map1="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
   var oDataLen = (iLen*4+2)/3;
   var oLen = ((iLen+2)/3)*4;
   var out = '';
   var ip = 0;
   var op = 0;
   
   while (ip < iLen) {
      var xx = psstrs.charCodeAt(ip++);
      var yy = ip < iLen ? psstrs.charCodeAt(ip++) : 0;
      var zz = ip < iLen ? psstrs.charCodeAt(ip++) : 0;
      var aa = xx >>> 2;
      var bb = ((xx &   3) << 4) | (yy >>> 4);
      var cc = ((yy & 0xf) << 2) | (zz >>> 6);
      var dd = zz & 0x3F;
      out += map1.charAt(aa);
      op++;
      out += map1.charAt(bb);
      op++;
      out += op < oDataLen ? map1.charAt(cc) : '='; 
      op++;
      out += op < oDataLen ? map1.charAt(dd) : '='; 
      op++; 
   }
   
   return out; 
}

function check_user_level(which_level){
	if (which_level == "0"){	// if the level is the user level
		
		is_submit = true;		// prevent users click the apply button
		disable_all_items(true);
		
		if (get_by_id("user_only")){
			get_by_id("user_only").style.display = "";
		}
	}
}

function encode_char(encode_str){
	var str = "";
	
	for (var i = 0; i < encode_str.length; i++){
		var ch = encode_str.substring(i, i+1);
		var find = false;
		
		for (var j = 0; j < encoding_char.length; j++){
			if (ch == encoding_char[j]){
				find = true;
			}		
		}
		
		if (find){
			str += "%" + ascii_to_hex(ch);
		}else{
			str += ch;
		}		
	}
	
	return str;
}

function ascii_to_hex(ascii){
	var hex = "";
						
	for (var i = 0; i < ascii.length; i++){
		var dec = ascii.charCodeAt(i);
		var str = "";
		
		str = parseInt(dec / 16, 10);	
		
		if (str > 9){
			str = String.fromCharCode(str + 55);
		}
						
		if ((dec % 16) > 9){
			str += String.fromCharCode((dec % 16) + 55);				
		}else{
			str += (dec % 16) + "";
		}
			
		hex += str;				
	}			
		
	return hex;
}

function disable_all_items(is_disable){
	var input_objs = document.getElementsByTagName("input");
	var select_objs = document.getElementsByTagName("select");

	if (input_objs != null){
		for (var i = 0; i < input_objs.length; i++){
			input_objs[i].disabled = is_disable;
		}
	}

	if (select_objs != null){
		for (var i = 0; i < select_objs.length; i++){
			select_objs[i].disabled = is_disable;
		}
	}
}

/**
 *	check_name()  :	check the input data shouldn't include "/"
 *
 *	Parameter(s) :
 *		data		 :	data that you want to check
 *			 
 * Return : if the input data doesn't include "/", return true else return false
 * 	
 **/
function check_name(data){	
	for (var i = 0; i < data.length; i++){	
		var temp_char = data.charCodeAt(i);
		
		if (temp_char == 47){	// if the character is "/"
			return false;
		}
	}
	return true;
}


/**
 *	check_ascii()  :	check the input data is in the ascii range or not
 *
 *	Parameter(s) :
 *		data		 :	data that you want to check
 *			 
 * Return : if the input data is in the ascii range, return true else return false
 * 	
 **/
function check_ascii(data){
	
	for (var i = 0; i < data.length; i++){	
		var temp_char = data.charCodeAt(i);
		
		if (temp_char < 32 || temp_char > 126){	// if the character is less than a space(0x20) or greater than ~(0x7F)
			return false;
		}
	}
	
	return true;
}
