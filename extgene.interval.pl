#!/usr/bin/env perl 
#
# Extracting genes in the fast and slow sub-genomes
#
# Usage:
# ./extgene.interval.pl gff_file state.tsv list_prefix
#

use strict;
use warnings;

my $gff = $ARGV[0] || "data/refseq/FG.RR.27.gff3";
my $state = $ARGV[1] || "data/2speed/state.tsv";
my $list = $ARGV[2] || "list";
my $window = 25000;

my %state = ();
my $pos = undef;
open (STATE, "$state") or die "Cannot open file $state: $!\n";
while (<STATE>) {
	chomp;
	my @w = split /\s+/;
	$pos = $w[1] . "-" . $w[2];
	$state{$w[0]}{$pos} = $w[3];
}

my $chr = undef;
my $id = undef;
my $start = undef;
my $end = undef;
open (GFF, "$gff") or die "Cannot open file $gff: $!\n";
open (ID1, ">data/2speed/$list.fast") or die "Cannot open file $list.fast: $!\n";
open (ID2, ">data/2speed/$list.slow") or die "Cannot open file $list.slow: $!\n";
while (<GFF>) {
	next if /^#/;
	my @w = split /\t/;
	if ($w[2] eq "gene") {
		my ($id, $discard) = split /\;/, $w[8], 2;
		next unless $discard =~/biotype\=protein_coding/;
		$id =~ s/ID\=gene\://;
		if ($w[6] eq "+") {
			$start = int($w[3] / $window) * $window + 1;
		} elsif ($w[6] eq "-") {
			$start = int($w[4] / $window) * $window + 1;
		} else {
			die "Stopped: unknown strand found in $_!\n";
		}
		$end = $start + $window - 1;
		$chr = "Chr" . $w[0];
		$pos = $start . "-" . $end;
		if (exists $state{$chr}{$pos}) {
			if ($state{$chr}{$pos} eq "1") {
				print ID1 "$id\n";
			} else {
				print ID2 "$id\n";
			}
		}
	}
}
close GFF;
close ID1;
close ID2;

