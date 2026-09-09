/*
 * CNA analyses from WXS BAM files
 * Initial repository skeleton. Analysis modules will be added incrementally.
 */

nextflow.enable.dsl=2

workflow {
    if (!params.bam_dir) {
        error "Missing required parameter: --bam_dir"
    }
    if (!params.fasta) {
        error "Missing required parameter: --fasta"
    }

    bam_ch = Channel.fromPath(
        "${params.bam_dir}/${params.bam_pattern}",
        checkIfExists: true
    )

    if (bam_ch.empty) {
        error "No BAM files found under ${params.bam_dir} with pattern ${params.bam_pattern}"
    }

    // Processes will be connected here after the input contract is finalized.
    bam_ch.view { "Input BAM: ${it}" }
}
