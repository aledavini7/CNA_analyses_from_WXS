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
    matched = rows.filter { it.pairing_status == 'matched' }.map { r -> tuple(r.sample_id, file(r.tumor_bam).name, file(r.tumor_bam), file(r.normal_bam).name, file(r.normal_bam)) }
    tumor_only = rows.filter { it.pairing_status == 'tumor_only' }.map { r -> tuple(r.sample_id, file(r.tumor_bam)) }
    indexed = INDEX_BAM_PAIR(matched)
    indexed_tumor = INDEX_BAM_TUMOR_ONLY(tumor_only)
    qc = indexed.indexed_pairs.map { sid, tumor_name, normal_name, bams, idxs -> tuple("${sid}_tumor", bams.find { it.name == tumor_name }, idxs.find { it.name == "${tumor_name}.bai" }) }
        .mix(indexed.indexed_pairs.map { sid, tumor_name, normal_name, bams, idxs -> tuple("${sid}_normal", bams.find { it.name == normal_name }, idxs.find { it.name == "${normal_name}.bai" }) })
        .mix(indexed_tumor.indexed_tumor.map { sid, bam, bai -> tuple("${sid}_tumor", bam, bai) })
    BAM_QC(qc)
    MULTIQC(BAM_QC.out.qc_reports.map { it[3..5] }.flatten().collect())
    pairs = indexed.indexed_pairs.map { sid, tumor_name, normal_name, bams, idxs -> tuple(sid, bams.find { it.name == tumor_name }, bams.find { it.name == normal_name }, file(params.fasta), file(params.targets_bed)) }
    CNVKIT_BATCH(pairs)
    if (params.cnv_reference) {
        tumor_pairs = indexed_tumor.indexed_tumor.map { sid, bam, bai -> tuple(sid, bam, bai, file(params.fasta), file(params.targets_bed), file(params.cnv_reference)) }
        CNVKIT_TUMOR_ONLY(tumor_pairs)
    }
}
