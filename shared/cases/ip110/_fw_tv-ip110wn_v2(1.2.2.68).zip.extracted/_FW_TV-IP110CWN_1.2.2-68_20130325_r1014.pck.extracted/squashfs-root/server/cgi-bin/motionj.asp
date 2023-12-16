<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><% getWlanExist("stat"); %> Network Camera</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {color: #339900}
.style2 {color: #0048c0}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	background: url("images/bg.gif");
}
.style6 {
	color: #6699ff;
	background-color: FAFAF4;
}
.style7 {font-size: 12px}
.style8 {
	background-color: E5E5e5;
}
-->
</style>
<script language="JavaScript" type="text/javascript" src="language.js"></script>
<script language="javascript">
var protocol = location.protocol;
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}

function init(){
	if(protocol == "https:"){
		setContent("viewermsg",popup_msg[popup_msg_75]);
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
}

function start(){

	setContent("motion_detect_1",item_name[_MOTION_DETECTION]);
	setContent("detect_config",item_name[_DETECT_CONFIG]);
	
}

function goSetHeight() {
  if (parent == window) return;
  else parent.setIframeHeightMotion('ifrm');
}

var langIdx = 0;
function initView()
{
	var lang;
	if (parent == window)
		lang = "en"
	else
		lang = parent.languagevaule;
		
	var i;
	var opt;
	for(i=0;i<languageNum.length;i++)
	{
		opt = languageNum[i];
		if(lang == opt){
			langIdx = i;
			}
	}
	
	if (parent == window){
		var remote_host = document.location.hostname;
		var remote_port = parseInt((document.location.port == "")? 80: document.location.port);
		document.write(" \
			<object \
	  	  classid = 'clsid:CAFEEFAC-0015-0000-0012-ABCDEFFEDCBA' \
	  	  codebase = 'http:\/\/java.sun.com\/update\/1.5.0\/jinstall-1_5_0_12-windows-i586.cab#Version=5,0,120,4' \
	  	  WIDTH = '840' HEIGHT = '480' NAME = 'ucx' > \
	  	  <PARAM NAME = CODE VALUE = 'org\/fiti\/camera\/viewer\/UltraCam.class' > \
	  	  <PARAM NAME = ARCHIVE VALUE = 'ultracam.jar' > \
	  	  <PARAM NAME = NAME VALUE = 'ucx' > \
	  	  <param name = 'type' value = 'application\/x-java-applet;jpi-version=1.5.0_12'> \
	  	  <param name = 'scriptable' value = 'false'> \
	  	  <PARAM NAME = 'accountcode' VALUE='<% getserial(); %>' > \
	  	  <PARAM NAME = 'codebase' VALUE='http:\/\/"+remote_host+":"+remote_port+"\/' > \
	  	  <PARAM NAME = 'mode' VALUE='2' > \
	  	  <PARAM NAME = 'locale' VALUE='0' > \
	  	  <PARAM NAME = 'mayscript' VALUE='' /> \
	  	  <comment> \
			<embed \
	  	          type = 'application\/x-java-applet' \
	  	          CODE = 'org\/fiti\/camera\/viewer\/UltraCam.class' \
	  	          ARCHIVE = 'ultracam.jar' \
	  	          NAME = 'ucx' \
	  	          WIDTH = '840' \
	  	          HEIGHT = '480' \
	  	          accountcode ='<% getserial(); %>'  \
	  	          codebase ='http:\/\/"+remote_host+":"+remote_port+"\/'  \
	  	          mode ='2'  \
	  	          locale ='0'  \
	  	          mayscript ='' \
			    scriptable = false \
			    pluginspage = 'http:\/\/java.sun.com\/products\/plugin\/index.html#download'> \
			    <noembed> \
	  	          </noembed> \
			</embed> \
	  	  </comment> \
			</object> \
			");
	}else{
		document.write(" \
			<object \
	  	  classid = 'clsid:CAFEEFAC-0015-0000-0012-ABCDEFFEDCBA' \
	  	  codebase = 'http:\/\/java.sun.com\/update\/1.5.0\/jinstall-1_5_0_12-windows-i586.cab#Version=5,0,120,4' \
	  	  WIDTH = '840' HEIGHT = '480' NAME = 'ucx' > \
	  	  <PARAM NAME = CODE VALUE = 'org\/fiti\/camera\/viewer\/UltraCam.class' > \
	  	  <PARAM NAME = ARCHIVE VALUE = 'ultracam.jar' > \
	  	  <PARAM NAME = NAME VALUE = 'ucx' > \
	  	  <param name = 'type' value = 'application\/x-java-applet;jpi-version=1.5.0_12'> \
	  	  <param name = 'scriptable' value = 'false'> \
	  	  <PARAM NAME = 'accountcode' VALUE='<% getserial(); %>' > \
	  	  <PARAM NAME = 'codebase' VALUE='http:\/\/<% getip(); %>:<% getport() %>\/' > \
	  	  <PARAM NAME = 'mode' VALUE='2' > \
	  	  <PARAM NAME = 'locale' VALUE="+langIdx+" > \
	  	  <PARAM NAME = 'mayscript' VALUE='' /> \
	  	  <comment> \
			<embed \
	  	          type = 'application\/x-java-applet' \
	  	          CODE = 'org\/fiti\/camera\/viewer\/UltraCam.class' \
	  	          ARCHIVE = 'ultracam.jar' \
	  	          NAME = 'ucx' \
	  	          WIDTH = '840' \
	  	          HEIGHT = '480' \
	  	          accountcode ='<% getserial(); %>'  \
	  	          codebase ='http:\/\/<% getip(); %>:<% getport() %>\/'  \
	  	          mode ='2'  \
	  	          locale ="+langIdx+"  \
	  	          mayscript ='' \
			    scriptable = false \
			    pluginspage = 'http:\/\/java.sun.com\/products\/plugin\/index.html#download'> \
			    <noembed> \
	  	          </noembed> \
			</embed> \
	  	  </comment> \
			</object> \
			");
	}	
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="motion_detect_1" name="motion_detect_1"></span>&nbsp;&raquo;&nbsp;<span id="detect_config" name="detect_config"></span></font></b></td>
	</tr>
  <tr>
  	<td valign="top" width="553">
			<form action="system.cgi" method="post" name="form1">     
		  	<table width="97%" border="0" cellpadding="2" cellspacing="0" id="msgTR" name="msgTR" style=" display:none">
        	<tr>
          	<td width="100%" height="80" align="center"><b><span id="viewermsg" name="viewermsg"></span></b></td>
        	</tr>
	      </table>
	      <table width="98%" border="0" cellpadding="3" cellSpacing="1" bgcolor="#333333" class="box_tn">
	      	<tr>
	      		<td>
		      		<p align="left" id="viewerTR" name="viewerTR">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			<script language="JavaScript" type="text/javascript">initView();</script>
              </p>
            </td>
          </tr>
        </table>
		  </form>
      <br>
    </td>
  </tr>
</table>
</body>
<script language="javascript" >init();</script></html>
