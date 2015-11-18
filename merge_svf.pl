#!/usr/bin/perl

use strict;
use warnings;

my $svf1 = $ARGV[0]; # source
my $svf2 = $ARGV[1]; # added

my %pos = ();

# judge rank
my $head = `head -1 $svf1`;
my @item = split /\t/, $head;
my $rank = @item - 2;

# read file 1
my %svf1 = ();
open (SVF1, $svf1) or die "$!\n";
while (<SVF1>) {
	chomp;
	my @w = split /\t/, $_, 3;
	# keep first snp
	$w[2] =~ s/\,\S+//;
	$svf1{$w[0]}{$w[1]} = $w[2];
	$pos{$w[0]}{$w[1]} = 1;
}
close SVF1;


# read file 2
my %svf2 = ();
open (SVF2, $svf2) or die "$!\n";
while (<SVF2>) {
	chomp;
	my @w = split /\t/, $_, 3;
	# keep first snp
	$w[2] =~ s/\,\S+//;
	$svf2{$w[0]}{$w[1]} = $w[2];
	$pos{$w[0]}{$w[1]} = 1;
}
close SVF2;

# output
foreach my $chr (sort keys %pos) {
	foreach my $num (sort by_num keys $pos{$chr}) {
		print $chr, "\t", $num;
		# if both exist, print 1.full + 2.last
		if ((exists $svf1{$chr}{$num}) && (exists $svf2{$chr}{$num})) {
			my @snp2 = split /\t/, $svf2{$chr}{$num};
			print "\t$svf1{$chr}{$num}\t$snp2[-1]";
		# if only 1 exists, print 1.full + 1.reference
		} elsif (exists $svf1{$chr}{$num}) {
			my @snp1 = split /\t/, $svf1{$chr}{$num}; 
			print "\t$svf1{$chr}{$num}\t$snp1[0]";
		# if only 2 exists, print 2.reference x (rank) + 2.last
		} elsif (exists $svf2{$chr}{$num}) {
			my @snp2 = split /\t/, $svf2{$chr}{$num};
			for (my $i=1; $i<= $rank; $i++) {
				print "\t$snp2[0]";
			}
			print "\t$snp2[1]";
		} else {
			print "Oops, check $chr:$num\n";
		}
		print "\n";
	}
}

sub by_num {
		$a <=> $b;
}
