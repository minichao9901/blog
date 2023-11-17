
TVF FUNCTION nmos_sub_checks [/*

package require CalibreLVS_PERC

proc nmos_sub_init {}{
	# Define Voltages on supply ports.
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	# Create path through MOS S/D pins and resistors.
	# perc::create_lvs_path -break {Pwr_all || Ground}
	perc::create_net_path -type {R} -pin {p n}
}

proc nmos_sub_rule {} {
	#Identify all the LV-NMOS devices.
	perc::check_device -type {MN} -subtype {nmos nmos_hvt nmos_lvt nmos_lvt_mis nmos_hvt_mis nmos_3p3v nmos_5v nmos_sv_mis nmos_6v nmos_6v_mis} -condition cond_nmos_sub -comment "Error:Wrong B(Bulk) connection for NMOS outside dnwell"
}

proc cond_nmos_sub {dev} {
	# Pin B for NMOS outside DNWell must connect to ground
	if { [perc::is_pin_of_path_type $dev {b} {!Ground}] } {
		set cell [perc::name [perc::get_placements $dev]]
		# lnet is the local net in the subckt
		set lnet [perc::name [perc::get_nets $dev -name B ]]
		perc::report_base_result -value "[perc::name $dev]'B tied at $cell/$lnet is not ground."
		return 1
	}
	return 0
}

*/]

