<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link rel="STYLESHEET" type="text/css" href="layout.css">
<link rel="stylesheet" href="style.css" type="text/css">
<link rel="stylesheet" href="jquery-ui.css" type="text/css">
<link rel="stylesheet" href="jquery.treeview.css" />
<script language="JavaScript" src="uk.js"></script>
<script language="JavaScript" src="public.js"></script>
<script language="JavaScript" src="pandoraBox.js"></script>
<script language="Javascript" src="js/jquery-1.3.2.min.js"></script>
<script language="Javascript" src="jquery.tablesorter.min.js"></script>
<script language="JavaScript" src="js/webfile.js"></script>
<script language="Javascript" src="js/xml.js"></script>
<script language="Javascript" src="js/object.js"></script>
<script language="Javascript" src="jquery.color.js"></script> 
<script language="Javascript" src="jquery.treeview.js"></script>
<script language="Javascript" src="jquery-ui.min.js"></script>
<script language="Javascript" src="md5.js"></script>
<script language="Javascript" src="jquery.cookie.pack.js"></script>
<link rel="STYLESHEET" type="text/css" href="fancybox/jquery.fancybox-1.3.4.css" media="screen" />
<style>
html,body{
	margin:0;
	padding:0;
	height:100%;
	border:none;
	padding-left: 6px;
	font-size: 9pt; 
	height:85%; 
	width:99%
}

