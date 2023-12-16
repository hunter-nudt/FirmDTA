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
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="json.js"></script>
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript" type="text/javascript">

var result = "<%getResult();%>";

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("network_2",item_name[_NETWORK]);
	setContent("wireless",item_name[_WIRELESS]);
	setContent("wps_set",item_name[_WPS_SETTING]);
	setContent("protectedsetup",item_name[_PROTECTEDSETUP]);
	//setContent("resettounconfigured",item_name[_RETOUNCONFIGURED]);
	setContent("wps",item_name[_WPS]);
	setContent("pin_mode",item_name[_PIN_MODE]);
	setContent("pin_code",item_name[_PIN_CODE]);
	setContent("registar_id",item_name[_REGISTAR_ID]);
	setContent("pbc_mode",item_name[_PBC_MODE]);
	setContent("devicestatus",item_name[_DEVICESTATUS]);
	setContent("nouse",popup_msg[popup_msg_85]);
	setContent("inwcn",popup_msg[popup_msg_86]);
	setContent("pin_connect",popup_msg[popup_msg_79]);
	//setContent("sec",item_name[_WPS_SEC]);
	setContent("pbc_connect",popup_msg[popup_msg_80]);
	//setContent("sec2",item_name[_WPS_SEC]);
	setContent("use_state",popup_msg[popup_msg_81]);
	setContent("state_success",popup_msg[popup_msg_82]);
	setContent("state_error",popup_msg[popup_msg_83]);
	setContent("state_stop",popup_msg[popup_msg_84]);
	setContent("_essid",item_name[_ESSID]);
	setContent("mac",item_name[_MAC]);
	setContent("channel_1",item_name[_CHANNEL]);
	setContent("mode",item_name[_MODE]);
	setContent("privacy",item_name[_PRIVACY]);
	setContent("signal",item_name[_SIGNAL]);
	document.getElementById("wpsreset").value=item_name[_RETOUNCONFIGURED];
	document.getElementById("surveybtn").value=item_name[_SITE_SURVEY];
	document.getElementById("connect").value=item_name[_CONNECT];
	document.getElementById("stopbutton").value=item_name[_WPSCANCEL];
	
}

function makesurvey(){

	searchState(true);
	makeRequest("/admin/sitesurvey.cgi"); 
}
var sites = ''

function addCol(rowobj,text,pos){
	var cellobj = rowobj.insertCell(pos);
	var textNode = document.createTextNode(text);
	cellobj.appendChild(textNode);
}

function selectRow(idx){
	var i;
	var tbobj =document.getElementById("surveytbl");
	if(idx>=0)
	{	for(i=1;i<tbobj.rows.length;i++)
		{
			if(idx == i)
				tbobj.rows[i].style.backgroundColor = "#C5CEDA";
			else
				tbobj.rows[i].style.backgroundColor = "#ffffff";
		}
	}
}
function setChannel(ch){
	var o = document.form1;
	var i;
	for(i=0;i<o.channel.length;i++)
	{
		if(o.channel[i].value == ch)
			o.channel.selectedIndex = i;
	}
}
function getRowData(idx){
	selectRow(idx);
	var i;
	var o = document.form1;
	if(idx>=1)
		i = idx -1;
	o.essid.value = jobj.mySites[i].essid
	if(jobj.mySites[i].conntype == 0)
	{	o.connmode[1].checked = true;
		setChannel(jobj.mySites[i].channel);
		
	}
}
var siteAuthArr = new Array("OPEN",//0
					"SHARED",//1
					"WPA",//2 - can't use
					"WPA-PSK",//3
					"WPANONE",//4 - can't use, WPA for Ad-Hoc
					"WPA2",//5 - can't use
					"WPA2-PSK",//6
					"WPA(2)-PSK",//7
					"WPA(2)",//8 - can't use
					"WPA/WPA-PSK",//9
					"WPA2/WPA2-PSK",//10
					"WPA(2)/WPA(2)-PSK",//11
					"Unknown");

var siteEncArr = new Array("NONE",//0
						"WEP",//1
						"TKIP",//2
						"AES",//3
						"TKIP,AES",//4
						"Unknown");		
						
