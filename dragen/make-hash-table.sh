#!/bin/bash

# Set the locale first, otherwise you may get the following error.
# ERROR: locale::facet::_S_create_c_locale name not valid

export LANG="C"
export LC_ALL="C"

dragen --build-hash-table true \
  --ht-reference /home/centos/hg38_ref.fa 
  --output-directory /home/centos/hg38_ref.k_21.f_16.m_149
