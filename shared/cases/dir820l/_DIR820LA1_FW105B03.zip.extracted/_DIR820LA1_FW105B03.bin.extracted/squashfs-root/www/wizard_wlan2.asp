<html>
<head>
<link rel="STYLESHEET" type="text/css" href="css/css_router.css">
<title></title>
<script language="JavaScript" src="js/public.js"></script>
<script language="JavaScript" src="js/public_msg.js"></script>
<script language="JavaScript">
    var submit_button_flag = 0;

    function show_encryption()
    {
        var security = get_by_id("asp_temp_35").value;

        get_by_id("show_disable").style.display = "none";
       // get_by_id("show_wep").style.display = "none";
        get_by_id("show_wpa").style.display = "none";
        get_by_id("show_wpa2").style.display = "none";
        if (security == "1") {
            get_by_id("show_wep").style.display = "";
        }
        else if (security != "0") {
            if (security == "3") {
                get_by_id("show_wpa2").style.display = "";
            }
            else {
                get_by_id("show_wpa").style.display = "";
            }
        }
        else {
            get_by_id("show_disable").style.display = "";
        }
    }

    function send_request()
    {
        var security = get_by_id("asp_temp_35").value;
        if(security == "0"){
            get_by_id("wlan0_security").value= "disable";
            get_by_id("wps_configured_mode").value = 1;
        }else if(security == "1"){
            var key_word = get_by_id("asp_temp_37").value;
            get_by_id("wlan0_wep_default_key").value= "1";
            if(key_word.length > 10){
                get_by_id("wlan0_security").value= "wep_open_128";
                if(get_by_id("asp_temp_36").value == "ascii"){
                    get_by_id("wlan0_wep128_key_1").value= hex_to_a(get_by_id("asp_temp_37").value);
                }else{
                    get_by_id("wlan0_wep128_key_1").value= get_by_id("asp_temp_37").value;
                }
            }else{
                get_by_id("wlan0_security").value= "wep_open_64";
                if(get_by_id("asp_temp_36").value == "ascii"){
                    get_by_id("wlan0_wep64_key_1").value= hex_to_a(get_by_id("asp_temp_37").value);
                }else{
                    get_by_id("wlan0_wep64_key_1").value= get_by_id("asp_temp_37").value;
                }
            }
            get_by_id("wlan0_wep_display").value= "";
            get_by_id("wps_configured_mode").value = 5;
        }else if(security == "2"){
            get_by_id("wlan0_security").value= "wpa_psk";
            get_by_id("wlan0_psk_pass_phrase").value= get_by_id("asp_temp_37").value;
            get_by_id("wlan0_psk_cipher_type").value= "both";
            get_by_id("wps_configured_mode").value = 5;
        }else if(security == "3"){
            get_by_id("wlan0_security").value= "wpa2auto_psk";
            get_by_id("wlan0_psk_pass_phrase").value= get_by_id("asp_temp_37").value;
            get_by_id("wlan0_psk_cipher_type").value= "both";
            get_by_id("wps_configured_mode").value = 5;
        }else{
            alert("security error");
        }
        if(get_by_id("asp_temp_36").value=="ascii"){
            get_by_id("asp_temp_37").value = hex_to_a(get_by_id("asp_temp_37").value);
        }

        if(submit_button_flag == 0){
            submit_button_flag = 1;
            get_by_id("html_response_return_page").value = "login.asp";
            get_by_id("wps_enable").value = 1;
            get_by_id("form1").submit();
        }
    }

	function wizard_cancel(){
    if (!is_form_modified("mainform")) {
			if(!confirm(_wizquit)) {
		    	return false;
		}
	  }
		window.location.href="wizard_wireless.asp";
	}    
    function go_back(){
        window.location.href = get_by_id("html_response_return_page").value;
    }
</script>
<meta http-equiv=Content-Type content="text/html; charset=UTF8">
<style type="text/css">
<!--
.style4 {font-size: 10px}
-->
</style>
</head>
<body topmargin="1" leftmargin="0" rightmargin="0" bgcolor="#757575">
<table border=0 cellspacing=0 cellpadding=0 align=center width=838>
<tr>
<td></td>
</tr>
<tr>
<td>
<div align=left>
<table width=838 border=0 cellspacing=0 cellpadding=0 align=center height=100>
<tr>
<td bgcolor="#FFFFFF"><div align=center>
  <table id="header_container" border="0" cellpadding="5" cellspacing="0" width="838" align="center">
    <tr>

      <td width="100%">&nbsp;&nbsp;<script>show_words('TA2')</script>: <a href="http://www.dlink.com/us/en/support"></a></td>
      <td align="right" nowrap><script>show_words('TA3')</script>: &nbsp;</td>
      <td align="right" nowrap><script>show_words('sd_FWV')</script>:</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <div align="center"><img src="wlan_masthead.gif" width="836" height="92" align="middle"></div></td>
