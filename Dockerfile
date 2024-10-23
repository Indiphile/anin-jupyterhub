FROM quay.io/jupyterhub/jupyterhub:latest

RUN pip install --no-cache \
    notebook \
    oauthenticator \
    dockerspawner \
    jupyterhub-nativeauthenticator


COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
