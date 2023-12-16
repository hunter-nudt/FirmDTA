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
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("event_config_1",item_name[_EVENT_CONFIGURATION]);
	setContent("arrange_sch",item_name[_ARRANGE_SCH]);
	setContent("sch_profile_1",item_name[_SCHEDULE_PROF]);
	setContent("pro_name",item_name[_PROFILE_NAME]);
	setContent("weekdays_1",item_name[_WEEKDAYS]);
	setContent("sun",item_name[_SUN]);
	setContent("mon",item_name[_MON]);
	setContent("tue",item_name[_TUE]);
	setContent("wed",item_name[_WED]);
	setContent("thu",item_name[_THU]);
	setContent("fri",item_name[_FRI]);
	setContent("sat",item_name[_SAT]);
	setContent("time_list",item_name[_TIME_LIST]);
	setContent("start_time",item_name[_START_TIME]);
	setContent("end_time",item_name[_END_TIME]);

	document.getElementById("actadd").value=item_name[_ADD];
	document.getElementById("adddel").value=item_name[_DELETE];
	document.getElementById("addmod").value=item_name[_SAVE];
	document.getElementById("Button1").value=item_name[_CANCEL];
	document.getElementById("Button3").value=item_name[_ADD];
	document.getElementById("Button32").value=item_name[_COPY_THIS];
	document.getElementById("Button222").value=item_name[_DELETE];
	document.getElementById("Button322").value=item_name[_DELETE_THIS];
}	

//addEl('dump','button','check value','onclick',foo);
//addEl('dump','text','bar');

function addEl(target_id,typ,nam,val,onevnt,func){
var el=document.createElement('input');
el.type=typ;
if(nam) el.name=nam;
if(val)el.value=val;
if(onevnt)el[onevnt]=func;
document.getElementById(target_id).appendChild(el);
}

function foo(){
alert(document.getElementById('sometext').value);
}

function data(name,weekday, start, end){
	var startarr;
	var endarr;
	this.name = name;
	this.weekday = null;
	this.start = null;
	this.starthr = null;
	this.startmin = null;
	this.endhr = null;
	this.endmin = null;
	if(weekday!=null)this.weekday = weekday;	
	if(start!=null)
	{
	
	this.start = start;
	startarr = start.split(":");
	this.starthr = startarr[0];
	this.startmin = startarr[1];

	}
	if(end!=null)
	{
	this.end = end;	
	endarr = end.split(":");
	this.endhr = endarr[0];
	this.endmin = endarr[1];

	}
	
	this.clone = function(){
		return new data(this.name,this.weekday,this.start,this.end);
	}
	this.equals = function (dataobj){
		if((dataobj.name == this.name)&&
		(dataobj.weekday == this.weekday)&&
		(dataobj.start == this.start)&&
		(dataobj.end == this.end))
			return true;
		return false;
		
	}
}

var modified = false;
	
var lstarr = new Array();

<% getScheData(); %>
var formobj;//reference to document.form1
function InProfileList(name){
	
	var i;
	for(i=0;i<formobj.list.length;i++)
		if(formobj.list[i].value == name)
				return true;
	return false;
}

function insertProfile(){
	var i;
	for(i=0;i<lstarr.length;i++)
	{
		if((!InProfileList(lstarr[i].name))&&(lstarr[i].name.toUpperCase() != "ALWAYS"))
		{
			opt = new Option(lstarr[i].name,lstarr[i].name);
			formobj.list.options[formobj.list.length] = opt;
		}		
	}
}

function getTimeByWeekday(wkday){

	var i,day;
	formobj.tlist.length = 0;
	if(wkday == null){
		formobj.addmod.disabled=true;
		day =  getRadioCheckedIndex(formobj.weekdays)
	}else
		day = wkday;

	var tday = document.getElementById("weektext"+0)
	for(i=0;i<7;i++)
	{
		tday = document.getElementById("weektext"+lstarr[i].weekday)
		tday.className = ""
	}
	for(i=0;i<lstarr.length;i++)
	{
		if((formobj.list.selectedIndex>=0)&&(lstarr[i].name == formobj.list[formobj.list.selectedIndex].text)&&(lstarr[i].weekday != null))
		{
			tday = document.getElementById("weektext"+lstarr[i].weekday);
			tday.className = "bluetextbold";
		}
	}
		
	for(i=0;i<lstarr.length;i++)
	{
		if((formobj.list.selectedIndex>=0)&&(lstarr[i].name == formobj.list[formobj.list.selectedIndex].text) &&(lstarr[i].weekday == day))
		{
			opt = new Option(lstarr[i].starthr+":"+lstarr[i].startmin+" - " +lstarr[i].endhr+":"+lstarr[i].endmin,i);
			formobj.tlist[formobj.tlist.length] = opt;
		}
	}
	goSetHeight();
}

