# Designed and developed by Jacob Bieker (jacob@bieker.us)

# Script reads in a csv file containing spiked read counts from TCR sequencing, and calculates the 
# what number is needed to change the counts of each spiked read to the mean. 
# It then takes the multiples for the largest read and smallest read and uses that as the scale
# to normalize the FASTQ files with all the reads. 
# Prior to the full FASTQ file being normalized, the spiked reads are removed.
#
# Assumptions:
#   1.  A CSV file, named "<FASTQ File>xout.csv" per FASTQ file of the format ID,spike,count
#   2.  A FASTQ file per CSV file
#   3.  Spiked reads are supposed to be present in the exact same frequency

#############################################################################
#
#             Setup
#
#############################################################################

#############################################################################
#
#             Spiked Read CSV code
#
#############################################################################

#   identify all .csv files that should be the spiked read counts in the directory 
files <- list.files(getwd(), pattern = "*xout.csv");
