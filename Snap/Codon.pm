package Codon;

## Codons are three-letter combinations of DNA bases

%baseNumber = (T => 0, C => 1, A => 2, G => 3);
@baseLetter = qw/T C A G/;

#Convert Codon Number to corresponding Amino Acid
@aminoAcid = qw/ 
    F F L L L L L L I I I M V V V V 
    S S S S P P P P T T T T A A A A 
    Y Y Z Z H H Q Q N N K K D D E E 
    C C Z W R R R R S S R R G G G G/;

# Convert codon number to potential syn's
@synPotential = qw/
    1 1 2 2 3 3 4 4 2 2 2 0 3 3 3 3 
    3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
    1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 
    1 1 1 0 3 3 4 4 1 1 2 2 3 3 3 3/;

## Convert codon string to codon number
%toNumberHash = &build_to_number_hash;

sub to_synPotential {
    my $codon=shift;
    return undef if ($codon =~ /[-N]/);
    my $codonNumber=&to_number($codon);
    return $synPotential[$codonNumber]/3;
}
sub to_nonsynPotential {
    my $codon=shift; 
    return undef if ($codon =~ /[-N]/);
    return 3-$synPotential[&to_number($codon)];
}
    
sub to_number {
    # this uses base 4 for ACGT, converts compactly to 0-63
    my $codon=shift;
    return undef if ($codon =~ /[-N]/);
    my @codon=split(//,$codon);
    my $xleft = $baseNumber{$codon[0]};
    my $xmid = $baseNumber{$codon[1]};
    my $xright = $baseNumber{$codon[2]};
    return ($xmid*16) + ($xleft*4) + $xright;
}
sub build_to_number_hash {
    # this permits a faster computation of 'to_number', by
    # making a hashtable of all possible answers!  Hmmm, I
    # _could_ make the to_number build a hash table as it
    # is needed.
    my %hash=();
    my ($left,$mid,$right);
    foreach $left (@baseLetters) {
	foreach $mid (@baseLetters) {
	    foreach $right (@baseLetters) {
		my $codon = "$left$mid$right";
		$hash{$codon} = &to_number($codon);
	    }
	}
    }
    return %hash;
}

sub to_aminoacid {
    my @codon=@_; 
    return $aminoAcid[&to_number(@codon)];
}

1;
 
__END__