function delArrayElement3(srcarr,idx)
{
	var i;
	if((idx<=(srcarr.length-1))&&(idx>=0))
	{for(i=idx;i<srcarr.length;i++)
		srcarr[i] =  srcarr[i+1];
		srcarr.length = srcarr.length -1;
	}
	return srcarr;
}

function delArrayElement2(srcarray,idx)
{
        if((idx<=(srcarray.length-1))&&(idx>=0))
        {for(i=idx;i<srcarray.length;i++)
                srcarray[i] =  srcarray[i+1];
                srcarray.length = srcarray.length -1;
        }
        return srcarray;
}
function delArrayElement(srcarray,idx)
{
	srcarray.splice(idx,1);
	return srcarray;
}

function checkTime(starthr,startmin,endhr,endmin){
	if( (isPosInt(starthr.value) && range(starthr.value,0,23) ) == false)
	{
		warnAndSelect(starthr,popup_msg[popup_msg_33]);
		return false;
	}
	if( (isPosInt(startmin.value) && range(startmin.value,0,59) ) == false)
	{
		warnAndSelect(startmin,popup_msg[popup_msg_34]);
		return false;
	}
	if( (isPosInt(endhr.value) && range(endhr.value,0,23) ) == false)
	{
		warnAndSelect(endhr,popup_msg[popup_msg_33]);
		return false;
	}
	if( (isPosInt(endmin.value) && range(endmin.value,0,59) ) == false)
	{
		warnAndSelect(endmin,popup_msg[popup_msg_34]);
		return false;
	}
	if( parstIntTrimLeadZero(starthr.value) > parstIntTrimLeadZero(endhr.value))
	{
		warnAndSelect(starthr,popup_msg[popup_msg_35]);
		return false;
	}
	else if((parstIntTrimLeadZero(starthr.value) == parstIntTrimLeadZero(endhr.value)) &&(parstIntTrimLeadZero(startmin.value) > parstIntTrimLeadZero(endmin.value)))
	{
		warnAndSelect(startmin,popup_msg[popup_msg_35]);
		return false;
	}
	return true;
	
}

function addTime(){

	if(formobj.list.selectedIndex<0)
	{alert(popup_msg[popup_msg_36]);
		return false;
	}
	if(checkTime(formobj.start_hr,formobj.start_min,formobj.end_hr,formobj.end_min) == false ) return false;
	var tobj = new data(formobj.list[formobj.list.selectedIndex].text,
							getRadioCheckedIndex(formobj.weekdays),
							addZero(formobj.start_hr.value)+ ":" + addZero(formobj.start_min.value) +":00",
							addZero(formobj.end_hr.value) + ":" +	addZero(formobj.end_min.value) + ":59");
							
	if(isInArray(tobj))
	{
		alert(popup_msg[popup_msg_48]);
		return false;
	}
	
	modified = true;
	lstarr[lstarr.length]  = new data(formobj.list[formobj.list.selectedIndex].text,
							getRadioCheckedIndex(formobj.weekdays),
							addZero(formobj.start_hr.value)+ ":" + addZero(formobj.start_min.value) +":00",
							addZero(formobj.end_hr.value) + ":" +	addZero(formobj.end_min.value) + ":59");
	getTimeByWeekday();
	formobj.addmod.disabled=false;
}

