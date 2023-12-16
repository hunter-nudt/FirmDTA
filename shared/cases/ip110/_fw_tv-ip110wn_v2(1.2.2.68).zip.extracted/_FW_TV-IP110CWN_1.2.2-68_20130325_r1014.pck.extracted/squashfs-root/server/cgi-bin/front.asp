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
var profile=1;
var group="<% getgroup(); %>";
var nightmode = "<% getNightMode(); %>";
var msgRecOK = new Array(item_name[_STOP_RECORD],item_name[_MANUAL_RECORD]);
var msgAlmOK = new Array(item_name[_ALARM_SENT],item_name[_MANUAL_ALARM]);
var msgSnpOK = new Array(item_name[_SAVE_OK],item_name[_SNAPSHOT]);
var msgSnpFail = new Array(item_name[_SAVE_FAIL],item_name[_SNAPSHOT]);
var msgTlkOK = new Array(item_name[_TALKING],item_name[_TALK]);
var msgLisOK = new Array(item_name[_LISTENING],item_name[_LISTEN]);
var msgtrigOK = new Array(item_name[_TRIGGER_OUTING],item_name[_TRIGGER_OUT]);
var msgmultiOK = new Array(item_name[_MULTICASTSW],item_name[_MULTICASTSW]);

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

function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));

}

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function checkMultiStatus(){
	if(document.ucx.MulticastStatus == 2)
		alert(popup_msg[popup_msg_77]);
	if(document.ucx.MulticastStatus == 3)
		alert(popup_msg[popup_msg_94]);
}

