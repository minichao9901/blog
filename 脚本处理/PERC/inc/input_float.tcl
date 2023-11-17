
TVF FUNCTION input_float_checks [/*

package require CalibreLVS_PERC

proc input_float_init {} {
	#Define power supply nets.
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	perc:define_net_type "Pad" {lvsTopPorts}

	#Create indirect path through pins of resistor.
	#perc:create_net_path -type {R} -pin {p n} -property "r < 20000"
	perc:create_net_path -type {R} -pin {p n}

	#Define net type for the S/D pins of MOS devices.
	perc::define_net_type_by_device "nSrcDrn" -type {MN} -pin {s d} -cell -pinNetType {g !Ground} -condition cond_gb_connect
	#perc:define net_type_by_device "nSrcDrn" -type {MN} -pin {s d} -cell -condition cond_gb_connect
	perc:define net_type_by_device "pSrcDrn" -type {MP} -pin {s d} -cell -pinNetType {g !Power} -condition cond_gb_connect
	#perc:define_net_type_by_device "pSrcDrn" -type {MP} -pin {s d} -cell -condition cond_gb_connect
}

 proc cond_gb_connect {dev} {
	set gnet [perc::get_nets $dev -name G ]
	set bnet [perc:get_nets $dev -name B ]
	if { ![string equal $gnet $bnet] } {
		return 1
	}
	return 0
}

proc input_float_rule {} {
	# Check if gates of PMOS/NMOS are not connected to Pad net (Direct/Indirect)
	# Check if gates of PMOS/NMOS are not connected to S/D net (Direct/Indirect)
	# and Report the MOS devices with floating gates with a suitable comment.
	perc:check_device -type {MN MP} -pinPathType {g {!Pad && !nSrcDrn && !pSrcDrn}} -comment "MOS gate input floating"
}
*/]

