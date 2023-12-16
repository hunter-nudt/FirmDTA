<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title><% getWlanExist("stat"); %> Network Camera</title>

<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>

<script language="JavaScript" type="text/javascript" src="../lang/<%getFrontLanguage();%>/itemname.js"></script>
<script language="JavaScript" type="text/javascript" src="../lang/<%getFrontLanguage();%>/msg.js"></script>
<script language="JavaScript" type="text/javascript" src="cookies.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="date.js"></script>
<script language="JavaScript" type="text/JavaScript">
var protocol = location.protocol;
var profile=<% getprofile(); %>;
var group="<% getgroup(); %>";
var nightmode = "<% getNightMode(); %>";
var msgtrigOK = new Array(item_name[_TRIGGER_OUTING],item_name[_TRIGGER_OUT]);
var viewer="<% getviewer1("stat"); %>";
//-----check is iphone?
var agent = navigator.userAgent.toLowerCase();
var type_iphone = "iphone";
var is_iphone = agent.indexOf(type_iphone);
if (is_iphone != -1) { 
	viewer = 2;
}
//---------------

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

function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));

}

function start(){
	setContent("location",item_name[_LOCATION]);
	setContent("nightmode",item_name[_NIGHTMODE]);
	

	if(protocol == "https:")
		return;
	if(group != "guest")
	{
		document.getElementById("ctltb").style.display = "";
		document.getElementById("nighttd").style.display = "<% getNightVisionExist(); %>";
		document.getElementById("nightspc").style.display = "<% getNightVisionExist(); %>";
	}
	selectCompress(profile);
	selectNight(nightmode);
	
	return;

}

function selectCompress(pf){
	if(pf == 3)
		document.getElementById("compress0").className = "texthighlight";
	else if (pf == 2)
		document.getElementById("compress1").className = "texthighlight";
	else if (pf == 6)
		document.getElementById("compress2").className = "texthighlight";
}

function selectNight(pf){

	if (parseInt(pf) == 1)
		document.getElementById("nighta").className = "texthighlight";
	else 
		document.getElementById("nighta").className = "textori";
}

var nightflag = parseInt(nightmode);

function nighttrig(tdobj){
	var obj = document.formnight;

	nightflag = (nightflag == 1) ?0:1
	selectNight(nightflag);
	obj.night.value = nightflag;
	obj.target = "hid";
	obj.submit();
}

function sleep(seconds)
{
 var d1 = new Date();
 var t1 = d1.getTime();
 for (;;)
 {
   var d2 = new Date();
   var t2 = d2.getTime();
   if (t2-t1 > seconds*1000)
   {
      break;
   }
 }
}

var obja;
var blinkobj;
var blinktxt;
function swapCSS(flag,obj,texton,textoff){
	if(flag)
	{
		obja = obj.firstChild;
		obj.removeChild(obja);
		obj.innerHTML = texton
		obj.className = "t12 ButtonSmall";
	}
	else
	{
		obj.className =  "bglblue";
		obja = document.createElement("a");
		obja.className = "a";
		//obja.innerText = textoff;
		obja.appendChild(document.createTextNode(textoff));
		obja.href = "javascript:;";
		obj.innerHTML = "";
		obj.appendChild(obja);
	}
}

var flagTrig = false;

function trigout(obj){
	var o = document.formalarm;
	if(flagTrig != true){
		flagTrig = true;
		o.alarm.value = 1;
	}else{
		flagTrig = false;
		o.alarm.value = 0;
	}
	swapCSS(flagTrig,obj,msgtrigOK[0],msgtrigOK[1]);
	o.target = "hid";
	o.submit();
}

function resetPositionName(){
	var sItem = document.getElementById("pIndex");
	sItem[0].selected=true;
	document.getElementById("pName").value="";
}

function setPositionName(str,str1){
	var pItem='p'+str;
	document.getElementById(pItem).innerHTML = str1;
	resetPositionName();
}

var langIdx = 0;
function initView()
{		
	var lang = "<%getFrontLanguage();%>";
		
	var i;
	var opt;
	for(i=0;i<languageNum.length;i++)
	{
		opt = languageNum[i];
		if(lang == opt){
			langIdx = i;
			}
	}
	
	if(viewer=="2")
		document.write("<img src = \"\/cgi\/mjpg\/mjpg.cgi\">");
	else if(viewer=="1")
		document.write("<img src = \"\/cgi\/jpg\/image.cgi\">");
	else{
		var remote_host = document.location.hostname;
		var remote_port = parseInt((document.location.port == "") ? 80: document.location.port);
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
  	  <PARAM NAME = 'codebase' VALUE='http:\/\/"+remote_host+":"+remote_port+"\/<% getgroup(); %>' > \
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
  	          codebase ='http:\/\/"+remote_host+":"+remote_port+"\/<% getgroup(); %>'  \
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
	}		
}
</script>
</head>

