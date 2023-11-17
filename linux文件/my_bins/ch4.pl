#!/usr/bin/perl
use strict;
use warnings;

sub find_odds {
    my @numbers = @_;
    my @odds = ();

    for my $num (@numbers) {
        # 跳过 5 和 7
        next if $num == 5 or $num == 7;

        # 如果数字大于 20，则停止查找并返回结果
        last if $num > 20;

        # 如果数字是 11，打印
        if ($num == 11) {
            print "Number is 11\n";
        }

        # 添加奇数到 @odds 数组
        if ($num % 2 != 0) {
            push @odds, $num;
        }
    }

    return @odds;
}

my @nums = (1, 2, 3, 4, 5, 11, 13, 7, 19, 22);
my @result = find_odds(@nums);
print "Odd numbers found: ", join(", ", @result), "\n";