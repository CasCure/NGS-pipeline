#!/bin/bash
export LANG="C"
export LC_ALL="C"

# change the following info for your data
URL_S3="s3://cascure-active/UNIST/fastq.2020_03/"

# for hg38_ref
HASH_NAME="hg38_ref.k_21.f_16.m_149"

REF="/ephemeral/db/"$HASH_NAME

CENTER_ID="UNIST"
DATA_DIR="/ephemeral/"$CENTER_ID

for FQ_N1 in $(cat normal_R1.list)
do
    PROJECT_ID=$(echo $FQ_N1 | awk -F"_" '{print $1}')
    SAMPLE=$(echo $FQ_N1 | awk -F"_" '{print $3}')

    #FQ_N1=$PROJECT_ID"_HUMANg_"$SAMPLE"_normal_R1.raw.fastq.gz"
    FQ_N2=${FQ_N1/_R1/_R2}
    FQ_T1=${FQ_N1/_normal/_tumor}
    FQ_T2=${FQ_T1/_R1/_R2}

    RG_SM_N=$SAMPLE"_normal"
    RG_ID_N=$PROJECT_ID"_"$RG_SM_N
    RG_SM_T=${RG_SM_N/_normal/_tumor}
    RG_ID_T=$PROJECT_ID"_"$RG_SM_T

    OUT_PREFIX_N=${FQ_N1/_R1.raw.fastq.gz/}
    OUT_DIR_N=$DATA_DIR"_"$SAMPLE"_normal.dragen.germline"
    if [ -d $OUT_DIR_N ]; then
       rm -rf $OUT_DIR_N
    fi
    mkdir $OUT_DIR_N
    
    OUT_PREFIX_T=${FQ_T1/_R1.raw.fastq.gz/}
    OUT_DIR_T=$DATA_DIR"_"$SAMPLE"_tumor.dragen.germline"
    if [ -d $OUT_DIR_T ]; then
        rm -rf $OUT_DIR_T
    fi
    mkdir $OUT_DIR_T

    FQ_N1=$URL_S3"/"$FQ_N1
    FQ_N2=$URL_S3"/"$FQ_N2
    FQ_T1=$URL_S3"/"$FQ_T1
    FQ_T2=$URL_S3"/"$FQ_T2
  
    # germline-normal
    dragen -f -r $REF \
        -1 $FQ_N1 -2 $FQ_N2 \
        --RGID $RG_ID_N \
  	    --RGSM $RG_SM_N \
  	    --output-directory $OUT_DIR_N \
  	    --output-file-prefix $OUT_PREFIX_N \
        --enable-sort true \
  	    --enable-variant-caller true \
  	    --enable-duplicate-marking true \
  	    --enable-map-align-output true
    
    # germline-tumor
    dragen -f -r $REF \
        -1 $FQ_T1 -2 $FQ_T2 \
        --RGID $RG_ID_T \
        --RGSM $RG_SM_T \
        --output-directory $OUT_DIR_T \
        --output-file-prefix $OUT_PREFIX_T \
        --enable-sort true \
        --enable-variant-caller true \
        --enable-duplicate-marking true \
        --enable-map-align-output true

    BAM_N=$OUT_DIR_N/$OUT_PREFIX_N".bam"
    BAM_T=$OUT_DIR_T/$OUT_PREFIX_T".bam"
    
    # somatic
    OUT_PREFIX_S=${FQ_T1/_R1.raw.fastq.gz/}"_somatic"
    OUT_DIR_S=$DATA_DIR"_"$SAMPLE"_tumor.dragen.somatic"
    if [ -d $OUT_DIR_S ]; then
        rm -rf $OUT_DIR_S
    fi
    mkdir $OUT_DIR_S

    dragen -f -r $REF \
        --bam-input $BAM_N \
        --tumor-bam-input $BAM_T \
        --enable-map-align false \
        --prepend-filename-to-rgid true \
        --output-directory $OUT_DIR_S \
        --output-file-prefix $OUT_PREFIX_S \
        --enable-variant-caller true \

    # Clean-up
    aws s3 cp $OUT_DIR_N $URL_S3 --recursive --exclude="*" --include="*bam*"
    aws s3 cp $OUT_DIR_T $URL_S3 --recursive --exclude="*" --include="*bam*"
    # rm $OUT_DIR_N/*bam
    # rm $OUT_DIR_T/*bam
done
