#!/usr/bin/perl


use strict;
use warnings;


# 示例网表内容
my $dspf_netlist = <<'END';
*|NET AA 7e-15
cc_1 AA BB 2e-15
cc_3 AA CC 1e-15
cc_2 AA
+DD 4e-15


*|NET BB 7e-15
cc_23 BB CC 1e-15
cc_24 BB DD
+4e-15
cc_23
+BB CC 1e-15


*|NET CC 9e-15
cc_25
+CC DD 4e-15
cc_26 CC
+EE 3e-15


*|NET xA/xB/EE<0> 12e-15
cc_27 xA/xB/EE<0> EE<1> 4e-15
cc_28 xA/xB/EE<0> F 4e-15
cc_29 xA/xB/EE<0> EE<2> 3e-15
cc_30 xA/xB/EE<0> G 4e-15


m_25 CC DD 4e-15
x_26 CC
+EE 3e-15
END

# 定义用于存储网络名和其对应的电容值的哈希
my %nets;
# 定义用于存储每个节点及其关联的电容的哈希
my %capacitors;

# 处理断行连接的内容，将换行符后的'+'替换为空格，将多行内容合并为一行
$dspf_netlist =~ s/\n\+/ /g;

# 遍历每一行来解析数据
for my $line (split /\n/, $dspf_netlist) {
    # 匹配网络定义行，提取网络名和对应的电容值
    if ($line =~ /\*\|NET (\S+)\s+(\S+)/) {
        my ($net, $value) = ($1, $2);
        $nets{$net} = $value;
    } 
    # 匹配电容定义行，提取电容名、两个节点和电容值
    elsif ($line =~ /^(cc_\w+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
        my ($cap_name, $node1, $node2, $value) = ($1, $2, $3, $4);
        $value =~ s/f/e-15/; # 将 'f' 替换为 'e-15'
        # 将电容信息存储到两个节点的数组中
        push @{$capacitors{$node1}}, { name => $cap_name, node1 => $node1, node2 => $node2, value => $value };
        push @{$capacitors{$node2}}, { name => $cap_name, node1 => $node2, node2 => $node1, value => $value };
    }
}

# 按要求的格式打印输出
# 按电容值从大到小的顺序排序网络
for my $net (sort { $nets{$b} <=> $nets{$a} } keys %nets) {
    print "*|NET $net $nets{$net}\n";
    if (exists $capacitors{$net}) {
        # 按电容值从大到小排序电容
        my @sorted_capacitors = sort { $b->{value} <=> $a->{value} } @{$capacitors{$net}};
        my %printed_capacitors; # 用于跟踪已打印的电容
        for my $cap (@sorted_capacitors) {
            # 跳过已经打印的电容
            next if $printed_capacitors{$cap->{name}};
            print "$cap->{name} $cap->{node1} $cap->{node2} $cap->{value}\n";
            $printed_capacitors{$cap->{name}} = 1; # 标记电容为已打印
        }
    }
    print "\n";
}

# 指定查询的网络和排除模式
my @nets_to_query=qw(AA CC xA/xB/EE<0>);
my $exclude_pattern="EE*";

# 根据指定的网络和排除模式计算电容总和
for my $net (@nets_to_query) {
    my $total_capacitance = 0;
    if (exists $capacitors{$net}) {
        for my $cap (@{$capacitors{$net}}) {
            # 只排除匹配指定模式的node2
            next if defined $exclude_pattern && $cap->{node2} =~ /$exclude_pattern/;
            $total_capacitance += $cap->{value};
        }
    }
    $total_capacitance =~ s/e-15/f/; # 将 'e-15' 替换为 'f'
    print "$net => $total_capacitance\n";
}