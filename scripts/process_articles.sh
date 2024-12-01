#!/bin/bash

mkdir -p clean

output_file="clean/articles.tsv"

echo -e "PMID\tYear\tTitle" > "$output_file"

pmid_list=$(grep -oP '(?<=<Id>)[^<]+' raw/pmids.xml)

for pmid in $pmid_list; do
    file="raw/article-${pmid}.xml"
    if [[ ! -f "$file" ]]; then
        echo "Warning: $file not found, skipping..."
        continue
    fi

    title=$(grep -oP '(?<=<ArticleTitle>).*?(?=</ArticleTitle>)' "$file" | sed 's/<[^>]*>//g')

    year=$(grep -oP '(?<=<PubDate>).*?(?=</PubDate>)' "$file" | grep -oP '\b\d{4}\b')

    if [[ -z "$title" || -z "$year" ]]; then
        echo "Warning: Missing title or year for $file, skipping..."
        continue
    fi


    echo -e "${pmid}\t${year}\t${title}" >> "$output_file"
done

echo "Data processing complete. Extracted data saved to $output_file."

