<div class="sidenav">
	<ul>
		<li><div id="left_b1" class="sidenavoff"><a id="left_f1" href="tools_admin.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b2" class="sidenavoff"><a id="left_f2" href="tools_time.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b3" class="sidenavoff"><a id="left_f3" href="tools_syslog.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b4" class="sidenavoff"><a id="left_f4" href="tools_email.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b5" class="sidenavoff"><a id="left_f5" href="tools_system.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b6" class="sidenavoff"><a id="left_f6" href="tools_firmw.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b7" class="sidenavoff"><a id="left_f7" href="tools_ddns.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b8" class="sidenavoff"><a id="left_f8" href="tools_vct.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b9" class="sidenavoff"><a id="left_f9" href="tools_schedules.asp" onclick="return jump_if();"></a></div></li>
	</ul>
</div>

<script>
	$('#left_f1').html(get_words('_admin'));
	$('#left_f2').html(get_words('_time'));
	$('#left_f3').html(get_words('_syslog'));
	$('#left_f4').html(get_words('_email'));
	$('#left_f5').html(get_words('_system'));
	$('#left_f6').html(get_words('_firmware'));
	$('#left_f7').html(get_words('_dyndns'));
	$('#left_f8').html(get_words('_syscheck'));
	$('#left_f9').html(get_words('_scheds'));
	
	var misc = new ccpObject();
	var dev_info	= misc.get_router_info();
	var v4v6		= dev_info.v4v6_support;

	if (v4v6 == '1')
		$('.v6_use').show();
</script>
