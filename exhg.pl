#!/usr/bin/env perl 

use strict;
use warnings;

my $infile = $ARGV[0];
my $str = $ARGV[1];

open (IN, "$infile") or die "Cannot open file $infile: $!\n";
while (<IN>) {
	my @w = split /\t/;
	while ($w[7] =~ /\|Gene\_(FGRRES\_\d+)\|/) {
		$w[7] = $';
		print "Chr$w[0]\t$w[1]\t$w[3]\t$w[4]\t$1\n";
	}
}
close IN;
