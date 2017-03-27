# Dockerfile to build Wang et al 2016 RNA-seq pipeline container images
FROM ubuntu:14.04
LABEL maintainer "Wayne Decatur *(fomightez on Github)*"

# Install container-wide requrements gcc, python pip, zlib, libssl, make,
# libncurses, fortran77, g++, unzip, wget, screen #
RUN apt-get update && apt-get install -y libreadline-dev \
   gcc \
   make \
   zlib1g-dev \
   build-essential \
   python2.7-dev \
   python-numpy \
   python-matplotlib \
   python-pip \
   libssl-dev \
   libncurses5-dev \
   gfortran \
   g++ \
   wget \
   curl \
   unzip \
   screen \
   libbz2-dev \
   liblzma-dev \
   libpcre3-dev \
   libcurl4-openssl-dev \
   libgsl0-dev \
   software-properties-common \
   libtbb-dev \
   libicu-dev \
   xorg-dev \
   libxml2-dev \
 && rm -rf /var/lib/apt/lists/*

RUN wget -O /opt/get-pip.py --no-check-certificate https://bootstrap.pypa.io/get-pip.py && \
   python /opt/get-pip.py && \
   rm -f /opt/get-pip.py



# Install Java
# RUN apt-get install -y software-properties-common #moved earlier in Dockerfile
ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN add-apt-repository ppa:openjdk-r/ppa && \
   apt-get update && apt-get install -y openjdk-8-jre \
 && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME


# Install HTSeq
# Python 2.7 installation already handled. Important it be 2.7 because that is
# presently the version HTSeq works with.
#Install HtSeq
RUN curl https://pypi.python.org/packages/source/H/HTSeq/HTSeq-0.6.1.tar.gz#md5=b7f4f38a9f4278b9b7f948d1efbc1f05 > HTSeq-0.6.1.tar.gz && \
   tar -xzf HTSeq-0.6.1.tar.gz && \
   rm -f HTSeq-0.6.1.tar.gz && \
   cd HTSeq-0.6.1 && \
   ls && \
   python setup.py install --user && \
   ln -s $PWD/build/scripts-2.7/htseq-count /bin



# Install SRA Toolkit
WORKDIR /src
RUN wget "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.1-3/sratoolkit.2.8.1-3-ubuntu64.tar.gz" && \
    tar zxfv sratoolkit.2.8.1-3-ubuntu64.tar.gz && \
    rm -f sratoolkit.2.8.1-3-ubuntu64.tar.gz && \
    cp -r sratoolkit.2.8.1-3-ubuntu64/bin/* /usr/bin




#Install FastQC
RUN wget -O /opt/fastqc_v0.11.5.zip http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
RUN unzip /opt/fastqc_v0.11.5.zip -d /opt/
RUN chmod 755 /opt/FastQC/fastqc
RUN ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc
RUN rm -f /opt/fastqc_v0.11.5.zip

#Install Trimmomatic
# installation of JAVA necessary to run Trimmomatic already handled.
# installation of curl, used in code I found already handled.
ENV APP_NAME=Trimmomatic
ENV VERSION=0.36
ENV DEST=/software/applications/$APP_NAME/
ENV PATH=$DEST/$VERSION:$PATH
ENV TRIMMOMATIC=$DEST/$VERSION/trimmomatic-$VERSION.jar
ENV ADAPTERPATH=$DEST/$VERSION/adapters

RUN curl -L -o $APP_NAME-$VERSION.zip \
       http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-$VERSION.zip ; \
    unzip $APP_NAME-$VERSION.zip ; \
    rm -f $APP_NAME-$VERSION.zip ; \
    mkdir -p /usr/share/licenses/$APP_NAME-$VERSION ; \
    cp $APP_NAME-$VERSION/LICENSE /usr/share/licenses/$APP_NAME-$VERSION/ ; \
    mkdir -p $DEST ; \
    mv $APP_NAME-$VERSION  $DEST/$VERSION





#Install SAMTools
RUN wget -q -O /opt/samtools-1.3.1.tar.bz2 https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
    tar xvjf /opt/samtools-1.3.1.tar.bz2 -C /opt/ && \
    cd /opt/samtools-1.3.1;make;make install && \
    rm -f /opt/samtools-1.3.1.tar.bz2



# Install latest TopHat2 and old version of Bowtie2
################################################################################
# specifically TopHat 2.1.1 with Bowtie 2.2.3. That is specifically last
# Bowtie2 version noted as compatible with TopHat2 but unfortunately the last
# information on compatibility was situated down the page somewhat at
# https://ccb.jhu.edu/software/tophat/index.shtml .
################################################################################
# Set working directory in /bin for TopHat 2.1.1 with Bowtie 2.2.3 INSTALL
WORKDIR /bin
# install special Threading Building Blocks library needed for Bowtie2 2.3.0
# RUN apt-get install -y libtbb-dev # MOVED EARLIER IN DOCKERFILE
# Download TopHat2
RUN wget http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz && \
    tar zxvf tophat-2.1.1.Linux_x86_64.tar.gz && \
    rm -f tophat-2.1.1.Linux_x86_64.tar.gz && \
    wget --default-page=bowtie2-2.2.3-linux-x86_64.zip http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.3/bowtie2-2.2.3-linux-x86_64.zip/ && \
    unzip bowtie2-2.2.3-linux-x86_64.zip && \
    rm -f bowtie2-2.2.3-linux-x86_64.zip
# Working directory in Bowtie2
WORKDIR /bin/bowtie2-2.2.3
# Symbolic link from "bowtie" to "bowtie2"
RUN ln -s bowtie2 bowtie
# Change in PATH
ENV PATH $PATH:/bin/tophat-2.1.1.Linux_x86_64
ENV PATH $PATH:/bin/bowtie2-2.2.3





#Install R
# RUN apt-get install -y libicu-dev  #moved earlier in Dockerfile
# RUN apt-get install -y xorg-dev    #moved earlier in Dockerfile
# RUN apt-get install -y libxml2-dev #moved earlier in Dockerfile
RUN add-apt-repository -y "ppa:edd/misc"  && \
   apt-get update && apt-get install -y libpcre3-dev \
 && rm -rf /var/lib/apt/lists/*
# R 3.3.1 is the latest that works with Bioconductor packages for Bioconductor 3.4 (of which DESeq2 is one)
RUN wget -q -O /opt/R-3.3.1.tar.gz https://cran.r-project.org/src/base/R-3/R-3.3.1.tar.gz && \
    tar xvzf /opt/R-3.3.1.tar.gz -C /opt/ && \
    cd /opt/R-3.3.1;./configure;make;make install && \
    rm -f /opt/R-3.3.1.tar.gz

#Install R Packages
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r
RUN echo 'biocLite()' >> /opt/packages.r
RUN echo 'biocLite(c("Rsubread", "dupRadar", "limma", "lattice", "locfit", "edgeR", "chron", "data.table", "gtools", "gdata", "bitops", "caTools", "gplots", "DESeq2", "FactoMineR", "ReportingTools", "pheatmap", "RColorBrewer"))' >> /opt/packages.r
RUN Rscript /opt/packages.r
## Add a library directory (for user-installed packages)
WORKDIR /usr/local/lib/R/site-library



# Making so screen program starts up with Bash shell so that tab-completion and other features work
ENV HOME /root
WORKDIR $HOME
RUN cp /etc/screenrc . && \
    mv screenrc .screenrc && \
    echo -e "# ~/.screenrc\ndefshell -bash      # dash makes it a login shell\n" >> .screenrc


# Retrieve the genome sequence and genome annotation files from the large
# supplemental data archive, unpack it, and copy them to `/genome`, and delete all
# other traces to try and limit the increase in the size of the docker image.
# This eliminates a huge download later just to get two relatively small files.
WORKDIR /genome
RUN wget -O /genome/supp_data.tar.gz http://cgob.ucd.ie/supp_data/supp_data.tar.gz && \
   mkdir dl && \
   tar zxvf /genome/supp_data.tar.gz --directory /genome/dl && \
   rm -f /genome/supp_data.tar.gz  && \
   cp /genome/dl/ngs/data/cpar.fa .  && \
   cp /genome/dl/ngs/data/cpar.gff .  && \
   rm -rf dl

# Default command
WORKDIR /data
CMD ["bash"]
