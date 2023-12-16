document.write("<script language=JavaScript type=text/javascript src=frame.cmo></script>");
var languages_num =0;
/*DEF CONFIG_M17N_EN*/ var EN="English"; languages_num++; 
/*DEF CONFIG_M17N_TW*/ var TW="\u7E41\u9AD4\u4E2D\u6587"; languages_num++;
/*DEF CONFIG_M17N_CN*/ var CN="\u7B80\u4F53\u4E2D\u6587"; languages_num++;
/*DEF CONFIG_M17N_JA*/ var JA="\u65E5\u672C\u8A9E"; languages_num++;
/*DEF CONFIG_M17N_DE*/ var DE="Deutsch"; languages_num++;
/*DEF CONFIG_M17N_ES*/ var ES="Espa\u00F1ol"; languages_num++;
/*DEF CONFIG_M17N_FR*/ var FR="Fran\u00E7ais"; languages_num++;
/*DEF CONFIG_M17N_IT*/ var IT="Italiano"; languages_num++;
/*DEF CONFIG_M17N_KO*/ var KO="\uD55C\uAD6D\uC5B4"; languages_num++;

var topnav_text = new Array(_setup,_advanced,_tools,_status,_support);
var sidenav_1 = [
					[sa_Internet,"index",0]
					,[_wirelesst,"wizard_wireless",1]
					,[bln_title_NetSt,"lan",1]
/*DEF VLAN_8021Q_SUPPORT*/					,[bln_title_VlanSt,"vlan",1]
				];
var sidenav_2 = [
					[_virtserv,"adv_virtual",0]
					,[_pf,"adv_portforward",0]
					,[_specappsr,"adv_appl",0]
/*DEF CONFIG_QOS*/					,[YM48,"adv_qos",0]
/*DEF MAC_FILTER*/					,[_netfilt,"adv_filters_mac",0]
/*DEF WLAN_MAC_FILTER*/					,[wlan_netfilt,"adv_filters_mac_wlan",0]
					,[ACCESS_CONTROL,"adv_access_control",0]
					,[_websfilter,"adv_filters_url",0]
					,[INBOUND_FILTER,"Inbound_Filter",0]
					,[_firewalls,"adv_dmz",0]
/*DEF STATIC_ROUTING*/					,[_routing,"adv_routing",0]
					,[_adwwls,"adv_wlan_perform",1]
/*DEF CONFIG_WISH*/					,[YM63,"adv_wish",0]
					,[_advnetwork,"adv_network",0]
/*DEF IPV6_SUPPORT*/					,["IPv6","adv_ipv6_sel_wan",0]
/*DEF SNMP_SUPPORT*/					,[_snmp,"adv_snmp",0]
				];
var sidenav_3 = [
					[_admin,"tools_admin",1]
					,[_time,"tools_time",1]
					,[_syslog,"tools_syslog",1]
					,[te_EmSt,"tools_email",0]
					,[_system,"tools_system",1]
					,[_firmware,"tools_firmw",1]
					,[_dyndns,"tools_ddns",0]
					,[_syscheck,"tools_vct",0]
					,[_scheds,"tools_schedules",1]
				];
				
var sidenav_4 = [
					[_devinfo,"st_device",1]
					,[_logs,"st_log",1]
					,[_stats,"st_stats",1]
					,[YM157,"internet_sessions",0]
					,[sr_RTable,"st_routing",0]
					,[_wireless,"st_wireless",1]
/*DEF IPV6_SUPPORT*/					,["IPv6","st_ipv6",0]
				];
var sidenav_5 = [
					[ish_menu,"support_men",1]
					,[_setup,"support_internet",1]
					,[_advanced,"support_adv",1]
					,[_tools,"support_tools",1]
					,[_status,"support_status",1]
				];
				
					
side_nav = {
	sideclass: function(topenv){				
					return eval("sidenav_"+topenv);
				}	
}

var pathname = document.location.pathname;
var curPage = pathname.substring(pathname.lastIndexOf('/')+1,pathname.lastIndexOf('.'));