function delTime(){
	if(formobj.list.selectedIndex<0)
	{alert(popup_msg[popup_msg_36]);
		return false;
	}
	if(formobj.tlist.selectedIndex < 0)
	{alert(popup_msg[popup_msg_37]);
		return false;
	}
	lstarr  =delArrayElement(lstarr,formobj.tlist[formobj.tlist.selectedIndex].value);
		//lstarr.splice(formobj.tlist[formobj.tlist.selectedIndex].value,1);
	modified = true;
	getTimeByWeekday();
	formobj.addmod.disabled=false;
}
function splitTime(){
	if(formobj.tlist.selectedIndex>=0)
	{
	var idx = formobj.tlist[formobj.tlist.selectedIndex].value;
	
	formobj.start_hr.value  = lstarr[idx].starthr;
	formobj.start_min.value  = lstarr[idx].startmin;
	formobj.end_hr.value   = lstarr[idx].endhr;
	formobj.end_min.value  = lstarr[idx].endmin;
	}
}
function copyDayToAll(){

	if(!(formobj.list.selectedIndex>=0))
	{
		alert(popup_msg[popup_msg_36]);
	}
	if(!(formobj.tlist.length>0) )
	{		
		alert(popup_msg[popup_msg_63]);
		return ;
	}
	
	modified = true;
	
	var i,j;
	var templist = new Array();
	for(i=0;i<formobj.tlist.length;i++) // clone today list
	{
		templist[i] = lstarr[formobj.tlist[i].value].clone();
	}
	for(i=0;i<lstarr.length;i++)//delete all elements based on profile name
	{
		if(lstarr[i].name == formobj.list[formobj.list.selectedIndex].text)
		{			lstarr  =delArrayElement(lstarr,i);
					i--;//array index shifted after deleted, shift one index backward
		}
	}
	for(i=0;i<templist.length;i++)// re-add the clone list 
	{
		for(j=0;j<=6;j++)//all weekdays clone
		{
			templist[i].weekday = j;
			lstarr[lstarr.length] = templist[i].clone();
		}
	}
	getTimeByWeekday();
}
function copyTimeToAll(){

	if(!(formobj.list.selectedIndex>=0))
	{
		alert(popup_msg[popup_msg_36]);
	}
	if(formobj.tlist.selectedIndex<0)
	{		
		alert(popup_msg[popup_msg_37]);
		return ;
	}	

	modified = true;
	var tobj = lstarr[formobj.tlist[formobj.tlist.selectedIndex].value].clone();
	deleteFromAll();
	var j;	
	for(j=0;j<=6;j++)//all weekdays clone
	{
			tobj.weekday = j;
			lstarr[lstarr.length] = tobj.clone();
	}
	getTimeByWeekday();
	formobj.addmod.disabled=false;
	return;
	
	/*formobj.addmod.disabled=false;
	var i,j;
	var templist = new Array();
	for(i=0;i<formobj.tlist.length;i++) // clone today list
	{
		templist[i] = lstarr[formobj.tlist[i].value].clone();
	}
	for(i=0;i<lstarr.length;i++)//delete all elements based on profile name
	{
		if(lstarr[i].name == formobj.list[formobj.list.selectedIndex].text)
		{			lstarr  =delArrayElement(lstarr,i);
					i--;//array index shifted after deleted, shift one index backward
		}
	}
	for(i=0;i<templist.length;i++)// re-add the clone list 
	{
		for(j=0;j<=6;j++)//all weekdays clone
		{
			templist[i].weekday = j;
			lstarr[lstarr.length] = templist[i].clone();
		}
	}
	getTimeByWeekday();
	formobj.addmod.disabled=false;*/
}

function isTimeIdentical(lstobj,lstobj2){
	if((lstobj.name == lstobj2.name)&&
	(lstobj.start == lstobj2.start)&&
	(lstobj.end == lstobj2.end))	
		return true;
	return false;
}
function isInArray(dataobj){
	var i;
	for(i=0;i<lstarr.length;i++)
		if(dataobj.equals(lstarr[i]))
			return true;
	return false;
}
function deleteFromAll(){
	if(!(formobj.tlist.length>0) )
	{		
		alert(popup_msg[popup_msg_63]);
		return ;
	}
	if(formobj.tlist.selectedIndex<0)
	{		
		alert(popup_msg[popup_msg_37]);
		return ;
	}
	modified = true;
	var i;
	var tobj = lstarr[formobj.tlist[formobj.tlist.selectedIndex].value].clone();
	for(i=0; i<lstarr.length;i++)
	{
		if(isTimeIdentical(lstarr[i],tobj))
		{
			lstarr  =delArrayElement(lstarr,i);
			i--;
		}
	
	}
	getTimeByWeekday();
	formobj.addmod.disabled=false;
}
var lastpidx = -1;
function showProfile(){
	var lidx = formobj.list.selectedIndex
	if(lidx>=0)
	{
//		if((modified)&&(lastpidx!=lidx))
	//	{
//			if((lastpidx>=0)&&(confirm("undo changes in profile '"+ formobj.list[lastpidx].text + "'?") == false))
//			{
//				formobj.list.selectedIndex= lastpidx
//				return false;
//			}
//		}
		lastpidx = lidx ;
		formobj.name.value = formobj.list[lidx].text;
		
		getTimeByWeekday();
		document.getElementById("content").style.display = "";
	}
	goSetHeight();
}

