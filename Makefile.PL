# This -*- perl -*- script writes the Makefile for assocLBD
# (Last Updated 09/25/2017 -- Sam)
#
# Generates the Makefile for the assocLBD Perl modules. 
#
# ----------------------------------------------------------------------

use 5.005;
use ExtUtils::MakeMaker;
my $author1 = 'Sam Henry <henryst@vcu.edu>'; 
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $author1 = 'Sam Henry <henryst@vcu.edu>';

WriteMakefile(
              'NAME'		  => 'assocLBD',
              'VERSION_FROM' => 'lib/LiteratureBasedDiscovery.pm',
              'PREREQ_PM'      => { 'UMLS::Interface' => '0', 
                                      'UMLS::Association' => '0'},
              'EXE_FILES'         => [("utils/runDiscovery.pl", "utils/datasetCreator/applyMaxThreshold.pl", "utils/datasetCreator/applyMinThreshold.pl", "utils/datasetCreator/applySemanticFilter.pl", "utils/datasetCreator/combineCooccurrenceMatrices.pl", "utils/datasetCreator/makeOrderNotMatter.pl", "utils/datasetCreator/removeCUIPair.pl", "utils/datasetCreator/removeExplicit.pl", "utils/datasetCreator/testMatrixEquality.pl", "utils/datasetCreator/dataStats/getCUICooccurrences.pl", "utils/datasetCreator/dataStats/getMatrixStats.pl", "utils/datasetCreator/dataStats/metaAnalysis.pl", "utils/datasetCreator/fromMySQL/dbToTab.pl", "utils/datasetCreator/fromMySQL/removeQuotes.pl", "utils/datasetCreator/squaring/convertForSquaring_MATLAB.pl", "utils/datasetCreator/squaring/squareMatrix_perl.pl")], 
              'dist'              => {'COMPRESS' => 'gzip -9f', 'SUFFIX' => 'gz'},
    ($] >= 5.005 ?
     ('ABSTRACT_FROM'   => 'lib/LiteratureBasedDiscovery.pm', # retrieve abstract from module
      'AUTHOR'          => "$author1") : ()));

