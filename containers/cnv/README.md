# CNVkit container

Build locally for Linux/AMD64:

```bash
docker buildx build --platform linux/amd64 \
  -t cna-cnvkit:0.1.0 containers/cnv
```

The workflow uses the public `etal/cnvkit:0.9.11` image by default. The image
parameter can be overridden with a registry-hosted build when available.
