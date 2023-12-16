<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=800px">
<title>Success!</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">
var lang_use = "<% getLanguageValue(); %>";

if (lang_use == "en" || lang_use == "tc" || lang_use == "sc"|| lang_use == "de" || lang_use == "fr" || lang_use == "es" || lang_use == "it" || lang_use == "jp"){
	document.write("\<script language=\"JavaScript\" type=\"text\/javascript\" src=\"..\/lang\/"+lang_use+"\/itemname.js\"><\/script>");
	document.write("\<script language=\"JavaScript\" type=\"text\/javascript\" src=\"..\/lang\/"+lang_use+"\/msg.js\"><\/script>");
}else{
	document.write("\<script language=\"JavaScript\" type=\"text\/javascript\" src=\"..\/lang\/en\/itemname.js\"><\/script>");
	document.write("\<script language=\"JavaScript\" type=\"text\/javascript\" src=\"..\/lang\/en\/msg.js\"><\/script>");
}
</script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("test_server",item_name[_TEST_SERVER]);

}
</script>
</head>
<body onLoad="start();">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
  <tr>
    <td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="test_server" name="test_server"> </span></font></b></td>
  </tr>
  <tr>
    <td valign="top">
    	<table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      	<tr>
        	<td height="30" class="bggrey">
        		<p class="style7"><% geterrstr(); %></p>
          	<p class="style7">&nbsp;</p>
          	<p class="style7">&nbsp;</p>
          	<p class="style7">&nbsp;</p>
        	</td>
      	</tr>
    	</table>
    </td>
  </tr>
</table>
</body>
</html>
