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
				return false;
			}
		}
		if (navigator.appName.toUpperCase() == 'MICROSOFT INTERNET EXPLORER' && navigator.appVersion.indexOf("MSIE") > 0)
		{
			if (parseFloat(navigator.appVersion.substr(navigator.appVersion.indexOf("MSIE")+4)) >= 6.0)
			{
				return true;
			}
		}
			return false;
}


function start(){
	if(BrowserCheck())
		window.location = "watch.cgi?url=motion.asp";
	else
		window.location = "watch.cgi?url=motion.asp";
}

</script>
</head>

<body onload="start();">
</body>
</html>
