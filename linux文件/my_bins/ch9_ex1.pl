#! /usr/bin/perl
use strict;
use warnings;

# 内置的SPICE网表
my $spice_content = <<'END_SPICE';
.subckt latch_4bit_cb d<3> d<2> d<1> 
+ d<0> le q<3> q<2> q<1> 
+ q<0> rn vh vl
xi0 q<0> vh vl d<0> rn cb dlatchrb_hvt
xi1 q<1> vh vl d<1> rn cb dlatchrb_hvt
xi2 q<2> vh vl d<2> rn cb dlatchrb_hvt
xi3 q<3> vh vl d<3> rn cb dlatchrb_hvt
.ends latch_4bit_cb

.subckt or2_mv y vdd vss a b
xi1 y vdd vss net13 inv_x2_mv
xi0 net13 vdd vss a b nor2_mv
.ends or2_mv

.subckt inv_x2_mv y vdd vss a
m0 y a vss vss nmos_6v w=2e-6 l=600e-9
m1 y a vdd vdd pmos_6v w=5e-6 l=600e-9
.ends inv_x2
END_SPICE

my $sim_cell = "latch_4bit_cb"; # 指定的子电路

&main();
sub main {
    my $port_list_ptr = gen_port_list_spice();
    my @port_list_xinst = @{$port_list_ptr};
    
	print "\n$sim_cell port list:\n";	
    print_array(@port_list_xinst);
	
	print "\nVoltage Sources:\n";
    generate_port_stims(@port_list_xinst);
}

sub gen_port_list_spice {
    # 开始解析SPICE网表
    my $capture = 0; # 用于判断是否在目标子电路中
    my @ports; # 用于存储端口
    my $port_string = ""; # 用于存储可能跨多行的端口字符串

    for my $row (split("\n", $spice_content)) {
        chomp $row;

        # 检查是否是目标子电路开始的行
        if ($row =~ /\.subckt $sim_cell\s+(.*)/) {
            $capture = 1;
            $port_string .= $1; 
        }
        # 如果是在目标子电路中，并且行以+开始，则继续添加端口
        elsif ($capture and $row =~ /^\+\s*(.*)/) {
            $port_string .= " " . $1;
        }
        # 检查是否是子电路结束的行
        elsif ($row =~ /\.ends $sim_cell/) {
            $capture = 0;
            @ports = split(/\s+/, $port_string);
            last; # 结束循环
        }
    }
    
    return \@ports;
}


sub generate_port_stims {
    my @ports = @_;
    for my $port (@ports) {
        my $source = sprintf("V_%-20s%-20s%-20s", $port, $port, "0 dc=dvdd");
        print "$source\n";
    }
}


sub print_array {
    my @list = @_;
    for (@list) {
        print "$_\n";
    }
}
