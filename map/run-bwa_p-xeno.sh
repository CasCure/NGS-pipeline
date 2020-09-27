#!/bin/bash
NUM_THREADS=6

DB="$HOME/db.bwa/mm10"
DBNAME=$(basename $DB)

for FQ1 in $(ls ../fastq/*PDX*_1P.gz)
do
  FQ2=${FQ1/_1P/_2P}

  SAM=$(basename $FQ1)
  SAM=${SAM/_1P.gz/}"."$DBNAME".bwa_mem.sam"
  BAM=${SAM/.sam/}".bam"

  if [ ! -e $SAM ]; then
    echo "Make $SAM"
    bwa mem -M -t $NUM_THREADS $DB $FQ1 $FQ2 > $SAM
  fi

  if [ ! -e $BAM ]; then
    echo "Make $BAM"
    samtools view -h -@ $NUM_THREADS -o $BAM $SAM
  fi
done
