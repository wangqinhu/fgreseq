#!/usr/bin/perl

use strict;
use warnings;

open (IN, "$ARGV[0]") or die "$!\n";
my @seq1 = ();
my @seq2 = ();
my @seq3 = ();
my @seq4 = ();
my @seq5 = ();
my @seq6 = ();

while (<IN>) {
	chomp;
	my @w = split /\t/;
	push @seq1, $w[2];
	push @seq2, $w[3];
	push @seq3, $w[4];
	push @seq4, $w[5];
	push @seq5, $w[6];
	push @seq6, $w[7];
}

print ">PH-1\n";
print_seq(@seq1);
print ">YL-1\n";
print_seq(@seq2);
print ">HN9-1\n";
print_seq(@seq3);
print ">HN-Z6\n";
print_seq(@seq4);
print ">GZ3639\n";
print_seq(@seq5);
print ">CS3005\n";
print_seq(@seq6);

sub print_seq {

	foreach (@_) {
		print $_;
	}
	print "\n";

}
