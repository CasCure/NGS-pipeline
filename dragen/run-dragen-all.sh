#!/bin/bash
export LANG="C"
export LC_ALL="C"

REF="$HOME/work/db/hg38_ref.k_21.f_16.m_149"
URL_S3="s3://cascure-active/AMC_CRC/fastq/"

PROJECT_ID="AMC202005n"

for SAMPLE in CC02 CC06 CC07 CC08
do
    FQ_N1=$PROJECT_ID"_HUMANg_"$SAMPLE"_normal_R1.raw.fastq.gz"
    FQ_N2=${FQ_N1/_R1/_R2}
    FQ_T1=${FQ_N1/_normal/_tumor}
    FQ_T2=${FQ_T1/_R1/_R2}

    RG_SM_N=$SAMPLE"_normal"
    RG_ID_N=$PROJECT_ID"_"$RG_SM_N
    RG_SM_T=${RG_SM_N/_normal/_tumor}
    RG_ID_T=$PROJECT_ID"_"$RG_SM_T

    OUT_PREFIX_N=${FQ_N1/_normal_R1.raw.fastq.gz/}"_normal"
    OUT_DIR_N="$HOME/work/AMC-"$SAMPLE"_normal.dragen.germline"
    if [ -d $OUT_DIR_N ]; then
        rm -rf $OUT_DIR_N
    fi
    mkdir $OUT_DIR_N
    
    OUT_PREFIX_T=${FQ_T1/_Tumor_R1.raw.fastq.gz/}"_tumor"
    OUT_DIR_T="$HOME/work/AMC-"$SAMPLE"_tumor.dragen.germline"
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
  	  --enable-variant-caller true \
  	  --enable-duplicate-marking true \
  	  --enable-map-align-output true

    BAM_N=$(ls $OUT_DIR_N/*bam)
    BAM_T=$(ls $OUT_DIR_T/*bam)

    # somatic
    dragen -f -r $REF \
      -1 $FQ_N1 -2 $FQ_N2 \
      --RGID $RG_ID_N --RGSM $RG_SM_N \
      --tumor-fastq1 $FQ_T1 --tumor-fastq2 $FQ_T2 \
      --RGID-tumor $RG_ID_T --RGSM-tumor $RG_SM_T \
      --output-directory $OUT_DIR \
      --output-file-prefix $OUT_PREFIX \
      --enable-variant-caller true \
      --enable-duplicate-marking true
    
    # MSIsensor-pro
    $HOME/git/NGS-pipeline/MSIsensor/msisensor-pro msi -d $MSI_LIST -n $BAM_N -t $BAM_T -o $OUT
    
    aws s3 cp $OUT_DIR_N $URL_S3 --recursive --exclude="*" --include="*bam*"
    aws s3 cp $OUT_DIR_T $URL_S3 --recursive --exclude="*" --include="*bam*"
    rm $OUT_DIR_N/*bam
    rm $OUT_DIR_T/*bam
done
