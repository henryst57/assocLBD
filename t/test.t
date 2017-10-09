#!/usr/local/bin/perl -w

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl t/lch.t'

use strict;
use warnings;
use Test::Simple tests => 2;

#Test that the demo file can run correctly
my @lines = `(cd ./samples/; perl runSample.pl) &`;
ok ($lines[2] =~ /LBD Open discovery results output to sampleOutput/);
ok ($lines[5] =~ /LBD Time Slicing results output to sampleTimeSliceOutput/); 
