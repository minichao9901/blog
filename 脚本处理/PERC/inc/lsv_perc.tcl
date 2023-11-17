
TVF FUNCTION lsv_checks [/*

package require calibreLVS_PERC

set LV_Vmax 1.35
set LV_Vmin [expr -1*$LV_Vmax]
set MV_Vmax 6
set MV_Vmin [expr -1*$MV_Vmax]
set LS_Vth 0.2

proc lsv_init {} {
	# Define Voltages on supply ports.
	define_net_voltage_by_file /project/AXS15260_ANF/sch/cds/xujch/perc/voltages.txt
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	# Define voltage propagations rules.
	#perc::create_voltage_path -type {MN MP} -pin {s d} -break {Power || Ground}
	#perc::create_voltage_path -type {MN MP} -subtype {nmos nmos_hvt* nmos_lvt* pmos pmos_hvt* pmos_lvt*} -pin {s d} -condition cond_gb_connect -break {Power || Ground}
	perc::create_voltage_path -type {MN MP} -pin {s d} -condition cond_gb_connect -break {Power || Ground}
	perc::create_voltage_path -type {R} -pin {p n}
}
proc cond_gb_connect {dev} {
	set gnet [perc::get_nets $dev -name G]
	set bnet [perc::get_nets $dev -name B]
	if { ![string equal $gnet $bnet] } {
		return 1
	}
	return 0
}

proc lsv_lv2mv_pmos_rule {} {
	# Identify all the LV-MOS devices.
	perc::check_device -type {MP} -condition cond_lsv_pmos -comment "Error: PMOS gate missing Vlow-to-Vhigh level shifter!"
}

proc lsv_lv2mv_nmos_rule {} {
	# Identify all the LV-MOS devices.
	perc::check_device -type {MN} -condition cond_lsv_nmos -comment "Error:NMOS gate missing Vlow-to-Vhigh level shifter!"

}

proc cond_lsv_pmos {dev} {
	global LS_Vth
	
	# Find the max propagated voltage to the gate pin and the min propagated
	# voltage to the source pin.
	set d_max [perc::voltage_max $dev d]
	set g_max [perc::voltage_max $dev g]
	set s_max [perc::voltage_max $dev s]
	set b_max [perc::voltage max $dev b]
	
	set d_min [perc::voltage_min $dev d]
	set g_min [perc::voltage_min $dev g]
	set s_min [perc::voltage_min $dev s]
	set b_min [perc::voltage_min $dev b]
	
	set gnet [perc::get_nets $dev -name G ]
	set bnet [perc::get_nets $dev -name B ]
	if { [string equal $gnet $bnet] } {
		return 0
	}
	
	if { ($g_min ne "") && ($s_min ne "") && ($d_min ne "") && ($g_min < $b_max) && ($g_max > $g_min) } {
		if { $s_min < $d_min } {
			set ds_bot [expr "$s_min + $LS_Vth"]
		}else{
			set ds_bot [expr "$d_min + $LS_Vth"]
		}
		
		if { $g_min > $ds_bot } {
			# Make sure the devices with pins connected to different power domains
			# are within level shifter cells.
			set cell [perc::name [perc::get_placements $dev]]
			# lnet is the local net in the subckt
			set lnet [perc::name [perc::get_nets $dev -name G ]]
			set lv2mv_ls_cells [tvf::svrf_var lv2mv_ls_cells]
			if { [lsearch $lv2mv_ls_cells $cell] < 0 }{
				# Report the violating MOS devices with suitable comment.
				perc::report_base_result -value "[perc::name $dev] tied at $cell/$lnet needs adding a Vlow-to-Vhigh level shifter."
				return 1
			} 
			elseif { ($lnet eq "RB") || ($lnet eq "SB") || ($lnet eq "DSTB") || ($lnet eq "DSTB_N") || ($lnet eq "DSTB_MV") || ($lnet eq "POC") || ($lnet eq "POC_NV") || ($lnet eq "Poc_PV") || ($lnet eq "POC_WV") } {
				perc::report_base_result -value "[perc::name $dev] tied at $cell/$lnet needs adding a Vlow-to-Vhigh level shifter."
				return 1
			}
  		}
 	}
	return 0
}
	

proc cond_lsv_nmos {dev} {
	global LS_Vth
	
	#Find the max propagated voltage to the gate pin and the min propagated
	# voltage to the source pin.
	set d_max [perc::voltage_max $dev d]
	set g_max [perc::voltage_max $dev g]
	set s_max [perc::voltage_max $dev s]
	set b_max [perc::voltage max $dev b]
	
	set d_min [perc::voltage_min $dev d]
	set g_min [perc::voltage_min $dev g]
	set s_min [perc::voltage_min $dev s]
	set b_min [perc::voltage_min $dev b]
	
	set gnet [perc::get nets $dev -name G ]
	set bnet [perc::get nets $dev -name B ]
	if { [string equal $gnet $bnet] } {
		return 0
	}
	
	if { ($g_max ne "") && ($s_max ne "") && ($d_max ne "") && ($g_max > $b_min) && ($g_max > $g_min) } {
		if { $s_max > $d_max } {
			set ds_top [expr "$s_max - $LS_Vth"]
		}else{
			set ds_top [expr "$d_max - $LS_Vth"]
		}
		
		if { $g_max < $ds_top }{
			# Make sure the devices with pins connected to different power domains
			# are within level shifter cells.
			set cell [perc::name [perc::get_placements $dev]]
			# lnet is the local net in the subckt
			set lnet [perc::name [perc::get_nets $dev -name G ]]
			set lv2mv_ls_cells [tvf::svrf_var lv2mv_ls_cells]
			if { [lsearch $lv2mv_ls_cells $cell] < 0 }{
				# Report the violating MOS devices with suitable comment.
				perc::report_base_result -value "[perc::name $dev] tied at $cell/$lnet needs adding a Vlow-to-Vhigh level shifter."
				return 1
			} 
			elseif { ($lnet eq "RB") || ($lnet eq "SB") || ($lnet eq "DSTB") || ($lnet eq "DSTB_N") || ($lnet eq "DSTB_MV") || ($lnet eq "POC") || ($lnet eq "POC_NV") || ($lnet eq "Poc_PV") || ($lnet eq "POC_WV") } {
				perc::report_base_result -value "[perc::name $dev] tied at $cell/$lnet needs adding a Vlow-to-Vhigh level shifter."
				return 1
			}
  		}
 	}
	return 0
}

#==============Util==============
proc define_net_voltage_by_file { file_name } { 
	set voltage_type_list {}
	set voltage_set {}
	set fn [open $file_name r]
	while {[gets $fn line]>=0 } {
		if{ [string trim $line] == {} } continue
 		lappend [lindex $line 1] [lindex $line 0]
		if{[lsearch $voltage_type_list [lindex $line 1]] <0 } {
 			lappend voltage_type_list [lindex $line 1]
		}
	}
	close $fn
		
 	foreach {voltage_type} $voltage_type_list {
		puts "perc:define_net_voltage \"${voltage_type}\" [subst \${${voltage_type}}]"
		perc:define_net_voltage "${voltage_type}" [subst \${${voltage_type}}]
	}
}

*/]

	
