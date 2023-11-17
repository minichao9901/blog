
TVF FUNCTION eos_checks [/*
package require CalibreLVS_PERC

set LV_Vmax 1.35
set LV_Vmin [expr -1*$LV_Vmax]
set MV_Vmax 6
set MV_Vmin [expr -1*$MV_Vmax]

proc eos_init {}
	# Define Voltages on supply ports.
	define_net_voltage_by_file /project/AXS15260_ANF/sch/cds/xujch/perc/voltages.txt
	INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl
	# Define voltage propagations rules.
	# perc:create_voltage_path -type {MN MP} -pin {s d} -break {Power || Ground}
	perc:create_voltage_path -type {MN MP} -pin {s d} -condition cond_gb_connect -break {Power || Ground}
	perc::create_voltage_path -type {R} -pin {p n}
}

proc cond_gb_connect {dev} {
	set gnet [perc::get_nets $dev -name G ]
	set bnet [perc:get_nets $dev -name B ]
	if { ![string equal $gnet $bnet] } {
		return 1
	}
	return 0
}


proc lv_eos_rule {} {
	# Identify all the LV-MOS devices.
	perc:check_device -type {MN MP} -subtype {nmos nmos_hvt nmos_lvt nmos_lvt_mis nmos_hvt_mis pmos pmos_hvt pmos_lvt pmos_lvt_mis pmos_hvt_mis} -condition cond_lv_mos_eos -comment "Error:LV MoS over-voltage stress!"
}

proc cond_lv_mos_eos {dev} {
	global LV_Vmax
	global LV_Vmin

	# Find the max propagated voltage to the gate pin and the min propagated
	# voltage to the source pin.
	set d_max [perc:voltage_max $dev d]
	set g_max [perc:voltage_max $dev g]
	set s_max [perc:voltage_max $dev s]
	set b_max [perc:voltage_max $dev b]

	set d_min [perc:voltage_min $dev d]
	set g_min [perc:voltage_min $dev g]
	set s_min [perc:voltage_min $dev s]
	set b_min [perc:voltage_min $dev b]

	# Compute the difference,compare versus breakdown voltage and report violations.
	# Check Vgs EOS
	if { ($g_max ne "") && ($s_min ne "") } {
		set max_diff [expr "$g_max-$s_min"]
		if { $max_diff > $LV_Vmax } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to gate and source is [expr $max_diff]V\
			which is greater than the limit ([expr $LV_Vmax]V)"
			return  1
		}
	}
	if { ($g_min ne "") && ($s_max ne "") } {
		set max_diff [expr "$g_min - $s_max"]
		if {$max_diff < $LV_Vmin } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to gate and source is [expr $max_diff]V\
			which is less than the limit ([expr SLV_Vmin]V)"
			return  1
		}
	}
	
	#Check Vgd EOS
	if { ($g_max ne "") && ($d_min ne "") } {
		set max_diff [expr "$g_max-$d_min"]
		if { $max_diff > $LV_Vmax } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to gate and drain is [expr $max_diff]V\
			which is greater than the limit ([expr $LV_Vmax]V)"
			return  1
		}
	}
	if { ($g_min ne "") && ($d_max ne "") } {
		set max_diff [expr "$g_min - $d_max"]
		if {$max_diff < $LV_Vmin } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to gate and drain is [expr $max_diff]V\
			which is less than the limit ([expr SLV_Vmin]V)"
			return  1
		}
	}
	
	#Check Vds EOS
	if { ($d_max ne "") && ($s_min ne "") } {
		set max_diff [expr "$d_max-$s_min"]
		if { $max_diff > $LV_Vmax } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to drain and source is [expr $max_diff]V\
			which is greater than the limit ([expr $LV_Vmax]V)"
			return  1
		}
	}
	if { ($d_min ne "") && ($s_max ne "") } {
		set max_diff [expr "$d_min - $s_max"]
		if {$max_diff < $LV_Vmin } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to drain and source is [expr $max_diff]V\
			which is less than the limit ([expr $LV_Vmin]V)"
			return  1
		}
	}
	
	#Check Vgb EOS
	if { ($g_max ne "") && ($b_min ne "") } {
		set max_diff [expr "$g_max-$b_min"]
		if { $max_diff > $LV_Vmax } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to gate and bulk is [expr $max_diff]V\
			which is greater than the limit ([expr $LV_Vmax]V)"
			return  1
		}
	}
	if { ($g_min ne "") && ($b_max ne "") } {
		set max_diff [expr "$g_min - $b_max"]
		if {$max_diff < $LV_Vmin } {
			perc:report_base_result -value "Over-voltage condition on this device.\
			\n Difference between propagated voltages to gate and bulk is [expr $max_diff]V\
			which is less than the limit ([expr SLV_Vmin]V)"
			return  1
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




