/*
 * CNA analyses from WXS BAM files
 * Initial repository skeleton. Analysis modules will be added incrementally.
 */

nextflow.enable.dsl=2

include { INDEX_BAM_PAIR } from './modules/bam_index'
include { CNVKIT_BATCH } from './modules/cnvkit_batch'
include { CNVKIT_TUMOR_ONLY } from './modules/cnvkit_tumor_only'
include { BAM_QC } from './modules/bam_qc'
include { MULTIQC } from './modules/multiqc'

workflow {
    if (!params.samplesheet || !params.fasta || !params.targets_bed) error "Required: --samplesheet, --fasta, --targets_bed"

    rows = Channel.fromPath(params.samplesheet, checkIfExists: true).splitCsv(header: true, sep: '\t')
    matched = rows.filter { it.pairing_status == 'matched' }.map { r -> tuple(r.sample_id, file(r.tumor_bam), file(r.normal_bam)) }
    tumor_only = rows.filter { it.pairing_status == 'tumor_only' }.map { r -> tuple(r.sample_id, file(r.tumor_bam)) }
    indexed = INDEX_BAM_PAIR(matched)
    indexed_tumor = INDEX_BAM_TUMOR_ONLY(tumor_only)
    qc = indexed.indexed_pairs.map { sid, bams, idxs -> tuple("${sid}_tumor", bams[0], idxs[0]) }
        .mix(indexed.indexed_pairs.map { sid, bams, idxs -> tuple("${sid}_normal", bams[1], idxs[1]) })
        .mix(indexed_tumor.indexed_tumor.map { sid, bam, bai -> tuple("${sid}_tumor", bam, bai) })
    BAM_QC(qc)
    MULTIQC(BAM_QC.out.qc_reports.map { it[3..5] }.flatten().collect())
    pairs = indexed.indexed_pairs.map { sid, bams, idxs -> tuple(sid, bams[0], bams[1], file(params.fasta), file(params.targets_bed)) }
    CNVKIT_BATCH(pairs)
    if (params.cnv_reference) {
        tumor_pairs = indexed_tumor.indexed_tumor.map { sid, bam, bai -> tuple(sid, bam, bai, file(params.fasta), file(params.targets_bed), file(params.cnv_reference)) }
        CNVKIT_TUMOR_ONLY(tumor_pairs)
    }
}
