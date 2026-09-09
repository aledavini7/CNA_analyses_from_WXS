process BAM_QC {
    tag "${sample_id}"
    container params.samtools_container
    publishDir "${params.outdir}/bam_qc", mode: 'copy', pattern: '*.txt'

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    tuple val(sample_id), path("*.bam", includeInputs: true), path("*.bam.bai", includeInputs: true), path("*.flagstat.txt"), path("*.idxstats.txt"), path("*.quickcheck.txt"), emit: qc_reports

    script:
    """
    samtools quickcheck -v ${bam} > ${sample_id}.quickcheck.txt 2>&1
    echo "quickcheck: PASS" >> ${sample_id}.quickcheck.txt
    samtools flagstat ${bam} > ${sample_id}.flagstat.txt
    samtools idxstats ${bam} > ${sample_id}.idxstats.txt
    """
}
