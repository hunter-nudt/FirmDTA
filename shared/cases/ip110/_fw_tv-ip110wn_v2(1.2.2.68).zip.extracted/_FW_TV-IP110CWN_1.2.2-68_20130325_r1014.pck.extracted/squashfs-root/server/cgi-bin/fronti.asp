<html>
<head>
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.6, maximum-scale=4.0, user-scalable=yes"/>
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
<script language="JavaScript" type="text/JavaScript">
var protocol = location.protocol;
var profile=<% getprofile(); %>;
var group="<% getgroup(); %>";
var nightmode = "<% getNightMode(); %>";
var msgtrigOK = new Array(item_name[_TRIGGER_OUTING],item_name[_TRIGGER_OUT]);
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}

function init(){
	if(protocol == "https:"){
		setContent("viewermsg",popup_msg[popup_msg_75]);
		//document.getElementById("formattb").style.display = "none";
		document.getElementById("viewerTR").style.display = "none";
		document.getElementById("msgTR").style.display = "";
	}
}

function start(){
	resetPositionName();
	setContent("triggerout",item_name[_TRIGGER_OUT]);
	setContent("nightmode",item_name[_NIGHTMODE]);
	setContent("pan_scan",item_name[_PAN_SCAN]);
	setContent("auto_patrol",item_name[_AUTO_PATROL]);
	setContent("stop",item_name[_STOP]);

	document.getElementById("Button").value=item_name[_APPLY];
	
	/*var i;
	var num = "<%getFrontLanguage();%>";
	var opt;
	for(i=0;i<languageNum.length;i++)
	{
		opt = languageNum[i];
		if(num == opt){
			document.getElementById("language2").options[i].selected = true;
		}
	}*/
	
	if(protocol == "https:")
		return;

	selectCompress(profile);
	selectNight(nightmode);
	
	return;

}

function selectCompress(pf){
	if(pf == 3)
		document.getElementById("compress0").className = "style1";
	else if (pf == 2)
		document.getElementById("compress1").className = "style1";
	else if (pf == 6)
		document.getElementById("compress2").className = "style1";
}

function selectNight(pf){

	if (parseInt(pf) == 1)
		document.getElementById("nighta").className = "style1";
	else 
		document.getElementById("nighta").className = "style3";
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


var obja;
var blinkobj;
var blinktxt;
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

var ptstatus=false;
function alertContents(){

    if (http_request.readyState == 4) {
        if (http_request.status == 200) {
			if(http_request.responseText == "Request failed\r\n"){
				alert(popup_msg[popup_msg_65]);
			}else if(http_request.responseText == "Disable\r\n"){
				window.location.reload();
			}else{
				if(ptstatus==true){
					ptstatus==false;
					var selectItem = document.getElementById("pIndex");
					var selectValue = selectItem.options[selectItem.selectedIndex].value;
					var positionName = document.getElementById("pName").value;
					setPositionName(selectValue,positionName);
				}	
			}
        }else {
            alert('There was a problem with the request.');
        }
    }
}

var http_request = false;

function makeRequest(url) {

    http_request = false;

    if (window.XMLHttpRequest) { // Mozilla, Safari,...
        http_request = new XMLHttpRequest();
        if (http_request.overrideMimeType) {
            http_request.overrideMimeType('text/xml;charset=utf-8');
        }
    } else if (window.ActiveXObject) { // IE
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
            http_request.setrequestheader("content-type","application/x-www-form-urlencoded; charset=utf-8");
        } catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
                http_request.setrequestheader("content-type","application/x-www-form-urlencoded; charset=utf-8");
            } catch (e) {}
        }
    }

    if (!http_request) {
        alert('Giving up :( Cannot create an XMLHTTP instance');
        return false;
    }
    http_request.onreadystatechange=alertContents;
    http_request.open("POST", url,true);
 	http_request.send(null);
}

function ptctl_move(act){
	ptstatus=false;
	makeRequest("/"+group+"/ptctl.cgi?move="+act);
}

