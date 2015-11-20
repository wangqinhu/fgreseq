#!/usr/bin/env perl 

use strict;
use warnings;


my $id = $ARGV[0] || "data/secretome/fg.secretome.txt";
my $gff = $ARGV[1] || "data/refseq/FG.RR.27.gff3";
my $circos = $ARGV[2] || "data/circos/data/secretome.txt";

# load id
my @id = ();
open (ID, $id) or die "Cannot open file $id: $!\n";
while (<ID>) {
	chomp;
	s/\s+//g;
	if (/(\S+)/) {
		push @id, $1;
	}
}
close ID;

# load gff
open (GFF, "$gff") or die "Cannot open file $gff: $!\n";
open (OUT, ">$circos") or die "Cannot open file $circos: $!\n";
while (<GFF>) {
	next if /^#/;
	my @w = split /\t/;
	if ($w[2] eq "transcript") {
		# transcript id
		my @tid = split /\;/, $w[8];
		$tid[0] =~ s/ID\=transcript\://;
		foreach my $id (@id) {
			if ( $tid[0] eq $id) {
				print OUT "Chr$w[0]\t$w[3]\t$w[4]\t1\n";
			}
		}
	}
}
close GFF;
close OUT;

#unlink $id;
