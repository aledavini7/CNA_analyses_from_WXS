process MULTIQC {
    tag 'cohort QC'
    container params.multiqc_container
    publishDir "${params.outdir}/multiqc", mode: 'copy'
    input:
    path qc_reports
    output:
    path 'multiqc_report.html'
    path 'multiqc_data'
    script:
    """
    multiqc . --force --outdir .
    """
}
