#combines the co-occurrences counts for the year range specified (inclusive)
use strict;
use warnings;
my $startYear;
my $endYear;
my $windowSize;
my $dataFolder;

#user input
$dataFolder = '/home/henryst/jackData/';
$startYear = '1911';
$endYear = '1920';
$windowSize = 8;
&combineFiles($startYear,$endYear,$windowSize);

####### Program Start ########
sub combineFiles {
    my $startYear = shift;
    my $endYear = shift;
    my $windowSize = shift;

#Check on I/O
    my $outFileName = "$startYear".'_'."$endYear".'_window'."$windowSize";
(!(-e $outFileName)) 
    or die ("ERROR: output file already exists: $outFileName\n");
open OUT, ">$outFileName" 
    or die ("ERROR: unable to open output file: $outFileName\n");

#combine the files
my %matrix = ();
for(my $year = $startYear; $year <= $endYear; $year++) {
    print "reading $year\n";
    my $inFile = $dataFolder.$year.'_window'.$windowSize;
    if (!(open IN, $inFile)) {
	print "   ERROR: unable to open $inFile\n";
	next;
    }

    #read each line of the file and add to the matrix
    while (my $line = <IN>) {
	#read values from the line
	$line =~ /([^\s]+)\t([^\s]+)\t([^\s]+)/;
	my $rowKey = $1;
	my $colKey = $2;
	my $val = $3;

	#add the values to the matrix
	if (!exists $matrix{$rowKey}) {
	    my %newHash = ();
	    $matrix{$rowKey} = \%newHash;
	}
	if (!exists ${$matrix{$rowKey}}{$colKey}) {
	    ${$matrix{$rowKey}}{$colKey} = 0;
	}
	${$matrix{$rowKey}}{$colKey}+=$val;
    }
    close IN;
}

#output the matrix
print "outputting the matrix\n";
foreach my $rowKey(keys %matrix) {
    foreach my $colKey(keys %{$matrix{$rowKey}}) {
	print OUT "$rowKey\t$colKey\t${$matrix{$rowKey}}{$colKey}\n";
    }
}
close OUT;
print "DONE!\n";
}





