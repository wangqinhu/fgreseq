#!/usr/bin/env perl
###############################################################################
#
#    gff2fasta.pl
#     
#    Convert a GFF file to fasta
#
#    Copyright (C) Michael Imelfort
#
#    Edited: Kranti Konganti
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

#pragmas
use strict;
use warnings;

#core Perl modules
use Getopt::Long;
use Carp;

#CPAN modules
use Bio::SeqIO;
use Bio::Perl;
use Bio::Tools::CodonTable;

#locally-written modules

BEGIN {
    select(STDERR);
    $| = 1;
    select(STDOUT);
    $| = 1;
}

# edit here to log all external commands 
my $global_log_commands = 0;

# ext command failure levels
use constant {
    IGNORE_FAILURE => 0,
    WARN_ON_FAILURE => 1,
    DIE_ON_FAILURE => 2
};

# get input params and print copyright
my $global_options = checkParams();
if(!exists $global_options->{'silent'}) {
    printAtStart();
}

######################################################################
# CODE HERE
######################################################################
my %global_gff_orfs = ();
my %global_gff_non_orfs = ();
my %global_lengths = ();
my $global_reject_length = overrideDefault(50,'length');
my $global_keep_non_orfs = overrideDefault(0, 'non_orfs');
my $global_protein_code =  overrideDefault(0,'protein');
if((0 != $global_keep_non_orfs) and (0 != $global_protein_code))
{
    print "**WARNING: $0 : non_orfs flag is invalid when translating into protein space --> ignoring\n";
    $global_keep_non_orfs = 0;
}
my $global_line_wrap = overrideDefault(80,'wrap');

