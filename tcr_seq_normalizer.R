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
spiked_files <- list.files(getwd(), pattern = "*_*.txt");
print(spiked_files)
#  Get all the MiTCR files with spiked reads removed in the directory
MiTCR_files <- list.files(getwd(), pattern = "*_*rm.csv");
print(MiTCR_files)

# Go through each file and read in the CSV spiked_reads, skpping the first line which gives no information
# All operations on the spiked_reads will happen inside the for loop, so that it goes through each file
# and each MiTCR file once
for(spike_file in spiked_files) {
  # Get the corresponding MiTCR file to go with the spiked file
  spiked_file_name <- strsplit(spike_file, ".txt");
  corresponding_MiTCR <- match(paste(spiked_file_name,"rm.csv",sep=""), MiTCR_files)
  
  # Opens the matching MiTCR file, if such file exists
  if(!is.na(MiTCR_files[corresponding_MiTCR])){
  MiTCR_file_data <- read.csv(MiTCR_files[corresponding_MiTCR])
  }
  
  spiked_reads <- read.csv(spike_file, header = FALSE, skip = 1);
  #Get the mean from the last column, which is the read count
  spiked_mean <- mean(spiked_reads[[3]])
  
  # Test vector holding all the multiples needed to hit the mean
  multiples_needed <- spiked_mean/spiked_reads$V3 
  
  #Puts the spiked_reads in the spiked_reads.frame for later use
  spiked_reads$V4 <- multiples_needed
  
}

