#!/usr/bin/env Rscript
# Author: Mei Wu, https://github.com/projectoriented

# Logging
log <- file(snakemake@log[[1]], open = "wt")
sink(log)
sink(log, type = "message")

# Extract arguments
paf.file.name <- snakemake@input[["oriented_ava_paf"]]
out.png.name <- snakemake@output[["ava_png"]]
seqnames.order <- snakemake@params[["desired_order"]]

# Load the library
library(SVbyEye)
library(ggplot2)

print(seqnames.order)

paf.table <- readPaf(paf.file = paf.file.name, include.paf.tags = TRUE, restrict.paf.tags = "cg")

plt <- plotAVA(
    paf.table = paf.table, color.by = 'direction',
    min.deletion.size = 10000, min.insertion.size = 10000,
    highlight.sv = 'outline', binsize = 100000,
    seqnames.order = seqnames.order,
    color.palette = c("+" = "azure3", "-" = "yellow3"),
    )
plt <- plt + ggtitle('AVA Alignment (100kbp bin identity)')

# Write out the figure
png(filename = out.png.name, width = 20, height = 10, res = 300, units = 'in')
plt
dev.off()