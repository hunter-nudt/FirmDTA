<!DOCTYPE html PUBLIC "-//W3C//DTD Xhtml 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Cache-Control" content="no-cache"/>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Expires" content="Tue, 01 Jan 1980 1:00:00 GMT"/>		
		<link rel="STYLESHEET" type="text/css" href="layout.css">
		<link rel="STYLESHEET" type="text/css" href="css_router.css">
		<script language="JavaScript" src="js/webfile.js"></script>
		<script language="JavaScript" src="js/object.js"></script>
		<script language="JavaScript" src="js/xml.js"></script>
		<script type="text/javascript" src="uk.js"></script>
		<script language="JavaScript" src="public.js"></script>
		<script language="JavaScript" src="pandoraBox.js"></script>
		<script language="Javascript" src="fancybox/jquery-1.4.3.min.js"></script> 
		<script language="Javascript" src="jquery.cookie.pack.js"></script>
		<script type="text/javascript">
			document.title = get_words('webf_title');
			var session_id  = $.cookie('id');
			var session_tok = $.cookie('key');
			if (session_id == null || session_tok == null)
				location.replace('login.asp');
			//load_lang_obj();	// you have to load language object for displaying words in each html page and load html object for the redirect or return page						

			//20111229 Silvia add
			function type_chose(i)
			{
				switch (i){
				case 0:
					type_ln =['music','icon_music', get_words('share_title_1')];//lang_obj.get_word('WS001')];
					break;
				case 1:
					type_ln = ['photo','icon_photos', get_words('share_title_2')];//lang_obj.get_word('WS002')];
					break;
				case 2:
					type_ln = ['movie','icon_movies', get_words('share_title_3')];//lang_obj.get_word('WS003')];
					break;
				case 3:
					type_ln = ['document','icon_files', get_words('share_title_4')];//lang_obj.get_word('WS004')];
					break;
				}
			}

			function paint_table()
			{
				var table_str ="";
				for (var i = 0;i<4;i++){
					type_chose(i);

					table_str += '<table width=960 border=0 cellpadding=0 cellspacing=0>';
					table_str += '<tr onMouseUp=\"location.href=\'category.asp#'+type_ln[0]+'\'\">';
					table_str += '<td height="25" style="cursor: default" onMouseOver=\"this.style.background=\'#efefef\'\" onMouseOut=\"this.style.background=\'\'\">';
					table_str += '<table width="960" border="0" align="left" cellpadding="0" cellspacing="0">';
					table_str += '<tr>';
					table_str += '<td width="56" class="tdbg"><img src=\"webfile_images/'+type_ln[1]+'.png\" alt="" width="56" height="56" border="0"></td>';
					table_str += '<td width="868" height="91" class="text_1">'+type_ln[2]+'</td>';
					table_str += '<td width="36" class="tdbg"><img src=\"webfile_images/).png\" alt="" width="15" height="15"></td>';
					table_str += '</tr></table></td></tr></table>';
				}
				$('#paint_list').html(table_str);
			}
			//end of silvia add
			
	document.oncontextmenu=function(){
		return false;
	}			
		</script>
	</head>
	<body onload="MM_preloadImages('webfile_images/btn_home_.png')">
		<div id="wrapper">
			<div id="header">
				<div align="right">
					<table width="100%" border="0" cellspacing="0">
						<tr>
							<th width="224" rowspan="2" scope="row"><img src="webfile_images/index_01.png" width="220" height="55" /></th>
							<th width="715" height="30" scope="row"><a href="folder_view.asp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','webfile_images/btn_menu_.png',1)"><img src="webfile_images/btn_menu_.png" name="Image6" width="25" height="25" border="0" align="right" id="Image6" /></a></th>
							<th width="15" scope="row"></th>
						</tr>
						<tr>
							<th scope="row"></th>
							<th scope="row"></th>
						</tr>
					</table>
				</div>
			</div>
			<div id="button_list">
				<table width="960" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_3">
					<tr>
						<td width="968" colspan="2" align="left" valign="top" id="paint_list">
							<script>paint_table()</script>
						</td>
					</tr>
				</table>
				<div id="footer"><center><img src="webfile_images/dlink.png" width="77" height="22" /></center></div>
			</div>
		</div>
	</body>
</html>