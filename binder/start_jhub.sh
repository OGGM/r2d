#!/bin/bash

# Add funny font
if [ ! -d ".fonts" ]
then
  mkdir ~/.fonts
  wget http://antiyawn.com/uploads/Humor-Sans-1.0.ttf
  mv Humor-Sans-1.0.ttf ~/.fonts/Humor-Sans-1.0.ttf
  cd ~/.fonts/
  fc-cache -f -v
fi

# Back to home
cd ~

# run matplotlib once to generate the font cache
python -c "import matplotlib as mpl; mpl.use('Agg'); import pylab as plt; fig, ax = plt.subplots(); fig.savefig('test.png')"
test -e test.png && rm test.png

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
