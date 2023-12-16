<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><% getWlanExist("stat"); %> Network Camera</title>
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
var acceptArry = new Array();
var denyArry = new Array();
var accept6Arry = new Array();
var deny6Arry = new Array();
var pIdx = 1;
var sIdx = 0;
var sType = "";
var sAction = "";
var sAddress = "";
<% getIpAcceptData(); %>
<% getIpDenyData(); %>
<% getIp6AcceptData(); %>
<% getIp6DenyData(); %>

function addEl(target_id,typ,nam,val){
	var el=document.createElement('input');
	el.type=typ;
	if(nam) el.name=nam;
	if(val)el.value=val;
	document.getElementById(target_id).appendChild(el);
}

function addCol(rowobj,text,pos){
	var cellobj = rowobj.insertCell(pos);
	//cellobj.className = "style7";
	var textNode = document.createTextNode(text);
	cellobj.appendChild(textNode);
}

function addRow(iptype,rule,ipaddress,idx){
	var obj =  document.getElementById("filtertbl");
	obj.style.display = "";
	var lastRow = obj.rows.length;
	var row = obj.insertRow(lastRow);
	row.onclick = function(){ selectRow(iptype,rule,ipaddress,idx);}
	addCol(row,iptype,0);
	addCol(row,rule,1);
	addCol(row,ipaddress,2);
	obj.rows[idx].style.backgroundColor = "#ffffff";
		
}

function deleteRow(idx)
{
	var tblObj =document.getElementById("filtertbl");
	if(idx!=0 && idx>tblObj.rows.length) {
		tblObj.deleteRow(idx);
	}
}

function deleteRows(idx)
{
	var tblObj =document.getElementById("filtertbl");
	while(tblObj.rows.length>idx) {
		tblObj.deleteRow(tblObj.rows.length-1);
	}
}

function selectRow(iptype,rule,ipaddress,idx){
	var i;
	var tbobj =document.getElementById("filtertbl");
	if(idx>=0)
	{	for(i=1;i<tbobj.rows.length;i++)
		{
			if(idx == i){
				tbobj.rows[i].style.backgroundColor = "#C5CEDA";
				sIdx = idx;
				sType = iptype;
				sAction = rule;
				sAddress = ipaddress;
			}else
				tbobj.rows[i].style.backgroundColor = "#ffffff";
		}
	}
}

function initPolicyList(){
	var formobj = document.form1;
	
	deleteRows(1);
	pIdx = 1;
	for(i=0;i<acceptArry.length;i++)
	{
		addRow("IPv4",item_name[_ACCEPT],acceptArry[i],pIdx);
		pIdx++;
	}
	
	for(i=0;i<denyArry.length;i++)
	{
		addRow("IPv4",item_name[_DENY],denyArry[i],pIdx);
		pIdx++;
	}
	
	for(i=0;i<accept6Arry.length;i++)
	{
		addRow("IPv6",item_name[_ACCEPT],accept6Arry[i],pIdx);
		pIdx++;
	}
	
	for(i=0;i<deny6Arry.length;i++)
	{
		addRow("IPv6",item_name[_DENY],deny6Arry[i],pIdx);
		pIdx++;
	}
	goSetHeight();
}

function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){

	setContent("network_2",item_name[_NETWORK]);
	setContent("ip_filter_1",item_name[_IP_FILTER]);
	setContent("ip_filter_2",item_name[_IP_FILTER]);
	setContent("ipf_disable",item_name[_DISABLE]);
	setContent("ipf_accept",item_name[_ACCEPT]);
	setContent("a_start_ip",item_name[_START]);
	setContent("a_end_ip",item_name[_END]);
	setContent("ipf_deny",item_name[_DENY]);
	setContent("d_start_ip",item_name[_START]);
	setContent("d_end_ip",item_name[_END]);
	setContent("a_ip6",item_name[_IP6_ADDR]);
	setContent("d_ip6",item_name[_IP6_ADDR]);
	setContent("ip_v4",item_name[_IPV4_ADDR_RANGE]);
	setContent("ip_v4_1",item_name[_IPV4_ADDR_RANGE]);
	setContent("ip_type",item_name[_TYPE]);
	setContent("ip_action",item_name[_FILTER_ACTION]);
	setContent("ip_address",item_name[_IP_ADDRESS]);

	document.getElementById("a_add").value=item_name[_ADD];
	document.getElementById("d_add").value=item_name[_ADD];
	document.getElementById("a_add_6").value=item_name[_ADD];
	document.getElementById("d_add_6").value=item_name[_ADD];
	document.getElementById("delete_policy").value=item_name[_DELETE];
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
	initPolicyList();
}	

