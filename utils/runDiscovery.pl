#
#
#
#TODO all the documentation here
#
#
#


use strict;
use warnings;

use Getopt::Long;

use lib '/home/share/packages/assoc_lbd/lib/'; #TODO delete this once installed
use LiteratureBasedDiscovery;

###############################################################################
# CONSTANT STRINGS
###############################################################################

my $usage = (&showVersion)."\n"
."FLAGS\n"
."--debug       Print EVERYTHING to STDERR.\n"
."--help        Print this help screen.\n"
."Config File OPTIONS\n"
."--assocConfig        path to the UMLS::Association Config File\n"
."--interfaceConfig    path to the UMLS::Interface Config File\n"
."--lbdConfig          path to the LBD Config File\n"
."--simConfig          path to the UMLS::Similarity Config File\n"
."\nUSAGE EXAMPLES\n"
."TODO write a typical command that will get this to run\n";
;

#############################################################################
#                       Parse command line options 
#############################################################################
my $DEBUG = 0;      # Prints EVERYTHING. Use with small testing files.        
my $HELP = '';      # Prints usage and exits if true.

#set default param values
my %options = ();
$options{'assocConfig'}  = '../config/association';
$options{'interfaceConfig'} = '../config/interface';
$options{'simConfig'} = '../config/sim';

#grab all the options and set values
GetOptions( 'debug'             => \$DEBUG, 
            'help'              => \$HELP,
            'assocConfig=s'     => \$options{'assocConfig'},
            'interfaceConfig=s' => \$options{'interfaceConfig'},
	    'lbdConfig=s'       => \$options{'lbdConfig'},
            'simConfig=s'       => \$options{'simConfig'},
);

#die $usage unless $#ARGV; #<- use this if args must be provided
die $usage if $HELP;               


############################################################################
#                          Begin Running LBD
############################################################################

$options{'lbdConfig'} = shift;
defined $options{'lbdConfig'} or die ("ERROR: no lbdConfig file defined\n");

my $lbd = LiteratureBasedDiscovery->new(\%options);
$lbd->performLBD();


##############################################################################
#  function to output minimal usage notes
##############################################################################
sub minimalUsageNotes {
    print "Usage: runDiscovery.pl [OPTIONS]\n";  #TOOD if parameters become required update this
    &askHelp();
    exit;
}

############################################################################
#  function to output help messages for this program
############################################################################
#TODO write your own help
sub showHelp() {
        
    print "This is a utility that takes as input either two terms \n";
    print "or two CUIs from the command line or a file and returns \n";
    print "their association using one of the following measures: \n";

    print "1.  Dice Coefficient (dice) \n";
    print "2.  Fishers exact test - left sided (left)\n";
    print "3.  Fishers exact test - right sided (right)\n";
    print "4.  Fishers twotailed test - right sided (twotailed)\n";
    print "5.  Jaccard Coefficient (jaccard)\n";
    print "6.  Log-likelihood ratio (ll)\n"; 
    print "7.  Mutual Information (tmi)\n";
    print "8.  Odds Ratio (oods)\n";
    print "9.  Pointwise Mutual Information (pmi)\n";
    print "10. Phi Coefficient (phi)\n";
    print "11. Pearson's Chi Squared Test (chi)\n";
    print "12. Poisson Stirling Measure (ps)\n";
    print "13. T-score (tscore) DEFAULT\n\n";

    print "Usage: umls-assocation.pl [OPTIONS] TERM1 TERM2\n\n";

    print "General Options:\n\n";

    print "--measure MEASURE        The measure to use to calculate the\n";
    print "                         assocation. (DEFAULT: tscore)\n\n";

    print "--precision N            Displays values upto N places of decimal. (DEFAULT: 4)\n\n";

    print "--version                Prints the version number\n\n";
    
    print "--help                   Prints this help message.\n\n";

    print "--getdescendants         Calculates the association score taking into account
                         the occurrences of descendants of the specified CUIs\n\n";

    print "--config FILE            Configuration file\n\n";    

    print "\n\nInput Options: \n\n";

    print "--infile FILE            File containing TERM or CUI pairs\n\n";  

    print "\n\nGeneral Database Options:\n\n"; 

    print "--username STRING        Username required to access mysql\n\n";

    print "--password STRING        Password required to access mysql\n\n";

    print "--hostname STRING        Hostname for mysql (DEFAULT: localhost)\n\n";
    print "--socket STRING          Socket for mysql (DEFAULT: /tmp/mysql.sock\n\n";

    print "\n\nUMLS-Interface Database Options: \n\n";

    print "--umlsdatabase STRING        Database contain UMLS (DEFAULT: umls)\n\n";
    
    print "\n\nUMLS-Association Database Options: \n\n";

    print "--assocdatabase STRING        Database containing CUI bigrams 
                              (DEFAULT: CUI_BIGRAMS)\n\n";
    
}
##############################################################################
#  function to output the version number
##############################################################################
sub showVersion {
    print '$Id: runDiscovery.pl,v 0.01 2015/06/24 19:25:05 btmcinnes Exp $';
    print "\nCopyright (c) 2017, Sam Henry\n";
}

##############################################################################
#  function to output "ask for help" message when user's goofed
##############################################################################
sub askHelp {
    print STDERR "Type runDiscovery.pl --help for help.\n";
}