function addRow(essid,mac,channel,conntype,privacy,signal,idx){
	var obj =  document.getElementById("surveytbl");
	obj.style.display = "";
	var lastRow = obj.rows.length;
	var row = obj.insertRow(lastRow);
	row.onclick = function(){ selectRow(idx);}
	row.ondblclick = function(){ getRowData(idx);}
	addCol(row,essid,0);
	addCol(row,mac,1);
	addCol(row,channel,2);
	addCol(row,conntype,3);
	addCol(row,privacy,4);
	addCol(row,signal,5);
	obj.rows[idx].style.backgroundColor = "#ffffff";
}
function deleteRows(tblObj,idx)
{
		while(tblObj.rows.length>idx) {
			tblObj.deleteRow(1)
		}
}
var connArr =  new Array("Ad-Hoc","Infrastructure","Automatic");
var privacyArr = new Array("No","Yes");
var jobj; //JSON objects
function parseData(){
	jobj = sites.parseJSON()
	var i;
	//clear table
	var obj =  document.getElementById("surveytbl");
	deleteRows(obj,1);

	
	for(i=0;i<jobj.mySites.length;i++){
		/*addRow(jobj.mySites[i].essid,
		jobj.mySites[i].mac,
		jobj.mySites[i].channel,
		connArr[jobj.mySites[i].conntype],
		privacyArr[jobj.mySites[i].privacy],
		jobj.mySites[i].signal+"%",
		siteAuthArr[jobj.mySites[i].auth],
		siteEncArr[jobj.mySites[i].enc],
		i+1);*/
		addRow(jobj.mySites[i].essid,
		jobj.mySites[i].mac,
		jobj.mySites[i].channel,
		connArr[jobj.mySites[i].conntype],
		privacyArr[jobj.mySites[i].privacy],
		jobj.mySites[i].signal+"%",
		i+1);
	}
	goSetHeight();
}
var http_request = false;

function makeRequest(url) {

    http_request = false;

    if (window.XMLHttpRequest) { // Mozilla, Safari,...
        http_request = new XMLHttpRequest();
        if (http_request.overrideMimeType) {
            http_request.overrideMimeType('text/xml');
        }
    } else if (window.ActiveXObject) { // IE
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {}
        }
    }

    if (!http_request) {
        alert('Giving up :( Cannot create an XMLHTTP instance');
        return false;
    }
    http_request.onreadystatechange = alertContents;
    http_request.open('GET', url, true);
    http_request.send(null);

}

function doingButton(obj,val,dis){
	obj.value = val;
	obj.disabled = dis;
}
function searchState(st){
	var btn = document.getElementById("surveybtn");
	if(st)
		doingButton(btn,item_name[_SEARCH], true);
	else
		doingButton(btn,item_name[_SITE_SURVEY], false);
	

}
function alertContents() {

    if (http_request.readyState == 4) {
        if (http_request.status == 200) {
			sites = http_request.responseText
			parseData();
			searchState(false);
        } else {
            alert('There was a problem with the request.');
        }
    }

}