function dupCheck(st1,st2,st3,st4,ed1,ed2,ed3,ed4,ip4arry)
{
	var ip = parstIntTrimLeadZero(st1.value)+"." +
	parstIntTrimLeadZero(st2.value)+"." +
	parstIntTrimLeadZero(st3.value)+"." +
	parstIntTrimLeadZero(st4.value)+"~" +
	parstIntTrimLeadZero(ed1.value)+"." +
	parstIntTrimLeadZero(ed2.value)+"." +
	parstIntTrimLeadZero(ed3.value)+"." +
	parstIntTrimLeadZero(ed4.value);

	for(i=0;i<ip4arry.length;i++)
	{
		if(ip4arry[i] == ip)
		{
			warnAndSelect(st1,popup_msg[popup_msg_30]);
			return false;
		}
	}
	return true;
}
function dupv6Check(st1,ip6arry)
{

	for(i=0;i<ip6arry.length;i++)
	{
		if(ip6arry[i] == st1.value)
		{
			warnAndSelect(st1,popup_msg[popup_msg_30]);
			return false;
		}
	}
	return true;
}
function delArrayElement(srcarray,delElement)
{
	for(i=0;i<srcarray.length;i++)
	{
		if(delElement == srcarray[i]){
			srcarray.splice(i,1);
		}
	}
	return srcarray;
}
function addAccept(){
	var o = document.form1;
	if(ipCheck(o.a_startip1,o.a_startip2,o.a_startip3,o.a_startip4,true)==false)	return;
	if(ipCheck(o.a_endip1,o.a_endip2,o.a_endip3,o.a_endip4,true)==false)	return;
	if(ipRangeCheck(o.a_startip1,o.a_startip2,o.a_startip3,o.a_startip4,o.a_endip1,o.a_endip2,o.a_endip3,o.a_endip4)==false) return;
	if(dupCheck(o.a_startip1,o.a_startip2,o.a_startip3,o.a_startip4,o.a_endip1,o.a_endip2,o.a_endip3,o.a_endip4,acceptArry) == false) return;
	
	
	acceptArry[acceptArry.length]  = TrimLeadZero(o.a_startip1.value)+"."+TrimLeadZero(o.a_startip2.value)+"."+TrimLeadZero(o.a_startip3.value)+"."+TrimLeadZero(o.a_startip4.value)+"~"+
									TrimLeadZero(o.a_endip1.value)+"."+TrimLeadZero(o.a_endip2.value)+"."+TrimLeadZero(o.a_endip3.value)+"."+TrimLeadZero(o.a_endip4.value);
	
	initPolicyList();
	o.a_startip1.value="";
	o.a_startip2.value="";
	o.a_startip3.value="";
	o.a_startip4.value="";
	o.a_endip1.value="";
	o.a_endip2.value="";
	o.a_endip3.value="";
	o.a_endip4.value="";
}

