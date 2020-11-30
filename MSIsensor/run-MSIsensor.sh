/bin/bash

MSI_LIST="$HOME/hg38_ref.MSIsensor-pro.list"

URL_S3="s3://cascure-active/AMC_CRC/fastq"

# Naming convention for a BAM file
# (Project ID)_HUMANg_(Sample ID)_[normal|tumor].(platform).bam
#
# i.e. AMC202005n_HUMANg_CC02_normal.dragen.bam 

for BAM_N in $(ls ../bam/*_normal.*bam)
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
