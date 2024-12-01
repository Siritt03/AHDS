#!/bin/bash

# Creating an output directory
mkdir -p clean

# Output file path
output_file="clean/articles.tsv"

# Initialise the output file 
echo -e "PMID\tYear\tTitle" > "$output_file"

# Extracted from pmids.xml file
pmid_list=$(grep -oP '(?<=<Id>)[^<]+' raw/pmids.xml)

# Iterate through each PMID
for pmid in $pmid_list; do
    # Find the corresponding XML file
    file="raw/article-${pmid}.xml"
    if [[ ! -f "$file" ]]; then
        echo "Warning: $file not found, skipping..."
        continue
    fi

    # Extract relevant fields
    title=$(grep -oP '(?<=<ArticleTitle>).*?(?=</ArticleTitle>)' "$file" | sed 's/<[^>]*>//g')
    year=$(grep -oP '(?<=<PubDate>).*?(?=</PubDate>)' "$file" | grep -oP '\b\d{4}\b')

    # If the title or year is empty, skip the document
    if [[ -z "$title" || -z "$year" ]]; then
        echo "Warning: Missing title or year for $file, skipping..."
        continue
    fi

    # Write to output file
    echo -e "${pmid}\t${year}\t${title}" >> "$output_file"
done

echo "Data processing complete. Extracted data saved to $output_file."

