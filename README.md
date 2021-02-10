# NGS-pipeline

WGS 및 WES 기본 프로세싱을 위한 pipeline 입니다. 

## Raw filename 규칙

이 pipeline 은 다음과 같은 raw 파일(fastq) 이름 규칙을 가정합니다. 

```
(CenterName)(SeqDate:YYYY-MM)(SeqType)_(SpeciesInfo)_(SampleName)_(SampleType)_[R1|R2].raw.fastq.gz
예) UNIST202012n_HUMANg_T101_blood_R1.raw.fastq.gz
    UNIST202012mgi_HUMANg_T101_tumor_R1.raw.fastq.gz
```

## Setting

$ yum install git pigz
$ cd ~
$ git clone https://github.com/CasCure/NGS-pipeline.git
$ ~/NGS-pipeline/install-Miniconda.sh
$ . ~/.bashrc
$ aws configure 
 - access key ID & secret access key should be configured. 
 - If the configuration is done, you may see the S3 buckets via 'aws s3 ls'.
$ ~/NGS-pipeline/dragen/retrieve-dragen-hash.sh
$ cd /ephemeral/
$ aws s3 ls <s3 url for FASTQ> | grep normal_R1 > normal_R1.list
$ ~/NGS-pipeline/dragen/run-dragen-somatic.sh

----
Copyright 2020 Taejoon Kwon. All rights reserved.
