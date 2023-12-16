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
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("network_2",item_name[_NETWORK]);
	setContent("wireless_set",item_name[_WIRE_SETTING]);
	setContent("wireless_1",item_name[_WIRELESS]);
	setContent("enable_1",item_name[_ENABLE]);
	setContent("network_id",item_name[_NETWORK_ID]);
	setContent("_essid",item_name[_ESSID]);
	setContent("mac",item_name[_MAC]);
	setContent("channel_1",item_name[_CHANNEL]);
	setContent("mode",item_name[_MODE]);
	setContent("privacy",item_name[_PRIVACY]);
	setContent("signal",item_name[_SIGNAL]);
	setContent("wireless_mode",item_name[_WIRELESS_MODE]);
	setContent("infrastruc",item_name[_INFRASTRUC]);
	setContent("ad_hoc",item_name[_AD_HOC]);
	setContent("channel_2",item_name[_CHANNEL]);
	setContent("auth",item_name[_AUTH]);
	setContent("encryption",item_name[_ENCRYPTION]);
	setContent("none",item_name[_NONE]);
	setContent("wep",item_name[_WEP]);
	setContent("format",item_name[_FORMAT]);
	setContent("ascii",item_name[_ASCII]);
	setContent("hex",item_name[_HEX]);
	setContent("key_len",item_name[_KEY_LENGTH]);
	setContent("_64bits",item_name[_BITS_64]);
	setContent("_128bits",item_name[_BITS_128]);
	setContent("wep_key_1",item_name[_WEP_K1]);
	setContent("wep_key_2",item_name[_WEP_K2]);
	setContent("wep_key_3",item_name[_WEP_K3]);
	setContent("wep_key_4",item_name[_WEP_K4]);
	setContent("encryption_1",item_name[_ENCRYPTION]);
	setContent("tkip",item_name[_TKIP]);
	setContent("aes",item_name[_AES]);
	setContent("pre_share_key",item_name[_PRE_SHAR_KEY]);

	document.getElementById("surveybtn").value=item_name[_SITE_SURVEY];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}	

function disChannel(){
	var o = document.form1;
	o.channel.disabled = o.connmode[0].checked;
	authSwap();
}

function disChannel1(){
	var o = document.form1;
	o.channel.disabled = o.connmode[0].checked;
	authSwap();
	checkSecu(o.authmode.selectedIndex);
}

function insertAuthArr(o,arrobj,pidx){
	var i;
	var opt;
	for(i=0;i<arrobj.length;i++)
	{
			opt = new Option(arrobj[i],i);
			o.options[o.length] = opt;
			if(pidx == i)
				o.options.selectedIndex = i;
	}
}

var authArr =  new Array("Open","Shared-Key","WPA-PSK","WPA2-PSK");
var authArr2 =  new Array("Open","Shared-Key");

function authSwap(){
	var o = document.form1;
	var pidx = o.authmode.selectedIndex
	if(o.connmode[0].checked)
	{
		o.authmode.length = 0;
		insertAuthArr(o.authmode,authArr,pidx);
	}
	else if(o.connmode[1].checked)
	{
		o.authmode.length = 0;
		insertAuthArr(o.authmode,authArr2,pidx);
	}
	hide();
	disableSecu(document.form1.authmode.selectedIndex);	
}
var nosignal = false;
function init(){
	if(document.form1.enable.checked == false)
	{
			nosignal = true;
			document.getElementById("signaltbl").style.display = "none";
			if (parent != window)
				parent.setEnable("0");
			return;
	}
	if (parent != window)
		parent.setEnable("1");
	disChannel();
	hide();
	disableSecu(document.form1.authmode.selectedIndex);	
}
function hide(){

	var obj = document.getElementById("authmode");
	var objwep = document.getElementById("tabwep");
	var objwpa = document.getElementById("tabwpa");
	
	if((obj.options[0].selected == true)||	(obj.options[1].selected == true))
	{
		objwep.style.display = "";
		objwpa.style.display = "none";

	}
	else if((obj.options[2].selected == true)||	(obj.options[3].selected == true))
	{
		objwep.style.display = "none";
		objwpa.style.display = "";

	}

}
function disableSecu(idx){
	var obj = document.form1;
	if(idx == 1)
		obj.secumode[0].disabled = true;
	else
		obj.secumode[0].disabled = false;
	
	if(obj.secumode[0].checked)
		disableWep(true);
	else
		disableWep(false);
}
function checkSecu(idx){
	var obj = document.form1;
	obj.secumode[idx].checked =true;
	disableSecu(idx);
	goSetHeight();
}

