#!/usr/bin/env perl 

use strict;
use warnings;

my $gff = $ARGV[0] || "FG.RR.27.gff3";

# parse gff
my %gene = ();
my @name = ();
open (GFF, "$gff") or die "Cannot open file $gff: $!\n";
while (<GFF>) {
	next if /^#/;
	my @w = split /\t/;
	if ($w[2] eq "gene") {
		my ($id, $discard) = split /\;/, $w[8], 2;
		$id =~ s/ID\=gene\://;
		push @name, $id;
		$gene{$id}{"start"} = $w[3];
		$gene{$id}{"end"} = $w[4];
		$gene{$id}{"strand"} = $w[6];
	}
}
close GFF;

# caculate fir length
my %fir = ();
for (my $i = 1; $i< @name - 1; $i++) { # discard first and last one
	my $prev_id = $name[$i - 1];
	my $curr_id = $name[$i];
	my $next_id = $name[$i + 1];
	$fir{$curr_id}{"5"} = $gene{$curr_id}{"start"} - $gene{$prev_id}{"end"};
	$fir{$curr_id}{"3"} = $gene{$next_id}{"start"} - $gene{$curr_id}{"end"};	
}

# output
foreach my $id (@name) {
	if (exists $fir{$id}{"5"} && exists $fir{$id}{"3"}) {
		next if $fir{$id}{"5"} < 0 or $fir{$id}{3} < 0; # discard the genes overlapped on on another chr
		if ($gene{$id}{"strand"} eq "+") {
			print $id, "\t", $fir{$id}{"5"}, "\t", $fir{$id}{"3"}, "\n";
		} else {
			print $id, "\t", $fir{$id}{"3"}, "\t", $fir{$id}{"5"}, "\n";
		}	
	}
}
