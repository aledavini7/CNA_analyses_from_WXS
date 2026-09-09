process INDEX_BAM_PAIR {
    tag "${sample_id}"
    container params.samtools_container
    publishDir "${params.outdir}/indexed_bams", mode: 'copy', pattern: '*.bam.bai'

    input:
    tuple val(sample_id), path(tumor_bam), path(normal_bam)

    output:
    tuple val(sample_id), path("*.bam", includeInputs: true), path("*.bam.bai"), emit: indexed_pairs

    script:
    """
    samtools index -@ ${task.cpus} ${tumor_bam}
    samtools index -@ ${task.cpus} ${normal_bam}
    """
}

process INDEX_BAM_TUMOR_ONLY {
    tag "${sample_id}"
    container params.samtools_container
    publishDir "${params.outdir}/indexed_bams", mode: 'copy', pattern: '*.bam.bai'
    input:
    tuple val(sample_id), path(tumor_bam)
    output:
    tuple val(sample_id), path("*.bam", includeInputs: true), path("*.bam.bai"), emit: indexed_tumor
    script:
    """
    samtools index -@ ${task.cpus} ${tumor_bam}
    """
}
