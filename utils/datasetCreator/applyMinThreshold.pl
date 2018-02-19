#Applies a minimum number of co-occurrences threshold to a file by 
#copying the $inputFile to $outputFile, but ommitting lines that have less than
#$minThreshold number of co-occurrences

my $minThreshold = 1;
my $inputFile = '/home/sam/data/lbdData/1975_1999_window8_ordered';
my $outputFile = '/home/sam/data/lbdData/1975_1999_window8_ordered_threshold'.$minThreshold;
&applyMinThreshold($minThreshold, $inputFile, $outputFile);



############

sub applyMinThreshold {
    #grab the input
    my $minThreshold = shift;
    my $inputFile = shift;
    my $outputFile = shift;

    #open files
    open IN, $inputFile or die("ERROR: unable to open inputFile\n");
    open OUT, ">$outputFile" 
	or die ("ERROR: unable to open outputFile: $outputFile\n");

    print "Reading File\n";
    #threshold each line of the file
    my ($key, $cui1, $cui2, $val);
    while (my $line = <IN>) {
	#grab values 
	($cui1, $cui2, $val) = split(/\t/,$line);

	#check minThreshold
	if ($val > $minThreshold) {
	    print OUT $line;
	}  
    }
    close IN;

    print "Done!\n";
}
