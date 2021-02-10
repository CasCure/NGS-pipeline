#!/bin/bash
export LANG="C"
export LC_ALL="C"

HASH_NAME="hg38_ref.k_21.f_16.m_149"

REF="/ephemeral/db/"$HASH_NAME

URL_S3="s3://cascure-active/DSMC_OvC/fastq.2020_12/"

for DATA_NAME in IBS202012n_HUMANg_MCF7 TKLab202012n_HUMANg_SH-SY5Y
do
    SAMPLE=$(echo $DATA_NAME | awk -F"_" '{print $3}')
    PROJECT_ID=$(echo $DATA_NAME | awk -F"_" '{print $1}')
    DATA_DIR="/ephemeral/"$PROJECT_ID

    FQ_N1=$DATA_NAME"_R1.raw.fastq.gz"
    FQ_N2=${FQ_N1/_R1/_R2}

    RG_SM_N=$SAMPLE
    RG_ID_N=$PROJECT_ID"_"$RG_SM_N

    OUT_PREFIX_N=${FQ_N1/_R1.raw.fastq.gz/}
    OUT_DIR_N=$DATA_DIR"-"$SAMPLE".dragen.germline"
    if [ -d $OUT_DIR_N ]; then
        rm -rf $OUT_DIR_N
    fi
    mkdir $OUT_DIR_N
    
    FQ_N1=$URL_S3"/"$FQ_N1
    FQ_N2=$URL_S3"/"$FQ_N2
   
    # germline
    dragen -f -r $REF \
        -1 $FQ_N1 -2 $FQ_N2 \
        --RGID $RG_ID_N \
        --RGSM $RG_SM_N \
        --output-directory $OUT_DIR_N \
        --output-file-prefix $OUT_PREFIX_N \
        --enable-variant-caller true \
        --enable-duplicate-marking true \
        --enable-map-align-output true
    
    #aws s3 cp $OUT_DIR_N $URL_S3 --recursive --exclude="*" --include="*bam*"
    #rm $OUT_DIR_N/*bam
done
