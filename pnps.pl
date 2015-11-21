#!/usr/bin/perl

use strict;
use warnings;

open (IN, "data/pnps/tsv/PH-1.seq.tsv");
my @ph1 = <IN>;
close IN;

open (IN, "data/pnps/tsv/YL-1.seq.tsv");
my @yl1 = <IN>;
close IN;

open (IN, "data/pnps/tsv/HN9-1.seq.tsv");
my @hn9 = <IN>;
close IN;

open (IN, "data/pnps/tsv/HN-Z6.seq.tsv");
my @hnz = <IN>;
close IN;

open (IN, "data/pnps/tsv/CS3005.seq.tsv");
my @cs3 = <IN>;
close IN;

for (my $i = 0; $i < @ph1; $i++) {
	open (TBL, ">seqfile.tbl") or die $!;
	print TBL "PH-1_$ph1[$i]";
	print TBL "YL-1_$yl1[$i]";
	print TBL "HN9-1_$hn9[$i]";
	print TBL "HN-Z6_$hnz[$i]";
	print TBL "CS3005_$cs3[$i]";
	close TBL;
	my ($id, undef) = split /\t/, $ph1[$i];
	print $id, "\t";
	system("perl ./Snap/SNAP.pl seqfile.tbl");
	system("cat summary.*");
	print "\n";
	system("rm seqfile.tbl summary.* codons.* background.*	dndist.* dsdist.*");
}
