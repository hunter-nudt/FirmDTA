function time_init(pdate){
        var last_date;
        var Y = parseInt(pdate.substring(0,4),10);
        var M = parseInt(pdate.substring(5,7),10) - 1;
        var D = parseInt(pdate.substring(8,10),10);
        var h = parseInt(pdate.substring(11,13),10);
        var m = parseInt(pdate.substring(14,16),10);
        var s = parseInt(pdate.substring(17,19),10);

        last_date = new Date(Y,M,D,h,m,s);
        time_sn = last_date.getTime();
}

function show_time()
{
        var str;

        time_sn = parseInt(time_sn) + 1000;
        now_dt.setTime(time_sn);

        str = addZero(now_dt.getFullYear()) + "/" + addZero(now_dt.getMonth() + 1) + "/" + addZero(now_dt.getDate());
        str += " "+ addZero(now_dt.getHours()) + ":" + addZero(now_dt.getMinutes()) + ":" +
addZero(now_dt.getSeconds());
        datebar_obj.innerHTML = str;

}
var now_dt = new Date();
var datebar_obj;
var int;
function start_date_show(obj){
	datebar_obj = obj;
	int=window.setInterval("show_time()", 1000);
}
function stop_date_show(){
	int=window.clearInterval(int);
}