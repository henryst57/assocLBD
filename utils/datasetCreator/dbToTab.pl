#converts a mysql database to tab seperated readable by LBD

`mysql 1980_1984_window1_retest -e "SELECT * FROM N_11 INTO OUTFILE '1980_1984_window1_retest_data.txt' FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';"`;
