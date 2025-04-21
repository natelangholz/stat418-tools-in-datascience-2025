#!/bin/bash

#the following fetch both NASA log files from the corresponding urls and write. Write them to your local hw1 directory and create a NEW .sh file that can be run on files named:
# NASA_Jul95.log
# NASA_Aug95.log

#curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log > NASA_Jul95.log

#curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log > NASA_Aug95.log

echo
echo 'This is an example of how you could format your first homework .sh file'

echo
echo 'ex1. This lists all files in your present working directory (pwd)'
ls

echo
echo 'ex2. This the head of the July 95 NASA log file '
head -n 5 NASA_Jul95.log

echo
echo 'ex3. This is the word count of Aug 95 NASA log file'
wc NASA_AUG95.log

echo
#echo - the echos are included to create an empty line to make more readable in terminal