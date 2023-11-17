/*
PERC check rules
*/

SOURCE PATH src.net
SOURCE PRIMARY "top"
SOURCE SYSTEM SPICE

PERC NETLIST SOURCE
PERC REPORT "perc.rep"
PERC REPORT MAXIMUM ALL
//PERC REPORT OPTION all_net_type

MASK SVDB DIRECTORY "svdb" QUERY

#PRAGMA ENV PERC_RULEDIR /project/AXS15260_ANF/sch/cds/xujch/perc
INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/ls_cell.tcl
PERC PROPERTY R r

PERC LOAD eos_checks INIT eos_init SELECT lv_eos_rule
PERC LOAD ls_checks INIT ls_init SELECT lv2mv_ls_rule
PERC LOAD lsv_checks INIT lsv_init SELECT lsv_lv2mv_pmos_rule lsv_lv2mv_nmos_rule
PERC LOAD nmos_sub_checks INIT nmos_sub_init SELECT nmos_sub_rule
PERC LOAD pnos_sub_checks INIT pmos_sub_init SELECT pmos_sub_rule
PERC LOAD input_float_checks INIT input_float_init SELECT input_float_rule
PERC LOAD mos_gate_esd_checks INIT mos_gate_esd_init SELECT lvng_esd_rulel lvng_esd_rule2 lvpg_esd_rulel lvpg_esd_rule2
PERC LOAD pad_in_gate_res INIT pad_in_gate_res_init SELECT pad_in_gate_res_rule

INCLUDE /project/AX515260_ANF/sch/cds/xujch/perc/inc/eos_perc.tcl
INCLUDE /project/AXS15260 ANF/sch/cds/xujch/perc/inc/ls_perc.tcl
INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/inc/lsv_perc.tcl
TNCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/inc/nmos_sub.tcl
INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/inc/pmos_sub.tcl
INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/inc/input_float.tcl
INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/inc/mos_gate_esd.tcl
INCLUDE /project/AXS15260_ANF/sch/cds/xujch/perc/inc/pad_in_gate_res.tcl