# Read in the gff
my $current_seq_id = "";
my $gff_fh = openRead($global_options->{'gff'});
while(<$gff_fh>){
    next if ($_ =~ m/^#/);
    my ($seqid, undef, $feature, $start, $end,
        undef, $strand, undef, $attributes) = split;
    ($attributes) = ($attributes =~ m/(ID|Alias|Parent)=([^;]*)/i)[1];
    push @{$global_gff_orfs{$seqid}}, [$start, $end, $strand, $attributes, $feature];
}
close $gff_fh;

# open the output file
my $out_fh = openWrite($global_options->{'out'});

# Read in the fasta
my $seqio = Bio::SeqIO->new( -file => $global_options->{'fasta'}, -format => 'fasta' ) or croak "**ERROR: Could not open FASTA file: $global_options->{'fasta'} $!\n";
while(my $sobj = $seqio->next_seq)
{
    my $seqid = $sobj->id;
    my $seq = $sobj->seq;
    my $seq_length = $sobj->length;
    
    # make sure this guy has an annotation
    if(defined($global_gff_orfs{$seqid}))
    {
        for(@{$global_gff_orfs{$seqid}})
        {
            my ($start, $end, $strand, $attributes, $feature) = @$_;

	    next if (defined $global_options->{'feature'} &&
		     $global_options->{feature} !~ m/$feature/);
     
            # work out the length of the sub string
            my $length = $end - $start + 1;
            
            # check if he's long enough
            if($length < $global_reject_length)
            {
                if(!exists $global_options->{'silent'}) {
                    print "Rejecting: $seqid -> ($start, $end) on $strand. $length is shorter than cutoff!\n";
                }
                next;
            }

            my $this_seq = substr($seq, $start-1, $length); 
            if($strand eq "+")
            {
		if ($global_options->{'seq-desc'}) {
		    print $out_fh ">$attributes | $seqid:$start-$end FORWARD\n";
		}
		else 
		{
		    print $out_fh ">$seqid"."_$start"."_$end"."_F\n";
		}
                print $out_fh fasta_cut($this_seq, $global_protein_code);
            }
            else
            {
		if ($global_options->{'seq-desc'}) {
                    print $out_fh ">$attributes | $seqid:$start-$end REVERSE\n";
		}
		else
                {
                    print $out_fh ">$seqid"."_$start"."_$end"."_R\n";
		}
                print $out_fh fasta_cut(revcompl($this_seq), $global_protein_code);                
            } 
        }
    }
    elsif(exists $global_options->{'include-nulls'})
    {
        # include anyway
        print $out_fh ">$seqid"."_1_$seq_length"."_X\n".fasta_cut($seq, $global_protein_code);
    }
}

close $out_fh;

######################################################################
# CUSTOM SUBS
######################################################################
sub revcompl {
    my ($seq) = @_;
    $seq =~ tr/ACGTacgt/TGCAtgca/;
    return scalar reverse $seq;
}

sub fasta_cut {
    #-----
    # Cut up a fasta sequence 
    #
    my ($string, $prot) =  @_;
    
    # translate if need be
    if(0 != $prot) 
    { 
        my $codon_table  = Bio::Tools::CodonTable -> new ( -id => $prot );
        $string  = $codon_table->translate($string); 
    }
    
    # wrap the line if need be
    if(0 != $global_line_wrap)
    {
        my $return_str = "";
        my $len = length $string;
        my $start = 0;
        while($start < $len)
        {
            $return_str .= substr $string, $start, $global_line_wrap;
            $return_str .="\n";
            $start += $global_line_wrap;
        }
        return $return_str;
    }
    return "$string\n";
}

######################################################################
# TEMPLATE SUBS

######################################################################
# PARAMETERS

sub checkParams {
    my @standard_options = ( "help|h+",
			     "gff|g:s",
			     "fasta|f:s",
			     "out|o:s",
			     "protein|p:i",
			     "length|l:i",
			     "wrap|w:i",
			     "non_orfs+",
			     "include_nulls+",
			     "seq-desc|d",
			     "feature|fe=s");
    my %options;

    # Add any other command line options, and the code to handle them
    # 
    GetOptions( \%options, @standard_options );

    # if no arguments supplied print the usage and exit
    #
    exec("pod2usage $0") if (0 == (keys (%options) ));

    # If the -help option is set, print the usage and exit
    #
    exec("pod2usage $0") if $options{'help'};

    # Compulsory items
    if(!exists $options{'gff'} ) { printParamError ("You MUST supply a GFF file to parse"); }
    if(!exists $options{'fasta'} ) { printParamError ("You MUST supply a FASTA file to parse"); }
    if(!exists $options{'out'} ) { printParamError ("Please specify the name of the fasta file you'd like to create"); }
    #if(!exists $options{''} ) { printParamError (""); }

    return \%options;
}

sub printParamError
{
    #-----
    # What to do if there's something wrong with a parameter
    #  
    my ($error) = @_;  
    print "**ERROR: $0 : $error\n"; exec("pod2usage $0");
}

sub overrideDefault
{
    #-----
    # Set and override default values for parameters
    #
    my ($default_value, $option_name) = @_;
    if(exists $global_options->{$option_name}) 
    {
        return $global_options->{$option_name};
    }
    return $default_value;
}

######################################################################
# FILE IO

sub openWrite
{
    #-----
    # Open a file for writing
    #
    my ($fn) = @_;
    open my $fh, ">", $fn or croak "**ERROR: could not open file: $fn for writing $!\n";
    return $fh;
}

sub openRead
{   
    #-----
    # Open a file for reading
    #
    my ($fn) = @_;
    open my $fh, "<", $fn or croak "**ERROR: could not open file: $fn for reading $!\n";
    return $fh;
}

######################################################################
# EXTERNAL COMMANDS
#
# checkAndRunCommand("ls", {
#                          -a => ""
#                          }, 
#                          WARN_ON_FAILURE);

sub checkFileExists {
    #-----
    # Does a file exists?
    #
    my ($file) = @_;
    unless(-e $file) {
        croak "**ERROR: $0 : Cannot find:\n$file\n";
    }
}

sub logExternalCommand
{
    #-----
    # Log a command line command to the command line!
    #
    if(1 == $global_log_commands) {
        print $_[0], "\n";
    }
}

sub isCommandInPath
{
    #-----
    # Is this command in the path?
    #
    my ($cmd, $failure_type) = @_;
    if (system("which $cmd |> /dev/null")) {
        handleCommandFailure($cmd, $failure_type);
    }
}

sub runExternalCommand
{
    #-----
    # Run a command line command on the command line!
    #
    my ($cmd) = @_;
    logExternalCommand($cmd);
    system($cmd);
}

sub checkAndRunCommand
{
    #-----
    # Run external commands more sanelier
    #
    my ($cmd, $params, $failure_type) = @_;
    
    isCommandInPath($cmd, $failure_type);
    
    # join the parameters to the command
    my $param_str = join " ", map {formatParams($_)} @{$params};
    
    my $cmd_str = $cmd . " " . $param_str;
    
    logExternalCommand($cmd_str);

    # make sure that all went well
    if (system($cmd_str)) {
         handleCommandFailure($cmd_str, $failure_type)
    }
}

sub formatParams {

    #---------
    # Handles and formats the different ways of passing parameters to 
    # checkAndRunCommand
    #
    my $ref = shift;
    
    if (ref($ref) eq "ARRAY") {
        return join(" ", @{$ref});
    } elsif (ref($ref) eq "HASH") {
        return join(" ", map { $_ . " " . $ref->{$_}} keys %{$ref});
    }
    croak 'The elements of the $params argument in checkAndRunCommand can ' .
        'only contain references to arrays or hashes\n';
}


sub handleCommandFailure {
    #-----
    # What to do when all goes bad!
    #
    my ($cmd, $failure_type) = @_;
    if (defined($failure_type)) {
        if ($failure_type == DIE_ON_FAILURE) {
            croak "**ERROR: $0 : " . $! . "\n";
        } elsif ($failure_type == WARN_ON_FAILURE) {
            carp "**WARNING: $0 : " . $! . "\n";
        }
    }
}

######################################################################
# MISC

sub printAtStart {
print<<"EOF";
---------------------------------------------------------------- 
 $0
 Copyright (C) Michael Imelfort
 Edited: Kranti Konganti
    
 This program comes with ABSOLUTELY NO WARRANTY;
 This is free software, and you are welcome to redistribute it
 under certain conditions: See the source for more details.
---------------------------------------------------------------- 
EOF
}

__DATA__

=head1 NAME

    gff2fasta.pl

=head1 COPYRIGHT

   copyright (C) Michael Imelfort

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 CHANGES

=item * 02/04/2013

   Fasta sequence headers now include either ID or Alias tags from gff files.
    
=head1 DESCRIPTION

   Convert a GFF file to fasta

=head1 SYNOPSIS

    gff2fasta.pl -gff|g GFF -fasta|f FASTA -out|o FASTA

      -gff -g GFF                  GFF3 file to parse
      -fasta -f FASTA              Original fasta file
      -out -o FASTA                Multi fasta file to create
      [-protein -p CODON_CODE]     Output protein sequences --> see below
      [-non_orfs]                  Process non-ORF regions [default: false]
      [-include_nulls]             Transparently write through contigs with no genes [default: false] 
      [-seq-desc|d]                Use either ID or Alias attributes of GFF file as sequence identifiers
      [-feature|fe gene]           Print fasta for only mentioned features. Example: gene or CDS or exon etc...
      [-wrap -w LEN]               Line wrap at LEN chars [default: 80] Set to 0 for no wrap
      [-length -l LENGTH]          Reject any orfs shorter than this length [default: 50]
      [-help -h]                   Displays basic usage information
      
      CODON_CODE
      
      Specify a number from the following list (Uses: Bio::Tools::CodonTable)
      
      1 Standard
      2 Vertebrate Mitochondrial
      3 Yeast Mitochondrial
      4 Mold, Protozoan,_and_CoelenterateMitochondrial_and_Mycoplasma/Spiroplasma
      5 Invertebrate Mitochondrial
      6 Ciliate, Dasycladacean_and_Hexamita_Nuclear
      9 Echinoderm Mitochondrial
      10 Euplotid Nuclear
      11 Bacterial
      12 Alternative Yeast_Nuclear
      13 Ascidian Mitochondrial
      14 Flatworm Mitochondrial
      15 Blepharisma Nuclear
      16 Chlorophycean Mitochondrial
      21 Trematode Mitochondrial
      22 Scenedesmus obliquus_Mitochondrial
      23 Thraustochytrium Mitochondrial
         
=cut
>>
