#!/usr/bin/env perl 

use strict;
use warnings;

my $gff = $ARGV[0] || "FG.RR.27.gff3";

# parse gff
my %exon = ();
my $id = undef;
my $discard = undef;
open (GFF, "$gff") or die "Cannot open file $gff: $!\n";
while (<GFF>) {
	next if /^#/;
	my @w = split /\t/;
	if ($w[2] eq "gene") {
		($id, $discard) = split /\;/, $w[8], 2;
		$id =~ s/ID\=gene\://;
		$exon{$id} = 1;
	} elsif ($w[2] eq "exon") {
		$exon{$id}++;
	} else {
		if ($w[2] =~ /RNA/) {
			$exon{$id} = 0;
		}
	}
}
close GFF;

# output
foreach my $id (sort keys %exon) {
	print $id, "\t",$exon{$id}, "\n";
}
