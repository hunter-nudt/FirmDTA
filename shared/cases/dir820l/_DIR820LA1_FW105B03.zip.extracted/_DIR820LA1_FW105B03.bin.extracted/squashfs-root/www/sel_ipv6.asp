<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/css_router.css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="uk.js"></script>
<script type="text/javascript" src="js/xml.js"></script>
<script type="text/javascript" src="js/object.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript" src="js/public_msg.js"></script>
<script type="text/javascript" src="js/public_ipv6.js"></script>
<script type="text/javascript" src="js/pandoraBox.js"></script>
<script type="text/javascript" src="js/ccpObject.js"></script>
<script type="text/javascript">
	var mainObj = new ccpObject();
	var param = {
		url: "get_set.ccp",
		arg: "ccp_act=getMisc"
	};
	
	param.arg = "ccp_act=get&num_inst=1";
	param.arg +="&oid_1=IGD_WANDevice_i_&inst_1=1100";
	mainObj.get_config_obj(param);
	
function select_ipv6_page(){
	var html_file;
	var sel_ipv6 = mainObj.config_val("wanDev_CurrentConnObjType6_"); 
	switch(sel_ipv6)
	{
		case "0":
			html_file = "ipv6_autodetect.asp";
			break;
		case "1":
			html_file = "ipv6_static.asp";
			break;
		case "2":
			html_file = "ipv6_autoconfig.asp";
			break;
		case "3":
			html_file = "ipv6_pppoe.asp";
			break;
		case "4":
			html_file = "ipv6_6in4.asp";
			break;
		case "5":
			html_file = "ipv6_6to4.asp";
			break;	
		case "6":
			html_file = "ipv6_6rd.asp";
			break;
		case "7":
			html_file = "ipv6_link_local.asp";
			break;		
		default:
			html_file = "ipv6_link_local.asp";
			break;
	}

	location.href = html_file;
}

</script>
</head>

<body>
</body>
<script>
	select_ipv6_page();
</script>
</html>
