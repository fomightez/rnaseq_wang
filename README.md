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

	After that gets the image and kicks off running it. you'll then end up with a command line prompt that looks sort of like this

			root@e84005c430c8:/data#

	The `e84005c430c8` string will be something else, but this means your are actually in your Docker container ready to go.

	Any time you need to get back to the command line of your local computer. You can just type `exit` to leave the container, but stay there for now.

	If you type `ls` to list the files present in the current directory and see nothing, continue on to step #2. If you already have the data in your local `data` directory on your computer, you should see it in `/data` directory within your container.



2. Download the data.

	Using your browser or another window of command line interface with the wget or curl command, download the `supp_data.tar.gz` file from http://cgob.ucd.ie/supp_data/supp_data.tar.gz .

	If you get the data from there it will also have the output files generated by working through the steps in the Wang et al 2016 example analysis.

	Alternatively, you can get just the raw data from the Short Read Archive (SRA). This is not the recommended route for this case and is an effort not for the faint hearted, but using the SRA and Gene Expression Omnibus (GEO) or European Nucleotide Archive (ENA) resources might be important to you later for getting public data. Our campus network makes the route using the SRA Toolkit difficult/impossible. Your mileage may vary. The individual reads are stored in the SRA under accession number SRP041812. The dataset is under the GEO accession number GSE57451. Adapt the information [here](http://fenglabwkshopmay2015.readthedocs.io/en/latest/Get%20a%20ChIP-Seq%20dataset/#obtaining-a-fastq-file-using-the-sra-toolkit) to suit this data set. You can disregard the information about where to work though, and you may wish to look at the information earlier on that page too.

	For ease in referencing the locale, I suggest keeping the data in a folder called `data` on your system and these steps assume you did that. Feel free to deviate and adapt the commands to match where you have placed the data.

	Make a directory called `data` on local machine upon which you'll be running Docker. This is a directory where you'll place your data. Make a note of the path. For example, on my Mac I made it with the path `/Users/Wayne/data`. You can use your graphical OS or a command line to make the local directory. Doesn't matter how as long as you make one to serve as where you link the `data` directory within your container by binding a volume.

	However you aquire the data, move it into that folder. If you obtained the data as the `supp_data.tar.gz` file you'll need to uncompress it. Because it contains all the output files generated as well. I suggest sticking in with a directory called `dl` within the `data` directory`. Move the raw reads back out to `data` with the following commands

	PUT COMMANDS TO DO THAT HERE

	If you have your Docker container running in a terminal window, switch to it. If you exited, start it back up with

		docker run -v /Users/Wayne/data:/data -it fomightez/rnaseqwang

	again. Assuming you already did step #1, it will be instantaneous to restart because it has all the needed information on your local system already.

	Remember any time you need to get back to the command line of your local computer. You can just type `exit` to leave the container, and you can always restart the Docker container with

		docker run -v /Users/Wayne/data:/data -it fomightez/rnaseqwang

	You'll need a running contianer to continue on.







Building the image
------------------

If for some reason you wanted Docker to use the [Dockerfile](https://github.com/fomightez/rnaseq_wang/blob/master/Dockerfile) to build locally, the command is

	docker build -t YOURchoiceOFname .

, where `YOURchoiceOFname` part gets replaced with what you'd like to call.

It is easier to just get the already built image from Docker hub though, see the `Usage` section.
