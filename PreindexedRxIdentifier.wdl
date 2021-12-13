
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
import "tasks/Qc.wdl" as QC

# WORKFLOW DEFINITION
workflow RxIdentifier {
  input {
    File input_bam
    File input_bam_index
    String base_name
    Int preemptible_tries
  }

  # Collect BAM/CRAM index stats
  call QC.BamIndexStats as BamIndexStats {
    input:
      input_bam = input_bam,
      input_bam_index = input_bam_index,
      preemptible_tries = preemptible_tries
  }

  call QC.RxIdentifier as RxIdentifier {
    input:
      idxstats = BamIndexStats.idxstats,
      sample_id = base_name,
      preemptible_tries = preemptible_tries
  }

  output {
    File bam_idxstats = BamIndexStats.idxstats 
    File bam_rx_result = RxIdentifier.rx_result
    String rx_value = RxIdentifier.rx_value
  }
}
