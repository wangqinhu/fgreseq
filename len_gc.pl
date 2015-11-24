#!/usr/bin/perl

use warnings;
use strict;

my $inseq = $ARGV[0] || "*.fa";

my %seq = ();
my $sid = ();
open (IN, $inseq) or die "Cannot open file $inseq: $!\n";;
while (<IN>) {
	if (/^\>[\S\s]+gene\:(\S+)\s/) {
		$sid = $1;
	} else {
		$seq{$sid} .= uc $_;
	}
}
close IN;


foreach my $id (sort keys %seq) {
	$seq{$id} =~ s/\s//g;
	my $len= length($seq{$id});
	my $gc = $seq{$id} =~ tr/GC/GC/;
	print $id, "\t", $len, "\t", $gc/$len * 100, "\n";
}
