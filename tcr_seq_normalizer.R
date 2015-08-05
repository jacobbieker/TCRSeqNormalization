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
  vectorized_spikes <- data$V3
  vectorized_large <- max(vectorized_spikes)
  vectorized_small <- min(vectorized_spikes)
  vectorized_range <- vectorized_large - vectorized_small
  # Get change per number in range for multiple
  delta_multiple <- multiple_range/spiked_range
  # Convert to change per percentage
  percentage_per_number_in_range <- 100.00/spiked_range
  # Divide delta by percentage to get the change per 1 percent of the range
  delta_per_one_percent <- delta_multiple/percentage_per_number_in_range
  
  #Get percentages from range of FASTQ file (for now just spiked reads)
  fastq_percentage_per_step <- 100.00/vectorized_range
  
  #IDEA: go through vector/data.frame, get difference between smallest value and current value
  # Multiply by the difference and (fastq_percentage_per_step * delta_per_one_percent)
  result_vector <- sapply(vectorized_spikes, function(x) FUN = (x) * (fastq_percentage_per_step * delta_per_one_percent))
  
  final_values <- rev(result_vector) * vectorized_spikes
  #TODO: Check if range is 0, if so, do nothing for
}

