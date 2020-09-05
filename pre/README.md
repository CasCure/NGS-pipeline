# Pre-processing of short read sequence data

## FASTQ to uBAM (unmapped BAM)

* Ref: https://gatk.broadinstitute.org/hc/en-us/articles/360037872491
* Fix a badly formatted BAM: https://gatk.broadinstitute.org/hc/en-us/articles/360037872491
* Cleanup: https://gatk.broadinstitute.org/hc/en-us/articles/360039568932--How-to-Map-and-clean-up-short-read-sequence-data-efficiently

* GATK Best practice requires to add the Read Group (RG) in this step, 
 but it is quite inefficient. I recommend to add it in the mapping step
 using '-R' option of bwa-mem.
** https://github.com/lh3/bwa/issues/158
