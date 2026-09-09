process CNVKIT_BATCH {
    tag "${sample_id}"
    container params.cnvkit_container
    publishDir "${params.outdir}/cnvkit/${sample_id}", mode: 'copy'
    input:
    tuple val(sample_id), path(tumor_bam), path(normal_bam), path(fasta), path(targets_bed)
    output:
    path "*"
    script:
    """
    cnvkit.py batch ${tumor_bam} --normal ${normal_bam} --targets ${targets_bed} --fasta ${fasta} --output-reference ${sample_id}.reference.cnn --output-dir . --diagram --scatter
    """
}
