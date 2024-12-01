library(tidyverse)
library(tidytext)

# Execute shell command to create a directory
system("mkdir -p visualize")

# Define input and output file paths
input_file <- "clean/titles_grouped.tsv"
output_plot <- "visualize/word_frequency_plot.png"

# Check if the input file exists
if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

# Read the data
data <- read_tsv(input_file)

# Check if the column names are correct
if (!all(c("PMID", "Year", "processed_title") %in% colnames(data))) {
  stop("The input file must contain 'PMID', 'Year', and 'processed_title' columns.")
}

# Tokenize: Split the processed_title column into individual words
processed_data <- data %>%
  unnest_tokens(word, processed_title)

# Calculate total frequency for each word and select the top 10 most frequent words
top_words <- processed_data %>%
  count(word, sort = TRUE) %>%
  slice_head(n = 10) %>%  # Select the top 10 most frequent words
  pull(word)  # Extract the list of words

# Filter the data to include only high-frequency words
filtered_data <- processed_data %>%
  count(Year, word) %>%  # Calculate the frequency of each word by year
  filter(word %in% top_words, Year <= 2024)

# Create a plot
plot <- ggplot(filtered_data, aes(x = Year, y = n, color = word)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Top 10 Words by Frequency Over Time",
       x = "Year",
       y = "Frequency (Absolute)",
       color = "Words") +
  theme_minimal()

# Save the plot
ggsave(output_plot, plot = plot, width = 10, height = 6)

cat("Visualization saved to:", output_plot, "\n")

