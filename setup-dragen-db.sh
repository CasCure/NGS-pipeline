#!/bin/bash

DB_DIR="/ephemeral/db/"
HASH_TGZ="hg38_ref.k_21.f_16.m_149.dragen_hash.tgz"

if [ ! -e $DB_DIR ]; then
    mkdir $DB_DIR
fi

aws s3 cp s3://cascure-active/db/$HASH_TGZ $DB_DIR
cd $DB_DIR
tar xvzpf $HASH_TGZ
