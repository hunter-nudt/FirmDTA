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
	
	setContent("basic_1",item_name[_BASIC]);
	setContent("user_1",item_name[_USER]);
	setContent("usr_account",item_name[_USER_ACCOUNT]);
	setContent("admin",item_name[_ADMIN]);
	setContent("pwd",item_name[_PASSWORD]);
	setContent("confirm_pwd",item_name[_CONFIRM_PWD]);
	setContent("gen_user",item_name[_GEN_USER]);
	setContent("user_name",item_name[_USER_NAME]);
	setContent("pwd_1",item_name[_PASSWORD]);
	setContent("user_list",item_name[_USERLIST]);
	setContent("guest",item_name[_GUEST]);
	setContent("user_name_1",item_name[_USER_NAME]);
	setContent("pwd_2",item_name[_PASSWORD]);
	setContent("user_list_1",item_name[_USERLIST]);
	setContent("hiddenpage",item_name[_HIDDENPAGEAUTH]);
	setContent("hidenable",item_name[_ENABLE]);

	document.getElementById("add3").value=item_name[_MODIFY];
	document.getElementById("add").value=item_name[_ADD_MOD];
	document.getElementById("delete").value=item_name[_DELETE];
	document.getElementById("add2").value=item_name[_ADD_MOD];
	document.getElementById("delete2").value=item_name[_DELETE];
	document.getElementById("Button").value=item_name[_APPLY];
}	

