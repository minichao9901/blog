
TVF FUNCTION pad_in_gate_res [/*

package require CalibreLVS_PERC

proc pad_in_gate_res_init{} {
	# Define Voltages on supply ports.
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	perc::define_net_type "Pad" {lvsTopPorts}
	# Create net path through resistors less than 300 ohm.
	perc::create_net_path -type {R} -pin {p n} -property "r < 300"
}

proc pad_in_gate_res_rule{} {
	# Identify all MOS devices in design, Check if the gate pin has path to input
	# Pad net and Report the MOS devices without a proper ESD protection with
	# suitable comment.
	#perc::check_device -type {MN MP} -pinPathType { {g} {Pad && !Power && !Ground} } -comment "MOS gate connected to Pad with less than 300 ohm esd protection"
	#perc::check device -type {MN MP} -pinPathType { {g} {Pad} {s} {!Power && !Ground} } -comment "MOS gate connected to Pad with less than 300 ohm esd protection"
	perc::check_device -type {MN MP} -pinPathType { {g} {Pad} {s} {!Power && !Ground} {d} {!Power && !Ground} } -comment "Error: MOS gate connected to Pad with less than 300 ohm esd protection"
	#perc::check_device -type {MN MP} -pinPathType { {g} {Pad} } -comment "MOS gate connected to Pad with less than 300 ohm esd protection"
	#perc::check device -type {MN MP} -pinPathType { {g} {Power} } -comment "MOS gate connected to Pad with less than 300 ohm esd protection"
	
}

*/]

