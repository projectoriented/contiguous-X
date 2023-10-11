#!/usr/bin/env Rscript

# # Load command line arguments
# args <- commandArgs(trailingOnly = TRUE)
#
# # Check that arguments were provided
# if (length(args) == 0) {
#   stop("Error: No arguments provided.")
# }

# Extract arguments
paf.file.name <- snakemake@input[["oriented_ava_paf"]]
out.pdf.name <- snakemake@output[["ava_pdf"]]

# Load the library
library(SVbyEye)

paf.table <- readPaf(paf.file = paf.file.name, include.paf.tags = TRUE, restrict.paf.tags = "cg")

pdf(out.pdf.name)
plotAVA(paf.table = paf.table, color.by = "direction", min.deletion.size = 50, min.insertion.size = 50, highlight.sv = 'outline')
dev.off()