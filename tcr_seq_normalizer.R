# Designed and developed by Jacob Bieker (jacob@bieker.us)

# Script reads in a csv file containing spiked read counts from TCR sequencing, and calculates the 
# what number is needed to change the counts of each spiked read to the mean. 
# It then takes the multiples for the largest read and smallest read and uses that as the scale
# to normalize the FASTQ files with all the reads. 
# Prior to the full FASTQ file being normalized, the spiked reads are removed.
#
# Assumptions:
#   1.  A CSV file per FASTQ file of the format ID,spike,count
#   2.  A FASTQ file per CSV file
#
