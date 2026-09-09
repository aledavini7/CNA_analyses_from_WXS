/*
 * CNA analyses from WXS BAM files
 * Initial repository skeleton. Analysis modules will be added incrementally.
 */

nextflow.enable.dsl=2

include { INDEX_BAM } from './modules/bam_index'

workflow {
    if (!params.bam_dir) {
        error "Missing required parameter: --bam_dir"
    }

    bam_ch = Channel.fromPath("${params.bam_dir}/**/*.bam", checkIfExists: true)

    INDEX_BAM(bam_ch)
}