function ptctl_setpreset(){
	var selectItem = document.getElementById("pIndex");
	var selectValue = selectItem.options[selectItem.selectedIndex].value;
	if(selectValue=="none"){
		alert(popup_msg[popup_msg_70]);
        selectItem.focus();
    	return;
	}
	ptstatus=true;
	makeRequest("/"+group+"/ptctl.cgi?position="+selectValue+"&positionname="+encodeURIComponent(document.getElementById("pName").value));
}
function buttontrig(){
		
		//var selectItem = document.getElementById("language2");
		var selectValue = selectItem.options[selectItem.selectedIndex].value;
		window.location = "../../<% getgroup(); %>/view.cgi?profile="+profile+"&language="+selectValue;		
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
	
	document.write("<img width=\"320\" height=\"240\" src = \"\/cgi\/mjpg\/mjpg.cgi\">");
}

</script>
</head>

<body onLoad="MM_preloadImages('img/but_liveview_over.gif','img/but_setup_over.gif','img/but_over.gif');start();">

<div  align="center" bgcolor="E6E6CA" id="viewerTR" name="viewerTR">  
   <!--"CONVERTED_APPLET"-->
   <script language="JavaScript" type="text/javascript">initView();</script>
   <!--"END_CONVERTED_APPLET"-->
