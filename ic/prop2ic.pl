#!/usr/bin/perl

while(<>) { 
    chomp;
    if($_=~/C[0-9]+<>[0-9\.]+/) { 
	my ($cui, $prob) = split/<>/;
	if($prob <= 0 || $prob > 1) { 
	    next; print "$cui : $prob\n"; exit; 
	}
	my $ic = -1 * (log($prob) / log(10));
	print "$cui<>$ic\n";
    }
}
