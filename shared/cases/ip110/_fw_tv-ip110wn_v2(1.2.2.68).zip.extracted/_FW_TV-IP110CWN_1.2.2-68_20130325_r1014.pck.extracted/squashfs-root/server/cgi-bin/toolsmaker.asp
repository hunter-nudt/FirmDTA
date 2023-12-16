<html><!-- InstanceBegin template="/Templates/setupconfig.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- InstanceBeginEditable name="doctitle" -->
<title><% getWlanExist("stat"); %> Network Camera</title>
<!-- InstanceEndEditable -->
<link href="web.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {color: #339900}
.style2 {color: #0048c0}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
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
<!-- InstanceBeginEditable name="head" -->
<script language="javascript">
var rf=0;
var uf=0;
function res(){
	var obj = document.formrestore;
//	if(obj.cfgfile.value == "")
	//{
		//alert("Please select a file first");		
		//return false;
//	}	

	if(rf == 0)
		obj.submit();
	rf++;	
}

function disup(){

	var obj = document.formreset;
	obj.reset.disabled = true;
	obj = document.formreboot;
	obj.reboot.disabled = true;
	obj = document.formbackup;
	obj.backup.disabled = true;

	obj = document.formrestore;	
	obj.restore.disabled = true;
	obj.cfgfile.disabled = true;
	obj = document.formup;
	obj.update.disabled = true;
//	obj.file.disabled = true;	

}
function up(){
	var obj = document.formup;
/*	if(obj.firmware.bin.value == "")
	{
		alert("Please select a file first");		
		return false;
	}
	*/
	if(uf == 0)
		obj.submit();
	disup();
	uf++;		
}
</script>

<!-- InstanceEndEditable -->
</head>

<body onLoad="MM_preloadImages('img/but_liveview_over.gif','img/but_setup_over.gif')">

<table width="97%" border="0" cellpadding="8" cellspacing="0">
  <tr>
    <td width="80%" height="50" bgcolor="#E6E6CA" class="t22b">Pan/Tilt <span style="display:<% getWlanExist(); %>">Wireless</span> Network Camera</td>
    <td width="13%" align="right" bgcolor="#E6E6CA"><table width="100%" border="0" cellpadding="1" cellspacing="0">
      <tr>
        <td bgcolor="FF6633"><img src="img/spacer.gif" width="2" height="5"></td>
        <td align="center" class="t12">Location:<% getLocation(); %></td>
      </tr>
      <tr>
        <td colspan="2"><img src="img/spacer.gif" width="1" height="2"></td>
        </tr>
    </table>            
      <table width="100%" border="0" cellpadding="3" cellspacing="0">
        <tr align="center" bgcolor="F4F4E7">
          <td><span class="style1"><% getDate(); %> <% getTime(); %></span> </td>
        </tr>
    </table></td>
  </tr>
</table>
<table width="97%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="15%" valign="top"><img src="img/spacer.gif" width="10" height="3"><br>      
      <table width="98%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="80" align="center" class="tdline"><table width="134" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td><a href="../." onMouseOver="MM_swapImage('a1','','img/but_liveview_over.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="img/but_liveview.gif" name="a1" width="134" height="26" vspace="5" border="0" id="a1"></a></td>
          </tr>
          <tr>
            <td><a href="system.asp" onMouseOver="MM_swapImage('a2','','img/but_setup_over.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="img/but_setup_over.gif" name="a2" width="134" height="26" vspace="3" border="0" id="a2"></a></td>
          </tr>
        </table></td>
      </tr>
    </table>
       
      <img src="img/spacer.gif" width="10" height="3"><br>
    <table width="98%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="174" height="80" align="center" class="tdline">
          <br>
          <table width="134" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="134" height="21" align="center" background="img/but.gif" class="t12"><a href="smartwizard.cgi?go=1" class="c">Smart Wizard</a></td>
            </tr>
        </table>
          <br>
          <!-- InstanceBeginEditable name="EditRegion5" -->
          <table width="125" border="0" cellpadding="4" cellspacing="2">
            <tr>
              <td width="134" class="t12">&#8231; <a href="system.asp" class="c">Basic</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="network.asp">Network</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="pantilt.asp">Pan/Tilt</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="rdrvideo.asp">Video/Audio</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="ftp.asp">Event Server </a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="watch.cgi?url=motion.asp">Motion Detect </a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="general.asp">Event Config</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="style1" href="toolsmaker.asp">Tools</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="usb.asp">USB</a></td>
            </tr>
            <tr>
              <td class="t12">&#8231; <a class="c" href="info.asp">Information</a></td>
            </tr>
          </table>
          <!-- InstanceEndEditable --></td>
      </tr>
    </table></td>
    <td width="85%" valign="top"><img src="img/spacer.gif" width="10" height="3"><br>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="100%" height="80" align="center" valign="top" class="tdline"><br>
		  <!-- InstanceBeginEditable name="EditRegion4" -->
          <table width="97%" border="0" cellpadding="2" cellspacing="0">
            <tr>
              <td width="2" bgcolor="FF6633"><img src="img/spacer.gif" width="2" height="5"></td>
              <td class="t16"> System Tools <span class="style2"><b><img src="img/icon_arrow.gif" width="7" height="5" hspace="2" align="absmiddle"></b></span>Tools</td>
            </tr>
            <tr>
              <td colspan="2"><img src="img/spacer.gif" width="1" height="2"></td>
            </tr>
          </table>
          <table width="97%"  border="0" cellpadding="3" cellspacing="1" class="stylebanner">
              <tr>
                <td class="t12 style6"><span class="style2"><b><img src="img/icon_arrow.gif" width="7" height="5" align="absmiddle"></b></span> Factory Reset </td>
              </tr>
            </table>
            <table width="95%"  border="0"><form action="reset.cgi" method="get" name="formreset">
              <tr>
                <td><span class="style7">Factory reset will restore all the settng 
                    <input type="submit" name="reset" value="Reset">                
                    <input type="hidden" name="type" value="0" />
                </span></td>
              </tr></form>
            </table>
            <br>
            <br>
            <table width="97%"  border="0" cellpadding="3" cellspacing="1" class="stylebanner">
              <tr>
                <td class="t12 style6"><span class="style2"><b><img src="img/icon_arrow.gif" width="7" height="5" align="absmiddle"></b></span> System Reboot </td>
              </tr>
            </table>
            <table width="95%"  border="0"><form action="reboot.cgi" method="get" name="formreboot">
              <tr>
                <td class="style7">System will be rebooted  
                  <input name="reboot" type="submit" id="reboot" value="Reboot">
                  <input type="hidden" name="type" value="0" /></td>
              </tr></form>
            </table>
            <br>
            <br>
            <table width="97%"  border="0" cellpadding="3" cellspacing="1" class="stylebanner">
              <tr>
                <td class="t12 style6"><span class="style2"><b><img src="img/icon_arrow.gif" width="7" height="5" align="absmiddle"></b></span> Configuration </td>
              </tr>
            </table>
            <table width="95%"  border="0">
              <tr>
                <td width="201"><span class="style7">
                  &#8231;
                  
                  Backup 
                </span></td>
                <td><span class="style7"><form action="backup.cgi" method="get" name="formbackup">
                  <input type="submit" name="backup" value="Get the backup file">
                </form>
                </span></td>
              </tr>
              <tr>
                <td width="201"><span class="style7">&#8231;
                  Restore: </span><span class="t12"></span></td>
                <td><form action="restore.cgi" method="post"  enctype="multipart/form-data" name="formrestore">
                <input name="cfgfile" type="file" id="cfgfile">
                <span class="style7">
                  <input type="button" name="restore" value="Restore" onClick="res();">
                  </span></form></td>
              </tr>
            </table>
			<br>
			<br>
            <table width="97%"  border="0" cellpadding="3" cellspacing="1" class="stylebanner">
              <tr>
                <td class="t12 style6"><span class="style2"><b><img src="img/icon_arrow.gif" width="7" height="5" align="absmiddle"></b></span>  Update Firmware</td>
              </tr>
            </table>
            <table width="95%"  border="0">
              <tr>
                <td width="201"><span class="style7">&#8231;
                  Current Firmware Version : </span><span class="t12"></span></td>
                <td><span class="style7"><% getfwversion(); %> build:<% getfwbuild(); %></span></td>
              </tr>
                <form action="firmwareupgrade.cgi?type=factorydefault" method="post" enctype="multipart/form-data" name="formup" id="formup">
              <tr>
                <td width="201"><span class="style7">&#8231;
                  Select the firmware : </span><span class="t12"></span></td>
                <td><input name="firmware.bin" type="file" id="firmware.bin">
                  <span class="style7">
                    <input type="button" name="update" value="Update" onClick="up();">
                  </span></td></tr></form>
            </table>
            <p><br>
            </p>
            
          <!-- InstanceEndEditable --><br>
            
            <br>
            <br>
          <br></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<!-- InstanceBeginEditable name="EditRegion6" --><!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>
