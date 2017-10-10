# generates results output files for each of the time slicing terms.
# These results files can then be clustered and reranked for evaluation

#file containing cuis for time slicing
my $timeSliceCuiFile = '/home/henryst/lbdData/timeSliceCuiList';
#folder to output the LBD inputs to
my $inputDirectory = '/home/henryst/lbdData/timeSliceInput/';
#folder to output the LBD results to
my $outputDirectory = '/home/henryst/lbdData/timeSliceOutput/';
#file containing explicit co-occurrence data for LBD
my $inputMatrix = '/home/henryst/1975_1999_window8_noOrder';



#############################################################################
# Begin Code
#############################################################################

#read each time slice cui from file
open IN, $timeSliceCuiFile 
    or die("ERROR: unable to open time slice cui file: timeSliceCuiFile\n");
my @cuis = ();
while (my $line = <IN>) {
    chomp $line;
    push @cuis, $line;
}
close IN;


#create an lbd input file for each term
foreach my $cui(@cuis) {
    open OUT, ">$inputDirectory$cui" 
	or die("ERROR: unable to open lbd input file: $inputDirectory$cui\n");
    print OUT "<rankingProcedure>ltc\n";
    print OUT "<linkingAcceptGroups>CHEM,DISO,GENE,PHYS,ANAT\n";
    print OUT "<targetAcceptGroups>CHEM,GENE\n";   
    print OUT "<startCuis>$cui\n";
    print OUT "<explicitInputFile>$inputMatrix\n";
    print OUT "<implicitOutputFile>$outputDirectory$cui\n";
    close OUT;
}



#run LBD for each of the input cuis
foreach my $cui(@cuis) {
    `perl runDiscovery.pl $inputDirectory$cui`;
}

