# NGS-pipeline

WGS 및 WES 기본 프로세싱을 위한 pipeline 입니다. 

## Raw filename 규칙

이 pipeline 은 다음과 같은 raw 파일(fastq) 이름 규칙을 가정합니다. 

```
(CenterName)(SeqDate:YYYY-MM)(SeqType)_(SpeciesInfo)_(SampleName)_(SampleType)_[R1|R2].raw.fastq.gz
예) UNIST202012n_HUMANg_T101_blood_R1.raw.fastq.gz
    UNIST202012mgi_HUMANg_T101_tumor_R1.raw.fastq.gz
```

----
Copyright 2020 Taejoon Kwon. All rights reserved.
