<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="/Templates/setupconfig.dwt" codeOutsideHTMLIsLocked="false" --><head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>Serial</title>
<!-- InstanceEndEditable -->
<link rel="stylesheet" href="style.css" type="text/css">
<link rel="stylesheet" href="web.css" type="text/css">

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
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="date.js"></script>

<script language="javascript">
function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));

}
</script>
</head><body onLoad="time_go();">
<table width="900" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="21"><img src="images/c1_tl.gif" width="21" height="21"></td>
    <td width="858" background="images/bg1_t.gif"><img src="images/top_1.gif" width="390" height="21"></td>
    <td width="21"><img src="images/c1_tr.gif" width="21" height="21"></td>
  </tr>
  <tr>
    <td valign="top" background="images/bg1_l.gif"><img src="images/top_2.gif" width="21" height="69"></td>
    <td background="images/bg.gif"><table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="13%" valign="top"><img src="images/logo.gif" width="390" height="69"></td>
          <td width="87%" align="right" valign="top"><table width="100%" border="0" cellpadding="4" cellspacing="0">
              <tr>
                <td align="right" valign="top"><img src="images/description_<% getmodelname(); %>.gif"></td>
              </tr>
              <tr>
                <td align="right" valign="top"><b><font color="#FFFFFF">Location: <span class="t12">
                  <% getLocation(); %>
&nbsp;&nbsp;&nbsp; </span></font><font color="#FFFFFF"><span class="style1">
                  <span id="datebar"><% getDate(); %> <%getTime(); %></span>
                  &nbsp; </span>&nbsp; </font></b></td>
              </tr>
            </table></td>
        </tr>
      </table>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="200" valign="top"><table width="21%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td><table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><img src="images/but_top.gif" width="150" height="3"></td>
                    </tr>
                    <tr>
                      <td><table width="100%" border="0" cellpadding="3" cellspacing="0" class="submenubg">
                          <tr>
                            <td width="103%" align="right"><img src="images/spacer.gif" width="10" height="5"></td>
                          </tr>
                          <tr>
                            <td align="center"><a href="/"><img src="images/but_liveview_0.gif" name="b_liveview" width="122" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('b_liveview','','images/but_liveview_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                          </tr>
                          <tr>
                            <td align="center"><a href="setup.cgi?page=system"><img src="images/but_setup_1.gif" name="b_setup" width="122" height="25" border="0" id="Image2" onMouseOver="MM_swapImage('b_setup','','images/but_setup_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                          </tr>
                          <tr>
                            <td align="right"><img src="images/spacer.gif" width="10" height="5"></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr>
                      <td><img src="images/but_bottom.gif" width="150" height="3"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <td width="100%"><img src="images/spacer.gif" width="8" height="8"></td>
              </tr>
            </table>
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="200" height="80"><br>
                  <!-- InstanceBeginEditable name="EditRegion5" -->
                  <table height="100" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><a href="smartwizard.cgi?go=1"><img src="images/but_smartwizard_0.gif" name="b_wizard" width="150" height="28" border="0" id="Image3" onMouseOver="MM_swapImage('b_wizard','','images/but_smartwizard_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=system"><img src="images/but_basic_0.gif" name="b_basic" width="150" height="28" border="0" id="b_basic" onMouseOver="MM_swapImage('b_basic','','images/but_basic_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=network"><img src="images/but_network_0.gif" name="b_network" width="150" height="28" border="0" id="b_network" onMouseOver="MM_swapImage('b_network','','images/but_network_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=camera"><img src="images/but_videoaudio_0.gif" name="b_videoaudio" width="150" height="28" border="0" id="b_videoaudio" onMouseOver="MM_swapImage('b_videoaudio','','images/but_videoaudio_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=http"><img src="images/but_eventserver_0.gif" name="b_eventserver" width="150" height="28" border="0" id="b_eventserver" onMouseOver="MM_swapImage('b_eventserver','','images/but_eventserver_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=motiondetect"><img src="images/but_motiondetect_0.gif" name="b_motiondetect" width="150" height="28" border="0" id="b_motiondetect" onMouseOver="MM_swapImage('b_motiondetect','','images/but_motiondetect_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=general"><img src="images/but_eventconfig_0.gif" name="b_eventconfig" width="150" height="28" border="0" id="b_eventconfig" onMouseOver="MM_swapImage('b_eventconfig','','images/but_eventconfig_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=tools"><img src="images/but_tools_1.gif" name="b_tools" width="150" height="28" border="0" id="b_tools" onMouseOver="MM_swapImage('b_tools','','images/but_tools_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                    <tr>
                      <td><img src="images/spacer.gif" width="8" height="8"></td>
                    </tr>
                    <tr>
                      <td><a href="setup.cgi?page=network"><img src="images/but_information_0.gif" name="b_information" width="150" height="28" border="0" id="b_information" onMouseOver="MM_swapImage('b_information','','images/but_information_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
                    </tr>
                  </table>
                  <!-- InstanceEndEditable --></td>
              </tr>
            </table></td>
          <td width="10"><img src="images/spacer.gif" width="10" height="15"></td>
          <td valign="top"><!-- InstanceBeginEditable name="EditRegion4" -->
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
            <tr>
              <td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4">System Tools &raquo; Mac Rewrite </font></b></td>
            </tr>
            <tr>
              <td valign="top"><form id="form1" name="form1" method="post" action="snwrite.cgi">
                <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
                  <tr>
                    <td colspan="2" class="greybluebg">Mac Rewrite </td>
                    </tr>
                  <tr>
                    <td width="32%" class="bgblue"><span class="style7"> Mac address </span></td>
                    <td width="68%" class="bggrey"><input name="mac" type="text" id="mac" value="<% getdevmac(); %>" size="17" maxlength="17"/></td>
                  </tr>
                </table>
              <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
                    <tr>
                      <td class="bggrey2">                        <input name="Submit" type="submit" class="ButtonSmall" value="Save"/>                        </td>
                    </tr>
                  </table></form>
                <br>
              </td>
            </tr>
          </table>
          <!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
    <td width="21" background="images/bg1_r.gif">&nbsp;</td>
  </tr>
  <tr>
    <td><img src="images/c1_bl.gif" width="21" height="20"></td>
    <td align="right" background="images/bg1_b.gif"><img src="images/copyright.gif" width="264" height="20"></td>
    <td><img src="images/c1_br.gif" width="21" height="20"></td>
  </tr>
</table>
<!-- InstanceBeginEditable name="EditRegion6" --><!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>