function delPolicy(){
	if(sIdx){
		if(sType == "IPv4"){
			if(sAction == item_name[_ACCEPT]){
				if(acceptArry.length==0)return;
				if(confirm(popup_msg[popup_msg_31])==false)	return;
				acceptArry = delArrayElement(acceptArry,sAddress);
			}else if(sAction == item_name[_DENY]){
				if(denyArry.length==0)return;
				if(confirm(popup_msg[popup_msg_31])==false)	return;
				denyArry = delArrayElement(denyArry,sAddress);
			}
		}else if(sType == "IPv6"){
			if(sAction == item_name[_ACCEPT]){
				if(accept6Arry.length==0)return;
				if(confirm(popup_msg[popup_msg_31])==false)	return;
				accept6Arry = delArrayElement(accept6Arry,sAddress);
			}
			else if(sAction == item_name[_DENY]){
				if(deny6Arry.length==0)return;
				if(confirm(popup_msg[popup_msg_31])==false)	return;
				deny6Arry = delArrayElement(deny6Arry,sAddress);
			}
		}
	}
	sIdx = 0;
	sType = "";
	sAction = "";
	sAddress = "";
	initPolicyList();
}

function addDeny(){
	var o = document.form1;
	if(ipCheck(o.d_startip1,o.d_startip2,o.d_startip3,o.d_startip4,true)==false)	return;
	if(ipCheck(o.d_endip1,o.d_endip2,o.d_endip3,o.d_endip4,true)==false)	return;
	if(ipRangeCheck(o.d_startip1,o.d_startip2,o.d_startip3,o.d_startip4,o.d_endip1,o.d_endip2,o.d_endip3,o.d_endip4)==false) return;
	if(dupCheck(o.d_startip1,o.d_startip2,o.d_startip3,o.d_startip4,o.d_endip1,o.d_endip2,o.d_endip3,o.d_endip4,denyArry) == false) return;
	
	denyArry[denyArry.length]  = TrimLeadZero(o.d_startip1.value)+"."+TrimLeadZero(o.d_startip2.value)+"."+TrimLeadZero(o.d_startip3.value)+"."+TrimLeadZero(o.d_startip4.value)+"~"+
									TrimLeadZero(o.d_endip1.value)+"."+TrimLeadZero(o.d_endip2.value)+"."+TrimLeadZero(o.d_endip3.value)+"."+TrimLeadZero(o.d_endip4.value);
	
	initPolicyList();
	o.d_startip1.value="";
	o.d_startip2.value="";
	o.d_startip3.value="";
	o.d_startip4.value="";
	o.d_endip1.value="";
	o.d_endip2.value="";
	o.d_endip3.value="";
	o.d_endip4.value="";
}

function addAccept6(){
	var o = document.form1;
	if(ipv6Check(o.a_ip6_1,true)==false)return;
	if(dupv6Check(o.a_ip6_1,accept6Arry) == false) return;
	
	accept6Arry[accept6Arry.length] = o.a_ip6_1.value;
	
	initPolicyList();
	o.a_ip6_1.value="";
}

function addDeny6(){	
	var o = document.form1;
	if(ipv6Check(o.d_ip6_1,true)==false)return;
	if(dupv6Check(o.d_ip6_1,deny6Arry) == false) return;
	
	deny6Arry[deny6Arry.length] = o.d_ip6_1.value;

	initPolicyList();
	o.d_ip6_1.value="";
}