</tr>
</table>
</div>
</td>
</tr>
<tr>
  <td bgcolor="#FFFFFF"><p>&nbsp;</p>
  <table width="650" border="0" align="center">
    <tr>
      <td><div class=box>
        <h2 align="left"><script>show_words('_setupdone')</script></h2>
        <div align="left">
          <p class="box_msg"><script>show_words('wwl_intro_end')</script></p>
          <form id="form1" name="form1" method="post" action="">
            <input type="hidden" id="html_response_page" name="html_response_page" value="back_long.asp">
            <input type="hidden" id="html_response_return_page" name="html_response_return_page" value="">
            <input type="hidden" id="reboot_type" name="reboot_type" value="all">
            <input type="hidden" id="asp_temp_35" name="asp_temp_35" value="">
            <input type="hidden" id="asp_temp_37" name="asp_temp_37" value="">
            <input type="hidden" id="asp_temp_36" name="asp_temp_36" value="">
            <input type="hidden" id="asp_temp_50" name="asp_temp_50" value="">

            <input type="hidden" id="wlan0_security" name="wlan0_security">
            <input type="hidden" id="wlan0_ssid" name="wlan0_ssid" value="">
            <input type="hidden" id="wlan0_wep_default_key" name="wlan0_wep_default_key">
            <input type="hidden" id="wlan0_wep_display" name="wlan0_wep_display" value="hex">
            <input type="hidden" id="wlan0_wep128_key_1" name="wlan0_wep128_key_1">
            <input type="hidden" id="wlan0_wep64_key_1" name="wlan0_wep64_key_1">
            <input type="hidden" id="wlan0_psk_pass_phrase" name="wlan0_psk_pass_phrase">
            <input type="hidden" id="wlan0_psk_cipher_type" name="wlan0_psk_cipher_type">
            <input type="hidden" id="wps_configured_mode" name="wps_configured_mode">
            <input type="hidden" id="wps_enable" name="wps_enable">
            <div>
              <div id=w2>
                <table width="650" align="center" class="formarea">
                  <tr id="show_disable" style="display:none">
                    <td class="duple"><script>show_words('wwl_wnn')</script>&nbsp;:</td>
                    <td width="263"></td>
                    <td width="10">&nbsp;</td>
                  </tr>
                  <tr id="show_wep" style="display:none">
                    <td colspan="3">
                      <table>
                        <tr>
                          <td class="duple"><script>show_words('wwl_wnn')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td></td>
                        </tr>
                        <tr>
                          <td class="duple"><script>show_words('wwl_WKL')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td>
                            <script>
                                var secu_length = get_by_id("asp_temp_50").value;
                                document.write(key_num_array[secu_length]);
                            </script>
                            bits
                          </td>
                        </tr>
                        <tr>
                          <td class="duple"<script>show_words('wwl_DWKL')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td>1</td>
                        </tr>
                        <tr>
                          <td class="duple"><script>show_words('auth')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td><script>show_words('_open')</script></td>
                        </tr>
                        <tr id="summary_wep_tr">
                          <td class="duple"><script>show_words('wwl_WK')</script>&nbsp;:</td>
                          <td id="summary_wep_td">&nbsp;</td>
                          <td id="summary_wep_td">
                          <script>
                            var show_word = get_by_id("asp_temp_37").value;
                            if(get_by_id("asp_temp_35").value == "1"){
                                if(get_by_id("asp_temp_36").value=="ascii"){
                                     show_word = hex_to_a(get_by_id("asp_temp_37").value);
                                }else if(get_by_id("asp_temp_36").value=="hex"){
                                     show_word = get_by_id("asp_temp_37").value;
                                    }
                            }
                            document.write(show_word);
                          </script>
                          </td>
                        </tr>
                    </table></td>
                  </tr>
                  <tr id="show_wpa" style="display:none">
                    <td colspan="3">
                      <table>
                        <tr>
                          <td class="duple"><script>show_words('wwl_wnn')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td></td>
                        </tr>
                        <tr>
                          <td class="duple"><script>show_words('bws_SM')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td><script>show_words('bws_WPAM_1')</script></td>
                        </tr>
                        <tr>
                          <td class="duple"><script>show_words('bws_CT')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td><script>show_words('bws_CT_3')</script></td>
                        </tr>
                        <tr>
                          <td class="duple"><script>show_words('_psk')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td></td>
                        </tr>
                    </table></td>
                  </tr>
                    <tr id="show_wpa2" style="display:none">
                    <td colspan="3">
                      <table>
                        <tr>
                          <td width="3%">&nbsp;</td>
                          <td width="26%" class="duple"><script>show_words('wwl_wnn')</script>&nbsp;:</td>
                          <td width="1%">&nbsp;</td>
                          <td width="70%"></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td class="duple"><script>show_words('bws_SM')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td><script>show_words('KR48')</script></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td class="duple"><script>show_words('bws_CT')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td><script>show_words('bws_CT_3')</script></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td class="duple"><script>show_words('_psk')</script>&nbsp;:</td>
                          <td>&nbsp;</td>
                          <td></td>
                        </tr>

                    </table></td>
                  </tr>
                  <tr id="show_wpa2_auto style="display:none">
                    <td colspan="3">&nbsp;</td>
                  </tr>
                </table>
                <div align="center"><br>
                    <input type="button" class="button_submit" id="prev_b" name="prev_b" value="" onClick="go_back();">
                    <input type="button" class="button_submit" id="save_b" name="save_b" value="" onClick="send_request();">
                    <input type="button" class="button_submit" id="cancel_b" name="cancel_b" value="" onClick="wizard_cancel();">
                    <script>get_by_id("prev_b").value = _prev;</script>
                    <script>get_by_id("save_b").value = _save;</script>
                    <script>get_by_id("cancel_b").value = _cancel;</script>
                    <br>
                </div>
              </div>
            </div>
          </form>
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
</table>
<div id="copyright"></div>
</body>
<script>
    show_encryption();
</script>
</html>