#!/usr/bin/perl -w

use strict;

my $inseq = $ARGV[0] || "*.fa";
my $ouseq = $ARGV[1] || "fg.pep.fa";

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


open (OUT, ">$ouseq") or die "Cannot create file $ouseq: $!\n";
foreach my $id (sort keys %seq) {
	print OUT ">$id\n";
	print OUT $seq{$id};
}
close OUT;
