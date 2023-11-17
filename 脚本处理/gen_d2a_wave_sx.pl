#! /usr/bin/perl

$path="/homelocal/xujch/hspice_sim/AXS15231/cosim_top_sim/cosim/AXS15231_ANF/sim1/output/fsdb/com_analog.fsdb";
$wave="tb/u0_dut/xp1_20da/xdig";

#*******************************************************************************
$str_head=qq{
### Custom WaveView session file (version M-2017.03-SP1 build May 20,)###
wdf 0 "$path" load=used
scalar list
};
$str_tail="browserOpened\n";

#*******************************************************************************
$bgr_porlvd_osc=qq{
BGR_CORE1_TRIM_DTA<4:0>
BGR_CORE1_NPN_SEL_DTA
BGR_CORE2_EN_DTA
};

$ldo=qq{
};

$rfck_esdet=qq{
};

$source=qq{
};

$datashift=qq{
};

$gamma=qq{
};

$vgh_vgl=qq{
};

$vsp_vsn=qq{
};

$gip=qq{
};

$vref_tp=qq{
};

$afe=qq{
};

$mipi=qq{
};

$ioesd=qq{
};

$otp=qq{
};

$vcom=qq{
};

&main();
sub main
{
	my $str;
	$str=$str_head;
	$str.=&gen_str_one($bgr_porlvd_osc, "bgr_porlvd_osc");
	$str.=&gen_str_one($ldo,			"ldo");
	$str.=&gen_str_one($vsp_vsn,		"vsp_vsn");
	$str.=&gen_str_one($vgh_vgl,		"vgh_vgl");
	$str.=&gen_str_one($gip,			"gip");
	$str.=&gen_str_one($source,			"source");
	$str.=&gen_str_one($gamma,			"gamma");
	$str.=&gen_str_one($datashift,		"datashift");
	$str.=&gen_str_one($vcom,			"vcom");
	$str.=&gen_str_one($vref_tp,		"vref_tp");
	$str.=&gen_str_one($afe,			"afe");
	$str.=&gen_str_one($mipi,			"mipi");
	$str.=&gen_str_one($rfck_esdet,		"rfck_esdet");
	$str.=&gen_str_one($ioesd,			"ioesd");
	$str.=&gen_str_one($otp,			"otp");
	$str.=$str_tail;

	open $fho, ">cosim_tc.sx";
	print $fho $str;
	close $fho;

	$str=~s/\//./g;
	$str=lc($str);
	open $fho, ">cosim_tc_alg.sx";
	print $fho $str;
}

sub gen_str_one
{
	$cir_name=shift;
	$cir_name_str=shift;
	my @tmp_names=split /\s+/, $cir_name;
	@port_names=grep /\S+/, @tmp_names;
	my $str=qq{waveview begin 2 stack offset=0 name_b=729 mntr_b=799 name_width=714 mcur=1.89299859396226e-02 vc=cur-pnl "name=$cir_name_str"};
	for (@port_names){
		$_=~s/</[/g;
		$_=~s/>/]/g;
		$str.=qq{
  panel_begin digital pidx=0 spath=name+file marker=on xlabel="sec" radix=bin
	line src=wdf lidx=0 fidx=0 "delim=/" sigtype=20 "name=$wave/$_" disp=show
  panel_end
};
	}
	$str.="waveview end\n";
	return $str;
}

