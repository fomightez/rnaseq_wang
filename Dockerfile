FROM ubuntu:14.04
MAINTAINER Wayne Decatur *(fomightez on Github)*

#Install container-wide requrements gcc, python pip, zlib, libssl, make, libncurses, fortran77, g++,wget#
RUN apt-get update
RUN apt-get install -y libreadline-dev
RUN apt-get install -y gcc
RUN apt-get install -y make
RUN apt-get install -y zlib1g-dev
RUN apt-get install --yes build-essential python2.7-dev python-numpy python-matplotlib python-pip
RUN apt-get install -y libssl-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y gfortran
RUN apt-get install -y g++
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libgsl0-dev
RUN wget -O /opt/get-pip.py --no-check-certificate https://bootstrap.pypa.io/get-pip.py
RUN python /opt/get-pip.py
RUN rm /opt/get-pip.py



# Install Java
RUN apt-get install -y software-properties-common
RUN apt-get install -y unzip
ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install -y openjdk-8-jre

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME




# Install SRA Toolkit
WORKDIR /src
RUN wget "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.1-3/sratoolkit.2.8.1-3-ubuntu64.tar.gz" && \
    tar zxfv sratoolkit.2.8.1-3-ubuntu64.tar.gz && \
    cp -r sratoolkit.2.8.1-3-ubuntu64/bin/* /usr/bin




#Install FastQC
RUN wget -O /opt/fastqc_v0.11.5.zip http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
RUN unzip /opt/fastqc_v0.11.5.zip -d /opt/
RUN chmod 755 /opt/FastQC/fastqc
RUN ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc
RUN rm /opt/fastqc_v0.11.5.zip

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




# Install HTSeq
# Python 2.7 installation already handled. Important it be 2.7 because that is
# presently the version HTSeq works with.
#Install HtSeq
RUN curl https://pypi.python.org/packages/source/H/HTSeq/HTSeq-0.6.1.tar.gz#md5=b7f4f38a9f4278b9b7f948d1efbc1f05 > HTSeq-0.6.1.tar.gz && \
   tar -xzf HTSeq-0.6.1.tar.gz && \
   rm HTSeq-0.6.1.tar.gz && \
   cd HTSeq-0.6.1 && \
   ls && \
   python setup.py install --user


#Install SAMTools
RUN wget -q -O /opt/samtools-1.3.1.tar.bz2 https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN tar xvjf /opt/samtools-1.3.1.tar.bz2 -C /opt/
RUN cd /opt/samtools-1.3.1;make;make install
RUN rm /opt/samtools-1.3.1.tar.bz2



# Install Bowtie2 and TopHat2
# specifically TopHat 2.1.1 with Bowtie 2.3.0
# Set working directory in /bin for TopHat 2.1.1 with Bowtie 2.3.0 INSTALL
WORKDIR /bin
# install special Threading Building Blocks needed for newest Bowtie2
RUN apt-get install -y libtbb-dev
# Download TopHat2
RUN wget http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz
# Download Bowtie2
RUN wget --default-page=bowtie2-2.3.0-linux-x86_64.zip http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.0/bowtie2-2.3.0-linux-x86_64.zip/
# Unzip the archive
RUN tar zxvf tophat-2.1.1.Linux_x86_64.tar.gz
# Remove the archive
RUN rm tophat-2.1.1.Linux_x86_64.tar.gz
# Unzip the archive
RUN unzip bowtie2-2.3.0-linux-x86_64.zip
# Remove the archive
RUN rm bowtie2-2.3.0-linux-x86_64.zip
# Working directory in Bowtie2
WORKDIR /bin/bowtie2-2.3.0
# Symbolic link from "bowtie" to "bowtie2"
RUN ln -s bowtie2 bowtie
# Change in PATH
ENV PATH $PATH:/bin/tophat-2.1.1.Linux_x86_64
ENV PATH $PATH:/bin/bowtie2-2.3.0




#Install R
RUN apt-get install -y libicu-dev
RUN apt-get install -y xorg-dev
RUN add-apt-repository -y "ppa:edd/misc"
RUN apt-get update
RUN apt-get install -y libpcre3-dev
RUN wget -q -O /opt/R-3.3.2.tar.gz https://cran.r-project.org/src/base/R-3/R-3.3.2.tar.gz
RUN tar xvzf /opt/R-3.3.2.tar.gz -C /opt/
RUN cd /opt/R-3.3.2;./configure;make;make install
RUN rm /opt/R-3.3.2.tar.gz

#Install R Packages
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r
RUN echo 'biocLite()' >> /opt/packages.r
RUN echo 'biocLite(c("Rsubread", "dupRadar", "limma", "lattice", "locfit", "edgeR", "chron", "data.table", "gtools", "gdata", "bitops", "caTools", "gplots", "DESeq2", "FactoMineR", "ReportingTools"))' >> /opt/packages.r
RUN Rscript /opt/packages.r
RUN mkdir /usr/local/lib/R/site-library


# Default command
WORKDIR /data
CMD ["bash"]
