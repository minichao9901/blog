  # Power net set
  perc::define_net_type "HV_power" {VGH VGH_R VGH_L VGL VGL1 VGL2}
  perc::define_net_type "MV_power" {VPP AVDD VSP VSN VDDI VDDI_LDO VDDI_TP VREF VREF_TP VCOM}
  perc::define_net_type "LV_power" {VDD VDD_TP VDD_DRV VDD_DIG SYS_VDD}
  perc::define_type_set "Power"    {HV_power || MV_power || LV_power}
  perc::define_net_type "Ground"   {VSS VSSA VSSD VSSA_M VSSA2 VSSA0}
  perc::define_type_set "Pwr_digital"  {LV_power}
  perc::define_type_set "Pwr_analog"   {HV_power || MV_power}
  # perc::define_type_set "Pwr_all" {Pwr_digital || Pwr_analog}

