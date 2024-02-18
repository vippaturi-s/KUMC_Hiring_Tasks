# Load necessary library for reading gzipped files
library(data.table)

# Function to load gene info and create mapping of symbols to Entrez IDs
load_gene_info <- function(gene_info_file) {
  gene_mapping <- data.table::fread(cmd=paste0("gunzip -c ", gene_info_file), header=FALSE, sep="\t", select=c(2, 3, 5))
  setnames(gene_mapping, c("GeneID", "Symbol", "Synonyms"))
  
  # Expand synonyms into separate rows
  gene_mapping <- gene_mapping[, .(GeneID, Symbol = unlist(strsplit(Symbol, "|", fixed = TRUE))), by = 1:nrow(gene_mapping)]
  
  return(gene_mapping)
}

# Function to replace symbols with Entrez IDs in GMT file
replace_symbols_with_entrez <- function(gmt_file, gene_mapping, output_file) {
  gmt_data <- readLines(gmt_file)
  
  # Process each line in the GMT file
  updated_gmt_lines <- sapply(gmt_data, function(line) {
    fields <- unlist(strsplit(line, "\t", fixed = TRUE))
    pathway_name <- fields[1]
    pathway_desc <- fields[2]
    genes_symbols <- fields[-c(1, 2)]
    
    # Replace symbols with Entrez IDs
    entrez_ids <- sapply(genes_symbols, function(symbol) {
      mapped_id <- gene_mapping[Symbol == symbol, "GeneID"]
      if (length(mapped_id) > 0) {
        return(mapped_id)
      } else {
        warning(paste("Warning: Gene symbol '", symbol, "' not found in mapping."))
        return(NULL)
      }
    })
    
    return(paste(pathway_name, pathway_desc, paste(unlist(entrez_ids), collapse = "\t"), sep = "\t"))
  })
  
  # Write updated pathway information to output file
  writeLines(updated_gmt_lines, output_file)
}

# Main function
main <- function() {
  gene_info_file <- "/Users/sravanisaadhu/Desktop/Data_Files/hiring_task/Homo_sapiens.gene_info.gz"
  gmt_file <- "/Users/sravanisaadhu/Desktop/Data_Files/hiring_task/h.all.v2023.1.Hs.symbols.gmt"
  output_file <- "/Users/sravanisaadhu/Desktop/Data_Files/output_entrez_ids.gmt"
  
  # Step 1: Load gene info and create mapping of symbols to Entrez IDs
  gene_mapping <- load_gene_info(gene_info_file)
  
  # Step 2: Replace symbols with Entrez IDs in GMT file
  replace_symbols_with_entrez(gmt_file, gene_mapping, output_file)
}

# Run the main function
main()
