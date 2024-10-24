# Use the GDAL base image
FROM ghcr.io/osgeo/gdal:ubuntu-small-3.8.5

# Install dependencies and JupyterHub
RUN apt-get update && apt-get install -y \
    curl \
    python3-dev \
    python3-pip \
    nodejs \
    npm \
    && pip3 install --upgrade pip

# Install JupyterHub and required Python packages
RUN pip install --no-cache \
    notebook \
    oauthenticator \
    dockerspawner \
    jupyterhub \
    jupyterhub-nativeauthenticator
    
# Install the JupyterHub proxy
RUN npm install -g configurable-http-proxy

# Copy JupyterHub configuration file
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# Expose port 8000 for JupyterHub
EXPOSE 8000

# Set up command to run JupyterHub
CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]

