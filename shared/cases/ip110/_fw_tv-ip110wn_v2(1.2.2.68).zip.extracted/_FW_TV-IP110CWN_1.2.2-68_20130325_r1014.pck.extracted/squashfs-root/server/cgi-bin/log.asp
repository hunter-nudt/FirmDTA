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
	color: #000000;
	background-color: FFFFFF;
}
.style7 {font-size: 12px}
.style8 {
	background-color: E5E5e5;
}
.style12 {color: #999999}
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
	
	setContent("sys_info",item_name[_SYS_INFO]);
	setContent("logs",item_name[_LOGS]);
	//setContent("logs_table",item_name[_LOGS_TABLE]);
	setContent("time",item_name[_TIME]);
	setContent("event",item_name[_EVENT]);
	
	document.getElementById("Button").value=item_name[_REFRESH];
}

function logdata(date,mesg){
	this.date = date;
	this.mesg = mesg;
}
logarr = new Array();

<% getLog(); %>

function addRow(cell1,cell2){
	var obj =  document.getElementById("logtable");
	var lastRow = obj.rows.length;
  // if there's no header row in the table, then iteration = lastRow + 1
  	var row = obj.insertRow(lastRow);
	// left cell
  var cellLeft = row.insertCell(0);
  var textNode = document.createTextNode(cell1);
//  cellLeft.appendChild(textNode);
  
  var spanNode = document.createElement("span");
  spanNode.className = "style12";
  spanNode.appendChild(textNode);
  cellLeft.appendChild(spanNode);
  
  // right cell
  var cellRight = row.insertCell(1);
  var spanNodeRight = document.createElement("span");
  textNode = document.createTextNode(cell2);
  spanNodeRight.className = "style12";
  spanNodeRight.appendChild(textNode);
 
  cellRight.appendChild(spanNodeRight);
  }
function init(){
	var i;
	for(i=logarr.length-1;i>=0;i--)
	{
		addRow(logarr[i].date,logarr[i].mesg);
	}	
	
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="sys_info" name="sys_info"></span>&nbsp;&raquo;&nbsp;<span id="logs" name="logs"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
			<form action="" method="post" name="form1">
      	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#000000" class="box_tn" id="logtable">
        	<tr>
    		  	<td width="23%">&nbsp;</td>
    		    <td width="77%" align="right">
    		      <input type="button" id="Button" name="Button" value="" onClick="reloadScreen('log.asp');">
    		    </td>
    		  </tr>
    		  <tr bgcolor="#FAFAF4">
    		    <td class="style6"><span id="time" name="time"></span></td>
    		    <td class="style6"><span id="event" name="event"></span></td>
    		  </tr>
    		  <tr>
    		    <td>&nbsp;</td>
    		    <td>&nbsp;</td>
    		  </tr>
    		</table>
		  </form> 	
      <br>
    </td>
  </tr>
</table>
<script language="javascript">init();</script>
</body>
</html>
