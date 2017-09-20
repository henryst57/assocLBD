#!/usr/bin/perl

=head1 NAME

runDiscovery.pl This program runs literature based discovery with the 
parameters specified in the input file. Please see samples/lbd or 
samples/thresholding for sample input files and descriptions of parameters
full details on what can be in an LBD input file

=head1 SYNOPSIS

This utility takes an lbd configuration file and outputs the results
of lbd

=head1 USAGE

Usage: umls-assocation.pl [OPTIONS] LBD_CONFIG_FILE

=head1 INPUT

=head2 LBD_CONFIG_FILE

Configuration file specifying the parameters of LBD. 
See '../config/lbd' for an example

=head1 OPTIONS

Optional command line arguements

=head2 General Options:

Displays the quick summary of program options.

=head3 --help

displays help

=head3 --assocConfig

path to a UMLS::Association configuration file. Default location is 
'../config/association'. Replace this file for your computer to avoid haveing
to specify each time.

=head3 --interfaceConfig

path to a UMLS::Interface configuration file. Default location is 
'../config/interface'. Replace this file for your computer to avoid haveing
to specify each time.

=head3 --debug

enter debug mode

=head1 OUTPUT

The association between the two concepts (or terms)

=head1 SYSTEM REQUIREMENTS

=over

=item * Perl (version 5.16.5 or better) - http://www.perl.org

=item * UMLS::Interface - http://search.cpan.org/dist/UMLS-Interface

=item * UMLS::Association - http://search.cpan.org/dist/UMLS-Association

=back

=head1 CONTACT US
   
  If you have any trouble installing and using assocLBD, 
  You may contact us directly :
    
      Sam Henry: henryst at vcu.edu 

=head1 AUTHOR

 Sam Henry, Virginia Commonwealth University

=head1 COPYRIGHT

Copyright (c) 2017

 Sam Henry, Virginia Commonwealth University 
 henryst at vcu.edu

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to:

 The Free Software Foundation, Inc.,
 59 Temple Place - Suite 330,
 Boston, MA  02111-1307, USA.

=cut

###############################################################################
#                               THE CODE STARTS HERE
###############################################################################

use strict;
use warnings;

use Getopt::Long;
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
."\nUSAGE EXAMPLES\n"
."perl runDiscovery ../config/lbd\n";
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

#grab all the options and set values
GetOptions( 'debug'             => \$DEBUG, 
            'help'              => \$HELP,
            'assocConfig=s'     => \$options{'assocConfig'},
            'interfaceConfig=s' => \$options{'interfaceConfig'},
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



