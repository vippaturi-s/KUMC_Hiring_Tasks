#!/bin/bash

# Download the protein FASTA file
wget -O NC_000913.faa https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa

# Extract the lengths of proteins
protein_lengths=$(awk '/^>/ {print length(seq); seq=""; next} { seq = seq $0 } END { print length(seq) }' NC_000913.faa | grep -v '^$')

# Calculate the total length and count of proteins
total_length=0
count=0
for length in $protein_lengths; do
    total_length=$((total_length + length))
    count=$((count + 1))
done

# Calculate the average length
average_length=$(echo "scale=2; $total_length / $count" | bc)

echo "Average length of proteins in E. coli MG1655: $average_length"

