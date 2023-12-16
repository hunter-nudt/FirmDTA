function check(selectElem, selectElem2){
			document.getElementById(selectElem).style.backgroundColor="";
			document.getElementById(selectElem2).className = 'submenushightlight' ;
}
	
function uncheck(selectElem, selectElem2){
			document.getElementById(selectElem).style.backgroundColor="";
			document.getElementById(selectElem2).className = 'submenus' ;

}

function loadIframe(iframeName, url, selectItem, selectElem, selectElem2) {
	var obj = document.getElementById(selectItem);	
	
		if (selectItem == "Basic" ){ 
			
			document.getElementById("b_basic_h").style.display = "";
			document.getElementById("b_basic").style.display = "none";
			document.getElementById(selectItem).className="submenubg";
	 		obj.style.display = "";
	 		if(selectElem == "system")
				check(selectElem, selectElem2);
			else
				uncheck("system", "system2");
			if(selectElem == "date")
				check(selectElem, selectElem2);
			else
				uncheck("date", "date2");
			if(selectElem == "user")
				check(selectElem, selectElem2);
			else
				uncheck("user", "user2");
		}else{
			 document.getElementById("Basic").style.display = "none";
			 document.getElementById("b_basic_h").style.display = "none";
			 document.getElementById("b_basic").style.display = "";
		}
	
		if (selectItem == "Network" ){
			
			document.getElementById("b_network_h").style.display = "";
			document.getElementById("b_network").style.display = "none";
			document.getElementById(selectItem).className="submenubg";
	 		obj.style.display = "";
	 		if(selectElem == "net"){
				check(selectElem, selectElem2);
				document.getElementById("advanced").style.display = "";
			}else
				uncheck("net", "net2");
			if(selectElem == "ip")
				check(selectElem, selectElem2);
			else
				uncheck("ip", "ip2");
			if(selectElem == "wire"){
				check(selectElem, selectElem2);
				//document.getElementById("wps").style.display = "";
			}else
				uncheck("wire", "wire2");
			if(selectElem == "advanced"){
				check(selectElem, selectElem2);
				document.getElementById("advanced").style.display = "";
			}else
				uncheck("advanced", "advanced2");
			if(selectElem == "wps"){
				check(selectElem, selectElem2);
				document.getElementById("wps").style.display = "";
			}else
				uncheck("wps", "wps2");
		}else{
			 document.getElementById("Network").style.display = "none";
			 document.getElementById("b_network_h").style.display = "none";
			 document.getElementById("b_network").style.display = "";	
		}
		
		/*if (selectItem == "PanTilt" ){
			
			document.getElementById("b_pantilt_h").style.display = "";
			document.getElementById("b_pantilt").style.display = "none";
	 		
		}else{
			
			document.getElementById("b_pantilt_h").style.display = "none";
			document.getElementById("b_pantilt").style.display = "";	
		}*/
		
		if (selectItem == "VideoAudio" ){
			
			document.getElementById("b_videoaudio_h").style.display = "";
			document.getElementById("b_videoaudio").style.display = "none";
			document.getElementById(selectItem).className="submenubg";
	 		obj.style.display = "";
	 		if(selectElem == "camera")
				check(selectElem, selectElem2);
			else
				uncheck("camera", "camera2");
			if(selectElem == "video")
				check(selectElem, selectElem2);
			else
				uncheck("video", "video2");
			if(selectElem == "audio")
				check(selectElem, selectElem2);
			else
				uncheck("audio", "audio2");
			if(selectElem == "overlaymask"){
				check(selectElem, selectElem2);
				document.getElementById("textover").style.display = "";
			}else
				uncheck("overlaymask", "overlaymask2");
			if(selectElem == "textover"){
				check(selectElem, selectElem2);
				document.getElementById("textover").style.display = "";
			}else
				uncheck("textover", "textover2");
		}else{
			 document.getElementById("VideoAudio").style.display = "none";
			 document.getElementById("b_videoaudio_h").style.display = "none";
			 document.getElementById("b_videoaudio").style.display = "";	
		}
		
		if (selectItem == "Server" ){
			
			document.getElementById("b_eventserver_h").style.display = "";
			document.getElementById("b_eventserver").style.display = "none";
			document.getElementById(selectItem).className="submenubg";
	 		obj.style.display = "";
	 		if(selectElem == "http")
				check(selectElem, selectElem2);
			else
				uncheck("http", "http2");
	 		if(selectElem == "ftp")
				check(selectElem, selectElem2);
			else
				uncheck("ftp", "ftp2");
			if(selectElem == "email")
				check(selectElem, selectElem2);
			else
				uncheck("email", "email2");
			if(selectElem == "nets")
				check(selectElem, selectElem2);
			else
				uncheck("nets", "nets2");
			if(selectElem == "jabber")
				check(selectElem, selectElem2);
			else
				uncheck("jabber", "jabber2");
			if(selectElem == "picasa")
				check(selectElem, selectElem2);
			else
				uncheck("picasa", "picasa2");
			if(selectElem == "youtube")
				check(selectElem, selectElem2);
			else
				uncheck("youtube", "youtube2");
		}else{
			 document.getElementById("Server").style.display = "none";
			 document.getElementById("b_eventserver_h").style.display = "none";
			 document.getElementById("b_eventserver").style.display = "";	
		}
		
		if (selectItem == "Motion" ){
			
			document.getElementById("b_motiondetect_h").style.display = "";
			document.getElementById("b_motiondetect").style.display = "none";
	 		
		}else{
			
			 document.getElementById("b_motiondetect_h").style.display = "none";
			 document.getElementById("b_motiondetect").style.display = "";	
		}
		
		if (selectItem == "Event" ){
			
			document.getElementById("b_eventconfig_h").style.display = "";
			document.getElementById("b_eventconfig").style.display = "none";
			document.getElementById(selectItem).className="submenubg";
	 		obj.style.display = "";
	 		if(selectElem == "general")
				check(selectElem, selectElem2);
			else
				uncheck("general", "general2");
			if(selectElem == "sche")
				check(selectElem, selectElem2);
			else
				uncheck("sche", "sche2");
			if(selectElem == "motrig")
				check(selectElem, selectElem2);
			else
				uncheck("motrig", "motrig2");
			if(selectElem == "schet")
				check(selectElem, selectElem2);
			else
				uncheck("schet", "schet2");
			if(selectElem == "gpiotrig")
				check(selectElem, selectElem2);
			else
				uncheck("gpiotrig", "gpiotrig2");
		}else{
			 document.getElementById("Event").style.display = "none";
			 document.getElementById("b_eventconfig_h").style.display = "none";
			 document.getElementById("b_eventconfig").style.display = "";
		}
		
		if (selectItem == "Tool" ){
			
			document.getElementById("b_tools_h").style.display = "";
			document.getElementById("b_tools").style.display = "none";
	 		
		}else{
			
			document.getElementById("b_tools_h").style.display = "none";
			document.getElementById("b_tools").style.display = "";	
		}
		
		/*if (selectItem == "RS485" ){
			
			document.getElementById("b_rs485_h").style.display = "";
			document.getElementById("b_rs485").style.display = "none";
	 		
		}else{
			
			document.getElementById("b_rs485_h").style.display = "none";
			document.getElementById("b_rs485").style.display = "";	
		}*/
		
		/*if (selectItem == "Usb" ){

			document.getElementById("b_usb_h").style.display = "";
			document.getElementById("b_usb").style.display = "none";

    	}else{

			document.getElementById("b_usb_h").style.display = "none";
			document.getElementById("b_usb").style.display = "";	
		}*/

		
		if (selectItem == "Information" ){
		
			document.getElementById("b_information_h").style.display = "";
			document.getElementById("b_information").style.display = "none";
			document.getElementById(selectItem).className="submenubg";
	 		obj.style.display = "";
	 		if(selectElem == "info")
				check(selectElem, selectElem2);
			else
				uncheck("info", "info2");
			if(selectElem == "log")
				check(selectElem, selectElem2);
			else
				uncheck("log", "log2");
			
		}else{
			 document.getElementById("Information").style.display = "none";
			 document.getElementById("b_information_h").style.display = "none";
			 document.getElementById("b_information").style.display = "";	
		}
			
  if ( window.frames[iframeName] ) {

    window.frames[iframeName].location = url;
    return false;
  }
  else return true;
}
