FROM ubuntu:22.04

LABEL author="Michael Mansfield michael.mansfield@oist.jp"
LABEL version="4.3.1"

# Download some dependencies
ARG DEBIAN_FRONTEND=noninteractive
 RUN apt update && \
	apt install -y wget \
		bzip2 && \
	apt autoremove --purge --yes && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

# Install conda and update it
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
	/bin/bash ~/miniconda.sh -b -p /opt/conda && \
	rm ~/miniconda.sh && \
	/opt/conda/bin/conda clean -tipsy && \
	ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
	echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
	echo "conda activate base" >> ~/.bashrc
CMD [ "/bin/bash" ]
RUN conda update -n base -c defaults conda

# Install NOVOPlasty and create mount points for config file
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/novoplasty/bin:"${PATH}"
WORKDIR /work