function timemode(){
		var mode="<% getWpsConnectMode(); %>";
    	var obj = document.form1;
    	if (obj.wpsmode[0].checked){
       		 document.getElementById("timecount1").style.display = "";
		
		}	
    	else{
    
	     document.getElementById("timecount2").style.display = "";
		}     	
		document.getElementById("statesuccess").style.display = "none";
		document.getElementById("stateerror").style.display = "none";
		document.getElementById("nousetab").style.display = "none";
			
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

var secs = 180; var wait = secs * 1000; 

function countDown(){
	var mode;
	var obj = document.form1;
	if (obj.wpsmode[0].checked)
		mode=0;
	else
		mode=1;
	for(i = 1; i <= secs; i++) { 
		setTimeout("update(" + i + ")", i * 1000); 
	}
}

function update(num) { 
		if (num == (wait/1000)) { 
		document.form1.connect.value = item_name[_CONNECT]; 
		} else { printnr = (wait / 1000)-num; 
		document.form1.connect.value =   printnr + item_name[_SECS]; 
		}
}

function wpsstates(){

	var state=<% getWpsStates(); %>;
	var obj = document.form1;
	var obj2 = document.formstop;
	if (obj.wpsmode[1].checked)
		obj.surveybtn.disabled = true;
	if (obj.wpsmode[0].checked)
		obj.surveybtn.disabled = "";
	obj2.stopbutton.disabled = true;
	
	if(state == 0)
		document.getElementById("nousetab").style.display = "";
	else if(state == 3){
	    document.getElementById("stateuse").style.display = "";
	    obj.surveybtn.disabled = true;
	    obj.wpsmode[0].disabled = true;
		obj.wpsmode[1].disabled = true;
		obj.connect.disabled = true;
		obj2.stopbutton.disabled = "";
    }
	if(result=="sucess" || state == 1){
		document.getElementById("statesuccess").style.display = "";
		document.getElementById("nousetab").style.display = "none";
	}
	else if(result=="fail" || state == 2){
		document.getElementById("stateerror").style.display = "";
		document.getElementById("nousetab").style.display = "none";
	}
	else if(result=="stop"){
		document.getElementById("statestop").style.display = "";
		document.getElementById("nousetab").style.display = "none";
	}
	goSetHeight();
} 
function buttontrig(){
	var obj = document.form1;
	var obj2 = document.formreset;
	var obj3 = document.formstop;
	obj3.stopbutton.disabled = "";
	//obj.surveybtn.disabled = true;
	obj.connect.disabled = true;
	
	//obj2.wpsreset.disabled = true;
	document.getElementById("nousetab").style.display = "none";
	document.getElementById("inwcntab").style.display = "none";
	document.getElementById("statestop").style.display = "none";
	obj.submit();
	obj.wpsmode[0].disabled = true;
	obj.wpsmode[1].disabled = true;
	//obj.essid.disabled=true;
}

function buttontrig3(){
	var obj = document.formstop;
	
	obj.submit();
}
var confstat="<% getWPSConf(); %>"

function wpsconfstates(){
	var obj = document.formreset;
	if(confstat == 0)
	obj.wpsreset.disabled = true;
}

function hideserver(){
	var obj = document.form1;
		obj.surveybtn.disabled = true;
}
function openserver(){
	var obj = document.form1;
		obj.surveybtn.disabled = "";
}
</script>
<body onLoad="start();goSetHeight();wpsstates();wpsconfstates();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="network_2" name="network_2"></span>&nbsp;&raquo;&nbsp;<span id="wireless" name="wireless"></span>&nbsp;&raquo;&nbsp;<span id="wps_set" name="wps_set"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      	<tr style=" display:none">
        	<td colspan="2" class="greybluebg"><span id="protectedsetup" name="protectedsetup"> </span></td>
      	</tr>
     	 	<tr style=" display:none">
      		<td>
      			<table width="100%"  border="0"><form action="wpsreset.cgi" method="get" name="formreset">
              <tr>
                <td><span class="style7"> 
                    <input type="submit" id="wpsreset" name="wpsreset" value="" onClick="">                
                    <input type="hidden" name="type" value="0" />
                </span></td>
              </tr></form>
            </table>
        	</td>
      	</tr>
      	<tr>
        	<td colspan="2" class="greybluebg"><span id="wps" name="wps"> </span></td>
      	</tr>
      	<tr>
      		<td>
      			<form  action="wps.cgi" method="post" name="form1">
      			<table width="100%"  border="0" id="pintime" style="display:">
           		<tr>
             		<td colspan="2" class="bggrey"><span class="style7">
              		<input name="wpsmode" type="radio" value="0" <% getWpsConnect("0"); %> onClick="openserver();"> 
                	<span id="pin_mode" name="pin_mode"></span>:</span></td>
           		</tr>
           		<tr>	
              	<td class="bgblue">&nbsp;&nbsp;&nbsp;<span class="style7">
                  	<span id="pin_code" name="pin_code"></span>:</span><span class="t12"> </span></td>
                <td class="bggrey"><span class="style7"><% getPinCode(); %></span>&nbsp;</td>
           		</tr>
           		<tr style=" display:none">
           			<td class="bgblue">&nbsp;&nbsp;&nbsp;<span class="style7">
                  	<span id="registar_id" name="registar_id"></span>:</span><span class="t12"> </span></td>
                <td class="bggrey"><input name="essid" type="text" id="essid" value="<% getWlanEssid("1"); %>" size="15" maxlength="26">
                <input name="surveybtn" type="button" id="surveybtn" value="" onClick="makesurvey();"></td>
        	  	</tr>
      			</table>
      			<table width="98%" align="center"   border="0" cellpadding="2" cellspacing="1" bgcolor="#333333" id="surveytbl" class="box_tn2" style="display:none; " >
							<tr class="style6">
								<td bgcolor="#CCCCCC"><span class="style7"><span id="_essid" name="_essid"></span></span></td>
								<td bgcolor="#CCCCCC"><span class="style7"><span id="mac" name="mac"></span></span></td>
								<td bgcolor="#CCCCCC"><span class="style7"><span id="channel_1" name="channel_1"></span></span></td>
								<td bgcolor="#CCCCCC"><span class="style7"><span id="mode" name="mode"></span></span></td>
								<td bgcolor="#CCCCCC"><span class="style7"><span id="privacy" name="privacy"></span></span></td>
								<td bgcolor="#CCCCCC"><span class="style7"><span id="signal" name="signal"></span></span></td>
							</tr>
	  					<tr>
	  				    <td width="7%" bgcolor="#EFEFEF">&nbsp;</td>
	  				    <td width="5%" bgcolor="#EFEFEF">&nbsp;</td>
	  				    <td width="6%" bgcolor="#EFEFEF">&nbsp;</td>
	  				    <td width="6%" bgcolor="#EFEFEF">&nbsp;</td>
	  				    <td width="6%" bgcolor="#EFEFEF">&nbsp;</td>
	  				    <td width="24%" bgcolor="#EFEFEF">&nbsp;</td>
	  				  </tr>
    				</table>			
    				<table width="100%" border="0">
   	  		 		<tr>
                <td colspan="2" class="bggrey"><span class="style7">
                 <input name="wpsmode" type="radio" value="1" <% getWpsConnect("1"); %> onClick="hideserver();"> 
                  <span id="pbc_mode" name="pbc_mode"></span>:</span></td>          	
           		</tr>
	   	  			<tr>
	   	    			<td align="right"><input name="connect" type="button" style ="width:80px" id="connect" value="" onclick="countDown();timemode();goSetHeight();buttontrig();"></form></td>
	   	    			<td><form  action ="wpsstop.cgi" method="post" name="formstop"><input name="stopbutton" type="button" style ="width:80px" id="stopbutton" onclick="buttontrig3();"></form></td>
	      			</tr>
      			</table>
      		</td>
      	</tr>
      	<tr>
        	<td colspan="2" class="greybluebg"><span id="devicestatus" name="devicestatus"> </span></td>
      	</tr>
      	<tr>
      		<td>
      			<form action="" method="post" name="formstatus">
      				<table width="100%"  border="0" id="stateuse"  style="display:none">  
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="use_state" name="use_state"></span></td>
             		</tr>
  		 				</table>
  		 				<table width="100%"  border="0" id="statesuccess"  style="display:none">  
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="state_success" name="state_success"></span></td>
             		</tr>
  		 				</table> 
  		 				<table width="100%"  border="0" id="stateerror"  style="display:none">
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="state_error" name="state_error"></span></td>
             		</tr>
  		 				</table> 
  		 				<table width="100%"  border="0" id="statestop"  style="display:none">
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="state_stop" name="state_stop"></span></td>
             		</tr>
  		 				</table>
  		 				<table width="100%"  border="0" id="nousetab"  style="display:none">
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="nouse" name="nouse"></span></td>
             		</tr>
  		 				</table>
  		 				<table width="100%"  border="0" id="inwcntab"  style="display:none">
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="inwcn" name="inwcn"></span></td>
             		</tr>
  		 				</table>
   	  	 			<table width="100%"  border="0" id="timecount1"  style="display:none">
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="pin_connect" name="pin_connect"></span></td>
             		</tr>
  		 				</table> 
  		  			<table width="100%"  border="0" id="timecount2"  style="display:none">
            		<tr> 		 
              		<td class="bggrey"><span class="style7"><span id="pbc_connect" name="pbc_connect"></span></td>
             		</tr>
  		 				</table> 
   	  				<input type="hidden" name="connect2" value="-1"/>
							<input type="hidden" name="virtual2" value="-1"/>
							<input type="hidden" name="essid2" value=""/>
							<input type="hidden" name="wpsmode2" value=""/>
           </form>
      		</td>
      	</tr>
    	</table>
  	</td>
  </tr>
</table>
