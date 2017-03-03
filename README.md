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
* Trimmomatic (Skewer was actually used to do this function in Wang et al. 2016)
* HTSeq
* Bowtie2
* TopHat
* R
* Bioconductor and needed packages

*Specific versions and sources are made clear in [the Dockerfile](https://github.com/fomightez/rnaseq_wang/blob/master/Dockerfile).*  
*See [here](http://tophat2-and-bowtie-compatibility.readthedocs.io/en/latest/) and [here](http://r-and-bioconductor-compatibility.readthedocs.io/en/latest/) for additional information related to versions.*

Requirements
------------

As far as I know, the only requirement is a working installation of Docker on your machine where you want to work. If that is not possible on your local computer, you could always access a Linux-based instance from your local computer.

Overall steps
-------------

You'll need two things:

* a running Docker container derived from this image with all necessary software already set up

* the data to perform the anlaysis on

Usage
-----

1. Get the container based on the image running.

	(Because the data files are large, you may want to at least start that download at this point. See below. While that is downloading, you can also be setting up the Docker container.)

	If you haven't already, make a directory called `data` on local machine upon which you'll be running Docker. This is a directory where you'll place your data. Make a note of the path. For example, on my Mac I made it with the path `/Users/Wayne/data`. You can use your graphical OS or a command line to make the local directory. Doesn't matter how as long as you make one to serve as where you link the `data` directory within your container by binding a volume.

	Then in your terminal issue the command to get and run the container

		docker run -v /Users/Wayne/data:/data -it fomightez/rnaseqwang

	, where you replace `/Users/Wayne/data` part with the full path of your local `data` directory.

	After that `docker run` command gets the image and initiates it running. you'll then end up with a command line prompt that looks sort of like this

			root@e84005c430c8:/data#

	The `e84005c430c8` string will be something else, but this means your are actually in your Docker container ready to go.

	Any time you need to get back to the command line of your local computer. You can just type `exit` to leave the container, but stay there for now.

	If you type `ls` to list the files present in the current directory and see nothing, continue on to step #2. If you already have the data in your local `data` directory on your computer, you should see it in `/data` directory within your container.

2. Download the data.
