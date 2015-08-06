# Designed and developed by Jacob Bieker (jacob@bieker.tech)

# Script reads in a csv file containing spiked read counts from TCR sequencing, and calculates the 
# what number is needed to change the counts of each spiked read to the mean. 
# Using the spiked reads, it finds the corresponding VJ region in a MiTCR-formatted CSV file
# It then normalizes the count for each region in the MiTCR file using the multiples from the spikes
#
# Assumptions:
#   1.  A CSV file, named "<MiTCR File>xout.csv" per MiTCR file of the format ID,spike,count
#   2.  A MiTCR csv file per CSV file
#   3.  A CSV file detailing the barcode-to-VJ-region 
#   4.  Spiked reads are supposed to be present in the exact same frequency

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
  
  # Test vector holding all the multiples needed to hit the mean
  multiples_needed <- spiked_mean/data$V3 
  
  #Puts the data in the data.frame for later use
  data$V4 <- multiples_needed
  
}

