#!/bin/bash
export LANG="C"
export LC_ALL="C"

# ----------
# change the following info for your data
URL_S3="s3://cascure-active/DSMC_OvC/fastq.2020_03/"
PROJECT_ID="DSMC202003"
TUMOR_TYPE="organoid" 	# organoid, tumor, etc
# -----------

# for hg38_ref
HASH_NAME="hg38_ref.k_21.f_16.m_149"

REF="/ephemeral/db/"$HASH_NAME
DATA_DIR="/ephemeral/"$PROJECT_ID

for SAMPLE in OvC01
do
    FQ_N1=$PROJECT_ID"_HUMANg_"$SAMPLE"_blood_R1.raw.fastq.gz"
    FQ_N2=${FQ_N1/_R1/_R2}
    FQ_T1=${FQ_N1/_blood/"_"$TUMOR_TYPE}
    FQ_T2=${FQ_T1/_R1/_R2}

    RG_SM_N=$SAMPLE"_blood"
    RG_ID_N=$PROJECT_ID"_"$RG_SM_N
    RG_SM_T=${RG_SM_N/_blood/"_"$TUMOR_TYPE}
    RG_ID_T=$PROJECT_ID"_"$RG_SM_T

    OUT_PREFIX_N=${FQ_N1/_R1.raw.fastq.gz/}
    OUT_DIR_N=$DATA_DIR"_"$SAMPLE"_blood.dragen.germline"
    OUT_PREFIX_T=${FQ_T1/_R1.raw.fastq.gz/}
    OUT_DIR_T=$DATA_DIR"_"$SAMPLE"_"$TUMOR_TYPE".dragen.germline"

    BAM_N=$OUT_DIR_N/$OUT_PREFIX_N".bam"
    BAM_T=$OUT_DIR_T/$OUT_PREFIX_T".bam"
    
    # somatic
    OUT_PREFIX_S=${FQ_T1/_R1.raw.fastq.gz/}"_somatic"
    OUT_DIR_S=$DATA_DIR"_"$SAMPLE"_"$TUMOR_TYPE".dragen.somatic"
    if [ -d $OUT_DIR_S ]; then
        rm -rf $OUT_DIR_S
    fi
    mkdir $OUT_DIR_S
    
    dragen -f -r $REF \
        --bam-input $BAM_N --tumor-bam-input $BAM_T \
        --output-directory $OUT_DIR_S \
        --output-file-prefix $OUT_PREFIX_S \
	--enable-map-align false \
        --enable-variant-caller true \
    
    # Clean-up
    # aws s3 cp $OUT_DIR_N $URL_S3 --recursive --exclude="*" --include="*bam*"
    # aws s3 cp $OUT_DIR_T $URL_S3 --recursive --exclude="*" --include="*bam*"
    # rm $OUT_DIR_N/*bam
    # rm $OUT_DIR_T/*bam
done
