version 1.0

## Portions Copyright Broad Institute, 2018
##
## This WDL pipeline implements QC in human whole-genome or exome/targeted sequencing data.
##
## Requirements/expectations
## - Human paired-end sequencing data in aligned BAM or CRAM format
## - Input BAM/CRAM files must additionally comply with the following requirements:
## - - files must pass validation by ValidateSamFile
## - - reads are provided in query-sorted order
## - - all reads must have an RG tag
## - Reference genome must be Hg38 with ALT contigs
##
## Runtime parameters are optimized for Broad's Google Cloud Platform implementation.
## For program versions, see docker containers.
##
## LICENSING :
## This script is released under the WDL open source code license (BSD-3).
## Full license text at https://github.com/openwdl/wdl/blob/master/LICENSE
## Note however that the programs it calls may be subject to different licenses. 
## Users are responsible for checking that they are authorized to run all programs before running this script.
## - [Picard](https://broadinstitute.github.io/picard/)
## - [VerifyBamID2](https://github.com/Griffan/VerifyBamID)

# Git URL import
import "https://raw.githubusercontent.com/genome/qc-analysis-pipeline/master/tasks/Qc.wdl" as QC

# WORKFLOW DEFINITION
workflow Index {
  input {
    File input_bam
    String base_name
    File ref_cache
    Int preemptible_tries
  }

  # Generate a BAM or CRAM index
  call QC.BuildBamIndex as BuildBamIndex {
    input:
      input_bam = input_bam,
      base_name = base_name,
      ref_cache = ref_cache,
      preemptible_tries = preemptible_tries
  }

  output {
    File bam_index = BuildBamIndex.bam_index
  }
}
