#!/bin/bash
export LANG="C"
export LC_ALL="C"

# ----------
# change the following info for your data
URL_S3="s3://cascure-active/DSMC_OvC/fastq.2020_03/"
CENTER_ID="DSMC"
PROJECT_ID="DSMC202003"
# -----------

# for hg38_ref
HASH_NAME="hg38_ref.k_21.f_16.m_149"

REF="/ephemeral/db/"$HASH_NAME
DATA_DIR="/ephemeral/"$CENTER_ID

for SAMPLE in CC28
do
    FQ_N1=$PROJECT_ID"_HUMANg_"$SAMPLE"_blood_R1.raw.fastq.gz"
    FQ_N2=${FQ_N1/_R1/_R2}
    FQ_T1=${FQ_N1/_blood/_tumor}
    FQ_T2=${FQ_T1/_R1/_R2}

    RG_SM_N=$SAMPLE"_blood"
    RG_ID_N=$PROJECT_ID"_"$RG_SM_N
    RG_SM_T=${RG_SM_N/_blood/_tumor}
    RG_ID_T=$PROJECT_ID"_"$RG_SM_T

    BAM_N=$OUT_DIR_N/$OUT_PREFIX_N".bam"
    BAM_T=$OUT_DIR_T/$OUT_PREFIX_T".bam"
    
    # somatic
    OUT_PREFIX_S=${FQ_T1/_R1.raw.fastq.gz/}"_somatic"
    OUT_DIR_S=$DATA_DIR"_"$SAMPLE"_tumor.dragen.somatic"
    if [ -d $OUT_DIR_S ]; then
        rm -rf $OUT_DIR_S
    fi
    mkdir $OUT_DIR_S

    #   --bam-input $BAM_N --tumor-bam-input $BAM_T 

    dragen -f -r $REF \
        -1 $FQ_N1 -2 $FQ_N2 --tumor-fastq1 $FQ_T1 --tumor-fastq2 $FQ_T2 \
        --RGID $RG_ID_N --RGSM $RG_SM_N \
        --RGID-tumor $RG_ID_T --RGSM-tumor $RG_SM_T \
        --output-directory $OUT_DIR \
        --output-file-prefix $OUT_PREFIX \
        --enable-variant-caller true \
        --enable-duplicate-marking true
    
    # Clean-up
    # aws s3 cp $OUT_DIR_N $URL_S3 --recursive --exclude="*" --include="*bam*"
    # aws s3 cp $OUT_DIR_T $URL_S3 --recursive --exclude="*" --include="*bam*"
    # rm $OUT_DIR_N/*bam
    # rm $OUT_DIR_T/*bam
done
