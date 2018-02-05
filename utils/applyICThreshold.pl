#   applyICThreshold.pl
#
# thresholds the target term list by removing any terms with IC less than the threshold provided. Uses the target term list, icpropogation file, and threshold provided as input
# NOTE: any CUI that does not occur in the IC file will NOT be eliminated
#
# usage: perl applyICThreshold.pl -termFile=<termFile> -icFile=<icFile> -outputFile=<outputFile> -threshold=<threshold>
#
# example: perl applyICThreshold.pl -termFile=../ic/rayFish_ltc -icFile=../ic/rayFish_ltc.sm.iic -outputFile=rayFish_ltc_ic3 -threshold=0.3
#
# Parameters:
#   termFile = the target term file output by LBD that is being thresholded
#   icFile = the IC propogation file generated by UMLS::Similarity::create-icpropagation.pl
#   outputFile = the target term list after an IC threshold has been applied
#   threshold = the IC threshold to apply. Any terms with an IC greater than the threshold are eliminated. Threshold must be greater than 0 and less than 1

use strict;
use warnings;
use Getopt::Long;

my $DEBUG = 0;
my $HELP = '';
my %options = ();

GetOptions( 'debug'             => \$DEBUG, 
            'help'              => \$HELP,
            'termFile=s'        => \$options{'termFile'},
	    'icFile=s'          => \$options{'icFile'},
	    'outputFile=s'      => \$options{'outputFile'},
	    'threshold=s'       => \$options{'threshold'},
);

#input checking
(exists $options{'termFile'}) or die ("ERROR: termFile must be specified\n");
open TERM_IN, $options{'termFile'} or 
    die ("ERROR: unable to open termFile file: $options{termFile}\n");

(exists $options{'icFile'}) or die ("ERROR: icFile must be specified\n");
open IC_IN, $options{'icFile'} or 
    die ("ERROR: unable to open termFile file: $options{icFile}\n");

(exists $options{'outputFile'}) or die ("ERROR: outputFile must be specified\n");
open OUT, '>'.$options{'outputFile'} or 
    die ("ERROR: unable to open output file: $options{outputFile}\n");

(exists $options{'threshold'} or die ("ERROR: threshold must be specified\n"));
if ($options{'threshold'} <= 0 || $options{'threshold'} >= 1) {
    die ("ERROR: threshold should be greater than 0 and less than 1");
}


##############################
# Begin Code
##############################


########################
### Target Term File
print "   Applying a threshold of $options{threshold} to $options{termFile}\n";


#skip the header stuff in the target term file, but save for output later
my @headerLines = ();
my $position = 0;
while (my $line = <TERM_IN>) {
    #see if its a header line
    if ($line =~ /1\t\d+\.\d+\tC\d{7}\t/) {
	last;
    }
    push @headerLines, $line;

    #update current position of file handle
    $position = tell(TERM_IN);
}
#move the file handle back one line so you don't skip the first CUI line
seek(TERM_IN, $position, 0);

#read in the target term list as a hash: key is the CUI and value is the rank
# also read in each line for output later: key is CUI and value is line
my %targetTermList = ();
my %lines = ();
while (my $line = <TERM_IN>) {
    #split line to get CUI and score
    # line is rank\tscore\tCUI\tterms
    my @vals = split(/\t/,$line);
    (scalar @vals == 4) or die ("Formatting Error in TermFile: $line\n");
    #vals = rank, score, cui, term

    #set hash to be the hash{CUI}=score
    $targetTermList{$vals[2]} = $vals[0];
    $lines{$vals[2]} = $line;
}
close TERM_IN;


########################
#### IC FILE
print "   IC is coming from $options{icFile}\n";

=comment     #reading co-occurrence based IC file
#skip header info for IC file
$position = 0;
while (my $line = <IC_IN>) {
    if ($line =~ /<>/) {
	last;
     }
    #update current position of file handle
    $position = tell(IC_IN);
}
#move the file handle back one line so you don't skip the first CUI line
seek(IC_IN, $position, 0); 


#get the information content for each target term from the ICfile
# and if the IC is less than the threshold, remove it from the target
# term list hash
while (my $line = <IC_IN>) {
    #read the line and get CUI and IC from it
    # line is CUI<>IC
    my @vals = split(/<>/,$line);
    (scalar @vals == 2) or die ("Formatting Error in ICFile: $line\n");

    #see if the CUI is one of the target terms
    if (exists $targetTermList{$vals[0]}) {
	#the cui is a target term so see if it should be kept based on its IC
	if ($vals[1] < $options{'threshold'}) {
	    delete $targetTermList{$vals[0]};
	}
    }
}
close IC_IN;
=cut

#read intrinsic IC file
#skip header info for IC file
$position = 0;
while (my $line = <IC_IN>) {
    if ($line =~ /C\d{7}/) {
	last;
     }
    #update current position of file handle
    $position = tell(IC_IN);
}
#move the file handle back one line so you don't skip the first CUI line
seek(IC_IN, $position, 0); 


#get the information content for each target term from the ICfile
# and if the IC is less than the threshold, remove it from the target
# term list hash
while (my $line = <IC_IN>) {
    #read the line and get CUI and IC from it
    # line is either just a CUI (no IC exists for it) or it is 
    # the text: The intrinsic information content of  (<CUI>) is <value>

    #grab the cui
    $line =~ /(C\d{7})/;
    my $cui = $1;

    if (!$cui) {
	print STDERR "Warning: error grabbing CUI from line: $line\n";
	next;
    }

    #grab the value if it exists
    my $value = -1;
    if ($line =~ /The intrinsic information content of  \(C\d{7}\) is (\d+\.?\d*)/) {
	$value = $1;
    }
    if ($value != -1) {
	#print STDERR "$cui value = $value\n";
    }
    

    #see if the CUI is one of the target terms
    if (exists $targetTermList{$cui}) {
	#the cui is a target term so see if it should be kept based on its IC
	# if the CUI has no IC (vale = -1), then keep it
	if ($value < $options{'threshold'} && $value != -1) {
	    delete $targetTermList{$cui};
	}
    }
}
close IC_IN;


#######################
### Output
print "   outputting to $options{outputFile}\n";


#output the header info to the new target term list file
foreach my $line(@headerLines) {
    print OUT $line;
}

#output the target term list now that IC threshold has been applied
# but be sure to output using ascending rank
# also put the new ranks, now that thresholds have been applied
my $rank = 1;
foreach my $key(sort { $targetTermList{$a} <=> $targetTermList{$b} } keys %targetTermList) {
    #get values from the line
    my @vals = split(/\t/,$lines{$key});
    #vals = rank, score, cui, term
    
    #print out the line, but use the new rank
    print OUT "$rank\t$vals[1]\t$vals[2]\t$vals[3]";
    $rank++;
}
close OUT;

#Finished
print "DONE!\n";
