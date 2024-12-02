# Assessment AHDS

The aim of this mini project is toexplore trends in COVID-19 publications. 
To achieve this, I will download, process and visualize data onthe text of research articles.

Unit Leads: Oliver Davis and Louise Millard.


## Environment

All tasks should be designed to run on BlueCrystal as part of a SnakeMake pipeline.

Install required Python and R packages: 
The environment is recorded in the AHDS_environment.yml file in this directory. 
To create this environment in Conda, use

conda env create --file AHDS_environment.yml
conda activate AHDS_env


## Running the Program

### Step1: Download
Retrieve the IDs of the relevant articles from this URL:

```bash
https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20c ovid%22&retmax=10000
```
```bash
https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=39240571
```
Download PubMed document PMIDs associated with ‘Long COVID’. Download metadata files in XML format for each article by PMID.
#### Output:
An XML file containing all PMIDs:
```bash
raw/pmids.xml
```
Metadata file for each article
```bash
raw/article-<PMID>.xml
```
### Step2: Process

Extract the year and titleof each article and store these in a tab separated file with three columns: PMID, year, and title.
```bash
bash process_articles.sh
```

Remove any xml tags(e.g.<i>and </i>)from the titles.
Remove any rows forarticles that do not have a title.
#### Output:
PMID: unique identification of the article.
Year: year of publication.
Title: title of the article.


### Step3: Tidytext

Process the titles using the tidytext package. 
Removing stop words and digits and reduce words to their stem
```bash
Rscript process_titles.R
```
#### Output:
Text-processed article title data:clean/processed_titles.csv


### Step4: visualisation
Word Frequency Analysis:
This part count the frequency of occurrence of high-frequency words in different years based on the cleaned headline data and generate a trend graph over time.
```bash
Rscript visualize_titles.R
```
#### Output:
Graphs are saved in the visualize directory and are used to show trends in the literature and other analyses.

## Pipeline
The pipeline is managed by a Snakefile in the root directory.

## Github link
```bash
git@github.com:Siritt03/AHDS.git
```