function send(){
	var obj = document.form1;
	if(asciiCheck(obj.essid) == false) return;
	
	if((obj.authmode[0]!=null)&&(obj.authmode[1]!=null))
	{
		if(((obj.authmode[0].selected)&&(obj.secumode[1].checked))||(obj.authmode[1].selected == true))
		{
	
			var def = eval("obj.wepkey" + (getRadioCheckedIndex(obj.wepdefaultkey)+1));	
			if(def.value == "")
			{	
				warnAndSelect(def,popup_msg[popup_msg_16]);
					return;
			}

			if((obj.wepkey1.value != "")&&(wepCheck(obj.wepkey1,getRadioCheckedIndex(obj.wepformat),getRadioCheckedIndex(obj.weplength))==false)) return ;
			if((obj.wepkey2.value != "")&&(wepCheck(obj.wepkey2,getRadioCheckedIndex(obj.wepformat),getRadioCheckedIndex(obj.weplength))==false)) return ;
			if((obj.wepkey3.value != "")&&(wepCheck(obj.wepkey3,getRadioCheckedIndex(obj.wepformat),getRadioCheckedIndex(obj.weplength))==false)) return ;
			if((obj.wepkey4.value != "")&&(wepCheck(obj.wepkey4,getRadioCheckedIndex(obj.wepformat),getRadioCheckedIndex(obj.weplength))==false)) return ;
		}
	}
	if((obj.authmode[2]!=null)&&(obj.authmode[3]!=null)){
		if((obj.authmode[2].selected == true)||	(obj.authmode[3].selected == true))
		{
			if(wpaCheck(obj.wpakey)==false) return ;
		}
	}
	obj.submit();
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
	else 
		o.connmode[0].checked = true;
	disChannel();		



}
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
		addRow(jobj.mySites[i].essid,jobj.mySites[i].mac,jobj.mySites[i].channel,connArr[jobj.mySites[i].conntype],privacyArr[jobj.mySites[i].privacy],jobj.mySites[i].signal+"%",i+1);
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

