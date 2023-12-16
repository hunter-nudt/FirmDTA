<html>
<head>
<link rel="STYLESHEET" type="text/css" href="css_router.css">
<script language="JavaScript" src="lingual_<% CmoGetCfg("lingual","none"); %>.js"></script>
<script language="JavaScript" src="public.js"></script>
<script language="JavaScript" src="public_msg.js"></script>
<script language="JavaScript">
	function save_firewall_rule(idx)
	{
		var start = idx * 8;
		var end = (idx + 1) * 8;
		var j = 4;
		for (var i = start; i < end; i++) {
			if (i < 10) {
				if (j < 10)
					get_by_id("firewall_rule_0" + i).value = get_by_id("asp_temp_0" + j).value;
				else
					get_by_id("firewall_rule_0" + i).value = get_by_id("asp_temp_" + j).value;
			}
			else {
				if (j < 10)
					get_by_id("firewall_rule_" + i).value = get_by_id("asp_temp_0" + j).value;
				else
					get_by_id("firewall_rule_" + i).value = get_by_id("asp_temp_" + j).value;
			}
			j++;
		}
	}

	function send_request()
	{
		var idx = parseInt(get_by_id("asp_temp_14").value);
		var control_list = "";

		if (idx == "-1") {		// add a new rule, set idx to max_row
			idx = parseInt(get_by_id("asp_temp_16").value);
		}

		control_list = "1/" + get_by_id("asp_temp_00").value + "/" + get_by_id("asp_temp_02").value + "/"
					 + get_by_id("asp_temp_03").value + "/" + get_by_id("asp_temp_12").value + "/" + get_by_id("asp_temp_01").value;

		if (idx < 10)
			get_by_id("access_control_0" + idx).value = control_list;
		else
			get_by_id("access_control_" + idx).value = control_list;

		save_firewall_rule(idx);

		get_by_id("access_control_filter_type").value = "enable";

		send_submit("form1");
	}
