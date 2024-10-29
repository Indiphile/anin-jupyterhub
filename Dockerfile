# Use the GDAL base image
FROM ghcr.io/osgeo/gdal:ubuntu-small-3.8.5

ENV SHELL=bash \
    DEBIAN_FRONTEND=non-interactive \
    USE_PYGEOS=0 \
    SPATIALITE_LIBRARY_PATH='mod_spatialite.so'
# Install dependencies and JupyterHub
RUN apt-get update && apt-get install -y \
    curl \
    python3-dev \
    python3-pip \
    nodejs \
    npm \
    postgresql-client \
    postgresql \
    less \
    wget \
    vim \
    tmux \
    htop \
    fish \
    tig \
    git \
    jq \
    xz-utils \
    zip \
    unzip \
    file \
    time \
    openssh-client \
    graphviz \
    sudo \
    iproute2 \
    iputils-ping \
    net-tools \
    simpleproxy \
    rsync \
    libtiff-tools \
    # rgsislib dependencies
    libboost-date-time1.74.0 \
    libboost-dev \
    libboost-filesystem1.74.0 \
    libboost-system1.74.0 \
    libcgal-dev \
    libgsl-dev \
    libgeos-dev \
    libmuparser2v5 \
    libpq-dev \
    libproj-dev \
    # for cython to work need compilers
    build-essential \
    # for pyRAT install or something
    libfftw3-dev \
    liblapack-dev \
    # install libhdf5
    libhdf5-serial-dev \
    # install ffmpeg the normal way
    ffmpeg \
    # Spatialite support
    libsqlite3-mod-spatialite \
    nodejs \
    # install texlive
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    && pip3 install --upgrade pip \
    && apt-get clean autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache}/


# Install tini
RUN wget -O /bin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini && \
    chmod +x /bin/tini

# Install yq
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# install pandoc 3.4.1
RUN wget https://github.com/jgm/pandoc/releases/download/3.4/pandoc-3.4-1-amd64.deb \
    && apt --fix-broken install \
    && dpkg -i pandoc-3.4-1-amd64.deb \
    && rm pandoc-3.4-1-amd64.deb

COPY requirements.txt /
COPY datacube.conf /

RUN python -m pip install --upgrade pip pip-tools
RUN pip install --no-cache-dir -r requirements.txt

# Install JupyterHub and required Python packages
RUN pip install --no-cache \
    notebook \
    oauthenticator \
    dockerspawner \
    jupyterhub \
    jupyterhub-nativeauthenticator

# activate datacube 
RUN datacube system init


# Install the JupyterHub proxy
RUN npm install -g configurable-http-proxy

# Copy JupyterHub configuration file
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# Expose port 8000 for JupyterHub
EXPOSE 8000

# Set up command to run JupyterHub
CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]

