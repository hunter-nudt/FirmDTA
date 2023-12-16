<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<script language="JavaScript" type="text/JavaScript">

var language = "<%getLanguageValue();%>";
function start()
{
	window.location = "setup.cgi?page=system&language=" + language;
}

</script>
</head>
<body onload="start();">
</body>
</html>
