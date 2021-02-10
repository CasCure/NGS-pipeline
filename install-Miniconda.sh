#!/bin/bash

# If 'conda' is available, skip this.
if [ -x "$(command -v conda)" ]; then
  echo "conda is avilalbe. Skip installation."
else

  echo "Download the latest Miniconda3"
  MINICONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
  wget https://repo.continuum.io/miniconda/$MINICONDA_INSTALLER
  
  echo "Install Miniconda3"
  #chmod 755 $MINICONDA_INSTALLER
  #./$MINICONDA_INSTALLER
  bash ./$MINICONDA_INSTALLER -b -p $HOME/miniconda3
  rm $MINICONDA_INSTALLER
  $HOME/miniconda3/bin/conda config --set auto_activate_base true
  $HOME/miniconda3/bin/conda init
fi

. ~/.bashrc

conda create -n py2 python=2.7
