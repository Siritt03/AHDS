#!/bin/bash

# 创建输出目录
mkdir -p clean

# 输出文件路径
output_file="clean/articles.tsv"

# 初始化输出文件（添加表头）
echo -e "PMID\tYear\tTitle" > "$output_file"

# 从 pmids.xml 文件中提取 PMIDs
pmid_list=$(grep -oP '(?<=<Id>)[^<]+' raw/pmids.xml)

# 遍历每个 PMID
for pmid in $pmid_list; do
    # 找到对应的 XML 文件
    file="raw/article-${pmid}.xml"
    if [[ ! -f "$file" ]]; then
        echo "Warning: $file not found, skipping..."
        continue
    fi

    # 提取文章标题
    title=$(grep -oP '(?<=<ArticleTitle>).*?(?=</ArticleTitle>)' "$file" | sed 's/<[^>]*>//g')

    # 提取出版年份
    year=$(grep -oP '(?<=<PubDate>).*?(?=</PubDate>)' "$file" | grep -oP '\b\d{4}\b')

    # 如果标题或年份为空，跳过该文件
    if [[ -z "$title" || -z "$year" ]]; then
        echo "Warning: Missing title or year for $file, skipping..."
        continue
    fi

    # 写入输出文件
    echo -e "${pmid}\t${year}\t${title}" >> "$output_file"
done

echo "Data processing complete. Extracted data saved to $output_file."

