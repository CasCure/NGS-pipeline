#!/bin/bash

REF="/home/centos/hg38_ref.k_21.f_16.m_149"
FQ_1="TKLab202010_HUMANg_AMC-CC27_normal_R1.raw.fastq.gz"
FQ_2="TKLab202010_HUMANg_AMC-CC27_normal_R2.raw.fastq.gz"
#TKLab202010_HUMANg_AMC-CC27_tumor_R1.raw.fastq.gz
#TKLab202010_HUMANg_AMC-CC27_tumor_R2.raw.fastq.gz

RG_ID="M202010_AMC-CC27_normal"
RG_SM="AMC-CC27_normal"

OUT_PREFIX=${FQ_1/_R1.raw.fastq.gz/}
OUT_DIR="/home/centos/CC27/dragen.out"

dragen -f -r $REF \
  -1 $FQ_1 -2 $FQ_2 \
  --RGID $RG_ID \
  --RGSM $RG_SM \
  --output-directory $OUT_DIR \
  --output-file-prefix $OUT_PREFIX \
  --enable-variant-caller true \
  --enable-duplicate-marking true
