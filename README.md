# CNA analyses from WXS

Nextflow pipeline for copy-number alteration analysis of WXS-derived BAM files,
with optional variant calling and focused reporting for chromosome arm 6q and
the `RPS12` gene.

The workflow is designed for configurable local, HPC, and Seqera execution.
References and sequencing data remain external to the repository.

## Initial input parameters

```bash
nextflow run main.nf \
  --bam_dir /path/to/bams \
  --fasta /path/to/Homo_sapiens_assembly19.fasta \
  --fasta_fai /path/to/Homo_sapiens_assembly19.fasta.fai \
  --fasta_dict /path/to/Homo_sapiens_assembly19.dict \
  --outdir results
```

The BAM directory is searched recursively using `--bam_pattern`, which defaults
to `**/*.bam`.
