#!/bin/bash

mkdir -p raw

# Step 1: Download PMIDs for articles on long COVID
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" > raw/pmids.xml

# Parse the PMIDs from the XML
grep -oP '(?<=<Id>)[^<]+' raw/pmids.xml > raw/pmids.txt

# Step 2: Download article metadata for each PMID
while IFS= read -r pmid; do
    echo "Downloading metadata for PMID: $pmid"
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > "raw/article-${pmid}.xml"
    sleep 1 # Pause to avoid overwhelming the server
done < raw/pmids.txt