function gen_frames(topnav){
//	if(get_by_id("header_container")) gen_header();
//	if(get_by_id("copyright")) gen_copyright();
//	if(get_by_id("m17n_div") && languages_num>1) m17n_lang_select();
//	if(get_by_id("topnav")) gen_topnav(topnav);
//	if(get_by_id("sidenav")) gen_sidenav(topnav);	
}

/* header_container generater**/
/*
function gen_header(){
	var header_container = get_by_id("header_container");
	var tmp_tbody = document.createElement("tbody");
	var tmp_tr = document.createElement("tr");
	var tmp_td;
	var tmp_text;
	
	for(var i=0;i<4;i++){
		tmp_td=document.createElement('td');		
		switch (i)	{
			case 0:
				tmp_text=document.createElement("div");
				tmp="\u00a0\u00a0"+TA2+":"+"\u00a0<a href=\"http://www.dlink.com/default.aspx\" onclick=\"return jump_if();\">"+CMOmodel_name+"</a>";				
				tmp_text.innerHTML=tmp;
				tmp_td.setAttribute("width","100%");
				break;
			case 1:				
				tmp_text=document.createTextNode(TA3+":\u00a0"+CMOhw_version+"\u00a0\u00a0");
				tmp_td.setAttribute("align","right");
				//tmp_td.setAttribute("nowrap",'true');
				tmp_td.style.whiteSpace='nowrap';	//for IE compatibility
				break;
			case 2:
				tmp_text=document.createTextNode(sd_FWV+": "+CMOversion);
				tmp_td.setAttribute("align","right");
				tmp_td.style.whiteSpace='nowrap';				
				break;
			case 3:	
				tmp_text=document.createTextNode(" ");
				break;			
		}
		tmp_td.appendChild(tmp_text);
		tmp_tr.appendChild(tmp_td);		
	}
	tmp_tbody.appendChild(tmp_tr);
	header_container.appendChild(tmp_tbody);	
}	
*/
/* topnav_container generater*/
function gen_topnav(highlight){
	if(!highlight) return false;
	if(!get_by_id("topnav")) return false;
	var topnav = get_by_id("topnav");	
	var tmp_td = new Array();
	var topnav_modelname;
	var topnav_href;
	
	tmp_td[0]= document.createElement("td");
	topnav_modelname = document.createElement("img");
	topnav_modelname.setAttribute("src","short_modnum.gif");
	topnav_modelname.setAttribute("width","125");
	topnav_modelname.setAttribute("height","25");
	tmp_td[0].setAttribute("width","125");
	tmp_td[0].setAttribute("height","29");		

	tmp_td[0].appendChild(topnav_modelname);
	topnav.appendChild(tmp_td[0]);

	for (i=1; i<=topnav_text.length;i++){
		if(CMOwlan0_mode=="rt")
			topnav_href = eval("sidenav_"+i)[0][1];
		else{
			var chPage = 0;
			for(j=0;j<=eval("sidenav_"+i).length;j++){
				if(eval("sidenav_"+i)[j][2]){
					topnav_href = eval("sidenav_"+i)[j][1];
					break;
				}
				if(curPage==eval("sidenav_"+i)[j][1])
					chPage=1;
			}
			if(chPage) location.href = topnav_href+".asp";
		}
				
		tmp_td[i]= document.createElement("td");
		if(highlight==i)
			tmp_td[i].setAttribute("id", "topnavon"); 
		else
			tmp_td[i].setAttribute("id", "topnavoff"); 
		tmp_td[i].setAttribute("height",29);
		tmp_td[i].innerHTML="<a href=\""+topnav_href+".asp\" onclick=\"return jump_if();\">"+topnav_text[i-1]+"</a>";
		topnav.appendChild(tmp_td[i]);
	}

}

