process CNVKIT_TUMOR_ONLY {
    tag "${sample_id}"
    container params.cnvkit_container
    publishDir "${params.outdir}/cnvkit/${sample_id}", mode: 'copy'
    input:
    tuple val(sample_id), path(tumor_bam), path(tumor_bai), path(fasta), path(targets_bed), path(cnv_reference)
    output:
    path "*"
    script:
    """
    cnvkit.py batch ${tumor_bam} --reference ${cnv_reference} --targets ${targets_bed} --fasta ${fasta} --output-dir . --diagram --scatter
    """
}
