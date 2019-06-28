#!/bin/bash

# Set up OGGM paths
mkdir -p .oggm_cache
if [ ! -f ".oggm_config" ]
then
  echo "Writing .oggm_config ..."
  echo "dl_cache_dir = $HOME/.oggm_cache/download_cache" >> .oggm_config
  echo "dl_cache_readonly = False" >> .oggm_config
  echo "tmp_dir = $HOME/.oggm_cache/tmp" >> .oggm_config
  echo "cru_dir = $HOME/.oggm_cache/cru" >> .oggm_config
  echo "rgi_dir = $HOME/.oggm_cache/rgi" >> .oggm_config
  echo "test_dir = $HOME/.oggm_cache/OGGM_tests" >> .oggm_config
  echo "has_internet = True" >> .oggm_config
fi

# Pre-download oggm and salem sample-data
python binder/download_cache.py
