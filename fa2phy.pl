#!/usr/bin/perl

use Bio::AlignIO;

my $in  = Bio::AlignIO -> new(-file => "$ARGV[0]", '-format' => 'fasta');
my $out = Bio::AlignIO -> new(-file => ">$ARGV[1]", '-format' => 'phylip');
my $aln = $in -> next_aln();
$out -> write_aln($aln);
