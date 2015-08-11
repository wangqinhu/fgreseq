#!/usr/bin/env perl 

use strict;
use warnings;

my $fasta = $ARGV[0];
my $gc = $ARGV[1];
my $step = $ARGV[2] || "25000";

#-------------------------------------------------------------------------------
#  Load karyotype
#-------------------------------------------------------------------------------
my $chr_id = undef;
my %chr_seq = ();

open (SEQ, "$fasta") or die "Cannot open file $fasta: $!\n";
while (<SEQ>) {
	chomp;
	if (/^\>(\S+)/) {
		$chr_id = $1;
	} else {
		s/\s//g;
		$chr_seq{$chr_id} .= $_;
	}
}
close SEQ;

#-------------------------------------------------------------------------------
#  Write GC density file
#-------------------------------------------------------------------------------
open (GC, ">$gc") or die "Cannot open file $gc: $!\n";
foreach my $chr_id (sort keys %chr_seq) {
	my $chr_len = length $chr_seq{$chr_id};
	for (my $start = 1; $start <= $chr_len; $start += $step ) {
		my $end = $start + $step - 1;
		my $seq = substr($chr_seq{$chr_id}, $start - 1, $step);
		my $gc = gc_content($seq);
		print GC "Chr$chr_id\t$start\t$end\t$gc\n";
	}
}
close GC;

sub gc_content {

	my ($seq) = @_;
	my $nt = uc($seq);
	my $gc = ($nt =~ tr/GC/gc/);
	$gc = $gc / length($seq) * 100;
	return $gc;

}
