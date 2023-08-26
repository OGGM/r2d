# You can pick a tag from: https://github.com/OGGM/oggm/pkgs/container/oggm
ARG OGGM_TAG=latest
# Here the date should be same or lower than above. Link: https://github.com/OGGM/OGGM-Docker/pkgs/container/empty_base
ARG BASE_TAG=latest
FROM ghcr.io/oggm/oggm:${OGGM_TAG} as builder

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install wget curl nodejs \
        build-essential gcc g++ gfortran rustc cargo \
        libffi-dev libssl-dev libopenblas-dev liblapack-dev zlib1g-dev \
        libtiff-dev libpng-dev libjpeg-dev libopenjp2-7-dev libfreetype6-dev \
        libgif-dev libnetcdf-dev libhdf4-dev libhdf5-dev libwebp-dev \
        libgeos-dev liblcms2-dev && \
    apt-get clean && \
    npm install --global yarn && \
    ln -s bash /bin/sh.bash && mv /bin/sh.bash /bin/sh

# Temporary workaround, since it requires tornado>=6.2 now, colliding with distributed wanting <6.2.
# Remove once distributed supports up-to-date tornado
RUN ${PIP} install --no-cache-dir "jupyter-client<7.3.5"

# repo2docker requirements
RUN ${PIP} install --no-cache-dir \
        ipywidgets \
        jupyter-offlinenotebook \
        jupyter-resource-usage \
        jupyterlab \
        jupyterhub \
        nbconvert \
        nbclassic \
        "notebook<7" \
        nteract_on_jupyter

# OGGM(-Hub) requirements
RUN ${PIP} install --no-cache-dir --no-binary :all: --no-build-isolation \
        pyct && \
    ${PIP} install --no-cache-dir --no-binary ipympl,scikit-learn \
        scikit-learn \
        pyviz_comms \
        ipympl && \
    ${PIP} install --no-cache-dir --no-binary :all: \
        nbgitpuller \
        nbserverproxy \
        graphviz \
        bokeh \
        param \
        shapely \
        parambokeh \
        seaborn \
        tables \
        h5netcdf \
        git+https://github.com/OGGM/oggm-edu.git 

# Problematic dependencies
RUN ${PIP} install --no-cache-dir --force-reinstall \
        typing_extensions && \
    ${PIP} install --no-cache-dir --no-binary :all: \
        tqdm \
        panel && \
    ${PIP} install --no-cache-dir --no-binary :all: --no-build-isolation \
        holoviews \
        hvplot \
        geoviews \
        datashader

# Lab extensions
RUN ${PIP} install --no-cache-dir \
        jupyter-server-proxy \
        nbgitpuller \
        jupyterlab-widgets \
        dask-labextension

ARG EXTRA_PACKAGES=-
RUN [ "${EXTRA_PACKAGES}" = "-" ] || \
    ${PIP} install --no-cache-dir --no-binary :all: ${EXTRA_PACKAGES}

ARG BASE_TAG=latest
FROM ghcr.io/oggm/empty_base:${BASE_TAG}

ARG BASE_TAG=latest
ARG MEM_LIMIT=2G
ARG CPU_LIMIT=2

ARG NB_USER=jovyan
ARG NB_UID=1100

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        nodejs wget curl libopenblas0 liblapack3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s bash /bin/sh.bash && mv /bin/sh.bash /bin/sh

ENV PYTHONUNBUFFERED=1 USER=${NB_USER} HOME=/home/${NB_USER} REPO_DIR=/home/${NB_USER} PATH=/home/${NB_USER}/.local/bin:${PATH}
RUN groupadd --gid ${NB_UID} ${NB_USER} && \
    useradd \
        --comment "Default user" \
        --create-home \
        --gid ${NB_UID} \
        --no-log-init \
        --shell /bin/bash \
        --uid ${NB_UID} \
        ${NB_USER}

COPY --from=builder /opt/proj /opt/proj
COPY --chown=${NB_USER}:${NB_USER} --from=builder /usr/local/pyenv /usr/local/pyenv

COPY --chown=${NB_USER}:${NB_USER} binder/ /home/${NB_USER}/binder

RUN mkdir -p /usr/local/bin && \
    wget https://raw.githubusercontent.com/jupyterhub/repo2docker/main/repo2docker/buildpacks/python3-login -O /usr/local/bin/python3-login && \
    wget https://raw.githubusercontent.com/jupyterhub/repo2docker/main/repo2docker/buildpacks/repo2docker-entrypoint -O /usr/local/bin/repo2docker-entrypoint && \
    chmod +x /usr/local/bin/{python3-login,repo2docker-entrypoint} && \
    ldconfig

RUN cp /usr/local/pyenv/versions/*/lib/*/site-packages/nbgitpuller/templates/status.html /usr/local/pyenv/versions/*/lib/*/site-packages/notebook/templates/

COPY binder/Humor-Sans-1.0.ttf /usr/share/fonts/Humor-Sans-1.0.ttf

USER ${NB_USER}
WORKDIR ${REPO_DIR}

RUN pyenv rehash && \
    ${PIP} check && \
    python3 -c "import fiona, matplotlib.font_manager, salem" && \
    bash /home/${NB_USER}/binder/postBuild

ENTRYPOINT ["/usr/local/bin/repo2docker-entrypoint"]
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