<body onLoad="MM_preloadImages('img/but_liveview_over.gif','img/but_setup_over.gif','img/but_over.gif');time_go();start();">
<table width="900" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="21"><img src="images/c1_tl.gif" width="21"></td>
		<td width="858" background="images/bg1_t.gif"><img src="images/top_1.gif" width="390"></td>
		<td width="21"><img src="images/c1_tr.gif" width="21"></td>
	</tr>
	<tr>
  	<td valign="top" background="images/bg1_l.gif"><img src="images/top_2.gif" width="21" height="69"></td>
    <td background="images/bg.gif">
    	<table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="13%" valign="top"><img src="images/logo.gif" width="300" height="69"></td>
					<td width="87%" align="right" valign="top">
						<table width="100%" border="0" cellpadding="4" cellspacing="0">
							<tr>
								<td align="right" valign="top"><img src="images/description_<% getmodelname(); %>.gif"></td>
							</tr>
							<tr>
								<td align="right" valign="top"><b><font color="#FFFFFF"><span id="location" name="location"></span>: <span class="t12">
								<% getLocation(); %>&nbsp;&nbsp;&nbsp; </span></font><font color="#FFFFFF"><span class="style1">
								<span id="datebar"><% getDate(); %> <%getTime(); %></span>
								&nbsp; </span>&nbsp; </font></b></td>
							</tr>
						</table>
					</td>
			  </tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="200" valign="top" align="center">
						<table width="21%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<table border="0" cellpadding="0" cellspacing="0">
										<tr>
										  <td><img src="images/but_top.gif" width="144" height="3"></td>
										</tr>
										<tr>
										  <td><table width="100%" border="0" cellpadding="3" cellspacing="0" class="submenubg">
										      <tr>
										        <td width="100%" align="right"><img src="images/spacer.gif" width="10" height="5"></td>
										      </tr>
										      <tr>
										        <td align="center"><a href="/"><img src="images/but_liveview_1.gif" name="b_liveview" width="122" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('b_liveview','','images/but_liveview_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
										      </tr>
										      <tr>
										        <td align="center"><a href="../admin/setup.cgi?page=system"><img src="images/but_setup_0.gif" name="b_setup" width="122" height="25" border="0" id="Image2" onMouseOver="MM_swapImage('b_setup','','images/but_setup_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
										      </tr>
										      <tr>
										        <td align="right"><img src="images/spacer.gif" width="10" height="5"></td>
										      </tr>
										    </table></td>
										</tr>
										<tr>
										  <td><img src="images/but_bottom.gif" width="144" height="3"></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%"><img src="images/spacer.gif" width="8" height="8"></td>
							</tr>
						</table>
					</td>
					<td width="10"><img src="images/spacer.gif" width="10" height="15"></td>
					<td valign="top">
						<table width="100%" border="0" cellpadding="2" cellspacing="0">
        			<tr id="viewerTR" name="viewerTR">
          			<td width="100%" height="80" align="center">
			      			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle" style=" display:none">
			        			<tr>
			        		  	<td valign="top">
			        		  		<table width="98%" border="0" cellpadding="3" cellspacing="1" class="box_tn">
			        		      	<tr>
			        		        	<td class="bggrey"><div align="right"></div>
			        		          	<div>&nbsp;<br /></div>
			        		            <div align="center">
			        		            	<table width="40" border="0" cellpadding="0" cellspacing="2" bgcolor="#4b688b" id="zoomtb" style="display:none">
			        		              	<tr align="center" >
			        		                	<td width="70" background="img/bg_view.gif" class="t12" id="nighttd"><a href="javascript:nighttrig(this);" id="nighta" class="textori" ><span id="nightmode" name="nightmode"></span></a></td>
			        		                </tr>
			        		              </table>
			        		            </div>
			        		          </td>
			        		        </tr>
			        		      </table>
			        		    </td>
			        		  </tr> 		  
			        		</table>
			      			<br style=" display:none"><div align="center">
			      			<!--"CONVERTED_APPLET"-->
									<script language="JavaScript" type="text/javascript">initView();</script>
									<!--"END_CONVERTED_APPLET"-->
									</div>
								</td>
							</tr>
							<tr id="msgTR" name="msgTR" style=" display:none">
        			  <td width="100%" height="80" align="center" class="tdline"><b><font color="#FFFFFF"><span id="viewermsg" name="viewermsg"></span></font></b></td>
        			</tr>
						</table>
					</td>
				</tr>
			</table>
		<td width="21" background="images/bg1_r.gif"></td>
  </tr>
  <tr>
    <td><img src="images/c1_bl.gif" width="21"></td>
    <td align="right" background="images/bg1_b.gif"><img src="images/copyright.gif" width="264"></td>
    <td><img src="images/c1_br.gif" width="21"></td>
  </tr>
</table>
<form name="formalarm" action="trigger.cgi" method="post">  
<input type="hidden" name="alarm" value="-1" />
</form>
<form name="formnight" action="trigger.cgi" method="post">  
<input type="hidden" name="night" value="-1" />
</form>
<iframe name="hid" width="0" height="0" src="hidden.asp" frameborder="0"></iframe>
<script language="javascript" >init();</script>
</body>
</html>
