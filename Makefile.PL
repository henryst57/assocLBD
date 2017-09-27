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
              'EXE_FILES'         => [("utils/runDiscovery.pl")], 
              'dist'              => {'COMPRESS' => 'gzip -9f', 'SUFFIX' => 'gz'},
    ($] >= 5.005 ?
     ('ABSTRACT_FROM'   => 'lib/LiteratureBasedDiscovery.pm', # retrieve abstract from module
      'AUTHOR'          => "$author1") : ()));

