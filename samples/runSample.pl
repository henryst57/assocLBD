#Demo file, showing how to run open discovery using the sample data, and how 
# to perform time slicing evaluation using the sample data


# run a sample lbd using the parameters in the lbd configuration file
`perl runDiscovery.pl --lbdConfig lbd`;


# run a sample time slicing
# first remove the co-occurrences of the precutoff matrix (in this case it is 
# the sampleExplicitMatrix from the post cutoff matrix. This generates a gold 
# standard discovery matrix from which time slicing may be performed
`perl removeExplicit::removeExplicit(sampleExplicitMatrix, postCutoffMatrix, sampleGoldMatrix)`;

# next, run time slicing 
`perl runDiscovery.pl --lbdConfig timeslicing`;
