<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<title>
<% getWlanExist("stat"); %> Network Camera</title>
</title>

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

function initView()
{
	var langIdx = 0;
	if(BrowserCheck()){
		
		document.write(" \
		<div name='myapp' id='myapp'> \
		<object \
  	  classid = 'clsid:CAFEEFAC-0015-0000-0012-ABCDEFFEDCBA' \
  	  codebase = 'http:\/\/java.sun.com\/update\/1.5.0\/jinstall-1_5_0_12-windows-i586.cab#Version=5,0,120,4' \
  	  WIDTH = '<% getwidth(); %>' HEIGHT = '<% getheight(); %>' NAME = 'ucx' ID = 'ucx'> \
  	  <PARAM NAME = CODE VALUE = 'ultracam.class' > \
  	  <PARAM NAME = ARCHIVE VALUE = 'ultracam.jar' > \
  	  <PARAM NAME = NAME VALUE = 'ucx' > \
  	  <PARAM NAME = ID VALUE = 'ucx' > \
  	  <param name = 'type' value = 'application\/x-java-applet;jpi-version=1.5.0_12'> \
  	  <param name = 'scriptable' value = 'false'> \
  	  <PARAM NAME = 'accountcode' VALUE='<% getserial(); %>' > \
  	  <PARAM NAME = 'codebase' VALUE='http:\/\/<% getip(); %>:<% getport() %>\/' > \
  	  <PARAM NAME = 'mode' VALUE='0' > \
  	  <PARAM NAME = 'locale' VALUE="+langIdx+" > \
  	  <PARAM NAME = 'mayscript' VALUE='' /> \
  	  <comment> \
			<embed \
  	          type = 'application\/x-java-applet' \
  	          CODE = 'ultracam.class' \
  	          ARCHIVE = 'ultracam.jar' \
  	          NAME = 'ucx' \
  	          ID = 'ucx' \
  	          WIDTH = '<% getwidth(); %>' \
  	          HEIGHT = '<% getheight(); %>' \
  	          accountcode ='<% getserial(); %>'  \
  	          codebase ='http:\/\/<% getip(); %>:<% getport() %>\/'  \
  	          mode ='0'  \
  	          locale ="+langIdx+"  \
  	          mayscript ='' \
		    scriptable = false \
		    pluginspage = 'http:\/\/java.sun.com\/products\/plugin\/index.html#download'> \
		    <noembed> \
  	          </noembed> \
		</embed> \
  	  </comment> \
		</object> \
		</div> \
		");
	}else
		document.write("<img src = \"\/cgi\/mjpg\/mjpg.cgi\">");
			
}

function setUCXSize(uwidth,uheight){
	var appletFrame = document.getElementById? document.getElementById('myapp'): document.all? document.all['myapp']: null;
	appletFrame.style.height = uheight;
	appletFrame.style.width = uwidth;
	appletFrame.focus();
}
</script>
</head>
<body onLoad="">
<table width="100%" border="0" cellspacing="1" cellpadding="10">
	<tr>
		<td align="center">
			<script language="JavaScript" type="text/javascript">initView();</script>
		</td>
</tr>
</table>
</body>
</html>
