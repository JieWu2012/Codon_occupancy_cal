# Codon_occupancy_cal
This code is for calculating the relative codon occupancy in the analysis of ribosome profiling data. 

"Codon_occupancy_cal.sh" script acceptes the mapping results (SAM format) and sequence of CDS (Fasta format) as input and it outputs the occupancy of each codon. Make sure the CDS fasta file matches the reference you used to map the Ribo-seq reads.  And use the following command: 

Codon_occupancy_cal.sh hg38_CDS_example.fa Mapped.sam


This code is under continual development and further updates will be posted here. 
