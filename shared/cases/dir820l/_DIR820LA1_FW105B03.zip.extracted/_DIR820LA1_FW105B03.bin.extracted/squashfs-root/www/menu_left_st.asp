<div class="sidenav">
	<ul>
		<li><div id="left_b1" class="sidenavoff"><a id="left_f1" href="st_device.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b2" class="sidenavoff"><a id="left_f2" href="st_log.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b3" class="sidenavoff"><a id="left_f3" href="st_stats.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b4" class="sidenavoff"><a id="left_f4" href="internet_sessions.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b5" class="sidenavoff"><a id="left_f5" href="st_routing.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b6" class="sidenavoff"><a id="left_f6" href="st_wireless.asp" onclick="return jump_if();"></a></div></li>
		<li class="v6_use" style="display:none"><div id="left_b7" class="sidenavoff"><a id="left_f7" href="st_ipv6.asp" onclick="return jump_if();"></a></div></li>
		<li class="v6_use" style="display:none"><div id="left_b8" class="sidenavoff"><a id="left_f8" href="st_routing6.asp" onclick="return jump_if();"></a></div></li>
	</ul>
</div>

<script>
	$('#left_f1').html(get_words('_devinfo'));
	$('#left_f2').html(get_words('_logs'));
	$('#left_f3').html(get_words('_stats'));
	$('#left_f4').html(get_words('YM157'));
	$('#left_f5').html(get_words('_routing'));
	$('#left_f6').html(get_words('_wireless'));
	$('#left_f7').html(get_words('IPV6_TEXT137'));
	$('#left_f8').html(get_words('v6_routing'));

	var misc = new ccpObject();
	var dev_info	= misc.get_router_info();
	var v4v6		= dev_info.v4v6_support;

	if (v4v6 == '1')
		$('.v6_use').show();
</script>