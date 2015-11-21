#! /usr/local/bin/perl 
##
## This code calculates syn and nonsyn values for an alignment
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
## Read the filenames from the command line

sub usage {
    printf "Usage: %s -plot (Y or N) -list (Y or N) file1 \n\n", __FILE__;
}

# syn-nonsyn.pl on it's own at the command line will produce a usage message.
# print "$#ARGV\n";
if ($#ARGV < 0) {
    &usage;
    exit(0);
} 

#defaults are no plot or list outputs.
$plot = "N";
$list = "N";

while ($#ARGV) {
    if    ($ARGV[0] eq '-plot') { shift @ARGV; $plot=shift @ARGV; } 
    elsif ($ARGV[0] eq '-list') { shift @ARGV; $list=shift @ARGV; }
    else {last;}
}

#Read in the file

#print "$#ARGV\n";

$file = shift @ARGV;
$number = shift @ARGV if (@ARGV);
open(FILE,"$file") || die "Cant open file: ($file)";

#TEST: is the file read properly?
#while (<FILE>) {      # can the code reproduce the input?
#   ($name,$seq) = split;
#   print "name = $name\n";
#   print "seq =$seq\n";
#}
#close FILE;

#create arrays of names and sequences
$count=0;
while (<FILE>) {
    chomp;
    next unless /^\S+\s+\S+/;
    ($name,$seq) = split;
    $count++;
    push(@names,$name);
    push(@seqs,$seq);
    if ($seq =~ /[^-ACGTN]/) {
      die "You should have only the characters -,A,C,G,T,N in $name, try again.\n";}	
}

    $seq_length = length($seqs[0]);
close FILE;
$num_seqs = scalar(@names);
#printf STDERR "Query file: %d sequences\n",$num_seqs;
#printf STDERR "Sequence Length: %d\n",$seq_length;
#printf STDERR "@seqs";

#PROVIDE AN ARRAY TO CONVERT A codon_number to its corresponding aa
@aa_array = qw/ F F L L L L L L I I I M V V V V S S S S P P P P T T T T A A A A Y Y Z Z H H Q Q N N K K D D E E C C Z W R R R R S S R R G G G G/;
#printf "@aa_array\n";

# $$ tails with the pid
#codons.$$ will be a file that contains codons and their "type"
open(CODONS, ">codons.$$") || die "Can't open codons.$$: $!\n"; 
open(SUMMARY, ">summary.$$") || die "Can't open summary.$$ : $!\n";
#print SUMMARY "Compare Sequences_names           Sd      Sn       S       N      ps      pn      ds      dn   ds/dn\n";
open(BASIC, ">background.$$") || die "Can't open background.$$ : $!\n";
print BASIC "The input file has $num_seqs sequences\n";
printf BASIC "Sequence Length: %d\n",$seq_length;
print BASIC "Compare Sequences_names     Codons  Compared Ambiguous Indels     Ns\n";


