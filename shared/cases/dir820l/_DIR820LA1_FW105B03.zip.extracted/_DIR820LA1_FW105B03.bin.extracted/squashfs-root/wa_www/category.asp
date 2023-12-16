<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SharePort Web Access</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="Tue, 01 Jan 1980 1:00:00 GMT"/>		
<link rel="STYLESHEET" type="text/css" href="layout.css">
<link rel="STYLESHEET" type="text/css" href="css_router.css">
<link rel="STYLESHEET" type="text/css" href="fancybox/jquery.fancybox-1.3.4.css" media="screen" />
<script type="text/javascript" src="fancybox/jquery-1.4.3.min.js"></script>
<script type="text/javascript" src="jquery.mousewheel.js"></script>
<script type="text/javascript" src="jquery.jscrollpane.min.js"></script>
<script type="text/javascript" src="fancybox/jquery.fancybox-1.3.4.pack.js"></script>
<script type="text/javascript" src="fancybox/json2.js"></script>
<script language="JavaScript" src="js/webfile.js"></script>
<script language="JavaScript" src="js/object.js"></script>
<script language="JavaScript" src="js/xml.js"></script>
<script type="text/javascript" src="uk.js"></script>
<script language="JavaScript" src="public.js"></script>
<script language="JavaScript" src="pandoraBox.js"></script>
<script language="Javascript" src="md5.js"></script>
<script language="Javascript" src="jquery.cookie.pack.js"></script>
<script type="text/javascript">

	var media_info;
	var files = null;
	var storage_user = new HASH_TABLE();
	var pageoffset=1;
	var bg_pageoffset=1;
	var maxcount=50;
	var load=false;
	var bg_load=false;
	var scrolldata;
	
	var session_id  = $.cookie('id');
	var session_tok = $.cookie('key');
	if (session_id == null || session_tok == null)
		location.replace('login.asp');
		
	var str="";
	var bg_str="";
	var str_top="<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
	var str_end="</table><div id=\"loading\" style=\"display:none;\" align=\"center\"><img src=\"webfile_images/loading.gif\"/></div>";
		str_end+="<div id=\"footer\"><center><img src=\"webfile_images/dlink.png\" width=\"77\" height=\"22\"/></center></div>"

	//load_lang_obj();	// you have to load language object for displaying words in each html page and load html object for the redirect or return page

	function reinit_fancybox(type)
	{
		switch (type){
		case 0:
			$("a[id=music1]").fancybox({
				'width'				: '60%',
				'height'			: '60%',
				'overlayOpacity'	: 0.9,
				'overlayShow'	: true,
				'hideOnOverlayClick' : false,
				'titlePosition'	: 'inside',
				'transitionIn'	: 'fade',
				'transitionOut'	: 'fade',
				'type'	: 'iframe'
			});
			break;
		case 1:
			$("a[rel=image1]").fancybox({
				'overlayOpacity'	: 0.9,
				'overlayShow'	: true,
				'hideOnOverlayClick' : false,
				'titlePosition'	: 'inside',
				'transitionIn'	: 'fade',
				'transitionOut'	: 'fade'
			});
			break;
		case 2:
			$("a[id=movie1]").fancybox({
				'width'			: 1024,
				'height'		: 768,
				'scrolling' 	: 'no',
				'overlayOpacity': 0.9,
				'overlayShow'	: true,
				'hideOnOverlayClick' : false,
				'titlePosition'	: 'inside',
				'transitionIn'	: 'fade',
				'transitionOut'	: 'fade',
				'type'			: 'iframe'
			});
			break;
		case 3:
			break;
		}
	}

	function show_media_list(which_action){
		//var media_list = $('#media_list')[0];
				
		if (media_info == null)
			return;
			
		if (media_info.count == 0)
			return;
			
		if (media_info.status == "ok" && media_info.error == null && media_info.count != 0)
		{			
			for (var i = 0; i < media_info.count; i++)
			{
				var obj = media_info.files[i];
				var file_name = obj.name;
				str += "<tr onMouseOver=\"this.style.background='#D8D8D8'\" onMouseOut=\"this.style.background=''\">"
					 + "<td width=\"36\" height=\"36\" class=\"tdbg\">"
					 + "<img src=\"webfile_images/"+type_ln[1]+".png\" width=\"36\" height=\"36\" border=\"0\">"
					 + "</td>"
					 + "<td width=\"868\" class=\"text_2\">";

				if (type_ln[5]==3)
					str += '<a href="'+APIGetFileURL(obj.path,obj.volid,obj.name)+'" target="_blank">';
				else
					str += '<a '+type_ln[4]+' href="'+APIGetFileURL(obj.path,obj.volid,obj.name)+'" title="' + file_name + '">';

					//Tin add to convert time of last modification 20120810
					
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
					
					/*
					var file_mtime = (obj.mtime)*1000;
					var tmp = new Date();
					var m_time = tmp.setTime(file_mtime);
					m_time = tmp.getDay() + " " + tmp.getDate() + " " + tmp.getMonth() + " " + tmp.getFullYear();
					*/

				 str += "<div>"
					 + file_name +"<br>" + get_file_size(obj.size) + ", " + m_time
					 + "</div>"
					 + "</a>"
					 + "</td></tr>";
			}
			//str += "<div id=\"footer\"><center><img src=\"webfile_images/dlink.png\" width=\"77\" height=\"22\" /></div>"
			$('#loading').hide();
			scrolldata.getContentPane().html(str_top + str);
		}
		else
		{
			location.href = "login.asp";
		}

		reinit_fancybox(type_ln[5]);	// we must reinit fancybox
		load=true;
		
	}
	
	//20120904 add background loading for search box
	function show_media_list2(which_action, renew){
		var search_value = $('#search_box').val();
		
		//close scroll event & start background loading
		if(which_action)
		{			
		if(search_value.length > 0)
		{
			bg_load=true;
			
			if(renew==1)
			{
				bg_pageoffset=1;
				bg_str="";
				delay_load();
			}
			
			if(media_info.status == "ok" && media_info.error == null && media_info.count != 0)
			{			
			for (var i = 0; i < media_info.count; i++)
			{
				var obj = media_info.files[i];
				var file_name = obj.name;	

				if(file_name.indexOf(search_value) != 0)
					continue;

				bg_str += "<tr onMouseOver=\"this.style.background='#D8D8D8'\" onMouseOut=\"this.style.background=''\">"
					 + "<td width=\"36\" height=\"36\" class=\"tdbg\">"
					 + "<img src=\"webfile_images/"+type_ln[1]+".png\" width=\"36\" height=\"36\" border=\"0\">"
					 + "</td>"
					 + "<td width=\"868\" class=\"text_2\">";

				if (type_ln[5]==3)
					bg_str += '<a href="'+APIGetFileURL(obj.path,obj.volid,obj.name)+'" target="_blank">';
				else
					bg_str += '<a '+type_ln[4]+' href="'+APIGetFileURL(obj.path,obj.volid,obj.name)+'" title="' + file_name + '">';
			
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
						m_time = ary[0] +" "+ ary[1] + " " + ary[2] + " " + ary[4] + " " + ary[3];
					

				 bg_str += "<div>"
					 + file_name +"<br>" + get_file_size(obj.size) + ", " + m_time
					 + "</div>"
					 + "</a>"
					 + "</td></tr>";
			}
			scrolldata.getContentPane().html(str_top + bg_str);
			bg_pageoffset++;
			if (media_info.count == maxcount)
				setTimeout('delay_load();',500);
			}
		}
		else
		{
			str="";
			pageoffset=1;
			bg_load=false;
			get_media_list(url.split("#")[1]);
		}
		}
		//$('#loading2').hide();
	}
	
	function get_settings_xml(http_req)
	{
		/*
		
		var my_txt = http_req.responseText;

		try {
			media_info = JSON.parse(my_txt);
		} catch(e) {
			get_media_list(ary);
			return;
		}

		*/
		if(bg_load && bg_pageoffset !=1)
			show_media_list2(true);
		else if(bg_load)
			show_media_list2(false);
		else
			show_media_list(false);
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

	function get_media_list(which_media)
	{
		// currently only support single volid
		var param = {
			url: '/dws/api/ListCategory',
			arg: 'id='+session_id
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		if(bg_load)
		{
			
			param.arg += '&pageoffset='+ bg_pageoffset +'&maxcount='+maxcount;//&maxcount=50';
			pageoffset=1;
			str="";			
		}
		else
		{
			load=false;
			param.arg += '&pageoffset='+ pageoffset +'&maxcount='+maxcount;//&maxcount=50';
			bg_pageoffset=1;
			bg_str="";
		}
		
		param.arg += '&filter=' + which_media;

		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		
		var data = json_ajax(param);
		if (data == null)
			return;

		try 
		{
			files = data.files;
			media_info = data;
		} 
		catch (e) 
		{
			files = null;
			media_info = null;
			return;
		}

		get_settings_xml();
	}

	function clear_search_box(){
		$('#search_box').val("");
		show_media_list2(false);
	}

	function reset_search_box(){
		$('#search_box').val(type_ln[3]);//lang_obj.display('WS006');
		show_media_list2(false);	
	}

	function get_login_info_result(http_req){
		var my_xml = http_req.responseXML;

		if (check_user_info(my_xml.getElementsByTagName("redirect_page")[0])){

			storage_user.put("id", get_node_value(my_xml, "user_name"));
			storage_user.put("tok", get_node_value(my_xml, "user_pwd"));
			storage_user.put("volid", get_node_value(my_xml, "volid"));

			var url=window.location.toString();
			get_media_list(url.split("#")[1]);
		}
	}

	//20111229 Silvia add

	function get_login_info()
	{
		/*var xml_request = new XMLRequest(get_login_info_result);
		var para = "request=get_login_info";
		xml_request.exec_webfile_cgi(para);*/

		var url=window.location.toString();
		get_media_list(url.split("#")[1]);

		show_context();
	}

	function show_context()
	{
		$('#title_item').html(type_ln[2]); 
		var url=window.location.toString();

		var str = '<input type=text id=search_box name=search_box class=search2 value=\"';
			str += type_ln[3];
			str += ' \" onfocus=clear_search_box() onkeyup=show_media_list2(true,1) size=105>';
		$('#search_item').html(str);

		get_media_list(url.split("#")[1]);
	}

	function PageLoad()
	{
		var url=window.location.toString();
		var ary=url.split("#")[1];

		switch (ary){
		case 'music':
			//type_ln =[ary,'icon_music',lang_obj.get_word('WS001'),lang_obj.get_word('WS005'),'id=\"music1\"',0];
			type_ln =[ary,'icon_music', get_words('share_title_1'), get_words('share_ser_1'),'id=\"music1\"',0];
			break;
		case 'photo':
			//type_ln = [ary,'icon_photos',lang_obj.get_word('WS002'),lang_obj.get_word('WS006'),'rel=\"image1\"',1];
			type_ln = [ary,'icon_photos', get_words('share_title_2'), get_words('share_ser_2'),'rel=\"image1\"',1];
			break;
		case 'movie':
			//type_ln = [ary,'icon_movies',lang_obj.get_word('WS003'),lang_obj.get_word('WS007'),'id=\"movie1\"',2];
			type_ln = [ary,'icon_movies', get_words('share_title_3'), get_words('share_ser_3'),'id=\"movie1\"',2];
			break;
		case 'document':
			//type_ln = [ary,'icon_files',lang_obj.get_word('WS004'),lang_obj.get_word('WS008'),'',3];
			type_ln = [ary,'icon_files', get_words('share_title_4'), get_words('share_ser_4'),'',3];
			break;
		}
		show_context();
	}
	
	document.oncontextmenu=function(){
		return false;
	}
	
	$(document).ready(function() {
		
		$("#media_list").css('height', $(window).height()-175);	
		$(window).resize(function(){
			$("#media_list").css('height', $(window).height()-175);
		});		
		//$("#footer2").css('padding-top', 32);
		
		$("#media_list").jScrollPane({autoReinitialise: true}).bind('jsp-scroll-y', scrollHandler);
		scrolldata = $("#media_list").data('jsp'); 

		$('#media_list').hover(
			function (){
			$('#media_list').find('.jspDrag').stop(true, true).fadeIn('slow');
		}, 
			function (){
			$('#media_list').find('.jspDrag').stop(true, true).fadeOut('slow');
		});
		
	});
	
	function scrollHandler(event) {
		if(load && media_info.count == maxcount){
			if ((scrolldata.getContentHeight() - scrolldata.getContentPositionY()) < ($('#media_list').height()+5))
			{
				$('#loading').show();
				pageoffset++;
				load=false;
				var url=window.location.toString();
				get_media_list(url.split("#")[1]);
	}}}
	
	function delay_load()
	{
		var url=window.location.toString();
		get_media_list(url.split("#")[1]);
	}

	function APIGetFileURL(path, volid, fileName){
		var param = {
			url: '/dws/api/GetFile',
			arg: 'id='+session_id+'&volid='+volid
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		param.arg += '&path='+encodeSingleQuotation(path); //encodeURIComponent urlencode
		param.arg += '&filename='+encodeSingleQuotation(fileName);
		
		var arg1 = param.url+'?'+param.arg+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		return param.url+'?'+param.arg;
	}
	function encodeSingleQuotation(str){
		return encodeURIComponent(str).replace(/'/g,'%27');
	}
</script>
</head>
<body onload="MM_preloadImages('webfile_images/btn_home_.png','webfile_images/backBtn_.png','webfile_images/x.png');PageLoad();">
	<div id="wrapper">
		<div id="header">
			<div align="right">
				<table width="100%" border="0" cellspacing="0">
					<tr>
						<th width="224" rowspan="2" scope="row"><img src="webfile_images/index_01.png" width="220" height="55" /></th>
						<th width="715" height="30" scope="row"><a href="category_view.asp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','webfile_images/btn_home_.png',1)"><img src="webfile_images/btn_home_.png" name="Image6" width="25" height="25" border="0" align="right" id="Image6" /></a></th>
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
		<div id="navi">
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<th width="9%" height="42" scope="row">
						<div align="right">
							<a href="category_view.asp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('back','','webfile_images/backBtn_.png',1)"><img src="webfile_images/backBtn.png" name="back" width="70" height="30" border="0" id="back" /></a>
						</div>
					</th>
					<td width="82%" class="text_2Copy" id = "title_item"></td>
					<td width="10%"></td>
				</tr>
			</table>
		</div>
		<div id="search">
			<table width="100%" height="49" border="0" border-color:transparent;align="left" cellpadding="0" cellspacing="0">
				<tr>
					<th width="40" height="49"  scope="row"></th>
					<th width="880" class="search2" scope="row">
						<span id = "search_item"></span>
					</th>
					<th width="40" scope="row"><a href="javascript:reset_search_box()" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('reset','','webfile_images/x.png',1)"><img src="webfile_images/x.png" name="reset" width="15" height="15" border="0" align="left" id="reset" /></a></th>
				</tr>
			</table>
		</div>		
		<div id="media_list"></div>
		<div id="footer2"><center><img src="webfile_images/dlink.png" width="77" height="22"/></center></div>	
	</div>
</body>
</html>
