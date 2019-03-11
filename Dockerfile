FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

#Versions
ARG python_version=3.7

# Update package list and install dependencies
RUN apt-get -qq update && \
    apt-get -y install sudo && \
    apt-get -qq install -y --no-install-recommends build-essential \
    ca-certificates libgtk2.0-0 sqlite3 wget git libhdf5-dev g++ graphviz unzip x11-apps sudo && \
    apt-get -qq clean
    
    
      # Install conda (Usar Miniconda3 se python 3)
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && rm /tmp/miniconda.sh
    
    
    # Set PATH and PYTHONPATH environmental variables 
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH    
ENV PYTHONPATH='/project/:$PYTHONPATH'


# Add generic user 'developer' (with root priveleges)
# Set-up for x11 local-ec2-docker
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
    mkdir -p $CONDA_DIR && \
    chown developer $CONDA_DIR -R && \
    mkdir -p /project && \
    chown developer /project

# Install Python libraries 
RUN conda update -n base conda &&\
    conda install --quiet --yes python=${python_version} &&\
    conda install tensorflow-gpu keras opencv Pillow scikit-learn notebook pandas matplotlib mkl nose  pyyaml six h5py pygpu && \
    conda clean -yt   

RUN apt-get update && apt-get install sudo

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
ENV HOME /home/docker

WORKDIR /home/docker/
