<div class="sidenav">
	<ul>
		<li><div id="left_b1" class="sidenavoff"><a id="left_f1" href="support_men.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b2" class="sidenavoff"><a id="left_f2" href="support_internet.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b3" class="sidenavoff"><a id="left_f3" href="support_adv.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b4" class="sidenavoff"><a id="left_f4" href="support_tools.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b5" class="sidenavoff"><a id="left_f5" href="support_status.asp" onclick="return jump_if();"></a></div></li>
	</ul>
</div>

<script>
	$('#left_f1').html(get_words('ish_menu'));
	$('#left_f2').html(get_words('_setup'));
	$('#left_f3').html(get_words('_advanced'));
	$('#left_f4').html(get_words('_tools'));
	$('#left_f5').html(get_words('_status'));

	var misc = new ccpObject();
	var dev_info	= misc.get_router_info();
	var v4v6		= dev_info.v4v6_support;

	if (v4v6 == '1')
		$('.v6_use').show();
</script>
