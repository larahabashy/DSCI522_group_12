# install base R & tidyverse
FROM rocker/tidyverse

# check for updates
RUN apt-get update

# install python3 & virtualenv
RUN apt-get install -y \
		python3-pip \
		python3-dev \
	&& pip3 install virtualenv

# install anaconda & put it in the PATH
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh 
ENV PATH /opt/conda/bin:$PATH

# install python packages
RUN conda install --quiet --yes \
    'docopt=0.6.*' \
    'conda-forge::arrow=0.*' 

RUN pip install --quiet \
    'pyarrow==2.0.*' \
    'feather-format==0.4.*'
    
# install R packages
RUN apt-get update -qq && install2.r --error \
    --deps TRUE \
    caret \
    pacman \
    feather \
    ggthemes