function list(objsel,objusr){
	if(objsel.length>0)
	objusr.value = objsel[objsel.selectedIndex].text;

}
function userInList(username){
	var obj = document.form1;
	var i=0;
	for(i=0;i<obj.userlist.length;i++)
		if(obj.userlist[i].value == username)
			return true;
	for(i=0;i<obj.guestlist.length;i++)
		if(obj.guestlist[i].value == username)
			return true;
	return false;
}
function hasWhiteSpace(s)
{
	re = new RegExp(/\s/g);
	return re.test(s);
}
function send(act){

	var obj = document.form1;
	obj.type.value = act;
	if(act == "addadm")
	{
		if(asciiCheck(obj.adminpass)== false) return false;
		if(asciiCheck(obj.adminpass2)== false) return false;
		if(hasWhiteSpace(obj.adminpass.value))
		{
			warnAndSelect(obj.adminpass, popup_msg[popup_msg_32]);
			return false;
		}
		if(obj.adminpass.value != obj.adminpass2.value)
		{
			warnAndSelect(obj.adminpass,popup_msg[popup_msg_10]);
			return false;
		}
	}
	else if((act == "addgen")||(act == "addgst"))
	{
		var tobj= (act == "addgen")? obj.username:obj.guestname;
		if((((obj.userlist.length+obj.guestlist.length))>10)&&(userInList(tobj.value)==false))
		{
			alert(popup_msg[popup_msg_45]);
			return false;
		}
		var vobj = (act == "addgen")? obj.userpass:obj.guestpass;
		if(hasWhiteSpace(vobj.value))
		{
			warnAndSelect(vobj, popup_msg[popup_msg_32]);
			return false;
		}
		if(equalCheck(tobj,"admin",popup_msg[popup_msg_28]) == false) return false;
		if(alphanumCheck(tobj)== false) return false;
	}
	else if(act == "delgen")
	{
		if(obj.userlist.length == 0)
			return
		obj.username.value = obj.userlist[obj.userlist.selectedIndex].value
		if(confirm(popup_msg[popup_msg_46]) == false) return false;
	}
	else if(act == "delgst")
	{
		if(obj.guestlist.length == 0)
			return
		obj.guestname.value = obj.guestlist[obj.guestlist.selectedIndex].value
		if(confirm(popup_msg[popup_msg_46]) == false) return false;
	}
	obj.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
	<tr>
		<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="basic_1" name="basic_1"></span>&nbsp;&raquo;&nbsp;<span id="user_1" name="user_1"></span></font></b></td>
	</tr>
	<tr>
  	<td width="100%" height="80" align="center" valign="top">
  		<form action="user.cgi" method="post" name="form1">
  			<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
  				<tr>
       			<td colspan="2" class="greybluebg"><span id="usr_account" name="usr_account"></span></td>
      		</tr>
        	<tr>
        		<td width="150" valign="top" class="bgblue"><span id="admin" name="admin"> </span>: </td>
     		   	<td class="bggrey">
        			<table width="100%" border="0" cellspacing="1" cellpadding="3">
              	<tr>
                	<td width="122" nowrap><span id="pwd" name="pwd"></span>: </td>
                	<td width="111"><input name="adminpass" type="password" class="input100px" id="adminpass" tabindex="1" size="20" maxlength="32"></td>
                	<td rowspan="2" valign="bottom"><input name="add3" type="button" id="add3" value="" onClick="send('addadm');" tabindex="3"></td>
              	</tr>
              	<tr>
                	<td nowrap><span id="confirm_pwd" name="confirm_pwd"></span>: </td>
                	<td><input name="adminpass2" type="password" class="input100px" id="adminpass2" tabindex="2" size="20" maxlength="32"></td>
              	</tr>
              </table>
            </td>
          </tr>
          <tr>
        		<td width="150" valign="top" class="bgblue"><span id="gen_user" name="gen_user"> </span>: </td>
        		<td class="bggrey">
        			<table width="100%" border="0" cellspacing="1" cellpadding="3">
              	<tr>
                	<td width="122" nowrap><span id="user_name" name="user_name"></span>: </td>
                	<td width="111"><input name="username" type="text" class="input100px" id="username" tabindex="4" size="20" maxlength="32"></td>
                	<td rowspan="2" valign="bottom"><input name="add" type="button" id="add" value="" onClick="send('addgen');" tabindex="6"></td>
                </tr>
              	<tr>
                	<td nowrap><span id="pwd_1" name="pwd_1"></span>: </td>
                	<td><input name="userpass" type="password" class="input100px" id="userpass" tabindex="5" size="20" maxlength="32"></td>
                </tr>
                <tr>
           				<td nowrap>&nbsp;</td>
           				<td>&nbsp;</td>
           				<td valign="bottom">&nbsp;</td>
         				</tr>
              	<tr>
                	<td nowrap><span id="user_list" name="user_list"></span>: </td>
                	<td>
                		<select name="userlist" id="userlist"  class="input100px" onChange="list(this,document.form1.username);" onclick="list(this,document.form1.username);" tabindex="7">
										<% getUserList("users"); %></select>
									</td>
                	<td valign="bottom">
                		<input name="delete" type="button" id="delete" value="" onClick="send('delgen');" tabindex="8">
                		<input name="type" type="hidden" value="">
                	</td>
                </tr>
            	</table>
            </td>
          </tr>
          <tr>
        		<td width="150" valign="top" class="bgblue"><span id="guest" name="guest"> </span>: </td>
        		<td class="bggrey">
            	<table width="100%" border="0" cellspacing="1" cellpadding="3">
              	<tr>
                	<td width="122" nowrap><span id="user_name_1" name="user_name_1"></span>: </td>
                	<td width="111"><input name="guestname" type="text" class="input100px" id="guestname" tabindex="9" size="20" maxlength="32"></td>
                	<td rowspan="2" valign="bottom"><input name="add2" type="button" id="add2" value="" onClick="send('addgst');" tabindex="11"></td>
            	  </tr>
              	<tr>
                	<td nowrap><span id="pwd_2" name="pwd_2"></span>: </td>
                	<td><input name="guestpass" type="password" class="input100px" id="guestpass" tabindex="10" size="20" maxlength="32"></td>
            	  </tr>
            	  <tr>
           				<td nowrap>&nbsp;</td>
           				<td>&nbsp;</td>
           				<td valign="bottom">&nbsp;</td>
         				</tr>
            	  <tr>
            	    <td nowrap><span id="user_list_1" name="user_list_1"></span>: </td>
            	    <td>
            	    	<select name="guestlist" id="guestlist" class="input100px" onChange="list(this,document.form1.guestname);" onclick="list(this,document.form1.guestname);" tabindex="12">
            	      <% getUserList("guest"); %></select>
            	    </td>
            	    <td><input name="delete2" type="button" id="delete2" value="" onClick="send('delgst');" tabindex="13"></td>
            	  </tr>
            	</table>
            </td>
          </tr>
          <tr>
          	<td width="150" valign="top" class="bgblue"><span id="hiddenpage" name="hiddenpage"> </span>: </td>
          	<td class="bggrey">
          		<table width="100%" border="0" cellspacing="1" cellpadding="3">
		  					<tr>
		  		  			<td width="122" nowrap><input name="hidden_enable" type="checkbox" id="hidden_enable" value="1" tabindex="14" <% getHiddenAuth("1"); %> ><span id="hidenable" name="hidenable"></span></td>
	        				<td width="111"></td>
	        				<td rowspan="2" valign="bottom"><input name="Button" type="button" id="Button" value="" onClick="send('authhidden');" tabindex="15"></td>
		  					</tr>
		  				</table>
		  			</td>
          </tr>
        </table>
		  </form>
		  <br>
		</td>
  </tr>
</table>
</body>
</html>
