# T-Cell Receptor Normalizer
This script is designed to take CSV files from MiTCR and a CSV file of the counts of spiked reads and normalizes the MiTCR output based off those spiked reads.

# Assumptions
1. All files in use share a common base name, for example: "S4_R1" for the foreward read and "S4_R2" for the backwards read
2. The spiked read file is a CSV file with the ".txt" extension, and is formatted as follow:

    <ID>,<barcode-sequence>,<count>,<V segment>,<J segment>
    

# Usage
Have a CSV file, with a ".txt" extension, 
