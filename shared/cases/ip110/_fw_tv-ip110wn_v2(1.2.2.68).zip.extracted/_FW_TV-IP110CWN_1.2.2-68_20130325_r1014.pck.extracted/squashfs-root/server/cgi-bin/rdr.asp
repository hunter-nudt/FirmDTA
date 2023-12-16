<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<script language="JavaScript" type="text/JavaScript">

function BrowserCheck()
{
		if( window.opera)
		{
			if( document.getElementById)
			{
				return 2;
			}
		}
		if (navigator.appName.toUpperCase() == 'MICROSOFT INTERNET EXPLORER' && navigator.appVersion.indexOf("MSIE") > 0)
		{
			if (parseFloat(navigator.appVersion.substr(navigator.appVersion.indexOf("MSIE")+4)) >= 6.0)
			{
				return 1;
			}
		}
		var agent = navigator.userAgent.toLowerCase();
		var type_iphone = "iphone";
		var is_iphone = agent.indexOf(type_iphone);
		if (is_iphone != -1) { 
			return 3;
		}
		else 
			return 2;
}

var language = "<%getLanguageBegin();%>";
function start(){
	type = BrowserCheck();
	if(type == 1)
		window.location = "<% getgroup(); %>/view.cgi?profile=0&language=" + language;
	else if (type == 2)
		window.location = "<% getgroup(); %>/view.cgi?profile=2&language=" + language;
	else if (type == 3)
		window.location = "<% getgroup(); %>/view.cgi?profile=7&language=" + language;
}

</script>
</head>

<body onload="start();">
</body>
</html>
