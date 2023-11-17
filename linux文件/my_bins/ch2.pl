#!/usr/bin/perl
use strict;
use warnings;

# 标量变量
my $name = "Alice";
my $age = 30;

# 数组变量
my @hobbies = ("reading", "hiking", "coding");

# 哈希变量
my %contact_info = (
    "email" => "alice\@example.com",
    "phone" => "123-456-7890",
    "address" => "123 Elm St, Wonderland"
);

# 打印个人信息
print "Name: $name\n";
print "Age: $age\n";
print "Hobbies: ", join(", ", @hobbies), "\n";

# 打印联系信息
print "Contact Info:\n";
foreach my $key (keys %contact_info) {
    print "$key: $contact_info{$key}\n";
}

# 添加一个新的爱好
push @hobbies, "painting";

# 更新联系信息
$contact_info{"email"} = "new_email\@example.com";

# 再次打印个人信息
print "\nUpdated Information:\n";
print "Hobbies: ", join(", ", @hobbies), "\n";
print "Email: $contact_info{'email'}\n";