</script>
<title><% CmoGetStatus("title"); %></title>
</head>
<body topmargin="1" leftmargin="0" rightmargin="0" bgcolor="#757575">
	<input type="hidden" id="asp_temp_00" name="asp_temp_00" value="<% CmoGetCfg("asp_temp_00","none"); %>">	<!-- policy name -->
	<input type="hidden" id="asp_temp_01" name="asp_temp_01" value="<% CmoGetCfg("asp_temp_01","none"); %>">	<!-- schedule -->
	<input type="hidden" id="asp_temp_02" name="asp_temp_02" value="<% CmoGetCfg("asp_temp_02","none"); %>">	<!-- machine -->
	<input type="hidden" id="asp_temp_03" name="asp_temp_03" value="<% CmoGetCfg("asp_temp_03","none"); %>">	<!-- filter method -->
	<input type="hidden" id="asp_temp_04" name="asp_temp_04" value="<% CmoGetCfg("asp_temp_04","none"); %>">	<!-- firewall rule 1 -->
	<input type="hidden" id="asp_temp_05" name="asp_temp_05" value="<% CmoGetCfg("asp_temp_05","none"); %>">	<!-- firewall rule 2 -->
	<input type="hidden" id="asp_temp_06" name="asp_temp_06" value="<% CmoGetCfg("asp_temp_06","none"); %>">	<!-- firewall rule 3 -->
	<input type="hidden" id="asp_temp_07" name="asp_temp_07" value="<% CmoGetCfg("asp_temp_07","none"); %>">	<!-- firewall rule 4 -->
	<input type="hidden" id="asp_temp_08" name="asp_temp_08" value="<% CmoGetCfg("asp_temp_08","none"); %>">	<!-- firewall rule 5 -->
	<input type="hidden" id="asp_temp_09" name="asp_temp_09" value="<% CmoGetCfg("asp_temp_09","none"); %>">	<!-- firewall rule 6 -->
	<input type="hidden" id="asp_temp_10" name="asp_temp_10" value="<% CmoGetCfg("asp_temp_10","none"); %>">	<!-- firewall rule 7 -->
	<input type="hidden" id="asp_temp_11" name="asp_temp_11" value="<% CmoGetCfg("asp_temp_11","none"); %>">	<!-- firewall rule 8 -->
	<input type="hidden" id="asp_temp_12" name="asp_temp_12" value="<% CmoGetCfg("asp_temp_12","none"); %>">	<!-- logging -->
	<input type="hidden" id="asp_temp_14" name="asp_temp_14" value="<% CmoGetCfg("asp_temp_14","none"); %>">	<!-- edit_row -->
	<input type="hidden" id="asp_temp_16" name="asp_temp_16" value="<% CmoGetCfg("asp_temp_16","none"); %>">	<!-- max_row -->

	<form id="form1" name="form1" method="post" action="">
	    <input type="hidden" id="html_response_page" name="html_response_page" value="back.asp">
	    <input type="hidden" id="html_response_message" name="html_response_message" value="">
	    <script>get_by_id("html_response_message").value = get_words('sc_intro_sv');</script>
	    <input type="hidden" id="html_response_return_page" name="html_response_return_page" value="adv_access_control.asp">
		<input type="hidden" id="reboot_type" name="reboot_type" value="filter">

		<input type="hidden" id="access_control_filter_type" name="access_control_filter_type" value="<% CmoGetCfg("access_control_filter_type","none"); %>">

		<input type="hidden" id="access_control_00" name="access_control_00" value="<% CmoGetCfg("access_control_00","none"); %>">
		<input type="hidden" id="access_control_01" name="access_control_01" value="<% CmoGetCfg("access_control_01","none"); %>">
		<input type="hidden" id="access_control_02" name="access_control_02" value="<% CmoGetCfg("access_control_02","none"); %>">
		<input type="hidden" id="access_control_03" name="access_control_03" value="<% CmoGetCfg("access_control_03","none"); %>">
		<input type="hidden" id="access_control_04" name="access_control_04" value="<% CmoGetCfg("access_control_04","none"); %>">
		<input type="hidden" id="access_control_05" name="access_control_05" value="<% CmoGetCfg("access_control_05","none"); %>">
		<input type="hidden" id="access_control_06" name="access_control_06" value="<% CmoGetCfg("access_control_06","none"); %>">
		<input type="hidden" id="access_control_07" name="access_control_07" value="<% CmoGetCfg("access_control_07","none"); %>">
		<input type="hidden" id="access_control_08" name="access_control_08" value="<% CmoGetCfg("access_control_08","none"); %>">
		<input type="hidden" id="access_control_09" name="access_control_09" value="<% CmoGetCfg("access_control_09","none"); %>">
		<input type="hidden" id="access_control_10" name="access_control_10" value="<% CmoGetCfg("access_control_10","none"); %>">
		<input type="hidden" id="access_control_11" name="access_control_11" value="<% CmoGetCfg("access_control_11","none"); %>">
		<input type="hidden" id="access_control_12" name="access_control_12" value="<% CmoGetCfg("access_control_12","none"); %>">
		<input type="hidden" id="access_control_13" name="access_control_13" value="<% CmoGetCfg("access_control_13","none"); %>">
		<input type="hidden" id="access_control_14" name="access_control_14" value="<% CmoGetCfg("access_control_14","none"); %>">

		<input type="hidden" id="firewall_rule_00" name="firewall_rule_00" value="<% CmoGetCfg("firewall_rule_00","none"); %>">
		<input type="hidden" id="firewall_rule_01" name="firewall_rule_01" value="<% CmoGetCfg("firewall_rule_01","none"); %>">
		<input type="hidden" id="firewall_rule_02" name="firewall_rule_02" value="<% CmoGetCfg("firewall_rule_02","none"); %>">
		<input type="hidden" id="firewall_rule_03" name="firewall_rule_03" value="<% CmoGetCfg("firewall_rule_03","none"); %>">
		<input type="hidden" id="firewall_rule_04" name="firewall_rule_04" value="<% CmoGetCfg("firewall_rule_04","none"); %>">
		<input type="hidden" id="firewall_rule_05" name="firewall_rule_05" value="<% CmoGetCfg("firewall_rule_05","none"); %>">
		<input type="hidden" id="firewall_rule_06" name="firewall_rule_06" value="<% CmoGetCfg("firewall_rule_06","none"); %>">
		<input type="hidden" id="firewall_rule_07" name="firewall_rule_07" value="<% CmoGetCfg("firewall_rule_07","none"); %>">

		<input type="hidden" id="firewall_rule_08" name="firewall_rule_08" value="<% CmoGetCfg("firewall_rule_08","none"); %>">
		<input type="hidden" id="firewall_rule_09" name="firewall_rule_09" value="<% CmoGetCfg("firewall_rule_09","none"); %>">
		<input type="hidden" id="firewall_rule_10" name="firewall_rule_10" value="<% CmoGetCfg("firewall_rule_10","none"); %>">
		<input type="hidden" id="firewall_rule_11" name="firewall_rule_11" value="<% CmoGetCfg("firewall_rule_11","none"); %>">
		<input type="hidden" id="firewall_rule_12" name="firewall_rule_12" value="<% CmoGetCfg("firewall_rule_12","none"); %>">
		<input type="hidden" id="firewall_rule_13" name="firewall_rule_13" value="<% CmoGetCfg("firewall_rule_13","none"); %>">
		<input type="hidden" id="firewall_rule_14" name="firewall_rule_14" value="<% CmoGetCfg("firewall_rule_14","none"); %>">
		<input type="hidden" id="firewall_rule_15" name="firewall_rule_15" value="<% CmoGetCfg("firewall_rule_15","none"); %>">

		<input type="hidden" id="firewall_rule_16" name="firewall_rule_16" value="<% CmoGetCfg("firewall_rule_16","none"); %>">
		<input type="hidden" id="firewall_rule_17" name="firewall_rule_17" value="<% CmoGetCfg("firewall_rule_17","none"); %>">
		<input type="hidden" id="firewall_rule_18" name="firewall_rule_18" value="<% CmoGetCfg("firewall_rule_18","none"); %>">
		<input type="hidden" id="firewall_rule_19" name="firewall_rule_19" value="<% CmoGetCfg("firewall_rule_19","none"); %>">
		<input type="hidden" id="firewall_rule_20" name="firewall_rule_20" value="<% CmoGetCfg("firewall_rule_20","none"); %>">
		<input type="hidden" id="firewall_rule_21" name="firewall_rule_21" value="<% CmoGetCfg("firewall_rule_21","none"); %>">
		<input type="hidden" id="firewall_rule_22" name="firewall_rule_22" value="<% CmoGetCfg("firewall_rule_22","none"); %>">
		<input type="hidden" id="firewall_rule_23" name="firewall_rule_23" value="<% CmoGetCfg("firewall_rule_23","none"); %>">

		<input type="hidden" id="firewall_rule_24" name="firewall_rule_24" value="<% CmoGetCfg("firewall_rule_24","none"); %>">
		<input type="hidden" id="firewall_rule_25" name="firewall_rule_25" value="<% CmoGetCfg("firewall_rule_25","none"); %>">
		<input type="hidden" id="firewall_rule_26" name="firewall_rule_26" value="<% CmoGetCfg("firewall_rule_26","none"); %>">
		<input type="hidden" id="firewall_rule_27" name="firewall_rule_27" value="<% CmoGetCfg("firewall_rule_27","none"); %>">
		<input type="hidden" id="firewall_rule_28" name="firewall_rule_28" value="<% CmoGetCfg("firewall_rule_28","none"); %>">
		<input type="hidden" id="firewall_rule_29" name="firewall_rule_29" value="<% CmoGetCfg("firewall_rule_29","none"); %>">
		<input type="hidden" id="firewall_rule_30" name="firewall_rule_30" value="<% CmoGetCfg("firewall_rule_30","none"); %>">
		<input type="hidden" id="firewall_rule_31" name="firewall_rule_31" value="<% CmoGetCfg("firewall_rule_31","none"); %>">

		<input type="hidden" id="firewall_rule_32" name="firewall_rule_32" value="<% CmoGetCfg("firewall_rule_32","none"); %>">
		<input type="hidden" id="firewall_rule_33" name="firewall_rule_33" value="<% CmoGetCfg("firewall_rule_33","none"); %>">
		<input type="hidden" id="firewall_rule_34" name="firewall_rule_34" value="<% CmoGetCfg("firewall_rule_34","none"); %>">
		<input type="hidden" id="firewall_rule_35" name="firewall_rule_35" value="<% CmoGetCfg("firewall_rule_35","none"); %>">
		<input type="hidden" id="firewall_rule_36" name="firewall_rule_36" value="<% CmoGetCfg("firewall_rule_36","none"); %>">
		<input type="hidden" id="firewall_rule_37" name="firewall_rule_37" value="<% CmoGetCfg("firewall_rule_37","none"); %>">
		<input type="hidden" id="firewall_rule_38" name="firewall_rule_38" value="<% CmoGetCfg("firewall_rule_38","none"); %>">
		<input type="hidden" id="firewall_rule_39" name="firewall_rule_39" value="<% CmoGetCfg("firewall_rule_39","none"); %>">

		<input type="hidden" id="firewall_rule_40" name="firewall_rule_40" value="<% CmoGetCfg("firewall_rule_40","none"); %>">
		<input type="hidden" id="firewall_rule_41" name="firewall_rule_41" value="<% CmoGetCfg("firewall_rule_41","none"); %>">
		<input type="hidden" id="firewall_rule_42" name="firewall_rule_42" value="<% CmoGetCfg("firewall_rule_42","none"); %>">
		<input type="hidden" id="firewall_rule_43" name="firewall_rule_43" value="<% CmoGetCfg("firewall_rule_43","none"); %>">
		<input type="hidden" id="firewall_rule_44" name="firewall_rule_44" value="<% CmoGetCfg("firewall_rule_44","none"); %>">
		<input type="hidden" id="firewall_rule_45" name="firewall_rule_45" value="<% CmoGetCfg("firewall_rule_45","none"); %>">
		<input type="hidden" id="firewall_rule_46" name="firewall_rule_46" value="<% CmoGetCfg("firewall_rule_46","none"); %>">
		<input type="hidden" id="firewall_rule_47" name="firewall_rule_47" value="<% CmoGetCfg("firewall_rule_47","none"); %>">

		<input type="hidden" id="firewall_rule_48" name="firewall_rule_48" value="<% CmoGetCfg("firewall_rule_48","none"); %>">
		<input type="hidden" id="firewall_rule_49" name="firewall_rule_49" value="<% CmoGetCfg("firewall_rule_49","none"); %>">
		<input type="hidden" id="firewall_rule_50" name="firewall_rule_50" value="<% CmoGetCfg("firewall_rule_50","none"); %>">
		<input type="hidden" id="firewall_rule_51" name="firewall_rule_51" value="<% CmoGetCfg("firewall_rule_51","none"); %>">
		<input type="hidden" id="firewall_rule_52" name="firewall_rule_52" value="<% CmoGetCfg("firewall_rule_52","none"); %>">
		<input type="hidden" id="firewall_rule_53" name="firewall_rule_53" value="<% CmoGetCfg("firewall_rule_53","none"); %>">
		<input type="hidden" id="firewall_rule_54" name="firewall_rule_54" value="<% CmoGetCfg("firewall_rule_54","none"); %>">
		<input type="hidden" id="firewall_rule_55" name="firewall_rule_55" value="<% CmoGetCfg("firewall_rule_55","none"); %>">

		<input type="hidden" id="firewall_rule_56" name="firewall_rule_56" value="<% CmoGetCfg("firewall_rule_56","none"); %>">
		<input type="hidden" id="firewall_rule_57" name="firewall_rule_57" value="<% CmoGetCfg("firewall_rule_57","none"); %>">
		<input type="hidden" id="firewall_rule_58" name="firewall_rule_58" value="<% CmoGetCfg("firewall_rule_58","none"); %>">
		<input type="hidden" id="firewall_rule_59" name="firewall_rule_59" value="<% CmoGetCfg("firewall_rule_59","none"); %>">
		<input type="hidden" id="firewall_rule_60" name="firewall_rule_60" value="<% CmoGetCfg("firewall_rule_60","none"); %>">
		<input type="hidden" id="firewall_rule_61" name="firewall_rule_61" value="<% CmoGetCfg("firewall_rule_61","none"); %>">
		<input type="hidden" id="firewall_rule_62" name="firewall_rule_62" value="<% CmoGetCfg("firewall_rule_62","none"); %>">
		<input type="hidden" id="firewall_rule_63" name="firewall_rule_63" value="<% CmoGetCfg("firewall_rule_63","none"); %>">

		<input type="hidden" id="firewall_rule_64" name="firewall_rule_64" value="<% CmoGetCfg("firewall_rule_64","none"); %>">
		<input type="hidden" id="firewall_rule_65" name="firewall_rule_65" value="<% CmoGetCfg("firewall_rule_65","none"); %>">
		<input type="hidden" id="firewall_rule_66" name="firewall_rule_66" value="<% CmoGetCfg("firewall_rule_66","none"); %>">
		<input type="hidden" id="firewall_rule_67" name="firewall_rule_67" value="<% CmoGetCfg("firewall_rule_67","none"); %>">
		<input type="hidden" id="firewall_rule_68" name="firewall_rule_68" value="<% CmoGetCfg("firewall_rule_68","none"); %>">
		<input type="hidden" id="firewall_rule_69" name="firewall_rule_69" value="<% CmoGetCfg("firewall_rule_69","none"); %>">
		<input type="hidden" id="firewall_rule_70" name="firewall_rule_70" value="<% CmoGetCfg("firewall_rule_70","none"); %>">
		<input type="hidden" id="firewall_rule_71" name="firewall_rule_71" value="<% CmoGetCfg("firewall_rule_71","none"); %>">

		<input type="hidden" id="firewall_rule_72" name="firewall_rule_72" value="<% CmoGetCfg("firewall_rule_72","none"); %>">
		<input type="hidden" id="firewall_rule_73" name="firewall_rule_73" value="<% CmoGetCfg("firewall_rule_73","none"); %>">
		<input type="hidden" id="firewall_rule_74" name="firewall_rule_74" value="<% CmoGetCfg("firewall_rule_74","none"); %>">
		<input type="hidden" id="firewall_rule_75" name="firewall_rule_75" value="<% CmoGetCfg("firewall_rule_75","none"); %>">
		<input type="hidden" id="firewall_rule_76" name="firewall_rule_76" value="<% CmoGetCfg("firewall_rule_76","none"); %>">
		<input type="hidden" id="firewall_rule_77" name="firewall_rule_77" value="<% CmoGetCfg("firewall_rule_77","none"); %>">
		<input type="hidden" id="firewall_rule_78" name="firewall_rule_78" value="<% CmoGetCfg("firewall_rule_78","none"); %>">
		<input type="hidden" id="firewall_rule_79" name="firewall_rule_79" value="<% CmoGetCfg("firewall_rule_79","none"); %>">

		<input type="hidden" id="firewall_rule_80" name="firewall_rule_80" value="<% CmoGetCfg("firewall_rule_80","none"); %>">
		<input type="hidden" id="firewall_rule_81" name="firewall_rule_81" value="<% CmoGetCfg("firewall_rule_81","none"); %>">
		<input type="hidden" id="firewall_rule_82" name="firewall_rule_82" value="<% CmoGetCfg("firewall_rule_82","none"); %>">
		<input type="hidden" id="firewall_rule_83" name="firewall_rule_83" value="<% CmoGetCfg("firewall_rule_83","none"); %>">
		<input type="hidden" id="firewall_rule_84" name="firewall_rule_84" value="<% CmoGetCfg("firewall_rule_84","none"); %>">
		<input type="hidden" id="firewall_rule_85" name="firewall_rule_85" value="<% CmoGetCfg("firewall_rule_85","none"); %>">
		<input type="hidden" id="firewall_rule_86" name="firewall_rule_86" value="<% CmoGetCfg("firewall_rule_86","none"); %>">
		<input type="hidden" id="firewall_rule_87" name="firewall_rule_87" value="<% CmoGetCfg("firewall_rule_87","none"); %>">

		<input type="hidden" id="firewall_rule_88" name="firewall_rule_88" value="<% CmoGetCfg("firewall_rule_88","none"); %>">
		<input type="hidden" id="firewall_rule_89" name="firewall_rule_89" value="<% CmoGetCfg("firewall_rule_89","none"); %>">
		<input type="hidden" id="firewall_rule_90" name="firewall_rule_90" value="<% CmoGetCfg("firewall_rule_90","none"); %>">
		<input type="hidden" id="firewall_rule_91" name="firewall_rule_91" value="<% CmoGetCfg("firewall_rule_91","none"); %>">
		<input type="hidden" id="firewall_rule_92" name="firewall_rule_92" value="<% CmoGetCfg("firewall_rule_92","none"); %>">
		<input type="hidden" id="firewall_rule_93" name="firewall_rule_93" value="<% CmoGetCfg("firewall_rule_93","none"); %>">
		<input type="hidden" id="firewall_rule_94" name="firewall_rule_94" value="<% CmoGetCfg("firewall_rule_94","none"); %>">
		<input type="hidden" id="firewall_rule_95" name="firewall_rule_95" value="<% CmoGetCfg("firewall_rule_95","none"); %>">

		<input type="hidden" id="firewall_rule_96" name="firewall_rule_96" value="<% CmoGetCfg("firewall_rule_96","none"); %>">
		<input type="hidden" id="firewall_rule_97" name="firewall_rule_97" value="<% CmoGetCfg("firewall_rule_97","none"); %>">
		<input type="hidden" id="firewall_rule_98" name="firewall_rule_98" value="<% CmoGetCfg("firewall_rule_98","none"); %>">
		<input type="hidden" id="firewall_rule_99" name="firewall_rule_99" value="<% CmoGetCfg("firewall_rule_99","none"); %>">
		<input type="hidden" id="firewall_rule_100" name="firewall_rule_100" value="<% CmoGetCfg("firewall_rule_100","none"); %>">
		<input type="hidden" id="firewall_rule_101" name="firewall_rule_101" value="<% CmoGetCfg("firewall_rule_101","none"); %>">
		<input type="hidden" id="firewall_rule_102" name="firewall_rule_102" value="<% CmoGetCfg("firewall_rule_102","none"); %>">
		<input type="hidden" id="firewall_rule_103" name="firewall_rule_103" value="<% CmoGetCfg("firewall_rule_103","none"); %>">

		<input type="hidden" id="firewall_rule_104" name="firewall_rule_104" value="<% CmoGetCfg("firewall_rule_104","none"); %>">
		<input type="hidden" id="firewall_rule_105" name="firewall_rule_105" value="<% CmoGetCfg("firewall_rule_105","none"); %>">
		<input type="hidden" id="firewall_rule_106" name="firewall_rule_106" value="<% CmoGetCfg("firewall_rule_106","none"); %>">
		<input type="hidden" id="firewall_rule_107" name="firewall_rule_107" value="<% CmoGetCfg("firewall_rule_107","none"); %>">
		<input type="hidden" id="firewall_rule_108" name="firewall_rule_108" value="<% CmoGetCfg("firewall_rule_108","none"); %>">
		<input type="hidden" id="firewall_rule_109" name="firewall_rule_109" value="<% CmoGetCfg("firewall_rule_109","none"); %>">
		<input type="hidden" id="firewall_rule_110" name="firewall_rule_110" value="<% CmoGetCfg("firewall_rule_110","none"); %>">
		<input type="hidden" id="firewall_rule_111" name="firewall_rule_111" value="<% CmoGetCfg("firewall_rule_111","none"); %>">

		<input type="hidden" id="firewall_rule_112" name="firewall_rule_112" value="<% CmoGetCfg("firewall_rule_112","none"); %>">
		<input type="hidden" id="firewall_rule_113" name="firewall_rule_113" value="<% CmoGetCfg("firewall_rule_113","none"); %>">
		<input type="hidden" id="firewall_rule_114" name="firewall_rule_114" value="<% CmoGetCfg("firewall_rule_114","none"); %>">
		<input type="hidden" id="firewall_rule_115" name="firewall_rule_115" value="<% CmoGetCfg("firewall_rule_115","none"); %>">
		<input type="hidden" id="firewall_rule_116" name="firewall_rule_116" value="<% CmoGetCfg("firewall_rule_116","none"); %>">
		<input type="hidden" id="firewall_rule_117" name="firewall_rule_117" value="<% CmoGetCfg("firewall_rule_117","none"); %>">
		<input type="hidden" id="firewall_rule_118" name="firewall_rule_118" value="<% CmoGetCfg("firewall_rule_118","none"); %>">
		<input type="hidden" id="firewall_rule_119" name="firewall_rule_119" value="<% CmoGetCfg("firewall_rule_119","none"); %>">
	</form>
</body>
<script>
	send_request();
</script>
</html>