for ($na=0; $na < $num_seqs; ++$na) {
#Create pointers to the arrays
$Astring = \$seqs[$na];  
#splits with no field separators turning the sequence string into an array.
@Aarray = split(//,"$$Astring");
$A = \@Aarray;

#$A is the pointer; to treat it as a variable and print what it is
# pointing to you need the $$; printf "$A" just gives the address of the pointer

#printf "$$Astring \n";
#printf "$$a\n";
#print "$$A[2]\n";

for ($n=$na+1; $n < $num_seqs; ++$n) {
    #the variables defined here are global and can be seen in the subroutines
    $count_insertions = 0;
    $count_Ns = 0;
    $syn_codons = 0;
    $nonsyn_codons = 0;
    $SA_Nei = 0;
    $SB_Nei = 0;
    $Bstring = \$seqs[$n];
    @Barray = split(//,"$$Bstring"); #splits the sequence string into an array
    $B = \@Barray;
    print CODONS "This is comparison $na x $n: $names[$na] $names[$n] \n";
    print CODONS "Codon# class     1   2   aa1 aa2  syn     non\n";
	# Comment out by Wang
    #printf SUMMARY "%-3d %-3d %-9s %-9s ", $na, $n, $names[$na], $names[$n];
	# Comment out by Wang
    printf BASIC "%-3d %-3d %-9s %-9s ", $na, $n, $names[$na], $names[$n];

    #print "$$B[2], $$B[12]\n"; #make sure B is loaded
    &countsubstitutions; 
    }

}
close(CODONS);
close(SUMMARY);
close(BASIC);

open(DATA, "summary.$$") || die "Can't open summary.$$ $!\n";
#$countdata = 0;
#$dsDtotal = 0;
#$dnDtotal =0;
#$ratioDtotal = 0;
# Below by Wang
#$pnDtotal = 0;
#$psDtotal = 0;
# Above by Wang
# reads the first line of data (the header) and moves along to the data
#$dummyline = <DATA>;
#while(<DATA>) {
#  ($seq1D,$seq2D,$name1D,$name2D,$SdD,$SnD,$SD,$ND,$psD,$pnD,$dsD,$dnD,$ratioD) = split;
#  unless (grep /NA/, ($dsD, $dnD,$ratioD)) { 
#  $countdata += 1;
#  $dsDtotal += $dsD;
#  $dnDtotal += $dnD;
#  $ratioDtotal += $ratioD;
#  $countdata0 += 1 if ($seq1D == 0); 
#  $dsD0 += $dsD if ($seq1D == 0);
#  $dnD0 += $dnD if ($seq1D == 0);
#  $ratioD0 += $ratioD if ($seq1D == 0) ;
#  }
# Below by Wang
#  $pnDtotal += $pnD;
#  $psDtotal += $psD;
# Above by Wang
#}
#close(DATA);

open(DATA, ">>summary.$$") ||  die "Cant open file: summary.$$";
#printf DATA "Averages of all pairwise comparisons: ds = %7.4f, dn = %7.4f, ds/dn = %7.4f\n", $dsDtotal/$countdata, $dnDtotal/$countdata, $ratioDtotal/$countdata;
#printf DATA "Averages of the first sequence compared to others: ds = %7.4f, dn = %7.4f, ds/dn = %7.4f\n", $dsD0/$countdata0, $dnD0/$countdata0, $ratioD0/$countdata0;
close(DATA);


my @SynDistArray;
my @NonSynDistArray;
my @ArrayRow;
my @SeqNames;
for ($i=0; $i<$num_seqs; ++$i) {
    push @ArrayRow, 0.0;
    push @SeqNames, "";
}
for ($i=0; $i<$num_seqs; ++$i) {
    push @SynDistArray, [ @ArrayRow ];
    push @NonSynDistArray, [ @ArrayRow ];
}
open(DATA,"summary.$$") || die;
$dummyline=<DATA>;
while(<DATA>) {
    next unless /^\s*\d+\s+\d+\s+/;
    ($seq1D,$seq2D,$name1D,$name2D,$SdD,$SnD,$SD,$ND,
     $psD,$pnD,$dsD,$dnD,$ratioD) = split;
    $SeqNames[$seq1D]=$name1D;
    $SeqNames[$seq2D]=$name2D;
    $SynDistArray[$seq1D][$seq2D] = $dsD;
    $SynDistArray[$seq2D][$seq1D] = $dsD;
    $NonSynDistArray[$seq1D][$seq2D] = $dnD;
    $NonSynDistArray[$seq2D][$seq1D] = $dnD;
}
close DATA;
    
open(DNADIST,">dsdist.$$") || die;
printf DNADIST "  $num_seqs";
for ($i=0; $i<$num_seqs; ++$i) {
    printf DNADIST "\n%-12s",$SeqNames[$i];
    for ($j=0; $j<$num_seqs; ++$j) {
        $dist = $SynDistArray[$i][$j];
        if ($dist eq "NA") {
            printf DNADIST "  %6s","NA";
        } else {
            printf DNADIST "  %6.4f",$dist;
        }
	if ($j%9 == 8 && $j != ($num_seqs - 1)) {print DNADIST "\n";}
    }
    #print DNADIST "\n";
}

open(DNADIST,">dndist.$$") || die;
printf DNADIST "  $num_seqs";
for ($i=0; $i<$num_seqs; ++$i) {
    printf DNADIST "\n%-12s",$SeqNames[$i];
    for ($j=0; $j<$num_seqs; ++$j) {
        $dist = $NonSynDistArray[$i][$j];
        if ($dist eq "NA") {
            printf DNADIST "  %6s","NA";
        } else {
            printf DNADIST "  %6.4f",$dist;
        }
	print DNADIST "\n" if ($j%9 == 8 && $j != ($num_seqs - 1));
    }
    #print DNADIST "\n";
}

sub countsubstitutions 
{
    $count_compared_codons = 0;
    $count_ambiguous_codons = 0;
    $count_codons = 0;

LINE:  for ($i=1; $i <= ($seq_length - 1); $i += 3) {
	@codonA = ("$$A[$i-1]", "$$A[$i]", "$$A[$i+1]");
	@codonB = ("$$B[$i-1]", "$$B[$i]", "$$B[$i+1]");
	$codA = \@codonA;
	$codB = \@codonB;
	# print "\nThe first base: $$A[$i-1]  "; #make sure codon is loaded
	# for($m=0; $m<3; $m++) {print "@codonA[$m]";} #make sure codon is loaded
	#count and print codons with indels
	# "next" means the loop starts again at LINE

	++$count_codons;

	if (grep /-/, (@$codA, @$codB)) {
	    ++ $count_insertions;
            printf CODONS "%-6d indel     %s%s%s %s%s%s -   -   \n", $count_codons, @$codA, @$codB;
            next LINE;
	}
	#count and print codons with Ns
	if (grep /N/, (@$codA, @$codB)) {
	    ++ $count_Ns; 
            printf CODONS "%-6d ambiguous %s%s%s %s%s%s -   -   \n", $count_codons, @$codA, @$codB; 
	    next LINE;
	}
	#this counts the potential number of synonymous changes
	$syn_siteA[$i] = &syn_site(@$codA);
	$syn_siteB[$i] = &syn_site(@$codB);
	$SA_Nei += $syn_siteA[$i];
	$SB_Nei += $syn_siteB[$i];
	
	#consider only codons with changes for subsequent steps
	if ($$codA[0] eq $$codB[0] && $$codA[1] eq $$codB[1] && $$codA[2] eq $$codB[2]) 
	{
            $codon_numberA = &codon_conversion(@$codA);
	    printf CODONS "%-6d identity  %s%s%s %s%s%s %-3s %-3s \n", $count_codons, @$codA, @$codB, $aa_array[$codon_numberA], $aa_array[$codon_numberA]; 
	    next LINE;
	}
	
	## At this point, codonA and codonB are "real" codons (no N's or -'s)
	## but are not identical
	
	#codon_conversion is a function that converts
	#a codon to a number 0-63, called codon_number 

	$codon_numberA = &codon_conversion(@$codA);
	$codon_numberB = &codon_conversion(@$codB);
        #print "$codon_numberA,$codon_numberB are codon conversions\n";

        if ($aa_array[$codon_numberA] eq $aa_array[$codon_numberB]) {
         printf CODONS "%-6d synon     %s%s%s %s%s%s %-3s %-3s ", $count_codons, @$codA, @$codB, $aa_array[$codon_numberA], $aa_array[$codon_numberB];}
        else {
         printf CODONS "%-6d nonsynon  %s%s%s %s%s%s %-3s %-3s ", $count_codons, @$codA, @$codB, $aa_array[$codon_numberA], $aa_array[$codon_numberB];}

        # the following tallies syn changes of 1 base in a codon
        # ie there is one base change in the codon, no aa change
        if (($aa_array[$codon_numberA] eq $aa_array[$codon_numberB]) &&
        (($$codA[0] ne $$codB[0] && $$codA[1] eq $$codB[1] && $$codA[2] eq $$codB[2]) ||
         ($$codA[0] eq $$codB[0] && $$codA[1] ne $$codB[1] && $$codA[2] eq $$codB[2]) ||
         ($$codA[0] eq $$codB[0] && $$codA[1] eq $$codB[1] && $$codA[2] ne $$codB[2]))) {
	    $syn_codons += 1.0; 
            print CODONS " 1.00    0.00\n";
	    #print "made it here, $syn_codons";
	}

        # the following tallies nonsyn changes of 1 base in a codon 
        # ie there is one base change in the codon, and the encoded aa change changes
        elsif(($aa_array[$codon_numberA] ne $aa_array[$codon_numberB]) &&
        (($$codA[0] ne $$codB[0] && $$codA[1] eq $$codB[1] && $$codA[2] eq $$codB[2]) ||
         ($$codA[0] eq $$codB[0] && $$codA[1] ne $$codB[1] && $$codA[2] eq $$codB[2]) ||
         ($$codA[0] eq $$codB[0] && $$codA[1] eq $$codB[1] && $$codA[2] ne $$codB[2]))) {
	    $nonsyn_codons += 1.0;
                        print CODONS " 0.00    1.00\n";
	}

        # the following 3 elsifs tally syn and nonsyn changes of 2 base in a codon
        #Two base change, example: AAA -> TTA
        elsif($$codA[0] ne $$codB[0] && $$codA[1] ne $$codB[1] && $$codA[2] eq $$codB[2])
          {
          $x = $$codA[0];
          $y = $$codA[1];
          $$codA[0] = $$codB[0];
          $codon_numberC = &codon_conversion(@$codA);
          $$codA[0] = $x;
          $$codA[1] = $$codB[1];
          $codon_numberD = &codon_conversion(@$codA);
          $$codA[1] = $y;
          $tmp_syn = 0;
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          $tmp_syn = $tmp_syn/2.0;
          printf CODONS "%7.4f   %7.4f\n", $tmp_syn, 2-$tmp_syn; 
          $syn_codons += $tmp_syn;
          $nonsyn_codons += (2.0 - $tmp_syn);
          }

        #Two base change, example: AAA -> TAT 
        elsif($$codA[0] ne $$codB[0] && $$codA[1] eq $$codB[1] && $$codA[2] ne $$codB[2])
          {
          $x = $$codA[0];
          $y = $$codA[2];
          $$codA[0] = $$codB[0];
          $codon_numberC = &codon_conversion(@$codA);
          $$codA[0] = $x;
          $$codA[2] = $$codB[2];
          $codon_numberD = &codon_conversion(@$codA);
          $$codA[2] = $y;
          $tmp_syn = 0;
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          $tmp_syn = $tmp_syn/2.0;
          printf CODONS "%7.4f   %7.4f\n", $tmp_syn, 2-$tmp_syn;
          $syn_codons += $tmp_syn;
          $nonsyn_codons += (2.0 - $tmp_syn);
          }

        #Two base change, example: AAA -> ATT 
        elsif($$codA[0] eq $$codB[0] && $$codA[1] ne $$codB[1] && $$codA[2] ne $$codB[2])
          {
          $x = $$codA[1];
          $y = $$codA[2];
          $$codA[1] = $$codB[1];
          $codon_numberC = &codon_conversion(@$codA);
          $$codA[1] = $x;
          $$codA[2] = $$codB[2];
          $codon_numberD = &codon_conversion(@$codA);
          $$codA[2] = $y;
          $tmp_syn = 0;
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          $tmp_syn = $tmp_syn/2.0;
          printf CODONS "%7.4f   %7.4f\n", $tmp_syn, 2-$tmp_syn;
          $syn_codons += $tmp_syn;
          $nonsyn_codons += (2.0 - $tmp_syn); 
          }

        #The following elsif deals with the situation where all three bases have changed
        # For example AAA -> TTT
        elsif($$codA[0] ne $$codB[0] && $$codA[1] ne $$codB[1] && $$codA[2] ne $$codB[2])
          {
          $x = $$codA[0];
          $y = $$codA[1];
          $z = $$codA[2];
          $$codA[0] = $$codB[0];
          $codon_numberC = &codon_conversion(@$codA);
          $$codA[1] = $$codB[1];
          $codon_numberF = &codon_conversion(@$codA);
          $$codA[1] = $y;
          $$codA[2] = $$codB[2];
          $codon_numberG = &codon_conversion(@$codA);
          $$codA[0] = $x;
          $codon_numberE = &codon_conversion(@$codA);
          $$codA[1] = $$codB[1];
          $codon_numberH = &codon_conversion(@$codA);
          $$codA[2] = $z;
          $codon_numberD = &codon_conversion(@$codA);
          $tmp_syn = 0;
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberC])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberD])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberA] eq $aa_array[$codon_numberE])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberF])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberG])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberB] eq $aa_array[$codon_numberH])
            {$tmp_syn += 1.0;}
          if($aa_array[$codon_numberC] eq $aa_array[$codon_numberF])
            {$tmp_syn += 0.5;}
          if($aa_array[$codon_numberC] eq $aa_array[$codon_numberG])
            {$tmp_syn += 0.5;}
          if($aa_array[$codon_numberD] eq $aa_array[$codon_numberF])
            {$tmp_syn += 0.5;}
          if($aa_array[$codon_numberD] eq $aa_array[$codon_numberH])
            {$tmp_syn += 0.5;}
          if($aa_array[$codon_numberE] eq $aa_array[$codon_numberG])
            {$tmp_syn += 0.5;}
          if($aa_array[$codon_numberE] eq $aa_array[$codon_numberH])
            {$tmp_syn += 0.5;}
          $syn_codons += $tmp_syn/3.0;
          $nonsyn_codons += (3.0 - $tmp_syn/3.0);
          printf CODONS "%7.4f   %7.4f\n", $tmp_syn/3.0, 3.0-$tmp_syn/3.0;
          $tmp_syn = 0;
          }
          else {
	      printf "Trouble in River City %s%s%s=%s, %s%s%s=%s\n",
	      $$codA[0],$$codA[1],$$codA[2],
	      $aa_array[&codon_conversion(@$codA)],
	      $$codB[0],$$codB[1],$$codB[2],
	      $aa_array[&codon_conversion(@$codB)];
	  }

   }