function send(s){
	var o = document.form1;
	o.type.value = s;
	if(s=="m_mode"){
		if(o.mode[1].checked){
			if(acceptArry.length<=0 && accept6Arry.length<=0)
			{
				alert(popup_msg[popup_msg_73]);
				return false;
			}
			
		}else if(o.mode[2].checked){
			if(denyArry.length<=0 && deny6Arry.length<=0)
			{
				alert(popup_msg[popup_msg_74]);
				return false;
			}
			
		}

		var i,j;
		for(i=0,j=0;i<acceptArry.length;i++)
		{
			addEl("form1","hidden","accept"+j,acceptArry[i]);
			j++;
		}
		o.amaxkey.value = j;
		
		for(i=0,j=0;i<denyArry.length;i++)
		{
			addEl("form1","hidden","deny"+j,denyArry[i]);
			j++;
		}
		o.dmaxkey.value = j;
		
		for(i=0,j=0;i<accept6Arry.length;i++)
		{
			addEl("form1","hidden","accept6"+j,accept6Arry[i]);
			j++;
		}
		o.a6maxkey.value = j;
		
		for(i=0,j=0;i<deny6Arry.length;i++)
		{
			addEl("form1","hidden","deny6"+j,deny6Arry[i]);
			j++;
		}
		o.d6maxkey.value = j;
	}
	/*o.a_startip1.disabled=true;
	o.a_startip2.disabled=true;
	o.a_startip3.disabled=true;
	o.a_startip4.disabled=true;
	o.a_endip1.disabled=true;
	o.a_endip2.disabled=true;
	o.a_endip3.disabled=true;
	o.a_endip4.disabled=true;
	o.d_startip1.disabled=true;
	o.d_startip2.disabled=true;
	o.d_startip3.disabled=true;
	o.d_startip4.disabled=true;
	o.d_endip1.disabled=true;
	o.d_endip2.disabled=true;
	o.d_endip3.disabled=true;
	o.d_endip4.disabled=true;
	
	o.a_ip6_1.disabled=true;
	o.d_ip6_1.disabled=true;*/
	o.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="network_2" name="network_2"></span>&nbsp;&raquo;&nbsp;</span><span id="ip_filter_1" name="ip_filter_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
			<form action="filter.cgi" method="post" name="form1" id="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
        	<tr>
        		<td colspan="2" class="greybluebg"><span id="ip_filter_2" name="ip_filter_2"> </span></td>
      		</tr>
          <tr>
          	<td width="200" class="bgblue"><span id="ipf_disable" name="ipf_disable"></span></td>
            <td class="bggrey"><input name="mode" type="radio" id="mode" value="0" <% getIpfilterMode("0"); %>></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="ipf_accept" name="ipf_accept"></span></td>
            <td class="bggrey"><input name="mode" type="radio" id="mode" value="1" <% getIpfilterMode("1"); %>></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="ip_v4" name="ip_v4"></span></td>
            <td class="bggrey">
          		<table width="100%" border="0" cellspacing="1" cellpadding="3">
          			<tr>
          				<td width="10%"><span id="a_start_ip" name="a_start_ip"></span>: </td>
          			  <td width="90%">
          			  	<input name="a_startip1" type="text" class="box_ip" id="a_startip1" size="3" maxlength="3">
          			    .
          			    <input name="a_startip2" type="text" class="box_ip" id="a_startip2" size="3" maxlength="3">
          			    .
  							  	<input name="a_startip3" type="text" class="box_ip" id="a_startip3" size="3" maxlength="3">
          			    .
  									<input name="a_startip4" type="text" class="box_ip" id="a_startip4" size="3" maxlength="3">
  								</td>
          			</tr>
          			<tr>
          				<td><span id="a_end_ip" name="a_end_ip"></span>: </td>
          			  <td>
          			  	<input name="a_endip1" type="text" class="box_ip" id="a_endip1" size="3" maxlength="3">
										.
										<input name="a_endip2" type="text" class="box_ip" id="a_endip2" size="3" maxlength="3">
										.
										<input name="a_endip3" type="text" class="box_ip" id="a_endip3" size="3" maxlength="3">
										.
										<input name="a_endip4" type="text" class="box_ip" id="a_endip4" size="3" maxlength="3">
										&nbsp;<input name="a_add" type="button" id="a_add" value="" onClick="addAccept();">
									</td>
          			</tr>
          		</table>
          	</td>
          </tr>
					<tr style="display:none">
          	<td class="bgblue"><span id="a_ip6" name="a_ip6"></span>: </td>
            <td class="bggrey">
            	<input name="a_ip6_1" type="text"  id="a_ip6_1" size="30" maxlength="39">
            	<input name="a_add_6" type="button" id="a_add_6" value="" onClick="addAccept6();">
            </td>
          </tr>
          <tr>
          	<td class="bgblue"><span id="ipf_deny" name="ipf_deny"></span></td>
            <td class="bggrey"><input name="mode" type="radio" id="mode" value="2" <% getIpfilterMode("2"); %>></td>
          </tr>
          <tr>
            <td class="bgblue"><span id="ip_v4_1" name="ip_v4_1"></span></td>
            <td class="bggrey">
  						<table width="100%" border="0" cellspacing="1" cellpadding="3">
	              <tr>
                	<td width="10%"><span id="d_start_ip" name="d_start_ip"></span>: </td>
                	<td>
                		<input name="d_startip1" type="text" class="box_ip" id="d_startip1" size="3" maxlength="3">
                  	.
                  	<input name="d_startip2" type="text" class="box_ip" id="d_startip2" size="3" maxlength="3">
                  	.
  				  				<input name="d_startip3" type="text" class="box_ip" id="d_startip3" size="3" maxlength="3">
                  	.
  									<input name="d_startip4" type="text" class="box_ip" id="d_startip4" size="3" maxlength="3">
  								</td>
                </tr>
              	<tr>
                	<td><span id="d_end_ip" name="d_end_ip"></span>: </td>
                	<td>
                		<input name="d_endip1" type="text" class="box_ip" id="d_endip1" size="3" maxlength="3">
										.
										<input name="d_endip2" type="text" class="box_ip" id="d_endip2" size="3" maxlength="3">
										.
										<input name="d_endip3" type="text" class="box_ip" id="d_endip3" size="3" maxlength="3">
										.
										<input name="d_endip4" type="text" class="box_ip" id="d_endip4" size="3" maxlength="3">
                		<input name="d_add" type="button" id="d_add" value="" onClick="addDeny();"></td>
              	</tr>
              </table>
            </td>
          </tr>
          <tr style="display:none">
          	<td class="bgblue"><span id="d_ip6" name="d_ip6"></span>: </td>
            <td class="bggrey">
            	<input name="d_ip6_1" type="text" id="d_ip6_1" size="30" maxlength="39">
            	<input name="d_add_6" type="button" id="d_add_6" value="" onClick="addDeny6();">
            </td>
          </tr>
          <tr>
          	<td colspan=2 align="center">
		        	<table  border="0" id="filtertbl" style="display:; border-left-width:2px; 
					    border-left-color:#999999;
					    border-style: ridge;
					    border-right-width:2px;
					    border-right-color:#ffffff;
							border-top-width:2px;
					    border-top-color: #999999; 
					    border-bottom-width:2px;
					    border-bottom-color:#ffffff;">
					  		<tr class="style6">
					    		<td width="50"><span class="style7" id="ip_type" name="ip_type"></span></td>
					    		<td width="50"><span class="style7" id="ip_action" name="ip_action"></span></td>
					    		<td width="300"><span class="style7" id="ip_address" name="ip_address"></span></td>
					  		</tr>
					  		<tr class="style6">
					    		<td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
		          </table>
            	<input name="delete_policy" type="button" id="delete_policy" value="" onClick="delPolicy();">
            </td>
        	</tr>
        </table>
        <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
					<tr>
        		<td class="bggrey2">
            	<input name="type" type="hidden" id="type" value="m_mode">
            	<input name="amaxkey" type="hidden" id="amaxkey" >
            	<input name="dmaxkey" type="hidden" id="dmaxkey" >
            	<input name="a6maxkey" type="hidden" id="a6maxkey" >
            	<input name="d6maxkey" type="hidden" id="d6maxkey" >
            	<input class="ButtonSmall" type="button" id="Button" name="Button" value="" onClick="send('m_mode');">
            	<input class="ButtonSmall" type="button" name="Button1" id="Button1" value="" onClick="reloadScreen('ipfilter.asp');">
          	</td>
        	</tr>
      	</table>
      <br>
      </form>
    </td>
  </tr>
</table>
</body>
</html>
