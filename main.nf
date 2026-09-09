/*
 * CNA analyses from WXS BAM files
 * Initial repository skeleton. Analysis modules will be added incrementally.
 */

nextflow.enable.dsl=2

include { INDEX_BAM_PAIR } from './modules/bam_index'
include { CNVKIT_BATCH } from './modules/cnvkit_batch'

workflow {
    if (!params.samplesheet || !params.fasta || !params.targets_bed) error "Required: --samplesheet, --fasta, --targets_bed"

    samples_ch = Channel.fromPath(params.samplesheet, checkIfExists: true).splitCsv(header: true, sep: '\t').map { r -> tuple(r.sample_id, file(r.tumor_bam), file(r.normal_bam)) }
    indexed = INDEX_BAM_PAIR(samples_ch)
    pairs = indexed.indexed_pairs.map { sid, bams, idxs -> tuple(sid, bams[0], bams[1], file(params.fasta), file(params.targets_bed)) }
    CNVKIT_BATCH(pairs)
}
