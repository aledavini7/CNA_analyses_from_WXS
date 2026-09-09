/*
 * CNA analyses from WXS BAM files
 * Initial repository skeleton. Analysis modules will be added incrementally.
 */

nextflow.enable.dsl=2

include { INDEX_BAM } from './modules/bam_index'
include { BAM_QC } from './modules/bam_qc'

workflow {
    if (!params.bam_dir) {
        error "Missing required parameter: --bam_dir"
    }

    bam_ch = Channel.fromPath("${params.bam_dir}/**/*.bam", checkIfExists: true)
        .map { bam -> tuple(bam.baseName, bam) }

    INDEX_BAM(bam_ch)
    BAM_QC(INDEX_BAM.out.indexed_bams)
}
