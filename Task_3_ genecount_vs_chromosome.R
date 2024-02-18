# Load required libraries
library(ggplot2)

# Read the data
gene_info <- read.delim("/Users/sravanisaadhu/Desktop/Data_Files_1/hiriing_task2/Homo_sapiens.gene_info.gz", header = TRUE, stringsAsFactors = FALSE)

# Filter out rows with ambiguous chromosome values
gene_info <- gene_info[!grepl("\\|", gene_info$chromosome), ]
gene_info <- gene_info[!grepl("^a \\|", gene_info$chromosome), ]

# Count the number of genes per chromosome
gene_counts <- table(gene_info$chromosome)

# Convert to data frame
gene_counts <- data.frame(chromosome = names(gene_counts), count = as.numeric(gene_counts))

# Plot
pdf("/Users/sravanisaadhu/Desktop/Data_Files_1/hiriing_task2/gene_counts_per_chromosome.pdf", width = 8, height = 4)
chromosome_order <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", 
                      "11", "12", "13", "14", "15", "16", "17", "18", "19", 
                      "20", "21", "22", "X", "Y", "MT", "Un")
gene_counts$chromosome <- factor(gene_counts$chromosome, levels = chromosome_order)

# Order the data frame by this chromosome order
gene_counts <- gene_counts[order(factor(gene_counts$chromosome, levels = chromosome_order)), ]

# Plot
ggplot(gene_counts, aes(x = chromosome, y = count)) +
  geom_bar(stat = "identity", fill = "black") +
  labs(title = "Number of genes in each chromosome",
       x = "Chromosomes",
       y = "Gene count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        plot.title = element_text(hjust = 0.5)) # Center the plot title
dev.off()
