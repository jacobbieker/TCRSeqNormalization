# Designed and developed by Jacob Bieker (jacob@bieker.tech)

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

# Go through each file and read in the CSV data, skpping the first line which gives no information
# All operations on the data will happen inside the for loop, so that it goes through each file
# and each FASTQ file once
for(spike_file in files) {
  data <- read.csv(spike_file, header = FALSE, skip = 1);
  #Get the mean from the last column, which is the read count
  spiked_mean <- mean(data[[3]])
  # The get max
  spiked_max <- max(data[[3]])
  # Get the min
  spiked_min <- min(data[[3]])
  # Get the smallest multiple that the FASTQ file will be normalized by
  smallest_multiple <- (spiked_mean/spiked_max)
  # Get the largest multiple that the FASTQ file will be normalized by
  largest_multiple <- (spiked_mean/spiked_min)
}

