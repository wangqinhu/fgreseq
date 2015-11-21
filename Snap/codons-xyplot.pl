#! /usr/local/bin/perl 
##
## Notice:
##                                                                 6/15/98
## Unless otherwise indicated, this information, consisting of source code,
## documentation, and executable programs, has been authored by an employee or
## employees of the University of California under LACC # ______ , operator of the
## Los Alamos National Laboratory under Contract No. W-7405-ENG-36 with the U.S.
## Department of Energy. The U.S. Government has rights to use, reproduce, and
## distribute this information. The public may copy and use this information
## without charge, make derivative works, distribute, and publicly display
## provided that this Notice and any statement of authorship are reproduced on all
## copies.  However, the public may not incorporate this information in any
## commercial or proprietary product.  Neither the Government nor the University
## makes any warranty, express or implied, or assumes any liability or
## responsibility for the use of this information.
##
# codons-xyplot.pl on it's own at the command line will produce a usage message.

sub usage {
    printf "Usage: %s codons.pid \n\n",  __FILE__;
    print "This code produces the data file codon.data for the codon.xy file\n";
    print "To generate the xyplot: xyplot -ps codon.xy > codon.ps \n"; 
}

# print "$#ARGV\n";
if ($#ARGV < 0) {
    &usage;
    exit(0);
}

$countpairwise = 0;
open(PLOT, ">codon.data") || die "Can't open codons.dat: $!\n";
print PLOT "#k codon indel-tally syn-tally nonsyn-tally\n";
while(<>) {
   ($Codon,$class,$nuc1,$nuc2,$aa1,$aa2,$syn,$non) = split;
    next unless $Codon =~ /\d+/;
    if ($Codon >= $Codon) {$maxcodon = $Codon;}
    $aa[$Codon]=$aa1;
    ++$countpairwise if ($Codon == 1);
    if ($class eq "indel") {++$indeltally[$Codon];}
    if ($class eq "synon" || $class eq "nonsynon") {  
       #calculates the number of syn, nonsyn and indels 
       # for each codon among pairwise comparisons
       $syntally[$Codon] += $syn;
       $nonsyntally[$Codon] += $non;
    }
}
print PLOT "#k The number of codons is: $maxcodon\n";
print PLOT "#k The average behavior for $countpairwise comparisons:  \n";
print PLOT "#k             Cumulative             Per Codon       \n";
print PLOT "#k         __________________    __________________ \n";
print PLOT "#k codon   indel  syn  nonsyn    indel  syn  nonsyn  aa\n";

for ($c = 1; $c <= $maxcodon; ++$c) {
    $indelperbase [$c] = $indeltally[$c]/$countpairwise;
    $synperbase[$c] = $syntally[$c]/$countpairwise;
    $nonsynperbase[$c] = $nonsyntally[$c]/$countpairwise;
} 

#makes the cumulative plot
for ($c = 2; $c <= $maxcodon; ++$c) {
    $indeltally[$c] += $indeltally[$c-1];
    $syntally[$c] += $syntally[$c-1];
    $nonsyntally[$c] += $nonsyntally[$c-1];
}

for ($c = 1; $c <= $maxcodon; ++$c) {
    printf PLOT "%4d    %7.2f%7.2f%7.2f%8.2f%7.2f%7.2f  %s \n", 
             $c, ($indeltally[$c]/$countpairwise), $syntally[$c]/$countpairwise, 
             $nonsyntally[$c]/$countpairwise, $indelperbase[$c], $synperbase[$c],
             $nonsynperbase[$c], $aa[$c];   
}
close(PLOT); 
__END__
