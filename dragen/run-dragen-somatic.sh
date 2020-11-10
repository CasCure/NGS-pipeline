#!/bin/bash
export LANG="C"
export LC_ALL="C"

REF="/home/centos/hg38_ref.k_21.f_16.m_149"
FQ_N1="TKLab202010_HUMANg_AMC-CC27_normal_R1.raw.fastq.gz"
FQ_N2="TKLab202010_HUMANg_AMC-CC27_normal_R2.raw.fastq.gz"
FQ_T1="TKLab202010_HUMANg_AMC-CC27_tumor_R1.raw.fastq.gz"
FQ_T2="TKLab202010_HUMANg_AMC-CC27_tumor_R2.raw.fastq.gz"

RG_ID="M202010_AMC-CC27_normal"
RG_SM="AMC-CC27_normal"
RG_ID_T="M202010_AMC-CC27_tumor"
RG_SM_T="AMC-CC27_tumor"

OUT_PREFIX=${FQ_N1/_normal_R1.raw.fastq.gz/}"_somatic"
OUT_DIR="/home/centos/CC27/AMC-CC27.dragen.somatic"

dragen -f -r $REF \
  -1 $FQ_N1 -2 $FQ_N2 \
  --RGID $RG_ID --RGSM $RG_SM \
  --tumor-fastq1 $FQ_T1 --tumor-fastq2 $FQ_T2 \
  --RGID-tumor $RG_ID_T --RGSM-tumor $RG_SM_T \
  --output-directory $OUT_DIR \
  --output-file-prefix $OUT_PREFIX \
  --enable-variant-caller true \
  --enable-duplicate-marking true
