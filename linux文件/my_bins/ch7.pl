#!/usr/bin/perl
use strict;
use warnings;

my $log = <<'END';
[2023-08-23 10:45:12] 192.168.1.1 - GET /home 200
[2023-08-23 10:46:15] 192.168.1.2 - POST /login 401
[2023-08-23 10:47:17] 192.168.1.3 - GET /dashboard 404
[2023-08-23 10:48:19] 192.168.1.4 - GET /profile 200
[2023-08-23 10:49:20] 192.168.1.5 - PUT /update 404
END

while ($log =~ /\[(.*?)\] (\d+\.\d+\.\d+\.\d+) - (\w+) (\/\w+) (\d+)/g) {
    my ($timestamp, $ip, $method, $endpoint, $status) = ($1, $2, $3, $4, $5);
    
    if ($status == 404) {
        print "Error 404 detected from IP $ip on endpoint $endpoint at $timestamp\n";
    }
}