function init(){
	if(protocol == "https:"){
		setContent("viewermsg",popup_msg[popup_msg_75]);
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
}

function start(){
	setContent("location",item_name[_LOCATION]);
	setContent("manualrecord",item_name[_MANUAL_RECORD]);
	setContent("snapshot",item_name[_SNAPSHOT]);
	setContent("browse",item_name[_BROWSE]);
	setContent("talk",item_name[_TALK]);
	setContent("listen",item_name[_LISTEN]);
	setContent("manualalarm",item_name[_MANUAL_ALARM]);
	setContent("triggerout",item_name[_TRIGGER_OUT]);
	setContent("multicastsw",item_name[_MULTICASTSW]);
	setContent("nightmode",item_name[_NIGHTMODE]);
	
	if(protocol == "https:")
		return;

	if(BrowserCheck()){

		if(document.getElementById("ucx")==null)
		{
			setContent("viewermsg",popup_msg[popup_msg_76]);
			document.getElementById("zoomtb").style.display = "none";
			document.getElementById("viewerTR").style.display = "none";
			document.getElementById("msgTR").style.display = "";
     		return;
    	}
		if(group != "guest")
		{
			document.getElementById("ctltb").style.display = "";
			document.getElementById("nighttd").style.display = "<% getNightVisionExist(); %>";
			document.getElementById("nightspc").style.display = "<% getNightVisionExist(); %>";
			avGetCookie();		
			
		}
		else
			setAFlag(true);	
			
		//document.ucx.RemoteHost = "<% getip(); %>";
		//document.ucx.RemotePort = "<% getport(); %>";
		document.ucx.RemoteHost = document.location.hostname;
		document.ucx.RemotePort = parseInt((document.location.port == "") ? 80: document.location.port);
		document.ucx.AccountCode = "<% getserial(); %>";
			
		pathGetCookie();

		SetOSD();
		avStart();
		scaleColor(1);
		selectNight(nightmode);
		checkIntv = window.setInterval("checkSize()",2000);
	}else{
		setContent("viewermsg",popup_msg[popup_msg_76]);
		document.getElementById("zoomtb").style.display = "none";
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
}

function SetOSD() {
	var osd_enable = "<% getOsdEnable("1"); %>";
	if (osd_enable == "checked")
		document.ucx.TimeStampEnable(1);
	else 
		document.ucx.TimeStampEnable(0);
	document.ucx.TimestampStroke(1);
}

function checkSize(){
	if(document.ucx.fChgImageSize == 1)
	{
	
		document.ucx.fChgImageSize=0;
		avStop();
		document.ucx.height = document.ucx.ImgHeight;
		document.ucx.width = document.ucx.ImgWidth;
		avStart();
	}
}

function changeMode(val){
	window.location = "view.cgi?profile=" +val
	
}
function avGetCookie(){
	if(getCookie("Video") != null)
		v = (getCookie("Video")=="true")?1:0;
	if(getCookie("Audio") != null)		
		a = (getCookie("Audio")=="true")?1:0;

}
function getVFlag(){

	return true;
}
var aflag = false;
function getAFlag(){
	return aflag;
}
function setAFlag(d){
	aflag = d;
}
function avStop(){
	videoEnable(false);
	audioEnable(false);	
}
function avStart(){
	videoEnable(getVFlag());
	audioEnable(getAFlag());
}
function videoEnable(flag){
	if(flag)
	{
		document.ucx.PlayVideo(profile);
	}
	else
		document.ucx.StopVideo();
	setCookieYears("Video",flag,null,null,null,null);

}
// -3 : disabled
// -2 : OS sound not-available
// -1 : server occupied
// 0 : success
function audioEnable(flag){
	var ret = 0;
	if(flag)
		ret = document.ucx.PlayAudio();
	else
		document.ucx.StopAudio();
	if(ret ==  0)
		setCookieYears("Audio",flag,null,null,null,null);	
		
	return ret;
	
}

///////////////////////////////////////////////////////////////////////////////

var filepath = "";
var flagRecording = false;
var cntRecording = 0;
function pathGetCookie(){
     var tpath=getCookie("CapPath");
     if((tpath!=null)&&(tpath!="null"))
     {
            filepath = tpath;
     }
     else
     {
        filepath = "";
     }
}


function addTrailSlash(s){
        if(s.substring(s.length-1,s.length) != "\\")
                s=s+"\\";
        return s;
}


//////////////////////////////////////////////////////////
function scale(f,obj){
	if(f>1){
		if((document.ucx.ImgWidth * f) >640)
			document.ucx.width = 640;
		else
			document.ucx.width = document.ucx.ImgWidth * f	
		if((document.ucx.ImgHeight * f) >480)		
			document.ucx.height = 480;
		else
			document.ucx.height = (document.ucx.ImgHeight * f)
	}else{
		if((document.ucx.ImgWidth * f) >1280)
			document.ucx.width = 1280;
		else
			document.ucx.width = document.ucx.ImgWidth * f	
		if((document.ucx.ImgHeight * f) >1024)		
			document.ucx.height = 1024;
		else
			document.ucx.height = (document.ucx.ImgHeight * f)
	}
	document.ucx.SetImgScale(f);
	scaleColor(f);
	document.ucx.SButtonStatus = 0;
}
function scaleColor(f){
	var i;
	for(i=1;i<=3;i++)
	{
		if(f==i)
			document.getElementById("scale"+i).className="texthighlight";
		else
			document.getElementById("scale"+i).className="textori";
	}
}
function change(idx){
	window.location = "view.cgi?profile=" + idx + "&language=<%getFrontLanguage();%>";
}

var obja;
var intcss;
var blinkflag = false;
var blinkobj;
var blinktxt;
function blinkCSS(obj){	
	if(blinkflag)
		obj.className = "t12 style8";
	else
		obj.className = "t12 style11";
	blinkflag = !blinkflag;
}

function Timer(pobj,pmsec){
	this.msec  = pmsec;
	this.obj	= pobj;
	this.bflag = false;
	this.int_timer = null;
	 
	
	
	this.Blinking = function(){
		if(this.bflag)
			this.obj.className = "t12 style8";
		else
			this.obj.className = "t12 style11";
			this.bflag = !(this.bflag);		
	}
	
	this.Start = function(){
		if(this.int_timer == null)
			this.int_timer  = window.setInterval(this.Blinking,this.msec);
	}
	this.Stop = function(){
		if(this.int_timer != null)
			window.clearInterval(this.int_timer);
	}
}

function swapCSS(flag,obj,texton,textoff){
	if(flag)
	{
		obja = obj.firstChild;
		obj.removeChild(obja);
		obj.innerHTML = texton
		obj.className = "ButtonSmall2";
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

function listen(obj){
		setAFlag(!aflag);
		var ret = audioEnable(aflag);
		
		if(ret == -1)
			alert(popup_msg[popup_msg_5]);
		else if (ret == -2)
			alert(popup_msg[popup_msg_6]);
		else if (ret == -3)	
			alert(popup_msg[popup_msg_7])
		else if (ret == -4)	
			alert(popup_msg[popup_msg_3]);
		else if (ret < 0)
			alert(popup_msg[popup_msg_4]);
		//restoring the flag
		if(ret<0)
			setAFlag(!aflag);
		swapCSS(aflag,obj,msgLisOK[0],msgLisOK[1]);
}
var tflag = false;
function setTFlag(d){
	tflag = d;
}


// -3 : disabled
// -2 : os mic not-available
// -1 : server occupied
// 0 : success
function talkEnable(f){
	var ret = 0;
	if(f)
		ret = document.ucx.TalkOn();
	else
		document.ucx.TalkOff();
	return ret;
}

function talk(obj){

	setTFlag(!tflag);
	var ret  = talkEnable(tflag);

	if(ret == -1)
		alert(popup_msg[popup_msg_0]);
	else if (ret == -2)
		alert(popup_msg[popup_msg_1]);
	else if (ret == -3)
		alert(popup_msg[popup_msg_2]);
	else if (ret == -4)
		alert(popup_msg[popup_msg_3]);
	else if (ret < 0)
		alert(popup_msg[popup_msg_4]);
		
	//restoring the flag
	if(ret < 0)
		setTFlag(!tflag);
	swapCSS(tflag,obj,msgTlkOK[0],msgTlkOK[1]);	
}

function browse(){
   if((t =  document.ucx.OpenFolder(filepath))!= "")   
        {       filepath =      addTrailSlash(t);
                     
						setCookieYears("CapPath",filepath);
        }

}


function snap(obj){
        if(filepath == "")
                {       browse();
                        if(filepath == "")
                        {
                        return;
                        }
                }
                document.ucx.SnapFileName= filepath
                ret = document.ucx.SnapVideo();
                if(ret!=0)
                {
						swapCSS(true,obj,msgSnpFail[0],msgSnpFail[1]);
                }
                else
                { 
					swapCSS(true,obj,msgSnpOK[0],msgSnpOK[1]);
					
                }
                window.setTimeout("clearMsg('snp','"+ msgSnpOK[0] +"','"+ msgSnpOK[1] + "')",500);

						
}
function clearMsg(tdid,mesgon,mesgoff){
       var obj = document.getElementById(tdid);
	   swapCSS(false,obj,mesgon,mesgoff);
	
}




function record(obj){

        if(flagRecording == false)
        {

                if(recordStart()!=false)
                {
					        flagRecording = true;							
							swapCSS(flagRecording,obj,msgRecOK[0],msgRecOK[1]);
				}
					
        }
        else
        {
                recordStop();
                flagRecording = false;
				swapCSS(flagRecording,obj,msgRecOK[0],msgRecOK[1]);
        }
}

var wholepath="";
function recordStart(){

                if(filepath == "")
                {       browse();
                        if(filepath == "")
                        {

                        return false;
                        }
                }
                        fileDate=new Date();
                        filename = ""
                        cntRecording++;
                        if(cntRecording>30000)
                                cntRecording=1;
                        filename = filename +(fileDate.getFullYear())+ addZero((fileDate.getMonth()+ 1 ))+addZero(fileDate.getDate())+"_"+addZero(fileDate.getHours())+ addZero(fileDate.getMinutes()) + addZero(fileDate.getSeconds())+ "_" + cntRecording + ".avi"

						wholepath = filepath+filename;
                        document.ucx.AVIRecStart(wholepath);

                rint = window.setInterval("getRecordState()",1000);

}
function recordStop(){

                document.ucx.AVIRecEnd()
                window.clearInterval(rint);

}
// -1: no space
// -2: resolution or framerate change
// -3: source format changed
// -4: file access error
function getRecordState(){
		var ret;

        if((ret =document.ucx.AVIRecStatus )!=0)
        {

                recordStop();
                flagRecording = false;
 				swapCSS(flagRecording,document.getElementById("recordtd"),msgRecOK[0],msgRecOK[1]);
				document.ucx.AVIRecStatus= 0;
				if(ret == -1)
					 alert(popup_msg[popup_msg_59]);
				else if(ret == -2)
					alert(popup_msg[popup_msg_60])
				else if(ret == -3)
					alert(popup_msg[popup_msg_61]);
				else if(ret == -4)
					alert(popup_msg[popup_msg_62]+" (" + wholepath+")" );
        }
}
function selectCompress(pf){
	if(pf == 0)
		document.getElementById("compress0").className = "style1";
	else if (pf == 1)
		document.getElementById("compress1").className = "style1";
	else if (pf == 5)
		document.getElementById("compress2").className = "style1";
}

function selectNight(pf){

	if (parseInt(pf) == 1)
		document.getElementById("nighta").className = "style1";
	else 
		document.getElementById("nighta").className = "style3";
}

function alarmtrig(tdobj){
	var obj = document.formalarm;
	obj.alarm.value = 1;
	obj.target = "hid";
	obj.submit();
	swapCSS(true,tdobj,msgAlmOK[0],msgAlmOK[1]);
    window.setTimeout("clearMsg('altd','" +msgAlmOK[0]+"','"+msgAlmOK[1]+"')",500);
	
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
					<td width="13%" valign="top"><img src="images/logo.gif" width="390" height="69"></td>
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
									  	<td>
									  		<table width="100%" border="0" cellpadding="3" cellspacing="0" class="submenubg3">
									      	<tr>
									        	<td width="100%" align="right"><img src="images/spacer.gif" width="10" height="5"></td>
										      </tr>
										      <tr>
										        <td align="center"><a href="../."><img src="images/but_liveview_1.gif" name="b_liveview" width="122" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('b_liveview','','images/but_liveview_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
										      </tr>
										      <tr>
										        <td align="center"><a href="../admin/setup.cgi?page=system"><img src="images/but_setup_0.gif" name="b_setup" width="122" height="25" border="0" id="Image2" onMouseOver="MM_swapImage('b_setup','','images/but_setup_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
										      </tr>
										      <tr>
										        <td align="right"><img src="images/spacer.gif" width="10" height="5"></td>
										      </tr>
									  	  </table>
									  	</td>
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
			            <table width="100%" border="0" cellpadding="4" cellspacing="2" id="ctltb" style="display:none">
			                <tr>
			                  <td width="100%"  class="bglblue" onClick="record(this);" align="center" id="recordtd"><a href="javascript:;" class="a"><span id="manualrecord" name="manualrecord"></span></a></td>
			                </tr>
			                <tr>
			                  <td class="bglblue" onClick="snap(this);" align="center" id="snp"><a href="javascript:;" class="a"><span id="snapshot" name="snapshot"></span></a></td>
			                </tr>
			                <tr>
			                  <td class="bglblue" onClick="browse(this);" align="center" id="brtd"><a href="javascript:;" class="a"><span id="browse" name="browse"></span></a></td>
			                </tr>
			                <tr style="display:none">
			                  <td class="bglblue" onClick="talk(this);" align="center" id="tktd"><a href="javascript:;" class="a" id="tlk"><span id="talk" name="talk"></span></a></td>
			                </tr>				
			                <tr>
			                  <td class="bglblue" onClick="listen(this);" align="center" id="lstd"><a href="javascript:;" class="a" id="lis"><span id="listen" name="listen"></span></a></td>
			                </tr>
			                <tr style=" display:none">
			                  <td class="bglblue" onClick="alarmtrig(this);" align="center" id="altd"><a href="javascript:;" class="a" id="alm"><span id="manualalarm" name="manualalarm"></span></a></td>
			                </tr>
			                <tr style=" display:none">
			                  <td class="bglblue" onClick="trigout(this);" align="center" id="tgtd"><a href="javascript:;" class="a" id="trig"><span id="triggerout" name="triggerout"></span></a></td>
			                </tr>
			                <tr style="display:none" id="mltr">
			                  <td class="bglblue" onClick="multicast(this);" align="center" id="mltd"><a href="javascript:;" class="a" id="multi"><span id="multicastsw" name="multicastsw"></span></span></a></td>
			                </tr>					
			            </table>
					</td>
					<td width="10"><img src="images/spacer.gif" width="10" height="15"></td>
					<td valign="top">
					<table width="100%" border="0" cellpadding="2" cellspacing="0">
        			<tr id="viewerTR" name="viewerTR">
          			<td width="100%" height="80" align="center">
          				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
				          	<tr>
				            	<td valign="top">
				            		<table width="98%" border="0" cellpadding="3" cellspacing="1" class="box_tn">
				            			<tr>
				                  	<td class="bggrey">
				                  		<div align="center">
                  							<table width="146" border="0" cellpadding="0" cellspacing="2" bgcolor="#666666" id="zoomtb">
                  		  					<tr align="center" >
                  							    <td background="img/bg_view.gif" class="t12"><a id="scale1" class="textori" href="javascript:scale(1.0);">1x</a></td>
                  							    <td background="img/bg_view.gif" class="t12"><a id="scale2" class="textori" href="javascript:scale(2.0);">2x</a></td>
                  							    <td background="img/bg_view.gif" class="t12"><a id="scale3" class="textori" href="javascript:scale(3.0);">3x</a></td>
                  							    <td width="20"  bgcolor="CFCFA6" class="t12" id="nightspc"  style="display:none">&nbsp;&nbsp;</td>
                  							    <td width="70" background="img/bg_view.gif" class="t12" id="nighttd" style="display:none"><a id="nighta" class="style3" href="javascript:nighttrig(this);"><span id="nightmode" name="nightmode"></span></a></td>					 
                  							  </tr>
                  							</table>
		                					</div>
		                				</td>
		                			</tr>
		                		</table>
		                	</td>
		                </tr>
		              </table>
		              <br>
		              <div align="center">
		  						<object classid="CLSID:<% getactivexclsid(); %>" codebase="./<% getactivexname(); %>#version=<% getactivexver(); %>" width="<% getwidth(); %>" height="<% getheight(); %>" align="middle" id="ucx" title="ActiveX Streaming Client">
                  <br />
                  <b>ActiveX is not installed. This function is only avaiable in Windows Internet Explorer.</b>
                  </object>
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
    </td>
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
