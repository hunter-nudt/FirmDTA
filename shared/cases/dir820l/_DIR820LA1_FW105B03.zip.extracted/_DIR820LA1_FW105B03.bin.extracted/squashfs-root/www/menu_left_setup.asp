<div class="sidenav">
	<ul>
		<li><div id="left_b1" class="sidenavoff"><a id="left_f1" href="wizard_internet.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b2" class="sidenavoff"><a id="left_f2" href="wizard_wireless.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b3" class="sidenavoff"><a id="left_f3" href="lan.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b4" class="sidenavoff"><a id="left_f4" href="storage_setup.asp" onclick="return jump_if();"></a></div></li>
		<li class="dlna_use" style="display:none"><div id="left_b5" class="sidenavoff"><a id="left_f5" href="media_server.asp" onclick="return jump_if();"></a></div></li>
		<li class="v6_use" style="display:none"><div id="left_b6" class="sidenavoff"><a id="left_f6" href="setup_ipv6.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b7" class="sidenavoff"><a id="left_f7" href="mydlink.asp" onclick="return jump_if();"></a></div></li>
	</ul>
</div>

<script>
	$('#left_f1').html(get_words('sa_Internet'));
	$('#left_f2').html(get_words('_wirelesst'));
	$('#left_f3').html(get_words('bln_title_NetSt'));
	$('#left_f4').html(get_words('storage'));
	$('#left_f5').html(get_words('dlna_t'));
	$('#left_f6').html(get_words('IPV6_TEXT137'));
	$('#left_f7').html(get_words('mydlink_S01'));

	var misc = new ccpObject();
	var dev_info	= misc.get_router_info();
	var v4v6		= dev_info.v4v6_support;
	var dlna_sup	= dev_info.media_server;
	var wfa = +misc.config_val('EN_SPEC_WFA_MYDLINK_1_00');

	if (v4v6 == '1')
		$('.v6_use').show();
	if (dlna_sup == '1')
		$('.dlna_use').show();

	if(wfa)
		$('#left_f4').attr('href', 'storage.asp');
</script>