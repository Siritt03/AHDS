options(repos = c(CRAN = "https://cloud.r-project.org"))
# Load necessary libraries
library(tidyverse)
library(tidytext)
library(SnowballC)

# Define input and output file paths
input_file <- "clean/articles.tsv"
output_file <- "clean/titles_grouped.tsv"

# Check if the input file exists
if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

# Read the data
data <- read_tsv(input_file)

# Ensure the data contains the required columns
if (!all(c("PMID", "Year", "Title") %in% colnames(data))) {
  stop("The input file must contain 'PMID', 'Year', and 'Title' columns.")
}

# Tokenize and process: remove stop words, numbers, and perform stemming
processed_data <- data %>%
  unnest_tokens(word, Title) %>%  
  anti_join(stop_words, by = "word") %>%  
  filter(!str_detect(word, "^[0-9]+$")) %>%  
  mutate(word = wordStem(word))  

# Group words by PMID and Year into "processed_title"
grouped_data <- processed_data %>%
  group_by(PMID, Year) %>%
  summarize(processed_title = paste(word, collapse = " "), .groups = "drop")

# Save the result to a new file
write_tsv(grouped_data, output_file)

# Print completion message
cat("Grouped titles saved to:", output_file, "\n")


