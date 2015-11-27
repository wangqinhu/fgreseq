#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;

my $blast_file = $ARGV[0] || "blast.txt";
my $report = $ARGV[1] || 'blast.tsv';
my $evalue = undef;

open (RPT,">$report");
print RPT "Query\tHit\tDescription\tE-value\n";
my $in = new Bio::SearchIO(
-format => 'blast',
-file   => "$blast_file");
while(my $result = $in->next_result) {
	while(my $hit = $result->next_hit) { 
		while(my $hsp = $hit->next_hsp) {                       
				print RPT $result->query_name, "\t";
				print RPT $hit->name, "\t", $hit->description, "\t";
				$evalue = $hsp->evalue;
				$evalue =~ s/\,//;
				print RPT $evalue, "\n";
				last;
		}
		last;
	}
}
close(RPT);
