library(tidyverse)
library(tidytext)

system("mkdir -p visualize")

input_file <- "clean/titles_grouped.tsv"
output_plot <- "visualize/word_frequency_plot.png"

if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

data <- read_tsv(input_file)

if (!all(c("PMID", "Year", "processed_title") %in% colnames(data))) {
  stop("The input file must contain 'PMID', 'Year', and 'processed_title' columns.")
}

processed_data <- data %>%
  unnest_tokens(word, processed_title)

top_words <- processed_data %>%
  count(word, sort = TRUE) %>%
  slice_head(n = 10) %>%  
  pull(word)  

filtered_data <- processed_data %>%
  count(Year, word) %>%  
  filter(word %in% top_words, Year <= 2024)

plot <- ggplot(filtered_data, aes(x = Year, y = n, color = word)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Top 10 Words by Frequency Over Time",
       x = "Year",
       y = "Frequency (Absolute)",
       color = "Words") +
  theme_minimal()

ggsave(output_plot, plot = plot, width = 10, height = 6)

cat("Visualization saved to:", output_plot, "\n")

