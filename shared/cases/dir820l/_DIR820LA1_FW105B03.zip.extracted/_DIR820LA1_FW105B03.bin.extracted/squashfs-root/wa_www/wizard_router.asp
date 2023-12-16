<html> 
<head>
<link rel="STYLESHEET" type="text/css" href="css_router.css">
<title></title>
<meta http-equiv=Content-Type content="text/html; charset=utf8">
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="js/jquery-ui.css" type="text/css"/>
<script language="Javascript" src="public.js"></script>
<script language="JavaScript" src="public_msg.js"></script>
<script language="JavaScript" src="pandoraBox.js"></script>
<script language="Javascript" src="js/jquery-1.3.2.min.js"></script>
<script language="Javascript" src="js/xml.js"></script>
<script language="Javascript" src="js/object.js"></script>
<script language="Javascript" src="js/jquery-ui.min.js"></script>
<script language="JavaScript">
//20120924 add for redirecting to setup wizard with other ports
var url=window.location.toString();
var url_split = url.split(":");
if(url_split.length>2)
{
	location.replace(url_split[0]+":"+url_split[1]);
}
</script>
</head>
<body>
</body>
</html>