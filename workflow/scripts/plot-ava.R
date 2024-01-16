#!/usr/bin/env Rscript
# Author: Mei Wu, https://github.com/projectoriented

# Logging
log <- file(snakemake@log[[1]], open = "wt")
sink(log)
sink(log, type = "message")

# Extract arguments
paf.file.name <- snakemake@input[["oriented_ava_paf"]]
identity.out.png.name <- snakemake@output[["ava_identity_png"]]
sv.out.png.name <- snakemake@output[["ava_sv_png"]]
identity_only.out.png.name <- snakemake@output[["ava_identity_only_png"]]
seqnames.order <- snakemake@params[["desired_order"]]
annot.bed.path <- snakemake@input[["annotation_bed"]]

# Load the library
library(SVbyEye)
library(ggplot2)

print(seqnames.order)

# Load the files
paf.table <- readPaf(paf.file = paf.file.name, include.paf.tags = TRUE, restrict.paf.tags = "cg")
target.annot.df <- read.table(annot.bed.path, header = FALSE, sep = "\t", stringsAsFactors = FALSE, col.names=c("seqnames", "start", "end", "label"))
target.annot.gr <- GenomicRanges::makeGRangesFromDataFrame(target.annot.df, keep.extra.columns=TRUE)

# Begin all versus all plotting, colored by identity
plt <- plotAVA(
    paf.table = paf.table, color.by = 'direction',
    min.deletion.size = 10000, min.insertion.size = 10000,
    highlight.sv = 'outline', binsize = 100000,
    seqnames.order = seqnames.order,
    color.palette = c("+" = "azure3", "-" = "yellow3"),
    )

# Add Annotation
plt <- addAnnotation(ggplot.obj = plt, annot.gr = target.annot.gr, coordinate.space = 'self', shape = "rectangle", annotation.level = 0, y.label.id='seqnames')

# Add title
plt <- plt + ggtitle('AVA Alignment (100kbp bin identity)')


# Write out the figure
png(filename = identity.out.png.name, width = 20, height = 10, res = 300, units = 'in')
plt
dev.off()


# Begin all versus all plotting, colored by only identity
plt <- plotAVA(
    paf.table = paf.table, color.by = 'direction',
    min.deletion.size = 10000, min.insertion.size = 10000,
    highlight.sv = 'NULL', binsize = 100000,
    seqnames.order = seqnames.order,
    )

# Add Annotation
plt <- addAnnotation(ggplot.obj = plt, annot.gr = target.annot.gr, coordinate.space = 'self', shape = "rectangle", annotation.level = 0, y.label.id='seqnames')

# Add title
plt <- plt + ggtitle('AVA Alignment (100kbp bin identity)')


# Write out the figure
png(filename = identity_only.out.png.name, width = 20, height = 10, res = 300, units = 'in')
plt
dev.off()

# Begin all versus all plotting, emphasize structural variants and not color by identity
plt <- plotAVA(
    paf.table = paf.table, color.by = 'direction',
    min.deletion.size = 10000, min.insertion.size = 10000,
    highlight.sv = 'outline', binsize = 100000,
    seqnames.order = seqnames.order,
    outline.alignments = TRUE
    )

# Add Annotation
plt <- addAnnotation(ggplot.obj = plt, annot.gr = target.annot.gr, coordinate.space = 'self', shape = "rectangle", annotation.level = 0, y.label.id='seqnames')

# Add title
plt <- plt + ggtitle('AVA Alignment')

# Write out the figure
png(filename = sv.out.png.name, width = 20, height = 10, res = 300, units = 'in')
plt
dev.off()