#!/bin/bash

SAMPLE="mydata"

FQ1=$SAMPLE"_R1.raw.fastq.gz"
FQ2=$SAMPLE"_R2.raw.fastq.gz"

UBAM=$SAMPLE".ubam"

TMP_DIR="./tmp/"

picard FastqToSam -F1 $FQ1 -F2 $FQ2 -O $UBAM -SM $SAMPLE -TMP_DIR $TMP_DIR
