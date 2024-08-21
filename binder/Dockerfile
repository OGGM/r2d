ARG R2D_TAG=latest
FROM ghcr.io/oggm/r2d:${R2D_TAG}

ARG EXTRA_PACKAGES="git+https://github.com/OGGM/oggm.git git+https://github.com/fmaussion/salem.git"
RUN [ "${EXTRA_PACKAGES}" = "-" ] || \
    { ${PIP} install --upgrade --no-cache-dir ${EXTRA_PACKAGES} && \
      rm -rf ~/oggm_cache ~/.oggm_cache ~/.salem_cache && mkdir ~/.oggm_cache && \
      python3 -c "from salem.utils import get_demo_file; get_demo_file('world_borders.shp')" && \
      python3 -c "from oggm.utils import download_oggm_files; download_oggm_files()"; }
