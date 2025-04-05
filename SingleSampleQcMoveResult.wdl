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


# WORKFLOW DEFINITION
workflow SingleSampleQcMoveResult {
  input {
    String sample_name

    String target_gcp_folder
    String? project_id

    File validation_report 

    File alignment_summary_metrics_file 

    File bait_bias_detail_metrics 
    File bait_bias_summary_metrics 
    File gc_bias_detail_metrics 
    File gc_bias_pdf 
    File gc_bias_summary_metrics 

    File insert_size_histogram_pdf 
    File insert_size_metrics_file 

    File pre_adapter_detail_metrics 
    File pre_adapter_summary_metrics 
    File quality_distribution_pdf 
    File quality_distribution_metrics 
    File error_summary_metrics 

    File selfSM 

    File duplication_metrics_file 

    File quality_yield_metrics 

    File? raw_wgs_metrics

    File? hs_metrics

    File input_bam_idxstats
    File input_bam_rx_result

    File evaluated_metrics_file
  }

  String gcs_output_dir = sub(target_gcp_folder, "/+$", "")

  String  old_raw_wgs_metrics = "~{raw_wgs_metrics}"
  String  output_raw_wgs_metrics = if old_raw_wgs_metrics == "" then "" else "~{gcs_output_dir}/~{sample_name}/~{basename(old_raw_wgs_metrics)}"

  String  old_hs_metrics = "~{hs_metrics}"
  String  output_hs_metrics = if old_hs_metrics == "" then "" else "~{gcs_output_dir}/~{sample_name}/~{basename(old_hs_metrics)}"


  call MoveResult {
    input:
      sample_name = sample_name,
      target_gcp_folder = target_gcp_folder,
      project_id = project_id,

      validation_report = validation_report,

      alignment_summary_metrics_file = alignment_summary_metrics_file,

      bait_bias_detail_metrics = bait_bias_detail_metrics,
      bait_bias_summary_metrics = bait_bias_summary_metrics,
      gc_bias_detail_metrics = gc_bias_detail_metrics,
      gc_bias_pdf = gc_bias_pdf,
      gc_bias_summary_metrics = gc_bias_summary_metrics,

      insert_size_histogram_pdf = insert_size_histogram_pdf,
      insert_size_metrics_file = insert_size_metrics_file,

      pre_adapter_detail_metrics = pre_adapter_detail_metrics,
      pre_adapter_summary_metrics = pre_adapter_summary_metrics,
      quality_distribution_pdf = quality_distribution_pdf,
      quality_distribution_metrics = quality_distribution_metrics,
      error_summary_metrics = error_summary_metrics,

      selfSM = selfSM,

      duplication_metrics_file = duplication_metrics_file,

      quality_yield_metrics = quality_yield_metrics,

      raw_wgs_metrics = raw_wgs_metrics,

      hs_metrics = hs_metrics,

      input_bam_idxstats = input_bam_idxstats,
      input_bam_rx_result = input_bam_rx_result,

      evaluated_metrics_file = evaluated_metrics_file
  }

  # Outputs that will be retained when execution is complete
  output {

    String  target_validation_report = "~{gcs_output_dir}/~{sample_name}/~{basename(validation_report)}"
    String  target_alignment_summary_metrics_file = "~{gcs_output_dir}/~{sample_name}/~{basename(alignment_summary_metrics_file)}"
    String  target_bait_bias_detail_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(bait_bias_detail_metrics)}"
    String  target_bait_bias_summary_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(bait_bias_summary_metrics)}"
    String  target_gc_bias_detail_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(gc_bias_detail_metrics)}"
    String  target_gc_bias_pdf = "~{gcs_output_dir}/~{sample_name}/~{basename(gc_bias_pdf)}"
    String  target_gc_bias_summary_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(gc_bias_summary_metrics)}"
    String  target_insert_size_histogram_pdf = "~{gcs_output_dir}/~{sample_name}/~{basename(insert_size_histogram_pdf)}"
    String  target_insert_size_metrics_file = "~{gcs_output_dir}/~{sample_name}/~{basename(insert_size_metrics_file)}"
    String  target_pre_adapter_detail_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(pre_adapter_detail_metrics)}"
    String  target_pre_adapter_summary_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(pre_adapter_summary_metrics)}"
    String  target_quality_distribution_pdf = "~{gcs_output_dir}/~{sample_name}/~{basename(quality_distribution_pdf)}"
    String  target_quality_distribution_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(quality_distribution_metrics)}"
    String  target_error_summary_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(error_summary_metrics)}"
    String  target_selfSM = "~{gcs_output_dir}/~{sample_name}/~{basename(selfSM)}"
    String  target_duplication_metrics_file = "~{gcs_output_dir}/~{sample_name}/~{basename(duplication_metrics_file)}"
    String  target_quality_yield_metrics = "~{gcs_output_dir}/~{sample_name}/~{basename(quality_yield_metrics)}"

    String  target_raw_wgs_metrics = output_raw_wgs_metrics
    String  target_hs_metrics = output_hs_metrics

    String  target_input_bam_idxstats = "~{gcs_output_dir}/~{sample_name}/~{basename(input_bam_idxstats)}"
    String  target_input_bam_rx_result = "~{gcs_output_dir}/~{sample_name}/~{basename(input_bam_rx_result)}"
    String  target_evaluated_metrics_file = "~{gcs_output_dir}/~{sample_name}/~{basename(evaluated_metrics_file)}"

    Int target_file_moved = MoveResult.target_file_moved
  }
}


