#!/bin/bash

SAMPLE="mydata"
UBAM=$SAMPLE".ubam"

MARKED_BAM=${UBAM/.ubam/}".marked.ubam"
MARKED_METRICS=$MARKED_BAM".matrics.txt"

TMP_DIR="./tmp"

picard MarkIlluminaAdapters TMP_DIR=$TMP_DIR \
  I=$UBAM O=$MARKED_BAM M=$MARKED_METRICS