function addProfile(){
	var proname;
	if(proname=prompt(popup_msg[popup_msg_42],"") )
	{	
		if(InProfileList(proname))
		{	
			alert(popup_msg[popup_msg_38]);
			return false;
		}
		else if(proname.length > 16)
		{
			alert(popup_msg[popup_msg_39]);
			return false;
		}
	}
	else 
		return false;

	var filter=/^[\w\-\+]+$/;
	if ((filter.test(proname)==false))
  {
    alert(popup_msg[popup_msg_92]);
    return false;
  }
	if(proname.toUpperCase() == "ALWAYS")
	{
		alert(popup_msg[popup_msg_40]);
		return false;
	}
	formobj.mode.value = "add";
	formobj.proname.value = proname;
	formobj.submit();
}
function delProfile(){
	if(formobj.list.selectedIndex<0)
	{
		alert(popup_msg[popup_msg_36]);
		return false;
	}
	if(confirm(popup_msg[popup_msg_41]+" '" + formobj.list[formobj.list.selectedIndex].text + "' ?")== false)
		return false;
	formobj.mode.value = "del";
	formobj.submit();
}
function modProfile(){
	if(formobj.list.selectedIndex<0)
	{
		alert(popup_msg[popup_msg_36]);
		return false;
	}
	if(formobj.name.value.toUpperCase() == "ALWAYS")
	{
		warnAndSelect(formobj.name,popup_msg[popup_msg_40]);
		return false;
	}
	if(((InProfileList(formobj.name.value)) && (formobj.list.selectedIndex>=0) && (formobj.list[formobj.list.selectedIndex].value)!=formobj.name.value))
	{	
		alert(popup_msg[popup_msg_38]);
		return false;
	}
	else if(formobj.name.length > 16)
	{
		alert(popup_msg[popup_msg_39]);
		return false;
	}	
//function addEl(target_id,typ,val,onevnt,func){
	var i,j;
	for(i=0,j=0;i<lstarr.length;i++)
	{
		if((lstarr[i].name == formobj.list[formobj.list.selectedIndex].text) && (lstarr[i].weekday != null))
		{	//addEl("form1","hidden","key"+j,lstarr[i].weekday+","+lstarr[i].start+","+lstarr[i].end)
			j++;
		}
	}
		
	if(j > 53)
	{
		alert(popup_msg[popup_msg_96]);
		return false;
	}
	for(i=0,j=0;i<lstarr.length;i++)
	{
		if((lstarr[i].name == formobj.list[formobj.list.selectedIndex].text) && (lstarr[i].weekday != null))
		{	addEl("form1","hidden","key"+j,lstarr[i].weekday+","+lstarr[i].start+","+lstarr[i].end)
			j++;
		}
	}
	var filter=/^[\w\-\+]+$/;
	if ((filter.test(formobj.name.value)==false))
  {
    alert(popup_msg[popup_msg_92]);
    return false;
  }
	formobj.maxkey.value = j;
		formobj.mode.value = "mod";
	formobj.submit();
}
function init(){
	formobj = document.form1;
	formobj.addmod.disabled=false;
	insertProfile();
	//getTimeByWeekday(0);
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_config_1" name="event_config_1"></span>&nbsp;&raquo;&nbsp;<span id="arrange_sch" name="arrange_sch"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
		  <form action="scheprofile.cgi" method="post" name="form1" id="form1">
        <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      		<tr>
        		<td colspan="2" class="greybluebg"><span id="sch_profile_1" name="sch_profile_1"> </span></td>
      		</tr>
          <tr>
          	<td colspan="2" class="bggrey"><select name="list" size="7" id="list" style="width:200px" onclick="showProfile();"></select>
              <input name="actadd" type="button" id="actadd" onClick="addProfile();" value="">
              <input name="adddel" type="button" id="adddel" onClick="delProfile();" value="">
              <input name="mode" type="hidden" id="mode">
              <input name="maxkey" type="hidden" id="maxkey">
              <input name="proname" type="hidden" id="proname">
            </td>
          </tr>
        </table>
				<div>
        <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" id="content" align="center" style="display:none;">
        	<tr>
          	<td class="bgblue"><span id="pro_name" name="pro_name"></span>:</td>
            <td class="bggrey"><input name="name" type="text" id="name"  style="width:200px" size="26" maxlength="16" onKeyUp="formobj.addmod.disabled=false;" onMouseDown="formobj.addmod.disabled=false;"></td>
          </tr>
          <tr>
          	<td width="150" class="bgblue"><span id="weekdays_1" name="weekdays_1"></span>:</td>
            <td class="bggrey">
            	<input name="weekdays" type="radio" value="radiobutton" checked onClick="getTimeByWeekday(0);">
							<span id='weektext0'><span id="sun" name="sun"></span></span>
  						<input name="weekdays" type="radio" value="radiobutton" onClick="getTimeByWeekday(1);">
							<span id='weektext1'><span id="mon" name="mon"></span></span>
							<input name="weekdays" type="radio" value="radiobutton" onClick="getTimeByWeekday(2);" >
							<span id='weektext2'><span id="tue" name="tue"></span></span>
							<input name="weekdays" type="radio" value="radiobutton" onClick="getTimeByWeekday(3);" >
							<span id='weektext3'><span id="wed" name="wed"></span></span>
							<input name="weekdays" type="radio" value="radiobutton" onClick="getTimeByWeekday(4);">
							<span id='weektext4'><span id="thu" name="thu"></span></span>
							<input name="weekdays" type="radio" value="radiobutton" onClick="getTimeByWeekday(5);">
							<span id='weektext5'><span id="fri" name="fri"></span></span>
							<input name="weekdays" type="radio" value="radiobutton"  onClick="getTimeByWeekday(6);">
							<span id='weektext6'><span id="sat" name="sat"></span></span>
							<input name="weekday" type="hidden" value="" >
						</td>
          </tr>
          <tr>
          	<td width="140" valign="top" class="bgblue"><span id="time_list" name="time_list"></span>:</td>
            <td width="508" class="bggrey">
            	<table width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr>
                  <td width="1%"><select name="tlist" size="7" style="width:120px" onclick="splitTime();"></select></td>
                	<td bgcolor="#333333" class="bggrey">
                		<p>
                  		<input type="button" id ="Button3" name="Button3" value="" onClick="addTime();" style="width:60px">
                  		<input type="button" id ="Button32" name="Button32" value="" onClick="copyTimeToAll();" style="width:200px">
                		</p>
                  	<p>
                    	<input type="button" id ="Button222" name="Button222" value="" onClick="delTime();" style="width:60px">
                    	<input type="button" id ="Button322" name="Button322" value="" onClick="deleteFromAll();" style="width:200px">
                    </p>
                  </td>
              	</tr>
              </table>
            </td>
          </tr>
          <tr>
          	<td class="bgblue"><span id="start_time" name="start_time"></span>:</td>
            <td class="bggrey">
            	<input name="start_hr" type="text" id="start_hr" size="2" maxlength="2">:
              <input name="start_min" type="text" id="start_min" size="2" maxlength="2">
            </td>
          </tr>
          <tr>
          	<td class="bgblue"><span id="end_time" name="end_time"></span>:</td>
            <td class="bggrey">
            	<input name="end_hr" type="text" id="end_hr" size="2" maxlength="2">:
              <input name="end_min" type="text" id="end_min" size="2" maxlength="2">
            </td>
          </tr>
          <tr>
          	<td width="150" class="bgblue">&nbsp;</td>
            <td class="bggrey">
            	<input class="ButtonSmall" name="addmod" type="button" id="addmod" onClick="modProfile();" value="">
              <input class="ButtonSmall" type="button" id="Button1" name="Button1" value="" onClick="document.location.reload('scheprofile.asp');">
            </td>
          </tr>
        </table>
        </div>
		  </form>
     	<br>
    </td>
  </tr>
</table>
<script language="javascript">init();</script>
</body>
</html>