task MoveResult {
  input {
    String sample_name

    String target_gcp_folder
    String? project_id

    String validation_report 

    String alignment_summary_metrics_file 

    String bait_bias_detail_metrics 
    String bait_bias_summary_metrics 
    String gc_bias_detail_metrics 
    String gc_bias_pdf 
    String gc_bias_summary_metrics 

    String insert_size_histogram_pdf 
    String insert_size_metrics_file 

    String pre_adapter_detail_metrics 
    String pre_adapter_summary_metrics 
    String quality_distribution_pdf 
    String quality_distribution_metrics 
    String error_summary_metrics 

    String selfSM 

    String duplication_metrics_file 

    String quality_yield_metrics 

    String? raw_wgs_metrics

    String? hs_metrics

    String input_bam_idxstats
    String input_bam_rx_result

    String evaluated_metrics_file
  }

  String gcs_output_dir = sub(target_gcp_folder, "/+$", "")

  command <<<

set -e

gsutil -m ~{"-u " + project_id} mv \
  ~{validation_report} \
  ~{alignment_summary_metrics_file} \
  ~{bait_bias_detail_metrics} \
  ~{bait_bias_summary_metrics} \
  ~{gc_bias_detail_metrics} \
  ~{gc_bias_pdf} \
  ~{gc_bias_summary_metrics} \
  ~{insert_size_histogram_pdf} \
  ~{insert_size_metrics_file} \
  ~{pre_adapter_detail_metrics} \
  ~{pre_adapter_summary_metrics} \
  ~{quality_distribution_pdf} \
  ~{quality_distribution_metrics} \
  ~{error_summary_metrics} \
  ~{selfSM} \
  ~{duplication_metrics_file} \
  ~{quality_yield_metrics} \
  ~{raw_wgs_metrics} \
  ~{hs_metrics} \
  ~{input_bam_idxstats} \
  ~{input_bam_rx_result} \
  ~{evaluated_metrics_file} \
  ~{gcs_output_dir}/~{sample_name}/

>>>

  runtime {
    docker: "google/cloud-sdk"
    preemptible: 1
    disks: "local-disk 10 HDD"
    memory: "2 GiB"
  }
  output {
    Int target_file_moved = 1
  }
}
