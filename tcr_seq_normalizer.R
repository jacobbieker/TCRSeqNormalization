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
#             Normalization functions
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
  # Getting the range for possible use at the scale
  multiple_range <- largest_multiple - smallest_multiple
  #Range of the spiked reads
  spiked_range <- spiked_max - spiked_min
  
  # Test vector holding all the multiples needed to hit the mean
  multiples_needed <- spiked_mean/data$V3 
  
  #Get the percentage of the range for each value, for later use with the multiple needed
  percentages_raw <- vectorized_spikes - vectorized_small
  percentage_change <- 100.00/max(percentages_raw)
  percentages <- percentages_raw * percentage_change
  
  #Puts the data in the data.frame for later use
  data$V4 <- multiples_needed
  data$V5 <- percentages
  
  # New IDEA: Use the 260 spiked points to estimate the amount necessary that does not hit one of the
  # percentages, take the multiple above it, the multiple below, average, and apply that to the 
  # FASTQ files, should be more accurate
}

