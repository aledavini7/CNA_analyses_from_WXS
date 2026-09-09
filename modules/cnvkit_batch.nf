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
    awk -v sid='${sample_id}' 'BEGIN{FS=OFS="\t"; print "sample_id","chromosome","segment_start","segment_end","log2","cn","probes"} NR==1{for(i=1;i<=NF;i++) h[\$i]=i; next} \$1=="6" && \$2<133138703 && \$3>133135708 {print sid,\$1,\$2,\$3,\$h["log2"],(h["cn"] ? \$h["cn"] : "NA"),(h["probes"] ? \$h["probes"] : "NA")}' ${tumor_bam.simpleName}.call.cns > ${sample_id}.RPS12_6q.tsv
    cnvkit.py scatter ${tumor_bam.simpleName}.cnr -s ${tumor_bam.simpleName}.cns -c 6:60000000-171115067 -o ${sample_id}.6q_RPS12.pdf
    mv ${tumor_bam.simpleName}.targetcoverage.cnn ${sample_id}.targetcoverage.cnn
    mv ${tumor_bam.simpleName}.antitargetcoverage.cnn ${sample_id}.antitargetcoverage.cnn
    mv ${tumor_bam.simpleName}.cnr ${sample_id}.cnr
    mv ${tumor_bam.simpleName}.cns ${sample_id}.cns
    mv ${tumor_bam.simpleName}.call.cns ${sample_id}.call.cns
    mv ${tumor_bam.simpleName}.bintest.cns ${sample_id}.bintest.cns
    mv ${tumor_bam.simpleName}-scatter.png ${sample_id}-scatter.png
    mv ${tumor_bam.simpleName}-diagram.pdf ${sample_id}-diagram.pdf
    """
}
