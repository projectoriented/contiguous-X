#!/usr/bin/env Rscript
# Author: Mei Wu, https://github.com/projectoriented

# Logging
log <- file(snakemake@log[[1]], open = "wt")
sink(log)
sink(log, type = "message")

# Extract arguments
paf.file.name <- snakemake@input[["oriented_ava_paf"]]
out.pdf.name <- snakemake@output[["ava_pdf"]]
seqnames.order <- snakemake@params[["desired_order"]]

# Load the library
library(SVbyEye)

print(seqnames.order)

paf.table <- readPaf(paf.file = paf.file.name, include.paf.tags = TRUE, restrict.paf.tags = "cg")

pdf(out.pdf.name)
plotAVA(
    paf.table = paf.table, color.by = "direction",
    min.deletion.size = 50, min.insertion.size = 50,
    highlight.sv = 'outline', seqnames.order = seqnames.order
)
dev.off()