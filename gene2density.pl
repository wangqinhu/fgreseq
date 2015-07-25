#!/usr/bin/env perl 

use strict;
use warnings;

my $gene = $ARGV[0];
my $density = $ARGV[1];
my $step = $ARGV[2] || "25000";
my $karyotype = $ARGV[3] || "data/karyotype/FG.karyotype.txt";

#-------------------------------------------------------------------------------
#  Load karyotype
#-------------------------------------------------------------------------------
my @chr = ();
my %chr_size = ();

open (KAR, "$karyotype") or die "Cannot open file $karyotype: $!\n";
while (<KAR>) {
	next unless /\S+/;
	my @w = split /\s+/;
	push @chr, "Chr" . $w[3];
	$chr_size{"Chr" . $w[3]} = $w[5]; 
}
close KAR;

#-------------------------------------------------------------------------------
#  Load gene location file
#-------------------------------------------------------------------------------
my %hold = ();

open (GLF, "$gene") or die "Cannot open file $gene: $!\n";
while (<GLF>) {
	my @w = split /\t/;
	my $chr = $w[0];
	my $pos = int(($w[1] + $w[2]) / 2);
	$hold{$chr}{$pos} = 1;
}
close GLF;

#-------------------------------------------------------------------------------
#  Caculate density
#-------------------------------------------------------------------------------
my %density = ();
my $j = 0;
my $start = 0;

foreach my $chr (@chr) {
	for (my $i = 1; $i <= $chr_size{$chr}; $i++) {
		if (exists $hold{$chr}{$i}) {
			$j = int ($i / $step);
			$start = $j * $step + 1;
			$density{$chr}{$start}++;
		}
	}
}

#-------------------------------------------------------------------------------
#  Write density file
#-------------------------------------------------------------------------------
open (DEN, ">$density") or die "Cannot open file $density: $!\n";
foreach my $chr (@chr) {
	for (my $start = 1; $start <= $chr_size{$chr}; $start += $step ) {
		my $end = $start + $step - 1;
		if (exists $density{$chr}{$start}) {
			print DEN "$chr\t$start\t$end\t$density{$chr}{$start}\n";
		} else {
			print DEN "$chr\t$start\t$end\t0\n";
		}
	}
}
close DEN;
