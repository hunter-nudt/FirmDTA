var lang_use = "";
if (parent == window){
	document.write("<script language=\"JavaScript\" type=\"text/javascript\" src=\"../lang/en/itemname.js\"></script>");
	document.write("<script language=\"JavaScript\" type=\"text/javascript\" src=\"../lang/en/msg.js\"></script>");
	lang_use = "en";
}else{
	document.write("<script language=\"JavaScript\" type=\"text/javascript\" src=\"../lang/"+parent.languagevaule+"/itemname.js\"></script>");
	document.write("<script language=\"JavaScript\" type=\"text/javascript\" src=\"../lang/"+parent.languagevaule+"/msg.js\"></script>");
	lang_use = parent.languagevaule;
}

