<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<link rel="stylesheet" type="text/css" href="css/pandoraBox.css" />
<link rel="stylesheet" type="text/css" href="js/jquery-ui.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="uk_w.js"></script>
<script type="text/javascript" src="uk.js"></script>
<script type="text/javascript" src="js/xml.js"></script>
<script type="text/javascript" src="js/object.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript" src="js/public_msg.js"></script>
<script type="text/javascript" src="js/pandoraBox.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	var count =0;

	function get_conn_st()	//20120423 chk wan function OK?
	{
		var conn_st = query_wan_connection();
		//conn_st ='true';
		if(conn_st == "true")
			get_wan_st();
		else
			setTimeout('get_conn_st()',500);
	}

	function get_wan_st()
	{
		var time=new Date().getTime();
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	"mdl_check.ccp",
			data: 	"act=getwanst"+"&"+time+"="+time,
			success: function(data) {
				if (data.indexOf('false') != -1)
				{
					count++;
					if ((count % 2) ==0)
						do_fakeping();
					setTimeout('get_wan_st()', 1000);
				}
				else{
					setTimeout('gotopage()', 1000*5);
				}
			}
		};
		try {
				$.ajax(ajax_param);
		} catch (e) {
		}
	}

	function gotopage()
	{
		location.replace('http://www.mydlink.com/entrance');
	}

	function query_wan_connection()
	{
		var queryObj = new ccpObject();
		var paramQuery = {
			url: "ping.ccp",
			arg: "ccp_act=queryWanConnect"
		};

		queryObj.get_config_obj(paramQuery);
		var ret = queryObj.config_val("WANisReady");
		return ret;
	}

	function do_fakeping()
	{
		
		var paramPing = {
			url: "ping.ccp",
			arg: 'ccp_act=fakeping&fakeping=1'
		};
		ping_wan(paramPing);
	}

	function ping_wan(p)
	{
		var time=new Date().getTime();
		var ajax_param = {
			type: 	"POST",
			async:	true,
			url: 	p.url,
			data: 	p.arg+"&"+time+"="+time
		};

		$.ajax(ajax_param);
	}
</script>
</head>
<body onLoad='get_conn_st()';></body>
</html>