#!/usr/bin/perl

use strict;
use warnings;

# YL-1 1
# HN9-1 2
# HN-Z6 3
# GZ3639 4
# CS3005 5

while (<>) {
	chomp;
	s/data\/vcf_filtered_gi\///g;
	s/\.vcf\S+\s\(\S+\)//g;
	s/YL\-1/1/;
	s/HN9\-1/2/;
	s/HN\-Z6/3/;
	s/GZ3639/4/;
	s/CS3005/5/;
	my @w = split /\t/, $_, 2;
	$w[1] =~ s/\s//g;
	print rank_num($w[1]), "\t", $w[0], "\n";
}

sub rank_num {

	my ($num) = @_;
	my @w = split //, $num;
	my $sorted_num;
	foreach (sort @w) {
		$sorted_num .= $_;
	}
	return $sorted_num;

}

