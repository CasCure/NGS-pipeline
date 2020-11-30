#!/bin/bash

mkdir $HOME/db
cd $HOME/db/

aws s3 cp s3://cascure-active/db/hg38_ref.k_21.f_16.m_149.dragen_hash.tgz $HOME/db/
aws s3 cp s3://cascure-active/db/hg38_ref.MSIsensor-pro.list.gz $HOME/db/
tar cvzpf hg38_ref.k_21.f_16.m_149.dragen_hash.tgz
gunzip hg38_ref.MSIsensor-pro.list.gz
