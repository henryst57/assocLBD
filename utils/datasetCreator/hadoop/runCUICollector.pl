#runs Hadoop CUICollector for each year in the provided range
my $startYear = 1809;
my $endYear = 2015;
my $name;

#run CUI collector over all the files
for (my $year = $startYear; $year <= $endYear; $year++) {
    #run article collector
    `gunzip 1809_2015/$year.txt.gz`;
    `hadoop jar CUICollectorMapReduce.jar Hadoop.CUICollectorMapReduce.ArticleCollector -i 1809_2015/$year.txt -o articles/`;
    `rm -r /home/hadoop/tmp/hadoop-henryst`;
    `gzip 1809_2015/$year.txt`;

    #run cui collector with different window sizes
    `hadoop jar CUICollectorMapReduce.jar Hadoop.CUICollectorMapReduce.CUICollector -i articles/part-r-00000 -o temp_output/ -m article -w 1`;
    `rm -r /home/hadoop/tmp/hadoop-henryst`;
    $name = $year.'_window1';
    `mv temp_output/part-r-00000 output/$name`;
    `rm -r temp_output/`;

    `hadoop jar CUICollectorMapReduce.jar Hadoop.CUICollectorMapReduce.CUICollector -i articles/part-r-00000 -o temp_output/$year_window8 -m article -w 8`;
    `rm -r /home/hadoop/tmp/hadoop-henryst`;
     $name = $year.'_window8';
    `mv temp_output/part-r-00000 output/$name`;
    `rm -r temp_output`;

    `hadoop jar CUICollectorMapReduce.jar Hadoop.CUICollectorMapReduce.CUICollector -i articles/part-r-00000 -o temp_output/$year_window9999 -m article -w 9999`;
    `rm -r /home/hadoop/tmp/hadoop-henryst`;
     $name = $year.'_window9999';
    `mv temp_output/part-r-00000 output/$name`;
    `rm -r temp_output`;
    `rm -r articles/`;
}
