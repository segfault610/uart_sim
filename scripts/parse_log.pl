#!/usr/bin/perl
use strict;
use warnings;

my $file = "transcript";
open(my $fh, '<', $file) or die "Cannot open $file";

my $fail = 0;
while(<$fh>) {
    if (/FAIL/) {
        $fail = 1;
    }
}

close($fh);

if ($fail) {
    print "REGRESSION FAILED\n";
} else {
    print "REGRESSION PASSED\n";
}
