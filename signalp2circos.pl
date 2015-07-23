#!/usr/bin/env perl 

use strict;
use warnings;

my $pep = $ARGV[0] || "data/refseq/FG.RR.27.pep.all.fa";
my $signalp_out = $ARGV[1] || "data/signalp/signalp.out";
my $gff = $ARGV[2] || "data/refseq/FG.RR.27.gff3";
my $circos = $ARGV[3] || "data/circos/signalp.txt";
my $id = $ARGV[4] || "id.txt";

# predict pep with siganlp
system("signalp -t euk -f short -m hmm $pep > $signalp_out");
system("grep 'Y' $signalp_out | grep 'noTM' | cut -d ' ' -f 1 > $id");

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

unlink $id;
