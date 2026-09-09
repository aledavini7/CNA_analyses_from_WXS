process INDEX_BAM {
    tag "${sample_id}"
    container params.samtools_container
    publishDir "${params.outdir}/indexed_bams", mode: 'copy', pattern: '*.bam.bai'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*.bam", includeInputs: true), path("*.bam.bai"), emit: indexed_bams

    script:
    """
    samtools index -@ ${task.cpus} ${bam}
    """
}
