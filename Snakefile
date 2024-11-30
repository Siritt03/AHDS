# 最终生成的目标
rule all:
    input:
        "visualize/word_frequency_plot.png"

# 规则 1: 下载数据
rule download:
    output:
        "raw/pmids.xml"
    shell:
        """
        bash scripts/download_articles.sh
        """

# 规则 2: 提取数据
rule extract:
    input:
        "raw/pmids.xml"
    output:
        "clean/articles.tsv"
    shell:
        """
        bash scripts/process_articles.sh
        """

# 规则 3: 清洗数据
rule tidytext:
    input:
        "clean/articles.tsv"
    output:
        "clean/titles_grouped.tsv"
    shell:
        """
        Rscript scripts/process_titles.R
        """

# 规则 4: 可视化数据
rule visualisation:
    input:
        "clean/titles_grouped.tsv"
    output:
        "visualize/word_frequency_plot.png"
    shell:
        """
        Rscript scripts/visualize_titles.R
        """

