# CNA analyses from WXS

Nextflow pipeline for copy-number alteration analysis of WXS-derived BAM files,
with optional variant calling and focused reporting for chromosome arm 6q and
the `RPS12` gene.

The workflow is designed for configurable local, HPC, and Seqera execution.
References and sequencing data remain external to the repository.

## BAM indexing test

```bash
nextflow run main.nf \
  --bam_dir /path/to/bams \
  --outdir results
```

To test a small subset on the cluster, provide a directory containing only the
sample folders you want to process:

```bash
nextflow run main.nf \
  --bam_dir /beegfs/scratch/ieo5898/phs000450_chapuy/test_bams \
  --outdir /beegfs/scratch/ieo5898/phs000450_chapuy/results/index_test
```

All `*.bam` files below `bam_dir` are discovered recursively. The directory
can point to any future data location.