</div>
<div>
<table width="50%" border="0" cellpadding="0" cellspacing="0" align="center" style="display:" bgcolor="#FFFFFF">
	<tr style="display:none">
    <td valign="top"><img src="img/spacer.gif" width="10" height="3"><br>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="100%" height="80" align="center" class="tdline">
		  			<form name="form1">
	            <div align="center">
		            <table width="70" border="0" cellpadding="0" cellspacing="2" bgcolor="CFCFA6" id="nighttd" style="display:none">
    	            <tr align="center" >
      	            <td width="70" background="img/bg_view.gif" class="t12"><a id="nighta" class="style3" href="javascript:nighttrig(this);"><span id="nightmode" name="nightmode"></span></a></td>					 
                  </tr>
                </table>
              </div>
				    </form>   		  			
					</td>
        </tr>
        <tr id="msgTR" name="msgTR" style=" display:none">
          <td width="100%" height="80" align="center" class="tdline"><b><span id="viewermsg" name="viewermsg"></span></b></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="1" valign="top"><img src="img/spacer.gif" height="3"><br>    
      <table width="100%" border="0" cellpadding="0" cellspacing="0" style="display:">
      	<tr>
        	<td background="images/bg.gif" align="center">
        		<table width="134" border="0" cellpadding="0" cellspacing="0">
          		<tr>
            		<td>
            			<a href="/" onMouseOver="MM_swapImage('a1','','images/but_liveview_1.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="images/but_liveview_1.gif" name="a1" width="134" height="26" vspace="5" border="0" id="a1"></a><br />
                	<a href="../admin/setup.cgi?page=system&language=<%getFrontLanguage();%>" onMouseOver="MM_swapImage('a2','','images/but_setup_1.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="images/but_setup_0.gif" name="a2" width="134" height="26" vspace="3" border="0" id="a2"></a><br />
            		</td>
            		<td>
              		<table width="98%" border="0" cellpadding="0" cellspacing="0" style="display:">
              			<tr>
              				<td height="80" align="center" class="">
												<table width="100%" border="0" cellpadding="0" cellspacing="0" id="pttb00" style="display:none">
                					<tr>
                						<td>
                  						<table width="100%" border="0" cellpadding="2" cellspacing="0" id="pttb01" style="display:none">
                    						<tr>
	                  							<td align="center">
	                    						<img src="img/but_ctrl.gif" border="0" usemap="#PTctrl"/>
																	<map name="PTctrl" id="PTctrl">
																	<area shape="poly" coords="5,42,23,24,32,33,27,40,27,48,31,58,22,66,7,51,4,47" href="javascript:;" onClick="ptctl_move('left');"/>
																	<area shape="poly" coords="49,90,55,86,69,71,62,63,54,66,45,67,37,63,27,71,42,86" href="javascript:;" onClick="ptctl_move('down');"/>
																	<area shape="poly" coords="93,45,88,38,74,25,65,33,69,40,69,49,65,58,74,66,89,51" href="javascript:;" onClick="ptctl_move('right');"/>
																	<area shape="poly" coords="53,3,69,19,61,28,53,25,45,25,36,28,28,20,43,4,48,2" href="javascript:;" onClick="ptctl_move('up');"/>
																	<area shape="circle" coords="49,46,16" href="javascript:;" onClick="ptctl_move('h');"/></map>
	                  							</td>
                    						</tr>
                   						</table>
                						</td> 
                					</tr>
                				</table>
                 			</td>
                 		</tr>
              		</table>
            		</td>
            		<td>
                	<table width="100%" border="0" cellpadding="0" cellspacing="0" id="pttb02" style="display:none">				
										<tr>
											<td>
                  			<table width="100%" border="0" cellpadding="3" cellspacing="2" id="pttb03" style="display:none">
                    			<tr>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p0');"><a href="javascript:;" class="f">1.<span id="p0" name="p0"><%getPositionName(1);%></span></a></td>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p4');"><a href="javascript:;" class="f">5.<span id="p4" name="p4"><%getPositionName(5);%></span></a></td>
                    			</tr>
                   			</table>
                 			</td> 
                		</tr>
                		<tr>
                			<td>
                  			<table width="100%" border="0" cellpadding="3" cellspacing="2" id="pttb04" style="display:none">
                    			<tr>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p1');"><a href="javascript:;" class="f">2.<span id="p1" name="p1"><%getPositionName(2);%></span></a></td>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p5');"><a href="javascript:;" class="f">6.<span id="p5" name="p5"><%getPositionName(6);%></span></a></td>
                    			</tr>
                   			</table>
                			</td> 
                		</tr>
                		<tr>
                			<td>
                  			<table width="100%" border="0" cellpadding="3" cellspacing="2" id="pttb05" style="display:none">
                    			<tr>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p2');"><a href="javascript:;" class="f">3.<span id="p2" name="p2"><%getPositionName(3);%></span></a></td>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p6');"><a href="javascript:;" class="f">7.<span id="p6" name="p6"><%getPositionName(7);%></span></a></td>
                    			</tr>
                   			</table>
                			</td> 
                		</tr>
                		<tr>
                			<td>
                  			<table width="100%" border="0" cellpadding="3" cellspacing="2" id="pttb06" style="display:none">
                    			<tr>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p3');"><a href="javascript:;" class="f">4.<span id="p3" name="p3"><%getPositionName(4);%></span></a></td>
	                  				<td width="50%" align="center" background="img/bg_view.gif" class="textori" onClick="ptctl_move('p7');"><a href="javascript:;" class="f">8.<span id="p7" name="p7"><%getPositionName(8);%></span></a></td>
                    			</tr>
                   			</table>
                			</td> 
                		</tr>
                		<tr>
                			<td>
                  			<table width="100%" border="0" cellpadding="3" cellspacing="0" id="pttb07" style="display:none">
                    			<tr>
	                  				<td height="21" align="center">
		                				<select id="pIndex" name="pIndex">
		                				<option value="none" selected>--</option>
		                				<option value="0">1</option>
		                				<option value="1">2</option>
		                				<option value="2">3</option>
		                				<option value="3">4</option>
		                				<option value="4">5</option>
		                				<option value="5">6</option>
		                				<option value="6">7</option>
		                				<option value="7">8</option>
		                				</select>
	                  				</td>
	                  				<td height="21" align="center"><input name="pName" type="text" id="pName" value="" size="6" maxlength="6"></td>
	                  				<td height="21" align="center"><input type="button" id="Button" name="Button" value="" onClick="ptctl_setpreset();"></td>
                    			</tr>
                   			</table>
                			</td>
                		</tr>
              		</table>
            		</td>
            		<td>
              		<table width="100%" border="0" cellpadding="4" cellspacing="2" id="ctltb" style="display:none">
                		<tr>
											<td width="37%" class="bglblue" onClick="ptctl_move('pscan');" align="center" id="ptscantd" style="display:none"><a href="javascript:;" class="a" id="ptscan"><b><span id="pan_scan" name="pan_scan"></span></b></a></td>
											<td width="50%" class="bglblue" onClick="ptctl_move('patrol');" align="center" id="ptpatroltd"><a href="javascript:;" class="a" id="ptpatrol"><span id="auto_patrol" name="auto_patrol"></span></a></td>
											<td width="50%" class="bglblue" onClick="ptctl_move('stop');" align="center" id="ptstoptd"><a href="javascript:;" class="a" id="ptstop"><span id="stop" name="stop"></span></a></td>
										</tr>
										<tr>
                  		<td colspan="3" class="bglblue" onClick="trigout(this);" align="center" id="tgtd"><a href="javascript:;" class="a" id="trig"><span id="triggerout" name="triggerout"></span></a></td>
                		</tr>
              		</table>
           			</td>
          		</tr>
        		</table>
        	</td>
      	</tr>
    	</table>
		</td>
	</tr>
</table>
</div>
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
