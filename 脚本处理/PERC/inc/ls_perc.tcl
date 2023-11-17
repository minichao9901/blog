
//VARIABLE lv2mv_ls_cells "gamma_lsn2 gamma_lsp2 ls_afe ls_gip ls_adc ls_0v_n5v"
//VARIABLE mv2lv_ls_cells "lsm2l lsmtl"

TVF FUNCTION ls_checks [/*

package require CalibreLVS_PERC

proc ls_init {} {
  # Define Voltages on supply ports.
  INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/power_net.tcl

  # Create path through MOS S/D pins and resistors.
  # perc::create_lvs_path  -break {Power || Ground}
  # Another method to create path through MOS S/D pins and resistors.
   perc::create_net_path -type {MN MP} -pin {s d} -condition cond_gb_connect -break {Pwr_digital || Pwr_analog || Ground}
   perc::create_net_path -type {R} -pin {p n}
   perc::create_net_path -type {D} -pin {p n}
   perc::create_net_path -type {Q} -pin {c e b}
}

proc cond_gb_connect {dev} {
	set gnet [perc::get_nets $dev -name G ]
	set bnet [perc:get_nets $dev -name B ]
	if { ![string equal $gnet $bnet] } {
		return 1
	}
	return 0
}

proc lv2mv_ls_rule {} {
  # Identify all MOS devices in design.
  # perc::check_device  -type  {MN MP} -condition cond_lv2mv -comment "Error: Missing LV-to-MV level shifter"
  perc::check_device  -type  {MN MP} -subtype {! nmos nmos_lvt nmos_hvt pmos pmos_lvt pmos_hvt } -condition cond_lv2mv -comment "Error: Missing LV-to-MV level shifter"
}

proc mv2lv_ls_rule {} {
  # Identify all MOS devices in design.
  perc::check_device  -type  {MN MP} -condition cond_mv2lv -comment "Missing MV-to-LV level shifter"
}

proc cond_lv2mv {dev} {
  # Verify that MOS pins connected to different domains are inside
  # level shifter cells only.
  set gnet [perc::get_nets $dev -name G ]
  set bnet [perc::get_nets $dev -name B ]
  set dnet [perc::get_nets $dev -name D ]
  set snet [perc::get_nets $dev -name S ]
  if { [string equal $gnet $bnet] } {
  	return 0
  } elseif { [string equal $dnet $snet] } {
  	return 0
  }

  if { [perc::is_pin_of_path_type $dev {s d} Pwr_analog] && ([perc::is_pin_of_path_type $dev g Pwr_digital] && (![perc::is_pin_of_path_type $dev g Pwr_analog])) } {
    # Make sure the devices with pins connected to different power domains
    # are within level shifter cells.
    set cell [perc::name [perc::get_placements $dev]]
    # lnet is the local net in the subckt
    set lnet [perc::name [perc::get_nets $dev -name G ]]
    set lv2mv_ls_cells [tvf::svrf_var lv2mv_ls_cells]
    if { [lsearch $lv2mv_ls_cells $cell] < 0 } {
    # Report the violating MOS devices with suitable comment.
      perc::report_base_result -value "[perc::name $dev] tied at $cell/$lnet needs adding a LV-to-MV level shifter."
      return 1
    } elseif { ($lnet eq "RB") || ($lnet eq "SB") || ($lnet eq "EN")|| ($lnet eq "DSTB")|| ($lnet eq "POC")|| ($lnet eq "POCN") } {
      perc::report_base_result -value "[perc::name $dev] tied at $cell/$lnet needs adding a LV-to-MV level shifter."
      return 1
    }
  }
  return 0
}

proc cond_mv2lv {dev} {
  # Verify that MOS pins connected to different domains are inside
  # level shifter cells only.
  if { [perc::is_pin_of_path_type $dev {s d} Pwr_digital] && [perc::is_pin_of_path_type $dev g Pwr_analog] } {
    # Make sure the devices with pins connected to different power domains
    # are within level shifter cells.
    set cell [perc::name [perc::get_placements $dev]]
    set mv2lv_ls_cells [tvf::svrf_var mv2lv_ls_cells]
    if { [lsearch $mv2lv_ls_cells $cell] < 0 } {
      # Report the violating MOS devices with suitable comment.
      perc::report_base_result -value "[perc::name $dev] is not a part of a MV-to-LV level shifter"
      return 1
    }
  }
  return 0
}

*/]

