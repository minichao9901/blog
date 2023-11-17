#!/usr/bin/perl
use strict;
use warnings;

# 1. 读取文件内容
open(my $in_fh, '<', 'input.txt') or die "Could not open file 'input.txt' $!";
my @items;

while (my $line = <$in_fh>) {
    chomp $line;
    my ($item, $price) = split(',', $line);
    push @items, {item => $item, price => $price};
}
close $in_fh;

# 2. 计算总价
foreach my $record (@items) {
    $record->{total} = $record->{price} * 5;  # 假设数量为5
}

# 3. 写入格式化的结果到 output.txt
open(my $out_fh, '>', 'output.txt') or die "Could not open file 'output.txt' $!";
printf $out_fh "%-10s | %6s | %6s\n", "Item", "Price", "Total";
print $out_fh "-" x 30 . "\n";

foreach my $record (@items) {
    printf $out_fh "%-10s | $%6.2f | $%6.2f\n", $record->{item}, $record->{price}, $record->{total};
}
close $out_fh;

print "Processing complete. Check 'output.txt' for formatted results.\n";