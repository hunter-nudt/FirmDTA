<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />	
<meta http-equiv='X-UA-Compatible' content='IE=9; requiresActiveX=true' >
<title></title>	
<link rel="stylesheet" type="text/css" href="reset.css" />
<link rel="stylesheet" type="text/css" href="web_file_access.css" />
<script type="text/javascript" src="js/webfile.js"></script>
<link rel="stylesheet" type="text/css" href="fancybox/style.css" />
<link rel="stylesheet" type="text/css" href="layout.css" />
<link rel="stylesheet" type="text/css" href="fancybox/jquery.fancybox-1.3.4.css" media="screen" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="jquery.mousewheel.js"></script>
<script type="text/javascript" src="jquery.jscrollpane.min.js"></script>
<script type="text/javascript" src="fancybox/jquery.fancybox-1.3.4.pack.js"></script>
<script type="text/javascript" src="fancybox/json2.js"></script>
<script type="text/javascript" src="js/object.js"></script>
<script type="text/javascript" src="js/xml.js"></script>
<script type="text/javascript" src="uk.js"></script>
<script type="text/javascript" src="public.js"></script>
<script type="text/javascript" src="pandoraBox.js"></script>
<script type="text/javascript" src="md5.js"></script>
<script type="text/javascript" src="jquery.cookie.pack.js"></script>
<script type="text/javascript" src="js/jquery.form.min.js"></script>
<style type="text/css">
.progress { position:relative; width:370px; border: 1px solid #ddd; padding: 1px; border-radius: 3px; }
.bar { background-color: DarkOrange; width:0%; height:20px; border-radius: 3px; }
.percent { position:absolute; display:inline-block; top:3px; left:48%; }
</style>
<script type="text/javascript">
	document.title = get_words('webf_title');
	var current_path;
	var current_volid;
	var usb_list = new Array();
	var storage_user = new HASH_TABLE();
	var root_info;
	var file_info;
//	var dir_info;
	
	var pageoffset=1;
	var bg_pageoffset=1;
	var maxcount=50;
	var scrolldata_right;
	var scrolldata_left;
	var load=false;
	var bg_load=false;
	var bg_get_sucess = false;
	
	var click_id;
	var pre_click_id;
	
	var left_str_top="<div>"
					+"<ul class=\"jqueryFileTree\">"
					+"<li class=\"toexpanded\">"+get_words('webf_hd')+"</li>"
					+"<li>"
	var left_str_end="</li></ul></div>";
				
	var session_id  = $.cookie('id');
	var session_tok = $.cookie('key');

	//load_lang_obj();	// you have to load language object for displaying words in each html page and load html object for the redirect or return page

	var images = {
					"file" 	:	"webfile_images/file.png",
					"3GP" 	:	"webfile_images/film.png",
					"AVI"	:	"webfile_images/film.png",
					"MOV"	:	"webfile_images/film.png",
					"MP4"	:	"webfile_images/film.png",
					"MPG"	:	"webfile_images/film.png",
					"MPEG"	:	"webfile_images/film.png",
					"WMV"	:	"webfile_images/film.png",
					"M4P"	:	"webfile_images/music.png",
					"MP3"	:	"webfile_images/music.png",
					"OGG"	:	"webfile_images/music.png",
					"WAV"	:	"webfile_images/music.png",
					"ASP"	:	"webfile_images/code.png",
					"ASPX"	:	"webfile_images/code.png",
					"C"		:	"webfile_images/code.png",
					"H"		:	"webfile_images/code.png",
					"CGI"	:	"webfile_images/code.png",
					"CPP"	:	"webfile_images/code.png",
					"VB"	:	"webfile_images/code.png",
					"XML"	:	"webfile_images/code.png",
					"CSS"	:	"webfile_images/css.png",
					"BAT"	:	"webfile_images/application.png",
					"COM"	:	"webfile_images/application.png",
					"EXE"	:	"webfile_images/application.png",
					"BMP"	:	"webfile_images/picture.png",
					"GIF"	:	"webfile_images/picture.png",
					"JPG"	:	"webfile_images/picture.png",
					"JPEG"	:	"webfile_images/picture.png",
					"PNG"	:	"webfile_images/picture.png",
					"PCX"	:	"webfile_images/picture.png",
					"TIF"	:	"webfile_images/picture.png",
					"TIFF"	:	"webfile_images/picture.png",
					"DOC"	:	"webfile_images/doc.png",
					"DOCX"	:	"webfile_images/doc.png",
					"PPT"	:	"webfile_images/ppt.png",
					"PPTX"	:	"webfile_images/ppt.png",
					"XLS"	:	"webfile_images/xls.png",
					"XLSX"	:	"webfile_images/xls.png",
					"HTM"	:	"webfile_images/html.png",
					"HTML"	:	"webfile_images/html.png",
					"PHP"	:	"webfile_images/php.png",
					"JAR"	:	"webfile_images/java.png",
					"JS"	:	"webfile_images/script.png",
					"PL"	:	"webfile_images/script.png",
					"PY"	:	"webfile_images/script.png",
					"RB"	:	"webfile_images/ruby.png",
					"RBX"	:	"webfile_images/ruby.png",
					"RUBY"	:	"webfile_images/ruby.png",
					"RHTML"	:	"webfile_images/ruby.png",
					"RPM"	:	"webfile_images/linux.png",
					"PDF"	:	"webfile_images/pdf.png",
					"PSD"	:	"webfile_images/psd.png",
					"SQL"	:	"webfile_images/db.png",
					"SWF"	:	"webfile_images/flash.png",
					"LOG"	:	"webfile_images/txt.png",
					"TXT"	:	"webfile_images/txt.png",
					"ZIP"	:	"webfile_images/zip.png",
					"RAR"	:	"webfile_images/zip.png",
					"7Z"	:	"webfile_images/zip.png",
					"GZ"	:	"webfile_images/zip.png",
					"BZ2"	:	"webfile_images/zip.png"
	};
		
	$(document).ready(function() {

		$("#right").css('height', $(window).height()-122);	
		$("#left2").css('height', $(window).height()-122);	
		$(window).resize(function(){
			$("#right").css('height', $(window).height()-122);
			$("#left2").css('height', $(window).height()-122);	
		});	
		
		$("#right").jScrollPane({autoReinitialise: true}).bind('jsp-scroll-y', scrollHandler);
		scrolldata_right = $("#right").data('jsp'); 
				
		$('#right').hover(
			function (){
			$('#right').find('.jspDrag').stop(true, true).fadeIn('slow');
		}, 
			function (){
			$('#right').find('.jspDrag').stop(true, true).fadeOut('slow');
		});
		
		$("#left2").jScrollPane({autoReinitialise: true});
		scrolldata_left = $("#left2").data('jsp'); 
		
		$('#left2').hover(
			function (){
			$('#left2').find('.jspHorizontalBar, .jspVerticalBar').stop().fadeTo('fast', 0.9);
		}, 
			function (){
			$('#left2').find('.jspHorizontalBar, .jspVerticalBar').stop().fadeTo('fast', 0);
		});
		
		$("a[id=button1]").fancybox({
			'showCloseButton'	: false,
			'hideOnOverlayClick' : false,
			'overlayShow'		: true
		});

		$(".uploadtab").css("background-color", "#808080");
		$(".uploadtab").css("background-color", "#808080");
 
	});

	function close_fancybox(){
		$.fancybox.close();
	}

	function ctxClick(path, ulId, type)
	{
		var pId = ulId.substring(0, ulId.lastIndexOf('/'));

		try {
			var classes = $('#'+transUid(pId)).parent().find('div').attr('class').split(' ');
			if (classes != null) {
				for (var i=0; i<classes.length; i++) {
					if (classes[i] != 'expandable-hitarea')
						continue;
					$('#'+transUid(pId)).parent().find('div').click();
					break;
				}
			}
		} catch (e) {
			
		}
		$('#'+transUid(ulId)).parent().find('div').click();
		
		if (type == "2")	// add folder
			$('#'+transUid(ulId)).parent().find('div').click();

	}

	function delay_refresh_ctx()
	{
		ctxClick(current_path, current_volid, "2");
	}
	
	function delete_file_result(http_req)
	{
		var my_txt = http_req;			
		var result_info;
	
		try {
			result_info = my_txt;
		} catch(e) {				
			return;
		}
			
		if (result_info.status == "ok" && result_info.error == null){	
			get_sub_folder(current_path, current_volid);
		}
	}	
	
	function create_folder_result(http_req){
		var my_txt = http_req;
		var result_info;

		try {
			result_info = my_txt;
		} catch(e) {
			return;
		}

		close_fancybox();

		if (result_info.status == "ok" && result_info.error == null){
			get_sub_folder(current_path, current_volid);
		}
		$('#folder_name').val("");
	}

	function gen_rand_num(len)
	{
		var rand = '';
		for (var i=0; i<len; i++) {	
			var num = Math.round(Math.random()*10)%10;
			rand += new String(num);
		}
		return rand;
	}

	function create_folder()
	{
		var folder_name = $('#folder_name').val();
		var cur_path = current_path.split("%2F");
		if(cur_path.length>1)
			var dev_path = cur_path[0] + cur_path[1] + "/";
		else
			var dev_path = cur_path[0] + "/";
		data = APIAddDir(dev_path, current_volid, folder_name);
		create_folder_result(data);
	}

	function show_folder_content(which_info, path, volid)
	{	
		var rtable = get_by_id("rtable");
		var sum = 0;
		
		try {
			file_info = which_info;
		} catch(e) {
			return;
		}
		if(pageoffset == 1)
		{
			if (rtable.rows.length > 0)
			{
				for (var i = rtable.rows.length; i > 0; i--)
				{
					rtable.deleteRow(i-1);
				}
			}
		}
		else
			sum = rtable.rows.length;

		for (var i = 0; i < which_info.count; i++)
		{			
			var obj = which_info.files[i];
			var desp = obj.desp.toUpperCase();
			var file_name = obj.name;				
			var file_path = current_path + "/" + file_name;
			var dev_name = file_path;	// to get the usb name,new api not contain %2f
			var new_path = dev_name;
			var row;
		
			if (file_name == "")
			{
				continue;
			}

			for (var j = 0; j < 1; j++)
			{
				var insert_cell; // create a cell
				var cell_html;

				if (obj.type != 1)
				{
					row = rtable.insertRow(rtable.rows.length);
					
					insert_cell = row.insertCell(j);

					//Tin add to convert time of last modification 20120514
					var isFirefox = navigator.userAgent.search("Firefox") > -1; 
					var isIE = navigator.userAgent.search("MSIE") > -1; 
					
					var file_mtime = (obj.mtime)*1000;
					var tmp = new Date();
					var m_time = tmp.setTime(file_mtime);
					m_time = tmp.toLocaleString();
					var ary = m_time.split(" ");
					if((isIE) || (isFirefox ))
						m_time = ary[0] +" "+ ary[1] + " " + ary[2];
					else
						m_time = ary[0] +" "+ ary[1]; // + " " + ary[2] + " " + ary[4] + " " + ary[3];
					
					cell_html = "<input type=\"checkbox\" id=\"" + sum + "\" name=\"" + file_name + "\" value=\"1\" class=\"chk\" onclick=\"shiftkey(event);\" />"
								+"<a href=\"" + APIGetFileURL(path,volid,file_name) + "\" target=\"_blank\">"
								+ "<div>"
								+ file_name + "<br>" + get_file_size(obj.size) + ", " + m_time
								+ "</div></a>";
					sum = sum + 1;
				}
				else
				{
					break;
				}

				switch(j)
				{

					case 0:	// Name
					insert_cell.id = "rname";							
					insert_cell.className = "tdbg";
					insert_cell.innerHTML = cell_html;					
					break;

				}
			}
			//$('#loading').hide();
		}
		if(file_info.count == maxcount)
			load=true;
		//show_content_height();

		}

	function get_sub_tree(which_info){
		var my_tree = "<ul class=\"jqueryFileTree\">";

		for (var i = 0; i < which_info.count; i++){
			var obj = which_info.dirs[i];
			var obj_path = current_path + "/" + obj.name;
			
			//20121214 pascal add for fixing ' and " folder name issue
			var path_fname = obj_path;
				path_fname = path_fname.replace(/'/ig, "&quot;63545&quot;");
				path_fname = path_fname.replace(/"/ig, '&quot;');
			var li_id = path_fname;
/*
			if (obj.name == ".." || obj.type != 1){	// when it's not a folder
				continue;
			}
*/
			my_tree += "<li id=\"" + li_id + "\" class=\"tocollapse\">"
					+  "<a href=\"#\" title=\"" + obj.name + "\" " 
					+ "onClick=\"click_folder('" + li_id + "', '" + current_volid + "', '" +obj.mode+ "')\">"
					+ obj.name + "</a></li>"
					+ "<li></li>"
					+ "<li><span id=\"" + li_id + "-sub\"></span></li>";
		}
		my_tree += "</ul>";
		return my_tree;
	}

	function show_sub_folder(obj){
		var parent_node = get_by_id(current_path.replace(/'/ig, "\"63545\"")); //20121214 pascal use random number to instead of '
		var current_node = get_by_id(current_path.replace(/'/ig, "\"63545\"") + "-sub");
		//var file_info;

		parent_node.className = "toexpanded";

		if (obj.status == "ok" && obj.error == null){
			if(obj.count == maxcount || bg_pageoffset >1)
				current_node.innerHTML += get_sub_tree(obj);
			else
				current_node.innerHTML = get_sub_tree(obj);
			//show_folder_content(file_info);
		}
		if(obj.count == maxcount)
		{
			bg_pageoffset++;
			setTimeout('bg_get_sub_folder()', 500);
		}
	}

	function bg_get_sub_folder(path, volid)
	{
		var cur_path = path.split("%2F");
		if(cur_path.length>1)
			var new_path = cur_path[0] + cur_path[1];
		else
			var new_path = cur_path[0];
		data = APIListDir(new_path,volid);
		show_sub_folder(data);	
	}
	
	function get_sub_folder(which_path, which_volid)
	{		
		current_path = which_path.replace(/\"63545\"/ig, "'");
		current_volid = which_volid;
		
		bg_get_sub_folder(current_path, current_volid);
		
		if(!bg_get_sucess)
			return;
			
		var cur_path = which_path.replace(/\"63545\"/ig, "'").split("%2F");
		if(cur_path.length>1)
			var new_path = cur_path[0] + cur_path[1];
		else
			var new_path = cur_path[0];

		data = APIListFile(new_path, current_volid);
		//show_sub_folder(data);
		show_folder_content(data, new_path, current_volid);
	}

	function delete_folder_content()
	{
		var rtable = get_by_id('rtable');
		if (rtable.rows.length > 0){
			for (var i = rtable.rows.length; i > 0; i--){
				rtable.deleteRow(i-1);
			}
		}
			//show_content_height();
			$("#left2").css('height', $('.jqueryFileTree').height()+5);
	}
	function click_folder(path, volid, mode){
		pageoffset=1;
		bg_pageoffset=1;
		
		var obj = get_by_id(path);		
		close_fancybox();

		if (obj != undefined){
			if (mode < 2 || mode != 2){
				$('#disable_top').show();
				$('#enable_top').hide();				
			}else{
				$('#enable_top').show();
				$('#disable_top').hide();
				
			}
			if (obj.className == "toexpanded"){
				obj.className = "tocollapse";
				get_by_id(path + "-sub").innerHTML = "";
				delete_folder_content();
				current_path=path;
				current_volid=volid;
			}
			else{
				obj.className = "toexpanded";
				get_sub_folder(path, volid);
			}
		}
		
		if($('.jqueryFileTree').height() > $(window).height()-122)
			$("#left2").css('height', $(window).height()-122);
		else
			$("#left2").css('height', $('.jqueryFileTree').height()+5);
	}

	function check_upload_file(){
		var upload_name = get_by_id("upload_file").value;
		var TimeZone = -(new Date().getTimezoneOffset()/60);
		var TimeStamp = Math.round(new Date().getTime()/1000);
		var file_name;

		if (window.ActiveXObject){	// code for IE
			file_name = upload_name.substring(upload_name.lastIndexOf("\\") + 1);
		}else{
			if (upload_name.indexOf("C:\\fakepath\\") != -1){
				file_name = upload_name.substring(upload_name.indexOf("C:\\fakepath\\") + 12);
			}else{
				file_name = upload_name;
			}
		}

		var rand = gen_rand_num(32);//generate 32 bytes random number
		//UploadFile tok CAN NOT contains parameter
		var arg1 = '/dws/api/UploadFile'+rand;
		
		$('#id').val(session_id);
		$('#volid').val(current_volid);
		$('#tok').val(rand+hex_hmac_md5(session_tok, arg1));
		$('#path').val(current_path);
		$('#filename').val(file_name);
		$('#TimeZone').val(TimeZone);
		$('#TimeStamp').val(TimeStamp);

		return true;
	}

	function onPageload_dis()
	{
		$('#disable_top').show();
		$('#enable_top').hide();		
	}

	function delete_file()
	{
		var checked_flag=0;
		var str="";
		var cur_path = current_path.split("%2F");
		if(cur_path.length>1)
			var dev_path = cur_path[0] + cur_path[1];
		else
			var dev_path = cur_path[0];
		
		var cnt_file_idx=0;
		
		for (var i = 0; i < file_info.count; i++){
			var file_name = file_info.files[i].name;
			var type = file_info.files[i].type;
			if (type != 1){
				if (get_by_id(cnt_file_idx).checked){
					checked_flag = 1;
					if (str != ""){
						str += ",\"" + file_name + "\"";
					}else{
						str += "[\"" + file_name + "\"";
					}
					
				}
				cnt_file_idx++;
			}
		}
		
		if (str != "")
			str += "]";

		if (checked_flag == 0){
			alert(get_words('file_acc_del_empty'));
			return;
		}
								
		if (!confirm(get_words('file_acc_del_file')))
			return;
		
		data = APIDelFile(dev_path, current_volid, str);
		delete_file_result(data);
	}
	function get_root_info(which_info){
		var my_tree = "<ul class=\"jqueryFileTree\">";
		if (which_info.status == "ok" && which_info.error == null){	
			if (which_info.rootnode.length > 0){
				for (var i = 0; i < which_info.rootnode.length; i++){
					var obj = which_info.rootnode[i];
					//new api dont need to split obj.volname by %2F
					//var dev_name = obj.volname.split("%2F");	// to split usb_dev and usb name
					//var dev_name = obj.volname;  //Tin modify
					var usb_info = new HASH_TABLE();
					if (obj.volname == ".."){
						continue;
					}
					if(obj.nodename.length==1 && obj.nodename[0]==obj.volid){//admin
						my_tree += "<li id=\"" + obj.volname + "\" class=\"tocollapse\">"
								+  "<a href=\"#\" title=\"" + obj.volname + "\" " 
								+ "onClick=\"click_folder('" + obj.volname + "', '" + obj.volid + "', '" + obj.mode + "')\">"
								+ obj.volname + "</a></li>"
								+ "<li></li>"
								+ "<li><span id=\"" + obj.volname + "-sub\"></span></li>";

						usb_info.put("volname", obj.volname);
						usb_info.put("volid", obj.volid);
						usb_info.put("status", obj.status);
						usb_info.put("nodename", obj.nodename);
						usb_list.push(usb_info);
					}
					else{
						my_tree += '<li id="'+obj.volname+'" class="toexpanded">'
								+  '<a href="#" title="'+obj.volname+'">'+obj.volname+'</a>'
								+  '</li>'
								+  '<li></li>'
								+  '<li><span id="'+obj.volname+'-sub">';

						my_tree += '<ul class="jqueryFileTree">';
						for(var j in obj.nodename){
							node = obj.nodename[j];
							my_tree	+='<li id="'+node+'" class="tocollapse">'
									+ '<a href="#" title="'+node+'" onClick="click_folder(\''+node+'\', \''+obj.volid+'\', \''+2+'\')">'
									+ node
									+ '</a>'
									+ '</li>'
									+ '<li></li>'
									+ '<li><span id="'+node+'-sub"></span></li>';
						}
						my_tree += '</ul>';
						my_tree += '</span></li>';
					}
				}
			}
		}else if (which_info.status == "fail"){
			if (which_info.error == 5002){
			my_tree += '<li class="warning">' + lang_obj.display('WS009') +'</li>';
			}else if (which_info.error == 5003){
				location.href = "login.asp";
			}
		}
		my_tree += "</ul>";
		return my_tree;
	}
	
	function show_menu_tree(which_info){
		scrolldata_left.getContentPane().html(left_str_top + get_root_info(which_info) +left_str_end);
		

	}

	function get_settings_xml(obj)
	{
		var my_txt = obj.rootnode;

		/*
		var root_info;
		
		try {
			root_info = JSON.parse(my_txt);
		} catch(e) {
			load_webfile_settings();
			return;
		}

		*/
		
		show_menu_tree(obj);
		
	}

	function load_webfile_settings()
	{
		//var xml_request = new XMLRequest(get_settings_xml);
		//var para = "ListRoot?id=" + storage_user.get("id") + "&tok=" + storage_user.get("tok");
		//xml_request.json_cgi(para);
		data = APIListRoot();
		get_settings_xml(data);
	}

	function get_login_info_result()
	{
		/*
		var my_xml = http_req.responseXML;
		if (check_user_info(my_xml.getElementsByTagName("redirect_page")[0])){
			storage_user.put("id", get_node_value(my_xml, "user_name"));
			storage_user.put("tok", get_node_value(my_xml, "user_pwd"));
			load_webfile_settings();
		}
		*/

		load_webfile_settings();
	}

	function get_login_info()
	{
		/*
		var xml_request = new XMLRequest(get_login_info_result);
		var para = "request=get_login_info";
		xml_request.exec_webfile_cgi(para);
		*/
 
		get_by_id("Image6").style.zIndex = "999";

		if (session_id == null || session_tok == null)
			location.replace('wa_login.asp');

		get_login_info_result();
	}

	function refresh_current_path(){
		close_fancybox();

		$('#upload_file').val("");
		$('#folder_name').val("");
		get_sub_folder(current_path, current_volid);
	}
	
	document.oncontextmenu=function(){
		return false;
	}
	
	function scrollHandler(event) {
		if(load && file_info.count == maxcount){
			if ((scrolldata_right.getContentHeight() - scrolldata_right.getContentPositionY()) < ($('#right').height()+5))
			{
				//$('#loading').show();
				pageoffset++;
				load=false;
				get_sub_folder(current_path, current_volid);
				
	}}
	}
	
	//20120906 pascal add allow user to use shift key
	function shiftkey(event){
		pre_click_id = click_id;
		if(event.currentTarget)
			click_id = event.currentTarget.id
		else if(event.srcElement)//IE8
			click_id = event.srcElement.id
		if(event.shiftKey)
		{
			var chk_range=$('.chk');
			chk_range.slice(Math.min(pre_click_id,click_id), Math.max(pre_click_id,click_id)+ 1).attr('checked', $('#'+click_id)[0].checked);
		}
	}

var fakeWidth=0;
var fakeHandle=0;
function fakeProgress(){
	if(fakeWidth<100){
		clearTimeout(fakeHandle);
		fakeWidth+=5;
		fakeHandle = setTimeout(function(){
			$('.bar').width(fakeWidth+'%');
			$('.percent').html(fakeWidth+'%');
			fakeProgress();
		},1000);
	}
	else
		clearTimeout(fakeHandle);
}
$(function(){
	/* upload progressbar */
	$('#form1').ajaxForm({
		resetForm: true,
		beforeSubmit: function($form, options) {
			fakeWidth=0;
			$('.bar').width('0%');
			$('.percent').html('0%');
			return check_upload_file(); 
		},
		uploadProgress: function(event, position, total, percentComplete) {
			clearTimeout(fakeHandle);
			var percentVal = (percentComplete==100?99:percentComplete) + '%';
			$('.bar').width(percentVal);
			$('.percent').html(percentVal);
		},
		success: function() {
			fakeWidth=100;
			$('.bar').width('100%');
			$('.percent').html('100%');
		},
		complete: function(xhr) {
			refresh_current_path();
			clearTimeout(fakeHandle);
			fakeWidth=0;
			$('.bar').width('0%');
			$('.percent').html('0%');
		}
	});
});


	function APIListRoot(){
		var param = {
			url: '/dws/api/ListRoot',
			arg: 'id='+session_id
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		
		var data = json_ajax(param);
		if (data == null)
			return;
		return data;
	}
	function APIListDir(path, volid){
		var param = {
			url: '/dws/api/ListDir',
			arg: 'id='+session_id+'&volid='+volid
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		param.arg += '&path='+encodeSingleQuotation(path); //encodeURIComponent urlencode
		param.arg += '&pageoffset='+bg_pageoffset+'&maxcount='+maxcount;
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		
		var data = json_ajax(param);
		if (data == null)
		{
			bg_get_sucess = false;
			return;
		}
		else
		{
			bg_get_sucess = true;
			return data;
		}
	}
	function APIListFile(path, volid){
		var param = {
			url: '/dws/api/ListFile',
			arg: 'id='+session_id+'&volid='+volid
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		param.arg += '&path='+encodeSingleQuotation(path); //encodeURIComponent urlencode
		param.arg += '&pageoffset='+pageoffset+'&maxcount='+maxcount;
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		
		var data = json_ajax(param);
		if (data == null)
			return;
		else
			return data;
	}
	function APIAddDir(path, volid, folderName){
		var param = {
			url: '/dws/api/AddDir',
			arg: 'id='+session_id+'&volid='+volid
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		param.arg += '&path='+encodeSingleQuotation(path); //encodeURIComponent urlencode
		param.arg += '&dirname='+encodeSingleQuotation(folderName)
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		//param.arg += '&dirname=' + folderName;

		var data = json_ajax(param);
		if (data == null)
			return;
		return data;
	}
	function APIDelFile(path, volid, filename){
		var param = {
			url: '/dws/api/DelFile',
			arg: 'id='+session_id+'&volid='+volid
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		param.arg += '&path='+encodeSingleQuotation(path);
		param.arg += '&filenames='+encodeSingleQuotation(filename);
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += '&tok='+rand+hex_hmac_md5(session_tok, arg1);
		
		var data = json_ajax(param);
		if (data == null)
			return;
		return data;
	}
	function APIGetFileURL(path, volid, filename){
		var param = {
			url: '/dws/api/GetFile',
			arg: 'id='+session_id+'&volid='+volid
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		param.arg += '&path='+encodeSingleQuotation(path); //encodeURIComponent urlencode
		param.arg += '&filename='+encodeSingleQuotation(filename);
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		return param.url+'?'+param.arg;
	}
	function encodeSingleQuotation(str){
		return encodeURIComponent(str).replace(/'/g,'%27');
	}
</script>
</head>
<body onLoad="get_login_info();onPageload_dis();">
	<div id="wrapper">
	<div id="header">
		<div align="right">
		<table width="100%" border="0" cellspacing="0">
			<tr>
				<th width="224" rowspan="2" scope="row"><img src="webfile_images/index_01.png" width="220" height="55" /></th>
				<th style="vertical-align:bottom;" width="715" height="30" scope="row"><a href="category_view.asp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','webfile_images/btn_menu2_.png',1)"><img src="webfile_images/btn_menu2_.png" name="Image6" width="25" height="25" border="0" align="right" id="Image6" /></a></th>
				<th width="15" scope="row"></th>
			</tr>
			<tr>
				<th scope="row"></th>
				<th scope="row"></th>
			</tr>
		</table>
		<a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','webfile_images/btn_home_.png',1)"></a>
		</div>
	</div>
	<div id="folder_top">
		<div id="left"></div>
		<div id="folder_view_right">
		<table width="670" height="29" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<th width="32" scope="row">&nbsp;</th>
			<td width="638">
			<div id="enable_top" style="">
				<a id="button1" href="#inline1"><script>document.write("<input type=\"button\" id=\"create_btn\" value=\"" + get_words('webf_folder') + "\" />");</script></a>					
				<a id="button1" href="#inline2"><script>document.write("<input type=\"button\" id=\"upload_btn\" value=\"" + get_words('tf_Upload') + "\" />");</script></a>				
				<input type="button" id="delete_btn" value='' onclick="delete_file();">
				<script>$('#delete_btn').val(get_words('_delete'));</script>
			</div>
			<div id="disable_top" style="display:none;">
				<input type='button' id='create_btn1' value='' disabled />
				<input type='button' id='upload_btn1' value='' disabled />
				<input type="button" id="delete_btn1" value='' onclick="delete_file();" disabled>
				<script>
					$('#create_btn1').val(get_words('webf_folder'));
					$('#upload_btn1').val(get_words('tf_Upload'));
					$('#delete_btn1').val(get_words('_delete'));
				</script>
			</div>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<div id="lower2">
		<div id="left2">
			<table id="ltable" width="100%" border="0" height="100%" cellspacing="0" cellpadding="0"></table>
		</div>
		<div id="right">
			<table id="rtable" width="670" border="0" cellspacing="0" cellpadding="0"></table>
			<div id="loading" style="display:none;" align="center"><img src="webfile_images/loading.gif"/></div>
		</div>		
	</div>
	<div id="footer2"><img src="webfile_images/dlink.png" width="77" height="22" /></div>
	<div style="display:none;">
		<div id="inline1" style="width:400px;height:120px;overflow:auto;">
			<div class="uploadtab" style="font-weight:bold;"><span id="creat_fd_title"></span></div>
			<script>$('#creat_fd_title').html(get_words('webf_createfd'));</script>
			<div id="creat_fd"><script>$('#creat_fd').html(get_words('webf_fd_name'));</script></div>
			<input type="text" id="folder_name" name="folder_name" size="32" style="border:1px solid #000000;">
			<br/><br/><br/>
			<div class="uploadtab" style="text-align:right;">
				<input type="button" id="ok1" name="ok1" value="" onClick="create_folder()">&nbsp; 
				<input type="button" id="cancel1" onClick="close_fancybox()" value="">
				<script>
					$('#ok1').val(get_words('_ok'));
					$('#cancel1').val(get_words('_cancel'));
				</script>
			</div>
		</div>
	</div>
	<div style="display: none;">
		<div id="inline2" style="width:400px;height:120px;overflow:auto;">
			<div class="uploadtab" style="font-weight:bold;"><span id="upload_fl_title"></span></div>
			<script>$('#upload_fl_title').html(get_words('webf_upload'));</script>
			<div id="upload_fl"></div>
			<script>$('#upload_fl').html(get_words('webf_file_sel'));</script>
			<form id="form1" method="post" action="/dws/api/UploadFile" enctype="multipart/form-data">
				<input type="hidden" id="id" name="id">
				<input type="hidden" id="tok" name="tok">
				<input type="hidden" id="volid" name="volid">
				<input type="hidden" id="path" name="path">
				<input type="hidden" id="filename" name="filename">
				<input type="hidden" id="TimeZone" name="TimeZone">
				<input type="hidden" id="TimeStamp" name="TimeStamp">
				<input type="hidden" id="upload_source" name="upload_source" value="gui">
				<input type="file" id="upload_file" name="upload_file" size="32">
				<div class="progress">
					<div class="bar"></div>
					<div class="percent">0%</div>
				</div>
				<div class="uploadtab" style="text-align:right;">
					<input type="submit" id="ok2" onclick="check_upload_file();fakeProgress()" value="">&nbsp; 
					<input type="button" id="cancel2" onClick="close_fancybox()" value="">
					<script>
						$('#ok2').val(get_words('_ok'));
						$('#cancel2').val(get_words('_cancel'));
					</script>
				</div>
			</form>
		</div>
	</div>
	</div>
</body>
</html>
