<div class="sidenav">
	<ul>
		<li><div id="left_b1" class="sidenavoff"><a id="left_f1" href="adv_virtual.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b2" class="sidenavoff"><a id="left_f2" href="adv_portforward.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b3" class="sidenavoff"><a id="left_f3" href="adv_appl.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b4" class="sidenavoff"><a id="left_f4" href="adv_qos.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b5" class="sidenavoff"><a id="left_f5" href="adv_filters_mac.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b6" class="sidenavoff"><a id="left_f6" href="adv_access_control.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b7" class="sidenavoff"><a id="left_f7" href="adv_filters_url.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b8" class="sidenavoff"><a id="left_f8" href="Inbound_Filter.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b9" class="sidenavoff"><a id="left_f9" href="adv_dmz.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b10" class="sidenavoff"><a id="left_f10" href="adv_routing.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b11" class="sidenavoff"><a id="left_f11" href="adv_wlan_perform.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b12" class="sidenavoff"><a id="left_f12" href="adv_wps_setting.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b13" class="sidenavoff"><a id="left_f13" href="adv_network.asp" onclick="return jump_if();"></a></div></li>
		<li><div id="left_b14" class="sidenavoff"><a id="left_f14" href="guest_zone.asp" onclick="return jump_if();"></a></div></li>
		<li class="v6_use" style="display:none"><div id="left_b15" class="sidenavoff"><a id="left_f15" href="adv_ipv6_firewall.asp" onclick="return jump_if();"></a></div></li>
		<li class="v6_use" style="display:none"><div id="left_b16" class="sidenavoff"><a id="left_f16" href="adv_ipv6_routing.asp" onclick="return jump_if();"></a></div></li>
		<li class="EN_SPEC_OPENDNS_BY_CLIENT" style="display:none;"><div id="left_b17" class="sidenavoff"><a id="left_f17" href="adv_opendns.asp" onclick="return jump_if();"></a></div></li>
	</ul>
</div>

<script>
	$('#left_f1').html(get_words('_virtserv'));
	$('#left_f2').html(get_words('_pf'));
	$('#left_f3').html(get_words('_specappsr'));
	$('#left_f4').html(get_words('YM48'));
	$('#left_f5').html(get_words('_netfilt'));
	$('#left_f6').html(get_words('_acccon'));
	$('#left_f7').html(get_words('_websfilter'));
	$('#left_f8').html(get_words('_inboundfilter'));
	$('#left_f9').html(get_words('_firewalls'));
	$('#left_f10').html(get_words('_routing'));
	$('#left_f11').html(get_words('_adwwls'));
	$('#left_f12').html(get_words('LY2'));
	$('#left_f13').html(get_words('_advnetwork'));
	$('#left_f14').html(get_words('_guestzone'));
	$('#left_f15').html(get_words('if_iflist'));
	$('#left_f16').html(get_words('v6_routing'));
	$('#left_f17').html(get_words('_adv_opendns'));

	var misc = new ccpObject();
	var dev_info	= misc.get_router_info();
	misc.make_member();
	var v4v6		= dev_info.v4v6_support;

	if (v4v6 == '1')
		$('.v6_use').show();
	if(+misc.misc[0].EN_SPEC_OPENDNS_BY_CLIENT==1){
		$('.EN_SPEC_OPENDNS_BY_CLIENT').show();
	}
</script>