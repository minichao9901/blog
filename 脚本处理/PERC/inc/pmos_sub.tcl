
TVF FUNCTION pmos_sub_checks [/*

package require CalibreLVS_PERC

proc pmos_sub_init {} {
	# Define Voltages on supply ports.
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	# Create path through MOS S/D pins and resistors.
	# perc::create_lvs_path -break {Pwr_all || Ground}
	perc::create_net_path -type {R} -pin {p n}
}

proc pmos sub_rule {} {
	# Identify all the LV-PMOS devices.
	perc::check_device -type {MP} -subtype {pmos pmos_hvt pmos_lvt pmos_lvt_mis pmos_hvt_mis pmos_3p3v pmos_5v pmos_5v_mis pmos_6v pmos_6v_mis} -condition cond_pmos_sub -comment "Error:Wrong B(Bulk) connection for PMOS outside dnwell!"
}

proc cond_pmos_sub {dev} {
	# Pin B for PMOS outside DNwell must connect to power
	if { [perc::is_pin_of_path_type $dev {b} {!Power}] } {
		set cell [perc::name [perc::get_placements $dev]]
		# lnet is the local net in the subckt
		set lnet [perc::name [perc::get_nets $dev -name B ]]
		perc::report_base_result -value "[perc::name $dev]'B tied at $cell/$lnet is not power."
		return 1
	}
	return 0
}

*/]

