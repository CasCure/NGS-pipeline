#!/bin/bash
EXP_DATE=60
REGION="us-west-2"

for FILE in $(cat PRESIGN.list)
do
  echo $FILE
  aws s3 presign $FILE --expires-in $EXP_DATE --region $REGION
done
