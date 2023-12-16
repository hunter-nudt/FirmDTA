<html lang=en-US xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<script language="Javascript" src="public.js"></script>
<script language="JavaScript" src="public_msg.js"></script>
<script language="JavaScript">
	function onPageLoad(){
		get_by_id("html_response_page").value = get_by_id("html_response_return_page").value;
	}
	function back(){
		var login_who="";
		if(login_who== "user"){
			window.location.href ="index.asp";
		}else{
			window.location.href = get_by_id("html_response_page").value;
		}
	}
</script>

<link rel="STYLESHEET" type="text/css" href="css_router.css">
<style type="text/css">
<!--
.style1 {color: #FF6600}
-->
</style>
<meta http-equiv=Content-Type content="text/html; charset=UTF8">
</head>
<body topmargin="1" leftmargin="0" rightmargin="0" bgcolor="#757575">
<div >
<form id="form1" name="form1" method="post">
<input type="hidden" id="html_response_page" name="html_response_page" value="wizard.asp">
<input type="hidden" name="html_response_message" value="">
<input type="hidden" id="html_response_return_page" name="html_response_return_page" value=">
  <input type="hidden" name="reboot_type" value="none">
  <table width="838" height="100" border=0 align="center" cellPadding=0 cellSpacing=0 id=table_shell>
  <tr>
    <td bgcolor="#FFFFFF">
      <div align="center">
        <table id="header_container" border="0" cellpadding="5" cellspacing="0" width="838" align="center">
	      <tr>
	        <td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"></a></td>
			<td align="right" nowrap><script>show_words('TA3')</script>:&nbsp;</td>
			<td align="right" nowrap><script>show_words('sd_FWV')</script>:</td>
			<td>&nbsp;</td>
	      </tr>
    	</table>
        <img src="wlan_masthead.gif" width="836" height="92"></div></td>
    </tr>
  <tr>
    <td>
      <table width="838" border=0 align="center" cellPadding=0 cellSpacing=0 >
        <tr>
          <td bgcolor="#FFFFFF"></td></tr>
        <tr>
          <td bgcolor="#FFFFFF"></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF"><p>&nbsp;</p>            <table width="650" border="0" align="center">
            <tr>
              <td height="15"><div id=box_header>
                  <H1 align="left"><span class="style1">&nbsp;</span>
                      <!-- insert name=title -->
                  </H1>
                  <div align="left">
                    <p align="center">Only admin account can change the settings.
                      <!-- repeat name=msg -->
                    </p>
                    <p align="center">&nbsp;</p>
                    <p align="center">
                      <input name="button" id="button" type=button class=button_submit value="" onClick="back()">
                          <script>get_by_id("button").value = _continue;</script>
                    </p>
                  </div>
              </div></td>
            </tr>
          </table>
            <p>&nbsp;</p></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF"><table id="footer_container" border="0" cellpadding="0" cellspacing="0" width="836" align="center">
            <tr>
              <td width="125" align="center">&nbsp;&nbsp;<img src="wireless_tail.gif" width="114" height="35"></td>
              <td width="10">&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table></td>
        </tr>
		</table>     </td>
    </tr>
  </table></form>
  <div id="copyright"></div>
</div>
</BODY>
<script>
	onPageLoad();
</script>
</html>