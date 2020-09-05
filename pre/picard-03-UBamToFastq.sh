#!/bin/bash

UBAM="mydata.marked.ubam"
FQ=${UBAM/.marked.ubam/}".i_marked.fastq"

TMP_DIR="./tmp"

echo $UBAM $FQ
picard SamToFastq -Xmx8g I=$UBAM FASTQ=$FQ \
  CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true TMP_DIR=$TMP_DIR