function disableWep(arg){
	var obj = document.form1;
	obj.wepformat[0].disabled=arg;
	obj.wepformat[1].disabled=arg;
	obj.weplength[0].disabled=arg;
	obj.weplength[1].disabled=arg;
	obj.wepdefaultkey[0].disabled=arg;
	obj.wepdefaultkey[1].disabled=arg;
	obj.wepdefaultkey[2].disabled=arg;
	obj.wepdefaultkey[3].disabled=arg;
	obj.wepkey1.disabled=arg;
	obj.wepkey2.disabled=arg;
	obj.wepkey3.disabled=arg;
	obj.wepkey4.disabled=arg;
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="network_2" name="network_2"></span>&nbsp;&raquo;&nbsp;<span id="wireless_set" name="wireless_set"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<form action="wireless.cgi" method="post" name="form1">
  			<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="wireless_1" name="wireless_1"> </span></td>
      		</tr>
      		<tr>
        		<td width="150" valign="top"  class="bgblue"><span id="enable_1" name="enable_1"></span></td>
        		<td class="bggrey"><input name="enable" type="checkbox" id="enable" value="1" <% getWlanEnable("1"); %>></td>
      		</tr>
      	</table>
      	<div id="signaltbl">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn2">
	      	<tr>
	        	<td width="150" valign="top"  class="bgblue"><span id="network_id" name="network_id"></span>: </td>
	        	<td class="bggrey">
	        		<input name="essid" type="text" id="essid" value="<% getWlanEssid("1"); %>" size="20" maxlength="32">
	        		<input name="surveybtn" type="button" id="surveybtn" value="" onClick="makesurvey();">
	        	</td>
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
    		<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn2" style="dis">
      		<tr>
        		<td width="150" valign="top"  class="bgblue"><span id="wireless_mode" name="wireless_mode"></span>:</td>
        		<td class="bggrey">
        			<input name="connmode" type="radio" value="0" <% getWlanConnmode("0"); %> onClick="disChannel1();">
          		<span class="style7"><span id="infrastruc" name="infrastruc"></span></span>
          		<input name="connmode" type="radio" value="1" <% getWlanConnmode("1"); %> onClick="disChannel1();">
          		<span class="style7"><span id="ad_hoc" name="ad_hoc"></span></span></td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="channel_2" name="channel_2"></span>: </td>
        		<td class="bggrey"><select name="channel" id="channel"><% getWlanChannel(); %></select></td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="auth" name="auth"></span>:</td>
        		<td class="bggrey"><select name="authmode" id="authmode" onChange="hide();checkSecu(this.selectedIndex)"><% getWlanAuth(); %></select></td>
      		</tr>
    		</table>
    		<br>
    		<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn2" id="tabwep" name="tabwep" >
      		<tr>
        		<td width="150" valign="top"  class="bgblue"><span id="encryption" name="encryption"></span>: </td>
        		<td class="bggrey">
        			<input name="secumode" type="radio" value="0" <% getWlanSecurity("0"); %> onClick="disableWep(true);">
          		<span class="style7" id="none" name="none"></span>
            	<input name="secumode" type="radio" value="1" <% getWlanSecurity("1"); %> onClick="disableWep(false);">
            	<span class="style7" id="wep" name="wep"></span>
            </td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="format" name="format"></span>: </td>
        		<td class="bggrey">
        			<input name="wepformat" type="radio" value="0" <% getWlanWepFormat("0"); %>>
          		<span class="style7" id="ascii" name="acsii"></span>
          		<input name="wepformat" type="radio" value="1" <% getWlanWepFormat("1"); %>>
          		<span class="style7" id="hex" name="hex"></span>
          	</td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="key_len" name="key_len"></span>: </td>
        		<td class="bggrey">
        			<input name="weplength" type="radio" value="0" <% getWlanWepLength("0"); %>>
          		<span class="style7" id="_64bits" name="_64bits"></span>
          		<input name="weplength" type="radio" value="1"<% getWlanWepLength("1"); %>>
          		<span class="style7" id="_128bits" name="_128bits"></span>
          	</td>
      		</tr>
      		<tr>
        		<td class="bgblue">
        			<input name="wepdefaultkey" type="radio" value="1"  <% getWlanWepDefKey("1"); %>>
          		<span id="wep_key_1" name="wep_key_1"></span>:
          	</td>
        		<td class="bggrey"><input name="wepkey1" type="password" id="wepkey1" value="<% getWlanWepKey1("1"); %>" size="20" maxlength="26"></td>
      		</tr>
      		<tr>
        		<td class="bgblue">
        			<input name="wepdefaultkey" type="radio" value="2" <% getWlanWepDefKey("2"); %>>
          		<span id="wep_key_2" name="wep_key_2"></span>:
          	</td>
        		<td class="bggrey"><input name="wepkey2" type="password" id="wepkey2" value="<% getWlanWepKey2("1"); %>" size="20" maxlength="26"></td>
      		</tr>
      		<tr>
        		<td class="bgblue">
        			<input name="wepdefaultkey" type="radio" value="3" <% getWlanWepDefKey("3"); %>>
          		<span id="wep_key_3" name="wep_key_3"></span>:
          	</td>
        		<td class="bggrey"><input name="wepkey3" type="password" id="wepkey3" value="<% getWlanWepKey3("1"); %>" size="20" maxlength="26"></td>
      		</tr>
      		<tr>
        		<td class="bgblue">
        			<input name="wepdefaultkey" type="radio" value="4" <% getWlanWepDefKey("4"); %>> 
          		<span id="wep_key_4" name="wep_key_4"></span>:
          	</td>
        		<td class="bggrey"><input name="wepkey4" type="password" id="wepkey4" value="<% getWlanWepKey4("1"); %>" size="20" maxlength="26">                </td>
      		</tr>
    		</table>
    		<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn2" id="tabwpa"  name="tabwpa">
      		<tr>
        		<td width="150" valign="top"  class="bgblue"><span id="encryption_1" name="encryption_1"></span>: </td>
        		<td class="bggrey">
        			<input name="secumode" type="radio" value="2"  <% getWlanSecurity("2"); %>>
          		<span class="style7"><span id="tkip" name="tkip"></span></span>
            	<input name="secumode" type="radio" value="3" <% getWlanSecurity("3"); %>>
            	<span class="style7"><span id="aes" name="aes"></span></span>
            </td>
      		</tr>
      		<tr>
        		<td class="bgblue"><span id="pre_share_key" name="pre_share_key"></span>: </td>
        		<td class="bggrey"><input name="wpakey" type="password" id="wpakey" value="<% getWlanPsk("1"); %>" size="20" maxlength="64"></td>
      		</tr>
    		</table>
				</div>
				<table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td class="bggrey2">
        			<input type="button" id="Button" name="Button" value="" class="ButtonSmall" onClick="send();">
        			<input type="button" id="Button1" name="Button1" value="" class="ButtonSmall" onClick="reloadScreen('wireless.asp');">
        		</td>
      		</tr>
    		</table>
    	</form>
    <br>
  	</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">init();</script>
</body>
</html>
