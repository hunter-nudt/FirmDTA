// JavaScript Document
function hello(){
	alert("hello!");
	
}
function range(value,min,max){
	return ((value<min)||(value>max))?false:true;
}


function warnAndSelect(obj,str){
        alert(str);
        obj.select();
}

function isNUM(obj){
	if(isNaN(obj.value)==true)
	{
		warnAndSelect(obj,popup_msg[popup_msg_13]+": "+ obj.value);
    	return false;
	}
	return true;
}
function inRange(obj){
	if (range(obj.value,0,255)==false)
	{
		warnAndSelect(obj,popup_msg[popup_msg_12]+": " + obj.value + " [0-255]");
		return false;
	}
	return true;
}

function isFilled(obj){
	if(trimAllblank(obj.value)=="")
	{
		warnAndSelect(obj,popup_msg[popup_msg_11]);
		return false;
	}
	return true
}

function isPosInt(num){
	re = /^\d+$/;
	return re.test(num);
}

function trimAllblank(s){
	// trim leading spaces 
  while (s.substring(0,1) == ' ') 
    s = s.substring(1,s.length);
	// trim trailing spaces
  while (s.substring(s.length-1,s.length) == ' ') 
    s = s.substring(0,s.length-1);
  return s;
}

function rangeCheck(obj,minint,maxint){
	re = /^\d+$/;
	if (isPosInt(obj.value)==false) {
		warnAndSelect(obj,"\'"+ obj.value + "\' "+popup_msg[popup_msg_43]+"!\'");
		return false;
	}
	if(range(obj.value,minint,maxint)==false){
		warnAndSelect(obj, "\'" + obj.value + "\' "+ popup_msg[popup_msg_12] +' ['+ minint + '-' + maxint + ']');
		return false;
	}
	return true;
	
}

function evenCheck(obj){
	if (isPosInt(obj.value)==false) {
		warnAndSelect(obj,"\'"+ obj.value + "\' "+popup_msg[popup_msg_43]+"!\'");
		return false;
	}
	if(((obj.value)%2)!=0){
		warnAndSelect(obj, popup_msg[popup_msg_93]);
		return false;
	}
	return true;
	
}

function ipCheck(a,b,c,d,option){
	if(((trimAllblank(a.value)=="")&&(trimAllblank(b.value)=="")&&(trimAllblank(c.value)=="")&&(trimAllblank(d.value)==""))==false)
	{
	 
	 if(isFilled(a) == false)return false;	
	 if(isFilled(b) == false)return false;
	 if(isFilled(c) == false)return false;
	 if(isFilled(d) == false)return false;
	}
	else if(option)//should filled
	{
		warnAndSelect(a,popup_msg[popup_msg_44]);
		return false;
	}
	
	if((parstIntTrimLeadZero(a.value)==0)&&(parstIntTrimLeadZero(b.value)==0)&&(parstIntTrimLeadZero(c.value)==0)&&(parstIntTrimLeadZero(d.value)==0))
	{
		warnAndSelect(a,popup_msg[popup_msg_14]);
		return false;
	}
	if((parstIntTrimLeadZero(a.value)==255)&&(parstIntTrimLeadZero(b.value)==255)&&(parstIntTrimLeadZero(c.value)==255)&&(parstIntTrimLeadZero(d.value)==255))
	{
		warnAndSelect(a,popup_msg[popup_msg_15]);
		return false;
	}
	
	if(inRange(a) == false)	return false;
	if(inRange(b) == false)	return false;
	if(inRange(c) == false)	return false;
	if(inRange(d) == false)	return false;
	if(isNUM(a) == false)	return false;
	if(isNUM(b) == false)	return false;
	if(isNUM(c) == false)  return false;
	if(isNUM(d) == false) 	return false;	
	return true;
}

