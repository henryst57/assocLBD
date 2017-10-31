use strict;
use warnings;

#TODO -  modify this to be the library where you have the ALBD package
use lib '/home/share/packages/ALBD/lib/';
use LiteratureBasedDiscovery::Discovery;
use LiteratureBasedDiscovery::TimeSlicing;



#TODO - manual or command line arguments
    my $goldMatrixFileName = '';
    my $rankedOutputFolder = '';
    my $numIntervals = 20;


    #The gold standard matrix
    my $goldMatrixRef = Discovery::fileToSparseMatrix($goldMatrixFileName);

    #TODO - write a script to load the ranked CUIs into this hash
    # ...probably want to use the ranked output folder
    #my %rowRanks;  # Keys of the hash are the starting term cui, values are 
                   # arrays of ranked target terms for that CUI
   #e.g. rowRanks{C0000224} contains an array of ranked target cuis that 
   # should be loaded from the ranked output file you generate
   # so in the end, rowRanks will have 100 keys, each key corresponds to the
   # contents of the output files for the CUI
    my $rowRanksRef = &loadRankedOutputFiles($rankedOutputFolder)
    
    #output all stats to STDOUT
    #TODO - probably want to modify so that only MAP is calculate, see the code in 
    # time slicing to do this. Also you probably want to output to a file rather than a folder
    TimeSlicing::outputTimeSlicingResults($goldMatrixRef, $rowRanksRef, $numIntervals);
#TODO - maybe just TimeSlicing::calculateMeanAveragePrecision ...but this will require the row ranks
# arrays to be threshold with code you write, at intervals


}



sub loadRankedOutputFiles {
    my $rankedOutputFolder = shift;

    my %rowRanks = ();
    #TODO, load and return as a row ranks hash of ranked arrays

    return \%rowRanks;

}
