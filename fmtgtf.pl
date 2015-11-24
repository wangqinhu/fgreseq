#!/usr/bin/perl

use strict;
use warnings;

open (GTF, $ARGV[0]) or die $!;
while (<GTF>) {
	chomp;
	my @w = split /\t/;
	my @t = split /\;/, $w[8];
	my $id = $t[0];
	$id =~ s/gene_id\s//;
	$id =~ s/\"//g;
	if ($w[6] eq "+") {
		my $next = <GTF>;
		chomp;
		my @n = split /\t/, $next;
		print $w[0], "\t.", "\tgene\t", $w[3], "\t", $n[4], "\t.\t", $w[6], "\t.\t", $id, "\n";
	} else {
		my $next = <GTF>;
		chomp;
		my @n = split /\t/, $next;
		print $w[0], "\t.", "\tgene\t", $w[4], "\t", $n[3], "\t.\t", $w[6], "\t.\t", $id, "\n";
	}
}
close GTF;