function ipRangeCheck(s1,s2,s3,s4,e1,e2,e3,e4){
	if( (s1.value - e1.value) > 0 )
	{
		alert(popup_msg[popup_msg_95]);
		return false;
	}
	else if( (s2.value - e2.value) > 0 )
	{
		if( s1.value < e1.value )
			return true
		alert(popup_msg[popup_msg_95]);
		return false;
	}
	else if( (s3.value - e3.value) > 0 )
	{
		if( (s1.value < e1.value) || (s2.value < e2.value) )
			return true
		alert(popup_msg[popup_msg_95]);
		return false;
	}
	else if( (s4.value - e4.value) > 0 )
	{
		if( (s1.value < e1.value) || (s2.value < e2.value) || (s3.value < e3.value) )
			return true
		alert(popup_msg[popup_msg_95]);
		return false;
	}
	return true;
}

function ipv6Check(a,option){
	var v=trimAllblank(a.value);
	var v6Expression = /^(([A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4})$|^([A-Fa-f0-9]{1,4}::([A-Fa-f0-9]{1,4}:){0,5}[A-Fa-f0-9]{1,4})$|^(([A-Fa-f0-9]{1,4}:){2}:([A-Fa-f0-9]{1,4}:){0,4}[A-Fa-f0-9]{1,4})$|^(([A-Fa-f0-9]{1,4}:){3}:([A-Fa-f0-9]{1,4}:){0,3}[A-Fa-f0-9]{1,4})$|^(([A-Fa-f0-9]{1,4}:){4}:([A-Fa-f0-9]{1,4}:){0,2}[A-Fa-f0-9]{1,4})$|^(([A-Fa-f0-9]{1,4}:){5}:([A-Fa-f0-9]{1,4}:){0,1}[A-Fa-f0-9]{1,4})$|^(([A-Fa-f0-9]{1,4}:){6}:[A-Fa-f0-9]{1,4})$|^(::[A-Fa-f0-9]{1,4})$/
	var mappingIPv4 = /^(FFFF:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$|^(ffff:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/
	var thesameIPv4 = /^(::\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/
	if(trimAllblank(v)!=""){
		
	 	if( v6Expression.test(v)== false ){
	 		if( v.match(mappingIPv4) )
	 		{
	 			var m=v.split(":"); // remove :
	 			var m4=m[1].split("."); 
	 			if( (m4[0] > 255) || (m4[1] > 255) || (m4[2] > 255) || (m4[3] > 255) || (m4[0] < 0) || (m4[1] < 0) || (m4[2] < 0) || (m4[3] < 0) ){
	 				warnAndSelect(a,popup_msg[popup_msg_91]);
	 				return false;
	 			}else
	 				return true;	
	 		}
	 		if( v.match(thesameIPv4) )
	 		{
	 			var t=v.split("::");
	 			var t4=t[1].split("."); 
	 			if( (t4[0] > 255) || (t4[1] > 255) || (t4[2] > 255) || (t4[3] > 255) || (t4[0] < 0) || (t4[1] < 0) || (t4[2] < 0) || (t4[3] < 0) ){
	 				warnAndSelect(a,popup_msg[popup_msg_91]);
	 				return false;
	 			}else
	 				return true;	
	 		}
		 	warnAndSelect(a,popup_msg[popup_msg_91]);
		 	return false;
		}
	}
	return true;
}

function getRadioCheckedIndex(radioobj){
	var value=0;
	for (i=0;i<radioobj.length;i++){
		if (radioobj[i].checked)
		   return i
	}
}
function wepCheck(obj,format,length){
	var maxlength ;
	if(format == 0)//ascii
	{
		if(isAscii(obj.value) == false)
		{	warnAndSelect(obj,popup_msg[popup_msg_19]);
			return false;
		}
			
	}else if(format == 1)//hex
	{
		if(isHex(obj.value) == false)
		{	warnAndSelect(obj,popup_msg[popup_msg_21]);
			return false;
		}	
		
	}
	if((format == 0) && ( length == 0))
		maxlength =5;//ascii ,64bits
	else if((format == 0) && ( length == 1))
			maxlength =13;//ascii, 128bits
	else if((format == 1) && ( length == 0))
			maxlength =10;//hex, 64bits
	else if((format == 1) && ( length == 1))
			maxlength = 26;//ascii, 128bits
	if(obj.value.length != maxlength)
	{	warnAndSelect(obj,popup_msg[popup_msg_17]+" " + maxlength + " "+popup_msg[popup_msg_18]);
		return false;
	}
	return true;
}
function wpaCheck(obj){
	if(obj.value.length == 64)
	{
		if(isHex(obj.value) == false)
		{	warnAndSelect(obj,popup_msg[popup_msg_21]);
			return false;
		}	
	}
	else
	{
		if(isAscii(obj.value) == false)
		{	warnAndSelect(obj,popup_msg[popup_msg_19]);
				return false;
		}
	}
	if(range(obj.value.length,8,64) == false)
	{	warnAndSelect(obj,popup_msg[popup_msg_20]);
		return false;
	}
	return true;
}

function isAscii(str){
      var temp ;

	  for(var i =0 ;i<str.length;i++){
	     temp = str.charCodeAt(i);
		 if(temp < 32 || temp >=127)
		 	return false;
	  }
	  return true;
}
function isHex(str){
	var filter = /^[a-fA-F0-9]+$/;
	return filter.test(str);
		
}
function isAlphaNum(str){
	var filter = /^[a-zA-Z0-9]+$/;
	return filter.test(str);

}
function hexCheck(obj){
	if(isHex(obj.value) == false)
	{	warnAndSelect(obj,popup_msg[popup_msg_22]);
		return false;
	}
		return true;	
}
	
function asciiCheck(obj){
	if(isAscii(obj.value) == false)
	{	warnAndSelect(obj,popup_msg[popup_msg_23]);
		return false;
	}
		return true;
}
function alphanumCheck(obj){
	if(isAlphaNum(obj.value) == false)
	{	warnAndSelect(obj,popup_msg[popup_msg_64]);
		return false;
	}
		return true;
}
function equalCheck(obj,str,warn){
	if(obj.value == str)
	{	
		if(warn!=null)
			warnAndSelect(obj,warn);
		else 
			warnAndSelect(obj,obj.value + " "+popup_msg[popup_msg_24]+" '"+ str +"'");
		return false;
	}
		return true;	
}
function inUserListCheck(listobj,nameobj){
	for(i=0;i<listobj.length;i++)
		if(listobj[i].value == nameobj.value)
		{	
			warnAndSelect(nameobj,popup_msg[popup_msg_25]);	
			return false;	
		}
	return true;
}

function parstIntTrimLeadZero(strobj){
        i=0;
        var str = new String(strobj);
        while ((str.substring(i,i+1)=="0")&&(i<str.length-1))
             i++;
        return parseInt(str.substring(i,str.length))

}

function TrimLeadZero(strobj){
        i=0;
        var str = new String(strobj);
        while ((str.substring(i,i+1)=="0")&&(i<str.length-1))
             i++;
        return str.substring(i,str.length)

}

function addZero(num){
	var t = parstIntTrimLeadZero(num);
	if(t<=9)
	  return "0"+t;
	else
	  return t;
}
function openTarget (form, features, windowName) {
	if (!windowName)
	windowName = popup_msg[popup_msg_26] + (new Date().getTime());
		window.open ('', windowName, features);
	form.target = windowName;

}

function dateCheck(obj){
  var v=trimAllblank(obj.value);
  var v1=v.split("/");
        var filter=/^([0-9]){4}(\/)+([0-9]){2}(\/)+([0-9]){2}$/
        if ((filter.test(v)==false) && (obj.value!="") || (v1[1] == 00) || (v1[2] == 00) )
        {
                warnAndSelect(obj,popup_msg[popup_msg_66]);
                return false;
        }
        return true;
        
}
function timeCheck(obj){
  var v=trimAllblank(obj.value);
        var filter=/^([0-9]){2}(\:)+([0-9]){2}(\:)+([0-9]){2}$/
        if ((filter.test(v)==false) && (obj.value!=""))
        {
                warnAndSelect(obj,popup_msg[popup_msg_66]);
                return false;
        }
        return true;
        
}

function ipv4Check(obj){
	var v=trimAllblank(obj.value);
	var v4=v.split(".");
	var filter4= /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if ((filter4.test(v)==true) && (obj.value!=""))
  {
    if( (v4[0] > 255) || (v4[1] > 255) || (v4[2] > 255) || (v4[3] > 255) || (v4[0] < 0) || (v4[1] < 0) || (v4[2] < 0) || (v4[3] < 0) ){
    	warnAndSelect(obj,popup_msg[popup_msg_66]);
    	return false;
    }
    //warnAndSelect(obj,"pass the IPv4");
    return true;
  }
  //warnAndSelect(obj,"Not IPv4 range");
  return false;
}

function ipCheckv6(obj){
	var v=trimAllblank(obj.value);
	var v4=v.split(".");
	var v6=v.split(":");
  	var v61=v.split("::");
  	var filter6= /^[0-9a-fA-F\:]{2,38}[0-9a-fA-F]$/;
  	var filter6ex1= /^\:\:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
  	var filter6ex2= /^\:\:[0-9a-fA-F]{1,4}\:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
  	if ((filter6ex1.test(v)==true) && (obj.value!=""))
  	{
  		v6ex=v4[0].split("::");
  		if( (v6ex[1] > 255) || (v4[1] > 255) || (v4[2] > 255) || (v4[3] > 255) || (v6ex[1] < 0) || (v4[1] < 0) || (v4[2] < 0) || (v4[3] < 0) ){
  			return false;
  		}
    	return true;
  	}
  	if ((filter6ex2.test(v)==true) && (obj.value!=""))
  	{
  		v6ex=v4[0].split(":");
  		if( (v6ex[3] > 255) || (v4[1] > 255) || (v4[2] > 255) || (v4[3] > 255) || (v6ex[3] < 0) || (v4[1] < 0) || (v4[2] < 0) || (v4[3] < 0) ){
  			return false;
  		}
    	return true;
 	 }
  	if ((filter6.test(v)==true) && (obj.value!=""))
  	{
  		if(v6.length == 1)
  			return false;
	  	if( (v6[0].length > 4) || (v6[1].length > 4) || (v6[2].length > 4) ){
		  		
	  			return false;
	  	}
	  	if(v61[2] >= 0){
	  			return false;
	  	}
	    return true;
  	}
  	return false;
}


function ipv4or6Check(obj){
  var v=trimAllblank(obj.value);
  var v4=v.split(".");
  var v6=v.split(":");
  var v61=v.split("::");
  var v6ex;
        var filter4= /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
        var filter6= /^[0-9a-fA-F\:]{2,38}[0-9a-fA-F]$/;
        var filter6ex1= /^\:\:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
        var filter6ex2= /^\:\:[0-9a-fA-F]{1,4}\:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
        if ((filter6ex1.test(v)==true) && (obj.value!=""))
        {
        	v6ex=v4[0].split("::");
        	if( (v6ex[1] > 255) || (v4[1] > 255) || (v4[2] > 255) || (v4[3] > 255) || (v6ex[1] < 0) || (v4[1] < 0) || (v4[2] < 0) || (v4[3] < 0) ){
        		alert("Invalid IP6ex");
        		return false;
        	}
        	warnAndSelect(obj,"test1");
          return true;
        }
        if ((filter6ex2.test(v)==true) && (obj.value!=""))
        {
        	v6ex=v4[0].split(":");
        	if( (v6ex[3] > 255) || (v4[1] > 255) || (v4[2] > 255) || (v4[3] > 255) || (v6ex[3] < 0) || (v4[1] < 0) || (v4[2] < 0) || (v4[3] < 0) ){
        	alert("Invalid IP6ex2");
        		return false;
        	}
        	warnAndSelect(obj,"test2");
          return true;
        }
        if ((filter4.test(v)==true) && (obj.value!=""))
        {
        	if( (v4[0] > 255) || (v4[1] > 255) || (v4[2] > 255) || (v4[3] > 255) || (v4[0] < 0) || (v4[1] < 0) || (v4[2] < 0) || (v4[3] < 0) ){
        		alert("Invalid IP1");
        		return false;
        	}
                warnAndSelect(obj,"test3");
                return true;
        }
        if ((filter6.test(v)==true) && (obj.value!=""))
        {
        	//alert(v6[0]);
        	//alert(v6[0].length);
     			alert(v.length);	
     			alert(v);	
        	if(v.length == 3)
        		if(v[1] != ":"){
        			alert("invalid IP5");
        			return false;
        		}
        	if((v6[1] == "undefined") || (v6[2] == "undefined"))
        		return false;
        	if( (v6[0].length > 4) || (v6[1].length > 4) || (v6[2].length > 4) ){
        			alert("invalid IP11111111");
        			return false;
        	}
        	if( (v6[3] != "undefined") || (v6[4] != "undefined") || (v6[5] != "undefined") || (v6[6] != "undefined") || (v6[7] != "undefined") ){
        		if( (v6[8] >= 0) || (v6[0].length > 4) || (v6[1].length > 4) || (v6[2].length > 4) || (v6[3].length > 4) || (v6[4].length > 4) || (v6[5].length > 4) || (v6[6].length > 4) || (v6[7].length > 4) ){
        			alert("invalid IP2");
        		return false;
        		}   		
        	}
        	if(v61[2] >= 0){
        			alert("invalid IP3");
        			return false;
        	}
              warnAndSelect(obj,"test4");
              return true;
        }
       	alert("invalid IP4");
        return false;
        
}

function hostCheck(obj){
	var v=trimAllblank(obj.value);
	var filter = /^([\w\.\-\_]+)$/;
	if ((filter.test(v)==true) || (obj.value==""))
	{
		//warnAndSelect(obj,"pass the host");
		return true;
	}
	warnAndSelect(obj,popup_msg[popup_msg_66]);
	return false;
}

function emailCheck(obj){
	var v=trimAllblank(obj.value);
	var filter=/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/
	//var filter=/^(\w+|\-+)((\w+|\-+)|(\.\w+)|(\-+\.)|(\.\-+))*\@[A-Za-z0-9]+((\.|\:)+[A-Za-z0-9]+)*(\.|\:)+[A-Za-z0-9]+$/
	if ((filter.test(v)==true) || (obj.value==""))
	{
	        //warnAndSelect(obj,"pass the email test");
	        return true;
	}
	warnAndSelect(obj,popup_msg[popup_msg_67]);
	return false;
}
function portUsedCheck(obj1,obj2,obj3){
	if(obj1.value == obj2 || obj1.value == obj3){
		warnAndSelect(obj1,popup_msg[popup_msg_78]);
		return false;
	}
	return true;
}
function reloadScreen(obj){
		location.href = obj;
}
function customCmdCheck(obj){
	if(!(trimAllblank(obj.value)=="")){
		if(hexCheck(obj)==false)
			return false;
	}
	return true;
}
function areaCheck(obj1,obj2){

        if((parseInt(obj1.value)*parseInt(obj2.value))>38400)
        {
                warnAndSelect(obj1,popup_msg[popup_msg_87]);
                return false;
        }else if((parseInt(obj1.value)*parseInt(obj2.value))<64)
        {
                warnAndSelect(obj1,popup_msg[popup_msg_97]);
                return false;
        }
        return true;     
}
function widthCheck(obj1,obj2){

        if((parseInt(obj1.value)+parseInt(obj2.value))>640)
        {
                warnAndSelect(obj2,popup_msg[popup_msg_88]);
                return false;
        }
        return true;     
}
function heightCheck(obj1,obj2){

        if((parseInt(obj1.value)+parseInt(obj2.value))>480)
        {
                warnAndSelect(obj2,popup_msg[popup_msg_89]);
                return false;
        }
        return true;     
}
function multipleCheck(obj1,obj2){
	if(obj1.value%obj2 != 0)
	{	warnAndSelect(obj1,popup_msg[popup_msg_90]);
		return false;
	}
	return true;
}
