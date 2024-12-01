# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Load required libraries, install if missing
if (!requireNamespace("tidyverse", quietly = TRUE)) {
    install.packages("tidyverse")
}
if (!requireNamespace("tidytext", quietly = TRUE)) {
    install.packages("tidytext")
}


library(tidyverse)
library(tidytext)
library(SnowballC)

input_file <- "clean/articles.tsv"
output_file <- "clean/titles_grouped.tsv"

if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

data <- read_tsv(input_file)

if (!all(c("PMID", "Year", "Title") %in% colnames(data))) {
  stop("The input file must contain 'PMID', 'Year', and 'Title' columns.")
}

processed_data <- data %>%
  unnest_tokens(word, Title) %>%  
  anti_join(stop_words, by = "word") %>%  
  filter(!str_detect(word, "^[0-9]+$")) %>%  
  mutate(word = wordStem(word)) 

grouped_data <- processed_data %>%
  group_by(PMID, Year) %>%
  summarize(processed_title = paste(word, collapse = " "), .groups = "drop")

write_tsv(grouped_data, output_file)

cat("Grouped titles saved to:", output_file, "\n")


