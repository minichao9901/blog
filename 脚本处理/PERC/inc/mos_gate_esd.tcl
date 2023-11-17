
TVF FUNCTION mos_gate_esd_checks [/*

package require CalibreLVS_PERC

proc mos_gate_esd_init {}{
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	# Create net path through resistor less than 100 ohm.
	perc::create_net_path -type {R} -pin {p n} -property "r < 300"
}
proc lvng_esd_rulel {} {
	# Identify all NMOS devices in design,Check whether gate pins are connected
	# to Power nets(Direct/Indirect) and Report the MOS devices without a proper
	# ESD protection with suitable comment.
	perc::check_device -type {MN} -subtype {nmos nmos_hvt* nmos_lvt*} -pinPathType { {g} {Power} {s d b} {Ground} } -comment "Error: LV NMOS s/d/b connected to Ground and gate connected to power with less than 300 ohm esa protection"
}
proc lvng_esd_rule2 {} {
	# Identify all NMOS devices in design,Check whether gate pins are connected
	# to Power nets(Direct/Indirect) and Report the MOS devices without a proper
	# ESD protection with suitable comment.
	perc::check_device -type {MN} -subtype {nmos nmos_hvt* nmos_lvt*} -pinPathType { {g} {Ground} {s d} {Power} } -comment "Error: LV NMOS s/d connected to power and gate connected to Ground with less than 300 ohm esd protection"
}
proc lvpg_esd_rulel {} {
	# Identify all PMOS devices in design, Check whether gate pins are connected
	# to Ground nets (Direct/Indirect) and Report the MOS devices without a proper
	# ESD protection with suitable comment.
	perc::check_device -type {MP} -subtype {pmos pmos_hvt* pmos_lvt*} -pinPathType { {g} {Ground} {s d b} {Power} } -comment "Error:LV PMOS s/d/b connected to Power and gate connected to vss with less than 300 Ohm esd protection"
}
proc lvpg_esd_rule2 {} {
	# Identify all PMOS devices in design, Check whether gate pins are connected
	# to Ground nets (Direct/Indirect) and Report the MOS devices without a proper
	# ESD protection with suitable comment.
	perc::check_device -type {MP} -subtype {pmos pmos_hvt* pmos_lvt=} -pinPathType { {g} {Power} {s d} {Ground} } -comment "Error:LV PMOS s/d connected to Ground and gate connected to Power with less than 300 Ohm esd protection"
}

*/]
