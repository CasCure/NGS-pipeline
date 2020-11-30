#!/bin/bash

MSI_LIST="$HOME/hg38_ref.MSIsensor-pro.list"

URL_S3="s3://cascure-active/AMC_CRC/fastq"

#for BAM_N in AMC202005n_HUMANg_CC02_normal.bam \
#for BAM_N in AMC202005n_HUMANg_CC06_normal.bam \
#	AMC202005n_HUMANg_CC07_normal.bam \
#	AMC202005n_HUMANg_CC08_normal.bam \
#do

URL_S3="s3://cascure-active/AMC_CRC/fastq.2020_10"
#for BAM_N in TKLab202010_HUMANg_AMC-CC09_normal.bam \
#	TKLab202010_HUMANg_AMC-CC16_normal.bam \
#	TKLab202010_HUMANg_AMC-CC27_normal.bam \
#	TKLab202010_HUMANg_AMC-CC33_normal.bam \
#	TKLab202010_HUMANg_AMC-CC35_normal.bam \
#	TKLab202010_HUMANg_AMC-CC36_normal.bam \
#	TKLab202010_HUMANg_AMC-CC37_normal.bam \
for BAM_N in	TKLab202010_HUMANg_AMC-CC38_normal.bam \
#	TKLab202010_HUMANg_AMC-CC39_normal.bam 
do

	BAM_T=${BAM_N/_normal/_tumor}
	OUT=$(basename $BAM_N)
	OUT=${OUT/_normal.bam/}".msisensor"

	BAM_N_S3=$URL_S3"/"$BAM_N
	BAM_T_S3=$URL_S3"/"$BAM_T

	#echo "aws s3 cp $BAM_N_S3 ./$BAM_N"
	aws s3 cp $BAM_N_S3 ./$BAM_N
	aws s3 cp $BAM_N_S3".bai" ./$BAM_N".bai"
	aws s3 cp $BAM_T_S3 ./$BAM_T
	aws s3 cp $BAM_T_S3".bai" ./$BAM_T".bai"

	~/msisensor-pro msi -d $MSI_LIST -n $BAM_N -t $BAM_T -o $OUT
	rm $BAM_N $BAM_T
done