$count_ambiguous_codons = $count_insertions + $count_Ns; 
$count_compared_codons = $count_codons - $count_ambiguous_codons;
$potential_syn = ($SA_Nei/3 + $SB_Nei/3)/2;
$potential_nonsyn = (3*$count_compared_codons - $potential_syn);
$ps = $syn_codons/$potential_syn;
$pn = $nonsyn_codons/$potential_nonsyn;
#print "ps = $ps, pn = $pn\n";
# ds and dn are Juke's Cantor corrections, and do not work if ps or pn is > .75
# the following is a concise if... else
# ds = (if ps < 0.75) -3.0/4.0*log(1-(4.0*$ps/3.0)) else NA 
$ds = ($ps < 0.75 ) ? -3.0/4.0*log(1-(4.0*$ps/3.0)) : "NA"; 
$dn = ($pn < 0.75 ) ? -3.0/4.0*log(1-(4.0*$pn/3.0)) : "NA";
$ratio = ($ds != 0 && $dn != 0 && $ds ne "NA" && $dn ne "NA") ? $ds/$dn : "NA";  

printf BASIC "  %d        %d        %d        %d      %d\n", 
  $count_codons, $count_compared_codons, $count_ambiguous_codons, $count_insertions, $count_Ns;

#printf SUMMARY "%10.4f%10.4f%10.4f%10.4f%10.4f%10.4f%8s%8s%8s\n",
#               $syn_codons, $nonsyn_codons, 
#               $potential_syn, $potential_nonsyn, $ps, $pn, 
#               ($ds eq "NA") ? "NA" : sprintf("%10.4f",$ds),
#               ($dn eq "NA") ? "NA" : sprintf("%10.4f",$dn),
#               ($ratio eq "NA") ? "NA" : sprintf("%10.4f",$ratio);
print SUMMARY $pn, "\t", $ps, "\t", ($dn eq "NA") ? "NA" : $ds, "\t", ($ds eq "NA") ? "NA" : $dn, "\t";



}
#syn-site is a function that determine the number of possible syn sbstitutions
#for a specific codon by the method of Nei -- this array is in the same order
#as the other amino acid translation arrays in this set. */

sub syn_site {
   local(@codon)=@_;
   @codon_syn_sites = qw/1 1 2 2 3 3 4 4 2 2 2 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 3 3 4 4 1 1 2 2 3 3 3 3/;
   $codon_number = &codon_conversion(@codon);
   return $codon_syn_sites[$codon_number];
   }

#codon_conversion converts each codon to a number
sub codon_conversion {
   local(@codon)=@_; 
   #make a hash that converts a base to a number
   %baseNumber = ("T" => 0, "C" => 1, "A" => 2, "G" => 3);
        my ($xleft,$xmid,$xright);

        $xleft = $baseNumber{$codon[0]};
        $xmid = $baseNumber{$codon[1]};
        $xright = $baseNumber{$codon[2]};

        return ($xmid*16) + ($xleft*4) + $xright;
# this uses base 4 for ACGT, converts compactly to 0-63
 }
