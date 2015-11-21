#!/usr/bin/perl

use strict;
use warnings;

my %cds = ();
my %strand = ();
my $id = "";
my $nu = undef;

open (IN, $ARGV[0]) or die "$!\n";
while (<IN>) {
	chomp;
	if (/^>(\S+)[\S\s]+FORWARD/) {
		if ($id ne $1) {
			$nu = 0;	
		}
		$id = $1;
		$strand{$id} = "+";
	} elsif (/^\>(\S+)[\S|\s]+REVERSE/) {
		if ($id ne $1) {
			$nu = 0;	
		}
		$id = $1;
		$strand{$id} = "-";
	} else {
		$nu++;
		$cds{$id}{$nu} = $_;
	}
}
close IN;

foreach my $id (sort keys %strand) {
	print $id, "\t";
	if ($strand{$id} eq "+") {
		foreach my $nu (sort by_num keys $cds{$id}) {
			print $cds{$id}{$nu};
		}
	} else {
		foreach my $nu (reverse sort by_num keys $cds{$id}) {
			print $cds{$id}{$nu};
		}
	
	}
	print "\n";
}

sub by_num {
	$a <=> $b;
}
