[![](https://images.microbadger.com/badges/image/fomightez/rnaseqwang.svg)](https://microbadger.com/images/fomightez/rnaseqwang "Get your own image badge on microbadger.com")  

# rnaseq_wang
Docker container for RNA-seq pipeline as described in [Wang et al 2016 (PMID: 26483013)](https://www.ncbi.nlm.nih.gov/pubmed/26483013)


[The Docker image is available](https://hub.docker.com/r/fomightez/rnaseqwang/) at Docker Hub.

Contents
--------

Complete Linux-based container for all command line processing as directed in:  

Using RNA-seq for Analysis of Differential Gene Expression in Fungal Species.
Wang C, Schröder MS, Hammel S, Butler G.
Methods Mol Biol. 2016;1361:1-40. doi: 10.1007/978-1-4939-3079-1_1. PMID: [26483013](https://www.ncbi.nlm.nih.gov/pubmed/26483013)


Includes:

* Ubunutu base
* JAVA
* Python 2.7 (version necessary for HTSeq)
* SRA Toolkit
* FASTQC
* Trimmomatic
* HTSeq
* Bowtie2
* TopHat
* R
* Bioconductor and needed packages

*Specific versions and sources are made clear in [the Dockerfile](https://github.com/fomightez/rnaseq_wang/blob/master/Dockerfile).*
