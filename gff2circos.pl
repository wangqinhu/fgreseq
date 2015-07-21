#!/usr/bin/env perl 

use strict;
use warnings;

my $gff = $ARGV[0] || "data/refseq/FG.RR.27.gff3";
my $ban = $ARGV[1];

open (GFF, "$gff") or die "Cannot open file $gff: $!\n";
open (OUT, ">$ban") or die "Cannot open file $ban: $!\n";
while (<GFF>) {
	next if /^#/;
	my @w = split /\t/;
	if ($w[2] eq "transcript") {
		print OUT "Chr$w[0]\t$w[3]\t$w[4]\t1\n";
	}
}
close GFF;
close OUT;
