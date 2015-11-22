library(edgeRun)
targets <- readTargets("data/rnaseq/targets.txt")
x<-read.delim("data/rnaseq/rnaseq.raw.tsv", row.names=1, stringsAsFactors=FALSE)
y <- DGEList(counts=x, group=targets$Treatment)
keep <- rowSums(cpm(y)>1) >= 2
y <- y[keep,]
y$samples$lib.size <- colSums(y$counts)
y <- calcNormFactors(y)
y <- estimateCommonDisp(y, verbose=TRUE)
y <- estimateTagwiseDisp(y)
plotBCV(y)
z <- UCexactTest(y,pair=c("Mycelia","Infection"))

#load("rnaseq.RData")

de <- decideTestsDGE(z, adjust.method = "BH", p.value = 0.05)
detags <- rownames(y)[as.logical(de)]
plotSmear(z, de.tags=detags)
tt = topTags(z, n = nrow(y))
write.table(tt$table, file = "data/rnaseq/rnaseq.diff.tsv",quote=F,sep="\t")
expr<-cpm(y)[rownames(tt), ]
write.table(expr, "data/rnaseq/rnaseq.cpm.tsv",quote=F,row.names=F,sep="\t")

# merge diff and cpm to sum file
# DO NOT change sh to other shells
system("sh ./merge_diff_cpm.sh")

write.table(detags, "data/rnaseq/deid.txt", quote=F,col.names = F, row.names=F)
uptags<-rownames(y)[as.logical(de>0)]
write.table(uptags, "data/rnaseq/upid.txt", quote=F,col.names = F, row.names=F)
downtags<-rownames(y)[as.logical(de<0)]
write.table(downtags, "data/rnaseq/dnid.txt", quote=F,col.names = F, row.names=F)
nondetags<-rownames(y)[as.logical(de==0)]
write.table(nondetags, "data/rnaseq/nondeid.txt", quote=F,col.names = F, row.names=F)



