library(tidyverse)
library(tidytext)

# 调用 Shell 命令创建目录
system("mkdir -p visualize")

# 定义输入和输出路径
input_file <- "clean/titles_grouped.tsv"
output_plot <- "visualize/word_frequency_plot.png"

# 检查文件是否存在
if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

# 读取数据
data <- read_tsv(input_file)

# 检查列名是否正确
if (!all(c("PMID", "Year", "processed_title") %in% colnames(data))) {
  stop("The input file must contain 'PMID', 'Year', and 'processed_title' columns.")
}

# 分词：将 processed_title 列拆分为单词
processed_data <- data %>%
  unnest_tokens(word, processed_title)

# 按单词计算总频率并选出前 10 个高频单词
top_words <- processed_data %>%
  count(word, sort = TRUE) %>%
  slice_head(n = 10) %>%  # 选取频率最高的 10 个单词
  pull(word)  # 提取单词列表

# 筛选出高频单词的数据
filtered_data <- processed_data %>%
  count(Year, word) %>%  # 计算每个单词在每年的出现次数
  filter(word %in% top_words, Year <= 2024)

# 绘制图表
plot <- ggplot(filtered_data, aes(x = Year, y = n, color = word)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Top 10 Words by Frequency Over Time",
       x = "Year",
       y = "Frequency (Absolute)",
       color = "Words") +
  theme_minimal()

# 保存图表
ggsave(output_plot, plot = plot, width = 10, height = 6)

cat("Visualization saved to:", output_plot, "\n")