</style>
<script language="Javascript">
	document.title = get_words('webf_title');
	var fileType = new Array('css', 'doc', 'docx', 'swf', 'htm', 'html', 'pdf', 'php', 
							'jpg', 'gif', 'png', 'ppt', 'pptx', 'txt', 'xls', 'zip',
							'rar', 'xlsx');
	var fileIcon = new Array('css.png', 'doc.png', 'doc.png', 'flash.png', 'html.png', 'html.png', 'pdf.png', 'php.png',
							'picture.png', 'picture.png', 'picture.png', 'ppt.png', 'ppt.png', 'txt.png', 'xls.png', 'xls.png', 'zip.png',
							'zip.png', 'xls.png');
	var errCode = new Array('Success', 
							'ADD_FOLDER_PATH_ERR',
							'ADD_FOLDER_INVALID_PATH',
							'ADD_FOLDER_FOLDER_EXIST',
							'ADD_FOLDER_FAILED');
	var session_id  = $.cookie('id');
	var session_tok = $.cookie('key');
	if (session_id == null || session_tok == null)
		location.replace('login.asp');
	
	var vol = '';
	var cur_path = '/';
	var cur_volId = 0;
	var cur_ulId = '';
	var dev_qty = config_val("usb_quantity");
	var folder_path_list = config_str_multi("dir_path");
	var file_path_list = config_str_multi("file_path");
	var folder_list = config_str_multi("dir");
	var file_list = config_str_multi("file");
	var content_rows = 0;
	var folders = null;
	var files = null;
	var upload_count=0;
	var polling_id=0;
	
	function gen_rand_num(len)
	{
		var rand = '';
		for (var i=0; i<len; i++) {	
			var num = Math.round(Math.random()*10)%10;
			rand += new String(num);
		}
		return rand;
	}
	
	function req_vol()
	{
		var param = {
			url: '/dws/api/ListRoot',
			arg: 'id='+session_id+'&path=/'
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		var arg1 = param.url+'?id='+session_id+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		var data = json_ajax(param);
		if (data == null)
			return;
		
		try {
			folders = data.rootnode;
		} catch (e) {
			folders = null;
			return;
		}
		
		$('#dev_content').html('');
		$("#myTable").trigger("update"); 
		//setTimeout('$("#myTable").trigger("sorton",[[[0,0],[1,0]]]);', 100); 
		update_tree('/', '_', '');
	}
	
	/**
	 *	req_subfolder() : request sub folder through ajax.
	 *
	 *	Parameter(s) :
	 *		path : path to request
	 *		ulId : where the sub folder will be append into.
	 *		type : 1 = folder, 2 = file, 3 = folder & file
	 *
	 * Return : void
	 *
	 **/
	function req_subfolder(path, ulId, volId) 
	{
		var param = {
			url: '/dws/api/ListDir',
			arg: 'id='+session_id+'&path='+urlencode(path)+'&volid='+volId
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		var arg1 = param.url+'?id='+session_id+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		var data = json_ajax(param);
		if (data == null)
			return;
		
		try {
			folders = data.dirs;
		} catch (e) {
			folders = null;
			return;
		}
		
		update_tree(path, ulId, volId);
		
		//if (path == '/')
		//	return;

		req_ctx(path, ulId, volId);
	}
	
	function req_ctx(path, ulId, volId)
	{
		var param = {
			url: '/dws/api/ListDir',
			arg: 'id='+session_id+'&path='+urlencode(path)+'&volid='+volId
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		var arg1 = param.url+'?id='+session_id+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		var data = json_ajax(param);
		if (data == null)
			return;
		
		try {
			folders = data.dirs;
		} catch (e) {
			folders = null;
			return;
		}

		param.url = '/dws/api/ListFile';
		param.arg = 'id='+session_id+'&path='+urlencode(path)+'&volid='+volId;
		rand = gen_rand_num(32);//generate 32 bytes random number
		
		arg1 = param.url+'?id='+session_id+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		data = json_ajax(param);
		if (data == null)
			return;
		files = data.files;

		/*
		folder_path_list = config_str_multi("dir_path");
		file_path_list = config_str_multi("file_path");
		folder_list = config_str_multi("dir");
		file_list = config_str_multi("file");
		*/
		show_content(path, ulId, volId);	
		cur_path = path;
		cur_volId = volId;
		cur_ulId = ulId;
	}
	
	function clear_ctx()
	{
		$('#dev_content').html('');
		$("#myTable").trigger("update"); 
		//setTimeout('$("#myTable").trigger("sorton",[[[0,0],[1,0]]]);', 100); 	
	}
	
	/**
	 *	update_tree() : prepare sub-tree html to append into original tree.
	 *
	 *	Parameter(s) :
	 *		path : path to request
	 *		ulId : where the sub folder will be append into.
	 *
	 * Return : void
	 *
	 **/
	function update_tree(path, ulId, volId)
	{
		var branches = '';
		var rPath;
		var reqPath = '';
		//var folders = config_str_multi("dir_path");
		
		if (path == '/')
			rPath = '';
		else
			rPath = path+'/';
		
		if (folders == null)
			return;

		for (var i=0; i<folders.length; i++) {
			var dispName = folders[i].name;
			if (path == '/') {
				dispName = 'Device '+(i+1);
				reqPath = '';
				volId = folders[i].volid;
			} else {
				reqPath = folders[i].name;
			}
			branches += '<li><span class=folder>'+dispName+'</span>'+
				'<ul id="'+ulId+'/'+dispName+'"'+
//					' url="req_subfolder(\''+rPath+folders[i]+'\', \''+transUid(ulId, folders[i])+'\', \'1\')"'+
//					' clr="req_ctx(\''+rPath+folders[i]+'\', \''+transUid(ulId, folders[i])+'\')">'+
					' url="req_subfolder(\''+rPath+reqPath+'\', \''+ulId+'/'+dispName+'\', \''+volId+'\')"'+
					' clr="req_ctx(\''+rPath+reqPath+'\', \''+ulId+'/'+dispName+'\', \''+volId+'\')">'+
				'</ul></li>';
		}
		$('#'+transUid(ulId)).html('');
		$(branches).appendTo('#'+transUid(ulId));
		prepare_treeview(ulId);
	}
	
	/**
	 *	transUid() : remove some special characters that may fail the js.
	 *
	 *	Parameter(s) :
	 *		uid : uid
	 *
	 * Return : void
	 *
	 **/
	function transUid(uid)
	{
		return uid.replace(/[@\$\.\ \/]/g, function(c) { return ('\\'+c); });
	}

	/**
	 *	prepare_treeview() : initial treeview.
	 *
	 *	Parameter(s) :
	 *		ulId : which treeview node will be initialized.
	 *
	 * Return : void
	 *
	 **/
	function prepare_treeview(ulId) 
	{
		$("#"+transUid(ulId)).treeview({
			collapsed: true,
			toggle: function() {
				var obj = $(this).find('ul');
				if ($(this).attr('class').substring(0,1) == 'c') {	//collapse
					eval(obj.attr('url'));
				} else {
					eval(obj.attr('clr'));
					obj.html('');
				}
			}
		});
	}
	
	/**
	 *	get_size_human() : get human readable size.
	 *
	 *	Parameter(s) :
	 *		size : size in bytes.
	 *
	 * Return : void
	 *
	 **/
	function get_size_human(size, power)
	{
		var divide = 1024;
		var arrUnit = new Array('KB', 'KB', 'MB', 'GB', 'TB');
		var aInt = size/Math.pow(divide, power);
		if (aInt > 0 && aInt < divide) {
			return (Math.round(aInt*100)/100 + ' ' + arrUnit[power]);
		}
		
		if (aInt > divide)
			return get_size_human(size, power+1);
		else	//aInt == 0
			return ('0 KB');
	}
	
	function get_file_ext_idx(ext)
	{
		if (fileType == null)
			return -1;

		for (var i=0; i<fileType.length; i++) {
			if (ext.toLowerCase() == fileType[i])
				return i;
		}
		
		return -1;
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
		
		if (type == '2')	// add folder
			$('#'+transUid(ulId)).parent().find('div').click();

	}
	
	function fileClick(path, filename, volId)
	{
/*
		var param = {
			url: '/dws/api/GetFile',
			arg: 'id='+session_id+'&path='+urlencode(path)+'&volid='+volId+'&filename='+urlencode(filename)
//			url: '/dws/api/DownloadFile',
//			arg: 'id='+session_id+'&path='+urlencode(path)+'&volid='+volId+'&filenames=["'+urlencode(filename)+'"]'
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		var arg1 = param.url+'?id='+session_id+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		var data = json_ajax(param);
*/
		var rand = gen_rand_num(32);//generate 32 bytes random number
		var arg1 = '/dws/api/GetFile?id='+session_id+rand;
		$('#get_wfa_id').val(session_id);
		$('#get_wfa_path').val(urlencode(path));
		$('#get_wfa_volid').val(volId);
		$('#get_wfa_file').val(urlencode(filename));
		$('#get_wfa_tok').val(rand+hex_hmac_md5(session_tok, arg1));
		
		document.getElementById('form2').target = 'upload_target';	//'upload_target' is the name of the iframe
		$('#form2').submit();	//send_submit("saveform");
	}
	
	function show_content(path, ulId, volId)
	{
		var rPath;
		var content_msg = "";
		content_rows = 0;
		
		if (path == '/')
			rPath = '';
		else
			rPath = path+'/';
		
		if (folders != null) {
			for(var i=0;i<folders.length;i++)
			{
				content_msg += '<tr class=listCtx onclick="ctxClick(\''+rPath+folders[i].name+'\', \''+ulId+'/'+folders[i].name+'\', \'1\')">';
				content_msg += "<td class=listHide>D</td>";
				content_msg += "<td class=listName><img src=directory.png>&nbsp;"+folders[i].name+"</td>";
				content_msg += "<td class=listSize></td>";
				content_msg += "<td class=listType>"+folders[i].desc+"</td>";
				content_msg += "<td class=listTime>"+folders[i].mtime+"</td>";
				content_msg += "</tr>";
			}
			content_rows += folders.length;
		}
		
		if (files != null) {
			for(var i=0;i<files.length;i++)
			{
				var ext = '';
				var extIdx  = -1;
				var extIcon = 'file.png';
				var desc = '';
				
				if (files[i].name.lastIndexOf('.') != -1)
					ext = files[i].name.substring(files[i].name.lastIndexOf('.')+1);
				
				extIdx = get_file_ext_idx(ext);
				if (extIdx != -1)
					extIcon = fileIcon[extIdx];

				desc = ext.toUpperCase( )+" File";
				//<a href =\""+ file_path_list[i] +"\">
				content_msg += '<tr class=listCtx onclick="fileClick(\''+rPath+'\', \''+files[i].name+'\', \''+volId+'\')">';
				//content_msg += '<tr>';
				content_msg += "<td class=listHide>F</td>";
				content_msg += "<td class=listName><img src="+extIcon+">&nbsp;"+
								files[i].name+"</td>";
				content_msg += "<td class=listSize>"+get_size_human(files[i].size, 1)+"</td>";
				content_msg += "<td class=listType>"+desc+"</td>";
				content_msg += "<td class=listTime>"+files[i].mtime+"</td>";
				content_msg += "</tr>";
			}
			content_rows += files.length;
		}
		
		if (content_rows > 0) {
			$('#dev_content').show();
		} else {
			$('#dev_content').hide();
		}
		
		$('#dev_content').html('');
		$("#myTable").trigger("update"); 
		$('#myTable tbody').append(content_msg);
		if (content_msg != '') {
			setTimeout('$("#myTable").trigger("sorton",[[[0,0],[1,0]]]);', 100); 
		}
	}
		
	function btn_new_folder()
	{
		$('#input_folder_name').val('');
		$('#dlg_newfolder').dialog('open');
	}
	
	function btn_upload()
	{
		$('#wfa_file').val('');
		$('#wfa_tok').val('');
		$('#upload_form').show();
		//$('#upload_status').hide();
		upload_count = 0;
		clearInterval(polling_id);
		$('#dlg_upload').dialog('open');
	}
	
	function delay_refresh_ctx()
	{
		ctxClick(cur_path, cur_ulId, '2');	
	}
	
	function dlg_upload_ok(obj)
	{
		if ($('#wfa_file').val() == '') {
			alert('Select a file');
			return;
		}
		
		var rand = gen_rand_num(32);//generate 32 bytes random number
		var arg1 = '/dws/api/UploadFile?id='+session_id+rand;
		
		$('#wfa_id').val(session_id);
		$('#wfa_path').val(cur_path);
		$('#wfa_volid').val(cur_volId);
		$('#wfa_tok').val(rand+hex_hmac_md5(session_tok, arg1));

		document.getElementById('form1').action = '/dws/api/UploadFile';
		document.getElementById('form1').target = 'upload_target';	//'upload_target' is the name of the iframe
		$('#form1').submit();
		$(obj).dialog("close");
		
		// update ctx and tree 
		setTimeout('delay_refresh_ctx()', 1000);
	}
	
	function dlg_newfolder_ok(obj)
	{
		var param = {
			url: '/dws/api/AddDir',
			arg: 'id='+session_id+'&path='+urlencode(cur_path)+'&volid='+cur_volId+'&dirname='+urlencode($('#input_folder_name').val())
		};
		var rand = gen_rand_num(32);//generate 32 bytes random number
		
		var arg1 = param.url+'?id='+session_id+rand;
		param.arg += ('&tok='+rand+hex_hmac_md5(session_tok, arg1));
		var data = json_ajax(param);
		if (data == null)
			return;
		
		// update ctx and tree 
		setTimeout('delay_refresh_ctx()', 500);
		
		$(obj).dialog("close");
	}
	
	function dlg_cancel(obj)
	{
		$(obj).dialog("close");
	}
	
	$(document).ready(function() 
	{
		$('#dlg_newfolder').dialog({ 
			title: 'Create Folder',
			buttons: [
			{
				text: "Ok",
				click: function() { dlg_newfolder_ok(this); }
			},
			{
				text: 'Cancel',
				click: function() { dlg_cancel(this); }
			}],
			resizable: false,
			movable: false,
			autoOpen: false,
			modal: true,
			width: '400px'
		});
		
		$('#dlg_upload').dialog({
			title: 'Upload File',
			buttons: [
			{
				text: "Ok",
				click: function() { dlg_upload_ok(this); }
			},
			{
				text: 'Cancel',
				click: function() { dlg_cancel(this); }
			}],
			resizable: false,
			movable: false,
			autoOpen: false,
			modal: true,
			width: '400px'
		});
		
		//$("#myTable").tablesorter({widgets: ['zebra']});
		$("#myTable").tablesorter({widgets: ['zebra'], sortForce: [[0,0]], sortList: [[1,0]]});
		
		prepare_treeview('browser');
		$('#browser div.expandable-hitarea:first').click();
		upload_count=0;
		$('#upload_form').show();
		//$('#upload_status').hide();
		
		//req_ctx('/', '_', 0);
		if (content_rows > 0) {
			$('#dev_content').show();
		} else {
			$('#dev_content').hide();
		}
	});

	document.oncontextmenu=function(){
		return false;
	}
</script>
</head>
<body onload="MM_preloadImages('webfile_images/btn_home_.png','webfile_images/backBtn_.png','webfile_images/x.png');">
<div id="wrapper">
	<div id="header">
		<div align="">
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
		</div>
	</div>
			<table border="0" width="100%" bgcolor="#808080">
			<tr>
				<td width="18%" class="left"></td>
				<td width="82%" class="right">
					<input type="button" id="new_folder" value="New Folder" onclick="btn_new_folder()">
					<input type="button" id="upload" value="Upload" onclick="btn_upload()">
				</td>
			</tr>
			</table>
			<table border="0" width="100%" height="100%">
			<tr height="100%">
				<td width="18%" valign="top" bgcolor=#ffffff >
				<ul id="browser" class="filetree">
					<li><span class="folder" id="__" >My Access Device Hard Drive</span>
						<ul id="_" url="req_vol()" clr="clear_ctx()"></ul>
					</li>
				</ul>	
				</td>
				
				<td width="82%" valign="top" bgcolor=#ffffff>
				<table id="myTable" class="tablesorter">
				<thead>
				<tr>
					<!--th>DF</th>
					<th>Name</th>
					<th>Size</th>
					<th>File Type</th>
					<th>Modified Time</th>
					<th></th-->
					<th style="display: none">DF</th>
					<th class="listName">Name</th>
					<th class="listSize">Size</th>
					<th class="listType">File Type</th>
					<th class="listTime">Modified Time</th>
					<th style="display: none"></th>
				</tr>
				</thead>
				<tbody id="dev_content">
				<tr style="display:none">
					<td class="listHide"></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td class="listHide"></td>
				</tr>
				</tbody>
				</table>
				</td>
			</tr>
			</table>
			<div id="dlg_newfolder">
				Please enter a folder name:<br>
				<input type="text" id="input_folder_name" maxlength="100" style="width:370px">
			</div>
			<div id="dlg_upload">
				<div id="upload_form">
				<form name="form1" id="form1" method="post" action="/dws/api/UploadFile" enctype="multipart/form-data">
				<input type="hidden" id="wfa_id" name="id">
				<input type="hidden" id="wfa_tok" name="tok">
				<input type="hidden" id="wfa_path" name="path">
				<input type="hidden" id="wfa_volid" name="volid">
				<input type="file" id="wfa_file" name="filename">
				</form>
				</div>
				<!--div id="upload_status">
				<input type="hidden" id="wfa_id" name="id">
				<input type="hidden" id="wfa_tok" name="tok">
				<input type="hidden" id="wfa_path" name="path">
				<input type="hidden" id="wfa_volid" name="volid">
				<input type="file" id="wfa_file" name="filename">
				</div-->
				<iframe id="upload_target" name="upload_target" src="" style="width:0;height:0;border:0px solid #fff;"></iframe>
			</div>
			<form name="form2" id="form2" method="post" action="/dws/api/GetFile">
			<input type="hidden" id="get_wfa_id" name="id">
			<input type="hidden" id="get_wfa_tok" name="tok">
			<input type="hidden" id="get_wfa_path" name="path">
			<input type="hidden" id="get_wfa_volid" name="volid">
			<input type="hidden" id="get_wfa_file" name="filename">
			</form>
			<div id="footer"><img src="webfile_images/dlink.png" width="77" height="22"></div>
</div>
</body>
</html>
