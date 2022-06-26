ARG R2D_VER=latest
FROM ghcr.io/oggm/r2d:${R2D_VER}

ARG MEM_LIMIT=2G
ARG CPU_LIMIT=2
ARG NB_USER=jovyan
ARG NB_UID=1100

USER root

RUN usermod -u ${NB_UID} ${NB_USER} && \
    chown -R ${NB_USER}:${NB_USER} /home/${NB_USER} /usr/local/pyenv

USER ${NB_USER}