/* sidenav_container generater*/
function gen_sidenav(which_topnav){
	if(!which_topnav) return false;	
	var sidenav = get_by_id("sidenav");
	var tmp_ul = document.createElement("ul");		
	sidenav.appendChild(tmp_ul);
	
	var tmp_li;
	var tmp_div = new Array();
	var tmpValue = new Array();
	tmpValue = side_nav.sideclass(which_topnav);	
	
	for (i=0; i<tmpValue.length;i++){
		tmp_li= document.createElement("li");
		tmp_div[i] = document.createElement("div");				
		if(CMOwlan0_mode=="rt" || tmpValue[i][2]) { /* Wireless Mode Type confirm */
			if(curPage==tmpValue[i][1]){
			tmp_div[i].setAttribute("id", "sidenavoff"); 
				tmp_div[i].innerHTML = tmpValue[i][0];
		}else
				tmp_div[i].innerHTML="<a href=\""+tmpValue[i][1]+".asp\" onclick=\"return jump_if();\">"+tmpValue[i][0]+"</a>";
		} else { 
				tmp_div[i].setAttribute("id", "sidenavdisable"); 
				tmp_div[i].innerHTML = tmpValue[i][0];
		}
		
		tmp_li.appendChild(tmp_div[i]);
		tmp_ul.appendChild(tmp_li);		
	}		
}	

function gen_copyright(){
	get_by_id("copyright").innerHTML = _copyright;
}

/* Multiple-lingual language form*/

function m17n_lang_select(){
/*DEF CONFIG_LP*/   return;
/*IFDEF	CONFIG_M17N*/
	if(!CMOm17n_lang)	return;
			
	var m17n_div = get_by_id("m17n_div");
	var m17n_p1 = document.createElement("p");	
	
	var m17n_form = document.createElement("form");
	m17n_form.setAttribute("id", "form_lingual"); 
	m17n_form.setAttribute("name", "form_lingual");  
	m17n_form.setAttribute("method","post");
	m17n_form.setAttribute("action","apply.cgi");	
	var m17n_select = document.createElement("select");
	m17n_select.setAttribute("id", "lingual"); 
	m17n_select.setAttribute("name", "lingual");
	m17n_select.onchange = send_lingual;	
	
	m17n_form.appendChild(m17n_select);
	m17n_p1.appendChild(m17n_form);
	m17n_div.appendChild(m17n_p1);	
	
/*DEF CONFIG_M17N_EN*/  AddOption(m17n_select,EN,"EN");
/*DEF CONFIG_M17N_TW*/  AddOption(m17n_select,TW,"TW");
/*DEF CONFIG_M17N_CN*/  AddOption(m17n_select,CN,"CN");
/*DEF CONFIG_M17N_JA*/  AddOption(m17n_select,JA,"JA");
/*DEF CONFIG_M17N_DE*/  AddOption(m17n_select,DE,"DE");
/*DEF CONFIG_M17N_ES*/  AddOption(m17n_select,ES,"ES");
/*DEF CONFIG_M17N_FR*/  AddOption(m17n_select,FR,"FR");
/*DEF CONFIG_M17N_IT*/  AddOption(m17n_select,IT,"IT");
/*DEF CONFIG_M17N_KO*/  AddOption(m17n_select,KO,"KO");	
	set_selectIndex (CMOm17n_lang,m17n_select);
/*ENDIF CONFIG_M17N*/
} 

function send_lingual(e){
 	try{
    var m17n_response_page = document.getElementById("html_response_page");	
	m17n_response_page.value = get_current_pagename();
    }catch(e){
    var m17n_response_page = document.createElement("input");
    m17n_response_page.setAttribute("type", "hidden");
    m17n_response_page.setAttribute("id", "html_response_page");
    m17n_response_page.setAttribute("name", "html_response_page");    
	m17n_response_page.setAttribute("value", get_current_pagename());
	}
	try{
	var reboot_type = document.getElementById("reboot_type");
	reboot_type.value = "none";
	}catch(e){
	var reboot_type = document.createElement("input");
	reboot_type.setAttribute("type", "hidden");
	reboot_type.setAttribute("id", "reboot_type");
	reboot_type.setAttribute("name","reboot_type");
	reboot_type.setAttribute("value","none");
	}

	document.getElementById("form_lingual").appendChild(m17n_response_page);
	document.getElementById("form_lingual").appendChild(reboot_type);
	document.getElementById("form_lingual").submit();
}
