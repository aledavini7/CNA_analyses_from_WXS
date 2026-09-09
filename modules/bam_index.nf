process INDEX_BAM {
    tag "${bam.simpleName}"
    container params.samtools_container
    publishDir "${params.outdir}/indexed_bams", mode: 'copy', pattern: '*.bam*'

    input:
    path bam

    output:
    tuple path("*.bam"), path("*.bam.bai"), emit: indexed_bams

    script:
    """
    samtools index -@ ${task.cpus} ${bam}
    """
}
