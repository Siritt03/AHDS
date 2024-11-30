# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Load required libraries, install if missing
if (!requireNamespace("tidyverse", quietly = TRUE)) {
    install.packages("tidyverse")
}
if (!requireNamespace("tidytext", quietly = TRUE)) {
    install.packages("tidytext")
}

# 加载必要的库
library(tidyverse)
library(tidytext)
library(SnowballC)

# 定义输入和输出文件路径
input_file <- "clean/articles.tsv"
output_file <- "clean/titles_grouped.tsv"

# 检查输入文件是否存在
if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

# 读取数据
data <- read_tsv(input_file)

# 确保数据包含必要的列
if (!all(c("PMID", "Year", "Title") %in% colnames(data))) {
  stop("The input file must contain 'PMID', 'Year', and 'Title' columns.")
}

# 分词并处理：移除停用词、数字，并进行词干化
processed_data <- data %>%
  unnest_tokens(word, Title) %>%  # 将 Title 列拆分为单词
  anti_join(stop_words, by = "word") %>%  # 移除停用词
  filter(!str_detect(word, "^[0-9]+$")) %>%  # 移除纯数字
  mutate(word = wordStem(word))  # 词干化

# 按 PMID 和 Year 拼接单词为 "processed_title"
grouped_data <- processed_data %>%
  group_by(PMID, Year) %>%
  summarize(processed_title = paste(word, collapse = " "), .groups = "drop")

# 保存结果到新文件
write_tsv(grouped_data, output_file)

# 输出完成信息
cat("Grouped titles saved to:", output_file, "\n")


