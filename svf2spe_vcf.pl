#!/usr/bin/perl

use strict;
use warnings;


my @dict = ("PH-1", "YL-1", "HN9-1", "HN-Z6", "GZ3639", "CS3005", "FG1", "FG2");

open (IN, "$ARGV[0]") or die "$!\n";

while (<IN>) {
	chomp;
	choose_spe_var($_);
}

close IN;

sub choose_spe_var {
	my ($str) = ($_);
	my @w = split /\t/;
	my @spe = ();
	for (my $i = 0; $i < 8; $i++) {
		if (is_spe_var($w[$i+2], $str)) {
			print "$dict[$i]\t$w[0]\t$w[1]\t$w[2]\t$w[$i+2]\n";
		}
	}
}

sub is_spe_var {
	my ($query, $str) = @_;
	my @w = split /\t/, $str;
	my %base = ();
	for (my $i = 2; $i <= 9; $i++) {
		if ($w[$i] eq "A") {
			$base{"A"}++;
		} elsif ($w[$i] eq "T") {
			$base{"T"}++;
		} elsif ($w[$i] eq "C") {
			$base{"C"}++;
		} elsif ($w[$i] eq "G") {
			$base{"G"}++;
		} else {
			warn "Non ATCG found: $w[$i] found in $str\n";
		}
	}
	if ($base{$query} == 1) {
		return 1;
	} else {
		return 0;
	}
}
